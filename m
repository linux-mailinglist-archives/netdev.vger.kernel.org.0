Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7E5480BFF
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 18:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhL1RNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 12:13:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55424 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhL1RNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 12:13:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B9F3B8168C;
        Tue, 28 Dec 2021 17:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC36C36AF0;
        Tue, 28 Dec 2021 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640711595;
        bh=T3HUEllg1Pw7vYBFjSPgjWTc0i5UwlDCIB5VYMi9zQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aC2AgnEYsVn8ajMr8WXjrdgvYdxaICxzBEIqsQvRNJDdSNTmgYKxxE13ldY57jvt6
         wtSnEDHwfFeP7WPa1v2BXHsL164j0gjjc1waprQ7FxnadoJwpFcS8YPlJ1fRUUEgNG
         1n8B6ybs2qiYbmmANluzHzAR+HA2JhBdfnB5r0OInhaGxnhy9LnnhUQ0kSAmYqyjvt
         U8WA12Q8XWC6B4+2O+Uw+3c+bVIkQEInrB+E4lsE9bM/HIbStWglKd4TfiZn9oNjTC
         71qzDaDkiqAQz8JEolGNowQ5U8m10M955+gDpfmp1KuoHVnN/ysNieqn8T0FB5YrhX
         IQJmZwEC33MlQ==
Date:   Tue, 28 Dec 2021 18:12:58 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ettore Chimenti <ek5.chimenti@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        John Garry <john.garry@huawei.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Jouni Malinen <j@w1.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Jiri Slaby <jirislaby@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-wireless@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-watchdog@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [RFC 01/32] Kconfig: introduce and depend on LEGACY_PCI
Message-ID: <20211228181107.2d476028@coco.lan>
In-Reply-To: <4b630b7b87bd983291f628c42a1394fc0d2d86bd.camel@linux.ibm.com>
References: <20211227164317.4146918-1-schnelle@linux.ibm.com>
        <20211227164317.4146918-2-schnelle@linux.ibm.com>
        <YcrJAwsKIxxX18pW@kroah.com>
        <20211228101435.3a55b983@coco.lan>
        <b1475f6aecb752a858941f44a957b2183cd68405.camel@linux.ibm.com>
        <20211228135425.0a69168c@coco.lan>
        <4b630b7b87bd983291f628c42a1394fc0d2d86bd.camel@linux.ibm.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 28 Dec 2021 16:06:44 +0100
Niklas Schnelle <schnelle@linux.ibm.com> escreveu:

(on a side note: the c/c list of this patch is too long. I would try to
avoid using a too long list, as otherwise this e-mail may end being rejected
by mail servers)

> On Tue, 2021-12-28 at 13:54 +0100, Mauro Carvalho Chehab wrote:
> >  
> ---8<---
> >     
> > > > > All you really care about is the "legacy" I/O spaces here, this isn't
> > > > > tied to PCI specifically at all, right?
> > > > > 
> > > > > So why not just have a OLD_STYLE_IO config option or something like
> > > > > that, to show that it's the i/o functions we care about here, not PCI at
> > > > > all?
> > > > > 
> > > > > And maybe not call it "old" or "legacy" as time constantly goes forward,
> > > > > just describe it as it is, "DIRECT_IO"?    
> > > > 
> > > > Agreed. HAVE_PCI_DIRECT_IO (or something similar) seems a more appropriate
> > > > name for it.
> > > > 
> > > > Thanks,
> > > > Mauro    
> > > 
> > > Hmm, I might be missing something here but that sounds a lot like the
> > > HAS_IOPORT option added in patch 02.
> > > 
> > > We add both LEGACY_PCI and HAS_IOPORT to differentiate between two
> > > cases. HAS_IOPORT is for PC-style devices that are not on a PCI card
> > > while LEGACY_PCI is for PCI drivers that require port I/O.   
> > 
> > I didn't look at the other patches on this series, but why it is needed
> > to deal with them on a separate way? Won't "PCI" and "HAS_IOPORT" be enough? 
> > 
> > I mean, are there any architecture where HAVE_PCI=y and HAS_IOPORT=y
> > where LEGACY_PCI shall be "n"?  
> 
> In the current patch set LEGACY_PCI is not currently selected by
> architectures, though of course it could be if we know that an
> architecture requires it. We should probably also set it in any
> defconfig that has devices depending on it so as not to break these.
> 
> Other than that it would be set during kernel configuration if one
> wants/needs support for legacy PCI devices. For testing I ran with
> HAVE_PCI=y, HAS_IOPORT=y and LEGACY_PCI=n on both my local Ryzen 3990X
> based workstation and Raspberry Pi 4 (DT). I guess at the moment it
> would make most sense for special configs such as those tailored for
> vitualization guets but in the end that would be something for
> distributions to decide.

