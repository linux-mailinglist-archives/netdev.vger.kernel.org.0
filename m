Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51866BDAA2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCPVMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCPVMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:12:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74858B8554
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 14:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679001119; x=1710537119;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CXP+h1le95di/NMUmfUnGpFf+QwYNrPpDPHFIPhD6t8=;
  b=U6RBuMSQ/lh7v6t+3PDelt7o6hZ7l5DezFG4yutfHZrRewbv8LLYxfox
   ZYNzmZ6tO7KIK3CDq7E7xEh0EiGKqPfOTIBwAmFhmV9HyZ2evphJ+in2v
   r80GV3bxmd1BrQs3YogtFpjMwZ+wXfaKgVpOeR5HtdpPUGCPHPzbXhaD5
   SIztA3QOqxgIr6HZdD5/A9GhNvQ7v6TUT6I5Gz/i7cFpWl13wtLfGtmzC
   MDB0FdycIJKUqjK/Y5VDipnQi032FSBomI0+CvkGUuCiv3IDNSUXYhLR9
   QPLVU8g6oNab+8raA7yATN+k/uCxPjagSnbY5AS4DX5j96cCbO7AcWH93
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="402994979"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="402994979"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 14:11:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="712502493"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="712502493"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2023 14:11:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 14:11:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 14:11:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 14:11:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOT/JpDEDBH7cOyHeveHxg0BIACQYSVV1XZJJI6a2QF8r2wwIjym96j66nMUrny1u/Heqf+x1t+IcqJxuGFJlSnZpYFvhuf9XPMYlVOtobBn1XqWMDdzVqjrSfOckLyCNs40r7OMu31cbmDKBKOsoxyy/ksXnwMcWj8OvuDGmwxSqta4+81+Yi6DvFaslW1HaDfE3PhX3jxulFCsO1aK3moT+zsDPCCLT/vR0+2Em1umjhPfKpouo7VqUvgqctR/V2Mieoa9JjmQyQKHXTomVmSK0IFBt+PfzBMY2ttbYv97iq6Z4njW22aEhmuINv774EXmJ/Dbs8vHB2z2hicjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oAlhFs4Ivl5gggObN3veV3Ye9G6jneQU/dMENcSLTho=;
 b=ZMm3K9nZLiLUaBC6tKgNccaD8+5uO2D+fj/jWIGsBdKYkkuCGcppzt1J4i9M3rF7sXCsTUdsk+bSe2FrVt2beMD+RR08dc8+yklWveoGZSoN0f4RySO1mSIAZOqSvkn6/25fw1W0Rjkx8CpaG1vj/lz6k7lSIGUSC+sfUiSW8/2xB2HLd71RSB+srIsft34eZ8xk4LTMKHdOV6q/0sz3GvyJNxCft4LbyICkr7mOQmVHTcrqoxQFkjJ+MU8ku3qlIIF3Klr9RbO+8HoJYfPRKSeEq0SFL8S+xLW7abcOvPI46zCvmCNH08LGeXTKbsV1G53JDxp24BAwpy7gJeiYqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6)
 by PH7PR11MB5913.namprd11.prod.outlook.com (2603:10b6:510:137::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 21:11:13 +0000
Received: from SJ0PR11MB6695.namprd11.prod.outlook.com
 ([fe80::25a3:92a0:1379:9e00]) by SJ0PR11MB6695.namprd11.prod.outlook.com
 ([fe80::25a3:92a0:1379:9e00%3]) with mapi id 15.20.6178.029; Thu, 16 Mar 2023
 21:11:13 +0000
Message-ID: <e91b0aa5-4d4d-adc7-b2e3-c36515fb32ee@intel.com>
Date:   Thu, 16 Mar 2023 15:11:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 3/3] iavf: do not track VLAN 0 filters
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
References: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
 <20230314174423.1048526-4-anthony.l.nguyen@intel.com>
 <20230315084856.GN36557@unreal>
 <bf4ce937-8528-69f1-7ba5-ef9772ce42aa@intel.com>
 <20230316135924.4ece7127@kernel.org>
