Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F85128BB5
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 22:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfLUVTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 16:19:52 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34809 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfLUVTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 16:19:52 -0500
Received: by mail-il1-f193.google.com with SMTP id s15so11051754iln.1
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 13:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ryiHDUuNAqP4QzqBSFVAqfWHx+GwcCe8K4qYuGFe+7I=;
        b=IofBVGqCwyHx05OokV0/Mi+GsZfFqUWPEqHXlE8SD7ljZnKjNn33dyid4kaub9mkZW
         Lh6gjQaG3b0cWchmJgUviTVtAwH/tp2kfExkrCyISdbITfud9qZ8MoOIJ4CupFu9B4QY
         A7LU+eXgYy/ZTnxP5ZYSXCLIBo5iJmdxSQYbHTxmH2N/nlS5b/2D7e/72bvp6pBhF/eL
         a5OuFiIu9F61BhYaMjmBov3wTOsqld80xy8q0OAxS3MS9tJxxureDAyiSOE02absgiUX
         wgCfUAYXeQw9C4PXaKZ8bi7aJ8xo1j0ZKQd3TbXXdGnH91ZSX1hd5yfG13/qRZDISFMJ
         JbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ryiHDUuNAqP4QzqBSFVAqfWHx+GwcCe8K4qYuGFe+7I=;
        b=MHdVfNvPE538svGPMuhGijJancWoCYm0glNkCp9nd5nCzDyBrwthZRGyMVPNydKgjd
         QPJO7b9GJYg7/zYJy0FjRcPe02GMEG8k0b7t9QNKljQuR+DgH2+/MXC8s/77MxoquaPI
         ka5U3lquGPqYOFzVkS71nwkXpCSvr8Rh+jz05Rn5CKDblqLfavFC089ZMQx/stPXEpMn
         IAQ+yG+/LvWmdjmTBsgO6YZd56QI/s9hECWIbc/hQtLn7fSzc386CyrnFtqqHqqCR9xJ
         ZKs6GYCEyiAf+kROvWRuaBLwrkUjJ7fEIGDgtFWJeTE36hh+2zpmbig55X9I4M+sqAh6
         zlVw==
X-Gm-Message-State: APjAAAW4JRicJ3KrCcrgzXriqsd0ZlbiKBbd6ObhbyAxsiXvDYrPVF92
        81QXatFeAKTVqUwBVqV4T+pLI7QJn2/F8IsuC9dHqQ==
X-Google-Smtp-Source: APXvYqyZE+QmAxWd9UXymtVOG+xl/oD9BEsoFWN9iahucCvKUbShAtJn3CxLUCBFxha+65qoTZX33gYHmhNnxPK2uuA=
X-Received: by 2002:a92:afc5:: with SMTP id v66mr17505932ill.123.1576963191681;
 Sat, 21 Dec 2019 13:19:51 -0800 (PST)
MIME-Version: 1.0
References: <20191220001517.105297-1-olof@lixom.net> <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
In-Reply-To: <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Sat, 21 Dec 2019 13:19:40 -0800
Message-ID: <CAOesGMgxHGBdkdVOoWYpqSF-13iP3itJksCRL8QSiS0diL26dA@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Fix printk format warning
To:     Joe Perches <joe@perches.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 6:07 PM Joe Perches <joe@perches.com> wrote:
>
> On Thu, 2019-12-19 at 16:15 -0800, Olof Johansson wrote:
> > Use "%zu" for size_t. Seen on ARM allmodconfig:
> []
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
> []
> > @@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
> >       len = nstrides << wq->fbc.log_stride;
> >       wqe = mlx5_wq_cyc_get_wqe(wq, ix);
> >
> > -     pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n",
> > +     pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %zu\n",
> >               mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
> >       print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, false);
> >  }
>
> One might expect these 2 outputs to be at the same KERN_<LEVEL> too.
> One is KERN_INFO the other KERN_WARNING

Sure, but I'll leave that up to the driver maintainers to decide/fix
-- I'm just addressing the type warning here.


-Olof
