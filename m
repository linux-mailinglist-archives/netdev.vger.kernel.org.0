Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A2F179873
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388296AbgCDS4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:56:18 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:32989 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388219AbgCDS4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:56:17 -0500
Received: by mail-pj1-f68.google.com with SMTP id o21so1293544pjs.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QfVlUkRWx96jKVo5Y/zvgqtMfTE1JVSuMZ+/gn0c/VM=;
        b=m5MGSYwTyu6J9JMdS38fNe++fsrnHqGPVHWk1hBTmp8QJ7W6bkEZLBo6rVmiuVfO4y
         8lf6bUU2lJPHAXTZqKqeE2ecRufQDBGSs3pSGccVImWcdddbX0mxp5pkqDN41AvFVpWf
         IyYUzirJH6VSbWIkmHSMJrRtzXKJU+g++6JzbO1K0Oa0BPGXZJ2BQu//xikxcDny6/fw
         +0L1P6+M5sbGdoGIEXWh8dRnm+VgXr8QXh2TUmtoU3TMsTOwceYUbFwip9YslXwhan5e
         pjK8WVZgmhP9T5F/RIUrJDDke5QXYCHMser9BTtgyJLNuGiHRTCYL8A4PJnZsPC5PT9r
         e6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QfVlUkRWx96jKVo5Y/zvgqtMfTE1JVSuMZ+/gn0c/VM=;
        b=SFfOEGQXGMeiT5ady1Uk8NVUm7Dl5UsiO6Qurby2V6JJE3bxJiYtb4fz+wsXhzkToD
         oCXMNk/V8Y/0JJ/9kO2nmRtgY1AG0vK3eQIUDe/XNGmrJKAyCFL2+Bf6d6D+mnkAH9Hl
         HDjF46OGdfMzye/prllN7QjmewyGFP5V3em2ooYG2wgslLz6Ynnx4PGdgSrpaJ57O/ae
         Dbr3lBS5hvH6QXOByejiB5/3nA/yDMTjpDcbLx94DCcDTIpeT79B+OZY43qAoS+CMAkR
         Y57Cd23lGVWlULRkYmp/S74LbSxw9CluPzcLAl2TqBXz5JxG3+fgtfgIS8pKluevk0LL
         wxMQ==
X-Gm-Message-State: ANhLgQ05BTsic2/RHi3pyk31wRzbvYspP2/wZzi53Dmw9z6AtKWSz/ja
        LnPmKjOLLqdADqb5axjnuGGW6rGM
X-Google-Smtp-Source: ADFU+vta9zkIQyaoTzU5HPxnSkYTZJHd52u45XxXx9hz0Bu78O90qWj4Af7p2kR0m/MqRf1e47zM4A==
X-Received: by 2002:a17:902:b089:: with SMTP id p9mr4195737plr.85.1583348176455;
        Wed, 04 Mar 2020 10:56:16 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id h12sm12720021pfk.124.2020.03.04.10.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:56:15 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next v2 2/4] pie: remove unnecessary type casting
Date:   Thu,  5 Mar 2020 00:26:00 +0530
Message-Id: <20200304185602.2540-3-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304185602.2540-1-lesliemonis@gmail.com>
References: <20200304185602.2540-1-lesliemonis@gmail.com>
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

