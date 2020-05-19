Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416791D9CD2
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgESQdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbgESQd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:33:29 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBE2C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:33:29 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u15so432516ljd.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TFvy+u64rADS0X9wXPVDcnjojb1U9iWCN3n097gO97s=;
        b=KITgpUd5bP2WD+I3Ft3adLmt6MH7MS4MFJexni61RXcXlzD9Gqjwa8Lmdkq9TYyfqS
         KL4aFjs9x04ZYvGYs2IsxZG5dgyhwKLIBJrjoMKhrn6xZPweQeBnKjN1RmntmQCr96TY
         jycjBR645lH/xqU7rOHokwZ9wup3usfS+9Z3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TFvy+u64rADS0X9wXPVDcnjojb1U9iWCN3n097gO97s=;
        b=fCwENjEdcn5tSuXaOG9J9Av/2wyG63jGO4LuEb926bKdLBIQfcbUmFlPNPpvSHS1nl
         KXxia0OdrCGhgDREGkibIHPQKNQuB86580qZTXWTjr44Ht36NSJgNjNECwtUXaWGBqUx
         yGocvgDyai7WzRt9mbNVjiUWlhbZcJ+k5nZYzRsCw6B/k6nWOrLyLY0seqs2zE3KfvTL
         hnmvabPoTLRPW42uVcUR1I+cBOBYieqyYcsRYPiT78FgXEgoFLHtPxThvyTlOTxBrCRz
         hcJg42s2Jygol6ddsHQkCauVKJ/TT/cOqFuAEqAN+vmE85UqPGjAkgynyR1t+PcDe0hk
         PZGw==
X-Gm-Message-State: AOAM5333zADidBAzrbtdEcTIOjDYvf4Ohqnk/ocK1ap89YcpRj0hbqD/
        ObY1GaSJzAMYrlIQJmIdyBtXcThvIWI=
X-Google-Smtp-Source: ABdhPJzgGv+zqGk65CviUE0cR6KElsIjQahICPi4FRs/6zqYNwsfvl0VRv+o7GOm1dO65FSmJldHVA==
X-Received: by 2002:a05:651c:3ce:: with SMTP id f14mr172832ljp.232.1589906004644;
        Tue, 19 May 2020 09:33:24 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id f24sm9244501lfc.43.2020.05.19.09.33.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:33:22 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id u15so432207ljd.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:33:22 -0700 (PDT)
X-Received: by 2002:a2e:9641:: with SMTP id z1mr145949ljh.201.1589906002260;
 Tue, 19 May 2020 09:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200519134449.1466624-1-hch@lst.de> <20200519134449.1466624-14-hch@lst.de>
In-Reply-To: <20200519134449.1466624-14-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 May 2020 09:33:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjg6v1NU31ku2aAMfX7Yu0oDKRvKeBJVGZFQB7AjcwhAA@mail.gmail.com>
Message-ID: <CAHk-=wjg6v1NU31ku2aAMfX7Yu0oDKRvKeBJVGZFQB7AjcwhAA@mail.gmail.com>
Subject: Re: [PATCH 13/20] maccess: always use strict semantics for probe_kernel_read
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
> +
> +       if (IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) &&
> +           compat && (unsigned long)unsafe_ptr < TASK_SIZE)
> +               ret = probe_user_read(dst, user_ptr, size);
> +       else
> +               ret = probe_kernel_read(dst, unsafe_ptr, size);
...
> -               ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
> +               if (IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) &&
> +                   (unsigned long)addr < TASK_SIZE) {
> +                       ret = probe_user_read(&c,
> +                               (__force u8 __user *)addr + len, 1);
> +               } else {
> +                       ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
> +               }
...
> +       if (IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) &&
> +           (unsigned long)src < TASK_SIZE) {
> +               return probe_user_read(dest, (__force const void __user *)src,
> +                               size);

If you can't make the conditional legible and fit on a single line and
make it obvious _why_ you have that conditional, just use a helper
function.

Either for just the conditional itself, or for the whole operation.
And at least for the bpf case, since you want the whole operation for
that error handling and clearing of the result buffer anyway, I
suspect it would be cleaner to have that kind of
"bpf_copy_legacy_nofault()" function or whatever.

(And see previous email why I dislike that "compat" naming in the bpf case)

                    Linus
