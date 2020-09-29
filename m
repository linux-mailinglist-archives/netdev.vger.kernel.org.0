Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E272B27D363
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgI2QNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 12:13:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15870 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728807AbgI2QNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 12:13:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TG4VsF027105;
        Tue, 29 Sep 2020 09:13:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=7YVSgKtYxuWDF9odsn5YvvKeolepZeV1lgUwOcgEsNs=;
 b=Mp2NgWTthkcny0+xiRsi+PzDE8Ktq44oyTiim9tZ3J/p5W5jcOa9rmsWw0vxpPyBFSZG
 DPz8jq4oS3rTs2o5Ww4Gqr9+sd+/yjIApy3sfAtzlKriVo5LZj3JF6VyN64OEIU6OXQM
 9G4eKUOMDsEZa9/7l8Vn15XLnbCVGh6lIsjiVFBqZQwHFlFpklZLdyAWDkZL/lPzjvB+
 L7EWf2VnsFf2Z2BTe2pDCYeTC8hZ5q7K9ozeGQvxI56BNyl/Of0RbxdFTnJ6s9ygopbo
 e4Eo2UXaNwGXxz4eBB7tFNqeqNxOd9vnuYYmN3yeef9fgriUCDkztm/ID8gPGac2grA6 bA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55p6rhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:13:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 09:13:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 09:13:15 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id 0622D3F704B;
        Tue, 29 Sep 2020 09:13:13 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 0/3] net: atlantic: phy tunables from mac driver
Date:   Tue, 29 Sep 2020 19:13:04 +0300
Message-ID: <20200929161307.542-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_10:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements phy tunables settings via MAC driver callbacks.

AQC 10G devices use integrated MAC+PHY solution, where PHY is fully controlled
by MAC firmware. Therefore, it is not possible to implement separate phy driver
for these.

We use ethtool ops callbacks to implement downshift and EDPC tunables.

Igor Russkikh (3):
  ethtool: allow netdev driver to define phy tunables
  net: atlantic: implement phy downshift feature
  net: atlantic: implement media detect feature via phy tunables

 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 56 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  4 ++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 40 +++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  4 ++
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 37 ++++++++++++
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 13 +++++
 include/linux/ethtool.h                       |  4 ++
 net/ethtool/ioctl.c                           | 37 +++++++-----
 8 files changed, 182 insertions(+), 13 deletions(-)

-- 
2.17.1

