Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93467D5CC
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjAZT7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAZT7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:59:45 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963B0410A3;
        Thu, 26 Jan 2023 11:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674763184; x=1706299184;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ocG4UFZ2ksXiWrxqNI3LecrZnX5ChzRKBY00sQtirfg=;
  b=C4ote4pzXiMDpngouqpF0XSxagdr22iMVd50zvug1H02xfnWAxwXwCEJ
   LcrUxpgw42ThvNOoKE4hY76mPFQhHmjB4mm/3T/ScU/pueI7ow/a87Ntt
   GcG3gqnsxXg4tQI1CKUj4YmiswRzmjZugii5sEPHwEp8xt/t3Rx3r4LGm
   N20BM3x0EvyhmwE6T8xUzznKyoHcpSGfYr6pRqCRrtHgcOh1NTKi40Sd5
   p1E7okT6kbQOaWgtjqhpAw1GtjY05PLSFjAkg2slCCklWQcQtI7bJRMkf
   SSpjwnvt8IiQSMIELggnVzqioy4/TP+BLB0Y2bVCf5LKD2E8UpeCeBD/Y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="306580376"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="306580376"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 11:59:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="786968970"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="786968970"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 26 Jan 2023 11:59:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 11:59:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 26 Jan 2023 11:59:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 26 Jan 2023 11:59:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eueDvB6hb1PRiyz5QhrMxpAzbvG8DRgzuG7XihMr/nD+qxQLcHHnzjwQx/Bbd78X4bmGFKxxWaQgJ09L9+ESW8ZkpIXp9abNxByl+/HL8MbjEGmhTUExbIY07hVoHAUsNjyijj6S6MqZnJeOCEJo8bHL5sFr987cg4aoYcT62vfJ7PwNN5GA6GuFt1iHnDU4Pkas440PJTS3IEo1YdWIFiFLet94M9O1SzoW0PrwmowGFO2hZEdlWFrBD77C1jpLOMQz56NRclNCiwisWqj+dqpvXdI32glkctMf81XLjtKs864F5tplOCD9NFwSP3Rhnc4SZftKtwIQ4Z8Ropa3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2NRk3zk319ICiEUhN5STYZrTK5ZxTH4g1mF3S60IHCc=;
 b=YBOoE1yNWOYuxMC/q8WbNWHZlrN+vuk2nf5vownzYaSHv1l0bNflKf3Sz5qxweAZ52d+TMv4Bh5vafnV08JHIR+emOIxNfHLgMEGMkSx5Dd3fylwanRiG5Wk35F+M33DMd03L8q+9bXN9mZ65oxu0xxhKaLukmzbx61ynRSBWjkxiFYXTWg1K8nd//YbBbuqkN8tTenM+Zh7tP8pH0XXyw16+MACc7Vj1X+PJ2A1vOLNYSRmG/6yfvSAmA5938SoW6+W+7ZQ0xOip+sPAmp6Ls/abwfqb/d/aNNONDUOA5HLv5zeYG0U1NF50jezO6OzCTqjoBT8QqTQiYq/XOV8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 19:59:39 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%5]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 19:59:39 +0000
Message-ID: <287458c5-3e56-8a0b-f993-92e2b6ba9adb@intel.com>
Date:   Thu, 26 Jan 2023 11:59:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.10 1/1] i40e: Add checking for null for
 nlmsg_find_attr()
Content-Language: en-US
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Natalia Petrova <n.petrova@fintech.ru>, <stable@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
References: <20230126135555.11407-1-n.petrova@fintech.ru>
 <20230126135555.11407-2-n.petrova@fintech.ru>
 <a23c80c4-933c-9be0-6d36-4d4238b13f23@intel.com>
