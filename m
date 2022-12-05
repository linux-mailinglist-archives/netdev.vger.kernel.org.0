Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6BF6423B2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiLEHmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiLEHmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:42:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3641114B
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670226057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U2ORF3R4iV7mI1vJ1A9ulBpSuMDWgI16na8CV3RHlrU=;
        b=fayuM5/mUU70XBvn/u2h1vZ7xOkFXTKc9Uc3fi1388ioN7Tlpy+LuIe/JbVwKyZpGPgHTP
        z4FOdzq43wiceQ9a8eq2d4C1a0EvxwC1JFrkvu2L1IasPAuIt/QaG8loFw/clu/WzK9UEy
        8xNBjB5ylX/TM9KvOTanmXDkfgUETDw=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-yX46vC-4MHSV-MtqT07UFg-1; Mon, 05 Dec 2022 02:40:56 -0500
X-MC-Unique: yX46vC-4MHSV-MtqT07UFg-1
Received: by mail-ot1-f69.google.com with SMTP id bm9-20020a056830374900b0066e7ffcb95dso5012608otb.2
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 23:40:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U2ORF3R4iV7mI1vJ1A9ulBpSuMDWgI16na8CV3RHlrU=;
        b=OlVh5Rzbo8ePXZbqsdVjabt/xorwWl0OuqqS9WXu2VfcCT2wUWNO/FQqS/Qe12ElgA
         FqH+Sghiig4i0RYVuXjGZco9p8uQV4qUglyIrzWZLAkw5FAKwoRzEthV6oCKlgoYtRPU
         IxqPe4so/yvzu63uW+F+E7/Nbl46EO2spc56x0E9qurzw8PIgREqDDGKGQ/SaXWtpH4p
         IPQMURUcRkldVgvwYObimz718zsN1masLfV4nB/NAPvwJ4LyCcBANKYDbv6tO1UupDXr
         lYSjTKzpZOYqiApjP+MNBythAcRZdNmHyK5j2VGBVH+PUGjkGzfAK1eZqNs5QaPoDWuN
         UbZQ==
X-Gm-Message-State: ANoB5pkNRz4ItuiSmPNAbiod5752QNLhPN+bltrI8UfPw73/ahEXMB+N
        Di2tVprIF6foErosUdFzEOyXHD3OcSN01BsW9FaWMRsHDItuq7ktxtk4UxTmKWN4szLjUCy0Ccn
        38TqEftW1fQMMnTHDjTEMc1PnQtRHYGO0
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id cm5-20020a056830650500b0066cfb5b4904mr40709860otb.237.1670226055017;
        Sun, 04 Dec 2022 23:40:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf60A61Pcvl1E+t4qsgiIFKIDdHf6deEAjh1KsLFq7/Z5BFDQT1FC4INORPOk4n1WGL3M2TWNE7rIHvtyTMhoBw=
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id
 cm5-20020a056830650500b0066cfb5b4904mr40709844otb.237.1670226054621; Sun, 04
 Dec 2022 23:40:54 -0800 (PST)
MIME-Version: 1.0
References: <20221118225656.48309-1-snelson@pensando.io> <20221118225656.48309-19-snelson@pensando.io>
 <CACGkMEtvz4LrS9_t3NWdsEs=XnrtOcAgDSJJ4Z_efZR5c5D-cg@mail.gmail.com> <4b4e7474-5b36-6b2c-a0a5-2e198e1bab0c@amd.com>
