Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B64449E85
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbhKHV7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbhKHV7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 16:59:47 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728E4C061714
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 13:57:02 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id x10so6588624ioj.9
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 13:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IyGf++HsWcdR0ymSOyyo/gWpZRHRvO1oI0zO4vspMsM=;
        b=vxq3lixp9fobI0QzIjgaBfyTNzcjBFCqjPFMT9q8ZIzecvofrDZrKxAizDBFdDfv+F
         g70nVh91i1SsL3SMGp3c67MSsc8JePmGGQswMAlq5y3wdFmGGtP+O5/jb4NOLQ8pubhb
         mNrTtlAt73JwpyetbertCAmiPUNaxjm08rAqhg95CCKkVv48j1+k6C68Y8a9u6a4Vodd
         VcR54w/nl7yE1zyi02caL2e7lKQl+N0+fKlvfniLYhtjGjSF5Ha7ZEmFfJGrICGGrKgl
         dwj+1tOJZ6fU+1ncBBwJzq368AZ0yEPI+pJhgmtyehm2pZ0CpMqCfamZgBLhc50txefc
         GzTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IyGf++HsWcdR0ymSOyyo/gWpZRHRvO1oI0zO4vspMsM=;
        b=ILA/iGPS7sFsGXfpPRTn3tw9g6yqTG+LiS+LpPgq5CYkrxR5lUSe01VL8oCYqEfvAX
         0p2+ap4YuwVgz8JWhStasMyXzL+0k0xBUyLPDz57cvoxJEMC4iz2oWvuyzuGuva6UqDq
         GqjKDmx3PTI4oG/ZmrBBbJ6f2QzyhHMTczmWcHPUlefDys9kJyx1LKeYMrYFvp36EwEW
         vnvEVmx6S8XyZKbWDv0KTnaBhcfZPlbJlVBNKOkbt3bAUDmYPWKKqakydkfmMhgJh3+3
         3G1uD2AdDiYwXOkOMHIuCpbuDQG9uL1wtdasiUpU8l9UtWAxVQ1M7lALlHfj2wrdizN5
         ELtA==
X-Gm-Message-State: AOAM530dguN30epLFC5bNI0sDBcP2UStWjBuMixrcl2Sesr9+/GFzfHi
        eCVAFBcPhn5IXUkzcTewV/8UvijxVPNSmqY+4BiqVQ==
X-Google-Smtp-Source: ABdhPJyMnKqnGU/0YhS5Ftnk/li3m9IYAYdQEY80Cy39T1Z2o0Yu2pYt5BKdf+TDte2XbO+gf0JWOmA0aOSxTUXVAq4=
X-Received: by 2002:a02:c901:: with SMTP id t1mr1832807jao.132.1636408621835;
 Mon, 08 Nov 2021 13:57:01 -0800 (PST)
MIME-Version: 1.0
References: <20211104124927.364683-1-robert.marko@sartura.hr>
 <20211108202058.th7vjq4sjca3encz@skbuf> <CA+HBbNE_jh_h9bx9GLfMRFz_Kq=Vx1pu0dE1aK0guMoEkX1S5A@mail.gmail.com>
 <20211108211811.qukts37eufgfj4sc@skbuf> <CA+HBbNGvg43wMNbte827wmK_fnWuweKSgA-nWW+UPGCvunUwGA@mail.gmail.com>
 <20211108214613.5fdhm4zg43xn5edm@skbuf>
