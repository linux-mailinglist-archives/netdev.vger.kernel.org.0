Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5826AF04
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgIOU6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:58:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728013AbgIOU6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:58:04 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FKhUdD039419;
        Tue, 15 Sep 2020 16:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=F2oUupJ2O6El4OpChO+MM/3vQ6dRQDnDtz8+41UYXhA=;
 b=ayduRqPD5B/hP3xke6mGN5x55wP/n/T5IwFdvMcG8ZNuAvJXjjAR17DmukRfszpZEFwx
 SedlH02sMeeicdXDsM+xoGCV7GY3PN+GXY3plhgK6YZrHNdX0ayiLWhCb7/XsNDRUFJ8
 dFAm5lYaWXTL0gazXy4+ZpDbEKx6TYr4lQ3Pui7yx4C8le7WtazofxDJ6Xw8Ummr8O73
 CjRg4dqvo8a4HwdReI/8Rf/kpUSK+BiaUpJanWZsQ1b0Gq9jxps+yUzfrs6X9N/SGxBN
 kdObSUtPIw1FI6phMUNeP3NsIlSRszOdngXuMnci6TNBFK+I4/mkMllIFNF9xDWFYWZy tQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33k4w0raa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 16:58:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08FKqk7u016923;
        Tue, 15 Sep 2020 20:57:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 33gny8c2bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 20:57:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08FKuLjD26673542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:56:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EB0B42042;
        Tue, 15 Sep 2020 20:57:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E95BC42041;
        Tue, 15 Sep 2020 20:57:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 20:57:54 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 0/1] net/smc: fix 2020-09-15
Date:   Tue, 15 Sep 2020 22:57:08 +0200
Message-Id: <20200915205709.50325-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_13:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 mlxlogscore=584 mlxscore=0 suspectscore=1 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch for smc to netdev's net-next tree.

The patch fixes a problem that was revealed by a smatch warning. Because the
fixed patch is still only in net-next tree I am sending this fix to net-next.

Karsten Graul (1):
  net/smc: check variable before dereferencing in smc_close.c

 net/smc/smc_close.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.17.1

