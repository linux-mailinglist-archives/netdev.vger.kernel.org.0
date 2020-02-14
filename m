Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0E515DB4C
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgBNPpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:45:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60018 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728859AbgBNPpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:45:12 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EFj7u0005985;
        Fri, 14 Feb 2020 07:45:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=ab17s+Wqtwe48zvVRYsvRRXRWxrcbEt0oLeOeS4WxD8=;
 b=YyK/e57Xs8r6Ddlt+qe/UQGub5vFNewz2D/3CmFqktZ0hpu7x/kuYJ7phgCsIgSkV4yv
 FXlibOcqcTTZ85uUtcUtHKORxoi40zPR1Mqokl7OPJlKjrXp+p6bQdGiBv1tcd8/p9KY
 awVRjhs0lNZh56jE9hrgFWRKt0svepTk7J8rE6/1dEU0WVXp3I9/M1RETrixz4ahljAR
 armIj6Zu8zzsVW6GNsuoTh5nzgTqL8Tszv0LB+I62uDEeu3N7D9WQOs+JrSGiJSoSeVJ
 HhLgmxx43H3Xf5ZggkLYOV9HK6YVRAzV3pTdwHRD78i2IrYriE9aOpyNcPusjcpdxVMD Ug== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5k3pag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:45:10 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:09 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:08 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:45:08 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 78F803F703F;
        Fri, 14 Feb 2020 07:45:06 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dbogdanov@marvell.com>, <pbelous@marvell.com>,
        <ndanilov@marvell.com>, <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 0/8] Marvell atlantic 2020/02 updates
Date:   Fri, 14 Feb 2020 18:44:50 +0300
Message-ID: <cover.1580299250.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, here is another set of bugfixes on AQC family found on
last integration phase.

Dmitry Bezrukov (1):
  net: atlantic: checksum compat issue

Dmitry Bogdanov (2):
  net: atlantic: check rpc result and wait for rpc address
  net: atlantic: fix out of range usage of active_vlans array

Egor Pomozov (1):
  net: atlantic: ptp gpio adjustments

Nikita Danilov (1):
  net: atlantic: better loopback mode handling

Pavel Belous (3):
  net: atlantic: fix use after free kasan warn
  net: atlantic: fix potential error handling
  net: atlantic: possible fault in transition to hibernation

 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  5 +++++
 .../ethernet/aquantia/atlantic/aq_filters.c   |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  2 ++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  8 +++----
 .../ethernet/aquantia/atlantic/aq_pci_func.c  | 13 ++++++-----
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 10 ++++++---
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  3 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 22 ++++++++++++-------
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 19 ++++++++++++++--
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 12 ++++++++++
 10 files changed, 71 insertions(+), 25 deletions(-)

-- 
2.17.1

