Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9DA486982
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242596AbiAFSOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:14:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbiAFSOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 13:14:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4870561D17;
        Thu,  6 Jan 2022 18:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A780C36AEB;
        Thu,  6 Jan 2022 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641492850;
        bh=pk9c3vFsS24A9H9YRNmuoLU04tTgveyiSfxz/RguLrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=tWL9ah320xPJ7ZLvQrLFkjIeV1LTlPrJ2qSY/t0fKFbU+5MxnpWBBUesVfIjO0xOO
         l+Yvi8TANgRjNK2vReZYRlLqehfzP4qE2oNJarfvWixIS0OfQkuKWpI6rrQEfWGn25
         oroVHI/IQA8JEpMkHqxWMkHxAKg+IVXn/Zqji7RoVtpWyymeRt5WcM4qay0A7EFOWe
         jnI4JpbaAmAttF9a/Yhl/wWUUgx6A1s8zF9Wpc8ft5Y9hFSMLv91rRujQQ/od6scnA
         LsHiF+8iYMGoQ6RcvIn/+ZU8WqHN0Y3LnsXMJdYHRbXi/+K/WGfnGi+pM9zExj10bs
         +smYL/+iBYHZg==
Date:   Thu, 6 Jan 2022 12:14:09 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ettore Chimenti <ek5.chimenti@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
        linux-serial@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [RFC 01/32] Kconfig: introduce and depend on LEGACY_PCI
Message-ID: <20220106181409.GA297735@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74bf4fde-3972-1c36-ca04-58089da0d82b@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 05:41:00PM +0000, John Garry wrote:
> On 05/01/2022 19:47, Bjorn Helgaas wrote:

> > IMO inb() should
> > be present but do something innocuous like return ~0, as it would if
> > I/O port space is supported but there's no device at that address.
> > 
> > [1]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/megaraid.c?id=v5.15#n4210
> > 
> 
> That driver would prob not be used on systems which does not support PIO,
> and so could have a HAS_IOPORT dependency. But it is not strictly necessary.

I don't want the path of "this driver isn't needed because the device
is unlikely to be used on this arch."

Maybe it's not _always_ possible, but if the device can be plugged
into the platform, I think we should be able to build the driver for
it.

If the device requires I/O port space and the platform doesn't support
it, the PCI core or the driver should detect that and give a useful
diagnostic.

Bjorn
