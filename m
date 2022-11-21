Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC72632B86
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiKURyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiKURx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:53:59 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8728826FE
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669053237; x=1700589237;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4VAeaR0cNtkkFDOerTgtN6CkijNKaQJ6EFZ2VbBeIMg=;
  b=XHs554lZjYg+up4JI0Hz92gJAWHar1TDqxJMCOpt0UGIbM/RXBUicMC+
   9KoE0oQkthwiSFWoFGBCMVgzMobEf0uVUu0bn5thqVyL6Yh1E1X6+lEuh
   jjHyz/k173KRalMcCTG37HvJz81G2ZQzL9ssObIE3CSGphZHhrJd2cfjz
   K+oOWGIFy0Xnm4V34KLTbW1DD5ZBqM2wwnKH94f0efWXXfgcpoEEJICEA
   HfzCXIOdnJK0PXOi3SWkYxVZh2FOr6g8xPk6MUDKfSuHgKgPkyrsKgZmO
   BdzxZdvxzc64bbFZFAMBwZtfbsay8qRuvTUQNX4iSA7P1ZnrUj/glxbA1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="375765813"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="375765813"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 09:53:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="709897466"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="709897466"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 21 Nov 2022 09:53:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:53:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:53:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 09:53:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 09:53:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwkX1DSqUsmuHp1bkmUG+FBNpj5+fTzMN+xlG/n9M9npnev0rt//YL2+lFQBf1zeS1x6u2CNvR5/XJHhPqH+5IDGc2HlOKfkLB/SIpHWcOnQkqDgHi+7sidhPZEDI8fyyGE7xrtrxgvEfZGPZ3+6xvfFDFjSlcE/YTxKF+sAKX5WgKbhsaxgX/ZESku/b0NUvh4pzmCLLtNxQ4sq01bDEOJ75ri7Iorkq6SUaW2ztJZQaFgKLq8Su25/oJYBaCQLtgKLOm9Vjk7UICcYkdp0+lft5qZKxS7RkQ7iRmrgvWZvkWpPMx0follr5UWA7vDKsGFlcNyX4xELOoj2doJ3uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wuifid5MtJM5mM3RiXX8ASS+jtqkmg7ij3OPv0YGLDM=;
 b=X3URBh+GXkUouA9vLY+nhk3qKNIXmCscOm6BRs2kB/hZpv5jXJwbtEgAvUZBwPEd1lfKR1GLsGsgonyB0d4RF7VCqnFpEJc3VHV+yIOXGS1kwJwwwQdhmRkB7Si3tWzcY+/txLY7jfrM5QAdvYhJxK0n5a8B9jvtPy/py4mOxbyncJC2GpZLXctF/l2au124kmJg16tPasMj90OWRKWKR5J4ARd5rMFwKrTZtVpNQn+JeSYfplje1y2DRiIMFyqn59B/I1jtGfNfbyJfSy2Z5kE4oKLQV4bN3oNWZWW2oiMblaGkbpxyVXzdDP5qL/OtN3jQ6Yl0toDvHawi93Rpsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB7063.namprd11.prod.outlook.com (2603:10b6:806:2b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 17:53:09 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 17:53:09 +0000
Message-ID: <9c8316d6-d804-0c21-2978-baa052b75513@intel.com>
Date:   Mon, 21 Nov 2022 09:53:07 -0800
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
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221118174012.5f4f5e21@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0025.namprd21.prod.outlook.com
 (2603:10b6:302:1::38) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB7063:EE_
X-MS-Office365-Filtering-Correlation-Id: 378ae3de-bea3-440a-5948-08dacbe9400b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VitgbeKmbkocRR1dUmmTUF8R7ajPzHnQhfZDATxK5jYsGNVPXtLAFT5sQyf2y8R7eGxXkevd5sDp6kbGzTmWx8ooBhF8s1SfWSHK5RvQ8lBQc8fglx0tJ8kPdyD+rqE7fYjIrn7wIJisbfHh+aUwBNW5O4lmO9p9M4uWpKBXWl6Xi0Q9QAsuMFZO5XN74zjYLn4LfP/afEYiK6qFPkTMBhhTWQy/QMhTJtIcZ7bPB5DTEmJz7ljFEBwMZQytflbKTLHvZ2cl+MCsaycnJ7UnLF3sg207kKmXTWKC5oYpclTAWffr89c7ISHHCEr3CcJ23zOxtSzn7MqgbsfnzecPErAVGmNsrqwODh7rPzo1ZEtvsYLF5NICv07aqr2GnU1Hp8LWQCUUU5KEX6Wgh9G+vNqbc3IZfKmauNsYZzfm6Ehb/NJYSXVKoG4CHFjm7MeyXSJ4p2r3xs/6J5We5Y1TriI8OqRNPKFEvsVewQbnWMMm49wAC+wzgUVcJGRhIcQxfwnHxa652OdxCyhgys1iyDdS1SkkXY7t6Up91znhEUvBoYtkGlfxragzZOTbD6mjh8QJNI4FkjfDHUAp/4heAkxtFF8JU3ab96QO0AAerJ+myl1OuzBAhaGEmHLV1f7U7u+gM0CB9B+P1PhZGR9QhXdp5MEXzEo0PqXY9+IW8+DLLDT3zEZJCSXjnvsFnI/DNmyMAg0S9fx5Ez/7iP1olFKGqojpPzvIyROhI1sBolM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199015)(6486002)(26005)(2906002)(36756003)(6506007)(86362001)(82960400001)(31696002)(478600001)(83380400001)(6512007)(38100700002)(53546011)(2616005)(186003)(8936002)(41300700001)(31686004)(66556008)(4326008)(66476007)(5660300002)(8676002)(66946007)(6916009)(15650500001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjdUSzBtYmx4UmxkSzRrRXoySjJwMnBtTmg0T0pXc2N2TlpURGhKalJSc2NG?=
 =?utf-8?B?RnNDeUdQS3BYMVJJRk8yQUxNK3RCVm5PeS9ZTnF2QmIya2RDVHpkbmpEWXJl?=
 =?utf-8?B?SUtqRnNJN25NL0FDSVYzTWhxRStyOC9aeVpOMklXQVV3bSs4MGJ6Q3MxWUl3?=
 =?utf-8?B?RkFuNXl2cEk1aXNob2c5NEJuRVdkWktRQ3NOZEJBK0hlU3VOZlo5R2p1TzR0?=
 =?utf-8?B?M2tnV2I3eUFjd3Nvc0wzUk5LREFSUTdXeTNiRHNpM1ZVcGFTRFc1NUgyRHhl?=
 =?utf-8?B?UzE3NnE2bUNkMnJVR2NzbDd2WVBkQWxFYVlxY1lCNGhRRTZhNVAvSkJ0UVpS?=
 =?utf-8?B?T09iSnN1eFpoRU1nT0R0cEwvdmV5YU1rMGRmb2tSRHg2czVkVFkyNUxObXA5?=
 =?utf-8?B?azdxMVpob0hVdVl2VmJLRDZnd0I4S1RFaWowcllpWnFvY01xTERLYnZuOUVR?=
 =?utf-8?B?aW5CMkxBMEhNQ1p1S3ZuNmRyWmd3Y0dxZWFyWXJaY2xVOGlYaGFJZWNCODBt?=
 =?utf-8?B?NHc2TzZJZE5MTkhhTVhyY21mUlZPeGhycFJ0QlhiQ3NvL0JrYlNZcGRrVU9w?=
 =?utf-8?B?WDI5eU15WmczRXFNVDdWTlBnUm1abzlISlFsblpPbFhsVUhoUzd2QnVkLzVp?=
 =?utf-8?B?cnBLaFg4dEc2ZDVhdnJJemliRHR6ZWlPK3RvdEwzQ1VOemNWMkVHYXBGS09B?=
 =?utf-8?B?UzZaWkI3WEZuUmhpNG9wQXNYV3lBbUtUdzNsaVBaOXJkWnRBeXFKOGJOZ1JK?=
 =?utf-8?B?eEorbmFzYThBWDQ0cGJnb3Frb1pVbEtrTU51WjFDVGMzOXFXY05oelJuSVI2?=
 =?utf-8?B?YTZWTnBpM252VnN4eFk4NTgrbEV1QWpHZG4yT05lSUxZTmFkWDZDV1lTNWJy?=
 =?utf-8?B?Wm5WUWRWNnBZVHZyaTE1SHJHSlhHci9FQVFlZkkxaEFVNjN5SGFTMFlqcTJN?=
 =?utf-8?B?MncwOTE2c3Q3NTlpSU9Wb1Q0N0grWmFaQ25uelVPbFNLRnRWY1NFMkZqL1U3?=
 =?utf-8?B?N2k5MTh6QngxakVJVHlUbHJrWkNMWXBpb3p6UkxKYjBORU5OTkozbERpdDd5?=
 =?utf-8?B?cmxJL1F2RVU4NUNGeVhEMi9UOUpDcEpqVEV3b01tUmc2YnovYVcyVzIrbW9H?=
 =?utf-8?B?bTF3MjZLSTNpOVl1ekx3a2lHTy9xeGJNOGpKRTlJamN0K0VPdFlIMUVMT2dm?=
 =?utf-8?B?NEs5MFdvbVFFS01NbnpPNFZXTUpOcWlpWEtTSzFvMHY5Z2k1S0VxYzB1bWdp?=
 =?utf-8?B?U3cxYlg5dU9XRmZId2krek1pYjQ5azd3QlN6bTdxMVRYRlNFR2FZOFpSbXhs?=
 =?utf-8?B?RHlCUUgzRVBOUXdtcmZrN0tHdkFobWJkZzM5OERvR2pVZkVJZTAySktKZlQr?=
 =?utf-8?B?anVPL1o5S0l0Q3lJdGJNbjlOMUREb1RwRVBjYlFwNktBZmtiV3k1T0VRRVc0?=
 =?utf-8?B?UUFMNEc2SXdOWGtpTHdWU2hOaWdwZFRmMS81TFpteTNwL3poa3VvQndLcS9p?=
 =?utf-8?B?cGozcnFNakpGQ0RuSm8wT1BxcVhQa25XUmgvK3NPYVV6K1VZM3pxOEU1dmQr?=
 =?utf-8?B?Umtla1BHSFluRGFjekhZNWU1dlFQNXNwNkNtWGFzZjRKWVk4MmxzUlpIWFdV?=
 =?utf-8?B?V0lzL2QwR0h4Q1FmMFlJbGV4QVdkbGVFTHlkNTNuMWZ0M0w3dzJXYWh4dEdj?=
 =?utf-8?B?VzFLeGFOVnU1ME1XZllhREZQYllIVURxZlJaa2xuc1REaFc5Y3JmaWlzdVlD?=
 =?utf-8?B?UVZwU3Q3d3I1Mk0yUnNwMUtvZTAyeXQ4VC92aHNCamVxRFovZ0NhelNHQTJo?=
 =?utf-8?B?aEFWdER5clN2SWx3a2VnYjhsNzBVTmlscnJnS3lJK1JZOUozRmNQY2hWallH?=
 =?utf-8?B?Sno1YUx5ZEZEeFZ5a1FFVmRuZVlrR0JlYTBLZytFVktDb1BncmdZSGdSN0JE?=
 =?utf-8?B?MzJSc0dHUVQxeno2WjdSOUlvaUVKeC9NaTV2RXFyY3ZNU3NYTWpXd09BQkRu?=
 =?utf-8?B?b1hrNWt3TXM5dVJsUkgvVWcyQkh0MFVYc1d3d3lNSklkQWJPNEhjZHd1TzhF?=
 =?utf-8?B?d2YvdlpZWjFHemVVVFdYZk9JWlhzbWVkbUVxZEhkOFRjc3dzMVp2SzMweC9a?=
 =?utf-8?B?aDNtRHZQb3V3NlRwVjF2b1dIejNoRlFxVWFUMTc4WHBoeHJnbHRRRzZSK1Vk?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 378ae3de-bea3-440a-5948-08dacbe9400b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 17:53:09.0161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61XnIMrIkUUUU03ldAN/EUbPmkGqI+qfmRxGX66x1aMWLp5WQxFmLqBv0/dzcn7UpNNvCIV8EzoEm9ap4H7cuuRmZeu28fX+FfSoC5BlIBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7063
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2022 5:40 PM, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 14:07:58 -0800 Jacob Keller wrote:
>> Report extended error details in the devlink_nl_cmd_region_read_dumpit
>> function, by using the extack structure from the netlink_callback.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>   net/core/devlink.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 932476956d7e..f2ee1da5283c 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -6453,8 +6453,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>>   
>>   	devl_lock(devlink);
>>   
>> -	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
>> -	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>> +	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
>> +		NL_SET_ERR_MSG_MOD(cb->extack, "No region name provided");
>> +		err = -EINVAL;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
> 
> Please use GENL_REQ_ATTR_CHECK() instead of adding strings.
> 

Wasn't aware of this, nice!

>> +		NL_SET_ERR_MSG_MOD(cb->extack, "No snapshot id provided");
>>   		err = -EINVAL;
>>   		goto out_unlock;
>>   	}
>> @@ -6477,6 +6483,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>>   		region = devlink_region_get_by_name(devlink, region_name);
>>   
>>   	if (!region) {
>> +		NL_SET_ERR_MSG_MOD(cb->extack,
>> +				   "The requested region does not exist");
> 
> NL_SET_ERR_MSG_ATTR()

Yep, should have noticed that myself. Thanks.

> 
>>   		err = -EINVAL;
>>   		goto out_unlock;
>>   	}
>> @@ -6484,6 +6492,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>>   	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>>   	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
>>   	if (!snapshot) {
>> +		NL_SET_ERR_MSG_MOD(cb->extack,
>> +				   "The requested snapshot id does not exist");
> 
> ditto
> 
>>   		err = -EINVAL;
>>   		goto out_unlock;
>>   	}
> 
