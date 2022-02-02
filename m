Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24884A68F0
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiBBAE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243089AbiBBAEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68899C061756;
        Tue,  1 Feb 2022 16:04:21 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id l5so37834372edv.3;
        Tue, 01 Feb 2022 16:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GkEFXtqNK8+fHp0XOHOlq+83wcTYuBrFojoKBiNgljc=;
        b=SyLHnPSQaH1Uz0tuPTnlFx/75PKG8GyE1B9ZfSIN+1Y5P5fgMSTVsx6CBbBltJaJU8
         DyVRkzJsIXSCEgyRcgv2u0cfCuEHejHqL4QNkuy/y4FRKPe+Xb5nGh9eq+lgkMd8aht3
         QQicN+stogfOZ8io4IUV+8FusMG8egXixRj+G3wFS0geu9YmS5lRzIe4q5HEAw2pKEZj
         ZA6zt6TQd50nblP9qcwT/7DoHoh+w9/9B6A2jIrGMgeHY67KpTj/G8WyVlyh7ueDDHD5
         2n7VY5scj25Gn2itRtsyrl2GATdfzgk8l39blBURPOvL9htc/WL+3iXJt1UXVst3TyEr
         rfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GkEFXtqNK8+fHp0XOHOlq+83wcTYuBrFojoKBiNgljc=;
        b=6fCRJHhWa9TjLRhBOZu9CbGf3Zcul7ZgHZT1d3TfsTUF0/ww/o9tNtSGXxzbHxjllS
         ZiB+n0okPfWHA0kDjSO2pQCRJmgWTc05AhdpMDF5GMudKawnxUnTn7cWrnT9aPFbtvIs
         iNCuqn9SV5iROVrhzzwfz11rUUJPpPWG1FRdYcf0B0Rte2dJx9uK7ZVc10U8rRXs/Ets
         GHuJMLXu9ghoZkTZ4ndh+DvUQidrWY4E9GiwERNTmWb0K9ljEvTSXYN5PBeiLe8cvcLo
         uhg9q5IAkOSYNzd8dJ38/LOxVCkVivAY4bnxnbqltp2mmyB+UmRKcwvey7mcPlNbrOkg
         zBCg==
X-Gm-Message-State: AOAM533v8pfccZrbzoH8tiEMH1vALQRcm7COUE3GwT17HDaysUiNjnaN
        VD5tumpfYoqQ2EH+cSlOGzMYwHKR2IY=
X-Google-Smtp-Source: ABdhPJzxYXkXwZ3v8yi6cz9qrfZfa7kqZiOBsEaON1o5Yr2Skt3o4b0jUfdtkgjodWZ9t8DfvgPc3A==
X-Received: by 2002:a05:6402:50cd:: with SMTP id h13mr21890321edb.256.1643760259929;
        Tue, 01 Feb 2022 16:04:19 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:19 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 07/16] net: dsa: tag_qca: add define for handling MIB packet
Date:   Wed,  2 Feb 2022 01:03:26 +0100
Message-Id: <20220202000335.19296-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
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
index f366422ab7a0..1fff57f2937b 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -62,4 +62,14 @@ struct qca_mgmt_ethhdr {
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
index f17ed5be20c2..be792cf687d9 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -57,6 +57,10 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
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

