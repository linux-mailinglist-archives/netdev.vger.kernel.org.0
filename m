Return-Path: <netdev+bounces-2486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B752F702323
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 643551C20A06
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112511C20;
	Mon, 15 May 2023 05:05:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E828F10E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:05:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A417A184
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684127128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TXsazl8TnwUKIK2ArgOPXPc2tzc/LvXvB9Ii4q7NM4=;
	b=bhOf3prkJxW31cRFl9ivRyZdeqI62yGKVq3YY0NIUMeVXXGRN6o1Uri0B6xmRy7a0zmriJ
	bgPXbMVpaGBjKJq1LAmvE+F8rObFtnLh/xvSAoUS+Kovohm7yhzoWSN/4V3R5XzuNn1214
	zwoABHXb4Z4NXHougA/KNy+sMQ+aE4I=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-1FY7Y8QyMtmtVmzy5CQ1Hw-1; Mon, 15 May 2023 01:05:27 -0400
X-MC-Unique: 1FY7Y8QyMtmtVmzy5CQ1Hw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4ec790b902bso6578613e87.1
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684127126; x=1686719126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2TXsazl8TnwUKIK2ArgOPXPc2tzc/LvXvB9Ii4q7NM4=;
        b=MIcWHW9Vz+hJiSbWjnmx3pWSRfuYrKH/bDlYCy32RFFllNb1WvbZemJAU13v0kaNps
         Kq6pgTNdnZcHCbfoRWYoRQsTwNK/je62PDG6+jYSiRic58hJknxecdVE4yIZpN9GHOB7
         gDRwqZDHmumniH9YjVIjJGJznpsfotKZJAxoAnD0oUNOYRZk24LY8j5mdjvVX6IUX4ha
         8swH2ZC3VtQOKIHgBb3mYf5n2KWVD6KvOGlZzo+xU/3Af28ojoKEXqd3O1X0+tG0tOSR
         7QIoDJhnrv89PNS+2Wn1deLrifVdir2yMb5DfcraNzn0kgxmahQ1mixyyS9UxbTpnSJD
         NNYQ==
X-Gm-Message-State: AC+VfDw82z0ZZjSBNuDSRWStpwpWb22K/QUsNpnc7BBfwX2ewDLwssBL
	mlmN6Pl37Vb2mOWcM2BqkrK4BQPWxWVYnCf43cEQDGpfu/G2qgEr/cSbRq2mAVob8+qmVZVV5qq
	OVK0AcfXEW1dSU7Wrv/j1rXm5lBS0TDhQH737Oy55/e8TJA==
X-Received: by 2002:a19:c208:0:b0:4f3:7a8c:d46c with SMTP id l8-20020a19c208000000b004f37a8cd46cmr1125412lfc.66.1684127126018;
        Sun, 14 May 2023 22:05:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7fciQZ+jb/u1h7/rHL6ZUvVh9YyshSGD3KoJ+Qvbnxx/cDxKF5kQUgx1vv1533hSM/b6ZXYqfuB8cLA7f7/IM=
X-Received: by 2002:a19:c208:0:b0:4f3:7a8c:d46c with SMTP id
 l8-20020a19c208000000b004f37a8cd46cmr1125406lfc.66.1684127125631; Sun, 14 May
 2023 22:05:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230503181240.14009-1-shannon.nelson@amd.com> <20230503181240.14009-9-shannon.nelson@amd.com>
In-Reply-To: <20230503181240.14009-9-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 15 May 2023 13:05:14 +0800
Message-ID: <CACGkMEtef8+ox3EKn7bba=4Oqr-8WCkey49D+pM8ZvHQaYdEJw@mail.gmail.com>
Subject: Re: [PATCH v5 virtio 08/11] pds_vdpa: add vdpa config client commands
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	brett.creeley@amd.com, netdev@vger.kernel.org, simon.horman@corigine.com, 
	drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 2:13=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> These are the adminq commands that will be needed for
