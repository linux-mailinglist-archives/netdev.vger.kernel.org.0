Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC83221C77
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 08:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgGPGPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 02:15:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41428 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727965AbgGPGPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 02:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594880130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M4FS4yzYrjpQnMFv5QUa2bTajd8sHiv/1qfXLXjqecQ=;
        b=X9Z6/m/eP45xHAT+IuJ3kHm+p8wAXxDFY2ekpVhTEOPKvWWoskB+gNdg7iD+8H2YgrMNX1
        2rG07YyQSMp88cGVZwehoUWQh3E+OmCCVI22HPymDOSVplc6MUQcAwBCuFmsjU0yBK7FiZ
        jqz83ibxDYgbM7i5IEGhqOseUbwhyYI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-dRH0QJGgOUenb5aYv5kU-A-1; Thu, 16 Jul 2020 02:15:29 -0400
X-MC-Unique: dRH0QJGgOUenb5aYv5kU-A-1
Received: by mail-wm1-f72.google.com with SMTP id v6so4154124wmg.1
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 23:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=M4FS4yzYrjpQnMFv5QUa2bTajd8sHiv/1qfXLXjqecQ=;
        b=VUc3DWMAmrGXYqID3LVxtcBVO0LaH7EfFkdzNwVpZ3xwbiLhsO7MbDhpziFUsrrTEz
         J5KmtPL5n3M7algHD2jw9YhxNGdPk5ruLPObMQwK0Kqh63PXbVaTETye1KRc+iuvR/Bw
         xdwVVr5oFVNpFVi7WEqSjRISZYm4g+FnaqZpwS33aaaXw6KMc0HCQtYg0xdVx5y6xFHK
         o7Yk+Nhyeb+VJCuts3w1pWv5z0hG3SW/mvFbpsSfZ4XuUGdXGvBqG5+cwk2u5d1PrXA/
         K8qbR3sUSoA1IPm14+UqybNsVkXolgfXKcF0mU3dOrOwmvzk/2+Oqg9co5K3j25X9Ozd
         NbHg==
X-Gm-Message-State: AOAM532GZRNtRljQGQf4y3cbKjIYr4zRdxuLwmfrQdjJGO+zObJjxklL
        CTerHmSE8TEnx9pqlWYDh+A/lqQS9bXSuG/GJr7MIFXYkIgpSfgBmd2dsyU8MFlrqYVuDjy5H1X
        MQ1ZW7Q7kVv7FJ3Sn
X-Received: by 2002:adf:cc85:: with SMTP id p5mr3315904wrj.273.1594880127877;
        Wed, 15 Jul 2020 23:15:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpXKQQdIeqinuWsERGiaLq/STljNJxBfiy4+NiiUehwjdb/coh4z5EcaCuvTh+krGRLDMqrA==
X-Received: by 2002:adf:cc85:: with SMTP id p5mr3315877wrj.273.1594880127633;
        Wed, 15 Jul 2020 23:15:27 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id l67sm7715417wml.13.2020.07.15.23.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 23:15:26 -0700 (PDT)
Date:   Thu, 16 Jul 2020 02:15:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex williamson <alex.williamson@redhat.com>,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        dan daly <dan.daly@intel.com>
Subject: Re: [PATCH 0/7] *** IRQ offloading for vDPA ***
Message-ID: <20200716021435-mutt-send-email-mst@kernel.org>
References: <1594565524-3394-1-git-send-email-lingshan.zhu@intel.com>
 <70244d80-08a4-da91-3226-7bfd2019467e@redhat.com>
 <97032c51-3265-c94a-9ce1-f42fcc6d3075@intel.com>
 <77318609-85ef-f169-2a1e-500473976d84@redhat.com>
 <29ab6da8-ed8e-6b91-d658-f3d240543b29@intel.com>
 <1e91d9dd-d787-beff-2c14-9c76ffc3b285@redhat.com>
 <a319cba3-8b3d-8968-0fb7-48a1d34042bf@intel.com>
 <67c4c41d-9e95-2270-4acb-6f04668c34fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67c4c41d-9e95-2270-4acb-6f04668c34fa@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 12:20:09PM +0800, Jason Wang wrote:
