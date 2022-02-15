Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6874B61B7
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 04:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiBODe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 22:34:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiBODe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 22:34:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56BD6AD135
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 19:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644896086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SV91EC1qIVu249rdG8c9qLwhivu0KgO1VbzennYEj3I=;
        b=XcOrEvmk7bM9Y5oaEZamXAV1IRe+HwSmhwIeE7KY6KdC7bsgZ2lpDG6py0VsrTCyTVsTpB
        PCAJhyVdqYjfNNFwPu65Z6iF1Ou0DUS9xOJyVDk4687U4+tFGTInUVagwCoGtibCvfOC9F
        MqZmZ1rZA9bHTFxMCaPWP/dAzOzXghA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-ukAowl6XMEqmzJ2wnOCCwg-1; Mon, 14 Feb 2022 22:34:45 -0500
X-MC-Unique: ukAowl6XMEqmzJ2wnOCCwg-1
Received: by mail-lj1-f197.google.com with SMTP id i8-20020a2ea228000000b002449296c787so5064196ljm.18
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 19:34:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SV91EC1qIVu249rdG8c9qLwhivu0KgO1VbzennYEj3I=;
        b=z0IZvqtC0/g2+K2u/3wBCLfnMtF1uutIWkigNUnvlQyqNe7TG1TW/G7mHTBq30lwJh
         MFCw88RFv4RdiHwyk23GOiqI+fSsYY0RskyzEdHRF1GVwpaS8vhjVdvzef66dA9baLbL
         qsYoptMUOt3MT8TSxlW+JI6TuxCsc9KS15uenyEa2FeID1yJAMj/5lb7kR94QGwiOSC6
         IvvgLd/f2yBsycnNoIYTgmR/tFI00+luwB2lkKxOUI0G0qD+YNN6+r0dSN0x/sy2O4w3
         xvbJqlYJtxWk6v2ZZetP5yJUaVB5DR2v9fXN1Y+wP/542sBxWQiW0TuWBImVLccvK05k
         OLBQ==
X-Gm-Message-State: AOAM531KDlmhTHca6uXHcSPBjCT/PDuIwTiCmwSNrIsdASZkM06qmzdW
        H2y2FF605R2CpaUNCGE/vWfMAOCYMJikGQ8+xnhhYVxdUp1m7OT7FRivBynHpBP2pT9EFyNfFfu
        i7ZLbib72CSvk244K2pyDjEqEq8DM7VJv
X-Received: by 2002:a2e:a80c:: with SMTP id l12mr1229869ljq.107.1644896083373;
        Mon, 14 Feb 2022 19:34:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzggEMFvnr440c/h/ht0U/NsKGjtsLVyBMXxoAsgGvqsdHnPotV5iUxc4q0ttoYhNgXFe/fkuLOibekxYWO7T0=
X-Received: by 2002:a2e:a80c:: with SMTP id l12mr1229850ljq.107.1644896082968;
 Mon, 14 Feb 2022 19:34:42 -0800 (PST)
MIME-Version: 1.0
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
 <20220203072735.189716-5-lingshan.zhu@intel.com> <c2036174-22ae-0882-1783-53a5d20a03ad@redhat.com>
 <20220214091842-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220214091842-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 15 Feb 2022 11:34:31 +0800
Message-ID: <CACGkMEtMDqsLk9O+pHUgd85NxH_0dT=QJZSy=GsnDfKq3cXC3Q@mail.gmail.com>
Subject: Re: [PATCH V4 4/4] vDPA/ifcvf: implement shared IRQ feature
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 10:25 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Feb 14, 2022 at 03:19:25PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2022/2/3 =E4=B8=8B=E5=8D=883:27, Zhu Lingshan =E5=86=99=E9=81=
=93:
> > > On some platforms/devices, there may not be enough MSI vector
> > > slots allocated for virtqueues and config changes. In such a case,
> > > the interrupt sources(virtqueues, config changes) must share
> > > an IRQ/vector, to avoid initialization failures, keep
> > > the device functional.
> > >
> > > This commit handles three cases:
> > > (1) number of the allocated vectors =3D=3D the number of virtqueues +=
 1
