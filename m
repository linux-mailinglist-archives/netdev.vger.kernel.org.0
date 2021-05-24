Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873B238F417
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhEXUKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhEXUKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:10:21 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED9DC061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:08:52 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id p24so42416611ejb.1
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SE/0+CkJi9aEOD135gTyzQ3ZU4H9nMfNkKir7dxLQIQ=;
        b=sS8Vcn/US54y1U/jGFwer76pbKoskmuFaNrfXAgz+UAOg5xVcxNU8vydJfpHFgLMDL
         RsgcYBEKIf1e4FZxiv8GbGfPAJM8DPZ0N7G4IjTkk71rzHxdfY3s++3cMgmIW4nsCUz7
         kS8gbHUmh4AI1XBQyKMxqRSbgUth4eF0C3sXv1SAmMPkaFtLckkhBYSnJLNc4epZTIC6
         lKF+1yaGuZkRuhx02dU9WACMBuCA9gbbO+n7J4Nhkmy/tkHfcB52oH04CD3zXewSlMjX
         7KKTIsINdHr/YSZl1qOO1hIwUhJSNe/KBeB7xU1mkxg3qRdTkkZGp5wGgnLX990CV6Vb
         mOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SE/0+CkJi9aEOD135gTyzQ3ZU4H9nMfNkKir7dxLQIQ=;
        b=CVsKRfzCdPu/pfwnwEBa4MFcAd6ofrSJpFFkuFtwmz7iqbEuF5Kn63g5e2Rk28Zh1x
         i9eUQclJZX+cE3KF0XsLVREC8ks/l8ft3yHUYe0PnX0GN8EZLFkyO1cEphGMRr3r1EcX
         de8ByEznLkKBxHnbfZ9mVt62FvvYZgmViXKaVv/uVZf6gi+JCFk11VVhz+AyxupS/wiz
         vNxLyltl8BstG9yuE4Zf/lkqYaD9dR91a9zEsWQHQU3OWLGKfzdFdeWGL6a4A6uilj8s
         d71WX7IsqwmRK0t/wNG4ygXV3FucNtU6z1/Jso2q8UGs1CIWnZrkXU19m/YBx1E5s7QY
         e+Fg==
X-Gm-Message-State: AOAM533DPtjxfOHoHs8LGEqhuUx4hVBOIvGrCjr/DAv/Pt4OxONVZKai
        iFwgBLaukzCeqODw8MeqwoX/fGvuZtK3IB3RhFk=
X-Google-Smtp-Source: ABdhPJxM4M6tYD2lfQ9oWDsq+8PvomKXFQ0+PWB+S0aGGCCGc5yhZiBuSdp6ZU+5Nk6cypsuAGJvVKGK6TYPE5D/Hs8=
X-Received: by 2002:a17:906:ff4b:: with SMTP id zo11mr23399164ejb.345.1621886930415;
 Mon, 24 May 2021 13:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210519111340.20613-1-smalin@marvell.com> <20210519111340.20613-2-smalin@marvell.com>
 <1df61e8a-c579-e945-ec13-9155b86bbbf4@grimberg.me>
In-Reply-To: <1df61e8a-c579-e945-ec13-9155b86bbbf4@grimberg.me>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 24 May 2021 23:08:36 +0300
Message-ID: <CAKKgK4yAFYn=_bJYP50GLueY_JufhkEi2CeZD76Yoj0fitd-8Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 01/27] nvme-tcp-offload: Add nvme-tcp-offload -
 NVMeTCP HW offload ULP
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>,
        Shai Malin <smalin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/21 1:13 AM, Sagi Grimberg wrote:
