Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FD8332C99
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 17:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCIQw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 11:52:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229689AbhCIQwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 11:52:32 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129GZ2iF157804;
        Tue, 9 Mar 2021 11:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/N4K0olEy+pw4RjsN/ikk19cFv7YsMAYQeH/ToO1DTo=;
 b=tdg9wUwsvG3pNOvPehZZ4V5kBzl3CHiN4u5y+K7HnPJ0FlCGRDzUga95N8lJNPIg6ais
 HCDqA1AKg6bGOzwTC8XKYaQs3QgCKqhTIf0A/uk5iv3QYfxeCFsbzh8GWdfqKyRX3iUN
 D8iYCcPpgD1giPJ7Mwlba+vjgq+4bWmy+UFHFA3OZXO0MKw4lo+edQIz3wczWs22cyLD
 68PyUPPATw+TgFP8gR8mFWv48+g8STUH2/cK5mlyUfftChLovPZzcF5AqxIVcfL86Bwq
 HhHwQzmtPtQxaaBghDNWIx1qvxU+X2sfVOJ1vP3U8TGVjGUV428p/XutWWsQPhmw1AiZ tg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375wgvherf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 11:52:29 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129GhRA0001955;
        Tue, 9 Mar 2021 16:52:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3768t4g76h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 16:52:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129Gq92t27066678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 16:52:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 932C05204E;
        Tue,  9 Mar 2021 16:52:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 42E905204F;
        Tue,  9 Mar 2021 16:52:24 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 0/4] s390/qeth: fixes 2021-03-09
Date:   Tue,  9 Mar 2021 17:52:17 +0100
Message-Id: <20210309165221.1735641-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_13:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 mlxlogscore=801
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series to netdev's net tree.

This brings one fix for a memleak in an error path of the setup code.
Also several fixes for dealing with pending TX buffers - two for old
bugs in their completion handling, and one recent regression in a
teardown path.

Thanks,
Julian

Julian Wiedmann (4):
  s390/qeth: fix memory leak after failed TX Buffer allocation
  s390/qeth: improve completion of pending TX buffers
  s390/qeth: schedule TX NAPI on QAOB completion
  s390/qeth: fix notification for pending buffers during teardown

 drivers/s390/net/qeth_core.h      |   3 +-
 drivers/s390/net/qeth_core_main.c | 128 ++++++++++++++----------------
 2 files changed, 62 insertions(+), 69 deletions(-)

-- 
2.25.1