> 
> On 2020/7/16 下午12:13, Zhu, Lingshan wrote:
> > 
> > 
> > On 7/16/2020 12:02 PM, Jason Wang wrote:
> > > 
> > > On 2020/7/16 上午11:59, Zhu, Lingshan wrote:
> > > > 
> > > > On 7/16/2020 10:59 AM, Jason Wang wrote:
> > > > > 
> > > > > On 2020/7/16 上午9:39, Zhu, Lingshan wrote:
> > > > > > 
> > > > > > 
> > > > > > On 7/15/2020 9:43 PM, Jason Wang wrote:
> > > > > > > 
> > > > > > > On 2020/7/12 下午10:52, Zhu Lingshan wrote:
> > > > > > > > Hi All,
> > > > > > > > 
> > > > > > > > This series intends to implement IRQ offloading for
> > > > > > > > vhost_vdpa.
> > > > > > > > 
> > > > > > > > By the feat of irq forwarding facilities like posted
> > > > > > > > interrupt on X86, irq bypass can  help deliver
> > > > > > > > interrupts to vCPU directly.
> > > > > > > > 
> > > > > > > > vDPA devices have dedicated hardware backends like VFIO
> > > > > > > > pass-throughed devices. So it would be possible to setup
> > > > > > > > irq offloading(irq bypass) for vDPA devices and gain
> > > > > > > > performance improvements.
> > > > > > > > 
> > > > > > > > In my testing, with this feature, we can save 0.1ms
> > > > > > > > in a ping between two VFs on average.
> > > > > > > 
> > > > > > > 
> > > > > > > Hi Lingshan:
> > > > > > > 
> > > > > > > During the virtio-networking meeting, Michael spots
> > > > > > > two possible issues:
> > > > > > > 
> > > > > > > 1) do we need an new uAPI to stop the irq offloading?
> > > > > > > 2) can interrupt lost during the eventfd ctx?
> > > > > > > 
> > > > > > > For 1) I think we probably not, we can allocate an
> > > > > > > independent eventfd which does not map to MSIX. So
> > > > > > > the consumer can't match the producer and we
> > > > > > > fallback to eventfd based irq.
> > > > > > Hi Jason,
> > > > > > 
> > > > > > I wonder why we need to stop irq offloading, but if we
> > > > > > need to do so, maybe a new uAPI would be more intuitive
> > > > > > to me,
> > > > > > but why and who(user? qemu?) shall initialize this
> > > > > > process, based on what kinda of basis to make the
> > > > > > decision?
> > > > > 
> > > > > 
> > > > > The reason is we may want to fallback to software datapath
> > > > > for some reason (e.g software assisted live migration). In
> > > > > this case we need intercept device write to used ring so we
> > > > > can not offloading virtqueue interrupt in this case.
> > > > so add a VHOST_VDPA_STOP_IRQ_OFFLOADING? Then do we need a
> > > > VHOST_VDPA_START_IRQ_OFFLOADING, then let userspace fully
> > > > control this? Or any better approaches?
> > > 
> > > 
> > > Probably not, it's as simple as allocating another eventfd (but not
> > > irqfd), and pass it to vhost-vdpa. Then the offloading is disabled
> > > since it doesn't have a consumer.
> > OK, sounds like QEMU work, no need to take care in this series, right?
> 
> 
> That's my understanding.
> 
> Thanks

Let's confirm a switch happens atomically so each interrupt
is sent either to eventfd to guest directly though.

> 
> > 
> > Thanks,
> > BR
> > Zhu Lingshan
> > > 
> > > Thanks
> > > 
> > > 

