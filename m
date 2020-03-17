Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB018781D
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCQDWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:22:36 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38382 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgCQDW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:22:27 -0400
Received: by mail-pf1-f194.google.com with SMTP id z5so11136245pfn.5
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 20:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Kh1lVmiW2UcsTpytBjVKvk3IZRJxfjUMW30Es8ZGulU=;
        b=pTUMrTEsASOXGR0zqkcKFbxN1Emp2rJVxmH70EKBFxfH/PqGCkLSITzJG7g3TaPWJ0
         4+GLK1CeX99xt18vKGbt3RbcjwCEKlnOUs3z5eXOqFDTxjdgtvw2SdrkCtxlT8ORpoaL
         uyXvP+QpUFwDEnQnnjoFUNLzFLPMHlYifJlAH8kH2XmTdNyaEFD3hzSWSOefi1KgO++7
         WGhkLM5NJJPWi9CHefZL82FpQ0dAGqs1l7AISDUWmlEqyMN3DOnI2C3YHE6tbr8ev6zz
         dp0a8meQ2hswYxlHtEObOHH0liYZ8fipypRy3BcF8di5AmtwIISE3J+RBnStDuIrndV2
         MwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Kh1lVmiW2UcsTpytBjVKvk3IZRJxfjUMW30Es8ZGulU=;
        b=Da4iDE+77ghwpnxo6I2jJcVXDo4Fi/klCgGtb3jkEd91NlyBMbaGgUpveODzN5/f2p
         IQ5QbxpKioUKrcwnnfQwHOKeMXJ3SlHG5HTKVWbA++C3wfhIZBV++HyzawF533TWoYAa
         o4g+7ltd9vPE+eBAaoE+x6vTLNe4yLlZ0PYU8lQ3+MqvBq+syKc/9wKTOZbJdxBi2yiG
         1K5rpdTP5YF+wGWdNNM8muxGRRqgaAuRFAKb+sOsGjLGxHk7gwUr8E1thbUqUSwFdhgJ
         UkajL7mQS5IheX5J5R/i8/krPqmaRUkqjEj1GymymJl0SdBJYPOXkGfmI7Mqu3CFz+ek
         DqGg==
X-Gm-Message-State: ANhLgQ04zjWyInOqypvTprvoEy3X1XVngwPtcnUUfec/YRCGpmbCahUS
        WD6jpvRcvwLc56War9BPhOrvnuz4xKk=
X-Google-Smtp-Source: ADFU+vuiSyMcwZJZjVJIvTXLBUz+GNO3ZW1GWwvl4GErh9fmWJORRn9I1gZ95t4BsD9lm4bbmKzGQg==
X-Received: by 2002:a63:5506:: with SMTP id j6mr3006325pgb.284.1584415346143;
        Mon, 16 Mar 2020 20:22:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f8sm1185639pfq.178.2020.03.16.20.22.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 20:22:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 3/5] ionic: remove adminq napi instance
Date:   Mon, 16 Mar 2020 20:22:08 -0700
Message-Id: <20200317032210.7996-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317032210.7996-1-snelson@pensando.io>
References: <20200317032210.7996-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the adminq's napi struct when tearing down
the adminq.

Fixes: 1d062b7b6f64 ("ionic: Add basic adminq support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 19fd7cc36f28..12e3823b0bc1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2070,6 +2070,7 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 		ionic_lif_rss_deinit(lif);
 
 	napi_disable(&lif->adminqcq->napi);
+	netif_napi_del(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
-- 
2.17.1

