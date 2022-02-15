Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951214B61C0
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 04:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiBODgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 22:36:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiBODgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 22:36:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 430C978064
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 19:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644896189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mT8sn2/JQd/WAcVKrrVmw2igR5OmVJPsm5bzsKU3F0I=;
        b=HX6tUsCxFJbi+2UNr3TeEMvFr9/0ucUOBjIZlkVa7gnX18VOfeJlXnbghG0yDRCNWC8gjo
        AeG3eCnmBesFv3+PAA8UQBhO/4Sp/tG9aW+mGWXXKyRmQ+BxFCDQuJUigrXdteD1BuXOvU
        595IQx7Jj6hh9QzgIBPWmIJ2vqZH6Us=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-thwM_JbCMOOBz845XpNVXg-1; Mon, 14 Feb 2022 22:36:28 -0500
X-MC-Unique: thwM_JbCMOOBz845XpNVXg-1
Received: by mail-lj1-f199.google.com with SMTP id o22-20020a05651c051600b00244ea309a54so196958ljp.14
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 19:36:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mT8sn2/JQd/WAcVKrrVmw2igR5OmVJPsm5bzsKU3F0I=;
        b=6UctT3aQEFOwZdLThoJC91t93SMDX12gxLyRU72qRfOEVztCK28isigrrQXa5EYLL1
         hd0bCehlIRLNouWGml3y0ctTPHiGb5z5Tjb293mq2lB2lDWd429Hav2Nt3igdfVyWniB
         Dr9YkoGsjBgkWuri5jkSNH+79VAjdKhmbJlJkGlOgNPoD5sXX9gcO1UPy0xtezvzy8Ln
         bpfq7sHbBSTX6P05IkXSqiZIJHHHsRcNcUfjsepQEkevy717aIdcHBsp90YR5SnxMRDp
         jkIo8mRSS9U0MJbfGMHpV55YKZPw81GcQoWtXUlJzIzMz+MBLPyLraTxVNbrv/9/QKKo
         TEcA==
X-Gm-Message-State: AOAM532KSEnKoYcZ95UPkUM/okPSnPgypAY9jAlxJAbo2d5TAVo3dWBe
        QSd8YA6jK0OEwMhOUeh73YncleeEhN1B2Un5SlZ5I/n2REaj3acziE02dX6bUxh895hS7Ew2aTP
        JVocUkGQ3AuZ2tEpuOIEQZkezU2g9/qBm
X-Received: by 2002:ac2:4437:: with SMTP id w23mr1676364lfl.481.1644896186199;
        Mon, 14 Feb 2022 19:36:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysVpKraeC1lSccZ1wKWrSkfCUUDxbic5PJinNpv+uTPjp7cKK6IeqpkvC3oT9FR6Lcb7skArdUx0ql9QfNdDE=
X-Received: by 2002:ac2:4437:: with SMTP id w23mr1676349lfl.481.1644896185804;
 Mon, 14 Feb 2022 19:36:25 -0800 (PST)
MIME-Version: 1.0
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
 <20220203072735.189716-5-lingshan.zhu@intel.com> <c2036174-22ae-0882-1783-53a5d20a03ad@redhat.com>
 <449aa3a3-06c8-1236-241e-42ea5b7d8877@linux.intel.com> <20220214092558-mutt-send-email-mst@kernel.org>
 <4920887f-0521-9054-035d-32114301ba3a@intel.com> <CACGkMEsW_yaVSW7dBECT1LOUVKapJvcBZeaDRtuwmeZHysfwSA@mail.gmail.com>
 <70ee26d4-9553-543a-ccd9-684f468e2704@intel.com>
In-Reply-To: <70ee26d4-9553-543a-ccd9-684f468e2704@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 15 Feb 2022 11:36:14 +0800
Message-ID: <CACGkMEvZqvYokmJ26KiDhiLMzUW7jCyx2j1BtW_B_ANPSnN5Ug@mail.gmail.com>
Subject: Re: [PATCH V4 4/4] vDPA/ifcvf: implement shared IRQ feature
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@linux.intel.com>,
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

On Tue, Feb 15, 2022 at 11:29 AM Zhu, Lingshan <lingshan.zhu@intel.com> wro=
te:
>
>
>
> On 2/15/2022 11:03 AM, Jason Wang wrote:
> > On Tue, Feb 15, 2022 at 10:18 AM Zhu, Lingshan <lingshan.zhu@intel.com>=
 wrote:
