Return-Path: <netdev+bounces-1307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCF16FD3E6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 04:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCBC528105A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED7F373;
	Wed, 10 May 2023 02:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44963361
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3A43C433D2;
	Wed, 10 May 2023 02:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683687020;
	bh=uYGUc2iemDUAZix/3j2XeIERBHlEpfWv5ACO+Ofk21I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=RdJEjA12dj4F0THfzvCLgpra7SlZYVF+g9Ir2ZbBYbG/XP2Y38KPlnt5ahBVPBLaF
	 CDcpN/4wfGFX8iYkh5gxGQo4JJlU+7+NY+QS/lvnsUShqwUo2ZiTnOoXknq6uGv4Sc
	 jRexMbAPkWn3DoiCxIyI5bA9H+diGdO3sURPsERlWWVOOBr7IZM3EnvF1tDz6axlg8
	 qpo/cukK6uI7oOCDgck/wXKeKELjp/46GZCPEPUeUvZu9NdUYiv+j/HYQXuPAuYIPT
	 qRJ92f7uH7g/UOhnuueRtE+HnnWfFQLo4wJRWrG88DbZ3WYiQODnWUmaVglJUkx6eI
	 BtAYDjqPenspA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA571C39562;
	Wed, 10 May 2023 02:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168368702069.23144.12939098876302994192.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 02:50:20 +0000
References: <20230506235845.246105-1-marex@denx.de>
In-Reply-To: <20230506235845.246105-1-marex@denx.de>
To: Marek Vasut <marex@denx.de>
Cc: netdev@vger.kernel.org, davem@davemloft.net, alexandre.torgue@foss.st.com,
 edumazet@google.com, francesco.dolcini@toradex.com, peppe.cavallaro@st.com,
 hws@denx.de, kuba@kernel.org, joabreu@synopsys.com,
 marcel.ziswiler@toradex.com, mcoquelin.stm32@gmail.com, pabeni@redhat.com,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  7 May 2023 01:58:45 +0200 you wrote:
> Initialize MAC_ONEUS_TIC_COUNTER register with correct value derived
> from CSR clock, otherwise EEE is unstable on at least NXP i.MX8M Plus
> and Micrel KSZ9131RNX PHY, to the point where not even ARP request can
> be sent out.
> 
> i.MX 8M Plus Applications Processor Reference Manual, Rev. 1, 06/2021
> 11.7.6.1.34 One-microsecond Reference Timer (MAC_ONEUS_TIC_COUNTER)
> defines this register as:
> "
> This register controls the generation of the Reference time (1 microsecond
> tic) for all the LPI timers. This timer has to be programmed by the software
> initially.
> ...
> The application must program this counter so that the number of clock cycles
> of CSR clock is 1us. (Subtract 1 from the value before programming).
> For example if the CSR clock is 100MHz then this field needs to be programmed
> to value 100 - 1 = 99 (which is 0x63).
> This is required to generate the 1US events that are used to update some of
> the EEE related counters.
> "
> 
> [...]

Here is the summary with links:
  - net: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register
    https://git.kernel.org/netdev/net/c/8efbdbfa9938

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



