Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16AE3691D89
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjBJLEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjBJLEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:04:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F196D71647;
        Fri, 10 Feb 2023 03:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OiSEzv9rtDSTvo2Zi5fGTIDoz35QzbSPZrOm1laNUMM=; b=q31jFGPkY6EPYOhhEOFeBuqgBW
        9DYtv8WXHGxMdfHJ/89KrDHm9dh9XGlQwu2RZR+kcob86Cka/SdhvlV23IZiQJwxArdcvGBNIn9bA
        6YQ0s3K1bsHI04vVpdhl0vpALG0d4hNE5lhaNc+U6ZRbwUC3PEhLGhqyWY+XFq3SA8T7C++E8jiK4
        vzufbQ1BC3MoOt4TSNpJ+IeGTpno75pw8TBo5MF0EBC6lzKQILQCGUBT6dnNA3RRk0bIlrajPTdKG
        3VxSbk4OXtnWvxaFZvyhf5wayWduKUrImf8HixkA/QfMx6UX3UH08sIMjHSy2OECuJqcz0ZL9xt8X
        BH16j7Xw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36512)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQRBu-0001MT-Sf; Fri, 10 Feb 2023 11:03:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQRBm-0005WD-Us; Fri, 10 Feb 2023 11:03:34 +0000
Date:   Fri, 10 Feb 2023 11:03:34 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Clark Wang <xiaoning.wang@nxp.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 3/6] net: stmmac: start phylink before setting
 up hardware
Message-ID: <Y+YkhjyaL+hNGW+7@shell.armlinux.org.uk>
References: <20230116103926.276869-1-clement.leger@bootlin.com>
 <20230116103926.276869-4-clement.leger@bootlin.com>
 <Y8UsvREsKOR2ejzT@shell.armlinux.org.uk>
 <20230207154135.6f0e59f8@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230207154135.6f0e59f8@fixe.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 03:41:35PM +0100, Clément Léger wrote:
> Le Mon, 16 Jan 2023 10:53:49 +0000,
> "Russell King (Oracle)" <linux@armlinux.org.uk> a écrit :
> 
> > On Mon, Jan 16, 2023 at 11:39:23AM +0100, Clément Léger wrote:
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > index f2247b8cf0a3..88c941003855 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > @@ -3818,6 +3818,12 @@ static int __stmmac_open(struct net_device *dev,
> > >  		}
> > >  	}
> > >  
> > > +	/* We need to setup the phy & PCS before accessing the stmmac registers
> > > +	 * because in some cases (RZ/N1), if the stmmac IP is not clocked by the
> > > +	 * PCS, hardware init will fail because it lacks a RGMII RX clock.
> > > +	 */
> > > +	phylink_start(priv->phylink);  
> > 
> > So what happens if you end up with the mac_link_up method being called
> > at this point in the driver, before the hardware has been setup ?
> > 
> > If you use a fixed-link, that's a real possibility.
> 
> I actually have this setup. On the board, one GMAC is connected to a
> DSA switch using a fixed-link and the other using the PCS such as added
> by this series.
> 
> From what I see, indeed, the mac_link_up() function is called before
> stmmac_hw_setup(). This does not seems to have any effect on my setup
> (except making it working of course) but I agree this is clearly not
> ideal.
> 
> What I could do is adding a function in the miic pcs driver that could
> be called from my rzn1 stmmac probe function to actually configure the
> PCS at probe time based on the detected "phy-mode". Does that seems
> better to you ?

I think Clark Wang is also working on addressing a very similar problem
with stmmac. Please can you check out his work first, he's adding a new
function to phylink to bring the PHY up early in the resume path.

I would like you both to work together to address what seems to be the
same issue.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
