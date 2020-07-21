Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0E222826E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgGUOmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:42:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727023AbgGUOmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:42:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LEe7Cv010662;
        Tue, 21 Jul 2020 07:41:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=RR/WjJHTZOCrJW4kTke0PKGgT4VEae2S+Js8QX/vCtM=;
 b=JELxNL7SXMs3wAPBVmCk8pmkYVzIp7clkJEU4gLnl5T5Nnyw6QTYJ7RXoEf+VUHMtMdK
 UxO1mqFXQthk9KQSnNzhdBpmK8yED22Y/bkB4SIWj2XuqIdduEr+bsQCMCIzF+IUQkwl
 Ioeo63igpnpQCJ4fEiWv3maPkd8omYhqIZ6luefvhuB9Ci/cjm6dtLqun0WQKrQ+mMgx
 31gUQitjCZf3AVz6kCDJ/nGIplcA6s0QkYNiFLtPSj+1TMQl0KHLKno8C5oRqDKV5rp/
 eT/uS45LK0QesfbuU0wH4RZJUtQllC+qSz94aBY62SPeKAsJXGcPD0CJqZhCn0W9txgX sg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkk787-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 07:41:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 07:41:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 07:41:55 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 0C3423F703F;
        Tue, 21 Jul 2020 07:41:51 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Tomer Tayar" <tomer.tayar@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/2] qed: suppress irrelevant error messages on HW init
Date:   Tue, 21 Jul 2020 17:41:41 +0300
Message-ID: <20200721144143.379-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_09:2020-07-21,2020-07-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This raises the verbosity level of several error/warning messages on
driver/module initialization, most of which are false-positives, and
the one actively spamming the log for no reason.

Alexander Lobakin (2):
  qed: suppress "don't support RoCE & iWARP" flooding on HW init
  qed: suppress false-positives interrupt error messages on HW init

 drivers/net/ethernet/qlogic/qed/qed_cxt.c |  4 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c | 50 +++++++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_int.h |  4 +-
 4 files changed, 34 insertions(+), 26 deletions(-)

-- 
2.25.1

