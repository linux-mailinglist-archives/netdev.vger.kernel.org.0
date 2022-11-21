Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18E2632C2B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiKUSfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKUSfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:35:53 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3BBD0DE2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669055751; x=1700591751;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bXoxoQuJMQnh6+FEe2no+ld+jIheN37F0Y9X7fi3L0s=;
  b=cym4pCV+rOD3N40+auO95/XgBNhkGiv6QTZ42WAbQhQTxcneaqPGR+D2
   ukGiIFzEEY1Li3waBaRn/n6Q1K9heob8qxVORf1kDKE2fuff2a11u0uV1
   i0NH1ziaJkA65G+t3YCx/KA5O/S/3GejblaPl4Uho/sLpDxsJis6SS+ak
   qbUkbL3vaJ0g9PJamvqMyVS79sQp8SF7kqKtLcCsNA4wBiDTXoK77BfGR
   bunX/xIKFWFveu2Uh8EN/C0pWtFpRR5Fnm7A7TCgqsOkOrrIvZ44s5plr
   wlZpqEF7lwpMsmWVqMxeiVkZphjeUjI2XIc+FqrZVwUv7uRuseP1ZwKtI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="314782317"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="314782317"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 10:35:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="970172995"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="970172995"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 21 Nov 2022 10:35:38 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 10:35:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 10:35:37 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 10:35:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGDdwrpXoAg2I23Syp/g5lmjdRj+ZksW5GDFz/wQHiVAdcjioKXAYbfHQjVof7vSwqNI/QyykBuukTOmK5LXZcDrVjxsESLRPvFU8Iz69gFzgMp6hTRY17PeTMzb2VGpc7dQ7xTByMHsLy18fszgvQEsBVR7A0JvtDB8Yu4xQKviVU00lfi/3DsYX9phDcrIoSTSzUISgvJ8bBAmrfxQ+F4D4Bi4lETAlvnZeiYUf9+fuh/hcReVSr7AXuYX67OlaBPHRcIwdn25VLapsnmBaIbjPtWhgQ7DTBQU2S9BF/q24Ou3lAG5sI6MR4ssbEnbhPYQ9Eskhl5iFlri48GelA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHg745H9OXilliIr/BMHhL7+hOjp+bSFM4z1jQZ6nx0=;
 b=K+T7MXAclKHYXHPg5kh9M9CTRnSy+yY6iHd7WhWmtYTEKuQsvcB93Ln2hFkIqE2bqVAIJM4VvfS6dSNLUITpOHvqYrrfCqVdirLeJbARZGdaf+xL4TWbTjq2YGtG4BQaO3rwhmihcjtMIz2plbG8OBWXppoj/66xYlt/EcWoUbrDcv2w+uc5nh4FUZky5BTMGgeKaef6TBVSp/amMKOOpxYpz+iTaHGjxFKbr2SaB+2LWkxcBKhd10l650JXnHth0G5bSryWCZF70ll9i+NN5hsPWX/gljRQfMwfVHyCmXlE1MbGxAeptSpiu8moOfRMpOUbI52l2qO/QzGgFKdvPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB7268.namprd11.prod.outlook.com (2603:10b6:930:9b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 18:35:36 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 18:35:35 +0000
Message-ID: <8b8d2f27-7295-4740-3264-9b4883153dd5@intel.com>
Date:   Mon, 21 Nov 2022 10:35:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 2/8] devlink: use min_t to calculate data_size
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
 <20221117220803.2773887-3-jacob.e.keller@intel.com>
 <20221118173628.2a9d6e7b@kernel.org>
 <753941bf-a1da-f658-f49b-7ae36f9406f8@intel.com>
