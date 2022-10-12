Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7395FC9CD
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiJLRUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJLRUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:20:03 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C941C931;
        Wed, 12 Oct 2022 10:20:00 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id ay36so10818895wmb.0;
        Wed, 12 Oct 2022 10:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AoQ3A/F8PYdy19UXwNsBLTZYRj4iAMP2nMzD56UYvqY=;
        b=YvuMZ1PfeSExvFRSqG1doFtT8GKdOAg72QnlKU0leLO665Bg8Zgns5g4Vi5safMxky
         ty58ssZjNTVU4r7YcpypWSN7m+TGYHDxL2AvlshJyOIJ+MHC37nAI4gI4r6VI42+4v1W
         kbgprAFSvQMuCCfwQtykVM+Jb6ZM09EveB8JzXEnJjkvU66Nm3V9fxCTp7DDQddiLZ1U
         TLTjdaFyQ1yQsTy51+EbWhHSXQBAQNtLySYwBDk9RmN8JQZyOMtAl7/WeWvSaSuUnfen
         vvpsmuMWmrbsICR7BBlPCDXDtarCrLrM3QoKHbsxP3bTKoBaOyUXBLDgd27+RT1yfjee
         ATGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AoQ3A/F8PYdy19UXwNsBLTZYRj4iAMP2nMzD56UYvqY=;
        b=Haek/YHWNecz7bfK1dvQFKZzjaAXFvaY14caL4OgzhKy1kXl2qXyOVKiJhhKlCAXoH
         bNyGRJHk09yHG9PCdo9uuLV613OhBJ1L3KTIKtqgqCK1anstgxdKYSCdh2rhITEXNyet
         dyGnnfVLt4gz7X5jzu7WRN0+pZ4YeYKvPD9XcOn2cURkDk0ZBMrTUqZxn78U4Hyfd4PS
         DlPjLuce/s9ncreFmqTvnerEbEQgIIHvmTpk6YMoLgwMo3r3JEJSo5gsRMQUW1bmzj9n
         xkK/uqiKp+oygmv9Tu7Os8yWROhHkSK6w3zf9NWtqDsvQjbS1N7nbOESeg5OHRWYIyp8
         +HOQ==
X-Gm-Message-State: ACrzQf1xej1wDSJwVpWHkke5QClgbBa4ZcFLpbpT7jwV59zpkNZKdWkW
        1ib5e5K0T656/JPhOdiPqEA=
X-Google-Smtp-Source: AMsMyM7LVKA5at1jpDX/b7sFrirD9scsSZHuoFPtPmAr8ZBTow//7VE+OfAzkN9xpc28Yeslw0VG7w==
X-Received: by 2002:a1c:ed0b:0:b0:3c1:d16e:a827 with SMTP id l11-20020a1ced0b000000b003c1d16ea827mr3497803wmh.127.1665595198762;
        Wed, 12 Oct 2022 10:19:58 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.googlemail.com with ESMTPSA id n18-20020adfe352000000b0022cc895cc11sm169286wrj.104.2022.10.12.10.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 10:19:57 -0700 (PDT)
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
Subject: [net PATCH v2 2/2] net: dsa: qca8k: fix ethtool autocast mib for big-endian systems
Date:   Wed, 12 Oct 2022 19:18:37 +0200
Message-Id: <20221012171837.13401-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221012171837.13401-1-ansuelsmth@gmail.com>
References: <20221012171837.13401-1-ansuelsmth@gmail.com>
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

The switch sends autocast mib in little-endian. This is problematic for
big-endian system as the values needs to be converted.

Fix this by converting each mib value to cpu byte order.

Fixes: 5c957c7ca78c ("net: dsa: qca8k: add support for mib autocast in Ethernet packet")
Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
Tested-by: Lech Perczak <lech.perczak@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---

Changes v2:
- Use get/put_unaligned_le32/le64 to handle unaligned addr

 drivers/net/dsa/qca/qca8k-8xxx.c | 20 ++++++++------------
 include/linux/dsa/tag_qca.h      |  2 +-
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 644338ca0510..c5c3b4e92f28 100644
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
+			mib_eth_data->data[i] = get_unaligned_le32(mib_ethhdr->data + i);
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
+			mib_eth_data->data[i] = get_unaligned_le64((__le64 *)data2);
+		else
+			mib_eth_data->data[i] = get_unaligned_le32(data2);
 
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

