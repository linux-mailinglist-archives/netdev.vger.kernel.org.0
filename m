Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0448EC0645
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfI0NX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10307 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfI0NX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 09:23:57 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7745F51EF8
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 13:23:56 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id r15so5680246qtn.12
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 06:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AyTMKGoGs/Lkq3kyZ5E07Ek1WWcR6PtX7h75NGzXR98=;
        b=UU4TxZ3yXWd83NoJvj6M6QdVOq6ZMSq1/uqIDlalXDvWb0elH2DbYu5fAjOA2gvotW
         aykZdZthAF+SMUaHgz/vbKxgiR8nJLR/5OyrW90O1bgoZd9uwBczDDvfwfgi1WGDYzdE
         Hat5HKZPgz7PMMuz09MZhUEmv0HJMzeo87Fr//OFvM6e+AJdJ9ghrgZ0pBnIM7D/v5QP
         FNKxBxincuVhbVG6E6dW/fznv+MDn7DM+Eon8L/VG4MPMrjRMUP9V0V6PEX1teCaGCB4
         OMnnTx+/EpjzKOsrQ/daGLD8Jd1PfEMjCGgA3hn04t6v+vgLdnm4kIhv9Q5cZ8HkrGmi
         xbNQ==
X-Gm-Message-State: APjAAAVbTl50nMM0RtRW7X9A4QyuclJ5tLchtcn8BBvp8q5IYyneeZjl
        LuLzcnXe8bV1k0P/jrR07ZtnbatApQqWBJzlElZcM48oBHlqVNyQPEVbypVSiNPdiw8Q+mJQGmG
        +GNDwKxbLUnRbAUZv
X-Received: by 2002:ae9:ebcc:: with SMTP id b195mr4157311qkg.387.1569590634432;
        Fri, 27 Sep 2019 06:23:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyd11e5rCRWe0bxFf6zGmoFapNlaYtDWeIQ/2TfJmDkfR/AHi55ZmXJPrcHHDUd2jtkidxpVA==
X-Received: by 2002:ae9:ebcc:: with SMTP id b195mr4157280qkg.387.1569590634189;
        Fri, 27 Sep 2019 06:23:54 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id m14sm1073230qki.27.2019.09.27.06.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 06:23:52 -0700 (PDT)
Date:   Fri, 27 Sep 2019 09:23:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190927092219-mutt-send-email-mst@kernel.org>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <20190926042156-mutt-send-email-mst@kernel.org>
 <20190926131439.GA11652@___>
 <8ab5a8d9-284d-bba5-803d-08523c0814e1@redhat.com>
 <20190927053935-mutt-send-email-mst@kernel.org>
 <a959fe1e-3095-e0f0-0c9b-57f6eaa9c8b7@redhat.com>
 <20190927084408-mutt-send-email-mst@kernel.org>
 <b6f6ffb2-0b16-5041-be2e-94b805c6a4c9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6f6ffb2-0b16-5041-be2e-94b805c6a4c9@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 09:17:56PM +0800, Jason Wang wrote:
> 
> On 2019/9/27 下午8:46, Michael S. Tsirkin wrote:
> > On Fri, Sep 27, 2019 at 08:17:47PM +0800, Jason Wang wrote:
> > > On 2019/9/27 下午5:41, Michael S. Tsirkin wrote:
> > > > On Fri, Sep 27, 2019 at 11:27:12AM +0800, Jason Wang wrote:
> > > > > On 2019/9/26 下午9:14, Tiwei Bie wrote:
> > > > > > On Thu, Sep 26, 2019 at 04:35:18AM -0400, Michael S. Tsirkin wrote:
> > > > > > > On Thu, Sep 26, 2019 at 12:54:27PM +0800, Tiwei Bie wrote:
> > > > > > [...]
> > > > > > > > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > > > > > > > index 40d028eed645..5afbc2f08fa3 100644
> > > > > > > > --- a/include/uapi/linux/vhost.h
> > > > > > > > +++ b/include/uapi/linux/vhost.h
> > > > > > > > @@ -116,4 +116,12 @@
> > > > > > > >     #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> > > > > > > >     #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> > > > > > > > +/* VHOST_MDEV specific defines */
> > > > > > > > +
> > > > > > > > +#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
> > > > > > > > +
> > > > > > > > +#define VHOST_MDEV_S_STOPPED	0
> > > > > > > > +#define VHOST_MDEV_S_RUNNING	1
> > > > > > > > +#define VHOST_MDEV_S_MAX	2
> > > > > > > > +
> > > > > > > >     #endif
> > > > > > > So assuming we have an underlying device that behaves like virtio:
> > > > > > I think they are really good questions/suggestions. Thanks!
> > > > > > 
> > > > > > > 1. Should we use SET_STATUS maybe?
> > > > > > I like this idea. I will give it a try.
> > > > > > 
> > > > > > > 2. Do we want a reset ioctl?
> > > > > > I think it is helpful. If we use SET_STATUS, maybe we
> > > > > > can use it to support the reset.
> > > > > > 
> > > > > > > 3. Do we want ability to enable rings individually?
> > > > > > I will make it possible at least in the vhost layer.
> > > > > Note the API support e.g set_vq_ready().
> > > > virtio spec calls this "enabled" so let's stick to that.
> > > 
> > > Ok.
> > > 
> > > 
> > > > > > > 4. Does device need to limit max ring size?
> > > > > > > 5. Does device need to limit max number of queues?
> > > > > > I think so. It's helpful to have ioctls to report the max
> > > > > > ring size and max number of queues.
> > > > > An issue is the max number of queues is done through a device specific way,
> > > > > usually device configuration space. This is supported by the transport API,
> > > > > but how to expose it to userspace may need more thought.
> > > > > 
> > > > > Thanks
> > > > an ioctl for device config?  But for v1 I'd be quite happy to just have
> > > > a minimal working device with 2 queues.
> > > 
> > > I'm fully agree, and it will work as long as VIRTIO_NET_F_MQ and
> > > VIRTIO_NET_F_CTRL_VQ is not advertised by the mdev device.
> > > 
> > > Thanks
> > Hmm this means we need to validate the features bits,
> > not just pass them through to the hardware.
> > Problem is, how do we add more feature bits later,
> > without testing all hardware?
> > I guess this means the device specific driver must do it.
> > 
> 
> That looks not good, maybe a virtio device id based features blacklist in
> vhost-mdev. Then MQ and CTRL_VQ could be filtered out by vhost-mdev.
> 
> Thanks

Two implementations of e.g. virtio net can have different
features whitelisted. So I think there's no way but let
the driver do it. We should probably provide a standard place
in the ops for driver to supply the whitelist, to make sure
drivers don't forget.

> 
> > > > > > Thanks!
