Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77AFE175E03
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 16:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgCBPSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 10:18:47 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43437 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgCBPSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 10:18:46 -0500
Received: by mail-pf1-f195.google.com with SMTP id s1so5701190pfh.10
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 07:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QfVlUkRWx96jKVo5Y/zvgqtMfTE1JVSuMZ+/gn0c/VM=;
        b=Yz1G6bylSXcup+9lVHIOvskU4X7N7Evo91DLv4Wsag0dAR3/fRUGeV8Xv22Nw4yzP3
         1YYgebs+jRDCkgHra3wskDutg7UNU/FeoYe8VfbfSqMp5CJDnzeCq3MOxj6/B4Mck2tF
         B8ErZ9eiGeNOsTvg9TOrJA8Iw4yo8/2/O98Uf0F+9hdhonILiE6VlhJ7MPlKGk+pTrdC
         hRIzRYFprYhbkHLush/LKpCkhhd13i/YsWk0iNoFp6waEmJIDge+5puXO9u8i3Gfu1tV
         i61rO0O84gNtul5f1zBc778YxA/TXagPNU30OfbNw7dFoie/6bLsnX9Wl/8xO0PrVpSq
         EOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QfVlUkRWx96jKVo5Y/zvgqtMfTE1JVSuMZ+/gn0c/VM=;
        b=bd8lta5Jmt8vZdaFpFsv2l8ZhwZsDMsKra8Gz8+jfQH72bx0pPqzVZbE7KZXM6qW7v
         /M7BQg++FfCVCJ1hR2BvPNm6DqCY/SSEFOu+uhS8KdgJPR0C1LQ3HCPoAiuW1yhRmLiy
         DutjGWsdRF3HrwewhrHJTixyojvzOdp33jGv6dAyWy4oErvTIEcunMhKe6SmxvYEEi+c
         QDjCQWt0j6f7s1dPTU0wtng84+L8F5e3k3oWDZtrP445LbpdcYcTCnIcnCHHmGXZ4Vyp
         SdrTAAvxjVcTSIS93ujuOZitRFFxyrkIblWW6psUK+3C8k7f7p3fLeESaNdHPEFce5Wr
         2pog==
X-Gm-Message-State: APjAAAX/fy95vezV/L/gnGX4mkH9IdGqD+E3xDSpraBKDcsN/uzT/a6O
        J/h1ZdBuiG4gmKMHn2lJ0mMSoogM
X-Google-Smtp-Source: APXvYqzb8z6AEv97sAZRAcOqZ3HZIrks+CWBwE7Ioo/W+FrQCPUJCtcA3UBF4cSKr+IuR7CBZKqhpQ==
X-Received: by 2002:aa7:8610:: with SMTP id p16mr18814576pfn.28.1583162325165;
        Mon, 02 Mar 2020 07:18:45 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id s206sm21908529pfs.100.2020.03.02.07.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 07:18:44 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next 2/4] pie: remove unnecessary type casting
Date:   Mon,  2 Mar 2020 20:48:29 +0530
Message-Id: <20200302151831.2811-3-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200302151831.2811-1-lesliemonis@gmail.com>
References: <20200302151831.2811-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function pie_calculate_probability(), the variables alpha and
beta are of type u64. The variables qdelay, qdelay_old and
params->target are of type psched_time_t (which is also u64).
The explicit type casting done when calculating the value for
the variable delta is redundant and not required.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 net/sched/sch_pie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 8a2f9f11c86f..198cfa34a00a 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -363,8 +363,8 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 	}
 
 	/* alpha and beta should be between 0 and 32, in multiples of 1/16 */
-	delta += alpha * (u64)(qdelay - params->target);
-	delta += beta * (u64)(qdelay - qdelay_old);
+	delta += alpha * (qdelay - params->target);
+	delta += beta * (qdelay - qdelay_old);
 
 	oldprob = vars->prob;
 
-- 
2.17.1