In-Reply-To: <20211108214613.5fdhm4zg43xn5edm@skbuf>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Mon, 8 Nov 2021 22:56:51 +0100
Message-ID: <CA+HBbNEKOW3F6Yu=OV3BDea+KKNH6AEUMS07az6=62aEAKHGgw@mail.gmail.com>
Subject: Re: [net-next] net: dsa: qca8k: only change the MIB_EN bit in
 MODULE_EN register
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabor Juhos <j4g8y7@gmail.com>, John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 8, 2021 at 10:46 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 08, 2021 at 10:39:27PM +0100, Robert Marko wrote:
> > On Mon, Nov 8, 2021 at 10:18 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Mon, Nov 08, 2021 at 10:10:19PM +0100, Robert Marko wrote:
> > > > On Mon, Nov 8, 2021 at 9:21 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > >
> > > > > Timed out waiting for ACK/NACK from John.
> > > > >
> > > > > On Thu, Nov 04, 2021 at 01:49:27PM +0100, Robert Marko wrote:
> > > > > > From: Gabor Juhos <j4g8y7@gmail.com>
> > > > > >
> > > > > > The MIB module needs to be enabled in the MODULE_EN register in
> > > > > > order to make it to counting. This is done in the qca8k_mib_init()
> > > > > > function. However instead of only changing the MIB module enable
> > > > > > bit, the function writes the whole register. As a side effect other
> > > > > > internal modules gets disabled.
> > > > >
> > > > > Please be more specific.
> > > > > The MODULE_EN register contains these other bits:
> > > > > BIT(0): MIB_EN
> > > > > BIT(1): ACL_EN (ACL module enable)
> > > > > BIT(2): L3_EN (Layer 3 offload enable)
> > > > > BIT(10): SPECIAL_DIP_EN (Enable special DIP (224.0.0.x or ff02::1) broadcast
> > > > > 0 = Use multicast DP
> > > > > 1 = Use broadcast DP)
> > > > >
> > > > > >
> > > > > > Fix up the code to only change the MIB module specific bit.
> > > > >
> > > > > Clearing which one of the above bits bothers you? The driver for the
> > > > > qca8k switch supports neither layer 3 offloading nor ACLs, and I don't
> > > > > really know what this special DIP packet/header is).
> > > > >
> > > > > Generally the assumption for OF-based drivers is that one should not
> > > > > rely on any configuration done by prior boot stages, so please explain
> > > > > what should have worked but doesn't.
> > > >
> > > > Hi,
> > > > I think that the commit message wasn't clear enough and that's my fault for not
> > > > fixing it up before sending.
> > >
> > > Yes, it is not. If things turn out to need changing, you should resend
> > > with an updated commit message.
> > >
> > > > MODULE_EN register has 3 more bits that aren't documented in the QCA8337
> > > > datasheet but only in the IPQ4019 one but they are there.
> > > > Those are:
> > > > BIT(31) S17C_INT (This one is IPQ4019 specific)
> > > > BIT(9) LOOKUP_ERR_RST_EN
> > > > BIT(10) QM_ERR_RST_EN
> > >
> > > Are you sure that BIT(10) is QM_ERR_RST_EN on IPQ4019? Because in the
> > > QCA8334 document I'm looking at, it is SPECIAL_DIP_EN.
> >
> > Sorry, QM_ERR_RST_EN is BIT(8) and it as well as LOOKUP_ERR_RST_EN should
> > be exactly the same on QCA833x switches as well as IPQ4019 uses a
> > variant of QCA8337N.
> > >
> > > > Lookup and QM bits as well as the DIP default to 1 while the INT bit is 0.
> > > >
> > > > Clearing the QM and Lookup bits is what is bothering me, why should we clear HW
> > > > default bits without mentioning that they are being cleared and for what reason?
> > >
> > > To be fair, BIT(9) is marked as RESERVED and documented as being set to 1,
> > > so writing a zero is probably not very smart.
> > >
> > > > We aren't depending on the bootloader or whatever configuring the switch, we are
> > > > even invoking the HW reset before doing anything to make sure that the
> > > > whole networking
> > > > subsystem in IPQ4019 is back to HW defaults to get rid of various
> > > > bootloader hackery.
> > > >
> > > > Gabor found this while working on IPQ4019 support and to him and to me it looks
> > > > like a bug.
> > >
> > > A bug with what impact? I don't have a description of those bits that
> > > get unset. What do they do, what doesn't work?
> >
> > LOOKUP_ERR_RST_EN:
> > 1b1:Enableautomatic software reset by hardware due to
> > lookup error.
> >
> > QM_ERR_RST_EN:
> > 1b1:enableautomatic software reset by hardware due to qm
> > error.
> >
> > So clearing these 2 disables the built-in error recovery essentially.
> >
> > To me clearing the bits even if they are not breaking something now
> > should at least have a comment in the code that indicates that it's intentional
> > for some reason.
> > I wish John would explain the logic behind this.
>
> That sounds... aggressive. Have you or Gabor exercised this error path?
> What is supposed to happen? Is software prepared for the hardware to
> automatically reset?

I am not trying to be aggressive, but to me, this is either a bug or they are
intentionally cleaned but it's not documented.
Have tried triggering the QM error, but couldn't hit it even when
doing crazy stuff.
It should be nearly impossible to hit it, but it's there to prevent
the switch from just locking up
under extreme conditions (At least that is how I understand it).

I don't think the driver currently even monitors the QM registers at all.
I can understand clearing these bits intentionally, but it's gotta be
documented otherwise
somebody else is gonna think is a bug/mistake/whatever in the code.

Regards,
Robert
--
Robert Marko
Staff Embedded Linux Engineer
Sartura Ltd.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
