Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE992C55E9
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390513AbgKZNjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390368AbgKZNjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:39:04 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EA6C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:39:02 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id s8so2163228wrw.10
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=szFDNNaKEVDZSNkDXGPen7gT5j56LfEHgacJ/wxEkwY=;
        b=XQcUa9RJyQ/gWcNlwnIDYsoz9CPu4L8xvrmIDJ592eF8o2DJIReBeKuEc+gq3RRIt/
         nQPH+ufwSfcAaL79gTVRhMaOZMiJcnEbwQqiP3QYuxR7R/z6gos71eyI4Adzxafv5hNm
         vXsy+OuhjicOJnUejRk/8eALGEpjzxBm7D45YOIStx0Qhtc3zo/OSBnefvVKWryXENLY
         F5Hk0U55K0ORvu8H6H2hl3KqbQVkyuh3xmHx7NQ2ojjKsibIT6oH434LsgM+/cBPxa5J
         6HaLrGMfOh/MCXSDhdbeUX7GBqmkVMj+Hv9eMwzP3iL3YK6MB5IksUSO5A0rnBSuoe4y
         lscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=szFDNNaKEVDZSNkDXGPen7gT5j56LfEHgacJ/wxEkwY=;
        b=H+JicQaFozdRPQ39K1ASuYTvoY2ogXKqFW14rhIVJPBSa+jonwRejzuC7wQsmrP3wM
         WO86FSbRKTYMpWlmeACnEjeZyMMWX3qhnO89LkLoHIL6o7cvumyKRa1ssNpgaibz818t
         9qJdQ2fSKnYFAsQb2YyFDymv10k2ul0bGrvwhrYp1VnW+Jtv+hTXvNmb3ahrHaCCK0vj
         dYkIQlo4Mfy+FIxXmApqhBu74UC53lhxe+Lw2zD+HK0t0rC8HN9cefVNWYaHPFcgc3fJ
         3sNgx7MSBw6uZYcPnzYlUCMLWHv9eEirfcCgJp2RCu7+iHSYEnD/f5+5YA9+uSXziwgA
         2YoA==
X-Gm-Message-State: AOAM532nG/9yJtGtE39ik6rlse/02vY/fShSNdfcKy02eoyXMvIrHb0b
        FuwaTefHKLZ+/SBro1OAeGB9Yw==
X-Google-Smtp-Source: ABdhPJyhCYTyjqMsQtRTV3z9ziWXG4cHAd3j08UndG1d38L+TaN2yXdvWRjgLSbALCW+AFDo3ljalA==
X-Received: by 2002:adf:f1d2:: with SMTP id z18mr4168184wro.244.1606397941240;
        Thu, 26 Nov 2020 05:39:01 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id s133sm7035825wmf.38.2020.11.26.05.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:39:00 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 3/8] net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function header
Date:   Thu, 26 Nov 2020 13:38:48 +0000
Message-Id: <20201126133853.3213268-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133853.3213268-1-lee.jones@linaro.org>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
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

