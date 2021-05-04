Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D994B372FFF
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 20:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhEDSvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 14:51:53 -0400
Received: from mx0b-000eb902.pphosted.com ([205.220.177.212]:36652 "EHLO
        mx0b-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231947AbhEDSvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 14:51:52 -0400
X-Greylist: delayed 1640 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 14:51:52 EDT
Received: from pps.filterd (m0220297.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144I9FZQ028304;
        Tue, 4 May 2021 13:23:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pps1; bh=8iNYorplWhEtYzy2kH7zXs3Mm5yOXeiK29CMkgf43V4=;
 b=jGNBDbIxNhnmUQ9EshosZcYvtJE2h7joP25r6IVRRcpVlksy3Cn5MFPT04GTY3Jw/X0d
 GoMl1xr/yfT8jxd/lBrVPsa0J+fHGG7IussM3Mov/Ugi+rdquF5z7RUKBUXFbYhpeOdw
 +FMhjagLOhBjqXGJKDsQ1LGtDWEshsfjfIOye4WXuMJ/ru4mNAFFZoynR7P0yLgwR4KS
 J05VoA8s48DRcQTRFuyZAd4+EXn2V8b+AHKFlB1GrndEUyij3wSFDB1je/D54tBENABH
 HsfT88/XgLjtKtiGXppGj6WqK0tZrlrAPYR+lAobcOGGUJM2KdX8ZR0TxIPo9X4i02Ox 5w== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-000eb902.pphosted.com with ESMTP id 38afvgah4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 13:23:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eyef7/2vp1DI+E/5JBH4c3qjGN/qctfwoZDaWxKcjnK4xVqUi0wbWenntGnZFVuFsWTfizTYzEdpf6QQ0A1xYBCxlFP1L/VCEC0bXCQhLyNRzFCkx3PlQJeIU+LcJQip1QfMRYZJiBxdCYG48/kV6DxqGtVwVYdRHNovcbH9fyoaclWy9bsWk4utKQMYc9I6OJFaHiZfdDTCF+i05HLjFvgNt8Zy873lCtJ5a0i486YMKl+iTiNQdFiCPfYpAx3yrLuLOpra6h2RmpF7HDerU3c4Wdpkihm4OytIzf/GAfKV6mUwU2EzaHZ+Awj9lwd9fy8R0Zy/WQyy5WOx1L7/+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iNYorplWhEtYzy2kH7zXs3Mm5yOXeiK29CMkgf43V4=;
 b=lV5ppuLvs0/wKg7pDLC/3oZjXm6Ae5yYiPSpR2SbqNdP+1MOT4T3qvnu1z5vJATXQ0wXdqZzlepqjNH6j8TvJNP8aBTcyVhHtr6IVXJMhhe+fvkGeM+Ll5LjuVJO4gh+A4WMyan5xAk0EAWKbAqi7XfEMmCo/BRkYrqkB3WGGzBerrEw7pqWeo1RoyZtcjQlVllpw8w6tXetIVaqKUksIRDO5z93xNZPjXR7zXL0sbHyyAuFIz1CZ9LpqO55BXzW/tcf6w4ad0KlQT8TyaFUmT7JDi5l6vrBD0fjwEs5AoxBNqF3uTq2gZpxNBpuESKbNKE7rHDZZP1fPwuHTdOqGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iNYorplWhEtYzy2kH7zXs3Mm5yOXeiK29CMkgf43V4=;
 b=n1CzGvq5Q3MLlXWtyhcqdOawaU9z45soeUxzPkec8AklZQcNgbX/rs6zMadZjH0xpVhsKJNSA4ozFBTEXB1lKzWjH0lTbcjPr5cKIkcj18itUwQtQe61zOMLkzppZBMqm4hvg2fyS15iSKl284ce/sfCX3NaxcEv4OTLo82UDnwzUDBbDEHTl8eL6joxVF5d6/TMUGrYZuzeBhQoBbz8fYk8m9WQPOuq2NzqIWe3eMqQrtIAxZp+URrI5kJ7AGO3W9wZOuoW9g2czWIKC5LCn3g9xx1XAH+EJqdhjMXc4LBWEyKqLZxlKeCoNJ3t9R2iNjxjK40fZKJ9FPUFf2keKg==
Received: from BN0PR04CA0111.namprd04.prod.outlook.com (2603:10b6:408:ec::26)
 by MWHPR0401MB3578.namprd04.prod.outlook.com (2603:10b6:301:79::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.44; Tue, 4 May
 2021 18:23:24 +0000
Received: from BN7NAM10FT051.eop-nam10.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::53) by BN0PR04CA0111.outlook.office365.com
 (2603:10b6:408:ec::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Tue, 4 May 2021 18:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 BN7NAM10FT051.mail.protection.outlook.com (10.13.156.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.27 via Frontend Transport; Tue, 4 May 2021 18:23:23 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge2.garmin.com (10.60.4.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 13:23:19 -0500
Received: from huangjoseph-vm1.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Tue, 4 May 2021 13:23:22 -0500
From:   Joseph Huang <Joseph.Huang@garmin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Joseph Huang <Joseph.Huang@garmin.com>
Subject: [PATCH net 0/6] bridge: Fix snooping in multi-bridge config with switchdev
Date:   Tue, 4 May 2021 14:22:53 -0400
Message-ID: <20210504182259.5042-1-Joseph.Huang@garmin.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) To
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5c72fbe-63be-404b-6d8d-08d90f29b41f
X-MS-TrafficTypeDiagnostic: MWHPR0401MB3578:
X-Microsoft-Antispam-PRVS: <MWHPR0401MB3578959F48DB8BA2309CF79EFB5A9@MWHPR0401MB3578.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JldXo1+Km7jXtw6EYFAU77htcplT06psfiAueBMYaynnPmceQObBW746aZuYdVig+DrJAFxMrRaiwFEX6najLq7dNBAkEoM4yMx+3osJu9H8cYCMEjqwm7bGJAYx2apzcSzwBkVDbr8THSlyTSBCiVdyMuUl92ExJ1M0IMU4mrsnMvllh3vAW4oFf+8MARmoZegAAL18gwK4n3wcXAyXYiQihsfrfHwXiJGS98i9QoHBMD5MLaqht9l9MioKFWlxbWnVTngGk5/Tqh3hoi2gZ3uIx3BqKJzZP5OYcsVY3vYYaz1YW/WFx03ADxj4lOgXsekPIMgOjfooaSD2PhvO3dtPq4UkEGZcwZCwMFLvyrmkjbKzSr7TdmTGlWDo1DLRtL6pVezFumueNTEDSnYceq6GziIL5quVLWJBpOGhI07s/PrgE2qu4Yc8kF0117qXtWFsOiG3TR+wFWtARD+g2Ktoc0+2aPDkLSHC+aI/6VtBsdlcFTt38sJ1+nP6JQjiIngopDe1AVKPPNgqyvzEKlIQIhVaoM88+TEfN4o7vkFkz46avVYch7mNmODnwSGTLidr7FkV53dBs3yFZYC5PGbS1uebhYzBjfuqBaeA9/fV3DJApqM9CrJ/bbDdUX3AvTHcgvJkQWVCfSces1Y1xryelZPWwGXHMuBLQmvay3k=
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(396003)(46966006)(36840700001)(426003)(86362001)(47076005)(5660300002)(7696005)(2616005)(186003)(8676002)(8936002)(336012)(356005)(26005)(110136005)(7636003)(316002)(2906002)(478600001)(4326008)(82310400003)(107886003)(36756003)(1076003)(36860700001)(70586007)(6666004)(70206006)(83380400001)(82740400003);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 18:23:23.8630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c72fbe-63be-404b-6d8d-08d90f29b41f
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: BN7NAM10FT051.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0401MB3578
X-Proofpoint-ORIG-GUID: c4QKdp2hXUo1WATe_Zj0BgqvFtd3V4ns
X-Proofpoint-GUID: c4QKdp2hXUo1WATe_Zj0BgqvFtd3V4ns
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_12:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 clxscore=1011 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches contains the following fixes:

1. In a distributed system with multiple hardware-offloading bridges,
   if a multicast source is attached to a Non-Querier bridge, the bridge
   will not forward any multicast packets from that source to the Querier.

                    +--------------------+
                    |                    |
                    |      Snooping      |    +------------+
                    |      Bridge 1      |----| Listener 1 |
                    |     (Querier)      |    +------------+
                    |                    |
                    +--------------------+
                              |
                              |
                    +----+---------+-----+
                    |    | mrouter |     |
   +-----------+    |    +---------+     |    +------------+
   | MC Source |----|      Snooping      |----| Listener 2 |
   +-----------|    |      Bridge 2      |    +------------+
                    |    (Non-Querier)   |
                    +--------------------+

   In this scenario, Listener 1 will never receive multicast traffic
   from MC Source since Snooping Bridge 2 does not forward multicast
   packets to the mrouter port. Patches 0001, 0002, and 0003 address
   this issue.

2. If mcast_flood is disabled on a bridge port, some of the snooping
   functions stop working properly.

   a. Consider the following scenario:

                       +--------------------+
                       |                    |
                       |      Snooping      |    +------------+
                       |      Bridge 1      |----| Listener 1 |
                       |     (Querier)      |    +------------+
                       |                    |
                       +--------------------+
                                 |
                                 |
                       +--------------------+
                       |    | mrouter |     |
      +-----------+    |    +---------+     |
      | MC Source |----|      Snooping      |
      +-----------|    |      Bridge 2      |
                       |    (Non-Querier)   |
                       +--------------------+

      In this scenario, Listener 1 will never receive multicast traffic
      from MC Source if mcast_flood is disabled on the mrouter port on
      Snooping Bridge 2. Patch 0004 addresses this issue.

   b. For a Non-Querier bridge, if mcast_flood is disabled on a bridge
      port, Queries received from other Querier will not be forwarded
      out of that bridge port. Patch 0005 addresses this issue.

3. After a system boots up, the first couple Reports are not handled
   properly:

   1) the Report from the Host is being flooded (via br_flood) to all
      bridge ports, and
   2) if the mrouter port's mcast_flood is disabled, the Reports received
      from other hosts will not be forwarded to the Querier.

   Patch 0006 addresses this issue.

These patches were developed and verified initially against 5.4 kernel
(due to hardware platform limitation) and forward-patched to 5.12.
Snooping code introduced between 5.4 and 5.12 are not extensively tested
(only IGMPv2/MLDv1 were tested). The hardware platform used were two
bridges utilizing a single Marvell 88E6352 Ethernet switch chip (i.e.,
no cross-chip bridging involved).

Joseph Huang (6):
  bridge: Refactor br_mdb_notify
  bridge: Offload mrouter port forwarding to switchdev
  bridge: Avoid traffic disruption when Querier state changes
  bridge: Force mcast_flooding for mrouter ports
  bridge: Flood Queries even when mcast_flood is disabled
  bridge: Always multicast_flood Reports

 net/bridge/br_device.c    |   5 +-
 net/bridge/br_forward.c   |   3 +-
 net/bridge/br_input.c     |   5 +-
 net/bridge/br_mdb.c       |  70 +++++++++++++---------
 net/bridge/br_multicast.c | 121 ++++++++++++++++++++++++++++++++++----
 net/bridge/br_private.h   |  11 +++-
 6 files changed, 169 insertions(+), 46 deletions(-)


base-commit: 5e321ded302da4d8c5d5dd953423d9b748ab3775
-- 
2.17.1

