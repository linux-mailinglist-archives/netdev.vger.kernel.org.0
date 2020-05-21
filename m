Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD5A1DD959
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgEUVVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:21:31 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:64611 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590096090; x=1621632090;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3YYTfA2G0R/lyoHmUaWO5sWwSP3/w89inO0e4lZ0ubk=;
  b=JesRP476xfbe7MwOQxsPkI71u/1lw45wuLNr/5WHFO8z2gLSjQT0x5cW
   EAdXSddpKHBaTv4WqFR8YLG7tf98AtA3tq55FNs3qVYiOafE3GYl2p9ry
   vNmfuN/CEJp+deBhWDxxUyyuGibKs7TzCjTySnDkg90KeXeJKijhMJ3K/
   +V9NNJNIrXfc5DTsIcgjFme9zGFRT29FgguRbxEdxyUa4qpK1IBDHENRL
   ypFm0r/WCcR3Zmd2RXg9PJT7YlhJySKBIoYm6Yg/WIwH+4A6nHMUssLtE
   TRZPnDednJz0/1w9dQNQOBWtdZkGttuIFKbZMxYF+Omz4m1yAGqtvj3AA
   Q==;
IronPort-SDR: CSSKbGS8Vh8u8ljYKS/8gGpe0qNuSxHPahN2RKcrWxNmqqWIdQRW7YwzCLWMC4K405dmsYL6vA
 BRV+7t6lEoO62I8tEbHUKoTJ9rBKY8y/jy/aaUnbnkRvQqY2EG42WzolYC9PCAsokXRoqrHs8a
 vpHFDDrXWrfbu+Iwce3z0FIoxM/b7L9x07OTJojgp+e3GfhR0GNZ+HWIV0eixWjJcfsgKZ8q5S
 0VqdWJrIL6YMNPo/Udmc0LXP1JuMEdgw3Qe9ic+mP7sugpjps8nW/HEJNZBAoDedySNtNOgxj2
 WFs=
X-IronPort-AV: E=Sophos;i="5.73,419,1583218800"; 
   d="scan'208";a="77506680"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 May 2020 14:21:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 May 2020 14:21:30 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 21 May 2020 14:21:28 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 0/3] bridge: mrp: Add br_mrp_unique_ifindex function
Date:   Thu, 21 May 2020 23:19:04 +0000
Message-ID: <20200521231907.3564679-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds small fixes to MRP implementation.
The following are fixed in this patch series:
- now is not allow to add the same port to multiple MRP rings
- remove unused variable
- restore the port state according to the bridge state when the MRP instance
  is deleted

v2:
 - use rtnl_dereference instead of rcu_dereference in the first patch

Horatiu Vultur (3):
  bridge: mrp: Add br_mrp_unique_ifindex function
  switchdev: mrp: Remove the variable mrp_ring_state
  bridge: mrp: Restore port state when deleting MRP instance

 include/net/switchdev.h |  1 -
 net/bridge/br_mrp.c     | 38 ++++++++++++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 5 deletions(-)

-- 
2.26.2

