Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4DD658F2B
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiL2QoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiL2Qnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:43:51 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE94A199;
        Thu, 29 Dec 2022 08:43:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h16so17827985wrz.12;
        Thu, 29 Dec 2022 08:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DRy4n53RTFJK/svNsb/BzVssR7kQTw8N2fRZXaNdwU=;
        b=IEY5UAWZ6uD/FP0uMQOSDS6RJRrh3DDUCLkLk1GIT5itCgllG5VG+qxEzuKQY4uG0Y
         JSjjv/f1IEOz9ZxrJptTxgtKW4Ht0yJJWrbfeAtdEr0kZp0HcNmxUviJDCuzY9bsmxfU
         5O0hY0AeGfSWjIKjRa7f5BexR4Gr7mApx5zh67skyXvsZpPbbqVlmBVypdsumdeYfhgp
         X2zrP3G0iiksaKDQEnWJ/NssqoVJAogPXTYiHIbnMwFakDCOEip5xKc745fF9yr86iK1
         wwLT24BIRVfYOaY24IvabRDVdhxCLUhSAaCLFOt3l7WCM566Zeovo3BlicCLaAn9F1wb
         Al/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7DRy4n53RTFJK/svNsb/BzVssR7kQTw8N2fRZXaNdwU=;
        b=aKl0D3iXTuwO660ixylvDb33gHrahT82Iy54jJgawqWA6JfdI60F1gyxjh6Xe/x8uz
         zrSm0Sa1DiszhyNLYQFcnzTc+8gSumcz5QGsyOeTSIdRVrpcsPquz0SNaQJhNAmbT788
         duYeuxYvH0B3deSb9ghKHTKs0VqAOvbdaFE1DsUm7cmZaksty/wHrKAQgmudH1FK/GA7
         6TJe4PR0DFdz1tTOkdTHmVOjIq8+ziuY632fDJ+KBoYYtO5K2wbAemmUE27bAoDlFN99
         RTPXD9nSYs235zNFixhhFBzBpBMpDoZgCK45+c6wxYH9g718hAr11pkb2dm1fmCS7/JV
         USeA==
X-Gm-Message-State: AFqh2kpRahxdEOr0u/c4JbCSprikPVELDMwWbfcWG5GtuRX4aTEtExrU
        56r2asEzvQQUHXAF0tadXGQ=
X-Google-Smtp-Source: AMrXdXuR5DfigdAyrXnl57aOMSBOwFw1spsU6cE9//4Ui2POlBodyJpPhYKQKidyKznT7GAkDWW9bw==
X-Received: by 2002:a05:6000:1378:b0:268:72d5:c8aa with SMTP id q24-20020a056000137800b0026872d5c8aamr18633922wrz.23.1672332228651;
        Thu, 29 Dec 2022 08:43:48 -0800 (PST)
Received: from localhost.localdomain (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.googlemail.com with ESMTPSA id t18-20020a5d42d2000000b00288a3fd9248sm4326586wrr.91.2022.12.29.08.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 08:43:48 -0800 (PST)
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
Subject: [net PATCH v2 1/5] net: dsa: qca8k: fix wrong length value for mgmt eth packet
Date:   Thu, 29 Dec 2022 17:33:32 +0100
Message-Id: <20221229163336.2487-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221229163336.2487-1-ansuelsmth@gmail.com>
References: <20221229163336.2487-1-ansuelsmth@gmail.com>
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

