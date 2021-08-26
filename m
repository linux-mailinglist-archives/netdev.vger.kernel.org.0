Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDA83F884D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhHZNHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhHZNHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:07:20 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EBEC0613C1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:06:33 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id l3so2341911qtk.10
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BxOyz0s7ffDW0S8EYOreEbHmjWrOws7Dl1EdWL/BVFY=;
        b=TVKdnRXvGmlIKYXCHgLQPx17q7jC5hFApJM2045zVSJhdcbWoOYeGnzCWpCV569/n2
         Hn51TJnS5ed72DNO6171LtsJ291lkWEe4ANvxuzsnmHhHJzNNh6sgpxMDDSaV605PnmB
         Uf464vAL74AsANQXCLE4ieCnZD6lpOlVTqHUkByZdO38YQNlzZ3qNm86hXM2oDQguLic
         h8qXAFrnQhLZytwhTYDe3vdjZrLVf1hsr9w7vYZs/u+2C4GCYkZYrcqqmsnZMNE8xuMs
         kBRRSapt5teu356Hag9SadQjyIBVjsiH5zYSgew648iqAv+89it77MVlmQbGPQbQdBQi
         0kBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BxOyz0s7ffDW0S8EYOreEbHmjWrOws7Dl1EdWL/BVFY=;
        b=aXQf5q4IF2+SOaXCFjY347aIOfABx53Viwq7ccStt6dHXlVo1s4bKryfNOtIT1Y3Xz
         F8+nwrNBdIlNUz/j7RoshOF1WxIq4yxr7Ddp47dO8fqiG1vtvvRakJ1+0XMkHNx5Y0My
         YK47jK5GoojYELV9d00QKMZwQq8b9NNRf5S1urioks4KKDV0qLbW0kbJMfusHne1rqjI
         aL1SMT/DujPURoZbqF48MxYFQ7EIBRElTpLVa3KQRO+6mBEz/RvCFzJFJfL30/OQOjfs
         WhpzTZ+bpICnOcsIumIi69pygSzQFxTHOJKIRuPMVJObC0MP5uBJZwtSUlgkXyIVn8fi
         EPYg==
X-Gm-Message-State: AOAM531pzn7YhKS4VxaWq5A0D95x9muLwKXLqEl+aX0/0q/LR9rgOJ+3
        ODhatUDsxmmyICI+/dvhuw9c8Q==
X-Google-Smtp-Source: ABdhPJxqLMAjYmwRdpXuAOL65+WntL9hgg+OspI02G+4pU4bQobcxdawy0kOOZmwzFUlb/tvbXFcLw==
X-Received: by 2002:ac8:5a51:: with SMTP id o17mr3083390qta.386.1629983192013;
        Thu, 26 Aug 2021 06:06:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id l13sm2413817qkp.97.2021.08.26.06.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:06:31 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mJF5S-005INL-HS; Thu, 26 Aug 2021 10:06:30 -0300
Date:   Thu, 26 Aug 2021 10:06:30 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Shai Malin <smalin@marvell.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] qed: Enable RDMA relaxed ordering
Message-ID: <20210826130630.GD1200268@ziepe.ca>
References: <SJ0PR18MB3882237C8D74EB4A93A711DFCCC79@SJ0PR18MB3882.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR18MB3882237C8D74EB4A93A711DFCCC79@SJ0PR18MB3882.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:05:18PM +0000, Shai Malin wrote:
> On Mon, Aug 23, 2021 at 02:52:21PM +0300, Leon Romanovsky wrote:
> > +RDMA
> > 
> > Jakub, David
> > 
> > Can we please ask that everything directly or indirectly related to RDMA
> > will be sent to linux-rdma@ too?
> 
> In addition to all that was discussed regarding qed_rdma.c 
> and qed_rdma_ops - certainly, everything directly or indirectly 
> related to RDMA will be sent to linux-rdma.
> 
> > 
> > On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> > > Enable the RoCE and iWARP FW relaxed ordering.
> > >
> > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > >  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > index 4f4b79250a2b..496092655f26 100644
> > > +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn
> > *p_hwfn,
> > >  				    cnq_id);
> > >  	}
> > >
> > > +	p_params_header->relaxed_ordering = 1;
> > 
> > Maybe it is only description that needs to be updated, but I would
> > expect to see call to pcie_relaxed_ordering_enabled() before setting
> > relaxed_ordering to always true.
> 
> This change will only allow the FW to support relaxed ordering but it 
> will be enabled only if the device/root-complex/server supports 
> relaxed ordering.
> The pcie_relaxed_ordering_enabled() is not needed in this case.

I'm confused, our RDMA model is not to blanket enable relaxed
ordering, we set out rules that the driver has to follow when a
relaxed ordering TLP can be issued:
 - QP/CQ/etc internal queues - device decision based on correctness
 - Kernel created MRs - always
 - User created MRs - only if IB_ACCESS_RELAXED_ORDERING is set

So what does this flag do, and does it follow this model?

Jason
