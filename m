Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B14B253558
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHZQst convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Aug 2020 12:48:49 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37992 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbgHZQpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:45:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id b2so2325625edw.5;
        Wed, 26 Aug 2020 09:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=VcpR9KHDU061Xv9zuvEUeTLNw9aF0vug7DDIpypunYI=;
        b=qc88HgN4gEDB1GZFa7LnH/4zVqz+w2yyCgwbk0VZNqmHXEg3xyBrFZycuXXzY8wPdN
         o2O5bRplEB/UkdvLL9dRTCvwoS9V4iGbqXl9bXuNJm+wk+aW+6juF21Vq6/QiBlqtBGm
         YgxhBQ3vyNAoSAok41E3yyDDK3FZIdOm1+AB6zMZgWBSCQKE6VINN3E3W6PGH8zbUsf8
         PXGKD3eSDeTU6i4QPMfio53/FApU2V8V6oAIXldZSnxWsdTuat9wrv9AROpue8tL2fqh
         pT8Ncv5/RAkGeW62co2N1DMSVudwQWK8boUwjGOCUS0mzBJqI1KfFex/P9kGn2irc0rv
         helQ==
X-Gm-Message-State: AOAM530ZPmk4PKEKDrGRlEjpVS5BbjNS/ffyiAsELuUj1SF2Lma92Ll3
        127N+XuFjDCxN0G2yzxWCsU=
X-Google-Smtp-Source: ABdhPJzNZvG8R0iGqLLI9Osb88KuUk8+rAMTgLpfwJZTkp1b9hrm1Bu1P1MhhqYt3+HlwwHi7Y0p3A==
X-Received: by 2002:a05:6402:1a46:: with SMTP id bf6mr15632175edb.284.1598460336278;
        Wed, 26 Aug 2020 09:45:36 -0700 (PDT)
Received: from kozik-lap ([194.230.155.216])
        by smtp.googlemail.com with ESMTPSA id s24sm2722569ejx.15.2020.08.26.09.45.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Aug 2020 09:45:35 -0700 (PDT)
Date:   Wed, 26 Aug 2020 18:45:33 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20200826164533.GC31748@kozik-lap>
References: <20200825184413.GA2693@kozik-lap>
 <CGME20200826145929eucas1p1367c260edb8fa003869de1da527039c0@eucas1p1.samsung.com>
 <dleftja6yhv4g2.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <dleftja6yhv4g2.fsf%l.stelmach@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 04:59:09PM +0200, Lukasz Stelmach wrote:
> It was <2020-08-25 wto 20:44>, when Krzysztof Kozlowski wrote:
> > On Tue, Aug 25, 2020 at 07:03:09PM +0200, Łukasz Stelmach wrote:
> >> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
> >> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
> >> supports SPI connection.
> >> 
> >> The driver has been ported from the vendor kernel for ARTIK5[2]
> >> boards. Several changes were made to adapt it to the current kernel
> >> which include:
> >> 
> >> + updated DT configuration,
> >> + clock configuration moved to DT,
> >> + new timer, ethtool and gpio APIs
> >> + dev_* instead of pr_* and custom printk() wrappers.
> >> 
> >> [1] https://protect2.fireeye.com/v1/url?k=074e9e9d-5a9dc212-074f15d2-0cc47a31ce52-0f896a3d08738907&q=1&e=bcaebfa2-4f00-46b6-a35d-096f39710f47&u=https%3A%2F%2Fwww.asix.com.tw%2Fproducts.php%3Fop%3DpItemdetail%26PItemID%3D104%3B65%3B86%26PLine%3D65
> >> [2] https://protect2.fireeye.com/v1/url?k=553869ec-08eb3563-5539e2a3-0cc47a31ce52-fc42424019c6fd8f&q=1&e=bcaebfa2-4f00-46b6-a35d-096f39710f47&u=https%3A%2F%2Fgit.tizen.org%2Fcgit%2Fprofile%2Fcommon%2Fplatform%2Fkernel%2Flinux-3.10-artik%2F
> >> 
> >> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> >> chips are not compatible. Hence, two separate drivers are required.
> >
> > Hi,
> >
> > Thanks for the driver, nice work. Few comments below.
> >
> 
> Thank you. I fixed most problems and asked some question where I didn't
> understand.
> 
> >> 
> >> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> >> ---
> >>  drivers/net/ethernet/Kconfig               |    1 +
> >>  drivers/net/ethernet/Makefile              |    1 +
> >>  drivers/net/ethernet/asix/Kconfig          |   20 +
> >>  drivers/net/ethernet/asix/Makefile         |    6 +
> >>  drivers/net/ethernet/asix/ax88796c_ioctl.c |  293 +++++
> >>  drivers/net/ethernet/asix/ax88796c_ioctl.h |   21 +
> >>  drivers/net/ethernet/asix/ax88796c_main.c  | 1373 ++++++++++++++++++++
> >>  drivers/net/ethernet/asix/ax88796c_main.h  |  596 +++++++++
> >>  drivers/net/ethernet/asix/ax88796c_spi.c   |  103 ++
> >>  drivers/net/ethernet/asix/ax88796c_spi.h   |   67 +
> >>  10 files changed, 2481 insertions(+)
> >>  create mode 100644 drivers/net/ethernet/asix/Kconfig
> >>  create mode 100644 drivers/net/ethernet/asix/Makefile
> >>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
> >>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
> >>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
> >>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
> >>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
> >>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h
> >> 
> >> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
> >> index de50e8b9e656..f3b218e45ea5 100644
> >> --- a/drivers/net/ethernet/Kconfig
> >> +++ b/drivers/net/ethernet/Kconfig
> >> @@ -32,6 +32,7 @@ source "drivers/net/ethernet/apm/Kconfig"
> >>  source "drivers/net/ethernet/apple/Kconfig"
> >>  source "drivers/net/ethernet/aquantia/Kconfig"
> >>  source "drivers/net/ethernet/arc/Kconfig"
> >> +source "drivers/net/ethernet/asix/Kconfig"
> >>  source "drivers/net/ethernet/atheros/Kconfig"
> >>  source "drivers/net/ethernet/aurora/Kconfig"
> >>  source "drivers/net/ethernet/broadcom/Kconfig"
> >> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> >> index f8f38dcb5f8a..9eb368d93607 100644
> >> --- a/drivers/net/ethernet/Makefile
> >> +++ b/drivers/net/ethernet/Makefile
> >> @@ -18,6 +18,7 @@ obj-$(CONFIG_NET_XGENE) += apm/
> >>  obj-$(CONFIG_NET_VENDOR_APPLE) += apple/
> >>  obj-$(CONFIG_NET_VENDOR_AQUANTIA) += aquantia/
> >>  obj-$(CONFIG_NET_VENDOR_ARC) += arc/
> >> +obj-$(CONFIG_NET_VENDOR_ASIX) += asix/
> >>  obj-$(CONFIG_NET_VENDOR_ATHEROS) += atheros/
> >>  obj-$(CONFIG_NET_VENDOR_AURORA) += aurora/
> >>  obj-$(CONFIG_NET_VENDOR_CADENCE) += cadence/
> >> diff --git a/drivers/net/ethernet/asix/Kconfig b/drivers/net/ethernet/asix/Kconfig
> >> new file mode 100644
> >> index 000000000000..4b127a4a659a
> >> --- /dev/null
> >> +++ b/drivers/net/ethernet/asix/Kconfig
> >> @@ -0,0 +1,20 @@
> >> +#
> >> +# Asix network device configuration
> >> +#
> >> +
> >> +config NET_VENDOR_ASIX
> >> +	bool "Asix devices"
> >> +	depends on SPI
> >> +	help
> >> +	  If you have a network (Ethernet) interface based on a chip from ASIX, say Y
> >
> > Looks like too long, did it pass checkpatch?
> 
> Yes? Let me try again. Yes, this one passed, but I missed a few other
> problems. Thank you.

