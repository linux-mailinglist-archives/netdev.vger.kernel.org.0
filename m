Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85ED2F8655
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388512AbhAOUKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388376AbhAOUKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:10:37 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA92C06179B
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:09:20 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v15so6823354wrx.4
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G08JJuzSVjauD2w7RKeXQ1nSbD1Rkjm71UkTsB/zD7Y=;
        b=D2amWQb9S98u/P5DUNkplruHJE6hVhzLyueXRjLidi8RMYlvYJAhCpbqxHg8k2MQjo
         1S5+7meCyWYbaXQZbhA1FJq7SfDR4nLyt3j+Jt6tJEev8HvJlVpqybhK+MTf4jK6+e2h
         HS9/myq1P0yBGJaqe2Pdye8TlfM5DlRC8+TwEZ7Z/eiUi1viUgUJV0tIxTxisRLNHbl8
         mizOpFQFPPkvu5KawxfqOWdEdA8g3UnjMV4D+VIDsTy6ig7B1lsk04d/E48bCNSbazJh
         Jhh4KjgIY+FL2YJRew11Mc6SL7julFqzizygkgUi6ACy04C3SN41sqQ8XmA7gQqzqJ0g
         uRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G08JJuzSVjauD2w7RKeXQ1nSbD1Rkjm71UkTsB/zD7Y=;
        b=C0e02Ynqt6bm9UZCym13KmtoYuNqLVjJAVI8157XsrUXtBLPFE3T9/hrN8muUieiFp
         bPdTtBOVsl+aIU50vZVYzbxYOAxM0NT6uJJ8xfMDr+74e+5lQCIwPvvwASWql5Jr8YVS
         rfhPR8cFOkz88drCusQV27CZ/llrXuRYzK6d4gJaplvNLUgr7wND1/49d4mpN2oaEhPI
         BFcTabJ9HdE+r32SqwmOuU2zZMKccdEL7Jq6tcYwDuFk+gGlQ+VlyhF7TxqIMH5hU+q+
         7j2U5GLJMfGgORs2x0G+Jm5bogsyuVrFn34J0Ueigvf7kIYX/jj8D3cWt3PmXnVBOPiO
         ou3w==
X-Gm-Message-State: AOAM533W6tngQBgaO1OpvVWRxFHv2EH77bKC8Xv4hypVWfirkxaFpI5A
        00cRyMhyanJhV4DvsJGKtMikECbOdLrLYmYV
X-Google-Smtp-Source: ABdhPJxfwfguWvKcJ2QuCcwdTin9mx4tSWoLnGUHJZrmHg1o0XwnvHiDMbU3NCBvaVyzrd7wiS0Lsg==
X-Received: by 2002:adf:e9d2:: with SMTP id l18mr14392232wrn.179.1610741359077;
        Fri, 15 Jan 2021 12:09:19 -0800 (PST)
Received: from dell.default ([91.110.221.158])
        by smtp.gmail.com with ESMTPSA id d85sm9187863wmd.2.2021.01.15.12.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:09:18 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 3/7] net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function header
Date:   Fri, 15 Jan 2021 20:09:01 +0000
Message-Id: <20210115200905.3470941-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115200905.3470941-1-lee.jones@linaro.org>
References: <20210115200905.3470941-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'ndev' not described in 'am65_cpsw_timer_set'
 drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'est_new' not described in 'am65_cpsw_timer_set'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: netdev@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index 3bdd4dbcd2ff1..ebcc6386cc34a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -356,7 +356,7 @@ static void am65_cpsw_est_set_sched_list(struct net_device *ndev,
 		writel(~all_fetch_allow & AM65_CPSW_FETCH_ALLOW_MSK, ram_addr);
 }
 
-/**
+/*
  * Enable ESTf periodic output, set cycle start time and interval.
  */
 static int am65_cpsw_timer_set(struct net_device *ndev,
-- 
2.25.1

