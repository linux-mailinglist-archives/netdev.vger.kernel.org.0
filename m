Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B072D191B8B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 21:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgCXUzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 16:55:50 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44889 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbgCXUzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 16:55:50 -0400
Received: by mail-qk1-f196.google.com with SMTP id j4so67088qkc.11;
        Tue, 24 Mar 2020 13:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZBt4wRf7+FBDuTYirZ1BhPnrjZSmaiF8RXqqdgqSOfg=;
        b=X/FbPaNNHdsJSqqpT5EimlUwRlhV4cl93yyKoaTOi1n4RQLd4NvkoKM4AtSoZRiszB
         U9q5R1XwoliAWBqs/VC86E5D3OAvoBF7bonFOAIPM63OpDXSY1LnFYNSv7IvOIvBFpp0
         fBLIUrh+cCk8c8XSN3L5juZggcLwY3NXJcFXqfzR0Gtf1tBQe0jbWQsRdAyka9pxHxmz
         glhyU1cjia+OzK67Saf/AvcGddzYGDv5/uw90HP1vSjDrDRcmWxaP0PKJKwrgjLD60aw
         QeJR/GAOIQamLZQdst2CozIao2i/7U4K0ohb/L00rup7GzTdO65/L9+E/ViiCMrXBjb4
         1tZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZBt4wRf7+FBDuTYirZ1BhPnrjZSmaiF8RXqqdgqSOfg=;
        b=iObO8jXxziFQmAa45b6tzoetcATh7CQOuYVVmCQKkug1SKlJWwfq+othDiJ8R+yF7E
         nvV4ykN3JS1ozZfj4Czaq1rZfJHnnBiN3e0VOBsYbtNJNSEsSSC+qGyEKlVW7BIrVDWq
         Kt+Lc5+iUICy2vjfbdlKSvbLPlj6Nl+/0wTgSBNNj3U0CNTjvPENj6Jyf6ny9TH9Csni
         Oqyc4jgccAnAZEcQ34Xxajs/AF8o76NPnlGVsInJGSEyBrmgJiVRAC5yhSIKMfrMyeU4
         UwGnoMfuB2yeJbfcKIoFbPUDl5VxCwQK8d17Ob7f/20KLkPCP+YzFXDd+2Zj/B9rUZWa
         nBlg==
X-Gm-Message-State: ANhLgQ3Ctqxou8g8gKDPf3QpNkELGfp/flsUKzRLS0nxvdHJLAR/m31L
        U+nLkNgQnLSQT8feuIOowHV3ojpt
X-Google-Smtp-Source: ADFU+vvK1mvoDl4YISD1dhOMkYFsIVnITlL7LQnQnzxOyAAQpYAzXqsB1QXELTTJ2AAFwu09YVodPw==
X-Received: by 2002:a37:a70e:: with SMTP id q14mr25153440qke.41.1585083348419;
        Tue, 24 Mar 2020 13:55:48 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5593:7720:faa1:dac9? ([2601:282:803:7700:5593:7720:faa1:dac9])
        by smtp.googlemail.com with ESMTPSA id 69sm13947663qki.131.2020.03.24.13.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 13:55:47 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk>
 <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk>
 <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <1dfae7b8-4f80-13b8-c67c-82fe0a34f42a@gmail.com>
 <CAEf4BzbT=vC8OF8cwFX8H5vphn8-dyWRjRSPq50t0Cg8onmYhA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3b6d6f73-26b2-6ef8-dfac-2bd28e361458@gmail.com>
Date:   Tue, 24 Mar 2020 14:55:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbT=vC8OF8cwFX8H5vphn8-dyWRjRSPq50t0Cg8onmYhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/20 10:53 PM, Andrii Nakryiko wrote:
> On Mon, Mar 23, 2020 at 6:01 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 3/23/20 1:23 PM, Toke Høiland-Jørgensen wrote:
>>>>>> I agree here. And yes, I've been working on extending bpf_link into
>>>>>> cgroup and then to XDP. We are still discussing some cgroup-specific
>>>>>> details, but the patch is ready. I'm going to post it as an RFC to get
>>>>>> the discussion started, before we do this for XDP.
>>>>>
>>>>> Well, my reason for being skeptic about bpf_link and proposing the
>>>>> netlink-based API is actually exactly this, but in reverse: With
>>>>> bpf_link we will be in the situation that everything related to a netdev
>>>>> is configured over netlink *except* XDP.
>>
>> +1
> 
> Hm... so using **libbpf**'s bpf_set_link_xdp_fd() API (notice "bpf" in
> the name of the library and function, and notice no "netlink"), which
> exposes absolutely nothing about netlink (it's just an internal
> implementation detail and can easily change), is ok. But actually
> switching to libbpf's bpf_link would be out of ordinary? Especially
> considering that to use freplace programs (for libxdp and chaining)
> with libbpf you will use bpf_program and bpf_link abstractions
> anyways.

It seems to me you are conflating libbpf api with the kernel uapi.
Making libbpf user friendly certainly encourages standardization on its
use, but there is no requirement that use of bpf means use of libbpf.

> 
>>
>>>>
>>>> One can argue that everything related to use of BPF is going to be
>>>> uniform and done through BPF syscall? Given variety of possible BPF
>>>> hooks/targets, using custom ways to attach for all those many cases is
>>>> really bad as well, so having a unifying concept and single entry to
>>>> do this is good, no?
>>>
>>> Well, it depends on how you view the BPF subsystem's relation to the
>>> rest of the kernel, I suppose. I tend to view it as a subsystem that
>>> provides a bunch of functionality, which you can setup (using "internal"
>>> BPF APIs), and then attach that object to a different subsystem
>>> (networking) using that subsystem's configuration APIs.
>>>
>>
>> again, +1.
>>
>> bpf syscall is used for program related manipulations like load and
> 
> bpf syscall is used for way more than that, actually...
> 
>> unload. Attaching that program to an object has a type unique solution -
>> e.g., netlink for XDP and ioctl for perf_events.
> 
> That's not true and hasn't been true for at least a while now. cgroup
> programs, flow_dissector, lirc_mode2 (whatever that is, I have no
> idea) are attached with BPF_PROG_ATTACH. raw_tracepoint and all the
> fentry/fexit/fmod_ret/freplace attachments are done also through bpf
> syscall. For perf_event related stuff it's done through ioctls right
> now, but with bpf_link unification I wouldn't be surprised if it will

and it always will be able to. Kernel uapi will not be revoked because a
new way to do something comes along.

> be done through the same LINK_CREATE command soon, as is done for
> cgroup and *other* tracing bpf_links. Because consistent API and
> semantics is good, rather than having to do it N different ways for N
> different subsystems.
> 

That's a bpf / libbpf centric perspective. What Toke and I are saying is
the networking centric perspective matters to and networking uses
netlink for configuration.
