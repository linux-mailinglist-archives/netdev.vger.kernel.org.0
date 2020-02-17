Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8696116160C
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgBQPZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:25:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728103AbgBQPZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:25:05 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HFJPUp086657
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:04 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6af36qd5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:04 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Mon, 17 Feb 2020 15:25:02 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 15:25:01 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HFOvZs56557804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 15:24:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB20BA4040;
        Mon, 17 Feb 2020 15:24:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F6C5A404D;
        Mon, 17 Feb 2020 15:24:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 15:24:57 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com
Subject: [PATCH net-next 0/6] net/smc: patches 2020-02-17
Date:   Mon, 17 Feb 2020 16:24:49 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20021715-0020-0000-0000-000003AAF979
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021715-0021-0000-0000-00002202F111
Message-Id: <20200217152455.15341-1-ubraun@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_10:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=870 spamscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=1
 bulkscore=0 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002170126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here are patches for SMC making termination tasks more perfect.

Thanks, Ursula

Karsten Graul (5):
  net/smc: improve smc_lgr_cleanup()
  net/smc: use termination worker under send_lock
  net/smc: do not delete lgr from list twice
  net/smc: remove unused parameter of smc_lgr_terminate()
  net/smc: simplify normal link termination

Ursula Braun (1):
  net/smc: reduce port_event scheduling

 net/smc/smc_clc.c  |  2 +-
 net/smc/smc_core.c | 26 +++++++++++---------------
 net/smc/smc_core.h |  8 +-------
 net/smc/smc_ib.c   | 44 +++++++++++++++++++++++++++++---------------
 net/smc/smc_llc.c  |  2 +-
 net/smc/smc_tx.c   |  2 +-
 6 files changed, 44 insertions(+), 40 deletions(-)

-- 
2.17.1

