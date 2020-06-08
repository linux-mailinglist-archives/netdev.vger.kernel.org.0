Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6FC1F15ED
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 11:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgFHJzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 05:55:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25000 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729227AbgFHJzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 05:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591610106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zwRQYwEhlzI9fhHIuV2ZDsHSs0DHTOaRaWRbv3sTP+c=;
        b=d/12E/PTZZOS/m71x9FcAvx0JclAsrIKYJnZ3jHZtixotEEjN547/6UBhSSmi41G0KUuPB
        pqZqIjVfdUC7xacohLVbGSNhF9IjRUTWyr5NnKCVoACZ6rqu96iLbqaQpntQFBXeKK0npj
        wXTsg66DIgitT1UHYMUPnFhY9jeC4gI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468--dj-sFyfMSaPYjuOYYFXTA-1; Mon, 08 Jun 2020 05:55:04 -0400
X-MC-Unique: -dj-sFyfMSaPYjuOYYFXTA-1
Received: by mail-wm1-f71.google.com with SMTP id 11so3743884wmj.6
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 02:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zwRQYwEhlzI9fhHIuV2ZDsHSs0DHTOaRaWRbv3sTP+c=;
        b=T3Hx+Gjl2r9FimSUmwGgUCTj24/+8TSw145ndqsZjdBAdc2lTYfdKSn5SaNltiwS5N
         1JdlO7Dq/B2kWap1T0naJkQjDYlJ7VaRy5B1jL1ATW1xPmvwd8FRNgQspx1ZEgPSRsZi
         IUGNoDal6jKc0JLvDy06IVffMNH8bC+Gb35riGfwBZkngz9AJur49ljY64lXtvFMKzX9
         SoQTHQTeMUOAd/PsK0ZQGYiTLyfo++fMu61I5mY/jbKdTuEF4VB6Y9xP9OyW7lS2n2f6
         AsZmWJMkAtJoYJkuQCCyYAORVoUE3S9+LVDQIyEXPeGt702/rs9Wmjcs/7NieHyITbER
         Bhig==
X-Gm-Message-State: AOAM530qspUaCjziwCQNAVlyZcMoClMxTMUwrscQLEafD8JmXj9uLPso
        7mNRDPmGyqggbRXZdl8O4BhWw7mDzmVuHHwoPUf5RrNRrStKKLlc68P4OYNCHj5yREjBn2Lr4gW
        NoBe6jjbCPwAecfLx
X-Received: by 2002:a7b:cf06:: with SMTP id l6mr15633408wmg.63.1591610103134;
        Mon, 08 Jun 2020 02:55:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyikeAcTqFLpMRWXI7wepdD3aO0/ujjV4fOTEz+k46ZIFoeVHzdsv1BhrAhul2cvz6zw90caQ==
X-Received: by 2002:a7b:cf06:: with SMTP id l6mr15633384wmg.63.1591610102957;
        Mon, 08 Jun 2020 02:55:02 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id o15sm23160537wrv.48.2020.06.08.02.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 02:55:02 -0700 (PDT)
Date:   Mon, 8 Jun 2020 05:54:59 -0400
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
Message-ID: <20200608055331-mutt-send-email-mst@kernel.org>
References: <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
 <6b1d1ef3-d65e-08c2-5b65-32969bb5ecbc@redhat.com>
 <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
 <20200608052041-mutt-send-email-mst@kernel.org>
 <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
 <20200608054453-mutt-send-email-mst@kernel.org>
 <bc27064c-2309-acf3-ccd8-6182bfa2a4cd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc27064c-2309-acf3-ccd8-6182bfa2a4cd@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 05:46:52PM +0800, Jason Wang wrote:
> 
> On 2020/6/8 下午5:45, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2020 at 05:43:58PM +0800, Jason Wang wrote:
> > > > > Looking at
> > > > > pci_match_one_device() it checks both subvendor and subdevice there.
> > > > > 
> > > > > Thanks
> > > > But IIUC there is no guarantee that driver with a specific subvendor
> > > > matches in presence of a generic one.
> > > > So either IFC or virtio pci can win, whichever binds first.
> > > 
> > > I'm not sure I get there. But I try manually bind IFCVF to qemu's
> > > virtio-net-pci, and it fails.
> > > 
> > > Thanks
> > Right but the reverse can happen: virtio-net can bind to IFCVF first.
> 
> 
> That's kind of expected. The PF is expected to be bound to virtio-pci to
> create VF via sysfs.
> 
> Thanks
> 
> 
> 

Once VFs are created, don't we want IFCVF to bind rather than
virtio-pci?

-- 
MST

