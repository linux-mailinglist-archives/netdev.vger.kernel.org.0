Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794605900FA
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbiHKPr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiHKPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:46:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9472C8E0FD;
        Thu, 11 Aug 2022 08:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20FEF616D1;
        Thu, 11 Aug 2022 15:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9B7C433D6;
        Thu, 11 Aug 2022 15:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232463;
        bh=QaOgUX6f59t2m5Q8gSbIyldyDlbSwfbK1pcUKFAUH38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPzfIZDe26RVKK0UQVPGLXA9S4uMh+NN6swA0ocV87Hr40hCJFAmt13GYYYth6Vac
         1s6I5sdq43YMvU4UcHfGNs4rK/Fx9n2H8JFrgfKYHNAvhaJiki0Zi7h/CNWWIPiL6v
         l7J1wzSw7mx+WBmKgRcXtnG3Il6vfwo/54O+29/giC9S4gb8WuOqU77FH6yohYLcNP
         4iJTkO6g9dU8hR3S2psUos0/dErjsUKavEZDsXzAD6QGPX3UlA/v3AK+OD1CQUb+pD
         /Z1BqCi6R2WPTXbwdkcyNXrnRQVqWSmlRWS9U+dHzgsKNS4CQJsJTJ57HF8lSvNSIG
         4nlq8CAjXQlCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zijun Hu <quic_zijuhu@quicinc.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 088/105] Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
Date:   Thu, 11 Aug 2022 11:28:12 -0400
Message-Id: <20220811152851.1520029-88-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 63b1a7dd38bfd4630e5f59a20a2b7b1f3d04f486 ]

Core driver addtionally checks LMP feature bit "Erroneous Data Reporting"
instead of quirk HCI_QUIRK_BROKEN_ERR_DATA_REPORTING to decide if HCI
commands HCI_Read|Write_Default_Erroneous_Data_Reporting are broken, so
remove this unnecessary quirk.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 11 -----------
 net/bluetooth/hci_sync.c    |  3 ---
 2 files changed, 14 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 000c70e88aa8..a74535e2edef 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -228,17 +228,6 @@ enum {
 	 */
 	HCI_QUIRK_VALID_LE_STATES,
 
-	/* When this quirk is set, then erroneous data reporting
-	 * is ignored. This is mainly due to the fact that the HCI
-	 * Read Default Erroneous Data Reporting command is advertised,
-	 * but not supported; these controllers often reply with unknown
-	 * command and tend to lock up randomly. Needing a hard reset.
-	 *
-	 * This quirk can be set before hci_register_dev is called or
-	 * during the hdev->setup vendor callback.
-	 */
-	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
-
 	/*
 	 * When this quirk is set, then the hci_suspend_notifier is not
 	 * registered. This is intended for devices which drop completely
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index a6418095b8d5..9a3a7cc01345 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3835,9 +3835,6 @@ static const struct {
 	HCI_QUIRK_BROKEN(STORED_LINK_KEY,
 			 "HCI Delete Stored Link Key command is advertised, "
 			 "but not supported."),
-	HCI_QUIRK_BROKEN(ERR_DATA_REPORTING,
-			 "HCI Read Default Erroneous Data Reporting command is "
-			 "advertised, but not supported."),
 	HCI_QUIRK_BROKEN(READ_TRANSMIT_POWER,
 			 "HCI Read Transmit Power Level command is advertised, "
 			 "but not supported."),
-- 
2.35.1

