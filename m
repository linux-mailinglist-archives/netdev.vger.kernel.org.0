Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46622C19AE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgKWX6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63622 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727931AbgKWX6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:12 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNSMux170892
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=LvWIOyMa0HCcBEvMyP2aUJOjkH/SXJT5HEem0ohzIcQ=;
 b=sbxN+QAjpl6kg+s+ZJp8thZp/Je9YFzuqrhgAiXlzkL8pzkfyrvq66JFMFpJrjHMU/s+
 BSGzzR22zAHdjoG0pXQjVPeMw4YFumuiIqdJU3VJrn0Lniw8EdhRnSilI1dE2Z04rSDT
 0sutRYgD9L+Wk2P191Y7rSMhx63scivMw2j04eQTG1ep4hIv/EIkehvHxnIJtGOulgIL
 ZjIMQ4OQE+lnhfbEavSatI8KQ9Yoagbrf67jxuVmWT6QnTCyqnDv6Ux2IXUc2VQlJRV5
 RU4dcf+1UX3ZjdUMSm0HCf6ikAZn/QraPWeMeyV4K2fJCwFKIY6ettN6G2j4/XmouRfR xg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34yhay8ux3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:11 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNqiBW001467
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:10 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 34xth8ysqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:10 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwA0011207394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:10 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19B502805E;
        Mon, 23 Nov 2020 23:58:10 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8FF62805C;
        Mon, 23 Nov 2020 23:58:09 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:09 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 0/9] ibmvnic: assorted bug fixes
Date:   Mon, 23 Nov 2020 18:57:48 -0500
Message-Id: <20201123235757.6466-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=485 bulkscore=0
 clxscore=1015 suspectscore=3 spamscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assorted fixes for ibmvnic originated from "[PATCH net 00/15] ibmvnic: 
assorted bug fixes" sent by Lijun Pan.

V2 Changes as suggested by Jakub Kicinski:
- Added "Fixes" to each patch
- Remove "ibmvnic: process HMC disable command" from the series. Submitting it
  separately to net-next.
- Squash V1 "ibmvnic: remove free_all_rwi function" into  
  ibmvnic: stop free_all_rwi on failed reset

Dany Madden (7):
  ibmvnic: handle inconsistent login with reset
  ibmvnic: stop free_all_rwi on failed reset
  ibmvnic: avoid memset null scrq msgs
  ibmvnic: restore adapter state on failed reset
  ibmvnic: send_login should check for crq errors
  ibmvnic: no reset timeout for 5 seconds after reset
  ibmvnic: reduce wait for completion time

Sukadev Bhattiprolu (2):
  ibmvnic: delay next reset if hard reset fails
  ibmvnic: track pending login

 drivers/net/ethernet/ibm/ibmvnic.c | 167 ++++++++++++++++++-----------
 drivers/net/ethernet/ibm/ibmvnic.h |   3 +
 2 files changed, 105 insertions(+), 65 deletions(-)

-- 
2.26.2

