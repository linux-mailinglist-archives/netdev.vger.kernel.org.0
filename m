Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9D1462F5C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240058AbhK3JRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 04:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240055AbhK3JRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 04:17:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDF4C061574;
        Tue, 30 Nov 2021 01:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6FE8t/IQzjs7MZIoLedBwmtqQBazVHkPq7YtRv1GtbQ=; b=YCz4YL0YBFmkpK+oFR6GCnpFuu
        gwYIKQ5jg0mF2+JncETedwjw6q3YZPoLN62c8SgZmGgrsZ3Sg2jFsoimhuPF7bma/IyJ5V+NM5Azl
        d0TpLEN3as0K9XcLW3HzXGLfqM0CyGvrnbFVQcmD96/pVkPahgRZRG0wNhA/MfoBzsz2g644LEuFo
        EUQ6ao8i1Sgbh4yr+ngS4i/IyskddbXGsVGNT+9Zeufj4jJMKWLzrZOVTJ+SZVurZEjj4mqCSY2eA
        gg2wChfJtm26k312JuF31RXFpamDUXDSyde+/YnqO7+wPzzBjpxMXBjEO6Wtb74L5oh+McwW5FQvw
        3gSBtf9Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55974)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mrzCy-0006et-E1; Tue, 30 Nov 2021 09:13:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mrzCw-0006vp-Rm; Tue, 30 Nov 2021 09:13:50 +0000
Date:   Tue, 30 Nov 2021 09:13:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: mdio: rework mdio_uevent for mdio ethernet
 phy device
Message-ID: <YaXrTkI/KFxLmYrx@shell.armlinux.org.uk>
References: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
 <1638260517-13634-2-git-send-email-zhuyinbo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638260517-13634-2-git-send-email-zhuyinbo@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 04:21:57PM +0800, Yinbo Zhu wrote:
> The of_device_uevent_modalias is service for 'of' type platform driver
> , which ask the first args must be 'of' that use MODULE_DEVICE_TABLE
> when driver was exported, but ethernet phy is a kind of 'mdio' type
> device and it is inappropriate if driver use 'of' type for exporting,
> in fact, most mainstream ethernet phy driver hasn't used 'of' type,
> even though phy driver was exported use 'of' type and it's irrelevant
> with mdio_uevent, at this time, platform_uevent was responsible for
> reporting uevent to match modules.alias configure, so, whatever that
> of_device_uevent_modalias was unnecessary, this patch was to remove it
> and add phy_id as modio uevent then ethernet phy module auto load
> function will work well.

NAK.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
