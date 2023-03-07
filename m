Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E5D6AE3B0
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCGPCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCGPC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:02:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75AC92BD1;
        Tue,  7 Mar 2023 06:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=52aUlbvng8ZlSp5SHAYvGoE7nONOcBEC7hFRcVN2iRc=; b=FyDOP/6Gvkyu/VtmHz7xOyXh6N
        AVAQjso/fCR2NkcrGWG/0WXOBz2EEl6kBfShcAPGNFrDbwOeNQ6r9ffrXQ70EEpKKwVfvwwYMz8Lv
        lY5O/DBsba4+5xTophqwCMhXFI7jqU0skSMLxFWo88r/q10zC15tNK8Gxb+XY8BZ73MOCaXqE58zA
        YLuBQriaWisGZl0bKkeIzQZrT66uDV1OeIjP2cN48k8gR8ga2Nv7KTl1XKZgdp+py0B+AoV3xGxxt
        jsvjv3M85Rn9A0G/M0ems4WJIL/TDxVxXKM6H9idA8wTH+VHcdGpgTJkxGqzI3TuVaW3dNrcp/nZQ
        nb6hlXLQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47312)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZYeD-0000Ym-So; Tue, 07 Mar 2023 14:50:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZYeC-0001c8-3F; Tue, 07 Mar 2023 14:50:36 +0000
Date:   Tue, 7 Mar 2023 14:50:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <ZAdPPAL549lg1uFG@shell.armlinux.org.uk>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <7a02294e-bf50-4399-9e68-1235ba24a381@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a02294e-bf50-4399-9e68-1235ba24a381@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 03:22:46PM +0100, Andrew Lunn wrote:
> > +		switch ((enum mdio_nl_op)insn->op) {
> > +		case MDIO_NL_OP_READ:
> > +			phy_id = __arg_ri(insn->arg0, regs);
> > +			prtad = mdio_phy_id_prtad(phy_id);
> > +			devad = mdio_phy_id_devad(phy_id);
> > +			reg = __arg_ri(insn->arg1, regs);
> > +
> > +			if (mdio_phy_id_is_c45(phy_id))
> > +				ret = __mdiobus_c45_read(xfer->mdio, prtad,
> > +							 devad, reg);
> > +			else
> > +				ret = __mdiobus_read(xfer->mdio, phy_id, reg);
> 
> The application should say if it want to do C22 or C45. As you said in
> the cover note, the ioctl interface is limiting when there is no PHY,
> so you are artificially adding the same restriction here. Also, you
> might want to do C45 on a C22 PHY, e.g. to access EEE registers. Plus
> you could consider adding C45 over C22 here.

Remembering of course that C45-over-C22 on a device that isn't a PHY
could end up causing havoc, but then if you are using this interface,
you already have the gun pointing at your foot... and if you go and
try C45-over-C22 to scan a MDIO bus, you'd definitely be pulling the
trigger too.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
