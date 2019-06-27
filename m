Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D2057AAC
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 06:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfF0EaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 00:30:25 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:34142 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfF0EaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 00:30:25 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 18A32440209;
        Thu, 27 Jun 2019 07:30:22 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] net: dsa: mv88e6xxx: wait after reset deactivation
Date:   Thu, 27 Jun 2019 07:29:46 +0300
Message-Id: <92655572ed0c232b490967bed1245d121cc5a299.1561609786.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a 1ms delay after reset deactivation. Otherwise the chip returns
bogus ID value. This is observed with 88E6390 (Peridot) chip.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f4e2db44ad91..549f528f216c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4910,6 +4910,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 		err = PTR_ERR(chip->reset);
 		goto out;
 	}
+	mdelay(1);
 
 	err = mv88e6xxx_detect(chip);
 	if (err)
-- 
2.20.1

