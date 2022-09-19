Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95ADB5BD280
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiISQt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiISQtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:49:53 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B9D5F9B;
        Mon, 19 Sep 2022 09:49:42 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 89C3B5C03D3;
        Mon, 19 Sep 2022 12:49:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 19 Sep 2022 12:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1663606181; x=
        1663692581; bh=Bogm0BjoknB2hpgssYrM4PmNTv/LKnDbzuF5OGZyNTY=; b=t
        US2K8xRJ8XwOL/yyfdJxfRJMaQLC9I2gpzb24CkVAhK5Em62bxqB/xYirWYDGJjF
        1DgyzhpSBNKdoMXfcXkgQ2uuN6dCbuOaCMEVt/iebO0oc+nTwS5M6g9g944XE0ag
        eNUmEXOdGzzu66k45FhKEZJyKyLLp8m4RbWQdDatPT7+GqHnYqFOlJ4CmwSqMYyY
        iLMKkBXiThCdhlBV5qI7r5eYUHPHO0uHxDLzS12z5SnEvEcoPJtL2JN/2N8QCWMR
        CJ0pyx+SUpWSPPa8qusnn2Iz8iwIZPZANH8eo/H/ObG8JfRVr4do3ON5poeF9KZX
        hAIwoTLKZp3MqHvpZ7+HQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663606181; x=1663692581; bh=Bogm0BjoknB2h
        pgssYrM4PmNTv/LKnDbzuF5OGZyNTY=; b=NPYhxIAeTyJJihXAJ/xkeVeWauK/L
        MAlPQNoNz8YhlHBFKm6RhTKK2mk6IcQsAT8BV0mwG1kM+4B+R5Ty05tmBCrc8VMc
        5UjwNskoCzHGcpZrxx323Vn5gFoVApIvsbViCHNXK+Lx37poS3G7Hmg4xmR5ZyBQ
        cCDKe9b9QbY0DvLI1YY/lZfp9fOFyqLArxZ3pFGqaQIxC4WGQyGmTfOZphyRMnMx
        DwCpbxoMmgldGhZkNzNnKAg8zjEBFQXfW5pXbqzDfhC2dd+174noZjR/58xpn9S2
        Ec8yLC11QIN5CjmZ/IBb6O6fiVgFHg5+9bWi4JiRhz4JX68zHnHZ7H7Lw==
X-ME-Sender: <xms:pZ0oY99WAOF9CaCI2FKOVDUIIasaBn8GZsAUTfK-0ho25tC2w1X0zg>
    <xme:pZ0oYxtzu9pQvtA2_PiTlMhnOKXY3NVLzUDr9FaX1gPly6zjyl9LfGZQPo7HS8UGw
    2n-qUsjXcSlnEagoKc>
X-ME-Received: <xmr:pZ0oY7CcfglAnHItahCLC1vf93NGkauBQPIGjI3o6teRM9JFVr3dZ6sZPOIf1XuwNqbF3yeBXJqyk4IZJJShz6DUJTTc7Fclq536CW3cB96hluNinXShyNE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleek
    jeegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:pZ0oYxdD0iJ1-v4FoyJFr2fLVYgvmIFYJJDlv_tcVnD20_eCNqGf4w>
    <xmx:pZ0oYyP_RMORWyUZ50LGE9uS4Ut8Vs8A58tpmO6hs-ODpDpou4jjLw>
    <xmx:pZ0oYzmwxDC8auZZHNKcqgpQj0SuiDHTGrEXbUenBW3XinPj4asW5A>
    <xmx:pZ0oY3dqAPtk_fnmeO99LpsT9ylXTWXXiuxUL5iT_yWUxYImLZ3m9Q>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 12:49:39 -0400 (EDT)
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
Subject: [PATCH v3 4/7] Bluetooth: hci_event: Ignore reserved bits in LE Extended Adv Report
Date:   Mon, 19 Sep 2022 18:48:31 +0200
Message-Id: <20220919164834.62739-5-sven@svenpeter.dev>
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

Broadcom controllers present on Apple Silicon devices use the upper
8 bits of the event type in the LE Extended Advertising Report for
the channel on which the frame has been received.
These bits are reserved according to the Bluetooth spec anyway such that
we can just drop them to ensure that the advertising results are parsed
correctly.

The following excerpt from a btmon trace shows a report received on
channel 37 by these controllers:

> HCI Event: LE Meta Event (0x3e) plen 55
      LE Extended Advertising Report (0x0d)
        Num reports: 1
        Entry 0
          Event type: 0x2513
            Props: 0x0013
              Connectable
              Scannable
              Use legacy advertising PDUs
            Data status: Complete
            Reserved (0x2500)
          Legacy PDU Type: Reserved (0x2513)
          Address type: Public (0x00)
          Address: XX:XX:XX:XX:XX:XX (Shenzhen Jingxun Software [...])
          Primary PHY: LE 1M
          Secondary PHY: No packets
          SID: no ADI field (0xff)
          TX power: 127 dBm
          RSSI: -76 dBm (0xb4)
          Periodic advertising interval: 0.00 msec (0x0000)
          Direct address type: Public (0x00)
          Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
          Data length: 0x1d
          [...]
        Flags: 0x18
          Simultaneous LE and BR/EDR (Controller)
          Simultaneous LE and BR/EDR (Host)
        Company: Harman International Industries, Inc. (87)
          Data: [...]
        Service Data (UUID 0xfddf):
        Name (complete): JBL Flip 5

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
changes from v2:
  - removed quirk and apply mask unconditionally since only bit 0-6
    are used according to the spec
changes from v1:
  - adjusted the commit message a bit to make checkpatch happy

 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_event.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index cf29511b25a8..556916110636 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2576,6 +2576,7 @@ struct hci_ev_le_conn_complete {
 #define LE_EXT_ADV_DIRECT_IND		0x0004
 #define LE_EXT_ADV_SCAN_RSP		0x0008
 #define LE_EXT_ADV_LEGACY_PDU		0x0010
+#define LE_EXT_ADV_EVT_TYPE_MASK	0x007f
 
 #define ADDR_LE_DEV_PUBLIC		0x00
 #define ADDR_LE_DEV_RANDOM		0x01
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6643c9c20fa4..00616cae596a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6481,7 +6481,7 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
 					info->length))
 			break;
 
-		evt_type = __le16_to_cpu(info->type);
+		evt_type = __le16_to_cpu(info->type) & LE_EXT_ADV_EVT_TYPE_MASK;
 		legacy_evt_type = ext_evt_type_to_legacy(hdev, evt_type);
 		if (legacy_evt_type != LE_ADV_INVALID) {
 			process_adv_report(hdev, legacy_evt_type, &info->bdaddr,
-- 
2.25.1

