Return-Path: <netdev+bounces-1614-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A95C56FE8A4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4350E1C20E63
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11371369;
	Thu, 11 May 2023 00:28:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048A0363
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:28:29 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279151B1;
	Wed, 10 May 2023 17:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=tcLipFI9l2dcvpk4UR/OvX7URY66r8z0RDWBBZZI3BE=; b=0N0j6XxO3sdBOByU603/1de0hj
	/3hAgqsZZ3F3RPMO2svK5cPiOmcQq6mrUZFp5d+0oCVrYwV4e67vqCE1jGYcreFAwDDXxQzjpUdt5
	OMv0rgJ8WMDZLY335P/kWuyBEKmtL9xTba9nuR4dP4wYYgp2DQiqXxi8VQbXS/cw8vvk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pwuAJ-00CUqP-8i; Thu, 11 May 2023 02:28:15 +0200
Date: Thu, 11 May 2023 02:28:15 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH net-next 0/8] Improvements for RealTek 2.5G Ethernet PHYs
Message-ID: <55c11fd9-54cf-4460-a10c-52ff62b46a4c@lunn.ch>
References: <cover.1683756691.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683756691.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 12:53:22AM +0200, Daniel Golle wrote:
> Improve support for RealTek 2.5G Ethernet PHYs (RTL822x series).
> The PHYs can operate with Clause-22 and Clause-45 MDIO.
> 
> When using Clause-45 it is desireable to avoid rate-adapter mode and
> rather have the MAC interface mode follow the PHY speed. The PHYs
> support 2500Base-X for 2500M, and Cisco SGMII for 1000M/100M/10M.

I don't see what clause-45 has to do with this. The driver knows that
both C22 and C45 addresses spaces exists in the hardware. It can do
reads/writes on both. If the bus master does not support C45, C45 over
C22 will be performed by the core.

    Andrew

