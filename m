Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFA7554E97
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357984AbiFVPFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353361AbiFVPFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:05:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 903AB3467F
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655910328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/2IQy+E40urhXFacB8Vj36ycB9yteHAjL3Hd6nT3fLI=;
        b=U6kOysbJkmDb1R7kxTl31SMyR1sshgjLyW8YOLyw/NZjKdTkh1WVrStdDT9vfUUY/u9Wu3
        Fld8Cz3ovVcvA5TYYKkOwzMhJo7xt+Nr51ZnGlk0EFm9Vb8QYHyEMBYBitPr+rQR7CbaRT
        Vwfy/nukP4lpd+PsP+HXX5SCCmSWhC0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-woDISYfvO9KcV4FMOjfRoQ-1; Wed, 22 Jun 2022 11:05:21 -0400
X-MC-Unique: woDISYfvO9KcV4FMOjfRoQ-1
Received: by mail-qk1-f200.google.com with SMTP id y8-20020a05620a44c800b006a6f8cd53cbso20246252qkp.5
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2IQy+E40urhXFacB8Vj36ycB9yteHAjL3Hd6nT3fLI=;
        b=Q0/sFzudLBPZbjYp/OvrF3Sc+QghUSDrCfPQGpcj0eftdHjFdSVl/0YMz06AdIafxs
         JY8CMUMkHbr90rHlVtWc7fXt+2yVtgTPo+h/WExl0hsQvKWtijnhrKLEoRHHMPlH8Rgb
         IINDPSBMpAl+sn9xKQTEnuX0VOsm4bchnHgfDvT9JlYyEtbPB8GU2wUKu/VUAAnflJnY
         bYlVpgifZuPeto0SxnCxsu046Dro6jm+mjn6U9ySB79uYRiMr5QAeJnheq/HysG+qCC5
         ayv3xn/HeedwLe+s5xpNCR5vVN6+C9jJtgohNMWC0Me0wvzxE0fuT/d+S3ayi2r7ZKbE
         gx/A==
X-Gm-Message-State: AJIora9+Y376OIMTUQJMv7qTSfnwvf9A04n28KC63XwU8q1S2hQxUO3t
        rrAcOeYDDqILAnrQdBz/wDv8oXLnqzXdbqpTG8VoW2uQdP/ntOqNNJPQoyw6sYKjHD2Abdpkqd6
        AmGdcYWR34Lt9UyhUqZ+veJYiWjwd93D/
X-Received: by 2002:a37:9e8d:0:b0:6ae:e97f:0 with SMTP id h135-20020a379e8d000000b006aee97f0000mr771689qke.255.1655910321126;
        Wed, 22 Jun 2022 08:05:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQQ1h9P/HHEVYnAo2mvHU2BBI6pfbGjZhVCLCVPT5jR/q5Yw/ghpcZqC3xUNOJBIwMqEbn/hBb7fQQn1SmrVE=
X-Received: by 2002:a37:9e8d:0:b0:6ae:e97f:0 with SMTP id h135-20020a379e8d000000b006aee97f0000mr771619qke.255.1655910320506;
 Wed, 22 Jun 2022 08:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220330180436.24644-1-gdawar@xilinx.com> <20220330180436.24644-20-gdawar@xilinx.com>
 <CAGxU2F6OO108oHsrLBWJnYRG2yRU8QnRxAdjJhUUcp8AqaAP-g@mail.gmail.com> <CAJaqyWd8MR9vTRcCTktzC3VL054x5H5_sXy+MLVNewFDkjQUSw@mail.gmail.com>
