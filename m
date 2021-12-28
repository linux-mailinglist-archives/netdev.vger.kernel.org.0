Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F334807DA
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 10:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbhL1JeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 04:34:14 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:40143 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhL1JeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 04:34:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1640684047;
        bh=td5/7s5euCyyDx5GzCAltI7Bvj9Xn81rXHm7OL7+L1k=;
        h=From:To:Cc:Subject:Date;
        b=hdv0R/WCvX1XyqRB62gihcOwfAtsY44L0V3WPGyKIY9BV00JVF3Rq6dpyCNfRTlhx
         A1fjqQBEuwcfy5yFH8gejvXUjyLqK5N/MANGsZAORWPXpI298NFuMCXu/dSiXH4TRR
         PhIIgp5fJv9m4pd1U7E0rU451Irq8FUSlqXUAT48=
Received: from localhost.localdomain ([159.226.95.43])
        by newxmesmtplogicsvrszc9.qq.com (NewEsmtp) with SMTP
        id 884242EC; Tue, 28 Dec 2021 17:34:04 +0800
X-QQ-mid: xmsmtpt1640684044t22y91cjd
Message-ID: <tencent_205AA371C910BBA2CF01B311811ABDF2560A@qq.com>
X-QQ-XMAILINFO: MpO6L0LObisWsPgxOAqbPeEgIgw8ezvtNWIYx+zAuIeMFZIBAcIEZ69PI2YTNa
         yTXJGxZBICZE/eYhonB0yv0gk9Tamb7BmBz8kv972KSvdU5EpFk9oMNvCSEwYbZUxzoIZPxgPSJh
         lAkuwbWNIJma2Zoak+lWp+bKgM7e/OGb1OK99IdA64gtmGLRbLvtn04S7ECDc8kZ+TEcyhinadUH
         dNukIOcqvPlR/i9xj1jk0xK/szstuPCSJcujtqNc0wcj1EnDLMopmfK5ghiKlEkrWa6gTJ9n4eKS
         iJ1b4a+Iv9NtHB/ylKDqNWh1Tr27kfILPkwiNQ1PnpmHe4rA4ImL6qXlNP4K+gZyTsfSvQKONnY9
         VM6HNY2IbzxlxmMwuAZqMPEP+t0hREwo/ydj/wTzygAIJ8KYfaxPoyaGRUJDFy5mHRlRP3bqg7+F
         ibNAKFDRCuPwx+sZiST1tiOR+WPv4/CGLViJqDxA3+sXA2Tec1MDHgFqBJfFNhj/zWkZxol7m+ob
         eL1MAXDCuYwbGA5vhCjqkAwYtC24HJKX4aF/QeCxrKziG8BSzwLsj1DjYL1EaZInnCM7eGfS7VqU
         NB8BDGodRyb1nJ0dhnNbxRnwnSbm16uFknATUlWKOqKYECiDpAKUINigyqowVk3l9Fb5sfEeEgu0
         LaqHRuWfm+cW2GsbQWI5abFfM6GR24l0g4Z3fQgEpSCszpm+RDTxIWXlZ11umKUd4I5Lf4ZMXDmQ
         46z6UtwUlxMDUgs2Dv8BmGSQTPCoiLxZm4C3FFaMl+4rWENFBIsFSU20+N4ShJrnBg9UhJeK+t2b
         keDwUTwjM/hf5PAhakT0ZUiN5+vin3D8T6UGyVYdLOgRTOE9+JbOGWb8c8fk5pGfcfPsEOQ6u0ET
         4zg3fcgHiH
From:   Peiwei Hu <jlu.hpw@foxmail.com>
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Peiwei Hu <jlu.hpw@foxmail.com>
Subject: [PATCH] ipw2100: inproper error handling of ipw2100_pci_init_one
Date:   Tue, 28 Dec 2021 17:34:00 +0800
X-OQ-MSGID: <20211228093400.3061632-1-jlu.hpw@foxmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

goto fail instead of returning directly in error exiting

Signed-off-by: Peiwei Hu <jlu.hpw@foxmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 2ace2b27ecad..de043edc0521 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -6183,7 +6183,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_enable_device.\n");
-		return err;
+		goto fail;
 	}
 
 	priv = libipw_priv(dev);
@@ -6196,7 +6196,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_set_dma_mask.\n");
 		pci_disable_device(pci_dev);
-		return err;
+		goto fail;
 	}
 
 	err = pci_request_regions(pci_dev, DRV_NAME);
@@ -6204,7 +6204,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_request_regions.\n");
 		pci_disable_device(pci_dev);
-		return err;
+		goto fail;
 	}
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-- 
2.25.1

