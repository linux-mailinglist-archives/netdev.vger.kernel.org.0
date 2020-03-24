Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC07D191907
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgCXSZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:25:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20830 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727672AbgCXSZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:25:26 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OI5nV9168017
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:24 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yynky4mhd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:13 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 24 Mar 2020 18:24:59 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 18:24:56 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OIOslg17039456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 18:24:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4A0AA4064;
        Tue, 24 Mar 2020 18:24:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D285A405C;
        Tue, 24 Mar 2020 18:24:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 18:24:54 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 00/11] s390/qeth: updates 2020-03-24
Date:   Tue, 24 Mar 2020 19:24:37 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20032418-0028-0000-0000-000003EABA12
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032418-0029-0000-0000-000024B024E5
Message-Id: <20200324182448.95362-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=772
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003240090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following patch series for qeth to netdev's net-next
tree.

This adds
1) NAPI poll support for the async-Completion Queue (with one qdio layer
   patch acked by Heiko),
2) ethtool support for per-queue TX IRQ coalescing,
3) various cleanups.

Thanks,
Julian

Julian Wiedmann (11):
  s390/qeth: simplify RX buffer tracking
  s390/qeth: split out RX poll code
  s390/qeth: remove redundant if-clause in RX poll code
  s390/qdio: extend polling support to multiple queues
  s390/qeth: simplify L3 dev_id logic
  s390/qeth: clean up the mac_bits
  s390/qeth: collect more TX statistics
  s390/qeth: add TX IRQ coalescing support for IQD devices
  s390/qeth: fine-tune MAC Address-related errnos
  s390/qeth: keep track of fixed prio-queue configuration
  s390/qeth: modernize two list helpers

 arch/s390/include/asm/qdio.h      |  11 +-
 drivers/s390/cio/qdio.h           |  11 +-
 drivers/s390/cio/qdio_debug.c     |   4 +-
 drivers/s390/cio/qdio_main.c      |  50 +++----
 drivers/s390/cio/qdio_setup.c     |  16 +--
 drivers/s390/cio/qdio_thinint.c   |  38 +++--
 drivers/s390/net/qeth_core.h      |  28 ++--
 drivers/s390/net/qeth_core_main.c | 224 ++++++++++++++++--------------
 drivers/s390/net/qeth_core_sys.c  |   8 +-
 drivers/s390/net/qeth_ethtool.c   |  76 ++++++++++
 drivers/s390/net/qeth_l2_main.c   |  23 +--
 drivers/s390/net/qeth_l3_main.c   |  30 ++--
 12 files changed, 299 insertions(+), 220 deletions(-)

-- 
2.17.1

