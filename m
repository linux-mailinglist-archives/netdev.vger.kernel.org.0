Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34228D6F9
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388780AbgJMXU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:20:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388762AbgJMXU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 19:20:56 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09DN38no134118;
        Tue, 13 Oct 2020 19:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QjU8QlXyCjD9rkqtjihwL03DgUWcQ1xXgqqR5saNXqE=;
 b=fEB9Ik1Yq2LypBgfGFqnhIB2D9dif+eDM7Vs+B/RuORbA04kf8DrOAZjXYINASysCzNT
 KD9tk+OQlCg6KceL/wuBxCGkZ401wCL4LmJTMqi6ESWTbaJmWSty1FGRwEtITMHcODPt
 iOBWDDDFYreOiGx7Lpw8J9UJ/TXt6JhZE01YcEnVvlTmGWH1NU5SKAHiR7G6Omd/YAXL
 2Zf5+OcO631Y6GFEJ2iJbDpqVpxwd3pHW+yWF7CQPn/N/bEojlWVnYfKvlouI5PDh8Cr
 7I1nhYow8N7YDqdJLM4XgM+ErRrETO8zNG1ahDHWdSFvthQn897zQsMKCmQkvzfa9BrC pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 345nfq0j9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 19:20:52 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09DN39Ru134159;
        Tue, 13 Oct 2020 19:20:51 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 345nfq0j9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 19:20:51 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09DNH0bL032595;
        Tue, 13 Oct 2020 23:20:51 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 3434k8ugwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 23:20:51 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09DNKoMj54591928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 23:20:50 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 485F7AE05C;
        Tue, 13 Oct 2020 23:20:50 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DAC3AE05F;
        Tue, 13 Oct 2020 23:20:48 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.65.207.144])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 13 Oct 2020 23:20:48 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org
Subject: [ PATCH v2 0/2] ibmveth gso fix. 
Date:   Tue, 13 Oct 2020 16:20:12 -0700
Message-Id: <20201013232014.26044-1-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-13_15:2020-10-13,2020-10-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=719
 suspectscore=1 phishscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130158
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ibmveth driver is a virtual Ethernet driver used on IBM pSeries systems.
Gso packets can be sent between LPARS (virtual hosts) without segmentation,
by flagging gso packets using one of two methods depending on the firmware
version. Some gso packet were not correctly identified by the receiver.
This patch-set corrects this issue.

V2:
- Added fix tags.
- Byteswap the constant at compilation time.
- Updated the commit message to clarify what frame validation is performed
  by the hypervisor.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>

David Wilder (2):
  ibmveth: Switch order of ibmveth_helper calls.
  ibmveth: Identify ingress large send packets.

 drivers/net/ethernet/ibm/ibmveth.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

-- 
1.8.3.1

