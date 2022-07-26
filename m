Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38ABF5810B0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiGZKD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiGZKD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:03:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7DB31227;
        Tue, 26 Jul 2022 03:03:55 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q9hnjD025224;
        Tue, 26 Jul 2022 10:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=wH8zMEOIyQKVKtup09OnQsKPecF9QC29pS4D05IAdyw=;
 b=V3PatpIcOfRUB/Nvve3zCaO8udPQY7tN1r8YOP/F9PtMxSixMst9Dz7bZuMHhakr4VkD
 dm/jPpxeqalD0DffrfKSesyaO4QTs7+yO5sSSuxjxiyRw5hb7RV/JwWGiUNPfyvFRreU
 921Depk1qPhHktPdV8n7cblApz8+waLuY++40Ds0fTQMHPP22FHoKlc3CrgcVIK/Q/W0
 ESx9a3Z3JRoLsvfY/l7JQKwTAkf9bdiIFhWQaBT9bjNpm0Qojt7VhzpDPmbFoPpijfqI
 utYnScJEa+576XxzaWKi16MFvF9dD/WGdgrMDdq7r8SwEg23GzlZZrksqz4EJ2xSeo5K 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjdvx0hhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:45 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26Q9vdIr019284;
        Tue, 26 Jul 2022 10:03:45 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjdvx0hgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:44 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26Q9pnYf016283;
        Tue, 26 Jul 2022 10:03:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3hg95yapy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QA1fuq17826074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 10:01:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 063664C04E;
        Tue, 26 Jul 2022 10:03:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DBAB4C046;
        Tue, 26 Jul 2022 10:03:36 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.107.22])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 10:03:36 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next v2 0/4] net/smc: updates 2022-07-25
Date:   Tue, 26 Jul 2022 12:03:26 +0200
Message-Id: <20220726100330.75191-1-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RjZUd4sjByo4BI5hRT2Ta6nCPuPPW2p7
X-Proofpoint-ORIG-GUID: bq0bg116dlo55S1DZVZr6ewA_PaaffiZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_02,2022-07-25_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207260035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patches to netdev's net-next tree.

These patches do some preparation to make ISM available for uses beyond
SMC-D, and a bunch of cleanups.

Thanks,
Wenjia

v2: add "Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>"


Heiko Carstens (1):
  net/smc: Eliminate struct smc_ism_position

Stefan Raspl (3):
  s390/ism: Cleanups
  net/smc: Pass on DMBE bit mask in IRQ handler
  net/smc: Enable module load on netlink usage

 drivers/s390/net/ism_drv.c | 15 ++++++++-------
 include/net/smc.h          |  4 ++--
 net/smc/af_smc.c           |  1 +
 net/smc/smc_diag.c         |  1 +
 net/smc/smc_ism.c          | 19 ++++---------------
 net/smc/smc_ism.h          | 20 +++++++++++---------
 net/smc/smc_tx.c           | 10 +++-------
 7 files changed, 30 insertions(+), 40 deletions(-)

-- 
2.35.2

