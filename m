Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C42E25357C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgHZQw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:52:56 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:45048 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgHZQww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:52:52 -0400
Received: by mail-ej1-f66.google.com with SMTP id bo3so3788527ejb.11;
        Wed, 26 Aug 2020 09:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f3SjKHg0rc/Hi94wKGeK4sTEIeweZxxU2pp3miD2U7w=;
        b=fw7+bH7AiRhwXjq5tfTImHCJPfa+iMv2NbgB0cFIh1y8lFXKapBDUFm5fXQNsJGlJj
         5DXxGyaezcySLqGq8GHC8LJLLaqbE6C/aeCXfXka5mYXJ1QGn2VRKPuSZdUj3M6SXRF6
         W1TBlka4AXnyAX74NdyrDDdgZuUn6hNrwO8xfKNBQEhdqvE7QTXDqJdocBsW3hPmVP6b
         MMGEE2p2VxiAO7kgtGOBwCSl9ZzTN0vlra+xY/dxBjwtyISYXgUiAovTDrORcrHDU/GV
         6mR3S+5Ct4w7Fx4tcjt4QXFl6jh1bwj4u6fpwmViuqJTfhxzez6jd2bULogNxJC316Qj
         PkTA==
X-Gm-Message-State: AOAM531Kyf8RS73pCksdr2lqiLQ2R+Ek5GFFOh/rK7OAph9jtFsHtOK2
        2efYRXJnX9pIy1U7qUE9Lqk=
X-Google-Smtp-Source: ABdhPJx8z7paHiBU5Vqit+UaxQDuL7FcpAQaf80dIweI/Cw+HnrnkKZ/d1NlwB9sHxh0qTew9unJQQ==
X-Received: by 2002:a17:906:b09a:: with SMTP id x26mr2766990ejy.162.1598460769603;
        Wed, 26 Aug 2020 09:52:49 -0700 (PDT)
Received: from kozik-lap ([194.230.155.216])
        by smtp.googlemail.com with ESMTPSA id d2sm2656101ejm.19.2020.08.26.09.52.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Aug 2020 09:52:49 -0700 (PDT)
Date:   Wed, 26 Aug 2020 18:52:46 +0200
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
Message-ID: <20200826165246.GA29212@kozik-lap>
References: <20200825184413.GA2693@kozik-lap>
 <CGME20200826145929eucas1p1367c260edb8fa003869de1da527039c0@eucas1p1.samsung.com>
 <dleftja6yhv4g2.fsf%l.stelmach@samsung.com>
 <20200826164533.GC31748@kozik-lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200826164533.GC31748@kozik-lap>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 06:45:33PM +0200, Krzysztof Kozlowski wrote:
> On Wed, Aug 26, 2020 at 04:59:09PM +0200, Lukasz Stelmach wrote:
 > >> +#include <linux/of.h>
> > >> +#endif
> > >> +#include <linux/crc32.h>
> > >> +#include <linux/etherdevice.h>
> > >> +#include <linux/ethtool.h>
> > >> +#include <linux/gpio/consumer.h>
> > >> +#include <linux/init.h>
> > >> +#include <linux/io.h>
> > >> +#include <linux/kmod.h>
> > >> +#include <linux/mii.h>
> > >> +#include <linux/module.h>
> > >> +#include <linux/netdevice.h>
> > >> +#include <linux/platform_device.h>
> > >> +#include <linux/sched.h>
> > >> +#include <linux/spi/spi.h>
> > >> +#include <linux/timer.h>
> > >> +#include <linux/uaccess.h>
> > >> +#include <linux/usb.h>
> > >> +#include <linux/version.h>
> > >> +#include <linux/workqueue.h>
> > >
> > > All of these should be removed except the headers used directly in this
> > > header.
> > >
> > 
> > This is "private" header file included in all ax88796c_*.c files and
> > these are headers required in them. It seems more conveninet to have
> > them all listed in one place. What is the reason to do otherwise?
> 
> Because:
> 1. The header is included in other files (more than one) so each other
> compilation unit will include all these headers, while not all of them
> need. This has a performance penalty during preprocessing.
> 
> 2. You will loose the track which headers are needed, which are not. We
> tend to keep it local, which means each compilation unit includes stuff
> it needs. This helps removing obsolete includes later.
> 
> 3. Otherwise you could make one header, including all headers of Linux,
> and then include this one header in each of C files. One to rule them
> all.

... and I got one more:

4. Drivers sometimes get reused, extended or they parts got reused. If
a header includes more stuff, it simply will pollute all other units
trying to reuse it... making the re-usage difficult. This is less likely
reason, I mean, quite imaginary for this particular driver.

I don't expect pieces of this driver to be reused... but who knows. Many
times in the past in the kernel there was a huge work rewriting headers
in many files, because something was including something else and we
wanted to decouple these things.  Therefore following the pattern -
include stuff you explicitly use - helps in every case.

Best regards,
Krzysztof

