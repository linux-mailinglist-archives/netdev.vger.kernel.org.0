Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D721C539F80
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 10:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350767AbiFAI3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 04:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349252AbiFAI3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 04:29:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88C04B86B;
        Wed,  1 Jun 2022 01:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hUcYa8u6coeEqMUwnvlLzfUj34eb1m5imtA8bKADKGY=; b=CjtD9x0IC7BZ2I0RCGMwMpYUA1
        UifYNmQLjK9EOCJGtNDfeqX0Zio+3tm4Zoq/mqT1yOWmBbxZXhhoj5WM41VJYJmMBHz2wMy6HHY6X
        X7nKiZC1RVRhxCitUovdQ32VLT9KUYnvQeGeD2C6fEDKjX0DjoKAIHWimZEWxX6atXV+JhqjCKsRi
        gvswIn0V1tTbExn4irwLbMPVZ6zxCRlTcFyNtdPHcRcZlRGywL3kP6Hnd7FLneZ+cqDwMDChYnU5w
        lzzQXex+lQ8+KdJSNa9fixC0q1n30XEY/YBjOD8cUn2Z6sZtlIKzvaSGzYCTAzOn0jINqSA9XN1NR
        lJVoA5Sw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60916)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nwJjP-0005ls-4h; Wed, 01 Jun 2022 09:29:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nwJjM-0003Jb-FF; Wed, 01 Jun 2022 09:29:28 +0100
Date:   Wed, 1 Jun 2022 09:29:28 +0100
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
Message-ID: <YpcjaOdXHC+uYJ2J@shell.armlinux.org.uk>
References: <20220531113058.23708-1-s-vadapalli@ti.com>
 <20220531113058.23708-4-s-vadapalli@ti.com>
 <YpYCJv2SIExL+VHs@shell.armlinux.org.uk>
 <9f531f8d-9ff2-2ec9-504f-eed324ba86c6@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f531f8d-9ff2-2ec9-504f-eed324ba86c6@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 11:39:57AM +0530, Siddharth Vadapalli wrote:
> Hello Russell,
> 
> On 31/05/22 17:25, Russell King (Oracle) wrote:
> > On Tue, May 31, 2022 at 05:00:58PM +0530, Siddharth Vadapalli wrote:
> >> In TI's J7200 SoC CPSW5G ports, each of the 4 ports can be configured
> >> as a QSGMII main or QSGMII-SUB port. This configuration is performed
> >> by phy-gmii-sel driver on invoking the phy_set_mode_ext() function.
> >>
> >> It is necessary for the QSGMII main port to be configured before any of
> >> the QSGMII-SUB interfaces are brought up. Currently, the QSGMII-SUB
> >> interfaces come up before the QSGMII main port is configured.
> >>
> >> Fix this by moving the call to phy_set_mode_ext() from
> >> am65_cpsw_nuss_ndo_slave_open() to am65_cpsw_nuss_init_slave_ports(),
> >> thereby ensuring that the QSGMII main port is configured before any of
> >> the QSGMII-SUB ports are brought up.
> > 
> > This sounds like "if we're configured via port->slave.phy_if to be in
> > QSGMII mode, then the serdes PHY needs to be configured before any of
> > the QSGMII ports are used". Doesn't that mean that if
> > port->slave.phy_if is QSGMII, then the port _only_ supports QSGMII
> > mode, and conversely, the port doesn't support QSGMII unless firmware
> > said it could be.
> > 
> > So, doesn't that mean am65_cpsw_nuss_init_port_ndev() should indicate
> > only QSGMII, or only the RGMII modes, but never both together?
> 
> The phy-gmii-sel driver called by phy_set_mode_ext() configures the CPSW5G MAC
> rather than the SerDes Phy. In the CPSW5G MAC, the QSGMII mode is further split
> up as two modes that are TI SoC specific, namely QSGMII main and QSGMII-SUB. Of
> the 4 ports present in CPSW5G (4 external ports), only one can be the main port
> while the rest are the QSGMII-SUB ports. Only the QSGMII main interface is
> responsible for auto-negotiation between the MAC and PHY. For this reason, the
> writes to the CPSW5G MAC, mentioning which of the interfaces is the QSGMII main
> interface and which ones are the QSGMII-SUB interfaces has to be done before any
> of the interfaces are brought up. Otherwise, it would result in a QSGMII-SUB
> interface being brought up before the QSGMII main interface is determined,
> resulting in the failure of auto-negotiation process, thereby making the
> QSGMII-SUB interfaces non-functional.

That confirms my suspicion - if an interface is in QSGMII mode, then
RGMII should not be marked as a supported interface to phylink. If the
"QSGMII main interface" were to be switched to RGMII mode, then this
would break the other ports. So RGMII isn't supported if in QSGMII
mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
