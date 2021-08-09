Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A1A3E420A
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhHIJG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:06:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234095AbhHIJG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:06:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17994Ea5167407;
        Mon, 9 Aug 2021 05:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=AbKCKkjqbT1X7XEd0WDBSI4mQO3kyShPQs+5s6HrFIY=;
 b=OSxq7PcL7cxqOlOq317Gec/TEZauesaI3TDNQ1ALKr3Jz0DPYfNXirJEqUTTsY3lzg36
 IiVFGZ9vg1urvrrk1+uXedzXXn0TgeZMc9HaHga2NT0xc9BONOa0KP23Rdf2dAB5Alnz
 EkNrrmDrtJ0AS6jfothrqA5i9OKn2O6ZNPOLDm/WYmS5VQL9Bi2dFaeeHv+Ihrt3T/nb
 q3VoxG2a2RpOkfQlJgdaGSlB3KEyj5ajapKLEIy6zOMAWOOCiOECG+oQtJsN4dn1OGnW
 pdh87tgSiUv5nTsnk2BVLZhvOT8KX60iPQ2bGbGex2ta7QFH6Ph6a69o7AdO7OBAfffk FA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa7qah8x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 05:06:03 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17992HBF014601;
        Mon, 9 Aug 2021 09:06:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3a9ht8ua6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 09:06:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17992mPu56951268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 09:02:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0735F4C04E;
        Mon,  9 Aug 2021 09:05:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7C704C050;
        Mon,  9 Aug 2021 09:05:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 09:05:57 +0000 (GMT)
From:   Guvenc Gulce <guvenc@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net 0/2] net/smc: fixes 2021-08-09
Date:   Mon,  9 Aug 2021 11:05:55 +0200
Message-Id: <20210809090557.3121288-1-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k3_8I1EjKVWcKufD2UIQ-_jr9P4W6_B6
X-Proofpoint-ORIG-GUID: k3_8I1EjKVWcKufD2UIQ-_jr9P4W6_B6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,
 
please apply the following patch series for smc to netdev's net tree. 
One patch fixes invalid connection counting for links and the other
one fixes an access to an already cleared link.

Thanks,

Guvenc

Guvenc Gulce (1):
  net/smc: Correct smc link connection counter in case of smc client

Karsten Graul (1):
  net/smc: fix wait on already cleared link

 net/smc/af_smc.c   |  2 +-
 net/smc/smc_core.c |  4 ++--
 net/smc/smc_core.h |  4 ++++
 net/smc/smc_llc.c  | 10 ++++------
 net/smc/smc_tx.c   | 18 +++++++++++++++++-
 net/smc/smc_wr.c   | 10 ++++++++++
 6 files changed, 38 insertions(+), 10 deletions(-)

-- 
2.25.1

