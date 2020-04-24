Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411221B6EF8
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgDXH1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:27:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37782 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgDXH1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:27:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7QKUr021188;
        Fri, 24 Apr 2020 00:27:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=LcKsnJrz9aSWeuSkf/cYho/Sotg6iZB5cqbJcljCr6Y=;
 b=NndA9dxXwWAWNv9i8+8rORLcrMGwyk3y98bO0YEK8nax3WacPoJEBBNY1oIT5BiyWb21
 iovp+vdOGYn/dXoz1DOKyjRa22mBtzUNaRDhBstrMcgES1SjqEx10mxklcyILSkz7pq7
 2ciRc7CBb2cCyndYpuQqBnhp+XmhrIh+uzAEn8D8C1Co8mMY6/1bSwE4hsTOsliqVWx3
 lVmaQOdHkD/DBzWflmafsA0svkgRQMF6aSq4IDOnA//dSPxsJATtPEWqR8PH+Kr7MU8N
 MCDAVVSXl30GJe+xDWEEjzg4qARIbeloC4hdmDrx1jfaekdhkfhUHhWxUsK/KdsZOMh4 Gw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb46a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:27:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:27:41 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 335263F703F;
        Fri, 24 Apr 2020 00:27:39 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 00/17] net: atlantic: A2 support
Date:   Fri, 24 Apr 2020 10:27:12 +0300
Message-ID: <20200424072729.953-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for the new generation of Atlantic NICs.

Chip generations are mostly compatible register-wise, but there are still
some differences. Therefore we've made some of first generation (A1) code
non-static to re-use it where possible.

Some pieces are A2 specific, in which case we redefine/extend such APIs.

Dmitry Bogdanov (5):
  net: atlantic: A2 driver-firmware interface
  net: atlantic: minimal A2 HW bindings required for fw_ops
  net: atlantic: minimal A2 fw_ops
  net: atlantic: HW bindings for basic A2 init/deinit hw_ops
  net: atlantic: common functions needed for basic A2 init/deinit hw_ops

Igor Russkikh (8):
  net: atlantic: update company name in the driver description
  net: atlantic: add A2 device IDs
  net: atlantic: add defines for 10M and EEE 100M link mode
  net: atlantic: A2 hw_ops skeleton
  net: atlantic: HW bindings for A2 RFP
  net: atlantic: add A2 RPF hw_ops
  net: atlantic: basic A2 init/deinit hw_ops
  net: atlantic: A2 ingress / egress hw configuration

Mark Starovoytov (3):
  net: atlantic: add hw_soft_reset, hw_prepare to hw_ops
  net: atlantic: make hw_get_regs optional
  net: atlantic: move IS_CHIP_FEATURE to aq_hw.h

Nikita Danilov (1):
  net: atlantic: simplify hw_get_fw_version() usage

 .../net/ethernet/aquantia/atlantic/Makefile   |   4 +
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   4 +-
 .../ethernet/aquantia/atlantic/aq_common.h    |  33 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   3 +
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  22 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  43 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |  39 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |   4 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  86 +--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  37 +
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  18 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  10 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  51 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  17 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 683 ++++++++++++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2.h       |  14 +
 .../atlantic/hw_atl2/hw_atl2_internal.h       | 110 +++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   | 208 ++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |  91 +++
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   | 328 +++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.c | 139 ++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h | 544 ++++++++++++++
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 341 +++++++++
 23 files changed, 2708 insertions(+), 121 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c

-- 
2.17.1

