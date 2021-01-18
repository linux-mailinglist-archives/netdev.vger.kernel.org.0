Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41F02FACB0
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394640AbhARVbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394671AbhARV17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:27:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD96722CB1;
        Mon, 18 Jan 2021 21:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611005238;
        bh=2uDWir6aAAC8UVeOQ8MB1+TSjXuJP6munYgw3bWg5E4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=STeTFM8iSGl90rUcJFOcQ5TivAqI1QEH49aaSU5YPrSUrxtsYX4lhIt+/FHLJ17Yj
         kmAk1Hj/bxt/gAsYWvqKcXghP4JBel5XGK3XJbxYX5gaYVblW3QEmg8Tkw8fFxN8ck
         U4c1z6O7tY7XxfkzabQEDyNUiveBcyGLIy1ajF6d+/MXH5TMXr9ot0UheiQ/zuVIqM
         UbLKoEowFIik2jq/bY2Qd25THqALltBhZY4/wey01hgxYqZtsZZL+X9FIhdsUblvi1
         WfvPhIxsDVXD5wTW5iYr0VdTubDbZC9E1Tue0uYmSD0/+nteVPAAjl240jNM0KFWAm
         8yfIH1RcvCr3Q==
Date:   Mon, 18 Jan 2021 13:27:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Icenowy Zheng <icenowy@aosc.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Shuosheng Huang <huangshuosheng@allwinnertech.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 12/21] net: stmmac: dwmac-sun8i: Prepare for second
 EMAC clock register
Message-ID: <20210118132716.49d39a16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118020848.11721-13-andre.przywara@arm.com>
References: <20210118020848.11721-1-andre.przywara@arm.com>
        <20210118020848.11721-13-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 02:08:39 +0000 Andre Przywara wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> index 58e0511badba..00c10ec7b693 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> @@ -1129,6 +1129,8 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
>  	struct stmmac_priv *priv;
>  	struct net_device *ndev;
>  	struct regmap *regmap;
> +	struct reg_field syscon_field;
> +	u32 syscon_idx = 0;

nit: please keep the longest-to-shortest line ordering of variables
