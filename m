Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F422C9156
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387821AbgK3Wmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK3Wmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:42:39 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D769C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:41:53 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v22so18635463edt.9
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rm3tgOxI+WlLBy0skZtUOWuA912yRKMMImbbQLEVlNw=;
        b=IRW8a2+QkCO+0fBVuV65IoDfdargSZ5ovB4/WQmVx0ZmsQVPEN1uL2O4xNgVEUJfmQ
         A7/8Zc10KdqNU6nmXr5pu/SMhx97p2gl7zQDPfLRu9owIadL43TKPSUYWanXz/DlG8vt
         CO4bgjf314KpjmmEV7G1+tkhQmAnj0eblZg15huo67MlqPDtMfH+/3eGRXh/48qyiO+K
         nGi7AsLv/Uedz0htHebGcS31aI3Tr7eyCDSPTgz974YgeuHh8gypBbLVWIAnYe1KJ82G
         maxfB7xcRFOmlDebEGnUHwMptYGccS+99rDbZLIeSyZjD4t0tNcxHWyguNL2yPORGFsU
         h2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rm3tgOxI+WlLBy0skZtUOWuA912yRKMMImbbQLEVlNw=;
        b=Cw+eqGraTuQsklom1qr8Uy65GnrXMuOeZ30jrjcjYu65EaCwJUiTJB8SshKrr6a20g
         SsNlJskSZ7NEH19oArETdbyN2lQX2Arkgja+VVCAwtSRC4/QcfqQEjfKdyGkqri6yg9H
         qAvcIcZ74aVJn2ofE9jP/ozy2+7yURQfv610eHlms+Zv93FfLXl8sumXKfPr6+5FFX5r
         ZEMuzS36PevLX6Pp2xFf7/sxKLkNSxyZ+UTosc9TJX6sXsgsS+bRNonEheEV2BMblUK+
         cFLFdi6ZP64H0uFsTHmn3TnO0z9WntHR2qRbMu4hTfMPygbprvG4ELd5pYefVIyny+oi
         1OQg==
X-Gm-Message-State: AOAM531v0m9hFZ/VQE62s8mqNkKF2fReI1A1jJ3oHIR7HPumjrv93DVV
        +llqfaqRemA/ahlJ+blhwB4=
X-Google-Smtp-Source: ABdhPJzMrzFWO1JND5eaYXJL+CfiukzO95pxFyjdbWMei663WGbL9woK/fMKF/cvt23CcE818n3Zkg==
X-Received: by 2002:a05:6402:559:: with SMTP id i25mr24544666edx.128.1606776112133;
        Mon, 30 Nov 2020 14:41:52 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id g9sm5475246edw.67.2020.11.30.14.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 14:41:51 -0800 (PST)
Date:   Tue, 1 Dec 2020 00:41:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130224150.hwilti2lhh5mthyu@skbuf>
References: <20201130202626.cnwzvzc6yhd745si@skbuf>
 <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
 <20201130203640.3vspyoswd5r5n3es@skbuf>
 <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
 <20201130205053.mb6ouveu3nsts3np@skbuf>
 <CANn89i+D+7XyYi=x2UxCrMM72GeP3u5MB0-7xruOZJGrERJ5vQ@mail.gmail.com>
 <20201130211158.37ay2uvdwcnegw45@skbuf>
 <CANn89iJGA8qWBJ97nnNGNOuLNUYF5WPnL+qi722KYCD7kvKyCg@mail.gmail.com>
 <20201130215322.7arp3scumobdnvtz@skbuf>
 <CANn89i+rZx4vex5N1RQE=y3uzd9yCjHOu5_6phUpZGyVmfUPOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+rZx4vex5N1RQE=y3uzd9yCjHOu5_6phUpZGyVmfUPOg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 11:20:23PM +0100, Eric Dumazet wrote:
> On Mon, Nov 30, 2020 at 10:53 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Mon, Nov 30, 2020 at 10:46:00PM +0100, Eric Dumazet wrote:
> > > You can not use dev_base_lock() or RCU and call an ndo_get_stats64()
> > > that could sleep.
> > >
> > > You can not for example start changing bonding, since bond_get_stats()
> > > could be called from non-sleepable context (net/core/net-procfs.c)
> > >
> > > I am still referring to your patch adding :
> > >
> > > +       if (!rtnl_locked)
> > > +               rtnl_lock();
> > >
> > > This is all I said.
> >
> > Ah, ok, well I didn't show you all the patches, did I?
>
>
> Have you sent them during Thanksgiving perhaps ?
>
> I suggest you follow normal submission process, sending patch series
> rather than inlining multiple patches in one email, this is becoming
> hard to follow.

No, I did not post these at all formally for review, nor do I intend to.
I just wrote them "for fun" (if this could be called fun) to get an idea
of how much there is to change, in the "best case" where I do no rework
to the locking at all, just use what's currently available. And I can't
submit these patches as-is, because of lockdep warnings in bonding. I
will post patches formally for review when I have a clear migration
plan.
