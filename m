Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E0432A3C1
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379034AbhCBJim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:38:42 -0500
Received: from www62.your-server.de ([213.133.104.62]:60536 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382421AbhCBJ0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:26:08 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lH1HN-000DrF-S1; Tue, 02 Mar 2021 10:25:22 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lH1HN-000BUt-JV; Tue, 02 Mar 2021 10:25:21 +0100
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release
 libbpf_smp_load_acquire
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org, will@kernel.org,
        paulmck@kernel.org
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com> <87k0qqx3be.fsf@toke.dk>
 <e052a22a-4b7b-fe38-06ad-2ad04c83dda7@intel.com>
 <12f8969b-6780-f35f-62cd-ed67b1d8181a@iogearbox.net>
 <0121ca03-d806-8e50-aaac-0f97795d0fbe@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cb975a27-ade5-a638-af6e-2e4e1024649c@iogearbox.net>
Date:   Tue, 2 Mar 2021 10:25:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0121ca03-d806-8e50-aaac-0f97795d0fbe@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26095/Mon Mar  1 13:10:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/21 10:16 AM, Björn Töpel wrote:
> On 2021-03-02 10:13, Daniel Borkmann wrote:
>> On 3/2/21 9:05 AM, Björn Töpel wrote:
>>> On 2021-03-01 17:10, Toke Høiland-Jørgensen wrote:
>>>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>>>
>>>>> Now that the AF_XDP rings have load-acquire/store-release semantics,
>>>>> move libbpf to that as well.
>>>>>
>>>>> The library-internal libbpf_smp_{load_acquire,store_release} are only
>>>>> valid for 32-bit words on ARM64.
>>>>>
>>>>> Also, remove the barriers that are no longer in use.
>>>>
>>>> So what happens if an updated libbpf is paired with an older kernel (or
>>>> vice versa)?
>>>
>>> "This is fine." ;-) This was briefly discussed in [1], outlined by the
>>> previous commit!
>>>
>>> ...even on POWER.
>>
>> Could you put a summary or quote of that discussion on 'why it is okay and does not
>> cause /forward or backward/ compat issues with user space' directly into patch 1's
>> commit message?
>>
>> I feel just referring to a link is probably less suitable in this case as it should
>> rather be part of the commit message that contains the justification on why it is
>> waterproof - at least it feels that specific area may be a bit under-documented, so
>> having it as direct part certainly doesn't hurt.
> 
> I agree; It's enough in the weed as it is already.
> 
> I wonder if it's possible to cook a LKMM litmus test for this...?

That would be amazing! :-)

(Another option which can be done independently could be to update [0] with outlining a
  pairing scenario as we have here describing the forward/backward compatibility on the
  barriers used, I think that would be quite useful as well.)

   [0] Documentation/memory-barriers.txt

>> Would also be great to get Will's ACK on that when you have a v2. :)
> 
> Yup! :-)
> 
> 
> Björn
> 
> 
>> Thanks,
>> Daniel
>>
>>> [1] https://lore.kernel.org/bpf/20200316184423.GA14143@willie-the-truck/

