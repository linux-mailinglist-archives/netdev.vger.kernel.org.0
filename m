Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3276747F6
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 01:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjATAXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 19:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjATAX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 19:23:27 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49175E3B7;
        Thu, 19 Jan 2023 16:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674174192; x=1705710192;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BOn8MmPvb9SZYT+wU3Yr7FR9vshpXWz74AUOy6p99qs=;
  b=BfM6uLhcFgA1DA18u6aI7PIqojo8Vzc5608kt0mKU75qpHlFNlcF8YTS
   RDwdUUjXwYQqJl0Iol9tRqq9ydQPonn7PXzfZbgNVAJzdPm/ze0rKd0A7
   v4ARlknxD/vgcGHIZ89SKkUG4qefLtgl5KaY+BJZkefwOdv9/MXzF02s2
   TtPWinspO5o3zQJXMoQMzdX8w1vEByqi062oseATrLqv/BrC2UoF0uvmR
   joitrWsKLiNmRfz7hiUaDJmMMHKmB49EBNckz0ibaJ9tG/rAjAiL+Bsw9
   9xdUmQKqY4OhpAHuQsZ6MQVM8ybecQFntCmWnb/fCXPymIt8TluWMSm24
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305145522"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="305145522"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 16:23:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="660410603"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="660410603"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 19 Jan 2023 16:23:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 16:23:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 16:23:08 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 16:23:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHRAn9PJtx1Sh0wFGTbTyDS4BPQ7mVmez1QyZ1yh4tw3oSAhHtKj7me707fR0RtG1fISj4UESJlmCTT1CPz4M3T7vZrUgtBrpoe4JR9delT7Ac21YjqCF544zgERQ3iCmjuyYFMfJmoIVrTYEF6ETLoziRsmDHc3hr5ciQvEFTPZbqmu+u2TsRh+ZeQTgi0PY5VY9j4gModT/oeAbkYN0vyeevtBsosVwPnCh4SNgiXuU6d/FAYw5m0Nm59EbJ7udxHyGynroibZ1YCb7RUpJ6HkElqIv0vdzmGWRt6HpF+MosmvoLdVKwPj1Paq3zUWcEhsG32U4n50Kv0xIfgTJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmhVZLY9sNkQIQEGndFp3qCgH1fP76hLFEuYjPhOy6A=;
 b=iwUWJRkP2/IPE+KhJqcE7/MsqYZ/ce2LBi+GD+w6t7QJ+NOm1Un1SqTNJM7Uc+KW3ZkLKo6ytOVDy5U7ttGY/zfooq3JbK9SljfXkFbakT/pL1/awrtLr8212MSUvNpQv6+HCsKk5P53H5iNsDIlSmpbDuiIVIj9CXzwsXx4q0wRwS19UYlJxuC6z57Izub70LNSEfZUn7EH523B47F7goq2VNeJ8FHfxMjWx+N56FroEr44CqBv49Py0FGr2yG6oywN07HLdfaKOvSsI5CnjXQ0IF7nVl+pEJISniGiVdD9XIFlu7cPXuRF42LuHwBg8FXYuN6QfYYiIkxF13YB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB7854.namprd11.prod.outlook.com (2603:10b6:208:3f6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 00:23:05 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 00:23:05 +0000
Message-ID: <5dd6c9bf-192d-44ab-7d93-22c01cb8d64b@intel.com>
Date:   Thu, 19 Jan 2023 16:23:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec
 docs)
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <robh@kernel.org>,
        <stephen@networkplumber.org>, <ecree.xilinx@gmail.com>,
        <sdf@google.com>, <f.fainelli@gmail.com>, <fw@strlen.de>,
        <linux-doc@vger.kernel.org>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, Bagas Sanjaya <bagasdotme@gmail.com>
References: <20230119003613.111778-1-kuba@kernel.org>
 <20230119003613.111778-2-kuba@kernel.org>
 <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0192.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::17) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB7854:EE_
