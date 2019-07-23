Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18072711BF
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 08:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388199AbfGWGPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 02:15:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:51134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388117AbfGWGOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 02:14:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5975FAFA8;
        Tue, 23 Jul 2019 06:14:37 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     David Miller <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org
Subject: [PATCH net-next] qlge: Move drivers/net/ethernet/qlogic/qlge/ to drivers/staging/qlge/
Date:   Tue, 23 Jul 2019 15:14:13 +0900
Message-Id: <20190723061413.10342-1-bpoirier@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware has been declared EOL by the vendor more than 5 years ago.
What's more relevant to the Linux kernel is that the quality of this driver
is not on par with many other mainline drivers.

Cc: Manish Chopra <manishc@marvell.com>
Message-id: <20190617074858.32467-1-bpoirier@suse.com>
Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 Documentation/PCI/pci-error-recovery.rst      |  1 -
 MAINTAINERS                                   |  2 +-
 drivers/net/ethernet/qlogic/Kconfig           |  9 ----
 drivers/net/ethernet/qlogic/Makefile          |  1 -
 drivers/staging/Kconfig                       |  2 +
 drivers/staging/Makefile                      |  1 +
 drivers/staging/qlge/Kconfig                  | 10 ++++
 .../ethernet/qlogic => staging}/qlge/Makefile |  0
 drivers/staging/qlge/TODO                     | 46 +++++++++++++++++++
 .../ethernet/qlogic => staging}/qlge/qlge.h   |  0
 .../qlogic => staging}/qlge/qlge_dbg.c        |  0
 .../qlogic => staging}/qlge/qlge_ethtool.c    |  0
 .../qlogic => staging}/qlge/qlge_main.c       |  0
 .../qlogic => staging}/qlge/qlge_mpi.c        |  0
 14 files changed, 60 insertions(+), 12 deletions(-)
 create mode 100644 drivers/staging/qlge/Kconfig
 rename drivers/{net/ethernet/qlogic => staging}/qlge/Makefile (100%)
 create mode 100644 drivers/staging/qlge/TODO
 rename drivers/{net/ethernet/qlogic => staging}/qlge/qlge.h (100%)
 rename drivers/{net/ethernet/qlogic => staging}/qlge/qlge_dbg.c (100%)
 rename drivers/{net/ethernet/qlogic => staging}/qlge/qlge_ethtool.c (100%)
 rename drivers/{net/ethernet/qlogic => staging}/qlge/qlge_main.c (100%)
 rename drivers/{net/ethernet/qlogic => staging}/qlge/qlge_mpi.c (100%)

diff --git a/Documentation/PCI/pci-error-recovery.rst b/Documentation/PCI/pci-error-recovery.rst
index 83db42092935..7e30f43a9659 100644
--- a/Documentation/PCI/pci-error-recovery.rst
+++ b/Documentation/PCI/pci-error-recovery.rst
@@ -421,4 +421,3 @@ That is, the recovery API only requires that:
    - drivers/net/ixgbe
    - drivers/net/cxgb3
    - drivers/net/s2io.c
-   - drivers/net/qlge
diff --git a/MAINTAINERS b/MAINTAINERS
index 783569e3c4b4..9bca7781d67e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13217,7 +13217,7 @@ M:	Manish Chopra <manishc@marvell.com>
 M:	GR-Linux-NIC-Dev@marvell.com
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	drivers/net/ethernet/qlogic/qlge/
+F:	drivers/staging/qlge/
 
 QM1D1B0004 MEDIA DRIVER
 M:	Akihiro Tsukada <tskd08@gmail.com>
diff --git a/drivers/net/ethernet/qlogic/Kconfig b/drivers/net/ethernet/qlogic/Kconfig
index a391cf6ee4b2..55a29ec76680 100644
--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -66,15 +66,6 @@ config QLCNIC_HWMON
 
 	  This data is available via the hwmon sysfs interface.
 
-config QLGE
-	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
-	depends on PCI
-	---help---
-	  This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called qlge.
-
 config NETXEN_NIC
 	tristate "NetXen Multi port (1/10) Gigabit Ethernet NIC"
 	depends on PCI
diff --git a/drivers/net/ethernet/qlogic/Makefile b/drivers/net/ethernet/qlogic/Makefile
index 6cd2e333a5fc..1ae4a0743bd5 100644
--- a/drivers/net/ethernet/qlogic/Makefile
+++ b/drivers/net/ethernet/qlogic/Makefile
@@ -5,7 +5,6 @@
 
 obj-$(CONFIG_QLA3XXX) += qla3xxx.o
 obj-$(CONFIG_QLCNIC) += qlcnic/
