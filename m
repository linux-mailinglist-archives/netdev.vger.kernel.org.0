Return-Path: <netdev+bounces-4683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF4770DDA9
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58ECA1C20905
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D581EA7E;
	Tue, 23 May 2023 13:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2F34A85A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A3D8C4339B;
	Tue, 23 May 2023 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684849219;
	bh=Xpwc0uMMenl8jokEfehO6+CpiK4LHBWvEX6sJPnK5Sg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fHYmi3pptGp50C+8SY1IhpS6+eRQX13Qo/OGsePO+e9cTbYVCkI7eOc/Cw4T5wJjs
	 l5AvrLIO1keKNzxRBYh9WbAnVqRRbKeyCD+OA9iAI7UNgGJR2NI2pUDClyCq8xA2Gj
	 +TF4qEEGZIYvixHDTgcDz6RBxVBb7YYfVkgdYKTE3JTBYdgZjj2yEFWAdWUmXYS8Cb
	 dKbbrx53wgGr3zNd6VNo3NkJCZ3eZ/3nDYLZPMVhPcpqfojYUy1fyA2R1BbQ9SRj8j
	 epoW0uDos0vaNARE1wC4YUidrC6sYzlpXvETQCy1j6JTImGeu7crYT8Shq9NuOvwKU
	 En9/gKmMv6bMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F0E4C04E32;
	Tue, 23 May 2023 13:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] lan966x: Fix unloading/loading of the driver
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168484921912.23799.4816780617642499694.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 13:40:19 +0000
References: <20230522120038.3749026-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230522120038.3749026-1-horatiu.vultur@microchip.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 UNGLinuxDriver@microchip.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 22 May 2023 14:00:38 +0200 you wrote:
> It was noticing that after a while when unloading/loading the driver and
> sending traffic through the switch, it would stop working. It would stop
> forwarding any traffic and the only way to get out of this was to do a
> power cycle of the board. The root cause seems to be that the switch
> core is initialized twice. Apparently initializing twice the switch core
> disturbs the pointers in the queue systems in the HW, so after a while
> it would stop sending the traffic.
> Unfortunetly, it is not possible to use a reset of the switch here,
> because the reset line is connected to multiple devices like MDIO,
> SGPIO, FAN, etc. So then all the devices will get reseted when the
> network driver will be loaded.
> So the fix is to check if the core is initialized already and if that is
> the case don't initialize it again.
> 
> [...]

Here is the summary with links:
  - [net] lan966x: Fix unloading/loading of the driver
    https://git.kernel.org/netdev/net/c/600761245952

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



