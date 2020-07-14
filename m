Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F2921FFD6
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgGNVQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgGNVQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:16:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6955C08C5C1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:16:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x184so292905ybx.10
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HzEMpeAsA85Ww9OWf319/ckjyVKaoI/djE5Efi8rzCg=;
        b=kSx6jbza4TcJaMQAaLz2/vObPEtYak6vZaux2wv9qmAAIQRRBlDC+teIjl3cw0m/El
         RydhEHRbnFzZbdocR+vyyCnrL0+snaVFtJwuIbJr1Clvdb4dkL/puff33XrndB51HnM1
         8L89teW1qxyW/3BPCAvdY8PKR3oAIZBLVpmGMf/YqRkdruIdoga7xNRJ7d9vel/pjGzj
         3OuvJv9jXDJnRD+AbHUMxLbwiR2l6LK5dQsWGrjilwCNtB2vDbGjfltynnmjXtxsuDPT
         iiEOwIpCtNF32NiYiKM18iBpXlKlAvkr9xqytJ7AxnblUX+myhWQvs8/bSh51uOPgVSb
         B9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HzEMpeAsA85Ww9OWf319/ckjyVKaoI/djE5Efi8rzCg=;
        b=pTOW+lM2Gv3+4oWabaM5SFliudC2LDlhr9s8s0dyUZc7Q2pcEjeh6okA+n4JYU+QWE
         dHOZ/KRe8KT2OBcrkVkf25QFh51a6KgSSSDYVMfPHvkB92zZsSKXdM1b+7WFc2alO2eX
         khYpq897UNUwzi5PfwFnqLrX0Qh7j0XO+BwkeWTMSsvTjcbOYgJ08PLgPIUbo+/KXgm5
         M9MJ2BXLv7q2tUQ5uideGZR7wYQakBMaWYXUdhYouev87TpVaCBrb8qN6rPASmjdOkEn
         E5U3yPHWQGJYTee5PUa+X35/PDLNdG24g7U6V1ht9prCPhmkbL40NmVtS/UUT6SrlZlP
         TFrQ==
X-Gm-Message-State: AOAM533MQniXwtypZ6ZyOBxB5DGfavwKmLBiMGjmNOUQSLphjNrgeRF0
        DQSu4aQQ5Cy9R4jr5P17/0R/EBmqnCHKJz7eKGPk
X-Google-Smtp-Source: ABdhPJzhQxfr7YmLnLQTuyAFMguLsPYwrYEipp4TVDG1jwjXWfgiFWmBYjDjwuyfzpGJzDHivCEfhKH77tKI4eUU13ro
X-Received: by 2002:a25:2105:: with SMTP id h5mr10362528ybh.65.1594761365824;
 Tue, 14 Jul 2020 14:16:05 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:16:00 -0700
Message-Id: <20200714141547.v1.1.Icd35ad65fb4136d45dd701ef9022fa8f7c9e5d65@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH v1] Bluetooth: Add per-instance adv disable/remove
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Shyh-In Hwang <josephsih@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functionality to disable and remove advertising instances,
and use that functionality in MGMT add/remove advertising calls.

