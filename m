Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8C1F12DD
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 08:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgFHGcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 02:32:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28206 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728538AbgFHGcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 02:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591597969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHa43udsYNKZo7N6VKsAJNE6lMJI4Ma06bbThMjTBZc=;
        b=E+znX66PqYlcKhzCZFErXyHapDYqr5vEZUDPRxGmkfHUA8OcBTRvH+GFH1sQLFfUFljnWq
        9M/QsOcfb+Vu8INbzRQlWLKdD3TNJp1MlAAfhuPJUqraLe1Bpoa0EIOm8XSjC/ZyzzLyxa
        W9oBZN05HHdgqRNrS7NbytwMMFbBlF8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-7VYFEahDOH6e95r16rwXWA-1; Mon, 08 Jun 2020 02:32:47 -0400
X-MC-Unique: 7VYFEahDOH6e95r16rwXWA-1
Received: by mail-wr1-f70.google.com with SMTP id e1so6757622wrm.3
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 23:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uHa43udsYNKZo7N6VKsAJNE6lMJI4Ma06bbThMjTBZc=;
        b=J2VRiC2JJWzP9qm7qibKFtyAFBiNkgiTn5SZOtC3o0yg2U7sleav5WwXotXsAvuAF6
         P0+1Vll8BVzrvepXBj+VEH0/Vq8IrslwLdNo5pZaRXqpj3jR4Q5y0dGtZGAEi5r0xYEE
         wyyqinLYpjvbuQCpvxBiDJUFts+J6dJFgVH3VyyUycybY/900ELHdfbwixy16dd7NDWG
         WJTPUh01pBSFZBWGmeNZLoY81kuAT/CmxrIb7aZCRXe6LFqx/YGhYNk9BqWiwUeSgs64
         YujeFSmm/w/6zTx6FmFtIdwDaOunP3XCTdFQCLP4QpC9rQUmbfhQHJC5Se7p5+m2hzQk
         NTfg==
X-Gm-Message-State: AOAM530sC0vjPLxn8Lx1kFvjUw1XBOPr4VJBy1/PZH9ZzKoZrk+sbsFV
        lO+t44RSQqxVRHZaHpWYNkbTcO0F2x5xSBXmbCi1kg3ggu2AIcSYgM7PYi1q+cvqZKBfBL5g48f
        1Gyk/0f6H/ZEx8BYn
X-Received: by 2002:adf:f4c6:: with SMTP id h6mr22588493wrp.398.1591597966538;
        Sun, 07 Jun 2020 23:32:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHTpMMuo2IYOqOej95ECMKiyl7nT0Q76q7fFs8v5zZkhDNtkqrniK0oE26ia6RYqO77tX8Xg==
X-Received: by 2002:adf:f4c6:: with SMTP id h6mr22588471wrp.398.1591597966374;
        Sun, 07 Jun 2020 23:32:46 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id c16sm22492989wrx.4.2020.06.07.23.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 23:32:45 -0700 (PDT)
Date:   Mon, 8 Jun 2020 02:32:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
Message-ID: <20200608021438-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010332-mutt-send-email-mst@kernel.org>
 <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
 <6b1d1ef3-d65e-08c2-5b65-32969bb5ecbc@redhat.com>
 <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 11:32:31AM +0800, Jason Wang wrote:
> 
> On 2020/6/7 下午9:51, Michael S. Tsirkin wrote:
> > On Fri, Jun 05, 2020 at 04:54:17PM +0800, Jason Wang wrote:
> > > On 2020/6/2 下午3:08, Jason Wang wrote:
> > > > > > +static const struct pci_device_id vp_vdpa_id_table[] = {
> > > > > > +    { PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> > > > > > +    { 0 }
> > > > > > +};
> > > > > This looks like it'll create a mess with either virtio pci
> > > > > or vdpa being loaded at random. Maybe just don't specify
> > > > > any IDs for now. Down the road we could get a
> > > > > distinct vendor ID or a range of device IDs for this.
> > > > 
> > > > Right, will do.
> > > > 
> > > > Thanks
> > > 
> > > Rethink about this. If we don't specify any ID, the binding won't work.
> > We can bind manually. It's not really for production anyway, so
> > not a big deal imho.
> 
> 
> I think you mean doing it via "new_id", right.

I really meant driver_override. This is what people have been using
with pci-stub for years now.

> 
> > 
> > > How about using a dedicated subsystem vendor id for this?
> > > 
> > > Thanks
> > If virtio vendor id is used then standard driver is expected
> > to bind, right? Maybe use a dedicated vendor id?
> 
> 
> I meant something like:
> 
> static const struct pci_device_id vp_vdpa_id_table[] = {
>     { PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID,
> VP_TEST_VENDOR_ID, VP_TEST_DEVICE_ID) },
>     { 0 }
> };
> 
> Thanks
> 

Then regular virtio will still bind to it. It has

drivers/virtio/virtio_pci_common.c:     { PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },


-- 
MST

