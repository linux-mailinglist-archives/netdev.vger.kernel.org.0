Return-Path: <netdev+bounces-4058-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CA170A567
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 06:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87D2D281A3B
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A793E652;
	Sat, 20 May 2023 04:51:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D470363;
	Sat, 20 May 2023 04:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7CBC433D2;
	Sat, 20 May 2023 04:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684558287;
	bh=VmdDGzzgUgkYiZG4TzyLb4L00axWz377Vxh71RqYFCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gKNmvtsg03Bdu7j5YgpWq7uIEhf8VBVkyz/88FzqdVrHp995IJB5yhDpkJp6TQSRg
	 6QbkKmB0oNtGNFAcCj2598vlwZTuyz0Yl+tozh8zlC6PuAqhonK/WaC5HOB44FYBk+
	 RFATiz3i4UucevkyWnBjDJvnfqlmqu5bRzIWy3bbAA5496jlqHD11Opjc0l9K3sFiz
	 Yjar5izy/vlFmSGRS6f0TKC+UEx9hvg4Pne1+pdAeHTuV7FnNJBbhcpSQXtn74+cP6
	 nIuUaznVs6R2rdVGk7qkytUTS9vOth+jGm7yVEp9JQTOueprZ5FFPlqa/jIfvxelWP
	 9+8z/fGKl//ew==
Date: Fri, 19 May 2023 21:51:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>,
 Heiner Kallweit <hkallweit1@gmail.com>, Clark Wang <xiaoning.wang@nxp.com>,
 NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
 imx@lists.linux.dev
Subject: Re: [PATCH v3 net] net: fec: add dma_wmb to ensure correct
 descriptor values
Message-ID: <20230519215126.4ecc695b@kernel.org>
In-Reply-To: <20230518150202.1920375-1-shenwei.wang@nxp.com>
References: <20230518150202.1920375-1-shenwei.wang@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 May 2023 10:02:02 -0500 Shenwei Wang wrote:
> Two dma_wmb() are added in the XDP TX path to ensure proper ordering of
> descriptor and buffer updates:
> 1. A dma_wmb() is added after updating the last BD to make sure
>    the updates to rest of the descriptor are visible before
>    transferring ownership to FEC.
> 2. A dma_wmb() is also added after updating the bdp to ensure these
>    updates are visible before updating txq->bd.cur.
> 3. Start the xmit of the frame immediately right after configuring the
>    tx descriptor.
> 
> Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

Applied, thanks (commit 9025944fddfed).

