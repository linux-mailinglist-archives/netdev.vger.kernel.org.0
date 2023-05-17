Return-Path: <netdev+bounces-3175-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD14B705E30
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A96F21C20D7C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49BB210D;
	Wed, 17 May 2023 03:38:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880CD17FF;
	Wed, 17 May 2023 03:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26D7AC4339E;
	Wed, 17 May 2023 03:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684294682;
	bh=m52AwY8jkOJZBA18hcFlrV08AkqFHGhpvAceGFKRUa8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uUxUMpZU1izkwKReHCQeOCvSUV87028CpR6qFoGkd5w6DeYMDd8hZUxU0PYw4ujce
	 8VXrvtL9NIXm15qahHmShhhMdqldmqITbPQeD4npE3Zo6OYO7i/UMyAJmWOmlMOOVQ
	 ybidG2prTxL17aFy09snRwt8/mI3T4NAwRvf8Ml8gceee/awLrIa1Yfr0/mMCmSkJa
	 QIW2WAbS2ZRfOLH2KwRm1jVI/MLYxg19YK2bv8JAuBuK2NcrKX2GZ5Bz/WeTo13X9Y
	 79na5Z2L9mNMD0Aa3RAfhkPjsmzKGntR3JzryEzd1rDoYuS+PgSS9jZ8ZT/Rsoiwtt
	 y6y4Ywk9A169w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0909AC73FE2;
	Wed, 17 May 2023 03:38:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 6.3 022/246] rxrpc: Fix potential data race in
 rxrpc_wait_to_be_connected()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168429468203.3680.17732082530948499467.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 03:38:02 +0000
References: <20230515161723.275161336@linuxfoundation.org>
In-Reply-To: <20230515161723.275161336@linuxfoundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com, dhowells@redhat.com,
 marc.dionne@auristor.com, dvyukov@google.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, sashal@kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Arnaldo Carvalho de Melo <acme@redhat.com>:

On Mon, 15 May 2023 18:23:54 +0200 you wrote:
> From: David Howells <dhowells@redhat.com>
> 
> [ Upstream commit 2b5fdc0f5caa505afe34d608e2eefadadf2ee67a ]
> 
> Inside the loop in rxrpc_wait_to_be_connected() it checks call->error to
> see if it should exit the loop without first checking the call state.  This
> is probably safe as if call->error is set, the call is dead anyway, but we
> should probably wait for the call state to have been set to completion
> first, lest it cause surprise on the way out.
> 
> [...]

Here is the summary with links:
  - [6.3,022/246] rxrpc: Fix potential data race in rxrpc_wait_to_be_connected()
    (no matching commit)
  - [6.3,051/246] rxrpc: Fix hard call timeout units
    (no matching commit)
  - [6.3,052/246] rxrpc: Make it so that a waiting process can be aborted
    (no matching commit)
  - [6.3,053/246] rxrpc: Fix timeout of a call that hasnt yet been granted a channel
    (no matching commit)
  - [6.3,100/246] perf lock contention: Fix compiler builtin detection
    https://git.kernel.org/bpf/bpf-next/c/17535a33a9c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



