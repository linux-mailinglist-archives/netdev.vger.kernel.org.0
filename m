Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D9C244607
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 09:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgHNH7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 03:59:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17848 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726807AbgHNH7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 03:59:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07E7Urap020833;
        Fri, 14 Aug 2020 03:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lKPuL9AEUwNbEMMrAuSbtDjAunKkNzlLrJkbsfgDB9s=;
 b=JTV7AYkg4JQ/SJcNxwoof4mVxxnp6ayFqcYoM+/z5SMtp2lW+XbXkbw8ArJNnxqC0cbA
 sg8aw4NKjQku1M5yJmvXNx9dgVS+w+YkKuSkKW7gvAyIl0K60eUJIhOm7dbtOxHhmc0H
 d9J9AuXrDJBlD2gXwTrA7ECcvFzTVFOWiqiDW1PAdy/42XXdrt1FKBM+FJEW3SDJ5exm
 bB/yHdxw8zghEB3ln4TY79B4Iq8yiillfDefcl9NAxsOI3viFZB6a8Jc42q1kRJneEou
 dJvkfKkhE+f0ATlIbhZofeMTtnpZ5+mx6ZAjiIjGpy4lBgpIiQAHbo/tjjLxICZx7T0q jw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w6tc1er1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 03:59:23 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07E7u3pq029852;
        Fri, 14 Aug 2020 07:59:22 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 32skp9rfnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 07:59:22 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07E7xMEw53674376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 07:59:22 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A6B2AC05B;
        Fri, 14 Aug 2020 07:59:22 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F374FAC059;
        Fri, 14 Aug 2020 07:59:21 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.68.30])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 07:59:21 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 0/5] refactoring of ibmvnic code
Date:   Fri, 14 Aug 2020 02:59:16 -0500
Message-Id: <20200814075921.88745-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_02:2020-08-13,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=1
 malwarescore=0 priorityscore=1501 mlxlogscore=640 clxscore=1011
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series refactor reset_init and init functions,
improve the debugging messages, and make some other cosmetic changes
to make the code easier to read and debug.

Lijun Pan (5):
  ibmvnic: print caller in several error messages
  ibmvnic: compare adapter->init_done_rc with more readable
    ibmvnic_rc_codes
  ibmvnic: improve ibmvnic_init and ibmvnic_reset_init
  ibmvnic: remove never executed if statement
  ibmvnic: merge ibmvnic_reset_init and ibmvnic_init

 drivers/net/ethernet/ibm/ibmvnic.c | 98 +++++++++---------------------
 1 file changed, 28 insertions(+), 70 deletions(-)

-- 
2.23.0

