Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C539C3747BF
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhEESFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbhEESED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 14:04:03 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC0CC0610E9
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 10:52:29 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h10so3020807edt.13
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 10:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R8dasBlS/Y7b20YlP5Fv5XJkDkpsZKVL54qsW+OQ24E=;
        b=F1PXH6urbmUO8odDmWIWLM0qMnkm8zo67lORvOQeJi2O5InMMFtc1pyISkNg5mTybr
         KuAYzZ05UK3Zv1KnEbljcBoUdJ2d1OjtMoEthJPgDUNeNCpWcgPFvfUQ5TgGdipqxoM+
         1yqVebUPm9DXzzS8p54sNIcqKFOKowMmEbyU9BvOjxc9l2I5d9lb/gbXhEPi0Zr4SYc9
         4o/gFn3tsC8cpkHtgy2OqDU55PwpTymovX69ElP375i17O8FjNHIrZX0MF25LHSq/bXB
         ClK+VUmREdidBHRV7G8A0YqOPKLsJrXZQDgajFbPDzb+CybFjw+Vyf+co8JuJTK85NUF
         /bUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R8dasBlS/Y7b20YlP5Fv5XJkDkpsZKVL54qsW+OQ24E=;
        b=AhWFtiiO0yBwpVzxZarM4zkqQBgTl5Wx+ddi6+juPKaeTgU3Tk40v0U1gnzACBqBhf
         /AFGIwDQKHxJqjhqEsKtJVhktWGtG8WSmEvHusVYmRXaiGXoDXV3EfHbsCO8Qlh0vk96
         tTLQlt4j0MUErIM+1wuwNy0IWbnW4VRyK+53mQCMy8KGfMWVIZCq+rC6Y0paiDOjc4k8
         rMQebpzBiqPnrxq6xiGFONiprWusl/vas2CW9Fy3jv3/UyRpBvgdUxijb+fpO6u//RKH
         BdIzsPg6+cta8WyDQv6nnpnfFQcaR3cz9+7KwOtSXYONHSMO4p7ZwcQFMjMfqcFMA60U
         L+xA==
X-Gm-Message-State: AOAM533wfMLwZOHAEYV4NDor+KkRzqh1440O02lo4R/xjmIhBDY/6Qhl
        bQ2143HBl+8cknPIZOiFXX9jWVP3Nf03tqGODFg=
X-Google-Smtp-Source: ABdhPJz4JwjMZV/Sf0GCdNN5q/WIZPPtnegN1KJ4hxF3Qa4bcDXVsL/M0JX3MlyxDjGnVCpLNgG8ZK3BuJu1my0oAuk=
X-Received: by 2002:a05:6402:35c4:: with SMTP id z4mr240575edc.362.1620237148599;
 Wed, 05 May 2021 10:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-11-smalin@marvell.com>
 <02a740cd-e765-1197-9c5d-78ce602ba7a1@suse.de>
In-Reply-To: <02a740cd-e765-1197-9c5d-78ce602ba7a1@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Wed, 5 May 2021 20:52:16 +0300
Message-ID: <CAKKgK4yg0oBu37U2mW8AXngtcLKity4=-pARZ6Oyq0BgtGEchQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 10/27] nvme-tcp-offload: Add device scan implementation
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 3:25 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Dean Balandin <dbalandin@marvell.com>
> >
> > As part of create_ctrl(), it scans the registered devices and calls
> > the claim_dev op on each of them, to find the first devices that matche=
s
> > the connection params. Once the correct devices is found (claim_dev
> > returns true), we raise the refcnt of that device and return that devic=
e
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
> >   drivers/nvme/host/tcp-offload.c | 94 ++++++++++++++++++++++++++++++++=
+
> >   1 file changed, 94 insertions(+)
> >
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-of=
fload.c
> > index 711232eba339..aa7cc239abf2 100644
> > --- a/drivers/nvme/host/tcp-offload.c
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -13,6 +13,11 @@
> >   static LIST_HEAD(nvme_tcp_ofld_devices);
> >   static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
> >
> > +static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_=
ctrl *nctrl)
> > +{
> > +     return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
> > +}
> > +
> >   /**
> >    * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registratio=
n
> >    * function.
> > @@ -98,6 +103,94 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_re=
q *req,
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
> > +                             pr_err("try_module_get failed\n");
> > +                             dev =3D NULL;
> > +                     }
> > +
> > +                     goto out;
> > +             }
> > +     }
> > +
> > +     dev =3D NULL;
> > +out:
> > +     up_read(&nvme_tcp_ofld_devices_rwsem);
> > +
> > +     return dev;
> > +}
> > +
> > +static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
> > +{
> > +     /* Placeholder - validates inputs and creates admin and IO queues=
 */
