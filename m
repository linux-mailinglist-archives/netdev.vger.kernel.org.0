Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57546496F81
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbiAWBeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiAWBdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:50 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58ABC06173B;
        Sat, 22 Jan 2022 17:33:49 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id o12so11117200eju.13;
        Sat, 22 Jan 2022 17:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rBREyuz+JJaVFiyJ9awvOej1C4zUf8tMKpoECjsnacs=;
        b=FgszAdl5Gn3/Z8D0Nr8rV9jcKuJgEA02NSMc3SDElelRU43VZYTjzl0AZIhMZ7B2zb
         qtrcN+ATJD14q/yG7ihcCA0n3z6J7haNUEYp/LE9Shbvc4KmYOkAVBXnT2XWi8NT/bci
         yWY+4+kv+AB9FPH1SEaKBJckOKsc79tE+8JG6So/g26wSsOhTwShtyllINWfpYeLLoeZ
         CQ/xbNmlr8Q+gADH3b++5ETZSAj4jXpo1N6/gl3T1y4prESJ/Tcia+SigkdH7dxUhBKk
         U0ZIkBDwYWJeFb1mj0XCyP5BnxhbItY67J78+k09EzSxmug6ffTegC7GIuq9NIC4zuo2
         k7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rBREyuz+JJaVFiyJ9awvOej1C4zUf8tMKpoECjsnacs=;
        b=OBe57Z/nWiAeIpLKKBFTIZaenI+GTiIRZSMu6tF6+khYk7IK6lVNcNzc5tcL59d64g
         UkgEzPdtVwvsEXxtc76SfrRCNvXBliBdvbHpmetQ0J5rm4QICdTee+jNguvZxOFxHZYt
         taQowVlok7Opnz0IaJ1k8JqMfHmQ1+CCImYsCp/iMXLR0UcykcjuAPjC+bDt369l4UW/
         5BqjOZMXo3yXIG5IJn+38Icx7VMfJgoSdNLaTxYKNWltPEKbft5xWGMccjrZYK7uWWyH
         2vCYuIa3OAkilOq0e59ljaUurYda6zvFlRqx7UNL+ZynQrZQZAHUIGsSI8RJPHHKLgHs
         KV/w==
X-Gm-Message-State: AOAM530XKRczhFrHaTqF/IxDsubcLHcbv0S2ms5P1EkBasRrh6dSSzQA
        28pro80jtQi+TegGPt6aPJ47cbq5jKc=
X-Google-Smtp-Source: ABdhPJwqp9YpXAAwJ+kpRu8NbD7mdFUwvHwiwWF5tbAUG+vl//B5AqnSvsDzmzm8ckds9DWW3gVIIQ==
X-Received: by 2002:a17:907:728c:: with SMTP id dt12mr8560897ejc.188.1642901628280;
        Sat, 22 Jan 2022 17:33:48 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:47 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 07/16] net: dsa: tag_qca: add define for handling MIB packet
Date:   Sun, 23 Jan 2022 02:33:28 +0100
Message-Id: <20220123013337.20945-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add struct to correctly parse a mib Ethernet packet.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/linux/dsa/tag_qca.h | 10 ++++++++++
 net/dsa/tag_qca.c           |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 1a02f695f3a3..87dd84e31304 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -62,4 +62,14 @@ struct mgmt_ethhdr {
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
+enum mdio_cmd {
+	MDIO_WRITE = 0x0,
+	MDIO_READ
+};
+
+struct mib_ethhdr {
+	u32 data[3];		/* first 3 mib counter */
+	__be16 hdr;		/* qca hdr */
+} __packed;
+
 #endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c57d6e1a0c0c..fdaa1b322d25 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -55,6 +55,10 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
 		return NULL;
 
+	/* Ethernet MIB counter packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_MIB)
+		return NULL;
+
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
 	dsa_strip_etype_header(skb, QCA_HDR_LEN);
-- 
2.33.1

