Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEFF6BA8BD
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjCOHHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjCOHHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:07:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35359591FF
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678863961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AVeDCxcVeUEwINX4A+87k6K5ylMcJjroc1LtLw+moxQ=;
        b=iqG40+YtT0VvLDvKcIbHZ7Cm19HMQxivUQX2tPRl93SpwmMnvMq1qaOI56DOS1vMibZIlv
        tXlWTIatCPbNArj14HTrBGj8hD5BXHvB66yiOkYG745iTWXXOgIHHDABJHb5BzwIYE6Y+g
        EqA2KhWglO2ZIh/mUjowad5K2tv3M+4=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-gj3l3qGRMoSk4TazEBk95A-1; Wed, 15 Mar 2023 03:05:59 -0400
X-MC-Unique: gj3l3qGRMoSk4TazEBk95A-1
Received: by mail-ot1-f71.google.com with SMTP id w27-20020a056830411b00b0069411644fc5so8461379ott.14
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:05:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678863957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AVeDCxcVeUEwINX4A+87k6K5ylMcJjroc1LtLw+moxQ=;
        b=p9dZfp+Fouc3Bc5/2sE/kXSamouwKa639IqPpXYDQPGTpmtdCV1JOqeOjbe0CF0B02
         8m+H+0JCWQxXtQv+jXh495ac7DTFqz5OgDK2IAIo9TLvCnxs2qrEDbnhgPqZXWWrQGZr
         yZrz8jeIJPCyXcEwCcKHJCEBtCJpht8TYjortn/u6PwerntN8P7FT3HlnE3kpmsdZLh3
         8Ns/cXgEJ1IsOVwl3nNxiJ0AD1Ohdz2/x/Qky6R2GSnbZfzlmu9F/XH3zEIbDFSv8oKg
         tUs0Z17O/agGhKrhjUf2hIPyNDeAOmKFLES3pfSUjJ3WP5PplI8fwGPbGhEIKMi1YIIS
         eBMA==
X-Gm-Message-State: AO0yUKUi4c4Gy3xN4QGHeTFhHd5Ot3Xk1XCV96QkkOGu7JU4o8G6D2jW
        BrJu/nY8XTnfPoz6tcvDx1FbR2xy5bm5HtnolIpRPlwUrUhCl2mNPv0epYV5LBvfmvOO9VOx5Wv
        uawNpjIhQKTpBjSRouYMnZKjXbDzTV58K
X-Received: by 2002:a05:6808:6149:b0:384:27f0:bd0a with SMTP id dl9-20020a056808614900b0038427f0bd0amr478950oib.9.1678863957086;
        Wed, 15 Mar 2023 00:05:57 -0700 (PDT)
X-Google-Smtp-Source: AK7set+WnuE5eiOs7ylPDUY/5xAf0BR2cgfz7T7MefTilIcifHuh2d99Dz/ke1uLTyhJHXSO0Bcmb0NygY8kmrYJ4So=
X-Received: by 2002:a05:6808:6149:b0:384:27f0:bd0a with SMTP id
 dl9-20020a056808614900b0038427f0bd0amr478946oib.9.1678863956756; Wed, 15 Mar
 2023 00:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com> <20230309013046.23523-6-shannon.nelson@amd.com>
