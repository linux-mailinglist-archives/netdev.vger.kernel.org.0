Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E77C3072F1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 10:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhA1JjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 04:39:13 -0500
Received: from m12-14.163.com ([220.181.12.14]:53403 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232489AbhA1Jaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 04:30:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=u572u
        RJOAm3kNOY9kS7OvdsbJ0boIJxgCpqT07Onf2k=; b=LHOoLY13HCGKNOo0D3qiL
        XdZJnWyHz92xKWw4rXtY6orqheMhfe/z7l5ikOLBc6Ri2aGTaeDjoPkXMRfxF/B6
        2/7E57OhZ5vnVBKMrVptm9afIn1RHA1Nj3ds9J1XrG13tklYUUTVn6bIRNdH2fVH
        AGEXrHCngXzMk1OuBuRSTY=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp10 (Coremail) with SMTP id DsCowAAHwbY8NRJgxjLNiA--.49842S2;
        Thu, 28 Jan 2021 11:53:35 +0800 (CST)
From:   dingsenjie@163.com
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] net/ethernet: convert to use module_platform_driver in octeon_mgmt.c
Date:   Thu, 28 Jan 2021 11:53:30 +0800
Message-Id: <20210128035330.17676-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowAAHwbY8NRJgxjLNiA--.49842S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw47KFW3KFW7Kr1DCrWDtwb_yoWkKrbE9r
        1xX3WfXF4UCr1Fka1qgw1a93ySka4kZrn3GF4IgrZ0qa13Wwn0v34DArW7Xw1kWr4xJFyD
        CrsrGFy7C3y2yjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU58Ma5UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbipRUnyFUMcFIUcwAGsF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

Simplify the code by using module_platform_driver macro
for octeon_mgmt.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 5e50bb1..ecffebd 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1556,18 +1556,7 @@ static int octeon_mgmt_remove(struct platform_device *pdev)
 	.remove		= octeon_mgmt_remove,
 };
 
-static int __init octeon_mgmt_mod_init(void)
-{
-	return platform_driver_register(&octeon_mgmt_driver);
-}
-
-static void __exit octeon_mgmt_mod_exit(void)
-{
-	platform_driver_unregister(&octeon_mgmt_driver);
-}
-
-module_init(octeon_mgmt_mod_init);
-module_exit(octeon_mgmt_mod_exit);
+module_platform_driver(octeon_mgmt_driver);
 
 MODULE_SOFTDEP("pre: mdio-cavium");
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-- 
1.9.1


