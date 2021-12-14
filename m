Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10A1474E25
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbhLNWpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbhLNWoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:32 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF11C061574;
        Tue, 14 Dec 2021 14:44:31 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so68865779edd.3;
        Tue, 14 Dec 2021 14:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gvGz4h9p5VDfr3y+9UFYfPgO2UTc2LnpHD+Ji3lAzY=;
        b=fBr+QgSA2rnBZokDvwjBtlyEV62HwHRNWMCKHmtAOJQnUVkIOafDuMSQ6DdHwNgmV9
         52vv92Ez0seXg/EOPM4Me80ieh88OwYr9AOwtlq6w8AhCPv2MFiwxhJjZTljjX8Vvd6A
         DpltWkXCtbdTnMr+pdSmmkjoi5Mj5r/eeaY+eyKI526gk+8hR92dMwGaBCYKe9/tuiG9
         Ws6U5R4iHjqXUUM363VtdEeyaCsZ+fkxGdNxntdWBmV4nVgjg6KeeL/wIKqrzxz9sDgM
         wfOnpwgGYa/a6OTq0Fc35ZZ8P2/yPyoWkem2ovmFuP5MYcdEwJWMcX49hsrQ5MtnlRQF
         jdDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gvGz4h9p5VDfr3y+9UFYfPgO2UTc2LnpHD+Ji3lAzY=;
        b=Pew15kei/5/h5CDwuWUJ6Fr87P74AyjjDh5OgEgznCOuBiFNmEfNE8w5l3UK+Ldcq9
         grxxhXsWo6dDLvoEt5g91isvVKTyE/cRNbkTSN8KoB9Y969g3PJGTW24j7M66hKFd+sA
         6JTfpE0gv84DL6TzJa1zv0baAG1KVgky/ljmBSCykzPTGonbE6VP2UsVL85xJfo54Fa/
         5k0dNRgPqDwarqMpcekrfuMgwHrT3+R05RpieUnrrCl1Xh7RTGXDR+Sp+NFufwADMLZ2
         xVkOEREiA5k1pl62SDzyTRGcXGROcD0Ki5XngWudKMa7wtLzqZHYFQVe3qMZTwI7BNe3
         JmPA==
X-Gm-Message-State: AOAM532w9iNwS29Xw8zDNk3KC8RYwBaa0V5JLEaxOdSclUj0NjYqxIer
        s45KC/0BT/v7KdsElHSNNpw=
X-Google-Smtp-Source: ABdhPJzpeqcbnz9GY1Ih7rJM7iEIxfjSO+ZA9I9XBpPoY6FnacAw+8CeSZNa+uUV85sdNjRa8fmlAQ==
X-Received: by 2002:a05:6402:1d50:: with SMTP id dz16mr11257319edb.385.1639521870110;
        Tue, 14 Dec 2021 14:44:30 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:29 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v6 09/16] net: dsa: tag_qca: add define for handling MIB packet
Date:   Tue, 14 Dec 2021 23:44:02 +0100
Message-Id: <20211214224409.5770-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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

