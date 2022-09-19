Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93165BD288
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiISQuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiISQtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:49:55 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27A2F58D;
        Mon, 19 Sep 2022 09:49:44 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1CF355C03D3;
        Mon, 19 Sep 2022 12:49:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 12:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1663606184; x=
        1663692584; bh=fS7E0tpreCM+xlmdHD1Aowm+v7DIsRJlZ0GHl2ieyyQ=; b=R
        9X41WnB6UTwe6Hnuw5e16mfWE4Ey2gq+StOGfhltmTPI2OvFPGZtu/rvdgNRFe6g
        bwqJqd900vqzM+bRR+PBu1BOhgPEFBHC0YM7vRbr98kg4lQseRxePWrTpeiYLIGv
        IAO7Qix0C2ZxTA1gaRn3YT8BiYb4jKX4GQi0MNVr4J1GRyXS7LWgUSMaSXZacPV2
        IlOgi/D/QJOroOipj5cG1w5VJvCTtZDJn2mD0KojspOzX0VNUJGvMvAou002FEXX
        YxvrLcNpLPoi5t2XnSSmeGLd0I+UYs2Cw4u65y5BfRdzq2bUHtT5A+mhHAcbk88e
        Um3aVV9jpHJqWUpkQ7PwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663606184; x=1663692584; bh=fS7E0tpreCM+x
        lmdHD1Aowm+v7DIsRJlZ0GHl2ieyyQ=; b=xjFcyKhuZVlf2FIQxlsPwwCUZCduu
        OC23tZ7nDHEY4Uhyd3XXm8hSFt1IXqkiLqynCDFSxBgtFPrcOY/FAXFkFoR3kpxz
        yz2+aO9Qo01TsG96HAhsstTohW9J9ih0hc/NDYuKu1SlxJjaDwhGIeb8m91KXh2x
        gSl9b1ZxLfrlgDwVmyy/kSXQt4ygD/aTSDhlEZMFMghbC6sz01bmrZlkq3jIH8NC
        LspFmP6w5XQIiK6dUPv3VUEdCmg4h/iND8xQNfQDF3aK+LeD2cvhJoF1ZHkuWprz
        Do5a51KG0Eyn4w4jdt7h/yOoAGqwWkU9c5HJ6rqCZJsfWN81J1fGkTvGw==
X-ME-Sender: <xms:p50oY-BrPtlxBciueUmHDRIe8QLszJ41sEx-z5ioFpc7Nl3Pd8YLVw>
    <xme:p50oY4hK9Y7QA3716MDK6wV1PjRFxEJApZR-zFBDW9NjF_HjGxfReRM77FwiMyOML
    6Y_M7bJfjbS5GUkGVY>
X-ME-Received: <xmr:p50oYxlEJ9wLCHOUTuYDKLgbHMMfncvvNgmbDW6uLRsrvKI04xcJzuti3JNmVcyaMiQbIGH5aEnTsWofAGLCpbKyN2rL_DFFp0LxHpW5Tokcasg7BHi_5n4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleek
    jeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:p50oY8zg1b2LCfHvyYebw3egRTaT7u_DCkNLcGX_rtZv48wY37Z6TA>
    <xmx:p50oYzTDW1xi3J_wDsCtnWZhDFfq4St6inblwHsxMWTzQpoxCpRrvA>
    <xmx:p50oY3ZxSVFLguntUB5lP19v47FxHSMDeFScpRd89IAp72Tr73Qz-Q>
    <xmx:qJ0oY0Aqw-j4LXRgtUR6jZ-V9TVbZ1nPOh6_KlHtK-HfuKLGBOUspQ>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 12:49:41 -0400 (EDT)
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
Subject: [PATCH v3 5/7] Bluetooth: Add quirk to disable extended scanning
Date:   Mon, 19 Sep 2022 18:48:32 +0200
Message-Id: <20220919164834.62739-6-sven@svenpeter.dev>
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
no changes since v2

changes from v1:
  - adjusted the commit message a bit to make checkpatch happy

 include/net/bluetooth/hci.h      | 10 ++++++++++
 include/net/bluetooth/hci_core.h |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 556916110636..75dcd818cf04 100644
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
index e7862903187d..29d1254f9856 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1681,7 +1681,9 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 
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

