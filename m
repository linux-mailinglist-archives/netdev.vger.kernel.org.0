Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA5523C1F2
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHDWof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 18:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgHDWof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 18:44:35 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5329C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 15:44:34 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id i26so27749800edv.4
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 15:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2aXRxp8MASX06VdqPQp1YQMOvMPB5xzNRr/YeI2YrEo=;
        b=Bc1+ISJyUn5UHeIBtU8c+jNS6naISZLT/VsYl9AcCnNvq7wBA2t6zhrBeLwFhAx2Yi
         DmVgNI6TnLJYyHgkRCgA3jys2iVw4ugV3cEWLWxOQoVfV7+bBdGN0lFr0v3bsSfPCHdz
         CZZK7GzPtk+Uy29gR/qG6kublRphcM2HipfQD0QRNreY9QUrcLUnvmWbncgh4/An1CCw
         mutNn6DuMRMhr43vJSLT2PRJqKJRA89Ds/MY5G45ep+9t8OVhcG5RvGEotPGNYf03y8F
         p7+22Oi2IuNBcHNj0b6p8H+B4OD0D2vZ1jegWW+Jd/DYzDaCxLIpHRwDbXzAil4BNAzr
         tGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2aXRxp8MASX06VdqPQp1YQMOvMPB5xzNRr/YeI2YrEo=;
        b=Fgq32AmZO3UAC2mlWiaFfkSe9dGr5MQ2HONgkyRHXYgi9X0XMsV6PbCcrvuLluXy0X
         u2o34x+6AsUX3SneIy5Sn/q10EAwmgnb1eynf1BGQ8g3ecJFwIaqUzkrp5CV4bUjMKth
         LP/Gqkc356WoqwP9tOPNYHjumNiuu5+Ed1kEFmZvCGq9gLiTAaB7KMR46dlK8IQ5AGXj
         JdUSYvUFtnI7RTntz3XegMk7EWHirO997JF9Q8PEKmf2N78ZDq/PDOsqHTFkqMrTGCuJ
         NFT/QP2F3VWU696YZKqHLLrILHPGxKHVRRDZVTJA/t82rB3/swKTuX7ML4MWePB1W38q
         ln8Q==
X-Gm-Message-State: AOAM533Z5vrf/fmP0tbd/XUA/KwaTk5k8sf0m5ZWWJ2iR97pf7LL8JNI
        Imc1X412l/i2bq3vcDH1ZNG0E9l4
X-Google-Smtp-Source: ABdhPJypAVrFuZn/hGxI10Iqzqeo67sFI+/e3o23J/2/xHi4bZjBGnwaaiEc5VUBMvSSMJBUIoq+iA==
X-Received: by 2002:a05:6402:1e2:: with SMTP id i2mr177583edy.70.1596581073281;
        Tue, 04 Aug 2020 15:44:33 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id by3sm209057ejb.9.2020.08.04.15.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 15:44:32 -0700 (PDT)
Date:   Wed, 5 Aug 2020 01:44:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200804224430.qt4zc2vihz7zeks6@skbuf>
References: <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <20200804142708.zjos3b6jvqjj7uas@skbuf>
 <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
 <20200804192933.pe32dhfkrlspdhot@skbuf>
 <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
 <20200804194333.iszq54mhrtcy3hs6@skbuf>
 <CANn89iKxjxdiMdmFvz6hH-XaH4wNQiweo27cqh=W-gC7UT_OLA@mail.gmail.com>
 <20200804212421.e2lztrrg4evuk6zd@skbuf>
 <CANn89iKuVa8-piOf424HyiFZqTHEjFEGa7C5KV4TMWNZyhJzvQ@mail.gmail.com>
 <20200804223952.je4yacy57vt5qjwk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804223952.je4yacy57vt5qjwk@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 01:39:52AM +0300, Vladimir Oltean wrote:
> On Tue, Aug 04, 2020 at 03:29:05PM -0700, Eric Dumazet wrote:
> > On Tue, Aug 4, 2020 at 2:24 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Tue, Aug 04, 2020 at 01:36:56PM -0700, Eric Dumazet wrote:
> > > > On Tue, Aug 4, 2020 at 12:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > >
> > > > > On Tue, Aug 04, 2020 at 12:40:24PM -0700, Eric Dumazet wrote:
> > > > > > On Tue, Aug 4, 2020 at 12:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > > > >
> > > > > > > On Tue, Aug 04, 2020 at 07:54:18AM -0700, Eric Dumazet wrote:
> > > > > > > >
> > > > > > > > My 2013 commit was a bug fix, and hinted that in the future (eg in
> > > > > > > > net-next tree) the stop-the-bleed could be refined.
> > > > > > > >
> > > > > > > > +               /* Note: we might in the future use prio bits
> > > > > > > > +                * and set skb->priority like in vlan_do_receive()
> > > > > > > > +                * For the time being, just ignore Priority Code Point
> > > > > > > > +                */
> > > > > > > > +               skb->vlan_tci = 0;
> > > > > > > >
> > > > > > > > If you believe this can be done, this is great.
> > > > > > >
> > > > > > > Do you have a reproducer for that bug? I am willing to spend some time
> > > > > > > understand what is going on. This has nothing to do with priority. You
> > > > > > > vaguely described a problem with 802.1p (VLAN 0) and used that as an
> > > > > > > excuse to clear the entire vlan hwaccel tag regardless of VLAN ID. I'm
> > > > > > > curious because we also now have commit 36b2f61a42c2 ("net: handle
> > > > > > > 802.1P vlan 0 packets properly") in that general area, and I simply want
> > > > > > > to know if your patch still serves a valid purpose or not.
> > > > > > >
> > > > > >
> > > > > > I do not have a repro, the patch seemed to help at that time,
> > > > > > according to the reporter.
> > > > >
> > > > > Do you mind if I respectfully revert then? It's clear that the patch has
> > > > > loopholes already (it clears the vlan if it's hwaccel, but leaves it
> > > > > alone if it isn't) and that the proper solution should be different
> > > > > anyway.
> > > >
> > > > Clearly the situation before the patch was not good, it seems well
> > > > explained in the changelog.
> > > >
> > > > If you want to revert, you will need to convince the bug has been
> > > > solved in another way.
> > > >
> > > > So it seems you might have to repro the initial problem.
> > >
> > > What bug? What repro? You just said you don't have any.
> > 
> > Ask Steinar ?
> > 
> 
> Hi Steinar, do you have a reproducer for the bug that Eric fixed in
> commit d4b812dea4a2 ("vlan: mask vlan prio bits")?
> 
> Thanks,
> -Vladimir

The Google email address from the original report bounces back. Adding
another address found by searching for your name on netdev.
