Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1AF4FEDA4
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 05:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiDMDhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 23:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiDMDhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 23:37:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7829026570;
        Tue, 12 Apr 2022 20:35:23 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CHw2UT008778;
        Tue, 12 Apr 2022 20:35:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=AkXs6NTbL7IKkOe27+UheR5UY26Uf0hizdTcbdBRvMc=;
 b=X30LHMPoUNnU6pDpoPYklDOSKvRDqWTG0HGcRiqu6ZVQXIywt/UFewO9eOJhMmKPHSEZ
 2d1G18tPJ500k1VlH5rTqL30uC0l+e0AvZkMdI0A7zOwRzSZr4ZzWYg5+bHv9DFErJol
 KfZs5VSBKmjOGtjix1zkiUyD1YcfKn9ftq5elCiQS9le2GWzedvI4QCau7p/WlpviLZ6
 ++blsZVe4pZFYVZ5fzE+27W7kkkVfqeDTk0Vp/ST5oIgmB131czj6aQCnpLpYYK3fvA2
 4Uk9ndD2DVHMgzTo4TChKKIITJ9mbg4oaxsUfSvI9NvR/CsZEODhkulYWnYOhhgRLVoL RA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fd6nfccx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 20:35:08 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Apr
 2022 20:35:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Apr 2022 20:35:07 -0700
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 5D43A3F705B;
        Tue, 12 Apr 2022 20:35:07 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [net-next PATCH v5 0/7] Add octeon_ep driver
Date:   Tue, 12 Apr 2022 20:34:56 -0700
Message-ID: <20220413033503.3962-1-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: BRquQkyRi16EfvARkF_R3XRBctEdKaFd
X-Proofpoint-ORIG-GUID: BRquQkyRi16EfvARkF_R3XRBctEdKaFd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
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

V4 -> V5:
   - Fix warnings reported by clang.
   - Address comments from community reviews.

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
 .../ethernet/marvell/octeon_ep/octep_main.c   | 1177 +++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.h   |  366 +++++
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  367 +++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |  508 +++++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.h |  199 +++
 .../net/ethernet/marvell/octeon_ep/octep_tx.c |  335 +++++
 .../net/ethernet/marvell/octeon_ep/octep_tx.h |  284 ++++
 21 files changed, 5633 insertions(+)
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


base-commit: f45ba67eb74ab4b775616af731bdf8944afce3f1
-- 
2.17.1

