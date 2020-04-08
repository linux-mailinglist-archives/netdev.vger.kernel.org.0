Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2FAF1A28DF
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 20:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgDHSyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 14:54:39 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55225 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgDHSyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 14:54:39 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MOzGc-1jezXZ2dFk-00PNE2; Wed, 08 Apr 2020 20:54:17 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chin-Yen Lee <timlee@realtek.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Brian Norris <briannorris@chromium.org>,
        Chris Chiu <chiu@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtw88: avoid unused function warnings
Date:   Wed,  8 Apr 2020 20:53:51 +0200
Message-Id: <20200408185413.218643-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:NcxJ3QwXn+I/rIrGm23TbRtV/rSdt2ck5/p2IEg1r3CmWhFbgeo
 b+WNMyhAX9E4KZ/3PsT3fuPrA9OgXE36y4NLKM+dm5k2yO2O/Em7jA8u0Ay7U0R93jOwpX9
 1f7kt/zVFU/4osp1IXY8rfOsb6NNivxBLWoOKk7hMsyCHvTdrkmQiTadkpONGGQ7QvGe3iz
 H6OqWAFqZhyqtrZfiyQqA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ain4j8UjaS4=:xPFq9x2/orRVHsZe2bfhS/
 7Fsft5wkuKS9ipxHcAHtN7JkgqgX78LuWM0lJpIVDscesdNeq7rDetOFaYNVuHiQI0u7oYQtK
 +F34ShN01nQGYKyPysrh8zOg18zwl7Hcpust1GxWMc/IbpH7FgbT0nszYlIfH37pP4XlmlRiw
 dV+O8rsBgLHn1jnXS/z4hAz8nke9CYmmzdOTced58zBVEFVRTn9q+OdLLSPPBX2S0XmWyr4NW
 snDsuSD6IcR6/ZI7U752HuqabBeTvWEjqAIwsm71Me3CjOJcQBMv9y6As0lzYLoIC7YuoBr6k
 Zft67PebPSvYndCdQzPP3xpwOMqfDoCag/i1ev+N/Q260cIlKO8H2f4gjS0tLFCmMi1JAo9/+
 noVCpVu+YLW4eZdAxIJwMC6V2RVL7GM8E37MD+eNGR7lSvBbOwJ12k8oMaVVbitjQaSqQUnIp
 RffpvWf2wzYu0OH3NUC7Duy12BMHN0Q+rAllc8wuwrZEfuXAP+zCFeJmysOesdpYsQBnh/T11
 nTTScIW5YHPQa85/8Zlr9lESMIPg1aISF5fS7+2sVKC/SqBeeYJ6oOItYjz4nPbwEUhL8OcR7
 oz3YcfWOlnLDnzVQxNFfMlx4C07EFrz/i9uZLAo/PPJtEbyopu8tcmNI3+HCflIQdDRhO9/Jq
 aOEhh2IgWXX+KMRxfkZSZ83yFGA8xgGLWQHT4s6WG+VV058KoSkizMuc3fEmAEwdzZ5pjCtOT
 vD4BhwkmPJdRglybncWfi+LFTrstyEKxcto1Q+pV5bFnmLcPyDsDx2RL8+v+LsQp9SjGpRVJD
 JZgqS1ctSqyfcF+jKHKqp6aEpk+nVc7p/v4kFK0nhGIRxBrPkU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtw88 driver defines emtpy functions with multiple indirections
but gets one of these wrong:

drivers/net/wireless/realtek/rtw88/pci.c:1347:12: error: 'rtw_pci_resume' defined but not used [-Werror=unused-function]
 1347 | static int rtw_pci_resume(struct device *dev)
      |            ^~~~~~~~~~~~~~
drivers/net/wireless/realtek/rtw88/pci.c:1342:12: error: 'rtw_pci_suspend' defined but not used [-Werror=unused-function]
 1342 | static int rtw_pci_suspend(struct device *dev)

Better simplify it to rely on the conditional reference in
SIMPLE_DEV_PM_OPS(), and mark the functions as __maybe_unused to avoid
warning about it.

I'm not sure if these are needed at all given that the functions
don't do anything, but they were only recently added.

Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index e37c71495c0d..1af87eb2e53a 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1338,22 +1338,17 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
 	rtw_pci_link_cfg(rtwdev);
 }
 
-#ifdef CONFIG_PM
-static int rtw_pci_suspend(struct device *dev)
+static int __maybe_unused rtw_pci_suspend(struct device *dev)
 {
 	return 0;
 }
 
-static int rtw_pci_resume(struct device *dev)
+static int __maybe_unused rtw_pci_resume(struct device *dev)
 {
 	return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(rtw_pm_ops, rtw_pci_suspend, rtw_pci_resume);
-#define RTW_PM_OPS (&rtw_pm_ops)
-#else
-#define RTW_PM_OPS NULL
-#endif
 
 static int rtw_pci_claim(struct rtw_dev *rtwdev, struct pci_dev *pdev)
 {
@@ -1582,7 +1577,7 @@ static struct pci_driver rtw_pci_driver = {
 	.id_table = rtw_pci_id_table,
 	.probe = rtw_pci_probe,
 	.remove = rtw_pci_remove,
-	.driver.pm = RTW_PM_OPS,
+	.driver.pm = &rtw_pm_ops,
 };
 module_pci_driver(rtw_pci_driver);
 
-- 
2.26.0

