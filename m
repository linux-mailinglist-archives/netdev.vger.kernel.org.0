Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813F66A4808
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjB0RbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjB0Raq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:30:46 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FEC1C302
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:20 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2B8671BF20D;
        Mon, 27 Feb 2023 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677519017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=leBhXZmpFP+IkBbS6iwS28mkVaXzoqBMlJi8kRBBlvo=;
        b=hSr8KfsDj1m6ZeABwW68grlPMTbzjXxkKch4zw4dObdHbkOOUu3yjzafg7NnSpmlMWGH93
        eQgkdIdkNw9xaIR1CNlPC0OllvjXHisTTvWILdnKGZatw987Fc+MkXH+F79w7IIkgWqL4J
        6WJlW37VJOcBVSNWeu8Bgni83eIyw+TYU4voH7XBzInuSM7UPuD7b57um27GO43Nio9JrZ
        lfdLxFCsKk7ddEq5DEWSL4j52hu06TArtzb+wnHpirxKUb7labfN7xuPNjopRb/4wdT0uX
        G5GGmasG++4hX3e4AqCEv9R48gI+NUQ65wEfKOC6G3yYHWuTUY9/qMjGCuFdqQ==
Date:   Mon, 27 Feb 2023 18:30:13 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230227183013.177b10e5@kmaincent-XPS-13-7390>
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Feb 2023 15:20:05 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

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

As I understand, if the PHY support PTP, it is prioritize to the PTP of the=
 MAC.
As quote in the mail thread it seems there was discussion in netdev about
moving phy_has_hwtstamp to core and allowing ethtool to choose which one to
use. I don't know if the decision have been made about it since, but it see=
ms
nothing has been sent to mainline. Meanwhile, why do we not move forward on
this patch with the current PTP behavior and updates it when new core PTP c=
hange
will be sent mailine?

Regards,
K=C3=B6ry