> >>
> >>
> >> On 2/14/2022 10:27 PM, Michael S. Tsirkin wrote:
> >>> On Mon, Feb 14, 2022 at 06:01:56PM +0800, Zhu Lingshan wrote:
> >>>> On 2/14/2022 3:19 PM, Jason Wang wrote:
> >>>>> =E5=9C=A8 2022/2/3 =E4=B8=8B=E5=8D=883:27, Zhu Lingshan =E5=86=99=
=E9=81=93:
> >>>>>> On some platforms/devices, there may not be enough MSI vector
> >>>>>> slots allocated for virtqueues and config changes. In such a case,
> >>>>>> the interrupt sources(virtqueues, config changes) must share
> >>>>>> an IRQ/vector, to avoid initialization failures, keep
> >>>>>> the device functional.
> >>>>>>
> >>>>>> This commit handles three cases:
> >>>>>> (1) number of the allocated vectors =3D=3D the number of virtqueue=
s + 1
> >>>>>> (config changes), every virtqueue and the config interrupt has
> >>>>>> a separated vector/IRQ, the best and the most likely case.
> >>>>>> (2) number of the allocated vectors is less than the best case, bu=
t
> >>>>>> greater than 1. In this case, all virtqueues share a vector/IRQ,
> >>>>>> the config interrupt has a separated vector/IRQ
> >>>>>> (3) only one vector is allocated, in this case, the virtqueues and
> >>>>>> the config interrupt share a vector/IRQ. The worst and most
> >>>>>> unlikely case.
> >>>>>>
> >>>>>> Otherwise, it needs to fail.
> >>>>>>
> >>>>>> This commit introduces some helper functions:
> >>>>>> ifcvf_set_vq_vector() and ifcvf_set_config_vector() sets virtqueue
> >>>>>> vector and config vector in the device config space, so that
> >>>>>> the device can send interrupt DMA.
> >>>>>>
> >>>>>> This commit adds some fields in struct ifcvf_hw and re-placed
> >>>>>> the existed fields to be aligned with the cacheline.
> >>>>>>
> >>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >>>>>> ---
> >>>>>>     drivers/vdpa/ifcvf/ifcvf_base.c |  47 ++++--
> >>>>>>     drivers/vdpa/ifcvf/ifcvf_base.h |  23 ++-
> >>>>>>     drivers/vdpa/ifcvf/ifcvf_main.c | 243 ++++++++++++++++++++++++=
+++-----
> >>>>>>     3 files changed, 256 insertions(+), 57 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c
> >>>>>> b/drivers/vdpa/ifcvf/ifcvf_base.c
> >>>>>> index 397692ae671c..18dcb63ab1e3 100644
> >>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> >>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> >>>>>> @@ -15,6 +15,36 @@ struct ifcvf_adapter *vf_to_adapter(struct
> >>>>>> ifcvf_hw *hw)
> >>>>>>         return container_of(hw, struct ifcvf_adapter, vf);
> >>>>>>     }
> >>>>>>     +int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vec=
tor)
> >>>>>> +{
> >>>>>> +    struct virtio_pci_common_cfg __iomem *cfg =3D hw->common_cfg;
> >>>>>> +    struct ifcvf_adapter *ifcvf =3D vf_to_adapter(hw);
> >>>>>> +
> >>>>>> +    ifc_iowrite16(qid, &cfg->queue_select);
> >>>>>> +    ifc_iowrite16(vector, &cfg->queue_msix_vector);
> >>>>>> +    if (ifc_ioread16(&cfg->queue_msix_vector) =3D=3D
> >>>>>> VIRTIO_MSI_NO_VECTOR) {
> >>>>>> +        IFCVF_ERR(ifcvf->pdev, "No msix vector for queue %u\n", q=
id);
> >>>>>> +            return -EINVAL;
> >>>>>> +    }
> >>>>> Let's leave this check for the caller, E.g can caller try to assign
> >>>>> NO_VECTOR during uni-nit?
> >>>> ifcvf driver sets NO_VECTOR when call hw_disable(). I am not sure wh=
ether I
> >>>> get it,
> > I meant you invent the ifcvf_set_vq_vector() you'd better use that in
> > hw_disable() as well.
> OK
> >
> >>>> Yes we can let the caller check a vq vector, however this may cause =
more
> >>>> than three levels brackets, may looks ugly.
> > I don't understand here, this is how virito_pci did:
> >
> > /*
> >   * vp_modern_queue_vector - set the MSIX vector for a specific virtque=
ue
> >   * @mdev: the modern virtio-pci device
> >   * @index: queue index
> >   * @vector: the config vector
> >   *
> >   * Returns the config vector read from the device
> >   */
> > u16 vp_modern_queue_vector(struct virtio_pci_modern_device *mdev,
> >                             u16 index, u16 vector)
> > {
> >          struct virtio_pci_common_cfg __iomem *cfg =3D mdev->common;
> >
> >          vp_iowrite16(index, &cfg->queue_select);
> >          vp_iowrite16(vector, &cfg->queue_msix_vector);
> >          /* Flush the write out to device */
> >          return vp_ioread16(&cfg->queue_msix_vector);
> > }
> > EXPORT_SYMBOL_GPL(vp_modern_queue_vector);
> I mean if we leave the checks for the caller, it may look like:
> +       for (i =3D 0; i < vf->nr_vring; i++) {
> +               snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
> pci_name(pdev), i);
> +               vector =3D i;
> +               irq =3D pci_irq_vector(pdev, vector);
> +               ret =3D devm_request_irq(&pdev->dev, irq,
> +                                      ifcvf_intr_handler, 0,
> +                                      vf->vring[i].msix_name,
> +                                      &vf->vring[i]);
> +               if (ret) {
> +                       IFCVF_ERR(pdev, "Failed to request irq for vq
> %d\n", i);
> +                       ifcvf_free_vq_irq(adapter, i);
> +               } else {
> +                       vf->vring[i].irq =3D irq;
> +                       ifcvf_set_vq_vector(vf, i, vector);
>                              if (xxxxx) {
>                                  xxxxxxxxxxx;
>                              }
> +               }
> +       }

If the brackets are the only concern, you can factor out the per vq
logic into a dedicated function.

Thanks

>
> Too many brackets.
> >
> >>>>>> +
> >>>>>> +    return 0;
> >>>>>> +}
> >>>>>> +
> >>>>>> +int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector)
> >>>>>> +{
> >>>>>> +    struct virtio_pci_common_cfg __iomem *cfg =3D hw->common_cfg;
> >>>>>> +    struct ifcvf_adapter *ifcvf =3D vf_to_adapter(hw);
> >>>>>> +
> >>>>>> +    cfg =3D hw->common_cfg;
> >>>>>> +    ifc_iowrite16(vector,  &cfg->msix_config);
> >>>>>> +    if (ifc_ioread16(&cfg->msix_config) =3D=3D VIRTIO_MSI_NO_VECT=
OR) {
> >>>>>> +        IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\=
n");
> >>>>>> +        return -EINVAL;
> >>>>>> +    }
> >>>>> Similar question as above.
> >>>>>
> >>>>>
> >>>>>> +
> >>>>>> +    return 0;
> >>>>>> +}
> >>>>>> +
> >>>>>>     static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
> >>>>>>                       struct virtio_pci_cap *cap)
> >>>>>>     {
> >>>>>> @@ -140,6 +170,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct
> >>>>>> pci_dev *pdev)
> >>>>>>               hw->common_cfg, hw->notify_base, hw->isr,
> >>>>>>               hw->dev_cfg, hw->notify_off_multiplier);
> >>>>>>     +    hw->vqs_shared_irq =3D -EINVAL;
> >>>>>> +
> >>>>>>         return 0;
> >>>>>>     }
> >>>>>>     @@ -321,12 +353,6 @@ static int ifcvf_hw_enable(struct ifcvf_h=
w *hw)
> >>>>>>           ifcvf =3D vf_to_adapter(hw);
> >>>>>>         cfg =3D hw->common_cfg;
> >>>>>> -    ifc_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
> >>>>>> -
> >>>>>> -    if (ifc_ioread16(&cfg->msix_config) =3D=3D VIRTIO_MSI_NO_VECT=
OR) {
> >>>>>> -        IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\=
n");
> >>>>>> -        return -EINVAL;
> >>>>>> -    }
> >>>>>>           for (i =3D 0; i < hw->nr_vring; i++) {
> >>>>>>             if (!hw->vring[i].ready)
> >>>>>> @@ -340,15 +366,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *h=
w)
> >>>>>>             ifc_iowrite64_twopart(hw->vring[i].used, &cfg->queue_u=
sed_lo,
> >>>>>>                          &cfg->queue_used_hi);
> >>>>>>             ifc_iowrite16(hw->vring[i].size, &cfg->queue_size);
> >>>>>> -        ifc_iowrite16(i + IFCVF_MSI_QUEUE_OFF,
> >>>>>> &cfg->queue_msix_vector);
> >>>>>> -
> >>>>>> -        if (ifc_ioread16(&cfg->queue_msix_vector) =3D=3D
> >>>>>> -            VIRTIO_MSI_NO_VECTOR) {
> >>>>>> -            IFCVF_ERR(ifcvf->pdev,
> >>>>>> -                  "No msix vector for queue %u\n", i);
> >>>>>> -            return -EINVAL;
> >>>>>> -        }
> >>>>>> -
> >>>>>>             ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx)=
;
> >>>>>>             ifc_iowrite16(1, &cfg->queue_enable);
> >>>>>>         }
> >>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h
> >>>>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
> >>>>>> index 949b4fb9d554..9cfe088c82e9 100644
> >>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> >>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> >>>>>> @@ -27,8 +27,6 @@
> >>>>>>       #define IFCVF_QUEUE_ALIGNMENT    PAGE_SIZE
> >>>>>>     #define IFCVF_QUEUE_MAX        32768
> >>>>>> -#define IFCVF_MSI_CONFIG_OFF    0
> >>>>>> -#define IFCVF_MSI_QUEUE_OFF    1
> >>>>>>     #define IFCVF_PCI_MAX_RESOURCE    6
> >>>>>>       #define IFCVF_LM_CFG_SIZE        0x40
> >>>>>> @@ -42,6 +40,13 @@
> >>>>>>     #define ifcvf_private_to_vf(adapter) \
> >>>>>>         (&((struct ifcvf_adapter *)adapter)->vf)
> >>>>>>     +/* all vqs and config interrupt has its own vector */
> >>>>>> +#define MSIX_VECTOR_PER_VQ_AND_CONFIG        1
> >>>>>> +/* all vqs share a vector, and config interrupt has a separate
> >>>>>> vector */
> >>>>>> +#define MSIX_VECTOR_SHARED_VQ_AND_CONFIG    2
> >>>>>> +/* all vqs and config interrupt share a vector */
> >>>>>> +#define MSIX_VECTOR_DEV_SHARED            3
> >>>>> I think there's no much value to differ 2 from 3 consider config
> >>>>> interrupt should be rare.
> >>>> IMHO we still need 2 and 3, because MSIX_VECTOR_SHARED_VQ_AND_CONFIG=
 means
