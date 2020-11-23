Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BCF2C148A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgKWTfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:35:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbgKWTft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:35:49 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJW3we103896
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YFSHVIDZKFvOx0+e/bjg9H+SqIuxbqmqN4jlJGpOdi0=;
 b=kSUXn/DE6CYp+zfmBF+cBE/myRlBR0XdVvYwnWgNYrSiZv6e7FRKq534d0EkCbDB/9/O
 tosoZIA8YVgHvR+dcYygKOzr4o/3N64o7ig7vAkbkLiR/o+kF2HgDWqcrcNU/525MTY9
 HjOA7HY2aEGZ/5F623qE9u40EqVX6GAS84VYJMveo7L3WA99nwJPvXV+cysEIJY0rXky
 o/6cCH0wccCvVK0jziNY71x/DQ1hy8w6ZbK2YE9TR9zcZ7ZNl31J+fvRHEzYOvhSkPhT
 0i0vG6PPCHW5cVqh3xcQej+lrYmHqSvOaxDIu1WgmPoa/HQqymbCNSmXmGzcamEMwUyt IA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ywjnk9h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:35:49 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJWaQf031391
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 19:35:48 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 34xth8snna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 19:35:48 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANJZmkc55312876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 19:35:48 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3A8DB206A;
        Mon, 23 Nov 2020 19:35:47 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 782D9B2065;
        Mon, 23 Nov 2020 19:35:47 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.185.230])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 19:35:47 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v2 0/3] ibmvnic: null pointer dereference
Date:   Mon, 23 Nov 2020 13:35:44 -0600
Message-Id: <20201123193547.57225-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=13
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 mlxlogscore=571 suspectscore=1 malwarescore=0 clxscore=1015 spamscore=0
 mlxscore=0 bulkscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two NULL pointer dereference crash issues.
Improve module removal procedure.

In v2, we split v1 into 3 sets according to patch dependencies so that
individual author can rework on them during the coming holiday.
1-11 as a set since they are dependent and most of them are Dany's.
12-14 as a set since they are independent of 1-11.
15 to be sent to net-next.

This series come from 12/15 13/15 14/15 of v1's "ibmvnic: assorted bug
fixes".

Lijun Pan (3):
  ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
  ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq
  ibmvnic: enhance resetting status check during module exit

 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++++++--
 drivers/net/ethernet/ibm/ibmvnic.h | 3 +--
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.23.0

