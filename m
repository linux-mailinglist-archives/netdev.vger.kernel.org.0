Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA051B18CA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgDTVvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:51:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:11821 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgDTVv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:51:27 -0400
IronPort-SDR: QiZJ5W7xgyMv4lnHx2wQ8mutdXsGpuPJ3jAVU6JXKcG2QjndUV1KYZ/ajNAF0R/6YvXy6ZQuFh
 CRHjd/v3x0ng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 14:51:26 -0700
IronPort-SDR: b+PJegl+nrYoqwLw5nJ15f9nI0KvnCv+Q9pOumHXVzQ5cw/FohdLiZ8f+SUBEUiy7NS1VezAWM
 SZ5JtEPu2Cyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="279391957"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 20 Apr 2020 14:51:24 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D5F6E17F; Tue, 21 Apr 2020 00:51:22 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/5] net: bcmgenet: Drop ACPI_PTR() to avoid compiler warning
Date:   Tue, 21 Apr 2020 00:51:17 +0300
Message-Id: <20200420215121.17735-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
References: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiled with CONFIG_ACPI=n, ACPI_PTR() will be no-op, and thus
genet_acpi_match table defined, but not used. Compiler is not happy about
such data. Drop ACPI_PTR() for good.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d975338bf78d..9f2f0e681656 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3740,7 +3740,7 @@ static struct platform_driver bcmgenet_driver = {
 		.name	= "bcmgenet",
 		.of_match_table = bcmgenet_match,
 		.pm	= &bcmgenet_pm_ops,
-		.acpi_match_table = ACPI_PTR(genet_acpi_match),
+		.acpi_match_table = genet_acpi_match,
 	},
 };
 module_platform_driver(bcmgenet_driver);
-- 
2.26.1

