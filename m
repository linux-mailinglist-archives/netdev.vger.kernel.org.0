Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D43C19F634
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgDFM5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:57:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28246 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728005AbgDFM5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586177824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zA3oXFlf+tA0XqNfZvZ8NSCiPUHKJG3g0r1brnP9MhE=;
        b=chc6MnK+nM8rXyMbVwOo8aQRMtRzQpTOvUQF/ty4P7jCKIkIFwo72Sv8UuQepseuA5rgnP
        VwXHur4Z0hjeHUffIMCHyBvO4tj4HOTwZGk3kRN6GfXOUQYeYmhduZY+a0wsY6en/kT1ds
        4vPQYkIl2z8hCaJtOgJN8BUqogRSTsw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-9QAh5OYFPlyPoy7FVAF5uw-1; Mon, 06 Apr 2020 08:57:01 -0400
X-MC-Unique: 9QAh5OYFPlyPoy7FVAF5uw-1
Received: by mail-wr1-f69.google.com with SMTP id a10so5817988wra.2
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 05:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zA3oXFlf+tA0XqNfZvZ8NSCiPUHKJG3g0r1brnP9MhE=;
        b=m4vVmIaZ0MpRawJqjZ1wyyjRf5inLwtSQNfIddYWkLwY3uHAVMjxSRNpGYXUmPFGfD
         Dc27zjeokyIvhWfu2f8bvaL5GkD7w2XDsJaZbMFZNI+aA3hiGHKq2MIDpv7LQ3XsEP5L
         lq7CiQ6Ga9ocpGtkkRf2+Za5eFE6YDjB7ZYq1gIQQqBS7ZtDpjzbfotKHdTjJWnNhD2V
         YZDVjenQX1kZ8ViMPT7JgNmpnGDtHXpaQ/dwSANkUaf2mgoEGkUhTPCObeoW3xc+WSGR
         PrB/JfzPclTXNVVdDgW1pyDxEz5VYzvVVLOu8mIihlETmmvl7Q+XpRTvn3W37INY1KKT
         qAhA==
X-Gm-Message-State: AGi0PuZNqDZGXGbYXRcC9OAEoaW/SXrIFIy+Hf21IFaobyjv3v2VrM5E
        DGPtcttTivD0OJx05wtEfUfxEBgdu4uRn764SwK02WgzZaY37dwEw18MKnoYRPdL5XAkQ5MVuCU
        yJoIO7lhnqsUd/rBF
X-Received: by 2002:a7b:c359:: with SMTP id l25mr22974367wmj.149.1586177820032;
        Mon, 06 Apr 2020 05:57:00 -0700 (PDT)
X-Google-Smtp-Source: APiQypLkRAUfyI4Cg7RaR/a2JYi9c2Rr5Wp8n4wDNVakzk3f4Q2RbJ2sjxo/Naa7H/tihWUIO6KVSg==
X-Received: by 2002:a7b:c359:: with SMTP id l25mr22974349wmj.149.1586177819765;
        Mon, 06 Apr 2020 05:56:59 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id i1sm1637648wmb.33.2020.04.06.05.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 05:56:59 -0700 (PDT)
Date:   Mon, 6 Apr 2020 08:56:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        Jason Wang <jasowang@redhat.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] vhost: disable for OABI
Message-ID: <20200406085453-mutt-send-email-mst@kernel.org>
References: <20200406121233.109889-1-mst@redhat.com>
 <20200406121233.109889-3-mst@redhat.com>
 <CAMj1kXFNeuZU66swwf_Cx7PrQJV34C0VJ7Rte5aga2Jx4S-yHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFNeuZU66swwf_Cx7PrQJV34C0VJ7Rte5aga2Jx4S-yHw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 02:45:13PM +0200, Ard Biesheuvel wrote:
> On Mon, 6 Apr 2020 at 14:12, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > vhost is currently broken on the default ARM config.
> >
> 
> Where did you get this idea? The report from the robot was using a
> randconfig build, and in general, AEABI is required to run anything on
> any modern ARM system .

Oh - I forgot it's randconfig. This part is wrong, sorry.
I decided to just force 2-byte alignment
instead (seems more robust) but I'll take this into account
if we do decide to add this dependency.


