Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B3FBF3EA
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfIZNRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:17:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:28880 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfIZNR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 09:17:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 06:17:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="194124583"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.73])
  by orsmga006.jf.intel.com with ESMTP; 26 Sep 2019 06:17:26 -0700
Date:   Thu, 26 Sep 2019 21:14:39 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190926131439.GA11652@___>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <20190926042156-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190926042156-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 04:35:18AM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 26, 2019 at 12:54:27PM +0800, Tiwei Bie wrote:
[...]
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index 40d028eed645..5afbc2f08fa3 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -116,4 +116,12 @@
> >  #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> >  #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> >  
> > +/* VHOST_MDEV specific defines */
> > +
> > +#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
> > +
> > +#define VHOST_MDEV_S_STOPPED	0
> > +#define VHOST_MDEV_S_RUNNING	1
> > +#define VHOST_MDEV_S_MAX	2
> > +
> >  #endif
> 
> So assuming we have an underlying device that behaves like virtio:

I think they are really good questions/suggestions. Thanks!

> 
> 1. Should we use SET_STATUS maybe?

I like this idea. I will give it a try.

> 2. Do we want a reset ioctl?

I think it is helpful. If we use SET_STATUS, maybe we
can use it to support the reset.

> 3. Do we want ability to enable rings individually?

I will make it possible at least in the vhost layer.

> 4. Does device need to limit max ring size?
> 5. Does device need to limit max number of queues?

I think so. It's helpful to have ioctls to report the max
ring size and max number of queues.

Thanks!
Tiwei


> 
> -- 
> MST
