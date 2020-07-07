Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83394217B0C
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgGGWhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbgGGWhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:37:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E0CC061755;
        Tue,  7 Jul 2020 15:37:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96833120ED48D;
        Tue,  7 Jul 2020 15:37:19 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:37:18 -0700 (PDT)
Message-Id: <20200707.153718.2038504409537711474.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bgolaszewski@baylibre.com,
        lkp@intel.com
Subject: Re: [PATCH net-next] net: phy: add a Kconfig option for mdio_devres
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200705095547.22527-1-brgl@bgdev.pl>
References: <20200705095547.22527-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:37:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Sun,  5 Jul 2020 11:55:47 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> If phylib is built as a module and CONFIG_MDIO_DEVICE is 'y', the
> mdio_device and mdio_bus code will be in the phylib module, not in the
> kernel image. Meanwhile we build mdio_devres depending on the
> CONFIG_MDIO_DEVICE symbol, so if it's 'y', it will go into the kernel
> and we'll hit the following linker error:
> 
>    ld: drivers/net/phy/mdio_devres.o: in function `devm_mdiobus_alloc_size':
>>> drivers/net/phy/mdio_devres.c:38: undefined reference to `mdiobus_alloc_size'
>    ld: drivers/net/phy/mdio_devres.o: in function `devm_mdiobus_free':
>>> drivers/net/phy/mdio_devres.c:16: undefined reference to `mdiobus_free'
>    ld: drivers/net/phy/mdio_devres.o: in function `__devm_mdiobus_register':
>>> drivers/net/phy/mdio_devres.c:87: undefined reference to `__mdiobus_register'
>    ld: drivers/net/phy/mdio_devres.o: in function `devm_mdiobus_unregister':
>>> drivers/net/phy/mdio_devres.c:53: undefined reference to `mdiobus_unregister'
>    ld: drivers/net/phy/mdio_devres.o: in function `devm_of_mdiobus_register':
>>> drivers/net/phy/mdio_devres.c:120: undefined reference to `of_mdiobus_register'
> 
> Add a hidden Kconfig option for MDIO_DEVRES which will be currently
> selected by CONFIG_PHYLIB as there are no non-phylib users of these
> helpers.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Applied, thank you.
