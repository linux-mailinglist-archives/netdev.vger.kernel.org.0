Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056C719ADCD
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbgDAO1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:27:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732843AbgDAO1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585751254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AC+xCtqiJYVKw8uvibXZdquPbYJhxrP3dh8NvWfdbEs=;
        b=Iqv/Hu9ta1nL+IuVNpRxKg2Pap3SV5q848wQQFuMKL3I3zaQIQm9xjvyeDBLCsplthU+K4
        KXx8lnOxf07f6oIgpHN7k7bFinmmrLObwMPX1f+E3VoIAnSOyV8WodXTj4DKDwcrfNyJJf
        MRoZ7Ja+nEB2mYVqavT6A6T2WoQNnPA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-8LRaKMNKMNCkz5JhuQ2PAw-1; Wed, 01 Apr 2020 10:27:31 -0400
X-MC-Unique: 8LRaKMNKMNCkz5JhuQ2PAw-1
Received: by mail-wr1-f69.google.com with SMTP id h95so9416543wrh.11
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 07:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AC+xCtqiJYVKw8uvibXZdquPbYJhxrP3dh8NvWfdbEs=;
        b=kl17eafFrAXT/iwoQNZmR7xLYKOAibOlU/RW3js01kNsKvhWSzPPZi3aeuohtKeVPu
         7G88wZTfUU+GKEsWH+2dO1bLXwrKkbJtw3E/PjQLbcp+Lsuf5RPd53bLRFqeEtjRVwmY
         ZKLsYKuuHX+W4z0RM6HiFCDYMLfvIF2VkPc+PzkuesSAdwNOIhXgroqJEAV7C3QjBkcj
         Hfbr5tm0EeWDMjyXxnDrocuGvuKpjVBWuRsYzgROZqdLq8/M2DOAhpLsGypK1rplXuDS
         j8EWb9xNTD/oZMrqSvZEA1fOQE1ahuPyZg8LsUfBTRbMEh+24YF3FkgQWHj1XHg1elhH
         z3Tw==
X-Gm-Message-State: AGi0PuYKLLaGgj/+1TuA4cGiVdO9kncp/QNwdi1pW6eGDFLJI617oHCo
        IXB3HeL8r5i/F3yK/1l870O/D7cocc94Yv7hBATOVT+VGjiy4HyhJYO9HQQOkC/nko0kbXkQpk8
        nc8TdrkmyOv6t3HCD
X-Received: by 2002:a1c:7d83:: with SMTP id y125mr4743871wmc.21.1585751249839;
        Wed, 01 Apr 2020 07:27:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypJJt7lJi60JuKAIp/rXIjmTJwlS5cY9W7TmEAMkhxUGDg3AMcGVYKQShXzSwPvJ9KNLjAunKg==
X-Received: by 2002:a1c:7d83:: with SMTP id y125mr4743844wmc.21.1585751249553;
        Wed, 01 Apr 2020 07:27:29 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id b127sm635666wmd.2.2020.04.01.07.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 07:27:28 -0700 (PDT)
Date:   Wed, 1 Apr 2020 10:27:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
Message-ID: <20200401102631-mutt-send-email-mst@kernel.org>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <fde312a4-56bd-f11f-799f-8aa952008012@de.ibm.com>
 <41ee1f6a-3124-d44b-bf34-0f26604f9514@redhat.com>
 <4726da4c-11ec-3b6e-1218-6d6d365d5038@de.ibm.com>
 <39b96e3a-9f4e-6e1d-e988-8c4bcfb55879@de.ibm.com>
 <c423c5b1-7817-7417-d7af-e07bef6368e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c423c5b1-7817-7417-d7af-e07bef6368e7@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 10:13:29PM +0800, Jason Wang wrote:
