Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4339C4EF671
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350864AbiDAPer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345602AbiDAOze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:55:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190B060CC9;
        Fri,  1 Apr 2022 07:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA1AEB823EB;
        Fri,  1 Apr 2022 14:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1351C340EE;
        Fri,  1 Apr 2022 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824226;
        bh=LSzVRn0NDfhPSMCSW4F1VVYlmUgrs7tEe750gpeqMOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddy5brxVmk4E0iIcdxzLkArG1ZV86eSiO+DiNgmfspO6qP2o2jfAczO7LUEKED+QZ
         UQadmcfgaW39i5s+uI05duO/bMvn+4bvzTuMYSWAMBeR/LwX9jncx/ahIIyI697LTr
         cNTUmOIVFG8kwzSnhDNpkCkffEpLrcWEuMaV+MdryXi6sEUxx2nrKv0HnFCRMpbl90
         xkVu+3prTsv7xSchz7Ar+GHeBZ26mBxUqRDONzo2ONU84m7G+MBBOq3iGoshbYLpio
         Jiy90UIBxAb/6D55Gw0GvTMBMbBU+4C9NPwm8o9DsLTA0oZE/eilCVBsM41ElQ/Tkl
         xZz+o2pXhuPHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, xing.song@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 38/65] mt76: mt7615: Fix assigning negative values to unsigned variable
Date:   Fri,  1 Apr 2022 10:41:39 -0400
Message-Id: <20220401144206.1953700-38-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 9273ffcc9a11942bd586bb42584337ef3962b692 ]

Smatch reports the following:
drivers/net/wireless/mediatek/mt76/mt7615/mac.c:1865
mt7615_mac_adjust_sensitivity() warn: assigning (-110) to unsigned
variable 'def_th'
drivers/net/wireless/mediatek/mt76/mt7615/mac.c:1865
mt7615_mac_adjust_sensitivity() warn: assigning (-98) to unsigned
variable 'def_th'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 424be103093c..1465a92ea3fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1626,7 +1626,7 @@ mt7615_mac_adjust_sensitivity(struct mt7615_phy *phy,
 	struct mt7615_dev *dev = phy->dev;
 	int false_cca = ofdm ? phy->false_cca_ofdm : phy->false_cca_cck;
 	bool ext_phy = phy != &dev->phy;
-	u16 def_th = ofdm ? -98 : -110;
+	s16 def_th = ofdm ? -98 : -110;
 	bool update = false;
 	s8 *sensitivity;
 	int signal;
-- 
2.34.1

