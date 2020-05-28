Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91ED41E70E9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437907AbgE1Xze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437889AbgE1Xz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:55:26 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D1AC08C5C9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:24 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bg4so257077plb.3
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z3Ddd9xAVc9PvNCd/pKZsNEG7UV+4uuv8lSwcrZKJdw=;
        b=NcTzCDqWPedxY47On0jdVEO1c82MGzc8Tcu85w8/J9aokJSb0sbSxQytxwTVzjTGPX
         pndqi6qLYF7OOYElty89Qrs0odbtWr2On2ynzGtAmOwueuER6l9CtN6aeT8GE+oSbD3/
         XskSo3quj4AiaI3RYYIsxQApcy9yq8jhfYv8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z3Ddd9xAVc9PvNCd/pKZsNEG7UV+4uuv8lSwcrZKJdw=;
        b=dMTHK9qxQQvfbQBFWOf1YbAAf57NFq6RWgB/FnsU1y7b3i6wOZIOy1JCaR2R7Ea1Va
         y67clDC3RcfSb+aq+W7P6xZy+hzIDpsjEDFHyZrucAZz+nD8/JxAoqzR7MOpHDgrV1Uk
         PaJyhJU1aC2TYCQH4vMHvnr/z7XwpMYVRQ1T6yFQPEr9ozpZrWaal3Vp787j+E4fLk5Y
         TJ7fcgB1BiGhL8u3Bd2YPCveamPxe7CICoqlsVbuyjmiLl5dg23Sjt8NS1oHx0Fwjeqp
         3IAN1KTdu+4XhvxPWhwElf6DUu/WHU/xKkHknQlqHV3kHfgIeKo+mxYagYmtJ4K6vEd9
         OCjA==
X-Gm-Message-State: AOAM533muyt/z7x7z9f3o4STiXDWU3GYQnaRCqYPcdu4oMEwBFzFO4N7
        YA1l0fmYTjsAGMH6F5fAZfsp2g==
X-Google-Smtp-Source: ABdhPJwDjU58jgQyoww8wQ2KDcbOGC0Q7ZRxVe4RCLnIyv0STOahyAc/lGrOCuxFzMqBXez1zOz/SQ==
X-Received: by 2002:a17:902:aa4a:: with SMTP id c10mr6344331plr.0.1590710124106;
        Thu, 28 May 2020 16:55:24 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id f18sm5022591pga.75.2020.05.28.16.55.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 16:55:23 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Yoni Shavit <yshavit@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 6/7] Bluetooth: Notify adv monitor removed event
Date:   Thu, 28 May 2020 16:54:54 -0700
Message-Id: <20200528165324.v1.6.If1a82f71eb63f969de3d5a5da03c2908b58a721a@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
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

 net/bluetooth/mgmt.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index da65b6ab2e3a0..728d79663cbcf 100644
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
+	ev.monitor_handle = handle;
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_REMOVED, hdev, &ev, sizeof(ev), sk);
+}
+
 static int read_adv_monitor_features(struct sock *sk, struct hci_dev *hdev,
 				     void *data, u16 len)
 {
@@ -4014,12 +4025,15 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 {
 	struct mgmt_cp_remove_adv_monitor *cp = data;
 	struct mgmt_rp_remove_adv_monitor rp;
+	unsigned int prev_adv_monitors_cnt;
 	int err;
 
 	BT_DBG("request for %s", hdev->name);
 
 	hci_dev_lock(hdev);
 
+	prev_adv_monitors_cnt = hdev->adv_monitors_cnt;
+
 	err = hci_remove_adv_monitor(hdev, cp->monitor_handle);
 	if (err == -ENOENT) {
 		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
@@ -4027,6 +4041,9 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	if (hdev->adv_monitors_cnt < prev_adv_monitors_cnt)
+		mgmt_adv_monitor_removed(sk, hdev, cp->monitor_handle);
+
 	hci_dev_unlock(hdev);
 
 	rp.monitor_handle = cp->monitor_handle;
-- 
2.26.2

