Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231412A3FD7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgKCJTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgKCJTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:19:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D765C0617A6
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:19:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 1so8301005ple.2
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J6To5x+/NpmSzPdToXkC2fL7RskesiLWAv1XVW6Uqzg=;
        b=rMOaIqgtb1OJTjCIZcMzutVqgJxqmPfR0sSLjUCmhI5NeSb7GUnj0igqQnh0R9Im5K
         hayoThholeZ2oQ43TihklgISWDsyrcy1m5/11JMVa+ORflttjN9TjGmnLTFE/K67HehN
         oSnm8UrMIMoU9nrgSsmiKInBO3pwoR2Mz2bS+ILd5cTBimxZgHhm42bJqWusjPYm6eTb
         4YEDiO6xDaH/n3Crf64dietkoLtbzruVEhBDPkzprFTOQkw7gq8U7cqJy81PlcaCPKuQ
         Gdf3yvHdzNB/kenTD8j2ddqtUVLwG+TYzt7TuAcCLogPp3eFWlZTQAd/lCf/eXC+Ldl0
         Nd6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J6To5x+/NpmSzPdToXkC2fL7RskesiLWAv1XVW6Uqzg=;
        b=k9BVC53YHiSsRO1V83AvkeExN/UJoryyDn6fqngMxlMDLRVS8wWLDRAX1LPCmiqJ+z
         VskpqaC0GZPfpJBBZP2dl21qNzDA3g2LVnZOYbRybJ9Y+qcaCj6E3j/+J80mEmEtalJL
         VU8lXIheJ4GSv9Y48oV9uyb0g49+w3fzWMpUOlQuEBeDCN//h8VqWnjV9UnVD3NoEEDM
         e801cZw1CnIo8jclevJW3jphFpXYDpjnUtKvKygal+WeMghBil5jaLgicu3vzyrpgwng
         xzEFb1TWD1gNJ5cAQDTgLJ/ReI8/9BURPSzvJqgpg4j/1vFB5q36iPgLco4UdpN2id6T
         eOvA==
X-Gm-Message-State: AOAM530UoW2RS3o98nP07D8qNXRSsNieu+rrMeUctJ+8hGDR281ZZUsH
        qqulaUL+6qsaPpuTMAfmBDY=
X-Google-Smtp-Source: ABdhPJwThl9EQ50CzXVrkPlMCCotgWiX5LyWomgN51fAHRZWAHeEwpJzKhqOboGZ6K84Bo0TN70SNA==
X-Received: by 2002:a17:902:8215:b029:d5:f299:8b11 with SMTP id x21-20020a1709028215b02900d5f2998b11mr24548965pln.39.1604395155046;
        Tue, 03 Nov 2020 01:19:15 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id f204sm17178063pfa.189.2020.11.03.01.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:19:14 -0800 (PST)
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
Subject: [net-next v4 6/8] net: sched: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 14:48:21 +0530
Message-Id: <20201103091823.586717-7-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103091823.586717-1-allen.lkml@gmail.com>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
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
 include/net/pkt_sched.h | 5 +++++
 net/sched/sch_atm.c     | 8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 4ed32e6b0201..15b1b30f454e 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -24,6 +24,11 @@ static inline void *qdisc_priv(struct Qdisc *q)
 	return &q->privdata;
 }
 
+static inline struct Qdisc *qdisc_from_priv(void *priv)
+{
+	return container_of(priv, struct Qdisc, privdata);
+}
+
 /* 
    Timer resolution MUST BE < 10% of min_schedulable_packet_size/bandwidth
    
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 1c281cc81f57..007bd2d9f1ff 100644
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
+	struct Qdisc *sch = qdisc_from_priv(p);
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

