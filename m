Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D505362A3A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344365AbhDPVYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344341AbhDPVYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:24:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F13C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so10457320pja.5
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Z+KBB3WVHECWMr+21ttbt1jBhUBOV9FuzyHsPxovwg=;
        b=nevmX/wSK3bKNss3CHXywbtjuCAWbmT1QtLoEFlC3RNiVtvRFVQ8gm5B7fS83LAmUt
         YxEi3ZQ/xm36MTfutczEwX4MQl2OKeZiNsGVOM4cjjH9i73BC/rWKKKrCVMPSb0s0k8/
         qUKDvqSgfcDsfOxhKAVX8Id9uSI/Ef8Lko8g49dDfBZ6T+o7WBWIJEZIHqv7k1U3esNn
         oRyCeieZHhC5zkdhd3EIBS0HV2nyKA28dZUT1uV7rmCdiotM5M/EHYMe48MKXlyUk4ya
         wV4zpPkBeK+M9dXDCOo7+Wzqp0E5dkoUnxjRTa/ynejTux6qM6hDRjvwGaNnR76p/pt4
         QX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Z+KBB3WVHECWMr+21ttbt1jBhUBOV9FuzyHsPxovwg=;
        b=aeT3zFeLktypsM23dFm+/XM9drlq9qjko15mbDgu93fiw15b1N1BwfNq0DdKhf3Csu
         31TnKFnWQPqklWki4oDuqazQSKl+UuJyX3odvVycl/GopabP4VndTzYE/N82m0+MXdD9
         g+NQsvpBo5dT2W7gef2BcqN72xhXtCnoiw8nKWGt9fYmgbw3g2xfShRAhNounh2opAM5
         Nadk34vETQcgHWiUpWHydUUF7gKaX0wNUOKFOvJdP0bK5y03rxLMq11CQ5F+2+s7HoAQ
         8SAjUu4rquW+nIkZ9AShBh2N1KVw735VOpy3M2WpCcyY8dKP+4VAPvaL/cJJTmpYPmQP
         PTww==
X-Gm-Message-State: AOAM530+FehBkfiRu1oDwRUoe4uQBLhmsP37bi4AW+2qfKOHE+EMzOc4
        H+RScV/RbPijfZA66pUwx9E=
X-Google-Smtp-Source: ABdhPJxgjS6u2V/mXTAKXUqsvrYHtlVUNG0BQegAh46cP1w67619phEmYxjr9u2QFJRsdZZX1Lckqw==
X-Received: by 2002:a17:90a:5d8f:: with SMTP id t15mr11581655pji.28.1618608236429;
        Fri, 16 Apr 2021 14:23:56 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 10/10] net: enetc: apply the MDIO workaround for XDP_REDIRECT too
Date:   Sat, 17 Apr 2021 00:22:25 +0300
Message-Id: <20210416212225.3576792-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Described in fd5736bf9f23 ("enetc: Workaround for MDIO register access
issue") is a workaround for a hardware bug that requires a register
access of the MDIO controller to never happen concurrently with a
register access of a port PF. To avoid that, a mutual exclusion scheme
with rwlocks was implemented - the port PF accessors are the 'read'
side, and the MDIO accessors are the 'write' side.

When we do XDP_REDIRECT between two ENETC interfaces, all is fine
because the MDIO lock is already taken from the NAPI poll loop.

But when the ingress interface is not ENETC, just the egress is, the
MDIO lock is not taken, so we might access the port PF registers
concurrently with MDIO, which will make the link flap due to wrong
values returned from the PHY.

To avoid this, let's just slap an enetc_lock_mdio/enetc_unlock_mdio at
the beginning and ending of enetc_xdp_xmit. The fact that the MDIO lock
is designed as a rwlock is important here, because the read side is
reentrant (that is one of the main reasons why we chose it). Usually,
the way we benefit of its reentrancy is by running the data path
concurrently on both CPUs, but in this case, we benefit from the
reentrancy by taking the lock even when the lock is already taken
(and that's the situation where ENETC is both the ingress and the egress
interface for XDP_REDIRECT, which was fine before and still is fine now).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f0ba612d5ce3..4f23829e7317 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1081,6 +1081,8 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 	int xdp_tx_bd_cnt, i, k;
 	int xdp_tx_frm_cnt = 0;
 
+	enetc_lock_mdio();
+
 	tx_ring = priv->xdp_tx_ring[smp_processor_id()];
 
 	prefetchw(ENETC_TXBD(*tx_ring, tx_ring->next_to_use));
@@ -1109,6 +1111,8 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 
 	tx_ring->stats.xdp_tx += xdp_tx_frm_cnt;
 
+	enetc_unlock_mdio();
+
 	return xdp_tx_frm_cnt;
 }
 
-- 
2.25.1

