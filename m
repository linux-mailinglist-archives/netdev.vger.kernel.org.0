Return-Path: <netdev+bounces-3795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8FCD708E1F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 05:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 549D028186C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844AC397;
	Fri, 19 May 2023 03:10:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3303B395
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 03:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C207AC433D2;
	Fri, 19 May 2023 03:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684465828;
	bh=Ql1+SfKvSzalhsD2bM0LltkvnRzf+wo7iv/Lg6dahns=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J1veWu/S5UTWy+HD1QIHFL2CyDr7Fdw60lI29KMmp0h6UY06WPEfYADR+bl/7z30M
	 lqDzXBsvzYGeREHq/HNe3EfZIeQdbXDXKKrERgbOygL9RKr+Xlg+ALBkMtl3NPLzs4
	 /CH4ZQoNgwh8A13gcGbNMV3mGLHPZhmQOVKhb23KTrSU9Dkcg1mWUx+gUKrZQ+6gLN
	 D20EupfHMKywLhNxhcf//Wi8JtU+nDniTut35Dv6kYAsykaCmDEq/YU5j1BXIRxYS+
	 B6TLTCf0VwVxg9rrXWZPe3MyawHIIJ1q5D72z01E4EsR3QIvBsNWU+lFut8Uzw8zpg
	 +ipoDouKdkOrA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B27BC3959E;
	Fri, 19 May 2023 03:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cdc_ncm: Deal with too low values of dwNtbOutMaxSize
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168446582856.25467.9181622347327037026.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 03:10:28 +0000
References: <20230517133808.1873695-2-tudor.ambarus@linaro.org>
In-Reply-To: <20230517133808.1873695-2-tudor.ambarus@linaro.org>
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: bjorn@mork.no, joneslee@google.com, oliver@neukum.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-usb@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+9f575a1f15fc0c01ed69@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 May 2023 13:38:08 +0000 you wrote:
> Currently in cdc_ncm_check_tx_max(), if dwNtbOutMaxSize is lower than
> the calculated "min" value, but greater than zero, the logic sets
> tx_max to dwNtbOutMaxSize. This is then used to allocate a new SKB in
> cdc_ncm_fill_tx_frame() where all the data is handled.
> 
> For small values of dwNtbOutMaxSize the memory allocated during
> alloc_skb(dwNtbOutMaxSize, GFP_ATOMIC) will have the same size, due to
> how size is aligned at alloc time:
> 	size = SKB_DATA_ALIGN(size);
>         size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> Thus we hit the same bug that we tried to squash with
> commit 2be6d4d16a084 ("net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero")
> 
> [...]

Here is the summary with links:
  - net: cdc_ncm: Deal with too low values of dwNtbOutMaxSize
    https://git.kernel.org/netdev/net/c/7e01c7f7046e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



