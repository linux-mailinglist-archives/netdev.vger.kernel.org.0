Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1102CF1366
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbfKFKJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:09:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41580 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727363AbfKFKJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:09:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573034988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fyCnjsS5Fr1x57FB71TWjKrF0PPoXy8TukWSnaTEGNY=;
        b=WgagIdfJVmELq/X0xdBrDW7IOnrRJIvPgs+TTn6HDZrBpk9QfPdb749AYDLBJL8pRUmCht
        6UrRYoN+FD1k542+ynTHkJYg4zmzY4BDxXHEN/CN3Y0TVZvjhcFPQ//ch6mJv5p/eNI+vT
        T62vv+XchXWfHWYUBSw46oMGUsnsXdE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-n2XZEeSkMe2v5tM7bF782Q-1; Wed, 06 Nov 2019 05:09:47 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A74731800D53;
        Wed,  6 Nov 2019 10:09:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9467D600C4;
        Wed,  6 Nov 2019 10:09:45 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 705FD1802213;
        Wed,  6 Nov 2019 10:09:45 +0000 (UTC)
Date:   Wed, 6 Nov 2019 05:09:44 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, alex williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan daly <dan.daly@intel.com>,
        cunming liang <cunming.liang@intel.com>,
        tiwei bie <tiwei.bie@intel.com>,
        jason zeng <jason.zeng@intel.com>
Message-ID: <485376113.12775534.1573034984498.JavaMail.zimbra@redhat.com>
In-Reply-To: <1572946660-26265-2-git-send-email-lingshan.zhu@intel.com>
References: <1572946660-26265-1-git-send-email-lingshan.zhu@intel.com> <1572946660-26265-2-git-send-email-lingshan.zhu@intel.com>
Subject: Re: [PATCH 1/2] IFC hardware operation layer
MIME-Version: 1.0
X-Originating-IP: [10.68.5.20, 10.4.195.20]
Thread-Topic: IFC hardware operation layer
Thread-Index: FsBfjW5Zoy9a7+TY0AAHFCwQ5mGXrA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: n2XZEeSkMe2v5tM7bF782Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/5 =E4=B8=8B=E5=8D=885:37, Zhu Lingshan wrote:
> This commit introduced ifcvf_base layer, which handles hardware
> operations and configurations.

It looks like the PCI layout is pretty similar to virtio. Can we reuse
e.g virtio_pci_modern_probe() (or helpers in virtio_pci_modern.c) to
do the probing?

