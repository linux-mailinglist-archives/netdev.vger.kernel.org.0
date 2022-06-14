Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0AF54AC83
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355875AbiFNIth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356582AbiFNItL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:49:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FCB47052;
        Tue, 14 Jun 2022 01:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QQ2FpvP0XV43LJGQiHOvInjKVg2YYiLABEA2FkVs+fk=; b=H41eTaT/754zEkzjyGDSVV1jae
        NNcAaAFkn2nj5kVBye7Xrc5jCnBKmuWzqfoSEajL5c2nmamLHVN+jFZgVvHs5bNoaiZMif52X2otu
        Jw5IYlO39N7sntceRpmlnQ5XVxvpOsMDXV0aHnqAA+PdnUa6gDhJov1Ir4LopBP2soO/rO8IzsIJ5
        Q5+z7pgeBYKBs1GU8ENeU6PWCN9gdTjueFQd2sXZm0lVP2sBYOnxsWIXCZYd+FJkekq250wOqPjNd
        pRrAQCz9tngYKedFAeNrgCWSMv0dtbODygMkcegk922LMqxHGOvcnJa78NjPvmIQ1huISRUX90vpR
        FW40c+iw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32858)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o12DA-0002xL-M9; Tue, 14 Jun 2022 09:47:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o12Cx-0007Ly-ES; Tue, 14 Jun 2022 09:47:31 +0100
Date:   Tue, 14 Jun 2022 09:47:31 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>
Subject: Re: [PATCH net-next v4 3/5] net: pcs: xpcs: add CL37 1000BASE-X AN
 support
Message-ID: <YqhLI0vWuDWNTQ8h@shell.armlinux.org.uk>
References: <20220614030030.1249850-1-boon.leong.ong@intel.com>
 <20220614030030.1249850-4-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614030030.1249850-4-boon.leong.ong@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 11:00:28AM +0800, Ong Boon Leong wrote:
> +int xpcs_modify_changed(struct dw_xpcs *xpcs, int dev, u32 reg,
> +			u16 mask, u16 set)

Why is this globally visible? I can find no reason for it in this patch
set.

> +{
> +	u32 reg_addr = mdiobus_c45_addr(dev, reg);
> +	struct mii_bus *bus = xpcs->mdiodev->bus;
> +	int addr = xpcs->mdiodev->addr;
> +
> +	return mdiobus_modify_changed(bus, addr, reg_addr, mask, set);

There is a mdiodev_modify_changed() which would be slightly cleaner
here.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
