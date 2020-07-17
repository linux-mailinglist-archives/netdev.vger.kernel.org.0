Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AF02242BC
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgGQSCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:02:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52952 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbgGQSCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:02:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HHw42u010563;
        Fri, 17 Jul 2020 11:02:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=ogSuBGYi+u47nbiXlf4DsRkCC38ZzT0iyKLh55Qc6t4=;
 b=jChLjwChfLHkXwG/boCV/44u9iiUp9barFLDYG/xXcdG1R7KMALHJSg/bfjCiC8f2Nhb
 aSneVThcmybdzrdBhc/hygJzSQ1TMbhNmNlHlWXzwrtWHuvcuX7LNjJWSoNLQcW6EuLd
 ytwRDVZX7cNdzcPSzoozQ8+6U0MQAGU1MOl4PGsiCWgLm/u1ymEyFIABfbku2me7bl3v
 JcxkosvVdlBwrWc3zO4uvr8RO422QWYNO1Nm+pYHN34ls1/JJq0qtZV3Ui2YRlx0Jl0f
 TJZsz6Ys9a3+BTNj9gtpQC/Vp/4yaGQtAHjrtUv2Fu2ibtLFKLoyXpvlCycyklDOfwXf 1g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmj5hgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 11:02:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 11:02:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 11:02:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jul 2020 11:02:03 -0700
Received: from NN-LT0044.marvell.com (unknown [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 042F93F7041;
        Fri, 17 Jul 2020 11:02:00 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH net-next 0/2] net: atlantic: add support for FW 4.x
Date:   Fri, 17 Jul 2020 21:01:45 +0300
Message-ID: <20200717180147.8854-1-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_09:2020-07-17,2020-07-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for FW 4.x, which is about to get into the
production for some products.
4.x is mostly compatible with 3.x, save for soft reset, which requires
the acquisition of 2 additional semaphores.
Other differences (e.g. absence of PTP support) are handled via
capabilities.

Note: 4.x targets specific products only. 3.x is still the main firmware
branch, which should be used by most users (at least for now).

Dmitry Bogdanov (1):
  net: atlantic: add support for FW 4.x

Mark Starovoytov (1):
  net: atlantic: align return value of ver_match function with function
    name

 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     | 17 +++++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     | 10 +++-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 11 +++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 58 +++++++++++++------
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  2 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.c |  3 +-
 6 files changed, 70 insertions(+), 31 deletions(-)

-- 
2.25.1

