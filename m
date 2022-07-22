Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AC857E1C9
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiGVM7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGVM7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC4C57E07;
        Fri, 22 Jul 2022 05:59:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B69261E84;
        Fri, 22 Jul 2022 12:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466A1C341C6;
        Fri, 22 Jul 2022 12:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658494785;
        bh=BKrizWV96d8+rZwIec8s+GHsD43ct+a/ytonnY3af3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TAIxnlQx4527e7gKVxmMg1IyqHmGp7XRatUsqJ/ANbfat2x0Ad5ap6wHnp2dNfFrb
         DYmhQmD0xL3CkWfA0X/VTddr/NosMCBZG7KXgUSNcb7WRDdeAp/I2YkzYYSiOu+n7Y
         V2cTtfkce9tmYGi3lYZqZPdjjHLxdbW8NbScXEcdh+5Hs0NZoeIjViekvD/r/cgxOR
         CgGDDglgNry2vcNHljiUSez3IS+uKG/G4sXv/rH5twGAFaYilVJoXWYczvPDhdKu6f
         jrp213JC37jLfc9Lvflko5MHOE5Ftw7xIYeeBxE9R9yCj53RMKI/kpr/bChYDb21me
         /AbxW+iqz3aFA==
Date:   Fri, 22 Jul 2022 14:59:36 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220722145936.497ac73f@dellmb>
In-Reply-To: <20220721182216.z4vdaj4zfb6w3emo@skbuf>
References: <20220716105711.bjsh763smf6bfjy2@skbuf>
        <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
        <20220716123608.chdzbvpinso546oh@skbuf>
        <YtUec3GTWTC59sky@shell.armlinux.org.uk>
        <20220720224447.ygoto4av7odsy2tj@skbuf>
        <20220721134618.axq3hmtckrumpoy6@skbuf>
        <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
        <20220721151533.3zomvnfogshk5ze3@skbuf>
        <20220721192145.1f327b2a@dellmb>
        <20220721192145.1f327b2a@dellmb>
        <20220721182216.z4vdaj4zfb6w3emo@skbuf>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 21:22:16 +0300
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Thu, Jul 21, 2022 at 07:21:45PM +0200, Marek Beh=C3=BAn wrote:
> > Marvell documentation says that 2500base-x does not implement inband
> > AN. =20
>=20
> Does Marvell documentation actually call it 2500base-x when it says it
> doesn't support in-band autoneg?

Yes, it does.

> > But when it was first implemented, for some reason it was thought that
> > 2500base-x is just 1000base-x at 2.5x speed, and 1000base-x does
> > support inband AN. Also it worked during tests for both switches and
> > SOC NICs, so it was enabled.
> >=20
> > At the time 2500base-x was not standardized. Now 2500base-x is
> > stanradrized, and the standard says that 2500base-x does not support
> > clause 37 AN. I guess this is because where it is used, it is intended
> > to work with clause 73 AN somehow. =20
>=20
> When you say 2500base-x is standardized, do you mean there is a document
> somewhere which I could use to read more about this?

IEEE Std 802.3cb-2018: Amendment 1: Physical Layer Specifications and
Management Parameters for 2.5 Gb/s and 5 Gb/s Operation over Backplane.

Annex 127A (informative): Compatibility of 2.5GBASE-X PCS/PMA with
1000BASE-X PCS/PMA running 2.5 times faster

  ...
  This annex discusses the restrictions when operating 2.5GBASE-X
  PCS/PMA with a 1000BASE-X PCS/PMA link partner running 2.5 times
  faster. Compatibility of the PMD is outside the scope of this annex.
  In this annex when 1000BASE-X PCS/PMA is referred to, the 2.5 times
  speed up is implied.
  ...
  The 2.5GBASE-X PCS does not support Clause 37 Auto-Negotiation.
  Hence, the 1000BASE-X PCS is expected to have its Clause 37
  Auto-Negotiation functionality disabled so that the /C/ ordered set
  will not be transmitted. If a 2.5GBASE-X PCS receives /C/ ordered
  set, then undefined behavior may occur.
  ...

Marek
