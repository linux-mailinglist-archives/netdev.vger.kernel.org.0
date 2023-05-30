Return-Path: <netdev+bounces-6440-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1220771648A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8D44281212
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B6C19E42;
	Tue, 30 May 2023 14:42:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D18719516
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:42:01 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B35F9C;
	Tue, 30 May 2023 07:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/lcVrnX7+XrRCgaaZHH0kp2gaMygkIh7ZjhZqlrEWnQ=; b=EnVrVJhkHR5/r+niPhrQYvRxwK
	UuKXFO1S9WWlxix5yCgjlvETE7GYbOOhPqaQhkNlopxJ7Zg5O2Qyj4u16953KxgXNZqamA0PMO+4y
	kIi3rTydXyld7uRPUC2DwwyU4OzeqITd9ayVOC/++ckz2gcmx45dbBcV8t3771hdWfBJaYowjhjoP
	xZwKvS9Kx4EMKPuDiBlO7UGojuQxe9eyyx8EfYUol+YfyUbRwyG11U27kQ/1Nr1ysTOwbxWwWd1AK
	PaIbhAlNauopBYk9gLmKdKyJBt5s1LnZfTkn534vq/b7nozqh04Wj8RWsL11NpKiDaJTYRcJPuaSC
	0jvxhMPQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38996)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q40Xt-0002x1-CH; Tue, 30 May 2023 15:41:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q40Xs-00088R-8O; Tue, 30 May 2023 15:41:56 +0100
Date: Tue, 30 May 2023 15:41:56 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Lukasz Majewski <lukma@denx.de>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <ZHYLNGkG26QP/QAS@shell.armlinux.org.uk>
References: <20230530122621.2142192-1-lukma@denx.de>
 <ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
 <20230530160743.2c93a388@wsk>
 <ZHYGv7zcJd/Ad4hH@shell.armlinux.org.uk>
 <35546c34-17a6-4295-b263-3f2a97d53b94@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35546c34-17a6-4295-b263-3f2a97d53b94@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:26:49PM +0200, Andrew Lunn wrote:
> > So, I'm wondering what's actually going on here... can you give
> > any more details about the hardware setup?
> 
> And what switch it actually is. I've not looked in too much detail,
> but i think different switch families have different EEE capabilities.
> But in general, as Russell pointed out, there is no MAC support for
> EEE in the mv88e6xxx driver.

... except for the built-in PHYs, which if they successfully negotiate
EEE, that status is communicated back to the MAC in that one sees
MV88E6352_PORT_STS_EEE set, which results in the MAC being able to
signal LPI to the PHY... and I've stuck a 'scope on the PHY media-side
signals in the past and have seen that activity does stop without there
needing to be any help from the driver for this.

At least reading the information I have for the 88E6352, there is no
configuration of LPI timers, nor any seperate LPI enable. If EEE is
enabled at the MAC, then LPI will be signalled according to whatever
Marvell decided would be appropriate.

For an external PHY that the PPU is not polling, the only way that
we'd have EEE functional is if we forced EEE in port control register 1
on switches that support those bits. In other words setting both the
EEE and FORCE_EEE bits...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

