Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58449162D71
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgBRRwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:52:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40490 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726700AbgBRRwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:52:38 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IHolMM062590;
        Tue, 18 Feb 2020 12:52:32 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6cbat6kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:52:32 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01IHpGQt063806;
        Tue, 18 Feb 2020 12:52:30 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6cbat6jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:52:30 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01IHot6J007968;
        Tue, 18 Feb 2020 17:52:30 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 2y6896c0hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 17:52:30 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01IHqTuu58130852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 17:52:29 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4412213604F;
        Tue, 18 Feb 2020 17:52:29 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAF0B136051;
        Tue, 18 Feb 2020 17:52:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.24.11.154])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Feb 2020 17:52:28 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v5, 0/2] net/ethtool: Introduce link_ksettings API for virtual network devices
Date:   Tue, 18 Feb 2020 11:52:25 -0600
Message-Id: <20200218175227.8511-1-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_05:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=1 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1011 phishscore=0
 mlxscore=0 mlxlogscore=873 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180124
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
v5:  - virtdev_validate_link_ksettings is taken out of the ethtool global structure
     and is instead added as an argument to ethtool_virtdev_set_link_ksettings
     as suggested by Jakub Kicinski.

v4:  - Cleaned up return statement in ethtool_virtdev_validate_cmd based off of
     Michal Kubecek's and Thomas Falcon's suggestion.

     - If the netvsc driver is using the VF device in order to get accelerated
     networking, the real speed and duplex is reported by using the VF device as
     suggested by Stephen Hemminger.

     - The speed and duplex variables are now passed by value rather than passed
     by pointer as suggested by Willem de Bruijin and Michal Kubecek.

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

 drivers/net/ethernet/ibm/ibmveth.c | 57 ++++++++++++++++++++++----------------
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 drivers/net/hyperv/netvsc_drv.c    | 25 +++++++++++------
 drivers/net/virtio_net.c           | 40 ++------------------------
 include/linux/ethtool.h            |  8 ++++++
 net/ethtool/ioctl.c                | 45 ++++++++++++++++++++++++++++++
 6 files changed, 108 insertions(+), 70 deletions(-)

-- 
1.8.3.1

