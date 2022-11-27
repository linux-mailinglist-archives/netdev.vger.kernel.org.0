Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01850639D8D
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiK0WPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiK0WPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:15:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECE2F001
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 14:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=o/xY6aByygLRUZxbkTVP92OGcPRTQUJKmqee3LobhSE=; b=LIgIlgu71KKaeDCtdeKogOii2M
        t6k8NWtak/Fvx6gOAy9tUd9L/zIjqgwy1xLUGroonO4CuPs6iMOZ0XXTZ9yTZaXQnQ6w1/7kbEOf1
        SG6j9BNLAA/+aoz3m8FwxVayZs4Z8XvlGEuJ/jj3IyWhE5oSX6IIVwiw0RCD+WMcpVI1kSXoIAS7u
        B62e0B10BAqxldRtk2HqLwIkl3E6fMbXlaefoP7MfZlrh9dO8bdAJ5wmDQ8b7xPMK6xmawir6KubF
        G+lEe2gjJyGz7LRVIP7XcR20q999NMut7ihDgeurYwVAUu8gxAGwGefU0f87gseMV1kYImBiDMIZk
        OUEi5FBg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35450)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ozPvI-0007N1-8C; Sun, 27 Nov 2022 22:14:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ozPvB-0008OJ-Nq; Sun, 27 Nov 2022 22:14:45 +0000
Date:   Sun, 27 Nov 2022 22:14:45 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <Y4PhVWmM6//kDoE/@shell.armlinux.org.uk>
References: <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
 <20221122193618.p57qrvhymeegu7cs@skbuf>
 <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
 <Y34b+7IOaCX401vR@shell.armlinux.org.uk>
 <20221125123022.cnqobhnuzyqb5ukw@skbuf>
 <Y4DGhv/6BHNaMEYQ@shell.armlinux.org.uk>
 <20221125153555.uzrl7j2me3lh2aeg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125153555.uzrl7j2me3lh2aeg@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 05:35:55PM +0200, Vladimir Oltean wrote:
> On Fri, Nov 25, 2022 at 01:43:34PM +0000, Russell King (Oracle) wrote:
> > The value of "EXT_SR before" is 1000base-X, so if you change sfp-bus.c::
> > sfp_select_interface() to use 1000BASEX instead of SGMII then you'll be
> > using 1000BASEX instead (and it should work, although at fixed 1G
> > speeds). The only reason the module is working in SGMII mode is because,
> > as you've noticed above, we switch it to SGMII mode in
> > m88e1111_config_init_sgmii().
> 
> Which is an interesting thing, because m88e1111_config_init_1000basex()
> does not change the HWCFG_MODE_MASK to something with 1000X in it.

It only changes the hwcfg mode if it was using 1000base-X no-AN -
switching it instead to be 1000base-X with AN, but as we've established
the comment above that code describes something which doesn't happen,
as the fibre page BMCR is unaffected by this change.

Anyway, with my SourcePhotonics SPGBTXCNFC module (which is a SGMII
module) I get:

Marvell 88E1111 i2c:sfp-3:16: extsr: 8084 fiber bmcr: 1140

although the first time I plugged it in, BMCR was 1940 (pdown set).
Key thing is this module doesn't have bypass permitted.

