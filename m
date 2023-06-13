Return-Path: <netdev+bounces-10359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0075772E1AA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E3171C20C2C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B69294E5;
	Tue, 13 Jun 2023 11:28:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBC13C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B077C433EF;
	Tue, 13 Jun 2023 11:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686655726;
	bh=hq8QxgtfWCwqWViXgoyl/4QAqSHZJrese1MOftstq84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pFgy3h0Vd4fsxoGvUIYQYGt9FMbA5KFK/9zVYhpykuWuXUFKHRV75RTyp8v0Dj4XG
	 JR9Dsdpr16RwfSqU9RoC2HhIstFPqw1dCpSWKU7wW3lm3coj1+nMwAmvpG7O0ukRDX
	 dbummXzHtoR5dmixkUE2QNmfFAuzUTm8hXkkUDCLaHu2/ysR56RUYSr/QB4XryLBRp
	 VAkMgONgDqBUgi/+LcYkMRPssPLpp1yvVZ45TW8vM1zJiW+7XbP3eL2EUz70AFsLgR
	 Qq/RiIxFvtwypMx5JyWE8nuOmyLHX627x0UlT7O2v7HXmjntimvtwI2l/ruG0o4LsK
	 8+OGnzYyQG79w==
Date: Tue, 13 Jun 2023 14:28:41 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230613112841.GZ12152@unreal>
References: <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
 <20230612140521.tzhgliaok5u3q67o@skbuf>
 <20230613071959.GU12152@unreal>
 <20230613083002.pjzsno2tzbewej7o@skbuf>
 <20230613090920.GW12152@unreal>
 <20230613093501.46x4rvyhhyx5wo3b@skbuf>
 <20230613101038.GY12152@unreal>
 <20230613103422.ppjeigcugva4gnks@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613103422.ppjeigcugva4gnks@skbuf>

On Tue, Jun 13, 2023 at 01:34:22PM +0300, Vladimir Oltean wrote:
> On Tue, Jun 13, 2023 at 01:10:38PM +0300, Leon Romanovsky wrote:
> > On Tue, Jun 13, 2023 at 12:35:01PM +0300, Vladimir Oltean wrote:
> > > Not really sure where you're aiming with your replies at this stage.
> > 
> > My goal is to explain that "bus drivers may implement .shutdown() 
> > the same way as .remove()" is wrong implementation and expectation
> > that all drivers will add "if (!priv) return ..." now is not viable.
> 
> I never said that all drivers should guard against that - just that it's
> possible and that there is no mechanism to reject such a thing - which
> is something you've incorrectly claimed.

I was wrong in details, but in general I was correct by saying that call
to .shutdown() and .remove() callbacks are impossible to be performed
at the same time.

https://lore.kernel.org/all/20230612115925.GR12152@unreal

Thanks