In-Reply-To: <20230309013046.23523-6-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 15 Mar 2023 15:05:45 +0800
Message-ID: <CACGkMEvFiNKNwGTtCsj12ywjn_DXUhRhpyJhUV5TNwu8VytrBQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 virtio 5/7] pds_vdpa: add support for vdpa and
 vdpamgmt interfaces
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 9:31=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> This is the vDPA device support, where we advertise that we can
> support the virtio queues and deal with the configuration work
> through the pds_core's adminq.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vdpa/pds/aux_drv.c  |  15 +
>  drivers/vdpa/pds/aux_drv.h  |   1 +
>  drivers/vdpa/pds/debugfs.c  | 172 ++++++++++++
>  drivers/vdpa/pds/debugfs.h  |   8 +
>  drivers/vdpa/pds/vdpa_dev.c | 545 +++++++++++++++++++++++++++++++++++-
>  5 files changed, 740 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> index 28158d0d98a5..d706f06f7400 100644
> --- a/drivers/vdpa/pds/aux_drv.c
> +++ b/drivers/vdpa/pds/aux_drv.c
> @@ -60,8 +60,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux=
_dev,
>                 goto err_free_mgmt_info;
>         }
>
> +       /* Let vdpa know that we can provide devices */
> +       err =3D vdpa_mgmtdev_register(&vdpa_aux->vdpa_mdev);
> +       if (err) {
> +               dev_err(dev, "%s: Failed to initialize vdpa_mgmt interfac=
e: %pe\n",
> +                       __func__, ERR_PTR(err));
> +               goto err_free_virtio;
> +       }
> +
> +       pds_vdpa_debugfs_add_pcidev(vdpa_aux);
> +       pds_vdpa_debugfs_add_ident(vdpa_aux);
> +
>         return 0;
>
> +err_free_virtio:
> +       pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
>  err_free_mgmt_info:
>         pci_free_irq_vectors(padev->vf->pdev);
>  err_aux_unreg:
> @@ -78,11 +91,13 @@ static void pds_vdpa_remove(struct auxiliary_device *=
aux_dev)
>         struct pds_vdpa_aux *vdpa_aux =3D auxiliary_get_drvdata(aux_dev);
>         struct device *dev =3D &aux_dev->dev;
>
> +       vdpa_mgmtdev_unregister(&vdpa_aux->vdpa_mdev);
>         pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
>         pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
>
>         vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
>
> +       pds_vdpa_debugfs_del_vdpadev(vdpa_aux);
>         kfree(vdpa_aux);
>         auxiliary_set_drvdata(aux_dev, NULL);
>
> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
> index 87ac3c01c476..1ab1ce64da7c 100644
> --- a/drivers/vdpa/pds/aux_drv.h
> +++ b/drivers/vdpa/pds/aux_drv.h
> @@ -11,6 +11,7 @@ struct pds_vdpa_aux {
>         struct pds_auxiliary_dev *padev;
>
>         struct vdpa_mgmt_dev vdpa_mdev;
> +       struct pds_vdpa_device *pdsv;
>
>         struct pds_vdpa_ident ident;
>
> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
> index aa5e9677fe74..b3ee4f42f3b6 100644
> --- a/drivers/vdpa/pds/debugfs.c
> +++ b/drivers/vdpa/pds/debugfs.c
> @@ -9,6 +9,7 @@
>  #include <linux/pds/pds_auxbus.h>
>
>  #include "aux_drv.h"
> +#include "vdpa_dev.h"
>  #include "debugfs.h"
>
>  #ifdef CONFIG_DEBUG_FS
> @@ -26,4 +27,175 @@ void pds_vdpa_debugfs_destroy(void)
>         dbfs_dir =3D NULL;
>  }
>
> +#define PRINT_SBIT_NAME(__seq, __f, __name)                     \
> +       do {                                                    \
> +               if ((__f) & (__name))                               \
> +                       seq_printf(__seq, " %s", &#__name[16]); \
> +       } while (0)
> +
> +static void print_status_bits(struct seq_file *seq, u16 status)
> +{
> +       seq_puts(seq, "status:");
> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER);
> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER_OK);
> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FEATURES_OK);
> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_NEEDS_RESET);
> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FAILED);
> +       seq_puts(seq, "\n");
> +}
> +
> +#define PRINT_FBIT_NAME(__seq, __f, __name)                \
> +       do {                                               \
> +               if ((__f) & BIT_ULL(__name))                 \
> +                       seq_printf(__seq, " %s", #__name); \
> +       } while (0)
> +
> +static void print_feature_bits(struct seq_file *seq, u64 features)
> +{
> +       seq_puts(seq, "features:");
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CSUM);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_CSUM);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MTU);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MAC);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO4);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO6);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ECN);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_UFO);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO4);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO6);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_ECN);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_UFO);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MRG_RXBUF);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STATUS);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VQ);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VLAN);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX_EXTRA);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ANNOUNCE);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MQ);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_MAC_ADDR);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HASH_REPORT);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSS);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSC_EXT);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STANDBY);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_SPEED_DUPLEX);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_NOTIFY_ON_EMPTY);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ANY_LAYOUT);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_VERSION_1);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ACCESS_PLATFORM);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_RING_PACKED);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ORDER_PLATFORM);
> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_SR_IOV);
> +       seq_puts(seq, "\n");

