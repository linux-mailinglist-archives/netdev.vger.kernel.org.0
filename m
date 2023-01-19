Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96F7674AE6
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjATEkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjATEkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:40:20 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606FFC4EB5;
        Thu, 19 Jan 2023 20:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189379; x=1705725379;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pyv1mhBfo/9stBOofKeGIBX79/qTMrLW1T5Iir2zcYQ=;
  b=XZm0rWvaaTmuxPCf5VnBBdfTPuML7B/Uh8HJXR8ohlLG5SHtipJWMnwb
   ZQ1kfKY9MLddSBEh+/hM6JoiD4lHO3VS8iaiC5IwMrI86rFSmUGrKMSIN
   XdEZBzMaLpl5sKycODDX/Qh41WwWtn43xX6C7X9MBs3Msd20VZQr5z001
   KFs7PtK+y9NK0+oO7kgBYu2zcrq6VoMWhwDxdDfyv7bCKHxOD8I2v7qk2
   XH5PcqTphpP++qt5Rm3PQ5r9K6vdjVqFr5Z6mmlGmY526/XSnd/cRFgMR
   vfJv1vCIje/Sok6mA7CdDoIE+E/T4Ptgr5/OSEdI4ovw9CN6TaXVFseGv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="411667187"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="411667187"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:39:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="723680670"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="723680670"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jan 2023 13:39:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 13:39:33 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 13:39:33 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 13:39:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7mo2teT1FVlnhLXiqpkRlmcBkCA/UpKKh2ziYLDdu8M9UzXc4Tdj6RudQZcib+KcUHH0pbX//TqX9uVya0wH1gxoQ5JyUwcyYtfH44YSeZzkGIqBDe3Pors7RfYZmZvZXthQdgTQKpRniKeRS4S+wYtNegjlK6ALOg5rS47LSFpU4sGyl7TuyhGPAHoRpsLKN6iOqEJorMI2EbsuVtbzJPgPnav/1KH1lPCjZmKEc5rFQuYZmqZ/H3bQ3tUx2GPtiD0Oy6pX1Z1ilZAn23bQmcGUom9s96tJ3qJ0744MGn4t14bMSQsR55LYQ9bJrVad3abl55+sn/nznFnRn6hnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JFu8RYLbTgyuBiWrIYw8TmdCXmcUIelo244u11aRfY=;
 b=XKtpt60m/cQq6IiSUCYrfqJ+anCQcjugM9jIolv1o7BJWcCnC0pWFQmPXmX6o3z+YTjEHxcq8djPV1bpWKLOKp9R9m9t/I0OUa1C7BFl7jWgqr2bXvsJmk9FKRQwdG2dhOIjHYc2wdVq7ZbagizUD7Nhk6rmh8/MOBgF/wpcQXkCAnmXBKPSY2yNH2338mhgIkue1B2ejRrEqIT/QdAwQYOPMmuEzToSDFnhw3Y2OqlhJNQY2ypV+UT65YmeSqP4ZU9xrcmrZNBGQquRstsrSYsXJ3mEQ5hUK81dJSnd1QV+XlIctZLVTfKG6ScMK2laB/FzPU0ccX+YYPdjMPvi6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH0PR11MB5208.namprd11.prod.outlook.com (2603:10b6:510:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 21:39:30 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 21:39:30 +0000
Message-ID: <9d672c05-d4e1-0adb-4425-bba2f8610b91@intel.com>
Date:   Thu, 19 Jan 2023 13:39:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 0/2] net: ravb: Fix potential issues
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <s.shtylyov@omp.ru>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <20230119043920.875280-1-yoshihiro.shimoda.uh@renesas.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230119043920.875280-1-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::26) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH0PR11MB5208:EE_
X-MS-Office365-Filtering-Correlation-Id: 918a2ebe-9b7c-4b9f-e9de-08dafa65a54f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pjJgLN1KeuiJGA5669fH/tICDE2zOp+Ryca3GEPRZ2s13wxQlcMoBVlCk7Ncj155cX/vUugTmegW/nTz7M22FABCbDOI95mbShGXPo0n71bAuVl1OKVhrCPz2j701ByCqsqas1gpmjDTL5hQUeENzlo4lcL2mAXbGyAqPLDDpmh77tnfWj/Hyfox5O2HSasCpST6DsQB6cE4gD9/PtCNof0DN5Msrs9TA1pr+nCfKxs1iwkrYhw3GGdiar39Hvk4uuwfMTurW/3OC9DbvmtecnVnrRSE7kb5dukOqf/9CP7oR/xI215Qdxe4BpgkTWG0ttF316RFeO4QBp1uswHHTP13N8x1ZNTEA8q1dKr2t34Z7FpGZup7Qu1tXSKnf03Mhwf+VptM5Lmrh/mS/okrQXwpETb/X0s7t9XIFZWS1nTSU0hK8kUbWSr+nX6JE1AiI/2QpiTLnextqBIf2GcLnoL7YolXV18shHIzm8eEqYidREiVShT16qly/ml41z/oIC5svqumQsOofKRT5u1ZTk+0Ch6agFiAVsSC9DDsLVfWA24sr3Pu/OGyWe2DCL911BC8BLqmLmb/uSjBGvRJhzGz6B7Nh0eW24gWjDSYKF/zdb/xg4yK/RkQ2ViqE82dw6uTXQRkUMX8/KjEGQ1Ija5VvwwRqKizvotENEFm2xYGbV9+cWzj35FsOBo1+vAexn+DtDkpmjkwgnwlwkvfI/k6jSnCscHmr7iCQ6tBYC0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199015)(31686004)(8936002)(5660300002)(316002)(86362001)(6486002)(478600001)(36756003)(6666004)(31696002)(53546011)(6506007)(83380400001)(2906002)(2616005)(66556008)(66476007)(4326008)(8676002)(38100700002)(82960400001)(4744005)(66946007)(6512007)(186003)(41300700001)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2VPc1B5eE5HSGhBUkpCM3F4T1ZNWUpXRkFkeWh1Z0Vob0k4WUQyZWY2Vm1t?=
 =?utf-8?B?Qk5UZVhMRWNXK0E3RTQxWHVkeXVkVnlMUjM2RVcxNEU3akYrSXV2WGQ5TFJz?=
 =?utf-8?B?b1Bsdnd1MFJzVkU2ZzJBWk94RWZYZkRmWDFJODB3M1NFUnM2ajBJaHFKOVAv?=
 =?utf-8?B?cldBeHVCbTh5UUhwdkpUNGthTzJ5MjdFUGU0UFQ2VktoS1BuTE9FalovQnpx?=
 =?utf-8?B?cE9JWTJyMjh3N2IvWnlWcXZhSmlwWlJBK1hsbytudnMzc3dWNnNjdXJBVjB3?=
 =?utf-8?B?VHFiaFE3bk01dmpwVFFoQXBSWnd4eWVwREM5eWtaM1BzaGcxK0RuUHFPNVNT?=
 =?utf-8?B?bmlxQXo5WjRwaURaUHlFTURYTG45OGNNZTB6eHhZVGVZRnA3WG9HWEdkSmw1?=
 =?utf-8?B?YWdDalhoNVN0YndDZER6QXFkU0oxaVl4ZlkzS0RXNHhaMCtoMnpnc2h0SmFD?=
 =?utf-8?B?U2l2elEyeFcrcmdkc0czcmR6NXh2S2hoa29MRERURCt0MWNvK2JJUWJ2ZkVv?=
 =?utf-8?B?bW0rdHJkMENOejZpVVRMV08xaUcwcXEyMWJTZ3FEbVo2amlBT1hDTnhtZmNK?=
 =?utf-8?B?R1M3STdwRWMzbWhOSWtqQWxsWFFLZ2FGMWRwU2djTkdtRFdIQjJEQnpZbEox?=
 =?utf-8?B?RGFVa1V0ek1waWl2QmlZN21yRDFCVng4UVlrNDV3WFRCOUJmV3Q5Sk1OditJ?=
 =?utf-8?B?Rzl1T2VkZnhaa3ErQmpWdVkwYzltVjFzQmRxY0UzM1VPV2FqbVJqdTlZS3E1?=
 =?utf-8?B?UjQrZGI4THZUalJZK2h4cjl6c3l6bnhZeUZtdTZBYnRTdWtya0Z4Y1B6bkRF?=
 =?utf-8?B?b0Z0elZ1b2Q3b1FDK2U0c1FYV2Z3S0NGemtpVC9IQ0d6Q3VXMy90UkYyVFJH?=
 =?utf-8?B?Rzl1dkdndXlVV291TE11QWR3RjBKY2I0bDJjaFR5bHJMYVpwdjVBY2Q0OEVo?=
 =?utf-8?B?dWswZ3ErY2E3dThqbzByY1F3NXdkZ09HVkJjSUg1TkZYaFM4a2JaazdTWTE2?=
 =?utf-8?B?MWNxM0R3UlNCNVgxN24wWi94bTJQVkJyazZwc2JUQTlTWnZwdW1ja3dyMXNW?=
 =?utf-8?B?Y095bU5abnpXcUVVMGxQU0ZsWktMWmZYcXd0RVdmYjhpbEhMcjAxTVk1SXgw?=
 =?utf-8?B?WEhDVXY0R2F2NWRXeWZHenlnamtzanQ0VnEvWmRaM2llQVZYNXgwQ2hzL0pF?=
 =?utf-8?B?TGtiTFBjQ2M5TzVVdUJwc0hOVFpuS1h6dVM4TzBCYUVqMHhzT0ptck9nb1NC?=
 =?utf-8?B?VGpwbFFXNmx3ellGMXN6eWxza1dQZlNJV2liVEJpalM2OFdLdHlDSU9HSXUx?=
 =?utf-8?B?RENwQmYzSEtPY3RCQUhWSmpwalJ5Sko0YS9lQnpmeEwyWjJtQjZvVGJCMkJP?=
 =?utf-8?B?K2h6L3NkNTcxZ3VHMFo2MkRXZUp1NGt3NlVxSkxUS29zd0tZNGQrT293NmFq?=
 =?utf-8?B?R2Z6anc4VEZ6YmJXYWxwMVJaVkt5UW9ValZUV3VxWTkzby90ZkhkSUFGcXli?=
 =?utf-8?B?TWd6RVUvY0FUWGxpWlA2UDFUVmM0MFZ3TTJaK2V0dDNad3JCS011d293Nkk3?=
 =?utf-8?B?dkFiOWRhRHgzU0I1YXNIYXduUjJmYWNwQzIyVGdTYjA2OFI5R3NEVWEwTjlD?=
 =?utf-8?B?NUNNOWNyc1dMQm5wM2cvbTFRcjliY21aMUF2WWtiOC9YS0xqNlRwdy9kcHVh?=
 =?utf-8?B?VW43SXVqdHVPdzkrRm8zQWplYjgybUx2RUR1VFQ1V3ZyckdiY0RtRjUzYXF4?=
 =?utf-8?B?bmxYb1JUME9nZW5YbFFvc3RwYUYxSUNUNUxsS2UwUWtvakorSmpWUFk0a2x3?=
 =?utf-8?B?ZkVRSStZSGkwNFZaeVQ3Q1N2b040Um4xSmNwNU9HNDZwSzdkeG4zRG53T2Zt?=
 =?utf-8?B?UW1rdW13NytITy92N2wzKzJWK0J3K1hjMUprVGNrRTk5cUplNlZScWJya3Ni?=
 =?utf-8?B?bFdRRkd0UzIvaW1acTJlNkF1SmRnbFI1SXcxcFd3N0t4K3dBT3NZWG9JNW51?=
 =?utf-8?B?TzdadjVQSE1oL0ZIWVY5RFZGWGlId0ZQb3k3Um1wQXdyMEdpZ3hFQmIvZEtU?=
 =?utf-8?B?cTlzeTRxT09pWmd4R1FsQmprQVBGdEZpL3pTVE5Fc3FwVllrcHJjSEZuZUEy?=
 =?utf-8?B?MlIxbnc2WWhvQTBTeUk3Z3lCVDhnZVJCSDVHR2E2amNyb05RSVBwRy9LNTNF?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 918a2ebe-9b7c-4b9f-e9de-08dafa65a54f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 21:39:30.0965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34CrGS8XHykN94p6DNcr4DAD0gcyVNC1//ghmPQIWw/zueqg+rPYOmyXxvmjVUQ4jsE5ohsma19l7TRcu/hA37O6eIYLSdG1nD2IuVldYrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5208
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/2023 8:39 PM, Yoshihiro Shimoda wrote:
> Fix potentiall issues on the ravb driver.

Typo here, but probably not worth a fixup unless you need a v2.

> Yoshihiro Shimoda (2):
>    net: ravb: Fix lack of register setting after system resumed for Gen3
>    net: ravb: Fix possible hang if RIS2_QFF1 happen
> 
>   drivers/net/ethernet/renesas/ravb_main.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)

Looks ok to me.

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