> 
> On 2020/4/1 下午9:02, Christian Borntraeger wrote:
> > 
> > On 01.04.20 14:56, Christian Borntraeger wrote:
> > > On 01.04.20 14:50, Jason Wang wrote:
> > > > On 2020/4/1 下午7:21, Christian Borntraeger wrote:
> > > > > On 26.03.20 15:01, Jason Wang wrote:
> > > > > > Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
> > > > > > not necessarily for VM since it's a generic userspace and kernel
> > > > > > communication protocol. Such dependency may prevent archs without
> > > > > > virtualization support from using vhost.
> > > > > > 
> > > > > > To solve this, a dedicated vhost menu is created under drivers so
> > > > > > CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
> > > > > FWIW, this now results in vhost not being build with defconfig kernels (in todays
> > > > > linux-next).
> > > > > 
> > > > Hi Christian:
> > > > 
> > > > Did you meet it even with this commit https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=a4be40cbcedba9b5b714f3c95182e8a45176e42d?
> > > I simply used linux-next. The defconfig does NOT contain CONFIG_VHOST and therefore CONFIG_VHOST_NET and friends
> > > can not be selected.
> > > 
> > > $ git checkout next-20200401
> > > $ make defconfig
> > >    HOSTCC  scripts/basic/fixdep
> > >    HOSTCC  scripts/kconfig/conf.o
> > >    HOSTCC  scripts/kconfig/confdata.o
> > >    HOSTCC  scripts/kconfig/expr.o
> > >    LEX     scripts/kconfig/lexer.lex.c
> > >    YACC    scripts/kconfig/parser.tab.[ch]
> > >    HOSTCC  scripts/kconfig/lexer.lex.o
> > >    HOSTCC  scripts/kconfig/parser.tab.o
> > >    HOSTCC  scripts/kconfig/preprocess.o
> > >    HOSTCC  scripts/kconfig/symbol.o
> > >    HOSTCC  scripts/kconfig/util.o
> > >    HOSTLD  scripts/kconfig/conf
> > > *** Default configuration is based on 'x86_64_defconfig'
> > > #
> > > # configuration written to .config
> > > #
> > > 
> > > $ grep VHOST .config
> > > # CONFIG_VHOST is not set
> > > 
> > > > If yes, what's your build config looks like?
> > > > 
> > > > Thanks
> > This was x86. Not sure if that did work before.
> > On s390 this is definitely a regression as the defconfig files
> > for s390 do select VHOST_NET
> > 
> > grep VHOST arch/s390/configs/*
> > arch/s390/configs/debug_defconfig:CONFIG_VHOST_NET=m
> > arch/s390/configs/debug_defconfig:CONFIG_VHOST_VSOCK=m
> > arch/s390/configs/defconfig:CONFIG_VHOST_NET=m
> > arch/s390/configs/defconfig:CONFIG_VHOST_VSOCK=m
> > 
> > and this worked with 5.6, but does not work with next. Just adding
> > CONFIG_VHOST=m to the defconfig solves the issue, something like
> 
> 
> Right, I think we probably need
> 
> 1) add CONFIG_VHOST=m to all defconfigs that enables
> CONFIG_VHOST_NET/VSOCK/SCSI.
> 
> or
> 
> 2) don't use menuconfig for CONFIG_VHOST, let NET/SCSI/VDPA just select it.
> 
> Thanks

OK I tried this:

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 2523a1d4290a..a314b900d479 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -19,11 +19,10 @@ menuconfig VHOST
 	  This option is selected by any driver which needs to access
 	  the core of vhost.
 
-if VHOST
-
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net"
 	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
+	select VHOST
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
@@ -35,6 +34,7 @@ config VHOST_NET
 config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
 	depends on TARGET_CORE && EVENTFD
+	select VHOST
 	default n
 	---help---
 	Say M here to enable the vhost_scsi TCM fabric module
@@ -44,6 +44,7 @@ config VHOST_VSOCK
 	tristate "vhost virtio-vsock driver"
 	depends on VSOCKETS && EVENTFD
 	select VIRTIO_VSOCKETS_COMMON
+	select VHOST
 	default n
 	---help---
 	This kernel module can be loaded in the host kernel to provide AF_VSOCK
@@ -57,6 +58,7 @@ config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
 	depends on EVENTFD
 	select VDPA
+	select VHOST
 	help
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest virtio devices with the vDPA-based backends.
@@ -78,5 +80,3 @@ config VHOST_CROSS_ENDIAN_LEGACY
 	  adds some overhead, it is disabled by default.
 
 	  If unsure, say "N".
-
-endif


But now CONFIG_VHOST is always "y", never "m".
Which I think will make it a built-in.
Didn't figure out why yet.

-- 
MST

