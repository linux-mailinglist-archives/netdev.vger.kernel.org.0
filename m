Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A8C1C2091
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgEAW2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgEAW2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:28:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220C5C061A0C;
        Fri,  1 May 2020 15:28:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86F3E14F4BE36;
        Fri,  1 May 2020 15:28:18 -0700 (PDT)
Date:   Fri, 01 May 2020 15:28:17 -0700 (PDT)
Message-Id: <20200501.152817.688071349221528108.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     grygorii.strashko@ti.com, david@lechnology.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v2] drivers: net: davinci_mdio: fix potential
 NULL dereference in davinci_mdio_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429025220.166415-1-weiyongjun1@huawei.com>
References: <20200427094032.181184-1-weiyongjun1@huawei.com>
        <20200429025220.166415-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:28:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 29 Apr 2020 02:52:20 +0000

> platform_get_resource() may fail and return NULL, so we should
> better check it's return value to avoid a NULL pointer dereference
> since devm_ioremap() does not check input parameters for null.
> 
> This is detected by Coccinelle semantic patch.
> 
> @@
> expression pdev, res, n, t, e, e1, e2;
> @@
> 
> res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
> + if (!res)
> +   return -EINVAL;
> ... when != res == NULL
> e = devm_ioremap(e1, res->start, e2);
> 
> Fixes: 03f66f067560 ("net: ethernet: ti: davinci_mdio: use devm_ioremap()")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied.
