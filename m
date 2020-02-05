Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE39152654
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 07:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgBEGam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 01:30:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33948 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725875AbgBEGam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 01:30:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580884241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SK/6EZm6JjjZrHYe/o5W90LoH1mAJQFt67RmR4CQh0M=;
        b=YgkvhRC6oEL83OP1ymGPPJJYiDFnwqsRhnOqo6LV6h3nEX9VZU9anBYQ21hs7Z5J20uNUo
        SZkb5eDb9rwubWni2fiPnCTX/RV+OcncXVRiQM2oD1RClkX3Lh0WSI/9zxSuVou9yIT6+R
        71AwJ2Jy8XqBF7f3VnpPDgJV6RPSpvI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-XvI695W8NWGVHF5Ee_2-9A-1; Wed, 05 Feb 2020 01:30:40 -0500
X-MC-Unique: XvI695W8NWGVHF5Ee_2-9A-1
Received: by mail-qk1-f197.google.com with SMTP id c206so628309qkg.6
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 22:30:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SK/6EZm6JjjZrHYe/o5W90LoH1mAJQFt67RmR4CQh0M=;
        b=Kg7HtlcDBXjeCTqGJZ1WhUjsoLHfReotw9ggnvuLwW3qV1G3n4WUGXC05jDIA6k+V7
         cndWM6EwgSieDebvcxEiMpcZ+y4oi2IkDjqhObn1RH1p9X3pZ5C7skKSWKLAavejpSaK
         EuIjhfUTcu9mXRdVt4FNoF1WAKnBkdGKHId0HlLaWMXEXBYddS6+Vt+lTzk8nfZ1Cz2x
         /8nN1NgwpNnLc7rWMnIBrsyFjTCdxr4RYT7U3hleZIOrN1fwVomSZCQxaGIhoMIFWaBq
         bYtbfz+RgcSExP99XmTXBs9gZjBFeMJWlC6psY7vuN7FSnz9mzwWsJIgLkFR/GDcvGhj
         b2Jw==
X-Gm-Message-State: APjAAAV+KXSk6AavEzS24gbKD9oEe24fQ8G8TavU/tznEnluIiqaDmNs
        8ybQlZXLCibfM7hvekKxcjZCmxkjGoXPwnpAB6hOZkrEO13FOdZoFdiVfJ3W2iIP3RJ3iHqzYMd
        Gb9LUgwZOI7zIGn3s
X-Received: by 2002:a05:6214:11a8:: with SMTP id u8mr30684177qvv.16.1580884239900;
        Tue, 04 Feb 2020 22:30:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwkD0A2RyJgsZhuekPIPi4xkOg0VrIIr3OXInSUl8ooLyFt/kzVDntwDVhZLhJKb38ZnUEwpg==
X-Received: by 2002:a05:6214:11a8:: with SMTP id u8mr30684150qvv.16.1580884239611;
        Tue, 04 Feb 2020 22:30:39 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id a36sm13471539qtk.29.2020.02.04.22.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 22:30:38 -0800 (PST)
Date:   Wed, 5 Feb 2020 01:30:32 -0500
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
Message-ID: <20200205011935-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200204005306-mutt-send-email-mst@kernel.org>
 <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
 <20200205020555.GA369236@___>
 <798e5644-ca28-ee46-c953-688af9bccd3b@redhat.com>
 <20200205003048-mutt-send-email-mst@kernel.org>
 <eb53d1c2-92ae-febf-f502-2d3e107ee608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb53d1c2-92ae-febf-f502-2d3e107ee608@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 01:50:28PM +0800, Jason Wang wrote:
> 
> On 2020/2/5 下午1:31, Michael S. Tsirkin wrote:
> > On Wed, Feb 05, 2020 at 11:12:21AM +0800, Jason Wang wrote:
> > > On 2020/2/5 上午10:05, Tiwei Bie wrote:
> > > > On Tue, Feb 04, 2020 at 02:46:16PM +0800, Jason Wang wrote:
> > > > > On 2020/2/4 下午2:01, Michael S. Tsirkin wrote:
> > > > > > On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> > > > > > > 5) generate diffs of memory table and using IOMMU API to setup the dma
> > > > > > > mapping in this method
> > > > > > Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?
> > > > > > 
> > > > > Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?
> > > > Do you mean we let userspace to only use VHOST_IOTLB_UPDATE/INVALIDATE
> > > > to do the DMA mapping in vhost-vdpa case? When vIOMMU isn't available,
> > > > userspace will set msg->iova to GPA, otherwise userspace will set
> > > > msg->iova to GIOVA, and vhost-vdpa module will get HPA from msg->uaddr?
> > > > 
> > > > Thanks,
> > > > Tiwei
> > > I think so. Michael, do you think this makes sense?
> > > 
> > > Thanks
> > to make sure, could you post the suggested argument format for
> > these ioctls?
> > 
> 
> It's the existed uapi:
> 
> /* no alignment requirement */
> struct vhost_iotlb_msg {
>     __u64 iova;
>     __u64 size;
>     __u64 uaddr;
> #define VHOST_ACCESS_RO      0x1
> #define VHOST_ACCESS_WO      0x2
> #define VHOST_ACCESS_RW      0x3
>     __u8 perm;
> #define VHOST_IOTLB_MISS           1
> #define VHOST_IOTLB_UPDATE         2
> #define VHOST_IOTLB_INVALIDATE     3
> #define VHOST_IOTLB_ACCESS_FAIL    4
>     __u8 type;
> };
> 
> #define VHOST_IOTLB_MSG 0x1
> #define VHOST_IOTLB_MSG_V2 0x2
> 
> struct vhost_msg {
>     int type;
>     union {
>         struct vhost_iotlb_msg iotlb;
>         __u8 padding[64];
>     };
> };
> 
> struct vhost_msg_v2 {
>     __u32 type;
>     __u32 reserved;
>     union {
>         struct vhost_iotlb_msg iotlb;
>         __u8 padding[64];
>     };
> };

Oh ok.  So with a real device, I suspect we do not want to wait for each
change to be processed by device completely, so we might want an asynchronous variant
and then some kind of flush that tells device "you better apply these now".

-- 
MST