> setting up and using the vDPA device.  There are a number
> of commands defined in the FW's API, but by making use of
> the FW's virtio BAR we only need a few of these commands
> for vDPA support.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/pds/Makefile   |   1 +
>  drivers/vdpa/pds/cmds.c     | 207 ++++++++++++++++++++++++++++++++++++
>  drivers/vdpa/pds/cmds.h     |  20 ++++
>  drivers/vdpa/pds/vdpa_dev.h |  33 +++++-
>  4 files changed, 260 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/vdpa/pds/cmds.c
>  create mode 100644 drivers/vdpa/pds/cmds.h
>
> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> index 13b50394ec64..2e22418e3ab3 100644
> --- a/drivers/vdpa/pds/Makefile
> +++ b/drivers/vdpa/pds/Makefile
> @@ -4,6 +4,7 @@
>  obj-$(CONFIG_PDS_VDPA) :=3D pds_vdpa.o
>
>  pds_vdpa-y :=3D aux_drv.o \
> +             cmds.o \
>               vdpa_dev.o
>
>  pds_vdpa-$(CONFIG_DEBUG_FS) +=3D debugfs.o
> diff --git a/drivers/vdpa/pds/cmds.c b/drivers/vdpa/pds/cmds.c
> new file mode 100644
> index 000000000000..405711a0a0f8
> --- /dev/null
> +++ b/drivers/vdpa/pds/cmds.c
> @@ -0,0 +1,207 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/vdpa.h>
> +#include <linux/virtio_pci_modern.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
> +#include <linux/pds/pds_auxbus.h>
> +
> +#include "vdpa_dev.h"
> +#include "aux_drv.h"
> +#include "cmds.h"
> +
> +int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       union pds_core_adminq_cmd cmd =3D {
> +               .vdpa_init.opcode =3D PDS_VDPA_CMD_INIT,
> +               .vdpa_init.vdpa_index =3D pdsv->vdpa_index,
> +               .vdpa_init.vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +       };
> +       union pds_core_adminq_comp comp =3D {};
> +       int err;
> +
> +       /* Initialize the vdpa/virtio device */
> +       err =3D pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_init),
> +                                   &comp, 0);
> +       if (err)
> +               dev_dbg(dev, "Failed to init hw, status %d: %pe\n",
> +                       comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       union pds_core_adminq_cmd cmd =3D {
> +               .vdpa.opcode =3D PDS_VDPA_CMD_RESET,
> +               .vdpa.vdpa_index =3D pdsv->vdpa_index,
> +               .vdpa.vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +       };
> +       union pds_core_adminq_comp comp =3D {};
> +       int err;
> +
> +       err =3D pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa), &com=
p, 0);
> +       if (err)
> +               dev_dbg(dev, "Failed to reset hw, status %d: %pe\n",
> +                       comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       union pds_core_adminq_cmd cmd =3D {
> +               .vdpa_setattr.opcode =3D PDS_VDPA_CMD_SET_ATTR,
> +               .vdpa_setattr.vdpa_index =3D pdsv->vdpa_index,
> +               .vdpa_setattr.vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id=
),
> +               .vdpa_setattr.attr =3D PDS_VDPA_ATTR_MAC,
> +       };
> +       union pds_core_adminq_comp comp =3D {};
> +       int err;
> +
> +       ether_addr_copy(cmd.vdpa_setattr.mac, mac);
> +       err =3D pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_setatt=
r),
> +                                   &comp, 0);
> +       if (err)
> +               dev_dbg(dev, "Failed to set mac address %pM, status %d: %=
pe\n",
> +                       mac, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_=
vqp)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       union pds_core_adminq_cmd cmd =3D {
> +               .vdpa_setattr.opcode =3D PDS_VDPA_CMD_SET_ATTR,
> +               .vdpa_setattr.vdpa_index =3D pdsv->vdpa_index,
> +               .vdpa_setattr.vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id=
),
> +               .vdpa_setattr.attr =3D PDS_VDPA_ATTR_MAX_VQ_PAIRS,
> +               .vdpa_setattr.max_vq_pairs =3D cpu_to_le16(max_vqp),
> +       };
> +       union pds_core_adminq_comp comp =3D {};
> +       int err;
> +
> +       err =3D pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_setatt=
r),
> +                                   &comp, 0);
> +       if (err)
> +               dev_dbg(dev, "Failed to set max vq pairs %u, status %d: %=
pe\n",
> +                       max_vqp, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
> +                        struct pds_vdpa_vq_info *vq_info)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       union pds_core_adminq_cmd cmd =3D {
> +               .vdpa_vq_init.opcode =3D PDS_VDPA_CMD_VQ_INIT,
> +               .vdpa_vq_init.vdpa_index =3D pdsv->vdpa_index,
> +               .vdpa_vq_init.vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id=
),
> +               .vdpa_vq_init.qid =3D cpu_to_le16(qid),
> +               .vdpa_vq_init.len =3D cpu_to_le16(ilog2(vq_info->q_len)),
> +               .vdpa_vq_init.desc_addr =3D cpu_to_le64(vq_info->desc_add=
r),
> +               .vdpa_vq_init.avail_addr =3D cpu_to_le64(vq_info->avail_a=
ddr),
> +               .vdpa_vq_init.used_addr =3D cpu_to_le64(vq_info->used_add=
r),
> +               .vdpa_vq_init.intr_index =3D cpu_to_le16(qid),
> +       };
> +       union pds_core_adminq_comp comp =3D {};
> +       int err;
> +
> +       dev_dbg(dev, "%s: qid %d len %d desc_addr %#llx avail_addr %#llx =
used_addr %#llx\n",
> +               __func__, qid, ilog2(vq_info->q_len),
> +               vq_info->desc_addr, vq_info->avail_addr, vq_info->used_ad=
dr);
> +
> +       err =3D pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_vq_ini=
t),
> +                                   &comp, 0);
> +       if (err)
> +               dev_dbg(dev, "Failed to init vq %d, status %d: %pe\n",
> +                       qid, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       union pds_core_adminq_cmd cmd =3D {
> +               .vdpa_vq_reset.opcode =3D PDS_VDPA_CMD_VQ_RESET,
> +               .vdpa_vq_reset.vdpa_index =3D pdsv->vdpa_index,
> +               .vdpa_vq_reset.vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_i=
d),
> +               .vdpa_vq_reset.qid =3D cpu_to_le16(qid),
> +       };
> +       union pds_core_adminq_comp comp =3D {};
> +       int err;
> +
> +       err =3D pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_vq_res=
et),
> +                                   &comp, 0);
> +       if (err)
> +               dev_dbg(dev, "Failed to reset vq %d, status %d: %pe\n",
> +                       qid, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_set_vq_state(struct pds_vdpa_device *pdsv,
> +                             u16 qid, u16 avail, u16 used)
> +{      struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       union pds_core_adminq_cmd cmd =3D {
> +               .vdpa_vq_set_state.opcode =3D PDS_VDPA_CMD_VQ_SET_STATE,
> +               .vdpa_vq_set_state.vdpa_index =3D pdsv->vdpa_index,
> +               .vdpa_vq_set_state.vf_id =3D cpu_to_le16(pdsv->vdpa_aux->=
vf_id),
> +               .vdpa_vq_set_state.qid =3D cpu_to_le16(qid),
> +               .vdpa_vq_set_state.avail =3D cpu_to_le16(avail),
> +               .vdpa_vq_set_state.used =3D cpu_to_le16(used),
> +       };
> +       union pds_core_adminq_comp comp =3D {};
> +       int err;
> +
> +       err =3D pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_vq_set=
_state),
> +                                   &comp, 0);
> +       if (err)
> +               dev_dbg(dev, "Failed to set state vq %d, status %d: %pe\n=
",
> +                       qid, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_get_vq_state(struct pds_vdpa_device *pdsv,
> +                             u16 qid, u16 *avail, u16 *used)
> +{      struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       union pds_core_adminq_cmd cmd =3D {
> +               .vdpa_vq_get_state.opcode =3D PDS_VDPA_CMD_VQ_SET_STATE,
> +               .vdpa_vq_get_state.vdpa_index =3D pdsv->vdpa_index,
> +               .vdpa_vq_get_state.vf_id =3D cpu_to_le16(pdsv->vdpa_aux->=
vf_id),
> +               .vdpa_vq_get_state.qid =3D cpu_to_le16(qid),
> +       };
> +       union pds_core_adminq_comp comp =3D {};
> +       int err;
> +
> +       err =3D pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_vq_set=
_state),
> +                                   &comp, 0);
> +       if (err) {
> +               dev_dbg(dev, "Failed to set state vq %d, status %d: %pe\n=
",
> +                       qid, comp.status, ERR_PTR(err));
> +               return err;
> +       }
> +
> +       *avail =3D le16_to_cpu(comp.vdpa_vq_get_state.avail);
> +       *used =3D le16_to_cpu(comp.vdpa_vq_get_state.used);
> +
> +       return 0;
> +}
> diff --git a/drivers/vdpa/pds/cmds.h b/drivers/vdpa/pds/cmds.h
> new file mode 100644
> index 000000000000..cf4f8764e73c
> --- /dev/null
> +++ b/drivers/vdpa/pds/cmds.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifndef _VDPA_CMDS_H_
> +#define _VDPA_CMDS_H_
> +
> +int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv);
> +
> +int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv);
> +int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac);
> +int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_=
vqp);
> +int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
> +                        struct pds_vdpa_vq_info *vq_info);
> +int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid);
> +int pds_vdpa_cmd_set_features(struct pds_vdpa_device *pdsv, u64 features=
);
> +int pds_vdpa_cmd_set_vq_state(struct pds_vdpa_device *pdsv,
> +                             u16 qid, u16 avail, u16 used);
> +int pds_vdpa_cmd_get_vq_state(struct pds_vdpa_device *pdsv,
> +                             u16 qid, u16 *avail, u16 *used);
> +#endif /* _VDPA_CMDS_H_ */
> diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
> index 97fab833a0aa..a21596f438c1 100644
> --- a/drivers/vdpa/pds/vdpa_dev.h
> +++ b/drivers/vdpa/pds/vdpa_dev.h
> @@ -4,11 +4,42 @@
>  #ifndef _VDPA_DEV_H_
>  #define _VDPA_DEV_H_
>
> -#define PDS_VDPA_MAX_QUEUES    65
> +#include <linux/pci.h>
> +#include <linux/vdpa.h>
> +
> +struct pds_vdpa_vq_info {
> +       bool ready;
> +       u64 desc_addr;
> +       u64 avail_addr;
> +       u64 used_addr;
> +       u32 q_len;
> +       u16 qid;
> +       int irq;
> +       char irq_name[32];
> +
> +       void __iomem *notify;
> +       dma_addr_t notify_pa;
> +
> +       u64 doorbell;
> +       u16 avail_idx;
> +       u16 used_idx;
>
> +       struct vdpa_callback event_cb;
> +       struct pds_vdpa_device *pdsv;
> +};
> +
> +#define PDS_VDPA_MAX_QUEUES    65
> +#define PDS_VDPA_MAX_QLEN      32768
>  struct pds_vdpa_device {
>         struct vdpa_device vdpa_dev;
>         struct pds_vdpa_aux *vdpa_aux;
> +
> +       struct pds_vdpa_vq_info vqs[PDS_VDPA_MAX_QUEUES];
> +       u64 req_features;               /* features requested by vdpa */
> +       u64 actual_features;            /* features negotiated and in use=
 */
> +       u8 vdpa_index;                  /* rsvd for future subdevice use =
*/
> +       u8 num_vqs;                     /* num vqs in use */
> +       struct vdpa_callback config_cb;
>  };
>
>  int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
> --
> 2.17.1
>


