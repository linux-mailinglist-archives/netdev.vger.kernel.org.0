Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81471253D62
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgH0GFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgH0GFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:05:01 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CADAC061246;
        Wed, 26 Aug 2020 23:05:01 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id q3so2317242ybp.7;
        Wed, 26 Aug 2020 23:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YS0E3x+rd6mFReNohPRwURMjsOh1VMEQF9vUanLTT/0=;
        b=IFTjQNtz4TH2ktM9bD6omTwK6z8gQvROWHXKbfocfX5JvTWo06Ms8/XrAlrIy3dtMZ
         8VJHbRmBi7VXDd4x7lDLd1u1yT/JX76vR3OHZBRrR0/Q0DtFLSb7KljcSSDEycOvMH+K
         qGEVrz42WL57VIifN8yGNgYfqDxdt5V9azJr3EW9JdUcF2s6UmFvanEl/WCh6/rQjjCF
         BuwbsvXjrxiJTyYgCSaDWHhCUFvhhnpRz5Aj7uPavBCLvAVQCwn3uOygMymfgKVydA9i
         mQO2Ru/0Iu2YMJ+6tgWb7kZZh2miNc8HUOKf4XogqPd6GpUyUMDCacl0OcjWALtiwarb
         JrPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YS0E3x+rd6mFReNohPRwURMjsOh1VMEQF9vUanLTT/0=;
        b=OpHFfK/GukplruU2rXg1Lw/dUSFVo7iKM1VnG0K6giv99VW/ehKme3CYsO9TF14FmK
         1H6AcoCxRplWJxZkkXUBUHacggfXU2kWCpUi1bFiPWi9WWP7X7XCazYK1+qCRk24m+HC
         Epk4nNj6RN++auzaebrQGoP6veghLMIKSX5KdUdG3LPuP3jl8+XVWf2UXcUbkQzBMeR0
         Lnw1hhfyzXVXZNQpGR0EjLlfmUAgIPTbAamFrMwfreR6yXEaIU1eDkR+lVJWuuoHIRuO
         kB4neczy/Y+f77dQOF3gV+AFEnb+GbW25ofTT+WB4YU8sB1kxQ9O5BVRmVEi+bo8JMAF
         qzrw==
X-Gm-Message-State: AOAM532vwMHsFe4QSGezFDiKXJphTS3wYmIgHUeqlyXZgCwwGYEbBf2O
        rbf3Ty5bbl9DfUQQ990k/xiT2w7cF/dY/cNLziE=
X-Google-Smtp-Source: ABdhPJxkd5AOFlyKfKZ9Ayi2ea1O8ksOJql6kpnE/JAyYTpEmJYhrmUoiUve3mvyb77ThYiXm979rJGxuQivakeUTxA=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr24534529ybk.230.1598508300269;
 Wed, 26 Aug 2020 23:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200825232003.2877030-1-udippant@fb.com> <20200825232003.2877030-3-udippant@fb.com>
In-Reply-To: <20200825232003.2877030-3-udippant@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Aug 2020 23:04:49 -0700
Message-ID: <CAEf4BzYsxBJf2a59L4EPKwX0eH2U7z41PSUgupwOWUXVH4sgYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] selftests/bpf: add test for freplace
 program with write access
To:     Udip Pant <udippant@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 4:21 PM Udip Pant <udippant@fb.com> wrote:
>
> This adds a selftest that tests the behavior when a freplace target program
> attempts to make a write access on a packet. The expectation is that the read or write
> access is granted based on the program type of the linked program and
> not itself (which is of type, for e.g., BPF_PROG_TYPE_EXT).
>
> This test fails without the associated patch on the verifier.
>
> Signed-off-by: Udip Pant <udippant@fb.com>
> ---
>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  1 +
>  .../selftests/bpf/progs/fexit_bpf2bpf.c       | 27 +++++++++++++++++++
>  .../selftests/bpf/progs/test_pkt_access.c     | 20 ++++++++++++++
>  3 files changed, 48 insertions(+)
>

[...]

> +__attribute__ ((noinline))
> +int test_pkt_write_access_subprog(struct __sk_buff *skb, __u32 off)
> +{
> +       void *data = (void *)(long)skb->data;
> +       void *data_end = (void *)(long)skb->data_end;
> +       struct tcphdr *tcp = NULL;
> +
> +       if (off > sizeof(struct ethhdr) + sizeof(struct ipv6hdr))
> +               return -1;
> +
> +       tcp = data + off;
> +       if (tcp + 1 > data_end)
> +               return -1;
> +       /* make modification to the packet data */
> +       tcp->check++;

Just FYI for all BPF contributors. This change makes test_pkt_access
BPF program to fail on kernel 5.5, which (the kernel) we use as part
libbpf CI testing. test_pkt_access.o in turn makes few different
selftests (see [0] for details) to fail on 5.5 (because
test_pkt_access is used as one of BPF objects loaded as part of those
selftests). This is ok, I'm blacklisting (at least temporarily) those
tests, but I wanted to bring up this issue, as it did happen before
and will keep happening in the future and will constantly decrease
test coverage for older kernels that libbpf CI performs.

I propose that when we introduce new features (like new fields in a
BPF program's context or something along those lines) and want to test
them, we should lean towards creating new tests, not modify existing
ones. This will allow all already working selftests to keep working
for older kernels. Does this sound reasonable as an approach?

As for this particular breakage, I'd appreciate someone taking a look
at the problem and checking if it's some new feature that's not
present in 5.5 or just Clang/verifier interactions (32-bit pointer
arithmetic, is this a new issue?). If it's something fixable, it would
be nice to fix and restore 5.5 tests. Thanks!

  [0] https://travis-ci.com/github/libbpf/libbpf/jobs/378226438

Verifier complains about:

; if (test_pkt_write_access_subprog(skb, (void *)tcp - data))

57: (79) r1 = *(u64 *)(r10 -8)

58: (bc) w2 = w1

59: (1c) w2 -= w9

R2 32-bit pointer arithmetic prohibited

processed 198 insns (limit 1000000) max_states_per_insn 1 total_states
8 peak_states 8 mark_read 7


> +       return 0;
> +}
> +
>  SEC("classifier/test_pkt_access")
>  int test_pkt_access(struct __sk_buff *skb)
>  {
> @@ -117,6 +135,8 @@ int test_pkt_access(struct __sk_buff *skb)
>         if (test_pkt_access_subprog3(3, skb) != skb->len * 3 * skb->ifindex)
>                 return TC_ACT_SHOT;
>         if (tcp) {
> +               if (test_pkt_write_access_subprog(skb, (void *)tcp - data))
> +                       return TC_ACT_SHOT;
>                 if (((void *)(tcp) + 20) > data_end || proto != 6)
>                         return TC_ACT_SHOT;
>                 barrier(); /* to force ordering of checks */
> --
> 2.24.1
>
