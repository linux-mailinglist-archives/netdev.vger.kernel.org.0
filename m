Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AD3258AA3
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgIAIqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIAIqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:46:30 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D818BC061244;
        Tue,  1 Sep 2020 01:46:29 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 109so508499otv.3;
        Tue, 01 Sep 2020 01:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=AGctBs2sDmt4ExjN4cAU8I9Yq9CZgsHUVhDgE0odfdA=;
        b=JZhdAwXLEqO1maNzgzV4iNSzNEsdWXMsuq8Diw3KiHENmdAXxVsghAgx+O6xiALh19
         oJs/xNEWE2efFDO0TbBhYIkpo6y3JlNi3ubrdWFjdwyqor0fpK/PVtAwW1HUENhn8SAC
         IspZ4Agdi2UA+OhTLiOCc5Mgh4sETgmKUV3S+gDKZ8DGccYff2LtHY/NNgL4sD47/pj0
         WR1I9UpVMfVhPVCsX9ldcPVEgpraD27ORyCtgPpTCWQuHnwqDJmcPBdsRUwlWTgDSCgb
         T71lBH4KkzC4vi70dIBAR3kVSchhk0wTDcs5yb7ncIPr9mheOcc0heDdjtsjPCxx0LWR
         aWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=AGctBs2sDmt4ExjN4cAU8I9Yq9CZgsHUVhDgE0odfdA=;
        b=I5SXWOcKvFBAGewDaMPif8HED1s2baNvGDsbLlujK4uxQcA1fXLzWWpRC4isL2Qob8
         S1XLqiJ9EMYyI3trivjnlg/7CH2nKBTkWB7AXn78aI/thpHN0QZDfHtlA7tHLr9T//rD
         x4g8M9QFDEXhWx+Jty1QIK3v/hmQlHCawVbI80GBMlXkezlPpGOZGvBJeHm3gmcrgqU1
         Z88J7JqmSuQ1uPAudaJAXpMWELOn8jdmVhWPJsiF4n9FxaPLI5e3Kc3BnnzlwBDJNEZ5
         7DhNDp3/iqZzUdIQRKfifAyU5osCf5aOEZJzQGywCBHWxKIRuiotXuOI3RP0Zs1n8YXU
         5K7A==
X-Gm-Message-State: AOAM531wHaMJnBGkJD6VjaTMo7lTyiPHXvnfVJj9tV5w2yX992RvqQaI
        iL/sCcXAlu7riJv40WTcKut9Km9sV8qlJniOkps=
X-Google-Smtp-Source: ABdhPJyWZ3NTRRvSNIT/KxkPbedzD1MVC9yAZ8pG2y47s/El3XH+OP4Ny2jbdlyovyKrMOnC3ftcc0CnlBfA7CT7NvU=
X-Received: by 2002:a9d:7656:: with SMTP id o22mr600508otl.109.1598949987882;
 Tue, 01 Sep 2020 01:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200901064302.849-1-w@1wt.eu> <20200901064302.849-2-w@1wt.eu>
 <CAKQ1sVM9SMYVTSZYaGuPDhQHfyEOFSxBL8PNixyaN4pR2PWMxQ@mail.gmail.com> <20200901083947.GB901@1wt.eu>
In-Reply-To: <20200901083947.GB901@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 1 Sep 2020 10:46:16 +0200
Message-ID: <CA+icZUXjDaoLG36X7Jd7i6=Ncf6xTm44qL7ZV+i7pmNgtLuJSA@mail.gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     Yann Ylavic <ylavic.dev@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 10:39 AM Willy Tarreau <w@1wt.eu> wrote:
>
> On Tue, Sep 01, 2020 at 10:33:40AM +0200, Yann Ylavic wrote:
> > On Tue, Sep 1, 2020 at 8:45 AM Willy Tarreau <w@1wt.eu> wrote:
> > >
> > > +/*
> > > + *     Generate some initially weak seeding values to allow
> > > + *     the prandom_u32() engine to be started.
> > > + */
> > > +static int __init prandom_init_early(void)
> > > +{
> > > +       int i;
> > > +       unsigned long v0, v1, v2, v3;
> > > +
> > > +       if (!arch_get_random_long(&v0))
> > > +               v0 = jiffies;
> > > +       if (!arch_get_random_long(&v1))
> > > +               v0 = random_get_entropy();
> >
> > Shouldn't the above be:
> >                   v1 = random_get_entropy();
> > ?
>
> Very good catch, many thanks Yann! Now fixed in my local tree.
>

Thanks for offering a new patchset, Willy.

Will you push the updated patchset to your prandom Git - for easy fetching?

Thanks.

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/
