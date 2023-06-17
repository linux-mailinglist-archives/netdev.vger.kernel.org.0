Return-Path: <netdev+bounces-11703-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B7ED733F46
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24F3F281945
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF206FB5;
	Sat, 17 Jun 2023 07:48:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0386D5231
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07989C433C8;
	Sat, 17 Jun 2023 07:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686988092;
	bh=jEER2SlngRJTcj6UGPVVWpH/QjWLiFOJ2CB533Wl2Jc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Pv7gwP/Wt7lAvwDo6yWxVrhPVJ44aIl+7GkljzA4Cdawyf5fTW9w6WNk/8Id6wuxz
	 mkh18SFuI6o9nfoW4N2c5gpouvAp9A2/Xy9bJyovyhtEUJ5sM/fbivKPwwr926AFMl
	 sNCbwjfRro30xp3dZqLiMEBRRyQ0iiwzKpQGaKs1UUKqOJDvYzK2hvxLSCDT+Bh9vP
	 2VCdazVlTVqrRj1SuodYuHjXPbhtsFKnf2lZKwi2Etzv2lQEqsXHCUNRAQBupq6OIE
	 tV9+t2sd9CQJYqMjyZbnGSswCF3R3Rur5JfOBWmYllTGTWjLqZMruhAGRYe/oG2mwY
	 etghjynEZkv4Q==
Date: Sat, 17 Jun 2023 00:48:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Paolo Abeni
 <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Saeed Mahameed
 <saeedm@nvidia.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>, Gal Pressman
 <gal@nvidia.com>
Subject: Re: [net-next 07/15] net/mlx5: Bridge, expose FDB state via debugfs
Message-ID: <20230617004811.46a432a4@kernel.org>
In-Reply-To: <20230616201113.45510-8-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
	<20230616201113.45510-8-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 13:11:05 -0700 Saeed Mahameed wrote:
> $ cat mlx5/0000\:08\:00.0/esw/bridge/bridge1/fdb
> DEV              MAC               VLAN              PACKETS                BYTES              LASTUSE FLAGS
> enp8s0f0_1       e4:0a:05:08:00:06    2                    2                  204           4295567112   0x0
> enp8s0f0_0       e4:0a:05:08:00:03    2                    3                  278           4295567112   0x0

The flags here are the only thing that's mlx5 specific?
Why not add an API for dumping this kind of stats that other drivers
can reuse?

The rest of the patches LGTM
-- 
pw-bot: cr