>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vhost/ifcvf/ifcvf_base.c | 344 +++++++++++++++++++++++++++++++++=
++++++
>  drivers/vhost/ifcvf/ifcvf_base.h | 132 +++++++++++++++
>  2 files changed, 476 insertions(+)
>  create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
>  create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
>
> diff --git a/drivers/vhost/ifcvf/ifcvf_base.c b/drivers/vhost/ifcvf/ifcvf=
_base.c
> new file mode 100644
> index 0000000..0659f41
> --- /dev/null
> +++ b/drivers/vhost/ifcvf/ifcvf_base.c
> @@ -0,0 +1,344 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2019 Intel Corporation.
> + */
> +
> +#include "ifcvf_base.h"
> +
> +static void *get_cap_addr(struct ifcvf_hw *hw, struct virtio_pci_cap *ca=
p)
> +{
> +=09struct ifcvf_adapter *ifcvf;
> +=09u32 length, offset;
> +=09u8 bar;
> +
> +=09length =3D le32_to_cpu(cap->length);
> +=09offset =3D le32_to_cpu(cap->offset);
> +=09bar =3D le32_to_cpu(cap->bar);
> +
> +=09ifcvf =3D container_of(hw, struct ifcvf_adapter, vf);
> +
> +=09if (bar >=3D IFCVF_PCI_MAX_RESOURCE) {
> +=09=09IFC_DBG(ifcvf->dev,
> +=09=09=09"Invalid bar number %u to get capabilities.\n", bar);
> +=09=09return NULL;
> +=09}
> +
> +=09if (offset + length < offset) {

Can this really happen? Both offset and length are u32.

> +=09=09IFC_DBG(ifcvf->dev, "offset(%u) + length(%u) overflows\n",
> +=09=09=09offset, length);
> +=09=09return NULL;
> +=09}
> +
> +=09if (offset + length > hw->mem_resource[cap->bar].len) {
> +=09=09IFC_DBG(ifcvf->dev,
> +=09=09=09"offset(%u) + len(%u) overflows bar%u to get capabilities.\n",
> +=09=09=09offset, length, bar);
> +=09=09return NULL;
> +=09}
> +
> +=09return hw->mem_resource[bar].addr + offset;

I don't see the initialization of mem_resource in the patch, I wonder
whether it's better to squash this patch just into patch 2.

> +}
> +
> +int ifcvf_read_config_range(struct pci_dev *dev,
> +=09=09=09uint32_t *val, int size, int where)
> +{
> +=09int ret, i;
> +
> +=09for (i =3D 0; i < size; i +=3D 4) {
> +=09=09ret =3D pci_read_config_dword(dev, where + i, val + i / 4);
> +=09=09if (ret < 0)
> +=09=09=09return ret;
> +=09}
> +
> +=09return 0;
> +}
> +
> +int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev)
> +{
> +=09struct virtio_pci_cap cap;
> +=09u16 notify_off;
> +=09int ret;
> +=09u8 pos;
> +=09u32 i;
> +
> +=09ret =3D pci_read_config_byte(dev, PCI_CAPABILITY_LIST, &pos);
> +
> +=09if (ret < 0) {
> +=09=09IFC_ERR(&dev->dev, "Failed to read PCI capability list.\n");
> +=09=09return -EIO;
> +=09}
> +
> +=09while (pos) {
> +=09=09ret =3D ifcvf_read_config_range(dev, (u32 *)&cap,
> +=09=09=09=09=09      sizeof(cap), pos);
> +
> +=09=09if (ret < 0) {
> +=09=09=09IFC_ERR(&dev->dev, "Failed to get PCI capability at %x",
> +=09=09=09=09pos);
> +=09=09=09break;
> +=09=09}
> +
> +=09=09if (cap.cap_vndr !=3D PCI_CAP_ID_VNDR)
> +=09=09=09goto next;
> +
> +=09=09IFC_DBG(&dev->dev, "read PCI config: config type: %u, PCI bar: %u,=
\
> +=09=09=09 PCI bar offset: %u, PCI config len: %u.\n",
> +=09=09=09cap.cfg_type, cap.bar, cap.offset, cap.length);
> +
> +=09=09switch (cap.cfg_type) {
> +=09=09case VIRTIO_PCI_CAP_COMMON_CFG:
> +=09=09=09hw->common_cfg =3D get_cap_addr(hw, &cap);
> +=09=09=09IFC_INFO(&dev->dev, "hw->common_cfg =3D %p.\n",
> +=09=09=09=09 hw->common_cfg);
> +=09=09=09break;
> +=09=09case VIRTIO_PCI_CAP_NOTIFY_CFG:
> +=09=09=09pci_read_config_dword(dev, pos + sizeof(cap),
> +=09=09=09=09=09      &hw->notify_off_multiplier);
> +=09=09=09hw->notify_bar =3D cap.bar;
> +=09=09=09hw->notify_base =3D get_cap_addr(hw, &cap);
> +=09=09=09IFC_INFO(&dev->dev, "hw->notify_base =3D %p.\n",
> +=09=09=09=09 hw->notify_base);
> +=09=09=09break;
> +=09=09case VIRTIO_PCI_CAP_ISR_CFG:
> +=09=09=09hw->isr =3D get_cap_addr(hw, &cap);
> +=09=09=09IFC_INFO(&dev->dev, "hw->isr =3D %p.\n", hw->isr);
> +=09=09=09break;
> +=09=09case VIRTIO_PCI_CAP_DEVICE_CFG:
> +=09=09=09hw->net_cfg =3D get_cap_addr(hw, &cap);
> +=09=09=09IFC_INFO(&dev->dev, "hw->net_cfg =3D %p.\n", hw->net_cfg);
> +=09=09=09break;

I think at least you can try to reuse e.g:
virtio_pci_find_capability() to aovid duplicating codes.

> +=09=09}
> +next:
> +=09=09pos =3D cap.cap_next;
> +=09}
> +
> +=09if (hw->common_cfg =3D=3D NULL || hw->notify_base =3D=3D NULL ||
> +=09    hw->isr =3D=3D NULL || hw->net_cfg =3D=3D NULL) {
> +=09=09IFC_DBG(&dev->dev, "Incomplete PCI capabilities.\n");
> +=09=09return -1;

Maybe it's better to fail eailier.

> +=09}
> +
> +=09for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +=09=09iowrite16(i, &hw->common_cfg->queue_select);
> +=09=09notify_off =3D ioread16(&hw->common_cfg->queue_notify_off);
> +=09=09hw->notify_addr[i] =3D (void *)((u8 *)hw->notify_base +
> +=09=09=09=09     notify_off * hw->notify_off_multiplier);

It might be better to store notify_addr inside the vring_info for
better locality.

> +=09}
> +
> +=09hw->lm_cfg =3D hw->mem_resource[IFCVF_LM_BAR].addr;
> +
> +=09IFC_DBG(&dev->dev, "PCI capability mapping: common cfg: %p,\
> +=09=09notify base: %p\n, isr cfg: %p, device cfg: %p,\
> +=09=09multiplier: %u\n",
> +=09=09hw->common_cfg, hw->notify_base, hw->isr,
> +=09=09hw->net_cfg, hw->notify_off_multiplier);
> +
> +=09return 0;
> +}
> +
> +u8 ifcvf_get_status(struct ifcvf_hw *hw)
> +{
> +=09u8 old_gen, new_gen, status;
> +
> +=09do {
> +=09=09old_gen =3D ioread8(&hw->common_cfg->config_generation);
> +=09=09status =3D ioread8(&hw->common_cfg->device_status);
> +=09=09new_gen =3D ioread8(&hw->common_cfg->config_generation);

config generation should be only used for config access not status,
and even it did, it should be called from virtio core.

> +=09} while (old_gen !=3D new_gen);
> +
> +=09return status;
> +}
> +
> +void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
> +{
> +=09iowrite8(status, &hw->common_cfg->device_status);
> +}
> +
> +void ifcvf_reset(struct ifcvf_hw *hw)
> +{
> +=09ifcvf_set_status(hw, 0);
> +=09ifcvf_get_status(hw);
> +}
> +
> +static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
> +{
> +=09if (status !=3D 0)
> +=09=09status |=3D ifcvf_get_status(hw);
> +
> +=09ifcvf_set_status(hw, status);
> +=09ifcvf_get_status(hw);
> +}
> +
> +u64 ifcvf_get_features(struct ifcvf_hw *hw)
> +{
> +=09struct virtio_pci_common_cfg *cfg =3D hw->common_cfg;
> +=09u32 features_lo, features_hi;
> +
> +=09iowrite32(0, &cfg->device_feature_select);
> +=09features_lo =3D ioread32(&cfg->device_feature);
> +
> +=09iowrite32(1, &cfg->device_feature_select);
> +=09features_hi =3D ioread32(&cfg->device_feature);
> +
> +=09return ((u64)features_hi << 32) | features_lo;
> +}
> +
> +void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
> +=09=09       void *dst, int length)
> +{
> +=09u8 old_gen, new_gen, *p;
> +=09int i;
> +
> +=09WARN_ON(offset + length > sizeof (struct ifcvf_net_config));
> +
> +=09do {
> +=09=09old_gen =3D ioread8(&hw->common_cfg->config_generation);

Same here, virtio core has did the call for generation, so no need do
do it again here.

> +=09=09p =3D dst;
> +
> +=09=09for (i =3D 0; i < length; i++)
> +=09=09=09*p++ =3D ioread8((u8 *)hw->net_cfg + offset + i);
> +
> +=09=09new_gen =3D ioread8(&hw->common_cfg->config_generation);
> +=09} while (old_gen !=3D new_gen);
> +}
> +
> +void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
> +=09=09=09    const void *src, int length)
> +{
> +=09const u8 *p;
> +=09int i;
> +
> +=09p =3D src;
> +=09WARN_ON(offset + length > sizeof (struct ifcvf_net_config));
> +
> +=09for (i =3D 0; i < length; i++)
> +=09=09iowrite8(*p++, (u8 *)hw->net_cfg + offset + i);
> +}
> +
> +static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
> +{
> +=09struct virtio_pci_common_cfg *cfg =3D hw->common_cfg;
> +
> +=09iowrite32(0, &cfg->guest_feature_select);
> +=09iowrite32(features & ((1ULL << 32) - 1), &cfg->guest_feature);

(u32)features ?

> +
> +=09iowrite32(1, &cfg->guest_feature_select);
> +=09iowrite32(features >> 32, &cfg->guest_feature);
> +}
> +
> +static int ifcvf_config_features(struct ifcvf_hw *hw)
> +{
> +=09struct ifcvf_adapter *ifcvf;
> +
> +=09ifcvf =3D=09container_of(hw, struct ifcvf_adapter, vf);
> +=09ifcvf_set_features(hw, hw->req_features);
> +=09ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
> +
> +=09if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATURES_OK)) {
> +=09=09IFC_ERR(ifcvf->dev, "Failed to set FEATURES_OK status\n");
> +=09=09return -EIO;
> +=09}
> +
> +=09return 0;
> +}
> +
> +void io_write64_twopart(u64 val, u32 *lo, u32 *hi)
> +{
> +=09iowrite32(val & ((1ULL << 32) - 1), lo);
> +=09iowrite32(val >> 32, hi);
> +}
> +
> +static int ifcvf_hw_enable(struct ifcvf_hw *hw)
> +{
> +=09struct virtio_pci_common_cfg *cfg;
> +=09struct ifcvf_adapter *ifcvf;
> +=09u8 *lm_cfg;
> +=09u32 i;
> +
> +=09ifcvf =3D container_of(hw, struct ifcvf_adapter, vf);
> +=09cfg =3D hw->common_cfg;
> +=09lm_cfg =3D hw->lm_cfg;
> +=09iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
> +
> +=09if (ioread16(&cfg->msix_config) =3D=3D VIRTIO_MSI_NO_VECTOR) {
> +=09=09IFC_ERR(ifcvf->dev, "No msix vector for device config.\n");
> +=09=09return -1;
> +=09}
> +
> +=09for (i =3D 0; i < hw->nr_vring; i++) {
> +=09=09iowrite16(i, &cfg->queue_select);
> +=09=09io_write64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
> +=09=09=09=09&cfg->queue_desc_hi);
> +=09=09io_write64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
> +=09=09=09=09&cfg->queue_avail_hi);
> +=09=09io_write64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
> +=09=09=09=09&cfg->queue_used_hi);
> +=09=09iowrite16(hw->vring[i].size, &cfg->queue_size);
> +
> +=09=09*(u32 *)(lm_cfg + IFCVF_LM_RING_STATE_OFFSET +
> +=09=09=09=09(i / 2) * IFCVF_LM_CFG_SIZE + (i % 2) * 4) =3D
> +=09=09=09(u32)hw->vring[i].last_avail_idx |
> +=09=09=09((u32)hw->vring[i].last_used_idx << 16);