> On 5/19/21 4:13 AM, Shai Malin wrote:
> > This patch will present the structure for the NVMeTCP offload common
> > layer driver. This module is added under "drivers/nvme/host/" and futur=
e
> > offload drivers which will register to it will be placed under
> > "drivers/nvme/hw".
> > This new driver will be enabled by the Kconfig "NVM Express over Fabric=
s
> > TCP offload common layer".
> > In order to support the new transport type, for host mode, no change is
> > needed.
> >
> > Each new vendor-specific offload driver will register to this ULP durin=
g
> > its probe function, by filling out the nvme_tcp_ofld_dev->ops and
> > nvme_tcp_ofld_dev->private_data and calling nvme_tcp_ofld_register_dev
> > with the initialized struct.
> >
> > The internal implementation:
> > - tcp-offload.h:
> >    Includes all common structs and ops to be used and shared by offload
> >    drivers.
> >
> > - tcp-offload.c:
> >    Includes the init function which registers as a NVMf transport just
> >    like any other transport.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > ---
> >   MAINTAINERS                     |   8 ++
> >   drivers/nvme/host/Kconfig       |  16 +++
> >   drivers/nvme/host/Makefile      |   3 +
> >   drivers/nvme/host/tcp-offload.c | 126 +++++++++++++++++++
> >   drivers/nvme/host/tcp-offload.h | 212 +++++++++++++++++++++++++++++++=
+
> >   5 files changed, 365 insertions(+)
> >   create mode 100644 drivers/nvme/host/tcp-offload.c
> >   create mode 100644 drivers/nvme/host/tcp-offload.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index bd7aff0c120f..49a4a73ea1c7 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -13092,6 +13092,14 @@ F:   drivers/nvme/host/
> >   F:  include/linux/nvme.h
> >   F:  include/uapi/linux/nvme_ioctl.h
> >
> > +NVM EXPRESS TCP OFFLOAD TRANSPORT DRIVERS
> > +M:   Shai Malin <smalin@marvell.com>
> > +M:   Ariel Elior <aelior@marvell.com>
> > +L:   linux-nvme@lists.infradead.org
> > +S:   Supported
> > +F:   drivers/nvme/host/tcp-offload.c
> > +F:   drivers/nvme/host/tcp-offload.h
> > +
> >   NVM EXPRESS FC TRANSPORT DRIVERS
> >   M:  James Smart <james.smart@broadcom.com>
> >   L:  linux-nvme@lists.infradead.org
> > diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
> > index a44d49d63968..6e869e94e67f 100644
> > --- a/drivers/nvme/host/Kconfig
> > +++ b/drivers/nvme/host/Kconfig
> > @@ -84,3 +84,19 @@ config NVME_TCP
> >         from https://github.com/linux-nvme/nvme-cli.
> >
> >         If unsure, say N.
> > +
> > +config NVME_TCP_OFFLOAD
> > +     tristate "NVM Express over Fabrics TCP offload common layer"
> > +     default m
> > +     depends on INET
> > +     depends on BLK_DEV_NVME
>
> This needs to be: select NVME_CORE
>
> In fact, I've sent a patch that fixes that for nvme-tcp..

Thanks, will be fixed.

>
> > +     select NVME_FABRICS
> > +     help
> > +       This provides support for the NVMe over Fabrics protocol using
> > +       the TCP offload transport. This allows you to use remote block =
devices
> > +       exported using the NVMe protocol set.
> > +
> > +       To configure a NVMe over Fabrics controller use the nvme-cli to=
ol
> > +       from https://github.com/linux-nvme/nvme-cli.
> > +
> > +       If unsure, say N.
> > diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
> > index cbc509784b2e..3c3fdf83ce38 100644
> > --- a/drivers/nvme/host/Makefile
> > +++ b/drivers/nvme/host/Makefile
> > @@ -8,6 +8,7 @@ obj-$(CONFIG_NVME_FABRICS)            +=3D nvme-fabrics=
.o
> >   obj-$(CONFIG_NVME_RDMA)                     +=3D nvme-rdma.o
> >   obj-$(CONFIG_NVME_FC)                       +=3D nvme-fc.o
> >   obj-$(CONFIG_NVME_TCP)                      +=3D nvme-tcp.o
> > +obj-$(CONFIG_NVME_TCP_OFFLOAD)       +=3D nvme-tcp-offload.o
> >
> >   nvme-core-y                         :=3D core.o ioctl.o
> >   nvme-core-$(CONFIG_TRACING)         +=3D trace.o
> > @@ -26,3 +27,5 @@ nvme-rdma-y                         +=3D rdma.o
> >   nvme-fc-y                           +=3D fc.o
> >
> >   nvme-tcp-y                          +=3D tcp.o
> > +
> > +nvme-tcp-offload-y           +=3D tcp-offload.o
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-of=
fload.c
> > new file mode 100644
> > index 000000000000..711232eba339
> > --- /dev/null
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -0,0 +1,126 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright 2021 Marvell. All rights reserved.
> > + */
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +/* Kernel includes */
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +
> > +/* Driver includes */
> > +#include "tcp-offload.h"
> > +
> > +static LIST_HEAD(nvme_tcp_ofld_devices);
> > +static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
>
> Why is that a rwsem?

