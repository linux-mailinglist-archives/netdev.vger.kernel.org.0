Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD9C4135A6
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 16:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhIUOx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 10:53:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19448 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233759AbhIUOx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 10:53:57 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LEiaOJ023308;
        Tue, 21 Sep 2021 10:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/inWloo3KMEInsk2lG3CJ7Yo4z3jULf4AXDwwfskk/w=;
 b=m5f03ae4t68kZMdd1NIj3a7klhTTgBu3eBXKgZTXaLswPv43Aj7AMcSO0f0+hTT+P/2Y
 b66fkuPUFlM6ax7BN9aoimgyR0K3GRwknsoJa+w09bzAKQkw2td+DFhMCCbVdJHYtxyO
 wXPqUQ1yRg5cEV08XhCsVYQj4YHNWDx70W1h1edH+2AOmlTu4pLZwKyQqrjJyBvV0T3/
 jiFGVKYHLqIndpArhVu3WhBf1Af6EEE+M8usnd4SXVeuTzzDdiWPuZgtntTSrYmvPj7J
 yW+XvpfP9O5kj4n0IMaWf1zE/Wgo/DqczZdwKf3HtkcRDKLkVE54aCik3aUgQvOY5Um9 Yw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7f69cmfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 10:52:25 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LEnHXd008101;
        Tue, 21 Sep 2021 14:52:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3b57r9ddhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 14:52:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LElVmf55181744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 14:47:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B47BD52050;
        Tue, 21 Sep 2021 14:52:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 598A352063;
        Tue, 21 Sep 2021 14:52:18 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net 0/3] s390/qeth: fixes 2021-09-21
Date:   Tue, 21 Sep 2021 16:52:14 +0200
Message-Id: <20210921145217.1584654-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0wrBOi6d2jtmnbZRGsCfUrKn3GREkzRP
X-Proofpoint-ORIG-GUID: 0wrBOi6d2jtmnbZRGsCfUrKn3GREkzRP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_04,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxlogscore=661 clxscore=1011 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net tree.

This brings two fixes for deadlocks when a device is removed while it
has certain types of async work pending. And one additional fix for a
missing NULL check in an error case.

Thanks,
Julian

Alexandra Winter (2):
  s390/qeth: Fix deadlock in remove_discipline
  s390/qeth: fix deadlock during failing recovery

Julian Wiedmann (1):
  s390/qeth: fix NULL deref in qeth_clear_working_pool_list()

 arch/s390/include/asm/ccwgroup.h  |  2 +-
 drivers/s390/cio/ccwgroup.c       | 10 ++++++++--
 drivers/s390/net/qeth_core.h      |  1 -
 drivers/s390/net/qeth_core_main.c | 22 +++++++++-------------
 drivers/s390/net/qeth_l2_main.c   |  1 -
 drivers/s390/net/qeth_l3_main.c   |  1 -
 6 files changed, 18 insertions(+), 19 deletions(-)

-- 
2.25.1

