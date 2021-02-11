Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A7A318910
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhBKLGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:06:54 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54128 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbhBKK7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:59:04 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11BAvX0j042891;
        Thu, 11 Feb 2021 04:57:33 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613041053;
        bh=kES9xi3cLs4m6wbQMIvfy/mryzrSHfq5nzjBcfr/Q0o=;
        h=From:To:CC:Subject:Date;
        b=aYO8zpxrbXoT6yWYv6+PGPvdYi4bO4VhqZl9vvny0G+6ICtvAVLASvC85FHqfYy6a
         3S2tenY7ZkWg/TGzWK5O+x2KQO0k4W3MZ9pXkKPp1jQsfXFDqkFT2vGav6AUGUG9aS
         ZZE5L91nCWVYU2QGVVcRlX7RzBnbKWAgIb2kUQrc=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11BAvXju029255
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 11 Feb 2021 04:57:33 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 11
 Feb 2021 04:57:32 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 11 Feb 2021 04:57:32 -0600
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11BAvS0Z045148;
        Thu, 11 Feb 2021 04:57:29 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 0/4] net: ti: am65-cpsw-nuss: Add switchdev driver
Date:   Thu, 11 Feb 2021 16:26:40 +0530
Message-ID: <20210211105644.15521-1-vigneshr@ti.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds switchdev support for AM65 CPSW NUSS driver to support
multi port CPSW present on J721e and AM64 SoCs.
It adds devlink hook to switch b/w switch mode and multi mac mode.

v2:
Rebased on latest net-next
Update patch 1/4 with rationale for using devlink

Vignesh Raghavendra (4):
  net: ti: am65-cpsw-nuss: Add devlink support
  net: ti: am65-cpsw-nuss: Add netdevice notifiers
  net: ti: am65-cpsw-nuss: Add switchdev support
  docs: networking: ti: Add driver doc for AM65 NUSS switch driver

 .../device_drivers/ethernet/index.rst         |   1 +
 .../ethernet/ti/am65_nuss_cpsw_switchdev.rst  | 143 +++++
 .../devlink/am65-nuss-cpsw-switch.rst         |  26 +
 Documentation/networking/devlink/index.rst    |   1 +
 drivers/net/ethernet/ti/Kconfig               |  10 +
 drivers/net/ethernet/ti/Makefile              |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 511 ++++++++++++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  26 +
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 533 ++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-switchdev.h |  34 ++
 10 files changed, 1267 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst
 create mode 100644 Documentation/networking/devlink/am65-nuss-cpsw-switch.rst
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-switchdev.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-switchdev.h

-- 
2.30.0

