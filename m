Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AE947805C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 00:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhLPXOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 18:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237100AbhLPXOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 18:14:47 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1019AC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:14:47 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r11so1121190edd.9
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=leN4ToUWeqVpg13p/IoYSSc9DyWGdv7mnjoOFy505fA=;
        b=COuDndAPNxF03xXqhgRDDWsGpGVwE98zlgUtoZag+Bvzj95HCbj01dkwIw4vwaq6Ga
         N90PFU8P57pDst3A16Zcjrgo4vCie/DI4eGMjE6d8Yz7eednpxuVTAwOpZT5P4Mm5gtS
         FZasthLCwD2sDJi9uHxz6z7IxY1oGo92UTBL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=leN4ToUWeqVpg13p/IoYSSc9DyWGdv7mnjoOFy505fA=;
        b=EyvLcs3gR65eSv+t+xswR1z6td7kEx3a1CaBIPhx3ElIyjEOXtKf//L7CvUaU7ChTU
         N1TqY6tm6HFmDv1P9aaAq0vEPNlqSAMQsx6cILvi0f3zktuuBUzulKN4qaUt6NxgZas3
         afwatB6sCGnNh1rNiW78loKHiFPQHMnQ26PIBaEPI1BVOTfJvBXDoZFcevQPXy0zEf8K
         rIfF0Ps8uP8mYcAxQx/uny91a9Wk1j0DpIyZusZPfAxji9938dVzj1UBbpEnOY5Gh4jS
         rtinuKh1zjbJb+LG1VTxSQtW07z6jTWz2UUEZAicqXYDGybgcDgkzuYw0qidRzqaSx8l
         PzAw==
X-Gm-Message-State: AOAM530tlPkkdhU5Grsd9Rjv+ejimtvg02i0tA9ftndOeB2AsP0WwQ7J
        gFhXI9s2+RY/Ld/sDDj4/Mxj+0twgDlfrBb7bQU=
X-Google-Smtp-Source: ABdhPJxmGvkrRChOGEsap4RDEaEfHFWBNRwEJSmDiapzD+y6Lq1bVe6qxhYa6EeyOj/BgvqsAmMfMA==
X-Received: by 2002:a17:906:7688:: with SMTP id o8mr275977ejm.291.1639696485131;
        Thu, 16 Dec 2021 15:14:45 -0800 (PST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id k21sm2792023edo.87.2021.12.16.15.14.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 15:14:44 -0800 (PST)
Received: by mail-wm1-f45.google.com with SMTP id p18so437620wmq.5
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:14:44 -0800 (PST)
X-Received: by 2002:a05:600c:1d97:: with SMTP id p23mr157474wms.144.1639696483940;
 Thu, 16 Dec 2021 15:14:43 -0800 (PST)
MIME-Version: 1.0
References: <20211216213207.839017-1-kuba@kernel.org>
In-Reply-To: <20211216213207.839017-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Dec 2021 15:14:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=whayMx6-Z7j7H1eAquy0Svv93Tyt7Wq6Efaogw8W+WpoQ@mail.gmail.com>
Message-ID: <CAHk-=whayMx6-Z7j7H1eAquy0Svv93Tyt7Wq6Efaogw8W+WpoQ@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.16-rc6
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 1:32 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Relatively large batches of fixes from BPF and the WiFi stack,
> calm in general networking.

Hmm. I get a very different diffstat, and also a different shortlog
than the one you quote.

I do get the top commit you claim:

>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc6
>
> for you to fetch changes up to 0c3e2474605581375d808bb3b9ce0927ed3eef70:
>
>   Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-12-16 13:06:49 -0800)

But your shortlog doesn't contain

  Alexei Starovoitov (3):
        bpf: Fix extable fixup offset.
        bpf: Fix extable address check.
        selftest/bpf: Add a test that reads various addresses.

  Daniel Borkmann (7):
        bpf: Fix kernel address leakage in atomic fetch
        bpf, selftests: Add test case for atomic fetch on spilled pointer
        bpf: Fix kernel address leakage in atomic cmpxchg's r0 aux reg
        bpf, selftests: Update test case for atomic cmpxchg on r0 with pointer
        bpf: Fix signed bounds propagation after mov32
        bpf: Make 32->64 bounds propagation slightly more robust
        bpf, selftests: Add test case trying to taint map value pointer

  Kumar Kartikeya Dwivedi (1):
        selftests/bpf: Fix OOB write in test_verifier

  Magnus Karlsson (1):
        xsk: Do not sleep in poll() when need_wakeup set

  Paul Chaignon (2):
        bpf: Fix incorrect state pruning for <8B spill/fill
        selftests/bpf: Tests for state pruning with u32 spill/fill

and that seems to be the missing diffstat contents also.

It looks like your pull request was done without that last merge, even
though you do mention it as being the top of tree.

I've pulled this, because that last merge looks fine and intentional,
but I'd like you to double-check your workflow to see what happened to
give a stale diffstat and shortlog...

              Linus
