Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520AC256782
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 14:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgH2Mlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 08:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgH2MlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 08:41:24 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB74C061236;
        Sat, 29 Aug 2020 05:41:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id v16so921565plo.1;
        Sat, 29 Aug 2020 05:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=inoIGbEpmdL0eBcL/eTYO9DUL34BzxMhEi+RCO4Fy4w=;
        b=imNiGgPSNVHTgkyR65Ye2n6UFzxVcj5PC00bxL6M6q+QkbrDpme8p5sIT/vyPhC0Rq
         0dxinnsMKJVrNE1SjLHFTOoDLbD1QJAJZgdZ3q7qrbzNPv7wsToS3KpU7tXAgXsx6d1E
         oGa7IGk95kJJO22t/7UEbQd4W/4bxQnhJ7C4gFsmzsBXs12xF+b81gdBj12E5pj/pevH
         LESYfR8XTlIGXcMgStlwbMpa9g4bRSFoRk6K96cbLnXn/LPyt0WVKA3l57KQszLvmq8g
         8oqjDCEIMWiNb/uix5TTs2dt3S9LwISoMi/yF4JWed9HPyN3HW3zdWEttVexG7zGeSiM
         4gVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=inoIGbEpmdL0eBcL/eTYO9DUL34BzxMhEi+RCO4Fy4w=;
        b=eBsBXJc3FnOGspXnb1aNGlbTjXf2C+LFqlfDNNg4YjTwdsIaIx+yo6lk/d3PHVWGDt
         tJcrE2YppeCkdzP6L1ksVrW6y+v1t1pmqu8YQgHfgLCMkutns9u6ebvPI+MT6brd6e4q
         kGV7s+IBEl5/xuT7VxRfs1hh/IXF1rRhD5edMQIOtiYr7NKKScdqWMbeiW44gmfj8gCv
         VA6F8cxQ19KcM+t99hzjh5vBNPmbuIX5UAJ/6IUTBQDuf3yFst2emSe/DRzkysqjPNff
         7o9J6dClx3/7PWSHCvq0pmDOFD+JYgbRnxcgfaDU4vTFuA+mFv4O5OBjJumsBUQaWbbb
         MIvA==
X-Gm-Message-State: AOAM533lZQVyqgV18/JJRC7yx89E8p4Ik3Hz2tvV9oKDS9msQwtBp56R
        7G6D+7b5mY4dOG6rd8riqTA=
X-Google-Smtp-Source: ABdhPJz+NLb7HIW5P9DPG54Uwcs3btCpwTqxKPO7aqvpyIgUfuoteTuwfpl4q5WoZwqSBATciOhjNw==
X-Received: by 2002:a17:902:123:: with SMTP id 32mr2619323plb.143.1598704883743;
        Sat, 29 Aug 2020 05:41:23 -0700 (PDT)
Received: from localhost.localdomain ([45.118.165.148])
        by smtp.googlemail.com with ESMTPSA id t25sm2496901pfe.76.2020.08.29.05.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 05:41:22 -0700 (PDT)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anmol.karan123@gmail.com,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer deref in hci_phy_link_complete_evt
Date:   Sat, 29 Aug 2020 18:11:12 +0530
Message-Id: <20200829124112.227133-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix null pointer deref in hci_phy_link_complete_evt, there was no checking there for
the hcon->amp_mgr->l2cap_conn->hconn, and also in hci_cmd_work, for
hdev->sent_cmd. 

To fix this issue Add pointer checking in hci_cmd_work and
hci_phy_link_complete_evt.
[Linux-next-20200827]

Reported-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=0d93140da5a82305a66a136af99b088b75177b99
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
 net/bluetooth/hci_core.c  | 4 ++++
 net/bluetooth/hci_event.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 68bfe57b6625..533048d2a624 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4922,6 +4922,10 @@ static void hci_cmd_work(struct work_struct *work)
 
 		kfree_skb(hdev->sent_cmd);
 
+		if(hdev->sent_cmd) {
+			hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
+		}
+
 		hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
 		if (hdev->sent_cmd) {
 			if (hci_req_status_pend(hdev))
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4b7fc430793c..c621c8a20ea4 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4941,6 +4941,10 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
 		hci_dev_unlock(hdev);
 		return;
 	}
+	if(!(hcon->amp_mgr->l2cap_conn->hcon)) {
+		hci_dev_unlock(hdev);
+		return;
+	}
 
 	bredr_hcon = hcon->amp_mgr->l2cap_conn->hcon;
 
-- 
2.28.0

