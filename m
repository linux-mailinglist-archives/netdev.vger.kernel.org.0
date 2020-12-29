Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CEF2E741F
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 22:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgL2VRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 16:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgL2VRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 16:17:06 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FCDC061574;
        Tue, 29 Dec 2020 13:16:26 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id 2so9798271qtt.10;
        Tue, 29 Dec 2020 13:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e5c5L6PkkRukqnqeirSiRa0wobmulUeCxBAdDa7q5Wo=;
        b=LBdtKJhZaU2qug8bi0oFTpSYo1HQ1o+LWSO4EH6JqS0CUojDNPaxArNMKzmAvKG1QV
         xTH8T0iAeZ6VNgO1+Nb03Qy9FRjnXiCpb0zRo7jmwbtncZedDuM/WLY1L51m8cc9Bqym
         xoFCi8UpXrDSH+BXcfyU9vrj++WU4BuP4NIXnA9pksYbHlotLtetUpkImMPquuoXnj3H
         F7wx0n15Q2mm7na2izyy98jq0aDd/z3/TAxKHwzYIuTrEeluSLvL45J4UHffgOYbPhp1
         KjtveWHrpl/a70y22HNIKbMkxGdurizftBVc5V9OGn7HJ2zThfzmX6s8/dQ3uFslF4kb
         r+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e5c5L6PkkRukqnqeirSiRa0wobmulUeCxBAdDa7q5Wo=;
        b=VaNdtaVK+JMh6F3vKtXXZ2z/1ZBrEtQXz/6rsyXU4cYBoQm71E20sLECQD1CHHzwr7
         aiWDJtzHb+mwI/gnVPiBQ5ZIptv+a/yWjrU6HjVNfZLTuh02Lus3EANpjbU1S32KgZlY
         Q4glZ9Ks6wDRK5QRv7dqpF4gUlz+aiclccUmP3JTDzUTHiRwicl0B5LBnDcie1V1aFZa
         SaSt1rxEgvxrNexgd4Rn5ztmw7JZdk1cJ6I+hRGPDJ9CryjiyqvFrxg2Pq/VpEtf3ALg
         ejyprzUFf8em7WkfEhfaN+Lod7WieMHlSvOjBsn8nRb8aKIYxKPxT5jDiqxE6mvnB2nR
         GiyA==
X-Gm-Message-State: AOAM532OFVbWGciDmRQZITjHKfXUm1h/0cbrIwkO/ZHUpUXs14GV6/6x
        bBdxXzWVE8mMXWJ2sMGsbek=
X-Google-Smtp-Source: ABdhPJxykmySgmkP73cl/xMh/k7U71ysJZwMD04YDaZs3K5u4rIQSefyX4MBBc4sjEUyhHi9+/ANtA==
X-Received: by 2002:ac8:5786:: with SMTP id v6mr51450739qta.268.1609276585265;
        Tue, 29 Dec 2020 13:16:25 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id l11sm26656665qtn.83.2020.12.29.13.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Dec 2020 13:16:24 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] mt76: Fix queue ID variable types after mcu queue split
Date:   Tue, 29 Dec 2020 14:15:48 -0700
Message-Id: <20201229211548.1348077-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns in both mt7615 and mt7915:

drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:271:9: warning: implicit
conversion from enumeration type 'enum mt76_mcuq_id' to different
enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
                txq = MT_MCUQ_FWDL;
                    ~ ^~~~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:278:9: warning: implicit
conversion from enumeration type 'enum mt76_mcuq_id' to different
enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
                txq = MT_MCUQ_WA;
                    ~ ^~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:282:9: warning: implicit
conversion from enumeration type 'enum mt76_mcuq_id' to different
enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
                txq = MT_MCUQ_WM;
                    ~ ^~~~~~~~~~
3 warnings generated.

drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:238:9: warning: implicit
conversion from enumeration type 'enum mt76_mcuq_id' to different
enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
                qid = MT_MCUQ_WM;
                    ~ ^~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:240:9: warning: implicit
conversion from enumeration type 'enum mt76_mcuq_id' to different
enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
                qid = MT_MCUQ_FWDL;
                    ~ ^~~~~~~~~~~~
2 warnings generated.

Use the proper type for the queue ID variables to fix these warnings.
Additionally, rename the txq variable in mt7915_mcu_send_message to be
more neutral like mt7615_mcu_send_message.

Fixes: e637763b606b ("mt76: move mcu queues to mt76_dev q_mcu array")
Link: https://github.com/ClangBuiltLinux/linux/issues/1229
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index a44b7766dec6..c13547841a4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -231,7 +231,7 @@ mt7615_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 			int cmd, int *seq)
 {
 	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
-	enum mt76_txq_id qid;
+	enum mt76_mcuq_id qid;
 
 	mt7615_mcu_fill_msg(dev, skb, cmd, seq);
 	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 5fdd1a6d32ee..e211a2bd4d3c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -256,7 +256,7 @@ mt7915_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 	struct mt7915_dev *dev = container_of(mdev, struct mt7915_dev, mt76);
 	struct mt7915_mcu_txd *mcu_txd;
 	u8 seq, pkt_fmt, qidx;
-	enum mt76_txq_id txq;
+	enum mt76_mcuq_id qid;
 	__le32 *txd;
 	u32 val;
 
@@ -268,18 +268,18 @@ mt7915_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 		seq = ++dev->mt76.mcu.msg_seq & 0xf;
 
 	if (cmd == -MCU_CMD_FW_SCATTER) {
-		txq = MT_MCUQ_FWDL;
+		qid = MT_MCUQ_FWDL;
 		goto exit;
 	}
 
 	mcu_txd = (struct mt7915_mcu_txd *)skb_push(skb, sizeof(*mcu_txd));
 
 	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state)) {
-		txq = MT_MCUQ_WA;
+		qid = MT_MCUQ_WA;
 		qidx = MT_TX_MCU_PORT_RX_Q0;
 		pkt_fmt = MT_TX_TYPE_CMD;
 	} else {
-		txq = MT_MCUQ_WM;
+		qid = MT_MCUQ_WM;
 		qidx = MT_TX_MCU_PORT_RX_Q0;
 		pkt_fmt = MT_TX_TYPE_CMD;
 	}
@@ -326,7 +326,7 @@ mt7915_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 	if (wait_seq)
 		*wait_seq = seq;
 
-	return mt76_tx_queue_skb_raw(dev, mdev->q_mcu[txq], skb, 0);
+	return mt76_tx_queue_skb_raw(dev, mdev->q_mcu[qid], skb, 0);
 }
 
 static void

base-commit: 5c8fe583cce542aa0b84adc939ce85293de36e5e
-- 
2.30.0

