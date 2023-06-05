Return-Path: <netdev+bounces-7888-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41086721FA9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0DAE280FFA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DECFA11C83;
	Mon,  5 Jun 2023 07:34:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ABA11C82
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:34:43 +0000 (UTC)
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CF983;
	Mon,  5 Jun 2023 00:34:41 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f620583bc2so1628929e87.1;
        Mon, 05 Jun 2023 00:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685950480; x=1688542480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DAgRq2EXmiJlw5QVvMbHQppFdqv5pzza5dzmoTwBNQ8=;
        b=GOPR4d+/UEzaru7bfg0RdVmwWCfzmOk0IQA91sr3KwRMPXT30HCwHUn05o8osUkDpD
         MsA7L94HI7gZfq3ALkgV3RippOJKS26pkN/bdoRJPCCwr7GkxE4BELQdzz+/jiFCzj47
         LutkrzD710untVOO5vy2jWpN3/4HCZv99+yPalk8MvgtcRMziJfLxNsR4GIugdW83XaK
         u8oLh5kpyiDr1n44SQIuGNyMUQvqnSeddlU6ij+6RtpodwOZ7ENHZiUkGCL7qydhznuI
         6RNnLnHKr8Qzd4ibaeAcm/tw0ObHcTOAA7muPFpKY/VxTLR7Y6kU0cV6lDEK+5JOB94w
         vMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685950480; x=1688542480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DAgRq2EXmiJlw5QVvMbHQppFdqv5pzza5dzmoTwBNQ8=;
        b=k0lRy8pwJNHGZ1uB79EjaMci6ErxKFg+Rv+epu00WLPDMLcaaztyD1AzRCZLXSZy0K
         jsfUC25onuWcnClnZB4WeJ6Q1zX7a4NItR1bRn+Hyjs8DFi9jjETGugNQO/u6IUu7x4H
         9FBkX8HyyiuzOJ3z7nZd13Mdi1fttNc0LNcLs23iECBBEmqxsTUAQwq9o0rJN+YSLOfn
         dpG0BuxjIRykslmaV0CXcaxo9nnxG5g+crXuizPzyBzBJrVzbxMUHOyilgEn96wk/nLv
         NXLKhrzdWMSbuqpVz/PrAusLhN3BsRD34OgD/KJ+AVuVD2Y7BIJsNj/AvvYEZd+GZlyD
         N3sg==
X-Gm-Message-State: AC+VfDyfILKOPeiVemfAXGBCDpDmRJe/W9fak6T5ascArkT11sDoK/2x
	QYU+8fZ8BkaxNYjSSfR+EwOQnIGlQjIn0A==
X-Google-Smtp-Source: ACHHUZ5IEYPCmzkGOJfS9ic1+YXKE8YtO6DZakUgS6piCmgDsgm+OHr8VSg70fHzplr4P2NyIUY0Sw==
X-Received: by 2002:ac2:4281:0:b0:4f1:3d6c:d89b with SMTP id m1-20020ac24281000000b004f13d6cd89bmr4850910lfh.42.1685950479796;
        Mon, 05 Jun 2023 00:34:39 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id w12-20020ac2598c000000b004f62225ffb6sm564382lfn.105.2023.06.05.00.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 00:34:39 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
	by home.paul.comp (8.15.2/8.15.2/Debian-22) with ESMTP id 3557YZcg008744;
	Mon, 5 Jun 2023 10:34:36 +0300
Received: (from paul@localhost)
	by home.paul.comp (8.15.2/8.15.2/Submit) id 3557YXaZ008743;
	Mon, 5 Jun 2023 10:34:33 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Paul Fertser <fercerpav@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Rani Hod <rani.hod@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] mt76: mt7615: do not advertise 5 GHz on first phy of MT7615D (DBDC)
Date: Mon,  5 Jun 2023 10:34:07 +0300
Message-Id: <20230605073408.8699-1-fercerpav@gmail.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On DBDC devices the first (internal) phy is only capable of using
2.4 GHz band, and the 5 GHz band is exposed via a separate phy object,
so avoid the false advertising.

Reported-by: Rani Hod <rani.hod@gmail.com>
Closes: https://github.com/openwrt/openwrt/pull/12361
Fixes: 7660a1bd0c22 ("mt76: mt7615: register ext_phy if DBDC is detected")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index 68e88224b8b1..ccedea7e8a50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -128,12 +128,12 @@ mt7615_eeprom_parse_hw_band_cap(struct mt7615_dev *dev)
 	case MT_EE_5GHZ:
 		dev->mphy.cap.has_5ghz = true;
 		break;
-	case MT_EE_2GHZ:
-		dev->mphy.cap.has_2ghz = true;
-		break;
 	case MT_EE_DBDC:
 		dev->dbdc_support = true;
 		fallthrough;
+	case MT_EE_2GHZ:
+		dev->mphy.cap.has_2ghz = true;
+		break;
 	default:
 		dev->mphy.cap.has_2ghz = true;
 		dev->mphy.cap.has_5ghz = true;
-- 
2.34.1


