Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7DE3016C4
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 17:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAWQWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 11:22:06 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:16215 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbhAWQVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 11:21:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611418891; x=1642954891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x1dQhUol+8VUXh7OWgoJGUChQ9yRIXGyOFo+E8lOWP0=;
  b=YzrxfEU65cCaBhozQul9J3RmFEPbYyY4Ui4ELjfUb06irRepTSGs5p9s
   3/wqZS9pZuukEpdxsIvKMEdVhL85YRPkSK1ObpuQv0FcdRjX5zyjb/+fe
   vzQEph9aIlKKOJYQQHKCSvxElq+i0Jkp5t8YluLE8bZI5gkANqECA/hy9
   VABS/aCrDT+xPOd0Q8Cho1+23mzN+5XiBtJrthTdcYIs4tJZoLxjmDVyj
   Y/WaZ16pCEtXNccLLcLiIuSVoIES2yfQnmJTALIUzOMdBk/xZlpqdFI+3
   BGyL7dq+wv/fFoh+rkyoe1w2zOBUCDnRkUFpkaNA+ZKBlBkaFK9KCBCJ/
   w==;
IronPort-SDR: 17Ql66CSHJhtCeqvHZkPXt/HGhDRp6yHMB7D2a8DlI4UXkQ9qPoaEUp/h3uehpztihvpkh5mxb
 m1XRTAKv0M4UX60edrRJwmCBr2r8dxbHbh/VQ0QWkYX+C1znSBFe0KXVm6/pzYf/YvUOF1bKXe
 2a4yy6HYsYwxDopqLVd6hECzeXA4f3EApcNT2BZEvH5quempu9vDW+zrYdN7MmTqHGBC++RL9H
 RS5euOrgNUxJatNIkoEpI3P4cSWjbAHyx4Lnw6TGm9Ssh/O24t46YCJuWu6SNu0NSzS8zKydpM
 ReA=
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="103959007"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jan 2021 09:19:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 23 Jan 2021 09:19:54 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sat, 23 Jan 2021 09:19:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/4] bridge: mrp: Add 'enum br_mrp_hw_support'
Date:   Sat, 23 Jan 2021 17:18:10 +0100
Message-ID: <20210123161812.1043345-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
References: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the enum br_mrp_hw_support that is used by the br_mrp_switchdev
functions to allow the SW to detect better the cases where the HW can't
implement this or when the SW is used as a backup.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_private_mrp.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 1883118aae55..31e666ae6955 100644
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

