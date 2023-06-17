Return-Path: <netdev+bounces-11659-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDF9733D24
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 02:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AEE91C21084
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34590622;
	Sat, 17 Jun 2023 00:20:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D076F39D
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 00:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2F8C433C9;
	Sat, 17 Jun 2023 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686961213;
	bh=TKB5Kg6Mvto4p2LOHtKiEM+FrrVcR2o1CXg2u7PPlL8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VjJVplJCxT14QwRxq3BHWXRE02Ow1RwDuWT1h0NinGqKQTndiYn6AwNpyBnoHhpE7
	 bZUYcrJHczc3iYjstpN1Y/H5bmK+9muQ9Ddg3sf4bV3Fb1hviF+X/06/nwOK444WSZ
	 oGSuXQP5/l0PRs772e30BhnPsaOlx1fYpW0jp00p5VBnHp1iI9+MHmk7MzLhffXYeT
	 CsV1Q7t9hFiZSUcidYDBxBbJrN6oWfdxtYYrTrmYkwqnP8tY+Cd6nfYDHY9EWoDlCO
	 06lqpeR3te7ZVv3i4IBTyQGsYqP9UJxAcH+zdOykKCrs4Wel8U49Y+800VEGbzSrQX
	 2byH291gZ+R9g==
Message-ID: <1a575a29-ed2c-a6c1-24c0-95e4f10db757@kernel.org>
Date: Fri, 16 Jun 2023 17:20:12 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] ipv6: also use netdev_hold() in
 ip6_route_check_nh()
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
 syzbot <syzkaller@googlegroups.com>
References: <20230616085752.3348131-1-edumazet@google.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230616085752.3348131-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/23 2:57 AM, Eric Dumazet wrote:
> In blamed commit, we missed the fact that ip6_validate_gw()
> could change dev under us from ip6_route_check_nh()

I guess I should have caught up on all email before responding to your
last one. I read "change dev" as changing it from say eth0 to eth1 but
you mean can change the value by actually setting it.

> 
> In this fix, I use GFP_ATOMIC in order to not pass too many additional
> arguments to ip6_validate_gw() and ip6_route_check_nh() only
> for a rarely used debug feature.
> 

...

> 
> Fixes: 70f7457ad6d6 ("net: create device lookup API with reference tracking")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv6/route.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


