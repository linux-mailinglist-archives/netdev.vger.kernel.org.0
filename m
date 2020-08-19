Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6A024947F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgHSFfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:35:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgHSFfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:35:18 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J5Vkq0066025;
        Wed, 19 Aug 2020 01:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lKPuL9AEUwNbEMMrAuSbtDjAunKkNzlLrJkbsfgDB9s=;
 b=GwwdNJCVXPPzd7AlyEusgT1RzRaF4yqjr+PWPHDX5RhE2iAKUEcxuDv9sGDMZNTATO/k
 wIh2v3oLdtuoFtVjZbexv6XOfohI+/W5YI6ANaLuPo1ERXYSrVzzlhK+QPzCq+WmE2jj
 FGvyy/w02i4tS3psy+aG/ocifoeqLxfoshV3gvL0XME9k9VVG+tjr9HjW5LujUlNew/i
 D0DNPUfV11iiSr/6Rol7u2HsnRlBfo+2+upkjnEOBWPz/yDADky4Tt4e3LKeNnleaaKW
 Cbwwj7yxyNAcCBTgBnPQewet66dlJZnlmWLGS9SW5H1HMQEpegn4lBC4sfegFaZcDKYm oA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r3ysgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 01:35:14 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07J5Upv6026936;
        Wed, 19 Aug 2020 05:35:13 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 3304ce1kd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 05:35:13 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07J5ZDMs59310374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 05:35:13 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2447AC05E;
        Wed, 19 Aug 2020 05:35:12 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F5C1AC060;
        Wed, 19 Aug 2020 05:35:12 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.104.33])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 05:35:12 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 0/5] refactoring of ibmvnic code
Date:   Wed, 19 Aug 2020 00:35:07 -0500
Message-Id: <20200819053512.3619-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_02:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=687 bulkscore=0 suspectscore=1 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190042
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

