Return-Path: <netdev+bounces-6322-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D94D715B1E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A48471C20BF0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FB2174C0;
	Tue, 30 May 2023 10:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85B1171BA;
	Tue, 30 May 2023 10:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80E8BC4339B;
	Tue, 30 May 2023 10:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685441420;
	bh=HJNcXaAUyXKvgisDwudLEOOftSXDXFSDtCqGxjZ80Fw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UsJQCpZzgiF+nqG1IPA7V9srR3gSXtZeZUuxAAluyJnglUVgyCPyTqCpeU5F3ErEs
	 UktXJbO3vHnMmc5baD2LNmZDZuTDUXlhd/ifVfnXaWQf+QzcIL+xFcdRKefq60guLJ
	 /xRwyIbb+wDIQ9DQdNuYDFtD9pqYEt9iqzhmaV60grW9pVYmjMWbWj0/BE5vs3XywA
	 zEbjrt2p9IdSSy+PFrNbyTI9mVIvkYgO8bGmxoSoMtRZzU+EiW7yyogGmCft262rAE
	 JttxKisLiFBsFIWQ8eFOCRcMn914B34W2tlWbiLVIfQwAH3VQ9xDMlAaRixk8j/iDH
	 lM1s6TvyoLzZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65394E52C02;
	Tue, 30 May 2023 10:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3,net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168544142040.13918.458960316651183871.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 10:10:20 +0000
References: <1685115537-31675-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1685115537-31675-1-git-send-email-haiyangz@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, decui@microsoft.com,
 kys@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
 vkuznets@redhat.com, davem@davemloft.net, wei.liu@kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, ssengar@linux.microsoft.com,
 linux-rdma@vger.kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
 bpf@vger.kernel.org, ast@kernel.org, sharmaajay@microsoft.com,
 hawk@kernel.org, tglx@linutronix.de, shradhagupta@linux.microsoft.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 26 May 2023 08:38:57 -0700 you wrote:
> The apc->eth_stats.rx_cqes is one per NIC (vport), and it's on the
> frequent and parallel code path of all queues. So, r/w into this
> single shared variable by many threads on different CPUs creates a
> lot caching and memory overhead, hence perf regression. And, it's
> not accurate due to the high volume concurrent r/w.
> 
> For example, a workload is iperf with 128 threads, and with RPS
> enabled. We saw perf regression of 25% with the previous patch
> adding the counters. And this patch eliminates the regression.
> 
> [...]

Here is the summary with links:
  - [V3,net] net: mana: Fix perf regression: remove rx_cqes, tx_cqes counters
    https://git.kernel.org/netdev/net/c/1919b39fc6ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



