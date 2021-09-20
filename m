Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608F54126C6
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 21:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350634AbhITTWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 15:22:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50043 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344007AbhITTUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 15:20:06 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KJGDFW001160;
        Mon, 20 Sep 2021 15:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=JhH0yiehiovZ8/rC9hSwkWTdsVLNXTs8QUHXiqRPuQY=;
 b=sEi1BjiGUn55TPcTyRme50mRiHgHpxNt7zuQXTSbB/La0MckdLVWebrUoXuiLgGdNw2E
 M4dBJ4oPs6sjGBvo2HuR39J2KMywOL152oggWgVY9PjuqzdLPWlpL/dh1FaKN8sDvN7h
 0CGjtkEqWRVIeg6HWaU1Xec+Nsw5PeUDsQCNG3glLVYxJRy6Mnad7qShuAhXsaMlCffQ
 Gl0T1GdRPQ2rfBlTOscQWCPvsmNiBLpAhrcRkLkrlEigx7PMIRqW/mTAZHCpbaMctCbA
 +WpbhNsUix92qrfqlUXDrp2TILXHByD849Z/0qZJ3ijfhGDdTYdWnHiTWosG0pr2yADa tw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5w0pkfbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 15:18:36 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KJ3BBt024695;
        Mon, 20 Sep 2021 19:18:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3b57r8ujkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 19:18:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KJDjuJ59310362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 19:13:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A1B911C052;
        Mon, 20 Sep 2021 19:18:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E62C511C054;
        Mon, 20 Sep 2021 19:18:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 19:18:30 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 0/2] net/smc: fixes 2021-09-20
Date:   Mon, 20 Sep 2021 21:18:13 +0200
Message-Id: <20210920191815.2919121-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BY2GGuRs36ChpeBrqkDKjNxIaGRLvtYO
X-Proofpoint-GUID: BY2GGuRs36ChpeBrqkDKjNxIaGRLvtYO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=643 spamscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patches for smc to netdev's net tree.

The first patch adds a missing error check, and the second patch
fixes a possible leak of a lock in a worker.

Karsten Graul (2):
  net/smc: add missing error check in smc_clc_prfx_set()
  net/smc: fix 'workqueue leaked lock' in smc_conn_abort_work

 net/smc/smc_clc.c  | 3 ++-
 net/smc/smc_core.c | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.25.1

