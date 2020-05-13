Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C59A1D229A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgEMXDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731815AbgEMXDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:03:40 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF07C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 16:03:39 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f18so1370272lja.13
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 16:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wdZg4gkYTds/C4KUVy9erLK1Ch+WqNN+RvFMTseVuAg=;
        b=C1TcjV6OtJpa2YRiWAUnGcZZ/u09cBy851Mx94wSMSQa9VrdsWV1jVHW4P1sNrL8Bh
         F6WpmJ1tQWre2J0ca6Wb2LX04yqV6LxMJpd1Tpa6EPb8PrEYBkkbwpuLaAdO/BjmCZ2G
         9egVYPaqRVmuIV8Yift2HwrZ/fz1dHM99i9n0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wdZg4gkYTds/C4KUVy9erLK1Ch+WqNN+RvFMTseVuAg=;
        b=TBz6urHWRqQ7qg9jHmSHLnoXE/rEfshPIrIj+oabqTV0H+GmOsISE9jNpDHCBcyq/2
         4Erm0qTOOUtSQu5Kn7xAZPdf1uW5pYQMtvZyVTwt9hRRH+Jyr9VoWxfMNevayjIB/Wop
         hiAFQVS2VGIPXdtjo5ttAJpCzqY/gnYAf4UTcSL2L0ljtjS48EPHpoPR6FJJw2zSTikj
         xS+06cSOq95Lw16z2ohHawnxFSJ+g1ChP3s7H2rh5I3JfTPnjOHz2Y0mP7/fxm7auGiT
         3Ne6lnYYfqPIqjmiy1diZi24ub3YKa9bVH6xnpoetGqa12Df076Jirp0D8YVmvGTy3W9
         Yz8g==
X-Gm-Message-State: AOAM532gTe0UuhMpocz9tpMbR1Pn4lM65PTEvsrUPCYuVVdwnT6pYPPI
        j/DCfMLecXc5NNgPMBAmcfa8oJV+8nc=
X-Google-Smtp-Source: ABdhPJwPPF3dSRkFKq6HMTIHGQTCfi5mqCikCNUoVRkGT+6hS6+QQUY+aby6Tnianax1t3VmOGLH+Q==
X-Received: by 2002:a2e:81c7:: with SMTP id s7mr804745ljg.203.1589411017632;
        Wed, 13 May 2020 16:03:37 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id h20sm564404lfj.26.2020.05.13.16.03.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 16:03:36 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id h188so207673lfd.7
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 16:03:36 -0700 (PDT)
X-Received: by 2002:ac2:58c8:: with SMTP id u8mr1177915lfo.142.1589411015919;
 Wed, 13 May 2020 16:03:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-12-hch@lst.de>
 <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
 <20200513192804.GA30751@lst.de> <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
In-Reply-To: <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 13 May 2020 16:03:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiivWJ70PotzCK-j7K4Y612NJBA2d+iN6Rz-bfMxCpwjQ@mail.gmail.com>
Message-ID: <CAHk-=wiivWJ70PotzCK-j7K4Y612NJBA2d+iN6Rz-bfMxCpwjQ@mail.gmail.com>
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christoph Hellwig <hch@lst.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 3:36 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> It's used for both.

Daniel, BPF real;ly needs to make up its mind about that.

You *cannot* use ti for both.

Yes, it happens to work on x86 and some other architectures.

But on other architectures, the exact same pointer value can be a
kernel pointer or a user pointer.

> Given this is enabled on pretty much all program types, my
> assumption would be that usage is still more often on kernel memory than user one.

You need to pick one.

If you know it is a user pointer, use strncpy_from_user() (possibly
with disable_pagefault() aka strncpy_from_user_nofault()).

And if you know it is a kernel pointer, use strncpy_from_unsafe() (aka
strncpy_from_kernel_nofault()).

You really can't pick the "randomly one or the other guess what I mean " option.

                  Linus
