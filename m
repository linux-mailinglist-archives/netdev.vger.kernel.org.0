Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1911000D6
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKRI5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:15 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37600 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfKRI5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:57:15 -0500
Received: by mail-pg1-f194.google.com with SMTP id b10so796737pgd.4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dcHFOyDCfRkCHfb/8xW+LBRQYXUKmyp7A+x0woA1Qs4=;
        b=O8Mhtyny7SjKy8cd/TBm6iqdUkkJUTMJFYcWwEj32abvwdI31ipgmUwcSGY4dqvD9Z
         RUdu9o1ds9qbPz7J7LA18HlhrenJmi1oUwQPIzfAVeCIyTBAp1xHx7dmiesQCQPx5uUM
         8Nt95FganBOAFGPaasWAd9g5WiPjEq7Qy5KQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dcHFOyDCfRkCHfb/8xW+LBRQYXUKmyp7A+x0woA1Qs4=;
        b=ScGQs9M9fiISQ+IVDVgZg0gDdkM6R4qZM+//C4kaerN57AjdFN5vFawtmXXlCNXZ9n
         Am71PkFtC0MYLQDjPIf8ALR7k9eUrV+udJsSmyAnSTZoqNqRq522psGyuQgsK75xxQxm
         PsOjVPoEWirIA0UOZHZvb94o3xd6jK4zyFnHX68ID7MvBApBW+gH4dRBaxXvQFsskQiQ
         p9askrZr2o6jlr/5BP7ZMHyV+G/kw6y6/cp0ud3e5OQ0wezOVSumUVomw2z0HbaydI4F
         KmQgP7yDvZitAJYvPeuoCcm7rzGcqMqpPOEgf6lORFWN5ZU1r93aA2ixHdJ/R7wG9PWs
         BTEg==
X-Gm-Message-State: APjAAAWuE9/PHQ9+G41glvqALYBHkwYsVVrWw9nb0RN602JC9aRua5XN
        6HH9NUMdOHqbBTBReBMYigCNrw==
X-Google-Smtp-Source: APXvYqy92tjNUfRZJ2g6LGBUNXG34MUJIidxFfCZBMf+IvPBMuRWXAF3fE6GB4an1Oq/F8paqVGPZA==
X-Received: by 2002:a62:606:: with SMTP id 6mr9956930pfg.76.1574067434252;
        Mon, 18 Nov 2019 00:57:14 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:57:13 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 8/9] bnxt_en: Add a warning message for driver initiated reset
Date:   Mon, 18 Nov 2019 03:56:42 -0500
Message-Id: <1574067403-4344-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

During loss of heartbeat, log this warning message.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a168324..55e02a9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10122,6 +10122,7 @@ static void bnxt_force_fw_reset(struct bnxt *bp)
 
 void bnxt_fw_exception(struct bnxt *bp)
 {
+	netdev_warn(bp->dev, "Detected firmware fatal condition, initiating reset\n");
 	set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 	bnxt_rtnl_lock_sp(bp);
 	bnxt_force_fw_reset(bp);
-- 
2.5.1

