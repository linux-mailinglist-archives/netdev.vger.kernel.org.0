Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083E4ED71F
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 02:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfKDBnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 20:43:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfKDBnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 20:43:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E31211503138B;
        Sun,  3 Nov 2019 17:43:11 -0800 (PST)
Date:   Sun, 03 Nov 2019 17:43:11 -0800 (PST)
Message-Id: <20191103.174311.1939967870267945019.davem@davemloft.net>
To:     linus.walleij@linaro.org
Cc:     netdev@vger.kernel.org, arnd@arndb.de, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 09/10 v2] net: ethernet: ixp4xx: Get port ID
 from base address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101130224.7964-10-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
        <20191101130224.7964-10-linus.walleij@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 17:43:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri,  1 Nov 2019 14:02:23 +0100

> @@ -1388,13 +1387,15 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
>  	regs_phys = res->start;
>  	port->regs = devm_ioremap_resource(dev, res);
>  
> -	switch (port->id) {
> -	case IXP4XX_ETH_NPEA:
> +	switch (res->start) {
> +	case 0xc800c000:

This is extremely non-portable.

The resource values are %100 opaque architecture specific values.

On sparc64 for example, it is absolutely not the bus address but rather
the physical address that the cpu needs to use to perform MMIO's to what
is behind that resource.

I'm not applying this, sorry.
