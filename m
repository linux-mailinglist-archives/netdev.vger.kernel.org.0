Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB1558028D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 18:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiGYQWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 12:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbiGYQWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 12:22:15 -0400
X-Greylist: delayed 357 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Jul 2022 09:22:12 PDT
Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CE3167EB;
        Mon, 25 Jul 2022 09:22:12 -0700 (PDT)
Received: from localhost.localdomain (unknown [113.118.189.34])
        by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 0C493800017;
        Tue, 26 Jul 2022 00:16:10 +0800 (CST)
From:   Chukun Pan <amadeus@jmu.edu.cn>
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lintel Huang <lintel.huang@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chukun Pan <amadeus@jmu.edu.cn>
Subject: [PATCH] wifi: mt7601u: Add AP mode support
Date:   Tue, 26 Jul 2022 00:16:03 +0800
Message-Id: <20220725161603.15201-1-amadeus@jmu.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTBodVkNDTkkfSUoYTkJCT1UTARMWGhIXJBQOD1
        lXWRgSC1lBWUpKSFVKSkNVSkNCVUhPWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ok06GTo4ND09PE42KD4WKwkr
        PwIaFDBVSlVKTU5DTE1OTExLTE9PVTMWGhIXVRoWGh8eDgg7ERYOVR4fDlUYFUVZV1kSC1lBWUpK
        SFVKSkNVSkNCVUhPWVdZCAFZQUlJTU03Bg++
X-HM-Tid: 0a823624fe87b03akuuu0c493800017
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add AP mode support to mt7601u chipset.
Simply tested it with firmware version
201302052146 and it seems working fine.

Run-tested-by: Lintel Huang <lintel.huang@gmail.com>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
---
 drivers/net/wireless/mediatek/mt7601u/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 5d9e952b2966..d18800b41704 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -609,7 +609,8 @@ int mt7601u_register_device(struct mt7601u_dev *dev)
 	SET_IEEE80211_PERM_ADDR(hw, dev->macaddr);
 
 	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
-	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_AP);
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
-- 
2.25.1

