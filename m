Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7DF2461FF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgHQJIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbgHQJIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:08:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D8AC06138A;
        Mon, 17 Aug 2020 02:08:34 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d4so7384629pjx.5;
        Mon, 17 Aug 2020 02:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+NTimJtnBbC2vn2emJhLbsb0QSFu4UbCkRf+2eRaD+0=;
        b=ExKwUmiQmHr3RgWLantVAoQwbPodTntzyfRbVjOeT28ZrRGl9TeB/MqFSWL/aBcTj/
         t3RZseL3pWsFNChvwUfIUMm3kiJjh+1Rla54XGdfxFMYjWv996HzzKmgEjYULvsSlS9U
         2lxK9f3yK6e0v88CqwqdGJEf9qDGxwgWqznDrrpOX/xRMfqyuZU3/9wHyekMLErocxQS
         Bp6Apl0XyMjlDN3P8gUrvoQvVTK+aoUFHH8jipVjoVNPfa5dO/DiHbILC+f4skl1dGNF
         +kLzi9FE/OGqE0SVnYUmPsW6BaevjapuMtoOJKw9ebpI/X5A6f4nSoiIuI56Yfdbklx3
         vlrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+NTimJtnBbC2vn2emJhLbsb0QSFu4UbCkRf+2eRaD+0=;
        b=AZlKAFHCDwuMNSNqZAmqVN6JmTY2Wt7nA8pl+QnWjoyTZ7wcs4Xbkbi2wCviwgMKaw
         wnjpHNxvErsJhnUnggQZUzz+X6/5lKhYmams9ApZCkp3dzrvBBiTgJZuRaJ/Cl/8gmOm
         7HMwe27o2nBRVXk0xsi5UyfEccGcA1bjvUw8CEi35XPiCYXdemNOTdfKNp6Diug9RuyC
         iyXDCmAhrzhjg7SYDl41LhRIKNhYJIvM3U1GESzGfvaIWOIrnOoEjKvNmCCIAuqE9tEF
         MhMmP57NlpEzyQsHogWF56mxlhGA2HmjO+rkHuzsD90TYB6ug9BGgOKbPc38aQi1MRve
         KS/g==
X-Gm-Message-State: AOAM531KM8XOYDLFTtABh6TBVThOY0zGXf9wtm+E4fd46WfN47otzvTs
        CHaEtJXekQjt6hf6vp6qPb8=
X-Google-Smtp-Source: ABdhPJwfnwt3fXRjQ/T61TvzQhDr1ZHJlzYMtVJeoImUWQzGwlR5MR44JULduGQQvPf8NxkeCObhiA==
X-Received: by 2002:a17:90a:b10e:: with SMTP id z14mr11603611pjq.8.1597655313886;
        Mon, 17 Aug 2020 02:08:33 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:08:33 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     kvalo@codeaurora.org, kuba@kernel.org, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de
Cc:     keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 13/16] wireless: quantenna: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:34 +0530
Message-Id: <20200817090637.26887-14-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817090637.26887-1-allen.cryptic@gmail.com>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 7 +++----
 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c | 7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index eb67b66b846b..9a20c0f29078 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -1091,9 +1091,9 @@ static void qtnf_pearl_fw_work_handler(struct work_struct *work)
 	put_device(&pdev->dev);
 }
 
-static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
+static void qtnf_pearl_reclaim_tasklet_fn(struct tasklet_struct *t)
 {
-	struct qtnf_pcie_pearl_state *ps = (void *)data;
+	struct qtnf_pcie_pearl_state *ps = from_tasklet(ps, t, base.reclaim_tq);
 
 	qtnf_pearl_data_tx_reclaim(ps);
 	qtnf_en_txdone_irq(ps);
@@ -1145,8 +1145,7 @@ static int qtnf_pcie_pearl_probe(struct qtnf_bus *bus, unsigned int tx_bd_size,
 		return ret;
 	}
 
-	tasklet_init(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn,
-		     (unsigned long)ps);
+	tasklet_setup(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_pcie_pearl_rx_poll, 10);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index d1b850aa4657..4b87d3151017 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -1105,9 +1105,9 @@ static void qtnf_topaz_fw_work_handler(struct work_struct *work)
 	put_device(&pdev->dev);
 }
 
-static void qtnf_reclaim_tasklet_fn(unsigned long data)
+static void qtnf_reclaim_tasklet_fn(struct tasklet_struct *t)
 {
-	struct qtnf_pcie_topaz_state *ts = (void *)data;
+	struct qtnf_pcie_topaz_state *ts = from_tasklet(ts, t, base.reclaim_tq);
 
 	qtnf_topaz_data_tx_reclaim(ts);
 }
@@ -1158,8 +1158,7 @@ static int qtnf_pcie_topaz_probe(struct qtnf_bus *bus,
 		return ret;
 	}
 
-	tasklet_init(&ts->base.reclaim_tq, qtnf_reclaim_tasklet_fn,
-		     (unsigned long)ts);
+	tasklet_setup(&ts->base.reclaim_tq, qtnf_reclaim_tasklet_fn);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_topaz_rx_poll, 10);
 
-- 
2.17.1

