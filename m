Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5472A54C75D
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345269AbiFOLX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344555AbiFOLX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:23:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F9F34663;
        Wed, 15 Jun 2022 04:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8YSiJRfVSCRx99U4o4ghQCn9P4N6/d/6pd8/bsVzP/w=; b=sJwyns6OubrMfUYLSJE9YUhSxl
        wFZOMo2Z/Ni92QoRvJWfpTrl50shcYJRQoRf6+xu3smxsaJwBLyoAFl0cIt98vqOX602Z8LieV9vU
        PsOx1fBdGMxUIke/5Angd2vgYfh+iihFxLe8vQWP5d3PHNJaQvg4czO+2nakqXpuA7V3W31+tAOV7
        4iA1twudj5/aUk4LbxTfn0JjdZStskGbKVRNtGZBsfyHVV9ZS8Jk162BisR4LCe80i0K8EXhOPYl/
        b5a9WvpqAwJbFTMk5ZfSXLc+IOYUjvxPIpFal5ts0ytY9peeFpniCR+61OWtXM30YHsnroirYhcmw
        K4wzjD0w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32876)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o1R7U-0004QB-Vo; Wed, 15 Jun 2022 12:23:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o1R7J-0008NQ-LM; Wed, 15 Jun 2022 12:23:21 +0100
Date:   Wed, 15 Jun 2022 12:23:21 +0100
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
Subject: Re: [PATCH net-next v5 3/5] net: pcs: xpcs: add CL37 1000BASE-X AN
 support
Message-ID: <YqnBKTpbhx+quBIc@shell.armlinux.org.uk>
References: <20220615083908.1651975-1-boon.leong.ong@intel.com>
 <20220615083908.1651975-4-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615083908.1651975-4-boon.leong.ong@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 04:39:06PM +0800, Ong Boon Leong wrote:
> For CL37 1000BASE-X AN, DW xPCS does not support C22 method but offers
> C45 vendor-specific MII MMD for programming.
> 
> We also add the ability to disable Autoneg (through ethtool for certain
> network switch that supports 1000BASE-X (1000Mbps and Full-Duplex) but
> not Autoneg capability.
> 
> v4: Fixes to comment from Russell King. Thanks!
>     https://patchwork.kernel.org/comment/24894239/
>     Make xpcs_modify_changed() as private, change to use
>     mdiodev_modify_changed() for cleaner code.
> 
> v3: Fixes to issues spotted by Russell King. Thanks!
>     https://patchwork.kernel.org/comment/24890210/
>     Use phylink_mii_c22_pcs_decode_state(), remove unnecessary
>     interrupt clearing and skip speed & duplex setting if AN
>     is enabled.
> 
> v2: Fixes to issues spotted by Russell King in v1. Thanks!
>     https://patchwork.kernel.org/comment/24826650/
>     Use phylink_mii_c22_pcs_encode_advertisement() and implement
>     C45 MII ADV handling since IP only support C45 access.
> 
> Tested-by: Emilio Riva <emilio.riva@ericsson.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