> >>>> there are at least 2 vectors,
> >>>> the vqs share one vector, config change has its own vector.
> > I want to know the value of having a dedicated vector for config?
> I think a dedicated vector for config changes can help us avoid
> operations on config space when vq interrupt triggered.
> >
> >>>> MSIX_VECTOR_DEV_SHARED means three are only one vector, all vqs and =
config
> >>>> changes need to share this vector.
> >>>>>
> >>>>>> +
> >>>>>>     static inline u8 ifc_ioread8(u8 __iomem *addr)
> >>>>>>     {
> >>>>>>         return ioread8(addr);
> >>>>>> @@ -97,25 +102,27 @@ struct ifcvf_hw {
> >>>>>>         u8 __iomem *isr;
> >>>>>>         /* Live migration */
> >>>>>>         u8 __iomem *lm_cfg;
> >>>>>> -    u16 nr_vring;
> >>>>> Any reason for moving nv_vring, config_size, and other stuffs?
> >>>> for cacheline alignment.
> >>> maybe a separate patch then.
> >> Sure
> >>
> >> Thanks!
> >>>>>
> >>>>>>         /* Notification bar number */
> >>>>>>         u8 notify_bar;
> >>>>>> +    u8 msix_vector_status;
> >>>>>> +    /* virtio-net or virtio-blk device config size */
> >>>>>> +    u32 config_size;
> >>>>>>         /* Notificaiton bar address */
> >>>>>>         void __iomem *notify_base;
> >>>>>>         phys_addr_t notify_base_pa;
> >>>>>>         u32 notify_off_multiplier;
> >>>>>> +    u32 dev_type;
> >>>>>>         u64 req_features;
> >>>>>>         u64 hw_features;
> >>>>>> -    u32 dev_type;
> >>>>>>         struct virtio_pci_common_cfg __iomem *common_cfg;
> >>>>>>         void __iomem *dev_cfg;
> >>>>>>         struct vring_info vring[IFCVF_MAX_QUEUES];
> >>>>>>         void __iomem * const *base;
> >>>>>>         char config_msix_name[256];
> >>>>>>         struct vdpa_callback config_cb;
> >>>>>> -    unsigned int config_irq;
> >>>>>> -    /* virtio-net or virtio-blk device config size */
> >>>>>> -    u32 config_size;
> >>>>>> +    int config_irq;
> >>>>>> +    int vqs_shared_irq;
> >>>>>> +    u16 nr_vring;
> >>>>>>     };
> >>>>>>       struct ifcvf_adapter {
> >>>>>> @@ -160,4 +167,6 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u1=
6
> >>>>>> qid, u16 num);
> >>>>>>     struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
> >>>>>>     int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
> >>>>>>     u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
> >>>>>> +int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)=
;
> >>>>>> +int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
> >>>>>>     #endif /* _IFCVF_H_ */
> >>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c
> >>>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
> >>>>>> index 44c89ab0b6da..ca414399f040 100644
> >>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> >>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> >>>>>> @@ -17,6 +17,7 @@
> >>>>>>     #define DRIVER_AUTHOR   "Intel Corporation"
> >>>>>>     #define IFCVF_DRIVER_NAME       "ifcvf"
> >>>>>>     +/* handles config interrupt */
> >>>>> This seems unrelated to the shared IRQ logic and it looks useless s=
ince
> >>>>> it's easily to deduce it from the function name below.
> >>>> OK, do you mean the comments? I can remove these comments.
> > Yes.
> >
> >>>>>>     static irqreturn_t ifcvf_config_changed(int irq, void *arg)
> >>>>>>     {
> >>>>>>         struct ifcvf_hw *vf =3D arg;
> >>>>>> @@ -27,6 +28,7 @@ static irqreturn_t ifcvf_config_changed(int irq,
> >>>>>> void *arg)
> >>>>>>         return IRQ_HANDLED;
> >>>>>>     }
> >>>>>>     +/* handles vqs interrupt */
> >>>>> So did this.
> >>>>>
> >>>>>
> >>>>>>     static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
> >>>>>>     {
> >>>>>>         struct vring_info *vring =3D arg;
> >>>>>> @@ -37,24 +39,78 @@ static irqreturn_t ifcvf_intr_handler(int irq,
> >>>>>> void *arg)
> >>>>>>         return IRQ_HANDLED;
> >>>>>>     }
> >>>>>>     +/* handls vqs shared interrupt */
> >>>>>> +static irqreturn_t ifcvf_vq_shared_intr_handler(int irq, void *ar=
g)
> >>>>>> +{
> >>>>>> +    struct ifcvf_hw *vf =3D arg;
> >>>>>> +    struct vring_info *vring;
> >>>>>> +    int i;
> >>>>>> +
> >>>>>> +    for (i =3D 0; i < vf->nr_vring; i++) {
> >>>>>> +        vring =3D &vf->vring[i];
> >>>>>> +        if (vring->cb.callback)
> >>>>>> + vf->vring->cb.callback(vring->cb.private);
> >>>>>> +    }
> >>>>>> +
> >>>>>> +    return IRQ_HANDLED;
> >>>>>> +}
> >>>>>> +
> >>>>>> +/* handles a shared interrupt for vqs and config */
> >>>>>> +static irqreturn_t ifcvf_dev_shared_intr_handler(int irq, void *a=
rg)
> >>>>>> +{
> >>>>>> +    struct ifcvf_hw *vf =3D arg;
> >>>>>> +    u8 isr;
> >>>>>> +
> >>>>>> +    isr =3D ifc_ioread8(vf->isr);
> >>>>> We need to exactly what vp_interrupt do here. Checking against vf->=
isr
> >>>>> first and return IRQ_NONE if it is not set.
> >>>>>
> >>>>> Always return IRQ_HANDLED will break the device who shares an irq w=
ith
> >>>>> IFCVF.
> >>>> as we discussed in another thread(spec inconsistency about ISR), ISR=
 may
> >>>> only works for INTx for now,
> >>>> but VFs don't have INTx, and a VF may not share its vectors with oth=
er
> >>>> devices, so I guess it can work
> >>>> and may be our best try for now.
> > Right, I thought you're using shared irq but actually not.
> >
> >>>>>> +    if (isr & VIRTIO_PCI_ISR_CONFIG)
> >>>>>> +        ifcvf_config_changed(irq, arg);
> > I wonder how ISR works in IFCVF, if ISR doesn't work for MSI, we need
> > to remove the check of isr otherwise we will break config interrupt?
> >
> >>>>>> +
> >>>>>> +    return ifcvf_vq_shared_intr_handler(irq, arg);
> >>>>>> +}
> >>>>>> +
> >>>>>>     static void ifcvf_free_irq_vectors(void *data)
> >>>>>>     {
> >>>>>>         pci_free_irq_vectors(data);
> >>>>>>     }
> >>>>>>     -static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int=
 queues)
