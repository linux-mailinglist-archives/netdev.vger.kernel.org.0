Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA94E611D5D
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 00:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJ1WVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 18:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJ1WVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 18:21:49 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6901DB244;
        Fri, 28 Oct 2022 15:21:47 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id c8so4976909qvn.10;
        Fri, 28 Oct 2022 15:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gvm+hczkyJbLd+X2XWCJf7XdhxPzM2OLrP9LO1Cdf7A=;
        b=cuDSYxN01RBWr+Oz0XuzQYz/so8QhWFa7VbDF7n+dS4z4pU4oEP7lClNqf/nHNiokF
         O26W1rnjWJRvEFNi+y8D2PTATf2C+CM/EF6KuSMRvsW6YMlgZRNAFpGdfdpMrp2XVKKn
         tWobwnbXWVgKjG0RVRBy42UfINo/Z54ULYoFzuCUXENvgeYcMzo3vyhaq0oHuSIYjVaH
         oX07QrLJvjEStzi3Y0SF9l+vDIYM/GIW3WF1bqxK/yy6qGOslrRLQYLRFwb02Yuj2DtX
         gMc/T6qt7WIaJ8mQziQz0+oRIjrfA2604Yyb2ZEDzT9PdBf0JIdpNxKyXCEvBdMbwO7n
         82gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gvm+hczkyJbLd+X2XWCJf7XdhxPzM2OLrP9LO1Cdf7A=;
        b=w+7sDIKqnh66FxsfamZZ6I6AUHyFfuFHju+CxVs71LvesdeUUCF1SSZ4L3eXR8AF5R
         mgBxXX4R7PK1xBzv5IyBs8Rep17R2ja5SVj+P0wUGcq2B5F5DhvGdnp6v1IGSeaDcRDZ
         HaFSxH+KWWSP3EP2mJ6E0bR5L8KD3zTL2I9CQ7rP9srFkg3l+gN4vHLaT2W+jRyX2zUe
         VBjF4tHnrp3oik1FciF6Jj2eRE/GiGN0r75Bf7MxlKKdX0Jq+L+ZrvwQy/4t//PY6uh0
         7DtXcYlhlka2EwA7zZVVgNIyzjMbymw4q37MRmAJKlw+MNC6tCknrwOdeumO1xvLHTPd
         HJFA==
X-Gm-Message-State: ACrzQf1qI1W6lm1c0QHzNgyC+xKlpxDGcEHB653k/F/i4UUTtuHGyWn6
        VQPAPKESZ3EtC1meDMBU+WwYvww85aDzWw==
X-Google-Smtp-Source: AMsMyM6ZVMyxFYxvSD9tVCOjnyRtEVRCCo5mKXN1qu8PCppBo+ID2zmpm2wrk7xDWwxQfJOe/c5dsg==
X-Received: by 2002:a05:6214:230b:b0:4b8:aa39:f3a6 with SMTP id gc11-20020a056214230b00b004b8aa39f3a6mr1614953qvb.30.1666995706186;
        Fri, 28 Oct 2022 15:21:46 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a0bcd00b006cf38fd659asm3823135qki.103.2022.10.28.15.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 15:21:45 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: systemport: Add support for RDMA overflow statistic counter
Date:   Fri, 28 Oct 2022 15:21:40 -0700
Message-Id: <20221028222141.3208429-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDMA overflows can happen if the Ethernet controller does not have
enough bandwidth allocated at the memory controller level, report RDMA
overflows and deal with saturation, similar to the RBUF overflow
counter.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- removed Changed-Id

 drivers/net/ethernet/broadcom/bcmsysport.c | 11 +++++++++++
 drivers/net/ethernet/broadcom/bcmsysport.h | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 425d6ccd5413..95449bf034ac 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -295,6 +295,8 @@ static const struct bcm_sysport_stats bcm_sysport_gstrings_stats[] = {
 	/* RBUF misc statistics */
 	STAT_RBUF("rbuf_ovflow_cnt", mib.rbuf_ovflow_cnt, RBUF_OVFL_DISC_CNTR),
 	STAT_RBUF("rbuf_err_cnt", mib.rbuf_err_cnt, RBUF_ERR_PKT_CNTR),
+	/* RDMA misc statistics */
+	STAT_RDMA("rdma_ovflow_cnt", mib.rdma_ovflow_cnt, RDMA_OVFL_DISC_CNTR),
 	STAT_MIB_SOFT("alloc_rx_buff_failed", mib.alloc_rx_buff_failed),
 	STAT_MIB_SOFT("rx_dma_failed", mib.rx_dma_failed),
 	STAT_MIB_SOFT("tx_dma_failed", mib.tx_dma_failed),
@@ -333,6 +335,7 @@ static inline bool bcm_sysport_lite_stat_valid(enum bcm_sysport_stat_type type)
 	case BCM_SYSPORT_STAT_NETDEV64:
 	case BCM_SYSPORT_STAT_RXCHK:
 	case BCM_SYSPORT_STAT_RBUF:
+	case BCM_SYSPORT_STAT_RDMA:
 	case BCM_SYSPORT_STAT_SOFT:
 		return true;
 	default:
@@ -436,6 +439,14 @@ static void bcm_sysport_update_mib_counters(struct bcm_sysport_priv *priv)
 			if (val == ~0)
 				rbuf_writel(priv, 0, s->reg_offset);
 			break;
+		case BCM_SYSPORT_STAT_RDMA:
+			if (!priv->is_lite)
+				continue;
+
+			val = rdma_readl(priv, s->reg_offset);
+			if (val == ~0)
+				rdma_writel(priv, 0, s->reg_offset);
+			break;
 		}
 
 		j += s->stat_sizeof;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 5af16e5f9ad0..335cf6631db5 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -290,6 +290,7 @@ struct bcm_rsb {
 
 #define RDMA_WRITE_PTR_HI		0x1010
 #define RDMA_WRITE_PTR_LO		0x1014
+#define RDMA_OVFL_DISC_CNTR		0x1018
 #define RDMA_PROD_INDEX			0x1018
 #define  RDMA_PROD_INDEX_MASK		0xffff
 
@@ -565,6 +566,7 @@ struct bcm_sysport_mib {
 	u32 rxchk_other_pkt_disc;
 	u32 rbuf_ovflow_cnt;
 	u32 rbuf_err_cnt;
+	u32 rdma_ovflow_cnt;
 	u32 alloc_rx_buff_failed;
 	u32 rx_dma_failed;
 	u32 tx_dma_failed;
@@ -581,6 +583,7 @@ enum bcm_sysport_stat_type {
 	BCM_SYSPORT_STAT_RUNT,
 	BCM_SYSPORT_STAT_RXCHK,
 	BCM_SYSPORT_STAT_RBUF,
+	BCM_SYSPORT_STAT_RDMA,
 	BCM_SYSPORT_STAT_SOFT,
 };
 
@@ -627,6 +630,14 @@ enum bcm_sysport_stat_type {
 	.reg_offset = ofs, \
 }
 
+#define STAT_RDMA(str, m, ofs) { \
+	.stat_string = str, \
+	.stat_sizeof = sizeof(((struct bcm_sysport_priv *)0)->m), \
+	.stat_offset = offsetof(struct bcm_sysport_priv, m), \
+	.type = BCM_SYSPORT_STAT_RDMA, \
+	.reg_offset = ofs, \
+}
+
 /* TX bytes and packets */
 #define NUM_SYSPORT_TXQ_STAT	2
 
-- 
2.25.1

