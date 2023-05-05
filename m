Return-Path: <netdev+bounces-541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7785D6F80B7
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F0531C2175D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8271279EE;
	Fri,  5 May 2023 10:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A091FC9;
	Fri,  5 May 2023 10:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B315BC433EF;
	Fri,  5 May 2023 10:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683282189;
	bh=nWNitmoUADkfmgkehlM5eSbfxlPEEaLRPvnf7gZnV/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GCxFMEGaPFYeeDiPMoXqoRCm7gALvdvTe93mKXt39+4zGIMTJj/7v3hcMdWCoonr/
	 HNn1HGTndg3RESLU4wuVGmv45/oVQT4JUWa/QM2H1uQLnaBXHRhmO5HbTpKro3bWQj
	 kb2L+ReqkhA32Ih1ziedzjnn17fvhMngBvmXgV5306mwUKHz1tDe4js9uk2EbhVtz8
	 adS/AxBeyx1k/yNCfTLLwfF95xE02IIxfTfr0O4GSJSldEiKnrIka7E/J0ATMvtLQI
	 BMeXmGHv/JITe+DMsWsD5JUFjbXSyDOHQlaLMiuak5Q9EvywcgAGH5DH8De9cb+HnQ
	 3o91WLK/Cvb+w==
Date: Fri, 5 May 2023 13:23:04 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	imx@lists.linux.dev, Gagandeep Singh <g.singh@nxp.com>
Subject: Re: [PATCH v3 net 1/1] net: fec: correct the counting of XDP sent
 frames
Message-ID: <20230505102304.GA525452@unreal>
References: <20230504153517.816636-1-shenwei.wang@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504153517.816636-1-shenwei.wang@nxp.com>

On Thu, May 04, 2023 at 10:35:17AM -0500, Shenwei Wang wrote:
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
> ---
>  v3:
>   - resend the v2 fix for "net" as the standalone patch.
> 
>  v2:
>   - only keep the bug fix part of codes according to Horatiu's comments.
>   - restructure the functions to avoid the forward declaration.
> 
>  drivers/net/ethernet/freescale/fec_main.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

