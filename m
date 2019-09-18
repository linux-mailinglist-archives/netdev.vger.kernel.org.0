Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB349B6D09
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 21:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbfIRT4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 15:56:17 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:37647 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731994AbfIRT4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 15:56:16 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M8Syu-1iF5tw2IvA-004RAk; Wed, 18 Sep 2019 21:56:08 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Baron <jbaron@akamai.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dynamic_debug: provide dynamic_hex_dump stub
Date:   Wed, 18 Sep 2019 21:55:11 +0200
Message-Id: <20190918195607.2080036-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ovq3juYvSxkhml2oJ/RZRmqQHrA4XE75uWc3u0KJ+V4KdWJOs6t
 i39PGmoo9NADZL/6Ekow8/e6SKCYQ1+jJJ2IO44y+GJgjYZZsdgFTYxJVuFWSKQv19igyDB
 ZRAZT2QKqwwTo5Ex3zkMdJByff/UrhSAeTFNeZmnOXoLgsqfcH/Bd7sE26aAYVYnIIOpLZF
 bs+dkOdwvqu0h7qATQJKg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jI2VMkCpF2U=:mAaUB4R8b+R4MeHwr9Ea99
 rJarNNaXKaH5L1aYOP+Zg/VFfUX5Hs+WYfsV6UApY+yKOxLR+uGs1arXHaRNHpz2o3j+DKk+i
 mgdv5/8KJOI5bp8iMvTTztmp4PieylIqTS5mgaG1XNNe59qYjSznaEQeOS0U8xGD9ou19q60c
 AlS6oqQXlhn9cXBiMuCy6PeiEQ4wIE4/I3/9RrziVpemcO8s6Ghe1+HmzcsAxQRy0UZYcD4Dn
 zaege8LbFSxoCE/eRi00eR5OFbERDpAx+z2/m68qluhQbBJIRESHBrH7ho5+pUZd4QBEqQl5l
 sMw97DaiVAh5zwDXEebys/8R/fjPqH/5TV/ksxtwAT2F4GED0/qOKGdBcXR3hqjq65n4WgFvO
 usK5ig18eKv7l6As9QX7hFG0+sZi6o5CqCLbbG8sFczYd+3O+pjc1XbGi83kC1Gj1KPTrfiX+
 Zc/BR7uE5khKV7bDu7xX8JXr0VSuyKN+tVj7llDBGgKJLFtJczR8ghgMia1LohHQuv9dbgIZ+
 Os0ufhGE83ukTvJGRKXjKVUAUEzxv9sRz/XJnPP6S8N7xE3J32tFppI6nx1ickJ2ppKC66t/U
 cGwKNhAS0s4XwIFgyfbSWV9Q/05BoKoFK0sHj+P972LCn845gxOvyT1k2SCHsdj2d5lAUfXo5
 KPMbsKrmsMeW6cM4Od2EFH1mG/kc4QFt1SOcs4R+xTnlKNRl/cMWi8sb8cDdtkNHuL1UV50wo
 o7SOhLuacXyM/O+MuVdQcXGu/QFaUo6GPtQ7ZvhUcnJgTXdi9k5sdmFnT5dHd29bBcq+X/2YJ
 2rxBDKTZ2v/7JKpadl5GUsunYte6sAQEYlR66KVATrAQjxM0bUo1fuzC/BTMYhziQQ8kEXwzR
 U4CPNZl0BC3GFJsDba7w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ionic driver started using dymamic_hex_dump(), but
that is not always defined:

drivers/net/ethernet/pensando/ionic/ionic_main.c:229:2: error: implicit declaration of function 'dynamic_hex_dump' [-Werror,-Wimplicit-function-declaration]

Add a dummy implementation to use when CONFIG_DYNAMIC_DEBUG
is disabled, printing nothing.

Fixes: 938962d55229 ("ionic: Add adminq action")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 2 ++
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 ++
 include/linux/dynamic_debug.h                    | 6 ++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index db7c82742828..a255d24c8e40 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
 
+#include <linux/printk.h>
+#include <linux/dynamic_debug.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 15e432386b35..aab311413412 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
 
+#include <linux/printk.h>
+#include <linux/dynamic_debug.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/utsname.h>
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 6c809440f319..4cf02ecd67de 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -204,6 +204,12 @@ static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
 	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
+			 groupsize, buf, len, ascii)			\
+	do { if (0)							\
+		print_hex_dump(KERN_DEBUG, prefix_str, prefix_type,	\
+				rowsize, groupsize, buf, len, ascii);	\
+	} while (0)
 #endif
 
 #endif
-- 
2.20.0

