Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D76587467
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiHAX3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiHAX3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:29:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCE474C2
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 16:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659396588; x=1690932588;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=IRoIvzlmmGuOoLJTlljL06L8P6meWS8fab1J0hn5TzI=;
  b=l23sH4rCk7wwkZk/tGvY/JOV//PkkZ+bzalOkVZ7CDS1bewIpPvgH23h
   JC8pjtwGEgXDxjxIp/TNg3tsxfXu5ESkIz/n4DkEeUUbpmd5+UwDfzMEN
   SdxpQp3ZxOpg+RbLQvs001foeI4gKvPmqDE8f2/SbE8l+Ap5qVyOo7E+0
   wyaUJ1wtJRSyBTVeMIjSDtfmfDMr8jly/CmFsmNDLdBpl1ZgEt+FjV9Js
   bpVzGUjeor3+AUwHzVTCcNKgtk5toEPDF8UXdq7jvXhCl9u81UxxAUcPM
   HQC81dI/SgcweX9UkKZxGOAGNOIP39sQ+pMHdMFh/Q97uAN+BaWsSfdJm
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="276181700"
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="276181700"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 16:29:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="670228652"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga004.fm.intel.com with ESMTP; 01 Aug 2022 16:29:47 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 16:29:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 1 Aug 2022 16:29:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 1 Aug 2022 16:29:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OU47QCe3dODUhBu18YlU1q5i0W4uOXe+tJgd4YKxj0eOp71DwICOCsixRWMYQLtJ0SxL6axRmvETWbWx6y0kJyXklXA2LUMN93U2T51b92G79TPiAse+HZGQYxRO+qAhc9snweSh5gbx13FoEWIyXMPA7Gi8yAsm46M2RR9eWkL5oUbE8KiKxVuUQ5m31ybAIv3QtLnU1CyVTXCN9fme4z2JhWVC/RnVLCbPZNBPmmTC4x2wmB4VxQ27de18Op29Jq1D6NWKJSetnv3PUS/yPeBQkyRauIZVmgBPgDYmIvT2cpRDNePn4IFIGubRyawd6tVRbV2ZJEYYakd43rzfHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmxApRbdW6WemSbh5NAHwH6l/Vx+sfed8u+4maEhwyE=;
 b=OLM9woWCcCbXBwEP0GLfhDeMpFWDcQEh1UKI2/76nJvUrhHTgAKgqiIMTRwYxIkhwSlXi911NwGL7de00Ti7X+IYvE8afAN8RrOtMvL8aL/QafnqVf9D0nU9k262IvNhvhl66OaLB30PeoJXkVyV/jLCXq3NNPPBY5OpcooiReymK5YkewH5xf7kxQptJHctyWgTPTMHyLeHPp0Isjs5969u+uNB9sDYPqeZIJSLfbxG2RH1UpHhHIWLaEWGNOx1LyBIjChGJHsoZaDOJd4wTjOeg4K0UN3PTKglqmDmx4yIC5xyNlui/pNYJiBFl1COt9hC0R59IR5/9lSRYROtyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BYAPR11MB3686.namprd11.prod.outlook.com (2603:10b6:a03:fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 23:29:45 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:29:45 +0000
Message-ID: <bd24eeb0-318c-71a4-527f-02832b74250c@intel.com>
Date:   Mon, 1 Aug 2022 16:29:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: Fwd: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
Content-Language: en-US
To:     Ilya Evenbach <ievenbach@aurora.tech>,
        Alison Chaiken <achaiken@aurora.tech>,
        Steve Payne <spayne@aurora.tech>, <jesse.brandeburg@intel.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>
References: <20220801133750.7312-1-achaiken@aurora.tech>
 <CO1PR11MB508966EB7A3CF01A58553536D69A9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAFzL-7tX845o2kJmE4o8EhbeD-=vkR6rmaiz_ZEWfSD4W+iWEA@mail.gmail.com>
 <CAJmffrqxwFyRGpMRYRYLPi3yrLQgzqnW5UKgbgACGNqoN_hsVQ@mail.gmail.com>
 <CAJmffrr=J_s9cFw5Q58rvZRWLpsrDnx3RkRXS3oLZDYY3BrNcw@mail.gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <CAJmffrr=J_s9cFw5Q58rvZRWLpsrDnx3RkRXS3oLZDYY3BrNcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0027.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::40) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afa168bf-9956-427d-653d-08da7415b78e
