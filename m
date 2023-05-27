Return-Path: <netdev+bounces-5841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D0F7131F8
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 04:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 488A51C21142
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 02:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF63198;
	Sat, 27 May 2023 02:33:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017B9194
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 02:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEEAC433D2;
	Sat, 27 May 2023 02:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685154805;
	bh=Tl5ybrj3DUSGRyiqlgYvFfrpfVcW36HCw9/41kY79oM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C4YnqJz9yjtYRjPaRuUxHocQbyAFxc6Lal466TxUWjl0RLuNmRUxi3zHt5+L5S5AM
	 3xk+SVYtwlkvY2mV3RYVeEipj7aFG7VEvcWaYltcr0BqXJxH2OG9PNLX1xnK29xy0r
	 1tJejPtmOv6hiGqtUpzNlhE8SHB0JfNcmhGoErCssgOc5bfInJyf4nFKIYLp+8m//d
	 1/LoAToT6N11YzI9xo/f0tTvItSRx537etddiDIhHzYa26AQ0xiZez70m/a2GCXz8U
	 zY02k3+TvJ+QKKbi8wvLVD5b79qBZpHvOBvKEW0MIWugbDRvhcBuztZYAU/cxBwBtu
	 2mzvj9Bfl6xpw==
Date: Fri, 26 May 2023 19:33:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: Pedro Tammela <pctammela@mojatatu.com>, Jamal Hadi Salim
 <jhs@mojatatu.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, Peilin Ye
 <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, John
 Fastabend <john.fastabend@gmail.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>, Vlad Buslov
 <vladbu@nvidia.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <20230526193324.41dfafc8@kernel.org>
In-Reply-To: <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
	<429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
	<faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
	<CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
	<CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
	<7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
	<ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 16:09:51 -0700 Peilin Ye wrote:
> Thanks a lot, I'll get right on it.

Any insights? Is it just a live-lock inherent to the retry scheme 
or we actually forget to release the lock/refcnt?

