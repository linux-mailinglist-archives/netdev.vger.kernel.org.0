Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3350C408E3A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbhIMNai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:30:38 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:57710
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240932AbhIMNV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:21:59 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 366C340265
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539243;
        bh=cs5MWRb4M9tfwP6GV7LH4BPGBlEq/OdD8zQOU93qEGI=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=GR2bePmaj7WHRMOQZOKKwFcDtvnGOv/9VUhFeeLXGdOdqkXbZIiMb6ny7QWE1AOiT
         l10/BEycIVdvCBpfDvCDq4gQmE8kSXgSdgM46gmKQkn7c7nbRR1X9HFUvaX1iklwgL
         D1xAYPXbQ2arKr99yIySoVAGblH9FdIUhKqt1nlE/TqgI0Vis2d8l+c0uSzkOOwxV9
         xfmoMIpXAf7+Vy4kdDldl6mWyUcnG1KLowWywtscEvpC07opVhLix1et5OJLDB2vYu
         hmU4IoohS4n/DjMFGwB5YXlyfwBJBfgTwbxPTmBGbXksifdxv63j2zIaJV7dx5xvXk
         /s3MRhHBPMl3A==
Received: by mail-wr1-f70.google.com with SMTP id q14-20020a5d574e000000b00157b0978ddeso2656489wrw.5
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cs5MWRb4M9tfwP6GV7LH4BPGBlEq/OdD8zQOU93qEGI=;
        b=F1ac1X8CiJ3OqgWTRRRf20Mew2QBfO11j2Pdipp10nS0/XgqG+Ae4ItHAqwc1howSb
         ssY0WJfYUKOV+WaoDiRo8c7Lxz+eL/ap2vU82sk6mFWwtmt3FpA6RWrVYwVASrgry32f
         86kSiYQDOmWgikImJsc69Hi84GPtRAgX5ZjXle/R8ajxjtTLgpUaCQt7XQkxZWFhQB/U
         8qBlj/gZzyLfO22ku7SjWcUa7p12aF8/Sx44oSQKyWzJFXTpT781gzkcdLrW1ED+Krln
         VYdpbt8RKHF+kWT7yLGVCvrmWnYPz7bja4TEWaXoQPV7LB+y/4JjuCfz1ONo8ryyM5eS
         xSGg==
X-Gm-Message-State: AOAM531l3D1ua8KN2xHLxhdt0J7QpBbKJBZFbeOrIDqEuXpiOr4OhNt9
        EKyx3ese3sqqpIUyTrDCA2pJySafBeVAvglKf6iltRKx+92AEPkbo8k3VTPRQGa2uD8Hiwkw/l2
        MbNR1LBx0zkLG8AJkccrkbsKpRo5Qa1gL9Q==
X-Received: by 2002:adf:b319:: with SMTP id j25mr8069924wrd.256.1631539242741;
        Mon, 13 Sep 2021 06:20:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5v4bayWSPxe/obNJPWhLd/yMiByG5JX8dkQyRTvyg7xiWBHVKbEBAdMX4lrRhGZ+UcTaROg==
X-Received: by 2002:adf:b319:: with SMTP id j25mr8069894wrd.256.1631539242510;
        Mon, 13 Sep 2021 06:20:42 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:20:41 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 01/15] nfc: drop unneeded debug prints
Date:   Mon, 13 Sep 2021 15:20:21 +0200
Message-Id: <20210913132035.242870-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ftrace is a preferred and standard way to debug entering and exiting
functions so drop useless debug prints.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/hci/command.c   | 16 ----------------
 net/nfc/hci/llc_shdlc.c | 12 ------------
 net/nfc/llcp_commands.c |  8 --------
 net/nfc/llcp_core.c     |  5 +----
 net/nfc/nci/core.c      |  4 ----
 net/nfc/nci/hci.c       |  4 ----
 net/nfc/nci/ntf.c       |  9 ---------
 7 files changed, 1 insertion(+), 57 deletions(-)

