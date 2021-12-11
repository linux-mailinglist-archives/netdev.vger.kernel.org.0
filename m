Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4EB4715E7
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhLKT62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhLKT6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:25 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54715C061714;
        Sat, 11 Dec 2021 11:58:25 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id w1so39838180edc.6;
        Sat, 11 Dec 2021 11:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6wPaNBOfuu/zzxVfLMdAXuf2rVrwWZl2wf2bIvpeLVc=;
        b=YP54dRpoVqg2AqpARe8WYGZFp7gKuRnv8qt/qG+pZvGRyQ70EKNvl6IjKT42w53Y7e
         7Fkz+VJcmNCi1k4RBVdzKVI26+CampxT1l7fErS8aBjxphUHKjCNgtTxeD7pbpJHYYZD
         +K2Bzs60OiO+Uiglzd5mhptWnLVod6aoJn9V3znV/4oZ3TW6Y4poPqUrZlG8zKtNQHlk
         HIV9st0Doevv1u5w89HWgEfSo6okXdAKhoZyor6UxU1+f/op0ueUX4uHUxqn32fCuFJL
         FFWhScVptdQ2KyXgwx1yQWrIOq2ZaoxS0kXpf5JpmSrxboOIBuuXmtiqRFk+OXxeAtkP
         A9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6wPaNBOfuu/zzxVfLMdAXuf2rVrwWZl2wf2bIvpeLVc=;
        b=cd4Zd0dQiRwSKNsEq4aNskVXu/J0kbi8rJxoLF6imSfH4n97OKKZptGdF6vlcaFAOs
         khoUjv1EvulEObuHRz3VkNINxD85Wt7BHbBeKvfr6Ks0x1tP4nPSJdHygZ+GvaKe4LjL
         TCHHKlR8T92A4tfwVXh/4wCSQWJ9Qh1pIeQXoWguuzt6sU2BNjItP0ssioGjD9CssesW
         M+N3kDTuvN/gUx5rxSCvHIVCglPbDKPbf+1zQtPNls8+iB+RH6aLQ2R43TIaBBG/b+iR
         jjaL3HEo233F65pmeObSvMiPcOyDFw6B7Div1OPTDBH/d38SG/0jFUXgnzKImUvuUvzR
         sXnA==
X-Gm-Message-State: AOAM533ZlaNoAuSlLhvz/OvNVkGrB9mbmnj1qIhdrIPujMHegFeYH0fA
        WO8y6yLFVFcaNq24OHDEB7g=
X-Google-Smtp-Source: ABdhPJwoWiUY/Q/jqr3h0jgADzFnnpJeyZAQLoOQLUbxa0kxM5VYG3D+m5WqgFZO9vLRUNRcWSSOoQ==
X-Received: by 2002:a17:907:1626:: with SMTP id hb38mr33191097ejc.481.1639252703734;
        Sat, 11 Dec 2021 11:58:23 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:23 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 09/15] net: dsa: tag_qca: add define for handling MIB packet
Date:   Sat, 11 Dec 2021 20:57:52 +0100
Message-Id: <20211211195758.28962-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add struct to correctly parse a mib Ethernet packet.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/linux/dsa/tag_qca.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 578a4aeafd92..f3369b939107 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -59,4 +59,21 @@ struct mdio_ethhdr {
 	u16 hdr;		/* qca hdr */
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
+struct tag_qca_priv {
+	void (*rw_reg_ack_handler)(struct dsa_port *dp,
+				   struct sk_buff *skb);
+	void (*mib_autocast_handler)(struct dsa_port *dp,
+				     struct sk_buff *skb);
+};
+
 #endif /* __TAG_QCA_H */
-- 
2.32.0

