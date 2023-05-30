Return-Path: <netdev+bounces-6520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4234716C10
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC40C281287
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD68E2D25C;
	Tue, 30 May 2023 18:14:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD361EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:14:30 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A1510A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=f3EHmXNJ/70uu48BxfNIikj/N0jwzDCJzCS1W7ReQXM=; b=PYr8FHC7pbpLza3AoKelhtZf9I
	uDz9jEorEHKnd/f98nujzpp4DW2vMrarynl7lIujmjQEPF5NVJqpAjdAkd6tMHV58rRhCiScCnhub
	rCiBXyzVeZ5YWNQcY7bOeRS5lwZ0V3fX62YRwuCXqSn91LpHxKMhJQNpAAA51didWNp0yGQ4djyEk
	m20Ceba0ouz61APma+8uHOoWF/JfLpY0FMI7WOBBlzRAT45JGQI7TYTQfrMtzgkEEtpTrCnH/re7x
	Sh2op1SAoBXOiG6aLeIMrjUWaFM0bG/naL9J6c3ge/N0hWQhH9Pb03NKM/XPEFeytyO4pFwhxgy24
	BWO9mnFQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53538)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q43rV-0003Hz-CO; Tue, 30 May 2023 19:14:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q43rU-0008H2-IR; Tue, 30 May 2023 19:14:24 +0100
Date: Tue, 30 May 2023 19:14:24 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 04/24] net: phy: Keep track of EEE tx_lpi_enabled
Message-ID: <ZHY9AE5swwyX06p0@shell.armlinux.org.uk>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-5-andrew@lunn.ch>
 <5c7a9903-2d4b-cb25-d481-bf78bd70d1ee@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c7a9903-2d4b-cb25-d481-bf78bd70d1ee@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 11:11:22AM -0700, Florian Fainelli wrote:
> On 3/30/23 17:54, Andrew Lunn wrote:
> > Have phylib keep track of the EEE tx_lpi_enabled configuration.  This
> > simplifies the MAC drivers, in that they don't need to store it.
> > 
> > Future patches to phylib will also make use of this information to
> > further simplify the MAC drivers.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>

To Andrew: I'm not sure this is a good idea, having read 802.3 recently.
EEE is supported on optical as well, which means that LPI, being a MAC
thing, would need to be controlled without the PHY present.

A phylink using driver would need to store the LPI config when it's
used without a phylib PHY. Maybe phylink can store it on behalf of
of the driver instead though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

