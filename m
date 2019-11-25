Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43FD1085D8
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 01:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfKYAHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 19:07:24 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46201 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfKYAHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 19:07:23 -0500
Received: by mail-qk1-f193.google.com with SMTP id h15so11150112qka.13
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 16:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3rsb5F1lHDE0CtRm2IxSUtJl5mFdVSKdIea1SqS+ca4=;
        b=OEcqqqrYJWOW+bzPRo++X/WVd6nNBEPqgOZ9kqgUsizO0SfZ493yMpQ/TjxV08a1mz
         IyoC3UJaMSyis/AjASzFxl7rvShDvSSlxLhteVxWci5UEW8FliAUaT+jQ1wQxYrv/kZB
         3nqYGjYqkka0PTw9kzX+sl7YGHzFITVxGfv+WMhPvSIyYjqWQVKy89looWAA3m71kwCs
         t0qDCN3MM0EaHOkIsCk1TvD2R1ich61hUEiyJRyZ1t3yVJa0WuQ10gRni5YwMjpBjqwK
         hzUFcRBX88wmLHIpcUKIK15KIXmPm6DCOs10YbmbFRD3SpgjVUXKkLaxlbFtw7WYbYgS
         2q3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3rsb5F1lHDE0CtRm2IxSUtJl5mFdVSKdIea1SqS+ca4=;
        b=F+7hqNmxo8tVBYIvZjCFAwr0TNOpFTtL8K8aADj8GHEhb/xJ17rX1oALIbjwInHPM7
         ZKAG3bQznQwriS7ipYS/l/0ztTBY0/OGpDUTQotnX1OUZ79y07kZOUma7dD5OPAaIWP8
         WoTQdb15r9DVkvjmX6Rvy9YE5Jn9Y4UYrVpSZesZFuoex/1vP08H87/CGvkcleOVE74X
         sro0rBzhEZ3HDgafT6C9VoTe66tR3KdL4rOMV+c4IwBg2DzlRnYrhtDZ8Og7Trd+91un
         XL8JaUMT23a9ztwIeYoKXp3J80ONHmSGx64UipgFQr89uqA4D05x+1MD5FrLZgTICGiF
         OguQ==
X-Gm-Message-State: APjAAAW9RNnKe7UdLj48P7rjXH7vqVkP0CvSdqsVHYhNczxODu8GIDx1
        1Cfhy2o706EprJTKDC9e8bPv0Q==
X-Google-Smtp-Source: APXvYqzEpOwLyu/rW0agYok2J8h7WtbxM68b/aqFwCJe1aRLrj6X3mdGRpEyyuOBh+GCEqHb5ne5kA==
X-Received: by 2002:a37:9a13:: with SMTP id c19mr6967608qke.365.1574640442354;
        Sun, 24 Nov 2019 16:07:22 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id i68sm2481824qkb.106.2019.11.24.16.07.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 24 Nov 2019 16:07:21 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iZ1uS-0001dp-Un; Sun, 24 Nov 2019 20:07:20 -0400
Date:   Sun, 24 Nov 2019 20:07:20 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191125000720.GA5634@ziepe.ca>
References: <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
 <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
 <20191122180214.GD7448@ziepe.ca>
 <20191123043951.GA364267@___>
 <20191123230948.GF7448@ziepe.ca>
 <20191124055343-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191124055343-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 06:00:23AM -0500, Michael S. Tsirkin wrote:
> On Sat, Nov 23, 2019 at 07:09:48PM -0400, Jason Gunthorpe wrote:
> > > > > > Further, I do not think it is wise to design the userspace ABI around
> > > > > > a simplistict implementation that can't do BAR assignment,
> > > > > 
> > > > > Again, the vhost-mdev follow the VFIO ABI, no new ABI is invented, and
> > > > > mmap() was kept their for mapping device regions.
> > > > 
> > > > The patches have a new file in include/uapi.
> > > 
> > > I guess you didn't look at the code. Just to clarify, there is no
> > > new file introduced in include/uapi. Only small vhost extensions to
> > > the existing vhost uapi are involved in vhost-mdev.
> > 
> > You know, I review alot of patches every week, and sometimes I make
> > mistakes, but not this time. From the ICF cover letter:
> > 
> > https://lkml.org/lkml/2019/11/7/62
> > 
> >  drivers/vfio/mdev/mdev_core.c    |  21 ++
> >  drivers/vhost/Kconfig            |  12 +
> >  drivers/vhost/Makefile           |   3 +
> >  drivers/vhost/mdev.c             | 556 +++++++++++++++++++++++++++++++
> >  include/linux/mdev.h             |   5 +
> >  include/uapi/linux/vhost.h       |  21 ++
> >  include/uapi/linux/vhost_types.h |   8 +
> >       ^^^^^^^^^^^^^^
> > 
> > Perhaps you thought I ment ICF was adding uapi? My remarks cover all
> > three of the series involved here.
> 
> Tiwei seems to be right - include/uapi/linux/vhost.h and
> include/uapi/linux/vhost_types.h are both existing files.  vhost uapi
> extensions included here are very modest. They
> just add virtio spec things that vhost was missing.

Sigh, fine whatever, I mispoke and called the 7 new ioctls a 'new
file' instead of 'new ioctls' when responding to someone who denied
they even existed. 

Anyhow why do both of you keep saying "small vhost extensions to the
existing vhost uapi" when these 7 new ioctls appear to be connected to
vfio_device_ops, and /dev/vfio ?

Oh, gross, this is running some existing ioctl interface over
/dev/vfio - the new uABI here is really putting all 10 new ioctls on
/dev/vfio that didn't exist there before.

Jason
