Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2F121C9AE
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgGLOJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:09:32 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:50857 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbgGLOJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 10:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594562970; x=1626098970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rT+zkN+mJUyB0ZWqxtGVHHzSd7amrOhD/J3nYFKzHLU=;
  b=HwpL1ynhOmz4wC0YheO/FzrkwJog5Tq52jmoDOVCo+yMeqIiP+krmxmo
   cHxOzjMGmwGxJU8BizCftF6dQZ1NWnEr5e/FJ4n3C/atMGnJEJCSSPzYE
   1FaRoGzv/XPSQDbmzkyaJEvvUlyHRCnU9x9c8lJPUbdfAYAeGIuuObQQn
   DQEwwOn0F1QfBUFoV328pwrz3uueG0Z51Ie4Wg7Hb6A/QQNVNWU+HfbET
   /ON5GE6isoqZhnHXZl+gn/k4gjHS7cE7lb+/57BDoyH5vAFqmUllrm0FO
   Blf6u1+9S2vHgFAPf9A6gzCbeumLZNnLI2bFuN7vH8cQ8wUAeKNnyCAF6
   Q==;
IronPort-SDR: niSiRnXfyFhoBRIVlrpJkbYA8adsh20VXzClGA6NnSYfiBY5TMbAEa1Y+rdByeEBifOz0hMVuj
 zpQW1aeedRGu6pQbnLPXoeXBH4COgADkVKYIG9cB/ZNBiGQOWSjaBIx7alIXqmDldZUHAFgb0/
 mtXOI0IVi8zIj3JFF6OG26tqyL7vshVx9bMDs/ridCQOuOD24jzPrPSlX0aayQXR2kCAI7vH5E
 lLcVEamyQ6WKHPixbc3b2gOWKPYr7AdR/rh/r1/kad1whFHI0Bi04JWD0XnBzvKBF908kxWXV6
 shg=
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="81541615"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2020 07:09:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 12 Jul 2020 07:09:00 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sun, 12 Jul 2020 07:08:58 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 03/12] bridge: mrp: Extend bridge interface
Date:   Sun, 12 Jul 2020 16:05:47 +0200
Message-ID: <20200712140556.1758725-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712140556.1758725-1-horatiu.vultur@microchip.com>
References: <20200712140556.1758725-1-horatiu.vultur@microchip.com>
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

