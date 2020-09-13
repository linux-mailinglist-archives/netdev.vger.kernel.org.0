Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A422680F5
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 21:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgIMTRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 15:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgIMTRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 15:17:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455B1C06174A
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 12:17:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d9so10688313pfd.3
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 12:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=TudM6FbZR7nKYpChFzWDh+w7FEwfLsFIiUVm0tBoXx4=;
        b=r4dcGz8k+JToOjJAGRg9xdKRptCATJ+rDjqMGRN2hCMwOwx7mpLreghoQSR2cf318U
         bB8NEGFixQaSXelfCc4cbUBo4kqQUO42KZeeexkvhYJnQnqgz0R6l7w6oEp9HrJWLF/1
         3RyjnIevhBTW6VqH59TYeg7i6pEsGcPj4bzl2dGqpmuyg202xhBbP9NpTQKdV0hzXwuj
         ooU+q+4eplKu3EI3JvRbGw8d1bfavBOB5Gl2jFxQz47g/cl+Leg61p7xcILXJDh+DJYQ
         Sc7Y53uRLxuWlY3JFq4pf5oEV//gWSHlmnZS483u59eE4UlGf8CxIkrvF4tDXDT/OeMM
         Xnkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TudM6FbZR7nKYpChFzWDh+w7FEwfLsFIiUVm0tBoXx4=;
        b=tqqiifjYM3rotvwfCNcPfsyXiDPH0yQMTIPqLO+pEAUM4vqokIeKN2YewOx12nFquB
         prvz6vz5ktIyDo1cF87ZRyd86TzPy3Zqkrh2BYUeVYvw+SV6H9iEgM62xhsc4MXO2IHr
         0NooeF35l+g6rhhdL2KZntjDwg5XpH+SU73xyQELmsFuv5CBri9m/2HH020m15/LuXbR
         rzW0MGuTXptoTEzUQXblGB3dCzFYcM6IrYsZZVZ6yir6bs3liBbtIS6D7EF4ZR+QUGQg
         5Xrzk4i8Nt4xCMayQ4LGtAnDIHQNZJ/3Iylh8KtSIjOabQEBNGrw1ymnaCeQVDJViIdI
         ptLg==
X-Gm-Message-State: AOAM5317GYHhdorhPx44ZEFp4+o1f70cqxCk043d/kSu5HMfsIK95GOe
        QsnuS1G111CuLDb+8i+4Uyfd1VOSWSbxRQ==
X-Google-Smtp-Source: ABdhPJzmKykFCoC6+OTg3Lzf5pQhQ4BbG7novycV5qG9dH4BQ9pQhb57TUIuq/b1whlXMfFdSpkiRw==
X-Received: by 2002:a63:2209:: with SMTP id i9mr3651166pgi.130.1600024620526;
        Sun, 13 Sep 2020 12:17:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f3sm6306094pgf.32.2020.09.13.12.16.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2020 12:17:00 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next] ionic: fix up debugfs after queue swap
Date:   Sun, 13 Sep 2020 12:16:54 -0700
Message-Id: <20200913191654.42345-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean and rebuild the debugfs info for the queues being swapped.

Fixes: a34e25ab977c ("ionic: change the descriptor ring length without full reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index eeaa73650986..895e2113bd6b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2235,6 +2235,21 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 		}
 	}
 
+	/* now we can rework the debugfs mappings */
+	if (tx_qcqs) {
+		for (i = 0; i < qparam->nxqs; i++) {
+			ionic_debugfs_del_qcq(lif->txqcqs[i]);
+			ionic_debugfs_add_qcq(lif, lif->txqcqs[i]);
+		}
+	}
+
+	if (rx_qcqs) {
+		for (i = 0; i < qparam->nxqs; i++) {
+			ionic_debugfs_del_qcq(lif->rxqcqs[i]);
+			ionic_debugfs_add_qcq(lif, lif->rxqcqs[i]);
+		}
+	}
+
 	swap(lif->nxqs, qparam->nxqs);
 
 err_out_reinit_unlock:
-- 
2.17.1

