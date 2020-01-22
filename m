Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9A31453E5
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgAVLgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:36:10 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35565 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgAVLgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:36:10 -0500
Received: by mail-pf1-f196.google.com with SMTP id i23so3259891pfo.2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lLPfkaHUdJk91hEn7ISh5HhzYqtAwjmDshBoNiXJGwM=;
        b=Tcdashgpi4sxLpbc07DW2t5OskG1oCjEwAXNEoHAUKaT2AOb7j3TTonT5ubptlSffM
         nZHSCILCmLziyIaCr0gKO5zEfVNKz/REs5XiMOIG/lU37PAPMQGbHxLn2Bk/QU4qt4K/
         Ce7YOKw+b6hDGql5yaS/cLZ09o5u7b3h3CAD5vLVKnID8halGbbprKFHEh4s+IDBuAla
         qXOcAWIvwbZplhYjFuxb4mVrkCD3cE4TjszxGZofCpz+P35o0wvDzjcyaLmXYDXnuht7
         g4bnFw6YHPr82fXYii4OjUhemObM3KcHx2pTpFwz1Gpo6W9mjtxnTKuOTBlH0V4tbu5O
         LCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lLPfkaHUdJk91hEn7ISh5HhzYqtAwjmDshBoNiXJGwM=;
        b=CF4SXSCvk8WMpZOagF3Yz+rqxQPmNOlv+A+wXtBKYTJsedZce5AoBsCVJLXpINtbhY
         fZPIG4b+7PjgM9uyCuf/cJLBl89IVWkmZiXX7odPushiLVhby9t6xWfkkSWA1oluqUKi
         zO8KBPiaapURKML1ck/nSlCuy7sP054bPnsuYf525ZxhqRFOyRTiRdNxRF7KsDgAl3tb
         H8nXo6uGWI29FjwqcuC6/zQjSGoUh2l86zC6Yjv25ZDXu65SnxtpBwtoqnhy4dWrlRiF
         JvSN31rpEUSoAs82SlnfxVgn+TIOSxi6EEzjmz5KcCg9b2m47cPuH4fPNxxQu98uEYcV
         DRvw==
X-Gm-Message-State: APjAAAV1nIQZTcGmMJmIXq+OT9s5bTVXCb/f86tuI/33kWtn00slE1uS
        soCDw+LnvKiZ0t2RBqayVbViETqmche7L0ER
X-Google-Smtp-Source: APXvYqwX2QGOUiJ/5No35WRqbwTOlVJn7DgUAh3uqG0xvbjYPzdtLGQJailOT0RcssKK8L1OwqfiQg==
X-Received: by 2002:a63:5fca:: with SMTP id t193mr10728874pgb.28.1579692969091;
        Wed, 22 Jan 2020 03:36:09 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:36:08 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v6 04/10] pie: use u8 instead of bool in pie_vars
Date:   Wed, 22 Jan 2020 17:05:27 +0530
Message-Id: <20200122113533.28128-5-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122113533.28128-1-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Linux best practice recommends using u8 for true/false values in
structures.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 397c7abf0879..f9c6a44bdb0c 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -21,8 +21,8 @@ struct pie_params {
 	u32 limit;		/* number of packets that can be enqueued */
 	u32 alpha;		/* alpha and beta are between 0 and 32 */
 	u32 beta;		/* and are used for shift relative to 1 */
-	bool ecn;		/* true if ecn is enabled */
-	bool bytemode;		/* to scale drop early prob based on pkt size */
+	u8 ecn;			/* true if ecn is enabled */
+	u8 bytemode;		/* to scale drop early prob based on pkt size */
 	u8 dq_rate_estimator;	/* to calculate delay using Little's law */
 };
 
-- 
2.17.1

