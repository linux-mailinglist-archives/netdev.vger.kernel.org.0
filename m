Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F38554D67
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358673AbiFVOfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358666AbiFVOfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:35:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FA33B546
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FycNZ0drijfgNsPYujyYHdFlbXslN/e1iKCzNQHlVko=; b=pvGHQxRB/bdSG6fnwbO17CYd3m
        F4whQqkOfPyedx4A/eOSNDF3kkcodMBo/szR2k87byu+APfPVYh62x8Gs16n8uMwj/7Dmj4JQddmc
        6g/5et90mof6WRe52DF14/95ExbmL62h7pfU3PlCKJJWA3tXsRnQGFI7H4Duz0/pZpUpw3kq4b5oz
        Ym97kw1DgezxmduH3SOSLjDyYNnveFzmFAD9Gbt0y17U+ahtC5ZkIJjRVS5yKujtVcFvvHbSFQ/ex
        dN12OxeZYslqjW/I3m8CDteMMY7cgx+iSAa54xvjWVrwkBi/n9LFeiawuU7QIMuZqzsSeEIWo0Zr2
        JtVTZnpw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32988)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o41Rn-0003i3-4E; Wed, 22 Jun 2022 15:35:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o41Rh-0007VE-EC; Wed, 22 Jun 2022 15:35:05 +0100
Date:   Wed, 22 Jun 2022 15:35:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net-next v2] net: pcs: xpcs: select PHYLINK in Kconfig
Message-ID: <YrMomUJ9HO0aIukP@shell.armlinux.org.uk>
References: <54288e0ef07ac8a40cf28d782aa3f1e8acaa4b59.1655906864.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54288e0ef07ac8a40cf28d782aa3f1e8acaa4b59.1655906864.git.pabeni@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 04:31:56PM +0200, Paolo Abeni wrote:
> This is another attempt at fixing:
> 
> >> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> >> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> 
> We can't mix select and depends, or that will trigger a circular dependency.
> We can't use 'depends on' for PHYLINK, as the latter config is not
> user-visible.
> Pull-in all the dependencies via 'select'.
> Note that PHYLINK already selects PHYLIB, which in turn selects MDIO_DEVICE.
> 
> v1 -> v2:
>  - use 'select' instead of 'depends on' (Jakub)

Why? I'm failing to understand the rationale here. See my reply to
Jakub sent a few minutes ago.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