> > > (config changes), every virtqueue and the config interrupt has
> > > a separated vector/IRQ, the best and the most likely case.
> > > (2) number of the allocated vectors is less than the best case, but
> > > greater than 1. In this case, all virtqueues share a vector/IRQ,
> > > the config interrupt has a separated vector/IRQ
> > > (3) only one vector is allocated, in this case, the virtqueues and
> > > the config interrupt share a vector/IRQ. The worst and most
> > > unlikely case.
> > >
> > > Otherwise, it needs to fail.
> > >
> > > This commit introduces some helper functions:
> > > ifcvf_set_vq_vector() and ifcvf_set_config_vector() sets virtqueue
> > > vector and config vector in the device config space, so that
> > > the device can send interrupt DMA.
> > >
> > > This commit adds some fields in struct ifcvf_hw and re-placed
> > > the existed fields to be aligned with the cacheline.
> > >
> > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > > ---
> > >   drivers/vdpa/ifcvf/ifcvf_base.c |  47 ++++--
> > >   drivers/vdpa/ifcvf/ifcvf_base.h |  23 ++-
> > >   drivers/vdpa/ifcvf/ifcvf_main.c | 243 +++++++++++++++++++++++++++--=
---
> > >   3 files changed, 256 insertions(+), 57 deletions(-)
> > >
> > > diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifc=
vf_base.c
> > > index 397692ae671c..18dcb63ab1e3 100644
> > > --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> > > +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> > > @@ -15,6 +15,36 @@ struct ifcvf_adapter *vf_to_adapter(struct ifcvf_h=
w *hw)
> > >     return container_of(hw, struct ifcvf_adapter, vf);
> > >   }
> > > +int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)
> > > +{
> > > +   struct virtio_pci_common_cfg __iomem *cfg =3D hw->common_cfg;
> > > +   struct ifcvf_adapter *ifcvf =3D vf_to_adapter(hw);
> > > +
> > > +   ifc_iowrite16(qid, &cfg->queue_select);
> > > +   ifc_iowrite16(vector, &cfg->queue_msix_vector);
> > > +   if (ifc_ioread16(&cfg->queue_msix_vector) =3D=3D VIRTIO_MSI_NO_VE=
CTOR) {
> > > +           IFCVF_ERR(ifcvf->pdev, "No msix vector for queue %u\n", q=
id);
> > > +                   return -EINVAL;
> > > +   }
> >
> >
> > Let's leave this check for the caller, E.g can caller try to assign
> > NO_VECTOR during uni-nit?
>
>
> Hmm I'm not sure I agree. Caller will have to write queue select
> again, and that's an extra IO, which is a waste.
> And having function checking itself just seems better contained.

It's as simple as just return what we read here like virtio_pci did:

u16 vp_modern_queue_vector(struct virtio_pci_modern_device *mdev,
                           u16 index, u16 vector)
{
        struct virtio_pci_common_cfg __iomem *cfg =3D mdev->common;

        vp_iowrite16(index, &cfg->queue_select);
        vp_iowrite16(vector, &cfg->queue_msix_vector);
        /* Flush the write out to device */
        return vp_ioread16(&cfg->queue_msix_vector);
}
EXPORT_SYMBOL_GPL(vp_modern_queue_vector);

Then the caller can decide to check it with NO_VECTOR if needed.
Current code will break the callers that want to set NO_VECTOR.

>
> >
> > > +
> > > +   return 0;
> > > +}
> > > +
> > > +int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector)
> > > +{
> > > +   struct virtio_pci_common_cfg __iomem *cfg =3D hw->common_cfg;
> > > +   struct ifcvf_adapter *ifcvf =3D vf_to_adapter(hw);
> > > +
> > > +   cfg =3D hw->common_cfg;
> > > +   ifc_iowrite16(vector,  &cfg->msix_config);
> > > +   if (ifc_ioread16(&cfg->msix_config) =3D=3D VIRTIO_MSI_NO_VECTOR) =
{
> > > +           IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\=
n");
> > > +           return -EINVAL;
> > > +   }
> >
> >
> > Similar question as above.
> >
> >
> > > +
> > > +   return 0;
> > > +}
> > > +
> > >   static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
> > >                               struct virtio_pci_cap *cap)
> > >   {
> > > @@ -140,6 +170,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci=
_dev *pdev)
> > >               hw->common_cfg, hw->notify_base, hw->isr,
> > >               hw->dev_cfg, hw->notify_off_multiplier);
> > > +   hw->vqs_shared_irq =3D -EINVAL;
> > > +
> > >     return 0;
> > >   }
> > > @@ -321,12 +353,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
> > >     ifcvf =3D vf_to_adapter(hw);
> > >     cfg =3D hw->common_cfg;
> > > -   ifc_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
> > > -
> > > -   if (ifc_ioread16(&cfg->msix_config) =3D=3D VIRTIO_MSI_NO_VECTOR) =
{
> > > -           IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\=
n");
> > > -           return -EINVAL;
> > > -   }
> > >     for (i =3D 0; i < hw->nr_vring; i++) {
> > >             if (!hw->vring[i].ready)
> > > @@ -340,15 +366,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
> > >             ifc_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used=
_lo,
> > >                                  &cfg->queue_used_hi);
> > >             ifc_iowrite16(hw->vring[i].size, &cfg->queue_size);
> > > -           ifc_iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_v=
ector);
> > > -
> > > -           if (ifc_ioread16(&cfg->queue_msix_vector) =3D=3D
> > > -               VIRTIO_MSI_NO_VECTOR) {
> > > -                   IFCVF_ERR(ifcvf->pdev,
> > > -                             "No msix vector for queue %u\n", i);
> > > -                   return -EINVAL;
> > > -           }
> > > -
> > >             ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
> > >             ifc_iowrite16(1, &cfg->queue_enable);
> > >     }
> > > diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifc=
vf_base.h
> > > index 949b4fb9d554..9cfe088c82e9 100644
> > > --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> > > +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> > > @@ -27,8 +27,6 @@
> > >   #define IFCVF_QUEUE_ALIGNMENT     PAGE_SIZE
> > >   #define IFCVF_QUEUE_MAX           32768
> > > -#define IFCVF_MSI_CONFIG_OFF       0
> > > -#define IFCVF_MSI_QUEUE_OFF        1
> > >   #define IFCVF_PCI_MAX_RESOURCE    6
> > >   #define IFCVF_LM_CFG_SIZE         0x40
> > > @@ -42,6 +40,13 @@
> > >   #define ifcvf_private_to_vf(adapter) \
> > >     (&((struct ifcvf_adapter *)adapter)->vf)
> > > +/* all vqs and config interrupt has its own vector */
> > > +#define MSIX_VECTOR_PER_VQ_AND_CONFIG              1
> > > +/* all vqs share a vector, and config interrupt has a separate vecto=
r */
> > > +#define MSIX_VECTOR_SHARED_VQ_AND_CONFIG   2
> > > +/* all vqs and config interrupt share a vector */
> > > +#define MSIX_VECTOR_DEV_SHARED                     3
> >
> >
> > I think there's no much value to differ 2 from 3 consider config interr=
upt
> > should be rare.
>
>
> Yes but if we do not have a dedicated vector then we need an
> extra device IO (in fact, a read) on each interrupt.

