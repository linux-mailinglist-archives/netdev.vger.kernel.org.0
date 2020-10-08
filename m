Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A1E28795D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbgJHP7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731069AbgJHP6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:18 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDA3C0613D2;
        Thu,  8 Oct 2020 08:58:18 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w21so4345267pfc.7;
        Thu, 08 Oct 2020 08:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zfl90cVmYUuW0xLp4/sHdwM7saiIni7ST7oKF7yhfIU=;
        b=tew9+4K1uFItwp52xS8rmCl8C8XA9nPO/WKFwYGjDlkWBnhoMt0OwKcWpEBtAachx5
         tvbANGYNsDafH3LYqjqtl6ACLMYgNwbcuekKhRSjPJs1Bsh1+130Py+b3fOMVSKLY18W
         fghUrPgLCk5MNU08owH3OhrI9h7Cqxgd52syNdrDFK8zlZNGJpH8f4RR1h8l1mz+BS8D
         YujIQ37sYCs144wZxe6I5ReAqBusEH/klucitvoLF4O2KPIXPLVCQ3l2gymFMSGp+i0n
         CPttVlH8XDW6sw3WGubvmyG6gaHhPBNZIeIoOf6gcQA6QoN2wrlk+PQfzxacfePNakIT
         9AWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zfl90cVmYUuW0xLp4/sHdwM7saiIni7ST7oKF7yhfIU=;
        b=O6LeuF2ObjfjZxhoFFSDGYvULsnf7utOPHVLJNje0KKzt4zeZwwy3/TayFUsFYGb8r
         S+Tl1aXptSyceqKal+IkKL20KHJdW5bMMNZAO5FYCJmX9qSjIbgkGpmC7jUwRHlxfWxX
         yX5jjde6/tCIhXgT+aXR1aO1Ik+e1+OGyRwLb+/7U4hpQb06gK3jPHtRQht/XC/TGzT4
         C7phIgy4UaNMfKa3Rspc8j7o8Kncy4OtZQZC6TF4Cl/QA2hTVjh2qc3eDIuE2hb49IL1
         uctyeoWYjpDLbhJK3JlXvnLK4rb5vKWkPAiY8dVLZg07mC/7vTDNWZcQ83zxrppFyXpC
         8NIQ==
X-Gm-Message-State: AOAM532V/tXhNtvN1W/dMBUwNgee5mLRPUmAVXmGuQTH2Z94cGOAZ1ki
        L+gUVdpDF4FKfav/39H6r3BU5jbcD4U=
X-Google-Smtp-Source: ABdhPJxFkST9RsXb8M+2dYvP5LZ7ie2SuemBVpbb9bC89RUYthOrqJuvNppdU3MnRM//oUHjKWFtEQ==
X-Received: by 2002:a17:90b:8c:: with SMTP id bb12mr5454202pjb.48.1602172698299;
        Thu, 08 Oct 2020 08:58:18 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:58:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 115/117] Bluetooth: set force_no_mitm_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:07 +0000
Message-Id: <20201008155209.18025-115-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c2aa30db744d ("Bluetooth: debugfs option to unset MITM flag")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/hci_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 6ea692a3d4a8..c9a074da16dd 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -1122,6 +1122,7 @@ static const struct file_operations force_no_mitm_fops = {
 	.read		= force_no_mitm_read,
 	.write		= force_no_mitm_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 DEFINE_QUIRK_ATTRIBUTE(quirk_strict_duplicate_filter,
-- 
2.17.1

