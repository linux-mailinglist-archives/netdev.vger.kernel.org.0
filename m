Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4E12BB93C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgKTWky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728587AbgKTWky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:54 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMVWDU071036
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=da4gVSjTKU/iyXU2uuo0KjPolWRw90jeFPmQF7rRmOY=;
 b=e/NxR5ItrrMBDR1sQG52SG2ylptxF6M4RUm7dodrWdQMuvTVITY3jeEMF9ZqL5Btcdcs
 ihzylVxnfrL6bkKCCPnanujW2lei/9bRB9mF3CGE5u8VaPu71q5oF0bPOUxjquIK3taw
 5ELALwzrunZLFumoEcxmpCJoIZzW8viIK7g2F75ecAngZWbbzs4xQPJCvuf3jWmdZ6K+
 BxRPNCRTp/zazlZFn+yuKmh8xPn74bw5+Bl4CsfmBuLL2Ipaivi3yT+5cyL8p5c5QNQa
 B0s1mNhwHWsvwNgg/b6dsJ/zeA+E/zheNZ29QSBr0IfyApjLCYaZyz/juhP8egg25nfd Rw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34xm8t3n13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:52 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMc2GM015124
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:52 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 34t6v9ss8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:52 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMeoCa7996022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:51 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E20416E054;
        Fri, 20 Nov 2020 22:40:50 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37C936E050;
        Fri, 20 Nov 2020 22:40:50 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:50 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 00/15] ibmvnic: assorted bug fixes
Date:   Fri, 20 Nov 2020 16:40:34 -0600
Message-Id: <20201120224049.46933-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=372 clxscore=1015 spamscore=0 suspectscore=3
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assorted fixes and improvements for ibmvnic bugs.

Dany Madden (9):
  ibmvnic: handle inconsistent login with reset
  ibmvnic: process HMC disable command
  ibmvnic: stop free_all_rwi on failed reset
  ibmvnic: remove free_all_rwi function
  ibmvnic: avoid memset null scrq msgs
  ibmvnic: restore adapter state on failed reset
  ibmvnic: send_login should check for crq errors
  ibmvnic: no reset timeout for 5 seconds after reset
  ibmvnic: reduce wait for completion time

Lijun Pan (3):
  ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
  ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq
  ibmvnic: enhance resetting status check during module exit

Sukadev Bhattiprolu (3):
  ibmvnic: delay next reset if hard reset failed
  ibmvnic: track pending login
  ibmvnic: add some debugs

 drivers/net/ethernet/ibm/ibmvnic.c | 246 +++++++++++++++++++++--------
 drivers/net/ethernet/ibm/ibmvnic.h |   9 +-
 2 files changed, 183 insertions(+), 72 deletions(-)

-- 
2.23.0

