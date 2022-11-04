Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3D61A30A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKDVOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiKDVNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:13:51 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DC412770;
        Fri,  4 Nov 2022 14:13:38 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id AA0633200922;
        Fri,  4 Nov 2022 17:13:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 04 Nov 2022 17:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1667596416; x=
        1667682816; bh=NsyIxhCuy3NX42H2/3Rfy8Jj+bJmvXH1V0swWErvcpc=; b=i
        /wI3fbJWX8ZGr4cRKFWxxgbfK8Uo3njTA/fF5S+ybcpkBjW35P7/liz0wFF4FoIq
        VCnJp+kf7dGgxWcWcqpc+mAAd1H7r8A/eQzTztFbdqayAKJnjqhHZZaS4sg5agde
        jtn0Qceg9OVQFXaqpZ+JlqcYMwaVO3LS3614BUgkVsB8xIQlOoz8sovVX1Sy3sCR
        6GrC/GeifgCWOVfUDMVPDMRkWUZPxD3HM1uvgTpa9lGPr5YE6Nu0IRo7TlD6n2Bw
        otdxBGpxeSkLZljPpCcs1oMrzXYXO6Nc5GbtIJeooowU/d7QCZiabu1A5G9cRMR8
        2t8b6utG89NMhQs9AW+uQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667596416; x=1667682816; bh=NsyIxhCuy3NX4
        2H2/3Rfy8Jj+bJmvXH1V0swWErvcpc=; b=Vtq3mH7UfYVLQ8Pgga8QlMhzC4VF/
        AlTs4GasQSZ98qF8cuXDZNz0nTP4Hr7Gw2QVui94KM1jtCzXcjqj8qX9RvLJvn+j
        KGB3YJRPvkYIL5XDGUZS/I7pgGhxThBDokXZ9QpEVM6zwUx+laZk6GEW5k6BmZhY
        kcJdgU8tMFeXe26wPNTkDdUF5Q02KNUEt+lUxoH21g4AOIikgw64aasVo1utvtx6
        gCVitn9sSOgQ1OMEtMJIDsDtpSKUOBv8+cadmDAebSRFWHz5ecz4Wpyc3RhjeEkv
        CxR9xF0dJZachBegId4Bv2SSsFH7fbIHKfUgwIS23pglpjCiH5Qt+50NA==
X-ME-Sender: <xms:gIBlYwBzF3bjcd7ZoQbZkjN3sLITRZ0mpBMTxzuBGTT0AOemu3IqfQ>
    <xme:gIBlYygTRKXEiF_zHM1l2H8UCwZNarD9qvcj55M_Hr8Sbc7DErBfqcFj33tLIARB3
    8zP-wkh0wMVwPKucmE>
X-ME-Received: <xmr:gIBlYzlwctdz9j_Xwj3bHBauGVf_SeQvg_BlsyhUqGatiiCCelirkATO9j7Mvid0C_QbYe4yKT9sNEXFy8_4FBM1uQ3NkbUe3npyV_tXxR_URpwVdm8C_zfuebXYMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpeejieehheekgedvjefhveekjefguddtfefhteehtdeiffelkeeiuedufeelkeej
    geenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvh
    gvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:gIBlY2xq_LOv8BNyOg_q13E6uqgHOxykr06VW9HOFTpc4Qfmz1zryQ>
    <xmx:gIBlY1Qc6mmXrwTEhynOEfvcYlBKfvUoj86R2zJW9Qniu4WZajvh8Q>
    <xmx:gIBlYxYkeOSRHIoJRcEY0s55T2fZMiFM3cZuFalB8bVhmQnDrLnoNw>
    <xmx:gIBlY2ACQGzay20Y3u6Ozj8DfR9mW6Y3KKTfCYEW8o2M0Zm45SwjfA>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Nov 2022 17:13:33 -0400 (EDT)
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
Subject: [PATCH v5 4/7] Bluetooth: hci_event: Ignore reserved bits in LE Extended Adv Report
Date:   Fri,  4 Nov 2022 22:13:00 +0100
Message-Id: <20221104211303.70222-5-sven@svenpeter.dev>
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
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_event.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index e004ba04a9ae..f4aa7b78a844 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2580,6 +2580,7 @@ struct hci_ev_le_conn_complete {
 #define LE_EXT_ADV_DIRECT_IND		0x0004
 #define LE_EXT_ADV_SCAN_RSP		0x0008
 #define LE_EXT_ADV_LEGACY_PDU		0x0010
+#define LE_EXT_ADV_EVT_TYPE_MASK	0x007f
 
 #define ADDR_LE_DEV_PUBLIC		0x00
 #define ADDR_LE_DEV_RANDOM		0x01
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index faca701bce2a..ade2628aae0d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6494,7 +6494,7 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
 					info->length))
 			break;
 
-		evt_type = __le16_to_cpu(info->type);
+		evt_type = __le16_to_cpu(info->type) & LE_EXT_ADV_EVT_TYPE_MASK;
 		legacy_evt_type = ext_evt_type_to_legacy(hdev, evt_type);
 		if (legacy_evt_type != LE_ADV_INVALID) {
 			process_adv_report(hdev, legacy_evt_type, &info->bdaddr,
-- 
2.25.1

