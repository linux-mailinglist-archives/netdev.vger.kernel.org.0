Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364AE2A3D2D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgKCHKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:13 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88628C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:13 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id w11so8133679pll.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gkuxstg5R+uheA6phR4fMLuBUdOEwyAXqM6AKai276Q=;
        b=jjU2X5BGCjSufVsF6Vf8JaiE09CcuHw3gz+rGFfmWoMig1rsOkioAke1Xip+ZMlSDm
         MM70okCmAygdERvD9/zV/dxOLyLjclm8xILCiMhHS0Hrigh/ygk37FmaXzxW2D30jFvF
         B8UpL0AqNbyERTB0X/6yOmdFmACnoSlEp3Ue+E1kr8+mFf85r2GqUoMIWoVLAVS1VLwW
         U0JkJFtIMICgrM28G5yyDpCrSlFgkVZCDDO/KdzRHZc2bU9MX+EaoRT43V9Oi3vCVR9N
         doAuC5o0W41G4V+DkO4hMIPlODwJkYVJ90znRWrXgbv47bB3tnN+9S0k2Uh07RDPhznu
         GOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gkuxstg5R+uheA6phR4fMLuBUdOEwyAXqM6AKai276Q=;
        b=pjRfOhMeRlAiqZkzKvPTeaZgpM1IOTPNdh6QNZm+0dq9YGsKuSwnFcCtIaYRjWgFua
         wmf64UfG7514fbt0kOeWOWnB7pLiko4mYT/DCL2byD0btN5t+A2L5kuZL4AHqDfcdweC
         K0UOWKpZhJijkgbKg0Zh0iR72rxiGAPsNAcNXpujY3zjzCpqyu93g7GSQVmYZya9OhkH
         KNrVEK8bjyvNXArTddFWM1F9Y0zltGKCqjbb0IIs+kIHfs2jNtEyUcLRUde3IX91+ScA
         IotpJ3ut9/mu0tWUqsuJjrDha/r4q06go4qkSe2rUqqgddRfL8CzuEBvnuJj9IBIqAbr
         h1vA==
X-Gm-Message-State: AOAM532pk+3Xclit+0DVXSfni8zIjLa6dsSB9vMH/deRuhJlG9bFyOsp
        V2URJWPlD7kAgpAPmhFzHkc=
X-Google-Smtp-Source: ABdhPJzB6IjXJmRrcSNmQNZzK5NuQIFihx9hozJBewl6TEL6CxenPnvnR6YueGhc+x5CTbaQFRykhg==
X-Received: by 2002:a17:902:a584:b029:d6:4a70:3241 with SMTP id az4-20020a170902a584b02900d64a703241mr25151304plb.81.1604387413110;
        Mon, 02 Nov 2020 23:10:13 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:12 -0800 (PST)
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
Subject: [net-next V3 1/8] net: dccp: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 12:39:40 +0530
Message-Id: <20201103070947.577831-2-allen.lkml@gmail.com>
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
 net/dccp/timer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index a934d2932373..db768f223ef7 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -215,13 +215,14 @@ static void dccp_delack_timer(struct timer_list *t)
 
 /**
  * dccp_write_xmitlet  -  Workhorse for CCID packet dequeueing interface
- * @data: Socket to act on
+ * @t: pointer to the tasklet associated with this handler
  *
  * See the comments above %ccid_dequeueing_decision for supported modes.
  */
-static void dccp_write_xmitlet(unsigned long data)
+static void dccp_write_xmitlet(struct tasklet_struct *t)
 {
-	struct sock *sk = (struct sock *)data;
+	struct dccp_sock *dp = from_tasklet(dp, t, dccps_xmitlet);
+	struct sock *sk = &dp->dccps_inet_connection.icsk_inet.sk;
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
@@ -235,16 +236,15 @@ static void dccp_write_xmitlet(unsigned long data)
 static void dccp_write_xmit_timer(struct timer_list *t)
 {
 	struct dccp_sock *dp = from_timer(dp, t, dccps_xmit_timer);
-	struct sock *sk = &dp->dccps_inet_connection.icsk_inet.sk;
 
-	dccp_write_xmitlet((unsigned long)sk);
+	dccp_write_xmitlet(&dp->dccps_xmitlet);
 }
 
 void dccp_init_xmit_timers(struct sock *sk)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
 
-	tasklet_init(&dp->dccps_xmitlet, dccp_write_xmitlet, (unsigned long)sk);
+	tasklet_setup(&dp->dccps_xmitlet, dccp_write_xmitlet);
 	timer_setup(&dp->dccps_xmit_timer, dccp_write_xmit_timer, 0);
 	inet_csk_init_xmit_timers(sk, &dccp_write_timer, &dccp_delack_timer,
 				  &dccp_keepalive_timer);
-- 
2.25.1

