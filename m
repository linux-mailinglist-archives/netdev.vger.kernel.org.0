Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B856B95C5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjCNNOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjCNNOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:14:22 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F42305FE
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=YSDGQgo64K7kPQPijTqgAMUKCwj
        Eu9vA4OsmPLBJ/pU=; b=B9HQI9o5SsFCfo06nrkKU/np4zw7Jw8Vb2MdaLMP+hH
        cMUnirTlQ8AIEKbdsMKhLQFnqNlSv1TnRxMonfGlCSMpPOSgdyZUvH38KsQFZ/tt
        qvLVFqkOF3gwDYP2UGN5B6bhF/uuG7HjcVnz+ktICCcNKvC7SrW3NHWos4S8gPUg
        =
Received: (qmail 3103901 invoked from network); 14 Mar 2023 13:49:30 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 14 Mar 2023 13:49:30 +0100
X-UD-Smtp-Session: l3s3148p1@nHeUqNv2OsQujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RESEND net-next] net: phy: micrel: drop superfluous use of temp variable
Date:   Tue, 14 Mar 2023 13:49:27 +0100
Message-Id: <20230314124928.44948-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'temp' was used before commit c0c99d0cd107 ("net: phy: micrel: remove
the use of .ack_interrupt()") refactored the code. Now, we can simplify
it a little.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---

Only tags added since last time.

 drivers/net/phy/micrel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 2c84fccef4f6..6c7845137c23 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -435,11 +435,9 @@ static int kszphy_config_intr(struct phy_device *phydev)
 		if (err)
 			return err;
 
-		temp = KSZPHY_INTCS_ALL;
-		err = phy_write(phydev, MII_KSZPHY_INTCS, temp);
+		err = phy_write(phydev, MII_KSZPHY_INTCS, KSZPHY_INTCS_ALL);
 	} else {
-		temp = 0;
-		err = phy_write(phydev, MII_KSZPHY_INTCS, temp);
+		err = phy_write(phydev, MII_KSZPHY_INTCS, 0);
 		if (err)
 			return err;
 
-- 
2.30.2

