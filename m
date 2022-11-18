Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A897662FEE6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKRUeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiKRUeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:34:10 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BE4220C9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668803648; x=1700339648;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1A0ViN03FrSZEko0Rhhec6/2knqfqFkhyhq3ed2IURc=;
  b=m7YLSFJ213oR8fQFkC19ZOZHex+LSPInAKIDOi6wc1QB6Wrp9Ju16vsT
   tViL4zN0rUswxiNeUISQHwxk4XMrDyyNOfJNORemyXQBn2WwuUyLW1BoS
   Q5V/dQyFgoNQQqkg2VQrnZMFF23oCcJvodJ5WlwmQ1OyPVTOOY6R2Sovc
   Ey93Wd40ZEmuqklW6DMVzwvHHM6VVLBu6uVopFI0Q28vQAeD3R7sn2tgl
   aoGzwG7spP+hx7Wm5vq4GTEs+PUNrbJPfPX3CgvAzaKkZluKSZby6lM3U
   bKdIcES9YzkNWwlTRrwZWdTodf507SZGp/pMXGhZ5ay37/TdgsB8MQ6HQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="313252630"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="313252630"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 12:34:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="885432375"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="885432375"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 18 Nov 2022 12:34:07 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 12:34:07 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 12:34:07 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 12:34:07 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 12:34:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWlcQvmoHdvW0Y1lrIFhI64qPpRQOU3z7XPCXYzfpwN7TOfvuWsruQLbc2HMAPrVK+xIhfcz/RSuwwedxsMAxAI9GW1A05ZVeqL8EUxvi3ZH89BLpHlB/xKH08din2z+3DoCWWi2vzyfHAmlG4wxGN/ZR3FdzAwWxLG4ExfutN0e1E4g8Al+PmnGyZ3a+xZ0ISbMNCc6e3IGyRLPtEBWXqi6TdQIYb9pck3mGBEBR1VL35XNRN9XpyssHCKKIbBSEs8G07NnqCsMsz9KiK8kmnFUuVFcPinTLp0L3MC9YeuVtzWZcYxlhJeQcR4QCI5NHBwVglxuy9yszOsfp2iq/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urWEP1zmygRd3GRThl2YyYmwC33mIcnAMrq1NFiKJlk=;
 b=b6B6EyVqhSg3aLahHjnCOchbimT4e4VkH4gWwnnQzcc+DMITKb/147uL2BAfd5ansfh5pQzQVVokmPjFMlOV1G/idjcybp4Cf32idxeu5hDhN0qTId6kyM0O6uIap+H/mjzSQumhTg8alEfBSxKGHzqc5MlmX/EWgGZcDfgMWaL0Yn4o6iG0AV4hpDyIgbjs5kHXUejxSg36visrNNusNs68hQaI00RS48o1UIRLIHsixYfpEiXg46RETA+qNz4tMFLTK0SYjT6u2CbP1KUkd89OCt1oNfO+YKrKhb0xq8bg6Z66a3O4zOZc6zXoSXyRAjK5CM9G+ZJvA+DLpa/+5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by MW3PR11MB4668.namprd11.prod.outlook.com (2603:10b6:303:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Fri, 18 Nov
 2022 20:34:05 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9%8]) with mapi id 15.20.5834.009; Fri, 18 Nov 2022
 20:34:05 +0000