IMO, it makes sense to have a "default y" there, as on systems that
support I/O space, disabling it will just randomly disable some drivers
that could be required by some hardware. I won't doubt that some of 
those could be ported from using inb/outb to use, instead, readb/writeb.

> 
> Arnd described the options here:
> https://lore.kernel.org/lkml/CAK8P3a3HHeP+Gw_k2P7Qtig0OmErf0HN30G22+qHic_uZTh11Q@mail.gmail.com/

Based on Arnd's description, LEGACY_PCI should depend on HAS_IOPORT.
This is missing on patch 1. You should probably reorder your patch
series to first create HAS_IOPORT and then add LEGACY_PCI with
depends on, as otherwise it may cause randconfig build issues
at robots and/or git bisect.

I would also suggest to first introduce such change and then send
a per-subsystem LEGACY_PCI patch, as it would be a lot easier for
maintainers to review.

> 
> >   
> > > This
> > > includes pre-PCIe devices as well as PCIe devices which require
> > > features like I/O spaces. The "legacy" naming is comes from the PCIe
> > > spec which in section 2.1.1.2 says "PCI Express supports I/O Space for
> > > compatibility with legacy devices which require their use. Future
> > > revisions of this specification may deprecate the use of I/O Space."  
> > 
> > I would still avoid calling it LEGACY_PCI, as this sounds too generic.
> > 
> > I didn't read the PCI/PCIe specs, but I suspect that are a lot more
> > features that were/will be deprecated on PCI specs as time goes by.
> > 
> > So, I would, instead, use something like PCI_LEGACY_IO_SPACE or 
> > HAVE_PCI_LEGACY_IO_SPACE, in order to let it clear what "legacy"
> > means.  
> 
> Hmm, I'd like to hear Bjorn's opinion on this. Personally I feel like
> LEGACY_PCI is pretty clear since most devices are either pre-PCIe
> devices or a compatibility feature allowing drivers for a pre-PCIe
> device to work with a PCIe device.

That's the main point: it is *not* disabling pre-PCIe devices or
even legacy PCI drivers. It just disables a random set of drivers just
because they use inb/outb instead of readb/writeb. It keeps several pure 
PCI drivers selected, and disables some PCIe for no real reason.

Just to give one example, this symbol:

> diff --git a/drivers/media/cec/platform/Kconfig b/drivers/media/cec/platform/Kconfig
> index b672d3142eb7..5e92ece5b104 100644
> --- a/drivers/media/cec/platform/Kconfig
> +++ b/drivers/media/cec/platform/Kconfig
> @@ -100,7 +100,7 @@ config CEC_TEGRA
>  config CEC_SECO
>  	tristate "SECO Boards HDMI CEC driver"
>  	depends on (X86 || IA64) || COMPILE_TEST
> -	depends on PCI && DMI
> +	depends on LEGACY_PCI && DMI
>  	select CEC_CORE
>  	select CEC_NOTIFIER
>  	help

Disables HDMI CEC support on some Intel motherboards.
Any distro meant to run on generic hardware should keep it selected.

I can see some value of a "PCI_LEGACY" option to disable all
non-PCIe drivers, but this is not the case here.

Thanks,
Mauro
