Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D865D1C766D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgEFQaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:30:39 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58202 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgEFQai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:38 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUYJw116942;
        Wed, 6 May 2020 11:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782634;
        bh=T7PG90KboEYVGUhRi6iQEWJpyNo3ebhImthT1MYEiqs=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=wYu2ABp7aOygtoEP1+e6dEHif/dwXyp9TBk2Vk9AFQRgo1WlmulR6DOrYwqEB9g89
         0iMZTm8fP12w1qZc0fDVe6OUUassHwD7av3IutvcLAry8yxWMcizUuzHLfkVyBTRls
         TalCS+VsfdXPkjvL1ZBGZ82H7ppqRtfWgDbQtIiU=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUYo6081648
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:34 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:34 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:34 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDe119719;
        Wed, 6 May 2020 11:30:34 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 01/13] net: hsr: Re-use Kconfig option to support PRP
Date:   Wed, 6 May 2020 12:30:21 -0400
Message-ID: <20200506163033.3843-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PRP, Parallel Redundancy Protocol is another redundancy
protocol defined by IEC62439-3 similar to HSR. PRP uses
a RCT, Redundancy Control Trailer appended to the end
of a Ethernet frame to implement redundancy. There are
many similarities between these protocols so that existing
code for HSR can be enhanced to support PRP. So as
a first step, rename the existing CONFIG_HSR to
CONFIG_HSR_PRP to introduce PRP.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/Makefile     |  2 +-
 net/hsr/Kconfig  | 38 +++++++++++++++++++++++---------------
 net/hsr/Makefile |  2 +-
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/net/Makefile b/net/Makefile
index 07ea48160874..4f1c6a44f2c3 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -77,7 +77,7 @@ obj-$(CONFIG_OPENVSWITCH)	+= openvswitch/
 obj-$(CONFIG_VSOCKETS)	+= vmw_vsock/
 obj-$(CONFIG_MPLS)		+= mpls/
 obj-$(CONFIG_NET_NSH)		+= nsh/
-obj-$(CONFIG_HSR)		+= hsr/
+obj-$(CONFIG_HSR_PRP)		+= hsr/
 ifneq ($(CONFIG_NET_SWITCHDEV),)
 obj-y				+= switchdev/
 endif
diff --git a/net/hsr/Kconfig b/net/hsr/Kconfig
index 9c58f8763997..220befd8e2c3 100644
--- a/net/hsr/Kconfig
+++ b/net/hsr/Kconfig
@@ -1,27 +1,35 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# IEC 62439-3 High-availability Seamless Redundancy
+# IEC 62439-3 High-availability Seamless Redundancy (HSR) /
+# IEC 62439-4 Parallel Redundancy Protocol (PRP)
 #
-
-config HSR
-	tristate "High-availability Seamless Redundancy (HSR)"
+config HSR_PRP
+	tristate "IEC 62439 HSR/PRP Support"
 	---help---
+	  This enables IEC 62439 defined High-availability Seamless
+	  Redundancy (HSR) and Parallel Redundancy Protocol (PRP).
 	  If you say Y here, then your Linux box will be able to act as a
-	  DANH ("Doubly attached node implementing HSR"). For this to work,
-	  your Linux box needs (at least) two physical Ethernet interfaces,
-	  and it must be connected as a node in a ring network together with
-	  other HSR capable nodes.
+	  DANH ("Doubly attached node implementing HSR") or DANP ("Doubly
+	  attached node implementing PRP"). For this to work, your Linux
+	  box needs (at least) two physical Ethernet interfaces.
+
+	  For DANH, it must be connected as a node in a ring network together
+	  with other HSR capable nodes. All Ethernet frames sent over the hsr
+	  device will be sent in both directions on the ring (over both slave
+	  ports), giving a redundant, instant fail-over network. Each HSR node
+	  in the ring acts like a bridge for HSR frames, but filters frames
+	  that have been forwarded earlier.
 
-	  All Ethernet frames sent over the hsr device will be sent in both
-	  directions on the ring (over both slave ports), giving a redundant,
-	  instant fail-over network. Each HSR node in the ring acts like a
-	  bridge for HSR frames, but filters frames that have been forwarded
-	  earlier.
+	  For DANP, it must be connected as a node connecting to two
+	  separate networks over the two slave interfaces. Like HSR, Ethernet
+	  frames sent over the prp device will be sent to both networks giving
+	  a redundant, instant fail-over network.
 
 	  This code is a "best effort" to comply with the HSR standard as
 	  described in IEC 62439-3:2010 (HSRv0) and IEC 62439-3:2012 (HSRv1),
-	  but no compliancy tests have been made. Use iproute2 to select
-	  the version you desire.
+	  and PRP standard described in IEC 62439-4:2012 (PRP), but no
+	  compliancy tests have been made. Use iproute2 to select the protocol
+	  you would like to use.
 
 	  You need to perform any and all necessary tests yourself before
 	  relying on this code in a safety critical system!
diff --git a/net/hsr/Makefile b/net/hsr/Makefile
index 75df90d3b416..fd207c1a0854 100644
--- a/net/hsr/Makefile
+++ b/net/hsr/Makefile
@@ -3,7 +3,7 @@
 # Makefile for HSR
 #
 
-obj-$(CONFIG_HSR)	+= hsr.o
+obj-$(CONFIG_HSR_PRP)	+= hsr.o
 
 hsr-y			:= hsr_main.o hsr_framereg.o hsr_device.o \
 			   hsr_netlink.o hsr_slave.o hsr_forward.o
-- 
2.17.1

