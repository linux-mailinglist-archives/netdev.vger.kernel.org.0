Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E05428460F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgJFGcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:32:19 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CFAC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:32:19 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d23so720873pll.7
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ro7FF8spJG58a2mM1edxZvD4AVGYl3L6lHSI77Kj9ao=;
        b=p+AaWphc0H66phAGtXk793c+E/sXIGFDnOXBHJ4i1L03TQs7M3AgJqUIKu0/GxOwz1
         kvUlge1Iu9NTy/lmoz41iLrQQXNZcgZgLMPbBaAx9vgJV5kWRsrg8jHCisQ7J5DxVyK7
         LDIExTT4j2jVb9Bf6gtuM7kNddD1mZ2jx4Kd+bkKdfjH6d17f/o9bKyuICuWhNpAEbWg
         DsRF3xTIeMELEnxg89vqxIE0xKZ0JD1YlTH/Fghh9nNy9xEKDkp+Uj59rFhK0NEtuoIg
         VOiGc3nhTcMbHHiYZEBb974t0B62u24XpRngUKznSCHKbLHLVJgnh2Don4HzO0E9s8Bg
         or2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ro7FF8spJG58a2mM1edxZvD4AVGYl3L6lHSI77Kj9ao=;
        b=Ksjw4LQnCoffqF2Duh6h+8FBNle/YMHgfc9fhlyTIlnp2jGCkwgno0RfEtuvGOOkjP
         hqx1A+BIz6l+bCnLtb+kXxhREDrbJBijtDNQ8KzHrR0pz7D8iUEv58dLD7/gllAbv/kb
         O0vv3iGbTUKy1wJUBfIZmYNycVnGEIhlS43fy773CtipOyilpSXmEsniMKQhodKfaEyT
         b8arQAGQo0P+NJOPbqqiQLnmt/wKLW2zDn0gEIagYrDWr8ZTSTtogr/1WDTATKOBTKQp
         oq7ekwrmJR18f2f1L3OMuJUm+8ZAnmJU83u8tJ8n8l+m9hrYZvgtBFzb7HSkqgJYslXH
         VOgw==
X-Gm-Message-State: AOAM530IeDXWEHmq5xgYnJV4Lb+gyLc2nhwaEStMtIX2h8LHMPZLDXCN
        awTjL5cuQHP5fWIQVEhEiqA=
X-Google-Smtp-Source: ABdhPJy+TTw5kSJAVmTDCtfoY/V6TNXbhDNXJCKYcMS4Igf+gP2OVujqGP3xKfe1FfXf9puErTRbpw==
X-Received: by 2002:a17:90a:94cc:: with SMTP id j12mr2878774pjw.106.1601965939302;
        Mon, 05 Oct 2020 23:32:19 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 124sm2047361pfd.132.2020.10.05.23.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:32:18 -0700 (PDT)
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
Subject: [RESEND net-next 1/8] net: dccp: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 12:01:54 +0530
Message-Id: <20201006063201.294959-2-allen.lkml@gmail.com>
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
 net/dccp/timer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index a934d2932..a57d66b29 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -219,9 +219,10 @@ static void dccp_delack_timer(struct timer_list *t)
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

