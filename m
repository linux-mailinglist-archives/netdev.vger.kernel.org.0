Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1762ED0FFB
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbfJIN0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:26:36 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:57749 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731229AbfJIN0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 09:26:35 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iIBz3-0007Cn-Fl; Wed, 09 Oct 2019 14:26:29 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iIBz2-00006n-P9; Wed, 09 Oct 2019 14:26:28 +0100
From:   Ben Dooks <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/ethernet: xgmac don't set .driver twice
Date:   Wed,  9 Oct 2019 14:26:27 +0100
Message-Id: <20191009132627.316-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup the .driver setup to just do it once, to avoid
the following sparse warning:

drivers/net/ethernet/calxeda/xgmac.c:1914:10: warning: Initializer entry defined twice
drivers/net/ethernet/calxeda/xgmac.c:1920:10:   also defined here

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/calxeda/xgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index f96a42af1014..af04a2c81adb 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1914,10 +1914,10 @@ static struct platform_driver xgmac_driver = {
 	.driver = {
 		.name = "calxedaxgmac",
 		.of_match_table = xgmac_of_match,
+		.pm = &xgmac_pm_ops,
 	},
 	.probe = xgmac_probe,
 	.remove = xgmac_remove,
-	.driver.pm = &xgmac_pm_ops,
 };
 
 module_platform_driver(xgmac_driver);
-- 
2.23.0

