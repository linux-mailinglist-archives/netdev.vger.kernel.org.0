Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B52F284613
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgJFGcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:32:46 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A34C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:32:46 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y14so5185658pfp.13
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Y7zJU2kCbZKAArjljkENfIcG6YEkpi6fwiJlDpruSA=;
        b=OYQ19+I41LDUKYbof6ciYk1EPOHTnjAxQliKytHF/07da6TdFHaVSKtKoc+UE84EPR
         pU8Y18q2F36spChWBgSdVz7+2rLBSjRCxLM+lIfKgHAZ4wq92nOPIRC8lLz3V42G5fnR
         hoicWXex3QfISogdqAHgNcPQiKsJGVxqMAE6qHBhHQ+1VPHGwp9GmW5Qe3zz53iZEHWK
         Q21dsbdQW005auttkBI+cQ92B3HagSxM71jNGL13PGG57Bwnxye9iFKmrUz+WnXxB74R
         RExMNFwIexszb4DoDWcL4ycuLtEfhOcYcrpodgaiKftrLdNTVX7srFli3RNUFATxOoxW
         szlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Y7zJU2kCbZKAArjljkENfIcG6YEkpi6fwiJlDpruSA=;
        b=gfi1j6TAdVQDY3x3nYhdGaSLofG4niFj6aGsd6mAny6HybDGB/ZfUtGs0lRN5+QjEJ
         1KZIc+0UbLv+XgYP3AX7608bEcCt0tTDYtO6Jx5yQla+pgBo1QRwPyS00vNYWtcIzcBu
         FyAHDitZey9YimFovCOfCypdS2e22JF8chxBzHFukjCozVvIczmcOR4MesdVoRCOikGN
         WRAP/jEGa1Jwl0NesEQwxwWYc0rF6rIS3MJRLSY8VPLmKqtv5+Bw53FBIpEI+V9l4Ui7
         WSMX4+I8J9beou6apUyjsWAyFmR5wXWeXlcKtIWgD+aduT58wDc1gv1y+4DFDnTVxAx1
         a2jg==
X-Gm-Message-State: AOAM530WMrz0hxqpEjMrMQO2YgY+JT+CgnY3b8RZwu1v/3iU85UJeSG/
        4eLaKUW9UAVQ2Y+zjMqPuYI=
X-Google-Smtp-Source: ABdhPJymSgnW0qvFhcSrsSlDdgThns0sfOZW5DxgIJTwqwClbJwM8eetbJX9qnOMtsoeA+W9oOenQg==
X-Received: by 2002:a63:d242:: with SMTP id t2mr2878576pgi.47.1601965966233;
        Mon, 05 Oct 2020 23:32:46 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 124sm2047361pfd.132.2020.10.05.23.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:32:45 -0700 (PDT)
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
Subject: [RESEND net-next 5/8] net: rds: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 12:01:58 +0530
Message-Id: <20201006063201.294959-6-allen.lkml@gmail.com>
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
 net/rds/ib_cm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 06603dd1c..396d6abf8 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -314,9 +314,9 @@ static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
 	}
 }
 
-static void rds_ib_tasklet_fn_send(unsigned long data)
+static void rds_ib_tasklet_fn_send(struct tasklet_struct *t)
 {
-	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
+	struct rds_ib_connection *ic = from_tasklet(ic, t, i_send_tasklet);
 	struct rds_connection *conn = ic->conn;
 
 	rds_ib_stats_inc(s_ib_tasklet_call);
@@ -354,9 +354,9 @@ static void poll_rcq(struct rds_ib_connection *ic, struct ib_cq *cq,
 	}
 }
 
-static void rds_ib_tasklet_fn_recv(unsigned long data)
+static void rds_ib_tasklet_fn_recv(struct tasklet_struct *t)
 {
-	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
+	struct rds_ib_connection *ic = from_tasklet(ic, t, i_recv_tasklet);
 	struct rds_connection *conn = ic->conn;
 	struct rds_ib_device *rds_ibdev = ic->rds_ibdev;
 	struct rds_ib_ack_state state;
@@ -1218,10 +1218,8 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
 	}
 
 	INIT_LIST_HEAD(&ic->ib_node);
-	tasklet_init(&ic->i_send_tasklet, rds_ib_tasklet_fn_send,
-		     (unsigned long)ic);
-	tasklet_init(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv,
-		     (unsigned long)ic);
+	tasklet_setup(&ic->i_send_tasklet, rds_ib_tasklet_fn_send);
+	tasklet_setup(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv);
 	mutex_init(&ic->i_recv_mutex);
 #ifndef KERNEL_HAS_ATOMIC64
 	spin_lock_init(&ic->i_ack_lock);
-- 
2.25.1

