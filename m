Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4459DC028F
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfI0JlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 05:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfI0JlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 05:41:15 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E58826B
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 09:41:14 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id k53so4642247qtk.0
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 02:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hwNSPFXYcjt0ijpRdc1M38OvqU5g9p5x1VDMj8NBIGI=;
        b=nY6DuDTvHUMGE5O+bEKq07Yl0TDGknBPNXZzguSEKxhFpMweBmpR4El/kDaAtIWMJE
         2Pw3pTw1Wuo39Gfh2AQo5EUfdsdrl9ep48HR13B+LmBmm8d3xUXxOxzDDcJMxETbfMw2
         oJk/eJ9wgaDG0FtPM4erjdm0XcOmvTTggt4d9rvcw7y288raN0k4GlLGuPzUaxSoraN6
         H1NWj/SpI141I6fyBrBJQeAgJBGwho0wW4lyuB7gurp5+vTPdCx2+3jn1NgxyIpOTiaF
         5hYE2AaYuESapVvYOZGFBrgb0C9IVWtv750ZKhoWA3RY4vDw3JR/56RgxqnQU+WC9ZGH
         CWRg==
X-Gm-Message-State: APjAAAWhiaBYh7sbeuB0ChPtECxIHcmBnmZyESrvGU5trKwQXjGsE/hV
        35gxmSVrYcIL5VopBrgrOorWeHgLsuypwqObQkg8CPFdLEBNvmfgwls9V7sJykYhaaOoX5Jn/Vw
        HZbG5CIYfh+lF0Tsy
X-Received: by 2002:a37:aac8:: with SMTP id t191mr3503418qke.325.1569577274237;
        Fri, 27 Sep 2019 02:41:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw/89V+twr9hPNLSOQXPg0tKZiJPuTDeybpYPFwNhDmewmUrIv8Fs6bzVi79PPZFA45J2U/tg==
X-Received: by 2002:a37:aac8:: with SMTP id t191mr3503317qke.325.1569577272663;
        Fri, 27 Sep 2019 02:41:12 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id v26sm3013791qta.88.2019.09.27.02.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 02:41:11 -0700 (PDT)
Date:   Fri, 27 Sep 2019 05:41:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190927053935-mutt-send-email-mst@kernel.org>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <20190926042156-mutt-send-email-mst@kernel.org>
 <20190926131439.GA11652@___>
 <8ab5a8d9-284d-bba5-803d-08523c0814e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ab5a8d9-284d-bba5-803d-08523c0814e1@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 11:27:12AM +0800, Jason Wang wrote:
> 
> On 2019/9/26 下午9:14, Tiwei Bie wrote:
> > On Thu, Sep 26, 2019 at 04:35:18AM -0400, Michael S. Tsirkin wrote:
> > > On Thu, Sep 26, 2019 at 12:54:27PM +0800, Tiwei Bie wrote:
> > [...]
> > > > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > > > index 40d028eed645..5afbc2f08fa3 100644
> > > > --- a/include/uapi/linux/vhost.h
> > > > +++ b/include/uapi/linux/vhost.h
> > > > @@ -116,4 +116,12 @@
> > > >   #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> > > >   #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> > > > +/* VHOST_MDEV specific defines */
> > > > +
> > > > +#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
> > > > +
> > > > +#define VHOST_MDEV_S_STOPPED	0
> > > > +#define VHOST_MDEV_S_RUNNING	1
> > > > +#define VHOST_MDEV_S_MAX	2
> > > > +
> > > >   #endif
> > > So assuming we have an underlying device that behaves like virtio:
> > I think they are really good questions/suggestions. Thanks!
> > 
> > > 1. Should we use SET_STATUS maybe?
> > I like this idea. I will give it a try.
> > 
> > > 2. Do we want a reset ioctl?
> > I think it is helpful. If we use SET_STATUS, maybe we
> > can use it to support the reset.
> > 
> > > 3. Do we want ability to enable rings individually?
> > I will make it possible at least in the vhost layer.
> 
> 
> Note the API support e.g set_vq_ready().

virtio spec calls this "enabled" so let's stick to that.

> 
> > 
> > > 4. Does device need to limit max ring size?
> > > 5. Does device need to limit max number of queues?
> > I think so. It's helpful to have ioctls to report the max
> > ring size and max number of queues.
> 
> 
> An issue is the max number of queues is done through a device specific way,
> usually device configuration space. This is supported by the transport API,
> but how to expose it to userspace may need more thought.
> 
> Thanks

an ioctl for device config?  But for v1 I'd be quite happy to just have
a minimal working device with 2 queues.

> 
> > 
> > Thanks!
