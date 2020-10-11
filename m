Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3642928AAB3
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 23:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbgJKVZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 17:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbgJKVZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 17:25:29 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC20C0613CE;
        Sun, 11 Oct 2020 14:25:28 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d81so15473047wmc.1;
        Sun, 11 Oct 2020 14:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FNN9OqkWHxkI2/FsUjbbTqtGt1jNhP9w+BKvnMiIIQI=;
        b=s+LGa/kT4lkSTkks6KB0yAW55qco2n1RBE7rjb9RfNzn5g6MQ7tRlgP/xN/qNO94jE
         qsad0x8X1jVeIUGGb9Nd7dg6MTksGtwW13Zqrp9m96R92Re98bkroi1LAq1YJLFjBATh
         hFaRlRFqIAtJezVPS1KPsla9ZONLsImKQQ6rtGJ6H2s+L3x755cOk3+gRwptvml+EckS
         3xO57Wxta5H38FmRXsK97p9EUhVkxX5APREzgGbpFI3Fo1W6umgDOTrLNC1kuCo4GTQh
         okIdRI/ycFYDwZd49CDW/MRlZE33SoggqfMxcrIlHnEpAE8SOJUzMFlqZWLYNmJZQ9UD
         nMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FNN9OqkWHxkI2/FsUjbbTqtGt1jNhP9w+BKvnMiIIQI=;
        b=M+LvCzwrIq/WybNIY3l6TtyFd0arM2U0wuHhG2/+RnTEfvOVpoalzEBBJwDgyYc6dg
         1As2bxrLMzZrHnYLj3g7CD+Dbq2usp9uxi4cBTDwhD9HAikFKJnMeQFkWO61IaXhwXxT
         MARgtLUTO9YDslQMk3Tw4Gm3Al8VvrZrRVyHPdsIlhJCuTv4MBS+4Lq5aC6EjTePWrTN
         K8AJke0GUHhKBhP6ts34r0/Oe/QPvouOIvT/VyuWqV0V2WJQ8XBpXwEIT3YS1UqfhIcs
         lVZRZAlaPB7DCJXIRWiMpbc4cRlrQuNRLdUsYLZIw5+wXdeTiZw9D1ttAwYCba9LN9ih
         vHyQ==
X-Gm-Message-State: AOAM531Rh/6e++Qn/MqJA6uAzzha/Dh3i0NK1GNxwIGNbyE3tFiLiEeS
        iCVPBEEY6OzSODAs+XH+SDbtsY8A8QYyzg==
X-Google-Smtp-Source: ABdhPJxNEUKo2W9hGeuoPkuyK6LDZibfcvoGmM+X2LpblcY0/MsoiH5sox5Bs66Yf3mxRQU74EO8AQ==
X-Received: by 2002:a1c:2e0d:: with SMTP id u13mr7862095wmu.179.1602451527531;
        Sun, 11 Oct 2020 14:25:27 -0700 (PDT)
Received: from localhost.localdomain (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id z17sm8908722wrr.93.2020.10.11.14.25.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Oct 2020 14:25:27 -0700 (PDT)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-safety@lists.elisa.tech,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] e1000: drop unneeded assignment in e1000_set_itr()
Date:   Sun, 11 Oct 2020 22:23:26 +0100
Message-Id: <20201011212326.2758-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable 'current_itr' is assigned to 0 before jumping to
'set_itr_now' but it has not been used after the jump. So, remove the
unneeded assignement.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 5e28cf4fa2cd..042de276e632 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -2632,7 +2632,6 @@ static void e1000_set_itr(struct e1000_adapter *adapter)
 
 	/* for non-gigabit speeds, just fix the interrupt rate at 4000 */
 	if (unlikely(adapter->link_speed != SPEED_1000)) {
-		current_itr = 0;
 		new_itr = 4000;
 		goto set_itr_now;
 	}
-- 
2.11.0

