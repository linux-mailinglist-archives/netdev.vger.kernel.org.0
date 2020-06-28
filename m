Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393D320CA1E
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgF1TyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgF1TyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:54:03 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B041DC03E979;
        Sun, 28 Jun 2020 12:54:02 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dp18so14519539ejc.8;
        Sun, 28 Jun 2020 12:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IecnikxrmKwKRsrCTW9kdHFofcFntdDjZkZFdGb3EQE=;
        b=htM9hGW3cBrcBx5OGriOoZ2Q7qb2kQCN4jBJM4mOX8cRyj2Fvt1fFBwLpHtarriC4Q
         FLclMgfMwZb2vt5V0WuH3YNZf6Ac9JxXRbN2DE/pqISuwewWSA4ZzIqpKRWCDgdB4gGJ
         W41F8SsLnxtkInh1/0RjcMDxWFkPqVi7kXDyZyPl/A6ZXSfaachwpt322k7R6ypgxW8F
         NdApUcsygtNPKTm66vQo5pInfspM76rA3tsFgggFOgZFVRGGi+17G5SzlUIhhrPGw6Yq
         F7XV6xpJa1pQWR8ugjJRm1e6Sd9ZbpxskMF/BYcrBJVfrlvMcxXzuWB8FALsLfXktnMB
         gNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IecnikxrmKwKRsrCTW9kdHFofcFntdDjZkZFdGb3EQE=;
        b=dM/FUaqe8z77+KXmSWUbh0NdeCl9nCY4YlaA28cJE6BNOnljosJW0hebEFNyLacA6N
         v4f8n1XwyCTrJk9Qc9O3+nexwlq8attafnCmAlHiJrZUmsy8gtT+DTdFWedcH0MR27br
         qNfHu185agbY/n2gtbMcC1371z6DlkWBMOOBuJ1gqjhRae7EzU2e8YusfbRpnX4297s0
         pcUN1ASBo1ZdMaA9hGxTmnlLssDvy5v4Liqom7s8yanC534zxrIDiwIU8mxHXPForKo0
         uAcCBxL4mNqR0hr+f+U8IWGI5qFPq1NzUGxEDQodTz+mYS8uaORjDoeVW/OvjPJOJKBA
         PI/g==
X-Gm-Message-State: AOAM533GIsNOQSeT+TJTq5Ju02NorX3Eq4jmp5TaT02bG40SvvmhPQkj
        7qJ3jG3MDNLGJbclfBzW9E0=
X-Google-Smtp-Source: ABdhPJwS6a+/f3aFAtr06rNEF0lhYkFRfGEM+tY+SaUPjEqw/nfHIiS2VxdQx+1Az4I0Kf670fZiaw==
X-Received: by 2002:a17:906:2e83:: with SMTP id o3mr7653587eji.261.1593374041507;
        Sun, 28 Jun 2020 12:54:01 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:54:01 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 15/15] cxgb4vf: fix t4vf_eth_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:37 +0200
Message-Id: <20200628195337.75889-16-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4vf/adapter.h | 2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/adapter.h b/drivers/net/ethernet/chelsio/cxgb4vf/adapter.h
index 3782e48dada2..f55105a4112f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/adapter.h
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/adapter.h
@@ -562,7 +562,7 @@ int t4vf_sge_alloc_eth_txq(struct adapter *, struct sge_eth_txq *,
 			   unsigned int);
 void t4vf_free_sge_resources(struct adapter *);
 
-int t4vf_eth_xmit(struct sk_buff *, struct net_device *);
+netdev_tx_t t4vf_eth_xmit(struct sk_buff *, struct net_device *);
 int t4vf_ethrx_handler(struct sge_rspq *, const __be64 *,
 		       const struct pkt_gl *);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index f71c973398ec..46e50e25dbba 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -1154,7 +1154,7 @@ static inline void txq_advance(struct sge_txq *tq, unsigned int n)
  *
  *	Add a packet to an SGE Ethernet TX queue.  Runs with softirqs disabled.
  */
-int t4vf_eth_xmit(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t t4vf_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	u32 wr_mid;
 	u64 cntrl, *end;
-- 
2.27.0

