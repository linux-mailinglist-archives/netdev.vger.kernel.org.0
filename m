Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D911D6B966F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjCNNiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjCNNi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:38:29 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890B3F772
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=SsTC9UU9wdPdSI
        0PbPhntycZBlShn3e/V5pFPLMU5/8=; b=ZvcXfLKABiDC9npZb4SVa4ELduNGUH
        JYWlTOq5gC2b1Av3MwV0fQnLvYANm1jrF0pT40lXXp0CxRsKZsy3vYQ9Tq9h8aJr
        28EY9RgVIc3Y//DR8263wPxS2Mdmzx+kTMLxVu0VBVJZZG9mv8UlX+qnZXcuzzXG
        m9CExX8bF7Wg4=
Received: (qmail 3111703 invoked from network); 14 Mar 2023 14:14:58 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 14 Mar 2023 14:14:58 +0100
X-UD-Smtp-Session: l3s3148p1@fFKrA9z2ts0ujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, kernel@pengutronix.de,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] smsc911x: add FIXME to move 'mac_managed_pm' to probe
Date:   Tue, 14 Mar 2023 14:14:42 +0100
Message-Id: <20230314131443.46342-5-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
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

On Renesas hardware, we had issues because the above flag was set during
'open'. It was concluded that it needs to be set during 'probe'. It
looks like SMS911x needs the same fix but I can't test it because I
don't have the hardware. At least, leave a note about the issue.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/smsc/smsc911x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index a2e511912e6a..745e0180eb34 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1038,6 +1038,7 @@ static int smsc911x_mii_probe(struct net_device *dev)
 	}
 
 	/* Indicate that the MAC is responsible for managing PHY PM */
+	/* FIXME: should be set right after mdiobus is registered */
 	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
-- 
2.30.2