> 
> > The reason is that that uses apcs-gnu which is the ancient OABI that is been
> > deprecated for a long time.
> >
> > Given that virtio support on such ancient systems is not needed in the
> > first place, let's just add something along the lines of
> >
> >         depends on !ARM || AEABI
> >
> > to the virtio Kconfig declaration, and add a comment that it has to do
> > with struct member alignment.
> >
> > Note: we can't make VHOST and VHOST_RING themselves have
> > a dependency since these are selected. Add a new symbol for that.
> >
> > Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> > Siggested-by: Richard Earnshaw <Richard.Earnshaw@arm.com>
> 
> typo ^^^


Thanks!

> 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/misc/mic/Kconfig |  2 +-
> >  drivers/net/caif/Kconfig |  2 +-
> >  drivers/vdpa/Kconfig     |  2 +-
> >  drivers/vhost/Kconfig    | 17 +++++++++++++----
> >  4 files changed, 16 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
> > index 8f201d019f5a..3bfe72c59864 100644
> > --- a/drivers/misc/mic/Kconfig
> > +++ b/drivers/misc/mic/Kconfig
> > @@ -116,7 +116,7 @@ config MIC_COSM
> >
> >  config VOP
> >         tristate "VOP Driver"
> > -       depends on VOP_BUS
> > +       depends on VOP_BUS && VHOST_DPN
> >         select VHOST_RING
> >         select VIRTIO
> >         help
> > diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
> > index 9db0570c5beb..661c25eb1c46 100644
> > --- a/drivers/net/caif/Kconfig
> > +++ b/drivers/net/caif/Kconfig
> > @@ -50,7 +50,7 @@ config CAIF_HSI
> >
> >  config CAIF_VIRTIO
> >         tristate "CAIF virtio transport driver"
> > -       depends on CAIF && HAS_DMA
> > +       depends on CAIF && HAS_DMA && VHOST_DPN
> >         select VHOST_RING
> >         select VIRTIO
> >         select GENERIC_ALLOCATOR
> > diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> > index d0cb0e583a5d..aee28def466b 100644
> > --- a/drivers/vdpa/Kconfig
> > +++ b/drivers/vdpa/Kconfig
> > @@ -14,7 +14,7 @@ if VDPA_MENU
> >
> >  config VDPA_SIM
> >         tristate "vDPA device simulator"
> > -       depends on RUNTIME_TESTING_MENU && HAS_DMA
> > +       depends on RUNTIME_TESTING_MENU && HAS_DMA && VHOST_DPN
> >         select VDPA
> >         select VHOST_RING
> >         select VHOST_IOTLB
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index cb6b17323eb2..b3486e218f62 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -12,6 +12,15 @@ config VHOST_RING
> >           This option is selected by any driver which needs to access
> >           the host side of a virtio ring.
> >
> > +config VHOST_DPN
> > +       bool "VHOST dependencies"
> > +       depends on !ARM || AEABI
> > +       default y
> > +       help
> > +         Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> > +         This excludes the deprecated ARM ABI since that forces a 4 byte
> > +         alignment on all structs - incompatible with virtio spec requirements.
> > +
> >  config VHOST
> >         tristate
> >         select VHOST_IOTLB
> > @@ -27,7 +36,7 @@ if VHOST_MENU
> >
> >  config VHOST_NET
> >         tristate "Host kernel accelerator for virtio net"
> > -       depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> > +       depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP) && VHOST_DPN
> >         select VHOST
> >         ---help---
> >           This kernel module can be loaded in host kernel to accelerate
> > @@ -39,7 +48,7 @@ config VHOST_NET
> >
> >  config VHOST_SCSI
> >         tristate "VHOST_SCSI TCM fabric driver"
> > -       depends on TARGET_CORE && EVENTFD
> > +       depends on TARGET_CORE && EVENTFD && VHOST_DPN
> >         select VHOST
> >         default n
> >         ---help---
> > @@ -48,7 +57,7 @@ config VHOST_SCSI
> >
> >  config VHOST_VSOCK
> >         tristate "vhost virtio-vsock driver"
> > -       depends on VSOCKETS && EVENTFD
> > +       depends on VSOCKETS && EVENTFD && VHOST_DPN
> >         select VHOST
> >         select VIRTIO_VSOCKETS_COMMON
> >         default n
> > @@ -62,7 +71,7 @@ config VHOST_VSOCK
> >
> >  config VHOST_VDPA
> >         tristate "Vhost driver for vDPA-based backend"
> > -       depends on EVENTFD
> > +       depends on EVENTFD && VHOST_DPN
> >         select VHOST
> >         select VDPA
> >         help
> > --
> > MST
> >