In-Reply-To: <CAJaqyWd8MR9vTRcCTktzC3VL054x5H5_sXy+MLVNewFDkjQUSw@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 22 Jun 2022 17:04:44 +0200
Message-ID: <CAJaqyWc36adK-gUzc8tMgDDe5SoBPy7xN-UtcFA4=aDezdJ5LA@mail.gmail.com>
Subject: Re: [PATCH v2 19/19] vdpasim: control virtqueue support
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Gautam Dawar <gautam.dawar@xilinx.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Longpeng <longpeng2@huawei.com>, Eli Cohen <elic@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 12:21 PM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Tue, Jun 21, 2022 at 5:20 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > Hi Gautam,
> >
> > On Wed, Mar 30, 2022 at 8:21 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
> > >
> > > This patch introduces the control virtqueue support for vDPA
> > > simulator. This is a requirement for supporting advanced features like
> > > multiqueue.
> > >
> > > A requirement for control virtqueue is to isolate its memory access
> > > from the rx/tx virtqueues. This is because when using vDPA device
> > > for VM, the control virqueue is not directly assigned to VM. Userspace
> > > (Qemu) will present a shadow control virtqueue to control for
> > > recording the device states.
> > >
> > > The isolation is done via the virtqueue groups and ASID support in
> > > vDPA through vhost-vdpa. The simulator is extended to have:
> > >
> > > 1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
> > > 2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
> > >    contains CVQ
> > > 3) two address spaces and the simulator simply implements the address
> > >    spaces by mapping it 1:1 to IOTLB.
> > >
> > > For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
> > > to group 1. So we have:
> > >
> > > 1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
> > >    RX and TX can be assigned to guest directly.
> > > 2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
> > >    is the buffers that allocated and managed by VMM only. So CVQ of
> > >    vhost-vdpa is visible to VMM only. And Guest can not access the CVQ
> > >    of vhost-vdpa.
> > >
> > > For the other use cases, since AS 0 is associated to all virtqueue
> > > groups by default. All virtqueues share the same mapping by default.
> > >
> > > To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
> > > implemented in the simulator for the driver to set mac address.
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> > > ---
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 91 ++++++++++++++++++++++------
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  2 +
> > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 88 ++++++++++++++++++++++++++-
> > >  3 files changed, 161 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > > index 659e2e2e4b0c..51bd0bafce06 100644
> > > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > > @@ -96,11 +96,17 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
> > >  {
> > >         int i;
> > >
> > > -       for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
> > > +       spin_lock(&vdpasim->iommu_lock);
> > > +
> > > +       for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
> > >                 vdpasim_vq_reset(vdpasim, &vdpasim->vqs[i]);
> > > +               vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
> > > +                                &vdpasim->iommu_lock);
> > > +       }
> > > +
> > > +       for (i = 0; i < vdpasim->dev_attr.nas; i++)
> > > +               vhost_iotlb_reset(&vdpasim->iommu[i]);
> > >
> > > -       spin_lock(&vdpasim->iommu_lock);
> > > -       vhost_iotlb_reset(vdpasim->iommu);
> > >         spin_unlock(&vdpasim->iommu_lock);
> > >
> > >         vdpasim->features = 0;
> > > @@ -145,7 +151,7 @@ static dma_addr_t vdpasim_map_range(struct vdpasim *vdpasim, phys_addr_t paddr,
> > >         dma_addr = iova_dma_addr(&vdpasim->iova, iova);
> > >
> > >         spin_lock(&vdpasim->iommu_lock);
> > > -       ret = vhost_iotlb_add_range(vdpasim->iommu, (u64)dma_addr,
> > > +       ret = vhost_iotlb_add_range(&vdpasim->iommu[0], (u64)dma_addr,
> > >                                     (u64)dma_addr + size - 1, (u64)paddr, perm);
> > >         spin_unlock(&vdpasim->iommu_lock);
> > >
> > > @@ -161,7 +167,7 @@ static void vdpasim_unmap_range(struct vdpasim *vdpasim, dma_addr_t dma_addr,
> > >                                 size_t size)
> > >  {
> > >         spin_lock(&vdpasim->iommu_lock);
> > > -       vhost_iotlb_del_range(vdpasim->iommu, (u64)dma_addr,
> > > +       vhost_iotlb_del_range(&vdpasim->iommu[0], (u64)dma_addr,
> > >                               (u64)dma_addr + size - 1);
> > >         spin_unlock(&vdpasim->iommu_lock);
> > >
> > > @@ -250,8 +256,9 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
> > >         else
> > >                 ops = &vdpasim_config_ops;
> > >
> > > -       vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
> > > -                                   1, dev_attr->name, false);
> > > +       vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> > > +                                   dev_attr->ngroups, dev_attr->nas,
> > > +                                   dev_attr->name, false);
> > >         if (IS_ERR(vdpasim)) {
> > >                 ret = PTR_ERR(vdpasim);
> > >                 goto err_alloc;
> > > @@ -278,16 +285,20 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
> > >         if (!vdpasim->vqs)
> > >                 goto err_iommu;
> > >
> > > -       vdpasim->iommu = vhost_iotlb_alloc(max_iotlb_entries, 0);
> > > +       vdpasim->iommu = kmalloc_array(vdpasim->dev_attr.nas,
> > > +                                      sizeof(*vdpasim->iommu), GFP_KERNEL);
> > >         if (!vdpasim->iommu)
> > >                 goto err_iommu;
> > >
> > > +       for (i = 0; i < vdpasim->dev_attr.nas; i++)
> > > +               vhost_iotlb_init(&vdpasim->iommu[i], 0, 0);
> > > +
> > >         vdpasim->buffer = kvmalloc(dev_attr->buffer_size, GFP_KERNEL);
> > >         if (!vdpasim->buffer)
> > >                 goto err_iommu;
> > >
> > >         for (i = 0; i < dev_attr->nvqs; i++)
> > > -               vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu,
> > > +               vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
> > >                                  &vdpasim->iommu_lock);
> > >
> > >         ret = iova_cache_get();
> > > @@ -401,7 +412,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
> > >
> > >  static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
> > >  {
> > > -       return 0;
> > > +       /* RX and TX belongs to group 0, CVQ belongs to group 1 */
> > > +       if (idx == 2)
> > > +               return 1;
> > > +       else
> > > +               return 0;
> >
> > This code only works for the vDPA-net simulator, since
> > vdpasim_get_vq_group() is also shared with other simulators (e.g.
> > vdpa_sim_blk),
>
> That's totally right.
>
> > should we move this net-specific code into
> > vdpa_sim_net.c, maybe adding a callback implemented by the different
> > simulators?
> >
>
> At this moment, VDPASIM_BLK_VQ_NUM is fixed to 1, so maybe the right
> thing to do for the -rc phase is to check if idx > vdpasim.attr.nvqs?
> It's a more general fix.
>

Actually, that is already checked by vhost/vdpa.c.

Taking that into account, is it worth introducing the change for 5.19?
I'm totally ok with the change for 5.20.

Thanks!

> For the general case, yes, a callback should be issued to the actual
> simulator so it's not a surprise when VDPASIM_BLK_VQ_NUM increases,
> either dynamically or by anyone testing it.
>
> Thoughts?
>
> Thanks!

