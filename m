Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BE81B142B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgDTSQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:16:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:46779 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgDTSQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 14:16:57 -0400
IronPort-SDR: 2hImbGiGznTlUo4La2IPEL0Sn69ZGWGo1Q1yLGCm5jmCI+7BrAqcmzPVz8OxdmTNRvXlU0YsMt
 sZvTQBxzYxQQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 11:16:57 -0700
IronPort-SDR: qFQHTtrqWmuOg2z5mOWyOgYlUPkg7Sbz8CCp//jSZEb2k2k68/8MtKG8VjYP6BDzewVOPBZdrM
 9FCnjhLGYgSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="243907086"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2020 11:16:55 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 1DA88190; Mon, 20 Apr 2020 21:16:52 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/2] net: bcmgenet: Drop ACPI_PTR() to avoid compiler warning
Date:   Mon, 20 Apr 2020 21:16:51 +0300
Message-Id: <20200420181652.34620-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.1
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
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d975338bf78df..9f2f0e6816568 100644
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

