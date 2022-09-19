Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5827E5BD28D
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiISQub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiISQt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:49:56 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D381FCF5;
        Mon, 19 Sep 2022 09:49:47 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 96BE65C03E7;
        Mon, 19 Sep 2022 12:49:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 12:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1663606186; x=
        1663692586; bh=K5EvS7vP8L6M31QM3zmyMgApIJPVaOglFG1TvndhbBw=; b=m
        6kIL4i0AX7Y+QbPyrfAQbkpnc710+D3qXsWg9AoWYBNK5BlE9aJvSJHsDuvGraXU
        xaLcRHeaCeAOT0uh/j0kuAWFrQL9ZDYg3hzBLxmae1QJipFY7QmjN25moUdes5j4
        FupjAXmJ6LpRjh6fA+9kB2as22LmBBcjyRbErCda3SA35VFDZglhb631Scdw+2uj
        7860xrECNzIqN/OM2NDbE5UzZn1pEhQPQTep3/th7huBVbArBBZnHRXxEURGMeVh
        sjNLxxQZhaybkE2aHa/ythGAklLZgf8GvGpWwXYkCr7emSoK93eA6UQpUwaJqVI3
        WlW5XfF+k0h3cVUf/BizA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663606186; x=1663692586; bh=K5EvS7vP8L6M3
        1QM3zmyMgApIJPVaOglFG1TvndhbBw=; b=kR5Bzz9cWGSRkxYtO0zBmK2f/iFjm
        4e3OMtsG/jDd0RVAB/SEMypxzwlw38Q+7TfTEIVRaL7XpQy/zsPlPA9JfMDFoGsc
        8PR+bWni6TVUCNmiFt7MGQa+YZeiMPZGMxMDDSn9BgmU3ABp8+2iKzIMsMDfh3Ml
        1av58S34SGukv6w6Ny4XgcT200Uik3SqWfZy4tr04HSyQaX1keY7r0BVSNyCkd/O
        g6YITj87h3bpi/ofU7aOZZ/effdML61bKKBqgcwoVtDHF5WNV3LAX2M7IsqSOTRz
        u01pavh6PzsjFe7nZzyi9n5fXGxYhQTwfkH+IWcQ5XeDvSoqV+IT11ywA==
X-ME-Sender: <xms:qp0oY-OorunRT1vNL-2_TwRMcZBw-wJX0m6UoP41j1Yxb5s2a_JYFw>
    <xme:qp0oY8_2Uz5uemYoBAm3lyJi_LfzcWw90tRC2qSzvXXFqml-UxsAdh2TKIj_f4Y5H
    1lEXLdNcao-QBJvKwU>
X-ME-Received: <xmr:qp0oY1Rosvk0qyMBwpECSATrtUvukItAKO-FIiLCA9B2ha4hqyFixP05kqyyEOZuoWck2omzi2-O90wyaoBg1ltS62uxh50YK4hf5NqUGropYD4ROoK2mQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleek
    jeegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:qp0oY-tPBeUsc7t6W1MMCHZ-xHxRL9T_ZFsEMKHzmlXLoVPuxBnkcw>
    <xmx:qp0oY2ft9_tfWN7nqb3qUFBnLrRpPuTJWTTc_KIh0pjkk3VOUTkZMg>
    <xmx:qp0oYy07tbVxfQCGhtLxgT578JT-jsNnl5i1zkugBnZktY5LX3LPLA>
    <xmx:qp0oY5vXa5d8Dnho-Xd0cGt8vOaoESGEyHePtvk_6XkHZJOyb5mnUw>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 12:49:44 -0400 (EDT)
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
Subject: [PATCH v3 6/7] Bluetooth: Add quirk to disable MWS Transport Configuration
Date:   Mon, 19 Sep 2022 18:48:33 +0200
Message-Id: <20220919164834.62739-7-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220919164834.62739-1-sven@svenpeter.dev>
References: <20220919164834.62739-1-sven@svenpeter.dev>
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
new commit in v3 since this now fails loudly since 6.0-rc4

 include/net/bluetooth/hci.h | 10 ++++++++++
 net/bluetooth/hci_sync.c    |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 75dcd818cf04..33d83d5ab84b 100644
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
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index fbd5613eebfc..791b37344ed6 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3939,6 +3939,8 @@ static int hci_get_mws_transport_config_sync(struct hci_dev *hdev)
 {
 	if (!(hdev->commands[30] & 0x08))
 		return 0;
+	if (test_bit(HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG, &hdev->quirks))
+		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_GET_MWS_TRANSPORT_CONFIG,
 				     0, NULL, HCI_CMD_TIMEOUT);
-- 
2.25.1

