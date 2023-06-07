Return-Path: <netdev+bounces-8676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 312F47252AE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C4F51C20C64
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5359815;
	Wed,  7 Jun 2023 04:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AAC812
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35DE2C4339B;
	Wed,  7 Jun 2023 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686111021;
	bh=O8QcPriM6FAnak9cEPJJhXiDuQ/MzN+feMRVnKiw9i4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=H5DqGyC0fhRSkp69A2gsm2PKAQaCWxi4PitZsdwSVXPfOQQiULxA2DGxVMHXCvVw6
	 wt/Qldb7K4hNzNOt9s+ZvIGPUxqSokwb6/efvimW3lyPURsMCljPg2yNTimZDSGc9m
	 N3xEIfkbdQOo3vQ16U7IV+MJVCwuxPstKgLdlFHBAMJErECM9wIX9Y/4tdwBVOEdJa
	 BupBMAkOAqfo8YCi7JcR8muqHDXJR9QBO4TsnL9LMIyrRajRJu2AKU3nD/d3o3YmAX
	 3hWMsVRYMWdYWRnR7IQreHkE2GDaJRwyZ6ExUgOoRobcIScV7hDFr0Jyds99nvGXGW
	 oxy2P/3IYZTUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06482E87231;
	Wed,  7 Jun 2023 04:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] ipv6: rpl: Fix Route of Death.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168611102100.26028.5718929525458673124.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 04:10:21 +0000
References: <20230605180617.67284-1-kuniyu@amazon.com>
In-Reply-To: <20230605180617.67284-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, dsahern@kernel.org, alex.aring@gmail.com,
 kuni1840@gmail.com, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 5 Jun 2023 11:06:17 -0700 you wrote:
> A remote DoS vulnerability of RPL Source Routing is assigned CVE-2023-2156.
> 
> The Source Routing Header (SRH) has the following format:
> 
>   0                   1                   2                   3
>   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
>   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
>   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   | CmprI | CmprE |  Pad  |               Reserved                |
>   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   |                                                               |
>   .                                                               .
>   .                        Addresses[1..n]                        .
>   .                                                               .
>   |                                                               |
>   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 
> [...]

Here is the summary with links:
  - [v2,net] ipv6: rpl: Fix Route of Death.
    https://git.kernel.org/netdev/net/c/a2f4c143d76b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



