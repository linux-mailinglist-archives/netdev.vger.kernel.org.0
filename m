Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E316537DAC
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbiE3Ngr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiE3Nf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:35:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB755972A6;
        Mon, 30 May 2022 06:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F73BB80DB2;
        Mon, 30 May 2022 13:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77616C341C0;
        Mon, 30 May 2022 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917365;
        bh=T278upJVbk/em8SEvypNZ1SQJbk0LgQu1PtRWWC3Fk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmrflu6BB6qYtMwexXN4gE7m1evmgZ0KM+ezA/iXPC4KMWj6qwWieK3sm67Xz4zK/
         Gr7stbfbNE+/dY1eeHA17hragCy13WK8KNtSflXj7DEl4tRY8ZY8FeYMySQ/9WKjVH
         SqXFaMKdbmI3UDR9FAZtr5a7OzomvRXPU+yBxN/u4forfqhkUWuzBEsTNuKNUo0XLE
         9S78RxnN6WMwM4BU164N6ehSqxjCBz1sZbiuTCDo5KnG9futEd03XAoE1JUZt9MNg5
         Dg0K0ZGh5Ckv5ye9sXKb9kuKaErzTfnKau55gPYwCVgLEHSrgeYBGbI9C8u797molq
         2PEOUaGrTEjtw==
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
Subject: [PATCH AUTOSEL 5.18 110/159] mt76: mt7921: accept rx frames with non-standard VHT MCS10-11
Date:   Mon, 30 May 2022 09:23:35 -0400
Message-Id: <20220530132425.1929512-110-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
index 233998ca4857..f34070ca7bbe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -696,7 +696,7 @@ mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
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

