Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB9760FB3F
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiJ0PJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbiJ0PJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:09:07 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F53418F0F0;
        Thu, 27 Oct 2022 08:09:07 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 55EE03200956;
        Thu, 27 Oct 2022 11:09:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 27 Oct 2022 11:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1666883344; x=
        1666969744; bh=HeLlRgoVyMb+h3pYlgiJih0MGiBH90tTjy5h5+fx504=; b=I
        rSwAWSFKLrcdGcT1XAehAb7wD99vD15jdhe/HzONHCu7cjb0/0jD2nZXhtnIztcU
        sfl+PSJqlng3ZMr36Giiz8pSMMWJposk8EHWY9a05VmHDHeKQ9jHebyHVKmeRrd4
        mT/c8fymeahkq3m+uLtyiDfSPzAxRtYYfBmuFISjwijJ2U725wDOHV605ABeiA8l
        PMdCr1Qlcpd3pLtp7nRf/byRrbV/WrLgeOedYScIb3Pk21uOKj8roOTvZ9mrb9ru
        Iie4I9CKOalyo3Gba2klAcZtUEIrmiWxCKNzaiFneadn5mvtDAH3JYa9Y2CMGyLw
        goWp6Z5T7Ys3Vsqu5HS7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1666883344; x=1666969744; bh=HeLlRgoVyMb+h
        3pYlgiJih0MGiBH90tTjy5h5+fx504=; b=m6Z3aKsafge/tXhe+8rsWyQsNN04S
        DSMnLCdfrkb24R2m0EivdkIRTkCf6jtrvT8QcZ/iRBqZvqLLMsbGbZawfsUKhXv4
        q7l1uDXkxyxLFYGMue6McPyzU1mp/xMg63WLb5nedieJWlqpYcGhyBYKm2NylIC9
        0h/Uk7Zbx6hVGhcC0FTXLn9g3rPMBo6q172o0BzHOS8j3weOKqqSIfZa/12m+Jm7
        zETIJx7B3W+lN3HSMuGiTyrpzl89mHUtlroIoSwDNZ3BoEyH+EZqmCEaEcoMJTvf
        3TpT35YTUvMb80aiEqVlDn2Gx0YolGV6D8cd6PheVX7T045MIP/z/92LQ==
X-ME-Sender: <xms:Dp9aY_saVCQaTFldYyQ84nygqsGG6PB3ECvj5pK4AgW6SPhDD4K_xQ>
    <xme:Dp9aYwcbZ9m8MEaKSAK0lW4utjRh0_fqm7MtYOH30FvtPPC5BibFHJSGXjW0RhuIX
    2T78RAYlNUuZpbNBTU>
X-ME-Received: <xmr:Dp9aYywkAycJ2c8zaCYEkkEw49ePALrFoIol6kAKZ4aH9yv9AFEKSU4krIuslVHFl4g3nh5GezD9Pw2eyWw64HP_tXxkAO3XVcnIHHenmEihckVYL-fvemY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcu
    rfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvg
    hrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleekjeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvg
    hnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:D59aY-NaSTQiYXVvtS7GLJMzadaMXRQ-F7DSe2oazFo44qAauxkJ9w>
    <xmx:D59aY_9oawqSNASKQx87TQvfIpWgAtVv_WalmpB0XsUdD3HTKBXhyg>
    <xmx:D59aY-VqC168Pwfz_G5htjY2Ug6LCbvGcIK_i2_3lpilbI421jeSmw>
    <xmx:EJ9aY3OcLAXY5u5hx_I9JT1RJCbjbPuXjDBPoCEr3R7mPij0V7fhVQ>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 11:09:00 -0400 (EDT)
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
Subject: [PATCH v4 6/7] Bluetooth: Add quirk to disable MWS Transport Configuration
Date:   Thu, 27 Oct 2022 17:08:21 +0200
Message-Id: <20221027150822.26120-7-sven@svenpeter.dev>
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
 include/net/bluetooth/hci.h | 10 ++++++++++
 net/bluetooth/hci_sync.c    |  2 ++
 2 files changed, 12 insertions(+)

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
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 76c3107c9f91..91788d356748 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4260,6 +4260,8 @@ static int hci_get_mws_transport_config_sync(struct hci_dev *hdev)
 {
 	if (!(hdev->commands[30] & 0x08))
 		return 0;
+	if (test_bit(HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG, &hdev->quirks))
+		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_GET_MWS_TRANSPORT_CONFIG,
 				     0, NULL, HCI_CMD_TIMEOUT);
-- 
2.25.1

