Return-Path: <netdev+bounces-1611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8E06FE7F2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7B4428161A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49941E528;
	Wed, 10 May 2023 23:08:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993371E50D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 23:08:16 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAA1B1;
	Wed, 10 May 2023 16:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=ZiW05wKPLD7YCuYetjd69zZZPcMJTzbLVXYOQGMznZs=; b=pqftOVm0RQw6AHZbB4QudUbxlg
	8PgU+yebmovbsSnp8RZBjrUQFJhVdeMBQQwMcCduSxr7WDEHL5YCc5RlH8vc6bgkYamcRIt5ZXpjp
	1HP6XP9yECMPv8vBm73DFd9t1kboP4PHvRdJ23mq4OjW4njtl4GM/3+WsxO1hu1wAzjA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pwsue-00CUfW-GC; Thu, 11 May 2023 01:08:00 +0200
Date: Thu, 11 May 2023 01:08:00 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Qingfang Deng <dqfext@gmail.com>,
	SkyLake Huang <SkyLake.Huang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH net-next v3] net: phy: add driver for MediaTek SoC
 built-in GE PHYs
Message-ID: <e7671e05-3a42-4c73-b1f5-05ed83a60c18@lunn.ch>
References: <ZFwVwlN0eHjo_xB4@pidgin.makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFwVwlN0eHjo_xB4@pidgin.makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +static int mt7988_phy_probe_shared(struct phy_device *phydev)
> +{
> +	struct mtk_socphy_shared_priv *priv = phydev->shared->priv;
> +	void __iomem *boottrap;
> +	struct device_node *np;
> +	u32 reg;
> +
> +	np = of_find_compatible_node(NULL, NULL, "mediatek,boottrap");
> +	if (!np)
> +		return -ENOENT;

Is this documented somewhere in the DT binding document?

The rest of the driver just seems to be undocumented magic which
nobody except the vendor would understand.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

