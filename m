Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B050B21F3CF
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgGNOWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:22:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:53224 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgGNOWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 10:22:19 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id B6739140974;
        Tue, 14 Jul 2020 16:22:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1594736533; bh=NieiXCfh5o60E79GA2oM1/Nk5/5yOQgzvNC83nIpS34=;
        h=From:To:Date;
        b=hXWehJsfsD/MCcgACrSfGIrJzhUTz6j2yVY4lplhG7LUFJka5EiFwIpo/pSSjnbWL
         R8gI9bYB4tuXueOx9SOei3XT9LuOAcMFc54yxpOaFnHOQkDsPvcjCZyI6V40opp4u9
         DyjIqFn2ZuZXvu22/zfvpjC+k177FuX6HGWrDIMQ=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v1 2/2] Documentation: ABI: document MDIO bus debugfs files
Date:   Tue, 14 Jul 2020 16:22:13 +0200
Message-Id: <20200714142213.21365-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142213.21365-1-marek.behun@nic.cz>
References: <20200714142213.21365-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the documentation for debugfs files residing in
/sys/kernel/debug/mdio_bus. These files are created when
CONFIG_MDIO_BUS_DEBUGFS option is enabled.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 Documentation/ABI/testing/debugfs-mdio_bus | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-mdio_bus

diff --git a/Documentation/ABI/testing/debugfs-mdio_bus b/Documentation/ABI/testing/debugfs-mdio_bus
new file mode 100644
index 000000000000..4cd60869c896
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-mdio_bus
@@ -0,0 +1,29 @@
+What:		/sys/kernel/debug/mdio_bus/<MDIO_BUS>/addr
+Date:		July 2020
+KernelVersion:	5.9
+Contact:	Marek Behún <marek.behun@nic.cz>
+Description:	(RW) Address of the PHY device on the MDIO bus which should be
+		read from/written to when accessing the "val" file in this
+		directory.
+		Format: %u
+
+What:		/sys/kernel/debug/mdio_bus/<MDIO_BUS>/reg
+Date:		July 2020
+KernelVersion:	5.9
+Contact:	Marek Behún <marek.behun@nic.cz>
+Description:	(RW) Register number of the PHY device selected by the "addr"
+		file in this directory, which should be read from/written to
+		when accessing the "val" file in this directory.
+		To access Clause 45 register do a bitwise or with MII_ADDR_C45
+		(=0x40000000).
+		Format: %u
+
+What:		/sys/kernel/debug/mdio_bus/<MDIO_BUS>/val
+Date:		July 2020
+KernelVersion:	5.9
+Contact:	Marek Behún <marek.behun@nic.cz>
+Description:	(RW) Value of the register specified by the "reg" file of the
+		PHY device specified by the "addr" file in this directory.
+		Reading/writing this file calls directly function
+		mdiobus_read/mdiobus_write with arguments from these files.
+		Format: 0x%04x
-- 
2.26.2