X-MS-Office365-Filtering-Correlation-Id: 39ce6758-faef-4e29-8f37-08dafa7c7fe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ijrtjw5pV+mIWcFzK8gG8GrNEL32ucu7Xdbk6toCmC8hBiAwZPBoOwiWkV+wxKnmAf4l52OC2GyvDRjxsHDE+zkfuHQEWhloauok/DEgYqFeFti+nSJ7dp919Ov+kmjXAFbxVL5PiGwUTFr/i5wCpjvXNhSDk7NRKZ79Nm72MPaYuTR2Iz+GWxHviuZk9fA4EvUym6/rOLPTumjNrW+C+uPHB56fqUwYHMNXLZ9n6aqBF7vWNu7fARyHwSzCRzTML77Q8Q7eN6Ud/q7UNin3NzrkV7NN0iscdi1CN1WnZJd5zxoAw0CxBTuYnHtxb3P2buFvJAznsvaceoZ1J9aOA7ok+Gh9qCJOKihocyYYjr3TXcC7XvrTjBx3/4pCkwVq7/OBVWrSKUzOQUXbjh0KDXbFVuG7eI9KxzC0khCVv2LXgi0pCJb0cXOMq74Tvtx+YOTWJl7aOYLuVNab29Ik4tl4Zzc1cCVflAfQekLuN8lYaGM1C5L1pS+vqX4zJ4KTr2tP9FjdePwU3ZcRYsQus6rlRyd5W1uD9xTS+YWoTepycVeE3Ed+Qp4YFFPmnQ1vteXhg2D4GQBJo6PW8GCTVKxV50lr6ghgvj8aJtEx8TqGGXhhE/lShQvWxAORfsx2nv6b3floDA3wjVOJ3RoECN5y21f6RGtqR5dQEOIACRrWZOfGdE9pCxFiE1VJaf7OpM9eqQWFajtwg5aUVzJLMSYkL5D6eWbc/Ov0sRP0smg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(6486002)(316002)(6506007)(53546011)(478600001)(31696002)(6666004)(36756003)(8936002)(86362001)(5660300002)(8676002)(4744005)(82960400001)(4326008)(7416002)(66476007)(6512007)(41300700001)(38100700002)(66946007)(186003)(26005)(2616005)(2906002)(110136005)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Und5cmVZanRnRjA3YVVaYlJZSWtzL2NCYitxMkwzc0lzdkN2T0tFNmxtTXB2?=
 =?utf-8?B?WVRVMnFPbGVqVEh4NE5vQ2dLdm5sSVlZZXk3dCtDMCtBc2RVUGtqa1RoSjlC?=
 =?utf-8?B?UTlXREtVN01pZGx2UGlad0VrUGMwWnJwL3E0ekM4dnRQeXgxY0d5WUd6ck1a?=
 =?utf-8?B?bStrQ05OSUpZdWRUMi9vM0tjaUtORmhDalFwNmlCZkMzQVNzWUFhNmo4R0Zn?=
 =?utf-8?B?SWRMVlZ1Vi9XaXpUekNRRTV1bzdsRkJ0b2Q4ZTkxWjQrTzRENDVIdER6U2Fn?=
 =?utf-8?B?aEh0Z3gzeC9SZGczYjhpb3ZSMmFZenlLOWU4U21JdnRZazdCVDJDSnZjc2Zp?=
 =?utf-8?B?SVZTZzkybCtpc0VoRzNlanBSN1BRVm1Xa2hmemh6ZjNZOXNtZzRJMmZPa3dX?=
 =?utf-8?B?WWs3MlcyQ0Vod0Y2OVZJeHU0VzVaQ09Ta1I3VExFZE5tSk1DbHJSVmxteGRa?=
 =?utf-8?B?QUw2Nk53UkY5SnRYM2NxRktkZEZMME5KWWQ2bzljejM3U2pmZ2N6U1Vyempk?=
 =?utf-8?B?U0pOVEdabnkvOG1LcWU0SFVYMHRCK1FiT3gydkZ6VkUyKys5ZUwwNUM1MmRz?=
 =?utf-8?B?VVM2ZDNHMkhYMHMraWJJV2toVlltRzdxcHpxbmMxUWJlVEJ1cjQwbmQ0S3VB?=
 =?utf-8?B?S3BER3IxRWhjRkd2eC9qTjBlMG16R3BGYTkrZGd0WkQwMlBiM09FdndlWlBs?=
 =?utf-8?B?ZTRVUnlSb3VhenZkSmhBeUc5WFJ2UFVQKzlZeDhvWUtxN2E1SnBXTVlEd2Jh?=
 =?utf-8?B?dUFCYzB3YTNzZ2hsVjNWRzRyd0VpaGl1djNKTFhMdFZxVlFlckd1Y0RpMzZy?=
 =?utf-8?B?MWd2MU5pdElUMmptVGU4UGxnaW80QzI2QWMxbmc5ZDNLVzlUWElrNGMwVGVH?=
 =?utf-8?B?UG1kZE12V3h4OUROZ2pBazUwQldQdys5M1VHUFlBSEM3eDE2R0pLWmVaOHl3?=
 =?utf-8?B?dlVHWFd3ZEJFb0VlZGNuNDBYcDBDemgwRkFxbGRTdGI4WFYyeVkxNWVlbWMv?=
 =?utf-8?B?MmFiYlVJeTBXeTA1K2tvaWF1LzBVRTF2Nlc1TDFtMVFLbUw5RlBrT1VkTnJi?=
 =?utf-8?B?NkUyK1lIV2VDbG9ZZmJqQjVOdERXWHNFUkhGSHdhcUlEak1lNnh4dkJabW9X?=
 =?utf-8?B?OEdQRXN4VUhINkRqOWN5ZWxVUDVvbFVldUdrbzFoUEVqVStuSVhGWE9zeVdV?=
 =?utf-8?B?NENLSEU4NWdrTGhBUUtVN01BSUw5bW9EMHpzUHJJMVArb1J6MmRSY2hEMVZE?=
 =?utf-8?B?TytRdlp2czNvWmdzOWFIVXZhQ2s3Q0VVN0RBTmNKN2o3dDNsUkwrRlJiZ294?=
 =?utf-8?B?TGNQTDlrZDcxUE5hcFFmMnVBYlRDVEtNWHRpWHRXTzdDNXd6cThjQmhNQlA5?=
 =?utf-8?B?SjBacUxBV2NIWGtTOGUvbHFRcXJPTlVFZE9zVE4xVTFzOVRnSjlxNmJCQy9j?=
 =?utf-8?B?cmM2dE5UWjFFcG02R1U1V1h3eko0eVQvalo3YTJwTUdhV2h4VnhEOGROZkZl?=
 =?utf-8?B?TWRvSmxXa3M3REZiS0RJMHBQUktCeWhkTkEwSHBZREo0enRIc3pxM2FSUU8y?=
 =?utf-8?B?b0U5N2pYMGYwN3l1SWlKVWNDZXVpN0lPNGFGNHQzU0FHOHpTaFZWRGdJMkxh?=
 =?utf-8?B?VlIvdUtKb3RWNUh3ZVNCYnhlM0x6RlE0cytKZms4ZjJXaFh6RWNvakc1Ymo4?=
 =?utf-8?B?ZmhFeGRTVWdEN3NRTkpsaTgyWFNCTVlXek9DSWFVUWE1K3NiQmQzOXBuZCtu?=
 =?utf-8?B?RmhzcHR3OVN2cmpDL0FNbEF1NU12d1dkN3VmWmdVNERjWFE1T2N2dENqWU45?=
 =?utf-8?B?emNXSm8zcnN6QTRJeHN6ZVY3ZDArQTZSTGlwKytKYmF3RW9vZG5xUUJ1amxY?=
 =?utf-8?B?STFSTm9mMmVuZmtZQXVWS3NEc1UrbU5EVjdjN1pjKzhrK1FoZVptTWNNNC9M?=
 =?utf-8?B?a2J4dG5qbjViQncrSmxqNlRuTEdlLzBENVV4OTRYUlVNZkpmMkJRQXJrTEts?=
 =?utf-8?B?OVdORXFNaGJtUXVEQzUyMGJJM2lhVGxxU1lVMVoweU1SaUhVT3JQam5nNWpE?=
 =?utf-8?B?ZGYxUFEzMTdMRTBIaHBsUVN2dGk3czRucFlkcTl2U1MwOE4wNHBTVWFiL1Zo?=
 =?utf-8?B?dGtBVkRNaHpDZ2pRcVFTRXRkdmZYSGpJRlBwK09EMHBMSWpMZjl5bjljR3NW?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ce6758-faef-4e29-8f37-08dafa7c7fe9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 00:23:05.6654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4RJw09vqNuAacUQmqN1ziTfTi1ewESyAUms3VNCdlnQ0ZadtKVvmMnm32DZOS5VFd0J/FJ3jASHh5bvIXjsR7RAuORw06e1bkPkvYhX3Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7854
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2023 12:29 PM, Johannes Berg wrote:
> On Wed, 2023-01-18 at 16:36 -0800, Jakub Kicinski wrote:
>> +kernel-policy
>> +~~~~~~~~~~~~~
>> +
>> +Defines if the kernel validation policy is per operation (``per-op``)
>> +or for the entire family (``global``). New families should use ``per-op``
>> +(default) to be able to narrow down the attributes accepted by a specific
>> +command.
> 
> Again I'm not sure I agree with that recommendation, but I know it's
> your preference :-)
> 
> (IMHO some things become more complex, such as having a "ifindex" in
> each one of them)
> 

Per op policy is important because otherwise it can become impossible to
safely extend a new attribute to commands over multiple kernel releases.

If you add an attribute like DEVLINK_ATTR_DRY_RUN in one kernel, and add
it to devlink_cmd_foo.. its no longer really possible to add it to
another command if the policy is global.
