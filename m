Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD206DA063
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 20:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDFSz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 14:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjDFSz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 14:55:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EEB8688
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 11:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680807355; x=1712343355;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DLCCRZ/rYKZByV0yDd2bBuBmVHn5u/DN0Kw8jFnh2GY=;
  b=MKrDsSFoCB9+6MMAOi9b9y3kq7/AQL/t658s6U9SDubXQl68KNr7Xl9n
   rzIZ13pQu7idbBQq2j6HQIfyfWM/MZNJOeoMEVIX0iTz6TyJr4kG+6hk/
   26fUv9DzF6WHL2JwXYhtBeVFPjhCCXfFaPTFGM10lUXMIsQY9f+AFjU3M
   fTXGkBfbvryuwT+f/GPf7n8Zkj419gcf/7higr9BUjJ3IUdB4UamQsVDt
   /HHxEMWLa7ikG4XYsYjV8RXvlOPXPjIaxOw0VZVpUgg+x/Mw6opFDrUTk
   sZ+jkBsnQ5ASM4jEMiIaSOC6bZ2ISKGog6ZbdA9zrRWhDAojsj+3Xs7XS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="323191715"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="323191715"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 11:55:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="798437100"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="798437100"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 06 Apr 2023 11:55:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 11:55:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 11:55:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 11:55:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aay0OhYc3AYb6U1HfFH+ryX/uVnIKwD1e642ralWBOYWwSkER5lErDbdBFoZURahEQAMQTduHRGqPWOaMvcA1bnsdFOIe6QYfGdiwCzN5CliBE836CKmZAe2iohtCfoHiFp1go7E1Si4xbjbrsgacUFudfrYttZjQ8YFWVOFELXenR3C3tigYr0icon2aZtz+0BZh+z41H00ml/gLB0xxZb3xxFS7BeRjX7hm3lH+Ik0EXvWzVNalrCVPeFZEgZM8lX/oqmn5FHexRdboVkvXEER3/3gI3EZ5KtAOOUHArP1pZHSVtuwkAaKH/Dop7hG+tADBvbtv4P/ElUP38+oAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8/vItlfwwwXvuXipG9Kz44SQcqt45MQHw0mEO8h3aw=;
 b=kKYhsGKak7yHXQb4c7s8mxqtLTEXAfGUGrip3sY86Z6JZsjF1CgQFhs/bhUq3uAxJzY3rdKldIeKf9S6vaPJlbJXZl/MC3ajUnXa9whaEmkQ5kC91rZjI6aiqNRjUffJQStlyygtaaV8sJDRw7CAXIuJ64BcKP4UA0u5TTGPinJuZuWOOmAq15XH0AQroS9hCFCfVEDBv7zW+AxWP7eLofVuWKxhtgjLMem1QpSmgXy1V1F3ljISd9Fk3tGNzJ2y8fJ2aT+g8O3haiaZcM4cE2XbqpKwcM0IflAp09lH/iJLLW/TcxH/fCWo3gNBa+Xv0VQ0xAVz7gd19AqxtMN/sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7420.namprd11.prod.outlook.com (2603:10b6:806:328::20)
 by DS0PR11MB7559.namprd11.prod.outlook.com (2603:10b6:8:146::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.28; Thu, 6 Apr
 2023 18:55:53 +0000
Received: from SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::a3e9:b91e:a70b:100b]) by SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::a3e9:b91e:a70b:100b%6]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 18:55:52 +0000
Message-ID: <e6e256a9-009b-593a-9f06-6f4adb4df688@intel.com>
Date:   Thu, 6 Apr 2023 12:55:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net 1/2] iavf: refactor VLAN filter states
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>,
        "Rafal Romanowski" <rafal.romanowski@intel.com>
References: <20230404172523.451026-1-anthony.l.nguyen@intel.com>
 <20230404172523.451026-2-anthony.l.nguyen@intel.com>
 <20230405171542.3bba2cc8@kernel.org>
 <99053387-16ff-9ed0-ef12-7bcbc7a7af2e@intel.com>
 <20230405175908.2d3b504f@kernel.org>
