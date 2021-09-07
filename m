Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF694030CC
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhIGWRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347525AbhIGWRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:17:34 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BCCC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:16:27 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id m4so80047ljq.8
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rI0WC20BXjVjzaeO3sQGxSjjHO4dQiVDCRLV5j9nGLk=;
        b=P75ZGmdgymFTaH6OHWYMs7eNE2c+mhXoEVHPp9EGFVi+KAgBuf5F4S4+vC681qLeb9
         GI81Qvv3LNNelXKtmfuR7j7Y2zB1QcDgmAnAWgRpVsoygPpZy6eTHzOY8aEX3ZL4jPGy
         Tm9dveI0XRCpGyaySxpy3h51e6LKbYY0x05Hw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rI0WC20BXjVjzaeO3sQGxSjjHO4dQiVDCRLV5j9nGLk=;
        b=UZIraOXBo6k2ylJiLaBduyf9CqtWKZe2WeBKr/QSnVjb8A7TCvBnJPomTV5Qq5xvKw
         ZS7Pa2in5ijHxlpAjfS+3r+UYYivVaPjLDeFh97JZjIi9zkuqdrW9ntoYcqHjHK+o/zw
         vGInsZpbdGtEqyK7oMeuyzHN4/sIum14w3/vV3iOu20Tq3Ts4phTw4TasZbVTMYJsqvj
         BOOnrWfDL0DuL1laxigHbxbVlUnffqUtsCD5ioAFcQjoBaXOHCaUPl6nUC7f4ExEe72k
         2VJKpvm2ZPNikd/fY7LerBfDtX+QYNh8e506stPUPNvn91ncdaND82tJxK3dc+2wWzio
         gImw==
X-Gm-Message-State: AOAM531EjIDpX+48ZlJF0FP0zBxurCZrAoLNOfn739z2ivKHXUzu0ifP
        sLtsqmd60FFmhhzx8AcZXwm3BjvoaT7JGJEy4Kw=
X-Google-Smtp-Source: ABdhPJxLC2QG6vYBT4UKpMF6spT5PUin9wSJ2PnEst37Kp+U9f6vTlXZlvK5vJQSnU+ilEclnIaNHA==
X-Received: by 2002:a2e:99d9:: with SMTP id l25mr325975ljj.217.1631052985098;
        Tue, 07 Sep 2021 15:16:25 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id s27sm18024lfs.234.2021.09.07.15.16.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 15:16:22 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id j12so72156ljg.10
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:16:22 -0700 (PDT)
X-Received: by 2002:a2e:8107:: with SMTP id d7mr371422ljg.68.1631052981640;
 Tue, 07 Sep 2021 15:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
In-Reply-To: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Sep 2021 15:16:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
Message-ID: <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 6, 2021 at 5:27 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> /builds/linux/net/ipv4/tcp.c: In function 'do_tcp_getsockopt.constprop':
> /builds/linux/net/ipv4/tcp.c:4234:1: error: the frame size of 1152

None of these seem to be new.

It looks like this is (yet another) example of some build testing that
just never cared about warnings.

Which was the exact problem that the new -Werror flag is all about.
All these build test servers that only go "ok, it built, never mind
all the warnings".

Everybody tells me that the build servers care about warnings.
Everything I actually see tells a very different story indeed.

              Linus
