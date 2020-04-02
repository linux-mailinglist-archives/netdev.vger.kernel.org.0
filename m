Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A6219C472
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388580AbgDBOi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:38:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23919 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729166AbgDBOiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585838332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5zJId47dIDTUhCxWFjRzhT8S4/K1qhmpRh3SERFybFs=;
        b=E0ZDTEoGUYhe87qu7LwHt2F45sE4baeoxIYaR8HRqYMuAW7CMjKmxjcNmMGnXinzkkK6Yf
        q4afHK4oKodYFLsjw5/1OtlwYRvCZcEb++nF80LZr4AYYxFFCS1Uj8q5unoKo9MeCfo2jQ
        Cz8nI2OD1t/N0CtBlOTKqLytmzF015o=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-h1yzPTOoO9qvfSHHEbS3SQ-1; Thu, 02 Apr 2020 10:38:50 -0400
X-MC-Unique: h1yzPTOoO9qvfSHHEbS3SQ-1
Received: by mail-qt1-f197.google.com with SMTP id k46so3354340qta.2
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 07:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5zJId47dIDTUhCxWFjRzhT8S4/K1qhmpRh3SERFybFs=;
        b=CqDRkD9JNsE6ezsrcTnbvHiZHm9BXRLPrkkFavQlCXfgZ0SdjxlBWeBKh824MTmIlP
         MIedWJZCCICkITaCNHmhMhVv7fOFuNSWYlJDAjfKmHxGq+8IlpoRAL44KYRbgFD2TVjx
         Q1HPei74QMHj7QSucTZ1YfHZslow+ADK14QVQHqgZnF938vxDBOdITRTjgr7MhZJj0Oc
         Y1WScOcWy+DKWKBDyzHopQd418wzCjx0Pt3aTYQQ8lhauSXwYabyvluKK1T+b2NSk87V
         IqhuE6xky7MMj7Yx84N5yOmzK/wK+unix1mXohKrYhQ2IdPMnmVHQy2tAyCmrbC6x87K
         klnA==
X-Gm-Message-State: AGi0PuZTBR+Rd7wCW09lMOM/+qFm1QRjfnyy4HsivthBisrLCjlp2BfH
        vT4Ya23hyJL9X3R0+lAcQT1iQ1zluzQnTqxJ29x9xd4kqhB76HSJbC8uCA2X5Tg+Sw/jVsxQjSK
        6xEmd4B1nmPIsKSWX
X-Received: by 2002:ac8:24c1:: with SMTP id t1mr3248348qtt.275.1585838329494;
        Thu, 02 Apr 2020 07:38:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypLhy6AetkOXTZr7DRk6EDkALT/IdoKI3LjJeVYjOumPny6hIpCUhk1U1rDap04t/JdFxAlwBg==
X-Received: by 2002:ac8:24c1:: with SMTP id t1mr3248313qtt.275.1585838329193;
        Thu, 02 Apr 2020 07:38:49 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id q1sm3489017qtn.69.2020.04.02.07.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:38:48 -0700 (PDT)
Date:   Thu, 2 Apr 2020 10:38:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
Message-ID: <20200402103813-mutt-send-email-mst@kernel.org>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <20200401092004-mutt-send-email-mst@kernel.org>
 <6b4d169a-9962-6014-5423-1507059343e9@redhat.com>
 <20200401100954-mutt-send-email-mst@kernel.org>
 <3dd3b7e7-e3d9-dba4-00fc-868081f95ab7@redhat.com>
 <20200401120643-mutt-send-email-mst@kernel.org>
 <c11c2195-88eb-2096-af47-40f2da5b389f@redhat.com>
 <20200402100257-mutt-send-email-mst@kernel.org>
 <279ed96c-5331-9da6-f9c1-b49e87d49c31@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <279ed96c-5331-9da6-f9c1-b49e87d49c31@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 10:23:59PM +0800, Jason Wang wrote:
