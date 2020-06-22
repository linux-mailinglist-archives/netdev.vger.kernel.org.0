Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29A22032E0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgFVJH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgFVJHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:07:25 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96812C061794;
        Mon, 22 Jun 2020 02:07:24 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u13so18597462iol.10;
        Mon, 22 Jun 2020 02:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Q5S8rsZFww2RQBPdBUO2Ls9OyyX7I+zxItrTRXSG0Dc=;
        b=byUv3cY+AOOV8gBuW1AflMUjWv5hGVN35Q9Puu+2+t56nc7VxjmYosOJG1J+HkPYXS
         3TZxW1V6K6ebV03vKgzZrhV1bNWxEGJ5UehJHU4zA10lNahWo0JSu66sUiWH8hJRMcW8
         0cAibGMRjdGlKjMMTw4Nsxq4CiHO5PyxWYzhDwz1a7N+yvueYFxdG5WwKEsQxjotkVAA
         woFysNO8jzVb9O5LFFBPb3F5iLNRl/0IayvoEqgk8TZE6VLrmrSa8+XJdlpq9+29XBpc
         4s6HD3c4+svqyGMv4cn+41pcfMqBcYZ21Ep9jDMR6pCISERYGxSxKOue3BQZbSUIQcwi
         V2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Q5S8rsZFww2RQBPdBUO2Ls9OyyX7I+zxItrTRXSG0Dc=;
        b=cY6HEeSXp+AV7ry2wyjWEimpN0nkA6K0BeJVIFyVBkQXtL4ZM0WcjkmKIrkt7b95vz
         UNiqP4KV7o8Shkf7aHTwSpLvRO7cbZYvzrO1qvsjX9y/I0H2pjMepSmQsQgd36rC2ahA
         88VquX2pHcDsqhJeuCHsP14f9baGusPjyjruc+kTCPb4I/MkVvcCQf9XylNhSEuh9jv1
         ahsqDAb37FTk3+eeNamPG2ZIjbHRD6ag/Gl88FCC99s6nRwqEpkLK3FqPy6lnReczKZK
         o6Q7canfHcuiWV3Jz/wK7BnZUax+UqF4QqORpZXLfJg2XXlFmAc/ZZxVnO1g20QdUip8
         W3ow==
X-Gm-Message-State: AOAM530qYGiPJP7z2Or4q3Z6bhvbGTLyVdPJH0EsbrkS7HPOivJnuSBr
        4MAQwBflUEqPTLtaMzvOaUXUnEhxO/PoZIXDhjA=
X-Google-Smtp-Source: ABdhPJwOiPKxd4xAeSQ6KNxpRqMrnK69wq8YYDF8YwjNAfHrsblHFiobqwkDYYJqyfrnzy4dcsM3nJ1AWGyTJWxwexs=
X-Received: by 2002:a6b:780d:: with SMTP id j13mr18940211iom.66.1592816843974;
 Mon, 22 Jun 2020 02:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200620033007.1444705-1-keescook@chromium.org>
 <CA+icZUWpHRR7ukyepiUH1dR3r4GMi-s2crfwR5vTszdt1SUTQw@mail.gmail.com> <202006200854.B2D8F21@keescook>
In-Reply-To: <202006200854.B2D8F21@keescook>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 22 Jun 2020 11:07:14 +0200
Message-ID: <CA+icZUV-gBgUnrm6pF2MHWC2SnK_ZBatAa9VrEJ2VbdARi1YBw@mail.gmail.com>
Subject: Re: [PATCH v2 00/16] Remove uninitialized_var() macro
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mm@kvack.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 5:57 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Sat, Jun 20, 2020 at 09:03:34AM +0200, Sedat Dilek wrote:
> > On Sat, Jun 20, 2020 at 5:30 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > v2:
> > > - more special-cased fixes
> > > - add reviews
> > > v1: https://lore.kernel.org/lkml/20200603233203.1695403-1-keescook@chromium.org
> > >
> > > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > > (or can in the future), and suppresses unrelated compiler warnings
> > > (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> > > either simply initialize the variable or make compiler changes.
> > >
> > > As recommended[2] by[3] Linus[4], remove the macro.
> > >
> > > Most of the 300 uses don't cause any warnings on gcc 9.3.0, so they're in
> > > a single treewide commit in this series. A few others needed to actually
> > > get cleaned up, and I broke those out into individual patches.
> > >
> > > The tree is:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/uninit/macro
> > >
> > > -Kees
> > >
> >
> > Hi Kees,
> >
> > thanks for doing a v2 of your patchset.
> >
> > As I saw Jason Yan providing some "uninitialized_var() macro" patches
> > to the MLs I pointen him to your tree "v1".
>
> Thanks!
>
> > BTW, I have tested your "v1" against Linux v5.7 (see [1]) - just
> > yesterday with Linux v5.7.5-rc1.
> >
> > Is it possible to have a v2 of this patchset on top od Linux v5.7 - if
> > you do not mind.
>
> Since it's only going to be for post-v5.8, I'm fine skipping the v5.7
> testing. Mainly I'm looking at v5.8 and linux-next.
>
> Thanks for looking at it!
>

Thanks for the feedback.

"I knew you'd say that."
( Judge Dredd )

- Sedat -
