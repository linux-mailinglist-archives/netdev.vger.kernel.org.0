Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9CC259B8A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732559AbgIARDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729586AbgIAPUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 11:20:07 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AEEC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 08:20:06 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d18so1604973iop.13
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 08:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ge/+DxJ15Ua6HWzt57ivLu5/J7fl349A6GNKghGBc48=;
        b=AtMWvdlzwwyu1P5XIqLQoKsW/5MrUf0fZZ3rjuA9nIxDGzYk1+hiIsXN17FAzg8KM3
         IkoV7nJ0dd4VtHLUuSD3pkBP6Ig3VZd3FFYyZkK2eKz526VCSz2o5x7wia+06I+0NO60
         3HyYMyseHFimP0lcXYILtCAhyI87wgfqFsOXTnoaXvsFGrHaVgHewDv3+cTBb2dlCOxq
         F3DekR95KANdSEBlSUBS/0H3hzJnnKUVtC3WS7fXipRyFGK5ZBoS0O+Ig2rB/eAIpSvW
         NB336CVUKMPQJRjkvGdZPy2GQ9lcZ0Leme9VBfiKKxgD/mcUzHLM71qlpDoFKJjcE+pw
         MO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ge/+DxJ15Ua6HWzt57ivLu5/J7fl349A6GNKghGBc48=;
        b=k9uW0drtnlnBtCBaNq0uhrApMDqLJ5ZkFJeKXMyVoLkeF6LGoLWebAZZe2DmL2gYrQ
         S8UCIUuORy8TJCEsB7wrziBpQzjbAiFs+Amd8TjqiUmPV9gzrp0syRuM19pDbd5XyPh3
         znnwkiYX4wC97pL7sAsyfxv2rBeUjnC4nOsYlVUR4p4+faJycTExAA2RZvY64YOXgfn2
         nkagvnMW+rckGRVQqxxpi9MVzz2GX6qPSkF0ctvYoYld5wlYPkG9lQuJBsq1MYUn+GHf
         Uw5fcR1B6+n0D3Ar8iVKqoyLuCm/COKXqAR+A0Neq2zYVhTH5KLTMCk19pE+VFUyq0rg
         WPpw==
X-Gm-Message-State: AOAM5320JZmBstQztMU19xB/MKqOSpGWvAPfAI33yHtYSpO/R6NojSAG
        XPwxPnl3PskkF663af7DUNqT/2p+E/3TJylX7Rpuow==
X-Google-Smtp-Source: ABdhPJx/Q89NgOh0VXJempeQiPr1aHcPIYG1M/1O83JNyWFNS6esLspfeXt9U3yxfbBeUXq8jO2jGHrzluthJVmreM0=
X-Received: by 2002:a02:e47:: with SMTP id 68mr1864149jae.17.1598973605935;
 Tue, 01 Sep 2020 08:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200901064302.849-1-w@1wt.eu> <CA+icZUVvOArpuR=PJBg288pJmLmYxtgZxJOHnjk943e9M22WOQ@mail.gmail.com>
 <20200901145509.GC1059@1wt.eu>
In-Reply-To: <20200901145509.GC1059@1wt.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Sep 2020 17:19:54 +0200
Message-ID: <CANn89iJ87D3NXHk418Qeeuzr1ANp9STqMQtqdA_QyCpXL=24CQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] prandom_u32: make output less predictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 4:55 PM Willy Tarreau <w@1wt.eu> wrote:
>
> On Tue, Sep 01, 2020 at 04:41:13PM +0200, Sedat Dilek wrote:
> > I have tested with the patchset from [1].
> > ( Later I saw, you dropped "WIP: tcp: reuse incoming skb hash in
> > tcp_conn_request()". )
>
> Yes because it's a bit out of the cope of this series and makes sense
> even without these patches, thus I assume Eric will take care of it
> separately.

Yes, I am still pondering on this one and really there is no hurry.
