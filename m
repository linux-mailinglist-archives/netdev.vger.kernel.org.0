Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF04B47108E
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244516AbhLKCHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345765AbhLKCGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:20 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66315C061353;
        Fri, 10 Dec 2021 18:02:34 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y12so34435145eda.12;
        Fri, 10 Dec 2021 18:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X4wMhrUN84KeHeknaHhQMPltoPDB0WqcvrysGGLndQ4=;
        b=oQNowIzeyAus8FbCJ0S7EbiSWNDIrQDGgIim3wS7+w4LVM095Lbt1KEA2a4V0c2DlB
         MPCN4fKzQM92rFe/LmI6lGJPcX8rVkd70tPJZoOxirn7z+twalseAZW79vO4LdxD1qu1
         WLW6D5/MXctjmVTLUz+4gL1prpUlMSTHacfL/SmXQ5oc7EG22rv8Kd3t6ReEfcDlnvDT
         BhWCi5tGXiiFLrCB/nDkhZFBs/VrkyZdeM39ca5A+f1qxUHHlbgO8NTD/ZlAQy9+oyE0
         MiSmehhx70sSE578Lpd4/ojwrxMKRkGS1M6INB3zOQvuQiT5aAjMCSSMWhjnZxnSxgbD
         pvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X4wMhrUN84KeHeknaHhQMPltoPDB0WqcvrysGGLndQ4=;
        b=HVQ1rWSbB/Ik86TSjDFOvVu/e8G8srnMJIWq+XPW2/3L+MU5xg5HYhtDP+3U64aEhf
         R3ydoHU1+piv0eQAtOWrW/rDoEuQz+jkS/ZJhE3CkL//C27A8m7CvLP4SVhQhsT/bzB3
         ypIOpVkGsJLU500Db2ZlxhYaH7dbD3bn6gsGLKG+5oN0PsQjI63/3sQU24r8snJL7KXS
         EPK1poc2im26aSyYirYd6CNrTKWeRGQDxlOj+2dYgr8PJpZdpHT2QFu360smr7DYJqJp
         QfW2wHpfpgsFalw0dOYQ5rkCnQGGGURlmxrgFyMZk3IykxWjJ4/APzDLpOJVVk/VWi/a
         9LAQ==
X-Gm-Message-State: AOAM532LK7O5LLcow0mLAKTMTnW8P9SbHklU+IWrGJHWPa0zrHEIXFY1
        qTQ0pX5r1QqcqPn/o3Mnioo=
X-Google-Smtp-Source: ABdhPJyeM3LUiV+uVrBngFJqG3aws6IotQ/CLaGNUbbStgHx+hIxd+qrZyLb+TC6Tev0l9d6PFLDNg==
X-Received: by 2002:a05:6402:1d50:: with SMTP id dz16mr44234607edb.309.1639188152875;
        Fri, 10 Dec 2021 18:02:32 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:32 -0800 (PST)
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
Subject: [net-next RFC PATCH v3 10/15] net: dsa: tag_qca: add support for handling mdio Ethernet and MIB packet
Date:   Sat, 11 Dec 2021 03:01:46 +0100
Message-Id: <20211211020155.10114-15-ansuelsmth@gmail.com>
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
index b91f9f1b2deb..7edc198fdb60 100644
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

