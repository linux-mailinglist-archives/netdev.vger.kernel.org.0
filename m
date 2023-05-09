Return-Path: <netdev+bounces-994-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBEF6FBC9C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62C4B2811C7
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8332F38C;
	Tue,  9 May 2023 01:46:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AAE7C;
	Tue,  9 May 2023 01:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780DDC433EF;
	Tue,  9 May 2023 01:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683596770;
	bh=LMdyy4IWImsK1SA4AwNEk1jXTLpVOax2pWupABnOyyE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ppo75Es8pZDmR2UJFCljfloHMxHGWgtxDW2pQAfDljVapDchuX6aM8fMgcXKQCi1G
	 7eIoD9NBJ63bpTqPyHoqICqWlezZNenHATl6ATLsvkqEckVxZOa2dhJmu3vXN3lHTe
	 3ik9h2LZUz067Dy9nMHnLSHCJhQBsRC4TL3GhZ8ph8TiuBtoVpqpooQEliBW2gdc+A
	 A8jTE3ubntK545W76Lh3jgVjXSxWLPrXEKY9LzFd5riajDWI4QA+x5FrF1nr7HOVjX
	 vvaNbfbtvEVVMGnM/IDGHmQMYplUWGrMbi3tgNH4xN+2FtRRAqI9IdwEUiGrA2e5AG
	 tEmXfM7drYI3Q==
Date: Mon, 8 May 2023 18:46:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Clark
 Wang <xiaoning.wang@nxp.com>, NXP Linux Team <linux-imx@nxp.com>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend
 <john.fastabend@gmail.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 Gagandeep Singh <g.singh@nxp.com>
Subject: Re: [RESEND PATCH v4 net 1/1] net: fec: correct the counting of XDP
 sent frames
Message-ID: <20230508184608.43376a10@kernel.org>
In-Reply-To: <20230508143831.980668-1-shenwei.wang@nxp.com>
References: <20230508143831.980668-1-shenwei.wang@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  8 May 2023 09:38:31 -0500 Shenwei Wang wrote:
> In the current xdp_xmit implementation, if any single frame fails to
> transmit due to insufficient buffer descriptors, the function nevertheless
> reports success in sending all frames. This results in erroneously
> indicating that frames were transmitted when in fact they were dropped.
> 
> This patch fixes the issue by ensureing the return value properly
> indicates the actual number of frames successfully transmitted, rather than
> potentially reporting success for all frames when some could not transmit.
> 
> Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
> Signed-off-by: Gagandeep Singh <g.singh@nxp.com>
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

Unfortunately the previous version was silently applied, it seems:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=26312c685ae0bca61e06ac75ee158b1e69546415

Could you send an incremental fix, on top of that patch?
-- 
pw-bot: cr

