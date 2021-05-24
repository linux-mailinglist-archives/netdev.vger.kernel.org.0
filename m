Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A28838F41D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhEXUNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhEXUNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:13:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0C7C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:12:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id et19so36640904ejc.4
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xfy0dyHrbLEOjOGa7ElKxCILayc2GVXDeBssKOFU88g=;
        b=f74A/Citjvue+GagztQU9vpToefSFhnASvmU3zxKgaQxHY+PEZXJMPiNm4niaRnAPa
         0D6IdKmRusyVkgG25Bi440JfrE/uJ0n1Ewv9VwKwnuoRLhJX/BvFSNdpJafOMQgVXsNF
         ZF2iicSwOZKPTpGrJiMZ3Gb/0WGktedWoP8BP7hB+uhwK/KKVAyNY/FUBlaOg8a0vv86
         oC4DCihpW69prxr6iLHQJ6d1vAX8nPHP+ryZ50Nm39l9ce8WbHEOOX/Qf797eJU/JxiM
         6OeQAvmdRLEkhRfdLUIqnyR1+uLGB/ZbOJsqJIhlv+k3dlZTzTIGG7xIiB9qvP1RZFmo
         KRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xfy0dyHrbLEOjOGa7ElKxCILayc2GVXDeBssKOFU88g=;
        b=LV1viiyxwLz8GtqPSN+FRJbP+cXc+h/oSdgV5A2WMNSqJTK6N3RzchbG8VWUF3Vd09
         hj2eUhUjwR5bWIbyDhd7s8fqY1mGffPpREe2SNyDcaOppMhntR2veCULAlquL+bCM1J4
         +yVhynNtDGAeFPGjIABSjg6lqF09fuJfFxvmzpH9JHT4ihdzuNq6F+6VmvMMUnMYdfZg
         I34eiuXE9u8hGgJYvALryyHXBvgbkjskOpENkF0h4MzpOvzbvauqMGxLkHYGWje1sREg
         zY4ahX60jTUSAUqBT5nVoz5Q8zm2a1d1HwLaq86A1aOtMzeD0+opLu75eXHM4bvwMM0x
         9CGQ==
X-Gm-Message-State: AOAM532RBsFOFTvaapfHgag3WVQoqTyKM+uvX5IaHsoHhnMN0pUA5A9I
        jOlN9E0iPINHedByBXpFUezkLvLVETdnzY2hb/Q=
X-Google-Smtp-Source: ABdhPJwnr+A1qmcw5pwwfh6ZGJiZfVvbPWforcbHUrI7616sMMo5L5+HAh+v7PfeFCQAn870uyyQpPB7frHNijgina0=
X-Received: by 2002:a17:906:ccde:: with SMTP id ot30mr25739319ejb.353.1621887128203;
 Mon, 24 May 2021 13:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210519111340.20613-1-smalin@marvell.com> <20210519111340.20613-2-smalin@marvell.com>
 <2790fe4a-1dc0-a8a5-d8f9-ef6eb73b323a@oracle.com>
In-Reply-To: <2790fe4a-1dc0-a8a5-d8f9-ef6eb73b323a@oracle.com>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 24 May 2021 23:11:55 +0300
Message-ID: <CAKKgK4yK8xP3+Hue_1mqsqZz=4vy6ZzMjzkjae1k_EmfgsBykA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 01/27] nvme-tcp-offload: Add nvme-tcp-offload -
 NVMeTCP HW offload ULP
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>,
        Shai Malin <smalin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/21 8:06 PM, Himanshu Madhani wrote:
