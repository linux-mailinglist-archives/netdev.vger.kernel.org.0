Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A121D9C05
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgESQIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729327AbgESQIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:08:17 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFBEC08C5C2
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:08:16 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z18so273095lji.12
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yx5q8kTLmBrxy32bs18zizlzOjtx0vFts57BKijzI48=;
        b=HCXGSXVripfdjF3MiGwI8HqE63+BVnW9g3cwRZiRc5Emx+jBu6A4Nsobp13SbpFd6U
         Lyt8wvpLjFnfI845wbjgkTVZflwu9OTBrRm/9vher3ASfX9/MH65gZZ8ahxQbI/5jnLa
         wMfTgbalXvP1B/G3Ib0nnbu0+sXLvWt0bQgfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yx5q8kTLmBrxy32bs18zizlzOjtx0vFts57BKijzI48=;
        b=sMjqFvlJ8/4U+L/F8INNdRJJHTysDmID6+84PoAwUU0+X/EZBbutBsgKd11IVhxrLK
         o29Wj9AU6042Eu+ikob41cRGTmpr3YbHKizB4KGWhy6eSTh+3RLfc4qHGYQ16PyX21+m
         0z1vRyi3o6boGOUi61MhzEZ8iCA+g1J5Vgb9pAmeIVJhHycrGJMzR3QiarlisxB+KjYL
         65WkhTK5ftBB08tThNwsBIYc0zuCAao2fbphBceYrs1gIu7bmBHFZrujOORFbWGZpnHo
         5qwzLAr6vV1H0M8bChvrr2nQljvXP9OE9/fWjwrQev1WybXwouI1NdZd893B2aBMT3Qu
         kI1A==
X-Gm-Message-State: AOAM533qpLdpuMBLj/Fd9a6FVLSfv87/rk8DVCtH0moNAlD1/r5vbYZM
        wmy+GHRYZTQVuv9I6aQ+2BRsXXXCrJ8=
X-Google-Smtp-Source: ABdhPJyJOMBGebnIbDQZ5PmDPDeqH3Ym+fu8U5sPQbeI06tquEBpBg6nOerCaCXddXloRWSPNmTn9w==
X-Received: by 2002:a2e:5451:: with SMTP id y17mr123080ljd.6.1589904493715;
        Tue, 19 May 2020 09:08:13 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id 26sm41424ljp.22.2020.05.19.09.08.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:08:12 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 82so11760lfh.2
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:08:12 -0700 (PDT)
X-Received: by 2002:ac2:5a0a:: with SMTP id q10mr1343727lfn.142.1589904491650;
 Tue, 19 May 2020 09:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200519134449.1466624-1-hch@lst.de> <20200519134449.1466624-12-hch@lst.de>
In-Reply-To: <20200519134449.1466624-12-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 May 2020 09:07:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjm3HQy_awVX-WyF6KrSuE1pcFRaNX_XhiLKkBUFUZBtQ@mail.gmail.com>
Message-ID: <CAHk-=wjm3HQy_awVX-WyF6KrSuE1pcFRaNX_XhiLKkBUFUZBtQ@mail.gmail.com>
Subject: Re: [PATCH 11/20] bpf: factor out a bpf_trace_copy_string helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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

On Tue, May 19, 2020 at 6:45 AM Christoph Hellwig <hch@lst.de> wrote:
>
> +       switch (fmt_ptype) {
> +       case 's':
> +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +               strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
> +               break;
> +#endif
> +       case 'k':
> +               strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);
> +               break;

That 's' case needs a "fallthrough;" for the overlapping case,
methinks. Otherwise you'll get warnings.

                  Linus
