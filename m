Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A042B86F4
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgKRVmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:42:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgKRVmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 16:42:06 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AILXLn5054347;
        Wed, 18 Nov 2020 16:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=NbQ/gadKZ3ntqG1pLK30U7VmOcV5rcTeoJvc22/oym4=;
 b=N09o4gRlhacPTL28JCqKnR9ldJcvNzmOH1eEKoKoo+x8/HL97+OR/wqeM0mHwOyjn/V+
 3ljPaGTnE53msRJlKHDOgPvPGCAATm61BMwAqs+otXZTOTy+GnVCfhTaFlgLWGP/wfeV
 fQt8wyUBVvRBulj5STab3T4HRR8JeGJbgDNkdPtMxJPfULIRCW1BCwcVXvcHXuGNu6Ho
 7KY9ztvMRUL1eQwMFooWT7YULrPkt/iJIwEa1Np2iPlJKkEQMdLx0+Iz6MD3cAzJXDVC
 ff4fG+W6DytBmCCUMSfvjAX/QgKRIGvY3kkoRt8LBasx1TgFGMajO7WcVOIbGhhgr0V1 Kw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w8q4wdu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 16:42:05 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AILcBmS006121;
        Wed, 18 Nov 2020 21:42:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 34t6v8axxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 21:42:03 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AILekrB8651434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 21:40:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEF0042047;
        Wed, 18 Nov 2020 21:40:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D42F42041;
        Wed, 18 Nov 2020 21:40:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Nov 2020 21:40:45 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net 0/2] net/smc: fixes 2020-11-18
Date:   Wed, 18 Nov 2020 22:40:36 +0100
Message-Id: <20201118214038.24039-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_08:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=1
 mlxlogscore=682 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180148
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net tree.

Patch 1 fixes the matching of link groups because with SMC-Dv2 the vlanid
should no longer be part of this matching. Patch 2 removes a sparse message.

Karsten Graul (2):
  net/smc: fix matching of existing link groups
  net/smc: fix direct access to ib_gid_addr->ndev in
    smc_ib_determine_gid()

 net/smc/af_smc.c   | 3 ++-
 net/smc/smc_core.c | 3 ++-
 net/smc/smc_ib.c   | 6 +++---
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.17.1

