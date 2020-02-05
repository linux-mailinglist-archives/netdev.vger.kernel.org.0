Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AE2152927
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 11:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgBEKdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 05:33:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33691 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727562AbgBEKdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 05:33:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580898829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fMJo0Joxo+pl/mB5o3Pd3oM2dXap9Kiay0KNytUxRsU=;
        b=ZIWxRiOIzLW96aEkYuzKP+c8c6Yr4VUb/c/lPxeAgEQfDfkgOe5MfIc00azpJg+CofmS5H
        oFRmCVrbW2lAeXJYCkJvCYyvfywqE3Z8VW1XF1CPlZKOc6I3ZkOkPmGu/0ynXMJh1yC7i+
        B9iSR9oVlUUGUgqROv65tADe6ktU4rY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-f9-TraQROHy_FKqLsR1fvA-1; Wed, 05 Feb 2020 05:33:48 -0500
X-MC-Unique: f9-TraQROHy_FKqLsR1fvA-1
Received: by mail-qk1-f197.google.com with SMTP id b23so946839qkg.17
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 02:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fMJo0Joxo+pl/mB5o3Pd3oM2dXap9Kiay0KNytUxRsU=;
        b=szRSzJFNEsgrkT07oAhJEYl5G454a2keezFprY6Tja9wckA2/w3nTuAn63753ILLog
         JNdTGi7hpt9Fl4aw2dzLTCrJssTMA3+dc3DR2rezbY49go1W1oau7UUPIEgTjDwBAFt4
         w3x6Kwn2Zu3qmwWVRKmLnxzgCg5P8cyQjOiM3OROhWE1gJzBIvdd+GXpDdBAD9v7jcJR
         3FoR1drmrvq6e/QnbgSw3ts2LPhC5qXakKVyVNVNKR0xRDlo314mLwz0pzQ1hIs/QhKo
         kCOdv20yd592MPGhn8PDSSlzunlTyu5udhvIU7epk7pvesia6HQc7/Prh7OLPeEKV8Qf
         6Ehg==
X-Gm-Message-State: APjAAAUN6aDfTuJveUWRZao5Ej6ow/CX/eg6tm5y6awz40f/ELcRx6iY
        d8kPOfY3t9zfmmi/dU8G+xyBdO4oAarRhtqznqs7S4pxOoQWlU3ylqraHMnVGx+swpRC1o4wFQF
        Mp9z2/+P3ZCovv2vs
X-Received: by 2002:a37:6853:: with SMTP id d80mr4494830qkc.57.1580898827683;
        Wed, 05 Feb 2020 02:33:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxSqc1HJF8dt4Eb/7jFWTJnHSPo1HCY1H3WJbmwy+Vb8UDe9HwZCYMCfYz7+b2DU8mORTzDoA==
X-Received: by 2002:a37:6853:: with SMTP id d80mr4494800qkc.57.1580898827421;
        Wed, 05 Feb 2020 02:33:47 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id p50sm13949401qtf.5.2020.02.05.02.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 02:33:46 -0800 (PST)
Date:   Wed, 5 Feb 2020 05:33:40 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shahaf Shuler <shahafs@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>, Tiwei Bie <tiwei.bie@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205053129-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
 <AM0PR0502MB3795AD42233D69F350402A8AC3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0PR0502MB3795AD42233D69F350402A8AC3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 09:30:14AM +0000, Shahaf Shuler wrote:
> Wednesday, February 5, 2020 9:50 AM, Jason Wang:
> > Subject: Re: [PATCH] vhost: introduce vDPA based backend
> > On 2020/2/5 下午3:15, Shahaf Shuler wrote:
> > > Wednesday, February 5, 2020 4:03 AM, Tiwei Bie:
> > >> Subject: Re: [PATCH] vhost: introduce vDPA based backend
> > >>
> > >> On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> > >>> On 2020/1/31 上午11:36, Tiwei Bie wrote:
> > >>>> This patch introduces a vDPA based vhost backend. This backend is
> > >>>> built on top of the same interface defined in virtio-vDPA and
> > >>>> provides a generic vhost interface for userspace to accelerate the
> > >>>> virtio devices in guest.
> > >>>>
> > >>>> This backend is implemented as a vDPA device driver on top of the
> > >>>> same ops used in virtio-vDPA. It will create char device entry
> > >>>> named vhost-vdpa/$vdpa_device_index for userspace to use.
> > Userspace
> > >>>> can use vhost ioctls on top of this char device to setup the backend.
> > >>>>
> > >>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > > [...]
> > >
> > >>>> +static long vhost_vdpa_do_dma_mapping(struct vhost_vdpa *v) {
> > >>>> +	/* TODO: fix this */
> > >>>
> > >>> Before trying to do this it looks to me we need the following during
> > >>> the probe
> > >>>
> > >>> 1) if set_map() is not supported by the vDPA device probe the IOMMU
> > >>> that is supported by the vDPA device
> > >>> 2) allocate IOMMU domain
> > >>>
> > >>> And then:
> > >>>
> > >>> 3) pin pages through GUP and do proper accounting
> > >>> 4) store GPA->HPA mapping in the umem
> > >>> 5) generate diffs of memory table and using IOMMU API to setup the
> > >>> dma mapping in this method
> > >>>
> > >>> For 1), I'm not sure parent is sufficient for to doing this or need
> > >>> to introduce new API like iommu_device in mdev.
> > >> Agree. We may also need to introduce something like the iommu_device.
> > >>
> > > Would it be better for the map/umnap logic to happen inside each device ?
> > > Devices that needs the IOMMU will call iommu APIs from inside the driver
> > callback.
> > 
> > 
> > Technically, this can work. But if it can be done by vhost-vpda it will make the
> > vDPA driver more compact and easier to be implemented.
> 
> Need to see the layering of such proposal but am not sure. 
> Vhost-vdpa is generic framework, while the DMA mapping is vendor specific. 
> Maybe vhost-vdpa can have some shared code needed to operate on iommu, so drivers can re-use it.  to me it seems simpler than exposing a new iommu device. 
> 
> > 
> > 
> > > Devices that has other ways to do the DMA mapping will call the
> > proprietary APIs.
> > 
> > 
> > To confirm, do you prefer:
> > 
> > 1) map/unmap
> 
> It is not only that. AFAIR there also flush and invalidate calls, right?
> 
> > 
> > or
> > 
> > 2) pass all maps at one time?
> 
> To me this seems more straight forward. 
> It is correct that under hotplug and large number of memory segments
> the driver will need to understand the diff (or not and just reload
> the new configuration).
> However, my assumption here is that memory
> hotplug is heavy flow anyway, and the driver extra cycles will not be
> that visible

I think we can just allow both, after all vhost already has both interfaces ...
We just need a flag that tells userspace whether it needs to
update all maps aggressively or can wait for a fault.

> > 
> > Thanks
> > 
> > 
> > >
> 