In-Reply-To: <753941bf-a1da-f658-f49b-7ae36f9406f8@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0093.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::34) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY8PR11MB7268:EE_
X-MS-Office365-Filtering-Correlation-Id: 45534a50-4191-44cb-1e36-08dacbef2e1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1uTGTpymAlFXdP6xHYyM1dK2koJ+26Lw7f4FcCrMk0ntrMypJzB6jKfC6b1Bu3zVPTkimK9NVJEcustlRXLA+WOOn3ap2VaO3sV6MRkImrZFz1gBwEM6FZ0Yjt0Cg35b9P2RyP8maxJYxgH+dJRtbxBKqfHlypacthQZqFr4B3LHD934KlH1iqWKqsNtjStvUQ3sBbsJdxVqS5xO2c4gJaesHSb3TEBZ9TonE8hia7nn2keFBsw9IvLgRexyiOPf9NLAH3MSJbAPiMVKHBbZLrHyCryQ5tk6InjB/3oDtgWTH8E3ndQkOiKjV4t5ZE9yIkqspjHFygah34KUueHyw6kH8wAeGo3O/92TR/JM7RnVO2H/u5USlhQ0p1lgqzpldPQDA8s5kaq4Yt4znySXb2wo57m57CYGncJ9jJboTZhWVr+XI2Dv6urM+WHErydtF9J9kYm7tnFACLtxYCf8ZfBrpLo9oI+elW9EwJlWpbvRfClb/aESTSi9wjYL+VxT2iyDaZjIWa688/7KqmxTpLbLpYTrpv9rR1yoxcPvfAxB3IP2OJ8mQCVtkpgD+qC1R27kTDiejWP18KHJqK6g1dfc8LKtP3tJY4nCMzMmiHlY2rZybb64zeKv7ZN1JalmL0HIxvO0mvh0YUaEudDh0Ah+TtFQizGGvlvcL183Y/E9fGD/34oMkXUwgqWMuMGQVBeewv4ffwk0aRlqLwTm5xp/Tb4CXStHg312pQhLpdQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199015)(38100700002)(83380400001)(86362001)(8676002)(31696002)(4744005)(8936002)(82960400001)(4326008)(2906002)(41300700001)(66476007)(66556008)(5660300002)(53546011)(26005)(6512007)(6506007)(2616005)(6916009)(316002)(186003)(478600001)(66946007)(6486002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cktyR1puNGtRUkFTZGpxYmFsTmIrVFdCdkp1Y080ZHRoYlFXNFh1REtQQUJ0?=
 =?utf-8?B?U1lId0NOQkdVUVNZWjF1TWRKMHdZck9LN0tTaytMNUp5akdiMzlQa1hTUlBt?=
 =?utf-8?B?SzJjOUpwK2ZPNCtKMmVUbkkvUVNGUGpQZWI3N1VjeGRsUSt6NEdSdnl2dUxp?=
 =?utf-8?B?bUFjUkYzeDBMdS82c05lQTlqR2JTZVRKMGtyKzlUc3U5WEljdVNGN090L2p3?=
 =?utf-8?B?S3hUa2RyUEp0VCthQndhZXlzWVhkWlhRM2hOZTdaOVdLWTVBN3d0SWZkNjly?=
 =?utf-8?B?M2tsSkV0Ym8yTmFnZDYwaGFTenpRNkhBdTFRNVV4M2ZNTDc3VWZSblVLZDJC?=
 =?utf-8?B?WktyaGtMeXJyTU1qMTBCcmI4Uy9tVk1qL3NxTzExbmY3VjhmOWI0Tm14dDJQ?=
 =?utf-8?B?MjVJWmpOMTluL1NxaE8zcUJUR1ZuUHdIRnhKNEVyTWtrVi81VlcvK3prUGdB?=
 =?utf-8?B?VFcyWno5SUJ3N1BxVlZ1ZmZFQ2pFVVpyVk93NHoveGhHeDdMUDY1SGIwSmk2?=
 =?utf-8?B?eHFGOE1XUW9xQ01PSWtpbU9XRm9ybVlmYXhVMHM2RFo0Q2xYM09zbVFwbUlQ?=
 =?utf-8?B?TUN1V0RJMm0rMnU0clBZNW5ibWtzUjVLVTFkNVJVb1dqNEdpOHdMMjBTM2o2?=
 =?utf-8?B?T2oydkxCTHRjSU9nUDRMZzZFWGdWempMMEZDWG1pZEVBMStuOTJzZ2xSWmVP?=
 =?utf-8?B?SVpZZFp2UkJUL2JpeXFoKzNIRUNYNXZmMGhOUmJKWWpVL0N4M1I4Y1VSSjR6?=
 =?utf-8?B?RUl2dkVjNVFiRlZYRW9XVWd4WXkvUS9aOFhvcWJ2WUxFdWRFcHR4TndMWTcw?=
 =?utf-8?B?Q1dvUHVsSHc5YlZ2RWdPL2RyWHBMVkl6MWV4dEx2ZldLdmNieDNEZGpxc3dN?=
 =?utf-8?B?L0FzcUQwUTg4MEFXa3RpTWh0RGppTktoVG80ZnczQlJ4NEV3WGZVanZWMEFy?=
 =?utf-8?B?aUNBUDVtZUFybTltY244bnZuUCtsalZONnZyVmZEZ0YzcWpXQ2pPSHR3NG84?=
 =?utf-8?B?bUsxREo4dVZzNk5ZR1hraFFGZURVK2hLVWFOZGxhSXVHUnkxKzRMb3BNcEYy?=
 =?utf-8?B?cktsdit1Z1hUY1dVMUhWTUpnNWNXNzl4K092bVpWVUpTMXpiM0VWS3pBVU9M?=
 =?utf-8?B?Wk0xUEEzTkRWSG1VU3I2Q1NrN25vcVpLUHBqNGlSZ1lVQmNaM2FNKy9kNHl2?=
 =?utf-8?B?ZTFWUEEwd3lIZGVuTklxcXBNZDhDalN3OFhxb2FiUlg1TTZ0UE1zQVVOQnhx?=
 =?utf-8?B?OEVUeVNYSGpLOTFRTTdENTlndUVMTVBodktnb3lnUnF4L3V6M3JQbzVDSjgy?=
 =?utf-8?B?SVhrUVNadWFkQ1dxY2V0RG9td1B3b3RsTWxoYkZRSEM1dEZDM2tZUXNCRDNy?=
 =?utf-8?B?UXcyUXdRelVpRWVxMnNrZmVjc1JJVzkyK1VWdVFwWmR5cHQ1bE0rVWZtTXJE?=
 =?utf-8?B?YXNnNkdWZkZ1Sk1XcmI0ZkRRQ3pmeVh1UklOSkV4K29OMVRQZ3dTemoydDNN?=
 =?utf-8?B?SzVvNG1TWkx1YVNaaHhXeEN0dG5XODNUNFF0M2d3aDZrald6MjMxdzZ0MHE1?=
 =?utf-8?B?UHVvblltKzRmU1lqNGFxb2pRUlhvdm4xMm4xNmRGYmZUcWgrOEp5L0VuVFhN?=
 =?utf-8?B?K0gwcVVMWlFMb0dLdTk0N1pTcS9ZbjRKMmlXRGZkRXg3d2VzTk16ZWRWMG9J?=
 =?utf-8?B?OEw0UFJZb21JN0YrcnhwMGZQZFl1SEk2WEovOGwrZlNnckVoMDdTTlBWOHU1?=
 =?utf-8?B?U0VLVWsvanBFVnhWOUN1MnpBWnl6RG1LclZ5UHBZNmhlUjM1Z2RWakppekJT?=
 =?utf-8?B?NDJ3SisrL1hiWGFHak1yU2ZCaFphRzFpNTlsVHBEbHBWbVJGTVN4U1V5OXlS?=
 =?utf-8?B?VzAyemdlK3NDUmJDSURvUmUrZk0rd0I4NkFKZC9VdWRlMHhpWGVzRWNjdzFB?=
 =?utf-8?B?aVJSVUV4cy9qZjZTbWlYS2VCbkV6MlN0Z3Zab0pURTY0SXJwL01qeTIySWp1?=
 =?utf-8?B?R2g4aFM3Y2J5Y3pSMStPSmFNUzBRZk1CejlDdGJBcTRPQWxBbXVxQUJwNEV6?=
 =?utf-8?B?Y0M4dWhkZXRoUlN3Q0tabm1mRnIrT3FmbU1UVUhyOFN0YmNQS0s5WHdzbmVZ?=
 =?utf-8?B?RTFjbDViZkZ4WTZjZ3h3QytQb3Y2SXJDNWpHbStNQVprTy9QNlc4ZHdJRCtx?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45534a50-4191-44cb-1e36-08dacbef2e1d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 18:35:35.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUFZDStAnMHA4J4WPUNe+XmF/OJQUw6HzGOJPpq/QipvvhBy6AJ8l+qAnObbsNWIM6MO/skatIDaeW+Ar7LtSMYwTx+4YeYPMMl+LCkvfDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7268
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/2022 9:51 AM, Jacob Keller wrote:
> On 11/18/2022 5:36 PM, Jakub Kicinski wrote:
>>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>>> index 96afc7013959..932476956d7e 100644
>>> --- a/net/core/devlink.c
>>> +++ b/net/core/devlink.c
>>> @@ -6410,14 +6410,10 @@ static int 
>>> devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
>>>       *new_offset = start_offset;
>>>       while (curr_offset < end_offset) {
>>> -        u32 data_size;
>>> +        u32 data_size = min_t(u32, end_offset - curr_offset,
>>> +                      DEVLINK_REGION_READ_CHUNK_SIZE);
>>
>> nit: don't put multi-line statements on the declaration line if it's
>> not the only variable.
>>
> 
> Sure, that makes sense.
> 

This becomes the only variable in patch 5 of 8. It ends up making the 
diff look more complicated if I change it back to a combined 
declare+assign in that patch.
