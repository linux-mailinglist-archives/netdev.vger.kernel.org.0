Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D903D5C26
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbhGZOMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:12:12 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60934
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234736AbhGZOMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:12:10 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id D0E483F355
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627311155;
        bh=y9Uo/os+3OziqdNdxRl0CGuCizZoyhHNVP1pooBGgac=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=NU81zU1R7rNONpX3ES54R4VeWOQQjHx5Phjh3TT1OI2RxWQA2pWB4dIwpZFKXk9ve
         IXQaTHaH7xVjANywn3GcHtCDu+lSAHigbcVo5MXymiO49EApf0h6wP9dHUiUKa7jpL
         DobEkCUr6twvqx8pV3KuimCQ/x/bAwx2L7tb6n45KXwkjXA7clPw7D13KrgwkaMpNo
         18k84LM50jehOiwdhQvvlhQbAX/h/pxMHnhMsvCcBYudQDZwQYC/2HvQBLydzygM3X
         5AgmnY4zifbGVplFuFC95GJi9A0TZJdGjq8PSrwbEOe09QYgJY6VwtUMdQEfzXoeUo
         5PzAq/DaHBmmA==
Received: by mail-ed1-f69.google.com with SMTP id o90-20020a5093e30000b02903bb95130460so1501404eda.0
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y9Uo/os+3OziqdNdxRl0CGuCizZoyhHNVP1pooBGgac=;
        b=odIbI0O0SRq+N5+vqNJLsEjxNoM1czOWj5SKdXtErr5Q4/cKlALnrX7Q65EpYLyThN
         QC7l0jFN1oUxFeLSdftke7gEqE5axD17/qHYp8qO074BHlc6mLwURlMGkbAy37Fcpmsb
         WMV89KOU0uhQIsshAVKknh8INHBn/vkWvwA/yV+iBtDNgHe1xb7naHaKfKScEsTdneMR
         TkMmBvQjNZ0MsxFEsn+rHJ1XvDALFJq/b1Qz71hHSFPOBI251PhKmapCu7tBOmd8r8gg
         JyFZ/6b+Z1hdKISupDo453I06wF+qPo9H3hgoct4+dYxTAfaVKd0yL0jDNEqKYoc0t9V
         zZIg==
X-Gm-Message-State: AOAM530Vxf8BoPeeyGRCNnxF+dNJs+OxvfYj/Z6BRNWx7bG5Wt2nfSyJ
        3TBmP+vg9XeCRMy7LJJq6TjdDPkHCqxSQccy/0dE9rZ+7Y8jXJKULqVd/Lia5EBUJNEaa/IeAnh
        2TUsGgs6sxo1ZvIEACrwK7sGSW6O+hq6JeQ==
X-Received: by 2002:aa7:cd4c:: with SMTP id v12mr9710432edw.155.1627311155630;
        Mon, 26 Jul 2021 07:52:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXMsl4bfkWqmvwoJZSAFu044phU7iVG+4mjnATxDBi8P+AoRYwbMGLeSZ7bnvbmGTRA0tOcw==
X-Received: by 2002:aa7:cd4c:: with SMTP id v12mr9710419edw.155.1627311155520;
        Mon, 26 Jul 2021 07:52:35 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id l16sm12750753eje.67.2021.07.26.07.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 07:52:35 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] nfc: constify local pointer variables
Date:   Mon, 26 Jul 2021 16:52:21 +0200
Message-Id: <20210726145224.146006-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
References: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
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