Message-ID: <b343285e-142f-68de-778c-6103bc16bb8f@intel.com>
Date:   Fri, 18 Nov 2022 12:34:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 2/5] sfc: Use kmap_local_page() instead of
 kmap_atomic()
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        <netdev@vger.kernel.org>
CC:     Ira Weiny <ira.weiny@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <8192948.T7Z3S40VBb@suse> <164778f1-f2a6-1e82-8924-a4d7ba073e23@intel.com>
 <2153769.NgBsaNRSFp@suse>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <2153769.NgBsaNRSFp@suse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|MW3PR11MB4668:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6bb7b7-6439-4623-1739-08dac9a43c6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nM03p8wWrGTRrkqgoUj23DdJHBka16C0mBEpzd0e96s+dsYuxUOcMOH+xqX5hS6Aviowk3dlq6iCRbqMpZih2ZIDIxjPWJfydMbXDOcy1sMoBWaXYzAfglcs1qJmGBwtFZ5KmtvcfS+U+P5WaNkd9OWIghav5w07RovIbRxE0T3xpw+rur2xrhtsCQda/HYFFh4tpbwyQvNDa03E6VJyQWB/HMtDqIUwrzC1SGIc+pD7IeRc6yeKCcKycNBPVk9Fa+vKaqEye9ERBSiedG9rJXmwS0GfADwLVv7P/4i3RLxzcgkV3Gbku8Y5sUSfVuBkeT6LcFZzRfJOE7lRB7L0Emb4XaDNX+qK6v+PAuqPArz+O29lE/X4v5j1GOuNS0rwcztupwOxPrmf3QO+EbqKFyYtqb3U9rBySULawgNHFeiR5lbicyNPZ+YqB7ddS12qecAZsIx8IGXy2E6nHdhj4aFPkeIn1eooG3xC56KE/F1lFYqHyvwEcO2axz47J8w+gv0/rpyE7v1JRz7BxYBdchFVae7KpLv7smqCIuf4hgaU70EigeJnn2XH1j3Fpl9BiK5npPsnY1SNkgwpG9Q0y40ry0PTz43gGALSgi0ZvUjEwdt/W3mYgbBaQMqcESfepkljATnHq1wNwTY7guJAGY+WUxrAGgBTiwoy247wtLQaV+wWeNwE/QH9uIwsXweP0+163a6WiwjptwF3egKPUfOjE8bkAFQ2ERoV4CeHTaY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199015)(31686004)(36756003)(66476007)(2906002)(82960400001)(4326008)(316002)(8936002)(83380400001)(38100700002)(31696002)(86362001)(66556008)(6486002)(2616005)(186003)(478600001)(66946007)(8676002)(41300700001)(5660300002)(44832011)(54906003)(53546011)(26005)(6506007)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWJkYVZnaWdxR2RoR09PUTRyMEp6TzE5Vk9nTTN1cS9NTys3cVNlOU1WajRu?=
 =?utf-8?B?WEp2d2pWRWFCcHZ2a1I4MjlzV0l3UE5Qc1hraUlFaTVvbytnZ0hiUlBOc2hP?=
 =?utf-8?B?L3dOWFZkbVNXZ2prL3BjWUpvNzlkVnZuMUp3WXhXVWNUdzlKMmNhS1VHZTlo?=
 =?utf-8?B?d2c4RUdmMXhweFBLd21xOUNCcVBtQjJDd1hubFRHb2JxT3JDSmpldTM5dUo5?=
 =?utf-8?B?N285SEpNNmJ5NXhHMTNObnlwSEY2bGRJMlpMODh0UXM0TEYxYi9HQ0pjeTFW?=
 =?utf-8?B?MlA4ZEpZSkk0WGpLWis3aEVkZThYY2xZQThENDhvNTM0YkU1WUNYb3dLSnBH?=
 =?utf-8?B?RFlnTitNZEJoa1RKQTArVGp6RWVvNjlXVmY1VVNZZytjdG8zNDI0MThtMlk0?=
 =?utf-8?B?eUg3dC92YkV0ME8ybmE1RnVuNm93Y1YweFowdmNXL1hTMEVHYlloaU5jVko1?=
 =?utf-8?B?bUFCVDY3RTNPSVVMTTRpSVFiTHBpU0dZVi9YQWw3WlV5bGJsb0VCbkliTVZt?=
 =?utf-8?B?NFJvMVRBOWRFQWRjVElyWmhpMHdmMXpxUjZaT3FvV0ZCcGNBK3daMkxpUFBw?=
 =?utf-8?B?WGt0VzJOZzczSUV6aWFRS21EM1IyVlFCSGY4SEl4VU5IRGZCZ1doRWRpdUFE?=
 =?utf-8?B?VkZYVjRkN0NYMExIUzNRSkVNdWdvR3RaK050aDJYb2hjMmRUV2Eya3RRQ3J4?=
 =?utf-8?B?bXQwV3FkOUZ1YVJLaDZHelFBVHhoLzhtMStPdGJLL1BPUzVwMUNaVHM3dzN0?=
 =?utf-8?B?L2VOelJtT0wvK3FoQyt4VEVBUG9QdmQ1YUI4aXlmdEp5SEFyRzJnUmdjTFBN?=
 =?utf-8?B?OTZQdllPRmRodHUzUU9MYWxyNVY5eVpLYlluY2VNdzlRYWphL3d4bThSM0ht?=
 =?utf-8?B?OElGR3Vab1loT0RLT20wVjhJVWdFY3ZQU29KZk95amVCTVFJdXZLVldOZmo4?=
 =?utf-8?B?WUZCclhnM3NiWE9ZTzBHUDZldGYrTjBpcWVoMWFndUV6MW5xYk5KVHU5cjR1?=
 =?utf-8?B?U3NSVEhFczJiZFV3NTZrV0IrQkRESHhZUzZuWm5aZFBTOW9IYVRnYVYvMUli?=
 =?utf-8?B?VkxtVndFYW1yS1BIRXBlSktmSStmQWRtZkVQRGxoSkdRcXc2Q3NMMzBDTHVp?=
 =?utf-8?B?VkIrMEwwcEZ3OC9LSCtmaFQrOUZ0NEhkUEVsK1h4aitrWU9xRmZNYUVER29C?=
 =?utf-8?B?aGhYclBwZXI3a0JjWmdvN3lLeEdQNklKUFNZQVhVdHl6WlEzM0pPdE9FdHBU?=
 =?utf-8?B?TFF6SkcyVEZFUzZZS0E5bGI2WTZnUEY5RzhQR0hhWkF5U2pPTkE5cDM2U0V4?=
 =?utf-8?B?eWxtMFFlVHU3bE1xOGo0ellLaVp5OWl3MnVkUjU2VjBIa0wvWDZ2MkYyc0ZM?=
 =?utf-8?B?WWxjWkFsd3VhV3J4NU9kd2pvSEQ3emlpeG9PSmV6dGhVaTFKMGQ1NFZuS3Fm?=
 =?utf-8?B?TVNSckZuWU83Tkk2ZWVVQUtKbzhMbUwxYjh0bk5VcnVCaDROQndEajhZTzF4?=
 =?utf-8?B?TTQ2M2xPYUFSWEwrWnpPY2ZzdHZMKzlpL01xWlB0OXZVYjY3bzBHemRqOEg2?=
 =?utf-8?B?ZjJ0ekdSNU1sdDNTbXJVR0luUW8wd2prelk3NVQyODVkQXFiR3FERDRVYytW?=
 =?utf-8?B?TGo0aUNGSTFQZDQybEcrVnFmaElyTE5seUpSSmxNSmllTThROXlsYlhjbTgy?=
 =?utf-8?B?Tk1JbGY0b0MzZXNaTXFRUllyWjZCTkpaZmFuaC9iMThSUzRMNHZ6Lys3eGU5?=
 =?utf-8?B?dTBiajhPMEZhUG5KL2x4OHRiMXlSaTRzb29aZUFMVzFFR0dmQWkxa3RNWWJs?=
 =?utf-8?B?RC9LK2JhbWxQdElpbGsvZWF4WXpHOFdFQkxvRmpETnlYdk9Ubi92WS9vTnFx?=
 =?utf-8?B?dUJiY2dpWFlRVHVUYm43alVUSXZnSTZ4QlhlaVpYRk4rQTJBQWhNb1ZDVGlI?=
 =?utf-8?B?Zm1HdU0xajlWRERqZE42cVpScDJRM2VZTUlMVlRjYlRUcWFyQmRmWGhMYjFJ?=
 =?utf-8?B?b0s2ak5GN3FrYTRxcS9xNEI2T1IzK3NkcW14eThHQjUram55UzlwcjcwdzQ5?=
 =?utf-8?B?cUFCa0plb3B0cUllSzVhLzZmbGtrL0hHd1Y2ZDVVT1ZLVmtCNUhsOU14QmQ2?=
 =?utf-8?B?SXJEeGU3NG01SlFRQzBkYjNidEVZQkZwMU1yakVuVFQ0bHF3bjljenZkTHJ4?=
 =?utf-8?Q?Y5e3i4Y5XYWT9+4a1+ud+xs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6bb7b7-6439-4623-1739-08dac9a43c6f
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 20:34:05.3343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZoct7gzifSOsiygER+CtsYHVJ+icOpFNBHCthORErsnu9alId0veckovGk0gH++8JeLg08XweUpxqNiwigdNCF9fAt/21qO1rv7D4KPjSLuI58MLmtHchEIWxKm8eNo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4668
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

