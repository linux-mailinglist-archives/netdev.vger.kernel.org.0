Return-Path: <netdev+bounces-11157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 524B6731CA3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82B4C1C20EBB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19067171DF;
	Thu, 15 Jun 2023 15:28:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEC020F5;
	Thu, 15 Jun 2023 15:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7075C433C8;
	Thu, 15 Jun 2023 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686842929;
	bh=3rUJKAAkVI4LiG4fM0PQkGZktYejaRvzK+AL0LZ3Y74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WMK8BkG+KJoxgGBdTk9yp8ZAuScSukNpIc1QMKIcgns2cazl704jin1fe/1UXio5n
	 HJ9ZR7Pg0SF0WXvQBw+oAsOPRmVV/A5Q+xoE7yj0YM3/KYiY9tCWmdiJsryU+UHBB3
	 ri0LFyoZ9tF4c9V7ir8xb1Fp8oTMuVGnt/AEkCji6IqiCA/bnQAoiCreP9UwAU8ChQ
	 aruy8AOj9e28HAeajwzSGG7a/3ST4fNv9DKiRlMHsZCe+bQLP01+ASsp6LatoHiScd
	 2pBlbYs0eu0naQmy+3XJsJ93n6/5vsZIrrNY1mZG9mdyEKm3M9U7y8kY/NYBp5Ar3r
	 TlMEq1Y/2+kpg==
Date: Thu, 15 Jun 2023 23:17:26 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 0/3] net: stmmac: fix & improve driver statistics
Message-ID: <ZIsrhuxRrx2AwI7F@xhacker>
References: <20230614161847.4071-1-jszhang@kernel.org>
 <ZIoXZQXLTWKF8nCZ@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZIoXZQXLTWKF8nCZ@corigine.com>

On Wed, Jun 14, 2023 at 09:39:17PM +0200, Simon Horman wrote:
> On Thu, Jun 15, 2023 at 12:18:44AM +0800, Jisheng Zhang wrote:
> > patch1 and patch2 fix two issues in net driver statistics:
> > 1. network driver statistics are cleared in .ndo_close() and
> > .ndo_open() cycle
> > 2. some network driver statistics overflow on 32 bit platforms
> 
> I would encourage you to describe these as enhancements or similar,
> but not fixes. Because fix implies a bug, such as a crash. And
> bugs for fixes are handled by a slightly different process which
> often includes backporting.

So it seems I need to fold patch2 and patch3 into one patch. Previously
I thought the counters overflow on 32 bit platforms was a bug, thus
I split the 64bit stats patch into patch2 and patch3 so that patch2
can be backported to stable tree.

I will fold patch2 and patch3 into one patch in v2.

Thanks for your review.
> 
> > patch3 use pcpu statistics where necessary to remove frequent
> > cacheline ping pongs.
> 
> Assuming these are three enhancements, then they should be
> targeted at the net-next tree. And that should be noted in the subject:
> 
> 	Subject: [PATCH net-next v2] ...
> 
> Unfortunately the series does not seem to apply to net-next
> in its current form. So it probably needs to be rebased and reposted.
> 
> If you do post an updated series, please observe a 24h grace
> period between postings, to give reviewers time to do their thing.
> 
> Link: https://docs.kernel.org/process/maintainer-netdev.html

