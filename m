Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01DF1BF1FD
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgD3IFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58858 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726420AbgD3IFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U853gf011063;
        Thu, 30 Apr 2020 01:05:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=D85lbHpiv/YA4QwNToNzgozCwDid9NuFN1Ui9kHAtvQ=;
 b=egIeJe+XvGSVS+HW9KPGGKlhakyxnMQDGxBFv0m+XzUqtX3xK+Eom058o8Jder5yFcWO
 +bLui5y1zthehmelXrLc1mss2FSM4A5mixWK5UryQlDQSlY11+DBtcssEPRRh/sg/Gvv
 ncwzjJ+Tcn3wi1ct6Q+pffPIxIibRmmLZTUFk451ylNl0BP2P7NTh/mhOOx0KW3hivwL
 zHNOuvziu454S9l0pyzSreHzpivf6mrKlKa+VAehMpxU74sK81mf5mTBWzfdB39ymhZx
 wLdiBSX3QZRlpSIzbvcxiNoRptYDGwyZEEzZ57G6VgFJdYHyVOrEpfF2V/M6Yd9f9VK7 zw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnshd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:03 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 17BC13F7040;
        Thu, 30 Apr 2020 01:05:00 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 00/17] net: atlantic: A2 support
Date:   Thu, 30 Apr 2020 11:04:28 +0300
Message-ID: <20200430080445.1142-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for the new generation of Atlantic NICs.

Chip generations are mostly compatible register-wise, but there are still
some differences. Therefore we've made some of first generation (A1) code
non-static to re-use it where possible.

Some pieces are A2 specific, in which case we redefine/extend such APIs.

v2:
 * removed #pragma pack (2 structures require the packed attribute);
 * use defines instead of magic numbers where possible;

v1: https://patchwork.ozlabs.org/cover/1276220/

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
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 684 ++++++++++++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2.h       |  14 +
 .../atlantic/hw_atl2/hw_atl2_internal.h       | 137 ++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   | 208 ++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |  91 +++
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   | 328 +++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.c | 139 ++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h | 606 ++++++++++++++++
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 341 +++++++++
 23 files changed, 2798 insertions(+), 121 deletions(-)
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
2.20.1

