Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5EE7C812
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfGaQCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 12:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbfGaQCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 12:02:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D28C206A2;
        Wed, 31 Jul 2019 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564588941;
        bh=VN+7uqWWVVSJqZuPldysiASKx1rHOEYOcX3GkT4BirE=;
        h=Date:From:To:Cc:Subject:From;
        b=BSStEoJ9JQOakWBJ5751Txzqf7eFEDdWn4NhRNsC0zZHkdMQeaQ8Gb06H7lDwyY3N
         j5zpu+1XZoxEPYTXpLYGJDUJ0Rv2q50jrb7DTPBrcueIdYjyWs5ZX8s/fzFlZudult
         KkHDwZEnJKYpVSyqTSYMygsUfp+uJnKTPikkLdwo=
Date:   Wed, 31 Jul 2019 18:02:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     willy@infradead.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, YueHaibing <yuehaibing@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging/octeon: Fix build error without CONFIG_NETDEVICES
Message-ID: <20190731160219.GA2114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

While do COMPILE_TEST build without CONFIG_NETDEVICES,
we get Kconfig warning:

WARNING: unmet direct dependencies detected for PHYLIB
  Depends on [n]: NETDEVICES [=n]
  Selected by [y]:
  - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC && NETDEVICES [=n] || COMPILE_TEST [=y])

Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Mark Brown <broonie@kernel.org>
Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: cc: netdev and add another reported-by line.

 drivers/staging/octeon/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/Kconfig b/drivers/staging/octeon/Kconfig
index 5b39946..5319909 100644
--- a/drivers/staging/octeon/Kconfig
+++ b/drivers/staging/octeon/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 config OCTEON_ETHERNET
 	tristate "Cavium Networks Octeon Ethernet support"
-	depends on CAVIUM_OCTEON_SOC && NETDEVICES || COMPILE_TEST
+	depends on CAVIUM_OCTEON_SOC || COMPILE_TEST
+	depends on NETDEVICES
 	select PHYLIB
 	select MDIO_OCTEON
 	help
-- 
2.7.4


_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
