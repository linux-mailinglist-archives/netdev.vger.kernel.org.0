Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F133F2211A0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGOPtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:49:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13480 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727029AbgGOPtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:49:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FFf2Gp032725;
        Wed, 15 Jul 2020 08:49:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=BEQtvxb/pzCDehlEooibEjd1GLtLr2kvF/62GSS4rAw=;
 b=KZXiIwbq/sO5pAVqsX0kT+3eCQvg5dW2JjZPAtgiL9pe2g2Rhl4IdlGqov1DvZr3LLTb
 ndGGJnjhfN+qePyEEFPS8DlcXhmaJGXIfZFRa1xFAeansAVNm7As8LF/n2WL3CdVwOSC
 HdnyNrViJq1Fz2S3v9rJZi1UiVpf/omdiCUfWIfNrxLuX8w+2agN3vMsRCEMOlKD3jzp
 bWz3kM8U9sCcZ6cSFWx3Dvw7RLEBdF/iLINSV5fBL1v1ZCYupipOx5E5/6c77/OnoJvs
 /MAueCUs8OlQxqW8X15ECMKQVfhIJEIp0pftezNpxetMH3xJH1yZPn3vN0YzCX8aQYL4 5w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asnja51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 08:49:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:48:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:48:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 08:48:58 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 78B513F7040;
        Wed, 15 Jul 2020 08:48:56 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 net-next 00/10] net: atlantic: various features
Date:   Wed, 15 Jul 2020 18:48:32 +0300
Message-ID: <20200715154842.305-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patchset adds more features for Atlantic NICs:
 * media detect;
 * additional per-queue stats;
 * PTP stats;
 * ipv6 support for TCP LSO and UDP GSO;
 * 64-bit operations;
 * A0 ntuple filters;
 * MAC temperature (hwmon).

This work is a joint effort of Marvell developers.

v2:
 * removed media detect feature (will be reworked and submitted later);
 * removed irq counter from stats;
 * use u64_stats_update_* to protect 64-bit stats;
 * use io-64-nonatomic-lo-hi.h for readq/writeq fallbacks.

v1: https://patchwork.ozlabs.org/cover/1327894/

Dmitry Bogdanov (2):
  net: atlantic: additional per-queue stats
  net: atlantic: A0 ntuple filters

Igor Russkikh (1):
  net: atlantic: enable ipv6 support for TCP LSO and UDP GSO

Mark Starovoytov (4):
  net: atlantic: move FRAC_PER_NS to aq_hw.h
  net: atlantic: use u64_stats_update_* to protect access to 64-bit
    stats
  net: atlantic: use U32_MAX in aq_hw_utils.c
  net: atlantic: add hwmon getter for MAC temperature

Nikita Danilov (1):
  net: atlantic: use intermediate variable to improve readability a bit

Pavel Belous (2):
  net: atlantic: PTP statistics
  net: atlantic: add support for 64-bit reads/writes

 .../ethernet/aquantia/atlantic/aq_drvinfo.c   |  62 +++++---
 .../ethernet/aquantia/atlantic/aq_drvinfo.h   |  10 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  34 +++++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   7 +
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  |  34 +++--
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |   8 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  44 +++++-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   6 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  57 +++++---
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |  25 +++-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  30 ++++
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  11 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 108 +++++++-------
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |  14 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      | 136 +++++++++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  66 +++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  51 ++++++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  25 +++-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  37 ++++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |   1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   1 +
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |   1 +
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       |  21 +++
 23 files changed, 619 insertions(+), 170 deletions(-)

-- 
2.25.1

