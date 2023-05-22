Return-Path: <netdev+bounces-4359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A2170C2FA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 160351C20B34
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BA8154AD;
	Mon, 22 May 2023 16:06:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6CF13AE7
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 16:06:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09613B6
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Og4lodhFKpW1QN60YIe1CtLOG3awZ87wIG7sXlLotYo=; b=Xfirz69TGExCYr9f2iQCHVLjAV
	PpO2GOYTxHH+J3wh+kH2M4Lixi7O8FzYr1pbkDnMuuTDzzXFnwqeJIOdOM6zbO7Ra8f1nnFqiUUjL
	ejNOh+nnkOlui61gFcBWLNYFO3vQtMcD6FJ7S2rQB7V0uF3QNkJ1o+cSS3Yz+hBzr21tQXVb9fQGg
	VS135om3G6KNhz7tEMMan/MF/biPgp7K2eF0S4FdNIyYiy7NK5U0GBsQHrrrB2lQaZodwmzR2bEI1
	ipIFt3n5djEs+aDEM+K/58FkSTDN3lLb8N+4BvmDPekCQfKM3O/4CzIEsOkDMGuAcW2b5sjCP0gpa
	iZF+cKZA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43442)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q183d-00077q-5A; Mon, 22 May 2023 17:06:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q183b-00084P-VO; Mon, 22 May 2023 17:06:47 +0100
Date: Mon, 22 May 2023 17:06:47 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: avoid kernel warning dump when
 stopping an errored PHY
Message-ID: <ZGuTF6rNEYBOUFCG@shell.armlinux.org.uk>
References: <E1q17vE-007Baz-8c@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q17vE-007Baz-8c@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 04:58:08PM +0100, Russell King (Oracle) wrote:
> When taking a network interface down (or removing a SFP module) after
> the PHY has encountered an error, phy_stop() complains incorrectly
> that it was called from HALTED state.
> 
> The reason this is incorrect is that the network driver will have
> called phy_start() when the interface was brought up, and the fact
> that the PHY has a problem bears no relationship to the administrative
> state of the interface. Taking the interface administratively down
> (which calls phy_stop()) is always the right thing to do after a
> successful phy_start() call, whether or not the PHY has encountered
> an error.

Note that I can reproduce this by repeatedly plugging and unplugging any
SFP with a PHY that we access - if one unplugs it while the PHY is being
accessed, phylib logs an error, and then the unplug event happens which
ends up correctly calling phy_stop(), which then spits out a kernel
warning.

One may suggest that this is an unlikely event, but any SFP using the
Rollball I2C protocol to access the PHY, each access can take tens of
milliseconds, which is more than enough time to hit this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

