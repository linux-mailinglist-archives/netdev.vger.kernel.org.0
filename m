Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873B71C6B1A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgEFIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:10:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728349AbgEFIJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:09:58 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04682SGi043259;
        Wed, 6 May 2020 04:09:57 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30uf8hq7nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:09:56 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04685U9f017013;
        Wed, 6 May 2020 08:09:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 30s0g5kgq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 08:09:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04689pe9721180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 08:09:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBD67A4065;
        Wed,  6 May 2020 08:09:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97061A405F;
        Wed,  6 May 2020 08:09:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 08:09:51 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 00/10] s390/qeth: updates 2020-05-06
Date:   Wed,  6 May 2020 10:09:39 +0200
Message-Id: <20200506080949.3915-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following patch series for qeth to netdev's net-next
tree.
Same patches as yesterday, except that the ethtool reset has been
dropped for now.

This primarily adds infrastructure to deal with HW offloads when the
packets get forwarded over the adapter's internal switch.
Aside from that, just some minor tweaking for the TX code.

Thanks,
Julian

Julian Wiedmann (10):
  s390/qeth: keep track of LP2LP capability for csum offload
  s390/qeth: process local address events
  s390/qeth: add debugfs file for local IP addresses
  s390/qeth: extract helpers for next-hop lookup
  s390/qeth: don't use restricted offloads for local traffic
  s390/qeth: merge TX skb mapping code
  s390/qeth: indicate contiguous TX buffer elements
  s390/qeth: set TX IRQ marker on last buffer in a group
  s390/qeth: return error when starting a reset fails
  s390/qeth: clean up Kconfig help text

 drivers/s390/net/Kconfig          |   9 +-
 drivers/s390/net/qeth_core.h      |  49 +++-
 drivers/s390/net/qeth_core_main.c | 465 +++++++++++++++++++++++++-----
 drivers/s390/net/qeth_core_mpc.h  |  25 ++
 drivers/s390/net/qeth_core_sys.c  |  15 +-
 drivers/s390/net/qeth_l2_main.c   |   2 +
 drivers/s390/net/qeth_l3_main.c   |  19 +-
 7 files changed, 486 insertions(+), 98 deletions(-)

-- 
2.17.1