On 11/18/2022 11:26 AM, Fabio M. De Francesco wrote:
> On venerdì 18 novembre 2022 18:47:52 CET Anirudh Venkataramanan wrote:
>> On 11/18/2022 12:23 AM, Fabio M. De Francesco wrote:
>>> On giovedì 17 novembre 2022 23:25:54 CET Anirudh Venkataramanan wrote:
>>>> kmap_atomic() is being deprecated in favor of kmap_local_page().
>>>> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
>>>> and kunmap_local() respectively.
>>>>
>>>> Note that kmap_atomic() disables preemption and page-fault processing,
> but
>>>> kmap_local_page() doesn't. Converting the former to the latter is safe
> only
>>>> if there isn't an implicit dependency on preemption and page-fault
> handling
>>>> being disabled, which does appear to be the case here.
>>>
>>> NIT: It is always possible to disable explicitly along with the
> conversion.
>>
>> Fair enough. I suppose "convert" is broader than "replace". How about this:
>>
>> "Replacing the former with the latter is safe only if there isn't an
>> implicit dependency on preemption and page-fault handling being
>> disabled, which does appear to be the case here."
>>
>> Ani
> 
> Let's start with 2/5 because it looks that here we are talking of a sensitive
> subject. Yesterday something triggered the necessity to make a patch for
> highmem.rst for clarifying that these conversions can _always_ be addressed.
> 
> I sent it to Ira and I'm waiting for his opinion before submitting it.
> 
> The me explain better... the point is that all kmap_atomic(), despite the
> differences, _can_ be converted to kmap_local_page().
> 
> What I care of is the safety of the conversions. I trust your commit message
> where you say that you inspected the code and that "there isn't an implicit
> dependency on preemption and page-fault handling being disabled".
> 
> I was talking about something very different: what if the code between mapping
> and unmapping was relying on implicit page-faults and/or preemption disable? I
> read between the lines that you consider a conversion of that kind something
> that cannot be addressed because "kmap_atomic() disables preemption and page-
> fault processing, but kmap_local_page() doesn't" (which is true).

