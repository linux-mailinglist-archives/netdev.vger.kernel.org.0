Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE684E2045
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 06:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344461AbiCUFzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 01:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344439AbiCUFzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 01:55:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B54A4F468;
        Sun, 20 Mar 2022 22:53:53 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22KKbL24029509;
        Sun, 20 Mar 2022 22:53:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=hT+HGXs0ZEbIy/JemVhWHaTROOpRZd8zXq+y0c9H4IQ=;
 b=H2oqWeErSTGr+EDdRnHvs21TFBwNG3RDLQ796v4j/LBO8nE35Qsjxdt2O7ZrHxxAqJRR
 8YcTeUbKu4JDbhXo8Z9SosW1nckCqY8nYNHYTeWO9AHLzOO7SxQlUcsdzpBH9uUfhQ7S
 6n3yKR+2dGu5pG6+WIUv7OwyN4MmLXulOINghu9Tc+vIvlY9wyj1uWGuVpXp7I/gYBs3
 g4IHgUd9rnCrTQo/ndL0sOSQeUGNmedgTCpRC+erm8l4ToVTg8GEFcAJBvl87B646i38
 ELYhlK3puRmG0kn0ofTbb9o+UXJ24c/YqOfgrIywGJxfoGEE2OZYMCjHaF0ZDNm7G1qn Xw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ewepmwr1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 20 Mar 2022 22:53:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Mar
 2022 22:53:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 20 Mar 2022 22:53:39 -0700
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 03AD83F704B;
        Sun, 20 Mar 2022 22:53:38 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [net-next PATCH v4 0/7] Add octeon_ep driver
Date:   Sun, 20 Mar 2022 22:53:30 -0700
Message-ID: <20220321055337.4488-1-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: kEd6WbP7wNL3kFMyzXZ3xX0U8kgOPRS2
X-Proofpoint-GUID: kEd6WbP7wNL3kFMyzXZ3xX0U8kgOPRS2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_02,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver implements networking functionality of Marvell's Octeon
PCI Endpoint NIC.

This driver support following devices:
 * Network controller: Cavium, Inc. Device b200

V3 -> V4:
   - Fix warnings and errors reported by "make W=1 C=1".

V2 -> V3:
   - Fix warnings and errors reported by kernel test robot:
     "Reported-by: kernel test robot <lkp@intel.com>"

V1 -> V2:
    - Address review comments on original patch series.
    - Divide PATCH 1/4 from the original series into 4 patches in
      v2 patch series: PATCH 1/7 to PATCH 4/7.
    - Fix clang build errors.

Veerasenareddy Burru (7):
  octeon_ep: Add driver framework and device initialization
  octeon_ep: add hardware configuration APIs
  octeon_ep: Add mailbox for control commands
  octeon_ep: add Tx/Rx ring resource setup and cleanup
  octeon_ep: add support for ndo ops
  octeon_ep: add Tx/Rx processing and interrupt support
  octeon_ep: add ethtool support for Octeon PCI Endpoint NIC

 .../device_drivers/ethernet/index.rst         |    1 +
 .../ethernet/marvell/octeon_ep.rst            |   35 +
 MAINTAINERS                                   |    7 +
 drivers/net/ethernet/marvell/Kconfig          |    1 +
 drivers/net/ethernet/marvell/Makefile         |    1 +
 .../net/ethernet/marvell/octeon_ep/Kconfig    |   20 +
 .../net/ethernet/marvell/octeon_ep/Makefile   |    9 +
 .../marvell/octeon_ep/octep_cn9k_pf.c         |  737 +++++++++++
 .../ethernet/marvell/octeon_ep/octep_config.h |  204 +++
 .../marvell/octeon_ep/octep_ctrl_mbox.c       |  256 ++++
 .../marvell/octeon_ep/octep_ctrl_mbox.h       |  170 +++
 .../marvell/octeon_ep/octep_ctrl_net.c        |  194 +++
 .../marvell/octeon_ep/octep_ctrl_net.h        |  299 +++++
 .../marvell/octeon_ep/octep_ethtool.c         |  463 +++++++
 .../ethernet/marvell/octeon_ep/octep_main.c   | 1178 +++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.h   |  379 ++++++
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  367 +++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |  508 +++++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.h |  199 +++
 .../net/ethernet/marvell/octeon_ep/octep_tx.c |  335 +++++
 .../net/ethernet/marvell/octeon_ep/octep_tx.h |  284 ++++
 21 files changed, 5647 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Makefile
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_config.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.h


base-commit: 092d992b76ed9d06389af0bc5efd5279d7b1ed9f
-- 
2.17.1

