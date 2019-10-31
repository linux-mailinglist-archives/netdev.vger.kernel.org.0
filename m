Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85169EB083
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 13:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfJaMmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 08:42:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbfJaMmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 08:42:31 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9VCcg8j089869
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:42:30 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vyysng4pu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:42:30 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 31 Oct 2019 12:42:27 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 12:42:25 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9VCgNqZ28573818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 12:42:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A139711C05B;
        Thu, 31 Oct 2019 12:42:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 461C611C050;
        Thu, 31 Oct 2019 12:42:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Oct 2019 12:42:23 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/8] s390/qeth: updates 2019-10-31
Date:   Thu, 31 Oct 2019 13:42:13 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19103112-0028-0000-0000-000003B175FF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103112-0029-0000-0000-00002473BFD2
Message-Id: <20191031124221.34028-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=846 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following series of spooky qeth updates for net-next.

The first two patches add support for an enhanced TX doorbell, which
enables us to do more xmit_more-based bulking.
Note that this requires one patch for the s390/qdio base layer, which
has been graciously acked by Heiko to go through your tree.

The remaining patches are just the usual minor cleanups/improvements.

Thanks,
Julian


Julian Wiedmann (8):
  s390/qdio: implement IQD Multi-Write
  s390/qeth: use IQD Multi-Write
  s390/qeth: use QDIO_BUFNR()
  s390/qeth: keep IRQ disabled until NAPI is really done
  s390/qeth: consolidate some duplicated HW cmd code
  s390/qeth: don't set card state in qeth_qdio_clear_card()
  s390/qeth: use helpers for IP address hashing
  s390/qeth: don't cache MAC addresses for multicast IPs

 drivers/s390/cio/qdio.h           |   1 +
 drivers/s390/cio/qdio_main.c      |  31 +++++----
 drivers/s390/net/qeth_core.h      |   9 +++
 drivers/s390/net/qeth_core_main.c | 108 ++++++++++++++++++++----------
 drivers/s390/net/qeth_core_mpc.h  |   4 +-
 drivers/s390/net/qeth_l2_main.c   |  21 ------
 drivers/s390/net/qeth_l3.h        |  24 ++-----
 drivers/s390/net/qeth_l3_main.c   |  41 ++++--------
 8 files changed, 120 insertions(+), 119 deletions(-)

-- 
2.17.1

