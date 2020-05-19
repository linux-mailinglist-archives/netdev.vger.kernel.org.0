Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EFB1D9C85
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgESQ0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729407AbgESQ0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:26:18 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7430BC08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:26:18 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id k5so346629lji.11
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhbRZ27gTq3LlamCeWaOIagumkyuEgHdNj01JBr2vyU=;
        b=a8S6FimrljQCYdqdMRjHudj5xuwSAYeW17sDBke8Wp/wO6Vv10u9cXvAcweW0ZSEYT
         O3hXN68ol8TooTR2xUI2YNd5y+PctNRhxhENJnhmYB+aBitMMtqsXQFMvUY86xEYH5PA
         jFICERjG8bgZGMW0GbVN6qDt50ZsFp9Lq9zCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhbRZ27gTq3LlamCeWaOIagumkyuEgHdNj01JBr2vyU=;
        b=VmNgLxPWPscysdAOLbvXtC41STz2rLNGVn0hC98casq/GSUL2SdytRVA8CQESM3e1N
         TOpB3VvNGHFaSiKycdPC7ZNnjH+CAf7Q88zmTVS4EMILA5X1Fe7pVVBhjoH5fkzx1RXE
         Vlcp8Kcpe/ejgcQshD5BQLf9FmYdH9wXTuqdhDPNf0HWbJIC/QEe4trXZNjQwc4BUUBK
         9I9Iy89Zgg9WH4jExlzUKP7eSrpf7aKxYNtgFStqzJrBBzUjWnkAuhQIRb+dU3s/EF+Z
         ayIXY4silaKdvgJFqUw4r0HkRtdJGVOZ1Q4eOAISMGIIItrujk3pUwXNByx4dmWd5RYG
         sbPQ==
X-Gm-Message-State: AOAM533AYF6JgALUQXxiyKRvjS9KP8duV+lZKejbBOHRsFJhmPWgKcMG
        91EOv9kax8svs9vkH2vWi2h3089xZJw=
X-Google-Smtp-Source: ABdhPJxa6LnBWoRgdmG1G+vOIIGdEc4K6bAbrA0AKJvZGwjTNt9kLd+Ap5y3EKzixZwrSCf90S3JMQ==
X-Received: by 2002:a2e:7c03:: with SMTP id x3mr134464ljc.113.1589905575399;
        Tue, 19 May 2020 09:26:15 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id u15sm3129285lfg.92.2020.05.19.09.26.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:26:14 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id k5so346335lji.11
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:26:13 -0700 (PDT)
X-Received: by 2002:a05:651c:1183:: with SMTP id w3mr128485ljo.265.1589905573160;
 Tue, 19 May 2020 09:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200519134449.1466624-1-hch@lst.de> <20200519134449.1466624-13-hch@lst.de>
In-Reply-To: <20200519134449.1466624-13-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 May 2020 09:25:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=whE_C2JF0ywF09iMBWtquEfMM3aSxCeLrb5S75EdHr1JA@mail.gmail.com>
Message-ID: <CAHk-=whE_C2JF0ywF09iMBWtquEfMM3aSxCeLrb5S75EdHr1JA@mail.gmail.com>
Subject: Re: [PATCH 12/20] maccess: remove strncpy_from_unsafe
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
> +       if (IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) &&
> +           compat && (unsigned long)unsafe_ptr < TASK_SIZE)
> +               ret = strncpy_from_user_nofault(dst, user_ptr, size);
> +       else
> +               ret = strncpy_from_kernel_nofault(dst, unsafe_ptr, size);

These conditionals are completely illegible.

That's true in the next patch too.

Stop using "IS_ENABLED(config)" to make very complex conditionals.

A clear #ifdef is much better if the alternative is a conditional that
is completely impossible to actually understand and needs multiple
lines to read.

If you made this a simple helper (called "bpf_strncpy_from_unsafe()"
with that "compat" flag, perhaps?), it would be much more legible as

  /*
   * Big comment goes here about the compat behavior and
   * non-overlapping address spaces and ambiguous pointers.
   */
  static long bpf_strncpy_from_legacy(void *dest, const void
*unsafe_ptr, long size, bool legacy)
  {
  #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
        if (legacy && addr < TASK_SIZE)
            return strncpy_from_user_nofault(dst, (const void __user
*) unsafe_ptr, size);
  #endif

        return strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
  }

and then you'd just use

        if (bpf_strncpy_from_unsafe(dst, unsafe_ptr, size, compat) < 0)
                memset(dst, 0, size);

and avoid any complicated conditionals, goto's, and make the code much
easier to understand thanks to having a big comment about the legacy
case.

In fact, separately I'd probably want that "compat" naming to be
scrapped entirely in that file.

"compat" generally means something very specific and completely
different in the kernel: it's the "I'm a 32-bit binary on a 64-bit
kernel" compatibility case.

Here, it's literally "BPF legacy behavior", not that kind of "compat" thing.

But that renaming is separate, although I'd start the ball rolling
with that "bpf_strncpy_from_legacy()" helper.

                Linus
