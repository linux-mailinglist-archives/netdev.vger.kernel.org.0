Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B755279CA2
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgIZV0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:26:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgIZV0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 17:26:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMHhw-00GJud-MU; Sat, 26 Sep 2020 23:26:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Matteo Croce <mcroce@microsoft.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: marvell: mvpp2: Fix W=1 warning with !CONFIG_ACPI
Date:   Sat, 26 Sep 2020 23:26:03 +0200
Message-Id: <20200926212603.3889748-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:7084:36: warning: ‘mvpp2_acpi_match’ defined but not used [-Wunused-const-variable=]
 7084 | static const struct acpi_device_id mvpp2_acpi_match[] = {
      |                                    ^~~~~~~~~~~~~~~~

Wrap the definition inside #ifdef/#endif.

Compile tested only.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d11d33cf3443..f6616c8933ca 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7081,11 +7081,13 @@ static const struct of_device_id mvpp2_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mvpp2_match);
 
+#ifdef CONFIG_ACPI
 static const struct acpi_device_id mvpp2_acpi_match[] = {
 	{ "MRVL0110", MVPP22 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, mvpp2_acpi_match);
+#endif
 
 static struct platform_driver mvpp2_driver = {
 	.probe = mvpp2_probe,
-- 
2.28.0

