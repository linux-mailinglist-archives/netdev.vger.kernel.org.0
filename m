Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708564AB889
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358515AbiBGKNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355058AbiBGKKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:10:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F5EC0401CA;
        Mon,  7 Feb 2022 02:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6sxoW/ISAr7EZslftgzerxXaRtMvkVhaLePDKbPLOas=; b=gSngBZWRfuh9D5OmDHeCRTv/DB
        vZuSAbCv00nahQ+hF31/TwvP8PsoEQS3ePAqMD/bJFnWcxyxjfMiR6nUOq6NxZNwJaMTOkdNzdbxn
        t9W22ey7id5kRthOw22xQVifN22THHUQDYSgYDvoj+jIKKSHC7vzdtWyM9+i+OrjC4yLbyjsuIh/v
        4VA5JFiYmYbB/xYyL3k65h88WEzOtOnZURQrTWI8UoMy3xrnZw08XSIGyAEHBz1sVRr1iz0CzXnev
        TNjDV4WZgYfci0KAAnjKIAT1iuoc5l23sa54CP3BojThkP9pYRWHJmkhqMO6dONzpOESUMF/eFScL
        k060uIuA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57076)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nH0yg-0001Rr-5p; Mon, 07 Feb 2022 10:10:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nH0yb-0007l1-CB; Mon, 07 Feb 2022 10:10:29 +0000
Date:   Mon, 7 Feb 2022 10:10:29 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2 net-next] net: dsa: mv88e6xxx: Fix off by in one in
 mv88e6185_phylink_get_caps()
Message-ID: <YgDwFdW/cBwKXGcx@shell.armlinux.org.uk>
References: <20220207082253.GA28514@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207082253.GA28514@kili>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 11:22:53AM +0300, Dan Carpenter wrote:
> The <= ARRAY_SIZE() needs to be < ARRAY_SIZE() to prevent an out of
> bounds error.
> 
> Fixes: d4ebf12bcec4 ("net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Good catch, thanks.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
