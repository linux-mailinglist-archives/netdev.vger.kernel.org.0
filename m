Return-Path: <netdev+bounces-1993-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1171F6FFE40
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEE8B2817D2
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B1B7F0;
	Fri, 12 May 2023 01:06:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3BC39D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27BCC433D2;
	Fri, 12 May 2023 01:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683853570;
	bh=O2xWsXKa4DjDdRZtiAgJqkrBYrAeY725PaQRhhhgrEQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pBrwLga7/TezsQ1Kh7o15ipSWuuCVFFIHPkIkomN4nRFP0Wxljj/vefQ32eDNjIJq
	 rpQ/eJoZ/LRvVBiOWMj6ZuEq0xoTzt0enapdJ7QNjA6PC5sAOpvQ2TqIAxjKxJZugX
	 r/AZvRyw4bcHXmSFA6+Yc88DAq30831M1neh3OhcpHsMofQczURhSqI5mHlMbslRAQ
	 vIgiC9wweJ+8Y1lZkhtoGmOuOnTValycTxHzZrHlqrCTAGwTQ6M/Eq0sZ01yxBCZOe
	 cSpOHkWWAiFjaIxsWrHvfIZ2WT7Q/SnHFJ52/ZwRgpMf7apNU/D6AI6IOdaQ1VCGVq
	 ToPHUTgvERRKQ==
Date: Thu, 11 May 2023 18:06:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Lorenz Brun <lorenz@brun.one>
Cc: Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>, Sean Wang
 <sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>, Lorenzo
 Bianconi <lorenzo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 net-next] net: ethernet: mtk_eth_soc: log clock
 enable errors
Message-ID: <20230511180608.6e1f6620@kernel.org>
In-Reply-To: <20230510181350.3743141-1-lorenz@brun.one>
References: <20230510181350.3743141-1-lorenz@brun.one>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 May 2023 20:13:50 +0200 Lorenz Brun wrote:
>  	for (clk = 0; clk < MTK_CLK_MAX ; clk++) {
>  		ret = clk_prepare_enable(eth->clks[clk]);
> -		if (ret)
> +		if (ret) {
> +			dev_err(eth->dev, "enabling clock %s failed with error %d\n",
> +				mtk_clks_source_name[clk], ret);
>  			goto err_disable_clks;
> +		}

dev_err_probe() would be even better, I think?
-- 
pw-bot: cr

