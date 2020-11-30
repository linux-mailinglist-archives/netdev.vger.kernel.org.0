Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D307A2C7FE3
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgK3IaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:30:01 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:60860 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgK3IaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:30:01 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8SFDV117789;
        Mon, 30 Nov 2020 02:28:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606724895;
        bh=uih+wC6pY43onP10Es0hOsD8pxhoanJP5k7AS+OzJhM=;
        h=From:To:CC:Subject:Date;
        b=LJftCy6qDKQgoj1vpOFxI1a+JjRSTK+nJdTsUzPaeEQ2stWIavcL41n1KvPaynvPB
         ieU4VUEv/fy9cUAiVyFDE42exTNKH37++ME+vOm+seDdUviQdNJOD4FYF5Pg5Q4lAn
         AfTX3uHxfyrBwBTRFU6BUPsQaPIdrMEaNti4LSSw=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AU8SFwH039344
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 02:28:15 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 30
 Nov 2020 02:28:14 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 30 Nov 2020 02:28:14 -0600
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8S9Dq057144;
        Mon, 30 Nov 2020 02:28:10 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/4] net: ti: am65-cpsw-nuss: Add switchdev driver
Date:   Mon, 30 Nov 2020 13:50:42 +0530
Message-ID: <20201130082046.16292-1-vigneshr@ti.com>
X-Mailer: git-send-email 2.29.2
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
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 511 +++++++++++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  26 +
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 572 ++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-switchdev.h |  34 ++
 10 files changed, 1306 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst
 create mode 100644 Documentation/networking/devlink/am65-nuss-cpsw-switch.rst
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-switchdev.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-switchdev.h

-- 
2.29.2