> 
> On 2020/4/2 下午10:03, Michael S. Tsirkin wrote:
> > On Thu, Apr 02, 2020 at 11:22:57AM +0800, Jason Wang wrote:
> > > On 2020/4/2 上午12:08, Michael S. Tsirkin wrote:
> > > > On Wed, Apr 01, 2020 at 10:29:32PM +0800, Jason Wang wrote:
> > > > > >From 9b3a5d23b8bf6b0a11e65e688335d782f8e6aa5c Mon Sep 17 00:00:00 2001
> > > > > From: Jason Wang <jasowang@redhat.com>
> > > > > Date: Wed, 1 Apr 2020 22:17:27 +0800
> > > > > Subject: [PATCH] vhost: let CONFIG_VHOST to be selected by drivers
> > > > > 
> > > > > The defconfig on some archs enable vhost_net or vhost_vsock by
> > > > > default. So instead of adding CONFIG_VHOST=m to all of those files,
> > > > > simply letting CONFIG_VHOST to be selected by all of the vhost
> > > > > drivers. This fixes the build on the archs with CONFIG_VHOST_NET=m in
> > > > > their defconfig.
> > > > > 
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > ---
> > > > >    drivers/vhost/Kconfig | 15 +++++++++++----
> > > > >    1 file changed, 11 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > > > > index 2523a1d4290a..362b832f5338 100644
> > > > > --- a/drivers/vhost/Kconfig
> > > > > +++ b/drivers/vhost/Kconfig
> > > > > @@ -11,19 +11,23 @@ config VHOST_RING
> > > > >    	  This option is selected by any driver which needs to access
> > > > >    	  the host side of a virtio ring.
> > > > > -menuconfig VHOST
> > > > > -	tristate "Host kernel accelerator for virtio (VHOST)"
> > > > > -	depends on EVENTFD
> > > > > +config VHOST
> > > > > +	tristate
> > > > >    	select VHOST_IOTLB
> > > > >    	help
> > > > >    	  This option is selected by any driver which needs to access
> > > > >    	  the core of vhost.
> > > > > -if VHOST
> > > > > +menuconfig VHOST_MENU
> > > > > +	bool "VHOST drivers"
> > > > > +	default y
> > > > > +
> > > > > +if VHOST_MENU
> > > > >    config VHOST_NET
> > > > >    	tristate "Host kernel accelerator for virtio net"
> > > > >    	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> > > > > +	select VHOST
> > > > >    	---help---
> > > > >    	  This kernel module can be loaded in host kernel to accelerate
> > > > >    	  guest networking with virtio_net. Not to be confused with virtio_net
> > > > > @@ -35,6 +39,7 @@ config VHOST_NET
> > > > >    config VHOST_SCSI
> > > > >    	tristate "VHOST_SCSI TCM fabric driver"
> > > > >    	depends on TARGET_CORE && EVENTFD
> > > > > +	select VHOST
> > > > >    	default n
> > > > >    	---help---
> > > > >    	Say M here to enable the vhost_scsi TCM fabric module
> > > > > @@ -43,6 +48,7 @@ config VHOST_SCSI
> > > > >    config VHOST_VSOCK
> > > > >    	tristate "vhost virtio-vsock driver"
> > > > >    	depends on VSOCKETS && EVENTFD
> > > > > +	select VHOST
> > > > >    	select VIRTIO_VSOCKETS_COMMON
> > > > >    	default n
> > > > >    	---help---
> > > > > @@ -56,6 +62,7 @@ config VHOST_VSOCK
> > > > >    config VHOST_VDPA
> > > > >    	tristate "Vhost driver for vDPA-based backend"
> > > > >    	depends on EVENTFD
> > > > > +	select VHOST
> > > 
> > > This part is not squashed.
> > > 
> > > 
> > > > >    	select VDPA
> > > > >    	help
> > > > >    	  This kernel module can be loaded in host kernel to accelerate
> > > > OK so I squashed this into the original buggy patch.
> > > > Could you please play with vhost branch of my tree on various
> > > > arches? If it looks ok to you let me know I'll push
> > > > this to next.
> > > 
> > > With the above part squashed. I've tested all the archs whose defconfig have
> > > VHOST_NET or VHOST_VSOCK enabled.
> > > 
> > > All looks fine.
> > > 
> > > Thanks
> > 
> > I'm a bit confused. So is the next tag in my tree ok now?
> 
> 
> Still need to select CONFIG_VHOST for  CONFIG_VHOST_VDPA. Others are ok.
> 
> Thanks


Oh like this then?

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index bdd270fede26..cb6b17323eb2 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -61,6 +63,7 @@ config VHOST_VSOCK
 config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
 	depends on EVENTFD
+	select VHOST
 	select VDPA
 	help
 	  This kernel module can be loaded in host kernel to accelerate

