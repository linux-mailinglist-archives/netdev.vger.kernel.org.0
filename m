Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE21A1FA511
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 02:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgFPAZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 20:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbgFPAZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 20:25:19 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0137AC08C5C3
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 17:25:18 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a127so8616830pfa.12
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 17:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=awD337CBHyYdSueStD1GXtB0uBoMw71o8ikTZfEl/T8=;
        b=jT5IqgddoepqoTXi1PgtAUNM2UBaXwxr+oCyyEuKZYhGqCPjBSJ1pXsEc8ZJCWpcml
         a0zd7wf4YfIVsxfIBXl8eX1fsf2NzQtzlzjPlaOxAkx7FmBNv4msQrbdmvP88ZR//Uou
         7WwiIT+C1lf22okY5wtvNiXwmfrFg5+Fm/44w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=awD337CBHyYdSueStD1GXtB0uBoMw71o8ikTZfEl/T8=;
        b=ghpaFdgXYphg/kaPagb+xLtKdb3BLsI5AkHRkhu31yN31oku7fA8PYDF1t6/NT/9qh
         G1Aj8PW1HmYwcAUyw8GTvh1uPJje2CiYJABNCPVhLfPxFRF3NIIWu4n8aUrA1IJdNvBF
         pNbYODybeHbYoQgUY59DSbr0tnXKr8vQwRAmlL+QwFnSvfVjera42UlgFaHewJFcrQwL
         eyKsca9MueUYPke22iETe1Rkb/rL5yX9T+WAvIw8QbCMZQdMOkJ3e/iWkrIC3nWj2hGT
         jzS8Xber3sq3GvGSWz7/kJgK7P4oyQl3Ybm2FFjW0Xb3z4CgQfcXoD85Fr3ZmsIgBfsg
         kqaA==
X-Gm-Message-State: AOAM532ukAdb7AEIhaRz3AmuuUkFGDH/dyKPK4Hxp77qOYMAqkVJMMKY
        CZpIoqkTYE08hkYVEi6EWMPlSA==
X-Google-Smtp-Source: ABdhPJy9Ja7JFzS0zZuNTCBAJH/wdxBzeXeGLz3CsuXbZzW05pM3l2CKs4u0QPD5SyBCFjb6KzSGrg==
X-Received: by 2002:a63:c50:: with SMTP id 16mr87071pgm.143.1592267117577;
        Mon, 15 Jun 2020 17:25:17 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id x2sm14783781pfr.186.2020.06.15.17.25.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 17:25:16 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 6/7] Bluetooth: Notify adv monitor removed event
Date:   Mon, 15 Jun 2020 17:25:04 -0700
Message-Id: <20200615172440.v5.6.If1a82f71eb63f969de3d5a5da03c2908b58a721a@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
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

Changes in v5:
- Fix warnings.

Changes in v4: None
Changes in v3:
- Convert the endianness of the returned handle.

Changes in v2: None

 net/bluetooth/mgmt.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index f4dffd06c3aa2..fed9c17b90dc9 100644
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
@@ -4016,6 +4027,7 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 {
 	struct mgmt_cp_remove_adv_monitor *cp = data;
 	struct mgmt_rp_remove_adv_monitor rp;
+	unsigned int prev_adv_monitors_cnt;
 	u16 handle;
 	int err;
 
@@ -4024,6 +4036,7 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 	hci_dev_lock(hdev);
 
 	handle = __le16_to_cpu(cp->monitor_handle);
+	prev_adv_monitors_cnt = hdev->adv_monitors_cnt;
 
 	err = hci_remove_adv_monitor(hdev, handle);
 	if (err == -ENOENT) {
@@ -4032,6 +4045,9 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	if (hdev->adv_monitors_cnt < prev_adv_monitors_cnt)
+		mgmt_adv_monitor_removed(sk, hdev, handle);
+
 	hci_dev_unlock(hdev);
 
 	rp.monitor_handle = cp->monitor_handle;
-- 
2.26.2

