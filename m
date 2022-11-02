Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E149616411
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiKBNs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKBNs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:48:26 -0400
X-Greylist: delayed 103 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Nov 2022 06:48:24 PDT
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E502AC51;
        Wed,  2 Nov 2022 06:48:24 -0700 (PDT)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4N2Ss338PDz5PkGw;
        Wed,  2 Nov 2022 21:48:23 +0800 (CST)
Received: from xaxapp03.zte.com.cn ([10.88.40.52])
        by mse-fl1.zte.com.cn with SMTP id 2A2DmGnv006058;
        Wed, 2 Nov 2022 21:48:16 +0800 (+08)
        (envelope-from zhang.songyi@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Wed, 2 Nov 2022 21:48:20 +0800 (CST)
Date:   Wed, 2 Nov 2022 21:48:20 +0800 (CST)
X-Zmail-TransId: 2af963627524ffffffffb35f9d57
X-Mailer: Zmail v1.0
Message-ID: <202211022148203360503@zte.com.cn>
Mime-Version: 1.0
From:   <zhang.songyi@zte.com.cn>
To:     <snelson@pensando.io>
Cc:     <drivers@pensando.io>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <brett@pensando.io>, <mohamed@pensando.io>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhang.songyi@zte.com.cn>, <jiang.xuexin@zte.com.cn>,
        <xue.zhihong@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIGlvbmljOiByZW1vdmUgcmVkdW5kYW50IHJldCB2YXJpYWJsZQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2A2DmGnv006058
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 63627527.000 by FangMail milter!
X-FangMail-Envelope: 1667396903/4N2Ss338PDz5PkGw/63627527.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<zhang.songyi@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63627527.000/4N2Ss338PDz5PkGw
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 06579895d9e3f6441fa30d52e3b585b2015c7e2e Mon Sep 17 00:00:00 2001
From: zhang songyi <zhang.songyi@zte.com.cn>
Date: Wed, 2 Nov 2022 20:57:40 +0800
Subject: [PATCH linux-next] ionic: remove redundant ret variable

Return value from ionic_set_features() directly instead of taking this in
another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4dd16c487f2b..a68d748502fd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1557,14 +1557,11 @@ static int ionic_set_features(struct net_device *netdev,
                  netdev_features_t features)
 {
    struct ionic_lif *lif = netdev_priv(netdev);
-   int err;

    netdev_dbg(netdev, "%s: lif->features=0x%08llx new_features=0x%08llx\n",
           __func__, (u64)lif->netdev->features, (u64)features);

-   err = ionic_set_nic_features(lif, features);
-
-   return err;
+   return ionic_set_nic_features(lif, features);
 }

 static int ionic_set_attr_mac(struct ionic_lif *lif, u8 *mac)
--
2.15.2
