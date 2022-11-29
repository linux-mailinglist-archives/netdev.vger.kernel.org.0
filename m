Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0138D63C730
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbiK2S3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiK2S3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:29:19 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B241554E1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 10:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669746553; x=1701282553;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8vLFug+3wjdSbni2Qn7zqykyTYAKZ/zd3UETVAe70x0=;
  b=aUxLZLoHvNUJ7pHl83XhYfl9yXCVlPtbhoQbXsHeDvUZCk/1aEQHG0gK
   trTkfoGGlEKyCyd4Ee6WAUJSDW86zjN2UDNran8rnitcaAi11hP4IXXAp
   a0D1PX//MCcpdiLJFDSUmWHXl+8n6RWPqfXIehTe0A8iJAXSlJQkTXtnv
   48GnFDcw54y9frvxBDXig30t3aQEuRzJiSW3Hp64RKMmLIeoWSG5H9O4q
   ePzo3zJ8MVnScjgOcOinvCKEQj1Ug9wfia+zoFmyBx83FHsxDhI5gd1Kp
   dImMU2x6NJ/WwexBxwxaeCIMLXReA0TwgIjDC8GzoW2XfKlCxeiT14bNC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="377354705"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="377354705"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 10:29:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="786154190"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="786154190"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 29 Nov 2022 10:29:12 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 10:29:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 10:29:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 10:29:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 10:29:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQXg3DEiag6Yl952Mfxu2XAYqjhA5csJ7jICCUdBnibepm7/+HKDzg7CgUCXtFwaBFStz32IokMCq8TPXuvRMwQq6Au4jntAXugAECdM3bA7gkkU63SATUeJ3mLuJDMDTuLqIZF2yY214VRwPZ7Fs8XpGypnD87sUIG6L+J79CRkiOCd84Tb8zEilMaUDXUDLbQ4ErJVr6ndRVd1eim0wRtIJQSFwCKyVKGUrgVaEYAOhRzRgGXvj4E7XtG7E+WODb/02odggseb2dWxNyRBj7uYXXM2eb1jnK6lzTiWSOf92mGmRaSMHIOYDyBfooNlL646tlr5wuAL5redOOYJBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B9pWOC2Ru1hlkG7tGKKQ72/wSSNssa65g82S/a6XnNk=;
 b=BQyu+qbBq9EwIpwaMNHIF+8YrfeP5U/SkQNRL95U2rsXmVOEuI7CBoSCDHJQaGdMh9MGUmRkpfxIMAl4l5JYr0nvXDe3DU+eUIcTEQkfsBYhmYJYwB250IqBt3Vehc58n8c1zUO+M5iS+jWumtAt9xX0nE93DPXbRNPyIvmT7K+tGPUC+DYb8iP5hRIbbgsp9cWL4ZU2l8TXctvjrbrIlVhsVZPJVTH0d2nP2ENoux627xft6UwjJvjK0fUGcepS+rRMsrjVF52yZysS/+LgGDA16gBP6q0LXT96dVfbzjiKmDrZ5t2WY+VzXyTzGe89tlMcIB13iu7cw6lDAngwxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO6PR11MB5634.namprd11.prod.outlook.com (2603:10b6:5:35d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 18:29:09 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 18:29:08 +0000
Message-ID: <cbb0a853-8904-bc38-f1dc-b99541b2d100@intel.com>
Date:   Tue, 29 Nov 2022 10:29:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 13/15] net/mlx5e: MACsec, remove replay window size
 limitation in offload path
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-14-saeed@kernel.org>
 <4bc41493-f837-6536-5f10-7359cf082756@intel.com>
 <20221128193553.0e694508@kernel.org> <Y4WcWaVbNptkQiEL@fedora>
 <Y4W+/6MIAP2ZSqiz@fedora>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y4W+/6MIAP2ZSqiz@fedora>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0053.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO6PR11MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: 588478d9-2622-45ba-2e07-08dad237998f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqGCtz/rkabNwWDRB0hq1yCU28L0KOvtgycQIatlNRO4ivhB984A5MBh+9PAcTfvBH/Kr9kJmrZMTqRxX2np45hX/NvQ9rcGCo8jxNYNJgx+39RZr1+wB5xdgI6imkVYawRVj6V70wZsUBqXRe5nG6xZy9lb4PeKTg0aIrPKSy5xJ1ieRrNuolA2lZx5SgNldFI8BRKib3owRVLHDmh+ucoHyZQzE8KVz3E5fuG1VVXp7MRSMInFDA2GBje/ePRfPT8U+8VLXjQdzgKR4P7X+YQOwJXU7AFY3qrQf4siOvSrvkpwbXRz4GMyn6JEuNLGjY4NERmEhqPD9KVMJGperPMg0ILHVPm7QiAKba4A86PvBqdPHyDoh4xgNOPL+z1Vbz1r2/ojJbZlU37cxOaGcARFAyIeIN4N2GPW4Iyj/Fetfxx3xsdmANgSsLVI2rLk77Cu+eOXOBVE5cRMAkMeLY79IkTwyHuO4OpV1Nqwd2RzJuADWtf8PwBqCelm+omrZKlVCL264VL2ZsLwNNUg3ov9LNx9akxbzdeGWf70VnGdgGLNVJp3I72MfHPB5GoJeKP8Oy6Um2aUDn+lD/s/oVaf0HyRszoPlU6B5T+nTawemyaEidiRguVVPcrJDjrCJmqtThdps8wJQgNDObOWDc3VgxeC3tFlu7aHki/JriGNXKBr4xgAew9VUul6mYsbg1isJ3o+a148hNABjnikszQT2zFmrTNQr5GZz2S1T/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199015)(2906002)(4744005)(31686004)(36756003)(41300700001)(7416002)(8936002)(66476007)(5660300002)(66946007)(66556008)(110136005)(8676002)(186003)(4326008)(316002)(2616005)(54906003)(26005)(6512007)(6486002)(6506007)(86362001)(478600001)(6666004)(53546011)(31696002)(82960400001)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajB5TjI0K2NDakxXenhFVHpqWHBLRXpyTFZXMEVHclRDU1Q3dmZnREVEYjJK?=
 =?utf-8?B?M3pOaXFFbnljTmVoSTQrM2JXTVYwenI1VmVWV1Y4UGJ3QUpHaWNLMDJCR3Jy?=
 =?utf-8?B?NWZ5b1BpWnNHY05ickplZHJXODFkc21Tek9FWCsyTUJUSzF6RmRrb0Y0eVc3?=
 =?utf-8?B?OGlMVTF6Q0Y1TDJZOUNxZG9rTi9ta21aSEd6NXJXL2dhalNhdFVJRjgrMllE?=
 =?utf-8?B?WkFjU0N1Q1dvL2F5bittSW1waE8yampFdWtjSEd2RHY5OGZ1OE5aWG85SFVo?=
 =?utf-8?B?aVQydFUyZ09oY1l2aHh2V1ErMktjZEFUc1o2c3AwQnJXU09yakdwZWJGZTVj?=
 =?utf-8?B?MXpLQXQ4ak1tck8wL3k5UGpNOTJCVTJaam5hMzlQdVkxVTlaSVF5K0lOK3U5?=
 =?utf-8?B?TUVkTTVOVHBYWXZkVG5salR4ZU9iZTc2aERraHh3STFBeFhFcjM3Vk96bmdh?=
 =?utf-8?B?M1kraFhnYkM5cE1NM1pGUW1hV2VJbHA5Tkl5V2pBZEZSQUFYNHkyNW5DSzZs?=
 =?utf-8?B?ZjhVRENlVGFBOHFMVGtONVlLWXQvWkMzSmxoemZYNS94ZVBoWGhxdGxTOEZZ?=
 =?utf-8?B?R21lTVVadkw1aWs4L1hZT0ZnOGdEY0NycUFPVGt1aTFPRUVxa2o4UitMenM0?=
 =?utf-8?B?TVlHOFR4WklFR0dqRUF4VTlHN0Q2V3A0S2VmamZoZjE4K1lzRzg3NHBuWkFK?=
 =?utf-8?B?M05jc3h5R1lqaGJLTE5iNzBWYXJXVlpyeFBNcnhoRVlBZlBCaGJaTFp6Vksr?=
 =?utf-8?B?VjBsV2NYM2w5bm5wU2E3U3phQ3NmN0Z1RHpuWVR1bmxKTm9qbC96ZS93Z1Mr?=
 =?utf-8?B?aVFTWVhIR1dnZGlMblFySHRvakNlczd1NXJtcEd0TGdIOWFTL1g5Zks0NjVK?=
 =?utf-8?B?c0Z4UDVoeWRjRmV1U3NUTmFNN1VjODVsRmgvWkRTREM1T3c5SXUwYmg3cGlT?=
 =?utf-8?B?QWgzdkduSEl3NzVla0dnSlBwQlpRSnJsdVgwWFhJcWQ1Y0RKWWxiUEZlZlpP?=
 =?utf-8?B?UnNybXVZRXBobmQvdXdrNzBoTnVkUi9Nck9mNmtuaTA1ODRobWZtYU9maFFj?=
 =?utf-8?B?cTd6ckczYUNjUUJyNjFWbElER3QxUnd4ZXVlSm1YRjh1T2p6aHEwSHdXSmhy?=
 =?utf-8?B?enZvdmhEN3ByRlJPSDhPK0pFMnF1UWJ2b3QvbUVYVGZ3Y001UmhHZ0lnWXox?=
 =?utf-8?B?Y3BBalArV1R1RSs3ckNWalBoT21jekgyOWlpUG5zbXQza3BDbGplTXExblFS?=
 =?utf-8?B?V2duSUMwQ0hjemhIL0lWSjdJSzhRdnpOQUkrbitnbVhlVFlKbWp3ekZlWDBZ?=
 =?utf-8?B?b1RGUG81d1ZhTEl1M2VRVFRIOTIwU3NRZ09WZktzVmFpeGxBT2NVZFpjeDE0?=
 =?utf-8?B?VlFwR0xwS3dzbVVPZ2s4bTJhQ25rWnlIa0xhN25hQ1FzM1FkdzlGbHV3V1Fa?=
 =?utf-8?B?UHQ0eUthRWZmbXY5eE4zK0tYWjVMV1ZTVyswT3VxaDlaTm9FV0FUbzM2Vy92?=
 =?utf-8?B?bERIalNlbWp5WllxMmVlYUYwMkR3cFNiNitjZnBUUS9QL1lhSXhmaXN3dEZD?=
 =?utf-8?B?dHNiVHJyd2FtWHRHeEt0MlU0VHRLRnRZdWFxWVg0aStkblRnZzdXb2RRVW9j?=
 =?utf-8?B?WjFXaE12ZWtncWFZZEZKRzdqTUViRUVaajM5NUNhajRVRmM4cjR3QXVPYWp6?=
 =?utf-8?B?endCUFA5YkgvTXY4U2NHY3dHVGI4UnV2R2hpdi9GbnhWVEpwZmRrRVdEOEVK?=
 =?utf-8?B?YVp4ZEZLZVhZT3UvVkI0U3Y4UStsbjlWNFpUbW5MSVZJNXArbkpDbUVQTmto?=
 =?utf-8?B?a21ydHNNNnYweW9tdHNEZktWV0lkdXY1SVFNRlJCeEJVcDlXb1o3Y1FqVVBi?=
 =?utf-8?B?bXJaS3JtelFVQi8rcUk0TUxjNFliYXczYzJCczRxRDdxWVhja3dBYnlFT1VX?=
 =?utf-8?B?UmFiSmszNldKeGpQNmV5S0IzTk43VEtuaFBYS2VaUXhPdlA3UWxuTEZDVmVt?=
 =?utf-8?B?ZXR3UW9pYi9qa2FkcDRzRm9hTEYyWmhrUVp3UFRWTytSV0x0a1JUOVRTbTNL?=
 =?utf-8?B?TGZ3MitYY0xmUXpKcm0wdGd4N2EveERmWWFQZHlHUkdQc1F4TVQxQitEVyt6?=
 =?utf-8?B?VENwNWx3ck1kQUZsc0VlL1o5OVpIMysxNVlKbFlGQjdubk12cUhVT1BJTnJX?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 588478d9-2622-45ba-2e07-08dad237998f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 18:29:08.3001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQcOMYw4dUSAFmcUEsGs4f8yMnkQOcR1LUrQ0IX7tEX+81A5zpHV2aADPyv2mo833IsAHlhxVUlnf9z7ThmqKuH589JLCF2RDn8D2DakqtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5634
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/29/2022 12:12 AM, Saeed Mahameed wrote:
> On 28 Nov 21:44, Saeed Mahameed wrote:
>> On 28 Nov 19:35, Jakub Kicinski wrote:
>>> Damn it, this is a clang warning, I need to rescind the PR :/
>>
>> Make sense, Jacob found two real issues and this one is critical,
>> but I don't know how that works for PRs, let me know when you do it so I
>> will add his reviewed-by tags and address the two issues when is send v2.
>>
> 
> hmm, I thought you were planing to revert my PR :).. anyways, i am will
> send the two fixes soon, so you could release your pr to linus,
> sorry about the mess.
> 

The fixes look fine to me! Glad things got caught and fixed before 
getting spread widely.

Thanks,
Jake
