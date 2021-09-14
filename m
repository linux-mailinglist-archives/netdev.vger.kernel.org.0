Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DE140A94A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhINIfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:35:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230487AbhINIfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:35:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E7f5oP015176;
        Tue, 14 Sep 2021 04:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=oEPKXKrys1Lj+3UwTsxeCpOipe1FbO2kiblAQnK8xRY=;
 b=lm1KDgwi1JJDAGwHSR1i0+gBU5nJyzafshl6FJrnBEqN9zZD6mKylpGBsZ51ArawQY1J
 8sy/mhhrtu5ol3JNWNIU6jpeMwfz3cwW4jTjrkpETUo3rJJ7JcJTKX//hUvc9KenxQhs
 1NIuomxT62RAazBMWNT1AO/vzskEeqvzq9BLtYbKKFTo5tBMuFPZhQ96Hj2lvY+av39G
 /Mi0VTEWYGSd31zneb4y9FosOYlT/U5fiY9J82hQS8a3SE/MNOhp5t8pG68dhfdeMpVL
 xIK2Jf6pKakONJXPa3zdx+vyI/0wx992+joo6PCs0tBnLMDvhtaklEq6uaZoFomDCwYu LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2mvb4kyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:55 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18E6UT7R013217;
        Tue, 14 Sep 2021 04:33:55 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2mvb4ky6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:55 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8XPH0014062;
        Tue, 14 Sep 2021 08:33:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3b0m398umj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:33:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8XnQD46006694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:33:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A1784C058;
        Tue, 14 Sep 2021 08:33:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE48C4C04A;
        Tue, 14 Sep 2021 08:33:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 08:33:48 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next 0/4] s390/net: updates 2021-09-14
Date:   Tue, 14 Sep 2021 10:33:16 +0200
Message-Id: <20210914083320.508996-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _zigWZEqPJXLC0KSqg-6BJIjdv-B9TVo
X-Proofpoint-GUID: o9pr3lBBiCGwfchQK1SW6fW9iDzhtyqs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109140017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patches to netdev's net-next tree.

Stop using the wrappers in include/linux/pci-dma-compat.h,
and fix warnings about incorrect kernel-doc comments.

Christophe JAILLET (1):
  s390/ism: switch from 'pci_' to 'dma_' API

Heiko Carstens (3):
  s390/ctcm: remove incorrect kernel doc indicators
  s390/lcs: remove incorrect kernel doc indicators
  s390/netiucv: remove incorrect kernel doc indicators

 drivers/s390/net/ctcm_fsms.c |  60 ++++++++---------
 drivers/s390/net/ctcm_main.c |  38 +++++------
 drivers/s390/net/ctcm_mpc.c  |   8 +--
 drivers/s390/net/fsm.c       |   2 +-
 drivers/s390/net/ism_drv.c   |   2 +-
 drivers/s390/net/lcs.c       | 121 ++++++++++++++++++-----------------
 drivers/s390/net/netiucv.c   | 104 +++++++++++++++---------------
 7 files changed, 168 insertions(+), 167 deletions(-)

-- 
2.25.1

