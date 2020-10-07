Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A382C285CA0
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgJGKNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgJGKNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:13:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD691C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:13:14 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id j8so798789pjy.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZXcGDdp/F4MDe0wlnitN/mVcmbFUqJgXDXsl2Sj2Io4=;
        b=ASqNQTy2OP6WI9QiCqc3IIHsfb98jIlfwQbFNu6lazi04kRaetsbGtgIoWCn2cCAI0
         g/lCCBJwWkbxdSHei8C0l7jeQ3+Rk6KYEbkZmLdMI2CeBnyiWZMgMlOAc7glIVS0e81i
         VjXi/C1nff46lzJxq5iLkldWvVB/5/Xyxu2kLK1N4r5fu+Kxb77axx78MIEdgOD4n46W
         tN7OY1UptLzUkfA7ikQ/VHg8zsDbFj6w0CwlNqnQHyRvy0EIC9XrtOffTfEgIiRHgwu7
         2D28K6eV8SLQs6DOTFbPFXJnWxximW5tFRsWNDPVfDOsQJYHwtQeCpIkcl76XNsml0NG
         /4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXcGDdp/F4MDe0wlnitN/mVcmbFUqJgXDXsl2Sj2Io4=;
        b=Dvw/JakyAfE2ywgefOC1XbLqH8J8g3dSeY/4ZyTxCpS5Aedj8UR/RNkUQVAoZORrqA
         AuryAsYjq83iE3U+Ng8DrnlcASLazW+Rg5iDOHT7IlH25jlmTWRPKl5cII/WrAmxqnsr
         qvbOEk/hCdIZ+YxHmgidszCGci7qZ1WMH06qzo3g4kd8w8PqGyphqwaLb35j9tzsj0us
         +GuXZ39ZlJl5HKpZj8sKaeiGMj/rj4ngwA5cvP8N6lZBhS7xrTXj/dB7K82GGP8yTXPl
         TzjWBjDnSZO9W5UoIWHXr6EdkQEAXu9fVUJHNmK6qBOE51yPLb48QSCYd80mWFs2XFI6
         Oa7g==
X-Gm-Message-State: AOAM533aIfcobIHF8TEtwJyAMGWrPMxe0UqbikyLIJuT0LEGdHj1tFgR
        U3oD29BXjSpqFPrRg5TtQok=
X-Google-Smtp-Source: ABdhPJwiYvykiaE9/BI7vc4gvOnNYDGx4fwnH104ZZ80xyVvQHUFNUkTuUrw2en6GlYdXg/kDnmTuw==
X-Received: by 2002:a17:902:bd92:b029:d3:8087:c6c9 with SMTP id q18-20020a170902bd92b02900d38087c6c9mr2169898pls.53.1602065594496;
        Wed, 07 Oct 2020 03:13:14 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:13:13 -0700 (PDT)
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
Subject: [net-next v2 6/8] net: sched: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 15:42:17 +0530
Message-Id: <20201007101219.356499-7-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007101219.356499-1-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
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
 net/sched/sch_atm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 1c281cc81..0a4452178 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -466,10 +466,11 @@ drop: __maybe_unused
  * non-ATM interfaces.
  */
 
-static void sch_atm_dequeue(unsigned long data)
+static void sch_atm_dequeue(struct tasklet_struct *t)
 {
-	struct Qdisc *sch = (struct Qdisc *)data;
-	struct atm_qdisc_data *p = qdisc_priv(sch);
+	struct atm_qdisc_data *p = from_tasklet(p, t, task);
+	struct Qdisc *sch = (struct Qdisc *)((char *) p -
+					     QDISC_ALIGN(sizeof(struct Qdisc)));
 	struct atm_flow_data *flow;
 	struct sk_buff *skb;
 
@@ -563,7 +564,7 @@ static int atm_tc_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
 
-	tasklet_init(&p->task, sch_atm_dequeue, (unsigned long)sch);
+	tasklet_setup(&p->task, sch_atm_dequeue);
 	return 0;
 }
 
-- 
2.25.1

