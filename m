Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075EA2BA58E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgKTJJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:09:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727058AbgKTJJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:09:50 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK95NxU009214;
        Fri, 20 Nov 2020 04:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=XxSfbu9NyfPtYH/Xd3/dvRJ7iR2hKaxa5WCRuSbNAtM=;
 b=knofnfr8SXt7eeGTPIbjdOx9EDucruxoJSEsi9dXIhPFZr416SgIgJv1FeBzTjwatF2t
 wkZmWOCwIDNRq997DUMWXW9SPWsEJWE8KZ0MG1o8wiRi6PobsuT66N7/P6RJ7dX+KctW
 k2HTYLuzI6oeq+9CHOUCLxh/hrnIISref5FkLmIfCctFqCanJprMb7HisJLSGq6oBbhW
 AhS40dS7LSX7Sg030acc6kgQKnCM5CoU3/eTdQ3pWW2APs+gxiUpNtNysVXnr891Hg4f
 QTZ4HZrVQA/RtidFVcsSKSMKYYcXKQh+1KBD11Ar2XeEHU1Mq//9CzMFjptmZCjYHL6b KQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xakj0fe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 04:09:45 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AK984MR020944;
        Fri, 20 Nov 2020 09:09:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34weby1ggk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 09:09:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AK99e8a9306774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 09:09:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4044F4203F;
        Fri, 20 Nov 2020 09:09:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E49B442041;
        Fri, 20 Nov 2020 09:09:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 09:09:39 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 0/4] s390/qeth: fixes 2020-11-20
Date:   Fri, 20 Nov 2020 10:09:35 +0100
Message-Id: <20201120090939.101406-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0 mlxlogscore=768
 lowpriorityscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

please apply the following patch series to netdev's net tree.

This brings several fixes for qeth's af_iucv-specific code paths.

Also one fix by Alexandra for the recently added BR_LEARNING_SYNC
support. We want to trust the feature indication bit, so that HW can
mask it out if there's any issues on their end.

Thanks,
Julian

Alexandra Winter (1):
  s390/qeth: Remove pnso workaround

Julian Wiedmann (3):
  s390/qeth: make af_iucv TX notification call more robust
  s390/qeth: fix af_iucv notification race
  s390/qeth: fix tear down of async TX buffers

 drivers/s390/net/qeth_core.h      |  9 ++--
 drivers/s390/net/qeth_core_main.c | 82 ++++++++++++++++++++-----------
 drivers/s390/net/qeth_l2_main.c   | 18 +------
 3 files changed, 62 insertions(+), 47 deletions(-)

-- 
2.17.1

