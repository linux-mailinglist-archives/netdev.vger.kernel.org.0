Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE08D32A3BA
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243018AbhCBJgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:36:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:14012 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1838018AbhCBJRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 04:17:44 -0500
IronPort-SDR: SWskgWMvj+YmA8TGkKwtfmd4krQsmTwrPtCn3hMaDjaf44hawMFFBYNSO/P1QDvl0s02xXL0ou
 bzQbj+UwKGNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="183356978"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="183356978"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 01:17:01 -0800
IronPort-SDR: Bum09qkuPQg5WMxKjkqJJe/pqHMRPVGGG1Q17o2HOQU/Hwk239QOxFocuX+fIh4G/4Y+MFzQqV
 5WmlFArNDznA==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="398777931"
Received: from ilick-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.41.237])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 01:16:57 -0800
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release
 libbpf_smp_load_acquire
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org, will@kernel.org
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com> <87k0qqx3be.fsf@toke.dk>
 <e052a22a-4b7b-fe38-06ad-2ad04c83dda7@intel.com>
 <12f8969b-6780-f35f-62cd-ed67b1d8181a@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0121ca03-d806-8e50-aaac-0f97795d0fbe@intel.com>
Date:   Tue, 2 Mar 2021 10:16:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <12f8969b-6780-f35f-62cd-ed67b1d8181a@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-02 10:13, Daniel Borkmann wrote:
> On 3/2/21 9:05 AM, Björn Töpel wrote:
>> On 2021-03-01 17:10, Toke Høiland-Jørgensen wrote:
>>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>>
>>>> Now that the AF_XDP rings have load-acquire/store-release semantics,
>>>> move libbpf to that as well.
>>>>
>>>> The library-internal libbpf_smp_{load_acquire,store_release} are only
>>>> valid for 32-bit words on ARM64.
>>>>
>>>> Also, remove the barriers that are no longer in use.
>>>
>>> So what happens if an updated libbpf is paired with an older kernel (or
>>> vice versa)?
>>
>> "This is fine." ;-) This was briefly discussed in [1], outlined by the
>> previous commit!
>>
>> ...even on POWER.
> 
> Could you put a summary or quote of that discussion on 'why it is okay 
> and does not
> cause /forward or backward/ compat issues with user space' directly into 
> patch 1's
> commit message?
> 
> I feel just referring to a link is probably less suitable in this case 
> as it should
> rather be part of the commit message that contains the justification on 
> why it is
> waterproof - at least it feels that specific area may be a bit 
> under-documented, so
> having it as direct part certainly doesn't hurt.
>

I agree; It's enough in the weed as it is already.

I wonder if it's possible to cook a LKMM litmus test for this...?


> Would also be great to get Will's ACK on that when you have a v2. :)
>

Yup! :-)


Björn


> Thanks,
> Daniel
> 
>> [1] https://lore.kernel.org/bpf/20200316184423.GA14143@willie-the-truck/