In-Reply-To: <a23c80c4-933c-9be0-6d36-4d4238b13f23@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:303:b7::31) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|MW4PR11MB7125:EE_
X-MS-Office365-Filtering-Correlation-Id: 504a9f8f-cc64-4b78-93d5-08daffd7db8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AUpQfHr9upVBKJjl4FeAIwEpGlZ1aZvy3azTQR1xWEkGJuKWBHfRFcfdkj7vqKombTgl7XhniGSVi5t864W7lHQC9eYftUu1v66kb4DkZ8w48GgULkmCoGGJTcO8UXg/2Z8yVFxUjTev23VYny5GIflGGs/8Az55cFP+zNEhHluePRtpmsYvM461gTB3gAweOxo/yH5O4tpRBlPl2VBlQji3JxTjUxb+ft5zip8eTiv4LqRhstxVBzIT7sn1CoLiy+BsJttv21aYPJJ8cdPisykeA7QVxsAxYklMC62b7aaZDWtRNPNPHmk21DjDKu+kCyxP5RiaIR/ogYENu1Ekh2N9hK1/8AJFoFjruP0RnwVXmPopnBlwaCf6e3+jprtC1UtyCD/lKyBY5/XswYSA3PAqE+ymEOTPMzFMXt2b0F1lbNAaGy+UR55z8bhN7/NmZFh+D3taIq7AtrjQmhjtc+ydVM3kloSElHcfVmVY6taLW8in2vxw+FotC8xacjJUuNTh8tkMPNEETyLX9vwqdl6vkdmTvyPeoJAYHRuTiyC9Or5TvDct6p0p70B82HqtURUYLnjaI/+kZeshWjiPjk+rkXFhx2CdGLtr7EBsWe4CFDOJUHahKih6UFD1COL6Mgm4VsfwraKfHeznlRD7f8kMdpE7j549vnPF0fmxmdB/861O93d/VzsFPEOihRzSvbMAw4FWupyfZXs9+9/9dJxzRCQHfSiPrsxo3r4UHvKq0Y0lSDRdJqh0oAUw4ILcUfl5cLolOzj4N83mYSSrKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199018)(41300700001)(66476007)(8936002)(36756003)(7416002)(5660300002)(44832011)(66556008)(2906002)(31686004)(66946007)(110136005)(8676002)(4326008)(54906003)(6486002)(478600001)(82960400001)(38100700002)(31696002)(86362001)(6506007)(83380400001)(316002)(2616005)(53546011)(186003)(6512007)(26005)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXpBRS8zV1Zod3VRemZ0QVRuQzI0NDZCb2tIK2xiY1pxbWJ0YkFvRHYzdlhZ?=
 =?utf-8?B?K09GclIwNkQzcjFtMUZrN3g0a29Ld29MUysvclVTWjFYdUI0U0xyODExSXF5?=
 =?utf-8?B?NGwraHlIVWFUNFl2RGM3M2xkUkFpNVNJRTA5OU9vcG5tVEVJQjJ2Nldna1Na?=
 =?utf-8?B?U3BXT2lzNmx1d3ByZGFHenRuZzFwL3EvSW8rdVB6MEJXMkZ2NmEvd2hvS3kw?=
 =?utf-8?B?SUpWR0Raa2wzOG9uRVVnTUlEMFJMTUtjUk5lY1llUzZyRElvbFcyQjBPeDRt?=
 =?utf-8?B?Z3hIZmJqTEJLNWhvSERFdUFUWjZmUWFrbGhJdEk5K29heGEwQldkeC92UTVN?=
 =?utf-8?B?dVQ0VnI0alhOZVhhbkZvcTR5WHRYMnF3MkgyQkxMUWdwNnp5U29oTXVrVGZT?=
 =?utf-8?B?SHVxYVZzbTZsSlFFMEsxcm9IbzcyRC9rdEpRN0lwb0xycnJrMnVldTQ5UGFV?=
 =?utf-8?B?NlY1RE9YbnQ2ZWx4U1FCM0VRY0hlUjNPU0FYK1VUckdXTXZIZnlDMDF3a3Bh?=
 =?utf-8?B?T1A1bFgybG5LUFlrdjhWWm82Rmt3cm5GcG1KcTNmaENzWEp2ZlQxSjJDbFlw?=
 =?utf-8?B?Tm9CaDF3MW9xYWlIZWdtY2l0VHRJNG1ONUUxSkFxa1lOOER0NmFTUzZ4aHh3?=
 =?utf-8?B?NkVlMmRjZHMra2hxTUF1cVdxSGNxS2FwWDd1MDEyVytqRlhqQkNJdEViTFZv?=
 =?utf-8?B?cnMwZzQzK3pEMDdXeStOTml0Mzl0RUlyNDBYMmt0WnAwbVhJZ1oySlRWdGpO?=
 =?utf-8?B?aVpwVHJxOGt0dlcrWHovSGU0eUs3dld5RVpBaWdKbVdKSnBycnVSWTEyMTdP?=
 =?utf-8?B?akl6MDJwNnBNMGJ1djYxdk9xb3dHU0R2THFWRXB1SWFDaFhCSHZOQVB4eEZh?=
 =?utf-8?B?L3BkYVBHM2JjWW4zcGJMTnRMRlF2RGpQT1FVL1ZWNys2S0s3MVdRUjROamhr?=
 =?utf-8?B?Mk9IcmliQVB6UEFKWXp0U1dnTlVvSGxXb3VaUlFtckhrdmhlS0FReTFRMFNN?=
 =?utf-8?B?QXovZFRzMEhRa01CNDhtbWZxSFpEeXQxbi9oZWd6bTRSYXNWNEVYSkpZNThs?=
 =?utf-8?B?YUREVzJ5Nm10MnlZVGpCb0xGNnpIQndEVmFBakJsTUVFdWlQM2RDZnc4eUVi?=
 =?utf-8?B?aG82ZVozdUxLZHU3ZFhNR2lVdnBuQXJGTU9vdUh4UFZkaHRlS2VselpoeGdt?=
 =?utf-8?B?TnVOQVFQdzFHQzFZdFlqN3FzcUY5RkN3MGgvVXR4SGNBZUw2ekVwMHdwSTVO?=
 =?utf-8?B?VWs4WlowZm5uUDF6NGg4OVJLaDhHVFJkQ2tTR0FRWmoxSnAzbjVxcThOVlBk?=
 =?utf-8?B?UmlVSnBqc1pEY01kNkpzTnIrb29YL0lQR1p1cis4Q1c0ajNpZ21nTStDK0tv?=
 =?utf-8?B?dS8yTEUyOHVZVEZJMDZGK0tncFZOMkltRlc0RDQ3dk9TZVVnQWtFQWR6TFJh?=
 =?utf-8?B?SElQeGszOWl4SXdzTkluYnZSbng5M0szRVZtbGxKV2dUS3k4Z0d3TzBlT3Q4?=
 =?utf-8?B?eWhDTTU0eVZjSDh2NWxxNTV0YTRRU0QwWTBrNHd4VkdQQ2lWcTNLYWdWenpM?=
 =?utf-8?B?MEN3VnNVVkRKOUhWZFpTZ1g3cVFVRE0xOXFtZzNsWW0yMWtNTEQySGJIT1gr?=
 =?utf-8?B?YXVvc254MzdoY2htazI3RnM4Y0xFdVBzelNydkJWVGFlaHE5MkhqajFodjk2?=
 =?utf-8?B?MGoxMkNQRVZJZlloRWxiTzd4V0d6bTl2L0dPeUhKMHIzQU1tdmxTS2UvdFNL?=
 =?utf-8?B?SFFhRk5xeGtjSHZPd0VaY3BlS3p5S0xDemdadS9OQUpyS25lcmRCWnJUd0Y3?=
 =?utf-8?B?WW5OYXUwdTdteFFGWXM2YTJ3bTNGZnRRT2RLbE5iS09uWFhoV1psSDRRM2Jn?=
 =?utf-8?B?NnBKTUU0YS92bjNjS0RZTXlETHpJelRteGs2cko2ekVCcGJQVFhJcW1TYzhJ?=
 =?utf-8?B?L1A5QTZVMUdKMFhRcU45REdYUWlFaWZpNDdtRWFUR3ZKUkhFN3VkUUE4U1Z5?=
 =?utf-8?B?M0pGaTZtaUcyYk4zN0VsTHJVa3F6NzdlVHFodGFPZnZROWJoV0d1RS80TXFM?=
 =?utf-8?B?bzkrdUpvYmdxcXdPVWI2bytpYTVGMTFIYWljUzA0cHhGOEFCT0dyZzh5czBY?=
 =?utf-8?B?eEd5S1FoMjJhVWk0c1RXZHorNE5xTDFadHBHbmdDTUo0eklSYkxZcVVWL3RY?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 504a9f8f-cc64-4b78-93d5-08daffd7db8c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 19:59:39.3914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjl05x60V6VkNqxPYA8znfHTHI76LunafK8iDcAxChJ30bQOIhO9YkAcb+EFi3/22BMmaP31NnpACtqTmpxgyU+gnkuSFb+PPKKRdPigoYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7125
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/2023 11:55 AM, Jesse Brandeburg wrote:
> On 1/26/2023 5:55 AM, Natalia Petrova wrote:
>> The result of nlmsg_find_attr() 'br_spec' is dereferenced in
>> nla_for_each_nested(), but it can take null value in nla_find() function,
>> which will result in an error.
>>
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> Fixes: 51616018dd1b ("i40e: Add support for getlink, setlink ndo ops")
>> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
>> ---
>>   drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c 
>> b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> index 53d0083e35da..4626d2a1af91 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> @@ -13167,6 +13167,8 @@ static int i40e_ndo_bridge_setlink(struct 
>> net_device *dev,
>>       }
>>       br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), 
>> IFLA_AF_SPEC);
>> +    if (!br_spec)
>> +        return -EINVAL;
>>       nla_for_each_nested(attr, br_spec, rem) {
>>           __u16 mode;
> 
> Makes sense to me. Thanks.
> 
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 

I presume that you meant this to be targeted to the "net" tree, which 
you should indicate with the subject line:
[PATCH net ...]

as per the netdev rules published [1], and generally you don't need a 
cover letter for a single patch.

[1] https://www.kernel.org/doc/html/v5.10/networking/netdev-FAQ.html

