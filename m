Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB632FDB74
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 22:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbhATUzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:55:55 -0500
Received: from m12-18.163.com ([220.181.12.18]:55758 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388187AbhATNtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 08:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=1gsABYDfG5RbJRuW+5
        LcmE2LNHNvGErZzNpRw38meiQ=; b=c/Zp9QqjSTB/yeLxkozcmiAbVhQhKDoTMp
        RLn0+jUWSuLBWVO/fGCGoUEwqLYj9VdcjS/BzZZ3BbHqhCJDEZwjV1xvn88Q1Nbw
        Uq+qDIVfYNK93qoSRz72zWvZVyGOMtFyeTVorxKJ0fpNhv0Eb2HCTwyDgPyJFWOz
        BPog6bz+M=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp14 (Coremail) with SMTP id EsCowAAnOBgSDwhgjCFyQA--.58652S4;
        Wed, 20 Jan 2021 19:08:06 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Rusaimi Amira Ruslan <rusaimi.amira.rusaimi@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] net: stmmac: dwmac-intel-plat: remove config data on error
Date:   Wed, 20 Jan 2021 03:07:44 -0800
Message-Id: <20210120110745.36412-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EsCowAAnOBgSDwhgjCFyQA--.58652S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrW7ZrW5GrWrAF4ktr43KFg_yoWDZFc_uF
        1fZF9YqFW5Crs0yrW2vw43Z34F9F1qqr1SgFWkKaySvr9rWwn0qr97ZrnrXr4ku3yFyF9r
        Gr1xt3yxA34fKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5CksPUUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBZBYgclQHMDV47AAAsi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the config data when rate setting fails.

Fixes: 9efc9b2b04c7 ("net: stmmac: Add dwmac-intel-plat for GBE driver")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index 82b1c7a5a7a9..ba0e4d2b256a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -129,7 +129,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 				if (ret) {
 					dev_err(&pdev->dev,
 						"Failed to set tx_clk\n");
-					return ret;
+					goto err_remove_config_dt;
 				}
 			}
 		}
@@ -143,7 +143,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 			if (ret) {
 				dev_err(&pdev->dev,
 					"Failed to set clk_ptp_ref\n");
-				return ret;
+				goto err_remove_config_dt;
 			}
 		}
 	}
-- 
2.17.1


