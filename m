Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0DC46BC00
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhLGNCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbhLGNB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 08:01:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A680AC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 04:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YZ5ZPNKt1OJkuoldnWyGLjlds9DQ9uLeVVN8FQ4CWVw=; b=aQS1evbZTrsrtHFQHR+BNW1clq
        uU+po9sfsegSjEbl61jNPhAkGAOXbIVvPartOrykzjXBCvGYVeMK52MlcO0hFZRdK5SezoOxFcSOx
        1JTzYvonM0NdAxIULPIPX+f7eoUat6wo4i4koPJehBbOs2jek7wwIOLDZYm2GRjD+RyJCvsyea75r
        zckObXDBlJaZRYxdOfgSYCy3qCzsw5MvZ6rbFnrAYlvvSUVlsgUDbo5H674tPwbagdXiOhw49W8Fd
        tac898hxWleTuJkkkhANbxouE5EqFYWchg3WWM71EXfMQonMNDoW4Y93a6YYLALvCZi+PbGmQC2XY
        JCXQKCMQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56146)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mua35-0006Bj-Pl; Tue, 07 Dec 2021 12:58:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mua33-0005L2-W3; Tue, 07 Dec 2021 12:58:22 +0000
Date:   Tue, 7 Dec 2021 12:58:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU
 and DSA ports
Message-ID: <Ya9abXJELHCaBE0k@shell.armlinux.org.uk>
References: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
 <aa5e48e4b03eb9fd8eb6dacb439ef8e600245774.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa5e48e4b03eb9fd8eb6dacb439ef8e600245774.camel@collabora.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 12:47:35PM +0000, Martyn Welch wrote:
> Sorry Russell, but unfortunately this patch doesn't seem to be
> resolving the issue for me.
> 
> I've dumped in a bit of debug around this change to see if I could
> determine what was going on here, it seems that in my case the function
> is being exited before this at:
> 
> /* FIXME: is this the correct test? If we're in fixed mode on an
>  * internal port, why should we process this any different from
>  * PHY mode? On the other hand, the port may be automedia between
>  * an internal PHY and the serdes...
>  */
> if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
>         return;

Oh, I was going to remove that, but clearly forgot, sorry. Please can
you try again with that removed? Meanwhile, I'll update the patch at
my end.

Thanks.
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
