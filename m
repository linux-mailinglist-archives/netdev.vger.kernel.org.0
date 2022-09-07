Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BF55B0B27
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiIGRK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiIGRKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:10:18 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E0A9D125;
        Wed,  7 Sep 2022 10:10:06 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5D82E320094F;
        Wed,  7 Sep 2022 13:10:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 07 Sep 2022 13:10:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1662570603; x=
        1662657003; bh=ZOAgVmD4sQnWNvzpbfQISdxHPQGYqTpMmJPA7iGKzEE=; b=u
        D2IcdeQ4XphtQxXHOB+5QESLDS2to1Dd/9Ov/Dw5JwmyEwdZhaJDCRYAU5irXIHZ
        JsTdyKutKUM3wRenk4S2UuUbc2LOm01K43lOfwE6/mOB7s2xmPMH3joJxD7UCeNB
        1ubJPR5wWgRaCYowIG0E2wN+BJ+xhUIxK6C3MU2gQqT4nur1iTX7dCGcXnvYuPlQ
        4ox0lzLJOkZoN3TCz/1ug5mJKjz8NDGT/blvmdUZIfWnJSNd8iQuaf+jjLFneMPf
        XaNFBDKTL5OOIXYIerMerkOd3DQA4bmSG4W0IBIJXVZNdG+uoaBBNm7+I3DmqNCT
        CYcoDq7lx14661H39CKWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662570603; x=1662657003; bh=ZOAgVmD4sQnWN
        vzpbfQISdxHPQGYqTpMmJPA7iGKzEE=; b=N71k/Ot7mDlaojCjkXIm2WXRyjtgx
        uY+TWQqhUrX8or1q/e0N7k+qhnsaHxrT1rTOFj/FNkg5cHoA+JVZcziy/IKPcJo5
        aUBzCZF710/kyy0FmWJsBMCjasjySHs6tHPWWtGHRofew72DCkklkyj9FY5F0m0x
        pnlHAw9ifI0wqx07G1xGyMLu0CahW3/sjWTfchWx0hKSD0kcbYMZLkrskhbGqPuH
        leTggxcd8dEE1kWObtAFApBRYRiS2X3yHEbTKdcpq7q3sbLyz3MYLCcRTkdJxf7M
        6olGsoMIx0cSGZdFNMe7ph+bwsUgHtdBJLFIC7z6k3XTCjfuelJPUepfA==
X-ME-Sender: <xms:a9AYY_ot-m9DI2sWd3SyqtVF7djC-BhHCiR1je8WKBCqA6t7VWQGfA>
    <xme:a9AYY5pLQulXzbfD0YHrWi9CaPNvsGgz6KEiFkaQRq1j4PfpQMr4R7E418hHbAh-V
    dp_IW4pDWjtT-E_j14>
X-ME-Received: <xmr:a9AYY8PkfhZu6OKc0UCYtaU1vABLjCg2hpsj5Quva0CpiUiT2Dn3i_n7AJHNH5hIGcty35UbLTaaXQaNlS0UaTTocNx5jydu4Ihyv2JRsOhVGl4fgt0DNTM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleek
    jeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:a9AYYy4FNtiwU7WEREjys7xU3vfXKa4CoEQPZLPQ1f2SjAl5Didm6Q>
    <xmx:a9AYY-5MU37LG5t2F98e0EdSmRmAIcZoBRazllbO6Hr6xt4Ty0HdsA>
    <xmx:a9AYY6gx5HDaLGDoJBpc6XRugVVsxAWVfYuYmqBTeK6FwJF9d-V2jw>
    <xmx:a9AYY6pE3UdbkHLDfpCESkUTN1ZKJv92s3nZ8wqg26QqOtKh-ioGag>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 13:10:01 -0400 (EDT)
From:   Sven Peter <sven@svenpeter.dev>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] Bluetooth: Add quirk to disable extended scanning
Date:   Wed,  7 Sep 2022 19:09:34 +0200
Message-Id: <20220907170935.11757-5-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220907170935.11757-1-sven@svenpeter.dev>
References: <20220907170935.11757-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Broadcom 4377 controllers found in Apple x86 Macs with the T2 chip
claim to support extended scanning when querying supported states,

< HCI Command: LE Read Supported St.. (0x08|0x001c) plen 0
> HCI Event: Command Complete (0x0e) plen 12
      LE Read Supported States (0x08|0x001c) ncmd 1
        Status: Success (0x00)
        States: 0x000003ffffffffff
[...]
          LE Set Extended Scan Parameters (Octet 37 - Bit 5)
          LE Set Extended Scan Enable (Octet 37 - Bit 6)
[...]

, but then fail to actually implement the extended scanning:

< HCI Command: LE Set Extended Sca.. (0x08|0x0041) plen 8
        Own address type: Random (0x01)
        Filter policy: Accept all advertisement (0x00)
        PHYs: 0x01
        Entry 0: LE 1M
          Type: Active (0x01)
          Interval: 11.250 msec (0x0012)
          Window: 11.250 msec (0x0012)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Extended Scan Parameters (0x08|0x0041) ncmd 1
        Status: Unknown HCI Command (0x01)

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
changes from v1:
  - adjusted the commit message a bit to make checkpatch happy

 include/net/bluetooth/hci.h      | 10 ++++++++++
 include/net/bluetooth/hci_core.h |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 62539c1a6bf2..05a13b0c5ff1 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -274,6 +274,16 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_EVT_TYPE,
+
+	/*
+	 * When this quirk is set, the HCI_OP_LE_SET_EXT_SCAN_ENABLE command is
+	 * disabled. This is required for some Broadcom controllers which
+	 * erroneously claim to support extended scanning.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_EXT_SCAN,
 };
 
 /* HCI device flags */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index e7862903187d..29d1254f9856 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1681,7 +1681,9 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 
 /* Use ext scanning if set ext scan param and ext scan enable is supported */
 #define use_ext_scan(dev) (((dev)->commands[37] & 0x20) && \
-			   ((dev)->commands[37] & 0x40))
+			   ((dev)->commands[37] & 0x40) && \
+			   !test_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &(dev)->quirks))
+
 /* Use ext create connection if command is supported */
 #define use_ext_conn(dev) ((dev)->commands[37] & 0x80)
 
-- 
2.25.1

