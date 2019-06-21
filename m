Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C4A4EFB8
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfFUT6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 15:58:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46888 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUT6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 15:58:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so8121356qtn.13
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 12:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+OL1EA4GCbl4Wh7y66sPCRx7u7qlJpiBT7Azs49rZ54=;
        b=aDjgKXV6FnLW14ByDPqOBaeUXx6pK0vNdEQ7hSHyRGy0adxzZJMswyS6FCvLBj8M3w
         q8ft14gQmSA2IgeSnnxvUIEclc1OgibEzbcHXIuEtkP31RryJ/kuEZHAV8U0lpctQ3YL
         iEQxFJ9Mo7cX4+VeKO/1ik6lHUk1tQpuW5xLeNsVZLgKAqejRpG/0u4KfLbP4mtCLEA0
         Ah0bF8UMrQt0pOTySqDq4X7My6Ft1mXlv2xGMlOIfYjLAQWnLdWO9Y6ml7NX/IQWv0Yk
         E8qjVhqP4kHYaAziQ4RQSAGe/q8nNiJ5Bzmn1J9kaV+PQqmcBYWuHmB7dh6hvYL7hPvp
         Y3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+OL1EA4GCbl4Wh7y66sPCRx7u7qlJpiBT7Azs49rZ54=;
        b=eY2LGLdSTrIFdh/Ad7aiGVUmJu8d+Cg2ois3+YWLWMvEL+MZ4KUqBLx2eausVoReF1
         GW1gJ8v4kQlx7F8N3iigV0oCZBWIiuYhYOSdQ/e5Dp57B75Rjx+hxpJOfVTXo20lRp2D
         RBFV78chgFIi+oPP+LTjrxtAsjexZGzjvjP8aYf8PMNO+P9BrXcB4Ep2vRPdHxKnFshG
         gDLYSLgzM9OeSDdCqMnXkDTXQJNHTow63ARZSvOcPcVRFWzLk89G1Cy+pv6cC/EgYKY2
         xYZ2evuz5m4RKuQA0YIceNGzKtbEhfKnoJ4KodJH4OjcozaGPH/nivNJyixgI3MabwCC
         I88A==
X-Gm-Message-State: APjAAAXXwI+jP/nBQZ4pWWqadQ1fJN9bokgzDSRuvIVTgL8JsbfSKjSo
        G6PbtVJ4PaHiOCA9Kmlfysdiyg==
X-Google-Smtp-Source: APXvYqzXKKjFNghyDugBNIDlSQHmdWu+B3owSseXWV1iQfYGMMS+MpWqWx05AoM1Aw67ubtqFggDKA==
X-Received: by 2002:a0c:8849:: with SMTP id 9mr15273062qvm.21.1561147099205;
        Fri, 21 Jun 2019 12:58:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id y20sm1869495qka.14.2019.06.21.12.58.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Jun 2019 12:58:18 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hePfu-00089L-8Q; Fri, 21 Jun 2019 16:58:18 -0300
Date:   Fri, 21 Jun 2019 16:58:18 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Ariel Elior <aelior@marvell.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 rdma-next 0/3] RDMA/qedr: Use the doorbell overflow
 recovery mechanism for RDMA
Message-ID: <20190621195818.GY19891@ziepe.ca>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
 <bda0321cb362bc93f5428b1df7daf69fed083656.camel@redhat.com>
 <MN2PR18MB3182498CA8C9C7EB3259F62FA1E70@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB3182498CA8C9C7EB3259F62FA1E70@MN2PR18MB3182.namprd18.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 07:49:39PM +0000, Michal Kalderon wrote:
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Doug Ledford
> > 
> > On Thu, 2019-06-13 at 11:38 +0300, Michal Kalderon wrote:
> > > This patch series used the doorbell overflow recovery mechanism
> > > introduced in commit 36907cd5cd72 ("qed: Add doorbell overflow
> > > recovery mechanism") for rdma ( RoCE and iWARP )
> > >
> > > rdma-core pull request #493
> > >
> > > Changes from V2:
> > > - Don't use long-lived kmap. Instead use user-trigger mmap for the
> > >   doorbell recovery entries.
> > > - Modify dpi_addr to be denoted with __iomem and avoid redundant
> > >   casts
> > >
> > > Changes from V1:
> > > - call kmap to map virtual address into kernel space
> > > - modify db_rec_delete to be void
> > > - remove some cpu_to_le16 that were added to previous patch which are
> > >   correct but not related to the overflow recovery mechanism. Will be
> > >   submitted as part of a different patch
> > >
> > >
> > > Michal Kalderon (3):
> > >   qed*: Change dpi_addr to be denoted with __iomem
> > >   RDMA/qedr: Add doorbell overflow recovery support
> > >   RDMA/qedr: Add iWARP doorbell recovery support
> > >
> > >  drivers/infiniband/hw/qedr/main.c          |   2 +-
> > >  drivers/infiniband/hw/qedr/qedr.h          |  27 +-
> > >  drivers/infiniband/hw/qedr/verbs.c         | 387
> > > ++++++++++++++++++++++++-----
> > >  drivers/net/ethernet/qlogic/qed/qed_rdma.c |   6 +-
> > >  include/linux/qed/qed_rdma_if.h            |   2 +-
> > >  include/uapi/rdma/qedr-abi.h               |  25 ++
> > >  6 files changed, 378 insertions(+), 71 deletions(-)
> > >
> > 
> > Hi Michal,
> > 
> > In patch 2 and 3 both, you still have quite a few casts to (u8 __iomem *).
> > Why not just define the struct elements as u8 __iomem * instead of void
> > __iomem * and avoid all the casts?
> > 
> Hi Doug, 
> 
> Thanks for the review. The remaining casts are due to pointer arithmetic and not variable assignments
> as before. Removing the cast entirely will require quite a lot of changes in qed and in rdma-core
> which I would be happy to avoid at this time. 

In linux pointer math on a void * acts the same as a u8 so you should
never need to cast a void * to a u8 just to do math?

Jason
