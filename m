Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF981740BF
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 21:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgB1UMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 15:12:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726287AbgB1UMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 15:12:23 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SJsOIb107149;
        Fri, 28 Feb 2020 15:12:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yepx5upm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Feb 2020 15:12:17 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01SJuOiJ111779;
        Fri, 28 Feb 2020 15:12:16 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yepx5upkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Feb 2020 15:12:16 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01SK1KKP029903;
        Fri, 28 Feb 2020 20:12:15 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 2yepv2xxke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Feb 2020 20:12:15 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01SKCEAn49676694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 20:12:14 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E74A6A047;
        Fri, 28 Feb 2020 20:12:14 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B51946A04D;
        Fri, 28 Feb 2020 20:12:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.163.83.215])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Feb 2020 20:12:13 +0000 (GMT)
From:   Cris Forno <cforno12@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v7, 0/2] net/ethtool: Introduce link_ksettings API for virtual network devices
Date:   Fri, 28 Feb 2020 14:12:03 -0600
Message-Id: <20200228201205.15846-1-cforno12@linux.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_07:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 suspectscore=1 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cris Forno <cforno12@linux.vnet.ibm.com>

This series provides an API for drivers of virtual network devices that
allows users to alter initial device speed and duplex settings to reflect
the actual capabilities of underlying hardware. The changes made include
a helper function ethtool_virtdev_set_link_ksettings, which is used to
retrieve alterable link settings. In addition, there is a new ethtool
function defined to validate those settings. These changes resolve code
duplication for existing virtual network drivers that have already
implemented this behavior.  In the case of the ibmveth driver, this API is
used to provide this capability for the first time.

---
v7:  - removed ethtool_validate_cmd function pointer parameter from
      ethtool_virtdev_set_link_ksettings since none of the virtual drivers
      pass in a custom validate function as suggested by Michal Kubecek.

v6:  - removed netvsc_validate_ethtool_ss_cmd(). netvsc_drv now uses
     ethtool_virtdev_validate_cmd() instead as suggested by Michal Kubecek
     and approved by Haiyang Zhang.

     - matched handler argument name of ethtool_virtdev_set_link_ksettings
     in declaration and definition as suggested by Michal Kubecek.

     - shortened validate variable assignment in
     ethtool_virtdev_set_link_ksettings as suggested by Michal Kubecek.

v5:  - virtdev_validate_link_ksettings is taken out of the ethtool global
     structure and is instead added as an argument to
     ethtool_virtdev_set_link_ksettings as suggested by Jakub Kicinski.

v4:  - Cleaned up return statement in ethtool_virtdev_validate_cmd based
     off of Michal Kubecek's and Thomas Falcon's suggestion.

     - If the netvsc driver is using the VF device in order to get
     accelerated networking, the real speed and duplex is reported by using
     the VF device as suggested by Stephen Hemminger.

     - The speed and duplex variables are now passed by value rather than
     passed by pointer as suggested by Willem de Bruijin and Michal
     Kubecek.

     - Removed ethtool_virtdev_get_link_ksettings since it was too simple
     to warrant a helper function.

v3:  - Factored out duplicated code to core/ethtool to provide API to
     virtual drivers

v2:  - Updated default driver speed/duplex settings to avoid breaking
     existing setups
---

Cris Forno (2):
  ethtool: Factored out similar ethtool link settings for virtual
    devices to core
  net/ethtool: Introduce link_ksettings API for virtual network devices

 drivers/net/ethernet/ibm/ibmveth.c | 57 +++++++++++++++++-------------
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 drivers/net/hyperv/netvsc_drv.c    | 41 ++++++++-------------
 drivers/net/virtio_net.c           | 39 ++------------------
 include/linux/ethtool.h            |  6 ++++
 net/ethtool/ioctl.c                | 39 ++++++++++++++++++++
 6 files changed, 98 insertions(+), 87 deletions(-)

-- 
2.25.0

