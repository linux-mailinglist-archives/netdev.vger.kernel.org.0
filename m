Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F2B2B1BC0
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 14:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgKMNRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 08:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgKMNRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 08:17:19 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7804AC0613D1;
        Fri, 13 Nov 2020 05:17:19 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p22so8119737wmg.3;
        Fri, 13 Nov 2020 05:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ic34olRO1gILB7gSPiIOtGJOG1ezfBO762HyFmKeo4c=;
        b=dXZWaDNCupkDEDcP1H9UDTiR9J/VrkhBgMPk4QKQYSvM7rxl3Qkp7dmVINcMV6c0aY
         9QxJXa4iVHj1Sl6wypkrImhD2uc/vSV9uA1GUk6UN+bfZYRxQl5pTSEOs34RMYdG6Gg2
         PDsWnYsc6qTKO+vPmAzLQ5pC8FXj549C6lV6wF0Zrs7zzbmovyDPZtu7PbFcYWR0EBF3
         1irRsmew9DFvezAFeKCtqp24f1iDIfjY3mdUoAIE8s8pwlSmB/CwKp+DjgMgWikjelum
         +HtwkJ21H+vqUwvcP8gHSaEsQLgrbrKo/gmmUMJphZGf9tJlwom8KzPrjZ1YO0yDjRS5
         /Cxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ic34olRO1gILB7gSPiIOtGJOG1ezfBO762HyFmKeo4c=;
        b=Fd3n4WoVbAQtJGncJRRXxhbav4olNZ8MqserHxlTwLMcMzkdaAOtnYgqICdd+f58BM
         KywwxbXCkZXwi6SOIJkTQe6wtZJoiTe9EIA4mUfWU3YsCV+Uig82HR+m55jI+0xK1ujs
         QHsj9BWrJJ06wtSiumH1FT10KXOsh7eRNi53YNZDiBX0RPt6/UmX9kqeHmYr4Uob6sT8
         dUxGelGxstDID9dZr3zHX1xghv8Cb5jrRCJ0dELST1hcAfr/7KfdToCs3hRe6owaJ7/d
         Dx2BWO6fBUvX4+gMaOR2iHXGNvGPXj3EplNTxuhK0F/OtTiyZWlbGdA0X5s+u+LmmnIy
         yk8g==
X-Gm-Message-State: AOAM5310aJyvyWihbntlVgVUujFRG12e9MUYR6qzYaSV7p+cMmoqVbuE
        Lyx+wEWYv3Vx6egUeoMidvFEp42yybkYpU7lbNI=
X-Google-Smtp-Source: ABdhPJyR9jcrE71G44eJv6n4mvmESr0CggEl3JIC2AlR0fXpd5EBaeDBh86nGWe0VRO7sJ0/vssfGi6UCiFOVKiI4D8=
X-Received: by 2002:a7b:c08e:: with SMTP id r14mr2592872wmh.165.1605273437363;
 Fri, 13 Nov 2020 05:17:17 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
 <e23c63dd-5f90-c273-615f-d5d67991529c@gmail.com>
In-Reply-To: <e23c63dd-5f90-c273-615f-d5d67991529c@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Nov 2020 14:17:04 +0100
Message-ID: <CAJ+HfNgDwsNP_yM1_NH066JUfqMNPc-Q-K_yxqDaCQztEtwuZA@mail.gmail.com>
Subject: Re: csum_partial() on different archs (selftest/bpf)
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 at 12:34, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 11/13/20 11:36 AM, Bj=C3=B6rn T=C3=B6pel wrote:
> > I was running the selftest/bpf on riscv, and had a closer look at one
> > of the failing cases:
> >
> >   #14/p valid read map access into a read-only array 2 FAIL retval
> > 65507 !=3D -29 (run 1/1)
> >
> > The test does a csum_partial() call via a BPF helper. riscv uses the
> > generic implementation. arm64 uses the generic csum_partial() and fail
> > in the same way [1]. arm (32-bit) has a arch specfic implementation,
> > and fail in another way (FAIL retval 131042 !=3D -29) [2].
> >
> > I mimicked the test case in a userland program, comparing the generic
> > csum_partial() to the x86 implementation [3], and the generic and x86
> > implementation does yield a different result.
> >
> > x86     :    -29 : 0xffffffe3
> > generic :  65507 : 0x0000ffe3
> > arm     : 131042 : 0x0001ffe2
> >
> > Who is correct? :-) It would be nice to get rid of this failed case...
> >
>
> There are all the same value :), they all fold to u16  0xFFE3
>
> Maybe the test needs a fix, there is a missing folding.
>

Ah, makes sense. Thank you!

Bj=C3=B6rn
