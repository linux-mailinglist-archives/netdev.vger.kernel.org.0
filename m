Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C85FA297
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJJRRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJJRR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:17:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F12774DFF;
        Mon, 10 Oct 2022 10:17:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bk15so17953787wrb.13;
        Mon, 10 Oct 2022 10:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDO6o47fnrG82tJ2IBiHmRKST0iqq3l1tiR5yIHUD7w=;
        b=ZDFJAY4wTRFQjwaonOAJauhcc1OGkHEgIjj5GsNX4uue4WRjybUEitaAHDaSnfG9HD
         OwbkM0JtwGOiPaP3wqoZoU+7/PyAaX4h2xmmT+AYfcPm/2v/no0fKvsJdoucy4jRc4O9
         z7VxWWWAHa+e0lxzg7q29LwpLMQZJ0gmzYJ3+MRUTkyyxTSDOsLRKqV7VOIQvwqwAfsr
         hJ+aw6lAQQSg7QCwHCzn0TsT4V/9ZBt98gy8g5HW4OP4uHP42Bxu4BuYn0THhOv1GZZk
         9X+XKB4RuPTd4Y7+wxEed2I3XxTxuN2bypWDMSFrjaf4kZuNWL3Ho+oMvsXDhi3Id0zT
         HXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDO6o47fnrG82tJ2IBiHmRKST0iqq3l1tiR5yIHUD7w=;
        b=LYq86jBtAlPruIy8X5i4k45E8xqZ4JPRni3e2puhtbJCtIl4YIBezNCtWKiWke3eU2
         oiLYAvAJXXw4fJrEReyNcg1+i+n0jNDdNDzCfGA6jZMQJAgMOQY/LNurddNyCplOnIrA
         /ZRbFZd2GdjM+AhR24usqb46NT2cciWNtdALUf2a1lUtvoBtS7oXEguHPTpgJAbz8d/S
         9cG2k2LyI3d8vypS6R6hYaAISEHnYym8voe7UGFGwf0c4y6USRgOhBk9tjDfct8pnnEY
         JX/7orRHn3mCug3X6D7GGBXj3BVg5BbnS5yuM961n1Upe1YcWoT8iwPbV0vA66tz/orv
         ZOeQ==
X-Gm-Message-State: ACrzQf0CMo7MYICDzlxLGm/VqNEhdZj4HxK8u0tIylHFNcFKf8oErsO2
        UvK1YSpVEqKFgAu2pxl/jgIM7AxhEls=
X-Google-Smtp-Source: AMsMyM49/LTtFxNWjBx/Q7Vze5//gyp/hYbp3jEIGbpVD397UTzfGAfMwOA5mYZV8Td2qNo1i4Hi9Q==
X-Received: by 2002:adf:ea04:0:b0:22e:6545:9963 with SMTP id q4-20020adfea04000000b0022e65459963mr12230193wrm.417.1665422246848;
        Mon, 10 Oct 2022 10:17:26 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.googlemail.com with ESMTPSA id g11-20020a5d488b000000b00228d7078c4esm9328735wrq.4.2022.10.10.10.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 10:17:26 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: [net PATCH 2/2] net: dsa: qca8k: fix ethtool autocast mib for big-endian systems
Date:   Mon, 10 Oct 2022 13:14:59 +0200
Message-Id: <20221010111459.18958-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221010111459.18958-1-ansuelsmth@gmail.com>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch sends autocast mib in little-endian. This is problematic for
big-endian system as the values needs to be converted.

Fix this by converting each mib value to cpu byte order.

Fixes: 5c957c7ca78c ("net: dsa: qca8k: add support for mib autocast in Ethernet packet")
Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
Tested-by: Lech Perczak <lech.perczak@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 20 ++++++++------------
 include/linux/dsa/tag_qca.h      |  2 +-
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 4bb9b7eac68b..e3e89ce479c6 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1518,9 +1518,9 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	struct qca8k_priv *priv = ds->priv;
 	const struct qca8k_mib_desc *mib;
 	struct mib_ethhdr *mib_ethhdr;
-	int i, mib_len, offset = 0;
-	u64 *data;
+	__le32 *data2;
 	u8 port;
+	int i;
 
 	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
 	mib_eth_data = &priv->mib_eth_data;
@@ -1532,28 +1532,24 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	if (port != mib_eth_data->req_port)
 		goto exit;
 
-	data = mib_eth_data->data;
+	data2 = (__le32 *)skb->data;
 
 	for (i = 0; i < priv->info->mib_count; i++) {
 		mib = &ar8327_mib[i];
 
 		/* First 3 mib are present in the skb head */
 		if (i < 3) {
-			data[i] = mib_ethhdr->data[i];
+			mib_eth_data->data[i] = le32_to_cpu(mib_ethhdr->data[i]);
 			continue;
 		}
 
-		mib_len = sizeof(uint32_t);
-
 		/* Some mib are 64 bit wide */
 		if (mib->size == 2)
-			mib_len = sizeof(uint64_t);
-
-		/* Copy the mib value from packet to the */
-		memcpy(data + i, skb->data + offset, mib_len);
+			mib_eth_data->data[i] = le64_to_cpu(*(__le64 *)data2);
+		else
+			mib_eth_data->data[i] = le32_to_cpu(*data2);
 
-		/* Set the offset for the next mib */
-		offset += mib_len;
+		data2 += mib->size;
 	}
 
 exit:
diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 0e176da1e43f..b1b5720d89a5 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -73,7 +73,7 @@ enum mdio_cmd {
 };
 
 struct mib_ethhdr {
-	u32 data[3];		/* first 3 mib counter */
+	__le32 data[3];		/* first 3 mib counter */
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
-- 
2.37.2