As pointed out by Michael, it's better to formalize lm_cfg as a
structure instead of doing math here.

> +
> +=09=09iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
> +=09=09if (ioread16(&cfg->queue_msix_vector) =3D=3D
> +=09=09    VIRTIO_MSI_NO_VECTOR) {
> +=09=09=09IFC_ERR(ifcvf->dev,
> +=09=09=09=09"No msix vector for queue %u.\n", i);
> +=09=09=09return -1;
> +=09=09}
> +
> +=09=09iowrite16(1, &cfg->queue_enable);

This queue_enable should be done through set_vq_ready() from virtio core.

> +=09}
> +
> +=09return 0;
> +}
> +
> +static void ifcvf_hw_disable(struct ifcvf_hw *hw)
> +{
> +=09struct virtio_pci_common_cfg *cfg;
> +=09u32 i;
> +
> +=09cfg =3D hw->common_cfg;
> +=09iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->msix_config);
> +
> +=09for (i =3D 0; i < hw->nr_vring; i++) {
> +=09=09iowrite16(i, &cfg->queue_select);
> +=09=09iowrite16(0, &cfg->queue_enable);
> +=09=09iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->queue_msix_vector);
> +=09}
> +}
> +
> +int ifcvf_start_hw(struct ifcvf_hw *hw)
> +{
> +=09ifcvf_reset(hw);
> +=09ifcvf_add_status(hw, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> +=09ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER);
> +
> +=09if (ifcvf_config_features(hw) < 0)
> +=09=09return -1;

It's better to set status to CONFIG_S_FAILED when fail.

> +
> +=09if (ifcvf_hw_enable(hw) < 0)
> +=09=09return -1;
> +
> +=09ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER_OK);
> +
> +=09return 0;
> +}
> +
> +void ifcvf_stop_hw(struct ifcvf_hw *hw)
> +{
> +=09ifcvf_hw_disable(hw);
> +=09ifcvf_reset(hw);
> +}
> +
> +void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
> +{
> +=09iowrite16(qid, hw->notify_addr[qid]);
> +}
> +
> +u64 ifcvf_get_queue_notify_off(struct ifcvf_hw *hw, int qid)
> +{
> +=09return (u8 *)hw->notify_addr[qid] -
> +=09=09(u8 *)hw->mem_resource[hw->notify_bar].addr;
> +}
> diff --git a/drivers/vhost/ifcvf/ifcvf_base.h b/drivers/vhost/ifcvf/ifcvf=
_base.h
> new file mode 100644
> index 0000000..c97f0eb
> --- /dev/null
> +++ b/drivers/vhost/ifcvf/ifcvf_base.h
> @@ -0,0 +1,132 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright (C) 2019 Intel Corporation.
> + */
> +
> +#ifndef _IFCVF_H_
> +#define _IFCVF_H_
> +
> +#include <linux/virtio_mdev_ops.h>
> +#include <linux/mdev.h>
> +#include <linux/pci.h>
> +#include <linux/pci_regs.h>
> +#include <uapi/linux/virtio_net.h>
> +#include <uapi/linux/virtio_config.h>
> +#include <uapi/linux/virtio_pci.h>
> +
> +#define IFCVF_VENDOR_ID         0x1AF4
> +#define IFCVF_DEVICE_ID         0x1041
> +#define IFCVF_SUBSYS_VENDOR_ID  0x8086
> +#define IFCVF_SUBSYS_DEVICE_ID  0x001A
> +
> +#define IFCVF_MDEV_LIMIT=091
> +
> +/*
> + * Some ifcvf feature bits (currently bits 28 through 31) are
> + * reserved for the transport being used (eg. ifcvf_ring), the
> + * rest are per-device feature bits.
> + */
> +#define IFCVF_TRANSPORT_F_START 28
> +#define IFCVF_TRANSPORT_F_END   34
> +
> +#define IFC_SUPPORTED_FEATURES \
> +=09=09((1ULL << VIRTIO_NET_F_MAC)=09=09=09| \
> +=09=09 (1ULL << VIRTIO_F_ANY_LAYOUT)=09=09=09| \
> +=09=09 (1ULL << VIRTIO_F_VERSION_1)=09=09=09| \
> +=09=09 (1ULL << VIRTIO_F_ORDER_PLATFORM)=09=09=09| \
> +=09=09 (1ULL << VIRTIO_NET_F_GUEST_ANNOUNCE)=09=09| \
> +=09=09 (1ULL << VIRTIO_NET_F_CTRL_VQ)=09=09=09| \
> +=09=09 (1ULL << VIRTIO_NET_F_STATUS)=09=09=09| \
> +=09=09 (1ULL << VIRTIO_NET_F_MRG_RXBUF)) /* not fully supported */

