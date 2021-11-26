Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DEC45F344
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhKZSB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:01:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233429AbhKZR72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:59:28 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQHpoZF027425;
        Fri, 26 Nov 2021 17:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=aFlVky/IoKDPJd7bE3ETQVZrISPxOwThqn8RLLkZwLY=;
 b=JtTZfwMZiCzjmdhWlkmXZLFUTvWEL7BgljsNED4k3ul2rB/NVN36GYapopLKeu+Ogik1
 JFrYhsFSgacFPdbHpRjE1k6hLyzGNkvPl6CTuM9W4JAguDZ1Rcs6Swt2easLk7XJfyqz
 hTXRLccETW/UnTfGw0Jl6+1h6s5KbfMgzDYmlnjMHHTtdj+yRf09kFcJeDuHAmMUkdHp
 aSKiIOYrynysSV4ikhWg3nF8+L3nBRxJlsMNfxR1KPqWC+UdQajuBfV8JG80wYZj1cx9
 8PmnHaLW9AYKaGzcBBxqLekimysXX20jr/XsExj0krr9Ta1Z+HB/65R5NW8cqTPyQZzp lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ck4bv814a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 17:56:04 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AQHqc28002299;
        Fri, 26 Nov 2021 17:56:04 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ck4bv813q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 17:56:04 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AQHrRG4014476;
        Fri, 26 Nov 2021 17:56:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3cjm1fq0fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 17:56:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AQHtxEj787106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 17:55:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BD974C044;
        Fri, 26 Nov 2021 17:55:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 069A84C046;
        Fri, 26 Nov 2021 17:55:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Nov 2021 17:55:58 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] ethtool: ioctl: fix potential NULL deref in ethtool_set_coalesce()
Date:   Fri, 26 Nov 2021 18:55:43 +0100
Message-Id: <20211126175543.28000-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XK4HXu8W6j5wdtUYc119KzWSc7C5jv9C
X-Proofpoint-ORIG-GUID: ILXIq4UNUp4Kob5CEq-4yyzMWlUnyWx7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_05,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 clxscore=1011 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111260099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool_set_coalesce() now uses both the .get_coalesce() and
.set_coalesce() callbacks. But the check for their availability is
buggy, so changing the coalesce settings on a device where the driver
provides only _one_ of the callbacks results in a NULL pointer
dereference instead of an -EOPNOTSUPP.

Fix the condition so that the availability of both callbacks is
ensured. This also matches the netlink code.

Note that reproducing this requires some effort - it only affects the
legacy ioctl path, and needs a specific combination of driver options:
- have .get_coalesce() and .coalesce_supported but no
 .set_coalesce(), or
- have .set_coalesce() but no .get_coalesce(). Here eg. ethtool doesn't
  cause the crash as it first attempts to call ethtool_get_coalesce()
  and bails out on error.

Fixes: f3ccfda19319 ("ethtool: extend coalesce setting uAPI with CQE mode")
Cc: Yufeng Mo <moyufeng@huawei.com>
Cc: Huazhong Tan <tanhuazhong@huawei.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 65e9bc1058b5..20bcf86970ff 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1719,7 +1719,7 @@ static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 	struct ethtool_coalesce coalesce;
 	int ret;
 
-	if (!dev->ethtool_ops->set_coalesce && !dev->ethtool_ops->get_coalesce)
+	if (!dev->ethtool_ops->set_coalesce || !dev->ethtool_ops->get_coalesce)
 		return -EOPNOTSUPP;
 
 	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
-- 
2.32.0