Should we print the features that are not understood here?

> +}
> +
> +void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux)
> +{
> +       vdpa_aux->dentry =3D debugfs_create_dir(pci_name(vdpa_aux->padev-=
>vf->pdev), dbfs_dir);
> +}
> +
> +static int identity_show(struct seq_file *seq, void *v)
> +{
> +       struct pds_vdpa_aux *vdpa_aux =3D seq->private;
> +       struct vdpa_mgmt_dev *mgmt;
> +
> +       seq_printf(seq, "aux_dev:            %s\n",
> +                  dev_name(&vdpa_aux->padev->aux_dev.dev));
> +
> +       mgmt =3D &vdpa_aux->vdpa_mdev;
> +       seq_printf(seq, "max_vqs:            %d\n", mgmt->max_supported_v=
qs);
> +       seq_printf(seq, "config_attr_mask:   %#llx\n", mgmt->config_attr_=
mask);
> +       seq_printf(seq, "supported_features: %#llx\n", mgmt->supported_fe=
atures);
> +       print_feature_bits(seq, mgmt->supported_features);
> +
> +       return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(identity);
> +
> +void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux)
> +{
> +       debugfs_create_file("identity", 0400, vdpa_aux->dentry,
> +                           vdpa_aux, &identity_fops);
> +}
> +
> +static int config_show(struct seq_file *seq, void *v)
> +{
> +       struct pds_vdpa_device *pdsv =3D seq->private;
> +       struct virtio_net_config vc;
> +
> +       memcpy_fromio(&vc, pdsv->vdpa_aux->vd_mdev.device,
> +                     sizeof(struct virtio_net_config));
> +
> +       seq_printf(seq, "mac:                  %pM\n", vc.mac);
> +       seq_printf(seq, "max_virtqueue_pairs:  %d\n",
> +                  __virtio16_to_cpu(true, vc.max_virtqueue_pairs));
> +       seq_printf(seq, "mtu:                  %d\n", __virtio16_to_cpu(t=
rue, vc.mtu));
> +       seq_printf(seq, "speed:                %d\n", le32_to_cpu(vc.spee=
d));
> +       seq_printf(seq, "duplex:               %d\n", vc.duplex);
> +       seq_printf(seq, "rss_max_key_size:     %d\n", vc.rss_max_key_size=
);
> +       seq_printf(seq, "rss_max_indirection_table_length: %d\n",
> +                  le16_to_cpu(vc.rss_max_indirection_table_length));
> +       seq_printf(seq, "supported_hash_types: %#x\n",
> +                  le32_to_cpu(vc.supported_hash_types));
> +       seq_printf(seq, "vn_status:            %#x\n",
> +                  __virtio16_to_cpu(true, vc.status));
> +       print_status_bits(seq, __virtio16_to_cpu(true, vc.status));
> +
> +       seq_printf(seq, "req_features:         %#llx\n", pdsv->req_featur=
es);
> +       print_feature_bits(seq, pdsv->req_features);
> +       seq_printf(seq, "actual_features:      %#llx\n", pdsv->actual_fea=
tures);
> +       print_feature_bits(seq, pdsv->actual_features);
> +       seq_printf(seq, "vdpa_index:           %d\n", pdsv->vdpa_index);
> +       seq_printf(seq, "num_vqs:              %d\n", pdsv->num_vqs);
> +
> +       return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(config);
> +
> +static int vq_show(struct seq_file *seq, void *v)
> +{
> +       struct pds_vdpa_vq_info *vq =3D seq->private;
> +
> +       seq_printf(seq, "ready:      %d\n", vq->ready);
> +       seq_printf(seq, "desc_addr:  %#llx\n", vq->desc_addr);
> +       seq_printf(seq, "avail_addr: %#llx\n", vq->avail_addr);
> +       seq_printf(seq, "used_addr:  %#llx\n", vq->used_addr);
> +       seq_printf(seq, "q_len:      %d\n", vq->q_len);
> +       seq_printf(seq, "qid:        %d\n", vq->qid);
> +
> +       seq_printf(seq, "doorbell:   %#llx\n", vq->doorbell);
> +       seq_printf(seq, "avail_idx:  %d\n", vq->avail_idx);
> +       seq_printf(seq, "used_idx:   %d\n", vq->used_idx);
> +       seq_printf(seq, "irq:        %d\n", vq->irq);
> +       seq_printf(seq, "irq-name:   %s\n", vq->irq_name);
> +
> +       seq_printf(seq, "hw_qtype:   %d\n", vq->hw_qtype);
> +       seq_printf(seq, "hw_qindex:  %d\n", vq->hw_qindex);
> +
> +       return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(vq);
> +
> +void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux)
> +{
> +       int i;
> +
> +       debugfs_create_file("config", 0400, vdpa_aux->dentry, vdpa_aux->p=
dsv, &config_fops);
> +
> +       for (i =3D 0; i < vdpa_aux->pdsv->num_vqs; i++) {
> +               char name[8];
> +
> +               snprintf(name, sizeof(name), "vq%02d", i);
> +               debugfs_create_file(name, 0400, vdpa_aux->dentry,
> +                                   &vdpa_aux->pdsv->vqs[i], &vq_fops);
> +       }
> +}
> +
> +void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux)
> +{
> +       debugfs_remove_recursive(vdpa_aux->dentry);
> +       vdpa_aux->dentry =3D NULL;
> +}
>  #endif /* CONFIG_DEBUG_FS */
> diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
> index fff078a869e5..23e8345add0d 100644
> --- a/drivers/vdpa/pds/debugfs.h
> +++ b/drivers/vdpa/pds/debugfs.h
> @@ -10,9 +10,17 @@
>
>  void pds_vdpa_debugfs_create(void);
>  void pds_vdpa_debugfs_destroy(void);
> +void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux);
> +void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux);
> +void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux);
> +void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux);
>  #else
>  static inline void pds_vdpa_debugfs_create(void) { }
>  static inline void pds_vdpa_debugfs_destroy(void) { }
> +static inline void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa=
_aux) { }
> +static inline void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_=
aux) { }
> +static inline void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdp=
a_aux) { }
> +static inline void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdp=
a_aux) { }
>  #endif
>
>  #endif /* _PDS_VDPA_DEBUGFS_H_ */
> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
> index 15d623297203..2e0a5078d379 100644
> --- a/drivers/vdpa/pds/vdpa_dev.c
> +++ b/drivers/vdpa/pds/vdpa_dev.c
> @@ -5,6 +5,7 @@
>  #include <linux/vdpa.h>
>  #include <uapi/linux/vdpa.h>
>  #include <linux/virtio_pci_modern.h>
> +#include <uapi/linux/virtio_pci.h>
>
>  #include <linux/pds/pds_core.h>
>  #include <linux/pds/pds_adminq.h>
> @@ -13,7 +14,426 @@
>
>  #include "vdpa_dev.h"
>  #include "aux_drv.h"
> +#include "cmds.h"
> +#include "debugfs.h"
>
> +static struct pds_vdpa_device *vdpa_to_pdsv(struct vdpa_device *vdpa_dev=
)
> +{
> +       return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
> +}
> +
> +static int pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid=
,
> +                                  u64 desc_addr, u64 driver_addr, u64 de=
vice_addr)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +
> +       pdsv->vqs[qid].desc_addr =3D desc_addr;
> +       pdsv->vqs[qid].avail_addr =3D driver_addr;
> +       pdsv->vqs[qid].used_addr =3D device_addr;
> +
> +       return 0;
> +}
> +
> +static void pds_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid, u=
32 num)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +
> +       pdsv->vqs[qid].q_len =3D num;
> +}
> +
> +static void pds_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +
> +       iowrite16(qid, pdsv->vqs[qid].notify);
> +}
> +
> +static void pds_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
> +                              struct vdpa_callback *cb)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +
> +       pdsv->vqs[qid].event_cb =3D *cb;
> +}
> +
> +static irqreturn_t pds_vdpa_isr(int irq, void *data)
> +{
> +       struct pds_vdpa_vq_info *vq;
> +
> +       vq =3D data;
> +       if (vq->event_cb.callback)
> +               vq->event_cb.callback(vq->event_cb.private);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void pds_vdpa_release_irq(struct pds_vdpa_device *pdsv, int qid)
> +{
> +       if (pdsv->vqs[qid].irq =3D=3D VIRTIO_MSI_NO_VECTOR)
> +               return;
> +
> +       free_irq(pdsv->vqs[qid].irq, &pdsv->vqs[qid]);
> +       pdsv->vqs[qid].irq =3D VIRTIO_MSI_NO_VECTOR;
> +}
> +
> +static void pds_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev, u16 qid,=
 bool ready)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +       struct pci_dev *pdev =3D pdsv->vdpa_aux->padev->vf->pdev;