-obj-$(CONFIG_QLGE) += qlge/
 obj-$(CONFIG_NETXEN_NIC) += netxen/
 obj-$(CONFIG_QED) += qed/
 obj-$(CONFIG_QEDE)+= qede/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 7c96a01eef6c..0b8a614be11e 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -120,4 +120,6 @@ source "drivers/staging/kpc2000/Kconfig"
 
 source "drivers/staging/isdn/Kconfig"
 
+source "drivers/staging/qlge/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index fcaac9693b83..741152511a10 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -50,3 +50,4 @@ obj-$(CONFIG_EROFS_FS)		+= erofs/
 obj-$(CONFIG_FIELDBUS_DEV)     += fieldbus/
 obj-$(CONFIG_KPC2000)		+= kpc2000/
 obj-$(CONFIG_ISDN_CAPI)		+= isdn/
+obj-$(CONFIG_QLGE)		+= qlge/
diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
new file mode 100644
index 000000000000..ae9ed2c5300b
--- /dev/null
+++ b/drivers/staging/qlge/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config QLGE
+	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
+	depends on PCI
+	help
+	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
+
+	To compile this driver as a module, choose M here. The module will be
+	called qlge.
diff --git a/drivers/net/ethernet/qlogic/qlge/Makefile b/drivers/staging/qlge/Makefile
similarity index 100%
rename from drivers/net/ethernet/qlogic/qlge/Makefile
rename to drivers/staging/qlge/Makefile
diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
new file mode 100644
index 000000000000..51c509084e80
--- /dev/null
+++ b/drivers/staging/qlge/TODO
@@ -0,0 +1,46 @@
+* reception stalls permanently (until admin intervention) if the rx buffer
+  queues become empty because of allocation failures (ex. under memory
+  pressure)
+* commit 7c734359d350 ("qlge: Size RX buffers based on MTU.", v2.6.33-rc1)
+  introduced dead code in the receive routines, which should be rewritten
+  anyways by the admission of the author himself, see the comment above
+  ql_build_rx_skb(). That function is now used exclusively to handle packets
+  that underwent header splitting but it still contains code to handle non
+  split cases.
+* truesize accounting is incorrect (ex: a 9000B frame has skb->truesize 10280
+  while containing two frags of order-1 allocations, ie. >16K)
+* while in that area, using two 8k buffers to store one 9k frame is a poor
+  choice of buffer size.
+* in the "chain of large buffers" case, the driver uses an skb allocated with
+  head room but only puts data in the frags.
+* rename "rx" queues to "completion" queues. Calling tx completion queues "rx
+  queues" is confusing.
+* struct rx_ring is used for rx and tx completions, with some members relevant
+  to one case only
+* there is an inordinate amount of disparate debugging code, most of which is
+  of questionable value. In particular, qlge_dbg.c has hundreds of lines of
+  code bitrotting away in ifdef land (doesn't compile since commit
+  18c49b91777c ("qlge: do vlan cleanup", v3.1-rc1), 8 years ago).
+* triggering an ethtool regdump will hexdump a 176k struct to dmesg depending
+  on some module parameters.
+* the flow control implementation in firmware is buggy (sends a flood of pause
+  frames, resets the link, device and driver buffer queues become
+  desynchronized), disable it by default
+* some structures are initialized redundantly (ex. memset 0 after
+  alloc_etherdev())
+* the driver has a habit of using runtime checks where compile time checks are
+  possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
+* reorder struct members to avoid holes if it doesn't impact performance
+* in terms of namespace, the driver uses either qlge_, ql_ (used by
+  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
+  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
+  prefix.
+* avoid legacy/deprecated apis (ex. replace pci_dma_*, replace pci_enable_msi,
+  use pci_iomap)
+* some "while" loops could be rewritten with simple "for", ex.
+  ql_wait_reg_rdy(), ql_start_rx_ring())
+* remove duplicate and useless comments
+* fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
+  qlge_set_multicast_list()).
+* fix weird indentation (all over, ex. the for loops in qlge_get_stats())
+* fix checkpatch issues
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h b/drivers/staging/qlge/qlge.h
similarity index 100%
rename from drivers/net/ethernet/qlogic/qlge/qlge.h
rename to drivers/staging/qlge/qlge.h
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
similarity index 100%
rename from drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
rename to drivers/staging/qlge/qlge_dbg.c
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
similarity index 100%
rename from drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c
rename to drivers/staging/qlge/qlge_ethtool.c
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
similarity index 100%
rename from drivers/net/ethernet/qlogic/qlge/qlge_main.c
rename to drivers/staging/qlge/qlge_main.c
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
similarity index 100%
rename from drivers/net/ethernet/qlogic/qlge/qlge_mpi.c
rename to drivers/staging/qlge/qlge_mpi.c
-- 
2.22.0

