Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F406CD243
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjC2Go0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjC2GoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:44:25 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F7C3AA6
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 23:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=n8up9OJPcKiVa51VxJ/2teaZbWR
        WgLIPAQW7kxiXS0A=; b=C6cDbrJ5bT/Dj6Aaynq2ZsZyjIwn+tLkVWeRU6Ucpt9
        SM94E6Guh4zRaxOvKUKlCQBcK6iyOm1wfPu0gZK75as+xTVZ+uKx0yJCcHIlU8bP
        oXfM0HnXvKMXBXLZYZsDp2uKVdOx85TLvGRjLpNS0CqHBbty7scwftNFQcSK8VIM
        =
Received: (qmail 457609 invoked from network); 29 Mar 2023 08:44:18 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 29 Mar 2023 08:44:18 +0200
X-UD-Smtp-Session: l3s3148p1@8RYgTgT4Ao8ujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] smsc911x: remove superfluous variable init
Date:   Wed, 29 Mar 2023 08:44:14 +0200
Message-Id: <20230329064414.25028-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phydev is assigned a value right away, no need to initialize it.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---

Changes since v1:
* rebased to net-next as of today
* added Geert's tag (thanks!)

 drivers/net/ethernet/smsc/smsc911x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 39446d4e94b6..c653ea792dd1 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1016,7 +1016,7 @@ static void smsc911x_phy_adjust_link(struct net_device *dev)
 static int smsc911x_mii_probe(struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
-	struct phy_device *phydev = NULL;
+	struct phy_device *phydev;
 	int ret;
 
 	/* find the first phy */
-- 
2.30.2

