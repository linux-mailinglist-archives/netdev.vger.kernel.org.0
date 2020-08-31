Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619F5257F1E
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgHaQ6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:58:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbgHaQ6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:58:19 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGVqBg170453
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=qQu8ZPsq/jzqD8XGavLYHY4AVFuG2rEW2E0AzO5eHgk=;
 b=ewGuuB+zRnbahrTJiCPmYXdpgh89sHReYm4C0SYSMzmihBok7wsaDgDJxK3khJZk18n/
 KKuzm+JsRJpd5S21+XMEY07NtIFs0gcd7Z3K3+SZ9xU9Z0wJNnBIAbKycClRekP5Jh0E
 BStev4ua4SMT0OKzwJ4Pj7IBgGV2rzADvjecxdg5y4EVcowPmtgM7ctN+EN3aQjbv5P2
 RRtOyNbfl9hy3k3Kks117HPWUw0r8CuxnrHYdn57nO0NT/DOKCZuR6l7gy96s+pT0QX3
 aBbmO3BdEpJD+endphxFto3xAOuDi3pbwjunXY7vociYnwguBJ/6hUdf25am2FZApDuM iA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3394chha4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:19 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VGrKFI032183
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:18 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 337en95vey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:18 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VGwHts16515486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:58:17 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13F70B2066;
        Mon, 31 Aug 2020 16:58:17 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D0BEB2065;
        Mon, 31 Aug 2020 16:58:16 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 16:58:16 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next 0/5] ibmvnic: Report ACL settings in sysfs
Date:   Mon, 31 Aug 2020 11:58:08 -0500
Message-Id: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_07:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 suspectscore=1 mlxlogscore=706 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches provide support for VNIC Access Control List
settings reporting through sysfs, where they may be exposed
to administrators or tools. ABI Documentation is provided for
existing sysfs device files as well.

Thomas Falcon (5):
  ibmvnic: Create failover sysfs as part of an attribute group
  ibmvnic: Include documentation for ibmvnic sysfs files
  ibmvnic: Remove ACL change indication definitions
  ibmvnic: Reporting device ACL settings through sysfs
  ibmvnic: Provide documentation for ACL sysfs files

 Documentation/ABI/testing/sysfs-driver-ibmvnic |  40 +++++
 drivers/net/ethernet/ibm/ibmvnic.c             | 230 ++++++++++++++++++++++++-
 drivers/net/ethernet/ibm/ibmvnic.h             |  36 ++--
 3 files changed, 284 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ibmvnic

-- 
1.8.3.1

