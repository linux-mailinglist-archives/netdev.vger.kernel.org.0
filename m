Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BBD37714E
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 13:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhEHLCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 07:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhEHLCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 07:02:20 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD25C061574
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 04:01:19 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g14so13217869edy.6
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 04:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VAUSWbe9maPv3azSF5cK9vewt6XdzzIzjYRsNZyI8g4=;
        b=kmnQb3WKCARapuB49OEfA1cc57eN8zet05EyGIn4OgtlGqV7+uzsPzqhUjiOph8UsU
         /3lnj/Q4PrmQDv5312GZPGSZyIif5RGUxoEVNd+q/4gOupBFfyEuHTvuOZ7nEMq5zWEY
         4ifY7SpwuiE4BSMbnZajF0fZAKyUu2acv86+FA8Sey6O5+R4DsL0jOLn9AgTZcdAkr6i
         2TpAMqKvqpGXmgNKRnQaHYf+KWVlnOKFVjgjxSGTfHVZSnHs4N9VGwSeH6w0baJuPvQZ
         DkXAeIJxEJp43YuvEORdMBHgRsp7e+UO9zoQblLLkxXx1XDs/X8FJTWVR6MXhXRZyoc6
         C34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VAUSWbe9maPv3azSF5cK9vewt6XdzzIzjYRsNZyI8g4=;
        b=bMyB3iE1tUWgDUgj9kPbjKJ/lRratW4CYEDcSonKkNwW5lWZvXtRjDFyu0oDl8yygu
         RGqYHsyY3+qUy6X0ORZD9imaW6Wywxbd0VdEmQUdP+sBDpa5Pnwo3SACWnP9jV3EVyaI
         rwc3PQQTVoGl97mP8G8IXyk+pqynyCRiYO1t9aT5JX7j5WtT7X4vyyxwfRxyTbR3YSTB
         aEEA13ww8C7c4CYLvGbjLmLaHiIGW073PBKKFYqRTodUer6PcDRpGvZamUBk6cZZUy3L
         7M2wWH27OeOUgme5VBAwW+8fe4ywK3HeZTCZNEM/axc7TKCkq9SyDy1xWmMjHVsCPrqy
         VAZw==
X-Gm-Message-State: AOAM531Y/9IM+yVudM091o43xeK7SrdybsUIz8x9H6g7A7EpOa/zp+KL
        vx2Lrxf1eYLp7c7X7iekZsC9IKdfLc0kbGeBRj8=
X-Google-Smtp-Source: ABdhPJy0Dlo/FWJZnjdhZ+6bWhNS1rFvP6Nan8puN4ikCMCmfNlCAqPWx5Avmw++EIcelRfYkuD0hSVOPENzozj+Ihc=
X-Received: by 2002:aa7:c30c:: with SMTP id l12mr17218569edq.217.1620471677945;
 Sat, 08 May 2021 04:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-18-smalin@marvell.com>
 <301d2567-2880-e8b2-7d68-0437d7c4f1bb@suse.de>