> But there's actually a problem (or maybe two problems).
> 
> First is that if I make phylink treat the ON_TIMEOUT capability by using
> MLO_AN_PHY (basically like this):
> 
> phylink_sfp_config_phy():
> 
> 	/* Select whether to operate in in-band mode or not, based on the
> 	 * capability of the PHY in the current link mode.
> 	 */
> 	ret = phy_validate_an_inband(phy, iface);
> 	phylink_err(pl, "PHY driver reported AN inband 0x%x\n", ret);
> 	if (ret == PHY_AN_INBAND_UNKNOWN) {
> 		mode = MLO_AN_INBAND;
> 
> 		phylink_dbg(pl,
> 			    "PHY driver does not report in-band autoneg capability, assuming true\n");
> //	} else if (ret & (PHY_AN_INBAND_ON | PHY_AN_INBAND_ON_TIMEOUT)) {
> 	} else if (ret & PHY_AN_INBAND_ON) {
> 		mode = MLO_AN_INBAND;
> 	} else {
> 		mode = MLO_AN_PHY;
> 	}
> 
> [   30.059923] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // PHY_AN_INBAND_ON_TIMEOUT
> [   30.066867] fsl_dpaa2_eth dpni.1 dpmac7: switched to phy/1000base-x link mode // MLO_AN_PHY
> [   30.153350] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_1000basex: EXT_SR before 0x9088 after 0x9088, fiber page BMCR before 0x1140 after 0x1140
> [   30.238970] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)
> 
> then pinging is broken with mismatched in-band AN settings ("TIMEOUT" in
> PHY, "OFF" in PCS). I triple-checked this.
> 
> ping 192.168.100.2
> PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
> From 192.168.100.1 icmp_seq=1 Destination Host Unreachable
> From 192.168.100.1 icmp_seq=2 Destination Host Unreachable
> From 192.168.100.1 icmp_seq=3 Destination Host Unreachable
> From 192.168.100.1 icmp_seq=4 Destination Host Unreachable
> From 192.168.100.1 icmp_seq=5 Destination Host Unreachable
> From 192.168.100.1 icmp_seq=6 Destination Host Unreachable
> ^C
> --- 192.168.100.2 ping statistics ---
> 9 packets transmitted, 0 received, +6 errors, 100% packet loss, time 8170ms
> 
> 
> However, if using the same phylink code (to force a mismatch), I unhack
> sfp_select_interface() and use SGMII mode, the timeout feature does
> actually work:
> 
> [   30.262979] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // PHY_AN_INBAND_ON_TIMEOUT
> [   30.270349] fsl_dpaa2_eth dpni.1 dpmac7: switched to phy/sgmii link mode // MLO_AN_PHY
> [   30.351066] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_sgmii: EXT_SR before 0x9088 after 0x9084, fiber page BMCR before 0x1140 after 0x1140
> [   30.433236] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)
> 
> this is a functional link despite the mismatched settings.
> 
> ping 192.168.100.2
> PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
> 64 bytes from 192.168.100.2: icmp_seq=1 ttl=64 time=0.885 ms
> 64 bytes from 192.168.100.2: icmp_seq=2 ttl=64 time=0.221 ms
> 64 bytes from 192.168.100.2: icmp_seq=3 ttl=64 time=0.216 ms
> 64 bytes from 192.168.100.2: icmp_seq=4 ttl=64 time=0.217 ms
> 64 bytes from 192.168.100.2: icmp_seq=5 ttl=64 time=0.238 ms
> ^C
> --- 192.168.100.2 ping statistics ---
> 5 packets transmitted, 5 received, 0% packet loss, time 4062ms
> rtt min/avg/max/mdev = 0.216/0.355/0.885/0.264 ms
> 
> 
> The second problem is that not even *matched* settings work if I turn
> off BMCR_ANENABLE in the PHY fiber page.
> 
> [   30.809869] fsl_dpaa2_eth dpni.1 dpmac7: configuring for inband/sgmii link mode
> [   30.817936] mdio_bus 0x0000000008c1f000:00: MII_BMCR 0x1140 MII_BMSR 0x9 MII_ADVERTISE 0x1 MII_LPA 0x0 IF_MODE 0x3 // PCS registers at the end of lynx_pcs_config_giga()
> [   30.917651] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // ignore; m88e1111_validate_an_inband() is hardcoded for this and does not detect BMCR for BASE-X
> [   30.924571] fsl_dpaa2_eth dpni.1 dpmac7: switched to phy/1000base-x link mode
> [   30.932441] mdio_bus 0x0000000008c1f000:00: MII_BMCR 0x140 MII_BMSR 0xd MII_ADVERTISE 0x1 MII_LPA 0x0 IF_MODE 0x1
> [   31.032547] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_1000basex: EXT_SR before 0x9088 after 0x9088, fiber page BMCR before 0x140 after 0x140
> [   31.117668] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)
> 
> ping 192.168.100.2
> PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
> ^C
> --- 192.168.100.2 ping statistics ---
> 4 packets transmitted, 0 received, 100% packet loss, time 3058ms
> 
> What's common is that if in-band autoneg is turned off (either forced
> off or via timeout), 1000BASE-X between the Lynx PCS and the 88E1111
> simply doesn't work.

I've just tried an experiment here with my SourcePhotonics module.

I made m88e1111_validate_an_inband() set the SERIAL_AN_BYPASS bit,
and then the bit I think you're probably unaware of - the PHY needs
to be soft-reset in order for that change to take effect. Calling
genphy_soft_reset() is sufficient.

Then I made m88e1111_validate_an_inband() return PHY_AN_INBAND_OFF.
So we now have the PHY setup with BMCR=1140 and EXTSR=9084.

# ping -I eth4 fe80::222:68ff:fe15:37dd
ping: Warning: source address might be selected on device other than: eth4
PING fe80::222:68ff:fe15:37dd(fe80::222:68ff:fe15:37dd) from :: eth4: 56 data bytes
64 bytes from fe80::222:68ff:fe15:37dd%eth4: icmp_seq=1 ttl=64 time=0.281 ms
^C
--- fe80::222:68ff:fe15:37dd ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.281/0.281/0.281/0.000 ms

