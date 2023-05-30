Return-Path: <netdev+bounces-6539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D96716DBD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C95B0280C96
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0572D24B;
	Tue, 30 May 2023 19:39:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01CB200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264D8C433EF;
	Tue, 30 May 2023 19:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685475570;
	bh=6BVs/4ylZ5MJhPhB0/aJDvk7bJwuMJkawV5+ouDr0gE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sS4WDe5IEn0pNA1TTf/DHBrcX0mRJ6kxZWu3xHplhmDd2Yv+PFlZ3Cdy2DOJRIUyF
	 x4SuYDFQo1A4RnH2WSVSHxcdZFvlh4dLIXG7WJPrVSVfo/cCgtMQ/BYUN6Tuc7EJn2
	 fpg2ukujl6EzrnSxEln+dTU9//vumMArvgkihKNXXd14zqTC0/F4JfsEPd5LYfqHKT
	 V+jcaVPeOCCIsFF9ugPhgj/vldFhvBh/IoQ/q3UCTw4+GuhAE2vGVW9baRIIomalfc
	 OytYvUAwVvA7PQRQa43RfWQxG4jOvD2BW2JUIzDUdC8u4YkBJyFmchYkJXSL7qCxiP
	 z3uLiEeT7uiLg==
Date: Tue, 30 May 2023 12:39:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Parav Pandit <parav@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, David Ahern <dsahern@kernel.org>,
 davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: Make gro complete function to return void
Message-ID: <20230530123929.42472e9f@kernel.org>
In-Reply-To: <CANn89iLxUk6KpQ1a=Q+pNb95nkS6fYbHsuBGdxyTX23fuTGo6g@mail.gmail.com>
References: <20230529134430.492879-1-parav@nvidia.com>
	<b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
	<CANn89iLxUk6KpQ1a=Q+pNb95nkS6fYbHsuBGdxyTX23fuTGo6g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 17:48:22 +0200 Eric Dumazet wrote:
> > tcp_gro_complete seems fairly trivial. Any reason not to make it an
> > inline and avoid another function call in the datapath?  
> 
> Probably, although it is a regular function call, not an indirect one.
> 
> In the grand total of driver rx napi + GRO cost, saving a few cycles
> per GRO completed packet is quite small.

IOW please make sure you include the performance analysis quantifying
the win, if you want to make this a static inline. Or let us know if
the patch is good as is, I'm keeping it in pw for now.

