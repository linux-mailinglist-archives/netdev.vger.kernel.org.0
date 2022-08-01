Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4290B5867A5
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiHAKkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiHAKkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:40:07 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D744639BAD;
        Mon,  1 Aug 2022 03:39:57 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E69A75C0130;
        Mon,  1 Aug 2022 06:39:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 01 Aug 2022 06:39:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1659350396; x=
        1659436796; bh=NkwFPO/ZTUvbyS6zTolzX5iCRdPBBF2BR7/v0HZlVoU=; b=V
        K1oPBLYVjvANj5UxeJu7pGvWZSPYu0oiFkT0w88ptmfXzIsNHxXYCetBVTaJTLXa
        kL7dOl+9Wj0nJBQf4GqNbISfn6kXl7/HLk0wpto22cW7VrvMHpxUJkyU1E0b3UVa
        VYyBpccsXmgxOe4cfsOEAvPIVLSPDAIrWUsDSKGNBo3Nj/cXmDLM1lwqQxaRYaPX
        n4k1wJu5Z2PkKxfxVcKx8FswQSRPMUvqotCU1G9edrC4b1VWq2zDbKjm0G26kXVl
        qpwvOXZ98Cx0awYlOTjD2ZdkcAeeVyRyKxO0bYPO9uClcTjk/5uu+7hFf9CYIU8i
        Z36r+x+nBql+Ns9e8e1fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1659350396; x=1659436796; bh=NkwFPO/ZTUvby
        S6zTolzX5iCRdPBBF2BR7/v0HZlVoU=; b=hjSLDIumXMjSLcaWE/7iN5n6VPlZb
        dLuTdkckdLJsWAPnmWG/HiZMORZd90/mB0FmDgZHMNORETYNmCz5VD60emJ4TVBZ
        OLI7iPAjW5MuaySlUS2PkoHKVjkH7jLDRFVii5AMpnWLc7ZWwyDO3syhvzKFOeCP
        UsDZDGMIItv6revPgpzcut4x3YmX33P1OAHxYRagoVMvHHYh9qxluwxmw8OXbxai
        FC0x6f13gxbsUP7fYZJJmUdgsqOsL2w2dNK/e5vjx0qrbU9si0s4etH3Sp3jRmYx
        37KPry2L2apsWm1PiFMT+HLATElCOx2IKza2eO0tPGvWKOQGGsDrD6uNg==
X-ME-Sender: <xms:fK3nYiVRPpEAVlXvc7xTt8TXdsCdXpH-B38zmS5EFIXizfKRZ-lRJQ>
    <xme:fK3nYunmgQBkKkoITxXOzaEd5bnZ77h68u3ZzEPLPKtEmXkhLvclumjcx7nSOedwB
    w5UohdDiR6HnGozkuo>
X-ME-Received: <xmr:fK3nYmb_8NDRQJDuCOvGP4fhv96lDNbYSrmLc70iwuCkL2zG8AIQcLiDQHB6ZiaocEWClyj2hZsPXSQt7CSBUHqCpg7RlKxPOuXav_thebmmgxgpyBQ_BWM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddvfedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpeejieehheekgedvjefhveekjefguddtfefhteehtdeiffelkeeiuedufeelkeej
    geenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvh
    gvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:fK3nYpXO_aabo670LuWX-i55lhpNg2izXNHI1tLC9Kl-Xz0om8SiSA>
    <xmx:fK3nYsmXSgVRh93BVoiEa9VXV4RODjKnzR0h-GwB2jJbVCJIcj0Sxg>
    <xmx:fK3nYufSUwEs5v91IvNXN__n3nbRlwZ1yc_Y2SA216JQ2Naf9hJURw>
    <xmx:fK3nYm33S2qZd2lghMOC-Ovi1H1eyk-lAk_2qvz6yNPSF5BMxJtweQ>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Aug 2022 06:39:54 -0400 (EDT)
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
Subject: [PATCH 4/5] Bluetooth: Add quirk to disable extended scanning
Date:   Mon,  1 Aug 2022 12:36:32 +0200
Message-Id: <20220801103633.27772-5-sven@svenpeter.dev>
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

Broadcom 4377 controllers found in Apple x86 Macs with the T2 chip
claim to support extended scanning when querying supported states,

< HCI Command: LE Read Supported St.. (0x08|0x001c) plen 0  #27 [hci0] 2.971839
> HCI Event: Command Complete (0x0e) plen 12                #28 [hci0] 2.972730
      LE Read Supported States (0x08|0x001c) ncmd 1
        Status: Success (0x00)
        States: 0x000003ffffffffff
[...]
          LE Set Extended Scan Parameters (Octet 37 - Bit 5)
          LE Set Extended Scan Enable (Octet 37 - Bit 6)
[...]

, but then fail to actually implement the extended scanning:

< HCI Command: LE Set Extended Sca.. (0x08|0x0041) plen 8  #105 [hci0] 5.460776
        Own address type: Random (0x01)
        Filter policy: Accept all advertisement (0x00)
        PHYs: 0x01
        Entry 0: LE 1M
          Type: Active (0x01)
          Interval: 11.250 msec (0x0012)
          Window: 11.250 msec (0x0012)
> HCI Event: Command Complete (0x0e) plen 4                #106 [hci0] 5.461777
      LE Set Extended Scan Parameters (0x08|0x0041) ncmd 1
        Status: Unknown HCI Command (0x01)

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
 include/net/bluetooth/hci.h      | 10 ++++++++++
 include/net/bluetooth/hci_core.h |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 47e1ee6f275d..dd275842b9b2 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -285,6 +285,16 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_EVT_TYPE,
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
index c0ea2a4892b1..149b9a10f52f 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1501,7 +1501,9 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 
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

