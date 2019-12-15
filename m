Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3A711FAA6
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLOTBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:01:35 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:37876 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfLOTBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:01:34 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 47bYfP5tVGz9vZT1
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 19:01:33 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 96JgpARsWNX9 for <netdev@vger.kernel.org>;
        Sun, 15 Dec 2019 13:01:33 -0600 (CST)
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com [209.85.219.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 47bYfP4lt0z9vYwq
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 13:01:33 -0600 (CST)
Received: by mail-yb1-f198.google.com with SMTP id d191so4846095ybc.17
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qz7hLv3TGqOg26p7ukuVbPc1PJuaHmmS15JJ7SJDcyg=;
        b=WDeUlTq0RckidAgYO+X9nuaqk8amj5C8qSBi+Bs+62XAkYuTXYBcxgJAV+VCIY3LNs
         0Qm8E9YIXNNhn/DSgXScWghVmMWjcIHWNRRwc05ezVNjCWM3Uu5+9rjqgF/mqn9SDgC9
         dSmBX7q6cLSD5LNkShwtklXC/JeVIS+hKSpooT1Qat6uAcWIj2YCvpW6Bdgd1Vrus1G2
         yvm2GwxdHFE5quzCM0aenozhY75fuuqazgtdWIbx08jNLBHz98XuCb9jRm9ZKytFHgK5
         3bbjzxm24evQ22vf6Q9xKey05WSxW15DS+lWx0/5MDsUsIF7vNeig4wYergwmtZV7oqn
         PVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qz7hLv3TGqOg26p7ukuVbPc1PJuaHmmS15JJ7SJDcyg=;
        b=QHbpeshjnXGZLzJRBxzYc8ImhM4fizia0UIqKJ/X403lSCot8+GN37uvCTN4BPAo53
         BMi+ta+IWj4EXHfj4MSNrLaY0ZUR5bKcqueTlmDHd33DjmKAnxTvZPuc3eNjXLzcv4Rc
         Daaf9ki9fTWr93r5Kb/67CJ9smCjzr/C/cCG1ffDhoxM1lzgk1IAdZO1UvlTUiwkCx6t
         PleePTw0jvBOhmb1nS7pMgQQucQJEmlvNwTKpza5mwPBOzsC/qFGYaPMhsQioanQ+pWY
         hUjw+7DuoR82aP5LOm9dc33GyIzVUOKer2BMLvt/RpT9yDrTCOUvOM0fhMo2ixCO4fjs
         tUuA==
X-Gm-Message-State: APjAAAUxFVSMR3KN9msvk0hClwSB+Ui7Wgu3qhNVGd9aQaDNJNdIDFI8
        GYQ695WFKjZineqDe0QUY2OdvEYKlYSA2B8vDgXPLQ1k0ULT0dmeyO5RnVHHo3iJ4oHXq76TnzZ
        JgWIGhQqoBVA359K6WSMy
X-Received: by 2002:a0d:e253:: with SMTP id l80mr9334259ywe.144.1576436493174;
        Sun, 15 Dec 2019 11:01:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3YZdwihU43qkPnbxJKmlB06NwItzwFqufpU0Q7+Fs8bphzIW5aEm6q8m735lWJ3DWuSQ7fw==
X-Received: by 2002:a0d:e253:: with SMTP id l80mr9334241ywe.144.1576436492917;
        Sun, 15 Dec 2019 11:01:32 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id l20sm4937468ywa.108.2019.12.15.11.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 11:01:32 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Robert Baldyga <r.baldyga@samsung.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: s3fwrn5: replace the assertion with a WARN_ON
Date:   Sun, 15 Dec 2019 13:01:29 -0600
Message-Id: <20191215190129.1587-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In s3fwrn5_fw_recv_frame, if fw_info->rsp is not empty, the
current code causes a crash via BUG_ON. However, s3fwrn5_fw_send_msg
does not crash in such a scenario. The patch replaces the BUG_ON
by returning the error to the callers.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/nfc/s3fwrn5/firmware.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index be110d9cef02..cdc7d45237d2 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -507,7 +507,8 @@ int s3fwrn5_fw_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
 	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
 	struct s3fwrn5_fw_info *fw_info = &info->fw_info;
 
-	BUG_ON(fw_info->rsp);
+	if (WARN_ON(fw_info->rsp))
+		return -EINVAL;
 
 	fw_info->rsp = skb;
 
-- 
2.20.1

