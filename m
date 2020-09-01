Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C4525A103
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgIAVwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729501AbgIAVwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:11 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C60C061247
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:11 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id f5so1491118pfe.2
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=qm0KYWWyWC7VzRV6b5FGuhbeKRRJgNfVwQb8pLTqbjs=;
        b=DggOQ4ggeg+x8H/uwwfXk16LN9Yw44jHKwRnD7VbwrileYaaRPM7E+Lmj4/6vs+Snp
         mmqX2HfNrj+PDc/eZDsk9qP61+RzfXn0aS9Oj5b2QgCAL90J7p713QfoUGkLDzYRYxs5
         p0BFWXHDlPDF1sv3mTniOGPcubbCgkPBi19dHk8jWzKNmuFeYa24ic36p3yDR61QUl6U
         ekN2pAG16qujUL2jbBVnOx9oOODIQPBqV9lV5hJl63ZxutnwqTQKE9djOkqCFyyaerNP
         YwWi8Fkg8q7+BbaeG/5mc6i6a4Ymt+LK7b9TZ5W5FfEJpS3c5oXpNJbddLUK31ybz8Kp
         090w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qm0KYWWyWC7VzRV6b5FGuhbeKRRJgNfVwQb8pLTqbjs=;
        b=lk322PIpEFjqEyKWygSBo/XJC1ili+ZbLynkMob+Hvb+CT4XsLoSjRYeu8KlXOITk1
         m3T0w+dmup0lww3/KeR0wZJYqMcZnKtXtJ0+prxvwbqCuLnZOUF5PqD9rUZzgLnRL/y/
         n0CAvSRdrCUai/26Kag8hXjbC2Suw5uTXQmz2We5ziuVUgb9MFIG5wqsv5CXjA6RUyNf
         xAjU19c4RcPj4ocSGKWUNf0d2oqbolEgCy3wJnUqLzxZ1HnAq08sr6O5JJgrqrxpBZao
         i/LhacXkGhAObKkhTiYRO/kuPGPhz9e3Dl8uzdXX34fAZjy7wivp5bOfeejX1D0pcTac
         njxQ==
X-Gm-Message-State: AOAM533666iu1n4Cx2vM/7hTYlDQ7gNwdP8tJASVbFr3lNWU6RHNJEya
        es/BgewZHnTf9ReU6ktuv0BB3ezGGU+4UAI+2JRiNGCgPOs0eoYLtQaXLF4z1yqjFbUsvBlHDet
        iZpO9/oKBl7tnu4QLAcy8EVzg76M/QBtBscLC4fhfebA5FxRyrO76kMRRP3Bis/lLY8nNf6jv
X-Google-Smtp-Source: ABdhPJzLlQds8V7c1NvsaWrSE5ZVzuQh4mq0fBB9d4l2aT+NfGMRze1H44pzmJl/8sPADXtyw++4eExzrrEIzyRP
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:902:7e82:b029:cf:85aa:69f6 with
 SMTP id z2-20020a1709027e82b02900cf85aa69f6mr807202pla.3.1598997130552; Tue,
 01 Sep 2020 14:52:10 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:48 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-9-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 8/9] gve: Use link status register to report link status
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Patricio Noyola <patricion@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patricio Noyola <patricion@google.com>

This makes the driver better aware of the connectivity status of the
device. Based on the device's status register, the driver can call
netif_carrier_{on,off}.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Patricio Noyola <patricion@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 24 +++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index d5019132874d..4ddcc1836d1c 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -769,7 +769,7 @@ static int gve_open(struct net_device *dev)
 	gve_set_device_rings_ok(priv);
 
 	gve_turnup(priv);
-	netif_carrier_on(dev);
+	queue_work(priv->gve_wq, &priv->service_task);
 	priv->interface_up_cnt++;
 	return 0;
 
@@ -1026,16 +1026,34 @@ void gve_handle_report_stats(struct gve_priv *priv)
 	}
 }
 
+static void gve_handle_link_status(struct gve_priv *priv, bool link_status)
+{
+	if (!gve_get_napi_enabled(priv))
+		return;
+
+	if (link_status == netif_carrier_ok(priv->dev))
+		return;
+
+	if (link_status) {
+		dev_info(&priv->pdev->dev, "Device link is up.\n");
+		netif_carrier_on(priv->dev);
+	} else {
+		dev_info(&priv->pdev->dev, "Device link is down.\n");
+		netif_carrier_off(priv->dev);
+	}
+}
+
 /* Handle NIC status register changes, reset requests and report stats */
 static void gve_service_task(struct work_struct *work)
 {
 	struct gve_priv *priv = container_of(work, struct gve_priv,
 					     service_task);
+	u32 status = ioread32be(&priv->reg_bar0->device_status);
 
-	gve_handle_status(priv,
-			  ioread32be(&priv->reg_bar0->device_status));
+	gve_handle_status(priv, status);
 
 	gve_handle_reset(priv);
+	gve_handle_link_status(priv, GVE_DEVICE_STATUS_LINK_STATUS_MASK & status);
 	if (gve_get_do_report_stats(priv)) {
 		gve_handle_report_stats(priv);
 		gve_clear_do_report_stats(priv);
-- 
2.28.0.402.g5ffc5be6b7-goog

