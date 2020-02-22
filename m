Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7264E168F35
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 14:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgBVNuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 08:50:00 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40060 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbgBVNuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 08:50:00 -0500
Received: by mail-lj1-f194.google.com with SMTP id n18so5200040ljo.7
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 05:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=0+clKuYh7KPvWqzrnI6AakWzmOHJogBn0b1gTuFVo7o=;
        b=FvYszws9VA4gn8vxUjwgHHZiNH5agadj/BOL0SFYiK7f1ixMQMJQA7MchGJwkLDG0Q
         xClcRoOIoAROktIFwqQvhvwI/ChoVWu3jwE9GvMyhA02qZMTnJk7WGS3zqBqwZOOnsn7
         ++bHoFvvSJFFQ17KV2drIZA3Ky9NHw5cwXxrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=0+clKuYh7KPvWqzrnI6AakWzmOHJogBn0b1gTuFVo7o=;
        b=AOjcz77/gZH90Snwfo31mH8BchArjwj+UbNSTxKa/QHzGiW13EUBr6a4robinnS8K3
         FIa1YMQ/nfvXeARFmVNn7VkNN+fjXRnogW8+I4SoCzDAmjL8wZhk7QAStd30t1ho1e9B
         OSqp2RPCMBxtYEpJ2Tye/aj3Sj/GiqsWGe8A1XU1B4i6cLTIrwEvUKp845S5BXubg/1P
         WHFAputDtS+KjoQrB21Byyizamq4Ao60lAE52iMSWXIn+EPGRDKmEJx0n1ExoR26a0uI
         XgygggXwsRsO4s9MViVVE18iRQRsuWTaQLMUkgqJr8Iz1y0PlMrSvRybKbzGf0Qkz2ZZ
         fbtA==
X-Gm-Message-State: APjAAAUzIrJ/Cp1mv2LUWral+P23XZjV//FGuEg9h6nxY7k/sTAzSXyG
        BmbKC2A9zlaj2/ugspAdhCXuyg==
X-Google-Smtp-Source: APXvYqy09JWNZOnCO5lbS6bNZy01zOlQiTyFsElMSYd8XaJeRQWhmARC+4HQ62uci8x7lNZnk52Dow==
X-Received: by 2002:a2e:9110:: with SMTP id m16mr24874270ljg.140.1582379397071;
        Sat, 22 Feb 2020 05:49:57 -0800 (PST)
Received: from cloudflare.com (user-5-173-1-230.play-internet.pl. [5.173.1.230])
        by smtp.gmail.com with ESMTPSA id g25sm3265934ljn.107.2020.02.22.05.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 05:49:56 -0800 (PST)
References: <20200218171023.844439-1-jakub@cloudflare.com> <c86784f5-ef2c-cfd6-cb75-a67af7e11c3c@iogearbox.net> <CAADnVQJrsfpsT47SqyCTM6=MSkeMESZACZR12Kx+0kRGBnRbvg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v7 00/11] Extend SOCKMAP/SOCKHASH to store listening sockets
In-reply-to: <CAADnVQJrsfpsT47SqyCTM6=MSkeMESZACZR12Kx+0kRGBnRbvg@mail.gmail.com>
Date:   Sat, 22 Feb 2020 13:49:52 +0000
Message-ID: <87d0a668an.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Sat, Feb 22, 2020 at 12:47 AM GMT, Alexei Starovoitov wrote:
> On Fri, Feb 21, 2020 at 1:41 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> On 2/18/20 6:10 PM, Jakub Sitnicki wrote:
>> > This patch set turns SOCK{MAP,HASH} into generic collections for TCP
>> > sockets, both listening and established. Adding support for listening
>> > sockets enables us to use these BPF map types with reuseport BPF programs.
>> >
>> > Why? SOCKMAP and SOCKHASH, in comparison to REUSEPORT_SOCKARRAY, allow the
>> > socket to be in more than one map at the same time.
>> >
>> > Having a BPF map type that can hold listening sockets, and gracefully
>> > co-exist with reuseport BPF is important if, in the future, we want
>> > BPF programs that run at socket lookup time [0]. Cover letter for v1 of
>> > this series tells the full story of how we got here [1].
>> >
>> > Although SOCK{MAP,HASH} are not a drop-in replacement for SOCKARRAY just
>> > yet, because UDP support is lacking, it's a step in this direction. We're
>> > working with Lorenz on extending SOCK{MAP,HASH} to hold UDP sockets, and
>> > expect to post RFC series for sockmap + UDP in the near future.
>> >
>> > I've dropped Acks from all patches that have been touched since v6.
>> >
>> > The audit for missing READ_ONCE annotations for access to sk_prot is
>> > ongoing. Thus far I've found one location specific to TCP listening sockets
>> > that needed annotating. This got fixed it in this iteration. I wonder if
>> > sparse checker could be put to work to identify places where we have
>> > sk_prot access while not holding sk_lock...
>> >
>> > The patch series depends on another one, posted earlier [2], that has been
>> > split out of it.
>> >
>> > Thanks,
>> > jkbs
>> >
>> > [0] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
>> > [1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
>> > [2] https://lore.kernel.org/bpf/20200217121530.754315-1-jakub@cloudflare.com/
>> >
>> > v6 -> v7:
>> >
>> > - Extended the series to cover SOCKHASH. (patches 4-8, 10-11) (John)
>> >
>> > - Rebased onto recent bpf-next. Resolved conflicts in recent fixes to
>> >    sk_state checks on sockmap/sockhash update path. (patch 4)
>> >
>> > - Added missing READ_ONCE annotation in sock_copy. (patch 1)
>> >
>> > - Split out patches that simplify sk_psock_restore_proto [2].
>>
>> Applied, thanks!
>
> Jakub,
>
> what is going on here?
> # test_progs -n 40
> #40 select_reuseport:OK
> Summary: 1/126 PASSED, 30 SKIPPED, 0 FAILED
>
> Does it mean nothing was actually tested?
> I really don't like to see 30 skipped tests.
> Is it my environment?
> If so please make them hard failures.
> I will fix whatever I need to fix in my setup.

The UDP tests for sock{map,hash} are marked as skipped, because UDP
support is not implemented yet. Sorry for the confusion.

Having read the recent thread about BPF selftests [0] I now realize that
this is not the best idea. It sends the wrong signal to the developer.

I propose to exclude the UDP tests w/ sock{map,hash} by not registering
them with test__start_subtest at all. Failing them would indicate a
regression, which is not true. While skipping them points to a potential
problem with the test environment, which isn't true, either.

I'll follow up with a patch for this, if that sounds good to you.

[0] https://lore.kernel.org/bpf/20200220191845.u62nhohgzngbrpib@ast-mbp/T/#t
