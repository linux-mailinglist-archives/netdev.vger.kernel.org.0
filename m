Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC1B47108F
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346169AbhLKCHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345754AbhLKCGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:20 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB81C0698C9;
        Fri, 10 Dec 2021 18:02:32 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x10so17835644edd.5;
        Fri, 10 Dec 2021 18:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ug17C0BlF8flc3ASDfigJVcIU3yUjGTjLhKNa+SJZOg=;
        b=QXRFy1zGMEzwHGscx1GDGZRc4MaB8MYQzjpC5KwwlPayCCbZF0J/nzRYWcXowNqlKm
         TyOGi/6PO8+0nq3MweqViBugKISnW8R+i2BVrV7NgCqqc7p9uclhd9+87BjM5Wj0l2GC
         0+RIEz/EOP1lIUtXWq46SLgu4rSNRzgdgnEbAp5pZ6/zmKg5NmUpg24eYyLWtUNA4jaE
         s1M9NUQdv0F7/W7m3eNwvmScx190aF82fUQ8jv6LNiwaMf/RVSKxIvVtuDfXyr3JKO6l
         a9GpF+zN4YIFtcarM7kWhw8FwQZnAKIYzYZVlPevz1GKx1zhmkmd+/+0fntRa1RELLT1
         jl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ug17C0BlF8flc3ASDfigJVcIU3yUjGTjLhKNa+SJZOg=;
        b=023O4h8yAoovXSEBsXGG9xhWikVQKUKGDIYgmP+cNjQdXF2lbKkFuL4edBbgfTKEAR
         lxZwSpzmXWryv4YB5lVeXs2EWTobubE0h2MJrmernoXdGdkRyKX1Tk4FUg5iTYchgGB6
         2vEoDnQcjXjfnDACskxklYOMgvMJ7Hmd9uKtQyRk/LWEM/KPYOHYh4RG2Zl0vSRoZ3G5
         I88NxR92y9TLh72Pd0umTX8RreG7iYuK7q3BOppPG+xj7U85te3wgRBQmS2yffpbFwCa
         IGwY5JzJjFPYwbpGNMHr2tYTChPtAbzwCzk0fHNhRWDyp4bElLv/D/ps2i78KaosQA9R
         WuvA==
X-Gm-Message-State: AOAM533b8xgE9x4CdSAJH0MEBF0zhsFGcSE1nY7Df2EZVm3Mr60YwSDS
        7nFC9XWUGyw2AzLmwmoUqcc=
X-Google-Smtp-Source: ABdhPJwnbH7tLeSECimzcf5Evgd6qKjZpjiI2Pze20Skrtt/WPuhYi+MtSyk98T5yx2a9Dj6srN5sQ==
X-Received: by 2002:a50:d543:: with SMTP id f3mr42655692edj.56.1639188150539;
        Fri, 10 Dec 2021 18:02:30 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:30 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v3 09/14] net: dsa: tag_qca: add support for handling mdio Ethernet and MIB packet
Date:   Sat, 11 Dec 2021 03:01:44 +0100
Message-Id: <20211211020155.10114-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add connect/disconnect helper to assign private struct to the cpu port
dsa priv.
Add support for Ethernet mdio packet and MIB packet if the dsa driver
provide an handler to correctly parse and elaborate the data.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/tag_qca.c | 52 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index b8b05d54a74c..ded4d024d791 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -32,11 +32,15 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
+	struct dsa_port *dp = dev->dsa_ptr;
+	struct tag_qca_priv *priv;
 	u16  hdr, pk_type;
 	__be16 *phdr;
 	int port;
 	u8 ver;
 
+	priv = dp->ds->tagger_data;
+
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
 
@@ -51,9 +55,19 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	/* Get pk type */
 	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
 
-	/* MDIO read/write packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+	/* Ethernet MDIO read/write packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
+		if (priv->rw_reg_ack_handler)
+			priv->rw_reg_ack_handler(dp, skb);
+		return NULL;
+	}
+
+	/* Ethernet MIB counter packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_MIB) {
+		if (priv->mib_autocast_handler)
+			priv->mib_autocast_handler(dp, skb);
 		return NULL;
+	}
 
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
@@ -69,9 +83,43 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
+static int qca_tag_connect(struct dsa_switch_tree *dst)
+{
+	struct tag_qca_priv *priv;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->tagger_data)
+			continue;
+
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+		if (!priv)
+			return -ENOMEM;
+
+		dp->ds->tagger_data = priv;
+	}
+
+	return 0;
+}
+
+static void qca_tag_disconnect(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->tagger_data)
+			continue;
+
+		kfree(dp->ds->tagger_data);
+		dp->ds->tagger_data = NULL;
+	}
+}
+
 static const struct dsa_device_ops qca_netdev_ops = {
 	.name	= "qca",
 	.proto	= DSA_TAG_PROTO_QCA,
+	.connect = qca_tag_connect,
+	.disconnect = qca_tag_disconnect,
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
 	.needed_headroom = QCA_HDR_LEN,
-- 
2.32.0

