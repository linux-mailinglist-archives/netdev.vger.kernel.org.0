Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8F964EECF
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiLPQR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiLPQRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:17:54 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1871D9FDA;
        Fri, 16 Dec 2022 08:17:52 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id h16so2964768wrz.12;
        Fri, 16 Dec 2022 08:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7DRy4n53RTFJK/svNsb/BzVssR7kQTw8N2fRZXaNdwU=;
        b=ahQvMD2F4cGPmNokXTy1HZH9ZIAl0qrlxBPyXtzOmL6z2joMX+1JD60TzxIGp9MKVu
         16CVvo9VM4cjnr9NEAUv9nCzph/3VV++6d7DeNXOINgDHbLQrCI2V5KSqgAB36IXaQGF
         D3p7MJU9DnpBn3YR6a3P3mLFCmEk9BtRSKRedfEAC5q8TiSDvlhoN9G0EpyIu/vEtBK6
         HuJoNB3xmIhUdhYhSW1vwQ54AkNOKvp/4uE5SuE02pLTJuCfIZ2C+gU4QRU0pXk36kDz
         vhZC4gJXiHinGx0lnp5Zz1j5ntTxh9g9dfz5uw6ckSMEbsj4OKelnhbjJSBjgRaa4ktX
         2Wsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7DRy4n53RTFJK/svNsb/BzVssR7kQTw8N2fRZXaNdwU=;
        b=fEH43lW909n4mLYYMxCY47wAzk0QonhCjDzV5Kz1BIha7+Bnw9AM9K8sool0EIfm5d
         TzKN0HtwOLZt0gncwyNg8pdQK1mJsERnqZM4RvDTI7gRxn6l2kz79LnRRJfe6UF0fheu
         HNJLHWXHtaihNPU773b2u0HdQBS6TKvgf6qyGtJnZAKxWSyVQM6/xV9B7KacpsN96JWZ
         UaWkKc8DeuRMxOjB1GYBEW/6y0x+0lsVmnuGJq9tDhiC0tva0Fm+tL9j87C+IaJUiml9
         Qrzw8wV3bBPQ2nwyk4yTQOujSxqIUOgF9YJmCOJyxqrKvewR/tylCtG8v6txgRblKkNz
         2wsQ==
X-Gm-Message-State: ANoB5plIGGayZqlDNymCV9rKjYabUmnlPG1gYJKoP2sP0aJi7DyyRFVJ
        AvyNUBiw6mHhjI6T8C8/jBs=
X-Google-Smtp-Source: AA0mqf45sf89H05tJHxltQD5urIHhph1sdyw8KoKhkzUNZ5EOGWh7lOm6uQnLEf8bDeRio3XCt+Odw==
X-Received: by 2002:a5d:4586:0:b0:242:1522:24a7 with SMTP id p6-20020a5d4586000000b00242152224a7mr20196996wrq.32.1671207470494;
        Fri, 16 Dec 2022 08:17:50 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id bj19-20020a0560001e1300b002238ea5750csm3079720wrb.72.2022.12.16.08.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:17:49 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ronald Wahl <ronald.wahl@raritan.com>, stable@vger.kernel.org
Subject: [net PATCH 1/5] net: dsa: qca8k: fix wrong length value for mgmt eth packet
Date:   Fri, 16 Dec 2022 17:17:17 +0100
Message-Id: <20221216161721.23863-1-ansuelsmth@gmail.com>
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

The assumption that Documentation was right about how this value work was
wrong. It was discovered that the length value of the mgmt header is in
step of word size.

As an example to process 4 byte of data the correct length to set is 2.
To process 8 byte 4, 12 byte 6, 16 byte 8...

Odd values will always return the next size on the ack packet.
(length of 3 (6 byte) will always return 8 bytes of data)

This means that a value of 15 (0xf) actually means reading/writing 32 bytes
of data instead of 16 bytes. This behaviour is totally absent and not
documented in the switch Documentation.

In fact from Documentation the max value that mgmt eth can process is
16 byte of data while in reality it can process 32 bytes at once.

To handle this we always round up the length after deviding it for word
size. We check if the result is odd and we round another time to align
to what the switch will provide in the ack packet.
The workaround for the length limit of 15 is still needed as the length
reg max value is 0xf(15)

Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Fixes: 90386223f44e ("net: dsa: qca8k: add support for larger read/write size with mgmt Ethernet")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.18+
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 45 +++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index c5c3b4e92f28..46151320b2a8 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -146,7 +146,16 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 
 	command = get_unaligned_le32(&mgmt_ethhdr->command);
 	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, command);
+
 	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, command);
+	/* Special case for len of 15 as this is the max value for len and needs to
+	 * be increased before converting it from word to dword.
+	 */
+	if (len == 15)
+		len++;
+
+	/* We can ignore odd value, we always round up them in the alloc function. */
+	len *= sizeof(u16);
 
 	/* Make sure the seq match the requested packet */
 	if (get_unaligned_le32(&mgmt_ethhdr->seq) == mgmt_eth_data->seq)
@@ -193,17 +202,33 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	if (!skb)
 		return NULL;
 
-	/* Max value for len reg is 15 (0xf) but the switch actually return 16 byte
-	 * Actually for some reason the steps are:
-	 * 0: nothing
-	 * 1-4: first 4 byte
-	 * 5-6: first 12 byte
-	 * 7-15: all 16 byte
+	/* Hdr mgmt length value is in step of word size.
+	 * As an example to process 4 byte of data the correct length to set is 2.
+	 * To process 8 byte 4, 12 byte 6, 16 byte 8...
+	 *
+	 * Odd values will always return the next size on the ack packet.
+	 * (length of 3 (6 byte) will always return 8 bytes of data)
+	 *
+	 * This means that a value of 15 (0xf) actually means reading/writing 32 bytes
+	 * of data.
+	 *
+	 * To correctly calculate the length we devide the requested len by word and
+	 * round up.
+	 * On the ack function we can skip the odd check as we already handle the
+	 * case here.
+	 */
+	real_len = DIV_ROUND_UP(len, sizeof(u16));
+
+	/* We check if the result len is odd and we round up another time to
+	 * the next size. (length of 3 will be increased to 4 as switch will always
+	 * return 8 bytes)
 	 */
-	if (len == 16)
-		real_len = 15;
-	else
-		real_len = len;
+	if (real_len % sizeof(u16) != 0)
+		real_len++;
+
+	/* Max reg value is 0xf(15) but switch will always return the next size (32 byte) */
+	if (real_len == 16)
+		real_len--;
 
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, skb->len);
-- 
2.37.2

