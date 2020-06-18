Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BA41FDA9F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgFRAzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgFRAzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:55:37 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5502CC06174E;
        Wed, 17 Jun 2020 17:55:37 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id p15so1995362qvr.9;
        Wed, 17 Jun 2020 17:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=QkrtFvauH63vzyLl34SLgBXYBYzigso9U0CawvX780o=;
        b=kEUGfJfpHGMgCu7c+K4a12UZVAfTXaQAy5kfhgscxhv/TKrTbfU3whZB3RZtjyODLN
         cA9BnCMs90sxMBgjq6OnVhuQw+MvyaWKcBLwJZVShVCQ3IpRPU8WkpwZ7yrp7fTIgC1a
         vn/soMmN0mV9Vt+D/N2r2eiTCZL9QJhjo8kc+9lawnsy76DCgtoIQccXEatSoxs3+1M9
         txiO827hlQrX0GG7QggjCEtYs8O1+7fsRWTcapXdN2OLCCuF1qx8ZEKLMXtnoh3a5djS
         auF0vWUc2T2OQ1ywqTIwmydmY+i7NOGVZE0czjHptQvqAo4L1YjRF2OmLZ9Ome/MLAQM
         FBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=QkrtFvauH63vzyLl34SLgBXYBYzigso9U0CawvX780o=;
        b=JiQKdJpbt+hIwVO/lHj3RrVmBlrtgarrETm+sfotq0pCLt5zylwWmldycwVTSNBCBH
         V+s1lxXdNRJ02MnrpZiLxKOL8iNEsTlbsnyq8c96btHbhFO9Plfkd8ySOfR0++fCzqiG
         yn7byo9jiaHp1+jLQJR5kYDPEotQD4NosRzZ+Q8ym+K0GxQjDa8XrdLFDVWm17L0dCT3
         AaKlDStc+wsncRG3Po5os622nreEJgWRb70+oK191saFq9Sv1ppLpreRn2knGjiEVX/F
         tY0WartZYFEnfi2z3TTw9bON9QvLajOdbT6dVLR3+fBgQ0V9q4RMJBbGBMXKBgVDxH6O
         OAoA==
X-Gm-Message-State: AOAM530s/tb/+sm0ABm0el7IEQIaBUu4d4bBgsmQroeYcvDB83bwck98
        52fxWuGKgJLvP8uXDlZ3a2Q=
X-Google-Smtp-Source: ABdhPJw3XybahemiQNIeKp8LJpmX8EUeDDm0yVJR0PAc9Jwu3boUpU3kND1lRJ3i9Q8hgAX+/304aQ==
X-Received: by 2002:ad4:4368:: with SMTP id u8mr1326797qvt.227.1592441736093;
        Wed, 17 Jun 2020 17:55:36 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:9c3:b47c:c995:4853])
        by smtp.googlemail.com with ESMTPSA id c6sm1527351qkg.93.2020.06.17.17.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 17:55:35 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TC subsystem),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/sched]: Remove redundant condition in qdisc_graft
Date:   Wed, 17 Jun 2020 20:55:26 -0400
Message-Id: <20200618005526.27101-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parent cannot be NULL here since its in the else part
of the if (parent == NULL) condition. Remove the extra
check on parent pointer.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 9a3449b56bd6..8c92d00c5c8e 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1094,7 +1094,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 		/* Only support running class lockless if parent is lockless */
 		if (new && (new->flags & TCQ_F_NOLOCK) &&
-		    parent && !(parent->flags & TCQ_F_NOLOCK))
+		    && !(parent->flags & TCQ_F_NOLOCK))
 			qdisc_clear_nolock(new);
 
 		if (!cops || !cops->graft)
-- 
2.17.1