> > +
> > +     return 0;
> > +}
> > +
> > +static struct nvme_ctrl *
> > +nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_option=
s *opts)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl;
> > +     struct nvme_tcp_ofld_dev *dev;
> > +     struct nvme_ctrl *nctrl;
> > +     int rc =3D 0;
> > +
> > +     ctrl =3D kzalloc(sizeof(*ctrl), GFP_KERNEL);
> > +     if (!ctrl)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     nctrl =3D &ctrl->nctrl;
> > +
> > +     /* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received=
 opts */
> > +
> > +     /* Find device that can reach the dest addr */
> > +     dev =3D nvme_tcp_ofld_lookup_dev(ctrl);
> > +     if (!dev) {
> > +             pr_info("no device found for addr %s:%s.\n",
> > +                     opts->traddr, opts->trsvcid);
> > +             rc =3D -EINVAL;
> > +             goto out_free_ctrl;
> > +     }
> > +
> > +     ctrl->dev =3D dev;
> > +
> > +     if (ctrl->dev->ops->max_hw_sectors)
> > +             nctrl->max_hw_sectors =3D ctrl->dev->ops->max_hw_sectors;
> > +     if (ctrl->dev->ops->max_segments)
> > +             nctrl->max_segments =3D ctrl->dev->ops->max_segments;
> > +
> > +     /* Init queues */
> > +
> > +     /* Call nvme_init_ctrl */
> > +
> > +     rc =3D ctrl->dev->ops->setup_ctrl(ctrl, true);
> > +     if (rc)
> > +             goto out_module_put;
> > +
> > +     rc =3D nvme_tcp_ofld_setup_ctrl(nctrl, true);
> > +     if (rc)
> > +             goto out_uninit_ctrl;
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
> >   static struct nvmf_transport_ops nvme_tcp_ofld_transport =3D {
> >       .name           =3D "tcp_offload",
> >       .module         =3D THIS_MODULE,
> > @@ -107,6 +200,7 @@ static struct nvmf_transport_ops nvme_tcp_ofld_tran=
sport =3D {
> >                         NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST =
|
> >                         NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES =
|
> >                         NVMF_OPT_TOS,
> > +     .create_ctrl    =3D nvme_tcp_ofld_create_ctrl,
> >   };
> >
> >   static int __init nvme_tcp_ofld_init_module(void)
> >
> I wonder if we shouldn't take the approach from Martin Belanger, and
> introduce a new option 'host_iface' to select the interface to use.
> That is, _if_ the nvme-tcp offload driver would present itself as a
> network interface; one might argue that it would put too much
> restriction on the implementations.

We should add the new option 'host_iface' also to nvme-tcp-offload and
each vendor-specific driver shall register with this to nvme_tcp_ofld_ops.

> But if it does not present itself as a network interface, how do we
> address it? And if it does, wouldn't we be better off to specify the
> interface directly, and not try to imply the interface from the IP addres=
s?

Specifically for the Marvell qedn driver, we are pairing between the net-de=
vice
(qede) and the offload-device (qedn) on each port.

The usage for the user is:
Assign IP to the net-device (from any existing linux tool):

    ip addr add 100.100.0.101/24 dev p1p1

This IP will be used by both net-device (qede) and offload-device (qedn).
In order to connect from "sw" nvme-tcp through the net-device (qede):

    nvme connect -t tcp -s 4420 -a 100.100.0.100 -n testnqn

In order to connect from "offload" nvme-tcp through the offload-device (qed=
n):

    nvme connect -t tcp_offload -s 4420 -a 100.100.0.100 -n testnqn

A suggestion (by Hannes Reinecke), as a future enhancement, and in
order to simplify the usage, we suggest modifying nvme-cli with a new flag
that will determine if "-t tcp" should be the regular nvme-tcp (which will
be the default) or nvme-tcp-offload.
For exmaple:

    nvme connect -t tcp -s 4420 -a 100.100.0.100 -n testnqn -[new flag]

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
