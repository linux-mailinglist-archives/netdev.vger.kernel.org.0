Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71FD3157FE
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhBIUtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:49:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:54902 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbhBIUfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612902936; x=1644438936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EHLVPvUVJez21AH8PebxAXBSYM5AvLzTmtWmafYTWPs=;
  b=UCTir8jeHWWyumutCnlkXE1qxTYqOB7zWLvg5nhBDUIZEV+B0OwtgDDG
   EQzk2Xqupy7E/qa7/ZzVe1FU7wxn/xjiqlEOCkErCA3GZt8obxZyZRNyD
   Ct7bBW40XwmFpRqpGWocl5h4PkFo1Zmjni5r0Q1oK5oRJPKoA2GcDKdBz
   xYQLdxLrGDKPCfmbbjowMGT1FyFnJ3rX1GxANKmnujQsPka54O0Jw5aMd
   sNgbp/Wox8Zfcr0ld3rvzSH6Kgj9dQTZDxiMygOjZQUl06SvaUfQbDC0f
   Ww+AAL6G46FVkgcfSfvvVUf1Xn6pM6iBwfxAp3+115iY2zpRak4q9jac8
   A==;
IronPort-SDR: Oju202nIkkMU8pXEVI3BqXqb0RWdKUozUz5kt4tNCAFAd0J2XSBaRxcWdKWH6AIB6QwXo7p9nv
 IJ2b8Be5yRgZ1p+wxko5mTvhyuQ77QULLOgBSBS68lvPt0/A8/hjG0n0h2O/sRRGfgmb3Zf6oU
 r/VaFOWSeknhPem7dgzrcZnFNmE1llE6xEu+IVmhmFF/Zo2Nwj5jU37uuCuzJJYYh/elcGLQek
 JpqCTXTRK1/s4ywwO74fK8t7RGCOq5dV6TCnW04ZpJckOEG7fpbyc9NT6NAv5KvcuZs+Xw7Sk4
 G+Y=
X-IronPort-AV: E=Sophos;i="5.81,166,1610434800"; 
   d="scan'208";a="114457590"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2021 13:24:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 13:24:22 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 9 Feb 2021 13:24:19 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 2/5] bridge: mrp: Add 'enum br_mrp_hw_support'
Date:   Tue, 9 Feb 2021 21:21:09 +0100
Message-ID: <20210209202112.2545325-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
References: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the enum br_mrp_hw_support that is used by the br_mrp_switchdev
functions to allow the SW to detect the cases where HW can't implement
the functionality or when SW is used as a backup.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_private_mrp.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 32a48e5418da..a94017f86cda 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -46,6 +46,20 @@ struct br_mrp {
 	struct rcu_head			rcu;
 };
 
+/* This type is returned by br_mrp_switchdev functions that allow to have a SW
+ * backup in case the HW can't implement completely the protocol.
+ * BR_MRP_NONE - means the HW can't run at all the protocol, so the SW stops
+ *               configuring the node anymore.
+ * BR_MRP_SW - the HW can help the SW to run the protocol, by redirecting MRP
+ *             frames to CPU.
+ * BR_MRP_HW - the HW can implement completely the protocol.
+ */
+enum br_mrp_hw_support {
+	BR_MRP_NONE,
+	BR_MRP_SW,
+	BR_MRP_HW,
+};
+
 /* br_mrp.c */
 int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance);
 int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance);
-- 
2.27.0

