Return-Path: <netdev+bounces-1536-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 979BF6FE2D1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68CBB1C20E06
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56580168AF;
	Wed, 10 May 2023 16:58:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B564A154A9
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 16:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FE5C433D2;
	Wed, 10 May 2023 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683737882;
	bh=qJuJIBvih8g6RXYnDAMY7eIiU7f28h7yFvO7O3NnHl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JoxF0xLiF97ME2LwAOCgsjP+qbiKEPjI8NXvR0f6ny+34BjoijR6zkktSCF/Jxkyh
	 6Zd9CStVs+T4UTEZOJHTtxR6ABUbwf0gpopSQ2jGf5gVl01NXH5eQlwD5ESHv73Xqk
	 xOgdI7KtKJXDhvicehsfdf16bD8nAKDjTbZDIC0jQkIdN6mMw3ZCV8q9wnnQ9Vkgge
	 juLJ6iko098M6ZcPOqDU6BHEax6Z7rLFGabQ4KOmDXRgZQbZEmekth0Kq9cViQ8VK9
	 zoHkftzt8KCu/SEOolUeFfrfbZ5R271DnikY0jR1qirT1tTZUlo3zwIu5ClJ/wGVzy
	 tC+yvWq3b2yTw==
Date: Wed, 10 May 2023 19:57:57 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Message-ID: <20230510165757.GS38143@unreal>
References: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>
 <20230507081053.GD525452@unreal>
 <PH7PR21MB31168035C903BD666253BF70CA709@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230508060938.GA6195@unreal>
 <PH7PR21MB3116031E5E1B5B9B97AE71BCCA719@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230509073034.GA38143@unreal>
 <PH7PR21MB326324A880890867496A60C5CE769@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20230510065844.GQ38143@unreal>
 <PH7PR21MB3263176E4B1E41A5A2088D6ACE779@PH7PR21MB3263.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3263176E4B1E41A5A2088D6ACE779@PH7PR21MB3263.namprd21.prod.outlook.com>

