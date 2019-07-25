Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D487568B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfGYSG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:06:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35663 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGYSGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:06:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so50024172qto.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 11:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IBzLUbfuZY1yXSm5tU/kxob6ZMidh6X8dv85/aPXEPs=;
        b=GXQCM2pmttL9pRo3O8N2fTMYslKqPqjJWB94KMSRAICEClAFscw5G5xGh6Cj79m93x
         5nmV4of6dSvJLGdZ84s94MuGBQFGZxTv85hes23hz/n5xUWNNhfRSo+eIMsvmrIw+OK0
         1ZKeicAuGmvOka1FsS91lvOqHDKhD5L27MYkexclgtLlHm08ekQt4rEeketan2jY6fT4
         /7f0uK2yxguOll53aVg/hXI55YOVu14gLaa2WknZVHWnMFA4Bobk5BTEELhaWSuFINcU
         CIbDYQhEJFG6ha8Xer1KR4TKEcZ+/q9F3QGNT7ArEaXh/kr38q3RQ8A4L6bzMxAtZeVU
         0eJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IBzLUbfuZY1yXSm5tU/kxob6ZMidh6X8dv85/aPXEPs=;
        b=mQB5n9besl5X/sQn7mOe7+6j5p2TEpizDE2FpAx+HyddqZQ3P8J9mUdUxLz/eJB7Lp
         HCAs3MvS3U9r1Kjt2RDvwRcQBm2IdujBGD4Hd/vt+sLobJP+TgDK1xSEQ3x3H8mMEFd8
         FkPpOLSPw8c+6nUDJ2y70oH0RDquw/NrZNBFQ9d/ZPeZ5P0AdQTX/kSnuFt7gvp5qFvH
         ZizgkP5EFd2kdVD1Qywkb7JCODDV+utfZtvnTkYg+Sowop/0rd3ShWvsteMRH1WaK1P1
         /Bfwu48Ph6CNQpS806isHwPATnArtlOqCSFjzIabYOW3zKoz7Ola2R/70WqQyaMlNpGR
         rSEw==
X-Gm-Message-State: APjAAAWZNDHuJNy29TV+rF2gt3LMbN8LgMuwLZQsr7hRuS9O70ZQO4EK
        jL4yxP6ayMgZNo0VbN62gIUeiQ==
X-Google-Smtp-Source: APXvYqxuCFS52KUiwjQrsyCGdLoT5/fE0KDdLCqz30/q/szjTbrmHIOXQMIt0uNvoaq72eyUTY4u4Q==
X-Received: by 2002:ac8:1b30:: with SMTP id y45mr61139694qtj.218.1564077984957;
        Thu, 25 Jul 2019 11:06:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id o22sm20371188qkk.50.2019.07.25.11.06.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jul 2019 11:06:24 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hqi8F-0008SB-SC; Thu, 25 Jul 2019 15:06:23 -0300
Date:   Thu, 25 Jul 2019 15:06:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     ariel.elior@marvell.com, dledford@redhat.com, galpress@amazon.com,
        linux-rdma@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 rdma-next 4/6] qed*: Change dpi_addr to be denoted
 with __iomem
Message-ID: <20190725180623.GA32435@ziepe.ca>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-5-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709141735.19193-5-michal.kalderon@marvell.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 05:17:33PM +0300, Michal Kalderon wrote:
> Several casts were required around dpi_addr parameter in qed_rdma_if.h
> This is an address on the doorbell bar and should therefore be marked
> with __iomem.
> 
> Reported-by: Jason Gunthorpe <jgg@mellanox.com>
> Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
>  drivers/infiniband/hw/qedr/main.c          | 2 +-
>  drivers/infiniband/hw/qedr/qedr.h          | 2 +-
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 5 ++---
>  include/linux/qed/qed_rdma_if.h            | 2 +-
>  4 files changed, 5 insertions(+), 6 deletions(-)

More lines are RDMA than net, so this patch applied to for-next

Thanks,
Jason
