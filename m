Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1C51C5620
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgEENBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:01:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728834AbgEENBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 09:01:50 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045Cb72F114713;
        Tue, 5 May 2020 09:01:48 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4xkp48t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 09:01:45 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045D0qbr023230;
        Tue, 5 May 2020 13:01:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 30s0g5jtqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 13:01:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045D1dhJ63242286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 13:01:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 866ADAE057;
        Tue,  5 May 2020 13:01:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D229AE056;
        Tue,  5 May 2020 13:01:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 13:01:39 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 0/2] log state changes and cleanup
Date:   Tue,  5 May 2020 15:01:19 +0200
Message-Id: <20200505130121.103272-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_07:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=834 spamscore=0 impostorscore=0 mlxscore=0 adultscore=0
 suspectscore=1 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 adds the logging of important state changes to enable SMC-R 
users to detect SMC-R link groups that are not redundant and require
user actions. Patch 2 is a contribution to clean up an unused inline 
function.

Karsten Graul (1):
  net/smc: log important pnetid and state change events

YueHaibing (1):
  net/smc: remove unused inline function smc_curs_read

 net/smc/af_smc.c   |  6 ++----
 net/smc/smc_cdc.h  | 17 -----------------
 net/smc/smc_core.c | 34 ++++++++++++++++++++++++++++-----
 net/smc/smc_core.h |  2 +-
 net/smc/smc_ib.c   | 11 +++++++++++
 net/smc/smc_ism.c  |  6 ++++++
 net/smc/smc_llc.c  | 25 ++++++++++++++++++------
 net/smc/smc_llc.h  |  2 +-
 net/smc/smc_pnet.c | 47 +++++++++++++++++++++++++++++++++++++++++++---
 9 files changed, 113 insertions(+), 37 deletions(-)

-- 
2.17.1

