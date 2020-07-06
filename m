Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7F8215482
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 11:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgGFJUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 05:20:52 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:16658 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbgGFJUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 05:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594027250; x=1625563250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rT+zkN+mJUyB0ZWqxtGVHHzSd7amrOhD/J3nYFKzHLU=;
  b=y5tLFwFosf970xtPGDww65tSTltq/VrYRPrjZ1LbVwaqMZ5uvBbyi61z
   1rkz/SxME6uORTvWjVQ1DTcsdbQDbflsteiVa9feS1cYPh4+OJnbxUD/a
   jTPLjEViuUXC/Tqc/QfSeHEGYGbjA5yHyjQiG4Nh6j+Mi9T6cZ0SBtf+y
   9VCchoofPpeyGQ2so+zmhX+jlN3sY5pyya216ASgxvIz5RgxR0Z9JnDje
   B+A/7dP/OxgcWNRO8mSwRt8rWQauonDPnnGhaARNcvR4mZjwy0POqpm8p
   rYotie0SV8Ki6/H/3JmPWwfN9fl3euRYSs/YVIOwuDhT6d0lBxPDLpOXH
   g==;
IronPort-SDR: Prdk71/DpjzK+czNxa5hWdM4dusWBEvCYPqB8kE+uV4XBIg/20m+1Gt6cseA8TdPb8S1Jt3jdr
 qxi0NpjIT9r40oG3WAig48cqi4XKLQKKTUkSmV7r7vPIRbZb7UhwEWwSl9+wkbYOVl+NgQpore
 2bqXO4makaBS/pxDhOqOzKUSFaLUa4gYPH+QUtOuPw3I7ujG5suVcvQ5ru8r9ndc+bcN7v7LDy
 8OMrNTDjgFpyw24isJX3CdoJd2ltJwU9W0pzWrWlER02xKLsMk9+H9tcIqUiispCXMYnWlrQ/e
 WpQ=
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="18108972"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2020 02:20:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 6 Jul 2020 02:20:25 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 6 Jul 2020 02:20:23 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 03/12] bridge: mrp: Extend bridge interface
Date:   Mon, 6 Jul 2020 11:18:33 +0200
Message-ID: <20200706091842.3324565-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
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

