Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B676B61777F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 08:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiKCHTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 03:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiKCHTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 03:19:53 -0400
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [221.176.66.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA6FDFC7;
        Thu,  3 Nov 2022 00:19:48 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.97])
        by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee563636b913d6-f6bf7;
        Thu, 03 Nov 2022 15:19:46 +0800 (CST)
X-RM-TRANSID: 2ee563636b913d6-f6bf7
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.100])
        by rmsmtp-syy-appsvrnew09-12034 (RichMail) with SMTP id 2f0263636b8f318-b48e2;
        Thu, 03 Nov 2022 15:19:45 +0800 (CST)
X-RM-TRANSID: 2f0263636b8f318-b48e2
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] net: libwx: Remove variable dev to simplify code
Date:   Thu,  3 Nov 2022 15:19:56 +0800
Message-Id: <20221103071956.17480-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function wx_get_pcie_msix_counts(), the variable dev
is redundant, so remove it.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 1eb7388f1..a7d79490e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -883,13 +883,12 @@ EXPORT_SYMBOL(wx_reset_misc);
 int wx_get_pcie_msix_counts(struct wx_hw *wxhw, u16 *msix_count, u16 max_msix_count)
 {
 	struct pci_dev *pdev = wxhw->pdev;
-	struct device *dev = &pdev->dev;
 	int pos;
 
 	*msix_count = 1;
 	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
 	if (!pos) {
-		dev_err(dev, "Unable to find MSI-X Capabilities\n");
+		dev_err(&pdev->dev, "Unable to find MSI-X Capabilities\n");
 		return -EINVAL;
 	}
 	pci_read_config_word(pdev,
-- 
2.27.0



