Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0B064F8AE
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 11:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiLQKdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 05:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLQKdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 05:33:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CC3FC3;
        Sat, 17 Dec 2022 02:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T0IUR+h3EWhNWDM44FisaNbp0DfbZTkTXBT9yHJhAaM=; b=I8pkHiPQwndW7XVe/FBXsLJxzf
        BXgJ/WSGTJqgKqM6yLQi3n8UkV1CYgF4OPSGPOxmyYiFA4IokkUwpgESW7lGh7tP+m70ju8jVv5yK
        8y1VxTIM0eGnjbnHYRsHBXgxVgyWrAtyoCWPMtV3K+bN4I7Uw0EZ8nkaWg5E/ioNPoF6ZqOOoAtsR
        nzjvwk91C8ARt3PP5roTj1poWTmcPgXKp9korRhffPWwCRQIiThf0cpU8oAgLYRdthaOmiUlVKzjv
        thGg/Jhn1JWClXET2qOEubNYOaUWGlKwytY4+mll/iPalyt/u7qWVGXENYdXZzXnqEONK/65RLdjE
        qw9eCLrA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35756)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p6UV2-0004F3-68; Sat, 17 Dec 2022 10:33:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p6UUy-0001lu-SJ; Sat, 17 Dec 2022 10:32:56 +0000
Date:   Sat, 17 Dec 2022 10:32:56 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v7 net-next 2/5] drivers/net/phy: add the link modes for
 the 10BASE-T1S Ethernet PHY
Message-ID: <Y52a2PzgS3TRPEQB@shell.armlinux.org.uk>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
 <fb30ee5dae667a5dfb398171263be7edca6b6b87.1671234284.git.piergiorgio.beruto@gmail.com>
 <20221216204808.4299a21e@kernel.org>
 <Y52V/l2BG1WlHdft@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y52V/l2BG1WlHdft@gvm01>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 17, 2022 at 11:12:14AM +0100, Piergiorgio Beruto wrote:
> On Fri, Dec 16, 2022 at 08:48:08PM -0800, Jakub Kicinski wrote:
> > On Sat, 17 Dec 2022 01:48:33 +0100 Piergiorgio Beruto wrote:
> > > +const int phy_basic_t1s_p2mp_features_array[2] = {
> > > +	ETHTOOL_LINK_MODE_TP_BIT,
> > > +	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> > > +};
> > > +EXPORT_SYMBOL_GPL(phy_basic_t1s_p2mp_features_array);
> > 
> > Should this be exported? It's not listed in the header.
> In my understanding PHY drivers can be compiled as modules, therefore
> this should be exported? I see other features arrays being exported as
> well. But If I'm overlooking something I'll be happy to change this.

If something wants to make use of it, it needs a prototype in a header
file. An EXPORT_SYMBOL* only makes it visible to modules at run-time,
it doesn't make it build-time visible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