I noticed that now the limit is 100 when improves readability, so this
one is good.

(...)

> >> +
> >> +u8 ax88796c_check_power(struct ax88796c_device *ax_local)
> >
> > Looks here like pointer to const. Unless it is because of
> > AX_READ_STATUS() which cannot take const?
> 
> It can. I changed other stuff in ax88796c_spi.[hc] to const too.
> 
> >> +{
> >
> > Please put file-scope definitions first, so this should go to the end.
> 
> I don't understand.

Functions and variables which (file scope) are static go to the
beginning of file. Ones visible externally (non static), go after them.

(...)

> >> +
> >> +	AX_WRITE(&ax_local->ax_spi, rx_ctl, P2_RXCR);
> >> +
> >
> > No need for empty line.
> >
> 
> Fixed.
> 
> >> +}
> >> +
> >> +#if 0
> >
> > Please comment why it is commented out.
> >
> 
> Always has been (-; This is how it came from the vendor I missed it when
> I focused on making things work. I will investigate it and either
> uncomment or remove it.

Then just remove it.

(...)

> >> +#include <linux/of.h>
> >> +#endif
> >> +#include <linux/crc32.h>
> >> +#include <linux/etherdevice.h>
> >> +#include <linux/ethtool.h>
> >> +#include <linux/gpio/consumer.h>
> >> +#include <linux/init.h>
> >> +#include <linux/io.h>
> >> +#include <linux/kmod.h>
> >> +#include <linux/mii.h>
> >> +#include <linux/module.h>
> >> +#include <linux/netdevice.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/sched.h>
> >> +#include <linux/spi/spi.h>
> >> +#include <linux/timer.h>
> >> +#include <linux/uaccess.h>
> >> +#include <linux/usb.h>
> >> +#include <linux/version.h>
> >> +#include <linux/workqueue.h>
> >
> > All of these should be removed except the headers used directly in this
> > header.
> >
> 
> This is "private" header file included in all ax88796c_*.c files and
> these are headers required in them. It seems more conveninet to have
> them all listed in one place. What is the reason to do otherwise?

Because:
1. The header is included in other files (more than one) so each other
compilation unit will include all these headers, while not all of them
need. This has a performance penalty during preprocessing.

2. You will loose the track which headers are needed, which are not. We
tend to keep it local, which means each compilation unit includes stuff
it needs. This helps removing obsolete includes later.

3. Otherwise you could make one header, including all headers of Linux,
and then include this one header in each of C files. One to rule them
all.

Best regards,
Krzysztof
