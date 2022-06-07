Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E96540079
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 15:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbiFGNxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 09:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiFGNxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 09:53:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16721839C;
        Tue,  7 Jun 2022 06:52:59 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w21so15646718pfc.0;
        Tue, 07 Jun 2022 06:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gtNkKx+/2unC1GVaVBioVyWR0yH6yoHaqdLuh5hJp/o=;
        b=lklB9Z7ui0Me1WyhjYW5weDEqwQWv8gVnvpq527Tlr5bK3xBk0ywRf88dv/fiV8LCG
         pnkP9WT+01Y5TWgpzuNXW4cU0VQ+E3QIHMeT8LgD1ffYSA6cG3ErnuC8megHSuDixfsA
         LuZZAzmgxRlYvV46AKXK4f8i//El4ofTh6swpXKah0qQnSQYTPKFMug1BGKHcmzOeOSw
         y4V4Z3R/ZkTXF5Mrl7RctK6oOeJyubpgTUFQxE6bg/WKUz7aTWHbNxs7fJvxYCZA2A09
         kESFLzVHB+r0Pyc6N1BUI8qhxwdVwJXYD3SKMxzmJXP15KF9Bcn0nCg6mWviJAvUFS9c
         dQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gtNkKx+/2unC1GVaVBioVyWR0yH6yoHaqdLuh5hJp/o=;
        b=rNUGicjL9hdZ55hFNYVuRAeI32qx6Q1Rq1S3MzP5XZ0EE99HaLE0370P34Dy2sX9p6
         UMMzXUaDrE9lL5CENNCxqfIckgvOEyy7Eur+UhUsDfYP00ir5WMrFhNtBQn0s9QLWKkh
         sLriJ92v6FMM7TrIVYllA8pBAjEKPwmm+1TxKts46A5TnJgIB7vxCZKrnBawaG0tDfQ7
         KjwFSL6KYktaCZXuNw2ldSB8bQUY+ODGrjGMx22tJnAv4QLDFfhX+eo24xoBA5niCyfS
         VOvoqkb8XYYzNH9JlNnY4AKRbh4tcbtrNqWG7yvhO+K+gQrpCOwF3cLJ4lbwrKmLiA9V
         w8JA==
X-Gm-Message-State: AOAM533OE6AoeHPRgpTTEtNPUSmFUegZL/65K6EWf79DVR5RQ1q9C7Ne
        Tw/pgYFAMYaKtJKDLG9m2dYIjOfT5a1mIeIsuBs=
X-Google-Smtp-Source: ABdhPJwgyPMmV4gJ8eqWucWYJU+x/bUw22ixxuGQjpgyb6+BKwhLLGQwDzXRcdzqSjCXz71BJYHbXqb6lsXgNVjkyFs=
X-Received: by 2002:a05:6a00:130e:b0:51b:c19c:44b0 with SMTP id
 j14-20020a056a00130e00b0051bc19c44b0mr29801979pfu.21.1654609979348; Tue, 07
 Jun 2022 06:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220606130130.2894410-1-alvin@pqrs.dk> <Yp4BpJkZx4szsLfm@shell.armlinux.org.uk>
 <20220606134708.x2s6hbrvyz4tp5ii@bang-olufsen.dk>
In-Reply-To: <20220606134708.x2s6hbrvyz4tp5ii@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 7 Jun 2022 10:52:48 -0300
Message-ID: <CAJq09z6YLza5v7fzfH2FCDrS8v8cC=B5pKg0_GiqX=fEYaGoqQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for ports
 with internal PHY
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Luiz, Russel:
> > >
> > > Commit a5dba0f207e5 ought to have had a Fixes: tag I think, because it
> > > claims to have been fixing a regression in the net-next tree - is that
> > > right? I seem to have missed both referenced commits when they were
> > > posted and never hit this issue personally. I only found things now
> > > during some other refactoring and the test for GMII looked weird to me
> > > so I went and investigated.
> > >
> > > Could you please help me identify that Fixes: tag? Just for my own
> > > understanding of what caused this added requirement for GMII on ports
> > > with internal PHY.
> >
> > I have absolutely no idea. I don't think any "requirement" has ever been
> > added - phylib has always defaulted to GMII, so as the driver stood when
> > it was first submitted on Oct 18 2021, I don't see how it could have
> > worked, unless the DT it was being tested with specified a phy-mode of
> > "internal". As you were the one who submitted it, you would have a
> > better idea.
> >
> > The only suggestion I have is to bisect to find out exactly what caused
> > the GMII vs INTERNAL issue to crop up.
>
> Alright, thanks for the quick response. Maybe Luiz has a better idea, otherwise
> I will try bisecting if I find the time.

I don't know. I just got hit by the issue after a rebase (sorry, I
don't know exactly from which commit I was rebasing).
But I did test the net (!-next) and left a working commit note. You
can diff 3dd7d40b43..a5dba0f20.
If I'm to guess, I would blame:

21bd64bd717de: net: dsa: consolidate phylink creation

Regards,

Luiz
