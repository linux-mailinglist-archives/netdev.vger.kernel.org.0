Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4E3538005
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbiE3OJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbiE3OGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:06:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B8746B1F;
        Mon, 30 May 2022 06:42:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63C8BB80D86;
        Mon, 30 May 2022 13:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3317BC36AE5;
        Mon, 30 May 2022 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918133;
        bh=Poz0P3FU8oei4d2vEBfJHhiPc/hGrkpoKT1vFnt42T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oxskev01N4G84C9GC+nejttmA0hEd6BdRkcnk21UXMPb89qa+9F5P12spiU0X4oPz
         OhwqJ4UW4remL1pzcM2d/aU6WRWp4TY9xxNBwSGT0CqDf7ypLWHlcq4e4uepUsrD+M
         WJ0btL0loELeTu28xyye28t7olm30RHExqNxVmZMMiDMDaoJmn4C4gUtK2sBDufYEn
         SpTZD7IwwvsZ59/MKosjX5nwwy0b+ssLXG5hT9ogH2+x+hBJQE7zK41rrZqE51vwlm
         LgldYUBljhRBO6c0AepbqWomRs4wxJE/YIBmpSqsRzgdZyn9wt8yz329BH7lh22OsK
         DeLFMegV19iOA==
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
Subject: [PATCH AUTOSEL 5.15 074/109] mt76: mt7921: accept rx frames with non-standard VHT MCS10-11
Date:   Mon, 30 May 2022 09:37:50 -0400
Message-Id: <20220530133825.1933431-74-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index c093920a597d..5024ddf07cbc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -563,7 +563,7 @@ int mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
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

