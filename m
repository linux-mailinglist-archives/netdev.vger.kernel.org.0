Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF03E2DC0
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244592AbhHFP0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:26:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240164AbhHFP0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:26:31 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176F2lda091797;
        Fri, 6 Aug 2021 11:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YtfGBiRzxyDqpeYBbrQPcjSHRrdrsGHgwi/p+N0QCsI=;
 b=ZZzrt6v9qv7oPLbYhazp38bEXtuWFGlZGIJ7450KK2piZNdl3QGrWqSyXQ4tQlMPhUoA
 fqtq3nZINObpzDxiOYuwB+gGlp+xSFDUGsxFyY5v9ZdJabXJgNptT4UCJIoEAXD2jx1X
 XLsFJ04b8LMK4fB80qchO3tVNVYaW2rbFG7TuOgts83cxqrU1amjDozsfzHzfmdBjP6r
 N3Mt4O62GTSbh5flEtzY4c+d3FVApav9l5tqIIXpywKfaPzSzkzNPRrxKUUupWZhZZso
 7jxd5PYh7gptbErsF7WFWyQ/U2m7rPeH+RrtZjTF6MNZO+EYn+Z68LCv1G59++BLUg50 kw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8ww8a52s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 11:26:11 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176FMo9e022089;
        Fri, 6 Aug 2021 15:26:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3a4x58uyvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 15:26:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176FN5Ai40304930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 15:23:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 091C7A4068;
        Fri,  6 Aug 2021 15:26:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9109CA4067;
        Fri,  6 Aug 2021 15:26:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 15:26:05 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 0/3] s390/qeth: Add bridge to switchdev LEARNING_SYNC
Date:   Fri,  6 Aug 2021 17:26:00 +0200
Message-Id: <20210806152603.375642-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bRv47BtOMweVQgbMCMBqsmc0wGlIJahF
X-Proofpoint-ORIG-GUID: bRv47BtOMweVQgbMCMBqsmc0wGlIJahF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_05:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 bulkscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108060104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for qeth to netdev's net-next tree.

The netlink bridgeport attribute LEARNING_SYNC can be used to enable
qeth interfaces to report MAC addresses that are reachable via this
qeth interface to the attached software bridge via switchdev
notifiers SWITCHDEV_FDB_ADD_TO_BRIDGE and SWITCHDEV_FDB_DEL_TO_BRIDGE.

Extend this support of LEARNING_SYNC to the bridge to switchdev notifiers
SWITCHDEV_FDB_ADD_TO_DEVICE and SWITCHDEV_FDB_DEL_TO_DEVICE.

Add the capability to sync MAC addresses that are learned by a
north-facing, non-isolated bridgeport of a software bridge to
south-facing, isolated bridgeports. This enables the software bridge to
influence south to north traffic steering in hardware.

Alexandra Winter (3):
  s390/qeth: Register switchdev event handler
  s390/qeth: Switchdev event handler
  s390/qeth: Update MACs of LEARNING_SYNC device

 drivers/s390/net/Kconfig        |   1 +
 drivers/s390/net/qeth_l2_main.c | 239 +++++++++++++++++++++++++++++++-
 2 files changed, 237 insertions(+), 3 deletions(-)

-- 
2.25.1

