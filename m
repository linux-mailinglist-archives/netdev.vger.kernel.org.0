Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3562204D8F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732227AbgFWJIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:08:41 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:49195 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731860AbgFWJIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 05:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592903319; x=1624439319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kQsP/yVJQUNUJxvLd2o3N1wn7VHKUz9qL3WSHlmLZFk=;
  b=Q32xHsQzTgNH2EuW1l8323hHiq8nbGoY+7E0kvW23MxGdHyms5JnXIRX
   v0eJ463QXjI83mk6JpYrwOaILy/b71RrrmcP3yj5JU11Qo3zKZdFT41KF
   BgZvUoifY9B0hX+QjXt73+rxJ1rlgFYHBLu9m/d+P36rgJkdFvj0vi6Vr
   PK/409M8SD3KEy+k/W7W1XL9wssRoF51CbnXbzZDvsx0HiEw1ftzwqnkO
   0YriJccKhTvXZXpjCaytz/IitYQpapFxqpY2MsW3Zb3qUoyACkWBA8SgN
   BzBXZPLcqTst/azEKATiLayEhN5tet7WJnVhKV+dPe+Cw6o346Amzy0QI
   Q==;
IronPort-SDR: ZWC3iHEXC8SuJzWR7KqfKAYgTV8gCEBoinHxCA/wRpTju48DhbOMQuMmaFF6baDAQIHa6jyR0R
 ItgadKISWBj4rfI6qA4seVAKqkdIKbQT/fhX5VVrtFIiXRiygefHaPlsfnqOWNU8PryRO0Vn/q
 3nB6XHKROq6L0+VhPrNCwlP6UNPBQhHQ0xp8Q2r3iRXJ5dwez7h25IM3Rs97Vu3a2xR+zqTKOQ
 UvJyXX6Q2c/xi1IQeoqSB+87y24+WhSXBeo9OnyZ47tDJxp2up85aPEDf1PBar6VgCIrsixSxu
 DFk=
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="79436705"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jun 2020 02:08:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 02:08:27 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 23 Jun 2020 02:08:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 1/2] bridge: uapi: mrp: Fix MRP_PORT_ROLE
Date:   Tue, 23 Jun 2020 11:05:40 +0200
Message-ID: <20200623090541.2964760-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623090541.2964760-1-horatiu.vultur@microchip.com>
References: <20200623090541.2964760-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the MRP_PORT_ROLE_NONE has the value 0x2 but this is in conflict
with the IEC 62439-2 standard. The standard defines the following port
roles: primary (0x0), secondary(0x1), interconnect(0x2).
Therefore remove the port role none.

Fixes: 4714d13791f831 ("bridge: uapi: mrp: Add mrp attributes.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/mrp_bridge.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
index 84f15f48a7cb1..bee3665402129 100644
--- a/include/uapi/linux/mrp_bridge.h
+++ b/include/uapi/linux/mrp_bridge.h
@@ -36,7 +36,6 @@ enum br_mrp_port_state_type {
 enum br_mrp_port_role_type {
 	BR_MRP_PORT_ROLE_PRIMARY,
 	BR_MRP_PORT_ROLE_SECONDARY,
-	BR_MRP_PORT_ROLE_NONE,
 };
 
 enum br_mrp_tlv_header_type {
-- 
2.26.2

