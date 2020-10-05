Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D72E283DEC
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgJER6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 13:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbgJER6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 13:58:49 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B0FC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 10:58:48 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id r127so7405220lff.12
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 10:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQapKerqEPOfWjuVkuWjhpBPHOAY0WMdQww5oZQ+egs=;
        b=OXKb2fbfDYHdc1AbGUIMBgMPVh7d7kxEbrnogtA7tkBCFR9wFHBTnbowM3BhSEljnh
         UEswPIgw4X463SChT4PQxD9A/LlhUfYNQWfSbDf+C8TBTKfDBnzK13OEqez3jPckrVjv
         qUxSB2BhkFOZGyy2nFmMHm6nnRfP1HV8q//vo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQapKerqEPOfWjuVkuWjhpBPHOAY0WMdQww5oZQ+egs=;
        b=UdVfE0KT845xF4XreqthcY54d0nuxEKxUmLE7suAg7g5IKBcJTbvgHoufr6bBIuLE9
         CMOHpA+a0YvjSi28CDoepcxrNwzsYiDUrNuWH1J5Kr7RgyRoaYD35wtNe1olO11S2tSk
         OGRQCWAa/sfKPN1BxoH9nIeTIeuu5PA8c8XXs6VGaiEaNfVa/fj3fvgg6uDecDnE4Jj2
         icjFk8IctNskpjApVcwmkcg98TSj9PpM+CZoPqBAGEkam/GhLhdVi68KJwG+/XvptQV4
         tI4/Hw50e2aQEYFiuUVi4VD5BaJ6HzDyJ/X0WdC/1aHchBKobjbtA2VbG9DHnH9jORyb
         qAYQ==
X-Gm-Message-State: AOAM530tm5oP1g/o/qcgQ0XqEukMGP+tvitLSKZg9R6BgfWCQW2tcXg4
        0p9C4XO/WYaDjDllvMThGsKGt5oJfUwInQ==
X-Google-Smtp-Source: ABdhPJzDdyn2MBizx70R9j0QhYd33CFUUrBREUavcgFPCv1eEZciJLKMQZa4inI/QD3vPYtLbnjwhA==
X-Received: by 2002:a05:6512:52f:: with SMTP id o15mr185050lfc.381.1601920725869;
        Mon, 05 Oct 2020 10:58:45 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id v17sm130115lfr.42.2020.10.05.10.58.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 10:58:44 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id b22so11914103lfs.13
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 10:58:43 -0700 (PDT)
X-Received: by 2002:a19:414b:: with SMTP id o72mr224618lfa.23.1601920723274;
 Mon, 05 Oct 2020 10:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20201004131931.29782-1-trix@redhat.com>
In-Reply-To: <20201004131931.29782-1-trix@redhat.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 5 Oct 2020 10:58:31 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOrr7k73mOizNGxPxXQ=bHEMUbTtCnoEusj2vRAaRPufA@mail.gmail.com>
Message-ID: <CA+ASDXOrr7k73mOizNGxPxXQ=bHEMUbTtCnoEusj2vRAaRPufA@mail.gmail.com>
Subject: Re: [PATCH] wireless: mwifiex: fix double free
To:     trix@redhat.com
Cc:     amit karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        ndesaulniers@google.com, linville@tuxdriver.com,
        Nishant Sarmukadam <nishants@marvell.com>, rramesh@marvell.com,
        bzhao@marvell.com, Frank Huang <frankh@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 4, 2020 at 6:19 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> clang static analysis reports this problem:
>
> sdio.c:2403:3: warning: Attempt to free released memory
>         kfree(card->mpa_rx.buf);
>         ^~~~~~~~~~~~~~~~~~~~~~~

That's some interesting static analysis for a compiler.

> When mwifiex_init_sdio() fails in its first call to
> mwifiex_alloc_sdio_mpa_buffer, it falls back to calling it
> again.  If the second alloc of mpa_tx.buf fails, the error
> handler will try to free the old, previously freed mpa_rx.buf.
> Reviewing the code, it looks like a second double free would
> happen with mwifiex_cleanup_sdio().
>
> So set both pointers to NULL when they are freed.
>
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Signed-off-by: Tom Rix <trix@redhat.com>

For whatever it's worth:

Reviewed-by: Brian Norris <briannorris@chromium.org>
