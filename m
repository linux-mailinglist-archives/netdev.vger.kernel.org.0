Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8221D527
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgGMLmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:42:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15858 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729027AbgGMLmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:42:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBfkdb014165;
        Mon, 13 Jul 2020 04:42:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=M3H4CpVNYtXEo3USGtRejJjTNIyBt07bN+dcl7fwuQA=;
 b=ArLj2OtwiIURsCOy7k9RsVA/uMgubf27KN6HDxvDcUGJng+/fWAFnkElwF68zNyVP37X
 HN2alMi0HGomMldlte0Bz0z52Cq6Te9AlRY1LfiLBqzSyFsvUQ17YSwPlLJGnGFl8+1P
 TQfI5/nwSgipObLb97OGHC8GuxEHrJdmWDUnCOhZb14g0kq/KqnS6B4VBpsOJY+RbaC+
 PibTvoueAv60V29w33wWt6SJ8LKdHtKUojhNbf7Vgz8plKZRp2/W7KT6tcWXEWf0LQ3B
 aNrWUgEmZodUxFKJGNWfrQO6oxDuW8MJa21TuZEvNNzY6+IX2aGi2GQShuVnmDkAV9Hz wg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhgfgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:42:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:42:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:42:43 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id 7FC853F703F;
        Mon, 13 Jul 2020 04:42:41 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 00/10] net: atlantic: various features
Date:   Mon, 13 Jul 2020 14:42:23 +0300
Message-ID: <20200713114233.436-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_10:2020-07-13,2020-07-13 signatures=0
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

Dmitry Bogdanov (2):
  net: atlantic: additional per-queue stats
  net: atlantic: A0 ntuple filters

Igor Russkikh (2):
  net: atlantic: media detect
  net: atlantic: enable ipv6 support for TCP LSO and UDP GSO

Mark Starovoytov (3):
  net: atlantic: move FRAC_PER_NS to aq_hw.h
  net: atlantic: use U32_MAX in aq_hw_utils.c
  net: atlantic: add hwmon getter for MAC temperature

Nikita Danilov (1):
  net: atlantic: use intermediate variable to improve readability a bit

Pavel Belous (2):
  net: atlantic: PTP statistics
  net: atlantic: add support for 64-bit reads/writes

 .../ethernet/aquantia/atlantic/aq_drvinfo.c   |  62 +++++---
 .../ethernet/aquantia/atlantic/aq_drvinfo.h   |  10 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  42 ++++++
 .../ethernet/aquantia/atlantic/aq_ethtool.h   |  10 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  11 ++
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  |  40 ++++--
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |   8 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  64 ++++++++-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   7 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  57 +++++---
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |  25 +++-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   4 +
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  11 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |  48 ++-----
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |  14 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      | 136 +++++++++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  66 +++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  51 ++++++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  25 +++-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  37 ++++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |   1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  22 +++
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |   1 +
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       |  21 +++
 24 files changed, 615 insertions(+), 158 deletions(-)

-- 
2.17.1

