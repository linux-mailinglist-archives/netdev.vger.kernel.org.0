Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828E361A311
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiKDVOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKDVOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:14:03 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7713050F34;
        Fri,  4 Nov 2022 14:13:49 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AFA743200922;
        Fri,  4 Nov 2022 17:13:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 04 Nov 2022 17:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1667596427; x=
        1667682827; bh=tz6qvQQLm1zdUrv6Quh+x5j7yM/AMqQeKT8unbdl7VM=; b=p
        8khVMUaJkjz2KcE8r930f6TyEKGG2YnEAzU77tO5FOkzWvRAC25P5J1P2HtRXcVg
        vaHnw9S6rTsbh78lqixu0eMMRAHgQQ+3IcE3d+qpo+97omlnz0KzndtR/BPE6TJh
        VlUT2ARRk2X0RBt3IqXEC3KUV3wn8C9LQeB3pnbXCwrb9/tbpckCixmK4NH/pwqn
        BV9tuEKW4Nk3Rfh1tbkHXmDmIHKeEemnmK1du8SHzy0Xob3y/pHelCsoN317Poq6
        7WDfSjqDf6R3e22ReApTB2zMce5TCgDkJow5BvYDMtWPvpmlrG/yts5Nogvo2i5h
        DBtdWuJ3AL6GyAUOYXkrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667596427; x=1667682827; bh=tz6qvQQLm1zdU
        rv6Quh+x5j7yM/AMqQeKT8unbdl7VM=; b=OEc/LkwYSiOLij+zQfRAVm+260cA2
        TDDllmGScCm9WVpKQaRNThnCfxgC7NbHVZaNVxsdpkpQ30pzrLcsK7BexBgHTXUl
        lJ0fF9go23efGnOGnKe7BWH2ewhM2TIE+R0LmmTLJc9KnDn4yHyH+eOf/rusEsaR
        XoRNSw8MZcRb7KzUF/zxL3E1hxbulufLwh/1eL8oe92MW35f/eLUQo/CJrMZdciz
        9fvpeLd+4q407pi2IqXDkz/frsBZKnuJA6fLAH+6c2nfBqXF3NZsdB67QpL5Npqf
        k91NLPYlHjoksHLstKLRsw/CkFJY6YmHZ+Yggs3fo35w7n8tK/mNxoptQ==
X-ME-Sender: <xms:i4BlY6A-hVljWwd3pdV2OW6MYB74Plkpp6G6qD-DFpQbjAB7ci4Y8A>
    <xme:i4BlY0iGdZd96E5UpIJmuYBuLODsxTV4NrKbtpRBTDjfgCZpVcdBOfDhirm-l0tSq
    J-pKWM8xG5LK-BOigA>
X-ME-Received: <xmr:i4BlY9k0b0WURp96_1qpa9O47zAhBn4ZckKHMeAJr8bF6UWpymJnH8SsqIIShl5UTVDqRLC-6GRhPOXIC5shxXd9nVpOHundKkQFRm5GL7fAPu_4P3YEHWvDOtddBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpeejieehheekgedvjefhveekjefguddtfefhteehtdeiffelkeeiuedufeelkeej
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvh
    gvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:i4BlY4ziw6Rw9YolZRDTVkfL3D7BRxlPbJCmJHoPX30RY94wUdjWPQ>
    <xmx:i4BlY_QBRaIRR4i0TCIs7nV_ZPq3sIIFf8RyeXnDAeuBsTtkM6IWiA>
    <xmx:i4BlYzap-fwi4lB9OhNLikA8KdXlej-6SYiwe0uJ8iH-pA2SWLnhhA>
    <xmx:i4BlYwAjNGp2U1UsJ74QtxPw8GgDdy83k_wbkiBHMVN11WvvW3RyOg>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Nov 2022 17:13:44 -0400 (EDT)
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
Subject: [PATCH v5 6/7] Bluetooth: Add quirk to disable MWS Transport Configuration
Date:   Fri,  4 Nov 2022 22:13:02 +0100
Message-Id: <20221104211303.70222-7-sven@svenpeter.dev>
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

Broadcom 4378/4387 controllers found in Apple Silicon Macs claim to
support getting MWS Transport Layer Configuration,

< HCI Command: Read Local Supported... (0x04|0x0002) plen 0
> HCI Event: Command Complete (0x0e) plen 68
      Read Local Supported Commands (0x04|0x0002) ncmd 1
        Status: Success (0x00)
[...]
          Get MWS Transport Layer Configuration (Octet 30 - Bit 3)]
[...]

, but then don't actually allow the required command:

> HCI Event: Command Complete (0x0e) plen 15
      Get MWS Transport Layer Configuration (0x05|0x000c) ncmd 1
        Status: Command Disallowed (0x0c)
        Number of transports: 0
        Baud rate list: 0 entries
        00 00 00 00 00 00 00 00 00 00

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
 include/net/bluetooth/hci.h      | 10 ++++++++++
 include/net/bluetooth/hci_core.h |  3 +++
 net/bluetooth/hci_sync.c         |  2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 8cd89948f961..110d6df1299b 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -273,6 +273,16 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_EXT_SCAN,
+
+	/*
+	 * When this quirk is set, the HCI_OP_GET_MWS_TRANSPORT_CONFIG command is
+	 * disabled. This is required for some Broadcom controllers which
+	 * erroneously claim to support MWS Transport Layer Configuration.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG,
 };
 
 /* HCI device flags */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 3cd00be0fcd2..7f585e5dd71b 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1719,6 +1719,9 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 	((dev)->le_features[3] & HCI_LE_CIS_PERIPHERAL)
 #define bis_capable(dev) ((dev)->le_features[3] & HCI_LE_ISO_BROADCASTER)
 
+#define mws_transport_config_capable(dev) (((dev)->commands[30] & 0x08) && \
+	(!test_bit(HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG, &(dev)->quirks)))
+
 /* ----- HCI protocols ----- */
 #define HCI_PROTO_DEFER             0x01
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 76c3107c9f91..d8e9eae17083 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4258,7 +4258,7 @@ static int hci_read_local_pairing_opts_sync(struct hci_dev *hdev)
 /* Get MWS transport configuration if the HCI command is supported */
 static int hci_get_mws_transport_config_sync(struct hci_dev *hdev)
 {
-	if (!(hdev->commands[30] & 0x08))
+	if (!mws_transport_config_capable(hdev))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_GET_MWS_TRANSPORT_CONFIG,
-- 
2.25.1

