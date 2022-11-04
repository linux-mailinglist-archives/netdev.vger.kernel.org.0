Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DF361A30E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKDVO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKDVNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:13:53 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507FF50F1B;
        Fri,  4 Nov 2022 14:13:44 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 9CE3432007F1;
        Fri,  4 Nov 2022 17:13:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 04 Nov 2022 17:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1667596421; x=
        1667682821; bh=cX+kFcwiwR6EWUUl0/qFnNFmlcF+5xuzGwswUuq+WOE=; b=m
        BBuIqv6iDq4Od3tDThyTvp4v5awBgIzXmJhu1qk4cOGCPCjIFM+P8y5wZMrpclEn
        tvD51sWXG+vXcsKwFqzMeXQPZmnL4LReePGk8kmPb3Tyo0oEzSDc4XFowF16P6gW
        nCeze0/1ItOe3qvWfbW14NZJQZX5/dhx45/Ky43tqrOur9NV+H9RIOPKKoG7IkM3
        mo6HqsPdqLIuNs1MhQQhz7AnSZtrs76ecu/ms7HqGzrgfqpgKZaQ4sElkxp+Y2uH
        zBkeXYbvOAipCGTpfQlNUDpLMiW5GW7xKj8WyANyoUgu7qqAOSkrjDh11c7NyrNb
        NIRYgTKHGL5eoRsdyAH1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667596421; x=1667682821; bh=cX+kFcwiwR6EW
        UUl0/qFnNFmlcF+5xuzGwswUuq+WOE=; b=FL2LLJP8d3s6G0ldKXAliTQkkZHMV
        cuGqM7EwRQu9hs0Vvgm0Q8P5DCVC/nA+dwQuNNd1N4tCjn3SNEu7tJWXHfg8xnuv
        LCrs4fqcLI2BVyUE4HihUmdqUVvsFUIF54hw6vSJ0j7NBuhypJmkr7dsArAzfo9k
        NCNoUlzV4OOX2yjTnRL7Ux8XDaj31Z/Ci5TMZQ6dUeYbofl1a3V017ApE+lTchD3
        rUA6SExKOlXnX8v00E+LKE4d1B9g8XN0b1IhD4zYl0B3eyVeQ/Yyr6ZXVzG76ABd
        tSRt24Zy0Pe/hdGZTRaGHYHFDnSGGNCpIdyJ7xqWWwSJ4Mqttv2yCWeuw==
X-ME-Sender: <xms:hYBlY87IOYxNqRGDVdmyovPb91BrP5dCrrc3cWErvlT92sHDy4R3_g>
    <xme:hYBlY96v4agTRqLtcdQZX-1BoIhd9iIhShtw1aSWzXCeJZycImcSybu8q8A2-QB3J
    oV01Gs1hWapZoPlwvE>
X-ME-Received: <xmr:hYBlY7etIUhiMyaKOmL9M9kt_Cag_2CBZlUXOanyUM8OVq4Foz99odgZTYdI6Vs4VE545Ra_nSYozacCsO4ZtmbIKwixSR8v0vHRy52wRVTchQ5XuMlv2wwC_9ICgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpeejieehheekgedvjefhveekjefguddtfefhteehtdeiffelkeeiuedufeelkeej
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvh
    gvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:hYBlYxLNABQUAAwz2Iswrn5Mg32tx3FXCDdfSFxRgmYPz3nPZtHkMw>
    <xmx:hYBlYwJBcSHQ_xlGMsyoUqk6R21ZGMdOaM367i70W9eTdOs9ARO3Jw>
    <xmx:hYBlYywWXyilyO4t4moXqbi4yKuOQiIhQG_MzWqpGKugkbYT2YA2Xw>
    <xmx:hYBlYx59QFOdKXpjN2mpVxamYgdZrMgC1eczlecb6wo4rkC88cBd-g>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Nov 2022 17:13:38 -0400 (EDT)
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
Subject: [PATCH v5 5/7] Bluetooth: Add quirk to disable extended scanning
Date:   Fri,  4 Nov 2022 22:13:01 +0100
Message-Id: <20221104211303.70222-6-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20221104211303.70222-1-sven@svenpeter.dev>
References: <20221104211303.70222-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

