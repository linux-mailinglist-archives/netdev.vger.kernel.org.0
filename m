Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9B83AFCB6
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 07:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFVFpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 01:45:12 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:14465
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229677AbhFVFpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 01:45:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kc9QQ4NAF7caSQaEPXoPMCYV3qPSUHgVHqgZkutfxX5wqUfm2McS1bYJjwDNmbg8DrRDfEY0onkmIniYWVr8OcdvWlv1HcVtTKetl5kxTqF6T37MMZdUjhYSYOoSDaU2E79ZuTBWmpSfcLAy2TcvI+XIc+EnC2+AAeQQDSYXpTs/NaIeelFeQsrEP9PLkZW8Xc0P38ZUrX6YEiffhbCueQtkMgwTR7p7HzPrqrIDcFcugYt7XBEWIpc8LEJ4YuWQj1kH2Wf8by35ljF043ka5ZnWSi8sjdf4tdTUGlKSvBcwZJZPAy9QplqQXJDkWSplUNIfKtOwOEIgEbajDaADDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rVfSO1yMRBnTmIn9C/PUWXZe6rqc0XJ6vVQf/i+vpc=;
 b=QOte3uq54HKD+sSFzgZGRThutfBvJSYjoodEPd6z56zWO81hNnYx+QnPGqE2tMmljNrOaoNTOUblsWVn3Nvui613JhEGlFQOBW62sx0YuTfv5bp500iQr6szrk6UCYtjSIsQ1Q2O2gN8n2SHTBw6mrgTMWAAeUXIQ2Sx0j3PsqzpMsNV1JvbqWHXoXVoFHXV3Xf2nZk/mfXYZ9qkPUeHyvY+kXg2UTsZNDTJgA8OpXUNE4jOXt18LxMp4Nh1msaVIuyMwESV//tnh7EpEh73DyENGENPSxT5QozLDs84XtgEntYiqGT033+BR2ZdIsuRxbOhN9iBCVUzddtnGt3tpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rVfSO1yMRBnTmIn9C/PUWXZe6rqc0XJ6vVQf/i+vpc=;
 b=eMX8Ry+E5aEpofl4stQYnaxBQGju67PXgDgpuqAmVHDDu6p1wgk1LpZ2idRr6EeBNrC6YD/MOGMgUW8drgEszF/0VyebkGHtbWzUP4sx2mDGMi9ScQofFS4EZ587HebevfSqgyHukcR9m9HEgQjGqsvHkWhGsjfvRmzNvJ07wHplmcinQkfxr8r5pq2tuP6hMUmGQ3LuiAYt90sNY3gvQWJh1TYbq1sVUiiHRVk4FNkScWYlE+vS/BV7uqAWqtGXixDqXAht5It+7JO0eEzZgmDiGLwoG7iTk316ZRG4camAK29DNOZgg2q0PGW4F78skJKwmTrAbu+ixdeTTMLF2g==
Received: from CO1PR15CA0049.namprd15.prod.outlook.com (2603:10b6:101:1f::17)
 by DM5PR1201MB0251.namprd12.prod.outlook.com (2603:10b6:4:55::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Tue, 22 Jun
 2021 05:42:54 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::f3) by CO1PR15CA0049.outlook.office365.com
 (2603:10b6:101:1f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend
 Transport; Tue, 22 Jun 2021 05:42:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Tue, 22 Jun 2021 05:42:54 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Jun
 2021 22:42:54 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Jun 2021 05:42:52 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, David Ahern <dsahern@gmail.com>,
        "Dmytro Linkin" <dlinkin@nvidia.com>
Subject: [PATCH iproute2-next] devlink: Fix link errors on some systems
Date:   Tue, 22 Jun 2021 08:42:50 +0300
Message-ID: <20210622054250.2710106-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7d20d65-74d2-47ab-2217-08d935409538
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0251:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB025117EEC66602C0F1EC58E7B8099@DM5PR1201MB0251.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNbJZgFNiLz58AQSrHT78ZN37/lKgERvchwForPdjYIKuvAbSyfNBzNP2yS553A/A/Fg38HsRUMDeKQZaVE6WsOW5dfHTHQszyyA/hKm/y6MzOEHmz3xLBlcDWkDryEaTwXl6oDY1D01X7LCnjlKfhOO33EubboIY0Vwvy/j6T4YlSQVleTt0Am/Zu84vB0Rx3Ii0YUZCTohlSHn3+zJAXUUt+hFchuOxf5pFLsyYCSxIksyK6wMnoJ9cbOTM6qX+zWSSObGEPtviNhLHUKQThYKwPt5yBD9rNEEzP3Vl/Ajdc8/5CqPp11VhIUgYGw+041Cpneg8rNU3N2zniwINVByAqHrnltVwCv9n5Zs/WbAefRoPoPG27KhO87hwH9AKAVyz/Rs1T4Ck9A3BKO4UB/7aq4t4Do0TNL5fD0Eyws/Gq0J2kmEIfjpa6tgHkfvVZezqbzF4Ca7QRmywzc/6bzIfRVShCoT3zwVl03dkVnQlo2QjihXG2Kdvv6We06yGzcIF/8WqwdFzl+C2/LJUUVrNXFq7OB/S6J3JNgr4yrQClzzFMYAZCGCRe969Z19J3G2GUXuRN/wR5Cj2ihcHXRJ+OxAUmqL52+bvp0ZMxA/wIhbNxZhucZ7NtKuVfJTcqkufn5+ISk3sXuFxDfwcrZDcpNVHhgDEUp+HRtOOW4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(36840700001)(46966006)(36756003)(54906003)(82310400003)(1076003)(426003)(186003)(70206006)(8676002)(316002)(2616005)(107886003)(2906002)(4326008)(478600001)(7636003)(8936002)(86362001)(82740400003)(26005)(4744005)(5660300002)(6916009)(36860700001)(356005)(47076005)(70586007)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 05:42:54.6249
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d20d65-74d2-47ab-2217-08d935409538
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0251
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some systems we fail to link because of missing math lib.
add -lm to devlink.

    LINK     devlink
../lib/libutil.a(utils_math.o): In function `get_rate':
utils_math.c:(.text+0xcc): undefined reference to `floor'
../lib/libutil.a(utils_math.o): In function `get_size':
utils_math.c:(.text+0x384): undefined reference to `floor'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:16: devlink] Error 1
make: *** [Makefile:64: all] Error 2

Fixes: 6c70aca76ef2 ("devlink: Add port func rate support")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 devlink/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/devlink/Makefile b/devlink/Makefile
index d540feb3c012..d37a4b4d0241 100644
--- a/devlink/Makefile
+++ b/devlink/Makefile
@@ -7,6 +7,7 @@ ifeq ($(HAVE_MNL),y)
 
 DEVLINKOBJ = devlink.o mnlg.o
 TARGETS += devlink
+LDLIBS += -lm
 
 endif
 
-- 
2.8.0

