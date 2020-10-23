Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070A9297742
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755073AbgJWSso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:48:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55674 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S462940AbgJWSsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:48:43 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09NIXipl180590;
        Fri, 23 Oct 2020 14:48:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=1v/WrBEV1NPAZPFzy8nLXiCTuTfriFWMg7cw1JhR1Ig=;
 b=U2vp5s7jh9C60ZRT0AZgLfuLEeVRa4rKEx17no3jd/6uBSK3AOBT45Vu9KTnQQV/Suw2
 kR8s7h4lOBuWl7MigVZHZTEQiYg+717+UAURaK6zix3eqWpR9rWt3vx6S4SX89qFL44H
 ageJ3XqJV9KIFbHbRYsyianO0hPhVtAJVCsLREx2YiGJVhU+38CvuouSKWlS//D+syMZ
 ic79y07hoa+rzHpG0Bl6mp/xCxg7jp84szeLlfl0uci7sjk2mA6Pq4MBHlh1qKzHYur3
 Gruqjk7jSq91G9VSbHqpiH6q48gM/qxgJTSfZ9WwYjopJuL+dsk26LtDZFGhQ6uihWMP TA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34bh716aeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 14:48:41 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09NIZhkT001371;
        Fri, 23 Oct 2020 18:48:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 347r87ukn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 18:48:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09NImaEA26542492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 18:48:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CE3C42045;
        Fri, 23 Oct 2020 18:48:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E865242041;
        Fri, 23 Oct 2020 18:48:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Oct 2020 18:48:35 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 0/3] net/smc: fixes 2020-10-23
Date:   Fri, 23 Oct 2020 20:48:27 +0200
Message-Id: <20201023184830.59548-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_12:2020-10-23,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=1
 mlxlogscore=424 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 bulkscore=1 suspectscore=1 phishscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net tree.

Patch 1 fixes a potential null pointer dereference. Patch 2 takes care
of a suppressed return code and patch 3 corrects the system EID in the
ISM driver.

Karsten Graul (3):
  net/smc: fix null pointer dereference in smc_listen_decline()
  net/smc: fix suppressed return code
  s390/ism: fix incorrect system EID

 drivers/s390/net/ism_drv.c | 2 +-
 net/smc/af_smc.c           | 7 ++++---
 net/smc/smc_core.c         | 7 +++++--
 3 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.17.1

