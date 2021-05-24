Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCD838EB0D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhEXPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhEXO47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:56:59 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C774C061251;
        Mon, 24 May 2021 07:48:22 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id t17so17218237ljd.9;
        Mon, 24 May 2021 07:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2L7Zpcg8p9FlzlxJjyApthNnbGoirfbLWxVjf+T4ljE=;
        b=PQ+LlPvTXJj1NyUDyuw3i4B3ONPLHuPNd7pK/aCKciPsVv16ftfgWzbMEilSNX7oPV
         Gwj2foEHmlqil2rRBqTwCo5/GdrPdhGB9Mnybxl8gurIoDOegUyjERYFf79D6eB7cgEe
         eU1Uauv2vwfU/fY07eYEjS457ke3UZe67i4Ug9oBrK6N7jvMpaVyOzC9quaa7i5ESHR1
         2ph7kpKIcq9Lhb5CeYWMugf9iD0RbQ82n9QQUWOYCHe8PNs6REAki/WHGt6l1RD5x36Q
         K3x7VSBb64NlA9JUbV3wmKfGYDJuBLQXJqc8gQc8i4uOwCXJ0hbEHSElMqQUklSqCVl3
         sTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2L7Zpcg8p9FlzlxJjyApthNnbGoirfbLWxVjf+T4ljE=;
        b=XPnju/mA1uoGlc6fV2rMgQDSBZI/H9FL+IXMMaeAhlV7dcxwaLMxAiUwDnPiyw1Xmn
         a0FziuE3Yf2Iv4f1Re3duQAbVLO/bGhXq2kQCFCvG82+y6JXPwXAXiHL2oVzJd8nNDST
         PlO6vaSQUJ5n172h3/Z5gz81U+rkM84DFLv/0b8e6FnkT9+nwU8nFJeWP3FWCHj2lPF+
         zCAWpSsTaB6SSkC/GjdNZ/J7J5b8iu/bk899TveIURU4BXRuR+Z4Ba+s6yyK2NKrxL+T
         ipKO7x8TtdVEPobssyUmMdxPRMRlyGnZeBFl9Q7tvGLoUSL9PK1Jq9+Zg2jfhIa/JrCI
         P4WQ==
X-Gm-Message-State: AOAM532U3LxgEqoVMdl6y+90mClCE29yCeFygve7C6GI3ttftC0Nuc65
        aaBG70tCu8xX+2Jsr1sHaYmFpzAO26ITmX9/bCU=
X-Google-Smtp-Source: ABdhPJxTZuzZYmxKk6hptRhM6i525B9wtrVlcPfANsiVvX5uKztPynVr9gTnUuDkQ5jXVlZSeujEUFdkKntpDkf2uBU=
X-Received: by 2002:a2e:2f1d:: with SMTP id v29mr16978289ljv.44.1621867700520;
 Mon, 24 May 2021 07:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <87o8d1zn59.fsf@toke.dk> <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
 <CACAyw9_Vq6f7neqrgw6AjJBw7ELa+s7u12Vnt5Ueh49gaE2PQg@mail.gmail.com>
In-Reply-To: <CACAyw9_Vq6f7neqrgw6AjJBw7ELa+s7u12Vnt5Ueh49gaE2PQg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 May 2021 07:48:09 -0700
Message-ID: <CAADnVQKjMp7EE1iArtYKVnr=iSaOuynnuB09mEb-KAWHwzaVQw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 1:42 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Sun, 23 May 2021 at 16:58, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>
> ...
>
> >
> > msecs are used to avoid exposing jiffies to bpf prog, since msec_to_jiffies
> > isn't trivial to do in the bpf prog unlike the kernel.
>
> Isn't that already the case with bpf_jiffies64?

It's reading jiffies. To convert to time the prog needs HZ value.
The HZ is also accessible via kconfig special map type and libbpf magic,
but supplying jiffies as an end-time is an implementation detail.
Are you arguing that api should be exactly one-to-one to kernel
and force all progs to do bpf_jiffies64() + end_time/HZ ?
