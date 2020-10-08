Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A40C287937
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732010AbgJHP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbgJHP6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3F6C0613D3;
        Thu,  8 Oct 2020 08:58:06 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id i2so4659481pgh.7;
        Thu, 08 Oct 2020 08:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=STf+1xnAdWv7hMrgcPL8ZiWZwYzLO+1aLUXFpjRCvgc=;
        b=lhdWkX1ey708K603b3BNPUGjqR8pXW84dpRBXo/GTeGHb4SbgvdH0jpMgaD7xTZLJZ
         Cq3Xsq1nDt8QqJbHg15ib7maKaVBHfkNzSCE2Kxk10SwrxhHdmj8IhFiO9X6tfOuUVxo
         kgANZwX0xVGuGvt8Aqr6xa9bC3XrNyF9XZjZuBmNa1CQII444s0AYXdmMePyBIrCGls7
         gybBeJNy4NN06Nf1nDWhplWIpBua9RxTrppmVCOH7cPQq4AMRxwtDTeiqGy+HYO32h3f
         4Ihdg68epJZhzdecD/wLrAEPHRllF1vdpVcwNoKFshZiaW55PyTCcMvE+lmQU21lhzej
         HdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=STf+1xnAdWv7hMrgcPL8ZiWZwYzLO+1aLUXFpjRCvgc=;
        b=qxd/Z08Vcv8cEKEX0MgzIwRevg/5UyabBQ8l01qTwMXHstgUfRhjx3V4YcCq33uvtJ
         grQ9sFZpBqunWA8en9i7nA7FhqBkR2NzPIxtmhVUjRrSCtJnhSMHHOM40wD84YOYyYb4
         E7+/nOocjDmdB5KJlTDUPb1QaP3mooso+H74wjeFitYuBiAQwkj5fok3LJRhqzDLAUPM
         oWs9Qo1yS8s40zaRyO97V3Xpr1IGIPHYAJAxU6+yPmRUcdecuWfjUA7hunuOaXsj5bKb
         gfqkiPeBL201Ag1hAo7aJrRbCaTAT8fQT7R6UzWek9lyB6tG0H7AkzMJF0z7Z06N/vgj
         QAjg==
X-Gm-Message-State: AOAM530GHhw8WB1rWFkOr0/WQUu/YedbP/CjtudQbYs7OuspQ8BljW3E
        6KIW+V5hNgHwjf2Aw+GipRfjZ/bRp58=
X-Google-Smtp-Source: ABdhPJxsvZd7Pi5b2mq96Kkj0p/5A+SvFlSA88im8U1vWnNqs5WuE46Tobiz7+2WqUQmfLa9pynNsg==
X-Received: by 2002:a17:90a:8007:: with SMTP id b7mr8940979pjn.84.1602172686077;
        Thu, 08 Oct 2020 08:58:06 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:58:05 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 111/117] Bluetooth: set sc_only_mode_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:03 +0000
Message-Id: <20201008155209.18025-111-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 134c2a89af22 ("Bluetooth: Add debugfs entry to show Secure Connections Only mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/hci_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index cdf19e494c31..b8e297e71692 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -303,6 +303,7 @@ static const struct file_operations sc_only_mode_fops = {
 	.open		= simple_open,
 	.read		= sc_only_mode_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 DEFINE_INFO_ATTRIBUTE(hardware_info, hw_info);
-- 
2.17.1

