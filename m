Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F53260FB52
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbiJ0PJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiJ0PJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:09:02 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5251E18F0F0;
        Thu, 27 Oct 2022 08:08:55 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 9C317320094D;
        Thu, 27 Oct 2022 11:08:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 27 Oct 2022 11:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1666883333; x=
        1666969733; bh=NsyIxhCuy3NX42H2/3Rfy8Jj+bJmvXH1V0swWErvcpc=; b=a
        t6BGC8QmN/9Hb6apE4+YvkARHsuJC/Se81aqWzzHBBPAkQ/RN0UQAMpj7FCx/VxJ
        uOxTrU/wXVsYlxuQGiELaM9g9Zw3kYxMScPNW0/1SwF+Np0lLkkJSOkCyqY0edYp
        hTuHqNb+OR7GoqFhPYS4H8Fn8tAQxOkTl3d29sxpDkKV3uvkrkebdS2qZd0BVpoz
        h6lPm4jngA2gaEjMGlEV2hCIEG1zlWNrHX/3Z51ftjLof7JhzKy85MSlcQcPQ+i8
        gxU5mKWcjRlk6qLRqkoG9VGGhewQbJc4Tm6hX1i3RhYO824kAYsXAmKE6BP0OA8d
        1FnCSua03/ZZl57PiC9+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1666883333; x=1666969733; bh=NsyIxhCuy3NX4
        2H2/3Rfy8Jj+bJmvXH1V0swWErvcpc=; b=ETVcrVnYu8JGiJ+L+omZhuRcpTqih
        ifkl4BBiTawa5t27HM2wS2/u1dd2mxD79j/RuCN5vGT/KVKAjZztitpTblllO0fP
        zaBDBGV3h/Z0z/a2VxuFhHYA/7Fk8ngcS3iea/rElA6WA6nPQlonTZ7EXGKmV1SK
        uwu8wVxSXCu44V6rSW3TckfUFPtAPoSsG/W71og9GSPfq/Uu4fOTHFl59TW0L03s
        wtTKOuBXTxd/jXac4VLbSSIYQB3Rn4RTE9wbHuKyadGPwmVanzrGAxU8e8tu7VNk
        Q+G0xj6BOhzEsOyoIUwChNTLI7QQvSKDch7KbDHDIdeChDtK3mCk1OdCQ==
X-ME-Sender: <xms:A59aY2ExqCwHjhQHiaDX-Oq18QxxXQ_JaJLRzpIZiTTsasp652jMpw>
    <xme:A59aY3VIXAvOJbmCsrPF2dKeYxh-xcJg322TdVa1pfRgFbuZFP5CMrns-jEjtcXBC
    pXLpoN9JSjlCQYVxNc>
X-ME-Received: <xmr:A59aYwJQoPiy2eFRPe6bR4KGjPuMlEWKwbV56n_uN7_u38I7vVWSKTBIkgqXGzXWr0LTwunb0MT1E9nq4iuljas8ROBqgfH4b3ui0XUu_8L4PNFkoFDhZyE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcu
    rfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvg
    hrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleekjeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvg
    hnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:BJ9aYwFJ36YUK1V8SHO1TvUVHee3NaN3OpILsp-RQUFl9Zhp_Kaakw>
    <xmx:BJ9aY8W_2A_9Dx8Li1tixQAHGI3w6oc3Yc4xcH9UJF5yHXR7O-S6rw>
    <xmx:BJ9aYzNBF5zF5IlTSMZrChBFXdKQQJilz1Nxrvulj835DUUxKkcLyw>
    <xmx:BZ9aY4l-VFwFksIaAnQMCeably74NFg9BsKL74iG44kQId8n6nDf4Q>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 11:08:49 -0400 (EDT)
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
Subject: [PATCH v4 4/7] Bluetooth: hci_event: Ignore reserved bits in LE Extended Adv Report
Date:   Thu, 27 Oct 2022 17:08:19 +0200
Message-Id: <20221027150822.26120-5-sven@svenpeter.dev>
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