In-Reply-To: <4b4e7474-5b36-6b2c-a0a5-2e198e1bab0c@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 5 Dec 2022 15:40:43 +0800
Message-ID: <CACGkMEvhr1MYrf2DyeVbtd5uOC+K6+-0P4DPYndkwJiXxkjsWw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 18/19] pds_vdpa: add support for vdpa and
 vdpamgmt interfaces
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 8:11 AM Shannon Nelson <shnelson@amd.com> wrote:
>
> On 11/21/22 10:32 PM, Jason Wang wrote:
> > On Sat, Nov 19, 2022 at 6:57 AM Shannon Nelson <snelson@pensando.io> wrote:
> >>
> >> This is the vDPA device support, where we advertise that we can
> >> support the virtio queues and deal with the configuration work
> >> through the pds_core's adminq.
> >>
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> >> ---
> >>   drivers/vdpa/pds/Makefile   |   3 +-
> >>   drivers/vdpa/pds/aux_drv.c  |  33 ++
> >>   drivers/vdpa/pds/debugfs.c  | 167 ++++++++
> >>   drivers/vdpa/pds/debugfs.h  |   4 +
> >>   drivers/vdpa/pds/vdpa_dev.c | 796 ++++++++++++++++++++++++++++++++++++
> >>   5 files changed, 1002 insertions(+), 1 deletion(-)
> >>   create mode 100644 drivers/vdpa/pds/vdpa_dev.c
> >>
> >> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> >> index fafd356ddf86..7fde4a4a1620 100644
> >> --- a/drivers/vdpa/pds/Makefile
> >> +++ b/drivers/vdpa/pds/Makefile
> >> @@ -7,4 +7,5 @@ pds_vdpa-y := aux_drv.o \
> >>                cmds.o \
> >>                pci_drv.o \
> >>                debugfs.o \
> >> -             virtio_pci.o
> >> +             virtio_pci.o \
> >> +             vdpa_dev.o
> >> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> >> index aef3c984dc90..83b9a5a79325 100644
> >> --- a/drivers/vdpa/pds/aux_drv.c
> >> +++ b/drivers/vdpa/pds/aux_drv.c
> >> @@ -12,6 +12,7 @@
> >>   #include <linux/pds/pds_vdpa.h>
> >>
> >>   #include "aux_drv.h"
> >> +#include "vdpa_dev.h"
> >>   #include "pci_drv.h"
> >>   #include "debugfs.h"
> >>
> >> @@ -25,10 +26,25 @@ static void
> >>   pds_vdpa_aux_notify_handler(struct pds_auxiliary_dev *padev,
> >>                              union pds_core_notifyq_comp *event)
> >>   {
> >> +       struct pds_vdpa_device *pdsv = padev->priv;
> >>          struct device *dev = &padev->aux_dev.dev;
> >>          u16 ecode = le16_to_cpu(event->ecode);
> >>
> >>          dev_info(dev, "%s: event code %d\n", __func__, ecode);
> >> +
> >> +       /* Give the upper layers a hint that something interesting
> >> +        * may have happened.  It seems that the only thing this
> >> +        * triggers in the virtio-net drivers above us is a check
> >> +        * of link status.
> >> +        *
> >> +        * We don't set the NEEDS_RESET flag for EVENT_RESET
> >> +        * because we're likely going through a recovery or
> >> +        * fw_update and will be back up and running soon.
> >> +        */
> >> +       if (ecode == PDS_EVENT_RESET || ecode == PDS_EVENT_LINK_CHANGE) {
> >> +               if (pdsv->hw.config_cb.callback)
> >> +                       pdsv->hw.config_cb.callback(pdsv->hw.config_cb.private);
> >> +       }
> >>   }
> >>
> >>   static int
> >> @@ -80,10 +96,25 @@ pds_vdpa_aux_probe(struct auxiliary_device *aux_dev,
> >>                  goto err_register_client;
> >>          }
> >>
> >> +       /* Get device ident info and set up the vdpa_mgmt_dev */
> >> +       err = pds_vdpa_get_mgmt_info(vdpa_aux);
> >> +       if (err)
> >> +               goto err_register_client;
> >> +
> >> +       /* Let vdpa know that we can provide devices */
> >> +       err = vdpa_mgmtdev_register(&vdpa_aux->vdpa_mdev);
> >> +       if (err) {
> >> +               dev_err(dev, "%s: Failed to initialize vdpa_mgmt interface: %pe\n",
> >> +                       __func__, ERR_PTR(err));
> >> +               goto err_mgmt_reg;
> >> +       }
> >> +
> >>          pds_vdpa_debugfs_add_ident(vdpa_aux);
> >>
> >>          return 0;
> >>
> >> +err_mgmt_reg:
> >> +       padev->ops->unregister_client(padev);
> >>   err_register_client:
> >>          auxiliary_set_drvdata(aux_dev, NULL);
> >>   err_invalid_driver:
> >> @@ -98,6 +129,8 @@ pds_vdpa_aux_remove(struct auxiliary_device *aux_dev)
> >>          struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
> >>          struct device *dev = &aux_dev->dev;
> >>
> >> +       vdpa_mgmtdev_unregister(&vdpa_aux->vdpa_mdev);
> >> +
> >>          vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
> >>          if (vdpa_aux->vdpa_vf)
> >>                  pci_dev_put(vdpa_aux->vdpa_vf->pdev);
> >> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
> >> index f766412209df..aa3143126a7e 100644
> >> --- a/drivers/vdpa/pds/debugfs.c
> >> +++ b/drivers/vdpa/pds/debugfs.c
> >> @@ -11,6 +11,7 @@
> >>   #include <linux/pds/pds_auxbus.h>
> >>   #include <linux/pds/pds_vdpa.h>
> >>
> >> +#include "vdpa_dev.h"
> >>   #include "aux_drv.h"
> >>   #include "pci_drv.h"
> >>   #include "debugfs.h"
> >> @@ -19,6 +20,72 @@
> >>
> >>   static struct dentry *dbfs_dir;
> >>
> >> +#define PRINT_SBIT_NAME(__seq, __f, __name)                     \
> >> +       do {                                                    \
> >> +               if (__f & __name)                               \
> >> +                       seq_printf(__seq, " %s", &#__name[16]); \
> >> +       } while (0)
> >> +
> >> +static void
> >> +print_status_bits(struct seq_file *seq, u16 status)
> >> +{
> >> +       seq_puts(seq, "status:");
> >> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> >> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER);
> >> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER_OK);
> >> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FEATURES_OK);
> >> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_NEEDS_RESET);
> >> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FAILED);
> >> +       seq_puts(seq, "\n");
> >> +}
> >> +
> >> +#define PRINT_FBIT_NAME(__seq, __f, __name)                \
> >> +       do {                                               \
> >> +               if (__f & BIT_ULL(__name))                 \
> >> +                       seq_printf(__seq, " %s", #__name); \
> >> +       } while (0)
> >> +
> >> +static void
> >> +print_feature_bits(struct seq_file *seq, u64 features)
> >> +{
> >> +       seq_puts(seq, "features:");
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CSUM);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_CSUM);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MTU);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MAC);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO4);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO6);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ECN);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_UFO);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO4);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO6);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_ECN);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_UFO);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MRG_RXBUF);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STATUS);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VQ);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VLAN);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX_EXTRA);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ANNOUNCE);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MQ);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_MAC_ADDR);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HASH_REPORT);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSS);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSC_EXT);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STANDBY);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_SPEED_DUPLEX);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_NOTIFY_ON_EMPTY);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ANY_LAYOUT);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_VERSION_1);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ACCESS_PLATFORM);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_RING_PACKED);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ORDER_PLATFORM);
> >> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_SR_IOV);
> >> +       seq_puts(seq, "\n");
> >> +}
> >> +
> >>   void
> >>   pds_vdpa_debugfs_create(void)
> >>   {
> >> @@ -49,10 +116,18 @@ static int
> >>   identity_show(struct seq_file *seq, void *v)
> >>   {
> >>          struct pds_vdpa_aux *vdpa_aux = seq->private;
> >> +       struct vdpa_mgmt_dev *mgmt;
> >>
> >>          seq_printf(seq, "aux_dev:            %s\n",
> >>                     dev_name(&vdpa_aux->padev->aux_dev.dev));
> >>
> >> +       mgmt = &vdpa_aux->vdpa_mdev;
> >> +       seq_printf(seq, "max_vqs:            %d\n", mgmt->max_supported_vqs);
> >> +       seq_printf(seq, "config_attr_mask:   %#llx\n", mgmt->config_attr_mask);
> >> +       seq_printf(seq, "supported_features: %#llx\n", mgmt->supported_features);
> >> +       print_feature_bits(seq, mgmt->supported_features);
> >> +       seq_printf(seq, "local_mac_bit:      %d\n", vdpa_aux->local_mac_bit);
> >> +
> >>          return 0;
> >>   }
> >>   DEFINE_SHOW_ATTRIBUTE(identity);
> >> @@ -64,4 +139,96 @@ pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux)
> >>                              vdpa_aux, &identity_fops);
> >>   }
> >>
> >> +static int
> >> +config_show(struct seq_file *seq, void *v)
> >> +{
> >> +       struct pds_vdpa_device *pdsv = seq->private;
> >> +       struct virtio_net_config *vc = &pdsv->vn_config;
> >> +
> >> +       seq_printf(seq, "mac:                  %pM\n", vc->mac);
> >> +       seq_printf(seq, "max_virtqueue_pairs:  %d\n",
> >> +                  __virtio16_to_cpu(true, vc->max_virtqueue_pairs));
> >> +       seq_printf(seq, "mtu:                  %d\n", __virtio16_to_cpu(true, vc->mtu));
> >> +       seq_printf(seq, "speed:                %d\n", le32_to_cpu(vc->speed));
> >> +       seq_printf(seq, "duplex:               %d\n", vc->duplex);
> >> +       seq_printf(seq, "rss_max_key_size:     %d\n", vc->rss_max_key_size);
> >> +       seq_printf(seq, "rss_max_indirection_table_length: %d\n",
> >> +                  le16_to_cpu(vc->rss_max_indirection_table_length));
> >> +       seq_printf(seq, "supported_hash_types: %#x\n",
> >> +                  le32_to_cpu(vc->supported_hash_types));
> >> +       seq_printf(seq, "vn_status:            %#x\n",
> >> +                  __virtio16_to_cpu(true, vc->status));
> >> +       print_status_bits(seq, __virtio16_to_cpu(true, vc->status));
> >> +
> >> +       seq_printf(seq, "hw_status:            %#x\n", pdsv->hw.status);
> >> +       print_status_bits(seq, pdsv->hw.status);
> >> +       seq_printf(seq, "req_features:         %#llx\n", pdsv->hw.req_features);
> >> +       print_feature_bits(seq, pdsv->hw.req_features);
> >> +       seq_printf(seq, "actual_features:      %#llx\n", pdsv->hw.actual_features);
> >> +       print_feature_bits(seq, pdsv->hw.actual_features);
> >> +       seq_printf(seq, "vdpa_index:           %d\n", pdsv->hw.vdpa_index);
> >> +       seq_printf(seq, "num_vqs:              %d\n", pdsv->hw.num_vqs);
> >> +
> >> +       return 0;
> >> +}
> >> +DEFINE_SHOW_ATTRIBUTE(config);
> >> +
> >> +static int
> >> +vq_show(struct seq_file *seq, void *v)
> >> +{
> >> +       struct pds_vdpa_vq_info *vq = seq->private;
> >> +       struct pds_vdpa_intr_info *intrs;
> >> +
> >> +       seq_printf(seq, "ready:      %d\n", vq->ready);
> >> +       seq_printf(seq, "desc_addr:  %#llx\n", vq->desc_addr);
> >> +       seq_printf(seq, "avail_addr: %#llx\n", vq->avail_addr);
> >> +       seq_printf(seq, "used_addr:  %#llx\n", vq->used_addr);
> >> +       seq_printf(seq, "q_len:      %d\n", vq->q_len);
> >> +       seq_printf(seq, "qid:        %d\n", vq->qid);
> >> +
> >> +       seq_printf(seq, "doorbell:   %#llx\n", vq->doorbell);
> >> +       seq_printf(seq, "avail_idx:  %d\n", vq->avail_idx);
> >> +       seq_printf(seq, "used_idx:   %d\n", vq->used_idx);
> >> +       seq_printf(seq, "intr_index: %d\n", vq->intr_index);
> >> +
> >> +       intrs = vq->pdsv->vdpa_aux->vdpa_vf->intrs;
> >> +       seq_printf(seq, "irq:        %d\n", intrs[vq->intr_index].irq);
> >> +       seq_printf(seq, "irq-name:   %s\n", intrs[vq->intr_index].name);
> >> +
> >> +       seq_printf(seq, "hw_qtype:   %d\n", vq->hw_qtype);
> >> +       seq_printf(seq, "hw_qindex:  %d\n", vq->hw_qindex);
> >> +
> >> +       return 0;
> >> +}
> >> +DEFINE_SHOW_ATTRIBUTE(vq);
> >> +
> >> +void
> >> +pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_device *pdsv)
> >> +{
> >> +       struct dentry *dentry;
> >> +       const char *name;
> >> +       int i;
> >> +
> >> +       dentry = pdsv->vdpa_aux->vdpa_vf->dentry;
> >> +       name = dev_name(&pdsv->vdpa_dev.dev);
> >> +
> >> +       pdsv->dentry = debugfs_create_dir(name, dentry);
> >> +
> >> +       debugfs_create_file("config", 0400, pdsv->dentry, pdsv, &config_fops);
> >> +
> >> +       for (i = 0; i < pdsv->hw.num_vqs; i++) {
> >> +               char name[8];
> >> +
> >> +               snprintf(name, sizeof(name), "vq%02d", i);
> >> +               debugfs_create_file(name, 0400, pdsv->dentry, &pdsv->hw.vqs[i], &vq_fops);
> >> +       }
> >> +}
> >> +
> >> +void
> >> +pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_device *pdsv)
> >> +{
> >> +       debugfs_remove_recursive(pdsv->dentry);
> >> +       pdsv->dentry = NULL;
> >> +}
> >> +
> >>   #endif /* CONFIG_DEBUG_FS */
> >> diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
> >> index 939a4c248aac..f0567e4ee4e4 100644
> >> --- a/drivers/vdpa/pds/debugfs.h
> >> +++ b/drivers/vdpa/pds/debugfs.h
> >> @@ -13,12 +13,16 @@ void pds_vdpa_debugfs_destroy(void);
> >>   void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
> >>   void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
> >>   void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux);
> >> +void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_device *pdsv);
> >> +void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_device *pdsv);
> >>   #else
> >>   static inline void pds_vdpa_debugfs_create(void) { }
> >>   static inline void pds_vdpa_debugfs_destroy(void) { }
> >>   static inline void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
> >>   static inline void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
> >>   static inline void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux) { }
> >> +static inline void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_device *pdsv) { }
> >> +static inline void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_device *pdsv) { }
> >>   #endif
> >>
> >>   #endif /* _PDS_VDPA_DEBUGFS_H_ */
> >> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
> >> new file mode 100644
> >> index 000000000000..824be42aff0d
> >> --- /dev/null
> >> +++ b/drivers/vdpa/pds/vdpa_dev.c
> >> @@ -0,0 +1,796 @@
> >> +// SPDX-License-Identifier: GPL-2.0-only
> >> +/* Copyright(c) 2022 Pensando Systems, Inc */
> >> +
> >> +#include <linux/interrupt.h>
> >> +#include <linux/module.h>
> >> +#include <linux/pci.h>
> >> +#include <linux/sysfs.h>
> >> +#include <linux/types.h>
> >> +#include <linux/vdpa.h>
> >> +#include <uapi/linux/virtio_pci.h>
> >> +#include <uapi/linux/vdpa.h>
> >> +
> >> +#include <linux/pds/pds_intr.h>
> >> +#include <linux/pds/pds_core_if.h>
> >> +#include <linux/pds/pds_adminq.h>
> >> +#include <linux/pds/pds_auxbus.h>
> >> +#include <linux/pds/pds_vdpa.h>
> >> +
> >> +#include "vdpa_dev.h"
> >> +#include "pci_drv.h"
> >> +#include "aux_drv.h"
> >> +#include "pci_drv.h"
> >> +#include "cmds.h"
> >> +#include "debugfs.h"
> >> +
> >> +static int
> >> +pds_vdpa_setup_driver(struct pds_vdpa_device *pdsv)
> >> +{
> >> +       struct device *dev = &pdsv->vdpa_dev.dev;
> >> +       int err = 0;
> >> +       int i;
> >> +
> >> +       /* Verify all vqs[] are in ready state */
> >> +       for (i = 0; i < pdsv->hw.num_vqs; i++) {
> >> +               if (!pdsv->hw.vqs[i].ready) {
> >> +                       dev_warn(dev, "%s: qid %d not ready\n", __func__, i);
> >> +                       err = -ENOENT;
> >> +               }
> >> +       }
> >> +
> >> +       return err;
> >> +}
> >> +
> >> +static struct pds_vdpa_device *
> >> +vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
> >> +{
> >> +       return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
> >> +}
> >> +
> >> +static struct pds_vdpa_hw *
> >> +vdpa_to_hw(struct vdpa_device *vdpa_dev)
> >> +{
> >> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
> >> +
> >> +       return &pdsv->hw;
> >> +}
> >> +
> >> +static int
> >> +pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
> >> +                       u64 desc_addr, u64 driver_addr, u64 device_addr)
> >> +{
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +
> >> +       hw->vqs[qid].desc_addr = desc_addr;
> >> +       hw->vqs[qid].avail_addr = driver_addr;
> >> +       hw->vqs[qid].used_addr = device_addr;
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static void
> >> +pds_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid, u32 num)
> >> +{
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +
> >> +       hw->vqs[qid].q_len = num;
> >> +}
> >> +
> >> +static void
> >> +pds_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
> >> +{
> >> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
> >> +
> >> +       iowrite16(qid, pdsv->hw.vqs[qid].notify);
> >> +}
> >> +
> >> +static void
> >> +pds_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
> >> +                  struct vdpa_callback *cb)
> >> +{
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +
> >> +       hw->vqs[qid].event_cb = *cb;
> >> +}
> >> +
> >> +static irqreturn_t
> >> +pds_vdpa_isr(int irq, void *data)
> >> +{
> >> +       struct pds_core_intr __iomem *intr_ctrl;
> >> +       struct pds_vdpa_device *pdsv;
> >> +       struct pds_vdpa_vq_info *vq;
> >> +
> >> +       vq = data;
> >> +       pdsv = vq->pdsv;
> >> +
> >> +       if (vq->event_cb.callback)
> >> +               vq->event_cb.callback(vq->event_cb.private);
> >> +
> >> +       /* Since we don't actually know how many vq descriptors are
> >> +        * covered in this interrupt cycle, we simply clean all the
> >> +        * credits and re-enable the interrupt.
> >> +        */
> >> +       intr_ctrl = (struct pds_core_intr __iomem *)pdsv->vdpa_aux->vdpa_vf->vd_mdev.isr;
> >> +       pds_core_intr_clean_flags(&intr_ctrl[vq->intr_index],
> >> +                                 PDS_CORE_INTR_CRED_REARM);
> >> +
> >> +       return IRQ_HANDLED;
> >> +}
> >> +
> >> +static void
> >> +pds_vdpa_release_irq(struct pds_vdpa_device *pdsv, int qid)
> >> +{
> >> +       struct pds_vdpa_intr_info *intrs = pdsv->vdpa_aux->vdpa_vf->intrs;
> >> +       struct pci_dev *pdev = pdsv->vdpa_aux->vdpa_vf->pdev;
> >> +       struct pds_core_intr __iomem *intr_ctrl;
> >> +       int index;
> >> +
> >> +       intr_ctrl = (struct pds_core_intr __iomem *)pdsv->vdpa_aux->vdpa_vf->vd_mdev.isr;
> >> +       index = pdsv->hw.vqs[qid].intr_index;
> >> +       if (index == VIRTIO_MSI_NO_VECTOR)
> >> +               return;
> >> +
> >> +       if (intrs[index].irq == VIRTIO_MSI_NO_VECTOR)
> >> +               return;
> >> +
> >> +       if (qid & 0x1) {
> >> +               pdsv->hw.vqs[qid].intr_index = VIRTIO_MSI_NO_VECTOR;
> >> +       } else {
> >> +               pds_core_intr_mask(&intr_ctrl[index], PDS_CORE_INTR_MASK_SET);
> >> +               devm_free_irq(&pdev->dev, intrs[index].irq, &pdsv->hw.vqs[qid]);
> >> +               pdsv->hw.vqs[qid].intr_index = VIRTIO_MSI_NO_VECTOR;
> >> +               intrs[index].irq = VIRTIO_MSI_NO_VECTOR;
> >> +       }
> >> +}
> >> +
> >> +static void
> >> +pds_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev, u16 qid, bool ready)
> >> +{
> >> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
> >> +       struct pci_dev *pdev = pdsv->vdpa_aux->vdpa_vf->pdev;
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +       struct device *dev = &pdsv->vdpa_dev.dev;
> >> +       struct pds_core_intr __iomem *intr_ctrl;
> >> +       int err;
> >> +
> >> +       dev_dbg(dev, "%s: qid %d ready %d => %d\n",
> >> +                __func__, qid, hw->vqs[qid].ready, ready);
> >> +       if (ready == hw->vqs[qid].ready)
> >> +               return;
> >> +
> >> +       intr_ctrl = (struct pds_core_intr __iomem *)pdsv->vdpa_aux->vdpa_vf->vd_mdev.isr;
> >
> > It looks to me pds has a different layout/semantic for isr than virtio
> > spec. I'd suggest to not reuse spec isr here to avoid confusion.
>
> Hmm, yes, that needs some straightening out.
>
> >
> >> +       if (ready) {
> >
> > Spec said no interrupt before DRIVER_OK, it looks more simple if we
> > move the interrupt setup to set_status():
> >
> > E.g we can know if we have sufficient vectors and use different
> > mapping policies in advance.
>
> I'll look at that.
>
> >
> >> +               struct pds_vdpa_intr_info *intrs = pdsv->vdpa_aux->vdpa_vf->intrs;
> >> +               int index = VIRTIO_MSI_NO_VECTOR;
> >> +               int i;
> >> +
> >> +               /*  Tx and Rx queues share interrupts, and they start with
> >> +                *  even numbers, so only find an interrupt for the even numbered
> >> +                *  qid, and let the odd number use what the previous queue got.
> >> +                */
> >> +               if (qid & 0x1) {
> >> +                       int even = qid & ~0x1;
> >> +
> >> +                       index = hw->vqs[even].intr_index;
> >> +               } else {
> >> +                       for (i = 0; i < pdsv->vdpa_aux->vdpa_vf->nintrs; i++) {
> >> +                               if (intrs[i].irq == VIRTIO_MSI_NO_VECTOR) {
> >> +                                       index = i;
> >> +                                       break;
> >> +                               }
> >> +                       }
> >> +               }
> >> +
> >> +               if (qid & 0x1) {
> >> +                       hw->vqs[qid].intr_index = index;
> >> +               } else if (index != VIRTIO_MSI_NO_VECTOR) {
> >> +                       int irq;
> >> +
> >> +                       irq = pci_irq_vector(pdev, index);
> >> +                       snprintf(intrs[index].name, sizeof(intrs[index].name),
> >> +                                "vdpa-%s-%d", dev_name(dev), index);
> >> +
> >> +                       err = devm_request_irq(&pdev->dev, irq, pds_vdpa_isr, 0,
> >> +                                              intrs[index].name, &hw->vqs[qid]);
> >> +                       if (err) {
> >> +                               dev_info(dev, "%s: no irq for qid %d: %pe\n",
> >> +                                        __func__, qid, ERR_PTR(err));
> >
> > Should we fail?
> >
> >> +                       } else {
> >> +                               intrs[index].irq = irq;
> >> +                               hw->vqs[qid].intr_index = index;
> >> +                               pds_core_intr_mask(&intr_ctrl[index],
> >> +                                                  PDS_CORE_INTR_MASK_CLEAR);
> >
> > I guess the reason that you don't simply use VF MSI-X is the DPU can
> > support vDPA subdevice in the future?
> >
> >> +                       }
> >> +               } else {
> >> +                       dev_info(dev, "%s: no intr slot for qid %d\n",
> >> +                                __func__, qid);
> >
> > Do we need to fail here?
> >
> >> +               }
> >> +
> >> +               /* Pass vq setup info to DSC */
> >> +               err = pds_vdpa_cmd_init_vq(pdsv, qid, &hw->vqs[qid]);
> >> +               if (err) {
> >> +                       pds_vdpa_release_irq(pdsv, qid);
> >> +                       ready = false;
> >> +               }
> >> +       } else {
> >> +               pds_vdpa_release_irq(pdsv, qid);
> >> +               (void) pds_vdpa_cmd_reset_vq(pdsv, qid);
> >> +       }
> >> +
> >> +       hw->vqs[qid].ready = ready;
> >> +}
> >> +
> >> +static bool
> >> +pds_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
> >> +{
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +
> >> +       return hw->vqs[qid].ready;
> >> +}
> >> +
> >> +static int
> >> +pds_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
> >> +                     const struct vdpa_vq_state *state)
> >> +{
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +
> >> +       hw->vqs[qid].used_idx = state->split.avail_index;
> >> +       hw->vqs[qid].avail_idx = state->split.avail_index;
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static int
> >> +pds_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
> >> +                     struct vdpa_vq_state *state)
> >> +{
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +
> >> +       state->split.avail_index = hw->vqs[qid].avail_idx;
> >
> > Who is in charge of reading avail_idx from the hardware?
>
> We didn't have that available in the early FW, so it isn't here yet.
> Work in progerss.
>
> >
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static struct vdpa_notification_area
> >> +pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
> >> +{
> >> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +       struct virtio_pci_modern_device *vd_mdev;
> >> +       struct vdpa_notification_area area;
> >> +
> >> +       area.addr = hw->vqs[qid].notify_pa;
> >> +
> >> +       vd_mdev = &pdsv->vdpa_aux->vdpa_vf->vd_mdev;
> >> +       if (!vd_mdev->notify_offset_multiplier)
> >> +               area.size = PAGE_SIZE;
> >> +       else
> >> +               area.size = vd_mdev->notify_offset_multiplier;
> >> +
> >> +       return area;
> >> +}
> >> +
> >> +static int
> >> +pds_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev, u16 qid)
> >> +{
> >> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +       int irq = VIRTIO_MSI_NO_VECTOR;
> >> +       int index;
> >> +
> >> +       if (pdsv->vdpa_aux->vdpa_vf->intrs) {
> >> +               index = hw->vqs[qid].intr_index;
> >> +               irq = pdsv->vdpa_aux->vdpa_vf->intrs[index].irq;
> >
> > The notification area mapping might only work well when each vq has
> > it's own irq. Otherwise guest may see spurious interrupt which may
> > degrade the performance.
>
> We haven't been expecting to use shared interrupts - are we being overly
> optimistic?

So at least from the codes above, I think we may end up with e.g two
queues that are using the same irq? And the comment said:

               /*  Tx and Rx queues share interrupts, and they start with
                 *  even numbers, so only find an interrupt for the
even numbered
                 *  qid, and let the odd number use what the previous queue got.
                 */
                if (qid & 0x1) {
                        int even = qid & ~0x1;

                index = hw->vqs[even].intr_index;

It said TX and RX share interrupts.

>
>
> >
> >> +       }
> >> +
> >> +       return irq;
> >> +}
> >> +
> >> +static u32
> >> +pds_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
> >> +{
> >> +
> >> +       return PAGE_SIZE;
> >> +}
> >> +
> >> +static u32
> >> +pds_vdpa_get_vq_group(struct vdpa_device *vdpa_dev, u16 idx)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >> +static u64
> >> +pds_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
> >> +{
> >> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
> >> +
> >> +       return le64_to_cpu(pdsv->vdpa_aux->ident.hw_features);
> >> +}
> >> +
> >> +static int
> >> +pds_vdpa_set_driver_features(struct vdpa_device *vdpa_dev, u64 features)
> >> +{
> >> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
> >> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
> >> +       struct device *dev = &pdsv->vdpa_dev.dev;
> >> +       u64 nego_features;
> >> +       u64 set_features;
> >> +       u64 missing;
> >> +       int err;
> >> +
> >> +       if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)) && features) {
> >> +               dev_err(dev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
> >> +               return -EOPNOTSUPP;
> >
> > Should we fail the FEATURE_OK in this case and all the other below
> > error conditions?
>
> Perhaps I'm missing a nuance in the inteface... isn't that what we're
> doing by returning a non-zero status?

Kind of, but to be compliant with the spec, the subsequent get_feature
should return status without FEATURE_OK, I'm not sure this can be
guaranteed:

static u8
pds_vdpa_get_status(struct vdpa_device *vdpa_dev)
{
        struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);

      return hw->status;
}

> >> +                       dev_warn(dev, "Known FW issue - overriding to use max_vq_pairs %d\n",
> >> +                                hw->num_vqs / 2);
> >
> > Should we fail here? Since the device has a different max_vqp that expected.
>
> Wasn't sure if we should annoy users with a fail here, or try to adjust
> and continue on with something that should work.

I think it's better to fail since it's the behaviour of other vDPA
devices and software virtio devices.

Thanks

