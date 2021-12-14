Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3EA474D19
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbhLNVL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbhLNVKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B48DC061574;
        Tue, 14 Dec 2021 13:10:37 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z5so68181762edd.3;
        Tue, 14 Dec 2021 13:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gvGz4h9p5VDfr3y+9UFYfPgO2UTc2LnpHD+Ji3lAzY=;
        b=AKUuz0vu42JWoouYZipMGwF3zgTdWnTW910lWxn06NdS4uvRt0tv2smsYWru9Gnn6c
         Q4vNLq+oy6y4vTGQuAq/49L2iTucPibbdl68uoh8bDiTSpnsWd+2blvksow2ZHHh8O7Y
         Sv3yGe+7Da7XRwenL8u4bGSLtxvdozBJ/iS1qLfup1L5Rj8r1kihVkjh4oJRfJlq/UZx
         MNFtWdlAaPZzd6ugxvRC8j8p74gq2PhnSS6p9pZhZ4axZScUM1Pni2XwJVdyxkkNb/+f
         u7KQUWmwo8TI+4iyTalZrp0WGuEfB3+vFBMbHWnnhc+JzPkGWkilvWZMLu9QCJTnZp2p
         7jZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gvGz4h9p5VDfr3y+9UFYfPgO2UTc2LnpHD+Ji3lAzY=;
        b=P7lQlBrOE6DA5FO+3sTod3JN6Md61xIQX0iC5u821J17sJXhwxmodjVtGvIyc6XyBG
         rB9mnmUIVb0hdoet45S9iR96YFuYd2/sMu5b6rW3VEvY4+q3vjtajUDC7R1fGsoMk3aq
         qo+OMNmA+bBfwBeXjuB6tIlIbDFTCcNMgYYipdQ0psCgtd6OXRmPFwk9q6BynWBiE8uY
         g8sjLbqZc1TlfHrRUXhb5Mia1ccNt+FmUN2He0uhfI5Rawl2wWBt/X0H/13iU0UBxJxR
         j8dOP8CyOJd8b3jz3yGrELYiuiAoL/sRd3u3FTXD9xMx5bkEW9UUo5v8N9e6ypu8M48Q
         tJVg==
X-Gm-Message-State: AOAM53013I2bR+LsgmuIM9UMhXaT49hzlnOTbL7MRbJk0DNF2IjV+NYQ
        +e+rKb2EpmBOa0Klhv3kfko=
X-Google-Smtp-Source: ABdhPJyE4Drn7nnOFgOx3qrrjtM1Hy8lwZyPf/uZyaqsgOJxuV+wyVtMgPJC2/IgQRSt52Dufb2R4A==
X-Received: by 2002:a17:906:a3c6:: with SMTP id ca6mr3750942ejb.639.1639516235711;
        Tue, 14 Dec 2021 13:10:35 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:35 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 09/16] net: dsa: tag_qca: add define for handling MIB packet
Date:   Tue, 14 Dec 2021 22:10:04 +0100
Message-Id: <20211214211011.24850-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
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
index 21cd0db5acc2..cd6275bac103 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -59,4 +59,14 @@ struct mdio_ethhdr {
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
index d30249b5205d..f5547d357647 100644
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