Signed-off-by: Daniel Winkler <danielwinkler@google.com>
Reviewed-by: Shyh-In Hwang <josephsih@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

 net/bluetooth/hci_conn.c    |  2 +-
 net/bluetooth/hci_request.c | 59 +++++++++++++++++++++++++++++++------
 net/bluetooth/hci_request.h |  2 ++
 net/bluetooth/mgmt.c        |  6 ++++
 4 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 8805d68e65f2a..be67361ff2f00 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -931,7 +931,7 @@ static void hci_req_directed_advertising(struct hci_request *req,
 		 * So it is required to remove adv set for handle 0x00. since we use
 		 * instance 0 for directed adv.
 		 */
-		hci_req_add(req, HCI_OP_LE_REMOVE_ADV_SET, sizeof(cp.handle), &cp.handle);
+		__hci_req_remove_ext_adv_instance(req, cp.handle);
 
 		hci_req_add(req, HCI_OP_LE_SET_EXT_ADV_PARAMS, sizeof(cp), &cp);
 
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 770b937581122..7c0c2fda04adf 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1179,13 +1179,8 @@ static u8 get_cur_adv_instance_scan_rsp_len(struct hci_dev *hdev)
 void __hci_req_disable_advertising(struct hci_request *req)
 {
 	if (ext_adv_capable(req->hdev)) {
-		struct hci_cp_le_set_ext_adv_enable cp;
+		__hci_req_disable_ext_adv_instance(req, 0x00);
 
-		cp.enable = 0x00;
-		/* Disable all sets since we only support one set at the moment */
-		cp.num_of_sets = 0x00;
-
-		hci_req_add(req, HCI_OP_LE_SET_EXT_ADV_ENABLE, sizeof(cp), &cp);
 	} else {
 		u8 enable = 0x00;
 
@@ -1950,13 +1945,59 @@ int __hci_req_enable_ext_advertising(struct hci_request *req, u8 instance)
 	return 0;
 }
 
+int __hci_req_disable_ext_adv_instance(struct hci_request *req, u8 instance)
+{
+	struct hci_dev *hdev = req->hdev;
+	struct hci_cp_le_set_ext_adv_enable *cp;
+	struct hci_cp_ext_adv_set *adv_set;
+	u8 data[sizeof(*cp) + sizeof(*adv_set) * 1];
+	u8 req_size;
+
+	/* If request specifies an instance that doesn't exist, fail */
+	if (instance > 0 && !hci_find_adv_instance(hdev, instance))
+		return -EINVAL;
+
+	memset(data, 0, sizeof(data));
+
+	cp = (void *)data;
+	adv_set = (void *)cp->data;
+
+	/* Instance 0x00 indicates all advertising instances will be disabled */
+	cp->num_of_sets = !!instance;
+	cp->enable = 0x00;
+
+	adv_set->handle = instance;
+
+	req_size = sizeof(*cp) + sizeof(*adv_set) * cp->num_of_sets;
+	hci_req_add(req, HCI_OP_LE_SET_EXT_ADV_ENABLE, req_size, data);
+
+	return 0;
+}
+
+int __hci_req_remove_ext_adv_instance(struct hci_request *req, u8 instance)
+{
+	struct hci_dev *hdev = req->hdev;
+
+	/* If request specifies an instance that doesn't exist, fail */
+	if (instance > 0 && !hci_find_adv_instance(hdev, instance))
+		return -EINVAL;
+
+	hci_req_add(req, HCI_OP_LE_REMOVE_ADV_SET, sizeof(instance), &instance);
+
+	return 0;
+}
+
 int __hci_req_start_ext_adv(struct hci_request *req, u8 instance)
 {
 	struct hci_dev *hdev = req->hdev;
+	struct adv_info *adv_instance = hci_find_adv_instance(hdev, instance);
 	int err;
 
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
-		__hci_req_disable_advertising(req);
+	/* If instance isn't pending, the chip knows about it, and it's safe to
+	 * disable
+	 */
+	if (adv_instance && !adv_instance->pending)
+		__hci_req_disable_ext_adv_instance(req, instance);
 
 	err = __hci_req_setup_ext_adv_instance(req, instance);
 	if (err < 0)
@@ -2104,7 +2145,7 @@ void hci_req_clear_adv_instance(struct hci_dev *hdev, struct sock *sk,
 	    hci_dev_test_flag(hdev, HCI_ADVERTISING))
 		return;
 
-	if (next_instance)
+	if (next_instance && !ext_adv_capable(hdev))
 		__hci_req_schedule_adv_instance(req, next_instance->instance,
 						false);
 }
diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
index 0e81614d235e9..bbe892ab078ab 100644
--- a/net/bluetooth/hci_request.h
+++ b/net/bluetooth/hci_request.h
@@ -86,6 +86,8 @@ void hci_req_clear_adv_instance(struct hci_dev *hdev, struct sock *sk,
 int __hci_req_setup_ext_adv_instance(struct hci_request *req, u8 instance);
 int __hci_req_start_ext_adv(struct hci_request *req, u8 instance);
 int __hci_req_enable_ext_advertising(struct hci_request *req, u8 instance);
+int __hci_req_disable_ext_adv_instance(struct hci_request *req, u8 instance);
+int __hci_req_remove_ext_adv_instance(struct hci_request *req, u8 instance);
 void __hci_req_clear_ext_adv_sets(struct hci_request *req);
 int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 			   bool use_rpa, struct adv_info *adv_instance,
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 686ef47928316..f45105d2de772 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7504,6 +7504,12 @@ static int remove_advertising(struct sock *sk, struct hci_dev *hdev,
 
 	hci_req_init(&req, hdev);
 
+	/* If we use extended advertising, instance is disabled and removed */
+	if (ext_adv_capable(hdev)) {
+		__hci_req_disable_ext_adv_instance(&req, cp->instance);
+		__hci_req_remove_ext_adv_instance(&req, cp->instance);
+	}
+
 	hci_req_clear_adv_instance(hdev, sk, &req, cp->instance, true);
 
 	if (list_empty(&hdev->adv_instances))
-- 
2.27.0.389.gc38d7665816-goog

