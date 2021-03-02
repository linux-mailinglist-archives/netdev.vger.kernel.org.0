Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0E932A39D
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382142AbhCBJYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:24:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:45288 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837932AbhCBJOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:14:14 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lH15m-000CAX-27; Tue, 02 Mar 2021 10:13:22 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lH15l-000IT0-Pz; Tue, 02 Mar 2021 10:13:21 +0100
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release
 libbpf_smp_load_acquire
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org, will@kernel.org
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com> <87k0qqx3be.fsf@toke.dk>
 <e052a22a-4b7b-fe38-06ad-2ad04c83dda7@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <12f8969b-6780-f35f-62cd-ed67b1d8181a@iogearbox.net>
Date:   Tue, 2 Mar 2021 10:13:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e052a22a-4b7b-fe38-06ad-2ad04c83dda7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26095/Mon Mar  1 13:10:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/21 9:05 AM, Björn Töpel wrote:
> On 2021-03-01 17:10, Toke Høiland-Jørgensen wrote:
>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> Now that the AF_XDP rings have load-acquire/store-release semantics,
>>> move libbpf to that as well.
>>>
>>> The library-internal libbpf_smp_{load_acquire,store_release} are only
>>> valid for 32-bit words on ARM64.
>>>
>>> Also, remove the barriers that are no longer in use.
>>
>> So what happens if an updated libbpf is paired with an older kernel (or
>> vice versa)?
> 
> "This is fine." ;-) This was briefly discussed in [1], outlined by the
> previous commit!
> 
> ...even on POWER.

Could you put a summary or quote of that discussion on 'why it is okay and does not
cause /forward or backward/ compat issues with user space' directly into patch 1's
commit message?

I feel just referring to a link is probably less suitable in this case as it should
rather be part of the commit message that contains the justification on why it is
waterproof - at least it feels that specific area may be a bit under-documented, so
having it as direct part certainly doesn't hurt.

Would also be great to get Will's ACK on that when you have a v2. :)

Thanks,
Daniel

> [1] https://lore.kernel.org/bpf/20200316184423.GA14143@willie-the-truck/
