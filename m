Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861632FABF2
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389163AbhARU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394506AbhARUz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:55:58 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE13C061573;
        Mon, 18 Jan 2021 12:55:33 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b5so10654066pjl.0;
        Mon, 18 Jan 2021 12:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ruFco5xWA/+b9SdvAnrzJirm3DFQidkDyFrYUFYOIhM=;
        b=PHUIVUA+UHyfkRIww6QRky8yjEn2KLoiiu3EiEutYGjX5M6nIhWyr7svc8q/o3BJlX
         PFD3h/XUkiBtVLxTd3sM1b5sZNfb7df63igcgpDb2fiNM+zHgJORr1EzBWHloAnorD8o
         /v37Duq+K5Y3tFsK2CD6IW1MHRlsMb32iuzX13rR6lUIS/FB3MdxFc9Zv93WvY1nvRIV
         68ox6/x1DihkYxrvmvnZ6nq5oASFQMAUYMcgxvzzpF4wp1GJjq/cO6mwbyFi4p1ztpW3
         7gfBTzgwhg+eKcg3/2yTH7hWIqSJmW+LLZ8pGS9Cs/wii3oAN+hpTLEEaU4Nv8Xd4Emr
         3R5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ruFco5xWA/+b9SdvAnrzJirm3DFQidkDyFrYUFYOIhM=;
        b=FTtJmN1cvvWMaSPwo7k1DoIev88ra0ctq5hrU5+MQahrHNl+95qF8eBqR607SRWy3C
         CwLmZcPCC8vJn/PvMmT6uV+EGswEClP62ydBk+sVx8a5hgOVIqRQOW8puIiYwkOu7mAb
         DfQ1IUcd0tycejdv4Lya/xcDLBWWsFpRHvQ1AzuhPYIVMfxv7w/cj/f8S9+YNtTIHFt7
         cEt/nV++8JcTmgJL1Y5JtmYQmJzKu90/uvEV2fkEQyfAoiXNE6N+d2GgLFrtIzMrr9Lw
         LPq7P2BzGlE6jy39DHZjSRlneQtEMMrC+LZ1s0e/vULcZxlFsoLKTcpT4aKhRv1qu0uH
         YUjA==
X-Gm-Message-State: AOAM53137BXpAGSCSwaFmAZ5bnVBWfmx7Omo0ZSzNTqWTtOa6UMFiJE2
        pjGv4FYPyWxESKhX2LyvfKf7gytQIQez9w==
X-Google-Smtp-Source: ABdhPJyPT2W/Qas4x40xT79rgOIhRxTbqaBcyEflSf75Ca4VkIGC2xg7T6HCGH8gZ69HdAcNCx6cKw==
X-Received: by 2002:a17:90a:4490:: with SMTP id t16mr1247891pjg.55.1611003332605;
        Mon, 18 Jan 2021 12:55:32 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id k11sm16843653pgt.83.2021.01.18.12.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:55:31 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net] net: nfc: nci: fix the wrong NCI_CORE_INIT parameters
Date:   Tue, 19 Jan 2021 05:55:22 +0900
Message-Id: <20210118205522.317087-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Fix the code because NCI_CORE_INIT_CMD includes two parameters in NCI2.0
but there is no parameters in NCI1.x.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 net/nfc/nci/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index e64727e1a72f..02a1f13f0798 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -508,7 +508,7 @@ static int nci_open_device(struct nci_dev *ndev)
 		};
 		unsigned long opt = 0;
 
-		if (!(ndev->nci_ver & NCI_VER_2_MASK))
+		if (ndev->nci_ver & NCI_VER_2_MASK)
 			opt = (unsigned long)&nci_init_v2_cmd;
 
 		rc = __nci_request(ndev, nci_init_req, opt,
-- 
2.25.1

