Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D14F6B0E98
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCHQZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjCHQYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:24:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550699C985;
        Wed,  8 Mar 2023 08:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E7fsE/PIWBnLScuWwKIke56fUTXEdQdGN990S+ann7g=; b=FFhBzhCj83fRbsk3eL7Jj3eQzr
        E3hVZlDzmWtjHK6/n9OgdY2+iB+IC1yC91SyK3rn2K0hCtXOHvQ6YNJRdAhOCC5Fmdgfb89tXiSbt
        k5KdG4VD1QJxke5lv2tlCLjj/jEainZmhn4mEG6eb1p6VBMMU0dr0GVi4WfvGpqExHWiql9xkhfIf
        Wjv0eEFqqdwXP/YnSra/ul/F09khVz/KJvbyecRS6rbGjdARC1hT4ESmzHmCsJWyIjvezQxjaI1Ru
        oX4UgKTnqoqnV6MTrh2676QOyMyRU2WHq6m/fikWZ1q4nKlRALvKeABj/o87L5NcvlRHOEqzF58FV
        g8SWo/zA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42346)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZwai-0002ww-GR; Wed, 08 Mar 2023 16:24:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZwaa-0002jQ-TM; Wed, 08 Mar 2023 16:24:28 +0000
Date:   Wed, 8 Mar 2023 16:24:28 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Frank Wunderlich <frank-w@public-files.de>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 09/18] net: ethernet: mtk_eth_soc: Fix link
 status for none-SGMII modes
Message-ID: <ZAi2vLLC7ycaTlvI@shell.armlinux.org.uk>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org>
 <ZAhzt5eIZiJUyVm7@shell.armlinux.org.uk>
 <B69026D7-E770-4168-B1CA-54E34D52C961@public-files.de>
 <ZAh5/+erE6yYYl7B@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAh5/+erE6yYYl7B@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 12:05:19PM +0000, Daniel Golle wrote:
> On Wed, Mar 08, 2023 at 12:44:57PM +0100, Frank Wunderlich wrote:
> > Am 8. März 2023 12:38:31 MEZ schrieb "Russell King (Oracle)" <linux@armlinux.org.uk>:
> > >On Tue, Mar 07, 2023 at 03:54:11PM +0000, Daniel Golle wrote:
> > >> Link partner advertised link modes are not reported by the SerDes
> > >> hardware if not operating in SGMII mode. Hence we cannot use
> > >> phylink_mii_c22_pcs_decode_state() in this case.
> > >> Implement reporting link and an_complete only and use speed according to
> > >> the interface mode.
> > >> 
> > >> Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
> > >> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > >
> > >This has been proven to work by Frank Wunderlich last October, so by
> > >making this change, you will be regressing his setup.
> > 
> > Hi
> > 
> > My tests were done with 1 kind of 1g fibre sfp as i only have these atm...have ordered some 2g5 rj54 ones,but don't have them yet. I'm not sure if they are working with/without sgmii (1000base-X) and if they have builtin phy.
> > 
> > Daniel have a lot more of different SFPs and some (especially 2g5) were not working after our pcs change.
> 
> Exactly. 1 GBit/s SFPs with built-in PHY and using SGMII are working
> fine before and after conversion to phylink_pcs. 1000Base-X and
> 2500Base-X PHYs and SFPs were broken after this.
> 
> The patch about (and the other one you already NACK'ed) fixes those
> codepaths which were simply not used in Frank's setup.

You're replying to "Frank" but I think the "you" you are using there
is addressed to me.

I beg to differ with your assessment over whether the code paths were
used or not. Here's the proof from Frank's testing:

https://lore.kernel.org/all/trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49/

The values at offset 8 (0x40e041a0) _are_ 1000base-X AN values, not
SGMII. There are many messages in that thread showing valid 1000base-X
AN values in register 8 (that being the local advertisement in the
lower 16 bits, and the partner's advertisement in the upper 16 bits.

The link partner in this case sent 0x40e0, which is:

#define LPA_1000XFULL           0x0020  /* Can do 1000BASE-X full-duplex */
#define LPA_1000XHALF           0x0040  /* Can do 1000BASE-X half-duplex */
#define LPA_1000XPAUSE          0x0080  /* Can do 1000BASE-X pause     */
#define LPA_LPACK               0x4000  /* Link partner acked us       */

and our advertisement was 0x41a0:

#define ADVERTISE_1000XFULL     0x0020  /* Try for 1000BASE-X full-duplex */
#define ADVERTISE_1000XPAUSE    0x0080  /* Try for 1000BASE-X pause    */
#define ADVERTISE_1000XPSE_ASYM 0x0100  /* Try for 1000BASE-X asym pause */
#define ADVERTISE_LPACK         0x4000  /* Ack link partners response  */

(bit 14 is managed by the PCS.)

> I have a ballpark of different SFPs and MediaTek boards with different
> PHYs here and tried all of them.
> 
> I have no way to tell if the SFPs and PHYs which stopped working after
> the phylink_pcs conversion are sending valid advertisement. The only
> other boards with SFP slots I got here are RealTek-based switches, and
> all I can say is that on an RTL8380 based 1G switch both, the SFP
> modules containing a PHY and operating in SGMII mode as well as the
> ones without a PHY exposed via i2c-mdio and operating in 1000Base-X
> mode are working fine with that switch, with both, stock firmware and
> OpenWrt running on it.
> 
> However, even should they not send valid advertisement, they are very
> common parts and they were working before and not after the change to
> phylink_pcs, for the reasons mentioned in the description of this
> patch.

Let me re-iterate in a different way to make this crystal clear: the
fibre SFP is completely transparent with respect to the PCS-to-PCS
link.

The clause 37 autonegotiation is between the PCS at one end and the PCS
at the other end. The fibre SFP is not involved in it. All that fibre
SFPs do is convert the serdes waveform into a varying optical intensity
and back again to a serdes waveform. They do not attempt to interpret
the waveform, but they may shape it via retimer circuitry and adjust
the gain to provide a compliant electrical signal.

So, if the PCS at the far end of the link is sending a zero
advertisement or not sending an advertisement at all, then the LPA
register will contain a zero irrespective of the fibre SFP module
being used.

Another case where it may give a zero value but with a copper SFP
is if the copper SFP is using 1000base-X or SGMII but without
sending an advertisement. As I've already stated, BCM84881 is
known to do this, which is used on some copper SFP modules. It
may be that some copper SFP modules have the PHY setup to use
1000base-X but without any clause 37 advertisement - that would
not surprise me in the least.


I would suggest that if you replaced your mediatek board in your
setup with something else, e.g. an Armada 388 based Clearfog board
which is known to work correctly, used the same fibre SFPs, you'll
find that negotiation would not complete and the link wouldn't
come up. Then if you use the same fibre SFPs that I do at both
ends, you'll find the same problem (because the fibre SFPs make
no difference as far as the in-band AN is concerned.)

I hope this helps.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
