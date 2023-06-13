Return-Path: <netdev+bounces-10302-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D6772DAD6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D23D01C20C07
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F573D87;
	Tue, 13 Jun 2023 07:29:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7E417D0
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484D2C433EF;
	Tue, 13 Jun 2023 07:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686641381;
	bh=4Qor2Eois7iv4mh8rLWFv20BV5k0vOezfA8NaE+NqFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H/AK2ja6byrwjff8XYyniafFUOEmCjUEVE7ee/T4u2O3VxX22dFyA3bDrN4BTwq9B
	 IMtbawLIcf856Kp72hD++WR8JhTe7SFap7iNZ03PKqMvsWurAAb9HS71RYYuSLsVFe
	 ST73X/9GD1M+1LHOr7Y4oIDQIutD+Tk5tlOvL8/bZ4j36DB68/makp2wfN2i4onoXj
	 dKI4lWtAY3pHSfv+Z6XyRJJwjJubWQ8/AEHeOtX3gZjFJJYTCdcRiAKd9UMWFVa4oU
	 oqcxcsIjfSEw90LO7ij5Ib6bLT6w7KMRUUtNkVE92lgJZDAgCun6eNku79FltQiRU3
	 lYMGv+UlDgnZQ==
Date: Tue, 13 Jun 2023 10:29:36 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Wei Hu <weh@microsoft.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Long Li <longli@microsoft.com>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, KY Srinivasan <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
	"shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>
Subject: Re: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Message-ID: <20230613072936.GV12152@unreal>
References: <20230606151747.1649305-1-weh@microsoft.com>
 <20230607213903.470f71ae@kernel.org>
 <SI2P153MB0441DAC4E756A1991A03520FBB54A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
 <20230612061349.GM12152@unreal>
 <20230612102221.2ca726fd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612102221.2ca726fd@kernel.org>

On Mon, Jun 12, 2023 at 10:22:21AM -0700, Jakub Kicinski wrote:
> On Mon, 12 Jun 2023 09:13:49 +0300 Leon Romanovsky wrote:
> > > Thanks for you comment. I am  new to the process. I have a few
> > > questions regarding to this and hope you can help. First of all,
> > > the patch is mostly for IB. Is it possible for the patch to just go
> > > through the RDMA branch, since most of the changes are in RDMA?   
> > 
> > Yes, it can, we (RDMA) will handle it.
> 
> Probably, although it's better to teach them some process sooner
> rather than later?

Like Jason wrote above, shared branch is valuable once the submitter has
enough volume to justify. In previous cycles, when we needed it, I simply
created shared branch [1] for them.

Even we (Nvidia), who has enough patch volume, sometimes prefer to
delay submission to next cycle and don't bother ourselves with shared
branch.

[1] https://lore.kernel.org/all/Y2v2CGEWC70g+Ot+@unreal/

Thanks

