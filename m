Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B3D47106A
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345806AbhLKCGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345750AbhLKCGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:20 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7D8C0698C8;
        Fri, 10 Dec 2021 18:02:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v1so35648744edx.2;
        Fri, 10 Dec 2021 18:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6wPaNBOfuu/zzxVfLMdAXuf2rVrwWZl2wf2bIvpeLVc=;
        b=k6w5sPVp+HaM8by38aBJsXMomTTNb+AWA5mUAs4tBHsMbYPaNnZ5XK4hJN0XTfTZrJ
         UA1MhkadtnuvqdyomMvCWI/s10eebINJSs3lSnhuKOMgvp2+2zcqw0yw6ELGeoMEQ1O9
         nj/F/iiTDAW7waxD/GC1m7J28NFhxuZheaRRZZ62ezqY/A+XWiyrIOsQq1n4zObIWo0F
         UT3bqLWvhdw1j6KL5lJaGjTqHWjdvYG19sCsdLvhaS6c1RhMM6vsXMgBdSl1HqRxi0qp
         gciRM6dvu8upAskz8nLANnH6NGHC6+otSum2AbHf/Djg+yJIIY5gnrA0fONnwlfBdUw5
         jeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6wPaNBOfuu/zzxVfLMdAXuf2rVrwWZl2wf2bIvpeLVc=;
        b=DjhfEe3RrKH3IW7fmfre+VqRyXDWPfC4PLING2gseBt/Y5pvUR2tFQDSxGTFw0bmly
         qK/abGSDobyF1BKr1Qryzdk0O3zPe7BK3NsA0Dzq/5vrHnoWsilJiDlY10vLfgS3wsfv
         ZtYw/L6FhEyZ8YNdnendsTR5xOlnEyvm3tWrxcf6ec7BOSsJ86y2rrghfhNh5fGCl52l
         1aNgNHAAnyJ6zjGUOex69vThz5qiMlOs85xqtwjskNNKGHgMO128GFTWLW+4aVi67UoN
         t5vrRvhNntHp07v0l7fTMfuRGANNrLPtCOAzLJoto3bD/ZNr4f2mIDvGFO6YkokjvgAZ
         i9Mw==
X-Gm-Message-State: AOAM530E5O4j8JHDza1yv9OlibN+v7XR/PK6cO4whvGT6ZybJo6uspcB
        5R6WFkQvRPfmAS71h3/xziAFWIfVUYIpMg==
X-Google-Smtp-Source: ABdhPJxG6j+KI0weRHYzBD7AwebO3xH+5DTYqM3s1d3Apn0FhJKcaHOpLL4VOxo4Cc1ElBSqC5W7/A==
X-Received: by 2002:a05:6402:1388:: with SMTP id b8mr44112829edv.171.1639188149433;
        Fri, 10 Dec 2021 18:02:29 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:29 -0800 (PST)
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
Subject: [net-next RFC PATCH v3 09/15] net: dsa: tag_qca: add define for handling MIB packet
Date:   Sat, 11 Dec 2021 03:01:43 +0100
Message-Id: <20211211020155.10114-12-ansuelsmth@gmail.com>
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

