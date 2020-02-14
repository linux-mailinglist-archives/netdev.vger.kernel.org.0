Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244BE15E52C
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393286AbgBNQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393004AbgBNQWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1604224764;
        Fri, 14 Feb 2020 16:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697374;
        bh=MLyC7p5DCKqMmpilfaOF4DuT3roGEBIotitr0W0Cwvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeYiI3sq78bvCQFIlAAJ6dM05ed1kGH6DyZb9r8vwHdD+4Bag/NgVTBaH3JahPqQ+
         QHSZNFq5erVl6uxwIRyh3hBh6leNBgXFbERvXtY4vliHOKYRyvR/WFO2dDEs6vtrXb
         NZY+hqtlYSbCGz+k9CegW/96mmmXN1J+lft87mLs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 072/141] net/wan/fsl_ucc_hdlc: remove set but not used variables 'ut_info' and 'ret'
Date:   Fri, 14 Feb 2020 11:20:12 -0500
Message-Id: <20200214162122.19794-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 270fe2ceda66b6964d4c6f261d7f562a02c1c786 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wan/fsl_ucc_hdlc.c: In function ucc_hdlc_irq_handler:
drivers/net/wan/fsl_ucc_hdlc.c:643:23:
	warning: variable ut_info set but not used [-Wunused-but-set-variable]
drivers/net/wan/fsl_ucc_hdlc.c: In function uhdlc_suspend:
drivers/net/wan/fsl_ucc_hdlc.c:880:23:
	warning: variable ut_info set but not used [-Wunused-but-set-variable]
drivers/net/wan/fsl_ucc_hdlc.c: In function uhdlc_resume:
drivers/net/wan/fsl_ucc_hdlc.c:925:6:
	warning: variable ret set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 87bf05a81db50..7c4a30391f746 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -591,11 +591,9 @@ static irqreturn_t ucc_hdlc_irq_handler(int irq, void *dev_id)
 	struct ucc_hdlc_private *priv = (struct ucc_hdlc_private *)dev_id;
 	struct net_device *dev = priv->ndev;
 	struct ucc_fast_private *uccf;
-	struct ucc_tdm_info *ut_info;
 	u32 ucce;
 	u32 uccm;
 
-	ut_info = priv->ut_info;
 	uccf = priv->uccf;
 
 	ucce = ioread32be(uccf->p_ucce);
@@ -826,7 +824,6 @@ static void resume_clk_config(struct ucc_hdlc_private *priv)
 static int uhdlc_suspend(struct device *dev)
 {
 	struct ucc_hdlc_private *priv = dev_get_drvdata(dev);
-	struct ucc_tdm_info *ut_info;
 	struct ucc_fast __iomem *uf_regs;
 
 	if (!priv)
@@ -838,7 +835,6 @@ static int uhdlc_suspend(struct device *dev)
 	netif_device_detach(priv->ndev);
 	napi_disable(&priv->napi);
 
-	ut_info = priv->ut_info;
 	uf_regs = priv->uf_regs;
 
 	/* backup gumr guemr*/
@@ -872,7 +868,7 @@ static int uhdlc_resume(struct device *dev)
 	struct ucc_fast __iomem *uf_regs;
 	struct ucc_fast_private *uccf;
 	struct ucc_fast_info *uf_info;
-	int ret, i;
+	int i;
 	u32 cecr_subblock;
 	u16 bd_status;
 
@@ -917,16 +913,16 @@ static int uhdlc_resume(struct device *dev)
 
 	/* Write to QE CECR, UCCx channel to Stop Transmission */
 	cecr_subblock = ucc_fast_get_qe_cr_subblock(uf_info->ucc_num);
-	ret = qe_issue_cmd(QE_STOP_TX, cecr_subblock,
-			   (u8)QE_CR_PROTOCOL_UNSPECIFIED, 0);
+	qe_issue_cmd(QE_STOP_TX, cecr_subblock,
+		     (u8)QE_CR_PROTOCOL_UNSPECIFIED, 0);
 
 	/* Set UPSMR normal mode */
 	iowrite32be(0, &uf_regs->upsmr);
 
 	/* init parameter base */
 	cecr_subblock = ucc_fast_get_qe_cr_subblock(uf_info->ucc_num);
-	ret = qe_issue_cmd(QE_ASSIGN_PAGE_TO_DEVICE, cecr_subblock,
-			   QE_CR_PROTOCOL_UNSPECIFIED, priv->ucc_pram_offset);
+	qe_issue_cmd(QE_ASSIGN_PAGE_TO_DEVICE, cecr_subblock,
+		     QE_CR_PROTOCOL_UNSPECIFIED, priv->ucc_pram_offset);
 
 	priv->ucc_pram = (struct ucc_hdlc_param __iomem *)
 				qe_muram_addr(priv->ucc_pram_offset);
-- 
2.20.1