Ok, right.

>
> >
> > > +
> > >   static inline u8 ifc_ioread8(u8 __iomem *addr)
> > >   {
> > >     return ioread8(addr);
> > > @@ -97,25 +102,27 @@ struct ifcvf_hw {
> > >     u8 __iomem *isr;
> > >     /* Live migration */
> > >     u8 __iomem *lm_cfg;
> > > -   u16 nr_vring;
> >
> >
> > Any reason for moving nv_vring, config_size, and other stuffs?
> >
> >
> > >     /* Notification bar number */
> > >     u8 notify_bar;
> > > +   u8 msix_vector_status;
> > > +   /* virtio-net or virtio-blk device config size */
> > > +   u32 config_size;
> > >     /* Notificaiton bar address */
> > >     void __iomem *notify_base;
> > >     phys_addr_t notify_base_pa;
> > >     u32 notify_off_multiplier;
> > > +   u32 dev_type;
> > >     u64 req_features;
> > >     u64 hw_features;
> > > -   u32 dev_type;
> > >     struct virtio_pci_common_cfg __iomem *common_cfg;
> > >     void __iomem *dev_cfg;
> > >     struct vring_info vring[IFCVF_MAX_QUEUES];
> > >     void __iomem * const *base;
> > >     char config_msix_name[256];
> > >     struct vdpa_callback config_cb;
> > > -   unsigned int config_irq;
> > > -   /* virtio-net or virtio-blk device config size */
> > > -   u32 config_size;
> > > +   int config_irq;
> > > +   int vqs_shared_irq;
> > > +   u16 nr_vring;
> > >   };
> > >   struct ifcvf_adapter {
> > > @@ -160,4 +167,6 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 q=
id, u16 num);
> > >   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
> > >   int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
> > >   u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
> > > +int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
> > > +int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
> > >   #endif /* _IFCVF_H_ */
> > > diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifc=
vf_main.c
> > > index 44c89ab0b6da..ca414399f040 100644
> > > --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> > > +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> > > @@ -17,6 +17,7 @@
> > >   #define DRIVER_AUTHOR   "Intel Corporation"
> > >   #define IFCVF_DRIVER_NAME       "ifcvf"
> > > +/* handles config interrupt */
> >
> >
> > This seems unrelated to the shared IRQ logic and it looks useless since=
 it's
> > easily to deduce it from the function name below.
> >
> >
> > >   static irqreturn_t ifcvf_config_changed(int irq, void *arg)
> > >   {
> > >     struct ifcvf_hw *vf =3D arg;
> > > @@ -27,6 +28,7 @@ static irqreturn_t ifcvf_config_changed(int irq, vo=
id *arg)
> > >     return IRQ_HANDLED;
> > >   }
> > > +/* handles vqs interrupt */
> >
> >
> > So did this.
> >
> >
> > >   static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
> > >   {
> > >     struct vring_info *vring =3D arg;
> > > @@ -37,24 +39,78 @@ static irqreturn_t ifcvf_intr_handler(int irq, vo=
id *arg)
> > >     return IRQ_HANDLED;
> > >   }
> > > +/* handls vqs shared interrupt */
> > > +static irqreturn_t ifcvf_vq_shared_intr_handler(int irq, void *arg)
> > > +{
> > > +   struct ifcvf_hw *vf =3D arg;
> > > +   struct vring_info *vring;
> > > +   int i;
> > > +
> > > +   for (i =3D 0; i < vf->nr_vring; i++) {
> > > +           vring =3D &vf->vring[i];
> > > +           if (vring->cb.callback)
> > > +                   vf->vring->cb.callback(vring->cb.private);
> > > +   }
> > > +
> > > +   return IRQ_HANDLED;
> > > +}
> > > +
> > > +/* handles a shared interrupt for vqs and config */
> > > +static irqreturn_t ifcvf_dev_shared_intr_handler(int irq, void *arg)
>
> shared is not a good name given IRQ_SHARED is not set.
> maybe "common"? "reused"?
>
> > > +{
> > > +   struct ifcvf_hw *vf =3D arg;
> > > +   u8 isr;
> > > +
> > > +   isr =3D ifc_ioread8(vf->isr);
> >
> >
> > We need to exactly what vp_interrupt do here. Checking against vf->isr =
first
> > and return IRQ_NONE if it is not set.
>
> no, vf->isr is not set for VQ interrupts.

I actually wonder what's the actual behaviour of IFCVF.

> If need to actually poke
> at the VQ to know.
>
> > Always return IRQ_HANDLED will break the device who shares an irq with
> > IFCVF.
>
>
> It's a MSI, not INT#. So interrupt is not shared as such - it's only
> sharing vector between config and vq.

Right, I thought it was a shared one as virito_pci did.

>
>
> >
> > > +   if (isr & VIRTIO_PCI_ISR_CONFIG)
> > > +           ifcvf_config_changed(irq, arg);
> > > +
> > > +   return ifcvf_vq_shared_intr_handler(irq, arg);
> > > +}
> > > +
> > >   static void ifcvf_free_irq_vectors(void *data)
> > >   {
> > >     pci_free_irq_vectors(data);
> > >   }
> > > -static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues=
)
> > > +static void ifcvf_free_vq_irq(struct ifcvf_adapter *adapter, int que=
ues)
> > >   {
> > >     struct pci_dev *pdev =3D adapter->pdev;
> > >     struct ifcvf_hw *vf =3D &adapter->vf;
> > >     int i;
> > > +   if (vf->msix_vector_status =3D=3D MSIX_VECTOR_PER_VQ_AND_CONFIG) =
{
> > > +           for (i =3D 0; i < queues; i++) {
> > > +                   devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->=
vring[i]);
> > > +                   vf->vring[i].irq =3D -EINVAL;
> > > +           }
> > > +   } else {
> > > +           devm_free_irq(&pdev->dev, vf->vqs_shared_irq, vf);
> > > +           vf->vqs_shared_irq =3D -EINVAL;
> > > +   }
> > > +}
> > > -   for (i =3D 0; i < queues; i++) {
> > > -           devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]=
);
> > > -           vf->vring[i].irq =3D -EINVAL;
> > > +static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
> > > +{
> > > +   struct pci_dev *pdev =3D adapter->pdev;
> > > +   struct ifcvf_hw *vf =3D &adapter->vf;
> > > +
> > > +   /* If the irq is shared by all vqs and the config interrupt,
> > > +    * it is already freed in ifcvf_free_vq_irq, so here only
> > > +    * need to free config irq when msix_vector_status !=3D MSIX_VECT=
OR_DEV_SHARED
> > > +    */
> > > +   if (vf->msix_vector_status !=3D MSIX_VECTOR_DEV_SHARED) {
> > > +           devm_free_irq(&pdev->dev, vf->config_irq, vf);
> > > +           vf->config_irq =3D -EINVAL;
> > >     }
> > > +}
> > > +
> > > +static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues=
)
> > > +{
> > > +   struct pci_dev *pdev =3D adapter->pdev;
> > > -   devm_free_irq(&pdev->dev, vf->config_irq, vf);
> > > +   ifcvf_free_vq_irq(adapter, queues);
> > > +   ifcvf_free_config_irq(adapter);
> > >     ifcvf_free_irq_vectors(pdev);
> > >   }
> > > @@ -86,58 +142,172 @@ static int ifcvf_alloc_vectors(struct ifcvf_ada=
pter *adapter)
> > >     return ret;
> > >   }
> > > -static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
> > > +static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
> > >   {
> > >     struct pci_dev *pdev =3D adapter->pdev;
> > >     struct ifcvf_hw *vf =3D &adapter->vf;
> > > -   int vector, nvectors, i, ret, irq;
> > > -   u16 max_intr;
> > > +   int i, vector, ret, irq;
> > > -   nvectors =3D ifcvf_alloc_vectors(adapter);
> > > -   if (!(nvectors > 0))
> > > -           return nvectors;
> > > +   for (i =3D 0; i < vf->nr_vring; i++) {
> > > +           snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n", p=
ci_name(pdev), i);
> > > +           vector =3D i;
> > > +           irq =3D pci_irq_vector(pdev, vector);
> > > +           ret =3D devm_request_irq(&pdev->dev, irq,
> > > +                                  ifcvf_intr_handler, 0,
> > > +                                  vf->vring[i].msix_name,
> > > +                                  &vf->vring[i]);
> > > +           if (ret) {
> > > +                   IFCVF_ERR(pdev, "Failed to request irq for vq %d\=
n", i);
> > > +                   ifcvf_free_vq_irq(adapter, i);
> > > +           } else {
> > > +                   vf->vring[i].irq =3D irq;
> > > +                   ifcvf_set_vq_vector(vf, i, vector);
> > > +           }
> > > +   }
> > > -   max_intr =3D vf->nr_vring + 1;
> > > +   vf->vqs_shared_irq =3D -EINVAL;
> > > +
> > > +   return 0;
> > > +}
> > > +
> > > +static int ifcvf_request_shared_vq_irq(struct ifcvf_adapter *adapter=
)
> > > +{
> > > +   struct pci_dev *pdev =3D adapter->pdev;
> > > +   struct ifcvf_hw *vf =3D &adapter->vf;
> > > +   int i, vector, ret, irq;
> > > +
> > > +   vector =3D 0;
> > > +   /* reuse msix_name[256] space of vring0 to store shared vqs inter=
rupt name */
> >
> >
> > I think we can remove this comment since the code is straightforward.
> >
> >
> > > +   snprintf(vf->vring[0].msix_name, 256, "ifcvf[%s]-vqs-shared-irq\n=
", pci_name(pdev));
> > > +   irq =3D pci_irq_vector(pdev, vector);
> > > +   ret =3D devm_request_irq(&pdev->dev, irq,
> > > +                          ifcvf_vq_shared_intr_handler, 0,
> > > +                          vf->vring[0].msix_name, vf);
> > > +   if (ret) {
> > > +           IFCVF_ERR(pdev, "Failed to request shared irq for vf\n");
> > > +
> > > +           return ret;
> > > +   }
> > > +
> > > +   vf->vqs_shared_irq =3D irq;
> > > +   for (i =3D 0; i < vf->nr_vring; i++) {
> > > +           vf->vring[i].irq =3D -EINVAL;
> > > +           ifcvf_set_vq_vector(vf, i, vector);
> > > +   }
> > > +
> > > +   return 0;
> > > +
> > > +}
> > > +
> > > +static int ifcvf_request_dev_shared_irq(struct ifcvf_adapter *adapte=
r)
> > > +{
> > > +   struct pci_dev *pdev =3D adapter->pdev;
> > > +   struct ifcvf_hw *vf =3D &adapter->vf;
> > > +   int i, vector, ret, irq;
> > > +
> > > +   vector =3D 0;
> > > +   /* reuse msix_name[256] space of vring0 to store shared device in=
terrupt name */
> > > +   snprintf(vf->vring[0].msix_name, 256, "ifcvf[%s]-dev-shared-irq\n=
", pci_name(pdev));
> > > +   irq =3D pci_irq_vector(pdev, vector);
> > > +   ret =3D devm_request_irq(&pdev->dev, irq,
> > > +                          ifcvf_dev_shared_intr_handler, 0,
> > > +                          vf->vring[0].msix_name, vf);
> > > +   if (ret) {
> > > +           IFCVF_ERR(pdev, "Failed to request shared irq for vf\n");
> > > -   ret =3D pci_alloc_irq_vectors(pdev, max_intr,
> > > -                               max_intr, PCI_IRQ_MSIX);
> > > -   if (ret < 0) {
> > > -           IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
> > >             return ret;
> > >     }
> > > +   vf->vqs_shared_irq =3D irq;
> > > +   for (i =3D 0; i < vf->nr_vring; i++) {
> > > +           vf->vring[i].irq =3D -EINVAL;
> > > +           ifcvf_set_vq_vector(vf, i, vector);
> > > +   }
> > > +
> > > +   vf->config_irq =3D irq;
> > > +   ifcvf_set_config_vector(vf, vector);
> > > +
> > > +   return 0;
> > > +
> > > +}
> > > +
> > > +static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter)
> > > +{
> > > +   struct ifcvf_hw *vf =3D &adapter->vf;
> > > +   int ret;
> > > +
> > > +   if (vf->msix_vector_status =3D=3D MSIX_VECTOR_PER_VQ_AND_CONFIG)
> > > +           ret =3D ifcvf_request_per_vq_irq(adapter);
> > > +   else
> > > +           ret =3D ifcvf_request_shared_vq_irq(adapter);
> > > +
> > > +   return ret;
> > > +}
> > > +
> > > +static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
> > > +{
> > > +   struct pci_dev *pdev =3D adapter->pdev;
> > > +   struct ifcvf_hw *vf =3D &adapter->vf;
> > > +   int config_vector, ret;
> > > +
> > > +   if (vf->msix_vector_status =3D=3D MSIX_VECTOR_DEV_SHARED)
> > > +           return 0;
> > > +
> > > +   if (vf->msix_vector_status =3D=3D MSIX_VECTOR_PER_VQ_AND_CONFIG)
> > > +           /* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vect=
or for config interrupt */
> > > +           config_vector =3D vf->nr_vring;
> > > +
> > > +   if (vf->msix_vector_status =3D=3D  MSIX_VECTOR_SHARED_VQ_AND_CONF=
IG)
> > > +           /* vector 0 for vqs and 1 for config interrupt */
> > > +           config_vector =3D 1;
> > > +
> > >     snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
> > >              pci_name(pdev));
> > > -   vector =3D 0;
> > > -   vf->config_irq =3D pci_irq_vector(pdev, vector);
> > > +   vf->config_irq =3D pci_irq_vector(pdev, config_vector);
> > >     ret =3D devm_request_irq(&pdev->dev, vf->config_irq,
> > >                            ifcvf_config_changed, 0,
> > >                            vf->config_msix_name, vf);
> > >     if (ret) {
> > >             IFCVF_ERR(pdev, "Failed to request config irq\n");
> > > +           ifcvf_free_vq_irq(adapter, vf->nr_vring);
> > >             return ret;
> > >     }
> > > -   for (i =3D 0; i < vf->nr_vring; i++) {
> > > -           snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
> > > -                    pci_name(pdev), i);
> > > -           vector =3D i + IFCVF_MSI_QUEUE_OFF;
> > > -           irq =3D pci_irq_vector(pdev, vector);
> > > -           ret =3D devm_request_irq(&pdev->dev, irq,
> > > -                                  ifcvf_intr_handler, 0,
> > > -                                  vf->vring[i].msix_name,
> > > -                                  &vf->vring[i]);
> > > -           if (ret) {
> > > -                   IFCVF_ERR(pdev,
> > > -                             "Failed to request irq for vq %d\n", i)=
;
> > > -                   ifcvf_free_irq(adapter, i);
> > > +   ifcvf_set_config_vector(vf, config_vector);
> > > -                   return ret;
> > > -           }
> > > +   return 0;
> > > +}
> > > +
> > > +static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
> > > +{
> >
> >
> > As replied above, I think having two modes should be sufficient and the=
 code
> > could be greatly simplified.
> >
> > Thanks
> >
>
> Well it is claimed there are platforms where we are short
> on vectors. 3 versus 2 seems a 50% saving. You disagree?

I think we can 2 vectors (a dedicated for config).

Thanks

>
> > > +   struct ifcvf_hw *vf =3D &adapter->vf;
> > > +   int nvectors, ret, max_intr;
> > > -           vf->vring[i].irq =3D irq;
> > > +   nvectors =3D ifcvf_alloc_vectors(adapter);
> > > +   if (!(nvectors > 0))
> > > +           return nvectors;
> > > +
> > > +   vf->msix_vector_status =3D MSIX_VECTOR_PER_VQ_AND_CONFIG;
> > > +   max_intr =3D vf->nr_vring + 1;
> > > +   if (nvectors < max_intr)
> > > +           vf->msix_vector_status =3D MSIX_VECTOR_SHARED_VQ_AND_CONF=
IG;
> > > +
> > > +   if (nvectors =3D=3D 1) {
> > > +           vf->msix_vector_status =3D MSIX_VECTOR_DEV_SHARED;
> > > +           ret =3D ifcvf_request_dev_shared_irq(adapter);
> > > +
> > > +           return ret;
> > >     }
> > > +   ret =3D ifcvf_request_vq_irq(adapter);
> > > +   if (ret)
> > > +           return ret;
> > > +
> > > +   ret =3D ifcvf_request_config_irq(adapter);
> > > +
> > > +   if (ret)
> > > +           return ret;
> > > +
> > >     return 0;
> > >   }
> > > @@ -441,7 +611,10 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_dev=
ice *vdpa_dev,
> > >   {
> > >     struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
> > > -   return vf->vring[qid].irq;
> > > +   if (vf->vqs_shared_irq < 0)
> > > +           return vf->vring[qid].irq;
> > > +   else
> > > +           return -EINVAL;
> > >   }
> > >   static struct vdpa_notification_area ifcvf_get_vq_notification(stru=
ct vdpa_device *vdpa_dev,
>

