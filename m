Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9986C3DB413
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbhG3G5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:57:12 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:39450
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237817AbhG3G5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 02:57:07 -0400
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 12D7B3F224
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 06:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627628222;
        bh=y9Uo/os+3OziqdNdxRl0CGuCizZoyhHNVP1pooBGgac=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=uBXvW9MWOczwFySCI4NDwt2ZPDMyW451Vys3Q514BRAhJJ/l4uULjLAFH/iNlLwe8
         i2Vob0SHAEG/GnyeS/eQ8EYQpMDwBi4BMhTFCPQNGAzsuqwrWHS7vQAlyvxzGhbGSD
         uDejQS+QeWytxVi7J1JRjYqGdxg06MAZMTYkdl29vyiuOpERjKFqIVwaMzEToyyVPq
         F0jphNQ40XJDCy5I5GKV9ha2L7n6knRKcvbVH9JDcKmwfg5SgHJCxClv1LlCHiRaGa
         /jht3jYt87hwT6tj+SO10TABexe4cpu+6L0ZWQ5gW++n4E4SDzxx48eDlC0g5Y0OIM
         PJ9ZN30j2asbw==
Received: by mail-ej1-f71.google.com with SMTP id kf3-20020a17090776c3b0290536d9b62eb6so2766556ejc.2
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 23:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y9Uo/os+3OziqdNdxRl0CGuCizZoyhHNVP1pooBGgac=;
        b=ssex2trrTXObCPx3k1kYSsiwb0yAGZ6X0VoVdi172YTBDrkU7mze/9Fyg4B4JK3diO
         iTs4jun2Dd8sZ7VO+oqwYJxuMxN3Mr9x4bAmlfSIrck9vt2gwyJBU7PsfakDLq1Sf9bm
         VshZOYsb7r6MV+jRkRuukaIsICZQUXnLdS2HdKESwXhcMOu9g13XOB6z02x+XRtb245s
         kpXUbUK3sGc/TJqihSqJsKui0eXsA9CEz6Lln7Qf4PGSrqjX9jOqpiElzo9N2V8+dBBA
         SKFz84vqTe4hUEMwY2iHVha0ZJAI6E/FuVhMiTwIXy5HstplrB+tBDMq56R7n1/0ZCSF
         7loA==
X-Gm-Message-State: AOAM532hZQoZ9GesP6t3XyAEXyLL8S6au37FBdglgk4YbQwNr6AnOLDU
        CrMY0aL/v1JZ/s7za1tQXTGjDqHSEqSyi9yzYMa036vrsgq+gkUIx4CLGJqLemo7BvDBTju3V02
        AwO95LR5MOUi+z9eXt8kka1Moeo2GUm7TBw==
X-Received: by 2002:a17:907:1c21:: with SMTP id nc33mr1135602ejc.436.1627628221839;
        Thu, 29 Jul 2021 23:57:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz89YqE2coEuxrHG66HbiJMUGqlqHkcPyCTLLvJ2b6xbRP9Loj3KGN/HienVTCbi1eYYbPvvQ==
X-Received: by 2002:a17:907:1c21:: with SMTP id nc33mr1135591ejc.436.1627628221721;
        Thu, 29 Jul 2021 23:57:01 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id m9sm238518ejn.91.2021.07.29.23.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 23:57:01 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] nfc: constify local pointer variables
Date:   Fri, 30 Jul 2021 08:56:22 +0200
Message-Id: <20210730065625.34010-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
References: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few pointers to struct nfc_target and struct nfc_se can be made const.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn544/pn544.c | 4 ++--
 net/nfc/core.c            | 2 +-
 net/nfc/hci/core.c        | 8 ++++----
 net/nfc/netlink.c         | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/nfc/pn544/pn544.c b/drivers/nfc/pn544/pn544.c
index c2b4555ab4b7..092f03b80a78 100644
--- a/drivers/nfc/pn544/pn544.c
+++ b/drivers/nfc/pn544/pn544.c
@@ -809,7 +809,7 @@ static int pn544_hci_discover_se(struct nfc_hci_dev *hdev)
 #define PN544_SE_MODE_ON	0x01
 static int pn544_hci_enable_se(struct nfc_hci_dev *hdev, u32 se_idx)
 {
-	struct nfc_se *se;
+	const struct nfc_se *se;
 	u8 enable = PN544_SE_MODE_ON;
 	static struct uicc_gatelist {
 		u8 head;
@@ -864,7 +864,7 @@ static int pn544_hci_enable_se(struct nfc_hci_dev *hdev, u32 se_idx)
 
 static int pn544_hci_disable_se(struct nfc_hci_dev *hdev, u32 se_idx)
 {
-	struct nfc_se *se;
+	const struct nfc_se *se;
 	u8 disable = PN544_SE_MODE_OFF;
 
 	se = nfc_find_se(hdev->ndev, se_idx);
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 08182e209144..3c645c1d99c9 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -824,7 +824,7 @@ EXPORT_SYMBOL(nfc_targets_found);
  */
 int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 {
-	struct nfc_target *tg;
+	const struct nfc_target *tg;
 	int i;
 
 	pr_debug("dev_name %s n_target %d\n", dev_name(&dev->dev), target_idx);
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index ff94ac774937..ceb87db57cdb 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -128,7 +128,7 @@ static void nfc_hci_msg_rx_work(struct work_struct *work)
 	struct nfc_hci_dev *hdev = container_of(work, struct nfc_hci_dev,
 						msg_rx_work);
 	struct sk_buff *skb;
-	struct hcp_message *message;
+	const struct hcp_message *message;
 	u8 pipe;
 	u8 type;
 	u8 instruction;
@@ -182,9 +182,9 @@ void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
 			  struct sk_buff *skb)
 {
 	u8 status = NFC_HCI_ANY_OK;
-	struct hci_create_pipe_resp *create_info;
-	struct hci_delete_pipe_noti *delete_info;
-	struct hci_all_pipe_cleared_noti *cleared_info;
+	const struct hci_create_pipe_resp *create_info;
+	const struct hci_delete_pipe_noti *delete_info;
+	const struct hci_all_pipe_cleared_noti *cleared_info;
 	u8 gate;
 
 	pr_debug("from pipe %x cmd %x\n", pipe, cmd);
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 70467a82be8f..49089c50872e 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -530,7 +530,7 @@ int nfc_genl_se_transaction(struct nfc_dev *dev, u8 se_idx,
 
 int nfc_genl_se_connectivity(struct nfc_dev *dev, u8 se_idx)
 {
-	struct nfc_se *se;
+	const struct nfc_se *se;
 	struct sk_buff *msg;
 	void *hdr;
 
-- 
2.27.0

