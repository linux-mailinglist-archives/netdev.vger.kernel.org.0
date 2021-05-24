Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC7738F41E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhEXUQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhEXUQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:16:25 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8FFC061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:14:55 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lg14so43656958ejb.9
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qXqx8ZIQOHXl21JR2YMW/bREa48kiM+B1pCDqSAY+p8=;
        b=E9wdqG4zmQVjp5/f9XP1E3+Qx3Avb6nXRqeaqspvyZTNvSu5mN9pQnMYAmwmTvtk5Z
         XZhi9IU4iZ8Ay/3y6K0w4u7NOR/IWnr5nwtIAc6ajBoT30qeg5NRP60mK6dTmrPEZYTv
         RWpcWDX/CFpeh7QAxL9AnV2O/dy2q2A3iMKeXuVqE1HlkPO1rla+ZtTl4OJ/usrtxnxO
         WBeI0razjJA9cYLvaFODhnSbQNcSd7jwJzYSZSo1RO+YauQbtL+YHkUeRsbcxt915FeP
         CMwr/9z9xkK/GYZmHRunG+sT37LAnJJ/woDvzSkVjD//bHW8xqq9Owl2gRoLgOOdCmfY
         WM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qXqx8ZIQOHXl21JR2YMW/bREa48kiM+B1pCDqSAY+p8=;
        b=PDLg3+fgy0qyqWXlqAPZmzY/d6iK1ntCaVN+7gyo0ebWJoWoU6jYtALxGMJmfhvcZz
         yZ/+y6FGWJ/tPwLu5MjRw43GgrPxYq2rCazwZQSG2VoDcaGNtlxLob994haN3uuCJKNr
         ov4HZnGKXhu2CfvTfTZUGa5PSjLK04TsWzn9bK68tMMgSkjgKWHywLpMeNajb0VmZcoA
         e963zqE6AmffCOqk+tc4GU87GKUaa9ryCrBYO23UxrCrsiP5A7FeYNsAXwsa8Kq07hdE
         gwhji3WonctpFZ2Pd1b2Xw+oIRt7GQR1EuePRjovYV8P9tJJ7LC+8pxiinPny5UeQhGL
         NyZw==
X-Gm-Message-State: AOAM533sSeW/SzWbwlNHZQl+SzDesa6h2U0UhHdq4j4OsPedyDRC9PPE
        hV4vJkDEKaTPRAD5LlEiMobJ4/H50jF3iHSADKE=
X-Google-Smtp-Source: ABdhPJzl1Y88BvW0MhmCGEtmNG5SBAP/C/lPJbzXZtBR+SBho1ZKraTzgwPm+uYATpE37TJN7YWKRPc6Jl4Xm612Ofs=
X-Received: by 2002:a17:907:76e8:: with SMTP id kg8mr23511321ejc.130.1621887293891;
 Mon, 24 May 2021 13:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210519111340.20613-1-smalin@marvell.com> <20210519111340.20613-4-smalin@marvell.com>
 <e986c505-b81a-36ab-6366-35d5fbc193e1@grimberg.me>
In-Reply-To: <e986c505-b81a-36ab-6366-35d5fbc193e1@grimberg.me>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 24 May 2021 23:14:41 +0300
Message-ID: <CAKKgK4y77NNN7N81GOdTm=btirDCv0uLGqESjuhccZs1CB5opg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 03/27] nvme-tcp-offload: Add device scan implementation
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>,
        Shai Malin <smalin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/21 1:22 AM, Sagi Grimberg wrote:
