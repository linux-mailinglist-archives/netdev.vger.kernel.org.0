Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436232D00A3
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 06:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgLFFWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 00:22:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgLFFWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 00:22:11 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B65AWUv036393
        for <netdev@vger.kernel.org>; Sun, 6 Dec 2020 00:21:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=sQrJwSd5uxtAhJQH/HAuIfQdgZj6UKilxKiGc0vRABI=;
 b=FQETwzCspLnMqckDRIHzbAXhYXAG4HRxryr/IhgLcUAQjjeGC5bLHsKA1WZ9XjjxGJga
 OvDtyI/eI/gdT3VKMV0gbA18SALY8KM4OJ6Sm5skx90OIO9n+oqT6eg/qZnvwulckpX6
 37dOpe9eMVIcxjjz4QsbpxOjdUvVzxF6lo2afLIXdgUp6ZbJfFGBWICE41JJaiOzaUS7
 j82BNruxoY9fscO/g2kKSdh37qZryFu4WC4tOnRsUG0Kd4jMRt5RIHfa69oHlMPdoaiE
 WauUHdJRdiFCzk6k2j1REo0mQISfbOswY2JBk6r0QPIbgP3RjkZnxHUO8UE+JY97xIcr yA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 358r5xgsgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 00:21:29 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B65HWZc008224
        for <netdev@vger.kernel.org>; Sun, 6 Dec 2020 05:21:28 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 3581u8eu23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 05:21:28 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B65LRn119661168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Dec 2020 05:21:27 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C57E1124054;
        Sun,  6 Dec 2020 05:21:27 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D20F124053;
        Sun,  6 Dec 2020 05:21:27 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.129.222])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun,  6 Dec 2020 05:21:27 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [RFC PATCH net-next 0/3] lockless version of
Date:   Sat,  5 Dec 2020 23:21:24 -0600
Message-Id: <20201206052127.21450-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-06_02:2020-12-04,2020-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxlogscore=819
 lowpriorityscore=0 clxscore=1015 suspectscore=1 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduce the lockless version of netdev_notify_peers
and then apply it to the relevant drivers.

Lijun Pan (3):
  net: core: introduce netdev_notify_peers_locked
  use netdev_notify_peers_locked in ibmvnic
  use netdev_notify_peers_locked in hyperv

 drivers/net/ethernet/ibm/ibmvnic.c |  9 +++------
 drivers/net/hyperv/netvsc_drv.c    |  6 +++---
 include/linux/netdevice.h          |  1 +
 net/core/dev.c                     | 19 +++++++++++++++++++
 4 files changed, 26 insertions(+), 9 deletions(-)

-- 
2.23.0

