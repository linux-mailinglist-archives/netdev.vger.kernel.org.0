Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44729554FAE
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359432AbiFVPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359421AbiFVPoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:44:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED0561D311
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655912692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ihQ51bcQWrzbwEBEWv0BHU9ir5A3unDKhLlROclaoHU=;
        b=ih8KE7EkxSv52VQhowjTwci3hilEtZVrNBEHeDTP1QJDbDLxPOB4nQHe60Os07XQUcprtY
        DPFrRCScl1bgyLd6xl1ijv70K1Zw/rjGaBk+zfHyUfCOCwhAFkYAWJnHA7ADPnE1dFkqUG
        6NyurRbDoxNh5J3YIvf2N3Ean/sucis=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-Hj9dw4OLOsaDrLiJc_F6yQ-1; Wed, 22 Jun 2022 11:44:51 -0400
X-MC-Unique: Hj9dw4OLOsaDrLiJc_F6yQ-1
Received: by mail-wr1-f70.google.com with SMTP id z11-20020adfc00b000000b0021a3ab8ec82so3972336wre.23
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ihQ51bcQWrzbwEBEWv0BHU9ir5A3unDKhLlROclaoHU=;
        b=x6lQyLd7w7RMz0Bo/T1T/EfCPdz6hFp+Lz09fnr7FVfAmvm4FfkMGXnOPqx5DC7f52
         iGHg5puqo6htiso49HHREgCuIVAEICHZUtIF4IC8zQTuwdcf3pNtm939JnVTe0nib0nj
         iYzAlPOLX5eIndfXTLj+h/MGZiuJSRRShtxCQXQw1EV5+SdV4MZMmk/wA0XNu/HHwxFB
         4NdTsn/m0E+K7C1EqFUH7SAI/DxDMJ6uu4ky2ebdFK/Bx5kUmcLhjyW8M6Q7zyZe5TFQ
         vOlxBdyD4arIumqFlOE3iLspUnzekQxc4FAyV1LOyqtR/xKSC8mz0DX0VwVBUnxt+BfH
         q5Rw==
X-Gm-Message-State: AJIora+ABeTwh+t++e3iC/kaQmkepwBoONhOgQSeNbD0+/j0iYsPyy6A
        WQDglLnyDFCF1B3eaes2EAoQvgpP6pzQb8F9FsG0LUAHYcakTzVAarx+l3qn5n3ieyz3GsJ4hwU
        KSIObuTnD7OrlDAyd
X-Received: by 2002:adf:e252:0:b0:21b:827e:4c63 with SMTP id bl18-20020adfe252000000b0021b827e4c63mr4009479wrb.307.1655912689734;
        Wed, 22 Jun 2022 08:44:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u7iQW1o9hu0M1BscDqcuqnTBsDy17WvRImGANcMHb/fY6669Lsq7nWLjQNBG3zGujOvpBU4Q==
X-Received: by 2002:adf:e252:0:b0:21b:827e:4c63 with SMTP id bl18-20020adfe252000000b0021b827e4c63mr4009443wrb.307.1655912689458;
        Wed, 22 Jun 2022 08:44:49 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id y6-20020a5d6206000000b0021350f7b22esm21860297wru.109.2022.06.22.08.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 08:44:48 -0700 (PDT)
Date:   Wed, 22 Jun 2022 17:44:44 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
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
Subject: Re: [PATCH v2 19/19] vdpasim: control virtqueue support
Message-ID: <20220622154444.tjx5ehw47pqyjzjt@sgarzare-redhat>
References: <20220330180436.24644-1-gdawar@xilinx.com>
 <20220330180436.24644-20-gdawar@xilinx.com>
 <CAGxU2F6OO108oHsrLBWJnYRG2yRU8QnRxAdjJhUUcp8AqaAP-g@mail.gmail.com>
 <CAJaqyWd8MR9vTRcCTktzC3VL054x5H5_sXy+MLVNewFDkjQUSw@mail.gmail.com>
 <CAJaqyWc36adK-gUzc8tMgDDe5SoBPy7xN-UtcFA4=aDezdJ5LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJaqyWc36adK-gUzc8tMgDDe5SoBPy7xN-UtcFA4=aDezdJ5LA@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 05:04:44PM +0200, Eugenio Perez Martin wrote:
