Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB36A451F
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjB0Osq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjB0Osn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:48:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9FA12040;
        Mon, 27 Feb 2023 06:48:31 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gi3-20020a17090b110300b0023762f642dcso6360052pjb.4;
        Mon, 27 Feb 2023 06:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlgqotCFpMlYYZrIocsEAB0uv8GgACUTLIGeGd3Q3nk=;
        b=W2W0YyP4y0NIJfPvaCtZBWeQk8GAwmXaRT+2ZfOOLiZMs+olZ8CqkFui/R7U2PquAP
         3xQHqbtYwMpNrKNdZLhwgnyjIWgIx3BILe5ZIOrK6c6ZPB5gE8bQj8BiUF49XmkRgDCp
         BgKnCXYSTZuEtiLEeOfUNu5C8/ahsUiBnOATSRuY858sOpQ7su9mVlxGIYoXiOEJBEl5
         ANOCeovDzD66ND/3ozkLzS0PlESqKxagpkvFlug2/Kk+RIzp88bCgQjLGeN4aXfrBnNg
         Mree5WsvfetKz0CoXg3DtjUTtGc4xrwm0mu1wGOMXMA1XgbOYMAeVagEXV3E5aZMPKAB
         oFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SlgqotCFpMlYYZrIocsEAB0uv8GgACUTLIGeGd3Q3nk=;
        b=J2ETYEiT9AyaPN/ONNj88E5wnkIHuuxNsNw9MCaMEsrSX7UDC5a++A7g3REaQTPbyD
         xCLlMAs4MsmOGfIPKyIe1Hkx5ejQC1xpTGaQQWbxGMkf1Xi5Lon1xXXPsRgrouLWw0Lf
         JKkSZPmHmsfmxJG8v4wwu6vHwolyHBf3Y5N3mYjEPeaCIOh46uRzGTpGQyNghJoI5jru
         gLc9P+SulInNO2okm+tiIocMkcgfEjwj0dbk+HnERMWuLRfuTy0kIfFm6eixAOlvZ+gh
         BcNHY4yILu+ReU5x3dcbqgby+FMQAHzI4fHlGAqou1JUCwQeb8PSk7Q1jdx7feWaysPg
         AlEg==
X-Gm-Message-State: AO0yUKXYeFkDgK+qvRMGaOu6yNOjVWbN0xTVuFgyj8B6M/qI3/x4OjMu
        d8MoCPgFiPXLbWKNUS7tIk8=
X-Google-Smtp-Source: AK7set9LjQIxiR8aWUSis2bKS9zBzibf4kvNlf9fsVaes9MFIMHBjmh+r3AxWIbfww8saVxOIsNLvw==
X-Received: by 2002:a17:90b:1c10:b0:230:fac8:d7e7 with SMTP id oc16-20020a17090b1c1000b00230fac8d7e7mr25520356pjb.2.1677509310988;
        Mon, 27 Feb 2023 06:48:30 -0800 (PST)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id v23-20020a17090ae99700b00234ba1cfacbsm4561131pjy.17.2023.02.27.06.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 06:48:30 -0800 (PST)
From:   void0red <void0red@gmail.com>
To:     lorenzo.bianconi@redhat.com
Cc:     angelogioacchino.delregno@collabora.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kvalo@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        lorenzo@kernel.org, matthias.bgg@gmail.com, nbd@nbd.name,
        netdev@vger.kernel.org, pabeni@redhat.com, ryder.lee@mediatek.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        void0red@gmail.com
Subject: [PATCH v3] wifi: mt76: handle failure of vzalloc in mt7615_coredump_work
Date:   Mon, 27 Feb 2023 22:48:23 +0800
Message-Id: <20230227144823.947648-1-void0red@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <Y/y5Asxw3T3m4jCw@lore-desk>
References: <Y/y5Asxw3T3m4jCw@lore-desk>
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

From: Kang Chen <void0red@gmail.com>

vzalloc may fails, dump might be null and will cause
illegal address access later.

Link: https://lore.kernel.org/all/Y%2Fy5Asxw3T3m4jCw@lore-desk
Fixes: d2bf7959d9c0 ("mt76: mt7663: introduce coredump support")
Signed-off-by: Kang Chen <void0red@gmail.com>
---
v3 -> v2: fix bugs
v2 -> v1: add Fixes tag

 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index a95602473..796768011 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2380,7 +2380,7 @@ void mt7615_coredump_work(struct work_struct *work)
 			break;
 
 		skb_pull(skb, sizeof(struct mt7615_mcu_rxd));
-		if (data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ) {
+		if (!dump || data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ) {
 			dev_kfree_skb(skb);
 			continue;
 		}
@@ -2390,6 +2390,8 @@ void mt7615_coredump_work(struct work_struct *work)
 
 		dev_kfree_skb(skb);
 	}
-	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
-		      GFP_KERNEL);
+
+	if (dump)
+		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
+			      GFP_KERNEL);
 }
-- 
2.34.1

