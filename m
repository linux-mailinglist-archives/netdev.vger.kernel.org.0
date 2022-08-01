Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6DA5867A8
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiHAKkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiHAKkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:40:06 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC4939B8A;
        Mon,  1 Aug 2022 03:39:55 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6341B5C011B;
        Mon,  1 Aug 2022 06:39:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 01 Aug 2022 06:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1659350394; x=
        1659436794; bh=ct/EECJuSwhp/U34BPYuXiltVWUcB7C+k2wANRMHh9o=; b=z
        6gRzCILy+5oZjGMeDzzFSsWW3qnxZyQCaAh9PnVEaEq1MV1nPI1jRxubMFYjYDua
        OXJNx1KcH45PFtSA5m8zpby/aOPql/PbjmJsedisklEm0zYY/Gp7iA8HGn+3XxyY
        iA48keKLJp7BYEGxpYH9Ovv+J9YRgYgxpsB2gHlZntQ4c5Vs/i4dXWGiUofl19XM
        qBsK4xNXTmjr8JhX0upZWhWhilCXRydCkwE7TLLKmlvrBFuTlVNNQtqsZebej1Uc
        6UPryObHXXDyvFetP8M9V8JP9LLBZJi5WmPKiQ7A7p6wqUenWa5QsO/AXOkR0ISH
        ym8hPn10Vc0caB5D9kRKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1659350394; x=1659436794; bh=ct/EECJuSwhp/
        U34BPYuXiltVWUcB7C+k2wANRMHh9o=; b=HMLMGgnUaVgTk2R/GhZHpGql7Trv8
        +xHzcbInEf57CBsrUUw57pZuAl9KCuFJQz5foLPMt9nAmoD6ImK82oCJMmbDRq8O
        1H1spvDR317VZfeC8R5YveZek/uuVzyjYafaGa8e9DHDivFC8jwkEjOLSXIcFZ+2
        2PCqcYVMYGjWtzPs3HTvPu6DoYIOrf3mcwAMlqqNI9PG4K9QCyFO9QJiYOwHzxhs
        xWQ6CR9uGLNa20nDVE1arTFVonTxzYPrJUYn+IJc4+4Yke7Y/Y5fZ0C9G0kbp9mZ
        dr1kHWcnZcqpuQjlWN3kY6lJdCk+L6UMpi1HbiA4ZWIiE6tIwdbNNbfQA==
X-ME-Sender: <xms:eq3nYgdlN0zsfbMRdabqGHJJu0q11tCfgzOt8TqkJXzHmpWJjHertg>
    <xme:eq3nYiNqxLSbTbJ1672-48jLuIFmLMi65yNg3P847o76Cf4LNYGrRtiNsYAfUg9ni
    0bKO_8tPf9aTQu8X5k>
X-ME-Received: <xmr:eq3nYhj7oJg7xweG38lX7Yn-gBRrSEx3r4hOrAefb4u_gahgShxBLxKBUgSXcI8hsI5bdxyAvQzYyJtyQxcZOePl5zxr8LNLnxQ4KhrQ16VsaQF44kvubzM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddvfedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpeejieehheekgedvjefhveekjefguddtfefhteehtdeiffelkeeiuedufeelkeej
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvh
    gvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:eq3nYl_lJS1YBY6zl8iIsnR5v7mn9qbkl2oouWf5dB8pimWXOkcSPA>
    <xmx:eq3nYsvHDVc502KCV-lw7Vw7y3XQqFPg2agHcLlSvYxxKfhl4z6GpA>
    <xmx:eq3nYsEPaSwBix6oSIjAwKUxrSL4txs3mNMLbZJxNzBz4Jar8d0yhg>
    <xmx:eq3nYt_X8AbA3FXtF-2gsh1yKFL_B-mbXbPH1fq_sKy4NAQ93esA9A>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Aug 2022 06:39:51 -0400 (EDT)
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
Subject: [PATCH 3/5] Bluetooth: hci_event: Add quirk to ignore byte in LE Extended Adv Report
Date:   Mon,  1 Aug 2022 12:36:31 +0200
Message-Id: <20220801103633.27772-4-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220801103633.27772-1-sven@svenpeter.dev>
References: <20220801103633.27772-1-sven@svenpeter.dev>
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
Add a quirk to drop the upper byte to ensure that the advertising
results are parsed correctly.

The following except from a btmon trace shows a report received on
channel 37 by these controllers:

> HCI Event: LE Meta Event (0x3e) plen 55                    #1 [hci0] 0.912271
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
          Address: XX:XX:XX:XX:XX:XX (Shenzhen Jingxun Software Telecommunication Technology Co.,Ltd)
          Primary PHY: LE 1M
          Secondary PHY: No packets
          SID: no ADI field (0xff)
          TX power: 127 dBm
          RSSI: -76 dBm (0xb4)
          Periodic advertising interval: 0.00 msec (0x0000)
          Direct address type: Public (0x00)
          Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
          Data length: 0x1d
        02 01 18 09 ff 57 00 31 1f 01 3c 86 ab 03 16 df  .....W.1..<.....
        fd 0b 09 4a 42 4c 20 46 6c 69 70 20 35           ...JBL Flip 5
        Flags: 0x18
          Simultaneous LE and BR/EDR (Controller)
          Simultaneous LE and BR/EDR (Host)
        Company: Harman International Industries, Inc. (87)
          Data: 311f013c86ab
        Service Data (UUID 0xfddf):
        Name (complete): JBL Flip 5

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
 include/net/bluetooth/hci.h | 11 +++++++++++
 net/bluetooth/hci_event.c   |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index fe7935be7dc4..47e1ee6f275d 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -274,6 +274,17 @@ enum {
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
index af17dfb20e01..0b5d70aeea93 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6237,6 +6237,10 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
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

