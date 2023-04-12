Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06716E010D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjDLVhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjDLVhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:37:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4CF83C2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:37:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=To7k3G6+qqgMuyIZu1i8L1KLparAQLrCFpF51EpQHFhPLFznpnCrsxDuhSSwLATo4PNRhdI2TRRJnNqaQztcbfK2nzfanm7nKWIkMYDU7eiDpm1FL/9tFdF5QIVEpq25qyp0sjgpta+XZ4JxBz7wdB+XcWgR/xQAZmWvvgcez3MDy+TE2rvpxM2qC0ptvIIj5+Vyo8Si5kJY3GCx97cSItcYpqDowD7PAm33ZQ7r0Km08pIxUZFA/aYtu7XUdZhD6dp49svnvxAukWe+ycOENKEmeKc3mmnCMlB6sCZOAnHH+kswzFS/+t3JUFgfe3goKjqP2cSsiHYtXm1ZCtUdEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4K2CEj1gl2DpGPIXFsEVSFHY9S5vaDo9MxzTgAGqYM=;
 b=EaDgc8+uHyiF6AEYJFZIZjk0ynNTjx929Pnam0D2uDsuATMPPViysVIX20akSUAruKMQeLY3ud+LZRQYdQLaIkcp3r75pyeBBxwDjVxrHfn0ojs7hBIGVRtf5ZP25bpQSNR0DEVDYUmjGNqtwqyxugDdz8zBDzoJWVupRQn3g+P6FFAL3UDCH5anrxfvmA4YeJl41oCBxLrnmckTWhhBpJ/eT9jE5ssSMebZqjP5mX6V11tNiDa4ECy3jscyKyec74IJEg/n5mpy1lfiZexu42XZgIX0WtJOK9EqJVB88BmKQbN1CsRRaNf7n8ZOhOgTeHW+CYc9ztcMWs160CF4Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4K2CEj1gl2DpGPIXFsEVSFHY9S5vaDo9MxzTgAGqYM=;
 b=D4JOyKC0JfjKjex5CgWKYbactBrnK1kOOhAFGDK7Dpc5lyq6B73hySak2/ZGjNZta65pREmxjB+jUM7+sQXqiFDkCtsN+ycpLKrMvYw7+C3J6PIeGPZL1h7G+xzgeusL+ILUjQQja3wJw+sn68ft/0cUg5/hrNVxt7Q2lXS+BeE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH0PR12MB8798.namprd12.prod.outlook.com (2603:10b6:510:28d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Wed, 12 Apr
 2023 21:36:54 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 21:36:54 +0000
Message-ID: <ffe43a28-641c-c263-2ea2-67882b476cde@amd.com>
Date:   Wed, 12 Apr 2023 14:36:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Content-Language: en-US
To:     "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, shiraz.saleem@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-2-pavan.kumar.linga@intel.com>
 <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
 <a5b7f1e4-8f14-d5fb-8f88-458d7070825d@intel.com>
 <f7c7c691-d173-73ab-c24a-79c22e6ef3b0@amd.com>
 <ffd66203-4349-0986-2130-f8b156f1923a@intel.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ffd66203-4349-0986-2130-f8b156f1923a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR21CA0018.namprd21.prod.outlook.com
 (2603:10b6:a03:114::28) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH0PR12MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: 36829439-d097-4058-e7b4-08db3b9e08e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Cna8PP9TRt3gUA1xqQHKmsnzfaL4vhj5sqttAR/yIgw8QUA6iAw8Z+PzCcVssBdabjTBBdlL06wxgDwaOLAptcfK5uyKHpLTIvReUI16E5Evmjn4GqLyoFsDILNvFimJ8WW5onOoW/XPVqOwhQiqVgGEaGgqQ2SxcOLOuLYfNQMOsdH8/yEgpCYWp+RE2Ebx/kcnI1uZX5AaMGWWgczJZsD9JK+ENOujD6SE+aQtXvaz8Xo7jPR2tFtglvhN8Qr847lE0j5VAQeXesns0CNc/jldxfsTlOcyyjfeUZxFBw3VrG8J0P6WPyszuZI+AHlC1oPMANKnh5Bs1Cgt1teYpmzRCIMnQDT/MWq3eXH9BHcBgcU2JaH6Zk+Uvr2/dyLyvwugflRnf0Y+WumGu3nNwBBmhGG0Jz6lZeqcjupjXCbfu0WjB1IVxvDllVEV0fvrjCVNleOMiVeNGsK9Aok43JqkabTGz7Tz9B6nGVM5TrLRbdH0B4lsiFl+6M8fsQxJQ05YnL7heAOQwbRh21WOj9QGw/GDP2SupDc6ccfiZxKETbmxn8w4nU6eLU5J1TC7RXTQvGVyDT1WrCYN/JqGhetKXALG4fmKK1psT/RQb9RiwEHORPe9O2wv23iFWXelLS1n20YRRL61hd4G9Rgnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199021)(83380400001)(6666004)(6486002)(186003)(26005)(110136005)(54906003)(6506007)(478600001)(53546011)(6512007)(44832011)(2906002)(7416002)(38100700002)(5660300002)(36756003)(66556008)(4326008)(66476007)(41300700001)(66946007)(2616005)(31696002)(316002)(8676002)(8936002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkhPajFwREhnWmZwa1ZjTHFjOENMKzBCUCtLeS82L0huN0twSzNzRkJlakI0?=
 =?utf-8?B?R291Y0gzdFNpZ3RXMWVWdFRoTDN6RVA5SzM0MTFWb1pIMlRob1lJUU52Y2t5?=
 =?utf-8?B?bG16YkJxN0NiZEFibnBoTG8rMDllTVo3VTVCMzZqa2Z2anc4cVEwbWdKTmJB?=
 =?utf-8?B?TEVGMW0vbWlVUTVSV0xPMmUzcjdpOXhVSU9JdjMxVEJ6d0JOSGpYT2J0UTla?=
 =?utf-8?B?TDFiN0UvVVZlU3dpT0pTelRQRnFSVTBqQlkwVTliRGFkbktHVTJEQVFDVURD?=
 =?utf-8?B?ekpRd28yem1YeHZQR3phbE9iNnZHNDVXb1lNeEwyTlI0ZWVxWk1WVnZ2eE96?=
 =?utf-8?B?c3NVNi9zZ2k1dkM0L3RsbW11QVJwWlBqNzRzRlFNSXZNam93dThUYTFMbWky?=
 =?utf-8?B?NUVJdE4xUnJwcTROTDdEWXdNYnhDTmlMaktFWk5sWVlwMndqdzhMMWpNNThP?=
 =?utf-8?B?OExLa0VZODFJYjhtOE1xSlRCYWdiUkxJMllNME1yWjZodE9yc3NRWHplQVhW?=
 =?utf-8?B?VDl0ZnlhWFI4R2RJbG53cnJOM0VBSlFoczlmUU13aElnS1dDTnAwc29WeEFS?=
 =?utf-8?B?SzNuMHQ2L3ljSkhXdU5ITTlmWU0xMkZieFJLWFAwSkJJRm9kWmJSaDJpRHlW?=
 =?utf-8?B?WGwwVG12ckNJdkZvMTBMSFNrNTE5K2JXY3hsL0pVcmFuWkxNWm54MDB2S0Za?=
 =?utf-8?B?VExaMVBhVmVXbGVjQTRaK1g2YWtoN0tyM3hnazcwNVVDMDNTa0VnTXhyUWFX?=
 =?utf-8?B?SjAvYm5MTlRFZGJHYldUckcxRzkvTmVJN25LeVNEQ0t0NG9HWXozMkE5ZHFW?=
 =?utf-8?B?MGM1VEdFOW5NblpjQm9lZStSaVFhUkNrOVg4SDJ0QTdzZWdNVmhzSU9kWWxY?=
 =?utf-8?B?TzRKQVNhVC9MdVpBVGMwU0ErWExhWlVPdHdaMTZFcXFUMXNvS1NrcEdOOTND?=
 =?utf-8?B?TXZpUjllYXhxMm1UdHVydEMzZ3FmcG1zYm9vUXN1aWhrcDJ1RitmV0FMSTJO?=
 =?utf-8?B?V0dDLy9QRkQ4eDhjUkwxSE5IdVFZZWpxcmc1eWllU3hKQkFQdzNuNXBuMjFm?=
 =?utf-8?B?Y015elF2dDc0UmNWWDlFc3JFYnlQMXM3VzdKM0RTN3RrQ2xHaHlaZUM0UVd3?=
 =?utf-8?B?UkFqTk1oQjlaU21hRUtZMGhCeHRhcGxVV2ZxNTJmcG1xN2kvZllFbUVlMCtJ?=
 =?utf-8?B?WEVTYm1aK0FqMk5SS1YvaldFejQxZWxtYndUcGtHYktOZUYwazlDZjJVakNP?=
 =?utf-8?B?U1JIQVNyNEJkdW92OUJRUmdNakZpSjBGWU1McGNuUEVWR2JidVJpb2NkeHpV?=
 =?utf-8?B?bkRtejZMZGttbHdOQmUxVW1VR05TTmJJYzdweEd3Q285QStoR1dUSXlsMHhQ?=
 =?utf-8?B?enkyTkE2cThuZGx4aW5oR3JObUx3eE5OL3lXUHc5ejk2RVpVVWRQMDE5VW1O?=
 =?utf-8?B?KysrcisyRkZWbWtDTlhhWUR6TStFVStHMlBvMExqMVkvRUNuSzdpMndQUnlz?=
 =?utf-8?B?Q0M3MEpnRWRJMkQvRisyTUNGL2pQbGlUWm90emMyZERWdHZiYWhIamJ0dWd3?=
 =?utf-8?B?LzdWTC9FUEdWVHQ2OExFdTlVTXNNK0hCVktKeGMwSzVnZFp3T3BJd3ZwYmZY?=
 =?utf-8?B?dnlnNWFMeUJMN0NKK3ppNTdJOHJ2S2xvVm5WeEFteEhJcVRScWVJVjd0T05H?=
 =?utf-8?B?L2h5TnNCUnZFSWFSeW9CVEY0ZnN4Y29SeURPellidFZoSzZSMnl3RXBsaXNr?=
 =?utf-8?B?a0h1Y1NEdmtjSHl6REhxVW50R3NSTFRhbmxZMkd5U1dQMnFOZThZemdtVTNy?=
 =?utf-8?B?RXg5aEltUWgvWm5NVm0vQmN6UkpYVEZ5bjlnbU8zSDdUSmRDR1VjRlRPdFB4?=
 =?utf-8?B?MmVNVUxvc0pwcWdLaVNNQldxTVNWeFREOWdWd3QxbW1TWVNKOHN6RzNvaWJq?=
 =?utf-8?B?RlMvR1NoamhhM2ljd2ptT1hJVVJ4WTVLL2svVWNDbE1YUTBjNDBEeXQ2Qzhq?=
 =?utf-8?B?ZzVIRmo1ekE3b0FkcnRZcjY4dEU4dnF0eFp5VjFQK1ZDN3ovQVI0M0UxL0po?=
 =?utf-8?B?bHFleUtLZ1ZMdytXeVJKOEdnWFkxQ0xtMTdqV1VSYmVuZHlkemFUWE1oRUNX?=
 =?utf-8?Q?5ztU1Hu8Nq8USr1rdDA+qjQjO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36829439-d097-4058-e7b4-08db3b9e08e3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:36:54.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTEMMAYNp9EDscLMpywuKkqhHbAK9ucrZn7ee+Bz3QF/YUiMektBmA1AZnC8Le3VfiFB/Ko9BZum8KAQpeJD/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8798
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/23 9:58 AM, Tantilov, Emil S wrote:
> 
> On 4/10/2023 3:12 PM, Shannon Nelson wrote:
>> On 4/10/23 1:27 PM, Linga, Pavan Kumar wrote:
>>>
>>> On 4/4/2023 3:31 AM, Shannon Nelson wrote:
>>>> On 3/29/23 7:03 AM, Pavan Kumar Linga wrote:
>>>>>
>>>>> Virtchnl version 1 is an interface used by the current generation of
>>>>> foundational NICs to negotiate the capabilities and configure the
>>>>> HW resources such as queues, vectors, RSS LUT, etc between the PF
>>>>> and VF drivers. It is not extensible to enable new features supported
>>>>> in the next generation of NICs/IPUs and to negotiate descriptor types,
>>>>> packet types and register offsets.
>>>>>
>>
>> [...]
>>
>>>>> +
>>>>> +#include "virtchnl2_lan_desc.h"
>>>>> +
>>>>> +/* VIRTCHNL2_ERROR_CODES */
>>>>> +/* Success */
>>>>> +#define VIRTCHNL2_STATUS_SUCCESS       0
>>>>
>>>> Shouldn't these be enum and not #define?
>>>>
>>>
>>> This header file is describing communication protocol with opcodes,
>>> error codes, capabilities etc. that are exchanged between IDPF and
>>> device Control Plane. Compiler chooses the size of the enum based on the
>>> enumeration constants that are present which is not a constant size. But
>>> for virtchnl protocol, we want to have fixed size no matter what. To
>>> avoid such cases, we are using defines whereever necessary.
>>
>> The field size limitations in an API are one thing, and that can be
>> managed by using a u8/u16/u32 or whatever as necessary.  But that
>> doesn't mean that you can't define values to be assigned in those fields
>> as enums, which are preferred when defining several related constants.
>>
> We can certainly look into it, but for the purpose of this series it
> doesn't seem like a meaningful change if it only helps with the grouping
> since the define names already follow a certain pattern to indicate that
> they are related.

I was trying not to be overly pedantic, but the last words of that 
paragraph are copied directly from section 12 of the coding-style.rst. 
We should follow the wisdom therein.

Look, whether we like this patchset or not, it is going to get used as 
an example and a starting point for related work, so we need to be sure 
it serves as a good example.  Let's start from the beginning with clean 
code.


> 
>>
>> [...]
>>
>>>
>>>>> +
>>>>> +/* VIRTCHNL2_OP_GET_EDT_CAPS
>>>>> + * Get EDT granularity and time horizon
>>>>> + */
>>>>> +struct virtchnl2_edt_caps {
>>>>> +       /* Timestamp granularity in nanoseconds */
>>>>> +       __le64 tstamp_granularity_ns;
>>>>> +       /* Total time window in nanoseconds */
>>>>> +       __le64 time_horizon_ns;
>>>>> +};
>>>>> +
>>>>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_edt_caps);
>>>>
>>>> Don't put a space between the struct and the check.
>>>>
>>>
>>> Checkpatch reports a warning (actually a 'Check') when the newline is
>>> removed. Following is the checkpatch output when the newline is removed:
>>>
>>> "CHECK: Please use a blank line after function/struct/union/enum
>>> declarations"
>>
>> Since it has to do directly with the finished definition, one would
>> think it could follow the same rule as EXPORT... does.  It might not be
>> a bad idea at some point for static_assert() to be added to that allowed
>> list.  For now, though, since it is only a CHECK and not WARN or ERROR,
>> you might be able to ignore it.  It might be easier to ignore if you
>> just used the existing static_assert() rather than definigin your own
>> synonym.
> 
> OK, we'll remove it.

