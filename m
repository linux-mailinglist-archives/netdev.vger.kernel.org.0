Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF433F5DEF
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 14:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbhHXMZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 08:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhHXMZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 08:25:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD70661265;
        Tue, 24 Aug 2021 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629807902;
        bh=j4Scjf2LPhmz0hwoYXxO4GymWUu5idJCZ0z81XCcypU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZvqN8MkvRWvN8ickJIazzt8J1EepxNBBs4khk9fzOdnmzzvhp6hGnFfmtNSi8MSqq
         2AC5chdQ0LzhQegoUrDHRt8nNQrUXu+BO2e7xY1ZKHAsDNkcNRmRDVpCRPdozpfLdD
         iIGKeLpe9MgCEnVUwXYXAQUUjU889m7qhTOpcIMIKfAygfD1sNjz1o44DWiv2730Xa
         DZ9XHvCBzk405DoBendDkwVFMl+7UcxT+PgyPqbY5B8sxGiLGjsHTn/GiNwOYtqYqj
         mq7NEAw9pYnK5LsObWBrRkG00UjgoJVXQJXPKZh06HdUrCZJ+0aq9hWH1LdA1e7IXu
         Uczuf1G0tq+gw==
Date:   Tue, 24 Aug 2021 15:24:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Ariel Elior <aelior@marvell.com>, Shai Malin <smalin@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Message-ID: <YSTlGlnDYjI/VhNB@unreal>
References: <20210822185448.12053-1-smalin@marvell.com>
 <YSOL9TNeLy3uHma6@unreal>
 <20210823133340.GC543798@ziepe.ca>
 <BY3PR18MB46419B2A887EFFCB5B74F30BC4C49@BY3PR18MB4641.namprd18.prod.outlook.com>
 <20210823151742.GD543798@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823151742.GD543798@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 12:17:42PM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 23, 2021 at 02:54:13PM +0000, Ariel Elior wrote:
> > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > Sent: Monday, August 23, 2021 4:34 PM
> > > To: Leon Romanovsky <leon@kernel.org>
> > > Cc: Shai Malin <smalin@marvell.com>; davem@davemloft.net;
> > > kuba@kernel.org; netdev@vger.kernel.org; Ariel Elior
> > > <aelior@marvell.com>; malin1024@gmail.com; RDMA mailing list <linux-
> > > rdma@vger.kernel.org>
> > > Subject: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
> > > 
> > > External Email
> > > 
> > > On Mon, Aug 23, 2021 at 02:52:21PM +0300, Leon Romanovsky wrote:
> > > > +RDMA
> > > >
> > > > Jakub, David
> > > >
> > > > Can we please ask that everything directly or indirectly related to
> > > > RDMA will be sent to linux-rdma@ too?
> > > >
> > > > On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> > > > > Enable the RoCE and iWARP FW relaxed ordering.
> > > > >
> > > > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > > > drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > > b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > > index 4f4b79250a2b..496092655f26 100644
> > > > > +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > > @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn
> > > *p_hwfn,
> > > > >  				    cnq_id);
> > > > >  	}
> > > > >
> > > > > +	p_params_header->relaxed_ordering = 1;
> > > >
> > > > Maybe it is only description that needs to be updated, but I would
> > > > expect to see call to pcie_relaxed_ordering_enabled() before setting
> > > > relaxed_ordering to always true.
> > > >
> > > > If we are talking about RDMA, the IB_ACCESS_RELAXED_ORDERING flag
> > > > should be taken into account too.
> > > 
> > > Why does this file even exist in netdev? This whole struct qed_rdma_ops
> > > mess looks like another mis-design to support out of tree modules??
> > > 
> > > Jason
> > 
> > Hi Jason,
> > qed_rdma_ops is not related to in tree / out of tree drivers. The qed is the
> > core module which is used by the protocol drivers which drive this type of nic:
> > qede, qedr, qedi and qedf for ethernet, rdma, iscsi and fcoe respectively.
> > qed mostly serves as a HW abstraction layer, hiding away the details of FW
> > interaction and device register usage, and may also hold Linux specific things
> > which are protocol agnostic, such as dcbx, sriov, debug data collection logic,
> > etc. qed interacts with the protocol drivers through ops structs for many
> > purposes (dcbx, ptp, sriov, etc). And also for rdma. It's just a way for us to
> > separate the modules in a clean way.
> 
> Delete the ops struct.
> 
> Move the RDMA functions to the RDMA module
> 
> Directly export the core functions needed to make that work
> 
> Two halfs of the same dirver do not and should not have an ops structure
> ABI between them.

Yea, I read drivers/net/ethernet/qlogic/qed/qed_rdma.c and have hard
time to believe that hiding RDMA objects and code from the RDMA community
can be counted as "a clean way".

Thanks

> 
> Jason