X-MS-TrafficTypeDiagnostic: BYAPR11MB3686:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dEgpXLzYSjWpOA2t46c5AGHtFlM1O4hwR9aE7kSj7kx1xSEOEsHmOdPXDoa9pnEP2p6+M4L1pTBDT0R4gOarrIc/yxbkhdSJVxi1aZWMjU3Npzas+sfLqLg6H476FLrR0f7lpEatYRl1C1Nw0BBIZDGpxDGoDd8IL4CAj1SDMYD26of0sI5JnMnghrVSMzjznCpGQr0AQbaDVFtavQso7/JhA33ZqsaOtwR7CncyV7cFIwHsJukXyzsx45UnXbSTI1cXC2M3fDYurJVJuI6JzyJdD12r4N+c2YEGWa+CfjmCjCUBEVnyG7F2PdtyLOSgDk6VN24EIy4CxTy6fOcrR2aJkjB+UQD8BmgnJicSi/wHQ8Vfj/hcNawK9Dei88z+rLe5MeLLZZTepW8a6G+Zz8cbKSLAkxgU+sGG5s0WhBkiqAZsEhYA7eN91I0H3WVUo/B9lKAkBlBG4jN882T6fgPyRw+ZUvJPbxl4id9b5YU3NAxs69l5Y6CPImsuKBXKt5l4LUdP96l8yxVR2Uh7Hyv3808QP2HzP4iHegYgMxUnh4c0i+0wUGJWVgU48Uq86PZCLrncG+KKY5VrxkVQ7wsI60x2mODX0Cwfh0Ejas6WZ4QV9HTxF6LoYclv7b/bLsYWTFQDCSTJwidqJMbCuzDxUbnmn1x/epeALt9Nm96GBVVYfW/PVof0G8QCyfDWopndo4Yc70hCGurCzIrDT/WTtpCR1uG8sXrvR/jsJRGdkg3p0nE5OCqjSjoBWkMb8nL1Bsa9NBP/Bo5q+uVOmfhHUxu56uJ174jDggBUAAX9EqOu53prY6eLZ7DFDAnmqGBPImiO0JzzmwV7SeIm/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(376002)(136003)(396003)(346002)(66476007)(31686004)(66946007)(66556008)(5660300002)(36756003)(41300700001)(478600001)(316002)(110136005)(8676002)(8936002)(6486002)(6666004)(2906002)(26005)(6512007)(2616005)(186003)(6506007)(53546011)(82960400001)(83380400001)(31696002)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckZ0MmpDRlFJQWt1U0hBeE1Pd0RnQVplakR6RHNDenZkVVpScWVRTnhvS2Fu?=
 =?utf-8?B?VVlHMTdCaVNJL3M4dmVOUFJOa01wV0l0VEsvcGQ3dEhxa21CdStMRnV0QVg5?=
 =?utf-8?B?NWxmcElwNmhseHp2M1loRmZwWGhIZlYzYXh0c0dqaHJEeDlLcWRQdm5oaTlS?=
 =?utf-8?B?MGwvZ3g3Z2kvZVl0QjRzOGVHbEJ1dm9rd0o2aURoRU01dlFpT0d4MXZPRnR2?=
 =?utf-8?B?Tk9OaFhxMDd3eEdpaUtYSUd2WFRGQ2RHTHJaU1VOV2NxVE9EZUpKaW9KQ0pp?=
 =?utf-8?B?aTJaQjRpaXRwWEV2KzJFZEE5R0M2L3pHZ1YrV2tlQnpyQUsyMS92c2ZzVVFE?=
 =?utf-8?B?a0E2Q21kVFljSUNhMVlJd2V0VnZjcHBQK2dKaGh6TzduVWF2RkVMWXY3alIx?=
 =?utf-8?B?QXVpcm1wY3RnVC9EaTZMRVdUMERKUXhlYmJBTWUrdTNWYVRrckk5UitqSkFv?=
 =?utf-8?B?TlpwNlIwNXNCcm0vSTY3SGh1dkh1QjhiNFJ4b2VMcVdkSFJoV2tYQzF0cXZa?=
 =?utf-8?B?bGo2a2JJNmN2ajVmVlRDTGlaUFpnTGw0SzQ2aHVoUEhZeStCQ3MxMkVrUHo4?=
 =?utf-8?B?ZFc4UXd1cDhsZmk3OGN1RExaTEhFZTdxMlhpYkhvYlpOZER0S3FEbE1VQVhy?=
 =?utf-8?B?R2JjaVJtODFqQWdGVkpaeGdmRmdQTWhvQi9pT0RoZ052ZmVna3J5MkxPU0VW?=
 =?utf-8?B?V3JQaTZqa0xlK2JaVXR6eFNhd3EzendLV0cyaTJvZFRCZ2VHWm05MnZaTFRI?=
 =?utf-8?B?eDFMaCtwTzJZeUJ1UWhsTUVNWmRuUCtLRHMxaGpTYnJaOVNtM1h1aXR0Z2o0?=
 =?utf-8?B?eHlSSTRUSitseURubm5MSlRIN2NhT2ZuZ1dreGZPYWxseFFTMDl3dWE3QUxV?=
 =?utf-8?B?ZzJJYXowc3E1eGhubThwNTFzZHUzQ0tyU0ppR3JINFFvYUZubUFxUFA4OStL?=
 =?utf-8?B?K283cHJMNURqNk5OTmNPTUpxNmcrSTR6K1ROOCtrdlRJMHdNVW5yVktrVDlh?=
 =?utf-8?B?ZnBPeDFhQXFkR2gyWWF3YkpXaHE4OVBRbU8vd3phTGxlRCtaVXdIUTFRZVJ3?=
 =?utf-8?B?azlGNzA5Y1VKbS9YNWQvbE9IN3ZFbUF4VmRxQStncGpGaE1abU1rYmhQbUNC?=
 =?utf-8?B?Mk9BeHgxL0toUngvVFRnWFJzcFVKeTNkT3VRNTZ5Q0RZb1F2bXk1NmJ5bzVl?=
 =?utf-8?B?SXFJZ1YwWVYxZ25RblEvbDlqN1h4bjl0ZTFKNExQVmxVSnBMNzhWWnpuS3FS?=
 =?utf-8?B?ekpDS0hEblo1dHV2OVVFZVp1M2dRT25NZlBJT0tyMHQ3d0xSS0l0ekFYWUJJ?=
 =?utf-8?B?U2dqZCt3bk9Zd1NJU24wSUYxbHgybXhYWEtxR0xFTTJyNCtwcFB4MVZ4OVVE?=
 =?utf-8?B?TCtCQUNUWWc4M2VmQ0FWRzZvcGViRHBFUlBvejN0UXdjVStHMkNVdVloVHNV?=
 =?utf-8?B?QU1XQmxNeUlYbkNLK0U2TmZKMG4yOXdwQU9pY2hjZ1NJVmJUVUphQlI3cVAr?=
 =?utf-8?B?UHVZSDZ1ZVo4NlpZbG9yZlRZTmpSWElwM2prUG9KREtua1F0ZDZaWkJPdDN3?=
 =?utf-8?B?Y3B4bllWdUoxN3I3R2pJbytxVy9RZjk5WjlVcUphL2psT0liUnRyVTl3MkY4?=
 =?utf-8?B?MGRiNzhDNmR1Sng2OFh2cmVGaDRyZHUwUUk3RGxzT3RkR0NSbTh5TnEvMk9D?=
 =?utf-8?B?MUhBY05raGRFRHcxcFBDK05PTHRXRnFiVjNnYU5iKytodzlnSmJEdVNzRUgv?=
 =?utf-8?B?NmFrR1U1a1d3UjhJNVEvaVV0azVMZG5KM3BHeFFpT2JOa1gvYU1mcUJPWE1w?=
 =?utf-8?B?Vklwa21rbTJ0QmZqdElua3dQL0tCcUdEWnptaGc4NWJzeTUwbm5RQ3J4M2pT?=
 =?utf-8?B?SllCNDVKdzdOK1FZamdadUxTWFVSc0pXY1NUMXc2WmFkZkdlWWlZN3k4eVYz?=
 =?utf-8?B?WHBhVlJqRGRjZXN6R200YmRlemkzUlZ0Mnh1dEE2N0o2REl3bEpyUTI0dFRQ?=
 =?utf-8?B?VEZmelQrWVo2cmY4RGxxckxsbnErRTdlTG9TMTRyUnZFOVNiajF1bDZnWExI?=
 =?utf-8?B?eStXR1lTclhrUDFwSm9VYzVVejE3Z2ZMNy9BOFRGS2JwZmFKVXhqQ0VqclhG?=
 =?utf-8?B?Z3MxTHNaSDgwcyszR3JhWmJnSDNmZ21uSnh2ZEdFbFJTd2lpWkYxcnhlUlpL?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afa168bf-9956-427d-653d-08da7415b78e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 23:29:45.0774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npAiwiO1A5hnKBJZVmBP7VGADswErIIYbSf+qI+wYBX7KMFMQf8NwB7WNcJ6tW29hm5uhW/DSCz5+q2c9T/aeNaR7IPLXLMt2egjzDv2oWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3686
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/2022 4:00 PM, Ilya Evenbach wrote:
>>> -----Original Message-----
>>> From: achaiken@aurora.tech <achaiken@aurora.tech>
>>> Sent: Monday, August 01, 2022 6:38 AM
>>> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>;
>>> richardcochran@gmail.com
>>> Cc: spayne@aurora.tech; achaiken@aurora.tech; alison@she-devel.com;
>>> netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
>>> Subject: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
>>>
>>> From: Steve Payne <spayne@aurora.tech>
>>>
>>> For an unknown reason, when `ixgbe_ptp_start_cyclecounter` is called
>>> from `ixgbe_watchdog_link_is_down` the PHC on the NIC jumps backward
>>> by a seemingly inconsistent amount, which causes discontinuities in
>>> time synchronization. Explicitly reset the NIC's PHC to
>>> `CLOCK_REALTIME` whenever the NIC goes up or down by calling
>>> `ixgbe_ptp_reset` instead of the bare `ixgbe_ptp_start_cyclecounter`.
>>>
>>> Signed-off-by: Steve Payne <spayne@aurora.tech>
>>> Signed-off-by: Alison Chaiken <achaiken@aurora.tech>
>>>
>>
>> Resetting PTP could be a problem if the clock was not being synchronized with the kernel CLOCK_REALTIME,
> 
> That is true, but most likely not really important, as the unmitigated
> problem also introduces significant discontinuities in time.
> Basically, this patch does not make things worse.
> 