No, I wasn't saying (or implying) this at all, nor did I think it 
could/would be interpreted this way.

I was trying to say that a straight-up replacing kmap_atomic() with 
kmap_local_page() would not be functionally safe if the code in between 
the mapping and unmapping relied on page-faults and/or preemption being 
disabled.

> 
> The point is that you have the possibility to convert also in this
> hypothetical case by doing something like the following.
> 
> Old code:
> 
> ptr = kmap_atomic(page);
> do something with ptr;
> kunmap_atomic(ptr);
> 
> You checked the code and understood that that "something" can only be carried
> out with page-faults disabled (just an example). Conversion:
> 
> pagefault_disable();
> ptr = kmap_local_page(page);
> do something with ptr;
> kunmap_local(ptr);
> pagefault_enable();
> 
> I'm not asking to reword your commit message only for the purpose to clear
> that your changes are "safe" because you checked the code and can reasonably
> affirm that the conversion doesn't depend on further disables.
> 
> I just said it to make you notice that every kmap_atomic() conversion to
> kmap_local_page() is "safe", but only if you really understand the code and
> act accordingly.
> 
> I'm too wordy, Ira said it so many times. Unfortunately, I'm not able to
> optimize English text and need to improve. I'm sorry.
> 
> Does my long explanation make any sense to you?
> 
> If so, I'm happy. I'm not asking to send v2. I just desired that you realize
> (1) how tricky these conversions may be and therefore how much important is
> not to do them mechanically (2) how to better craft your next commit message
> (if you want to keep on helping with these conversions).

Appreciate the explanation, but as I explained above, what you read 
between the lines isn't what I was saying. I am most certainly not 
making these changes mechanically.

> 
> I'm OK with this patch. Did you see my tag? :-)

I did, and thanks!

FYI, I will be sending a v2 for the series anyway (with the 
memcpy_from_page()) changes, and so I am planning to update the commit 
messages to hopefully be a little clearer to you.

Ani
