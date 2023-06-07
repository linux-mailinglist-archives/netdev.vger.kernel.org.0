Return-Path: <netdev+bounces-9086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE94272729F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C32528159D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF06A3B3F8;
	Wed,  7 Jun 2023 23:00:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFB03B3E0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 23:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA88C433EF;
	Wed,  7 Jun 2023 23:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686178841;
	bh=d16lCBn1h+6B3fp4bpIGIj7eRIhpXpXEtm2L/g3xXS4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O6zfEcuvWuxyROW+Q/KrM1TqtxK3eIfykFljt4qKaCIvye+byHG+0KLWARwXS3SYZ
	 M+lWK8kHvbttg7tnkQsuHOEAOSiqVmSKXPNENyyVJ9IIAy07FjafoY2in6Yn0UQhIX
	 VmMp99QlqYFvVq0T1hvWngJYL17rrxV4APMzUqRA56fw/ZLMzasJgiMpnXDDgID/2R
	 0cGdgAIyHc4ZG2d3Vyg2+YtKvl+QCUFDxFruwKga3eAu21erVQOiQP9d26Nkz6fdeV
	 xZTsNyRu2YBekTcN5NlDEaAbZq465oGRvucNVQFnqQzKVYmIywT3bDwdNC5G6UMPzc
	 mpwE2TUakMAwQ==
Date: Wed, 7 Jun 2023 16:00:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Edward Cree <ecree.xilinx@gmail.com>
Cc: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 5/6] sfc: neighbour lookup for TC encap action
 offload
Message-ID: <20230607160040.412fd9b2@kernel.org>
In-Reply-To: <9f05ef7a-479c-05a6-e38b-f792034c7afd@gmail.com>
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
	<286b3685eabf6cdd98021215b9b00020b442a42b.1685992503.git.ecree.xilinx@gmail.com>
	<20230606215658.3192feec@kernel.org>
	<9f05ef7a-479c-05a6-e38b-f792034c7afd@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 21:51:35 +0100 Edward Cree wrote:
> Fair point.  Guessing that applies to the netns reference as well?

Yes. I should add that to the checker..

> (Though looking back I honestly can't remember why we need to hold
>  the neigh->net reference for the life of efx_neigh_binder; but I
>  presumably had some reason for it at the time and I'm leery of
>  removing it now in case it's load-bearing.
>  Chesterton's Fence and all that.)

You don't seem to be doing much with the reference, just holding it.
Your call.

