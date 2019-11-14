Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D30FC3E7
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKNKTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726979AbfKNKTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:45 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAIfE8112663
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:44 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91m7ejt5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:42 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:31 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:29 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAJSkb30736468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:19:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48A80A4040;
        Thu, 14 Nov 2019 10:19:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BE3FA4053;
        Thu, 14 Nov 2019 10:19:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 10:19:27 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 00/11] s390/qeth: updates 2019-11-14
Date:   Thu, 14 Nov 2019 11:19:13 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19111410-0008-0000-0000-0000032EF01F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0009-0000-0000-00004A4DFDFB
Message-Id: <20191114101924.29558-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=753 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following qeth patches to net-next.
Along with the usual cleanups, this
(1) reduces collateral packet loss in the RX path when dealing with
    bad packets and/or allocation errors, and
(2) simplifies how the L3 driver deals with mcast IP addresses.

Thanks,
Julian


Julian Wiedmann (11):
  s390/qeth: gather more detailed RX dropped/error statistics
  s390/qeth: support per-frame invalidation
  s390/qeth: drop unwanted packets earlier in RX path
  s390/qeth: handle skb allocation error gracefully
  s390/qeth: clean up error path in qeth_core_probe_device()
  s390/qeth: fine-tune L3 mcast locking
  s390/qeth: remove gratuitious RX modeset
  s390/qeth: consolidate L3 mcast registration code
  s390/qeth: remove VLAN tracking for L3 devices
  s390/qeth: replace qeth_l3_get_addr_buffer()
  s390/qeth: don't check drvdata in sysfs code

 drivers/s390/net/qeth_core.h      |  10 +-
 drivers/s390/net/qeth_core_main.c |  82 +++++++----
 drivers/s390/net/qeth_core_mpc.h  |   1 +
 drivers/s390/net/qeth_core_sys.c  |  80 +----------
 drivers/s390/net/qeth_ethtool.c   |   2 +
 drivers/s390/net/qeth_l2_main.c   |  26 ++--
 drivers/s390/net/qeth_l2_sys.c    |  29 ----
 drivers/s390/net/qeth_l3.h        |   1 +
 drivers/s390/net/qeth_l3_main.c   | 226 ++++++++----------------------
 drivers/s390/net/qeth_l3_sys.c    |  94 -------------
 10 files changed, 139 insertions(+), 412 deletions(-)

-- 
2.17.1