(yes, it did use eth4's source address, I checked with tcpdump on the
target machine.)

So the link appears to be functional. Using a highly modified mii-diag
tool that allows me to read/write registers on the PHY, if I read the
EXT_SR register, it now contains:

Reading 0x001b=0x9884

and bit 11 being set means the PHY went into bypass mode. In other
words, it didn't see the SGMII acknowledgement from the MAC and
decided to bring the link up in bypass mode.

However, I've just tripped over some information in the 88E1111
manual which states that in SGMII mode, if bypass mode is used, then
the PHY will apparently renegotiate on the copper side advertising
1000baseT HD and FD only, no pause. So I checked what my link partner
is seeing, and it was seeing the original advertisement.

So I then triggered a renegotiate from the partner, and it now shows
only 1000baseT/Half 1000baseT/Full being advertised by the 88E1111.
Reading the advertisement register, it still contains 0x0d41, which
shows pause modes, 100FD, 10FD - so the advertisement register doesn't
reflect what was actually adfertised in this case.

Also, presumably, based on this observation, it will only renegotiate
if the copper side hadn't resolved to gigabit. If correct, what this
means is that when operating in SGMII mode, the the PHY becomes
gigabit-only if bypass mode gets used.

Given this behaviour, the fact that it switches to gigabit only when
the SGMII side enters bypass mode, I think we should _positively_ be
disabling inband bypass in SGMII mode. This change in advertisement
is not what phylib would expect, and I suspect could lead to surprises
e.g. if phylib was told to advertise non-gigabit speeds only.

However, I'll try this test with 1000base-X mode tomorrow.

> > I think a more comprehensive test would be to write the fiber page
> > BMCR with 0x140 before changing the mode from 1000baseX to SGMII and
> > see whether the BMCR changes value. My suspicion is it won't, and
> > the hwcfg_mode only has an effect on the settings in the fiber page
> > under hardware reset conditions, and mode changes have no effect on
> > the fiber page.
> 
> Confirmed that changes to the EXT_SR register don't cause changes to the
> MII_BMCR register:
> 
> [   28.587838] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_sgmii: EXT_SR before 0x9088 after 0x9084, fiber page BMCR before 0x140 after 0x140
> 
> generated by:
> 
> static int m88e1111_config_init_sgmii(struct phy_device *phydev)
> {
> 	int fiber_bmcr_before, fiber_bmcr_after;
> 	int ext_sr_before, ext_sr_after;
> 	int err;
> 
> 	ext_sr_before = phy_read(phydev, MII_M1111_PHY_EXT_SR);
> 	if (ext_sr_before < 0)
> 		return ext_sr_before;
> 
> 	err = phy_modify_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR,
> 			       BMCR_ANENABLE, 0);
> 	if (err < 0)
> 		return err;
> 
> 	fiber_bmcr_before = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
> 	if (fiber_bmcr_before < 0)
> 		return fiber_bmcr_before;
> 
> 	err = m88e1111_config_init_hwcfg_mode(
> 		phydev,
> 		MII_M1111_HWCFG_MODE_SGMII_NO_CLK,
> 		MII_M1111_HWCFG_FIBER_COPPER_AUTO);
> 	if (err < 0)
> 		return err;
> 
> 	ext_sr_after = phy_read(phydev, MII_M1111_PHY_EXT_SR);
> 	if (ext_sr_after < 0)
> 		return ext_sr_after;
> 
> 	fiber_bmcr_after = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
> 	if (fiber_bmcr_after < 0)
> 		return fiber_bmcr_after;
> 
> 	phydev_err(phydev, "%s: EXT_SR before 0x%x after 0x%x, fiber page BMCR before 0x%x after 0x%x\n",
> 		   __func__, ext_sr_before, ext_sr_after,
> 		   fiber_bmcr_before, fiber_bmcr_after);
> 
> 	/* make sure copper is selected */
> 	return marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
> }

Thanks for testing. So that means m88e1111_config_init_sgmii() will not
enable in-band if it was previously disabled. So we need to check the
fiber ANENABLE bit and unconditionally return PHY_AN_INBAND_OFF if it is
clear before evaluating anything else.

Also, given this behaviour of bypass mode, it seems it would only make
sense if the PHY were operating in 1000base-X mode, which we don't do
with SFPs, so maybe it makes no sense to support the ON_TIMEOUT as an
option right now - and as I say above, maybe we should be focing the
AN bypass allow bit to be clear in SGMII mode.

I think maybe Andrew needs to be involved in that last bit though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
