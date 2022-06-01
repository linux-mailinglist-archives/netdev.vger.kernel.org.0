Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0E153A154
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 11:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350648AbiFAJz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 05:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350652AbiFAJz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 05:55:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AB664D17;
        Wed,  1 Jun 2022 02:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MElt6uUY8fDpn46CK1g0cE05pn5ubvWvKHM1ibri8JQ=; b=xKjfljdNGnVBf8Cy54DrduNiiP
        MxfMNiicIsSy60WjTGPYe2iSbmZNoqVdfolQWovW6KFY9JdiyrvGk6qqV5c8VuYk65a2BL1yAXNpy
        2fgTvXJjsrvC1V4OugHaaHoSKvcAszbJW3HlTnDlvUqKffYwJ+lJUNKbS+QNwAR1ojfjfFD6va2ko
        hI4Rtl3sTVVHHJD+He7H/1Fh7Yji1/4wnu6zQSbwMpPUdudyxrgxODl1o7WNxcen9DIfLGA/N1KNC
        zC3+/GWwf/YrMX0Am5xNxuFCR7zuXUCWXEiPbsjOd5+wvtolmoAfYLa26L1aLJcbztXuYYXTqsI+l
        /DRmaVAQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60918)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nwL4n-0005r7-Rm; Wed, 01 Jun 2022 10:55:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nwL4l-0003Mm-Fd; Wed, 01 Jun 2022 10:55:39 +0100
Date:   Wed, 1 Jun 2022 10:55:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vladimir.oltean@nxp.com,
        grygorii.strashko@ti.com, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 3/3] net: ethernet: ti: am65-cpsw: Move
 phy_set_mode_ext() to correct location
Message-ID: <Ypc3myH2SgGwUmMF@shell.armlinux.org.uk>
References: <20220531113058.23708-1-s-vadapalli@ti.com>
 <20220531113058.23708-4-s-vadapalli@ti.com>
 <YpYCJv2SIExL+VHs@shell.armlinux.org.uk>
 <9f531f8d-9ff2-2ec9-504f-eed324ba86c6@ti.com>
 <YpcjaOdXHC+uYJ2J@shell.armlinux.org.uk>
 <41277985-28c9-9bf0-8b24-6acc40391ef2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41277985-28c9-9bf0-8b24-6acc40391ef2@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 02:59:47PM +0530, Siddharth Vadapalli wrote:
> Hello Russell,
> 
> On 01/06/22 13:59, Russell King (Oracle) wrote:
> > On Wed, Jun 01, 2022 at 11:39:57AM +0530, Siddharth Vadapalli wrote:
> >> Hello Russell,
> >>
> >> On 31/05/22 17:25, Russell King (Oracle) wrote:
> >>> On Tue, May 31, 2022 at 05:00:58PM +0530, Siddharth Vadapalli wrote:
> >>>> In TI's J7200 SoC CPSW5G ports, each of the 4 ports can be configured
> >>>> as a QSGMII main or QSGMII-SUB port. This configuration is performed
> >>>> by phy-gmii-sel driver on invoking the phy_set_mode_ext() function.
> >>>>
> >>>> It is necessary for the QSGMII main port to be configured before any of
> >>>> the QSGMII-SUB interfaces are brought up. Currently, the QSGMII-SUB
> >>>> interfaces come up before the QSGMII main port is configured.
> >>>>
> >>>> Fix this by moving the call to phy_set_mode_ext() from
> >>>> am65_cpsw_nuss_ndo_slave_open() to am65_cpsw_nuss_init_slave_ports(),
> >>>> thereby ensuring that the QSGMII main port is configured before any of
> >>>> the QSGMII-SUB ports are brought up.
> >>>
> >>> This sounds like "if we're configured via port->slave.phy_if to be in
> >>> QSGMII mode, then the serdes PHY needs to be configured before any of
> >>> the QSGMII ports are used". Doesn't that mean that if
> >>> port->slave.phy_if is QSGMII, then the port _only_ supports QSGMII
> >>> mode, and conversely, the port doesn't support QSGMII unless firmware
> >>> said it could be.
> >>>
> >>> So, doesn't that mean am65_cpsw_nuss_init_port_ndev() should indicate
> >>> only QSGMII, or only the RGMII modes, but never both together?
> >>
> >> The phy-gmii-sel driver called by phy_set_mode_ext() configures the CPSW5G MAC
> >> rather than the SerDes Phy. In the CPSW5G MAC, the QSGMII mode is further split
> >> up as two modes that are TI SoC specific, namely QSGMII main and QSGMII-SUB. Of
> >> the 4 ports present in CPSW5G (4 external ports), only one can be the main port
> >> while the rest are the QSGMII-SUB ports. Only the QSGMII main interface is
> >> responsible for auto-negotiation between the MAC and PHY. For this reason, the
> >> writes to the CPSW5G MAC, mentioning which of the interfaces is the QSGMII main
> >> interface and which ones are the QSGMII-SUB interfaces has to be done before any
> >> of the interfaces are brought up. Otherwise, it would result in a QSGMII-SUB
> >> interface being brought up before the QSGMII main interface is determined,
> >> resulting in the failure of auto-negotiation process, thereby making the
> >> QSGMII-SUB interfaces non-functional.
> > 
> > That confirms my suspicion - if an interface is in QSGMII mode, then
> > RGMII should not be marked as a supported interface to phylink. If the
> 
> CPSW5G MAC supports both RGMII and QSGMII modes, so wouldn't it be correct to
> mark both RGMII and QSGMII modes as supported? The mode is specified in the
> device-tree and configured in CPSW5G MAC accordingly.
> 
> > "QSGMII main interface" were to be switched to RGMII mode, then this
> > would break the other ports. So RGMII isn't supported if in QSGMII
> > mode.
> 
> Yes, if the QSGMII main interface were to be switched to RGMII mode, then it
> would break the other ports. However, the am65-cpsw driver currently has no
> provision to dynamically change the port modes once the driver is initialized.

If there is no provision to change the port mode, then as far as
phylink is concerned, you should not advertise that it supports
anything but the current mode - because if phylink were to request
the driver change the mode, the driver can't do it.

So, you want there, at the very least:

	if (phy_interface_mode_is_rgmii(port->slave.phy_if))
		phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
	else
		__set_bit(PHY_INTERFACE_MODE_QSGMII, port->slave.phylink_config.supported_interfaces);

which will still ensure that port->slave.phy_if is either a RGMII
mode or QSGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
