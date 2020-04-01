Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A734919AF2A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733207AbgDAP50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 11:57:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21741 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732799AbgDAP50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 11:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585756643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJvti0HQwxkGVr50UmLlXHEkmoOLavfcErw++olR+Jo=;
        b=YU2bBKijT6CWfrdyETj97cBby7OAxjy+9Tjzjo0un7WxfanqWalS7+CJrBQLBSKHKHTZ/j
        /mFM/TDfZ0n/qK4H66umu1KI+trEAME7vlIEQksmebmEQxmmj1yEylP+BeAbcP8F1HXg6E
        haFyn9dwESBgZhL+/o61uP9wUCVLqfU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-F_JHmoLaNI2TH7B6vMD2OA-1; Wed, 01 Apr 2020 11:57:20 -0400
X-MC-Unique: F_JHmoLaNI2TH7B6vMD2OA-1
Received: by mail-wr1-f69.google.com with SMTP id f15so50247wrt.4
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 08:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MJvti0HQwxkGVr50UmLlXHEkmoOLavfcErw++olR+Jo=;
        b=CYYBdjR4bQ5OW5LhxRy6fIBRh1PHHp0YBP4Qhje9JY+K+EWuOfvN1li7hxLDkYOYTr
         IJJfrNiVDAqGeyrzjJtUOWyTYSnA1Y97lKRUS0mHPr1mFZmVmo6MUZJ2NbVXPJsU10Fw
         jESditRSIYkr3fU5bQv/T9a9R89RSyWtSc2KW5c0c+j3klKxiuJHvNrapvMeNFXtiDZt
         DJbh84ij3lHKmr81GoAu2jWrySKX88i8sqnxjyT2UU813WsFSkxn2R+Kx54ZAgVrA7Tr
         iIJwwlS3YVuE4yvrT00licZrf4KBbzyuO2m3UfHoTi0U099dFs6iuAmd5IRIFvwVu00S
         ke4A==
X-Gm-Message-State: AGi0PuYpDoV5zG2qlkLw6Hw0MrjeX+AeMA6Wdsj+B2vM5szzVXWInEiu
        Ja7xDFpOE7PzR8f0q1K8ihXyPLpM5HUSB0S4gvXWhCY3vNoeBXjxdZ5qR1ILLYCIE/RcD1XW6Ts
        WjnA6W8Z6q2aC1htc
X-Received: by 2002:a1c:1942:: with SMTP id 63mr5209051wmz.133.1585756639450;
        Wed, 01 Apr 2020 08:57:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypKA2aA36/p1yS+4iSBINIMZYbsrQcGfbJmIXDjaLpAeYKGxwb5JBIS+CYjNIECD0H1M4kXpUQ==
X-Received: by 2002:a1c:1942:: with SMTP id 63mr5209012wmz.133.1585756639201;
        Wed, 01 Apr 2020 08:57:19 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id a8sm2954348wmb.39.2020.04.01.08.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 08:57:18 -0700 (PDT)
Date:   Wed, 1 Apr 2020 11:57:14 -0400
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
Message-ID: <20200401115650-mutt-send-email-mst@kernel.org>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <fde312a4-56bd-f11f-799f-8aa952008012@de.ibm.com>
 <41ee1f6a-3124-d44b-bf34-0f26604f9514@redhat.com>
 <4726da4c-11ec-3b6e-1218-6d6d365d5038@de.ibm.com>
 <39b96e3a-9f4e-6e1d-e988-8c4bcfb55879@de.ibm.com>
 <c423c5b1-7817-7417-d7af-e07bef6368e7@redhat.com>
 <20200401102631-mutt-send-email-mst@kernel.org>
 <5e409bb4-2b06-5193-20c3-a9ddaafacf5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e409bb4-2b06-5193-20c3-a9ddaafacf5a@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 10:50:50PM +0800, Jason Wang wrote:
