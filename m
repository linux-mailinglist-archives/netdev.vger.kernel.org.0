Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E54A5B0B22
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIGRKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiIGRKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:10:03 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC3B883CD;
        Wed,  7 Sep 2022 10:10:01 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id A5FF63200909;
        Wed,  7 Sep 2022 13:09:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 07 Sep 2022 13:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1662570599; x=
        1662656999; bh=O0i+3x8u3vyjUZfSMJXIAqHFz1c12i5gH79nN7Zcbc8=; b=z
        ybVx4BAdJ1CiIbO9JbPK7nTcCSrz+FxAuxaOl6PeFUYs8GxocM85E1cZq5HSQnyQ
        3WijFOFi2N7PyoLMtXxwDq4q76OejAHeR3MZBqHbQHCPu6W7aemzuzRvRcGuMrTj
        bnJ7DVugNuG+0M77oiu5MU+Y0bymFg5pD+E2ubwurgs7B5DuYSl/4QZpvKJFajHU
        7FneHEZZigsCRPt0I5Ylah3Nn5wdPQrbbxc/QTc8rmNlF3P/aE2Mla8I7/UjQnUD
        KiJueMjclzNC029gp8bqlYBN0IKd0cV7yUvlubkHkdenGEKytq7CrtNnrDyJQfR0
        dsXLNj6L+2GSqWhbhsuSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662570599; x=1662656999; bh=O0i+3x8u3vyjU
        ZfSMJXIAqHFz1c12i5gH79nN7Zcbc8=; b=2EXTqnGO4cyuOXRUN4Klywp/BpY4e
        9NGYfFtELQic0Ump4xnr0xglB8MgWD5w6KYznhqJOQkfEH7RmhH3NqnmQXBUbSbN
        6soZTCSbw9TRTcysu8I7kdioR3hz2CyUm/CgX3+ffsYYYlQGVzHdyePRftK/eOBC
        iRXD4WYQHvubUIM5MLDwWV5eK3yB6OpyN4BM670emErZ1J3LU720fgjnyr86njr2
        T8gIHZX/yATWllibtfioaq84dvhkKCnjuZ7GxsWyMunU3cYP7labafZrCE8gU7vC
        NhRyVGRzztaiXbNR2GumCYL5pOTCO+FSLUuRSXhTq2N33uNv8ClPxp0xA==
X-ME-Sender: <xms:ZtAYYx8y-Sbe8pE-a0vhydt6nIu8_yUJmPLl1gbvAH0Vyh5v2oAv2Q>
    <xme:ZtAYY1tNrNnMFE73l9y56Czio7pNvD6Va1vLECpFd-x_aKAMoB7LH_A6JSNMvu6-A
    aBQxdjL3mriBWC2QZQ>
X-ME-Received: <xmr:ZtAYY_AJIa09DPegMf1TjC-b02O3kE9ALLoft3yv7qpq3df5lQES4CUtjN5kKoACivzB9aZLBB9vx4_dT_LI3jjHu1HkQb05-Nw9WS5b9ZuKWiTryx5sYrU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleek
    jeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:Z9AYY1dHIvRNmSwG2oyM2g2Kiw9fjtunxZlZMIdYufqE0JpsgELEaw>
    <xmx:Z9AYY2NOKDGoKR-P8oz0vcgA1fczdsWQN0kyEorbl2rko4JxSwlD3w>
    <xmx:Z9AYY3nuwMIdRnniJ7Dyl2iAr3I-oojB3XmAPXiUyjInEHDOXjzVoQ>
    <xmx:Z9AYY7cPazjZri510DfKBDdXuOFKJtoZchMbSczU6zyPLqkkL3StHw>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 13:09:56 -0400 (EDT)
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
Subject: [PATCH v2 3/5] Bluetooth: hci_event: Add quirk to ignore byte in LE Extended Adv Report
Date:   Wed,  7 Sep 2022 19:09:33 +0200
Message-Id: <20220907170935.11757-4-sven@svenpeter.dev>
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

Broadcom controllers present on Apple Silicon devices use the upper
8 bits of the event type in the LE Extended Advertising Report for
the channel on which the frame has been received.
Add a quirk to drop the upper byte to ensure that the advertising
results are parsed correctly.

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
changes from v1:
  - adjusted the commit message a bit to make checkpatch happy

 include/net/bluetooth/hci.h | 11 +++++++++++
 net/bluetooth/hci_event.c   |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index cf29511b25a8..62539c1a6bf2 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -263,6 +263,17 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN,
+
+	/*
+	 * When this quirk is set, the upper 8 bits of the evt_type field of
+	 * the LE Extended Advertising Report events are discarded.
+	 * Some Broadcom controllers found in Apple machines put the channel
+	 * the report was received on into these reserved bits.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_EVT_TYPE,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 485c814cf44a..b50d05211f0d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6471,6 +6471,10 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
 			break;
 
 		evt_type = __le16_to_cpu(info->type);
+		if (test_bit(HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_EVT_TYPE,
+			     &hdev->quirks))
+			evt_type &= 0xff;
+
 		legacy_evt_type = ext_evt_type_to_legacy(hdev, evt_type);
 		if (legacy_evt_type != LE_ADV_INVALID) {
 			process_adv_report(hdev, legacy_evt_type, &info->bdaddr,
-- 
2.25.1

