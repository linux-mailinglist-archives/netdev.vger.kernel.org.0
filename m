Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1E25FC9CF
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJLRUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJLRUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:20:03 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DA01C107;
        Wed, 12 Oct 2022 10:19:58 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bk15so27180194wrb.13;
        Wed, 12 Oct 2022 10:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=22SKpBezuh1LwbiUtryd3JkRu4KCRJrHRt1nu8s+3zk=;
        b=B5edO61Ul4dRlYYvwlGk8OvhRLHALe12Bx1mfPMj5ItoBJWDJi+QMdqilqV4+S40jF
         ODtKiVIDPa6MqFQLDAcFnAPpujHAkOfAYZY3bJqNuui/C47mHxNDrIXrJw3g5nh6mN9S
         yHbJBbHwW7DMJlOQ/xuvDx1DHgWdM5wTB00Hrx13aHzPtSffBDUARKf4J57VsE+KZDr0
         K0emQXkorhP9DAW0wGl3LpUzrAWJSZMqkQWHhq0X0hRGD4k+voagaPqgmsSLzB5YonwM
         /1qN3+7NCw7YIME01JRe6mIOaUlkiCr6W1UWGaELTkoKrBF8XVM/oUYhwKh4Aby/ZxLK
         okhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=22SKpBezuh1LwbiUtryd3JkRu4KCRJrHRt1nu8s+3zk=;
        b=tcQ8vw6a6uYBngKmunMxz+1sIXk1p6mmHyH1LEngJbhgSKsmaII9pBzNlQbwOsLSJd
         sd+N5uxfQSCcxOkPAADsCnnFGTozaNIO6dFowMaiEj1Bofmsms5wTOqvDI4XuXMztjtD
         X46r+o0UObmsK3+zXZCm7Ah0ixlcYHdNqNR0SiXT6JhuJVbLp3ONNvOy4JU2wC94CYgo
         wGey2eiaahY7Lol6tIhd3VHl6gAPcD2dQa/HOwmrD61PCEi8sPKILO1kta7kDaCQ4G4D
         ePh/jbz1j5l1sJ28swRbg3H/MqjuKMfJVMLxaXF2glRYA+/leXSX06zvepNq/rMgcUcD
         fFfw==
X-Gm-Message-State: ACrzQf0xESILTF0AjcL1pIoJhIvvXt/U4ZDIQKEBFyZgkSq1RglEt1dm
        6zQ33t8oq9b+B+fxFnBM5iY=
X-Google-Smtp-Source: AMsMyM5APD/aRROiG8ZiVup3zB9r1XoxyHbemEgCA8WGZL/L3XxDPWNDF8jI/vFfZoRYlRfwFZ8GQA==
X-Received: by 2002:a5d:5a82:0:b0:224:f744:1799 with SMTP id bp2-20020a5d5a82000000b00224f7441799mr18645097wrb.582.1665595197097;
        Wed, 12 Oct 2022 10:19:57 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.googlemail.com with ESMTPSA id n18-20020adfe352000000b0022cc895cc11sm169286wrj.104.2022.10.12.10.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 10:19:56 -0700 (PDT)
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
Subject: [net PATCH v2 1/2] net: dsa: qca8k: fix inband mgmt for big-endian systems
Date:   Wed, 12 Oct 2022 19:18:36 +0200
Message-Id: <20221012171837.13401-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
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

The header and the data of the skb for the inband mgmt requires
to be in little-endian. This is problematic for big-endian system
as the mgmt header is written in the cpu byte order.

Fix this by converting each value for the mgmt header and data to
little-endian, and convert to cpu byte order the mgmt header and
data sent by the switch.

Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
Tested-by: Lech Perczak <lech.perczak@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Lech Perczak <lech.perczak@gmail.com>
---

Changes v2:
- Use get/put_unaligned_le32 to handle unaligned addr

 drivers/net/dsa/qca/qca8k-8xxx.c | 63 ++++++++++++++++++++++++--------
 include/linux/dsa/tag_qca.h      |  6 +--
 2 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 5669c92c93f7..644338ca0510 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -137,27 +137,42 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
 	struct qca8k_priv *priv = ds->priv;
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	u32 command;
 	u8 len, cmd;