Content-Language: en-US
From:   Ahmed Zaki <ahmed.zaki@intel.com>
In-Reply-To: <20230405175908.2d3b504f@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0195.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::6) To SN7PR11MB7420.namprd11.prod.outlook.com
 (2603:10b6:806:328::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7420:EE_|DS0PR11MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 634b9d52-3c9e-4925-28c7-08db36d08b92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4X75k+7scYcoTGV1vOuvMCXBQOIcDZnFkLjeISt2MfSHlysnxLFFSJ/y6yw3DPESZgmqBY5lGYseG3rzHF8MSXr5s0g6hqNlgtF6CTMfXAWU9nKvETWSEHszPFWbEMFXmFTQe1BGdAt89L3hnK4+k+xH7vPk0BqY/XdCFJ2vY9y26EMaqs+XXHgkrc/i1cMfh0IY7jGpLBOdkXZQzDTWOXiYJxcT7e+CI7dGQj2ZmvyU45G5Aia1IONv27JNNHocK9DSyXweGAhrpw5TBlTF74FkGB4gfKDkKwIBvFFvER1L6iIk1aeTAJdk7G1r4eayqNxhYOg9KEBuxgO4JzfT05+qnFGfuYRwJ+VNP28E7qVCVRXQyIrgDBKyGI2hBGJoIM1yFePsnewEeviTGu6+iez65XHViezIKBcdL6+Lw+1Di+NEvN4BAvAmlaP4Ydz/VMOzRYLhzVFl22TmamrK4hPuGrBbF9pvmHwozglXcNlAYNxGdqgf+jEaTSzZd6CjpTkcQqM7j6IlAOEo16IpohfBgCivXiv8MsnyUeXsz/LcG8yj0DIa+R71WTzSaHtfaCPMrZwTHg/2E4A6kYb1gsZSXwCTZagCJGQ/q6sQbtS4qgUJmw+nYcSTQ0VIETxOvSijR4ntMfgZFpUENq0T+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199021)(86362001)(31696002)(36756003)(2906002)(31686004)(41300700001)(2616005)(6486002)(186003)(53546011)(6666004)(107886003)(6506007)(6512007)(66476007)(66556008)(5660300002)(66946007)(4326008)(8676002)(26005)(54906003)(316002)(82960400001)(38100700002)(478600001)(44832011)(8936002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THNLVUFNM1RMVDg3bUxVdFlMNGtZNVJlOUpWN2d6Z2huaFpkbGtBK3pRbldC?=
 =?utf-8?B?MlRaeE5qaWZFcFJwQVMxVTl2cit2azVraUU0aWt4SXhWd1ZXcTlNamc5TlQz?=
 =?utf-8?B?QXpHWEpOSEJSSFd1enpHUmlTdXA1dFpVcC9ZQ1l5cks5ei94RitPbEkvVmh6?=
 =?utf-8?B?SGlnMzV0S25WQ1Rkc1BTVkZ1dm1YaCtTU0F1b0dhOVZTYy9UVk5OOVhJalFC?=
 =?utf-8?B?dzhBZExrMVIvd0h0cFJNUUgvUHFleVcwNEtFeVN2OXh1YWl5VDlZeU9VNE9j?=
 =?utf-8?B?SEhCdjhUdmlXNlBMaURzejhrcFFKZFpyOFRaM1VVUlMyZ21oZjdSbFZuN2JY?=
 =?utf-8?B?S2gvKytwZmxBcFdLVFFLZWVKRFpQcmFXeGJvL3JqSTBuRVlsL1Jvb1FsRStX?=
 =?utf-8?B?aTRKMG4wS0dIeG10ZjNlVU5KbDZ6eDY0MDhVdkJBMVllZUZkZmIrakRIMGZS?=
 =?utf-8?B?OW1kd2dJb3FBMlZSOE1MNEVtd01iNndNY3lySEEvTTdGakNWRklobk1Ka1Ry?=
 =?utf-8?B?WUtsNjZpY1VjUlh4TVV6Q1ZRVW94Q3Erc2FlNnhtYzZNbmdsZWZyQmJjTHBS?=
 =?utf-8?B?Uld0K1Y3RGFtSWZ5czZVTHJ0MFVxUzlJQkE4djEraWFWWlRjNjNlSlByNFVG?=
 =?utf-8?B?UHdhUFpsd3FlcVY5NHRpWkx1ekFVVG1PNy9jSExxbldWbk8wMFJTS21GTUtL?=
 =?utf-8?B?UHJZVGdzUWhnRjcrUEJhNWplVCtxekZFMFlrcmVqdU53VGJWUDZ3bk1wK3Ra?=
 =?utf-8?B?aDlDVFlvOVQvMnI3aDRUUEc5K014ZjFDaEh5OFI5YjRXQ1hpQTk3QUtpNVdO?=
 =?utf-8?B?Q25KRTJ5M2VhVjlaY3ViTUNLVmY3WkhWOU5kRk1lNytSZkxpeEcyWHpXZVkw?=
 =?utf-8?B?TTFPOEV1d1NHQUZXcklKazV0cU5JK1ROTzFPMVJKY0NMeWFyRUw0UWVqZHIx?=
 =?utf-8?B?NCtwZ3lsbkJEWUdDY2NyRFdYSTVLMEhxcXZrUU92M2pTNDRRYk44UzgvR0Rv?=
 =?utf-8?B?Ujg1ZTkvall3VG8rNGFFaXNINnVwL0dPYjIwZVVoWU44aUhPTHV2ZElucWdF?=
 =?utf-8?B?L296OUV6clcreGp2ejNWVmJQaDlPWGFPYnFCd3NUNFdaTzNMZTMzLzlxNDlT?=
 =?utf-8?B?SUhWRlA4ZWJXUXV5dG9mU1lXT2UrRVpuUzV4ZmwrS2pDb2RKRDJING12NWd5?=
 =?utf-8?B?b1JGc2xVOUowOWlraTFTRm1aTHh5aE1Sa0gzU2JCb3lsS1B6dldLam9JZ24y?=
 =?utf-8?B?RVJ5UkxsQzFEejFYSU5zN000VCtDdFNTQ3ZjREN0ZDljLzZUZm9FMjRiSHdR?=
 =?utf-8?B?a0dGMllCL3dCcGdleDlIQ3JoaERxV21uTVVFa3B0UWVwcWtVa05XVjU1VjZO?=
 =?utf-8?B?MW9wa2ZwREZGWjg1QTlGWVR5VU9XdHZhL01tZnJuc3V4bk5KSmNwSG1hdlBm?=
 =?utf-8?B?UXJRUkJCVXBrTHZ1b1NLTmFhcEVXNkpZd0loUnh0Vmc2K1liTnFraitmM1hY?=
 =?utf-8?B?WTJ6cWVwSHorSnZJZkNmUUFqRjk3dXB1MkR4bUVLQWtaR0E1N1lxZkZxV1Zy?=
 =?utf-8?B?b0UxUUo5OGlZaXRhUVRhUy9ZRWdiU2tvekxnWElMU0Z6Uld1U0NKK0JRN3BW?=
 =?utf-8?B?N0QyRWxrcGJQQVc3aFlQMHpuV3VBUjNLNVN5ZVpZNUpxZm1oUmFXZE5NYXNw?=
 =?utf-8?B?NkcvQ3pyQmQ3amtRdVVnR2NjdW1MeTJxa1VCK3lBUGkwdHg2SmxIZDMvSDVo?=
 =?utf-8?B?ZFRYVjJsRjNUSnlOY1B5Y1p5cXZWTGs4MTBzY2t1NkkwaDNxMnhTRUVFcjM1?=
 =?utf-8?B?eWh1YVM0N1pkZlJTY0k3cmNqb0RKMEwyZkdJdXovazZsZzZ4V2VsaEYwL2hT?=
 =?utf-8?B?RG5FL0EvSGNOMlgrMEJRUUg5VU4xWWpjS2JiY21JSG00RUwvNlNkVFZod2RO?=
 =?utf-8?B?WlMxWFpZaDNNNU9uTTlOMG96WlNzVVB0c0VqUFJyb0UxYlc1bnpIY2toSndh?=
 =?utf-8?B?ZlFsZWRQa1o3UHR3aTN5LzFQNlp5R05JaDZsemZJSDdiZkIydWZ3Q0p5MXlv?=
 =?utf-8?B?S3RjMTdLVTRiVnRBU2VRc0RMaHJ4aEMyRHpkdisrR3hOeS9BUzhaelJqdXdO?=
 =?utf-8?Q?SkiExMJPDq1qcf00ydqPG91aE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 634b9d52-3c9e-4925-28c7-08db36d08b92
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 18:55:52.8267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MO4kRjpGyTNXyz0xrFhMBFCydiDPjkKHnMfZTuosyMHSVdsAdY1PazQcofk3OxOHs+GRS858cWbc0kKm6eFuRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7559
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2023-04-05 18:59, Jakub Kicinski wrote:

> On Wed, 5 Apr 2023 18:50:55 -0600 Ahmed Zaki wrote:
>> On 2023-04-05 18:15, Jakub Kicinski wrote:
>>> On Tue,  4 Apr 2023 10:25:21 -0700 Tony Nguyen wrote:
>>>> +	__IAVF_VLAN_INVALID,
>>>> +	__IAVF_VLAN_ADD,	/* filter needs to be added */
>>>> +	__IAVF_VLAN_IS_NEW,	/* filter is new, wait for PF answer */
>>>> +	__IAVF_VLAN_ACTIVE,	/* filter is accepted by PF */
>>>> +	__IAVF_VLAN_REMOVE,	/* filter needs to be removed */
>>> Why the leading underscores?
>> Just following the convention. iavf_tc_state_t and
>> iavf_cloud_filter_state_t have these underscores. Same for iavf_state_t.
> What is the convention, tho?  Differently put what is the thing
> that would be defined with the same names but without the underscores?

Nothing.

>
> My intuition is that we prefix bit numbers with __,
> then the mask (1 << __BIT_NO) does not have a prefix.
>
> But these are not used as bits anywhere, in fact you're going away
> from bits...

Ok, how about sending v2 without these underscores, then send another 
patch to net-next fixing the rest of states?

