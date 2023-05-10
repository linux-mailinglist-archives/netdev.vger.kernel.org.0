Return-Path: <netdev+bounces-1557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6AF6FE4A3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74DDB281435
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A917117FF3;
	Wed, 10 May 2023 19:54:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4018C0F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B0EC4339B;
	Wed, 10 May 2023 19:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683748494;
	bh=+/Vyeo7tMzTPrlMDE/nSuC3BlFbyOqcWOzkcpSA/6vM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qFUlGejc7iNxvPQRsuwTlRnzHRVhVT05rgLqe6cBMwNbdFqF0D4yjbJWM9z1ekB+R
	 nli/E3Gm2n8AOV8hmqMLdnuMIkCMNLh+iafpjcuMkr9mf1PF/O/DQuiuHIWKGtblVj
	 BCSvIRV1kR5pBl+8sSkJ4Ha0bcebU0gMnIQ9dFR6iVQXWTNvgm4qcPyWuBm0bc+/re
	 1yzKMaQWgsfqlDMYnZwzNOoWso7mScDgbrxNhlOubXoiErKXQpJrmsxH9PI4UIDEnq
	 dc8Dc/UOl/okfzTkqh+4PhOaUBRzvbqGsBHY5YX8Xc5+ksxowh38boHTcLQ+BhXItx
	 3QhAM9qCX/vAg==
Message-ID: <04db1f1b-eb81-6fd6-7696-ea217871815a@kernel.org>
Date: Wed, 10 May 2023 13:54:52 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net] ipv6: remove nexthop_fib6_nh_bh()
To: Eric Dumazet <edumazet@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
 syzbot <syzkaller@googlegroups.com>
References: <20230510154646.370659-1-edumazet@google.com>
Content-Language: en-US
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230510154646.370659-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/10/23 9:46 AM, Eric Dumazet wrote:
> After blamed commit, nexthop_fib6_nh_bh() and nexthop_fib6_nh()
> are the same.
> 
> Delete nexthop_fib6_nh_bh(), and convert /proc/net/ipv6_route
> to standard rcu to avoid this splat:
> 

...

> 
> Fixes: 09eed1192cec ("neighbour: switch to standard rcu, instead of rcu_bh")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/nexthop.h | 23 -----------------------
>  net/ipv6/ip6_fib.c    | 16 ++++++++--------
>  2 files changed, 8 insertions(+), 31 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



