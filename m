Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA46E1F7FB7
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 01:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgFLXq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 19:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgFLXqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 19:46:24 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C8BC08C5C5
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:46:22 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ga6so4281581pjb.1
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sPZCJqVc3VD6afd7xeVx3YjOD3wIc/J7v0YJPBSoylE=;
        b=lcuSr3hS4k5aLLSKgmXkW/LobMkGihyN93NoxtdICodDkIleftkSl3TxXyf4CtsgMM
         9JJrmGdfeL0WCJKg/LRuCg42jUkMv5CXGjcgWTSpF0XikppJKnL06so1Hd7an3U1YKWT
         cQUJZARDuLv03cTDDoIMce3SxYkC2U/GZAclY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sPZCJqVc3VD6afd7xeVx3YjOD3wIc/J7v0YJPBSoylE=;
        b=XsKhC9Tpqsq0A8NqbJv/HxaCWdlFOJ3fFMH8jtVEVq0eyPr7RYI7sY00Ej3QmydEDV
         WHe0OUdWHzf27uFFrCHhQc28Y4VvkSenvGnQuDAs4VI8PwNG+4/cRm4vx50VApLyBY98
         EFG4qH2Q2d223B5nsMJeZoAjMIwWfndO0XZPOdHs/SPrYVRNwXgALvM03g9ndSiJBE20
         E7uOawKZjJSz+e/rlsp0czhZJqUXkdgCmAvnyInv2ny1LRTAeXqSKoAkjFnBjrATn1No
         oWeRDtA6bpgFF4zrSJOf62HK9SUm22OdLPBIOLUTxNjpI56Nd+Nr85aiiZzAyK2gUG7e
         XeVg==
X-Gm-Message-State: AOAM533lTKLeW3o5JL4Krh1Wdhukmf3UzMjDpQaaUgR6mBJWYRA7lquL
        bPoxs0XnN1FVt+Uro1XEW+nPWxKO+WQ=
X-Google-Smtp-Source: ABdhPJwZKG3kD4by+PeapJCV/S1whRjsjb71Wsm7yFU3/BtOC3DLfidb5BMvGxir4etSif7VJlZ04A==
X-Received: by 2002:a17:90a:ea84:: with SMTP id h4mr1109960pjz.45.1592005582350;
        Fri, 12 Jun 2020 16:46:22 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id b19sm6198639pjo.57.2020.06.12.16.46.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jun 2020 16:46:21 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 6/7] Bluetooth: Notify adv monitor removed event
Date:   Fri, 12 Jun 2020 16:45:55 -0700
Message-Id: <20200612164243.v4.6.If1a82f71eb63f969de3d5a5da03c2908b58a721a@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200612164243.v4.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200612164243.v4.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This notifies management sockets on MGMT_EV_ADV_MONITOR_REMOVED event.

The following test was performed.
- Start two btmgmt consoles, issue a btmgmt advmon-remove command on one
console and observe a MGMT_EV_ADV_MONITOR_REMOVED event on the other.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v4: None
Changes in v3:
- Convert the endianness of the returned handle.

Changes in v2: None

 net/bluetooth/mgmt.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 0a1e89ce75eae..325e528a1773e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -156,6 +156,7 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_PHY_CONFIGURATION_CHANGED,
 	MGMT_EV_EXP_FEATURE_CHANGED,
 	MGMT_EV_ADV_MONITOR_ADDED,
+	MGMT_EV_ADV_MONITOR_REMOVED,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -3864,6 +3865,16 @@ static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
 	mgmt_event(MGMT_EV_ADV_MONITOR_ADDED, hdev, &ev, sizeof(ev), sk);
 }
 
+static void mgmt_adv_monitor_removed(struct sock *sk, struct hci_dev *hdev,
+				     u16 handle)
+{
+	struct mgmt_ev_adv_monitor_added ev;
+
+	ev.monitor_handle = cpu_to_le16(handle);
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_REMOVED, hdev, &ev, sizeof(ev), sk);
+}
+
 static int read_adv_monitor_features(struct sock *sk, struct hci_dev *hdev,
 				     void *data, u16 len)
 {
@@ -4016,12 +4027,15 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 {
 	struct mgmt_cp_remove_adv_monitor *cp = data;
 	struct mgmt_rp_remove_adv_monitor rp;
+	unsigned int prev_adv_monitors_cnt;
 	int err;
 
 	BT_DBG("request for %s", hdev->name);
 
 	hci_dev_lock(hdev);
 
+	prev_adv_monitors_cnt = hdev->adv_monitors_cnt;
+
 	err = hci_remove_adv_monitor(hdev, __le16_to_cpu(cp->monitor_handle));
 	if (err == -ENOENT) {
 		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
@@ -4029,6 +4043,9 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	if (hdev->adv_monitors_cnt < prev_adv_monitors_cnt)
+		mgmt_adv_monitor_removed(sk, hdev, cp->monitor_handle);
+
 	hci_dev_unlock(hdev);
 
 	rp.monitor_handle = cp->monitor_handle;
-- 
2.26.2