If it was not fully supported, we need to remove it.

> +
> +//Not support MQ, only one queue pair for now.
> +#define IFCVF_MAX_QUEUE_PAIRS=09=091
> +#define IFCVF_MAX_QUEUES=09=092
> +
> +#define IFCVF_QUEUE_ALIGNMENT=09=09PAGE_SIZE
> +
> +#define IFCVF_MSI_CONFIG_OFF=090
> +#define IFCVF_MSI_QUEUE_OFF=091
> +#define IFCVF_PCI_MAX_RESOURCE=096
> +
> +#define IFCVF_LM_CFG_SIZE=09=090x40
> +#define IFCVF_LM_RING_STATE_OFFSET=090x20
> +#define IFCVF_LM_BAR=094
> +
> +#define IFCVF_32_BIT_MASK=09=090xffffffff
> +
> +#define IFC_ERR(dev, fmt, ...)=09dev_err(dev, fmt, ##__VA_ARGS__)
> +#define IFC_DBG(dev, fmt, ...)=09dev_dbg(dev, fmt, ##__VA_ARGS__)
> +#define IFC_INFO(dev, fmt, ...)=09dev_info(dev, fmt, ##__VA_ARGS__)
> +
> +#define IFC_PRIVATE_TO_VF(adapter) \
> +=09(&((struct ifcvf_adapter *)adapter)->vf)
> +
> +#define IFCVF_MAX_INTR (IFCVF_MAX_QUEUE_PAIRS * 2 + 1)
> +
> +struct ifcvf_net_config {
> +=09u8    mac[6];
> +=09u16   status;
> +=09u16   max_virtqueue_pairs;
> +} __packed;

