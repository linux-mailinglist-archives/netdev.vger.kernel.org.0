Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE241C2C36
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgECMjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:39:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728203AbgECMjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:47 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CVekt169236;
        Sun, 3 May 2020 08:39:44 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v5vwf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:44 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CaBrS004592;
        Sun, 3 May 2020 12:39:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g592d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043Cddwx17039398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF04B4C04A;
        Sun,  3 May 2020 12:39:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F12A4C044;
        Sun,  3 May 2020 12:39:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:39 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 00/11] net/smc: add and delete link processing
Date:   Sun,  3 May 2020 14:38:39 +0200
Message-Id: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=1 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=862
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches add the 'add link' and 'delete link' processing as 
SMC server and client. This processing allows to establish and
remove links of a link group dynamically.

v2: Fix mess up with unused static functions. Merge patch 8 into patch 4.
    Postpone patch 13 to next series.

Karsten Graul (11):
  net/smc: first part of add link processing as SMC client
  net/smc: rkey processing for a new link as SMC client
  net/smc: final part of add link processing as SMC client
  net/smc: first part of add link processing as SMC server
  net/smc: rkey processing for a new link as SMC server
  net/smc: final part of add link processing as SMC server
  net/smc: delete an asymmetric link as SMC server
  net/smc: llc_del_link_work and use the LLC flow for delete link
  net/smc: delete link processing as SMC client
  net/smc: delete link processing as SMC server
  net/smc: enqueue local LLC messages

 net/smc/af_smc.c   |   4 +-
 net/smc/smc_core.c |  29 +-
 net/smc/smc_core.h |   4 +-
 net/smc/smc_llc.c  | 798 +++++++++++++++++++++++++++++++++++++++++++--
 net/smc/smc_llc.h  |   5 +
 net/smc/smc_wr.c   |   2 +-
 net/smc/smc_wr.h   |   1 +
 7 files changed, 800 insertions(+), 43 deletions(-)

-- 
2.17.1

