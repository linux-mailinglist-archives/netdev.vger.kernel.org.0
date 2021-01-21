Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C32C2FE290
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbhAUGSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:18:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41920 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726810AbhAUGR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 01:17:56 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L5xVji044576
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FYbmJCmc4XYphRF5j9ymHK5CEw7IRee4REkaudCb/OE=;
 b=D0Nq26yIgQrZCNpCBRcsX4i/dG8rL51vjfsqXPciMwNgS+5nxN+8+xwSI5hd/d0Z5VNo
 ukp6QHUpvy6ZUQPOnnGcdjK8h0TvD1cYkRA1SGlmDJJmHX9+muP1eDzTvLSoeKA2AtFj
 dPOyhsWbEjX+b1IcP0a16/jPqvijULGFoDMb/OgkAZ3K3vGtYgLzHQE8RcU/+aZ0OWuh
 jnayzQHLpGu26os8/et+bAEgq0iaQv7bOrKVcdmRjVUnSQVe2TC0KKVsJG3f5nHjrrCY
 thDml929d1kpewnSE0S/5FkR70M8d35NRBJI87RhRt4E/sb+RSyeG6Cjc62AQvD+5sD3 VA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3673xy8kpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:17:13 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L6DVdY009142
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:17:12 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 3668pc1w29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:17:12 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L6HBw98323384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 06:17:11 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90B8F78063;
        Thu, 21 Jan 2021 06:17:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 181E47805E;
        Thu, 21 Jan 2021 06:17:10 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.137.249])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 06:17:10 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 0/3] fixes the memory barrier for SCRQ/CRQ entry 
Date:   Thu, 21 Jan 2021 00:17:07 -0600
Message-Id: <20210121061710.53217-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_02:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 phishscore=0 mlxlogscore=742 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series rework/fix the memory barrier for SCRQ (Sub-Command-Response
Queue) and CRQ (Command-Response Queue) entries.

This series does not have merge conflict with Suka's 
https://lists.openwall.net/netdev/2021/01/08/89

Lijun Pan (3):
  ibmvnic: rework to ensure SCRQ entry reads are properly ordered
  ibmvnic: remove unnecessary rmb() inside ibmvnic_poll
  ibmvnic: Ensure that CRQ entry read/write are correctly ordered

 drivers/net/ethernet/ibm/ibmvnic.c | 54 ++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 18 deletions(-)

-- 
2.23.0

