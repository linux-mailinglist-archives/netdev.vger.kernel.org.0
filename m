Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF84727D489
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgI2Rcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2Rct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:32:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89380C061755;
        Tue, 29 Sep 2020 10:32:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z19so5241330pfn.8;
        Tue, 29 Sep 2020 10:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xf7UYd55bBypBMw3nNJvaFu6tO4OkMryDnkxOfP4mCQ=;
        b=L3b+sbb1ZAJZvbidh3Qs2l8xQ/zyz/rGbhWqi3+dHNjqGS9VFkuw2TcY05NlVObSlS
         C7D93tqsTEzDPJzm0/8tb55prGjb/hfPt9tkKWScgCxv8xgPsJheyuFlzoy3MwPjh9++
         Uw2KIcbqIN4Gz1PPBd7Z2WvnQz7WPp7PVXx6/iRnA6OpUP7T4vpqhUzdGnnl9HCM9RoE
         8jWIA1WJilZ34mDpIlpYNTxjEiRUpC/atZuqfVDWjfjMzvVlGjZHFr/opJa9iqJYAXQ0
         4uFaYeiu89+ESDndbe10lndLfbPEiuLssadC518emRGFzU1gOf0YmI/UC7maKLgLremH
         nLWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xf7UYd55bBypBMw3nNJvaFu6tO4OkMryDnkxOfP4mCQ=;
        b=aq51k6AxnIDoqwt/8PUMxJhc/tqeKpl2PkMWGIPCLO4HMzH0NUwcrsgkFy+uYz+umu
         0sDKJmabhD6v3vY3GOO+FDWgs4vSQtjzgGo3F7l0kuDnPZREIPwZxe3Ztj7hkPFZeaTL
         0M06UKrIkxpSl73mkV7ts6nsmvN3X0JaUQIJZF2s+GOFi0Mx9Zgh55aOt07fxbffgHF0
         QZfgvbqH7C3QVGLwrjo+ZdieOF79R8PBduFyp5OmXzq7Vn1214tYHRoauysvJAxoykg2
         aXgV15M+xNBqaI/roxiWJi30uhdmJCaapCrHL9WcQ6OTdByOIbEU+x7aSy8YmU3jWaku
         Tb2w==
X-Gm-Message-State: AOAM532X/8duci0fT4vxs10ZxHnOOs76JFJo4tSibDt8i+BDWKc5F+qF
        Q40onfDLu9wdGZhipw14oHc=
X-Google-Smtp-Source: ABdhPJwc0s8N7Xf0hxKKvWjT3DfKxAZtK9X2pcW+qM/TaWv5j/tdAoTup1/sAlPie73LycYp7I8z/g==
X-Received: by 2002:a62:93:0:b029:13e:d13d:a085 with SMTP id 141-20020a6200930000b029013ed13da085mr4916522pfa.28.1601400768890;
        Tue, 29 Sep 2020 10:32:48 -0700 (PDT)
Received: from localhost.localdomain ([45.118.167.204])
        by smtp.googlemail.com with ESMTPSA id d17sm6270070pfq.157.2020.09.29.10.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 10:32:47 -0700 (PDT)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anmol.karan123@gmail.com,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer dereference in hci_event_packet()
Date:   Tue, 29 Sep 2020 23:02:31 +0530
Message-Id: <20200929173231.396261-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914154405.GC18329@kadam>
References: <20200914154405.GC18329@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AMP_MGR is getting derefernced in hci_phy_link_complete_evt(), when called from hci_event_packet() and there is a possibility, that hcon->amp_mgr may not be found when accessing after initialization of hcon.

- net/bluetooth/hci_event.c:4945
The bug seems to get triggered in this line:

bredr_hcon = hcon->amp_mgr->l2cap_conn->hcon;

Fix it by adding a NULL check for the hcon->amp_mgr before checking the ev-status.

Fixes: d5e911928bd8 ("Bluetooth: AMP: Process Physical Link Complete evt") 
Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com 
Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f 
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
Cahnge in v2:
  - Replaced IS_ERR_OR_NULL check with NULL check only (Suggested by: Dan Carpenter <dan.carpenter@oracle.com>)
  - Added "Fixes:" tag (Suggested by: Dan Carpenter <dan.carpenter@oracle.com>)


 net/bluetooth/hci_event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4b7fc430793c..b084142c578e 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4936,6 +4936,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
 		return;
 	}
 
+	if (!hcon->amp_mgr) {
+		hci_dev_unlock(hdev);
+		return 0;
+	}
+
 	if (ev->status) {
 		hci_conn_del(hcon);
 		hci_dev_unlock(hdev);
-- 
2.28.0

