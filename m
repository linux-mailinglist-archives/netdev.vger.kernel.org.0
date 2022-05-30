Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC3E537F53
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238681AbiE3NxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239305AbiE3Nv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:51:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBF78199D;
        Mon, 30 May 2022 06:36:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C98F060D2C;
        Mon, 30 May 2022 13:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245EEC385B8;
        Mon, 30 May 2022 13:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917765;
        bh=r/dBWgTFOJ7LNQfKaxvKd/CJUkl0jSQjIUTPtjmE1js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYM+drjM80ucn6citCXb+5xNTaUoC6h8917GwH5NPnhAxHpe+NWiCq49ETCoMKjxh
         fqUsbwCa4OfwPNoX8Xi9yc3Zb6HrkzJmqb7KP+VnBDS4+zQyiR2Ok+j+aMrzf12wUQ
         mgmF+RLqwdrbIrtTjIw49Eg4ZAQj43Wwp+moiMl0h7B19svaOlGXyA9CP6jhlLhqpp
         cpab+4TTw28xic+1ffXgLwUs8Bjw1E3MyG75kr2oe+7/a1NduIZT3dqrNyl2+9vQP8
         NbXBL/eEOd5Nj59Yx9UyEVGS9RMK9FHWLcm3yqpV3izkDLxaxKndrWKrjcmlq14fyE
         9h2b70+uQW97Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo@kernel.org, ryder.lee@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, sean.wang@mediatek.com,
        deren.wu@mediatek.com, xing.song@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 091/135] mt76: mt7921: accept rx frames with non-standard VHT MCS10-11
Date:   Mon, 30 May 2022 09:30:49 -0400
Message-Id: <20220530133133.1931716-91-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3128ea016965ce9f91ddf4e1dd944724462d1698 ]

The hardware receives them properly, they should not be dropped

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 84f72dd1bf93..e07707f518a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -698,7 +698,7 @@ mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
 			status->nss =
 				FIELD_GET(MT_PRXV_NSTS, v0) + 1;
 			status->encoding = RX_ENC_VHT;
-			if (i > 9)
+			if (i > 11)
 				return -EINVAL;
 			break;
 		case MT_PHY_TYPE_HE_MU:
-- 
2.35.1

