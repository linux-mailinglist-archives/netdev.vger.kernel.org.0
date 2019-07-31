Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B277BB8C
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfGaIZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:25:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45388 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbfGaIZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:25:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so68617011wre.12;
        Wed, 31 Jul 2019 01:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PBvat3Cj+G9qNA7G6T127x/LvFb5SqytRXR0mJynSfA=;
        b=JMlKifHEtnBLafyDCCviJsfvxk3JA0GfheE3T+aTse3OPcNSwTf5biT9Im47MzaLSx
         FbC46YMLXw1ZUg4P7rCDSj6197mPQWqzWv0oNkGE1sPseir23a43G95fTM0wza6MfKFn
         znjEz9i35tbUNG+CGhw6eYgsFHuXha6igKzhrPvX1g9zJRctSVec88WCjkqtxrX2AEad
         ayLl6FkUsRWdj2v3I+9fwZ58arUG+tJ7Fylqpb12527RywOLKs+s5ntFCtkP95zu71/G
         6Cwt6B46QGy8eU5lhbIN6OqAh6y8URlSa1NtvKwSY5WFiZx1yW9IiIsDxunKdlPbY5Y7
         RXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PBvat3Cj+G9qNA7G6T127x/LvFb5SqytRXR0mJynSfA=;
        b=L4zYd3uiqGHwPAg5JaMeyIDH5Xg0VkThRsvsn9nFEzvt3Xmf/AVLrJR9QEXkAvv2FB
         juytxDMkE1PeH7bRTQ1UktCV1TvwQsiNAMA87KId8f49egRFsPh1ZbXjHnSw9iAgENgf
         avDUsWkhxO92m+ICpDdaNXUCDNkm2raSK7mXvOHYhxrbECGcpGkaUPIVDS2s4WYK9kn4
         t7qbfMrFsq7E0R8NcB2W0/mVMpuYCpKSVbz4YPtURW0oox2eq3Vd0s6dalHNFyMbVsPV
         KsW596sjlCQHGCScyO5Uojgn6Fjwu56t52lUuI+RYkiYnkc8wF4l5Q/rvp86GCKnAl5r
         gbzg==
X-Gm-Message-State: APjAAAWiZJ39UOmDQU0kwS0+3LUPS9AbFAN/KV/V17CM1h2X+SDlQWXV
        d88Pf4+hfV4vlF5mmyEA9tX+95Ctss4=
X-Google-Smtp-Source: APXvYqy79i12WqjNEvC5nGcy3cGAtMCs+clryXvZbwbsuCE4hkmP2C/LrjTbRQH7l/VTvjjK605mKA==
X-Received: by 2002:a5d:5450:: with SMTP id w16mr85374182wrv.128.1564561549087;
        Wed, 31 Jul 2019 01:25:49 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c78sm93223959wmd.16.2019.07.31.01.25.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 01:25:48 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 5/6] net: dsa: mv88e6xxx: order ptp structs numerically ascending
Date:   Wed, 31 Jul 2019 10:23:50 +0200
Message-Id: <20190731082351.3157-6-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731082351.3157-1-h.feurstein@gmail.com>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it is done for all the other structs within this driver.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/ptp.c | 32 ++++++++++++++++----------------
 drivers/net/dsa/mv88e6xxx/ptp.h |  4 ++--
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 768d256f7c9f..a1ff182c8737 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -310,6 +310,22 @@ static int mv88e6352_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 	return 0;
 }
 
+const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {
+	.clock_read = mv88e6165_ptp_clock_read,
+	.global_enable = mv88e6165_global_enable,
+	.global_disable = mv88e6165_global_disable,
+	.arr0_sts_reg = MV88E6165_PORT_PTP_ARR0_STS,
+	.arr1_sts_reg = MV88E6165_PORT_PTP_ARR1_STS,
+	.dep_sts_reg = MV88E6165_PORT_PTP_DEP_STS,
+	.rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
+};
+
 const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
 	.clock_read = mv88e6352_ptp_clock_read,
 	.ptp_enable = mv88e6352_ptp_enable,
@@ -333,22 +349,6 @@ const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
 		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
 };
 
-const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {
-	.clock_read = mv88e6165_ptp_clock_read,
-	.global_enable = mv88e6165_global_enable,
-	.global_disable = mv88e6165_global_disable,
-	.arr0_sts_reg = MV88E6165_PORT_PTP_ARR0_STS,
-	.arr1_sts_reg = MV88E6165_PORT_PTP_ARR1_STS,
-	.dep_sts_reg = MV88E6165_PORT_PTP_DEP_STS,
-	.rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
-		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
-		(1 << HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
-		(1 << HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ) |
-		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
-		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
-		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
-};
-
 static u64 mv88e6xxx_ptp_clock_read(const struct cyclecounter *cc)
 {
 	struct mv88e6xxx_chip *chip = cc_to_chip(cc);
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.h b/drivers/net/dsa/mv88e6xxx/ptp.h
index 0a1f8de8f062..58cbd21d58f6 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.h
+++ b/drivers/net/dsa/mv88e6xxx/ptp.h
@@ -148,8 +148,8 @@ void mv88e6xxx_ptp_free(struct mv88e6xxx_chip *chip);
 #define ptp_to_chip(ptp) container_of(ptp, struct mv88e6xxx_chip,	\
 				      ptp_clock_info)
 
-extern const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops;
 extern const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops;
+extern const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops;
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_PTP */
 
@@ -167,8 +167,8 @@ static inline void mv88e6xxx_ptp_free(struct mv88e6xxx_chip *chip)
 {
 }
 
-static const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {};
 static const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {};
+static const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {};
 
 #endif /* CONFIG_NET_DSA_MV88E6XXX_PTP */
 
-- 
2.22.0