>On Wed, Jun 22, 2022 at 12:21 PM Eugenio Perez Martin
><eperezma@redhat.com> wrote:
>>
>> On Tue, Jun 21, 2022 at 5:20 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >
>> > Hi Gautam,
>> >
>> > On Wed, Mar 30, 2022 at 8:21 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>> > >
>> > > This patch introduces the control virtqueue support for vDPA
>> > > simulator. This is a requirement for supporting advanced features like
>> > > multiqueue.
>> > >
>> > > A requirement for control virtqueue is to isolate its memory access
>> > > from the rx/tx virtqueues. This is because when using vDPA device
>> > > for VM, the control virqueue is not directly assigned to VM. Userspace
>> > > (Qemu) will present a shadow control virtqueue to control for
>> > > recording the device states.
>> > >
>> > > The isolation is done via the virtqueue groups and ASID support in
>> > > vDPA through vhost-vdpa. The simulator is extended to have:
>> > >
>> > > 1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
>> > > 2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
>> > >    contains CVQ
>> > > 3) two address spaces and the simulator simply implements the address
>> > >    spaces by mapping it 1:1 to IOTLB.
>> > >
>> > > For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
>> > > to group 1. So we have:
>> > >
>> > > 1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
>> > >    RX and TX can be assigned to guest directly.
>> > > 2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
>> > >    is the buffers that allocated and managed by VMM only. So CVQ of
>> > >    vhost-vdpa is visible to VMM only. And Guest can not access the CVQ
>> > >    of vhost-vdpa.
>> > >
>> > > For the other use cases, since AS 0 is associated to all virtqueue
>> > > groups by default. All virtqueues share the same mapping by default.
>> > >
>> > > To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
>> > > implemented in the simulator for the driver to set mac address.
>> > >
>> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
>> > > Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
>> > > ---
>> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 91 ++++++++++++++++++++++------
>> > >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  2 +
>> > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 88 ++++++++++++++++++++++++++-
>> > >  3 files changed, 161 insertions(+), 20 deletions(-)
>> > >
>> > > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> > > index 659e2e2e4b0c..51bd0bafce06 100644
>> > > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> > > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> > > @@ -96,11 +96,17 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>> > >  {
>> > >         int i;
>> > >
>> > > -       for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
>> > > +       spin_lock(&vdpasim->iommu_lock);
>> > > +
>> > > +       for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
>> > >                 vdpasim_vq_reset(vdpasim, &vdpasim->vqs[i]);
>> > > +               vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
>> > > +                                &vdpasim->iommu_lock);
>> > > +       }
>> > > +
>> > > +       for (i = 0; i < vdpasim->dev_attr.nas; i++)
>> > > +               vhost_iotlb_reset(&vdpasim->iommu[i]);
>> > >
>> > > -       spin_lock(&vdpasim->iommu_lock);
>> > > -       vhost_iotlb_reset(vdpasim->iommu);
>> > >         spin_unlock(&vdpasim->iommu_lock);
>> > >
>> > >         vdpasim->features = 0;
>> > > @@ -145,7 +151,7 @@ static dma_addr_t vdpasim_map_range(struct vdpasim *vdpasim, phys_addr_t paddr,
>> > >         dma_addr = iova_dma_addr(&vdpasim->iova, iova);
>> > >
>> > >         spin_lock(&vdpasim->iommu_lock);
>> > > -       ret = vhost_iotlb_add_range(vdpasim->iommu, (u64)dma_addr,
>> > > +       ret = vhost_iotlb_add_range(&vdpasim->iommu[0], (u64)dma_addr,
>> > >                                     (u64)dma_addr + size - 1, (u64)paddr, perm);
>> > >         spin_unlock(&vdpasim->iommu_lock);
>> > >
>> > > @@ -161,7 +167,7 @@ static void vdpasim_unmap_range(struct vdpasim *vdpasim, dma_addr_t dma_addr,
>> > >                                 size_t size)
>> > >  {
>> > >         spin_lock(&vdpasim->iommu_lock);
>> > > -       vhost_iotlb_del_range(vdpasim->iommu, (u64)dma_addr,
>> > > +       vhost_iotlb_del_range(&vdpasim->iommu[0], (u64)dma_addr,
>> > >                               (u64)dma_addr + size - 1);
>> > >         spin_unlock(&vdpasim->iommu_lock);
>> > >
>> > > @@ -250,8 +256,9 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>> > >         else
>> > >                 ops = &vdpasim_config_ops;
>> > >
>> > > -       vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
>> > > -                                   1, dev_attr->name, false);
>> > > +       vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
>> > > +                                   dev_attr->ngroups, dev_attr->nas,
>> > > +                                   dev_attr->name, false);
>> > >         if (IS_ERR(vdpasim)) {
>> > >                 ret = PTR_ERR(vdpasim);
>> > >                 goto err_alloc;
>> > > @@ -278,16 +285,20 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>> > >         if (!vdpasim->vqs)
>> > >                 goto err_iommu;
>> > >
>> > > -       vdpasim->iommu = vhost_iotlb_alloc(max_iotlb_entries, 0);
>> > > +       vdpasim->iommu = kmalloc_array(vdpasim->dev_attr.nas,
>> > > +                                      sizeof(*vdpasim->iommu), GFP_KERNEL);
>> > >         if (!vdpasim->iommu)
>> > >                 goto err_iommu;
>> > >
>> > > +       for (i = 0; i < vdpasim->dev_attr.nas; i++)
>> > > +               vhost_iotlb_init(&vdpasim->iommu[i], 0, 0);
>> > > +
>> > >         vdpasim->buffer = kvmalloc(dev_attr->buffer_size, GFP_KERNEL);
>> > >         if (!vdpasim->buffer)
>> > >                 goto err_iommu;
>> > >
>> > >         for (i = 0; i < dev_attr->nvqs; i++)
>> > > -               vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu,
>> > > +               vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
>> > >                                  &vdpasim->iommu_lock);
>> > >
>> > >         ret = iova_cache_get();
>> > > @@ -401,7 +412,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
>> > >
>> > >  static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
>> > >  {
>> > > -       return 0;
>> > > +       /* RX and TX belongs to group 0, CVQ belongs to group 1 */
>> > > +       if (idx == 2)
>> > > +               return 1;
>> > > +       else
>> > > +               return 0;
>> >
>> > This code only works for the vDPA-net simulator, since
>> > vdpasim_get_vq_group() is also shared with other simulators (e.g.
>> > vdpa_sim_blk),
>>
>> That's totally right.
>>
>> > should we move this net-specific code into
>> > vdpa_sim_net.c, maybe adding a callback implemented by the different
>> > simulators?
>> >
>>
>> At this moment, VDPASIM_BLK_VQ_NUM is fixed to 1, so maybe the right
>> thing to do for the -rc phase is to check if idx > vdpasim.attr.nvqs?
>> It's a more general fix.
>>
>
>Actually, that is already checked by vhost/vdpa.c.
>
>Taking that into account, is it worth introducing the change for 5.19?
>I'm totally ok with the change for 5.20.
>
>Thanks!
>
>> For the general case, yes, a callback should be issued to the actual
>> simulator so it's not a surprise when VDPASIM_BLK_VQ_NUM increases,
>> either dynamically or by anyone testing it.

Exactly, since those parameters are not yet configurable at runtime 
(someday I hope they will be), I often recompile the module by changing 
them, so for me we should fix them in 5.19.

Obviously it's an advanced case, and I expect that if someone recompiles 
the module changing some hardwired thing, they can expect to have to 
change something else as well.

So, I'm also fine with leaving it that way for 5.19, but if you want I 
can fix it earlier.

Thanks,
Stefano

