Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8565C287C0C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgJHTGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:06:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgJHTGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:06:18 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 098J25k1057440
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 15:06:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=228q5yjoSn2ctgoeyscmzJK2F5eRBd7TtadVgF7tLpw=;
 b=GQvuAoOPyFrGIpR1cCGQW+UZBErt8YyXLWLOqOPWQUhGhMxbShyTrHVn4zuWE3NNPn7T
 9TYHqvLYxFKOfC84vWBPA+3EPSGU7ZGajdn/ShXiE0sIeuRDSBo5nZ0VP9mzjjDkfv9u
 xsYmT9q8suU5ic9Xh/3yoTdposei2BP9cm0t03D69kULz2nA3THY/gOa7hEGbFLCr2va
 1mKENk0yMYFWx1MOC1u9aOYY9eWfYyd0tyWXcGR7Q/WyD/VoyK/b0h3DzY/Czp+YLcVC
 jyMjnW1C9nRMGr4ZEs71CHqACj9xx/5nFvrcych5msd3mbQKGXwc88iLCulhKJtXzvFR jg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3428hc06et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 15:06:18 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 098IqQIK005592
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 19:06:17 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 33xgx99ed9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 19:06:17 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 098J66Vd63701502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Oct 2020 19:06:06 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C5A6BE058;
        Thu,  8 Oct 2020 19:06:13 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E13A0BE051;
        Thu,  8 Oct 2020 19:06:11 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.160.28.108])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Oct 2020 19:06:11 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com
Subject: [ PATCH v1 0/2] ibmveth gso fix. 
Date:   Thu,  8 Oct 2020 12:05:36 -0700
Message-Id: <20201008190538.6223-1-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-08_12:2020-10-08,2020-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=547 clxscore=1011 suspectscore=1 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ibmveth driver is a virtual Ethernet driver used on IBM pSeries systems.
Gso packets can be sent between LPARS (virtual hosts) without segmentation,
by flagging gso packets using one of two methods depending on the firmware
version. Some gso packet may not be correctly identified by the receiver.
This patch-set corrects this issue.

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

