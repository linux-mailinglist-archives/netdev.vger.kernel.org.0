Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F289B817
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390535AbfHWV0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:26:07 -0400
Received: from mail.nic.cz ([217.31.204.67]:35818 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389903AbfHWV0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 17:26:07 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id F3E06140D25;
        Fri, 23 Aug 2019 23:26:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566595565; bh=YIWvywXG5cMKb85+wWsVo0m8lI/pPY8HpQngP3cxvZw=;
        h=From:To:Date;
        b=e2SV+Zh4KEKCPkR7+bnYmVuvBZfr/UbBrr9qs42Qbjzj9U0b7qZ1Dzd6mALXvQu4Y
         yGA6HPn/YlK2eo7xmR7KEByPSgJ2fEOcdyQh09G77XltjWGScPF54ZmWkhO9zyfrn3
         k18FgPEZkhVF3UAGYpcZvsKxnEYYBLRkP6mhUp6U=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v2 3/9] net: dsa: mv88e6xxx: fix port hidden register macros
Date:   Fri, 23 Aug 2019 23:25:57 +0200
Message-Id: <20190823212603.13456-4-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823212603.13456-1-marek.behun@nic.cz>
References: <20190823212603.13456-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to be uniform with the rest of the driver, prepend hidden
register macro names with the MV88E6XXX_ prefix. Also do not use the
BIT() macro nor bit shifts, to be consistent with rest of port.h macro
definitions.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/port.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 2b251ba30e52..58aecf5a7cb4 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -261,14 +261,14 @@
 #define MV88E6095_PORT_IEEE_PRIO_REMAP_4567	0x19
 
 /* Offset 0x1a: Magic undocumented errata register */
-#define PORT_RESERVED_1A			0x1a
-#define PORT_RESERVED_1A_BUSY			BIT(15)
-#define PORT_RESERVED_1A_WRITE			BIT(14)
-#define PORT_RESERVED_1A_READ			0
-#define PORT_RESERVED_1A_PORT_SHIFT		5
-#define PORT_RESERVED_1A_BLOCK			(0xf << 10)
-#define PORT_RESERVED_1A_CTRL_PORT		4
-#define PORT_RESERVED_1A_DATA_PORT		5
+#define MV88E6XXX_PORT_RESERVED_1A		0x1a
+#define MV88E6XXX_PORT_RESERVED_1A_BUSY		0x8000
+#define MV88E6XXX_PORT_RESERVED_1A_WRITE	0x4000
+#define MV88E6XXX_PORT_RESERVED_1A_READ		0x0000
+#define MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT	5
+#define MV88E6XXX_PORT_RESERVED_1A_BLOCK	0x3c00
+#define MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT	0x04
+#define MV88E6XXX_PORT_RESERVED_1A_DATA_PORT	0x05
 
 int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 			u16 *val);
-- 
2.21.0

