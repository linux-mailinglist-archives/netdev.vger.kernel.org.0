Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423B560FB4C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiJ0PJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiJ0PJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:09:03 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C6A18F0E9;
        Thu, 27 Oct 2022 08:09:00 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id AC2353200958;
        Thu, 27 Oct 2022 11:08:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 27 Oct 2022 11:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1666883338; x=
        1666969738; bh=cX+kFcwiwR6EWUUl0/qFnNFmlcF+5xuzGwswUuq+WOE=; b=G
        OZecO8vC3ba9NIX44Gx/xSR6pjA4T7Ci9SkB4EI25pEUxrxDGGkuIYA7giKNkQ7k
        2BcAcoGPwzuzxX+aU+G7u5kGrAJwawQOItzS28hoJfKFK+VvT7hsBajgU0OiTHvR
        V8VZ7EcyRMchAo/kTjT4I8N4Tg0Ttlxvaf5HvM2ClPQ+zqYmJrAVeV6beeunDn+t
        eypv5WzJmL6fOSOP14IWphfWhmgbooRGzM0VvOvgOhmeaP48IFv1ULEPFPuUaH30
        mRgwxxBtWCW/IXTgBQWYIJ7Iy9r8oU0x28JUSH5nV70TsbVFCnDnauM5o3RdpiW9
        n0IVcRQKe13d/vjzTBX2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1666883338; x=1666969738; bh=cX+kFcwiwR6EW
        UUl0/qFnNFmlcF+5xuzGwswUuq+WOE=; b=Fu8GtYcLzQVZRQ3juZ700N9zWe0FP
        kK8IKkF2ptbLfIij1nGcZw6CRp7trVjYb/Ayk7KbBPOPB6cgQKcZuX/Ib5p90EZK
        U1MZ6Usiohh5kCGIKyqaFc2M+lA17f4gXYvsgu6p7THYtBi/9M61A7G+pEd1LxKN
        tcJoa6CQFfUXcvuVkmDa2RpmxfeIt+kXQonhdRDYi8GWkr52DO0nlDwnxj1x6sEM
        103Et26Plm9XwHF9/ISAVeSIxDge7JHkLfRLxcten8FdD1qOGe5hIzjaX4wHdD0x
        Xgc91y1GKQrwuNX5SvuJyPlTzP0Xz99WZLYXYapSniikKstBTsz5CiG7w==
X-ME-Sender: <xms:CZ9aY9MjP0nthZFcU8Gnh27cVb5cd5VlY0MpAy-j0qpuOu_ksUhg9Q>
    <xme:CZ9aY__uizLewsAX3JsIIdjPs3VoWREpECrSzU80reonSbCOCp8Kd8l1iygCMe2uO
    88pzZItgbOgGKwtZrM>
X-ME-Received: <xmr:CZ9aY8Q0wqpDPIe6-gidUZoC_IQNLzCFoq5T0pmvh4djyffIQWonSNMkdm2l1j-rAJ4xRQ7zssriXn7YRwAR53RgZzcgcUG1-YTh1SfmCvPYZvgceiDWjuU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcu
    rfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvg
    hrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleekjeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvg
    hnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:CZ9aY5v7qxHOHDOniluwt0uwNzLJArSfg0-3_rEHD7whu7BI7Xi06Q>
    <xmx:CZ9aY1cnb6NAYKp-2TxlZEmVlpoz01Mn8UUN9BIZIBMivqwYOFLvyw>
    <xmx:CZ9aY12GxqowQHAbJTvgySqD6-eFrwMlyIWwPPTRVMtGJmWpSXltBg>
    <xmx:Cp9aYws-7sM4QUvu6A1uS_GUBR58Dq0C6fQMKrc2zSOe5s8b-q5vIA>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 11:08:55 -0400 (EDT)
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
Subject: [PATCH v4 5/7] Bluetooth: Add quirk to disable extended scanning
Date:   Thu, 27 Oct 2022 17:08:20 +0200
Message-Id: <20221027150822.26120-6-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20221027150822.26120-1-sven@svenpeter.dev>
References: <20221027150822.26120-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 include/net/bluetooth/hci.h      | 10 ++++++++++
 include/net/bluetooth/hci_core.h |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index f4aa7b78a844..8cd89948f961 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -263,6 +263,16 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN,
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
index c54bc71254af..3cd00be0fcd2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1689,7 +1689,9 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 
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

