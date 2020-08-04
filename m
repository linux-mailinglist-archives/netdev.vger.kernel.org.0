Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F35823C1F1
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 00:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgHDWj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 18:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgHDWj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 18:39:57 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17275C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 15:39:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l23so17348152edv.11
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 15:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kQt0LAHOwKUBIaYn6k9KuJYFsQK5HP1g2FeWaobbpio=;
        b=OZylKV6goEq84Z4fgSL5yDy58jpV4YAsBxhw3WYFaVjfRCbknk2QceTzXbjAcwsSbD
         DdZymS5iQ43mU5sLh3KJLZKfjD9YHHw+Yp63gBlg3IYE92GzGK/6X80Xpd57Ceb/q/QP
         0UzAygGNpF7l+ohhc+K5Lx5Ssa9+OOLKPXwnFQOoUW6p4KDn5VN8E6vLS2FbGdAFGLqU
         nTkhjbaT8GMC8kmGIW8ojd/QpxQWk9Go905EQzyKs0wUYKI6JXBYyoiQq+ozDHIyEtQV
         +2ut7PXaZFG9SUD79pPFxFZ/tK567GqbsK/PBfVtgJlOHGHe5nqPClWNftj6kcEgZKyX
         lR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kQt0LAHOwKUBIaYn6k9KuJYFsQK5HP1g2FeWaobbpio=;
        b=PkemzVix7zxbatuPtqeO6uvQVmgIZcLdMyoPDdpwBg3MoTY+CvNJBgEVEBQnc4kYkg
         awujBQ3PuutZ03KwYEsq1B35i53X/wBahiWrnXWVDpub9uNmzyHi7JEdHfEn+C23b3Nl
         HnsCoZ2Q2DzLkRW6WGaqkKnK5dXs7AAvPQf/kD7kOEFXlEX0D8SMvk+Gqj9fhlRfC7Ay
         5Hikmx46leMREMQeT30dR4gHHXWfViQkRAzFZoShIof55EzttVBaOxatH2ZY7lV5DJ52
         KQLwcWQxzPIJPbG4Lu9SgVRYm+Uqb/G67rXFXHVKJlSrMpaK1jUFuCFNhDBAue8uTdiF
         EiLg==
X-Gm-Message-State: AOAM533X0qsOV6ykXj30W0DwCmVSWvd0szghjbcvG0F5NdrT5/qASyRa
        AViLYqsoBTZmZ738XLSDpj0=
X-Google-Smtp-Source: ABdhPJyOzdXpEKooPPHNQ7yv5C46kNJlh3QDZniw8Bl/58GdJQt/yzzoAJsSdIJkUxcveN+gAqeHWw==
X-Received: by 2002:aa7:c382:: with SMTP id k2mr116404edq.249.1596580795650;
        Tue, 04 Aug 2020 15:39:55 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id m20sm181818ejk.90.2020.08.04.15.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 15:39:54 -0700 (PDT)
Date:   Wed, 5 Aug 2020 01:39:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "Steinar H. Gunderson" <sesse@google.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200804223952.je4yacy57vt5qjwk@skbuf>
References: <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <20200804142708.zjos3b6jvqjj7uas@skbuf>
 <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
 <20200804192933.pe32dhfkrlspdhot@skbuf>
 <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
 <20200804194333.iszq54mhrtcy3hs6@skbuf>
 <CANn89iKxjxdiMdmFvz6hH-XaH4wNQiweo27cqh=W-gC7UT_OLA@mail.gmail.com>
 <20200804212421.e2lztrrg4evuk6zd@skbuf>
 <CANn89iKuVa8-piOf424HyiFZqTHEjFEGa7C5KV4TMWNZyhJzvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKuVa8-piOf424HyiFZqTHEjFEGa7C5KV4TMWNZyhJzvQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 03:29:05PM -0700, Eric Dumazet wrote:
> On Tue, Aug 4, 2020 at 2:24 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Tue, Aug 04, 2020 at 01:36:56PM -0700, Eric Dumazet wrote:
> > > On Tue, Aug 4, 2020 at 12:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > >
> > > > On Tue, Aug 04, 2020 at 12:40:24PM -0700, Eric Dumazet wrote:
> > > > > On Tue, Aug 4, 2020 at 12:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, Aug 04, 2020 at 07:54:18AM -0700, Eric Dumazet wrote:
> > > > > > >
> > > > > > > My 2013 commit was a bug fix, and hinted that in the future (eg in
> > > > > > > net-next tree) the stop-the-bleed could be refined.
> > > > > > >
> > > > > > > +               /* Note: we might in the future use prio bits
> > > > > > > +                * and set skb->priority like in vlan_do_receive()
> > > > > > > +                * For the time being, just ignore Priority Code Point
> > > > > > > +                */
> > > > > > > +               skb->vlan_tci = 0;
> > > > > > >
> > > > > > > If you believe this can be done, this is great.
> > > > > >
> > > > > > Do you have a reproducer for that bug? I am willing to spend some time
> > > > > > understand what is going on. This has nothing to do with priority. You
> > > > > > vaguely described a problem with 802.1p (VLAN 0) and used that as an
> > > > > > excuse to clear the entire vlan hwaccel tag regardless of VLAN ID. I'm
> > > > > > curious because we also now have commit 36b2f61a42c2 ("net: handle
> > > > > > 802.1P vlan 0 packets properly") in that general area, and I simply want
> > > > > > to know if your patch still serves a valid purpose or not.
> > > > > >
> > > > >
> > > > > I do not have a repro, the patch seemed to help at that time,
> > > > > according to the reporter.
> > > >
> > > > Do you mind if I respectfully revert then? It's clear that the patch has
> > > > loopholes already (it clears the vlan if it's hwaccel, but leaves it
> > > > alone if it isn't) and that the proper solution should be different
> > > > anyway.
> > >
> > > Clearly the situation before the patch was not good, it seems well
> > > explained in the changelog.
> > >
> > > If you want to revert, you will need to convince the bug has been
> > > solved in another way.
> > >
> > > So it seems you might have to repro the initial problem.
> >
> > What bug? What repro? You just said you don't have any.
> 
> Ask Steinar ?
> 

Hi Steinar, do you have a reproducer for the bug that Eric fixed in
commit d4b812dea4a2 ("vlan: mask vlan prio bits")?

Thanks,
-Vladimir
