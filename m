Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F166D2211
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjCaOKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjCaOKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:10:16 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4701C1D7;
        Fri, 31 Mar 2023 07:10:15 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1piFSC-0003GH-1P;
        Fri, 31 Mar 2023 16:10:08 +0200
Date:   Fri, 31 Mar 2023 15:10:05 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: Re: [PATCH net-next 14/15] net: dsa: mt7530: introduce driver for
 MT7988 built-in switch
Message-ID: <ZCbpvVqAEHpoAazr@makrotopia.org>
References: <cover.1680180959.git.daniel@makrotopia.org>
 <fef2cb2fe3d2b70fa46e93107a0c862f53bb3bfa.1680180959.git.daniel@makrotopia.org>
 <6a7c5f81-a8a3-27b5-4af3-7175a3313f9a@arinc9.com>
 <ZCazDBJvFvjcQfKo@makrotopia.org>
 <7d0acaef-0cec-91b9-a5c6-d094b71e3dbd@arinc9.com>
 <28d048c9-6389-749b-d0eb-18a9c2d83c4e@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28d048c9-6389-749b-d0eb-18a9c2d83c4e@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:18:19PM +0300, Arınç ÜNAL wrote:
> On 31.03.2023 15:06, Arınç ÜNAL wrote:
> > On 31.03.2023 13:16, Daniel Golle wrote:
> > > On Fri, Mar 31, 2023 at 08:50:28AM +0300, Arınç ÜNAL wrote:
> > > > On 30.03.2023 18:23, Daniel Golle wrote:
> > > > > Add driver for the built-in Gigabit Ethernet switch which can be found
> > > > > in the MediaTek MT7988 SoC.
> > > > > 
> > > > > The switch shares most of its design with MT7530 and MT7531, but has
> > > > > it's registers mapped into the SoCs register space rather than being
> > > > > connected externally or internally via MDIO.
> > > > > 
> > > > > Introduce a new platform driver to support that.
> > > > > 
> > > > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > > > > ---
> > > > >    MAINTAINERS                   |   2 +
> > > > >    drivers/net/dsa/Kconfig       |  12 ++++
> > > > >    drivers/net/dsa/Makefile      |   1 +
> > > > >    drivers/net/dsa/mt7530-mmio.c | 101
> > > > > ++++++++++++++++++++++++++++++++++
> > > > >    drivers/net/dsa/mt7530.c      |  86 ++++++++++++++++++++++++++++-
> > > > >    drivers/net/dsa/mt7530.h      |  12 ++--
> > > > >    6 files changed, 206 insertions(+), 8 deletions(-)
> > > > >    create mode 100644 drivers/net/dsa/mt7530-mmio.c
> > > > > 
> > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > index 14924aed15ca7..674673dbdfd8b 100644
> > > > > --- a/MAINTAINERS
> > > > > +++ b/MAINTAINERS
> > > > > @@ -13174,9 +13174,11 @@ MEDIATEK SWITCH DRIVER
> > > > >    M:    Sean Wang <sean.wang@mediatek.com>
> > > > >    M:    Landen Chao <Landen.Chao@mediatek.com>
> > > > >    M:    DENG Qingfang <dqfext@gmail.com>
> > > > > +M:    Daniel Golle <daniel@makrotopia.org>
> > > > >    L:    netdev@vger.kernel.org
> > > > >    S:    Maintained
> > > > >    F:    drivers/net/dsa/mt7530-mdio.c
> > > > > +F:    drivers/net/dsa/mt7530-mmio.c
> > > > >    F:    drivers/net/dsa/mt7530.*
> > > > >    F:    net/dsa/tag_mtk.c
> > > > > diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> > > > > index c2551b13324c2..de4d86e37973f 100644
> > > > > --- a/drivers/net/dsa/Kconfig
> > > > > +++ b/drivers/net/dsa/Kconfig
> > > > > @@ -52,6 +52,18 @@ config NET_DSA_MT7530
> > > > >          Multi-chip module MT7530 in MT7621AT, MT7621DAT, MT7621ST and
> > > > >          MT7623AI SoCs is supported as well.
> > > > > +config NET_DSA_MT7988
> > > > > +    tristate "MediaTek MT7988 built-in Ethernet switch support"
> > > > > +    select NET_DSA_MT7530_COMMON
> > > > > +    depends on HAS_IOMEM
> > > > > +    help
> > > > > +      This enables support for the built-in Ethernet switch found
> > > > > +      in the MediaTek MT7988 SoC.
> > > > > +      The switch is a similar design as MT7531, however, unlike
> > > > > +      other MT7530 and MT7531 the switch registers are directly
> > > > > +      mapped into the SoCs register space rather than being accessible
> > > > > +      via MDIO.
> > > > > +
> > > > >    config NET_DSA_MV88E6060
> > > > >        tristate "Marvell 88E6060 ethernet switch chip support"
> > > > >        select NET_DSA_TAG_TRAILER
> > > > > diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
> > > > > index 71250d7dd41af..103a33e20de4b 100644
> > > > > --- a/drivers/net/dsa/Makefile
> > > > > +++ b/drivers/net/dsa/Makefile
> > > > > @@ -8,6 +8,7 @@ endif
> > > > >    obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
> > > > >    obj-$(CONFIG_NET_DSA_MT7530_COMMON) += mt7530.o
> > > > >    obj-$(CONFIG_NET_DSA_MT7530)    += mt7530-mdio.o
> > > > > +obj-$(CONFIG_NET_DSA_MT7988)    += mt7530-mmio.o
> > > > 
> > > > I'm not fond of this way. Wouldn't it be better if we split the mdio and
> > > > mmio drivers to separate modules and kept switch hardware support on
> > > > mt7530.c?
> > > 
> > > You mean this in terms of Kconfig symbols?
> > > Because the way you describe is basically what I'm doing here:
> > >   * mt7530.c is the shared/common switch hardware driver
> > >   * mt7530-mdio.c contains the MDIO accessors and MDIO device drivers for
> > >     MT7530, MT7531, MT7621, MT7623, ...
> > >   * mt7530-mmio.c contains the platform device driver for in-SoC switches
> > >     which are accessed via MMIO, ie. MT7988 (and yes, this could be
> > >     extended to also support MT7620A/N).
> > 
> > Ok great.
> > 
> > > 
> > > In early drafts I also named the Kconfig symbols
> > > CONFIG_NET_DSA_MT7530 for mt7530.c (ie. the common part)
> > > CONFIG_NET_DSA_MT7530_MDIO for the MDIO driver
> > > CONFIG_NET_DSA_MT7530_MMIO for the MMIO driver
> > > 
> > > However, as existing kernel configurations expect
> > > CONFIG_NET_DSA_MT7530 to
> > > select the MDIO driver, I decided it would be better to hide the
> > > symbol of
> > > the common part and have CONFIG_NET_DSA_MT7530 select the MDIO
> > > driver like
> > > it was before.
> > 
> > You can "imply NET_DSA_MT7530_MDIO" from NET_DSA_MT7530 so the MDIO
> > driver is also enabled when NET_DSA_MT7530 is selected. For example, on
> > Realtek, both MDIO and SMI drivers are enabled by default when either of
> > the main drivers are selected.
> > 
> > config NET_DSA_MT7530
> >      tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
> >      select NET_DSA_TAG_MTK
> >      select MEDIATEK_GE_PHY
> >      select PCS_MTK_LYNXI
> >      imply NET_DSA_MT7530_MDIO
> >      imply NET_DSA_MT7530_MMIO
> 
> The final kconfig should look like this:
> 
> config NET_DSA_MT7530
> 	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
> 	select NET_DSA_TAG_MTK
> 	select MEDIATEK_GE_PHY
> 	select PCS_MTK_LYNXI
> 	imply NET_DSA_MT7530_MDIO
> 	imply NET_DSA_MT7530_MMIO
> 	help
> 	  This enables support for the MediaTek MT7530 and MT7531 Ethernet
> 	  switch chips. Multi-chip module MT7530 in MT7621AT, MT7621DAT,
> 	  MT7621ST and MT7623AI SoCs, and built-in switch in MT7688 SoC is
                                                             ^^^^^^
You probably meant MT7988.

The built-in Fast Ethernet switch of older Ralink SoCs as well as MT7628 and
MT7688 is a whole different story:
https://github.com/stroese/linux/blob/gardena-v5.5/drivers/net/dsa/mt7628-esw.c

> 	  supported.
> 
> config NET_DSA_MT7530_MDIO
> 	tristate "MediaTek MT7530 MDIO interface driver"
> 	default NET_DSA_MT7530
> 	depends on NET_DSA_MT7530
> 	help
> 	  This enables support for the MediaTek MT7530 switch chips which are
> 	  connected via MDIO.
> 
> config NET_DSA_MT7530_MMIO
> 	tristate "MediaTek MT7530 MMIO interface driver"
> 	depends on HAS_IOMEM
> 	depends on NET_DSA_MT7530
> 	help
> 	  This enables support for the MediaTek MT7530 switch chips which are
> 	  connected via MMIO.
> 
> You should also change MODULE_DESCRIPTION for both drivers to something
> like "Driver for MediaTek MT7530 ethernet switches connected via MMIO
> interface".

Ack. Will do.
