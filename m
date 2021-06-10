Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6391B3A37DE
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhFJXaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:30:08 -0400
Received: from mail-ej1-f48.google.com ([209.85.218.48]:44746 "EHLO
        mail-ej1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhFJXaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:30:01 -0400
Received: by mail-ej1-f48.google.com with SMTP id c10so1620704eja.11
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WbLxLivyZ41CT0nx04gBe1r1FFKUcqOUdJMAD/0Doas=;
        b=WGjinjWzv1LOb1tW1kc3YX/4Pst8ZyTMmX7u53H68KXjxZeQ3g2M5eZI/P6Idc1DPD
         GJj+DVgsWPInIbfagRvQZu4FAP7EsZ7JRMpuHWjXA4QwEpqFQeo5oN9cuG+Zysv9RXKq
         CuM14zCKaG443xmkV06VvQ0DCsApeokJbDnMCChb9/NJnChojxRJdnTaoqUGgw3GjCNM
         Bd7l8ePmhW9bMZmb66W3/aYarz7z6IMDulGTAbluUf5qQwFrmk56mNnn1n+VRvIXLJFH
         Ov7pc/Mk/XW1q2bELoU7c6tz+GDPVeuwqCGhrWd6RPvThL067DEewKND9zUXkjh0ulLV
         +y7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WbLxLivyZ41CT0nx04gBe1r1FFKUcqOUdJMAD/0Doas=;
        b=swX1BTrxeM89AhN06Vk06irF1UyLMUb54FvNyEyIhjL+cpNd7LTty6rUOSZ3i04aE8
         p/RzlPQm8wUdWhq7IJAlO1AgxXydFxHkZd20rzXmUglDA+Ei6RgJma71NAdjCF3rHEw7
         QpvXB/lfqT9gTP5EBgM4wS89x8aIacfkdANGCs0x7AZ9juhhD0kdTZQ7wNIuhJl0ciBo
         NhwEVPex3v2yahDFE7+vAffOn6Iv5rYLsvI57RSPB+XGBD/mA1vDRzdiI0JE5EynS/CL
         k8Ts2Ig+Tc4XSLyLFcEiHG+JauC6Nh+m5kuwZwg/rV18syTYXPe9zXNEBQeLfn9mGGXS
         buYg==
X-Gm-Message-State: AOAM5305Xuc+7lz+ITfJv2ET3kw9taj3q9C0mi2D+kHBy72mQnAAoVi7
        obBkZdNrUwyOSrODL8Fexc0=
X-Google-Smtp-Source: ABdhPJxF0+ruMFi6gzd+oypytj8b4Qw6v7whnUW+dOk7faFaBtVAHZFwHTkEjv3YTJLMbEtosvZRvA==
X-Received: by 2002:a17:906:b317:: with SMTP id n23mr810872ejz.324.1623367607595;
        Thu, 10 Jun 2021 16:26:47 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1534187ejt.11.2021.06.10.16.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:26:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 05/10] net: dsa: tag_8021q: remove shim declarations
Date:   Fri, 11 Jun 2021 02:26:24 +0300
Message-Id: <20210610232629.1948053-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610232629.1948053-1-olteanv@gmail.com>
References: <20210610232629.1948053-1-olteanv@gmail.com>
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