I'm not sure 'it' means your synonym or the actual check.  The check is 
a useful thing to help make sure no one screws up the API message 
layout, so don't remove the check itself.  If you can't get away with 
ignoring the checkpatch.pl CHECK complaint about the line spacing, I'm 
fine with leaving it alone.  Some other day we can look at teaching 
checkpatch.pl to allow static_assert() after a struct.

> 
>>
>>
>> [...]
>>
>>>>> +/* Queue to vector mapping */
>>>>> +struct virtchnl2_queue_vector {
>>>>> +       __le32 queue_id;
>>>>> +       __le16 vector_id;
>>>>> +       u8 pad[2];
>>>>> +
>>>>> +       /* See VIRTCHNL2_ITR_IDX definitions */
>>>>> +       __le32 itr_idx;
>>>>> +
>>>>> +       /* See VIRTCHNL2_QUEUE_TYPE definitions */
>>>>> +       __le32 queue_type;
>>>>> +       u8 pad1[8];
>>>>> +};
>>>>
>>>> Why the end padding?  What's wrong with the 16-byte size?
>>>>
>>>
>>> The end padding is added for any possible future additions of the fields
>>> to this structure. Didn't get the ask for 16-byte size, can you please
>>> elaborate?
>>
>> Without the pad1[8], this struct is an even 16 bytes, seems like a
>> logical place to stop.  24 bytes seems odd, if you're going to pad for
>> the future it makes some sense to do it to an even 32 bytes
>> (power-of-2).  And please add a comment for this future thinking.
> 
> We can change the name to reserved to make it clearer, but the size
> cannot be changed because it's an ABI already.

That's fine - just make sure it is clear this was intended.

sln
