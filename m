Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73213D00E0
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhGTRHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhGTRHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 13:07:23 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8060C061766;
        Tue, 20 Jul 2021 10:47:59 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id b29so11046973ljf.11;
        Tue, 20 Jul 2021 10:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vUmdle0okeye9wG/MQSJUYKK/oNkAcQU0zrJ8K6htdI=;
        b=bGURyZRhWmst/CyxrE441Wy0VrDxP/9N0HUp8BLrY/7Bo4VgY+M5kThochgSE7OV7R
         v46ztMO6rt+/OI9yyC1iyBbLrP8KxsKIhnmUg4NwD05S5iPniXaEs0IIrVryP27jyg8d
         Ryq/Vm/EnscOs3ZqgWouzi+DNt6rhGDQ9nNOwl8xcQkVF3YzvSRiW+66WQJU2hMc2/iU
         8MPJysddUeExnZupHl4YW4Q6B040CVRleHdG5z0uyIaQSMEbHKkD11PAE4JXsRiAm5Ka
         64L8F+PauoiUd56ltr+B6k8AjBI8RcAxD7xM8qjpziLWxkaMI1xl0pdNExId2TmpLBE6
         H09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vUmdle0okeye9wG/MQSJUYKK/oNkAcQU0zrJ8K6htdI=;
        b=EeKfziqVHxFr2haVbSLGPzGtE+6jrq8oEnuWAHPH5lSVioykaV/FYaO2P2RbI3GN27
         Fp+Ur9LPl449KIhU66tlxci60YxMDk6MMDpwbOWudmqmZvDPGJLGANLE8RtfuiRr0zBp
         Nxw/6egfl7mj5gZg51JWuc57G5SbFkeKxkyfQeZEIHYWZyPf+Ir58V6nfq6Ttk4RrzdY
         V8UxybYYt/DMBD0e+DvEf27KE0XLGxtSoSB3dPjqIYdf/abQhh7KGxkTsR+4dPUvimYs
         sxnm2Jw+2mslDqLYzx07UD7kTl8brxETvE85NQeAC12Y6md6wKKMwENkIqG3uditp+s/
         /fOQ==
X-Gm-Message-State: AOAM532N9bQ2GoQPzuIHwrdQLY3kyeec8GcFoWtp5zHw0X+J5aLG3W3F
        Uy/a0+X/mdMM8KZ03OH54hntllFE7uMPVdCMPSk=
X-Google-Smtp-Source: ABdhPJzbmeNAF0zBbShQOnE3KRREeAQLMAorAb2p3hcXaGq5CM5Vt1aSfKRcfRhigveNTRfu1XrHKW/w7ivq6N6PnKk=
X-Received: by 2002:a05:651c:32e:: with SMTP id b14mr2282131ljp.258.1626803278013;
 Tue, 20 Jul 2021 10:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <CAM1=_QR-siQtH_qE1uj4J_xw-jWwcRZrLL2hxK462HOwDV1f8A@mail.gmail.com>
In-Reply-To: <CAM1=_QR-siQtH_qE1uj4J_xw-jWwcRZrLL2hxK462HOwDV1f8A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 20 Jul 2021 10:47:46 -0700
Message-ID: <CAADnVQJ1uvLm6JC-qUp_owQy-A9N-SyVp1Yim3QHaREo4JArgQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v1 00/14] MIPS: eBPF: refactor code, add
 MIPS32 JIT
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-mips@vger.kernel.org,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 6:25 PM Johan Almbladh
<johan.almbladh@anyfinetworks.com> wrote:
>
> I have been focusing on the code the last couple of weeks so I didn't
> see your email until now. I am sure that this comes as much of a
> surprise to you as it did to me. Anyway, can send a patch with my JIT
> implementation tomorrow.

It is surprising to have not one but two mips32 JITs :)
I really hope you folks can figure out the common path forward.
It sounds to me that the register mapping choices in both
implementations are the same (which would be the most debated
part to agree on).
Not seeing Johan's patches it's hard to make any comparison.
So far I like Tony's patches. The refactoring and code sharing is great.

Tony,
what 'static analysis' by the JIT you're referring to?
re: bpf_jit_needs_zext issue between JIT and the verifier.
It's a difficult one.
opt_subreg_zext_lo32_rnd_hi32() shouldn't depend on JIT
(other than bpf_jit_needs_zext).
But you're setting that callback the same way as x86-32 JIT.
So the same bug should be seen there too.
Could you double check if it's the case?
It's either a regression (if both x86-32 and mips32 JITs fail
this test_verifier test) or endianness related (if it's mip32 JIT only).

Thank you both for the exciting work!