Content-Language: en-US
From:   Ahmed Zaki <ahmed.zaki@intel.com>
In-Reply-To: <20230316135924.4ece7127@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0165.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::10) To SJ0PR11MB6695.namprd11.prod.outlook.com
 (2603:10b6:a03:44e::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB6695:EE_|PH7PR11MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: e76e82c3-2840-4c1a-e877-08db2662f914
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZtPkgZ3sV8UcAMaVfT0k5pNAcpP+lpF6I3MtKVSOXYk3X2eI+OIpP59pVThteN5g+bRdy/UGVsKuCCBgB9O/CVaXLspmz15A9YIS0g8rOEzhFrzQBPVo49zDWSUNIB8TmkrGRQ3xNDh8qKEB7n8t0agTn3/lAtG8UQCESkv/C8UowHAD7sd/srOcI2oWp9x3raQwNDYxZxUwSdKDFEAAM7DdTVkyJ2hmdjOOPoByLNs4EVVud2RUjDFOXrTNczp54jbmWJIJFyh4/8MuFl6MmF6DxeD2yaiys/Rj5+uMUNhn84yDoD60HV7BrDBRPuKCpEiDB0ZPL9hKSGk/MdYNxxZbFJ8a5+8fqE01J6Ze4z+ihnHPRPie8YuC0vO4awZevCHnmHez3yMc7W6AHOMp38C9PqX4cq264LgKmmyiLe27DlDCPUOqIzwY24ST15DSQMFRpg8f7RPKeC/CawFAcuKkGHlIEXObRJvg9+jMAaUS5AsU/OXtex4TAoPRX8Zfw5YPzFWezRYq/ItPmRRHwk0xO3DcHrlR5Rc6d7KySwOfK2IMRy+xFaZX4nx6WABwohzp/guCkXV8p8m2r9vonInJ7SFjdtEXbhljk0rs8pOS+H+/NJdwukQORbpFSlHp2W8ZkqiIvcxQ7qJYz9BBm2QqkNv5PbqXrcAtRmnN+qmABssJSb+DS1oOiyBf/nrEyCwTeaWbj6m6zlfpo3oOoPkDxzgN9Qta2BhzsCjKMM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6695.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199018)(31696002)(5660300002)(86362001)(82960400001)(36756003)(4744005)(44832011)(41300700001)(38100700002)(2906002)(8936002)(4326008)(6916009)(316002)(6512007)(2616005)(26005)(6506007)(186003)(53546011)(54906003)(478600001)(8676002)(6666004)(6486002)(66556008)(107886003)(66476007)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2x4MlZzNEJyWWlyczFZcUFEazJVSDlvaERxNVF5Mk5uU3JSTUo3bHc0a1R2?=
 =?utf-8?B?TEcxekloOC9IZkhyc0ZyZStsNzBiVzFBR29GOElHZkF0cDdrbmxJZXRCTWM2?=
 =?utf-8?B?NEswTXZYaWs4czVudXJKQUd2K2Q5bXdSaG8vQkZlc0JKay9mZlpyWXpVeUVF?=
 =?utf-8?B?RENxZHlvZGY2THFORE1Tc2liSHVDaHhRWWZtb09UNXp1dkR1WlNFOU9OVTdD?=
 =?utf-8?B?bUZ3SlhyNTJma3MzeWhvK0VlOWdMZURzeFM1VDdiWmFwZjhxR05uSkhQKzN1?=
 =?utf-8?B?MkhoV3RuenIxc0JNODNwRXlFL01CU3dPMmdPcFRnWWRpU0M2SGZRS0NVLzNq?=
 =?utf-8?B?YnQxQStSaHRoU0xiNU03TzJsMUFpMHlHb0h0U2tuNlJ3azZwb0VuZXh0OTZV?=
 =?utf-8?B?Z05nM3Roc3IyWWsyS0hmWXBhTWtpZDlNNGlWV1RCZE5tRlRKSHpLbEJ0MEdw?=
 =?utf-8?B?TGNLVXJKMEV4a3VkdmprVm1OK2Fwd2Z3T0hndnpZSUVTdWxPeXdhZmtJWDAy?=
 =?utf-8?B?Y0pIQmRwTG5hRWYvTWRSemdQS3BlV0phR3UyKzEzSG5hbnAvcmUxZWk5Wk5l?=
 =?utf-8?B?K3JaV2JMUkthRmJweTQ3N21UcGE1RHVTaEZVQ2ZUZ3o4L0ZqSWcvd1AxbW13?=
 =?utf-8?B?d0NERStOck9mV2haTUE2UmFjUkpLbGFZbDJhbHBocHZodFV1dnhQUkdNSXcw?=
 =?utf-8?B?ajlaV051SHBRZUZEaDNOVGZrN25ZKzdyN042cW5WMk9CaWVCVDB2YVUwSHJC?=
 =?utf-8?B?RVMyR1QzZ0RJYW8rV20vbEdqVUxtUTFzaXQxQkVtOVByS0FsZjRMc2JNUlFF?=
 =?utf-8?B?SlBCOW91Y0lKQnRZQWFycVlmeGw4VDNkZzR1aG9GZS9pUU45SE5wWC9DOXlV?=
 =?utf-8?B?Z2swUVdlaGlZaUt3TGhlK3NpeWFxRmhqczFkQS9zeHFhTXVVbWljMGltNmZr?=
 =?utf-8?B?a21DMGl0MzE2S1hSS1hBSGVSaVVPaDNiVGhWTG5nQklycEgxYWpBL2xabEQv?=
 =?utf-8?B?cHF5MnNLbG9udWN6M1hTL3k4ajJxeUdQSnR6Z1U0SzhJd2VNQWN4UWw1cmVl?=
 =?utf-8?B?TEVrR1RHL0FhY0NIVERjYXFQcXNMVm1sQnUvQnpsYXdSUzRtU3dIM1EvWFRK?=
 =?utf-8?B?SFpyeWZGcE5QOHpHQzZPeStKTG5PQ3VDRUJLYXdEVzdiQlZ6emFWTzFub3hI?=
 =?utf-8?B?akZoNWxGY09lUURZVlg1dlNDT1BmVGZrQmpHaHVlUlNJcGJGZEtUS3FTT2tZ?=
 =?utf-8?B?MEk0ZGxrZ0huUXVMSC9tTFR0a1VCK01IMHlCUUtLenNITHJYU0Eyc3JCY1d2?=
 =?utf-8?B?M1kvaEdSbzNKUGpBRnZjcjVQYmd5UGRNaUtsMTdzdk5NT1hDTG9GdlE0dG44?=
 =?utf-8?B?NFVBRjZ4VFlUY1d6NWVWTDV4N2ZwTEtOOXRESW16eUgxa0o1RnlBdzVNcEdI?=
 =?utf-8?B?YkVud0Q4azE3emppNTJpTHJ5b0VOUHpLNDhQSlZTNXdoRFlUclkxSGtjeEhX?=
 =?utf-8?B?V3dMQW5NUkRxeXRxNExnL2hyblRteDFFNXBHRVcyRTQxL3lXMGZUZnZjREJZ?=
 =?utf-8?B?c0JybndJeU1xT1N1aVpYNVB1bmRRb3dSMkRUdUliN3lBZGQ3c2s5dkhzdEVI?=
 =?utf-8?B?SlVpUzErdDVzZ2czN3hBSWVCbTY1V1dtMnJ6THlkN21QVE9Ycmd1b0w5RlBG?=
 =?utf-8?B?UUJYbGoyY1hTVmc1UzFUNjFjeGZSdjdwSHdaS0JPYzA4eFJJUldKdGwreEU1?=
 =?utf-8?B?WFFVdzYrVUdhOEVWWEhudjBmN0hBRWtLZ1hBaTBmVStBS3VGMTZSbnhpR051?=
 =?utf-8?B?MnNWSXQ0Q29GZWR6SHZJQ28rWFVMY241UHpKa1hSWXJlNjBhUldMcjdlT0dQ?=
 =?utf-8?B?RUtQL01jejRZbzdsM01NM2IrU3pGVXNJNU5NVEtVZ0FpTW9UWGVxdjdPS2g5?=
 =?utf-8?B?OTI0RmtMcWFXSmwyZk5sVWRtOVY2bVRLcnRzdnFNakJTUGVDRE5laHpmTFRt?=
 =?utf-8?B?M1J4aU9lNlVwbkdHZkEyamhqOFpSMFdTa0NITk9HRFBrMjJMRmx4T1dqeHA5?=
 =?utf-8?B?c21malJjU2xJMnhMV2x2ZWxNc0pBc2ZjZTFDREdSQ05udUk3TXd5NGhJVDZU?=
 =?utf-8?B?V1pYUEQxNW9VN1pUcUFjaUVxTFcvYks0UnhqR01LRXNtcHYzNDhoYkZNeDBD?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e76e82c3-2840-4c1a-e877-08db2662f914
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6695.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 21:11:13.4353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+00wfWP0jz7Hg9TftPDhAyYBuStlETq9PhEZTNck/EQj9lwJAzbNLDU54KzhIqm6KN7PZz0AxRH3e0Q58m7ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5913
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2023-03-16 14:59, Jakub Kicinski wrote:
> On Thu, 16 Mar 2023 07:15:32 -0600 Ahmed Zaki wrote:
>>> I would expect similar check in iavf_vlan_rx_kill_vid(),
>> Thanks for review. Next version will include the check in
>> iavf_vlan_rx_kill_vid()
> FWIW it is okay to ask more clarifying questions / push back
> a little. I had a quick look and calling iavf_vlan_rx_kill_vid()
> with vid of 0 does not seem harmful. Or any vid that was not added
> earlier. So it's down to personal preference. I see v2 is already
> out but just for future reference..

Thanks. I had the same thoughts, but then the extra check still saves 
few cycles (the function trying to find the VID), so I added it.

