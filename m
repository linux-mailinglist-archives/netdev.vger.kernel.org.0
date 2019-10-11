Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E97D4571
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 18:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfJKQaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 12:30:23 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34263 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfJKQaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 12:30:23 -0400
Received: by mail-lj1-f194.google.com with SMTP id j19so10463904lja.1
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 09:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tMiHtB5ZlwenoYg0oyx0g7MXemkZFkoKB6mCSzMxar0=;
        b=WvTdQO3PPBIwZwj1t370syw4bWNuRNNu5X9kUBY4nmpGylmSdsm9EeaCjpU7Vnv8Yx
         RIBTnDZKFaNEeN2w5TKDtE/axPzbYs2ol1oaGAlHshlDH+Wbx81Cy8oDxPhDJcEJ+mEJ
         6/WqNX914YOM138DOaNAdg7ENVxoQn93vF7Gw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMiHtB5ZlwenoYg0oyx0g7MXemkZFkoKB6mCSzMxar0=;
        b=T46BVRSY3fgJ3/AOKed0+30LBS5YxSWVRSMOF1rFxQhyOBDKWgdWe13zSFjevUo4Zf
         WICyEzPkle3fi3S+n+QlOgqHuvBGfeDRDHUWe8QPphU0FTKJbEk6mKEHm7ASkYskJO/2
         fR8sWRBCio/8gRYGnBAPUv1FC26xlM8Z2xuCxQQ/O9q1UnJf4rjj/gZkGc7NOn8JBGEu
         1vzlAApbBrrgG7nFkdPAxIEpo2OOr06z60EatfIqB21oncVdZtfHf8cb2QQM0gIdteq7
         mWCjukgTclD7Eith1dSFMSIDxW+1LOy9X0s5u+t3SG0cEFQMbZglpszrxoydC2ZfS09q
         U9Ag==
X-Gm-Message-State: APjAAAVa0B3O7VlSxJiyHolNW8uGd0DZXvRiOeyfJJZD683JKATK3Ui2
        nfiPpkXD9+CfzN0Okl0CyX5B1F7EVBU=
X-Google-Smtp-Source: APXvYqzoj7ozLoc7Fe78FnAvEwepJENgRpuRvMVEv/hZYhvzeIMfaZAd2cxEL3WHiBRN2RVNA4Kp9Q==
X-Received: by 2002:a2e:9848:: with SMTP id e8mr9846845ljj.155.1570811421015;
        Fri, 11 Oct 2019 09:30:21 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id a8sm2081537ljf.47.2019.10.11.09.30.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2019 09:30:20 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id 72so7475444lfh.6
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 09:30:17 -0700 (PDT)
X-Received: by 2002:ac2:5924:: with SMTP id v4mr9294065lfi.29.1570811416172;
 Fri, 11 Oct 2019 09:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570292505.git.joe@perches.com>
In-Reply-To: <cover.1570292505.git.joe@perches.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 11 Oct 2019 09:29:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
Message-ID: <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
Subject: Re: [PATCH 0/4] treewide: Add 'fallthrough' pseudo-keyword
To:     Joe Perches <joe@perches.com>
Cc:     linux-sctp@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Machek <pavel@ucw.cz>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Shawn Landden <shawn@git.icu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 5, 2019 at 9:46 AM Joe Perches <joe@perches.com> wrote:
>
> Add 'fallthrough' pseudo-keyword to enable the removal of comments
> like '/* fallthrough */'.

I applied patches 1-3 to my tree just to make it easier for people to
start doing this. Maybe some people want to do the conversion on their
own subsystem rather than with a global script, but even if not, this
looks better as a "prepare for the future" series and I feel that if
we're doing the "fallthrough" thing eventually, the sooner we do the
prepwork the better.

I'm a tiny bit worried that the actual conversion is just going to
cause lots of pain for the stable people, but I'll not worry about it
_too_ much. If the stable people decide that it's too painful for them
to deal with the comment vs keyword model, they may want to backport
these three patches too.

            Linus