+	int i;
 
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
 	mgmt_eth_data = &priv->mgmt_eth_data;
 
-	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
-	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
+	command = get_unaligned_le32(&mgmt_ethhdr->command);
+	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, command);
+	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, command);
 
 	/* Make sure the seq match the requested packet */
-	if (mgmt_ethhdr->seq == mgmt_eth_data->seq)
+	if (get_unaligned_le32(&mgmt_ethhdr->seq) == mgmt_eth_data->seq)
 		mgmt_eth_data->ack = true;
 
 	if (cmd == MDIO_READ) {
-		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
+		u32 *val = mgmt_eth_data->data;
+
+		*val = get_unaligned_le32(&mgmt_ethhdr->mdio_data);
 
 		/* Get the rest of the 12 byte of data.
 		 * The read/write function will extract the requested data.
 		 */
-		if (len > QCA_HDR_MGMT_DATA1_LEN)
-			memcpy(mgmt_eth_data->data + 1, skb->data,
-			       QCA_HDR_MGMT_DATA2_LEN);
+		if (len > QCA_HDR_MGMT_DATA1_LEN) {
+			__le32 *data2 = (__le32 *)skb->data;
+			int data_len = min_t(int, QCA_HDR_MGMT_DATA2_LEN,
+					     len - QCA_HDR_MGMT_DATA1_LEN);
+
+			val++;
+
+			for (i = sizeof(u32); i <= data_len; i += sizeof(u32)) {
+				*val = get_unaligned_le32(data2);
+				val++;
+				data2++;
+			}
+		}
 	}
 
 	complete(&mgmt_eth_data->rw_done);
@@ -169,8 +184,10 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
 	unsigned int real_len;
 	struct sk_buff *skb;
-	u32 *data2;
+	__le32 *data2;
+	u32 command;
 	u16 hdr;
+	int i;
 
 	skb = dev_alloc_skb(QCA_HDR_MGMT_PKT_LEN);
 	if (!skb)
@@ -199,20 +216,32 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
 	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
 
-	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
+	command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
+	command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
+	command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
+	command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
 					   QCA_HDR_MGMT_CHECK_CODE_VAL);
 
+	put_unaligned_le32(command, &mgmt_ethhdr->command);
+
 	if (cmd == MDIO_WRITE)
-		mgmt_ethhdr->mdio_data = *val;
+		put_unaligned_le32(*val, &mgmt_ethhdr->mdio_data);
 
 	mgmt_ethhdr->hdr = htons(hdr);
 
 	data2 = skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
-	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN)
-		memcpy(data2, val + 1, len - QCA_HDR_MGMT_DATA1_LEN);
+	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN) {
+		int data_len = min_t(int, QCA_HDR_MGMT_DATA2_LEN,
+				     len - QCA_HDR_MGMT_DATA1_LEN);
+
+		val++;
+
+		for (i = sizeof(u32); i <= data_len; i += sizeof(u32)) {
+			put_unaligned_le32(*val, data2);
+			data2++;
+			val++;
+		}
+	}
 
 	return skb;
 }
@@ -220,9 +249,11 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 static void qca8k_mdio_header_fill_seq_num(struct sk_buff *skb, u32 seq_num)
 {
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	u32 seq;
 
+	seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb->data;
-	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
+	put_unaligned_le32(seq, &mgmt_ethhdr->seq);
 }
 
 static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 50be7cbd93a5..0e176da1e43f 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -61,9 +61,9 @@ struct sk_buff;
 
 /* Special struct emulating a Ethernet header */
 struct qca_mgmt_ethhdr {
-	u32 command;		/* command bit 31:0 */
-	u32 seq;		/* seq 63:32 */
-	u32 mdio_data;		/* first 4byte mdio */
+	__le32 command;		/* command bit 31:0 */
+	__le32 seq;		/* seq 63:32 */
+	__le32 mdio_data;		/* first 4byte mdio */
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
-- 
2.37.2