Why not just use virtio_net_config?

> +
> +struct ifcvf_pci_mem_resource {
> +=09/* Physical address, 0 if not resource. */
> +=09u64      phys_addr;
> +=09/* Length of the resource. */
> +=09u64      len;
> +=09/* Virtual address, NULL when not mapped. */
> +=09u8       *addr;
> +};
> +
> +struct vring_info {
> +=09u64 desc;
> +=09u64 avail;
> +=09u64 used;
> +=09u16 size;
> +=09u16 last_avail_idx;
> +=09u16 last_used_idx;
> +=09bool ready;
> +=09char msix_name[256];
> +=09struct virtio_mdev_callback cb;
> +};
> +
> +struct ifcvf_hw {
> +=09u8=09*isr;
> +=09u8=09notify_bar;
> +=09u8=09*lm_cfg;
> +=09u8=09nr_vring;
> +=09u16=09*notify_base;
> +=09u16=09*notify_addr[IFCVF_MAX_QUEUE_PAIRS * 2];
> +=09u32=09notify_off_multiplier;
> +=09u64=09req_features;
> +=09struct=09virtio_pci_common_cfg *common_cfg;
> +=09struct=09ifcvf_net_config *net_cfg;
> +=09struct=09vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
> +=09struct=09ifcvf_pci_mem_resource mem_resource[IFCVF_PCI_MAX_RESOURCE];
> +};

It's better to add comments to explain each field.

> +
> +struct ifcvf_adapter {
> +=09struct=09device *dev;
> +=09struct=09mutex mdev_lock;
> +=09int=09mdev_count;
> +=09int=09vectors;
> +=09struct=09ifcvf_hw vf;
> +};
> +
> +int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev);
> +int ifcvf_start_hw(struct ifcvf_hw *hw);
> +void ifcvf_stop_hw(struct ifcvf_hw *hw);
> +void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid);
> +u8 ifcvf_get_linkstatus(struct ifcvf_hw *hw);
> +void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
> +=09=09=09   void *dst, int length);
> +void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
> +=09=09=09    const void *src, int length);
> +u8 ifcvf_get_status(struct ifcvf_hw *hw);
> +void ifcvf_set_status(struct ifcvf_hw *hw, u8 status);
> +void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
> +void ifcvf_reset(struct ifcvf_hw *hw);
> +u64 ifcvf_get_features(struct ifcvf_hw *hw);
> +
> +#endif /* _IFCVF_H_ */
> --=20
> 1.8.3.1
>

