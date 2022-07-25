Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADA0580078
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiGYOKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiGYOKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:10:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBD564E0;
        Mon, 25 Jul 2022 07:10:17 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PDgQew018555;
        Mon, 25 Jul 2022 14:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mWmGgDpNjNyWQToF/Hzs2pCm0NpddwKbotywqddBLGU=;
 b=T7RrLQabVJ5DEPSpddrYnXWbEioQfJEVNYfZ6o97wyy1tVg8M0ijrAr1nm9o3IYXoWo7
 UggaO54i6TdB3Gou5rhb1i4mkTIepvrnPPtF9No7fFaPyACrB9ph72unUvEJMZeBj/n+
 FO6V1a8qFVBVQCkuVng+p0QP9lpny+digF6SwSQufo+nIClhBT3lwqm2rkwLTYH5KCOa
 eV9qDZJ2mT3Js2MC1iDwWiVEw0g10qlAHztvN3GT/gkqEWm6/4DlfPrQdvv9AJF3SqYA
 mtmuTN2JRSYFwtSwtRPFypG2Osj6nmALyo9G9m824oukXXSnYmshgoT2V4a1mbply9uZ DQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhv9ps3et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 14:10:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PE75Uq031080;
        Mon, 25 Jul 2022 14:10:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3hg945hw3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 14:10:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PEA7Wg21234018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 14:10:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9758442045;
        Mon, 25 Jul 2022 14:10:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A49A4203F;
        Mon, 25 Jul 2022 14:10:04 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.136.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jul 2022 14:10:04 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 0/4] net/smc: updates 2022-7-25
Date:   Mon, 25 Jul 2022 16:09:56 +0200
Message-Id: <20220725141000.70347-1-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x4cqknbkTNkf8O4-t3gm4n2LPV2rnEFG
X-Proofpoint-GUID: x4cqknbkTNkf8O4-t3gm4n2LPV2rnEFG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_09,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207250059
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

