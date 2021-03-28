Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F9434BC50
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 14:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhC1M0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 08:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhC1M02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 08:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46235617ED;
        Sun, 28 Mar 2021 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616934387;
        bh=B4r0dpa2i8p6ISiGwWzzhwikdXgNkehWJF7jPj0W90Q=;
        h=From:To:Cc:Subject:Date:From;
        b=OOFOnPIoQWobg+K0sYTP3wvgRF/jfiHdnf4or0Or7s6KfFTDqrZ+0ZvRdX41lp1Db
         eaXU4FC6X0EXCi4h3o9w8YgCAfR+O50tYpPUituolkdguRTTs8NN5/XFm21DZxGfmE
         O0M5Y07sV6EtlyfiGLVTE8uMfpi4pKI1L2MKZx74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Du Cheng <ducheng2@gmail.com>
Subject: [PATCH net-next] qrtr: move to staging
Date:   Sun, 28 Mar 2021 14:26:21 +0200
Message-Id: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There does not seem to be any developers willing to maintain the
net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
from the kernel tree entirely in a few kernel releases if no one steps
up to maintain it.

Reported-by: Matthew Wilcox <willy@infradead.org>
Cc: Du Cheng <ducheng2@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/Kconfig                | 2 ++
 drivers/staging/Makefile               | 1 +
 {net => drivers/staging}/qrtr/Kconfig  | 1 +
 {net => drivers/staging}/qrtr/Makefile | 0
 {net => drivers/staging}/qrtr/mhi.c    | 0
 {net => drivers/staging}/qrtr/ns.c     | 0
 {net => drivers/staging}/qrtr/qrtr.c   | 0
 {net => drivers/staging}/qrtr/qrtr.h   | 0
 {net => drivers/staging}/qrtr/smd.c    | 0
 {net => drivers/staging}/qrtr/tun.c    | 0
 net/Kconfig                            | 1 -
 net/Makefile                           | 1 -
 12 files changed, 4 insertions(+), 2 deletions(-)
 rename {net => drivers/staging}/qrtr/Kconfig (98%)
 rename {net => drivers/staging}/qrtr/Makefile (100%)
 rename {net => drivers/staging}/qrtr/mhi.c (100%)
 rename {net => drivers/staging}/qrtr/ns.c (100%)
 rename {net => drivers/staging}/qrtr/qrtr.c (100%)
 rename {net => drivers/staging}/qrtr/qrtr.h (100%)
 rename {net => drivers/staging}/qrtr/smd.c (100%)
 rename {net => drivers/staging}/qrtr/tun.c (100%)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 6e798229fe25..43ab47e7861c 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -112,4 +112,6 @@ source "drivers/staging/wfx/Kconfig"
 
 source "drivers/staging/hikey9xx/Kconfig"
 
+source "drivers/staging/qrtr/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 8d4d9812ecdf..0b7ae2a72954 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -45,4 +45,5 @@ obj-$(CONFIG_KPC2000)		+= kpc2000/
 obj-$(CONFIG_QLGE)		+= qlge/
 obj-$(CONFIG_WIMAX)		+= wimax/
 obj-$(CONFIG_WFX)		+= wfx/
+obj-$(CONFIG_QRTR)		+= qrtr/
 obj-y				+= hikey9xx/
diff --git a/net/qrtr/Kconfig b/drivers/staging/qrtr/Kconfig
similarity index 98%
rename from net/qrtr/Kconfig
rename to drivers/staging/qrtr/Kconfig
index b4020b84760f..e91825f01307 100644
--- a/net/qrtr/Kconfig
+++ b/drivers/staging/qrtr/Kconfig
@@ -4,6 +4,7 @@
 
 config QRTR
 	tristate "Qualcomm IPC Router support"
+	depends on NET
 	help
 	  Say Y if you intend to use Qualcomm IPC router protocol.  The
 	  protocol is used to communicate with services provided by other
diff --git a/net/qrtr/Makefile b/drivers/staging/qrtr/Makefile
similarity index 100%
rename from net/qrtr/Makefile
rename to drivers/staging/qrtr/Makefile
diff --git a/net/qrtr/mhi.c b/drivers/staging/qrtr/mhi.c
similarity index 100%
rename from net/qrtr/mhi.c
rename to drivers/staging/qrtr/mhi.c
diff --git a/net/qrtr/ns.c b/drivers/staging/qrtr/ns.c
similarity index 100%
rename from net/qrtr/ns.c
rename to drivers/staging/qrtr/ns.c
diff --git a/net/qrtr/qrtr.c b/drivers/staging/qrtr/qrtr.c
similarity index 100%
rename from net/qrtr/qrtr.c
rename to drivers/staging/qrtr/qrtr.c
diff --git a/net/qrtr/qrtr.h b/drivers/staging/qrtr/qrtr.h
similarity index 100%
rename from net/qrtr/qrtr.h
rename to drivers/staging/qrtr/qrtr.h
diff --git a/net/qrtr/smd.c b/drivers/staging/qrtr/smd.c
similarity index 100%
rename from net/qrtr/smd.c
rename to drivers/staging/qrtr/smd.c
diff --git a/net/qrtr/tun.c b/drivers/staging/qrtr/tun.c
similarity index 100%
rename from net/qrtr/tun.c
rename to drivers/staging/qrtr/tun.c
diff --git a/net/Kconfig b/net/Kconfig
index 9c456acc379e..09f14caf3f45 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -242,7 +242,6 @@ source "net/nsh/Kconfig"
 source "net/hsr/Kconfig"
 source "net/switchdev/Kconfig"
 source "net/l3mdev/Kconfig"
-source "net/qrtr/Kconfig"
 source "net/ncsi/Kconfig"
 
 config PCPU_DEV_REFCNT
diff --git a/net/Makefile b/net/Makefile
index 9ca9572188fe..5d57e972a33b 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -74,7 +74,6 @@ obj-$(CONFIG_NET_NSH)		+= nsh/
 obj-$(CONFIG_HSR)		+= hsr/
 obj-$(CONFIG_NET_SWITCHDEV)	+= switchdev/
 obj-$(CONFIG_NET_L3_MASTER_DEV)	+= l3mdev/
-obj-$(CONFIG_QRTR)		+= qrtr/
 obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
 obj-$(CONFIG_MPTCP)		+= mptcp/
-- 
2.31.1

