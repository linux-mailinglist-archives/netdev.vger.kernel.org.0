Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1116B537D37
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbiE3Nhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237921AbiE3Nfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03E695DDA;
        Mon, 30 May 2022 06:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8067DB80DB1;
        Mon, 30 May 2022 13:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753B1C36AE3;
        Mon, 30 May 2022 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917357;
        bh=VePB9HYfx5w6HP34ukuWlxDdJC0cAZBd+ZDzUXQyhfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1K2sU4KTLIzppIMW9gb2i6kKWCD29pKfzRv2QLA9SHg+jhXUJfgyN36onWzvCKvx
         cCnAzgjGLzHW2Yrfcvj/ohgjSIWIU3EpsCJzu+IfcfIXKBAjln0ehvVs+3eRYXP3Jt
         E06L8WdBiJvFvU73QzJTtlewRHGh1jofOk9VFzsQ/CWnrjts19Ojwdbrn30NYcvhq8
         4eFiJDSvbJM3RF+dSkEyjgHgPzCd844vDLetttkaPdpzWicUXoNq1embdHG5baKCqq
         HTvYKrZ8vFAtdZ6um5nZdjeVAW6sDZUlWlUgTiJrS8+I4s7F0+JzM5arsYl4uUZCBB
         W411Q3u8i3vzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo@kernel.org, ryder.lee@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, shayne.chen@mediatek.com,
        greearb@candelatech.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 109/159] mt76: mt7915: accept rx frames with non-standard VHT MCS10-11
Date:   Mon, 30 May 2022 09:23:34 -0400
Message-Id: <20220530132425.1929512-109-sashal@kernel.org>
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

[ Upstream commit 77045a3740fa3d2325293cf8623899532b39303e ]

The hardware receives them properly, they should not be dropped

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index e9e7efbf350d..a8df65cc115f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -521,7 +521,7 @@ mt7915_mac_fill_rx_rate(struct mt7915_dev *dev,
 		status->encoding = RX_ENC_VHT;
 		if (gi)
 			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
-		if (i > 9)
+		if (i > 11)
 			return -EINVAL;
 		break;
 	case MT_PHY_TYPE_HE_MU:
-- 
2.35.1

