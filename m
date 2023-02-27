Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED876A4143
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 12:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjB0L53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 06:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjB0L51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 06:57:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2261F900;
        Mon, 27 Feb 2023 03:57:25 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso11585143pjv.0;
        Mon, 27 Feb 2023 03:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UL2ps8yaPj+oovF7HkNPRUPm6/ExhIXpUcFA+LZV1i4=;
        b=mX8m8PH4kwuZFOdGmAjNOVMEHyrxdN+oHDHiDLndFYfPmKmlIQhlaWu9lodb+RDDWK
         BBTuTnw6joramjEwLl/njhxU83ctQyLqjN80SFFTjyIoCoLMLcY8wR/L7rJOijEWvRLa
         R3sMCrvfp7mjceLiUNf7vrSJav+7KnfFumfqaZsGnoV9PL9UkfIEDMBkS4nnOO4VW54k
         ewDp0dBPWg1etRzldVARQFFBq+nqNnIzCDrEWjMRPnzb9Pdx6thP2X3UbFjl0E/YPogi
         /9r4l+XKyjih1CK8zSpb1HaEXKe8e0UPyEYWKYl27KP/gxM9J+b70QmrIgNKkFlyP8kv
         u5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UL2ps8yaPj+oovF7HkNPRUPm6/ExhIXpUcFA+LZV1i4=;
        b=C5Vn1GHxcUtgGOF+KI/m3OHy5N6KEcj04k+mJplG1VPbKmT8KrPl2PNhpcj+Aet3F3
         TmEvZiiXr4G9dkBtr1lYlWufaEi5/dbgeeAn6qAUhI5YmjxsqD+Z1lYWe5vS6fuQVmXB
         4KL1AJd5/Ki8fPfekHre6z5AQVckB/qyXR/gHhl6gT7xvWfXUhpBRuYQRUU7bKZW6xkB
         b+hQ6wN3UrWcqVMSzCDABZFLXHujaffcIIJVR4AsER0sjTNRwtefxtGWqFUoaaIdWUjX
         xdGB3fdnEaCopF2buEuPYf1RciIgD8Uk79QRZKHNZZRfhScpX/ZkH7Ywy6WYtdnPGq/j
         wZdg==
X-Gm-Message-State: AO0yUKXCJTnavviWbniO8R9RUK7ismMPBGswIq5He1Xi0N4HNhhuRcvv
        1fxQCbMXEQRLIjXEqG7cNeg=
X-Google-Smtp-Source: AK7set+BLyzHJFtVSyKmZHTYpge+3sc6hQOxe+auHdzmUX0POIcjrnIIsYgxojEj7pDzaw4Rr1Gc8g==
X-Received: by 2002:a17:902:bd89:b0:19d:1509:5848 with SMTP id q9-20020a170902bd8900b0019d15095848mr2419219pls.29.1677499045263;
        Mon, 27 Feb 2023 03:57:25 -0800 (PST)
Received: from passwd123-ThinkStation-P920.. ([222.20.94.23])
        by smtp.gmail.com with ESMTPSA id w13-20020a170902d70d00b0019aeddce6casm4390573ply.205.2023.02.27.03.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 03:57:24 -0800 (PST)
From:   Kang Chen <void0red@gmail.com>
To:     shayne.chen@mediatek.com
Cc:     sean.wang@mediatek.com, kvalo@kernel.org, nbd@nbd.name,
        lorenzo@kernel.org, ryder.lee@mediatek.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Kang Chen <void0red@gmail.com>
Subject: [PATCH] wifi: mt76: add a check of vzalloc in mt7615_coredump_work
Date:   Mon, 27 Feb 2023 19:57:17 +0800
Message-Id: <20230227115717.3360755-1-void0red@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vzalloc may fails, dump might be null and will cause
illegal address access later.

Signed-off-by: Kang Chen <void0red@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index a95602473..73d84c301 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2367,6 +2367,9 @@ void mt7615_coredump_work(struct work_struct *work)
 	}
 
 	dump = vzalloc(MT76_CONNAC_COREDUMP_SZ);
+	if (!dump)
+		return;
+
 	data = dump;
 
 	while (true) {
-- 
2.34.1

