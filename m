Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679B3632EA7
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiKUVS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiKUVSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:18:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612A1C6223
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669065522; x=1700601522;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C3s/Qu0ATo/N1VviM+IL7KohbfdybGEAN/Nldsn0ECE=;
  b=iUenVk2JiyosXRa8b3paTj+T4MgHi8jk0i6gYQEO+uy3W8ReGoXhFqiq
   WPhJT9b8n0SaSIXdiTzagWFiLwfBTItrIht8n3AeETaYxMfPDebss1oHz
   85//PsL/auG7HTXZbWbpmq63x6I/DaJKNWQe229GayI7DGyyRES17+E4k
   WIpLiHdiUAY1nKTg+U0+mhzHfrqhQJfJ2m6/P7Q/eqowZ2fs/BF2q9rW/
   FOl9H2hDsORskPKAY3/UUq7fdTzuETzJGwHlOq95d4xSg7T3ag3A2bTcc
   2so1IZbZhL7sXYIAYwZwPlhjDV8o+H7+HdxcXKY6wZYPTbQDHEvrZ+ZeE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313693988"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="313693988"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 13:18:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="747070940"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="747070940"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2022 13:18:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 13:18:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 13:18:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 13:18:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXdGQ7X6xa3OlBpJYWk2RUqNKLSrnuhRg8YVMuvPo5TSMb/KMTNIM8ZBRcS1Qy8JUasc+OSLktq0ZqtdVHtjilmynySuQKk/1fVTSUOIT7xK+un0BdOiiur5YLykS/HlHj3CFyCC9VZHJRCUvo9I9e88+VepGf2Y4hF3t1CI6GgPdHEOUXR2GUD9/8WNX9RRAiQavFPQcrBX80X8hDCC/2FYc4yplFUb9XEbGPFXgFBVUwpmV/+vyq6iCaKRu5cdL4S0i0tAVZeHcEPEwrH1xpzuy0mezKUPTEK8SblF7JQCR3xnMmVMgrqfOjwvdGewoRuwp0hxQAenBQnwbYRBaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+inGSwXfZDKwG0Oe1kdqd0QLw1jvkCEp8v5Cxb0G5M=;
 b=EaV/onVjrbVj7lMuR4uWDFX4/z8owNqLsFUoX2YaCzfgOf2bg+8f7nMyaFniP6ZXpCbimdGDW1MjcLmFYiW+xR0awG3fZ/UsthFwj9eEICJ8ORm+owXHDpyoSsWoR+JC0Gdx8oMkn8YZrEtgeNcijQenyS9iN9s8c2KRKaNDW6ViEVkGZabcX8kVhieKuOZxgsR1yMgzd3isGF6jNAWRcC4kbaVTuwAkN46qcF/wSyyiddQ+0ojqusPWo4C7pkCSE97BIX3w1ysu6jPdsBFMAANb8fFX1CxMyfJzb2enLCN+tgj/FOXKWegtkTOAkT/k2b5TlkB8inDP7B2/2mTubQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB5003.namprd11.prod.outlook.com (2603:10b6:806:11e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 21:18:39 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 21:18:39 +0000
Message-ID: <f60f589d-930c-3f44-4872-eac6b83d67ef@intel.com>
Date:   Mon, 21 Nov 2022 13:18:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 3/8] devlink: report extended error message in
 region_read_dumpit
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
 <20221117220803.2773887-4-jacob.e.keller@intel.com>
 <20221118174012.5f4f5e21@kernel.org>
 <243100a2-abb4-6df4-235e-42a773716309@intel.com>
 <20221121112322.21bffb4b@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221121112322.21bffb4b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0100.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::41) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB5003:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bc1f98b-eafb-4003-6167-08dacc05f54a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Yrl2vFN9D6RW47LDyMfQM/O/R+S3OiO9OMvfGelgh0BdeDx9OpyYNwogLcWCifT2wfVxAJz0XMkGRsBjohct5SCjf+RI+LhmivoDUE4Yy16cU2qXGEWQoQ78WOMn93XAGmm+CfRQws2wq2gvoCRWnkgJDM2rZr5xsbmu31EYV702RDQ6hIDn/95dzwwZ04OTHY/IYzTx5Uvn6NuHQyxIJyIzgw0AX0N8fRE6sXTWr/gikWpEXDQ1u2HVIFOrtx/VZMjJa+3wTon/RQHnRVAptB38kUjjNL3atZcTbltoBQnCU8aFXFdfJsLej7U5oj+tP/w5v9ZTrUie8UmMCNIxk9l63/+ek+EUvavwXS3wVmbTTvxkibNwY0NK1/N2Yn6y9H/xTq5dy2g4130DdVUkYN3JXI+esCRK7UY/Zjx6Tx+KxQoz78L4w6CnDTL5eTxowZFNH9Y8qA2mKtmsmpQl+YOb5OftIStibX0LUV8lGA3AeGa7aXHcTxqL7cgoDih9D9n9EAYHhf9G3u3SCsvaePMQ7udRQcO0A4F/uKhod9jLchkbjh6/iGvrVLgRSGkKMGDXI7dYhXclnfZ50rsfC8xDchpuizxivjSN/hrdDbvJBYEMw8boOVDgr4ISaO1+5whepkVSJ2nXenx4+/DIi56pLhEePfC0Kf1EhUXoDGk+ZayZpjpAFoGWSKcG8fD+zT/0pWf9kl8rV+osrSNlKRf0+E349sP6ld1H6vR3/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(2616005)(82960400001)(83380400001)(6486002)(2906002)(186003)(6916009)(26005)(6512007)(6506007)(478600001)(53546011)(316002)(36756003)(38100700002)(66946007)(66556008)(66476007)(8676002)(5660300002)(4326008)(8936002)(41300700001)(31686004)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmFuQTRRNFNGWkh5cTAzbW9TRFZKUEh3U01qd2FBRTF1ajVaZTkwcm4wUGZG?=
 =?utf-8?B?akJJZzBkVW9temdjZ1NGY0NzNlJPa29KOTE5eG5wTlQxYmpXWWl1emJOUHMv?=
 =?utf-8?B?MzFSOEgrVEZDb3VJdDVPaEs0S2FLZlRZMytIbi9oRk80aWxBZGV1aitzM1Nh?=
 =?utf-8?B?RHdzbWlmLzhGZ0gvemJUd0lwS1A1UW55Ym9sNDlDdGNOY3J5b2xuL252Y25K?=
 =?utf-8?B?S1Mvd2dQdFB0ZGIrYnU1RmRINGFVdmZEbjNXdkNLTzFmQW1UalBUUGwwTWxJ?=
 =?utf-8?B?bW1nVlVxakRBR2xUQnFzUHU4WC9qbG5sZ0xTMllTUjRIWThvRjF2eTdXbmlO?=
 =?utf-8?B?alNsdkEyMXo1YmZZZHg0d0NFK1ZIcFU3bHBDeUZlUDNTNEU0dFVJNVJtZ3BS?=
 =?utf-8?B?ZE5pQjlKdnFkbDkxd0RTaHFoOVZzMFR0QXZFR29sRHRiTk9uM29seWR6NVlM?=
 =?utf-8?B?SVhXeDROUVNzejZKcDdXYytBZ1ZHOHA3ZExFME9IMVFybkRMN05yVXhwREJx?=
 =?utf-8?B?YVNRWWNhaFg1NWtrTHlMSHhlcjJwVTMxTVFjY284NUY0blVTYk91S0hTMkJz?=
 =?utf-8?B?b2dLR213MC9nRVlVODZ1ZW1obzNOZWE2TmNyRk13NGZqVVpyampIR042VWRM?=
 =?utf-8?B?d1BYQkpmWXRaV2lzR3JnRk15aGRocWM4T0ZrQXNBSGt6U2g5ZHBSbnR2Wnlp?=
 =?utf-8?B?SHJLcU5PZW9WMFlxSytVeW9QT00zZ0FER2VYc082eTh0RW41MFd1a3RIZmdI?=
 =?utf-8?B?anFWTTlqc0Z6L29MSy8wOTl3d0xXZW9RVHRENkdBcFRHYmpreEtOVGtKV3Jp?=
 =?utf-8?B?eklKbGdVRkE3QjM1OXAxZEpRYjFyZkRMcTlUWGQrTjlsWktvb01ORlpuRjNJ?=
 =?utf-8?B?UGJIRVF2RENURDdnOHlINTBGLzJ3Qk1DdkpQSyt0UGZ1MUlMVFBMMDJHZTVW?=
 =?utf-8?B?OHFwbGZKTGEwakdqTlNoUGJSM016RFhKb05mWkRJamVvWVFoVzhoVHJacEls?=
 =?utf-8?B?Qi8zK1k5aW0zWmpRNk9YY0xXVDJaWEphOVg4S1FqRngzY0dsZWJCNmNmRVBI?=
 =?utf-8?B?c3VYVllVbTZtU2NNTWk2Nlp5Q1IvK2xEaGxjTG9SWFZiRTg4QzBnMlVyZEI3?=
 =?utf-8?B?cjdnVjJETld2d2hrNXpFbWtXeHdramJsYTFXVEpqZjZHZVJwd2FhbFo0WWQv?=
 =?utf-8?B?L1E4bDkvMXJLTWxvODR5N2tEcFhrODliRTVZRmxWRW9oUStFUWtKeGM5WTdT?=
 =?utf-8?B?bFVyZTFRY0ppa040VXUxU0x4ZVlYWUwxbzNBamhocEpKZmc2bUZ6WGZub2pH?=
 =?utf-8?B?Z09IOExzekR4RXN0NmdtTDlEcTBPdzU4K3NCTFpLY085NFp3VndpeENCaHF1?=
 =?utf-8?B?NUlXZ3V3WEc0aldWYjE5YkRVVDFDb1ZvSkFlOFFaRVFCZVMvSGI2OWF2aTU2?=
 =?utf-8?B?VW0wK0VEWHRtWk0vTzZZTi94TEpFUVNobjVXVTdTZTFDbW4wdHphemdWeGlk?=
 =?utf-8?B?NmVscEUyVmZXTTgwanA4UitoZWsyUkY3eFkvbnQ0TWgzWkgzamhjdDBMVnJ4?=
 =?utf-8?B?R1BNOVdGekg3b1N1NFpFOXd3STlYb2FVbWd4NFpkam9qRUF0NnNQU1FiNHR6?=
 =?utf-8?B?Q0Uwam5iQ1dxdkU1Tzg4Yi9FR0pTa0lJelc5Qm5LQi8rRU1weGhYcFNJVjFP?=
 =?utf-8?B?ek1odHRnNDVXNDJBSHJlZHZxUC9zenoxU0NyNEJrMjFRaGZ0RWRjaythWUhp?=
 =?utf-8?B?RmRjbE1SWXlNcjdFK3VtZVVLSFQxSWp2VWIzZEQwVWQ3blVSdjJCSHV0VEhY?=
 =?utf-8?B?VFJUaU5CSTJuTXZBa2VicFpWMnh0eXloSGNmZ0E3MWFvOWhCemQvUFdEVWwr?=
 =?utf-8?B?MkdlSVMxY3ZjT3EzSCtrcksvOEhpYTBDcmsxYzNPaGs5cTVxQTdRdjBCdjZZ?=
 =?utf-8?B?eW56ZnAwZmhtckZFZTB0KzBZZTkxRDIrQWtPbHFmNlFhV2JqcjRPQ28zbHA0?=
 =?utf-8?B?aUdIOWxCR1BsUHhGMVFrMWFMUnFWbWhDWGxqSjlsTG4yZzVSemxrTktjL240?=
 =?utf-8?B?RFdQbXByYTBCYmlDbjdFMWlEMHoyMXY3SHppS0puc2UvTExrTmNlc3JIYmI0?=
 =?utf-8?B?UmZObmtFOG41U0MxUGZUTTdJa2tJQ0RBL1VValFGWkZ0NTRQL0ZYbXZjV1Vy?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc1f98b-eafb-4003-6167-08dacc05f54a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 21:18:38.9635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQn8QDm5GgZqXtUfdK0zP7Q5II8yqkAff+BS/ZbNrjFUt95aoQdfvztRtg6Jt9y19436nhIPmJC7PTZ5HLj6+XE8L9DYjbCbMg2+YToQoqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5003
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/2022 11:23 AM, Jakub Kicinski wrote:
> On Mon, 21 Nov 2022 11:10:37 -0800 Jacob Keller wrote:
>>>> @@ -6453,8 +6453,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>>>>    
>>>>    	devl_lock(devlink);
>>>>    
>>>> -	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
>>>> -	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>>>> +	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
>>>> +		NL_SET_ERR_MSG_MOD(cb->extack, "No region name provided");
>>>> +		err = -EINVAL;
>>>> +		goto out_unlock;
>>>> +	}
>>>> +
>>>> +	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>>>
>>> Please use GENL_REQ_ATTR_CHECK() instead of adding strings.
>>>    
>>
>> Ahhh. Figured out why GENL_REQ_ATTR_CHECK wasn't used here already. It
>> happens because the dumpit functions don't get a genl_info * struct,
>> they get a netlink_cb and a genl_dumpit_info.
>>
>> I can look at improving this.
> 
> Ah damn, you're right, I thought I just missed it because it wasn't
> at the top of the function.

I also saw a few other cases where it might make sense to use a 
GENL_CB_REQ_ATTR_CHECK or similar.

Unfortunately there's at least one area where we check for attributes 
inside a function that is used in both flows which would get a bit 
problematic :( Will see what I can come up with.

Thanks,
Jake