diff --git a/net/nfc/hci/command.c b/net/nfc/hci/command.c
index 3a89bd9b89fc..af6bacb3ba98 100644
--- a/net/nfc/hci/command.c
+++ b/net/nfc/hci/command.c
@@ -114,8 +114,6 @@ int nfc_hci_send_cmd(struct nfc_hci_dev *hdev, u8 gate, u8 cmd,
 {
 	u8 pipe;
 
-	pr_debug("\n");
-
 	pipe = hdev->gate2pipe[gate];
 	if (pipe == NFC_HCI_INVALID_PIPE)
 		return -EADDRNOTAVAIL;
@@ -130,8 +128,6 @@ int nfc_hci_send_cmd_async(struct nfc_hci_dev *hdev, u8 gate, u8 cmd,
 {
 	u8 pipe;
 
-	pr_debug("\n");
-
 	pipe = hdev->gate2pipe[gate];
 	if (pipe == NFC_HCI_INVALID_PIPE)
 		return -EADDRNOTAVAIL;
@@ -205,8 +201,6 @@ static int nfc_hci_open_pipe(struct nfc_hci_dev *hdev, u8 pipe)
 
 static int nfc_hci_close_pipe(struct nfc_hci_dev *hdev, u8 pipe)
 {
-	pr_debug("\n");
-
 	return nfc_hci_execute_cmd(hdev, pipe, NFC_HCI_ANY_CLOSE_PIPE,
 				   NULL, 0, NULL);
 }
@@ -242,8 +236,6 @@ static u8 nfc_hci_create_pipe(struct nfc_hci_dev *hdev, u8 dest_host,
 
 static int nfc_hci_delete_pipe(struct nfc_hci_dev *hdev, u8 pipe)
 {
-	pr_debug("\n");
-
 	return nfc_hci_execute_cmd(hdev, NFC_HCI_ADMIN_PIPE,
 				   NFC_HCI_ADM_DELETE_PIPE, &pipe, 1, NULL);
 }
@@ -256,8 +248,6 @@ static int nfc_hci_clear_all_pipes(struct nfc_hci_dev *hdev)
 	/* TODO: Find out what the identity reference data is
 	 * and fill param with it. HCI spec 6.1.3.5 */
 
-	pr_debug("\n");
-
 	if (test_bit(NFC_HCI_QUIRK_SHORT_CLEAR, &hdev->quirks))
 		param_len = 0;
 
@@ -271,8 +261,6 @@ int nfc_hci_disconnect_gate(struct nfc_hci_dev *hdev, u8 gate)
 	int r;
 	u8 pipe = hdev->gate2pipe[gate];
 
-	pr_debug("\n");
-
 	if (pipe == NFC_HCI_INVALID_PIPE)
 		return -EADDRNOTAVAIL;
 
@@ -296,8 +284,6 @@ int nfc_hci_disconnect_all_gates(struct nfc_hci_dev *hdev)
 {
 	int r;
 
-	pr_debug("\n");
-
 	r = nfc_hci_clear_all_pipes(hdev);
 	if (r < 0)
 		return r;
@@ -314,8 +300,6 @@ int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate,
 	bool pipe_created = false;
 	int r;
 
-	pr_debug("\n");
-
 	if (pipe == NFC_HCI_DO_NOT_CREATE_PIPE)
 		return 0;
 
diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index aef750d7787c..78b2ceb8ae6e 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -365,8 +365,6 @@ static int llc_shdlc_connect_initiate(const struct llc_shdlc *shdlc)
 {
 	struct sk_buff *skb;
 
-	pr_debug("\n");
-
 	skb = llc_shdlc_alloc_skb(shdlc, 2);
 	if (skb == NULL)
 		return -ENOMEM;
@@ -381,8 +379,6 @@ static int llc_shdlc_connect_send_ua(const struct llc_shdlc *shdlc)
 {
 	struct sk_buff *skb;
 
-	pr_debug("\n");
-
 	skb = llc_shdlc_alloc_skb(shdlc, 0);
 	if (skb == NULL)
 		return -ENOMEM;
@@ -573,8 +569,6 @@ static void llc_shdlc_connect_timeout(struct timer_list *t)
 {
 	struct llc_shdlc *shdlc = from_timer(shdlc, t, connect_timer);
 
-	pr_debug("\n");
-
 	schedule_work(&shdlc->sm_work);
 }
 
@@ -601,8 +595,6 @@ static void llc_shdlc_sm_work(struct work_struct *work)
 	struct llc_shdlc *shdlc = container_of(work, struct llc_shdlc, sm_work);
 	int r;
 
-	pr_debug("\n");
-
 	mutex_lock(&shdlc->state_mutex);
 
 	switch (shdlc->state) {
@@ -686,8 +678,6 @@ static int llc_shdlc_connect(struct llc_shdlc *shdlc)
 {
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(connect_wq);
 
-	pr_debug("\n");
-
 	mutex_lock(&shdlc->state_mutex);
 
 	shdlc->state = SHDLC_CONNECTING;
@@ -706,8 +696,6 @@ static int llc_shdlc_connect(struct llc_shdlc *shdlc)
 
 static void llc_shdlc_disconnect(struct llc_shdlc *shdlc)
 {
-	pr_debug("\n");
-
 	mutex_lock(&shdlc->state_mutex);
 
 	shdlc->state = SHDLC_DISCONNECTED;
diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 3c4172a5aeb5..41e3a20c8935 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -337,8 +337,6 @@ int nfc_llcp_send_disconnect(struct nfc_llcp_sock *sock)
 	struct nfc_dev *dev;
 	struct nfc_llcp_local *local;
 
-	pr_debug("Sending DISC\n");
-
 	local = sock->local;
 	if (local == NULL)
 		return -ENODEV;
@@ -362,8 +360,6 @@ int nfc_llcp_send_symm(struct nfc_dev *dev)
 	struct nfc_llcp_local *local;
 	u16 size = 0;
 
-	pr_debug("Sending SYMM\n");
-
 	local = nfc_llcp_find_local(dev);
 	if (local == NULL)
 		return -ENODEV;
@@ -399,8 +395,6 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 	u16 size = 0;
 	__be16 miux;
 
-	pr_debug("Sending CONNECT\n");
-
 	local = sock->local;
 	if (local == NULL)
 		return -ENODEV;
@@ -475,8 +469,6 @@ int nfc_llcp_send_cc(struct nfc_llcp_sock *sock)
 	u16 size = 0;
 	__be16 miux;
 
-	pr_debug("Sending CC\n");
-
 	local = sock->local;
 	if (local == NULL)
 		return -ENODEV;
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index eaeb2b1cfa6a..5ad5157aa9c5 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -45,8 +45,6 @@ static void nfc_llcp_socket_purge(struct nfc_llcp_sock *sock)
 	struct nfc_llcp_local *local = sock->local;
 	struct sk_buff *s, *tmp;
 
-	pr_debug("%p\n", &sock->sk);
-
 	skb_queue_purge(&sock->tx_queue);
 	skb_queue_purge(&sock->tx_pending_queue);
 
@@ -1505,9 +1503,8 @@ void nfc_llcp_recv(void *data, struct sk_buff *skb, int err)
 {
 	struct nfc_llcp_local *local = (struct nfc_llcp_local *) data;
 
-	pr_debug("Received an LLCP PDU\n");
 	if (err < 0) {
-		pr_err("err %d\n", err);
+		pr_err("LLCP PDU receive err %d\n", err);
 		return;
 	}
 
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 82ab39d80726..6fd873aa86be 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -930,8 +930,6 @@ static void nci_deactivate_target(struct nfc_dev *nfc_dev,
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	unsigned long nci_mode = NCI_DEACTIVATE_TYPE_IDLE_MODE;
 
-	pr_debug("entry\n");
-
 	if (!ndev->target_active_prot) {
 		pr_err("unable to deactivate target, no active target\n");
 		return;
@@ -977,8 +975,6 @@ static int nci_dep_link_down(struct nfc_dev *nfc_dev)
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	int rc;
 
-	pr_debug("entry\n");
-
 	if (nfc_dev->rf_mode == NFC_RF_INITIATOR) {
 		nci_deactivate_target(nfc_dev, NULL, NCI_DEACTIVATE_TYPE_IDLE_MODE);
 	} else {
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index e199912ee1e5..19703a649b5a 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -432,8 +432,6 @@ void nci_hci_data_received_cb(void *context,
 	struct sk_buff *frag_skb;
 	int msg_len;
 
-	pr_debug("\n");
-
 	if (err) {
 		nci_req_complete(ndev, err);
 		return;
@@ -547,8 +545,6 @@ static u8 nci_hci_create_pipe(struct nci_dev *ndev, u8 dest_host,
 
 static int nci_hci_delete_pipe(struct nci_dev *ndev, u8 pipe)
 {
-	pr_debug("\n");
-
 	return nci_hci_send_cmd(ndev, NCI_HCI_ADMIN_GATE,
 				NCI_HCI_ADM_DELETE_PIPE, &pipe, 1, NULL);
 }
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index c5eacaac41ae..282c51051dcc 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -738,8 +738,6 @@ static void nci_nfcee_discover_ntf_packet(struct nci_dev *ndev,
 	const struct nci_nfcee_discover_ntf *nfcee_ntf =
 				(struct nci_nfcee_discover_ntf *)skb->data;
 
-	pr_debug("\n");
-
 	/* NFCForum NCI 9.2.1 HCI Network Specific Handling
 	 * If the NFCC supports the HCI Network, it SHALL return one,
 	 * and only one, NFCEE_DISCOVER_NTF with a Protocol type of
@@ -751,12 +749,6 @@ static void nci_nfcee_discover_ntf_packet(struct nci_dev *ndev,
 	nci_req_complete(ndev, status);
 }
 
-static void nci_nfcee_action_ntf_packet(struct nci_dev *ndev,
-					const struct sk_buff *skb)
-{
-	pr_debug("\n");
-}
-
 void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	__u16 ntf_opcode = nci_opcode(skb->data);
@@ -813,7 +805,6 @@ void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		break;
 
 	case NCI_OP_RF_NFCEE_ACTION_NTF:
-		nci_nfcee_action_ntf_packet(ndev, skb);
 		break;
 
 	default:
-- 
2.30.2

