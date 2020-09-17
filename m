Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C5826E6F3
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgIQUxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:53:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23774 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgIQUxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:53:48 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 16:53:47 EDT
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HKcZIA086883;
        Thu, 17 Sep 2020 16:46:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=f5MrYuEAArr+pTJJxDVZRrN92SIcpamNhH9WHLp0GHM=;
 b=SQjnEl0k0Uq1xvlShW1Z29XqVZrdg8a4OpqYSSEhPaUJ0/5tK0x1mnw4wvMY/joyGI4W
 IrHMJEdCbgClvt1qxwJ5OWVMoTK42NJne1W/IGdo/b6DTWxr5uIL5Tfq/3A8BnLExrDS
 OBhX3YE9Rg2sb7MG1ok61pKIj0VK7ovL75spwGcifJAHE0sWElg/LhgrfLIQUuYHsDWv
 EUmsrgXu0cmY3U7j1XiaA9OhxniGcnPkl20r+ixNmCZe2a9eoLQr0DroBrmvW4wmRuFe
 ftO9KwCPcBmsR/rBySLMsO7riJKWcgk6qts39bfhMI2WWztCACUQu1lw7Xr+IAgkmtQ+ 8g== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33mdec2euf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 16:46:19 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HKg7kp031024;
        Thu, 17 Sep 2020 20:46:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 33k65v192q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 20:46:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HKkCX524641930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 20:46:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E40711C050;
        Thu, 17 Sep 2020 20:46:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E047711C04C;
        Thu, 17 Sep 2020 20:46:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 20:46:11 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 0/1] net/smc: fix 2020-09-17
Date:   Thu, 17 Sep 2020 22:46:01 +0200
Message-Id: <20200917204602.14586-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_17:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=727 impostorscore=0 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch for smc to netdev's net-next tree.

The patch fixes a problem reported by Dan. Because the fixed patch is
still only in net-next tree I am sending this fix to net-next.

Ursula Braun (1):
  net/smc: fix double kfree in smc_listen_work()

 net/smc/af_smc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.17.1

