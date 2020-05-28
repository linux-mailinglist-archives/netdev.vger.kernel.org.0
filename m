Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977581E70E7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437901AbgE1Xza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437888AbgE1XzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:55:23 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F1EC08C5CB
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:22 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 64so46814pfg.8
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LSWv1a2AYReRskzQvhkBjb0iSRTTIV4DxJjMfd48OhE=;
        b=UrA0iTOg50gC1alITZzEJ6olAVG678EysBccbqjAu151WV3kA2E3Ic4n3xREiYuk7Q
         nX4GVIdLj0wIn8TQgeDfk7HxT+1NtiLAI3znKquhbXuQHdnKLBpjXN9GXm+Ts9xpEwxh
         APYzmKkvevneVIammCUCUjT9n+jC20Q1RR8W0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LSWv1a2AYReRskzQvhkBjb0iSRTTIV4DxJjMfd48OhE=;
        b=ppTAfGucxZqP39QNMQejwVARLQEnDLftN0uyV/l+I404pimDnv/dl2bWcclt8ZPzmt
         sc5r26TMmpL9D0E432SnwZoTe/ru+5J3XpR9CcwJp1GH5ntD38vCvE+yrTi5hdIkEV0O
         YjSzzLikXponMtxvI9Sv48WkcBz8pD7sFPrEq2O+LlHTvfIPTw2I1p5D6BhdPT+v8Oht
         4/WWUWKbSgllPEqPJqvRHmL6F52vAxVEPnB9fKjXtVv7TG+TsSWfjEtYp2+hGkWnTSQb
         GNrBQjCu8fXLmP13l06Vi2HmH5T4wkM1H4ZoCP+LxFHJuoZPsD/K/jt6fD3THI6v+DBn
         l4Dw==
X-Gm-Message-State: AOAM530VxL6XKxuK8mlj91UTzO9I3suPdtd8+4jDH4qx6PxMpsOvsCel
        i8RiPlIq3r3OWkl3Ta9ausGyAg==
X-Google-Smtp-Source: ABdhPJwNtcpluriLpQr31e/YaMZi6+OJknFPwXzYeZEKpF/RvnoW5r+gNLrc1p9tmAMewkkq26eetw==
X-Received: by 2002:a62:640b:: with SMTP id y11mr6032255pfb.318.1590710122085;
        Thu, 28 May 2020 16:55:22 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id f18sm5022591pga.75.2020.05.28.16.55.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 16:55:21 -0700 (PDT)
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
Subject: [PATCH v1 5/7] Bluetooth: Notify adv monitor added event
Date:   Thu, 28 May 2020 16:54:53 -0700
Message-Id: <20200528165324.v1.5.Idb2c6bf4deb8728c363c3938b1d33057e07ca9c9@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
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

 net/bluetooth/mgmt.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 710ec00219a0b..da65b6ab2e3a0 100644
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
+	ev.monitor_handle = handle;
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_ADDED, hdev, &ev, sizeof(ev), sk);
+}
+
 static int read_adv_monitor_features(struct sock *sk, struct hci_dev *hdev,
 				     void *data, u16 len)
 {
@@ -3903,8 +3914,8 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 	struct mgmt_rp_add_adv_patterns_monitor rp;
 	struct adv_monitor *m = NULL;
 	struct adv_pattern *p = NULL;
+	unsigned int mp_cnt = 0, prev_adv_monitors_cnt;
 	__u8 cp_ofst = 0, cp_len = 0;
-	unsigned int mp_cnt = 0;
 	int err, i;
 
 	BT_DBG("request for %s", hdev->name);
@@ -3968,6 +3979,8 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 
 	hci_dev_lock(hdev);
 
+	prev_adv_monitors_cnt = hdev->adv_monitors_cnt;
+
 	err = hci_add_adv_monitor(hdev, m);
 	if (err) {
 		if (err == -ENOSPC) {
@@ -3978,6 +3991,9 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	if (hdev->adv_monitors_cnt > prev_adv_monitors_cnt)
+		mgmt_adv_monitor_added(sk, hdev, m->handle);
+
 	hci_dev_unlock(hdev);
 
 	rp.monitor_handle = m->handle;
-- 
2.26.2

