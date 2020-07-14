Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96B321EA47
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgGNHjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:39:15 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43769 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgGNHjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594712349; x=1626248349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rT+zkN+mJUyB0ZWqxtGVHHzSd7amrOhD/J3nYFKzHLU=;
  b=JxwlPnROO58/6tiag1X7+FgYJlMgutV5hmr5/83/N8fVXL6dXLbKDrQ/
   62CEyQS0c4Fn2nUinKDATS3a605riYo34lq/HcuR+w9BGd0ni0jRxqn+4
   +DTJAh7OUt+5fQWFl1yuL9c5qzoNVYoKk12gNIr22o3pXJTe6JqmrOF7l
   3lagI9KWbF6+z3J6KzpTYXNQJjH7SHpdJBLkc6hybrfyM0BTkQ0ilLMDW
   BMI0CjKVfT2J8xlf0/Pz+SOSHDQrvWdJkok/QNwNTdM53Y6VAmAClIPsS
   hz/6G8gNnOAB1OXNeq0YND8HpK0A5ZPOMyae1CiRD/HAoDK5/vDUC2QV3
   Q==;
IronPort-SDR: m/hxBj5PE/FCodgaV5+RJQN/vzZak33sLgZNRadnBwUS044pHJkbqVp6qT/5fEpSi0vW3DvDcO
 YQkso/xhX5Ijv/JnnMEmHe+3dwbJJLCOfWvXNk5g1GSBNW8NGhLRM9sU8fVB585gtBELfvUY55
 QLEflJUNU79XIG997TVGgm0xmKm84+XaBTMPY3gcgnQ8UJWF6YHYJgMAo6vDfTWAO22Ban+FFG
 mm3gmEWfKJX7B/Kx4R3eIX2PzdyuuL+c8qaaDsDpTJSwgPUqoqm51g1yAzqR6S7hfepwoMZmqY
 uXo=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="19099960"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 00:39:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 00:39:09 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 14 Jul 2020 00:39:06 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 03/12] bridge: mrp: Extend bridge interface
Date:   Tue, 14 Jul 2020 09:34:49 +0200
Message-ID: <20200714073458.1939574-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new flag(BR_MRP_LOST_IN_CONT) to the net bridge
ports. This bit will be set when the port lost the continuity of
MRP_InTest frames.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/linux/if_bridge.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b3a8d3054af0f..6479a38e52fa9 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -49,6 +49,7 @@ struct br_ip_list {
 #define BR_ISOLATED		BIT(16)
 #define BR_MRP_AWARE		BIT(17)
 #define BR_MRP_LOST_CONT	BIT(18)
+#define BR_MRP_LOST_IN_CONT	BIT(19)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
-- 
2.27.0

