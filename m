Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E359226E4D
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgGTScz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:32:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22686 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbgGTScz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:32:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIFs9T021896;
        Mon, 20 Jul 2020 11:32:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=oTDLLrL3hqi9BTFlP988QcBboy0VrRE9Qky2KaYBHBY=;
 b=njWkU00/5xAj/RAD99S+3wnh1UQZUXvKttawtxYIoWbbIaZrKCfOPcKcaLX1WEhU+5CA
 a6a9mNuYppPAGNB/bWm6RrXaoEzJiaaaFcXaytm6C20uAgxinhR4U0TPjGz03VIGycUV
 m5yMTLkITmEdFXGOlM+evbDwGiMYUdVgnetSOKADbGsWnZuKE+uCAcW7MhPvmhEvKeo6
 akOwR2jHPcN0yajDz/PXYf5gmWAvR3iwFtO+nr1bwfShbw7iZbqMC9vTsq68t2g6mXZx
 jSHnrR82kE3t/Nu0+Tk20Z7RV0kXRdmUtFcnFYBf0MUbRI8K53/EsxgviMsFNUOrll7J zQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkfb88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:32:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:32:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:32:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:32:49 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 952713F7040;
        Mon, 20 Jul 2020 11:32:47 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 00/13] net: atlantic: various features
Date:   Mon, 20 Jul 2020 21:32:31 +0300
Message-ID: <20200720183244.10029-1-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds more features for Atlantic NICs:
 * media detect;
 * additional per-queue stats;
 * PTP stats;
 * ipv6 support for TCP LSO and UDP GSO;
 * 64-bit operations;
 * A0 ntuple filters;
 * MAC temperature (hwmon).

This work is a joint effort of Marvell developers.

v3:
 * reworked patches related to stats:
   . fixed u64_stats_update_* usage;
   . use simple assignment in _get_stats / _fill_stats_data;
   . made _get_sw_stats / _fill_stats_data return count as return value;
   . split rx and tx per-queue stats;

v2: https://patchwork.ozlabs.org/cover/1329652/
 * removed media detect feature (will be reworked and submitted later);
 * removed irq counter from stats;
 * use u64_stats_update_* to protect 64-bit stats;
 * use io-64-nonatomic-lo-hi.h for readq/writeq fallbacks;

v1: https://patchwork.ozlabs.org/cover/1327894/

Dmitry Bogdanov (2):
  net: atlantic: additional per-queue stats
  net: atlantic: A0 ntuple filters

Igor Russkikh (1):
  net: atlantic: enable ipv6 support for TCP LSO and UDP GSO

Mark Starovoytov (7):
  net: atlantic: move FRAC_PER_NS to aq_hw.h
  net: atlantic: use simple assignment in _get_stats and _get_sw_stats
  net: atlantic: make _get_sw_stats return count as return value
  net: atlantic: split rx and tx per-queue stats
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
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  68 +++++++--
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   7 +
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  |  34 +++--
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |   8 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   6 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  68 ++++++---
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |  27 +++-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  74 +++++++++-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  22 ++-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |  74 +++-------
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |  11 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      | 136 +++++++++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  66 +++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  44 ++++++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  18 +++
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  30 ++++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |   1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   3 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |   1 +
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       |  21 +++
 22 files changed, 608 insertions(+), 183 deletions(-)

-- 
2.25.1

