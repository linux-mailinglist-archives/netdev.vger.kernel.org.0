Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32B2357862
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhDGXU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhDGXUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:24 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D70DC061761
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t23so122085pjy.3
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m/9XuxMbW3hH3rKlIJe8JySYt6M7v6ziCPcT5/gS7As=;
        b=DDvrUSkuJFeQLI8dqpn3wTs6j0CVWLgf8p5+zw9lLG9UuuP76br1r5p5WIJshO3KpE
         hz5AH/HyX2TTjxRWUjs3oG1fGP8/zOxKlEZwbSzBYCv3+JLUd2vujHw+lnDbt3/tZh+b
         1qKeuUgX1knIchj6OsaT0cM4ThPfrGQWqiP5sDWBWEnlXLgFbeGW9aaD4tO9FPhl3CHn
         TvRYT7Xys2oyc0EqqFA31NZ06PqaV8uSOVN2blL1V/pnOYJmd1UroUJXenCi9w2H0YuJ
         LadLT9ph1xm2Ug61fM4EwMzclwoaRBhRlR6YZxHaszc8UQUNw6QZhhEfEv1qAUVqHeAi
         Q6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m/9XuxMbW3hH3rKlIJe8JySYt6M7v6ziCPcT5/gS7As=;
        b=iBdbsZtbzOn59y/kuNwAvd9fGL8TZaVi+W0u4+jqAnub28/qeDrxorsy7TCv4fpnSN
         z+/yo5QQw1KoBuKlAkeNWZ7aaJOMiSsszlc+WfJS/DDZsCgxkZ2a/hbFa1MA1FNvZY4r
         H+KXt9SP0l4LDV/XKb8vCyjYnKgupJIHD2VNZsGZgZNAvK5RQ2EVC+8Iv/YCGYtLn/OS
         O2T/LL+eaz+vsG/Tn3xHz0Z9cY9n8Y5gz9Q1si1al6yresF28bR3+cpHOIQkT66b3hlA
         z5dPE9+RIfXG7pn1nlxFcSE8/iNbplF5xTXzMDFA3A0MZoswXSioek7amEPAMhcJRrqP
         3WDA==
X-Gm-Message-State: AOAM532ndP5MTFNu+TeKmxSm2RiI88vLIbkMInf6FvELVooluP6yqEbv
        9eib5Ud92MAjlhAkCUy8w+qiu4g9N/tUYA==
X-Google-Smtp-Source: ABdhPJxjolUM6koz462IaZIh539ENUW38B9+H1G/HrJg/adHOpmWnnZrXPs7wdACaQVSJf+OrgnqRg==
X-Received: by 2002:a17:90a:66c5:: with SMTP id z5mr5552101pjl.172.1617837613826;
        Wed, 07 Apr 2021 16:20:13 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:13 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/8] ionic: remove unnecessary compat ifdef
Date:   Wed,  7 Apr 2021 16:19:55 -0700
Message-Id: <20210407232001.16670-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
References: <20210407232001.16670-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to look for HAVE_HWSTAMP_TX_ONESTEP_P2P in the
upstream kernel.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index 86ae5011ac9b..5d5da61284e7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -18,10 +18,8 @@ static int ionic_hwstamp_tx_mode(int config_tx_type)
 		return IONIC_TXSTAMP_ON;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
 		return IONIC_TXSTAMP_ONESTEP_SYNC;
-#ifdef HAVE_HWSTAMP_TX_ONESTEP_P2P
 	case HWTSTAMP_TX_ONESTEP_P2P:
 		return IONIC_TXSTAMP_ONESTEP_P2P;
-#endif
 	default:
 		return -ERANGE;
 	}
-- 
2.17.1

