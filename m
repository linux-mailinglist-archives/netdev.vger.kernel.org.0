Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A7D405A5F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhIIPss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 11:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhIIPsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 11:48:47 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF931C061574;
        Thu,  9 Sep 2021 08:47:37 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v5so3295719edc.2;
        Thu, 09 Sep 2021 08:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SMuK2xLCSAdgKSOFL1sDq3ZtVCGQSUQXLqAzPrDhYes=;
        b=gILOHh1sdy6YEvPMKhMJlebCkpe/XwjPiBDgrKoRc0t7d8rASs4YrF+KwQU9yXQ56c
         aUcF0x+QI3kPOt+ETaVnSWDx2W6stCn3Tpzvd/lojs3Xa1jwqblBV8ag0EBxRERD4/kS
         KUkrmJXnokAIaObIl/qC9ru4l8/p3v72U7QhNNuakqhNYXrEO9iwVf0eEOs2BvHfPtQq
         /y53UVeJvfK+EotmcG01Qn46k/H8R1xU6nUBL//d7lA3SaUab3kC40yXT6S8pjJGOBdZ
         8XCv5XBxHIoPYuDVW5y4vt3PeHrV203uopnrMMOJH1OydB9xQVn/nEhdNxHPwlbclxcP
         enzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SMuK2xLCSAdgKSOFL1sDq3ZtVCGQSUQXLqAzPrDhYes=;
        b=y8P8mLdiAbAiHrKE0FS1zJtjk/5+5eZFAh7e917wWdNy8M/82le5yNNShGukOeVzGe
         nI/m9Z8+mkNyjKD4G4pXU7OXv4mfKCdR5CCS3+1N7iVSjAMXRhlEmv6AA2ICehP7H/Rm
         f9bMFGAQGovWv/z+lXHXZBhj4tLG9ibGl6paWy1rVqHtJUSKMqBT13e8N93RwSo+GF8Z
         wot8CrEd1PPNYb4og4LgWZIFn0S4qMFY6kySnF0ITWW9Gyhd1EFoFPo9r+YLa2IouRfO
         PRb6IwI6rTvmmvRZ3wxjHK0MkeU+46rdODJULBvFbMr5BEGrDgujtTB8OVguw/aVGS7P
         q0/Q==
X-Gm-Message-State: AOAM530eTmVYwFAe32Znu1kOs+8lGnTjRAFXWaGn9Pyq3xh4rR5PaBTw
        YDWkmyaMIA+2nT1tEURTbCc=
X-Google-Smtp-Source: ABdhPJzO9uSWNKj9OTHJkFLpOHM6VRqkMDzaYl0WAz+dHZj8rEHc/pkO8LbzZ6yYl50FW4xwKX3EdQ==
X-Received: by 2002:aa7:c313:: with SMTP id l19mr3852169edq.131.1631202456310;
        Thu, 09 Sep 2021 08:47:36 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id bj21sm1141469ejb.42.2021.09.09.08.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 08:47:35 -0700 (PDT)
Date:   Thu, 9 Sep 2021 18:47:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210909154734.ujfnzu6omcjuch2a@skbuf>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 03:19:52PM +0200, Lino Sanfilippo wrote:
> > Do you see similar things on your 5.10 kernel?
> 
> For the master device is see
> 
> lrwxrwxrwx 1 root root 0 Sep  9 14:10 /sys/class/net/eth0/device/consumer:spi:spi3.0 -> ../../../virtual/devlink/platform:fd580000.ethernet--spi:spi3.0

So this is the worst of the worst, we have a device link but it doesn't help.

Where the device link helps is here:

__device_release_driver
	while (device_links_busy(dev))
		device_links_unbind_consumers(dev);

but during dev_shutdown, device_links_unbind_consumers does not get called
(actually I am not even sure whether it should).

I've reproduced your issue by making this very simple change:

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 60d94e0a07d6..ec00f34cac47 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1372,6 +1372,7 @@ static struct pci_driver enetc_pf_driver = {
 	.id_table = enetc_pf_id_table,
 	.probe = enetc_pf_probe,
 	.remove = enetc_pf_remove,
+	.shutdown = enetc_pf_remove,
 #ifdef CONFIG_PCI_IOV
 	.sriov_configure = enetc_sriov_configure,
 #endif

on my DSA master driver. This is what the genet driver has "special".

I was led into grave error by Documentation/driver-api/device_link.rst,
which I've based my patch on, where it clearly says that device links
are supposed to help with shutdown ordering (how?!).

So the question is, why did my DSA trees get torn down on shutdown?
Basically the short answer is that my SPI controller driver does
implement .shutdown, and calls the same code path as the .remove code,
which calls spi_unregister_controller which removes all SPI children..

When I added this device link, one of the main objectives was to not
modify all DSA drivers. I was certain based on the documentation that
device links would help, now I'm not so sure anymore.

So what happens is that the DSA master attempts to unregister its net
device on .shutdown, but DSA does not implement .shutdown, so it just
sits there holding a reference (supposedly via dev_hold, but where from?!)
to the master, which makes netdev_wait_allrefs to wait and wait.

I need more time for the denial phase to pass, and to understand what
can actually be done. I will also be away from the keyboard for the next
few days, so it might take a while. Your patches obviously offer a
solution only for KSZ switches, we need something more general. If I
understand your solution, it works not by virtue of there being any
shutdown ordering guarantee at all, but simply due to the fact that
DSA's .shutdown hook gets called eventually, and the reference to the
master gets freed eventually, which unblocks the unregister_netdevice
call from the master. I don't yet understand why DSA holds a long-term
reference to the master, that's one thing I need to figure out.
