Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0733F4D32
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 17:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhHWPS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 11:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhHWPS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 11:18:26 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63722C061757
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 08:17:44 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id l24so14067270qtj.4
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 08:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VN41B2TInuUjKqFTZ4zpkChK47xwz4yGQZWIYcJjvv8=;
        b=N0DPPFzo/F0wFdNI+eDxPdvfhaDKls4KGfmrxhRq+rud1w23SmeKKjX9gn4pe3bkU6
         q140fhe9yvHKYDNc1O+/tbkvPjQ+Ew2lYSH5LbK6ISw2e44WKVJb8agckosLuZusVRpB
         gXpcCEB1pwUK3CvBOJ30xG4s5LlLxE8ptHndLGn53cWIwudoF+a9IayjORZsJ9miv/bp
         CTRCHpT/ruKN3Mq/+1GiFh0DzOLHyUnhEIEXwEFB4uhebx44B/1Ssf4M0TIoucEp3WDZ
         UuwaLmlJFf/KMCbuAch8BVg0DGwRWO5DneHJjhgpOzGHiY5F+47CSMnWxsmIBZQSCMLt
         yMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VN41B2TInuUjKqFTZ4zpkChK47xwz4yGQZWIYcJjvv8=;
        b=jno3pka437RvWYFtnccsOMPU9s3xaCtBu/xMR6SJArGtNhEddk3yGlH2JYm8FwI7ZO
         M08u4eL599u9Uruvk3M2eU6IWSJPLb0sSjVRvS4IExX6FNo59F+J4a8EphGM8UbUrQTJ
         V/GKAciYIkobXd8xaiWJ56qSaF1miiTqAl8Hr/XZHu7DjFuIq9HKq8l6DsVr9E6A3FMh
         WPuo2uHvFJj88yDCHa4qS5EKp9UK84TFdDE3341lfzYYgHrAv7uCD9ePxRfu7Kl4MRUF
         Ri+vQteml0/mYTpxm5npJ2upfkiXVfFZomutzz4hnERcge+g7C8ZFhC1/gCzhwaqNaa+
         Nt8Q==
X-Gm-Message-State: AOAM530wQKXp7OqwUYOt1D1ce0dKQxVC48IzlRI71nNytx6vSxgM/8fc
        OjiZXZz9fCWkELn64U3V0qIGXA==
X-Google-Smtp-Source: ABdhPJwOe5F+AET+LhWBy7pAq1u7fj7AVjs/sOrNnqkk5xSb3DlBmb8UH4jnlMQmrsv2DV1CaIls3A==
X-Received: by 2002:ac8:5941:: with SMTP id 1mr15648367qtz.1.1629731863349;
        Mon, 23 Aug 2021 08:17:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id d11sm3694825qtx.5.2021.08.23.08.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 08:17:42 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIBhm-003hrk-AR; Mon, 23 Aug 2021 12:17:42 -0300
Date:   Mon, 23 Aug 2021 12:17:42 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Shai Malin <smalin@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Message-ID: <20210823151742.GD543798@ziepe.ca>
References: <20210822185448.12053-1-smalin@marvell.com>
 <YSOL9TNeLy3uHma6@unreal>
 <20210823133340.GC543798@ziepe.ca>
 <BY3PR18MB46419B2A887EFFCB5B74F30BC4C49@BY3PR18MB4641.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB46419B2A887EFFCB5B74F30BC4C49@BY3PR18MB4641.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 02:54:13PM +0000, Ariel Elior wrote:
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Monday, August 23, 2021 4:34 PM
> > To: Leon Romanovsky <leon@kernel.org>
> > Cc: Shai Malin <smalin@marvell.com>; davem@davemloft.net;
> > kuba@kernel.org; netdev@vger.kernel.org; Ariel Elior
> > <aelior@marvell.com>; malin1024@gmail.com; RDMA mailing list <linux-
> > rdma@vger.kernel.org>
> > Subject: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
> > 
> > External Email
> > 
> > On Mon, Aug 23, 2021 at 02:52:21PM +0300, Leon Romanovsky wrote:
> > > +RDMA
> > >
> > > Jakub, David
> > >
> > > Can we please ask that everything directly or indirectly related to
> > > RDMA will be sent to linux-rdma@ too?
> > >
> > > On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> > > > Enable the RoCE and iWARP FW relaxed ordering.
> > > >
> > > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > > drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > index 4f4b79250a2b..496092655f26 100644
> > > > +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn
> > *p_hwfn,
> > > >  				    cnq_id);
> > > >  	}
> > > >
> > > > +	p_params_header->relaxed_ordering = 1;
> > >
> > > Maybe it is only description that needs to be updated, but I would
> > > expect to see call to pcie_relaxed_ordering_enabled() before setting
> > > relaxed_ordering to always true.
> > >
> > > If we are talking about RDMA, the IB_ACCESS_RELAXED_ORDERING flag
> > > should be taken into account too.
> > 
> > Why does this file even exist in netdev? This whole struct qed_rdma_ops
> > mess looks like another mis-design to support out of tree modules??
> > 
> > Jason
> 
> Hi Jason,
> qed_rdma_ops is not related to in tree / out of tree drivers. The qed is the
> core module which is used by the protocol drivers which drive this type of nic:
> qede, qedr, qedi and qedf for ethernet, rdma, iscsi and fcoe respectively.
> qed mostly serves as a HW abstraction layer, hiding away the details of FW
> interaction and device register usage, and may also hold Linux specific things
> which are protocol agnostic, such as dcbx, sriov, debug data collection logic,
> etc. qed interacts with the protocol drivers through ops structs for many
> purposes (dcbx, ptp, sriov, etc). And also for rdma. It's just a way for us to
> separate the modules in a clean way.

Delete the ops struct.

Move the RDMA functions to the RDMA module

Directly export the core functions needed to make that work

Two halfs of the same dirver do not and should not have an ops structure
ABI between them.

Jason
