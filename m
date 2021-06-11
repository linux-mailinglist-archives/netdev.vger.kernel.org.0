Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DB33A4919
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhFKTEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:04:48 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:34506 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhFKTEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:04:47 -0400
Received: by mail-ej1-f44.google.com with SMTP id g8so6049858ejx.1
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OZBJfTaAZHsECyIbUxqjfqnGI8fgnXdrqpdLy9vn9Hc=;
        b=dLKXr9cRhEuM5sIOae9gD8oQ9FuEWrLgwBvgTYFny1D1nKqwe61OWubGv+BA3rOUWH
         NS+FujGVZ5Fdnc3BtlwZQk9YlgU4Iagg7Kn064bsfd+ptO2rXtgrlg3PMm2BtTJcTv8l
         N2wwvftL3sO6F7K3VVnPHOSjxnGneWDax+iHxa5TQmjvK91wex2zK9E5mGzA6P/35XZT
         UslglfjgjrqUD70qsNirTssZ32Mdf1ome4f6xQ4liBPowyWrBupMLR3/TZI8uG2CbgZi
         nrHPD/WYoU3c5Evq5izoPM9OLn1bxZUtK1tH9Uln1FQDJKJsGsZ+6WK+Rm/THvBAzpUT
         +INw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OZBJfTaAZHsECyIbUxqjfqnGI8fgnXdrqpdLy9vn9Hc=;
        b=jO8LpiCgqzbluU8AApabeGUORCwqKvWA60d44Tc2XaQaAV5/Af5bbkkaOXiJgkcQsR
         9VXDNqbXPRI+nPN8WN2nIrcUb1wIoZ94+PwaXnLUuTdsyrreeMjOLGTFT1o2asnz7f5N
         1zO55tR86GXwpfNGQ2+fFc4VJLj+C83TRzvmbswt5i7joRufEYqhUa4BNfW29PIT/wYc
         z8lgCtg+YEXj7wSnrivIGhlk82Z9vJLUH7jmg4kGSFPz5rXNdMSwqYknwTDYUD3IE0Fg
         Kvc0lpxHWGhBbrZX/cyWYb9W7GWpBqphJxyt4qn0LLasNZMbfqyHj1hIu5eVmg9x8sGY
         R2sg==
X-Gm-Message-State: AOAM533iVKeT3c1vkO3BGkX191bW/oviG+witLK1M+zV8SYV1mfka0Sj
        5XyqPL99yhRwL9cAA+SuGwcVGPORfqg=
X-Google-Smtp-Source: ABdhPJwXXzl87DHjAwoZpetpzZi2jhVPCBKy1t1jddrJ/IteOwQZ6nRrAQrV4L3iYLQqiaMpAPL/DA==
X-Received: by 2002:a17:906:509:: with SMTP id j9mr4835327eja.149.1623438108728;
        Fri, 11 Jun 2021 12:01:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 05/10] net: dsa: tag_8021q: remove shim declarations
Date:   Fri, 11 Jun 2021 22:01:26 +0300
Message-Id: <20210611190131.2362911-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
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
v2->v3: none
v1->v2: none

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

