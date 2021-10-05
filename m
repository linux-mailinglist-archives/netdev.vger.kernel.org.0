Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E633C4222B2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhJEJxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbhJEJxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 05:53:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E135FC06161C;
        Tue,  5 Oct 2021 02:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rvTAA/S1qTFQnVPQl2To8Sp/QSkNKF02DKAlD/yXSNU=; b=gHES+WMIGOHFt5G6fas3+mpNGp
        UXHw12zXFfUhO2WKaBNst2q4sT3wkEeVD8zd9Mak5eW7upLtFsb8V1VoP5b/NQDJ3GMIPRziOXRzM
        p7TKUTKc8PbVSJGsiRFiZYJk62MM0LVgOWsmCDYeFznZPgZoPU3Z0n0aydmTUkhk6kcqxNIdJLzux
        PEogo4VYEpyuiBwuf+YvfVR/GsLtezZiONnO0NMlct3VTDZndneskBioYNoLkDmt9HJcbS0i++wq7
        RFitPvyl7Qb9g4LZaWkENRdaR6kZ5+noXHjMLIuZgRt8sOxclW/nCGTQagLK8lm0ib97QJ/R8C/2r
        MOz5JJ8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54948)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXh6p-000067-7o; Tue, 05 Oct 2021 10:51:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXh6o-0008N4-6J; Tue, 05 Oct 2021 10:51:38 +0100
Date:   Tue, 5 Oct 2021 10:51:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next PATCH 06/16] net: phylink: Add function for
 optionally adding a PCS
Message-ID: <YVwgKnxuOeZC6IxW@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-7-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-7-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:17PM -0400, Sean Anderson wrote:
> This adds a function to set the PCS only if there is not one currently
> set. The intention here is to allow MAC drivers to have a "default" PCS
> (such as an internal one) which may be used when one has not been set
> via the device tree. This allows for backwards compatibility for cases
> where a PCS was automatically attached if necessary.

I'm not sure I entirely like this approach. Why can't the network
driver check for the pcs-handle property and avoid using its
"default" if present?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
