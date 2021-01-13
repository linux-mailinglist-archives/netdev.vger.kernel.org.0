Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097E02F5039
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbhAMQmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbhAMQmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:42:50 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68302C0617A5
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:33 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id r3so2833884wrt.2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G08JJuzSVjauD2w7RKeXQ1nSbD1Rkjm71UkTsB/zD7Y=;
        b=h/F2lxdrgroIq/ZY7feq74qrpGnTA61pXLA+1K6ZxQ4xipHdZsKQabxegXx/fXVZG4
         go40xzp75VsUfMVjfaRWDi6ePQT9ag/KyKPlFeepMaqsszt6RS2A46MIpjyjjmer7Tof
         e5ah/aAqTMoVBQH4kUIgCfiIwfZfBpaHIoUJHGbtX4aI3TXdOHnnPSFXko8YvLfwyzCA
         I7Y66gaM0frkk6LaXymZ1PVFXETc9mv2q4r33HTYdefp1Avrn+e76kVEPeIrKT04ya5H
         JJHneE3/j586mxObhvRBA1AFdzsAzX2zm5NDznfNB132gdFEShcVMO3tuhKsdiYdjcsf
         zRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G08JJuzSVjauD2w7RKeXQ1nSbD1Rkjm71UkTsB/zD7Y=;
        b=ij5kWDyablPf7B6mudhJBdtsrVUxVse4GiYuD+cVnV3UY4FkwzTm0zNXuOH5j2r5M0
         T+SOaLSfQBYMMoBM/+S+5tNIpk1R4Xv9mCEMReYRf0aiNP1phGUb34L9U950c2X4FFFx
         zciwM+Jd6MN6fILZluigiBWO4IztU38cTwm4qlDMJRmTjiDvRMHAi9myyKN9C9rXmN1V
         70D/ARCubOJIkMQ3ydn5bCPET+KQzmkxHFzmxP4jWqIt87O0KATMX7y+xYqDfIgwoQ1I
         tI5nmMuQsQehPR8J8aCX9YxprELLnGjEwslOvJzkJzQXUdsrD7sQ2cY+pI6oINaytkJ/
         FwIg==
X-Gm-Message-State: AOAM530c0fr7PRg4ls+xgsbTOhStcS5Io2o7iWnxsqPYu1RNg2tFIsk9
        k7Q1hanCDLnFEBHgwi0d1Ty4vg==
X-Google-Smtp-Source: ABdhPJzFuuBL8tK9ckvJbxPslXmyXkwKkz5nZ8AT9PUJkNEdBxyUef5M8KNyQqn6Q4B2SaQCfgj50Q==
X-Received: by 2002:adf:e60f:: with SMTP id p15mr3502133wrm.60.1610556092215;
        Wed, 13 Jan 2021 08:41:32 -0800 (PST)
Received: from dell.default ([91.110.221.229])
        by smtp.gmail.com with ESMTPSA id t16sm3836510wmi.3.2021.01.13.08.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 08:41:31 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 3/7] net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function header
Date:   Wed, 13 Jan 2021 16:41:19 +0000
Message-Id: <20210113164123.1334116-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113164123.1334116-1-lee.jones@linaro.org>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
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

