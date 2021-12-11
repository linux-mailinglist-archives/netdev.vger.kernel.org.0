Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE92471064
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345705AbhLKCGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345791AbhLKCGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:10 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FD0C0698C4;
        Fri, 10 Dec 2021 18:02:28 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r25so34767523edq.7;
        Fri, 10 Dec 2021 18:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6wPaNBOfuu/zzxVfLMdAXuf2rVrwWZl2wf2bIvpeLVc=;
        b=hUkm1d5layslJ7erVvX+QsI7wgZ7agcgOpJpe+W0imIBoDSw+GgXEgOk+msKi3uaXm
         pMKWO2cW3VV8ey33aNL9YuhVEW9W3rHpPrG6IwAOQWetjb0uIROeGA/vKAnXVxyY5gZR
         OqfxPSZtGxnVw+H+o85FZSFAnyi/SzKynqpTSJhosUycZXwHSpo69dUydRnVMEUni/r2
         exMatouKoANFOiIgHQRwFBNVBTLUXiQaFeP+cDUaLi3amgj0mLdHyk+o3nxzQ9pXQ9aJ
         oIRQf7D437ydZoHZbf8VhB+j+bOaGMppyBBxYkmfK2iMnGtvROdlupAzNssO9aJGhf3Q
         LJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6wPaNBOfuu/zzxVfLMdAXuf2rVrwWZl2wf2bIvpeLVc=;
        b=M2s6uH27NFc/ZpiPzbR5Fip8PuNhU6kGnO1rIwwnVl55UuU/ehV8wOB69nZHI8jcBD
         DEiASC46NDX/+WZKPHADbNYdKBdAy5hhJg9vmwowiRo0TNoa8kMinShAECkxfIYYN4hq
         +7n+6LvwOG5YnxkbSnl6G4QMin5iGoX89Or935cAxbhm2zT/HrO0Vriighujhtu1rWvd
         2xFXt+3cqvDPixW26GUIpHvofpbh+6ZBHc4XfxywaVP92NtZjOzIr6Fsm3ZdHBN6Kukb
         B0WU6SgcTyuaZBUgEA9Nauwu0JsXbEFL79UOW3VpMRdFR+YH8lA11cSxJG/Y3SL8BTmm
         aJLg==
X-Gm-Message-State: AOAM5333hwPNcdFKG4+5iC+54VHqp6JLdNFpT2pe6SqgW9iGLBDvIos1
        VxK9EI0iTo9mybslKwSX5x24Rg0b5/zowg==
X-Google-Smtp-Source: ABdhPJznz1utVfKBzk9uHvHjT/M2qoqYIHCf8UYLM5RU2B2KKw65W80PfeBCGBxLaXomChye1RaELA==
X-Received: by 2002:a17:906:9753:: with SMTP id o19mr28946754ejy.243.1639188147106;
        Fri, 10 Dec 2021 18:02:27 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:26 -0800 (PST)
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
Subject: [net-next RFC PATCH v3 08/14] net: dsa: tag_qca: add define for handling MIB packet
Date:   Sat, 11 Dec 2021 03:01:41 +0100
Message-Id: <20211211020155.10114-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
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

