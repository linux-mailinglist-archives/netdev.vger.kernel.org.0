Return-Path: <netdev+bounces-6558-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1522716E97
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 601CE28125B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D69931EFA;
	Tue, 30 May 2023 20:24:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA2A200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:24:14 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC8DFC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685478252; x=1717014252;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BGJfUJmbxS3hLOsLjODdM7ocLhW7a2Gymuk5KeuFzlM=;
  b=nlemhlC3jqprLD4R1tte28S0s5P44oRxiiOiESotR3BPVVfypwiBIats
   JKQCVRjMkO8RahHim0M844CyT5iuQ8hgG/+ca316SD/Z67xfvgzW5wjFY
   BPddhy4d9vAs+AIrcd6v+6z7r5libXnAnDNRAMvQF1U+ri8kyHtWp9drA
   qDwcCMQM3QNFSqjBjmgcGjXCGyrexpWa6ToX1UZS3afGXuEe2zBRQQdJY
   Ho3ai6GoDHwxyj4HuVnvN5XF27KYmlUn8z1Nmk9n1GdEdtYfu42UnIv8G
   fO3Q6J/3bZ+8cX6THrCqAK2iqe1cxhuBIrE4y7384JZ3+W267I36E67YM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="383297711"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="383297711"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 13:24:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="776485003"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="776485003"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2023 13:24:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 13:24:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 13:24:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 13:24:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUkrrK5MNV/XMrUwMxXAFEcO2jdPUETGwEACyEsec9kgiNHgY1naRQDgHshvEAocmhEI7aph/q3aOA0Qnw2sS0lg1kuFGLhLKlGxqFvJAi/7Pj+p/ut0pTQd8IlE2sPajUfXSdiETukhusl+BhBN0gIlHpizPoVc5e0HrKwecs+hH4/5nHzth4t7bnoangwP5M5/90hkjjdi8LAGVGJxEAYPsPdGxQXN4k5/SLsnOX9a7PgGIg2AAgnrg9HK8j4zymCrLOgFdtVHP1Kk+/knpdlwJZfpWcS9t7JeFhb654tNP2OnIX5XJLjI565r1uImwJX3baSCO0rNVNxuU9JvrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PERkSmo8p1WwD+U4efwei6jaOHyfbHwuqbN7xApdGV0=;
 b=VO0GhfzBTVte/C32dUrJ6N1+tJhLN8PicNmoZwavTpOQIYb6skKBM8VfTqPpFNsflGIAybJa/C3RZKrQeyCsxEfdJF7itYAibsOGN/xMnDxldSyWowWeLyDJx6xcwluuNFUQFAaR/GCsD/eLZJ/vp7he7tqjbzBpM8+6zLl3wNUqzwmMv7JVppxaQrPHxAZx39D77vw447jz5KnIc88bsjq5sfl4srNHyghURcBHbAyNwssZrhN1SFtowWgynFSReJAWFu2Mc4CDtTCZ3opZ2IFW2xchPlxnngZPL8vcfifao7viGqYSbYTrQf9aThSmqSiokYRjM5FiPISQ2xvjow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MW4PR11MB8290.namprd11.prod.outlook.com (2603:10b6:303:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 20:24:08 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6433.020; Tue, 30 May 2023
 20:24:08 +0000
Message-ID: <8a60b531-09b2-2df4-a7bb-02e3a98e7591@intel.com>
Date: Tue, 30 May 2023 13:24:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iwl-next] ice: remove null checks before devm_kfree()
 calls
Content-Language: en-US
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	<intel-wired-lan-bounces@osuosl.org>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>, Anirudh Venkataramanan
	<anirudh.venkataramanan@intel.com>, Victor Raj <victor.raj@intel.com>,
	"Michal Swiatkowski" <michal.swiatkowski@linux.intel.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Martyna Szapar-Mudlaw
	<martyna.szapar-mudlaw@linux.intel.com>, Michal Wilczynski
	<michal.wilczynski@intel.com>, <netdev@vger.kernel.org>
