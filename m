Return-Path: <netdev+bounces-9797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0759B72A9CE
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:22:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD81C281A8E
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A01BA42;
	Sat, 10 Jun 2023 07:21:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F810A930
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 07:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD8E8C4339E;
	Sat, 10 Jun 2023 07:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686381694;
	bh=RvSo1FJjOz85fE52e6U+rY9alkLSoufcrxfT79FQfYk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=YZvVLXUSvQb7TPOpdr2CFZEV5gOgIKxUThDBudc9P/VLUaf0XDzQy+6Y4k1EOldrS
	 CevA9uYtqoXzHbB83m6GZwHJicfxfXEEdIzQIcmkHkL0FewMIao8SF9yz8RX1k9qBW
	 9A+d4t8lM9bJUdNWlIt+mU9bpELB8vEaqKvOln2X1OEohmVRiE7L3vHAHnFN722VbA
	 B2DoR2dRQMwU+7QVZbQiaJ+DFytsj7QeMix2wbvuIWIryAc7yc1uLrfhbNakCN2NrT
	 G/zvC24jvUvznXkS/u0UrE5iyS5n02fzSEXmI6A0LxkQJlUDmAY/5JeuM58Fn+XXPr
	 a+2ViZkhCEDAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8F8CE29F36;
	Sat, 10 Jun 2023 07:21:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: move gso declarations and functions to their
 own files
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168638169468.9909.16606138404983687177.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 07:21:34 +0000
References: <20230608191738.3947077-1-edumazet@google.com>
In-Reply-To: <20230608191738.3947077-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, sdf@google.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  8 Jun 2023 19:17:37 +0000 you wrote:
> Move declarations into include/net/gso.h and code into net/core/gso.c
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/net/ethernet/broadcom/tg3.c           |   1 +
>  .../net/ethernet/myricom/myri10ge/myri10ge.c  |   1 +
>  drivers/net/ethernet/sfc/siena/tx_common.c    |   1 +
>  drivers/net/ethernet/sfc/tx_common.c          |   1 +
>  drivers/net/tap.c                             |   1 +
>  drivers/net/usb/r8152.c                       |   1 +
>  drivers/net/wireguard/device.c                |   1 +
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |   1 +
>  include/linux/netdevice.h                     |  26 +-
>  include/linux/skbuff.h                        |  71 -----
>  include/net/gro.h                             |   1 +
>  include/net/gso.h                             | 109 +++++++
>  include/net/udp.h                             |   1 +
>  net/core/Makefile                             |   2 +-
>  net/core/dev.c                                |  70 +----
>  net/core/gro.c                                |  59 +---
>  net/core/gso.c                                | 273 ++++++++++++++++++
>  net/core/skbuff.c                             | 142 +--------
>  net/ipv4/af_inet.c                            |   1 +
>  net/ipv4/esp4_offload.c                       |   1 +
>  net/ipv4/gre_offload.c                        |   1 +
>  net/ipv4/ip_output.c                          |   1 +
>  net/ipv4/tcp_offload.c                        |   1 +
>  net/ipv4/udp.c                                |   1 +
>  net/ipv4/udp_offload.c                        |   1 +
>  net/ipv6/esp6_offload.c                       |   1 +
>  net/ipv6/ip6_offload.c                        |   1 +
>  net/ipv6/ip6_output.c                         |   1 +
>  net/ipv6/udp_offload.c                        |   1 +
>  net/mac80211/tx.c                             |   1 +
>  net/mpls/af_mpls.c                            |   1 +
>  net/mpls/mpls_gso.c                           |   1 +
>  net/netfilter/nf_flow_table_ip.c              |   1 +
>  net/netfilter/nfnetlink_queue.c               |   1 +
>  net/nsh/nsh.c                                 |   1 +
>  net/openvswitch/actions.c                     |   1 +
>  net/openvswitch/datapath.c                    |   1 +
>  net/sched/act_police.c                        |   1 +
>  net/sched/sch_cake.c                          |   1 +
>  net/sched/sch_netem.c                         |   1 +
>  net/sched/sch_taprio.c                        |   1 +
>  net/sched/sch_tbf.c                           |   1 +
>  net/sctp/offload.c                            |   1 +
>  net/xfrm/xfrm_device.c                        |   1 +
>  net/xfrm/xfrm_interface_core.c                |   1 +
>  net/xfrm/xfrm_output.c                        |   1 +
>  46 files changed, 425 insertions(+), 365 deletions(-)
>  create mode 100644 include/net/gso.h
>  create mode 100644 net/core/gso.c

Here is the summary with links:
  - [net-next] net: move gso declarations and functions to their own files
    https://git.kernel.org/netdev/net-next/c/d457a0e329b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



