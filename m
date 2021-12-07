Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BDD46BE35
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbhLGO5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238271AbhLGO5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:57:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F9EC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 06:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qEtHhJBLQ9ZROQ9PQxUStiU/tLhXm6fnS3cSVeD+HRk=; b=V0xXrfZt6Lz2+jCPPo/oYUbrFe
        x4m/Dc+Kfr08OXEYp3cgSjJlDKa0K1Dq/wKyr66M1A7gxSdXv62VwsZMMVM9qzbVDHf0sGeu9TbLo
        7w6D02CY8Eft2MQekhDxomDX1yVPoeC/1oENMRVRARFxZPDNYN+NnJUQipsutvAIhC/MEcGyg1irM
        lmvT2W4TjTs3D5r5M4rnqct+nAJQYe+ZwYdC60UtmiPJ/ogNojInLWe3QJ+RG1TTDK9diRitRS9JR
        Viy5ZxFeAhYBjiu/RRgaJ4eaYNKCdtrKru+C45PhR7hm1ltGPQMVXAABTyS75blMV3ftsUtP5Px3X
        D+bMFw5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56160)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mubqj-0006KN-0t; Tue, 07 Dec 2021 14:53:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mubqi-0005QB-3E; Tue, 07 Dec 2021 14:53:44 +0000
Date:   Tue, 7 Dec 2021 14:53:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya91eO25R/yehy+k@shell.armlinux.org.uk>
References: <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <Ya6FcTIbyO+zXj7V@shell.armlinux.org.uk>
 <20211206232735.vvjgm664y67nggmm@skbuf>
 <Ya6xrNbwZUxCbH3X@shell.armlinux.org.uk>
 <20211207132413.f4av4d3expfzhnwl@skbuf>
 <Ya9op2QJwWRyqmDY@shell.armlinux.org.uk>
 <20211207143705.46fd2zavniwb3gri@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207143705.46fd2zavniwb3gri@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 04:37:05PM +0200, Vladimir Oltean wrote:
> Although it isn't strictly true that "[ if ] there is a non-software
> method to handle the status updates, then we don't do any forcing in
> the mac_link_*() methods", because technically we still do in
> mac_link_down, due to the " || mode == MLO_AN_FIXED" condition plus the
> way in which we are called, it's just that we undo it later.

Fixed links are a "software method" as Andrew has already pointed
out - there is a software hook that can be used to retrieve the
link status, potentially also updating the other link parameters
as well.

Fixed links have never been "these are the only parameters you will
ever get and the link will always be forced up". That is not new.
Have a look at drivers/net/phy/fixed_phy.c and its link_update()
method, which can change any parameter of the fixed-link it desires.
There is also fixed_phy_change_carrier() which allows one to force
the link state of a fixed-link.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