In-Reply-To: <301d2567-2880-e8b2-7d68-0437d7c4f1bb@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Sat, 8 May 2021 14:01:06 +0300
Message-ID: <CAKKgK4yW4o1LoBQjGcQ3k1_oXfH9X54gNNGHrRfQ3uEBGm+5QQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 17/27] qedn: Add qedn probe
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 2:28 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch introduces the functionality of loading and unloading
> > physical function.
> > qedn_probe() loads the offload device PF(physical function), and
> > initialize the HW and the FW with the PF parameters using the
> > HW ops->qed_nvmetcp_ops, which are similar to other "qed_*_ops" which
> > are used by the qede, qedr, qedf and qedi device drivers.
> > qedn_remove() unloads the offload device PF, re-initialize the HW and
> > the FW with the PF parameters.
> >
> > The struct qedn_ctx is per PF container for PF-specific attributes and
> > resources.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/Kconfig          |   1 +
> >   drivers/nvme/hw/qedn/qedn.h      |  49 ++++++++
> >   drivers/nvme/hw/qedn/qedn_main.c | 191 ++++++++++++++++++++++++++++++=
-
> >   3 files changed, 236 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/nvme/hw/Kconfig b/drivers/nvme/hw/Kconfig
> > index 374f1f9dbd3d..91b1bd6f07d8 100644
> > --- a/drivers/nvme/hw/Kconfig
> > +++ b/drivers/nvme/hw/Kconfig
> > @@ -2,6 +2,7 @@
> >   config NVME_QEDN
> >       tristate "Marvell NVM Express over Fabrics TCP offload"
> >       depends on NVME_TCP_OFFLOAD
> > +     select QED_NVMETCP
> >       help
> >         This enables the Marvell NVMe TCP offload support (qedn).
> >
> > diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> > index bcd0748a10fd..c1ac17eabcb7 100644
> > --- a/drivers/nvme/hw/qedn/qedn.h
> > +++ b/drivers/nvme/hw/qedn/qedn.h
> > @@ -6,14 +6,63 @@
> >   #ifndef _QEDN_H_
> >   #define _QEDN_H_
> >
> > +#include <linux/qed/qed_if.h>
> > +#include <linux/qed/qed_nvmetcp_if.h>
> > +
> >   /* Driver includes */
> >   #include "../../host/tcp-offload.h"
> >
> > +#define QEDN_MAJOR_VERSION           8
> > +#define QEDN_MINOR_VERSION           62
> > +#define QEDN_REVISION_VERSION                10
> > +#define QEDN_ENGINEERING_VERSION     0
> > +#define DRV_MODULE_VERSION __stringify(QEDE_MAJOR_VERSION) "."       \
> > +             __stringify(QEDE_MINOR_VERSION) "."             \
> > +             __stringify(QEDE_REVISION_VERSION) "."          \
> > +             __stringify(QEDE_ENGINEERING_VERSION)
> > +
> >   #define QEDN_MODULE_NAME "qedn"
> >
> > +#define QEDN_MAX_TASKS_PER_PF (16 * 1024)
> > +#define QEDN_MAX_CONNS_PER_PF (4 * 1024)
> > +#define QEDN_FW_CQ_SIZE (4 * 1024)
> > +#define QEDN_PROTO_CQ_PROD_IDX       0
> > +#define QEDN_NVMETCP_NUM_FW_CONN_QUEUE_PAGES 2
> > +
> > +enum qedn_state {
> > +     QEDN_STATE_CORE_PROBED =3D 0,
> > +     QEDN_STATE_CORE_OPEN,
> > +     QEDN_STATE_GL_PF_LIST_ADDED,
> > +     QEDN_STATE_MFW_STATE,
> > +     QEDN_STATE_REGISTERED_OFFLOAD_DEV,
> > +     QEDN_STATE_MODULE_REMOVE_ONGOING,
> > +};
> > +
> >   struct qedn_ctx {
> >       struct pci_dev *pdev;
> > +     struct qed_dev *cdev;
> > +     struct qed_dev_nvmetcp_info dev_info;
> >       struct nvme_tcp_ofld_dev qedn_ofld_dev;
> > +     struct qed_pf_params pf_params;
> > +
> > +     /* Global PF list entry */
> > +     struct list_head gl_pf_entry;
> > +
> > +     /* Accessed with atomic bit ops, used with enum qedn_state */
> > +     unsigned long state;
> > +
> > +     /* Fast path queues */
> > +     u8 num_fw_cqs;
> > +};
> > +
> > +struct qedn_global {
> > +     struct list_head qedn_pf_list;
> > +
> > +     /* Host mode */
> > +     struct list_head ctrl_list;
> > +
> > +     /* Mutex for accessing the global struct */
> > +     struct mutex glb_mutex;
> >   };
> >
> >   #endif /* _QEDN_H_ */
> > diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qe=
dn_main.c
> > index 31d6d86d6eb7..e3e8e3676b79 100644
> > --- a/drivers/nvme/hw/qedn/qedn_main.c
> > +++ b/drivers/nvme/hw/qedn/qedn_main.c
> > @@ -14,6 +14,10 @@
> >
> >   #define CHIP_NUM_AHP_NVMETCP 0x8194
> >
> > +const struct qed_nvmetcp_ops *qed_ops;
> > +
> > +/* Global context instance */
> > +struct qedn_global qedn_glb;
> >   static struct pci_device_id qedn_pci_tbl[] =3D {
> >       { PCI_VDEVICE(QLOGIC, CHIP_NUM_AHP_NVMETCP), 0 },
> >       {0, 0},
> > @@ -99,12 +103,132 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops =3D=
 {
> >       .commit_rqs =3D qedn_commit_rqs,
> >   };
> >
> > +static inline void qedn_init_pf_struct(struct qedn_ctx *qedn)
> > +{
> > +     /* Placeholder - Initialize qedn fields */
> > +}
> > +
> > +static inline void
> > +qedn_init_core_probe_params(struct qed_probe_params *probe_params)
> > +{
> > +     memset(probe_params, 0, sizeof(*probe_params));
> > +     probe_params->protocol =3D QED_PROTOCOL_NVMETCP;
> > +     probe_params->is_vf =3D false;
> > +     probe_params->recov_in_prog =3D 0;
> > +}
> > +
> > +static inline int qedn_core_probe(struct qedn_ctx *qedn)
> > +{
> > +     struct qed_probe_params probe_params;
> > +     int rc =3D 0;
> > +
> > +     qedn_init_core_probe_params(&probe_params);
> > +     pr_info("Starting QED probe\n");
> > +     qedn->cdev =3D qed_ops->common->probe(qedn->pdev, &probe_params);
> > +     if (!qedn->cdev) {
> > +             rc =3D -ENODEV;
> > +             pr_err("QED probe failed\n");
> > +     }
> > +
> > +     return rc;
> > +}
> > +
> > +static void qedn_add_pf_to_gl_list(struct qedn_ctx *qedn)
> > +{
> > +     mutex_lock(&qedn_glb.glb_mutex);
> > +     list_add_tail(&qedn->gl_pf_entry, &qedn_glb.qedn_pf_list);
> > +     mutex_unlock(&qedn_glb.glb_mutex);
> > +}
> > +
> > +static void qedn_remove_pf_from_gl_list(struct qedn_ctx *qedn)
> > +{
> > +     mutex_lock(&qedn_glb.glb_mutex);
> > +     list_del_init(&qedn->gl_pf_entry);
> > +     mutex_unlock(&qedn_glb.glb_mutex);
> > +}
> > +
> > +static int qedn_set_nvmetcp_pf_param(struct qedn_ctx *qedn)
> > +{
> > +     u32 fw_conn_queue_pages =3D QEDN_NVMETCP_NUM_FW_CONN_QUEUE_PAGES;
> > +     struct qed_nvmetcp_pf_params *pf_params;
> > +
> > +     pf_params =3D &qedn->pf_params.nvmetcp_pf_params;
> > +     memset(pf_params, 0, sizeof(*pf_params));
> > +     qedn->num_fw_cqs =3D min_t(u8, qedn->dev_info.num_cqs, num_online=
_cpus());
> > +
> > +     pf_params->num_cons =3D QEDN_MAX_CONNS_PER_PF;
> > +     pf_params->num_tasks =3D QEDN_MAX_TASKS_PER_PF;
> > +
> > +     /* Placeholder - Initialize function level queues */
> > +
> > +     /* Placeholder - Initialize TCP params */
> > +
> > +     /* Queues */
> > +     pf_params->num_sq_pages_in_ring =3D fw_conn_queue_pages;
> > +     pf_params->num_r2tq_pages_in_ring =3D fw_conn_queue_pages;
> > +     pf_params->num_uhq_pages_in_ring =3D fw_conn_queue_pages;
> > +     pf_params->num_queues =3D qedn->num_fw_cqs;
> > +     pf_params->cq_num_entries =3D QEDN_FW_CQ_SIZE;
> > +
> > +     /* the CQ SB pi */
> > +     pf_params->gl_rq_pi =3D QEDN_PROTO_CQ_PROD_IDX;
> > +
> > +     return 0;
> > +}
> > +
> > +static inline int qedn_slowpath_start(struct qedn_ctx *qedn)
> > +{
> > +     struct qed_slowpath_params sp_params =3D {};
> > +     int rc =3D 0;
> > +
> > +     /* Start the Slowpath-process */
> > +     sp_params.int_mode =3D QED_INT_MODE_MSIX;
> > +     sp_params.drv_major =3D QEDN_MAJOR_VERSION;
> > +     sp_params.drv_minor =3D QEDN_MINOR_VERSION;
> > +     sp_params.drv_rev =3D QEDN_REVISION_VERSION;
> > +     sp_params.drv_eng =3D QEDN_ENGINEERING_VERSION;
> > +     strscpy(sp_params.name, "qedn NVMeTCP", QED_DRV_VER_STR_SIZE);
> > +     rc =3D qed_ops->common->slowpath_start(qedn->cdev, &sp_params);
> > +     if (rc)
> > +             pr_err("Cannot start slowpath\n");
> > +
> > +     return rc;
> > +}
> > +
> >   static void __qedn_remove(struct pci_dev *pdev)
> >   {
> >       struct qedn_ctx *qedn =3D pci_get_drvdata(pdev);
> > +     int rc;
> > +
> > +     pr_notice("qedn remove started: abs PF id=3D%u\n",
> > +               qedn->dev_info.common.abs_pf_id);
> > +
> > +     if (test_and_set_bit(QEDN_STATE_MODULE_REMOVE_ONGOING, &qedn->sta=
te)) {
> > +             pr_err("Remove already ongoing\n");
> > +
> > +             return;
> > +     }
> > +
> > +     if (test_and_clear_bit(QEDN_STATE_REGISTERED_OFFLOAD_DEV, &qedn->=
state))
> > +             nvme_tcp_ofld_unregister_dev(&qedn->qedn_ofld_dev);
> > +
> > +     if (test_and_clear_bit(QEDN_STATE_GL_PF_LIST_ADDED, &qedn->state)=
)
> > +             qedn_remove_pf_from_gl_list(qedn);
> > +     else
> > +             pr_err("Failed to remove from global PF list\n");
> > +
> > +     if (test_and_clear_bit(QEDN_STATE_MFW_STATE, &qedn->state)) {
> > +             rc =3D qed_ops->common->update_drv_state(qedn->cdev, fals=
e);
> > +             if (rc)
> > +                     pr_err("Failed to send drv state to MFW\n");
> > +     }
> > +
> > +     if (test_and_clear_bit(QEDN_STATE_CORE_OPEN, &qedn->state))
> > +             qed_ops->common->slowpath_stop(qedn->cdev);
> > +
> > +     if (test_and_clear_bit(QEDN_STATE_CORE_PROBED, &qedn->state))
> > +             qed_ops->common->remove(qedn->cdev);
> >
> > -     pr_notice("Starting qedn_remove\n");
> > -     nvme_tcp_ofld_unregister_dev(&qedn->qedn_ofld_dev);
> >       kfree(qedn);
> >       pr_notice("Ending qedn_remove successfully\n");
> >   }
> > @@ -144,15 +268,55 @@ static int __qedn_probe(struct pci_dev *pdev)
> >       if (!qedn)
> >               return -ENODEV;
> >
> > +     qedn_init_pf_struct(qedn);
> > +
> > +     /* QED probe */
> > +     rc =3D qedn_core_probe(qedn);
> > +     if (rc)
> > +             goto exit_probe_and_release_mem;
> > +
> > +     set_bit(QEDN_STATE_CORE_PROBED, &qedn->state);
> > +
> > +     rc =3D qed_ops->fill_dev_info(qedn->cdev, &qedn->dev_info);
> > +     if (rc) {
> > +             pr_err("fill_dev_info failed\n");
> > +             goto exit_probe_and_release_mem;
> > +     }
> > +
> > +     qedn_add_pf_to_gl_list(qedn);
> > +     set_bit(QEDN_STATE_GL_PF_LIST_ADDED, &qedn->state);
> > +
> > +     rc =3D qedn_set_nvmetcp_pf_param(qedn);
> > +     if (rc)
> > +             goto exit_probe_and_release_mem;
> > +
> > +     qed_ops->common->update_pf_params(qedn->cdev, &qedn->pf_params);
> > +     rc =3D qedn_slowpath_start(qedn);
> > +     if (rc)
> > +             goto exit_probe_and_release_mem;
> > +
> > +     set_bit(QEDN_STATE_CORE_OPEN, &qedn->state);
> > +
> > +     rc =3D qed_ops->common->update_drv_state(qedn->cdev, true);
> > +     if (rc) {
> > +             pr_err("Failed to send drv state to MFW\n");
> > +             goto exit_probe_and_release_mem;
> > +     }
> > +
> > +     set_bit(QEDN_STATE_MFW_STATE, &qedn->state);
> > +
> >       qedn->qedn_ofld_dev.ops =3D &qedn_ofld_ops;
> >       INIT_LIST_HEAD(&qedn->qedn_ofld_dev.entry);
> >       rc =3D nvme_tcp_ofld_register_dev(&qedn->qedn_ofld_dev);
> >       if (rc)
> > -             goto release_qedn;
> > +             goto exit_probe_and_release_mem;
> > +
> > +     set_bit(QEDN_STATE_REGISTERED_OFFLOAD_DEV, &qedn->state);
> >
> >       return 0;
> > -release_qedn:
> > -     kfree(qedn);
> > +exit_probe_and_release_mem:
> > +     __qedn_remove(pdev);
> > +     pr_err("probe ended with error\n");
> >
> >       return rc;
> >   }
> > @@ -170,10 +334,26 @@ static struct pci_driver qedn_pci_driver =3D {
> >       .shutdown =3D qedn_shutdown,
> >   };
> >
> > +static inline void qedn_init_global_contxt(void)
> > +{
> > +     INIT_LIST_HEAD(&qedn_glb.qedn_pf_list);
> > +     INIT_LIST_HEAD(&qedn_glb.ctrl_list);
> > +     mutex_init(&qedn_glb.glb_mutex);
> > +}
> > +
> >   static int __init qedn_init(void)
> >   {
> >       int rc;
> >
> > +     qedn_init_global_contxt();
> > +
> > +     qed_ops =3D qed_get_nvmetcp_ops();
> > +     if (!qed_ops) {
> > +             pr_err("Failed to get QED NVMeTCP ops\n");
> > +
> > +             return -EINVAL;
> > +     }
> > +
> >       rc =3D pci_register_driver(&qedn_pci_driver);
> >       if (rc) {
> >               pr_err("Failed to register pci driver\n");
> > @@ -189,6 +369,7 @@ static int __init qedn_init(void)
> >   static void __exit qedn_cleanup(void)
> >   {
> >       pci_unregister_driver(&qedn_pci_driver);
> > +     qed_put_nvmetcp_ops();
> >       pr_notice("Unloading qedn ended\n");
> >   }
> >
> >
> I do wonder what you need the global list of devices for, but let's see.
>

It is in use in qedn_get_pf_from_pdev().
We will replace it in V5 in order to benefit from the nvme_tcp_ofld_devices
list.

> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks.

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
