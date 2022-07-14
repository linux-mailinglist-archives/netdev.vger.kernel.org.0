Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB382574B17
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbiGNKsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237289AbiGNKsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:48:20 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A1C51406
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:48:19 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id h29-20020adfaa9d000000b0021d67fc0b4aso459400wrc.9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TcbL293klknuFRfZ1i01tinmhCgguD5yCB7g0kW+L6k=;
        b=G5jbzXEoJg6vN8TMAZMcpCS0XRYpdmVmOPqNHtSHypAGXhz8VJoUqU2KRox7AiA3sM
         S/NvzjYJK0dBsxN8zKdMRLKvQruCZIAPdLW7y/DfggEgFSv34G4aPSqJXomGxqG0Dua7
         h1HdW9A8ErP4DhheRfut5PVo+APDi2/JlHiLgy9uR3pA5uCQQpsHLqzPi1zfqrtKqfzo
         vO7fDKnOdgqE2jml88KtH6iEWhqQ5j7QcktLOgHd/zhX3ByHqhz5CcRI2lXW1HIuJh0o
         Mfw4L9Z/QQ0n+YXx9w967uVqwXWjxijfPD3/yBrs9J1+9dNTEpZY6tvrlv4n4GOj87EG
         HxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TcbL293klknuFRfZ1i01tinmhCgguD5yCB7g0kW+L6k=;
        b=Uo2e2DTYSXw6VjFSd44OrEPjKHphr8fBQulG1fbL3LrLOWs8JUnYg+mjmp1UAYxjtX
         fFCE/MZG/xZIy/rNggc7ndNfGKXQhT1hyHagq7dOBzzzWHDizSo6x3E2rXq153iZfoOW
         MkfrN4q71Hvo9YiufzuNDt1Ev2j88GkOpC4TVXKC9K+uVV3bX9WmKkW6fL/2EVDkr1ie
         gYq5tWZJzUc/3SYxriB3cfbG2QPzHX8UBbSkwRg0oXQzY5XocpTSEpWvC2DWX333/aqj
         y8nRbk7Wxm4a9JQyQ5KQQS18ewzsEsUk7fiUEZIwu4ETrHFTI0SZfmxXJzVx60Zw8C+R
         naSA==
X-Gm-Message-State: AJIora/N6Xy4+v0QRqQZzyl/XgqOgS+iTxhSCajeMul19kSfQy+oMjlc
        W0MhhXeEcAQA3vfkFxy2qVHwUnrakVs=
X-Google-Smtp-Source: AGRyM1sbV0Yq2YAAjCOTbGhhzgSDovNLXEQNSglI0p/MoD9f0OPPIRDj1RhbV1yqEROnz6Hyhac9fEZ/eeo=
X-Received: from rax.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2a98])
 (user=poprdi job=sendgmr) by 2002:a05:600c:4f4d:b0:3a1:98de:abde with SMTP id
 m13-20020a05600c4f4d00b003a198deabdemr14697421wmq.36.1657795697567; Thu, 14
 Jul 2022 03:48:17 -0700 (PDT)
Date:   Thu, 14 Jul 2022 10:48:14 +0000
Message-Id: <20220714104814.1296858-1-poprdi@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2] Bluetooth: Collect kcov coverage from hci_rx_work
From:   Tamas Koczka <poprdi@google.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, theflow@google.com,
        Tamas Koczka <poprdi@google.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_stop()
calls, so remote KCOV coverage is collected while processing the rx_q
queue which is the main incoming Bluetooth packet queue.

Coverage is associated with the thread which created the packet skb.

The collected extra coverage helps kernel fuzzing efforts in finding
vulnerabilities.

This change only has effect if the kernel is compiled with CONFIG_KCOV,
otherwise kcov_ functions don't do anything.

Signed-off-by: Tamas Koczka <poprdi@google.com>
Tested-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
---
Changelog since v1:
 - add comment about why kcov_remote functions are called

v1: https://lore.kernel.org/all/20220517094532.2729049-1-poprdi@google.com/

Note: this is a resubmission of https://lore.kernel.org/netdev/CAPUC6bJbVMPn1FMLYnXg2GUX4ikesMSRjj=oPOOrS5H2DOx_bA@mail.gmail.com/T/

 net/bluetooth/hci_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 45c2dd2e1590..0af43844c55a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -29,6 +29,7 @@
 #include <linux/rfkill.h>
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
+#include <linux/kcov.h>
 #include <linux/property.h>
 #include <linux/suspend.h>
 #include <linux/wait.h>
@@ -3780,7 +3781,14 @@ static void hci_rx_work(struct work_struct *work)
 
 	BT_DBG("%s", hdev->name);
 
-	while ((skb = skb_dequeue(&hdev->rx_q))) {
+	/* The kcov_remote functions used for collecting packet parsing
+	 * coverage information from this background thread and associate
+	 * the coverage with the syscall's thread which originally injected
+	 * the packet. This helps fuzzing the kernel.
+	 */
+	for (; (skb = skb_dequeue(&hdev->rx_q)); kcov_remote_stop()) {
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
+
 		/* Send copy to monitor */
 		hci_send_to_monitor(hdev, skb);
 
-- 
2.37.0.144.g8ac04bfd2-goog

