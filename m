Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A967B13DAB4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgAPM5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:57:09 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:59844 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbgAPM5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 07:57:09 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 655FFF404C9401744995;
        Thu, 16 Jan 2020 20:57:05 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Thu, 16 Jan 2020 20:56:54 +0800
From:   Hongbo Yao <yaohongbo@huawei.com>
To:     <kuba@kernel.org>
CC:     <yaohongbo@huawei.com>, <chenzhou10@huawei.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] drivers/net: netdevsim depends on INET
Date:   Thu, 16 Jan 2020 20:52:19 +0800
Message-ID: <20200116125219.166830-1-yaohongbo@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_INET is not set and CONFIG_NETDEVSIM=y.
Building drivers/net/netdevsim/fib.o will get the following error:

drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_hw_flags_set':
fib.c:(.text+0x12b): undefined reference to `fib_alias_hw_flags_set'
drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_destroy':
fib.c:(.text+0xb11): undefined reference to `free_fib_info'

Correct the Kconfig for netdevsim.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 83c9e13aa39ae("netdevsim: add software driver for testing
offloads")
Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
---
 drivers/net/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 77ee9afad038..25a8f9387d5a 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -549,6 +549,7 @@ source "drivers/net/hyperv/Kconfig"
 config NETDEVSIM
 	tristate "Simulated networking device"
 	depends on DEBUG_FS
+	depends on INET
 	depends on IPV6 || IPV6=n
 	select NET_DEVLINK
 	help
-- 
2.20.1