On Wed, May 10, 2023 at 04:37:57PM +0000, Long Li wrote:
> >Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
> >enable RX coalescing
> >
> >On Tue, May 09, 2023 at 07:08:36PM +0000, Long Li wrote:
> >> > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of
> >> > cfg_rx_steer_req to enable RX coalescing
> >> >
> >> > On Mon, May 08, 2023 at 02:45:44PM +0000, Haiyang Zhang wrote:
> >> > >
> >> > >
> >> > > > -----Original Message-----
> >> > > > From: Leon Romanovsky <leon@kernel.org>
> >> > > > Sent: Monday, May 8, 2023 2:10 AM
> >> > > > To: Haiyang Zhang <haiyangz@microsoft.com>
> >> > > > Cc: Long Li <longli@microsoft.com>; Jason Gunthorpe
> >> > > > <jgg@ziepe.ca>; Ajay Sharma <sharmaajay@microsoft.com>; Dexuan
> >> > > > Cui <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>;
> >> > > > Wei Liu
> >> > <wei.liu@kernel.org>; David S.
> >> > > > Miller <davem@davemloft.net>; Eric Dumazet
> >> > > > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> >> > > > Abeni <pabeni@redhat.com>;
> >> > > > linux- rdma@vger.kernel.org; linux-hyperv@vger.kernel.org;
> >> > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> >> > > > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of
> >> > > > cfg_rx_steer_req to enable RX coalescing
> >> > > >
> >> > > > On Sun, May 07, 2023 at 09:39:27PM +0000, Haiyang Zhang wrote:
> >> > > > >
> >> > > > >
> >> > > > > > -----Original Message-----
> >> > > > > > From: Leon Romanovsky <leon@kernel.org>
> >> > > > > > Sent: Sunday, May 7, 2023 4:11 AM
> >> > > > > > To: Long Li <longli@microsoft.com>
> >> > > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Ajay Sharma
> >> > > > > > <sharmaajay@microsoft.com>; Dexuan Cui
> >> > > > > > <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>;
> >> > > > > > Haiyang Zhang
> >> > > > <haiyangz@microsoft.com>;
> >> > > > > > Wei Liu <wei.liu@kernel.org>; David S. Miller
> >> > > > > > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> >> > Jakub
> >> > > > > > Kicinski <kuba@kernel.org>;
> >> > > > Paolo
> >> > > > > > Abeni <pabeni@redhat.com>; linux-rdma@vger.kernel.org;
> >> > > > > > linux- hyperv@vger.kernel.org; netdev@vger.kernel.org;
> >> > > > > > linux- kernel@vger.kernel.org
> >> > > > > > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of
> >> > > > > > cfg_rx_steer_req
> >> > > > to
> >> > > > > > enable RX coalescing
> >> > > > > >
> >> > > > > > On Fri, May 05, 2023 at 11:51:48AM -0700,
> >> > > > > > longli@linuxonhyperv.com
> >> > > > > > wrote:
> >> > > > > > > From: Long Li <longli@microsoft.com>
> >> > > > > > >
> >> > > > > > > With RX coalescing, one CQE entry can be used to indicate
> >> > > > > > > multiple
> >> > > > packets
> >> > > > > > > on the receive queue. This saves processing time and PCI
> >> > > > > > > bandwidth over the CQ.
> >> > > > > > >
> >> > > > > > > Signed-off-by: Long Li <longli@microsoft.com>
> >> > > > > > > ---
> >> > > > > > >  drivers/infiniband/hw/mana/qp.c |  5 ++++-
> >> > > > > > >  include/net/mana/mana.h         | 17 +++++++++++++++++
> >> > > > > > >  2 files changed, 21 insertions(+), 1 deletion(-)
> >> > > > > >
> >> > > > > > Why didn't you change mana_cfg_vport_steering() too?
> >> > > > >
> >> > > > > The mana_cfg_vport_steering() is for mana_en (Enthernet)
> >> > > > > driver, not the mana_ib driver.
> >> > > > >
> >> > > > > The changes for mana_en will be done in a separate patch
> >> > > > > together with changes for mana_en RX code patch to support
> >> > > > > multiple packets /
> >> > CQE.
> >> > > >
> >> > > > I'm aware of the difference between mana_en and mana_ib.
> >> > > >
> >> > > > The change you proposed doesn't depend on "support multiple
> >> > > > packets / CQE."
> >> > > > and works perfectly with one packet/CQE also, does it?
> >> > >
> >> > > No.
> >> > > If we add the following setting to the mana_en /
> >> > > mana_cfg_vport_steering(), the NIC may put multiple packets in one
> >> > > CQE, so we need to have the changes for mana_en RX code path to
> >> > > support
> >> > multiple packets / CQE.
> >> > > +	req->cqe_coalescing_enable = true;
> >> >
> >> > You can leave "cqe_coalescing_enable = false" for ETH and still
> >> > reuse your new
> >> > v2 struct.
> >>
> >> I think your proposal will work for both Ethernet and IB.
> >>
> >> The idea is that we want this patch to change the behavior of the IB driver. We
> >plan to make another patch for the Ethernet driver. This makes it easier to track
> >all changes for a driver.
> >
> >And I don't want to deal with deletion of v1 struct for two/three kernel cycles
> >instead of one patch in one cycle.
> 
> I'm resubmitting this patch to replace v1 for both driver.

Great

> 
> >
> >>
> >> >
> >> > H>
> >> > > So we plan to set this cqe_coalescing_enable, and the changes for
> >> > > mana_en RX code path to support multiple packets / CQE in another
> >patch.
> >> >
> >> > And how does it work with IB without changing anything except this
> >> > proposed patch?
> >>
> >> The RX CQE Coalescing is implemented in the user-mode. This feature is
> >always turned on from cluster. The user-mode code is written in a way that can
> >deal with both CQE Coalescing and CQE non-coalescing, so it doesn't depend on
> >kernel version for the correct behavior.
> >
> >Yes, but how does userspace know that CQE coalescing was enabled?
> 
> The user-mode doesn't know if CQE is enabled in advance. If this information is required I can modify the patch to pass this information along to rdma-core. However, this is not useful as the cluster is running with CQE coalescing enabled by default, there is no need to know this information.

It is ok, not needed. if we can do something without UAPI involvement,
it will be always preferable way.

Thanks

