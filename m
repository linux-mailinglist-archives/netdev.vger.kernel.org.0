Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C4F4D3AEF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiCIUUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbiCIUUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:20:08 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D8D12867A;
        Wed,  9 Mar 2022 12:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646857149; x=1678393149;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=HK/thi+judIZ4/mdtbL3lV0j5Dt+HG2tJtDbP8VcN6U=;
  b=KSjsFbhHgPpR2/49JLCeumkzsnIeAI96EVkBuOfppEYijXECfw7o0YWi
   pSLIofWV5Thkdwju2RpPqh4BR24qVNp46x0FVtGjtOQP3xtTg5OTXO60d
   RLPuPotU2pCTYVS5mRK7k1Rqkmngh5bNvALTP/JCuOUKfxr74NtzULQ5U
   25XFOxsgqkFOuUjNuIlWKrpQl00HUUboryBi1+tSx5YSePGJJF/iZ/6gH
   HKv7WuD3s0OiHYTTe7Tvi4SnkEHfmBP79F3pzJbJR1fdPwBdcyrQk9kQH
   eAfRKJRzCGXBDV6BWs5AEJfXsnzX2GSMGGOFRFJpa/PgppSlYYx7GenrI
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="254815723"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="254815723"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 12:19:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="554279567"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 09 Mar 2022 12:19:08 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 12:19:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 9 Mar 2022 12:19:07 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 9 Mar 2022 12:19:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgFUZs6LNn2rmS7bqPqNtLcsvh6RKCQDuCmc4zOlN33ToEL1fmGd7FLRhSwYwQXGWIz4jiLoyDPpFpX58pxLAsh9wJt7ZrdwEIdxgl5MN5wD6KbC57epd/TpAuA0vmBMczrSHBB/0Xl/atFRWp2bx4EQCpxIgwrlpriVvHVEFAG3QbxuLbn8QhHU9NVAXvaP5Knp6hAo0QRAsM5i+qWoABKtf1BYxFVm3zkf8udp38jgBKpBiHtpCcRtjVQbyFCyT9RKPRTrd5Vr4DAHz6eRXRQgi/zrV5Y7MiYhASKWEmBDu+4LesfPpaSKf2POlwjTPHvQDeLvgTcNNX7GwXKDKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBWh3OAG85WU/YSr8VHS+jSylM1OVknHmfFlXATw+Lg=;
 b=bsHZ6rZpSMhS1wtp9Q4qV9MzwiVcHJ8yJy4zR7Vuul2jfQyzk++eG0R6CZvG6zrt+gzpTDWQXKdkROkbDdkV4vBzhzf204GYlgloaA29Zo+ViMqeiYrgBGBlo5vJAARPxNjiOziJR3AL7qOtzdfno+zGVEmhjjD47Kpw/VcknqR76ps+QVo3JGev8e5MjI7nM7cqJkvdEs9mSqeJbr9zFeTTfBw6jVK+VYQFmlPnNKNywfeU7BMTp1Ec9WaLNnYb0pXudai66Q/g0/RmK4B8TSD2xBkSM13o0dt7xLZxEL6X+ok3T5DkJ/k5qv3f36UDbIi5sjuLnrDOdyhxi5udhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.26; Wed, 9 Mar 2022 20:19:06 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d6d:f382:c5a3:282b]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d6d:f382:c5a3:282b%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 20:19:05 +0000
