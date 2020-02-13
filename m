Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DE715CBD0
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 21:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgBMURQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 15:17:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727827AbgBMURQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 15:17:16 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DKH74i103157;
        Thu, 13 Feb 2020 15:17:11 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y3yw9n295-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 15:17:11 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01DKH9eT103496;
        Thu, 13 Feb 2020 15:17:10 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y3yw9n10j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 15:17:09 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01DKDb8b030867;
        Thu, 13 Feb 2020 20:14:15 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 2y5bbygthq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 20:14:15 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01DKEF5R46334276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 20:14:15 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12D5AAE062;
        Thu, 13 Feb 2020 20:14:15 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45B58AE060;
        Thu, 13 Feb 2020 20:14:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.24.11.154])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 Feb 2020 20:14:14 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v4, 0/2] net/ethtool: Introduce link_ksettings API for virtual network devices
Date:   Thu, 13 Feb 2020 14:14:08 -0600
Message-Id: <20200213201410.6912-1-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_08:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=1 spamscore=0 mlxscore=0
 phishscore=0 mlxlogscore=827 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides an API for drivers of virtual network devices that allows
users to alter initial device speed and duplex settings to reflect the actual
capabilities of underlying hardware. The changes made include two helper
functions ethtool_virtdev_set_link_ksettings, which is used to retrieve
alterable link settings. In addition, there is a new ethtool operation defined
to validate those settings provided by the user. This operation can use either a
generic validation function, ethtool_virtdev_validate_cmd, or one defined by the
driver. These changes resolve code duplication for existing virtual network
drivers that have already implemented this behavior.  In the case of the ibmveth
driver, this API is used to provide this capability for the first time.

---
v4:  - Cleaned up return statement in ethtool_virtdev_validate_cmd based off of
     Michal Kubecek's and Thomas Falcon's suggestion.

     - If the netvsc driver is using the VF device in order to get accelerated
     networking, the real speed and duplex is reported by using the VF device as
     suggested by Stephen Hemminger.

     - Removed ethtool_virtdev_get_link_ksettings since it was too simple to
     warrant a helper function.

v3:  - Factored out duplicated code to core/ethtool to provide API to virtual
     drivers
    
v2:  - Updated default driver speed/duplex settings to avoid breaking existing
     setups
---

Cris Forno (2):
  ethtool: Factored out similar ethtool link settings for virtual
    devices to core
  net/ethtool: Introduce link_ksettings API for virtual network devices

 drivers/net/ethernet/ibm/ibmveth.c | 62 ++++++++++++++++++++++----------------
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 drivers/net/hyperv/netvsc_drv.c    | 25 +++++++++------
 drivers/net/virtio_net.c           | 40 ++----------------------
 include/linux/ethtool.h            |  7 +++++
 net/ethtool/ioctl.c                | 40 ++++++++++++++++++++++++
 6 files changed, 105 insertions(+), 72 deletions(-)

-- 
1.8.3.1