> 
> On 2020/4/1 下午10:27, Michael S. Tsirkin wrote:
> > On Wed, Apr 01, 2020 at 10:13:29PM +0800, Jason Wang wrote:
> > > On 2020/4/1 下午9:02, Christian Borntraeger wrote:
> > > > On 01.04.20 14:56, Christian Borntraeger wrote:
> > > > > On 01.04.20 14:50, Jason Wang wrote:
> > > > > > On 2020/4/1 下午7:21, Christian Borntraeger wrote:
> > > > > > > On 26.03.20 15:01, Jason Wang wrote:
> > > > > > > > Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
> > > > > > > > not necessarily for VM since it's a generic userspace and kernel
> > > > > > > > communication protocol. Such dependency may prevent archs without
> > > > > > > > virtualization support from using vhost.
> > > > > > > > 
> > > > > > > > To solve this, a dedicated vhost menu is created under drivers so
> > > > > > > > CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
> > > > > > > FWIW, this now results in vhost not being build with defconfig kernels (in todays
> > > > > > > linux-next).
> > > > > > > 
> > > > > > Hi Christian:
> > > > > > 
> > > > > > Did you meet it even with this commit https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=a4be40cbcedba9b5b714f3c95182e8a45176e42d?
> > > > > I simply used linux-next. The defconfig does NOT contain CONFIG_VHOST and therefore CONFIG_VHOST_NET and friends
> > > > > can not be selected.
> > > > > 
> > > > > $ git checkout next-20200401
> > > > > $ make defconfig
> > > > >     HOSTCC  scripts/basic/fixdep
> > > > >     HOSTCC  scripts/kconfig/conf.o
> > > > >     HOSTCC  scripts/kconfig/confdata.o
> > > > >     HOSTCC  scripts/kconfig/expr.o
> > > > >     LEX     scripts/kconfig/lexer.lex.c
> > > > >     YACC    scripts/kconfig/parser.tab.[ch]
> > > > >     HOSTCC  scripts/kconfig/lexer.lex.o
> > > > >     HOSTCC  scripts/kconfig/parser.tab.o
> > > > >     HOSTCC  scripts/kconfig/preprocess.o
> > > > >     HOSTCC  scripts/kconfig/symbol.o
> > > > >     HOSTCC  scripts/kconfig/util.o
> > > > >     HOSTLD  scripts/kconfig/conf
> > > > > *** Default configuration is based on 'x86_64_defconfig'
> > > > > #
> > > > > # configuration written to .config
> > > > > #
> > > > > 
> > > > > $ grep VHOST .config
> > > > > # CONFIG_VHOST is not set
> > > > > 
> > > > > > If yes, what's your build config looks like?
> > > > > > 
> > > > > > Thanks
> > > > This was x86. Not sure if that did work before.
> > > > On s390 this is definitely a regression as the defconfig files
> > > > for s390 do select VHOST_NET
> > > > 
> > > > grep VHOST arch/s390/configs/*
> > > > arch/s390/configs/debug_defconfig:CONFIG_VHOST_NET=m
> > > > arch/s390/configs/debug_defconfig:CONFIG_VHOST_VSOCK=m
> > > > arch/s390/configs/defconfig:CONFIG_VHOST_NET=m
> > > > arch/s390/configs/defconfig:CONFIG_VHOST_VSOCK=m
> > > > 
> > > > and this worked with 5.6, but does not work with next. Just adding
> > > > CONFIG_VHOST=m to the defconfig solves the issue, something like
> > > 
> > > Right, I think we probably need
> > > 
> > > 1) add CONFIG_VHOST=m to all defconfigs that enables
> > > CONFIG_VHOST_NET/VSOCK/SCSI.
> > > 
> > > or
> > > 
> > > 2) don't use menuconfig for CONFIG_VHOST, let NET/SCSI/VDPA just select it.
> > > 
> > > Thanks
> > OK I tried this:
> > 
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index 2523a1d4290a..a314b900d479 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -19,11 +19,10 @@ menuconfig VHOST
> >   	  This option is selected by any driver which needs to access
> >   	  the core of vhost.
> > -if VHOST
> > -
> >   config VHOST_NET
> >   	tristate "Host kernel accelerator for virtio net"
> >   	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> > +	select VHOST
> >   	---help---
> >   	  This kernel module can be loaded in host kernel to accelerate
> >   	  guest networking with virtio_net. Not to be confused with virtio_net
> > @@ -35,6 +34,7 @@ config VHOST_NET
> >   config VHOST_SCSI
> >   	tristate "VHOST_SCSI TCM fabric driver"
> >   	depends on TARGET_CORE && EVENTFD
> > +	select VHOST
> >   	default n
> >   	---help---
> >   	Say M here to enable the vhost_scsi TCM fabric module
> > @@ -44,6 +44,7 @@ config VHOST_VSOCK
> >   	tristate "vhost virtio-vsock driver"
> >   	depends on VSOCKETS && EVENTFD
> >   	select VIRTIO_VSOCKETS_COMMON
> > +	select VHOST
> >   	default n
> >   	---help---
> >   	This kernel module can be loaded in the host kernel to provide AF_VSOCK
> > @@ -57,6 +58,7 @@ config VHOST_VDPA
> >   	tristate "Vhost driver for vDPA-based backend"
> >   	depends on EVENTFD
> >   	select VDPA
> > +	select VHOST
> >   	help
> >   	  This kernel module can be loaded in host kernel to accelerate
> >   	  guest virtio devices with the vDPA-based backends.
> > @@ -78,5 +80,3 @@ config VHOST_CROSS_ENDIAN_LEGACY
> >   	  adds some overhead, it is disabled by default.
> >   	  If unsure, say "N".
> > -
> > -endif
> > 
> > 
> > But now CONFIG_VHOST is always "y", never "m".
> > Which I think will make it a built-in.
> > Didn't figure out why yet.
> 
> 
> Is it because the dependency of EVENTFD for CONFIG_VHOST?

Oh no, it's because I forgot to change menuconfig to config.


> Remove that one for this patch, I can get CONFIG_VHOST=m.
> 
> But according to documentation/kbuild/kconfig.rst, select is used for option
> without prompt.
> 
> Thanks
> 
> 
> > 

