Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1242A3D32
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgKCHKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:46 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF0BC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:45 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id t6so8129857plq.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ge4cLiEBpSy5TOrMrj/Ga+3tavq0F26wgBOD5vzjV8U=;
        b=RFNudsiGoK+LANJ0iVEYmDYmPB/IE5RuM5obRqEh3XYHcmq+S7jWF/E2liz8AGBBQi
         msLYjyAEHboQkHW1uI1REuudFlZ/iIDzGy5qK+ynGw2h/QE9Gyo+BcVF9hz6MCbnIWj4
         cFSe/uoyU8z9LvHY7hYp8DS2NzsgMJBDg2n64ya/uliJRrklJlIo2kf/b0helJJrWKDu
         t3cDtiUDO+frsWaJ0moLr0NzC2Gc8THs9rwQE1/M2G75Bst2iTJSw+E2db7FzQmR1Ok/
         g09szASQF2+QR1+MCDf0ekiVKvW+KRSxYpJMsdUn8m81I+E26ErLWG2RDTpvKEkyq53Y
         6uEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ge4cLiEBpSy5TOrMrj/Ga+3tavq0F26wgBOD5vzjV8U=;
        b=daMSX75piOoyBf8e23PCFqwAFQbSRsjd2x1+zedBVVl5O0TTL6KLjZmd04fGc5QVgU
         E3wu6kyxwd19AGw3fgY55fWm625uAcsIlrTwVl53TKye0yawqWoThSkP2vPUpV5QFiOB
         LJ5AJ/wscblN8dHBJRj4eFJn1nv1rFlJyLhGtfqOcXrb3B1GKH2BkDvCk1ZJayXuuOry
         QfVLOfnlK4WPrACDWEa9kwaaNxyky09gr2PbjUzXB/ciTRFJZkoF6pYiFZZByvwbiWnd
         2bmGjhomugFyH1GkYJSUkfl9ACUDPY0Pu6TPdwoH49/oCcXjBsSN/8I6dUkWtdxfqxGD
         /iIA==
X-Gm-Message-State: AOAM531aaFVhCItPG/AIuP29gHexmncPxkidEqr7yhEDCjFF4MM97bSL
        Fs5njP+p2HpbhFEf2fFxL1A=
X-Google-Smtp-Source: ABdhPJzZwWj26cQwZ8/57guLBoKNkwCKwybgeCJpb6VVtp8dZdyzLiGhpeSS7hAzS5VxHrNvwelP6A==
X-Received: by 2002:a17:902:76cc:b029:d6:6007:9372 with SMTP id j12-20020a17090276ccb02900d660079372mr23305695plt.50.1604387445603;
        Mon, 02 Nov 2020 23:10:45 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:45 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next V3 6/8] net: sched: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 12:39:45 +0530
Message-Id: <20201103070947.577831-7-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103070947.577831-1-allen.lkml@gmail.com>
References: <20201103070947.577831-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/sched/sch_atm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 1c281cc81f57..390d972bb2f0 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -466,10 +466,10 @@ drop: __maybe_unused
  * non-ATM interfaces.
  */
 
-static void sch_atm_dequeue(unsigned long data)
+static void sch_atm_dequeue(struct tasklet_struct *t)
 {
-	struct Qdisc *sch = (struct Qdisc *)data;
-	struct atm_qdisc_data *p = qdisc_priv(sch);
+	struct atm_qdisc_data *p = from_tasklet(p, t, task);
+	struct Qdisc *sch = (struct Qdisc *)((char *)p - sizeof(struct Qdisc));
 	struct atm_flow_data *flow;
 	struct sk_buff *skb;
 
@@ -563,7 +563,7 @@ static int atm_tc_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
 
-	tasklet_init(&p->task, sch_atm_dequeue, (unsigned long)sch);
+	tasklet_setup(&p->task, sch_atm_dequeue);
 	return 0;
 }
 
-- 
2.25.1