> >>>>>> +static void ifcvf_free_vq_irq(struct ifcvf_adapter *adapter, int
> >>>>>> queues)
> >>>>>>     {
> >>>>>>         struct pci_dev *pdev =3D adapter->pdev;
> >>>>>>         struct ifcvf_hw *vf =3D &adapter->vf;
> >>>>>>         int i;
> >>>>>>     +    if (vf->msix_vector_status =3D=3D MSIX_VECTOR_PER_VQ_AND_=
CONFIG) {
> >>>>>> +        for (i =3D 0; i < queues; i++) {
> >>>>>> +            devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vrin=
g[i]);
> >>>>>> +            vf->vring[i].irq =3D -EINVAL;
> >>>>>> +        }
> >>>>>> +    } else {
> >>>>>> +        devm_free_irq(&pdev->dev, vf->vqs_shared_irq, vf);
> >>>>>> +        vf->vqs_shared_irq =3D -EINVAL;
> >>>>>> +    }
> >>>>>> +}
> >>>>>>     -    for (i =3D 0; i < queues; i++) {
> >>>>>> -        devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]=
);
> >>>>>> -        vf->vring[i].irq =3D -EINVAL;
> >>>>>> +static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
> >>>>>> +{
> >>>>>> +    struct pci_dev *pdev =3D adapter->pdev;
> >>>>>> +    struct ifcvf_hw *vf =3D &adapter->vf;
> >>>>>> +
> >>>>>> +    /* If the irq is shared by all vqs and the config interrupt,
> >>>>>> +     * it is already freed in ifcvf_free_vq_irq, so here only
> >>>>>> +     * need to free config irq when msix_vector_status !=3D
> >>>>>> MSIX_VECTOR_DEV_SHARED
> >>>>>> +     */
> >>>>>> +    if (vf->msix_vector_status !=3D MSIX_VECTOR_DEV_SHARED) {
> >>>>>> +        devm_free_irq(&pdev->dev, vf->config_irq, vf);
> >>>>>> +        vf->config_irq =3D -EINVAL;
> >>>>>>         }
> >>>>>> +}
> >>>>>> +
> >>>>>> +static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int que=
ues)
> >>>>>> +{
> >>>>>> +    struct pci_dev *pdev =3D adapter->pdev;
> >>>>>>     -    devm_free_irq(&pdev->dev, vf->config_irq, vf);
> >>>>>> +    ifcvf_free_vq_irq(adapter, queues);
> >>>>>> +    ifcvf_free_config_irq(adapter);
> >>>>>>         ifcvf_free_irq_vectors(pdev);
> >>>>>>     }
> >>>>>>     @@ -86,58 +142,172 @@ static int ifcvf_alloc_vectors(struct
> >>>>>> ifcvf_adapter *adapter)
> >>>>>>         return ret;
> >>>>>>     }
> >>>>>>     -static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
> >>>>>> +static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter=
)
> >>>>>>     {
> >>>>>>         struct pci_dev *pdev =3D adapter->pdev;
> >>>>>>         struct ifcvf_hw *vf =3D &adapter->vf;
> >>>>>> -    int vector, nvectors, i, ret, irq;
> >>>>>> -    u16 max_intr;
> >>>>>> +    int i, vector, ret, irq;
> >>>>>>     -    nvectors =3D ifcvf_alloc_vectors(adapter);
> >>>>>> -    if (!(nvectors > 0))
> >>>>>> -        return nvectors;
> >>>>>> +    for (i =3D 0; i < vf->nr_vring; i++) {
> >>>>>> +        snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
> >>>>>> pci_name(pdev), i);
> >>>>>> +        vector =3D i;
> >>>>>> +        irq =3D pci_irq_vector(pdev, vector);
> >>>>>> +        ret =3D devm_request_irq(&pdev->dev, irq,
> >>>>>> +                       ifcvf_intr_handler, 0,
> >>>>>> +                       vf->vring[i].msix_name,
> >>>>>> +                       &vf->vring[i]);
> >>>>>> +        if (ret) {
> >>>>>> +            IFCVF_ERR(pdev, "Failed to request irq for vq %d\n", =
i);
> >>>>>> +            ifcvf_free_vq_irq(adapter, i);
> >>>>>> +        } else {
> >>>>>> +            vf->vring[i].irq =3D irq;
> >>>>>> +            ifcvf_set_vq_vector(vf, i, vector);
> >>>>>> +        }
> >>>>>> +    }
> >>>>>>     -    max_intr =3D vf->nr_vring + 1;
> >>>>>> +    vf->vqs_shared_irq =3D -EINVAL;
> >>>>>> +
> >>>>>> +    return 0;
> >>>>>> +}
> >>>>>> +
> >>>>>> +static int ifcvf_request_shared_vq_irq(struct ifcvf_adapter *adap=
ter)
> >>>>>> +{
> >>>>>> +    struct pci_dev *pdev =3D adapter->pdev;
> >>>>>> +    struct ifcvf_hw *vf =3D &adapter->vf;
> >>>>>> +    int i, vector, ret, irq;
> >>>>>> +
> >>>>>> +    vector =3D 0;
> >>>>>> +    /* reuse msix_name[256] space of vring0 to store shared vqs
> >>>>>> interrupt name */
> >>>>> I think we can remove this comment since the code is straightforwar=
d.
> >>>> sure
> >>>>>> + snprintf(vf->vring[0].msix_name, 256,
> >>>>>> "ifcvf[%s]-vqs-shared-irq\n", pci_name(pdev));
> >>>>>> +    irq =3D pci_irq_vector(pdev, vector);
> >>>>>> +    ret =3D devm_request_irq(&pdev->dev, irq,
> >>>>>> +                   ifcvf_vq_shared_intr_handler, 0,
> >>>>>> +                   vf->vring[0].msix_name, vf);
> >>>>>> +    if (ret) {
> >>>>>> +        IFCVF_ERR(pdev, "Failed to request shared irq for vf\n");
> >>>>>> +
> >>>>>> +        return ret;
> >>>>>> +    }
> >>>>>> +
> >>>>>> +    vf->vqs_shared_irq =3D irq;
> >>>>>> +    for (i =3D 0; i < vf->nr_vring; i++) {
> >>>>>> +        vf->vring[i].irq =3D -EINVAL;
> >>>>>> +        ifcvf_set_vq_vector(vf, i, vector);
> >>>>>> +    }
> >>>>>> +
> >>>>>> +    return 0;
> >>>>>> +
> >>>>>> +}
> >>>>>> +
> >>>>>> +static int ifcvf_request_dev_shared_irq(struct ifcvf_adapter *ada=
pter)
> >>>>>> +{
> >>>>>> +    struct pci_dev *pdev =3D adapter->pdev;
> >>>>>> +    struct ifcvf_hw *vf =3D &adapter->vf;
> >>>>>> +    int i, vector, ret, irq;
> >>>>>> +
> >>>>>> +    vector =3D 0;
> >>>>>> +    /* reuse msix_name[256] space of vring0 to store shared devic=
e
> >>>>>> interrupt name */
> >>>>>> +    snprintf(vf->vring[0].msix_name, 256,
> >>>>>> "ifcvf[%s]-dev-shared-irq\n", pci_name(pdev));
> >>>>>> +    irq =3D pci_irq_vector(pdev, vector);
> >>>>>> +    ret =3D devm_request_irq(&pdev->dev, irq,
> >>>>>> +                   ifcvf_dev_shared_intr_handler, 0,
> >>>>>> +                   vf->vring[0].msix_name, vf);
> >>>>>> +    if (ret) {
> >>>>>> +        IFCVF_ERR(pdev, "Failed to request shared irq for vf\n");
> >>>>>>     -    ret =3D pci_alloc_irq_vectors(pdev, max_intr,
> >>>>>> -                    max_intr, PCI_IRQ_MSIX);
> >>>>>> -    if (ret < 0) {
> >>>>>> -        IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
> >>>>>>             return ret;
> >>>>>>         }
> >>>>>>     +    vf->vqs_shared_irq =3D irq;
> >>>>>> +    for (i =3D 0; i < vf->nr_vring; i++) {
> >>>>>> +        vf->vring[i].irq =3D -EINVAL;
> >>>>>> +        ifcvf_set_vq_vector(vf, i, vector);
> >>>>>> +    }
> >>>>>> +
> >>>>>> +    vf->config_irq =3D irq;
> >>>>>> +    ifcvf_set_config_vector(vf, vector);
> >>>>>> +
> >>>>>> +    return 0;
> >>>>>> +
> >>>>>> +}
> >>>>>> +
> >>>>>> +static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter)
> >>>>>> +{
> >>>>>> +    struct ifcvf_hw *vf =3D &adapter->vf;
> >>>>>> +    int ret;
> >>>>>> +
> >>>>>> +    if (vf->msix_vector_status =3D=3D MSIX_VECTOR_PER_VQ_AND_CONF=
IG)
> >>>>>> +        ret =3D ifcvf_request_per_vq_irq(adapter);
> >>>>>> +    else
> >>>>>> +        ret =3D ifcvf_request_shared_vq_irq(adapter);
> >>>>>> +
> >>>>>> +    return ret;
> >>>>>> +}
> >>>>>> +
> >>>>>> +static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter=
)
> >>>>>> +{
> >>>>>> +    struct pci_dev *pdev =3D adapter->pdev;
> >>>>>> +    struct ifcvf_hw *vf =3D &adapter->vf;
> >>>>>> +    int config_vector, ret;
> >>>>>> +
> >>>>>> +    if (vf->msix_vector_status =3D=3D MSIX_VECTOR_DEV_SHARED)
> >>>>>> +        return 0;
> >>>>>> +
> >>>>>> +    if (vf->msix_vector_status =3D=3D MSIX_VECTOR_PER_VQ_AND_CONF=
IG)
> >>>>>> +        /* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vect=
or
> >>>>>> for config interrupt */
> >>>>>> +        config_vector =3D vf->nr_vring;
> >>>>>> +
> >>>>>> +    if (vf->msix_vector_status =3D=3D MSIX_VECTOR_SHARED_VQ_AND_C=
ONFIG)
> >>>>>> +        /* vector 0 for vqs and 1 for config interrupt */
> >>>>>> +        config_vector =3D 1;
> >>>>>> +
> >>>>>>         snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
> >>>>>>              pci_name(pdev));
> >>>>>> -    vector =3D 0;
> >>>>>> -    vf->config_irq =3D pci_irq_vector(pdev, vector);
> >>>>>> +    vf->config_irq =3D pci_irq_vector(pdev, config_vector);
> >>>>>>         ret =3D devm_request_irq(&pdev->dev, vf->config_irq,
> >>>>>>                        ifcvf_config_changed, 0,
> >>>>>>                        vf->config_msix_name, vf);
> >>>>>>         if (ret) {
> >>>>>>             IFCVF_ERR(pdev, "Failed to request config irq\n");
> >>>>>> +        ifcvf_free_vq_irq(adapter, vf->nr_vring);
> >>>>>>             return ret;
> >>>>>>         }
> >>>>>>     -    for (i =3D 0; i < vf->nr_vring; i++) {
> >>>>>> -        snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
> >>>>>> -             pci_name(pdev), i);
> >>>>>> -        vector =3D i + IFCVF_MSI_QUEUE_OFF;
> >>>>>> -        irq =3D pci_irq_vector(pdev, vector);
> >>>>>> -        ret =3D devm_request_irq(&pdev->dev, irq,
> >>>>>> -                       ifcvf_intr_handler, 0,
> >>>>>> -                       vf->vring[i].msix_name,
> >>>>>> -                       &vf->vring[i]);
> >>>>>> -        if (ret) {
> >>>>>> -            IFCVF_ERR(pdev,
> >>>>>> -                  "Failed to request irq for vq %d\n", i);
> >>>>>> -            ifcvf_free_irq(adapter, i);
> >>>>>> +    ifcvf_set_config_vector(vf, config_vector);
> >>>>>>     -            return ret;
> >>>>>> -        }
> >>>>>> +    return 0;
> >>>>>> +}
> >>>>>> +
> >>>>>> +static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
> >>>>>> +{
> >>>>> As replied above, I think having two modes should be sufficient and=
 the
> >>>>> code could be greatly simplified.
> >>>> Do you mean if we don't get enough vectors, just use only one vector=
 for the
> >>>> vqs and config changes? I guess this
> >>>> only works if ISR work for MSIX as we expects, or we may waste some =
time in
> >>>> the device config space.
> > Ok, I think I got you here. It's better to document this in the change =
log.
> >
> > Thanks
> >
> >>>> Thanks,
> >>>> Zhu Lingshan
> >>>>> Thanks
> >>>>>
> >>>>>
> >>>>>> +    struct ifcvf_hw *vf =3D &adapter->vf;
> >>>>>> +    int nvectors, ret, max_intr;
> >>>>>>     -        vf->vring[i].irq =3D irq;
> >>>>>> +    nvectors =3D ifcvf_alloc_vectors(adapter);
> >>>>>> +    if (!(nvectors > 0))
> >>>>>> +        return nvectors;
> >>>>>> +
> >>>>>> +    vf->msix_vector_status =3D MSIX_VECTOR_PER_VQ_AND_CONFIG;
> >>>>>> +    max_intr =3D vf->nr_vring + 1;
> >>>>>> +    if (nvectors < max_intr)
> >>>>>> +        vf->msix_vector_status =3D MSIX_VECTOR_SHARED_VQ_AND_CONF=
IG;
> >>>>>> +
> >>>>>> +    if (nvectors =3D=3D 1) {
> >>>>>> +        vf->msix_vector_status =3D MSIX_VECTOR_DEV_SHARED;
> >>>>>> +        ret =3D ifcvf_request_dev_shared_irq(adapter);
> >>>>>> +
> >>>>>> +        return ret;
> >>>>>>         }
> >>>>>>     +    ret =3D ifcvf_request_vq_irq(adapter);
> >>>>>> +    if (ret)
> >>>>>> +        return ret;
> >>>>>> +
> >>>>>> +    ret =3D ifcvf_request_config_irq(adapter);
> >>>>>> +
> >>>>>> +    if (ret)
> >>>>>> +        return ret;
> >>>>>> +
> >>>>>>         return 0;
> >>>>>>     }
> >>>>>>     @@ -441,7 +611,10 @@ static int ifcvf_vdpa_get_vq_irq(struct
> >>>>>> vdpa_device *vdpa_dev,
> >>>>>>     {
> >>>>>>         struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
> >>>>>>     -    return vf->vring[qid].irq;
> >>>>>> +    if (vf->vqs_shared_irq < 0)
> >>>>>> +        return vf->vring[qid].irq;
> >>>>>> +    else
> >>>>>> +        return -EINVAL;
> >>>>>>     }
> >>>>>>       static struct vdpa_notification_area
> >>>>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
> >>>>> _______________________________________________
> >>>>> Virtualization mailing list
> >>>>> Virtualization@lists.linux-foundation.org
> >>>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

