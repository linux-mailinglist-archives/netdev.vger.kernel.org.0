Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F037287916
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgJHP5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731892AbgJHP5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:51 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC27C0613D3;
        Thu,  8 Oct 2020 08:57:51 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 34so4634959pgo.13;
        Thu, 08 Oct 2020 08:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g/P3d1o6K+7liSK5tnZOFW29VqzJ83c3uAI9iAPQ7vc=;
        b=Uns8iLgrOdNab0DKl/a4h5IgljoA7+n01g2c0x9ozuuqQtR/DGSo5LdB387QbsGpgh
         Nvr4fyVIQ2QmKXMqiaySoxaKDSqb0gXp4Tq75A+QDdv9nWsWv69vBY3oC6xTD7Z5rx+T
         76foE/jvrw+c0kFH6xjKj3kEYEoQndfqEzV8643hB7uCyYGZw9VBy27x/8Vldd5i4Vfb
         O/eE80zhE9AhTwGiLC+WAB1Mikw/s3DIrn1+4HnD+hMluIe3AACy7mdLtyj5pYuIw27R
         6nx+g6IY+2Mby/Q/yLM4wiT278Ap5EdBiIMy+1dGXjyV7nNyMRB9gDPOBOLZI3R9DnRp
         /l0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g/P3d1o6K+7liSK5tnZOFW29VqzJ83c3uAI9iAPQ7vc=;
        b=cwq2t6BTpOT+kWP7uQNbz5J548JKs/vgLPvsSJUkOEw0rbeEcqTnUYdAuS/WBl72Q0
         p/kltl+kZda8h6ycCQdlzTYHpkAl5s6P2cyl1B4rSLYOW3123TCqb3Wo2kuISEduhYDI
         U3tzsnPho2HM0/RtoOar3Gj84fUO5ncMC/+aCjvMU+Xr88b2u0S2UUitjSSCxYDLt8KR
         wiXv8QMpBHYbsdBEBNOOGo1rdEC8A/O9ODrQg4g4DdUXcQ0xpiZDctDzeKqAEE8QnAZt
         8K2mG0HXd6+aXr5Ryxh6ocRnN6n9h67ptL+b/t7RNHU9KwRqRm3W9TbtfYK5tXjYSGd1
         GlpQ==
X-Gm-Message-State: AOAM533wxF+bIAKlBXvhvVFVu7jMjTXi3uVOnx2cOQYdVHBnGrtIA5AX
        bG3P+NnntyNQm4Si0t2WsHI=
X-Google-Smtp-Source: ABdhPJxDzCULo0sZ8Ln7UbDE2JAQKX+Ad7qA4rJ0F9sQNQ0x4JMbaQLI5d1/lFhg1cuJd/Hn49A5gg==
X-Received: by 2002:a17:90a:9415:: with SMTP id r21mr8960151pjo.180.1602172670592;
        Thu, 08 Oct 2020 08:57:50 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:49 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 106/117] Bluetooth: set dut_mode_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:58 +0000
Message-Id: <20201008155209.18025-106-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 4b4148e9acc1 ("Bluetooth: Add support for setting DUT mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 68bfe57b6625..5c2e65b00e68 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -116,6 +116,7 @@ static const struct file_operations dut_mode_fops = {
 	.read		= dut_mode_read,
 	.write		= dut_mode_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static ssize_t vendor_diag_read(struct file *file, char __user *user_buf,
-- 
2.17.1

