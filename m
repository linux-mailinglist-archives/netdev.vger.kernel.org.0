Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B982F15282C
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 10:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgBEJWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 04:22:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728130AbgBEJWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 04:22:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580894558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+4ADA5RYq1REkZi1n0de2jyMCM/FMnBA16Dj7PrO/fQ=;
        b=emWrLMTAx61OA2rext6wg3Pp0iuhBSBkEfFA+4ani4NP6Gez5UeeJsW21dp5b3ljbT5MFo
        x3wqgrcx0HKsjHuhZBu9aVMGZ30QeBM8f04034cNNTKyW5wGOYbOo8QDrJgboZLiN0JgXu
        CsXf00AuPROKm/9g4AK9fztjtA13INs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-p2lvfD-wNsKpvwQT1Q2nsQ-1; Wed, 05 Feb 2020 04:22:36 -0500
X-MC-Unique: p2lvfD-wNsKpvwQT1Q2nsQ-1
Received: by mail-qt1-f200.google.com with SMTP id b5so933905qtt.10
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 01:22:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+4ADA5RYq1REkZi1n0de2jyMCM/FMnBA16Dj7PrO/fQ=;
        b=YGNkPoZdZwnp5j3bT4xgbsBeO0jvpXF8SE8wlrOO1LOUxhR0vsSpmefxsTP8vsWSL+
         6x40DTiWYfGE0UGFUx+UqyesM7ih4ZpxpFwEsxCxrciQG62qMT2REevj2pgkV9JrvTBG
         QFcl1cKxfgqIEsu2me3n+Iw1HdCPOEIpyxT2x1F1ugn+FdfYMCIjiBQ69ors2sMd2Pjs
         9kQakOIhcybeuuK58G5vQIpi8VcTmek8th8BDJQPJSQHcEIUwK4vToCApt6FfC5DiGtm
         mU2jmEZJIe8UIJP4RGNj4x0cJ5Qw7nqNDgmoulHG64XrsvPIyqIDyx8/XvMKPuT/ZCA9
         7jlw==
X-Gm-Message-State: APjAAAVuz97kkMtRH8xWiGjM53OJGuWdR1sxLn8tq3NnWebGszEMgFmr
        nKlnXnESJLn7Eh9n1d5rF1xOf03GZcylGGPVpWmCEAXL8TmELEmN/Wke7fNzgfZuMkSTsdEk+nF
        g3DOjPMRb1a0pKpTV
X-Received: by 2002:ae9:c106:: with SMTP id z6mr31970420qki.6.1580894556156;
        Wed, 05 Feb 2020 01:22:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNW6yz51xBNkYKmPewuHn/dhSffxfXzu9258rVB96SNzDJIZ1H3sTIKuDefukwjee0ClvffQ==
X-Received: by 2002:ae9:c106:: with SMTP id z6mr31970396qki.6.1580894555812;
        Wed, 05 Feb 2020 01:22:35 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id c45sm13902138qtd.43.2020.02.05.01.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 01:22:34 -0800 (PST)
Date:   Wed, 5 Feb 2020 04:22:28 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205041817-mutt-send-email-mst@kernel.org>
References: <20200204005306-mutt-send-email-mst@kernel.org>
 <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
 <20200205020555.GA369236@___>
 <798e5644-ca28-ee46-c953-688af9bccd3b@redhat.com>
 <20200205003048-mutt-send-email-mst@kernel.org>
 <eb53d1c2-92ae-febf-f502-2d3e107ee608@redhat.com>
 <20200205011935-mutt-send-email-mst@kernel.org>
 <2dd43fb5-6f02-2dcc-5c27-9f7419ef72fc@redhat.com>
 <20200205020547-mutt-send-email-mst@kernel.org>
 <4e947390-da7c-52bc-c427-b1d82cc425ad@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e947390-da7c-52bc-c427-b1d82cc425ad@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 03:42:18PM +0800, Jason Wang wrote:
