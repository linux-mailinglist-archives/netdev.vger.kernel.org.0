Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3E64CAEAA
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiCBT0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240439AbiCBT0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:26:32 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A33FC1C8C
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:25:37 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 74B673F5F5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 19:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646249136;
        bh=Mdsn7AT474MZc2MQVfRJDSMS8EOfClYXR9EYCiW/6uw=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=AUCDt5MsPe1PsjaSbSqC0wKPst/OHiR1mFTDwZknPsfCfDn916ACo+WiDg3LUbhvx
         dZd6/Pg+5i6ioIBg2Vmo0iSut117ANG+Bx5udlxo1Fw0w6W1mjq62wmXsYBLrTKZsD
         z0eNI7a/NpueBLdcZpxghkvOAZWXkVAFUIG1F6hQMpGwMl3lyjNRgAVQJHk7/AHJnj
         MOQGDbQZerf8yq2Zn55yQs0ZlhSFSBNHer/c9hTx7546G5clYCgRqQvb3O+8Q9xAzP
         sE1fNHrkqFBVneq139nTcS3cBXLdX7/8fviz3fsarIn9NQf7MA2I8k7b1hcH9fnw9/
         IIWibeZL7mW+w==
Received: by mail-ed1-f71.google.com with SMTP id j9-20020a056402238900b004128085d906so1509059eda.19
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:25:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mdsn7AT474MZc2MQVfRJDSMS8EOfClYXR9EYCiW/6uw=;
        b=T1NzDtc/NMBVIBNWb6vLeBgDD11yAD6r2jSRmT1f+m1BMUF8fihlbd1RW5thuFBTHI
         0hEsigShz5XSSJwqYIDK4WtR075yWd35UFpUJf8L1jXYrhDvP4Tc7p4ufBvpwqSe834M
         GGtlXCw52LO6Sy62aaEbafr+Gsi5aempXz7SoXpltXrJwN1pjkGMd+cGuTf2ch1xWWGN
         fwDQpg4mWDaN+4ViEplMMVKqoYMjtpKMcMo25VSFpLd3CFO3OLfkmS35ZXiaFSuQTqRk
         GueNlr4qK6PHMEBr64+byXgB+FW6VqHBsIq4sIynXi7DTD6uU0uf3tTgYigcAiWujDX5
         UhwA==
X-Gm-Message-State: AOAM533Lju2m8ecRhhE3wv3i3T/C8ZjIIaO7qG/xOrxQc00px8Jl2W66
        dQOnJqDlCANBxHjDYa4ryNZSLd/1F4E6Zd3PoPd59B/CKrTyjh/pgLg1XIPiTP412UlsLCI5Cqg
        HTXgfBDk8dVKIrkvnT2IOi/axBUehIfEWGw==
X-Received: by 2002:a17:906:714c:b0:6cf:4850:52cc with SMTP id z12-20020a170906714c00b006cf485052ccmr24550321ejj.319.1646249136076;
        Wed, 02 Mar 2022 11:25:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTh8qQiPVslsguc9Q0e99iiJ94AmhFY0BNCMiQLPiKFvI8B9dasw3D154XCQaRCiddESFGrA==
X-Received: by 2002:a17:906:714c:b0:6cf:4850:52cc with SMTP id z12-20020a170906714c00b006cf485052ccmr24550313ejj.319.1646249135910;
        Wed, 02 Mar 2022 11:25:35 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id i14-20020a50cfce000000b00415b0730921sm1482765edk.42.2022.03.02.11.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:25:34 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2 6/6] nfc: llcp: Revert "NFC: Keep socket alive until the DISC PDU is actually sent"
Date:   Wed,  2 Mar 2022 20:25:23 +0100
Message-Id: <20220302192523.57444-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
References: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 17f7ae16aef1f58bc4af4c7a16b8778a91a30255.

The commit brought a new socket state LLCP_DISCONNECTING, which was
never set, only read, so socket could never set to such state.

Remove the dead code.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp.h      | 1 -
 net/nfc/llcp_core.c | 7 -------
 net/nfc/llcp_sock.c | 7 -------
 3 files changed, 15 deletions(-)

diff --git a/net/nfc/llcp.h b/net/nfc/llcp.h
index d49d4bf2e37c..c1d9be636933 100644
--- a/net/nfc/llcp.h
+++ b/net/nfc/llcp.h
@@ -6,7 +6,6 @@
 enum llcp_state {
 	LLCP_CONNECTED = 1, /* wait_for_packet() wants that */
 	LLCP_CONNECTING,
-	LLCP_DISCONNECTING,
 	LLCP_CLOSED,
 	LLCP_BOUND,
 	LLCP_LISTEN,
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index b70d5042bf74..3364caabef8b 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -737,13 +737,6 @@ static void nfc_llcp_tx_work(struct work_struct *work)
 			print_hex_dump_debug("LLCP Tx: ", DUMP_PREFIX_OFFSET,
 					     16, 1, skb->data, skb->len, true);
 
-			if (ptype == LLCP_PDU_DISC && sk != NULL &&
-			    sk->sk_state == LLCP_DISCONNECTING) {
-				nfc_llcp_sock_unlink(&local->sockets, sk);
-				sock_orphan(sk);
-				sock_put(sk);
-			}
-
 			if (ptype == LLCP_PDU_I)
 				copy_skb = skb_copy(skb, GFP_ATOMIC);
 
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 5c5705f5028b..4ca35791c93b 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -641,13 +641,6 @@ static int llcp_sock_release(struct socket *sock)
 
 	release_sock(sk);
 
-	/* Keep this sock alive and therefore do not remove it from the sockets
-	 * list until the DISC PDU has been actually sent. Otherwise we would
-	 * reply with DM PDUs before sending the DISC one.
-	 */
-	if (sk->sk_state == LLCP_DISCONNECTING)
-		return err;
-
 out:
 	sock_orphan(sk);
 	sock_put(sk);
-- 
2.32.0