> +       struct device *dev =3D &pdsv->vdpa_dev.dev;
> +       int irq;
> +       int err;
> +
> +       dev_dbg(dev, "%s: qid %d ready %d =3D> %d\n",
> +               __func__, qid, pdsv->vqs[qid].ready, ready);
> +       if (ready =3D=3D pdsv->vqs[qid].ready)
> +               return;
> +
> +       if (ready) {
> +               irq =3D pci_irq_vector(pdev, qid);
> +               snprintf(pdsv->vqs[qid].irq_name, sizeof(pdsv->vqs[qid].i=
rq_name),
> +                        "vdpa-%s-%d", dev_name(dev), qid);
> +
> +               err =3D request_irq(irq, pds_vdpa_isr, 0,
> +                                 pdsv->vqs[qid].irq_name, &pdsv->vqs[qid=
]);
> +               if (err) {
> +                       dev_err(dev, "%s: no irq for qid %d: %pe\n",
> +                               __func__, qid, ERR_PTR(err));
> +                       return;
> +               }
> +               pdsv->vqs[qid].irq =3D irq;
> +
> +               /* Pass vq setup info to DSC */
> +               err =3D pds_vdpa_cmd_init_vq(pdsv, qid, &pdsv->vqs[qid]);
> +               if (err) {
> +                       pds_vdpa_release_irq(pdsv, qid);
> +                       ready =3D false;
> +               }
> +       } else {
> +               err =3D pds_vdpa_cmd_reset_vq(pdsv, qid);
> +               if (err)
> +                       dev_err(dev, "%s: reset_vq failed qid %d: %pe\n",
> +                               __func__, qid, ERR_PTR(err));
> +               pds_vdpa_release_irq(pdsv, qid);
> +       }
> +
> +       pdsv->vqs[qid].ready =3D ready;
> +}
> +
> +static bool pds_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +
> +       return pdsv->vqs[qid].ready;
> +}
> +
> +static int pds_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
> +                                const struct vdpa_vq_state *state)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_vq_set_state_cmd cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_VQ_SET_STATE,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +               .qid =3D cpu_to_le16(qid),
> +       };
> +       struct pds_vdpa_comp comp =3D {0};
> +       int err;
> +
> +       dev_dbg(dev, "%s: qid %d avail %#x\n",
> +               __func__, qid, state->packed.last_avail_idx);
> +
> +       if (pdsv->actual_features & VIRTIO_F_RING_PACKED) {
> +               cmd.avail =3D cpu_to_le16(state->packed.last_avail_idx |
> +                                       (state->packed.last_avail_counter=
 << 15));
> +               cmd.used =3D cpu_to_le16(state->packed.last_used_idx |
> +                                      (state->packed.last_used_counter <=
< 15));
> +       } else {
> +               cmd.avail =3D cpu_to_le16(state->split.avail_index);
> +               /* state->split does not provide a used_index:
> +                * the vq will be set to "empty" here, and the vq will re=
ad
> +                * the current used index the next time the vq is kicked.
> +                */
> +               cmd.used =3D cpu_to_le16(state->split.avail_index);
> +       }
> +
> +       err =3D padev->ops->adminq_cmd(padev,
> +                                    (union pds_core_adminq_cmd *)&cmd,
> +                                    sizeof(cmd),
> +                                    (union pds_core_adminq_comp *)&comp,
> +                                    0);

