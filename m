Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C91E72D7D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfGXL1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:27:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38914 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbfGXL1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:27:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so21086362pgi.6;
        Wed, 24 Jul 2019 04:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bcioE0DGUFJw/yrsZdFFy4R7kTbvkLIl7gGiYNHkNrA=;
        b=pkh9CKX/LAVggmd8KSgSJjcyP2axsA3oZ2hQZpHmxZVNe+vBattVZxJ4ps6NppX0Mz
         3Fc915iJip0j6Y00C9hhA6RaJFFTkl3SxssWvzSTmUwYb0BRCQNlwzRxT78xUNRlYSdm
         e3EwWyFQKqNG+Biri4T+kV73TUbCY4wbX1DcVw4miw9gQ57yKYWzQfZX7CRIMxdfvCSz
         kD7S0WWpEUsaaIPCjJGk9KsmyMy3YOj1KLlT68hqST9SR76wt90gSGE5oKTLug7MZo4H
         pqIZhjT3N3g+Kr3ELPaiVUXkOSsa5nV+Ji0WAcR8XOwWsr+T8Qc4pkda1t+hXig6uVzo
         vB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bcioE0DGUFJw/yrsZdFFy4R7kTbvkLIl7gGiYNHkNrA=;
        b=VH7tQrUPQUs6Mg1v2z7e906FM124WgNW6NnVnvvTdfiU2koOLP9Rfo7WDXD/zThjxC
         6J3v3RAaEdOgGdrRb0GT/HeMjuCFHP7GEevQMktkjjqq1ZW6CbGqubF+PEgDt06NMyvP
         5q6ZRCWFX5ADsx88AWAtVcbpmJoSaFVzG6Kk/mhKcAu/22Od9Wk2xwQY+pUbJSQA/Rhr
         k1MtqONuF4DGGDvCtA+ML+lcSB7K5tjvN/dAbyvOeApTFjp9uoPwLs3xMzNKiaLgBORA
         EMkkbnmsNcJ1NXIxGW7aYqjeA0XvmbGkTlBgI3K6bIj5qMOFYSM6aEyGTv/UxHebncg5
         hIAQ==
X-Gm-Message-State: APjAAAXPiLl7qfz6qsX6GX34x10nA70BRpevmaq4zRwrqLdswAzgL848
        4by4b8ca33Az6tpLYTpkkO0=
X-Google-Smtp-Source: APXvYqyRE+phszV3MvNPj/mXY/s4lkPP/dJzypRRSnJ6Byzz1CJE39bNZqH40JFjXAu91V3hMs+qOw==
X-Received: by 2002:a63:4846:: with SMTP id x6mr44830409pgk.332.1563967655646;
        Wed, 24 Jul 2019 04:27:35 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id l1sm60883684pfl.9.2019.07.24.04.27.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:27:35 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 06/10] iwlegacy: Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 19:27:30 +0800
Message-Id: <20190724112730.13403-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 4a88e35d58d7..73f7bbf742bc 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -4942,8 +4942,7 @@ EXPORT_SYMBOL(il_add_beacon_time);
 static int
 il_pci_suspend(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct il_priv *il = pci_get_drvdata(pdev);
+	struct il_priv *il = dev_get_drvdata(device);
 
 	/*
 	 * This function is called when system goes into suspend state
-- 
2.20.1

