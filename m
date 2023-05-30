Return-Path: <netdev+bounces-6321-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7DC715B0E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:07:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AC4828108F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F41171A9;
	Tue, 30 May 2023 10:07:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2707916418
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:07:09 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88FE198;
	Tue, 30 May 2023 03:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DeGM5yOpHooeQ82+eW4FvCK3F5xMOkbvQi/JFnXPufI=; b=QDopZATpyOhejCzUaEh7/eJFz1
	WS1a6CM1qRLdHf0/qzBgUUPT8ygqYZCr0+oY4IxFZxkBUYTUmsqsbhn1JI3AnqJqyGqiZyq7ZU3T8
	if1MPrNivamFWu0/mtDnzdXF72TQicmAe0c5LES2GmY3BUQlcuROztIPjmv958FF1jL4OHXMGPap0
	RmpOLo9Zei3YuKQb6hDcnRSrzWHyYIbLbm6SHYIDq/n3yKR1uTidUBCIF7L6+g5EWiORBxRK9OGPX
	felfXnyD1A/FTF8POmNmLd/BDMPbvXoAQLK0tLjuHoOZz77eOokOZU/mnKTq0dmZFvpo01vDeGoXe
	9OZUJLBA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36330)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q3wFd-0002P8-EG; Tue, 30 May 2023 11:06:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q3wFb-0007ve-7m; Tue, 30 May 2023 11:06:47 +0100
Date: Tue, 30 May 2023 11:06:47 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <ZHXKt2Zfr/zSqIMq@shell.armlinux.org.uk>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
 <20230529215802.70710036@kernel.org>
 <c7a1ee2dea22cd9665c0273117fe39eebc72e662.camel@redhat.com>
 <813008f6-cb26-4666-81ca-6f88c04bba07@kili.mountain>
 <ZHXGoaXX2YhqP2lm@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHXGoaXX2YhqP2lm@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 10:49:22AM +0100, Russell King (Oracle) wrote:
> On Tue, May 30, 2023 at 12:23:32PM +0300, Dan Carpenter wrote:
> > I don't see an issue in r8169_main.c and in drivers/net/phy/phy_device.c
> > then I only find the bug from this patch.
> 
> I agree - inspecting the code reveals that "val" would be of type "int".
> 
> > +	BUILD_BUG_ON((typeof(val))~0ULL > 0);				\
> 
> I've just thrown this in to my builds, and building for arm64 using
> debian stable's gcc, I don't see any errors with genphy_loopback()
> suitably hacked, even with r8169 included in the build.

Also successfully built with 32-bit ARM gcc.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

