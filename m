Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5471125B23E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgIBQ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:58:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52378 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726938AbgIBQ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:58:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GuBAp018081;
        Wed, 2 Sep 2020 09:58:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=mykFwg/X/3tyhxJTHKrhiFBinOiXbG3pVXiENvUkVgk=;
 b=cWc5Lk0n/n1WGLPCFU0A9TWpn7/qUwVoW/bqSkpwsq3/zwM97LXwtO9oTF2faU1MqMiM
 YvjCSASM+1OxeK9v0mj/OzzKs54G3a0MUOJQ+1zhQf4qIrWd/JiMbU2yTBrSks+M0SnJ
 C2L2NEFY67BZsQ3mYZegeav4p/bmtGN882iq7czcIOt6ybVwPL7F4FYU+fvPZ8qoggo5
 oWQWLAGQYncTjqKtF9285kUv78ybFuXOeHJQle+x0Hva4mxGu6NFNqMq8bSmMahugQk1
 +CITWuUohX9dN+gI++rntYrWlMC439pFlqwmjxDlEsVoS0Db+nMlxe6avf2SyYedZ7PH LQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqgbey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:07 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 2AFF53F703F;
        Wed,  2 Sep 2020 09:58:04 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 0/8] RDMA/qedr: various fixes
Date:   Wed, 2 Sep 2020 19:57:33 +0300
Message-ID: <20200902165741.8355-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_11:2020-09-02,2020-09-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set addresses several issues that were observed
and reproduced on different test and production configurations.

Dave, Jason,
There is one qede patch which is related to the mtu change notify.
This is a small change and required for the qede_rdma.h interface
change. Please consider applying this to rdma tree.

thanks,
Michal

Michal Kalderon (8):
  RDMA/qedr: Fix qp structure memory leak
  RDMA/qedr: Fix doorbell setting
  RDMA/qedr: Fix use of uninitialized field
  RDMA/qedr: Fix return code if accept is called on a destroyed qp
  qede: Notify qedr when mtu has changed
  RDMA/qedr: Fix iWARP active mtu display
  RDMA/qedr: Fix inline size returned for iWARP
  RDMA/qedr: Fix function prototype parameters alignment

 drivers/infiniband/hw/qedr/main.c               |  9 ++++++++-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c         |  6 ++++--
 drivers/infiniband/hw/qedr/verbs.c              | 13 ++++++++-----
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c |  4 +++-
 drivers/net/ethernet/qlogic/qede/qede_rdma.c    | 17 +++++++++++++++++
 include/linux/qed/qede_rdma.h                   |  4 +++-
 6 files changed, 43 insertions(+), 10 deletions(-)

-- 
2.14.5

