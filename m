Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDFF3B1884
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhFWLKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhFWLJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8n6XcLLXm/HC8/e7TDiaIKa4D1+079NdF0CtM9PlMq8=;
        b=L2zpNPwBkA2KUqOIW9hMKfMmx+LIkOG7Z0saVu27Z3tAUTk0xc3MMqMnZ6gf8Gb0WUbtO4
        30rZLdTLae7odS+nUKq/m1jva/7prs+//Z5kmrPpO/Vm68dn+3c9QbVZ+Ih4K/kA5tiJ2T
        oxJmf1bDq9njJS74sramQ8De2fBGFLc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-s1D_byBAP8-oVCJvw915YA-1; Wed, 23 Jun 2021 07:07:38 -0400
X-MC-Unique: s1D_byBAP8-oVCJvw915YA-1
Received: by mail-ed1-f71.google.com with SMTP id m4-20020a0564024304b0290394d27742e4so1097236edc.10
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8n6XcLLXm/HC8/e7TDiaIKa4D1+079NdF0CtM9PlMq8=;
        b=XJVc3NLQX7douuGEhxQ1X90jkgCJxprUysI/3Vn651DVErGUqR7qwXDOa8UEcEAFrj
         F3a2CBocVvK8SBAm+mdHxA0bXece5IVRVgoE5dbcF8msxVv59xiMjTu2CwgpG7Ifx8iy
         LBMa1Cn1gBd8e1fnho9bUERphvtTUCdcEN/DvMm9skgCeUE8l7eJ2aqeIiKLwge/eE8K
         IimC1R+G0eWzQAx34ay8c6jwP3MkLsOAB/Onh25cgbHTBth1SdWgMeRspYkmWXXJNL/0
         UQCGYzXcLRy0hTpmWD/OirRHjZ3t/tkj221qcy8cDTGkZchxy7ECXmoowmSX4WU/4QlV
         bLaw==
X-Gm-Message-State: AOAM532sRvWCJn6rIOelcMCpcHIK2WJT3KLZfx8ZN93J9Ewb6/Va+IHt
        lpZ0VX4WtSY0z4iV3UuJN4wgw3QcHupeamzY4ELqwi1fSoi6oRcNnzs0MpqOtH5pBdTWmTc8vYh
        ahzp45DUM4ltGunw6
X-Received: by 2002:a05:6402:6d3:: with SMTP id n19mr11792342edy.248.1624446457004;
        Wed, 23 Jun 2021 04:07:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkiD5H3LlCGb7IK6e0FT13/bnwywKl1w8bKqqDPQkSwyQvC9JZLaYqn51+rFHolYaIz4ezaw==
X-Received: by 2002:a05:6402:6d3:: with SMTP id n19mr11792322edy.248.1624446456831;
        Wed, 23 Jun 2021 04:07:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ck2sm4769159edb.72.2021.06.23.04.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:07:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 38CE818073A; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH bpf-next v4 10/19] freescale: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:18 +0200
Message-Id: <20210623110727.221922-11-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa and dpaa2 drivers have rcu_read_lock()/rcu_read_unlock() pairs
around XDP program invocations. However, the actual lifetime of the objects
referred by the XDP program invocation is longer, all the way through to
the call to xdp_do_flush(), making the scope of the rcu_read_lock() too
small. This turns out to be harmless because it all happens in a single
NAPI poll cycle (and thus under local_bh_disable()), but it makes the
rcu_read_lock() misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Madalin Bucur <madalin.bucur@nxp.com>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Reviewed-by: Camelia Groza <camelia.groza@nxp.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 8 +-------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 ---
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 177c020bf34a..e6826561cf11 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2558,13 +2558,9 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 	u32 xdp_act;
 	int err;
 
-	rcu_read_lock();
-
 	xdp_prog = READ_ONCE(priv->xdp_prog);
-	if (!xdp_prog) {
-		rcu_read_unlock();
+	if (!xdp_prog)
 		return XDP_PASS;
-	}
 
 	xdp_init_buff(&xdp, DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE,
 		      &dpaa_fq->xdp_rxq);
@@ -2638,8 +2634,6 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 		break;
 	}
 
-	rcu_read_unlock();
-
 	return xdp_act;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8433aa730c42..973352393bd4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -352,8 +352,6 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	u32 xdp_act = XDP_PASS;
 	int err, offset;
 
-	rcu_read_lock();
-
 	xdp_prog = READ_ONCE(ch->xdp.prog);
 	if (!xdp_prog)
 		goto out;
@@ -414,7 +412,6 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 
 	ch->xdp.res |= xdp_act;
 out:
-	rcu_read_unlock();
 	return xdp_act;
 }
 
-- 
2.32.0

