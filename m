Return-Path: <netdev+bounces-11293-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1863D7326D2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C69D628155B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856C13FEC;
	Fri, 16 Jun 2023 05:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D2BEC0;
	Fri, 16 Jun 2023 05:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D233BC433C9;
	Fri, 16 Jun 2023 05:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686894620;
	bh=KHvh2Gsa3DU3AZSLt/p36r6qy8qgkrrpfX/DHpT75es=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bHvhdhRtvxuUerithl4frahycEgwfsvl8On33BtJGXqywFDa5BueffdGSRR18xl4m
	 X2sUh7X1gM5XkhVgqEihX2AfYt9rvsNC8rcy7n3aAeN4F7rFVpJpR+t2skR/wrDUlT
	 xz36ZBVYQJpXajCe0hBktfrMyCs9NmzbaIqSr8E69YYr032MlclwL+K9JqIhZUOxT9
	 2pI2s8huFVtk4TvRkK69hqax1tCtmTi+gNeHaSYUTh9EELek5DMl/0gmjU2hYtlNlR
	 HIuFXS4o/uiY0QHX26YLdBc0EPqM0GPHnrQO1vcn5LPmmeQWYt7e+69eszP5PALOrC
	 fvHwdq1m7vmJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9725E49FAA;
	Fri, 16 Jun 2023 05:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7] net: ioctl: Use kernel memory on protocol ioctl
 callbacks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168689462068.26047.7995810161651055390.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 05:50:20 +0000
References: <20230609152800.830401-1-leitao@debian.org>
In-Reply-To: <20230609152800.830401-1-leitao@debian.org>
To: Breno Leitao <leitao@debian.org>
Cc: courmisch@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alex.aring@gmail.com,
 stefan@datenfreihafen.org, miquel.raynal@bootlin.com, dsahern@kernel.org,
 willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
 martineau@kernel.org, marcelo.leitner@gmail.com, lucien.xin@gmail.com,
 axboe@kernel.dk, asml.silence@gmail.com, leit@fb.com, willemb@google.com,
 martin.lau@kernel.org, ast@kernel.org, kuniyu@amazon.com,
 kernelxing@tencent.com, joannelkoong@gmail.com, hbh25y@gmail.com,
 wojciech.drewek@intel.com, andrea.righi@canonical.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dccp@vger.kernel.org,
 linux-wpan@vger.kernel.org, mptcp@lists.linux.dev, linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Jun 2023 08:27:42 -0700 you wrote:
> Most of the ioctls to net protocols operates directly on userspace
> argument (arg). Usually doing get_user()/put_user() directly in the
> ioctl callback.  This is not flexible, because it is hard to reuse these
> functions without passing userspace buffers.
> 
> Change the "struct proto" ioctls to avoid touching userspace memory and
> operate on kernel buffers, i.e., all protocol's ioctl callbacks is
> adapted to operate on a kernel memory other than on userspace (so, no
> more {put,get}_user() and friends being called in the ioctl callback).
> 
> [...]

Here is the summary with links:
  - [net-next,v7] net: ioctl: Use kernel memory on protocol ioctl callbacks
    https://git.kernel.org/netdev/net-next/c/e1d001fa5b47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



