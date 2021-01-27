Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7DF306577
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhA0Uzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:55:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:55542 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbhA0UzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:55:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611780920; x=1643316920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4l7QtdDF30xMuMl5WJwjk9QOHeOUIvPqe++9uZvWWQ4=;
  b=gT4Fs5v+g3qc4VPe587mo6HC72fZaVhfdBjkcg9A1Qj7bqNbITbs+inU
   bb8hqxSudXaS4shCnImqLP+34tZfnJRBR08t3Mf4Zp0o7JuYwZTN5YG3S
   vhBcRrczaXHlmYRdcZx6bhHWM7n2s1hTIyQpyWHt8RfMXl6BptIoCKpiP
   2Uo1WPjm1lLvgX5Pi07mPGSmsl1HlzLrk1K45bsp1+tWO/ltMHnFfeZEC
   AZfgf6nhV4qYAUxCyJTRuAqlJhuP7iSrbSosXcIGA41cVJuGQ3h//30rL
   DPiGOwSfWckKd00XevbXYHTVsibYF4anKRjoJvwZnKl54lz7mgeM80by+
   A==;
IronPort-SDR: ovy3c0dmtRwYTZo0ZxQWJRKhoBaNXy0J9xj725GGN99/o3jcMr0B9qwK3BpIGvoeKZ1VpeXD/2
 P/LuVqdAVslbtp0QeRe1wZwlo7m32s7qWH0tfE7NUZt2ANQGIaw4aR1PEqD25fqfnwiuSn25aW
 L47qK+Nmv65uCKxVyUX0ponve+MuPj1/WtUxF3/9U5/ljBDfX0/X5K+fRGWDjQA/lqsR9vfskH
 2eY9Q4KRx1BSc0IMUQScFLrkitdgQ0HtQ5n4x0WyfXse9zyugFtsWwuYP8tb/G8T/lD3sjtrBA
 dT0=
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="112760419"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 13:54:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 13:54:04 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 13:54:02 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/4] bridge: mrp: Add 'enum br_mrp_hw_support'
Date:   Wed, 27 Jan 2021 21:52:39 +0100
Message-ID: <20210127205241.2864728-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
References: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
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