> On 5/19/21 6:13 AM, Shai Malin wrote:
> > This patch will present the structure for the NVMeTCP offload common
> > layer driver. This module is added under "drivers/nvme/host/" and future
> > offload drivers which will register to it will be placed under
> > "drivers/nvme/hw".
> > This new driver will be enabled by the Kconfig "NVM Express over Fabrics
> > TCP offload commmon layer".
> > In order to support the new transport type, for host mode, no change is
> > needed.
> >
> > Each new vendor-specific offload driver will register to this ULP during
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
> >   drivers/nvme/host/tcp-offload.h | 212 ++++++++++++++++++++++++++++++++
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
> > +     select NVME_FABRICS
> > +     help
> > +       This provides support for the NVMe over Fabrics protocol using
> > +       the TCP offload transport. This allows you to use remote block devices
> > +       exported using the NVMe protocol set.
> > +
> > +       To configure a NVMe over Fabrics controller use the nvme-cli tool
> > +       from https://github.com/linux-nvme/nvme-cli.
> > +
> > +       If unsure, say N.
> > diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
> > index cbc509784b2e..3c3fdf83ce38 100644
> > --- a/drivers/nvme/host/Makefile
> > +++ b/drivers/nvme/host/Makefile
> > @@ -8,6 +8,7 @@ obj-$(CONFIG_NVME_FABRICS)            += nvme-fabrics.o
> >   obj-$(CONFIG_NVME_RDMA)                     += nvme-rdma.o
> >   obj-$(CONFIG_NVME_FC)                       += nvme-fc.o
> >   obj-$(CONFIG_NVME_TCP)                      += nvme-tcp.o
> > +obj-$(CONFIG_NVME_TCP_OFFLOAD)       += nvme-tcp-offload.o
> >
> >   nvme-core-y                         := core.o ioctl.o
> >   nvme-core-$(CONFIG_TRACING)         += trace.o
> > @@ -26,3 +27,5 @@ nvme-rdma-y                         += rdma.o
> >   nvme-fc-y                           += fc.o
> >
> >   nvme-tcp-y                          += tcp.o
> > +
> > +nvme-tcp-offload-y           += tcp-offload.o
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
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
> > +
> > +/**
> > + * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
> > + * function.
> > + * @dev:     NVMeTCP offload device instance to be registered to the
> > + *           common tcp offload instance.
> > + *
> > + * API function that registers the type of vendor specific driver
> > + * being implemented to the common NVMe over TCP offload library. Part of
> > + * the overall init sequence of starting up an offload driver.
> > + */
> > +int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev)
> > +{
> > +     struct nvme_tcp_ofld_ops *ops = dev->ops;
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
> > + * nvme_tcp_ofld_unregister_dev() - NVMeTCP Offload Library unregistration
> > + * function.
> > + * @dev:     NVMeTCP offload device instance to be unregistered from the
> > + *           common tcp offload instance.
> > + *
> > + * API function that unregisters the type of vendor specific driver being
> > + * implemented from the common NVMe over TCP offload library.
> > + * Part of the overall exit sequence of unloading the implemented driver.
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
> > + * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error event
> > + * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
> > + * @queue:   NVMeTCP offload queue instance on which the error has occurred.
> > + *
> > + * API function that allows the vendor specific offload driver to reports errors
> > + * to the common offload layer, to invoke error recovery.
> > + */
> > +int nvme_tcp_ofld_report_queue_err(struct nvme_tcp_ofld_queue *queue)
> > +{
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
> > + * API function that allows the vendor specific offload driver to report request
> > + * completions to the common offload layer.
> > + */
> > +void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
> > +                         union nvme_result *result,
> > +                         __le16 status)
> > +{
> > +     /* Placeholder - complete request with/without error */
> > +}
> > +
> > +static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
> > +     .name           = "tcp_offload",
> > +     .module         = THIS_MODULE,
> > +     .required_opts  = NVMF_OPT_TRADDR,
> > +     .allowed_opts   = NVMF_OPT_TRSVCID | NVMF_OPT_NR_WRITE_QUEUES  |
> > +                       NVMF_OPT_HOST_TRADDR | NVMF_OPT_CTRL_LOSS_TMO |
> > +                       NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
> > +                       NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
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
> > diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
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
> > +/* Representation of a vendor-specific device. This is the struct used to
> > + * register to the offload layer by the vendor-specific driver during its probe
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
> > +
> > +     /* Vendor specific driver context */
> > +     void *private_data;
> > +
> > +     bool async;
> > +     bool last;
> > +
> > +     void (*done)(struct nvme_tcp_ofld_req *req,
> > +                  union nvme_result *result,
> > +                  __le16 status);
> > +};
> > +
> > +enum nvme_tcp_ofld_queue_flags {
> > +     NVME_TCP_OFLD_Q_ALLOCATED = 0,
> > +     NVME_TCP_OFLD_Q_LIVE = 1,
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
> > +     /* If NVMF_OPT_HOST_TRADDR is provided it will be set in local_ip_addr
> > +      * in nvme_tcp_ofld_create_ctrl().
> > +      * If NVMF_OPT_HOST_TRADDR is not provided the local_ip_addr will be
> > +      * initialized by claim_dev().
> > +      */
> > +     struct sockaddr_storage local_ip_addr;
> > +
> > +     /* Output params */
> > +     struct sockaddr remote_mac_addr;
> > +     struct sockaddr local_mac_addr;
> > +     u16 vlan_id;
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
> > +
> > +     /* For vendor-specific max num of segments and IO sizes */
> > +     u32 max_hw_sectors;
> > +     u32 max_segments;
> > +
> > +     /**
> > +      * claim_dev: Return True if addr is reachable via offload device.
> > +      * @dev: The offload device to check.
> > +      * @conn_params: ptr to routing params to be filled by the lower
> > +      *               driver. Input+Output argument.
> > +      */
> > +     int (*claim_dev)(struct nvme_tcp_ofld_dev *dev,
> > +                      struct nvme_tcp_ofld_ctrl_con_params *conn_params);
> > +
> > +     /**
> > +      * setup_ctrl: Setup device specific controller structures.
> > +      * @ctrl: The offload ctrl.
> > +      * @new: is new setup.
> > +      */
> > +     int (*setup_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl, bool new);
> > +
> > +     /**
> > +      * release_ctrl: Release/Free device specific controller structures.
> > +      * @ctrl: The offload ctrl.
> > +      */
> > +     int (*release_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl);
> > +
> > +     /**
> > +      * create_queue: Create offload queue and establish TCP + NVMeTCP
> > +      * (icreq+icresp) connection. Return true on successful connection.
> > +      * Based on nvme_tcp_alloc_queue.
> > +      * @queue: The queue itself - used as input and output.
> > +      * @qid: The queue ID associated with the requested queue.
> > +      * @q_size: The queue depth.
> > +      */
> > +     int (*create_queue)(struct nvme_tcp_ofld_queue *queue, int qid,
> > +                         size_t q_size);
> > +
> > +     /**
> > +      * drain_queue: Drain a given queue - Returning from this function
> > +      * ensures that no additional completions will arrive on this queue.
> > +      * @queue: The queue to drain.
> > +      */
> > +     void (*drain_queue)(struct nvme_tcp_ofld_queue *queue);
> > +
> > +     /**
> > +      * destroy_queue: Close the TCP + NVMeTCP connection of a given queue
> > +      * and make sure its no longer active (no completions will arrive on the
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
> > +
> > +     /**
> > +      * send_req: Dispatch a request. Returns the execution status.
> > +      * @req: Ptr to request to be sent.
> > +      */
> > +     int (*send_req)(struct nvme_tcp_ofld_req *req);
> > +
> > +     /**
> > +      * commit_rqs: Serves the purpose of kicking the hardware in case of
> > +      * errors, otherwise it would have been kicked by the last request.
> > +      * @queue: The queue to drain.
> > +      */
> > +     void (*commit_rqs)(struct nvme_tcp_ofld_queue *queue);
> > +};
> > +
> > +/* Exported functions for lower vendor specific offload drivers */
> > +int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
> > +void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
> >
>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Thanks.

>
> --
> Himanshu Madhani                                Oracle Linux Engineering
