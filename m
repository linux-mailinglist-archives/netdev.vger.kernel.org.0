Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E9234187
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfFDIPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:15:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726788AbfFDIPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 04:15:23 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x548D64L047349
        for <netdev@vger.kernel.org>; Tue, 4 Jun 2019 04:15:22 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2swkqk3jjb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 04:15:21 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 4 Jun 2019 09:15:20 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Jun 2019 09:15:18 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x548FHB854657038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jun 2019 08:15:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5FC042056;
        Tue,  4 Jun 2019 08:15:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CED34205F;
        Tue,  4 Jun 2019 08:15:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jun 2019 08:15:16 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net 0/4] s390/qeth: fixes 2019-06-04
Date:   Tue,  4 Jun 2019 10:15:05 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19060408-0012-0000-0000-00000322E70F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060408-0013-0000-0000-0000215BC4BB
Message-Id: <20190604081509.56160-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040056
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

same patch series as yesterday, except that patch 2 has been adjusted
as per your review to use dst_check(). Please have another look.


From the v1 cover letter:

Please apply the following set of qeth fixes to -net.

- The first two patches fix issues in the L3 driver's cast type
  selection for transmitted skbs.
- Alexandra adds a sanity check when retrieving VLAN information from
  neighbour address events.
- The last patch adds some missing error handling for qeth's new
  multiqueue code.

Thanks,
Julian


Alexandra Winter (1):
  s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Julian Wiedmann (3):
  s390/qeth: handle limited IPv4 broadcast in L3 TX path
  s390/qeth: check dst entry before use
  s390/qeth: handle error when updating TX queue count

 drivers/s390/net/qeth_core_main.c | 22 ++++++++++++++++------
 drivers/s390/net/qeth_l2_main.c   |  2 +-
 drivers/s390/net/qeth_l3_main.c   | 20 +++++++++++++++++---
 3 files changed, 34 insertions(+), 10 deletions(-)

-- 
2.17.1

