Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455F84038ED
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 13:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349267AbhIHLiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 07:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349173AbhIHLiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 07:38:17 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2A5C061757
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 04:37:10 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y13so3572845ybi.6
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 04:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qx6GQAMSO0U5K2BQS7wUUyyG/8gFYoHictTOXxfB8o4=;
        b=A0536G+j0jtXOcqV21wJGXr5MugvHCmfMYFaPbbAfqY2cCqPGj1LP9HTci4DIsP59v
         xc4w9yKVww+P4uzNGaHSfF6JxQXj+GIHlKm1cRtbcWs4voqWNl5G4BYhMBJeVXuz4FzT
         65CA5HQ6SddZlCIjGC2ZaqSKIyZ4u6BJsx9wE6gnXmZC3jdiEJ4kQQbwDBlN58qDhYR3
         JMW/PAvJwc6N7V2Pl3XjUs90V5re+pao++Br5lU16ZdSNuYEhqiRKgl1zYxl7Yi+A6o+
         TAe6Z80FxqJvTM9vAGzATZMLuTyAcX22vAcqQYtPG1s9CCtUXp8WRWWgXsihiVHXs3qX
         kw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qx6GQAMSO0U5K2BQS7wUUyyG/8gFYoHictTOXxfB8o4=;
        b=KMZ2bFcDoKO24Ga8ZRjkS4JyXvOOFK7xBh/5cCGR0DnwAoDP0xlT+a/yQiJmGce5zZ
         AbEo0LMR0dHyxtFNP+ZZq2B0OOV1+GIiLOltPpKgOpRFtryUBYWj1MB/KcS1G+HHq7US
         G5blaxgSerUrD+hXkibQ2DP7eiLcUZiSY46mElbIwOi42WTE3rVZr02tSLOLrzhBz6u1
         KdxG3PmoOxpd+nwHW8PLUB51YbMj17B+65NOAA07se3vYR64Bi/AoLYuvex9/WSu2wCU
         kxj3swYV2qnSIFb+av8683dUocD+U86Fol8O+0ZO+ydHWb3QZrLahhSKOmdeK5p37zMt
         bQeQ==
X-Gm-Message-State: AOAM5302h24GsQdtvKjcEp7d+2Irv9sLx3D6kVilvt39x4xje2ANe1Xj
        f4ZeBJoni185D66RZbEmBSEqAkEt+/lp4YRiPE4t5A==
X-Google-Smtp-Source: ABdhPJwPNsP/cmoVneQoRGDpwarZJpktJvAbCd/Xjm1YQ4xhRQIkRrKgikr8DWAh5SUZuN8hQx5+JnlNnXJr6PYJL1s=
X-Received: by 2002:a25:bb08:: with SMTP id z8mr4576585ybg.306.1631101029164;
 Wed, 08 Sep 2021 04:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <1631089206-5931-1-git-send-email-yangtiezhu@loongson.cn>
 <e05e7407-74bb-3ba3-aab7-f62ca16a59ba@iogearbox.net> <9d0ca1ba-b8e1-dc99-17f4-189571f33c97@loongson.cn>
In-Reply-To: <9d0ca1ba-b8e1-dc99-17f4-189571f33c97@loongson.cn>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Wed, 8 Sep 2021 13:36:58 +0200
Message-ID: <CAM1=_QR7jEKWCta6krttm9dTdXAa8HpDcp+eV5ufiUMbJ9SivA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Make actual max tail call count as MAX_TAIL_CALL_CNT
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, bjorn@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Paul Chaignon <paul@cilium.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 12:56 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> On 09/08/2021 04:47 PM, Daniel Borkmann wrote:
> > [ You have a huge Cc list, but forgot to add Paul and Johan who recently
> >   looked into this. Added here. ]
> >
> > On 9/8/21 10:20 AM, Tiezhu Yang wrote:
> >> In the current code, the actual max tail call count is 33 which is
> >> greater
> >> than MAX_TAIL_CALL_CNT, this is not consistent with the intended meaning
> >> in the commit 04fd61ab36ec ("bpf: allow bpf programs to tail-call other
> >> bpf programs"):
> >>
> >> "The chain of tail calls can form unpredictable dynamic loops therefore
> >> tail_call_cnt is used to limit the number of calls and currently is set
> >> to 32."
> >>
> >> Additionally, after commit 874be05f525e ("bpf, tests: Add tail call test
> >> suite"), we can see there exists failed testcase.
> >>
> >> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
> >>   # echo 0 > /proc/sys/net/core/bpf_jit_enable
> >>   # modprobe test_bpf
> >>   # dmesg | grep -w FAIL
> >>   Tail call error path, max count reached jited:0 ret 34 != 33 FAIL
> >>
> >> On some archs:
> >>   # echo 1 > /proc/sys/net/core/bpf_jit_enable
> >>   # modprobe test_bpf
> >>   # dmesg | grep -w FAIL
> >>   Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
> >>
> >> with this patch, make the actual max tail call count as
> >> MAX_TAIL_CALL_CNT,
> >> at the same time, the above failed testcase can be fixed.
> >>
> >> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> >> ---
> >>
> >> Hi all,
> >>
> >> This is a RFC patch, if I am wrong or I missed something,
> >> please let me know, thank you!
> >
> > Yes, the original commit from 04fd61ab36ec ("bpf: allow bpf programs
> > to tail-call
> > other bpf programs") got the counting wrong, but please also check
> > f9dabe016b63
> > ("bpf: Undo off-by-one in interpreter tail call count limit") where we
> > agreed to
> > align everything to 33 in order to avoid changing existing behavior,
> > and if we
> > intend to ever change the count, then only in terms of increasing but
> > not decreasing
> > since that ship has sailed.
>
> Thank you, understood.
>
> But I still think there is some confusion about the macro MAX_TAIL_CALL_CNT
> which is 32 and the actual value 33, I spent some time to understand it
> at the first glance.
>
> Is it impossible to keep the actual max tail call count consistent with
> the value 32 of MAX_TAIL_CALL_CNT now?

Yes. If the limit is 32 or 33 does not really matter, but there has to
be a limit. Since the actual limit has been 33, we don't want to break
any user space program relying on this value.

> At least, maybe we need to modify the testcase?

Before making any changes in the test or the BPF code, we need to
understand what the current behaviour actually is. Then we can make
the necessary changes to make everything consistent with 33.

> > Tiezhu, do you still see any arch that is not on 33
> > from your testing?
>
> If the testcase "Tail call error path, max count reached" in test_bpf is
> right,
> it seems that the tail call count limit is 32 on x86, because the testcase
> passed on x86 jited.

When I run the test_bpf.ko suite I get the following limits.

Interpreter: 33
JIT for arm{32,64}, mips, s390x, powerpc{32,64}, sparc: 33
JIT for x86-{32,64}: 32

However, there are also tail call tests in the selftests suite.
According to Paul those tests show that everything is consistent with
33 now. So, there seem to be a discrepancy between the test_bpf.ko
tests and the selftests.

I am trying to investigate this matter further, but so far I have only
been able to run the test_bpf.ko module for various archs in QEMU.
Link: https://github.com/almbladh/test-linux

I am currently working on getting the selftests to run in QEMU too,
using Buildroot. If you have a working setup for this, it would be
great if you could share that.

Thanks,
Johan

>
> > Last time Paul fixed the remaining ones in 96bc4432f5ad ("bpf,
> > riscv: Limit to 33 tail calls") and e49e6f6db04e ("bpf, mips: Limit to
> > 33 tail calls").
> >
> > Thanks,
> > Daniel
>