It was based on nvmf_transports_rwsem.
We will change it to a regular lock.

>
> > +
> > +/**
> > + * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
> > + * function.
> > + * @dev:     NVMeTCP offload device instance to be registered to the
> > + *           common tcp offload instance.
> > + *
> > + * API function that registers the type of vendor specific driver
> > + * being implemented to the common NVMe over TCP offload library. Part=
 of
> > + * the overall init sequence of starting up an offload driver.
> > + */
> > +int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev)
> > +{
> > +     struct nvme_tcp_ofld_ops *ops =3D dev->ops;
> > +
> > +     if (!ops->claim_dev ||
> > +         !ops->setup_ctrl ||
> > +         !ops->release_ctrl ||
> > +         !ops->create_queue ||
> > +         !ops->drain_queue ||
> > +         !ops->destroy_queue ||
> > +         !ops->poll_queue ||
> > +         !ops->init_req ||
> > +         !ops->send_req ||
> > +         !ops->commit_rqs)
> > +             return -EINVAL;
> > +
> > +     down_write(&nvme_tcp_ofld_devices_rwsem);
> > +     list_add_tail(&dev->entry, &nvme_tcp_ofld_devices);
> > +     up_write(&nvme_tcp_ofld_devices_rwsem);
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_register_dev);
> > +
> > +/**
> > + * nvme_tcp_ofld_unregister_dev() - NVMeTCP Offload Library unregistra=
tion
> > + * function.
> > + * @dev:     NVMeTCP offload device instance to be unregistered from t=
he
> > + *           common tcp offload instance.
> > + *
> > + * API function that unregisters the type of vendor specific driver be=
ing
> > + * implemented from the common NVMe over TCP offload library.
> > + * Part of the overall exit sequence of unloading the implemented driv=
er.
> > + */
> > +void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev)
> > +{
> > +     down_write(&nvme_tcp_ofld_devices_rwsem);
> > +     list_del(&dev->entry);
> > +     up_write(&nvme_tcp_ofld_devices_rwsem);
> > +}
> > +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
> > +
> > +/**
> > + * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error eve=
nt
> > + * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
> > + * @queue:   NVMeTCP offload queue instance on which the error has occ=
urred.
> > + *
> > + * API function that allows the vendor specific offload driver to repo=
rts errors
> > + * to the common offload layer, to invoke error recovery.
> > + */
> > +int nvme_tcp_ofld_report_queue_err(struct nvme_tcp_ofld_queue *queue)
> > +{
>
> No semantics into what was the error?

We were following the multiple calls of nvme_tcp_error_recovery() in tcp.c =
and
nvme_rdma_error_recovery() in rdma.c where the controller reset flow is cal=
led
for any error type. We were planning to do something similar and the error
type doesn=E2=80=99t seem to be part of it.

>
> > +     /* Placeholder - invoke error recovery flow */
> > +
> > +     return 0;
> > +}
> > +
> > +/**
> > + * nvme_tcp_ofld_req_done() - NVMeTCP Offload request done callback
> > + * function. Pointed to by nvme_tcp_ofld_req->done.
> > + * Handles both NVME_TCP_F_DATA_SUCCESS flag and NVMe CQ.
> > + * @req:     NVMeTCP offload request to complete.
> > + * @result:     The nvme_result.
> > + * @status:     The completion status.
> > + *
> > + * API function that allows the vendor specific offload driver to repo=
rt request
> > + * completions to the common offload layer.
> > + */
> > +void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
> > +                         union nvme_result *result,
> > +                         __le16 status)
> > +{
>
> Why do you need to pass back the result? Isn't that a part
> of the request?

The result is part of the request only after calling nvme_try_complete_req(=
).
Both nvme_try_complete_req() and nvme_complete_rq() should be called
from the ULP layer.

>
> > +     /* Placeholder - complete request with/without error */
> > +}
> > +
> > +static struct nvmf_transport_ops nvme_tcp_ofld_transport =3D {
> > +     .name           =3D "tcp_offload",
> > +     .module         =3D THIS_MODULE,
> > +     .required_opts  =3D NVMF_OPT_TRADDR,
> > +     .allowed_opts   =3D NVMF_OPT_TRSVCID | NVMF_OPT_NR_WRITE_QUEUES  =
|
> > +                       NVMF_OPT_HOST_TRADDR | NVMF_OPT_CTRL_LOSS_TMO |
> > +                       NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST =
|
> > +                       NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES =
|
> > +                       NVMF_OPT_TOS,
> > +};
> > +
> > +static int __init nvme_tcp_ofld_init_module(void)
> > +{
> > +     nvmf_register_transport(&nvme_tcp_ofld_transport);
> > +
> > +     return 0;
> > +}
> > +
> > +static void __exit nvme_tcp_ofld_cleanup_module(void)
> > +{
> > +     nvmf_unregister_transport(&nvme_tcp_ofld_transport);
> > +}
> > +
> > +module_init(nvme_tcp_ofld_init_module);
> > +module_exit(nvme_tcp_ofld_cleanup_module);
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-of=
fload.h
> > new file mode 100644
> > index 000000000000..949132ce2ed4
> > --- /dev/null
> > +++ b/drivers/nvme/host/tcp-offload.h
> > @@ -0,0 +1,212 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright 2021 Marvell. All rights reserved.
> > + */
> > +
> > +/* Linux includes */
> > +#include <linux/dma-mapping.h>
> > +#include <linux/scatterlist.h>
> > +#include <linux/types.h>
> > +#include <linux/nvme-tcp.h>
> > +
> > +/* Driver includes */
> > +#include "nvme.h"
> > +#include "fabrics.h"
> > +
> > +/* Forward declarations */
> > +struct nvme_tcp_ofld_ops;
> > +
> > +/* Representation of a vendor-specific device. This is the struct used=
 to
> > + * register to the offload layer by the vendor-specific driver during =
its probe
> > + * function.
> > + * Allocated by vendor-specific driver.
> > + */
> > +struct nvme_tcp_ofld_dev {
> > +     struct list_head entry;
> > +     struct net_device *ndev;
> > +     struct nvme_tcp_ofld_ops *ops;
> > +
> > +     /* Vendor specific driver context */
> > +     void *private_data;
>
> Usually there is private_data pointer when the upper layer
> passes a struct to the lower layer to initialize, that is
> not the case here, why don't the device driver just use
> container_of to access its internal representation?

Thanks, will be fixed.

>
> > +     int num_hw_vectors;
> > +};
> > +
> > +/* Per IO struct holding the nvme_request and command
> > + * Allocated by blk-mq.
> > + */
> > +struct nvme_tcp_ofld_req {
> > +     struct nvme_request req;
> > +     struct nvme_command nvme_cmd;
> > +     struct list_head queue_entry;
> > +     struct nvme_tcp_ofld_queue *queue;
> > +     struct request *rq;
>
> Why is there an explicit rq pointer? there are converters from
> rq to driver req struct and vice-versa.

Will be fixed.

>
> > +
> > +     /* Vendor specific driver context */
> > +     void *private_data;
> > +
> > +     bool async;
> > +     bool last;
>
> Undocumented and unclear why these are needed.

Regarding the async, we need it for the vendor driver to use the common
send_req() for both the regular IO flow and the async flow. We will add
a comment to explain it.

We will remove the last.

>
> > +
> > +     void (*done)(struct nvme_tcp_ofld_req *req,
> > +                  union nvme_result *result,
> > +                  __le16 status);
> > +};
> > +
> > +enum nvme_tcp_ofld_queue_flags {
> > +     NVME_TCP_OFLD_Q_ALLOCATED =3D 0,
> > +     NVME_TCP_OFLD_Q_LIVE =3D 1,
> > +};
> > +
> > +/* Allocated by nvme_tcp_ofld */
> > +struct nvme_tcp_ofld_queue {
> > +     /* Offload device associated to this queue */
> > +     struct nvme_tcp_ofld_dev *dev;
> > +     struct nvme_tcp_ofld_ctrl *ctrl;
> > +     unsigned long flags;
> > +     size_t cmnd_capsule_len;
> > +
> > +     u8 hdr_digest;
> > +     u8 data_digest;
> > +     u8 tos;
> > +
> > +     /* Vendor specific driver context */
> > +     void *private_data;
> > +
> > +     /* Error callback function */
> > +     int (*report_err)(struct nvme_tcp_ofld_queue *queue);
> > +};
> > +
> > +/* Connectivity (routing) params used for establishing a connection */
> > +struct nvme_tcp_ofld_ctrl_con_params {
> > +     /* Input params */
> > +     struct sockaddr_storage remote_ip_addr;
> > +
> > +     /* If NVMF_OPT_HOST_TRADDR is provided it will be set in local_ip=
_addr
> > +      * in nvme_tcp_ofld_create_ctrl().
> > +      * If NVMF_OPT_HOST_TRADDR is not provided the local_ip_addr will=
 be
> > +      * initialized by claim_dev().
> > +      */
> > +     struct sockaddr_storage local_ip_addr;
> > +
> > +     /* Output params */
> > +     struct sockaddr remote_mac_addr;
> > +     struct sockaddr local_mac_addr;
> > +     u16 vlan_id;
>
> Why should a ULP care about this? It's a red-flag to
> me that a tcp ulp needs these params.

Right. TCP ULP doesn=E2=80=99t need these "Output params".
We will remove it.

>
> > +};
> > +
> > +/* Allocated by nvme_tcp_ofld */
> > +struct nvme_tcp_ofld_ctrl {
> > +     struct nvme_ctrl nctrl;
> > +     struct list_head list;
> > +     struct nvme_tcp_ofld_dev *dev;
> > +
> > +     /* admin and IO queues */
> > +     struct blk_mq_tag_set tag_set;
> > +     struct blk_mq_tag_set admin_tag_set;
> > +     struct nvme_tcp_ofld_queue *queues;
> > +
> > +     struct work_struct err_work;
> > +     struct delayed_work connect_work;
> > +
> > +     /*
> > +      * Each entry in the array indicates the number of queues of
> > +      * corresponding type.
> > +      */
> > +     u32 io_queues[HCTX_MAX_TYPES];
>
> What if the offload device doesn't support poll queue map?

The nvme-tcp-offload should support any queue type.
Each vendor driver shall register with the vendor specific allowed ops,
and it=E2=80=99s allowed to not support poll queue. In that case, the io_qu=
eues[]
will include only the supported queues.

>
> > +
> > +     /* Connectivity params */
> > +     struct nvme_tcp_ofld_ctrl_con_params conn_params;
> > +
> > +     /* Vendor specific driver context */
> > +     void *private_data;
> > +};
> > +
> > +struct nvme_tcp_ofld_ops {
> > +     const char *name;
> > +     struct module *module;
> > +
> > +     /* For vendor-specific driver to report what opts it supports */
> > +     int required_opts; /* bitmap using enum nvmf_parsing_opts */
> > +     int allowed_opts; /* bitmap using enum nvmf_parsing_opts */
>
> What is the difference between this one and the ulp one?

This one is for the specific vendor driver (and it could be different betwe=
en
different vendor drivers), and the nvme-tcp-offload ops should support
any opts.
It will be used in patch 4 =E2=80=93 =E2=80=9Cnvme-tcp-offload: Add control=
ler level
implementation=E2=80=9D in tcp-offload.c in nvme_tcp_ofld_check_dev_opts().
We will improve the documentation.

>
> > +
> > +     /* For vendor-specific max num of segments and IO sizes */
> > +     u32 max_hw_sectors;
> > +     u32 max_segments;
>
> Understand max_segments maybe needed, but why max_hw_sectors? Is
> that something an offload device really cares about?

Yes. Offload devices also might have a max_hw_sectors limitation.

>
> > +
> > +     /**
> > +      * claim_dev: Return True if addr is reachable via offload device=
.
> > +      * @dev: The offload device to check.
> > +      * @conn_params: ptr to routing params to be filled by the lower
> > +      *               driver. Input+Output argument.
> > +      */
> > +     int (*claim_dev)(struct nvme_tcp_ofld_dev *dev,
> > +                      struct nvme_tcp_ofld_ctrl_con_params *conn_param=
s);
> > +
> > +     /**
> > +      * setup_ctrl: Setup device specific controller structures.
> > +      * @ctrl: The offload ctrl.
> > +      * @new: is new setup.
> > +      */
> > +     int (*setup_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl, bool new);
>
> I think that the 'new' is really an odd interface, it's ok if its
> internal to a driver, but not for an interface...

We will remove the =E2=80=9Cnew=E2=80=9D and instead we will check the ctrl=
->private_data.

>
> > +
> > +     /**
> > +      * release_ctrl: Release/Free device specific controller structur=
es.
> > +      * @ctrl: The offload ctrl.
> > +      */
> > +     int (*release_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl);
> > +
> > +     /**
> > +      * create_queue: Create offload queue and establish TCP + NVMeTCP
> > +      * (icreq+icresp) connection. Return true on successful connectio=
n.
> > +      * Based on nvme_tcp_alloc_queue.
> > +      * @queue: The queue itself - used as input and output.
> > +      * @qid: The queue ID associated with the requested queue.
> > +      * @q_size: The queue depth.
> > +      */
> > +     int (*create_queue)(struct nvme_tcp_ofld_queue *queue, int qid,
> > +                         size_t q_size);
>
> queue_size

Will be fixed.

>
> > +
> > +     /**
> > +      * drain_queue: Drain a given queue - Returning from this functio=
n
> > +      * ensures that no additional completions will arrive on this que=
ue.
> > +      * @queue: The queue to drain.
> > +      */
> > +     void (*drain_queue)(struct nvme_tcp_ofld_queue *queue);
>
> I'm assuming this is a blocking call? should probably document it.

It could be a blocking call, we will document it.

>
> > +
> > +     /**
> > +      * destroy_queue: Close the TCP + NVMeTCP connection of a given q=
ueue
> > +      * and make sure its no longer active (no completions will arrive=
 on the
> > +      * queue).
> > +      * @queue: The queue to destroy.
> > +      */
> > +     void (*destroy_queue)(struct nvme_tcp_ofld_queue *queue);
> > +
> > +     /**
> > +      * poll_queue: Poll a given queue for completions.
> > +      * @queue: The queue to poll.
> > +      */
> > +     int (*poll_queue)(struct nvme_tcp_ofld_queue *queue);
> > +
> > +     /**
> > +      * init_req: Initialize vendor-specific params for a new request.
> > +      * @req: Ptr to request to be initialized. Input+Output argument.
> > +      */
> > +     int (*init_req)(struct nvme_tcp_ofld_req *req);
>
> What is this used for?

It was added for vendor drivers which will need to initialize resources
for the request.
It=E2=80=99s not in use with the qedn driver =E2=80=93 we will remove it.

>
> > +
> > +     /**
> > +      * send_req: Dispatch a request. Returns the execution status.
> > +      * @req: Ptr to request to be sent.
> > +      */
> > +     int (*send_req)(struct nvme_tcp_ofld_req *req);
> > +
> > +     /**
> > +      * commit_rqs: Serves the purpose of kicking the hardware in case=
 of
> > +      * errors, otherwise it would have been kicked by the last reques=
t.
> > +      * @queue: The queue to drain.
> > +      */
> > +     void (*commit_rqs)(struct nvme_tcp_ofld_queue *queue);
>
> Is this something you actually use? And the documentation talks about
> errors which doesn't match the name, not sure what is the purpose of
> this at all.

This is for vendor driver which might need it.
It=E2=80=99s not in use with the qedn driver =E2=80=93 we will remove it.
