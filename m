Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDE8293034
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbgJSVJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732513AbgJSVJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 17:09:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C42CC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 14:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fuHVpjanfVMMKaPp8BbkeI7pQEmUk0JZfQUOUq2X0eI=; b=aBdF1rrVr29urTv4byUyIar8X
        XM6pyB4hlL4pzj2+ZMQeBpmwkfGbGokfKH2rs2Z2EQ7tpC0SUlyAYIcPbM7h9zkMHXx898ca1dIOx
        JudH+Aafx9HrhN4zs98cCd19mDqDDjav1aWQl8JllHUBeX5HVEXaCbms7k4hydVpqUAK4tv78Wdqk
        +hXIagsUr4Cy9nn4dR/6aBYJyClch5VKdlNazfLbaCIg3XOu5ey1/sjLZ/HLQIhPdxyffnF1IsKDr
        khfSBl+bCG7H85+X/18UauNKkCz6rLtDbQuRD0uFnXQPEjoY+t17fe919uG1R/KzZRqkxpL1xziRy
        ZBs82amhg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48384)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUcOl-0006N8-Sg; Mon, 19 Oct 2020 22:08:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUcOj-0004YO-43; Mon, 19 Oct 2020 22:08:53 +0100
Date:   Mon, 19 Oct 2020 22:08:53 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019210852.GW1551@shell.armlinux.org.uk>
References: <20201019204913.467287-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019204913.467287-1-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 02:49:13PM -0600, Robert Hancock wrote:
> The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 81E1111 PHY

You mean 88E1111 here.

> with a modified PHY ID, and by default does not have 1000BaseX
> auto-negotiation enabled, which is not generally desirable with Linux
> networking drivers. Add handling to enable 1000BaseX auto-negotiation.
> Also, it requires some special handling to ensure that 1000BaseT auto-
> negotiation is enabled properly when desired.
> 
> Based on existing handling in the AMD xgbe driver and the information in
> the Finisar FAQ:
> https://www.finisar.com/sites/default/files/resources/an-2036_1000base-t_sfp_faqreve1.pdf

There's lots of modules that have the 88E1111 PHY on, and we switch
it to SGMII mode if it's not already in SGMII mode if we have access
to it. Why is your setup different?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
