Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8949925C9BC
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgICTxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:53:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbgICTxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:53:38 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083JWrWm175416;
        Thu, 3 Sep 2020 15:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=Vawr6Kbzn9YQRfu6yuG6CW4F5w8gbhcjbJo8CPUElRc=;
 b=OKlT2txqIIWXQFAgdpq1d/VKfWhzk/FQVLYKbMqQW6Q0ECavQ+MrnQNYGnJD4OgTg9cF
 XpEkaeaXXnnK9MciVCZcSwH6MrbZwmyNHO7Cd3+3+I3yN45ChEljllrJfnE7SasPj/9/
 u0gIg4RF8SDskWEMhI+RzfdcVVtS3vliBZUCGSLHIMhJiI5/StmBwPittmuHaI3kQDsq
 H19+oM/LhcgvfHYr/HB/JJ1wcfI7MBdrCmYOZE2K+NYCsxrh9qzsSfP1YgzKmqt8CLjK
 nz0xS5WKTrnpLOtxgpBrryQc/beZwrh/JOJIarD+9vM89VejjisV26dlWkiLbn409zyQ OA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33b62thf9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 15:53:37 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083JrYZB029078;
        Thu, 3 Sep 2020 19:53:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 337en8e5fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 19:53:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083JrV9719923358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 19:53:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0E7911C04A;
        Thu,  3 Sep 2020 19:53:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DA6911C04C;
        Thu,  3 Sep 2020 19:53:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 19:53:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 0/4] net/smc: fixes 2020-09-03
Date:   Thu,  3 Sep 2020 21:53:14 +0200
Message-Id: <20200903195318.39288-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=679 suspectscore=1 phishscore=0
 clxscore=1011 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009030176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net tree.

Patch 1 fixes the toleration of older SMC implementations. Patch 2
takes care of a problem that happens when SMCR is used after SMCD
initialization failed. Patch 3 fixes a problem with freed send buffers,
and patch 4 corrects refcounting when SMC terminates due to device
removal.

Thanks,
Karsten

Karsten Graul (1):
  net/smc: fix toleration of fake add_link messages

Ursula Braun (3):
  net/smc: set rx_off for SMCR explicitly
  net/smc: reset sndbuf_desc if freed
  net/smc: fix sock refcounting in case of termination

 net/smc/smc_close.c | 15 ++++++++-------
 net/smc/smc_core.c  |  3 +++
 net/smc/smc_llc.c   | 15 ++++++++++++++-
 3 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.17.1