Message-ID: <e68aa1f1-233f-6e5b-21a6-0443d565ca65@intel.com>
Date:   Wed, 9 Mar 2022 12:19:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] ethtool: Fix refcount leak in gfar_get_ts_info
Content-Language: en-US
To:     Miaoqian Lin <linmq006@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Yangbo Lu <yangbo.lu@nxp.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220309091149.775-1-linmq006@gmail.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220309091149.775-1-linmq006@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1401CA0014.namprd14.prod.outlook.com
 (2603:10b6:301:4b::24) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7fb3b8d-f80f-40e0-038d-08da020a0f63
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB33713F358B3A8E05E5FF1AC8970A9@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AGe6fxw60ikQ5wExo9k5P0O6MwuqXAi512EO1qpInHErMMpX6gVJoMfCsp8PG5uuV3JkQxpwQtjw9hKm+hI2hdCVJISIKWvRFvtNbjiXj5POv2kMKB2ItjBb6lsm/2Gfoz7HSiY8c8c+4o/4JFoxj4/jeC9ke/Qs+V/M5yZycGebDvbhrMTaiIP4csfv83c5oxI7vfnGdQJ1Lo0s0HRK4kbaDzuDNAPaaAQ1hqbnChhkAPe2QwX7W6qxl6m7eUOXwQDufVxWUcJhF1cGzqcDMOr4cY2GiR0x67wUiUBPH4KVp5iEXGUrrH6TaZGahF1pNCaI/erZsgktTk/5gTXazF/OxR6UbPzruIXe/i/Jtrm5Ox04fApcVfd3p6W4V/xXE20UezMnIt4LrMV4XxFGM8/0wf8wAZ+VcqskLqcl/BwLqqMqa3rXCcZfGZ+Itc7wBOheB++8gu09mI0rN9qKn3ZqmW7oVA4YFrtTreiQwSmpsmmliR0LHde85Z5hK7ZOi2CixP6TOGGdt+0NIu1xMoknayd2m7JOFPhlK9V9DqnegcllIeHx2y2uuwXAg5WF6KgQqrW0HfT8nz88SQ4wpR6HM44/XYgKLBtz0QDh2EArkJ0LSe4FKqVjJlvcEJr20hulBUxZTNgcvOIMUg7ws2YFWdlp4FYFTfKs/If9Lnc1woCsxQ6AR7hqCDPd5aNVSYokwzsZ8JvlBEWyXovrR3HWE/dSc6NitwWxSQPDU5OuoC4D+adNQS4XwOVde68t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(86362001)(2616005)(66556008)(31696002)(38100700002)(82960400001)(66946007)(8936002)(66476007)(110136005)(5660300002)(316002)(8676002)(44832011)(508600001)(2906002)(53546011)(6506007)(6486002)(31686004)(36756003)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHNlaVN2cXhaWFgrS1VoaTlQVWdqbU5ISmEzRzFVYWlodGZqbmNFNkZsc3Nv?=
 =?utf-8?B?RjJ2cGNTYW5ybnZ2U0xPV25QTUxNeUNHcHkrWG9EbCtTTVdHRHZyU0RWK0pm?=
 =?utf-8?B?SHdBVm95UmNiMHhRSG1IKzFINHlWaTdCbjcvRmxUWStOdjNDL0U4ZmpjVTdp?=
 =?utf-8?B?cFh3QlhHbXR2L3FNdHRHWHhHUWI1RHRBOXFkOFk4RTcwZlU1cE0vUTZBQms0?=
 =?utf-8?B?blBLMVBVQm81YkxieG5WL2hnYUI1SUZISjJMWFNwRzgwTzJ2MkRmWW5sTE11?=
 =?utf-8?B?c1RWOFhXdGlHeFdDczdyUGU4QlM2U1FxbTFGNkdweG5yODAvUC92cjVXRHVo?=
 =?utf-8?B?VEd5b0F2eGM2RWNnRkdVTzZCeTA2Tk14THRabFJPOXZOY1pRUTRUUlJJc0FX?=
 =?utf-8?B?ZlFqSlRtMVQxQlI3K1FiSlBGT1p2TGtLUFQvSXZ0OWppRnptdzYzV0Z3dERX?=
 =?utf-8?B?bmxaRWhtTU1HQmlLNW1BK251aUdKajJURExCVkl2aHFxTTF1a1RKaEhoWEJq?=
 =?utf-8?B?SlNCL1lKYWsvMHhOamxVZ1lucERaUzhoUTM5UTZiTnl5Q1l5aGFESEhiS2ZW?=
 =?utf-8?B?MGZWNlZCaXJZR3JuQ3R1Ykc4eEZ0dVNjK2NLRDdEMndQRFVvZmV2aWkrMWtk?=
 =?utf-8?B?Um9FS0RQbW1CMTlvL1lzTWRoc0dJRWFKY3RlaGRPRTNtY3N6eGhjbVN2SHE3?=
 =?utf-8?B?TnVQQldSbGdTaVR1U25EUzJ3VmNsMUMyb29wQTh4R1B3dE12ajFTZEduQnhq?=
 =?utf-8?B?SlYwMmlBdFZoN3MyQTBobXdnWnJRYWFWWGZ3cEtBUUErNFR2VFZ1RlhNdXFa?=
 =?utf-8?B?VjUybUxpYVg5bVVzVzFCdXRuOEVkdFg3a0dmRGoxZ2owNHgzNWh6bVA2RUZN?=
 =?utf-8?B?NWJmN3ZkUHdoOTJNdnBFQjFxQUozOXdtb1QzeVF1dmsyaUJiMC9SaG9wb3ZX?=
 =?utf-8?B?T3hFdkh6OUVNdVQ4M1dMSTV0Q2kxdWI4V3VGMXh0bmFINUZtV0FINU1hZ3lK?=
 =?utf-8?B?cTRFN3JQajlKNmVncVZuNVBLOHNyMlAvVEhqTGFZK3dveUllU282bngwOFkr?=
 =?utf-8?B?VlZ4MmdCWFk3OUtUWTBmTTlmMHYzWGY0MFZ2WkkreHRYZlorNmhuQ251cGNX?=
 =?utf-8?B?QWxiR1NlZDBvemY3K3VpWnVXMnlnd1o4Y2VUL1pXTzlHVE1YNStpMHRBdFJv?=
 =?utf-8?B?eVU2RFoyYWI1M2pxcjc4bGpqVis2dmZTT2xvNEVDSkRTYjkwN0tVcWpkM0dT?=
 =?utf-8?B?NUwvQ3JRYnZBeDlhdTd5NDNKSkNrNS8wc0lIUmtQcnpIVG1HQklUWWErZllz?=
 =?utf-8?B?SG5CYWM2Ylk5R0NFNk5Xd1hXRitHNWFzb3k3aUVRc1B5UGFTUDI3aUFBV1B4?=
 =?utf-8?B?d2VRWTBDeXdYcjZFVVIxbmpyWDU3Qm05WHdjcVQrVjQ4QjVxVm5DbFExWE5h?=
 =?utf-8?B?TFg4TDc1YkpNVjF2SERFWnFPOEsrREh2elFYMmNCdk9RK2FTSVFNQi9GU3V5?=
 =?utf-8?B?OW5iVzMxakR1aGoxREZrcFBQZ015TGtRYmxMTktmZ3BiNnNvdnVVUzcwK2Q5?=
 =?utf-8?B?cUVTRnB5U0hTR0pIakNJeExYYkVTdndoV0w4b29lYkRpZDBsWWJUaHF4NUEw?=
 =?utf-8?B?cnZLTFc2SFg4aEMzaDhHcXhvbnlmcUY3Vm1ZSmxIYVVTLy9xU0dHalRmbWRz?=
 =?utf-8?B?Nm9yRUV5WlhxUWlVODhYZ3RKcG9UcWVrSXZMMi9ON1V1MVE0bFRoT1NnUzBm?=
 =?utf-8?B?NXpscDllblBUb2NTV1pVcXI4VGdDYlNKRjh3T0lHVVlmQ3Y3VkZYcWVSZGV2?=
 =?utf-8?B?N1BqWjg0SUJaK1FhUWdGRFpZOHFUOXkvdFNlZ2pRVHk0WHZzWVJpNC9SeURr?=
 =?utf-8?B?T2R5aDBIaUZTeHBPak1rSnlIbG5jNDhGRTZ3MXE4Uzh3UWpTbHJBYlpqUHRU?=
 =?utf-8?B?THRBZWtwQTZpejFGZm9OUUZBSE5IMlNnSjFEY1c5S09GVHJZMkpicTRoL0N2?=
 =?utf-8?B?UUxvaFJDYm8yQUVzQUxhVTlWTkF4azRFTVU5bVJzbEYwSzdDR0NUMEhzWlF6?=
 =?utf-8?B?bWJHQmFhRjBGbU5MeERSTFFqclg5NEVBRFREbmhsT1FrbUtnY3NkLzVsZ0p2?=
 =?utf-8?B?MFByQUZLbnJqb081SGZxc0xFQjFsWWNmOUR2Y3FaZTNFSmtXdnFIZ0UxVitP?=
 =?utf-8?B?STlCY2NjZVEwT2NienJTeHkxdXcxcjJsckFoNHdEQzU4YlpqUi91WDJzbTJ1?=
 =?utf-8?Q?pDkpJrdaGd4gjCLmX8JGdIglxgrDV2AFL4F9YHxnQk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7fb3b8d-f80f-40e0-038d-08da020a0f63
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 20:19:05.8817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8rRdWUBmIaxbVk2KOhpyTdw958Ar/exa//NY6LWlcHQOtJFa+eN5gw2ZHaCIsyOYYcJQ025uB096agqJePQPfjriX6+JlJjXzVHGqw0I/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > Subject: [PATCH] ethtool: Fix refcount leak in gfar_get_ts_info

should be:
[PATCH net v2] gianfar: ethtool: Fix refcount leak in gfar_get_ts_info

On 3/9/2022 1:11 AM, Miaoqian Lin wrote:
> The of_find_compatible_node() function returns a node pointer with
> refcount incremented, We should use of_node_put() on it when done
> Add the missing of_node_put() to release the refcount.
> 
> Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>   drivers/net/ethernet/freescale/gianfar_ethtool.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> index ff756265d58f..9a2c16d69e2c 100644
> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> @@ -1464,6 +1464,7 @@ static int gfar_get_ts_info(struct net_device *dev,
>   	ptp_node = of_find_compatible_node(NULL, NULL, "fsl,etsec-ptp");
>   	if (ptp_node) {
>   		ptp_dev = of_find_device_by_node(ptp_node);
> +		of_node_put(ptp_node);
>   		if (ptp_dev)
>   			ptp = platform_get_drvdata(ptp_dev);
>   	}

If you fix the subject and resend a v2, you can add
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
