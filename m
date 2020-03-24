Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25D41912BB
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgCXOTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:19:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58136 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgCXOTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:19:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OEAdbq017435;
        Tue, 24 Mar 2020 07:19:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=IAFOWS/f34ZmiZn9WLhUx1qSwq7gkLKBe/LgGfvFQXA=;
 b=PsMQLp6cvZTJSzIR+YWe05voU2YmytFRpXtY55zoofItM8slzwFqSCTajl0Cojr2IDIZ
 q1kl9PxbQtVErqSVN9IeafpOlVaBFKpsPPCfD57wltfRl28vtm6nTNW2CoW+qbDdJZ9j
 +/1OSBtTIzjj+B711A16OUyzrhy1Ad1S5exJN6ptv8E1kb2c/Gmmels06tvCDIjdbsCC
 /mNmaZZhXX4G32o7kO/oG5ceWmxQgk0KVHNFjyH331HOoyfGD84K68J0AV4bLQsnhH7P
 qKJoZ5Z/+2Qx4lqQ37be2/PyHudNHhXwa5Q0y5+/SV0a9jDMDvzjALKHyX4vvMC3CG7R 2A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqsq0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 07:19:32 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 07:19:30 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Mar 2020 07:19:30 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id DD82E3F703F;
        Tue, 24 Mar 2020 07:19:29 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/3] qed: Fix and enhance slowpath workqueue mechanism.
Date:   Tue, 24 Mar 2020 16:13:45 +0200
Message-ID: <20200324141348.7897-1-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The next patch series enhances slowpath workqueue mechanism and fixes
a race between scheduled tasks and destroy_workqueue.

Yuval Basson (3):
  qed: Replace wq_active Boolean with an atomic QED_SLOWPATH_ACTIVE flag
  qed: Add a flag for rescheduling the slowpath task
  qed: Fix race condition between scheduling and destroying the slowpath
    workqueue

 drivers/net/ethernet/qlogic/qed/qed.h      |  3 ++-
 drivers/net/ethernet/qlogic/qed/qed_main.c | 37 +++++++++++++-----------------
 2 files changed, 18 insertions(+), 22 deletions(-)

-- 
1.8.3.1

