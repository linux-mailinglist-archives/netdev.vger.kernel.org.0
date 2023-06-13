Return-Path: <netdev+bounces-10374-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 408E672E2D8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9E28280C9A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0743A31EFD;
	Tue, 13 Jun 2023 12:26:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE2C3C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:26:32 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD61CE
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=/iU/ZSuxDUV236/57fxLLdZ0AOHWWf+ymczZdFb7YWg=; b=B74h35T6fR2PbzY9mf/KyHQMld
	TO9YCJ+jFM5qwBbxsCwN/LvTYLnqDOGvG8n04cLuA/xVDRf7AMLhkwOeV0EYgCExzpFOMCsaih7Er
	bSIURlGvxoydKBDaE+fXVRb7TE6r2/esDH0JiRNpYyDTPWfPgbZpXoK3SkkU/Oor5qnM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q936M-00Fj51-2E; Tue, 13 Jun 2023 14:26:22 +0200
Date: Tue, 13 Jun 2023 14:26:22 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 2/4] net: phylink: add EEE management
Message-ID: <e6a62d6c-7c1e-4084-b5e7-f5ffa2a2da02@lunn.ch>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9R-00DI8g-GF@rmk-PC.armlinux.org.uk>
 <bca7e7ec-3997-4d97-9803-16bfaf05d1f5@lunn.ch>
 <ZIY+szvNDxFCn94b@shell.armlinux.org.uk>
 <50a42dc7-02df-4052-abeb-7d7b9cd7225e@lunn.ch>
 <ZIgzUZSKW0WsA0AC@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIgzUZSKW0WsA0AC@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I'm wondering if, rather than adding a bit to mac_capabilities, whether
> instead:
> 
> 1) add eee_capabilities and re-use the existing MAC_CAP_* definitions
>    to indicate what speeds the MAC supports LPI. This doesn't seem to
>    solve (c).
> 2) add a phy interface bitmap indicating which interface modes support
>    LPI generation.
> 
> Phylib already has similar with its supported_eee link mode bitmap,
> which presumably MACs can knock out link modes that they know they
> wouldn't support.

O.K, I can probably make that work. None of the MAC drivers i've
looked at need this flexibility yet, but we can add it now.

I do however wounder if it should be called lpi_capabilities, not
eee_capabilities. These patches are all about making the core deal
with 99% of EEE. All the MAC driver needs to do is enable/disable
sending LPI and set the timer value. So we are really talking about
the MACs LPI capabilities.

	Andrew