References: <20230530112549.20916-1-przemyslaw.kitszel@intel.com>
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230530112549.20916-1-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|MW4PR11MB8290:EE_
X-MS-Office365-Filtering-Correlation-Id: e312299b-1480-4a89-5bb0-08db614bd1e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Skj6XQSCWpFYHqskk6yHZLJTeZaVs2/7bzIzCo5/UpLRDwh/dim80OcZMiA74Zhisb6DDDSBPHJS3d/3U2veQ1noRjOv0c//5rlF7e/Pqj9mMdzsxp7tJBCnXYScn275W4IXhPaCqN1CXEm39Qej/Ce8QaDWZ7uGisI3eOrFhpFPE0o5Zc54HPVX10MTQM4yTPCDY2jayoDVDFWDOZOowjpFXrG+pvJHhX1ICuaKyE1FoM/YCV6A7Qj+h+CnzrhLG4tznFnpreNmJaxhWKzaiU0wBHCaa6pTlBJ6PHDrZolctjm7UmaslhQ+CkW3qsSHB/jLVPcWkwVIIqb19RsXsO9sl8ncF/MZEA/YAJrVaogwFWfPmO3fkRYyinCuzUNrfGAtmkrk7LDym2+V45wq3uZYtXxTpbQ+xuBFqjO3W1Q8abILLW2FTSSSFYGrwscKuvrZaeWtfkLZJyTxFsaT/k+ze//RPAPO/OyVuOsjW0RlgcbcWp50KLb7pBLgmgSRKqktiyORRrEw4Q7MNk722iZVxJANOguJMj2zdRvSEzz07cHpVPrmqAY1sd4R7ph10jMOvKg8ROMWZj6T7BjfuRHrPxTgJ9OtDpOB9hvpA4eH8d4FCz7KJFsJmP/5Gond4DlRFtooxb/mGKjx5YKJPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199021)(31686004)(66946007)(66556008)(66476007)(54906003)(316002)(4326008)(478600001)(86362001)(31696002)(36756003)(26005)(186003)(6506007)(53546011)(6512007)(41300700001)(8676002)(8936002)(4744005)(2906002)(6486002)(6666004)(5660300002)(38100700002)(82960400001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVlKS0xzYmg1VENMT0tlK3dITUd0N0ovVWFhNlV6c1NieW1iNng3bCtTcXUz?=
 =?utf-8?B?eVJTNzR1MCtIL2VWek9JT3dDeTh3K0ZLaXd0MlpEYXVNWmZwcTVSY00vekNW?=
 =?utf-8?B?aFdtU2x3akdOSmpaY2RObjdJZmFKakU2Qk9aQjhDbWhpMHlmejR1aGE1Vy90?=
 =?utf-8?B?YlQwSUJFdTBqVXlJVS9ZN3ZBei9TVnlJQXpDSmhRNWFMYWV0Q2lnTHZyQk9o?=
 =?utf-8?B?N3pKMkRBdkxWT0tIV1piMDIwNjJTaTBWcFQxWjdhTXBvQjVFSjh6cW9aanJZ?=
 =?utf-8?B?VlpLNGpyN3N2SC9oc2JveTd1eVIxNE1GMzF5aXNqdU5pdGVrNzZHWVpJSmpw?=
 =?utf-8?B?VkJoVW5aUzA3a0dCdDl1WDM4MTM3eG56Q2RqeVROU1BGaVNNeVd6RHczb3Z1?=
 =?utf-8?B?dFZVaTdmUEc2R0F6OGorcUdkS21EWXdnN25wamdOU3d1TlRncE5KTU5tREJo?=
 =?utf-8?B?czI4SWhXQ1VOdFI1NU54UkEyczJnUFhSb1dSNlN6d2ROUDhJelBBTmVDdkJF?=
 =?utf-8?B?OWIvQnppbjZWRmlTMTJYTFNaUnhkNzMrVmhCbllSbm1UUDZWRENOK3FVMjBr?=
 =?utf-8?B?YS9FK2kxTDhndGpqbUhFaWxKbVEzUWVneDFQK0JjbkhVRnliQlB2K29SNTI0?=
 =?utf-8?B?M0R0UVB0bFhTcHJLV2tlMldDaFVLVGxib1hyZy8wM1dvV1hNRkVRSkZtSEM0?=
 =?utf-8?B?ZUI4VHUyeGR5U3U1d2lQTWpUZjFXZy8ya0djTjV2Z0RtZ3hLRXpBUjk0MjhB?=
 =?utf-8?B?VEFYSEFlRGlnUDFFenlRNFBKeGJJcnFEVkNjR3hVaXZhdWlTRVRLeS9xd2Rh?=
 =?utf-8?B?SjBCeHhRM2FwU1hyT2loL1JlQzloSG9tMEF5b2xrOFduei83NG9jR3Q2Y3hP?=
 =?utf-8?B?aFJRUjhVUmxraHR4MzBNRFJoek1IYW9mdjZYL1dlM1lCaVZ6V3BXa1dJbUNs?=
 =?utf-8?B?M3FRQ29FME55SFcwKzBzeHhGU3hjZURrbTZlTnJVdzhFR010bTg5dDZYcVVH?=
 =?utf-8?B?d3ZrTnFnQmorNUljeDZCd1Fjc2Nhc1pXbGRFdTMzVTF1WFJTQzBpOVkzdjdE?=
 =?utf-8?B?RENJSjAzOE1VTEpTcytJNlZHck1FWUdpcXJxTVRxN3plcVVsNFYyZ1VEeDdw?=
 =?utf-8?B?ZGxtd0dWUDA1bE9oaFZvcUdoZGQ4U1l3V3VmNXZCM1RtUFE5SkMwSGpwdEhR?=
 =?utf-8?B?RW1OV0pFME44OFpkMHAyS3BrVUJXd1BDQWtMZlhOMmd2NXJCUkZsU1B4aW1u?=
 =?utf-8?B?VnoyOFpJNDdjNENpTWlzeWhiclk4eldvUkZvUHUvTEtSRUFTUnlPM2dKcHhk?=
 =?utf-8?B?WFEwM3VYSzNVdldaZnhuNzVUaXVvRy9wWk1GdGpuVmJpTWk3ZmRLS1hmL0t5?=
 =?utf-8?B?RWhhUTAwc3NUQVFYL1VmWCs5VHZhaVV1aEo3bllkb0RsVzYzdHVydjREOC9D?=
 =?utf-8?B?b1F1RDZiM0JoUVUyTGlNVTlRRzlKckR6V0F3L0wzbkRTVURYZ3BjTEF1WnZl?=
 =?utf-8?B?MEVyVkZyWDBXN25VODdwakJXM0F6bzczOGFxRDUyY0lEblBBU3BISmloNTdT?=
 =?utf-8?B?dGNyUys3a1JSYmRub3RoVzYxSjNxSk43VU1TSkJ5cXVSamIzc0pNWjdDZm41?=
 =?utf-8?B?bjBvU1JIaGlWeG9SM2pHeVJtRTNINUthNU5ubkdqYllJeHl3UWJnUzJCYWFM?=
 =?utf-8?B?RnBiSEowdnlsd2lheERtZ0dBY1JZZEEyTTJndmJYS0FHVExnTGhiOEhjb2V6?=
 =?utf-8?B?WWdySWNnK2tiRUFIUGFGbFovUW9HbzNSWExHZUVMYXRZS1V3MGdqQVUxMmNp?=
 =?utf-8?B?eGlqYmh2S01CcEVJQ2tueTdDem9xK1hDa1Bwb21FRXprZGtZd3FVenNCQlli?=
 =?utf-8?B?STFUbHY4QWZqeDdaV0czTDdCYTQ0emlqR2dGVXJia3BON0JMRmJKdGhodHRv?=
 =?utf-8?B?d2hIa1hiLzdzV29McnFMakNNbDBxQTZyRlQ4U01XUWp4Y3BiRHcrekRGRUhm?=
 =?utf-8?B?MDZiVk9ldnhsOFRyd1lUQlNjUVluTTlTY29VaVhQZlFVRkt1ZlFUc29FV1di?=
 =?utf-8?B?dS9oWTluU3AwTVYvUElDUzQrZmE4Z290WWZRZlhaSmxlOGhHL3VWWFF2OW14?=
 =?utf-8?B?WVR6Y2t2Skg5WXdCd2J5cDlYOUlKSFJXaDFzZHdWQ2ZLQWFsNzhGRHh0ZHpO?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e312299b-1480-4a89-5bb0-08db614bd1e6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 20:24:07.7372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79t6ubHlF07RY1SUNvbg+8pnztgOljZYVmEoN2yBQimLZZau1W407QedisF7hNJJks0Rt0Tu2IJeYzehRF6uzF2cY5q6ZM+9Bb4v8Uzju4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8290
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/2023 4:25 AM, Przemek Kitszel wrote:

This wasn't received by IWL; you shouldn't be send sending to the 
bounces address, please use intel-wired-lan@lists.osuosl.org

Thanks,
Tony

> We all know they are redundant.
> 
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>


