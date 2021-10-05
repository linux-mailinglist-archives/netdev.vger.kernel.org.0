Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C14D423364
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbhJEWVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbhJEWVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 18:21:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69654C061762;
        Tue,  5 Oct 2021 15:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RkFnH7gA1sxL0O7gZh5eOoc5pnK3yQDNTNpNInHSkl4=; b=Cey2qd5E4HCJa4Rg23TMyXNhmQ
        qhCbwW3OCVRdUasHDrBoPVd7tI8ygPFrXd01+K3TQlvSIjOAHeQp4vdQezOj/+ltMubuGI5NJN70U
        4GedL32q5SKhQAVbz4veRpShANHj91L7QjDtzDkSf71kCIOsbgBYYlQcmadIFj7OJYCkcn31L4LAn
        n2jJt/aSyGMGnrG8ntOkbiy72Oa3hOpPprFXJpEQvFiIgMFHiLA8pXr7Pd3vxbZg/n/B3ydgTMu1A
        eRr38pFfgdLXql56m2ao5RTm4GuPnMs/EtzMGAELuBAkROJgDdwy9Z398BW4nORlibAwTvqOCdlcp
        qw/dXqxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54968)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXsmo-0000mo-Ez; Tue, 05 Oct 2021 23:19:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXsmn-0000NR-MA; Tue, 05 Oct 2021 23:19:45 +0100
Date:   Tue, 5 Oct 2021 23:19:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [RFC net-next PATCH 10/16] net: macb: Move PCS settings to PCS
 callbacks
Message-ID: <YVzPgTAS0grKl6CN@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-11-sean.anderson@seco.com>
 <YVwjjghGcXaEYgY+@shell.armlinux.org.uk>
 <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
 <YVyfEOu+emsX/ERr@shell.armlinux.org.uk>
 <ddb81bf5-af74-1619-b083-0dba189a5061@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddb81bf5-af74-1619-b083-0dba189a5061@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 05:44:11PM -0400, Sean Anderson wrote:
> At the very least, it should be clearer what things are allowed to fail
> for what reasons. Several callbacks are void when things can fail under
> the hood (e.g. link_up or an_restart). And the API seems to have been
> primarily designed around PCSs which are tightly-coupled to their MACs.

It has indeed been designed around that, because that's where the
technology that has been available to me has been. It is only in
the recent few years that we are starting to see designs where
the PCS is separate.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
