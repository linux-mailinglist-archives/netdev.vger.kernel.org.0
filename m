Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F8C37F4E4
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 11:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhEMJjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 05:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhEMJjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 05:39:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC63AC061574;
        Thu, 13 May 2021 02:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KrP6SOX0x86614uuETg88bVN1b1PzU7zY1Br0j675x8=; b=gTwifMER8vPwjYLdlxTA/a53n
        sSOCrP2RU7dVECBvzYNhbxkfzmANsJ0sT/CxThy/wAEeDErWCDf1X8PPActc7U7svENFTDJT8cutu
        u7q0eEZar+qI5H3LSNho/KL9eInQ7VqnVZS5myngOU7Ay0OX2+1rFBtsk9JM3Wu0HRSf8sZ8kk/9Q
        yCLaNHjkMWVLdL8Hw5/3h70AEKgzg7Wjeplq1aTAtvlWTSiHj+gChHxkx/zLLHKi3MKCm9hb8SWiy
        ShPVGoMQSVH8gIetv4JQASI/99LBzsPg6pF6vkQoefzVj2iV3JtVyzyykVXYxCxdqse+uKItu0yGa
        ah6bpU8oA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43920)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lh7mz-0005tm-Jo; Thu, 13 May 2021 10:37:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lh7mx-0002t7-Ne; Thu, 13 May 2021 10:37:51 +0100
Date:   Thu, 13 May 2021 10:37:51 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2] net: mdio: thunder: Fix a double free issue in the
 .remove function
Message-ID: <20210513093751.GU1336@shell.armlinux.org.uk>
References: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 09:44:49AM +0200, Christophe JAILLET wrote:
> 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.
> 
> Remove the incorrect 'mdiobus_free' in the remove function.
> 
> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Also note that I did review your patch, and give you a reviewed-by for
it, which I think should have been carried over to v2 since Andrew's
comment was only concerning the formatting of the subject line. The
patch content is entirely fine. So, I'll give it again, so patchwork
gets the right information:

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

My comments about the unregistration are a separate bug that should be
addressed in a separate follow-on patch. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
