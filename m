Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA794287922
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbgJHP6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731972AbgJHP5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CD1C061755;
        Thu,  8 Oct 2020 08:57:54 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 34so4635080pgo.13;
        Thu, 08 Oct 2020 08:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R9gs6Wld7jw/v0TFtg7coIV6VVR6/NQGiZexDt9xYbc=;
        b=pOsi2ytHK0X0AUZRUvgvDo/iBkXGN8PYgSC7EdAOPmgT0+yFiYDFqkfFMDQg4CIc04
         x5ytQXmSl7FeaIDsjiZDJfbwYxNa2955WA+9d9RFF2+Yaf6nPcURFtCm0piInlH2OKSD
         Owp/BOUtBvqj8o5h9xgzSBDJFUMT2ppyrm7d2xABt1iGBTZ5qTp1suX4h8+FwXQ4K0Ah
         bsXbQXaUKqfhGf46qhmXw4gg7ftyVKwGtvpdv52RcGJiVYAS066P7b0ioGFtxwGYue5v
         6QdX9VNqbmq/pJtgL7QUrw01JKbOq58TwtjRaxbkGXgISeiyRtkcjJPmuLggypAzbSyb
         K7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R9gs6Wld7jw/v0TFtg7coIV6VVR6/NQGiZexDt9xYbc=;
        b=Y3P0T8vMUZgHoX8udLre3mnnP/ZQNgQqewfST4uZhs3DiB8u2gqT82nGigz8xhWsh1
         2PVud6NuPBMHWTvCP14glRdUs5FE+6/BDnqaW+Jjzav1NRo+zFm7SOtqh1nnd4a2Qxmw
         ZsQPcFxxriMO71ZRixUgIRU/koucd/RhfjG1Kirpa8pv8cYhScpEQd687jWPzI5wdgHg
         Lctn7VVXQiS9MLmhXOWUw+a1F8TyocpumCZJw8aDtcn4nNQgK2DZIH1trAkaMFcciDEX
         RwGK4cgaPBtOkRP7bOaPeQRL8Flftc/qfK8Gk465dw1T1vyWKQzppZa0deC9jgCn45W8
         FvjA==
X-Gm-Message-State: AOAM531khJJs6oxrXCFeTpUTYVNCVG/Lp1/RIlKvnR6K/dMFd1iGpYw9
        R5BeewSiavw/fANqI79Wpzo=
X-Google-Smtp-Source: ABdhPJxfYxwR39jy2lNuKWSYKCr9KXVwOOd4gpt1A+Xs8SGkvngTumR9QA8PkaxSl03VGR3DChhTkg==
X-Received: by 2002:a17:90a:1ce:: with SMTP id 14mr8987293pjd.209.1602172673685;
        Thu, 08 Oct 2020 08:57:53 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:52 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 107/117] Bluetooth: set vendor_diag_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:59 +0000
Message-Id: <20201008155209.18025-107-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 4b4113d6dbdb ("Bluetooth: Add debugfs entry for setting vendor diagnostic mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5c2e65b00e68..6778114f6615 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -173,6 +173,7 @@ static const struct file_operations vendor_diag_fops = {
 	.read		= vendor_diag_read,
 	.write		= vendor_diag_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static void hci_debugfs_create_basic(struct hci_dev *hdev)
-- 
2.17.1

