Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3228F285C9F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgJGKNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgJGKNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:13:08 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D0DC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:13:08 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id n14so1064614pff.6
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75sqOIr03Ig/QRCpnr1LikfBIGNMbZpFkpCO8G+MCV8=;
        b=Fh0cl1sp+0EY0fprykVC/7Wd1M4d81zpYSmhFw0PutVDzDRg+Wt+JvNedT3MPbAo3p
         W/pV5mMTWZrMB+E1FB4OUiPTJZSSbF+nPoJcDeNO2KDGYjhFsfEctXYAOFSxBpSVgJbV
         Ifzp4lYi2kD61TGNoan+BkpUNuE0gDaYMM+0ckBDep8I9Ecujp2fCFvNoipwizuS7CXM
         yhAgKDRyfhowxM3pFOuXnxP2Muc3ouA+ZaDk4Uq9pHSzVfkgtx5WdW111Ia6QbR2pd/R
         DYGsMYYvWMsXpg7uEq5yLWdqUdFkjBtYezpbPakqhAOgvwawEpfKe+3BL6ejKiaUxZkk
         0K7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75sqOIr03Ig/QRCpnr1LikfBIGNMbZpFkpCO8G+MCV8=;
        b=R8MzimOtOn4i6dkdHg6kPA+MwrZP1R0S3bG3ga1ZGFgK421FqSpBVjrhHtblLD1U2J
         CImsinU10Ft5LW8i75T0NwfEy3nEEmdL/2NAXHiPIKHc8Dp6UveQxlHzrmZHogiEB9Qy
         tDg9u3xSfkSQrqB71/9BkxVFdHupLpnWUGZ2SKLFGZAtnHYxJKSOU7SbYC/wfG7lKi7Z
         KCO3wY0FDT88ChEFnM+DpATMUPPsMUUEgHMPWeETR/6M85MxK6nf6THkJR9aHo6N8Pca
         8wrzncyLnextE8muNOakWkeBXZG6RahYKsJMTKtP2Op2TBm7tDYtyxhlYBfMponppsyC
         FocA==
X-Gm-Message-State: AOAM5330EVxhOJQymAoZghVRDRps4AcRaEBft69s6LDFC4prNXXb2HUM
        KfhFIXOoORB7Z6diKWC5UVE=
X-Google-Smtp-Source: ABdhPJwWHVuWdHTMSNDTySxo21vxWkYDq4rW5kxYCkQR/aaM93bPL8VyjhvE54GIuNI2H/y4PJWxmQ==
X-Received: by 2002:a65:6a0a:: with SMTP id m10mr2325317pgu.162.1602065587654;
        Wed, 07 Oct 2020 03:13:07 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:13:07 -0700 (PDT)
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
Subject: [net-next v2 5/8] net: rds: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 15:42:16 +0530
Message-Id: <20201007101219.356499-6-allen.lkml@gmail.com>
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