> On 5/19/21 4:13 AM, Shai Malin wrote:
> > From: Dean Balandin <dbalandin@marvell.com>
> >
> > As part of create_ctrl(), it scans the registered devices and calls
> > the claim_dev op on each of them, to find the first devices that matches
> > the connection params. Once the correct devices is found (claim_dev
> > returns true), we raise the refcnt of that device and return that device
> > as the device to be used for ctrl currently being created.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/host/tcp-offload.c | 94 +++++++++++++++++++++++++++++++++
> >   1 file changed, 94 insertions(+)
> >
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> > index 711232eba339..aa7cc239abf2 100644
> > --- a/drivers/nvme/host/tcp-offload.c
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -13,6 +13,11 @@
> >   static LIST_HEAD(nvme_tcp_ofld_devices);
> >   static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
> >
> > +static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctrl)
> > +{
> > +     return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
> > +}
> > +
> >   /**
> >    * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
> >    * function.
> > @@ -98,6 +103,94 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
> >       /* Placeholder - complete request with/without error */
> >   }
> >
> > +struct nvme_tcp_ofld_dev *
> > +nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
> > +{
> > +     struct nvme_tcp_ofld_dev *dev;
> > +
> > +     down_read(&nvme_tcp_ofld_devices_rwsem);
> > +     list_for_each_entry(dev, &nvme_tcp_ofld_devices, entry) {
> > +             if (dev->ops->claim_dev(dev, &ctrl->conn_params)) {
> > +                     /* Increase driver refcnt */
> > +                     if (!try_module_get(dev->ops->module)) {
>
> This means that every controller will take a long-lived reference on the
> module? Why?

This is in order to create a per controller dependency between the
nvme-tcp-offload and the vendor driver which is currently used.
We believe that the vendor driver which offloads a controller should exist
as long as the controller exists.

>
> > +                             pr_err("try_module_get failed\n");
> > +                             dev = NULL;
> > +                     }
> > +
> > +                     goto out;
> > +             }
> > +     }
> > +
> > +     dev = NULL;
> > +out:
> > +     up_read(&nvme_tcp_ofld_devices_rwsem);
> > +
> > +     return dev;
> > +}
> > +
> > +static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
> > +{
> > +     /* Placeholder - validates inputs and creates admin and IO queues */
> > +
> > +     return 0;
> > +}
> > +
> > +static struct nvme_ctrl *
> > +nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl;
> > +     struct nvme_tcp_ofld_dev *dev;
> > +     struct nvme_ctrl *nctrl;
> > +     int rc = 0;
> > +
> > +     ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
> > +     if (!ctrl)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     nctrl = &ctrl->nctrl;
> > +
> > +     /* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received opts */
> > +
> > +     /* Find device that can reach the dest addr */
> > +     dev = nvme_tcp_ofld_lookup_dev(ctrl);
> > +     if (!dev) {
> > +             pr_info("no device found for addr %s:%s.\n",
> > +                     opts->traddr, opts->trsvcid);
> > +             rc = -EINVAL;
> > +             goto out_free_ctrl;
> > +     }
> > +
> > +     ctrl->dev = dev;
> > +
> > +     if (ctrl->dev->ops->max_hw_sectors)
> > +             nctrl->max_hw_sectors = ctrl->dev->ops->max_hw_sectors;
> > +     if (ctrl->dev->ops->max_segments)
> > +             nctrl->max_segments = ctrl->dev->ops->max_segments;
> > +
> > +     /* Init queues */
> > +
> > +     /* Call nvme_init_ctrl */
> > +
> > +     rc = ctrl->dev->ops->setup_ctrl(ctrl, true);
> > +     if (rc)
> > +             goto out_module_put;
>
> goto module_put without an explicit module_get is confusing.

We will modify the function to use explicit module_get so it will be clear.

>
> > +
> > +     rc = nvme_tcp_ofld_setup_ctrl(nctrl, true);
> > +     if (rc)
> > +             goto out_uninit_ctrl;
>
> ops->setup_ctrl and then call to nvme_tcp_ofld_setup_ctrl?
> Looks weird, why are these separated?

We will move the vendor specific setup_ctrl() call into
nvme_tcp_ofld_setup_ctrl().

>
> > +
> > +     return nctrl;
> > +
> > +out_uninit_ctrl:
> > +     ctrl->dev->ops->release_ctrl(ctrl);
> > +out_module_put:
> > +     module_put(dev->ops->module);
> > +out_free_ctrl:
> > +     kfree(ctrl);
> > +
> > +     return ERR_PTR(rc);
> > +}
> > +
> >   static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
> >       .name           = "tcp_offload",
> >       .module         = THIS_MODULE,
> > @@ -107,6 +200,7 @@ static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
> >                         NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
> >                         NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
> >                         NVMF_OPT_TOS,
> > +     .create_ctrl    = nvme_tcp_ofld_create_ctrl,
> >   };
> >
> >   static int __init nvme_tcp_ofld_init_module(void)
> >
