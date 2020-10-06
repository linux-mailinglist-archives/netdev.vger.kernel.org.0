Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF49C284614
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgJFGcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:32:53 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4791AC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:32:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so7436671pgl.2
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h977mUiOPKts4NfGUd35JNFFBJWMeM5ufmmYLU83Tco=;
        b=pmJcPtsUAD7tafWpGLBMnUY+blMz9U/qoV9lD6c7FC4vcdbbTYkjlDyB9MZt/HojYl
         H0LtgXJGPQAd7UCWHbQGh89+Rti89k2pyhc+8IYnuSqdLUlMg7Cm0MCMfX2sJ9jZxG3e
         ho1yk5GXQQGl3VczV0lJWC17KG0shmZA73zPUsqBoNQO6mAOwJ92szQkrbzTh7yTA9A7
         tpn8rz3/jnjBsZQ+dbxVOhs9GPQ/QFuB2nBMxn79MXH/Y4FzRRuflE2uccmB00RVtJ/d
         ZSTJ7w2XkJITyO3LeLxqWjjGajY/luqohmZ2AXbjb/e6mkhJ1tfGSgJYPaPXZ+gNgDc6
         Wjrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h977mUiOPKts4NfGUd35JNFFBJWMeM5ufmmYLU83Tco=;
        b=GFAB56pphrliQHmPvWp4upRgibc0SW7OobgsYamG20kup7D3JasV1ZIicuCnTu9BCf
         ITzG+xfyO6KdJHTRuYSKhKrJwJ+0DXOwSjPb+pdWLA9+ewI+W8jqhZyprhH7IDk/Kxem
         cHMmTpZogU8Zg+7LW3gSJYNVDCZ0tOkbNH+kd0AljHhz1VoC3G9z5iXjdqq2cP0deJHd
         8yhkF5h1aEy+VNoazZ5fVnw/YVLJ06Tc088UtNPBWJkUFUvT1elOd2EPxayQHKsquQNB
         wJr5sPIUTzjQS4Kg/cj7tG3FSqqFNJ4kEClhcMA8k0flWcetg6Rqd/YSlt2RBJdeiXaF
         ApOQ==
X-Gm-Message-State: AOAM5318PLrcWmjKqIJnb5o5fulSUpdgILQ+kOY8Opgfmjm4VM6gzV6f
        x70VA0nPN8WQ9Dy5YeRMz3w=
X-Google-Smtp-Source: ABdhPJxHDmhhv68PcuK12VN9RVfXtIyvwpv24/ulgfUPkeKKL6t9km6w1mrGiHBNuD9ttTI4kepoTw==
X-Received: by 2002:a63:c74e:: with SMTP id v14mr2724527pgg.186.1601965972853;
        Mon, 05 Oct 2020 23:32:52 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 124sm2047361pfd.132.2020.10.05.23.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:32:52 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: [RESEND net-next 6/8] net: sched: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 12:01:59 +0530
Message-Id: <20201006063201.294959-7-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006063201.294959-1-allen.lkml@gmail.com>
References: <20201006063201.294959-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

