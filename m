Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38256F07FD
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243751AbjD0PNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 11:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243979AbjD0PNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 11:13:16 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA0C44AE
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 08:13:10 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 24336FF80F;
        Thu, 27 Apr 2023 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1682608389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWNO8m6pm5R+N7UDJd9ESMCDK+O0CFfpMOjPzFnD+4Y=;
        b=dcf26ERaNZSQAg17jXmk4HzM8sqQt2jsYNJMfnYGa2jcwNqxTNirlETrDgPq+dpBQKD7NY
        ajnJUkBHSygcT9h9PyeeQk7ldGEGZpLjHy1Qc1FUEjaFCxJ4jTiJPAnZJIiYpcJE8GkgSx
        jGgF5TBcBq153ToJQ+Tqd3Oov3oEy6Jz8GaZ20/lPvET4d5fYjkEZIgeO2t2JZ0rWPpUEr
        jPw5ABEcd9ALJXsK4bzqEO11IaWkn2Sw3CkLCr7SWGpVa1nRl9iMujQJvhN3UcSVc9N2n6
        P+AP2hsTdJIfOpTxmmTXfZh0xEMJd4Zo8ChWL0eM/NSRn2QlAHZ3b94aPG/hZw==
Date:   Thu, 27 Apr 2023 17:13:06 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230427171306.2bfd824a@kmaincent-XPS-13-7390>
In-Reply-To: <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
        <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
        <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Mon, 27 Feb 2023 15:20:05 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Mon, Feb 27, 2023 at 03:40:37PM +0100, K=C3=B6ry Maincent wrote:
> > Hello RMK,
> >  =20
> > > Hence why I'm at the point of giving up; I don't see that PTP will be
> > > of very limited benefit on my network with all these issues, and in
> > > any case, NTP has been "good enough" for the last 20+ years.  Given
> > > that only a limited number of machines will be able to implement PTP
> > > support anyway, NTP will have to run along side it. =20
> >=20
> > I see this patch has been abandoned.
> > I am testing it with a ZynqMP board (macb ethernet) and it seems to mor=
e or
> > less work. It got tx timestamp timeout at initialization but after some
> > times (~20 seconds) ptp4l manages to set it working. Also the IEEE 802.3
> > network PTP mode is not working, it constantly throw rx timestamp overr=
un
> > errors.
> > I will aim at fixing these issues and adding support to interrupts. It
> > would be good to have it accepted mainline. What do you think is missing
> > for that? =20
>=20
> It isn't formally abandoned, but is permanently on-hold as merging
> Marvell PHY PTP support into mainline _will_ regress the superior PTP
> support on the Macchiatobin platform for the reasons outlined in:
>=20
> https://lore.kernel.org/netdev/20200729220748.GW1605@shell.armlinux.org.u=
k/
>=20
> Attempting to fix this problem was basically rejected by the PTP
> maintainer, and thus we're at a deadlock over the issue, and Marvell
> PHY PTP support can never be merged into mainline.

As we are currently moving forward on PTP core to resolve this issue, I wou=
ld
like to investigate your PHY PTP patch in parallel. Indeed it does not work=
 very
well on my side.

The PTP UDP v4 and v6 work only if I add "--tx_timestamp_timeout 20" and the
PTP IEEE 802.3 (802.1AS) does not work at all.
On PTP IEEE 802.3 network transport ("ptp4l -2") I get continuously rx time=
stamp
overrun:
Marvell 88E1510 ff0d0000.ethernet-ffffffff:01: rx timestamp overrun (5)
Marvell 88E1510 ff0d0000.ethernet-ffffffff:01: rx timestamp overrun (5)

I know it's been a long time but does it ring a bell on your memory?
