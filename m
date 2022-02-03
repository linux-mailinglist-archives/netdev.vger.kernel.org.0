Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853B14A9106
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 00:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355938AbiBCXMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 18:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiBCXMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 18:12:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4A7C061714;
        Thu,  3 Feb 2022 15:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF28DB835E9;
        Thu,  3 Feb 2022 23:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7834C340E8;
        Thu,  3 Feb 2022 23:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643929963;
        bh=M5HjFCZdxiAaPiipImUnmfv2jtfHule1mCY4Rgw/Q+4=;
        h=From:To:Cc:Subject:Date:From;
        b=FomJDNUBWgxl0ZuB9+PQ8YUpCaRi2ThbL4kbIJiZ630HJfY5WJ8Ry14IkpCJzHrcF
         FQcFx9+AEhXf8+LE2e0gcli9X0YmMSjanQ3tgKMlq7wVByMSJlceZ8UCffurfoqqME
         TObwKdUsRBfz/tnmQUAl1i5MbHOJqxQBOMdGm9A9QhXqya8c16SMiymfIyE/mdixLv
         Gn5Kjv8r8IbRih8xyKVdm3dh37B1j3ey5d/n76MnIcLlxDeWMjYXAW1rVtMY3x0YZV
         5KUTpUSykHHXTXFqB9MAVBtWkfw012W39gyZ2Ctyl5ReyXW9l3oUuizt/rY9WoJ++B
         KllkjakF6PB+w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        oliver@neukum.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        alex.aring@gmail.com, jukka.rissanen@linux.intel.com,
        matt@codeconstruct.com.au, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: [PATCH net-next v2] net: don't include ndisc.h from ipv6.h
Date:   Thu,  3 Feb 2022 15:12:40 -0800
Message-Id: <20220203231240.2297588-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing in ipv6.h needs ndisc.h, drop it.

Link: https://lore.kernel.org/r/20220203043457.2222388-1-kuba@kernel.org
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: j.vosburgh@gmail.com
CC: vfalico@gmail.com
CC: andy@greyhouse.net
CC: oliver@neukum.org
CC: yoshfuji@linux-ipv6.org
CC: dsahern@kernel.org
CC: alex.aring@gmail.com
CC: jukka.rissanen@linux.intel.com
CC: matt@codeconstruct.com.au
CC: linux-usb@vger.kernel.org
CC: linux-bluetooth@vger.kernel.org
CC: linux-wpan@vger.kernel.org
---
 drivers/net/bonding/bond_alb.c | 1 +
 drivers/net/usb/cdc_mbim.c     | 1 +
 include/net/ipv6.h             | 1 -
 include/net/ipv6_frag.h        | 1 +
 net/6lowpan/core.c             | 1 +
 net/ieee802154/6lowpan/core.c  | 1 +
 net/mctp/device.c              | 1 +
 7 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index c98a4b0a8453..303c8d32d451 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -19,6 +19,7 @@
 #include <linux/in.h>
 #include <net/arp.h>
 #include <net/ipv6.h>
+#include <net/ndisc.h>
 #include <asm/byteorder.h>
 #include <net/bonding.h>
 #include <net/bond_alb.h>
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 82bb5ed94c48..a7c1434fe2da 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -21,6 +21,7 @@
 #include <net/ipv6.h>
 #include <net/addrconf.h>
 #include <net/ipv6_stubs.h>
+#include <net/ndisc.h>
 
 /* alternative VLAN for IP session 0 if not untagged */
 #define MBIM_IPS0_VID	4094
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 082f30256f59..cda1f205f391 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -15,7 +15,6 @@
 #include <linux/refcount.h>
 #include <linux/jump_label_ratelimit.h>
 #include <net/if_inet6.h>
-#include <net/ndisc.h>
 #include <net/flow.h>
 #include <net/flow_dissector.h>
 #include <net/snmp.h>
diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 0a4779175a52..5052c66e22d2 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _IPV6_FRAG_H
 #define _IPV6_FRAG_H
+#include <linux/icmpv6.h>
 #include <linux/kernel.h>
 #include <net/addrconf.h>
 #include <net/ipv6.h>
diff --git a/net/6lowpan/core.c b/net/6lowpan/core.c
index a068757eabaf..7b3341cef926 100644
--- a/net/6lowpan/core.c
+++ b/net/6lowpan/core.c
@@ -5,6 +5,7 @@
  * (C) 2015 Pengutronix, Alexander Aring <aar@pengutronix.de>
  */
 
+#include <linux/if_arp.h>
 #include <linux/module.h>
 
 #include <net/6lowpan.h>
diff --git a/net/ieee802154/6lowpan/core.c b/net/ieee802154/6lowpan/core.c
index 2cf62718a282..2c087b7f17c5 100644
--- a/net/ieee802154/6lowpan/core.c
+++ b/net/ieee802154/6lowpan/core.c
@@ -47,6 +47,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/ieee802154.h>
+#include <linux/if_arp.h>
 
 #include <net/ipv6.h>
 
diff --git a/net/mctp/device.c b/net/mctp/device.c
index ef2755f82f87..02ddc0f1bd3e 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2021 Google
  */
 
+#include <linux/if_arp.h>
 #include <linux/if_link.h>
 #include <linux/mctp.h>
 #include <linux/netdevice.h>
-- 
2.34.1

