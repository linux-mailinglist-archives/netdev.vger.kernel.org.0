Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1F62316DC
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgG2Ajx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgG2Ajx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:39:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2E7C061794;
        Tue, 28 Jul 2020 17:39:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0374128D3F97;
        Tue, 28 Jul 2020 17:23:06 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:39:51 -0700 (PDT)
Message-Id: <20200728.173951.1166639369727479900.davem@davemloft.net>
To:     calvin.johnson@oss.nxp.com
Cc:     rafael@kernel.org, lenb@kernel.org, Lorenzo.Pieralisi@arm.com,
        guohanjun@huawei.com, sudeep.holla@arm.com, ahs3@redhat.com,
        jeremy.linton@arm.com, linux@armlinux.org.uk, jon@solid-run.com,
        cristian.sovaiala@nxp.com, ioana.ciornei@nxp.com, andrew@lunn.ch,
        andy.shevchenko@gmail.com, f.fainelli@gmail.com,
        madalin.bucur@oss.nxp.com, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux.cj@gmail.com, Paul.Yang@arm.com
Subject: Re: [net-next PATCH v7 0/6] ACPI support for dpaa2 MAC driver.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
References: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:23:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>
Date: Sat, 25 Jul 2020 19:53:58 +0530

>  This patch series provides ACPI support for dpaa2 MAC driver.
>  This also introduces ACPI mechanism to get PHYs registered on a
>  MDIO bus and provide them to be connected to MAC.
> 
>  Previous discussions on this patchset is available at:
>  https://lore.kernel.org/linux-acpi/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t
> 
>  Patch "net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver" depends on
>  https://git.kernel.org/pub/scm/linux/kernel/git/lpieralisi/linux.git/commit/?h=acpi/for-next&id=c279c4cf5bcd3c55b4fb9709d9036cd1bfe3beb8
>  Remaining patches are independent of the above patch and can be applied without
>  any issues.

This really needs to be reviewed by phy/phylink people.

>  Device Tree can be tested on LX2160A-RDB with the below change which is also
> available in the above referenced patches:
> 
> --- a/drivers/bus/fsl-mc/fsl-mc-bus.c
> +++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
> @@ -931,6 +931,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
>         if (error < 0)
>                 goto error_cleanup_mc_io;
> 
> +       mc_bus_dev->dev.fwnode = pdev->dev.fwnode;
>         mc->root_mc_bus_dev = mc_bus_dev;
>         return 0;

I don't know how you expect me to handle this dependency in the networking
tree.