Sure, but I am trying to see if I can understand *why* things get wonky.
I suspect the issue is caused because of how we're resetting the
cyclecounter.

>>
>> and does result in some loss of timer precision either way due to the delays involved with setting the time.
> 
>  That precision loss is negligible compared to jumps resulting from
> link down/up, and should be corrected by normal PTP operation very
> quickly.
> 

Only if CLOCK_REALTIME is actually being synchronized. Yes, that is
generally true, but its not necessarily guaranteed.

>>
>> Do you have an example of the clock jump? How much is it?
> 
> 2021-02-12T09:24:37.741191+00:00 bench-12 phc2sys: [195230.451]
> CLOCK_REALTIME phc offset        61 s2 freq  -36503 delay   2298
> 2021-02-12T09:24:38.741315+00:00 bench-12 phc2sys: [195231.451]
> CLOCK_REALTIME phc offset       169 s2 freq  -36377 delay   2294
> 2021-02-12T09:24:39.741407+00:00 bench-12 phc2sys: [195232.451]
> CLOCK_REALTIME phc offset 195213702387037 s2 freq +100000000 delay
> 2301
> 2021-02-12T09:24:40.741489+00:00 bench-12 phc2sys: [195233.452]
> CLOCK_REALTIME phc offset 195213591220495 s2 freq +100000000 delay
> 2081
> 

Thanks.

I think what's actually going on is a bug in the
ixgbe_ptp_start_cyclecounter function where the system time registers
are being reset.

What hardware are you operating on? Do you know if its an X550 board? It
looks like this has been the case since a9763f3cb54c ("ixgbe: Update PTP
to support X550EM_x devices").

The start_cyclecounter was never supposed to modify the current time
registers, but resetting it to 0 as it does for X550 devices would give
the exact behavior you're seeing.
