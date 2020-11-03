Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015202A3FD2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgKCJSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgKCJSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:18:44 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CBBC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:18:43 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id 1so8300434ple.2
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gkuxstg5R+uheA6phR4fMLuBUdOEwyAXqM6AKai276Q=;
        b=OvEYbHo3vzzjaz2MFLvoXq3TOPO1hezqiCCwqNO9Y82uk0QoyCPjloSWgK5x0K+xnh
         WbIRxXHQX6bc11NX9Pf1FUdMB8ZHnKufmwwuaUyrSuO69Wn2AjlR+mbYimhWjMGO8J17
         6e+eW1kw/x35K7Tocqt0EkGnP2fk6EDd73NJlHYiQLOXk4tqRKB9kG8UNAyza702wQ+H
         iqr5jiPJ64Ydmss/qrrHFx85P2SHkMYNyPycoslCvVAjsYytLGGZZM3ermUmEqCYBN2S
         I+3wRG0Zxv9e12lQbhCVqWwfwxx99AmYbw94ACNKKmQN2WoTDHxlf1xgYlpaVRqZu9q4
         5hKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gkuxstg5R+uheA6phR4fMLuBUdOEwyAXqM6AKai276Q=;
        b=ZLO9paeCco2wPIlW8V796WhHcoKBTg6DmQnYX5ZuZqjJEzMwqO+kC+eGzqcMmI3aI9
         PN9qhUQoOF12HmGi/XvTrK6jVQ2NriA1fILabu0NNHm7pxOnhValvWmvF/sVlsnrqw65
         UYVrvh6THBK1P/hzpA53DF4kiLu78/ESK8EhWMimmqdTEoaij+ffPMcjxhU08G/derRF
         8j2gcRxv3faeWweN1FtVCQDXDYROCB0KOwDKOMuB0xFPJOImCrBZNSzfNWbJ/OIgCQ0z
         WdM1NMaYtGJusf+PAHogtGOFyH49/Aer8veYJDUIIBopBxF3g/6jTTIx/3HbysIZ6JjZ
         PO3w==
X-Gm-Message-State: AOAM532Un84XD9HjWF7zz+mlhGbyBqgBiyhUq5ueeLVio6K7Z8eCEf8I
        DWJDql3Lwm51Vc7qDkNDpog=
X-Google-Smtp-Source: ABdhPJznQGbFNaTz7CxM7zn0tXOdPKm6W7NBu77qB8hOhUCKp7YvH8U+cpqy65LA3yxqHtsjRy/P1Q==
X-Received: by 2002:a17:902:b689:b029:d5:e78f:65d1 with SMTP id c9-20020a170902b689b02900d5e78f65d1mr24517621pls.6.1604395122740;
        Tue, 03 Nov 2020 01:18:42 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id f204sm17178063pfa.189.2020.11.03.01.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:18:42 -0800 (PST)
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
Subject: [net-next v4 1/8] net: dccp: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 14:48:16 +0530
Message-Id: <20201103091823.586717-2-allen.lkml@gmail.com>
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

