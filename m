Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CA4256935
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 18:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgH2Q50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 12:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728403AbgH2Q5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 12:57:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9D1C061236;
        Sat, 29 Aug 2020 09:57:23 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id z18so979728pjr.2;
        Sat, 29 Aug 2020 09:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JNi5HVcJ7yBT6DVF4xqHEm9pH1OJge9gkwZUJEYG2kc=;
        b=MNYxsNt6X9itvJUV8tku0XRaO2RkCQBN/mLZewjUf+5xA4M+6/yPPdjtQMeC03rKJ9
         /vBExQZIZEJ/8mNV+ATN2E3odhetvXRn7l9QyHP8+42rI56Lfe/pZyP7hzOJcp7nviGZ
         eV2wAYm2MIa0odEJKZOwYx5+dWqyhYy7c7gfzZvpF+6sArgdZWX43/5Td5xSSdadBQAI
         UqLS7vU+WQBQB33Y+fG73wRdTYAzCwZC6P+Cw3zj6uciFZgLsWtKw3pLiKGDy0tPj18t
         HZYa8ri3GqKOo9xgNfDTnVzZPj5A3ouYyVOBecWIQ3cHMy6md3gCkWSEW7fZ2M+731WJ
         st0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNi5HVcJ7yBT6DVF4xqHEm9pH1OJge9gkwZUJEYG2kc=;
        b=sl77v/v24McA3OEHQ6zgmMf5MX129/FsSNPVqKA4Gr52DpC3LfjDW8pod+uTiJOnqz
         SQG3qFm7xQle4AblQBmpChp3udSmJqQ6EIZjOkEJFKS9t3JfKwsgjQK+E/NRovbpHlaY
         8uHly7JKBWdvFNOd2zQUhpUhVuou58XJ/njk2wmmqvHBzW8aSqgtUXS41a94SsSuN+ZG
         5uI3VX/H3fMD2Gg3rkI1UesxgVP1+BpCXgSGNLCst2NG7X0In5pz0I4sD/rs3GRxbksg
         yyid59ryZfsMfn4xpciAIrIVvOViT8X9djF1rPNlUtnIDbX5SXrdw5xzkIGDmc56lxkG
         iibQ==
X-Gm-Message-State: AOAM533FNGIS35fsr/iBp4dEGdc+bGS7WD8HcelcGOC/ZI2UgxlBYDx/
        GpwkADH+Kjrr/mBrD18y8Lw=
X-Google-Smtp-Source: ABdhPJyJ2xh7VLE9WxChS1XpbZ+c5kNddCKSHHWbjfZPxZl64QPAKow+8XMyVaErBkNl9etlMM2aog==
X-Received: by 2002:a17:90b:238d:: with SMTP id mr13mr3474738pjb.132.1598720242628;
        Sat, 29 Aug 2020 09:57:22 -0700 (PDT)
Received: from localhost.localdomain ([45.118.165.144])
        by smtp.googlemail.com with ESMTPSA id a200sm3217970pfd.182.2020.08.29.09.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 09:57:21 -0700 (PDT)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anmol.karan123@gmail.com,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer deref in hci_phy_link_complete_evt
Date:   Sat, 29 Aug 2020 22:27:12 +0530
Message-Id: <20200829165712.229437-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200829124112.227133-1-anmol.karan123@gmail.com>
References: <20200829124112.227133-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix null pointer deref in hci_phy_link_complete_evt, there was no 
checking there for the hcon->amp_mgr->l2cap_conn->hconn, and also 
in hci_cmd_work, for hdev->sent_cmd.

To fix this issue Add pointer checking in hci_cmd_work and
hci_phy_link_complete_evt.
[Linux-next-20200827]

This patch corrected some mistakes from previous patch.

Reported-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=0d93140da5a82305a66a136af99b088b75177b99
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
 net/bluetooth/hci_core.c  | 5 ++++-
 net/bluetooth/hci_event.c | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 68bfe57b6625..996efd654e7a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4922,7 +4922,10 @@ static void hci_cmd_work(struct work_struct *work)
 
 		kfree_skb(hdev->sent_cmd);
 
-		hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
+		if (hdev->sent_cmd) {
+			hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
+		}
+
 		if (hdev->sent_cmd) {
 			if (hci_req_status_pend(hdev))
 				hci_dev_set_flag(hdev, HCI_CMD_PENDING);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4b7fc430793c..1e7d9bee9111 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4941,6 +4941,10 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
 		hci_dev_unlock(hdev);
 		return;
 	}
+	if (!(hcon->amp_mgr->l2cap_conn->hcon)) {
+		hci_dev_unlock(hdev);
+		return;
+	}
 
 	bredr_hcon = hcon->amp_mgr->l2cap_conn->hcon;
 
-- 
2.28.0

