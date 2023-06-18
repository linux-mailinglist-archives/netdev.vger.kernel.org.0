Return-Path: <netdev+bounces-11806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4A87347E7
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 21:15:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4AC11C208EB
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40E68470;
	Sun, 18 Jun 2023 19:15:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C873D74
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 19:15:52 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252371B7
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 12:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/G+S0kzPjiD6hYTdcjtrxAXG6faNMBPFRjJF1utC/Pk=; b=i1c1dTW2lcQitPjB1N3GogDNG1
	wxR5K7xQ1TQUO0G0W925D9IqizhFtoMUDcypbiNHvSxsfKcIEUc/DUIaLxPqphS4YztYpsSop9Z+M
	aK2jrLxK9xqII1BIOj4RfB5qLuLTVw7lHuBRMTJyarTmt+xMlj03jRkchMPSDkjvTcS8L+e0EGbWI
	7nVNtP8txPqwm6W/bDzq2FLCCDsaNFo2DWbl4QxcMX6hnmKhu6FpU6ApDSxEAdmmfB/5e8q6EJQQl
	GOKzCAIbMwyKqc2w35InZmOBBYygdkxrB4yF7dSsXDIRQshAaHTF1cEkGhmfW2pGhioqIV4MwMC3s
	kvyvOH+g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34382)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qAxsI-0007Wn-Lh; Sun, 18 Jun 2023 20:15:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qAxsH-0004qo-Kx; Sun, 18 Jun 2023 20:15:45 +0100
Date: Sun, 18 Jun 2023 20:15:45 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>, ansuelsmth@gmail.com,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v0 3/3] net: phy: marvell: Add support for
 offloading LED blinking
Message-ID: <ZI9X4Qe2iHc2q6QH@shell.armlinux.org.uk>
References: <20230618173937.4016322-1-andrew@lunn.ch>
 <20230618173937.4016322-3-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618173937.4016322-3-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 07:39:37PM +0200, Andrew Lunn wrote:
> Add the code needed to indicate if a given blinking pattern can be
> offloaded, to offload a pattern and to try to return the current
> pattern. It is expected that ledtrig-netdev will gain support for
> other patterns, such as different link speeds etc. So the code is
> over-engineers to make adding such additional patterns easy.

Hi Andrew,

What is the effect of this patch when LEDs are configured via the
existing DT property that allows arbitary register writes in this
driver?

There are a number of DTs that configure the LEDs this way, and
I don't think we would wish to regress that established configuration.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

