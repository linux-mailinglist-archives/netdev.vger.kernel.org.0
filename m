Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BED2CE652
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgLDDQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgLDDQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:16:02 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE55C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:15:16 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id t141so3851994qke.22
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=SqrSxY5uc4xcJqKSvQt8JkbosUVthJxwVLPagRQfa9k=;
        b=ZtoCbhF83mH8woZoUdtLoCbWmJ69GR8ZSC7CbsMblk48Asr7dttdoLeBj4/QMHcxWC
         n/WqQ0M6X4a2zQTPqqJbOUg5BMPeXthOn6YvhNjwvyYi2GhMIWsehNr3oF+HLQGUZFZB
         U+lzRysW5d6Bynymlp1oBm2meut/MtnoCvChFGvdVZJyU8a9w9j2dDeYtajHCy87oXFu
         GvkMsj5NHy8ahIki1cL7qxZWmwSWSyrYlw6lp97ts5Ok0cI8H2uPj7kgH4fCOHW1JM1i
         PFbXWl/oPM2xYrfOMbpPSaeeDSvQoERuv9h4wdX8ygDYryoQ4aeeMleNgs0RqUjkS8E7
         vSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=SqrSxY5uc4xcJqKSvQt8JkbosUVthJxwVLPagRQfa9k=;
        b=h2bCe9bj9YmQsFLy8ynnJuS/YsIerPennEqNZO7Toa0Rv6JzPp2VVcnf/16NzD0izL
         WsRhYOFlpiRG1wlCamyXB9PDC6Bg/ticnnwJRrafHircbuwc4tT1SBkhGJvfxy2M72a6
         EhTXtNCI8eX5ZwWT0975qfuqw03rHFz2NvvnSICZ1Y3LuMProCpwp5A4TmaglGH3ypbB
         koyo54pv5F6GIdyw9r6n2j05hP2SrBzxcXaMLP4RC+YFvcgP0Rw8muKK8Z1kj78RMuwo
         plzCoa13Qwv1Y7YP1uB9h0MifkfgixfoDelYEPiZI+J3cwYr/Nu2vXOdfJUY+t2To4dc
         ZjbQ==
X-Gm-Message-State: AOAM533ICPYYRafruwPdQjcgIDA0/NW8sN213syOq7uvEId97cShpaS6
        iiJghmi8rB7U8Qi47dPdmmLvZvZmTSn8+ZjT8w==
X-Google-Smtp-Source: ABdhPJw6pYkEPaXn6m8Sa+IEwWAZKLX13zrJN5JXeLuCA6Cr5L/HdyQWDCnm9EPigYwxBtnqeBX6CeiZcx6ZH0NoNg==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:ad4:4d84:: with SMTP id
 cv4mr2903690qvb.14.1607051715532; Thu, 03 Dec 2020 19:15:15 -0800 (PST)
Date:   Fri,  4 Dec 2020 11:14:31 +0800
Message-Id: <20201204111038.v1.1.I4557a89427f61427e65d85bc51cca9e65607488e@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v1] Bluetooth: Set missing suspend task bits
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     alainm@chromium.org, mmandlik@chromium.org, mcchou@chromium.org,
        marcel@holtmann.org, abhishekpandit@chromium.org,
        apusaka@chromium.org, Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

When suspending, mark SUSPEND_SCAN_ENABLE and SUSPEND_SCAN_DISABLE tasks
correctly when either classic or le scanning is modified.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

 net/bluetooth/hci_request.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 80dc451d6e124..71bffd7454720 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -707,6 +707,9 @@ void hci_req_add_le_scan_disable(struct hci_request *req, bool rpa_le_conn)
 		return;
 	}
 
+	if (hdev->suspended)
+		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
+
 	if (use_ext_scan(hdev)) {
 		struct hci_cp_le_set_ext_scan_enable cp;
 
@@ -1159,6 +1162,11 @@ static void hci_req_set_event_filter(struct hci_request *req)
 		scan = SCAN_PAGE;
 	}
 
+	if (scan)
+		set_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks);
+	else
+		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
+
 	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
 }
 
-- 
2.29.2.576.ga3fc446d84-goog