> 
> On 2020/2/5 下午3:16, Michael S. Tsirkin wrote:
> > On Wed, Feb 05, 2020 at 02:49:31PM +0800, Jason Wang wrote:
> > > On 2020/2/5 下午2:30, Michael S. Tsirkin wrote:
> > > > On Wed, Feb 05, 2020 at 01:50:28PM +0800, Jason Wang wrote:
> > > > > On 2020/2/5 下午1:31, Michael S. Tsirkin wrote:
> > > > > > On Wed, Feb 05, 2020 at 11:12:21AM +0800, Jason Wang wrote:
> > > > > > > On 2020/2/5 上午10:05, Tiwei Bie wrote:
> > > > > > > > On Tue, Feb 04, 2020 at 02:46:16PM +0800, Jason Wang wrote:
> > > > > > > > > On 2020/2/4 下午2:01, Michael S. Tsirkin wrote:
> > > > > > > > > > On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> > > > > > > > > > > 5) generate diffs of memory table and using IOMMU API to setup the dma
> > > > > > > > > > > mapping in this method
> > > > > > > > > > Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?
> > > > > > > > > > 
> > > > > > > > > Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?
> > > > > > > > Do you mean we let userspace to only use VHOST_IOTLB_UPDATE/INVALIDATE
> > > > > > > > to do the DMA mapping in vhost-vdpa case? When vIOMMU isn't available,
> > > > > > > > userspace will set msg->iova to GPA, otherwise userspace will set
> > > > > > > > msg->iova to GIOVA, and vhost-vdpa module will get HPA from msg->uaddr?
> > > > > > > > 
> > > > > > > > Thanks,
> > > > > > > > Tiwei
> > > > > > > I think so. Michael, do you think this makes sense?
> > > > > > > 
> > > > > > > Thanks
> > > > > > to make sure, could you post the suggested argument format for
> > > > > > these ioctls?
> > > > > > 
> > > > > It's the existed uapi:
> > > > > 
> > > > > /* no alignment requirement */
> > > > > struct vhost_iotlb_msg {
> > > > >       __u64 iova;
> > > > >       __u64 size;
> > > > >       __u64 uaddr;
> > > > > #define VHOST_ACCESS_RO      0x1
> > > > > #define VHOST_ACCESS_WO      0x2
> > > > > #define VHOST_ACCESS_RW      0x3
> > > > >       __u8 perm;
> > > > > #define VHOST_IOTLB_MISS           1
> > > > > #define VHOST_IOTLB_UPDATE         2
> > > > > #define VHOST_IOTLB_INVALIDATE     3
> > > > > #define VHOST_IOTLB_ACCESS_FAIL    4
> > > > >       __u8 type;
> > > > > };
> > > > > 
> > > > > #define VHOST_IOTLB_MSG 0x1
> > > > > #define VHOST_IOTLB_MSG_V2 0x2
> > > > > 
> > > > > struct vhost_msg {
> > > > >       int type;
> > > > >       union {
> > > > >           struct vhost_iotlb_msg iotlb;
> > > > >           __u8 padding[64];
> > > > >       };
> > > > > };
> > > > > 
> > > > > struct vhost_msg_v2 {
> > > > >       __u32 type;
> > > > >       __u32 reserved;
> > > > >       union {
> > > > >           struct vhost_iotlb_msg iotlb;
> > > > >           __u8 padding[64];
> > > > >       };
> > > > > };
> > > > Oh ok.  So with a real device, I suspect we do not want to wait for each
> > > > change to be processed by device completely, so we might want an asynchronous variant
> > > > and then some kind of flush that tells device "you better apply these now".
> > > 
> > > Let me explain:
> > > 
> > > There are two types of devices:
> > > 
> > > 1) device without on-chip IOMMU, DMA was done via IOMMU API which only
> > > support incremental map/unmap
> > Most IOMMUs have queues nowdays though. Whether APIs within kernel
> > expose that matters but we are better off on emulating
> > hardware not specific guest behaviour.
> 
> 
> Last time I checked Intel IOMMU driver, I see the async QI is not used
> there. And I'm not sure how queue will help much here. Qemu still need to
> wait for all the DMA is setup to let guest work.
> 
> > 
> > > 2) device with on-chip IOMMU, DMA could be done by device driver itself, and
> > > we could choose to pass the whole mappings to the driver at one time through
> > > vDPA bus operation (set_map)
> > > 
> > > For vhost-vpda, there're two types of memory mapping:
> > > 
> > > a) memory table, setup by userspace through VHOST_SET_MEM_TABLE, the whole
> > > mapping is updated in this way
> > > b) IOTLB API, incrementally done by userspace through vhost message
> > > (IOTLB_UPDATE/IOTLB_INVALIDATE)
> > > 
> > > The current design is:
> > > 
> > > - Reuse VHOST_SET_MEM_TABLE, and for type 1), we can choose to send diffs
> > > through IOMMU API or flush all the mappings then map new ones. For type 2),
> > > just send the whole mapping through set_map()
> > I know that at least for RDMA based things, you can't change
> > a mapping if it's active. So drivers will need to figure out the
> > differences which just looks ugly: userspace knows what
> > it was changing (really just adding/removing some guest memory).
> 
> 
> Two methods:
> 
> 1) using IOTLB message VHOST_IOTLB_UPDATE/INVALIDATE
> 2) let vhost differs from two memory tables which should not be too hard
> (compare two rb trees)


Right but 2 is just such an obvious waste of cyclces. userspace knows what changed
why does vhost need to re-calculate it? No?

> 
> > 
> > 
> > 
> > > - Reuse vhost IOTLB, so for type 1), simply forward update/invalidate
> > > request via IOMMU API, for type 2), send IOTLB to vDPA device driver via
> > > set_map(), device driver may choose to send diffs or rebuild all mapping at
> > > their will
> > > 
> > > Technically we can use vhost IOTLB API (map/umap) for building
> > > VHOST_SET_MEM_TABLE, but to avoid device to process the each request, it
> > > looks to me we need new UAPI which seems sub optimal.
> > > 
> > > What's you thought?
> > > 
> > > Thanks
> > I suspect we can't completely avoid a new UAPI.
> 
> 
> AFAIK, memory table usually contain just few entries, the performance cost
> should be fine. (At least should be the same as the case of VFIO).
> 
> So in qemu, simply hooking add_region/remove_region to
> VHOST_IOTLB_UPDATE/VHOST_IOTLB_INVALIDATE should work?
> 
> If we introduce API like you proposed previously (memory listener style):
> 
> begin
> add
> remove
> commit
> 
> I suspect it will be too heavweight for the case of vIOMMU and for the
> driver that want to build new mapping, we need addnop etc...
> 
> Thanks
> 

I feel this can help some workloads but this can wait, for sure.


> > 

