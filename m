Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9973A322C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFJRhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhFJRhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:37:01 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D80C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:04 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id cb9so34042830edb.1
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pPFtNdBfRE3W0V85CFXuPYglVMWW28G+16rA3Kbzhw0=;
        b=D3oPwX7wuoA0V2tluHcQFWuEPMQdyaSG/kkjhy5isYdEFJDWcB0OmTND7QY+Bh5QH5
         mdj7V1OonBGNNKS0RE+Qb+CQvxAAtA6UUNMx1oymMX76LdxVIrPKwkJ2zYBb/OZRNxi2
         pRTM5JoyPTMLrQBaOKI6cQqEDq6LN2s/JIvTexkAMXwcLjX/l3bj4uZGMKFSzg3OMi39
         DSlYbHWhGGwWHjO+7YgAQcp3BDH/RWrbC90COAVKAgprXqWCjQ3AfzkovpoAaF3DX/co
         GXSumaPw5TXGBoY7XbWBysLRFroS2XDysyTDQfVOMQbXMMvV/JeBvLuFGc1hGbCYpQ56
         ceeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPFtNdBfRE3W0V85CFXuPYglVMWW28G+16rA3Kbzhw0=;
        b=V71WwSUbO4HiRkW/Civu4V1FyMuOt3Ip+iR41DUVxXCw51/7t0IF8sLOO+3UOHqjs1
         DzPo34bVwu6qZCczLkvyUPetXJp5iM2eppEAlqHlXsJT176xhX0aMryFvUSsoKFSjDFx
         iKBT0DBtwPbrhmlVCXFzQnerWx6mnBZSnGgdUysbscaQ2q5tLYiZVWq8p/bEXERzvkEz
         UU2GX6D6ASRsz+ep/tPsn3xD6wvMG0CYSYG5L4Y7QHElflBER80KGehuy0D+i+zyiPMZ
         mHsJlfAuZdDtzWotGIYlo90LNO7VsiU8jZIt1B3rfZQwbmWbYfQ3DeZv24S4IuMt2ISO
         jGAQ==
X-Gm-Message-State: AOAM531SPoZuLPRAqyLuc3P9PekWOE/4mmetFcfYuaspUoJTpCz/kxlL
        SP/YahdG7CEM1TgyukDVIPU=
X-Google-Smtp-Source: ABdhPJzVEuCVVT5sQoE+uvTiM/pktdFOv23oivdDxYQ6yfgtEMgdWV09R03RH8bmbub09VrVKayr4A==
X-Received: by 2002:a50:cb8a:: with SMTP id k10mr585701edi.267.1623346503311;
        Thu, 10 Jun 2021 10:35:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:35:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 05/10] net: dsa: tag_8021q: remove shim declarations
Date:   Thu, 10 Jun 2021 20:34:20 +0300
Message-Id: <20210610173425.1791379-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

All users of tag_8021q select it in Kconfig, so shim functions are not
needed because it is not possible for it to be disabled and its callers
enabled.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h | 76 ---------------------------------------
 1 file changed, 76 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index b12b05f1c8b4..cbf2c9b1ee4f 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -37,8 +37,6 @@ struct dsa_8021q_context {
 
 #define DSA_8021Q_N_SUBVLAN			8
 
-#if IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q)
-
 int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled);
 
 int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
@@ -70,78 +68,4 @@ bool vid_is_dsa_8021q_txvlan(u16 vid);
 
 bool vid_is_dsa_8021q(u16 vid);
 
-#else
-
-int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled)
-{
-	return 0;
-}
-
-int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
-				    struct dsa_8021q_context *other_ctx,
-				    int other_port)
-{
-	return 0;
-}
-
-int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
-				     struct dsa_8021q_context *other_ctx,
-				     int other_port)
-{
-	return 0;
-}
-
-struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
-			       u16 tpid, u16 tci)
-{
-	return NULL;
-}
-
-u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
-{
-	return 0;
-}
-
-u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
-{
-	return 0;
-}
-
-u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan)
-{
-	return 0;
-}
-
-int dsa_8021q_rx_switch_id(u16 vid)
-{
-	return 0;
-}
-
-int dsa_8021q_rx_source_port(u16 vid)
-{
-	return 0;
-}
-
-u16 dsa_8021q_rx_subvlan(u16 vid)
-{
-	return 0;
-}
-
-bool vid_is_dsa_8021q_rxvlan(u16 vid)
-{
-	return false;
-}
-
-bool vid_is_dsa_8021q_txvlan(u16 vid)
-{
-	return false;
-}
-
-bool vid_is_dsa_8021q(u16 vid)
-{
-	return false;
-}
-
-#endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
-
 #endif /* _NET_DSA_8021Q_H */
-- 
2.25.1