I had one question for adminq command. I think we should use PF
instead of VF but in __pdsc_adminq_post() I saw:

        q_info->dest =3D comp;
        memcpy(q_info->desc, cmd, sizeof(*cmd));

So cmd should be fine since it is copied to the q_info->desc which is
already mapped. But q_info->dest look suspicious, where did it mapped?

Thanks


> +       if (err)
> +               dev_err(dev, "Failed to set vq state qid %u, status %d: %=
pe\n",
> +                       qid, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +static int pds_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
> +                                struct vdpa_vq_state *state)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_vq_get_state_cmd cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_VQ_GET_STATE,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +               .qid =3D cpu_to_le16(qid),
> +       };
> +       struct pds_vdpa_vq_get_state_comp comp =3D {0};
> +       int err;
> +
> +       dev_dbg(dev, "%s: qid %d\n", __func__, qid);
> +
> +       err =3D padev->ops->adminq_cmd(padev,
> +                                    (union pds_core_adminq_cmd *)&cmd,
> +                                    sizeof(cmd),
> +                                    (union pds_core_adminq_comp *)&comp,
> +                                    0);
> +       if (err) {
> +               dev_err(dev, "Failed to get vq state qid %u, status %d: %=
pe\n",
> +                       qid, comp.status, ERR_PTR(err));
> +               return err;
> +       }
> +
> +       if (pdsv->actual_features & VIRTIO_F_RING_PACKED) {
> +               state->packed.last_avail_idx =3D le16_to_cpu(comp.avail) =
& 0x7fff;
> +               state->packed.last_avail_counter =3D le16_to_cpu(comp.ava=
il) >> 15;
> +       } else {
> +               state->split.avail_index =3D le16_to_cpu(comp.avail);
> +               /* state->split does not provide a used_index. */
> +       }
> +
> +       return err;
> +}
> +
> +static struct vdpa_notification_area
> +pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +       struct virtio_pci_modern_device *vd_mdev;
> +       struct vdpa_notification_area area;
> +
> +       area.addr =3D pdsv->vqs[qid].notify_pa;
> +
> +       vd_mdev =3D &pdsv->vdpa_aux->vd_mdev;
> +       if (!vd_mdev->notify_offset_multiplier)
> +               area.size =3D PAGE_SIZE;

Note that PAGE_SIZE varies among archs, I doubt we should use a fixed size =
here.

Others look good.

Thanks

