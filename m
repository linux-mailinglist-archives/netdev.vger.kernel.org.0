Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC874BFF2
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfFSRla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:41:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39614 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbfFSRla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:41:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so104576pls.6
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+TIWmFG9D6KuYaPFIMfBgrrfumRxehwTCrylwENN8xU=;
        b=ogP3Zy3tnbLA3NRbrm8pfcXaJEJp4mx7LgYEInZBCECHgHYG2R6gOOeTzB9sArGh/8
         ZLxrMSPp0DuvAwLzLoqVDXbLLtJFzdRQI5yHswt7FVbzgzusC8aj9lzhMm6eU0Jjp3hO
         Wd4rGk8YJqq7zMH8YdE0vDIS+Ey36+/dsv5XmxIawSfzvtlswqgh9dvg1cQY6y5g+fd7
         Ljm6TTu4lb5w9MZijiRtayY+n+kwjLm8v2qNLVZeW4RrYwSJNtrwMJjRiVbH/VLi7wLA
         qlL91n+rf2jZMSWVyNzB/ccbhQ3qUOwFXKUyD3L6U5Xhsld0FKLR4gAsh27v5/ONYaAf
         7vlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+TIWmFG9D6KuYaPFIMfBgrrfumRxehwTCrylwENN8xU=;
        b=Dbmy8tuouwr71xYITgZ10U3Wi/RhIsSOXr+NnusRzd3B4QikP587Y05X30TiX/UGLE
         6XZdrtkR3aZnON0r+qTT5Z+awkiBavamizLQkB2eJntQKqdCfI+VRalWCMqmGFiVPZnG
         AhHsOCHRsXYFLX/cnvuioISxaMvqtd5KKHniHxLG3M2Q6MDb3ff0Ymw1iLnskgtnJUpc
         vZ46vwbA6GQ3Hydd7Po5+c5qLtVNWThTD4MUwhnWtrjjziNk3b5GYzHB1/wx6IVVdd34
         i7cWxuB+qBAbtcBG0qb3jcuPoimIV4txFzs5NEFRBYEpUk+IcsaOPzpZc43Us4gNasUW
         7GdQ==
X-Gm-Message-State: APjAAAXc64qPQ21S59SO8bRfwlp6mEaUYy6hxdTFZuuvC7MLLMrCEfmS
        /uMNeoTD52sr0/Z4YYZDpdJm7jnJ0CMSZuQbs5/kSA==
X-Google-Smtp-Source: APXvYqy+enr3Ts5pw8yfp3XBlK7WV6lAGqKMLC8GD484atRHugjWP233gEQrAu2FKMbtShYw2c3OSlB5XWLQw93/s54=
X-Received: by 2002:a17:902:b696:: with SMTP id c22mr115353335pls.119.1560966089069;
 Wed, 19 Jun 2019 10:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190618211440.54179-1-mka@chromium.org> <20190618230420.GA84107@archlinux-epyc>
 <CAKwvOd=i2qsEO90cHn-Zvgd7vbhK5Z4RH89gJGy=Cjzbi9QRMA@mail.gmail.com> <f22006fedb0204ad05858609bc9d3ed0abc6078e.camel@perches.com>
In-Reply-To: <f22006fedb0204ad05858609bc9d3ed0abc6078e.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 19 Jun 2019 10:41:17 -0700
Message-ID: <CAKwvOdkJCt7Du01e3LreLdpREPuZXWYnUad6WzqwO_o4i0yk7A@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
To:     Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 2:36 AM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2019-06-18 at 16:23 -0700, Nick Desaulniers wrote:
> > As a side note, I'm going to try to see if MAINTAINERS and
> > scripts/get_maintainers.pl supports regexes on the commit messages in
> > order to cc our mailing list
>
> Neither.  Why should either?

Looks like `K:` is exactly what I'm looking for.  Joe, how does:
https://github.com/ClangBuiltLinux/linux/commit/a0a64b8d65c4e7e033f49e48cc610d6e4002927e
look?  Is there a maintainer for MAINTAINERS or do I just send the
patch to Linus?

-- 
Thanks,
~Nick Desaulniers
