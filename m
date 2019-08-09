Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72F787D08
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 16:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407167AbfHIOol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 10:44:41 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:33633 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfHIOol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 10:44:41 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mth79-1iAbbg0rWx-00v4ZM; Fri, 09 Aug 2019 16:44:27 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        kbuild test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 09/13] net: lpc-enet: fix printk format strings
Date:   Fri,  9 Aug 2019 16:40:35 +0200
Message-Id: <20190809144043.476786-10-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190809144043.476786-1-arnd@arndb.de>
References: <20190809144043.476786-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6Fx2odY0ygf+ZHM70dyaWh2GH0CHTs6YpTvBzkGXRPduV6BL0xl
 t72e5WbYRZFfSyvNB5wHUAwHLeZrRfgO4HsFF1kwFOkXWXfEfef0oUUQmo9a7s+ITnC2TC+
 83aglvlCCZmL5CEyNOodIIoVqFkema1G7urRVaVoGoYERLaBffBuydHZlG05der7HKlg+8P
 OTW/9RUwYKzKBmDHb7gtQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IvXMTkvFbS0=:zCF+fdgg8gxSjM2KXJSPbJ
 VtwjpBPJBmUSNRZymPnwHy8UAVEH3AY87/wx7kAmDEo7Ulj2EaWiGC+0HiQ+ndiYtZKiyTLxl
 JAXVJ86moHoU7dHh7NqiGOJ2Y4Hr0CJHSWHTSLtnvX+b+hOeE+I/11Yi4s77Awb0yLy6lryhB
 tlDFKkKYJw8B19AA8zNr2iy0oVlqeNbck1fB/uiFuBrEiGvBRWOoPAt3pCDicmfFHv8EBM8vw
 2XMGotVZeXkuUwizIf9EXHPFDdz4VAl8pn3M5/mWc78z0ybKFzqIgthgmFglQat1OsHelO1QD
 rXrQhGs5SUXc+uStB+paJsNTPN77kxpbjTV+w1O1yCYC3Amyvmv/bSZmAf1YEOd6KlfBjpDD3
 VzNB1aQlAkF1mrKyvzy7ZRgkv9JmAZQ5xz2VRkNSu6mL0bMduELxlE+SIo4n1PkN0U/qfxVWP
 bzpXA/qiauT/MF13bZEN91IdcPpgpWVjz1G+9dq74SI3PLbTa+dWwGXXqwid4XAHRYbMqVDQi
 lvGIftyfNw8cJGgSEAyUBkbjfbnav+dp0GVwlM9+1ALdO7BkzPgrWKYSwT6SlUk1jraB2KY2W
 S9Q4BHZnG38FT0fpiQZsHq8FDrRVjQwz3OVmvGgF0MdVfh0VJyDOAHaG24pv5LIz/3i9bvb2l
 sj1C+PreIxrQ7mIjxDi988Xvgo8p3tN2V5ylpjAX/3tK8g2/6yAwypL2liN89WbYLGX0HT2tp
 GnBSi/LdGRTsDTOWzvgCZ0kpO6+9F4WT0WoDNg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

compile-testing this driver on other architectures showed
multiple warnings:

  drivers/net/ethernet/nxp/lpc_eth.c: In function 'lpc_eth_drv_probe':
  drivers/net/ethernet/nxp/lpc_eth.c:1337:19: warning: format '%d' expects argument of type 'int', but argument 4 has type 'resource_size_t {aka long long unsigned int}' [-Wformat=]

  drivers/net/ethernet/nxp/lpc_eth.c:1342:19: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]

Use format strings that work on all architectures.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 797bdbbcef76..96d509c418bf 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1333,13 +1333,14 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	pldat->dma_buff_base_p = dma_handle;
 
 	netdev_dbg(ndev, "IO address space     :%pR\n", res);
-	netdev_dbg(ndev, "IO address size      :%d\n", resource_size(res));
+	netdev_dbg(ndev, "IO address size      :%zd\n",
+			(size_t)resource_size(res));
 	netdev_dbg(ndev, "IO address (mapped)  :0x%p\n",
 			pldat->net_base);
 	netdev_dbg(ndev, "IRQ number           :%d\n", ndev->irq);
-	netdev_dbg(ndev, "DMA buffer size      :%d\n", pldat->dma_buff_size);
-	netdev_dbg(ndev, "DMA buffer P address :0x%08x\n",
-			pldat->dma_buff_base_p);
+	netdev_dbg(ndev, "DMA buffer size      :%zd\n", pldat->dma_buff_size);
+	netdev_dbg(ndev, "DMA buffer P address :%pad\n",
+			&pldat->dma_buff_base_p);
 	netdev_dbg(ndev, "DMA buffer V address :0x%p\n",
 			pldat->dma_buff_base_v);
 
@@ -1386,8 +1387,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_out_unregister_netdev;
 
-	netdev_info(ndev, "LPC mac at 0x%08x irq %d\n",
-	       res->start, ndev->irq);
+	netdev_info(ndev, "LPC mac at 0x%08lx irq %d\n",
+	       (unsigned long)res->start, ndev->irq);
 
 	device_init_wakeup(dev, 1);
 	device_set_wakeup_enable(dev, 0);
-- 
2.20.0

