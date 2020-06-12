Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9DF1F73C4
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 08:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgFLGQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 02:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgFLGPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 02:15:42 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C041FC08C5C6
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 23:15:42 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n2so3317953pld.13
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 23:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B/AHWNUq2hQO+UxX262IRskqa77C3GfCCHKEkjol6ks=;
        b=exZ6gq4jica7r1Am4MijAZBEmoV17NqQcQgJBgDTB2O7D/eIFqcS+QBv09tg+lpoX4
         4yo1vthRuvAuJoA+pjrPN3RhmCOry3XQAYhqxQqbsYkwnVGzXldC2S3UsDKayHHlOkkX
         zm716mYH2jX82WEfVBfoR6ixRw+Serj/6RX7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B/AHWNUq2hQO+UxX262IRskqa77C3GfCCHKEkjol6ks=;
        b=nYKDgZAlTyUD2GJRmfU6P8b84Bugl5wiUUijow/0dZE5X4qiocDZO7aFnM6DrjD8/Y
         QOWi5xnJF13dekqyDoTebiEGm5MHpIjnoA26xm83BBkas3Fd3UpwatM749aPUsnED/ut
         2JfJHweYOIW6XzbZjwY/foAolt1hg93JBqGk+sVuENU4pEyiy5DolNHp+1ldYqaXiCUv
         J+rUbNUuaw/szEkSysQFvscEWz9xSalPaQWu/1b4wvHfe5mUPs2Vo6qNw7ExsLfP400U
         45BC6duaYOhAf/aq9bIy4yvZwNv3ox2F6GUkPuywWO/laOEpvcgVlvGd+FdUKGpm2AJV
         deQw==
X-Gm-Message-State: AOAM530c0TSoFTmHybGl5oJ/+KGsha7Z+eiowKGaTPAbSMeLEJjovSuQ
        JeCp9ddEiA7lBDZHAlGSoW6KJQ==
X-Google-Smtp-Source: ABdhPJz8NU4IP8LCjEiHNcslLnkzsS225CV7pvoO8bQcuchT0N4rkCWqqcW8gUl2rbwYiD6sdOug/w==
X-Received: by 2002:a17:902:7408:: with SMTP id g8mr9559400pll.143.1591942542347;
        Thu, 11 Jun 2020 23:15:42 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id g6sm4933923pfb.164.2020.06.11.23.15.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 23:15:41 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Yoni Shavit <yshavit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 5/7] Bluetooth: Notify adv monitor added event
Date:   Thu, 11 Jun 2020 23:15:27 -0700
Message-Id: <20200611231459.v3.5.Idb2c6bf4deb8728c363c3938b1d33057e07ca9c9@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611231459.v3.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200611231459.v3.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This notifies management sockets on MGMT_EV_ADV_MONITOR_ADDED event.

The following test was performed.
- Start two btmgmt consoles, issue a btmgmt advmon-add command on one
console and observe a MGMT_EV_ADV_MONITOR_ADDED event on the other

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v3:
- Convert the endianness of the returned handle.

Changes in v2: None

 net/bluetooth/mgmt.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5dc47bba98a90..949964862c1b6 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -155,6 +155,7 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_EXT_INFO_CHANGED,
 	MGMT_EV_PHY_CONFIGURATION_CHANGED,
 	MGMT_EV_EXP_FEATURE_CHANGED,
+	MGMT_EV_ADV_MONITOR_ADDED,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -3853,6 +3854,16 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 			       MGMT_STATUS_NOT_SUPPORTED);
 }
 
+static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
+				   u16 handle)
+{
+	struct mgmt_ev_adv_monitor_added ev;
+
+	ev.monitor_handle = cpu_to_le16(handle);
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_ADDED, hdev, &ev, sizeof(ev), sk);
+}
+
 static int read_adv_monitor_features(struct sock *sk, struct hci_dev *hdev,
 				     void *data, u16 len)
 {
@@ -3905,8 +3916,8 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 	struct mgmt_rp_add_adv_patterns_monitor rp;
 	struct adv_monitor *m = NULL;
 	struct adv_pattern *p = NULL;
+	unsigned int mp_cnt = 0, prev_adv_monitors_cnt;
 	__u8 cp_ofst = 0, cp_len = 0;
-	unsigned int mp_cnt = 0;
 	int err, i;
 
 	BT_DBG("request for %s", hdev->name);
@@ -3970,6 +3981,8 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 
 	hci_dev_lock(hdev);
 
+	prev_adv_monitors_cnt = hdev->adv_monitors_cnt;
+
 	err = hci_add_adv_monitor(hdev, m);
 	if (err) {
 		if (err == -ENOSPC) {
@@ -3980,6 +3993,9 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	if (hdev->adv_monitors_cnt > prev_adv_monitors_cnt)
+		mgmt_adv_monitor_added(sk, hdev, m->handle);
+
 	hci_dev_unlock(hdev);
 
 	rp.monitor_handle = cpu_to_le16(m->handle);
-- 
2.26.2

