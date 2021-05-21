Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0809038CB8A
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbhEURI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:08:57 -0400
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:3872
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234071AbhEURIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 13:08:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eomM/HZ8c77B4ulLBvbJhAYXrIZVkh4vSP2a1mmaOAqLRCaHUuq7bwQwbauuVUdBRBaNSckrh45l+BhFCSaXybKuofViDg7EUGB8vaOBKcqpo/e2lnQNRbw3TtqaPSA6l8kaUJcpf9co2DLDWPu9e2LlO9F8BpoH68nUPVzYv2zjpyRJ/v4tVzo7QBb2EOmRLIr6eHTOVJMDXoxfiHb4tCb0q+FwGK8qK+MNeVRgSoXNBW7+oUIbbtGqNofZogh75yZeyPimC/8TyfzB5/wGIamyLjkAGGgsHfobB7WKFBQbfMP9cohzpbdn6aUQoFvc2KGqTT6T8lqKfiPN1U6TOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ans+1wp9KmQuaOQv+yi2nZKdOvgw5od1B40BT7B4c8=;
 b=K1Qu90fY7ujPTkLooY81J2u4RbH4J4eYA67moXf9yaw/J9teWOuPxGqACA3sS0hxndFuKkVI3iLxYWvQQ4wX0fVXKgr9fcXhPc5poe5T28/j/QR9+d0eYAW1Am2Ov4pyCriElNmdKI7438K/LkromCJR+STD9NYB2w+GUSfuiUhcGGOIA5p2YzqQLRF3WN9UFAVx471i2wovOSx4ec5pgQGTj5wXj2cp4gw1Sk46ifYZ5TbaQ4n2Aa4nzpr57vZGX4SNhlPKo72ZB1mmB9LJL/X262sM7lftqlFBCB6l532Y1gJJsiKvwzDv0hURYHOSo+KnSmgAVD2xvQAqT9IGGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ans+1wp9KmQuaOQv+yi2nZKdOvgw5od1B40BT7B4c8=;
 b=fc4grocEZRP8Bdjegg/FM/egVU2mZ/NFF+A1plvN3+CRaH+qZQAOMMWdmovc1kqNdu1tHOV89X3eU31OtBgPh6qlDHvNiEEV2h26AlxcyOcuGAVBjdK2ETu1jIGS0z9yrzuZr2FExjiUeXunUYds9iwnCrR+PUtOnJSPrrEwURupzqOVmi5Xr/ae7MjY7HcK/E4L/YXJzb1OPDaHXBIZaJvqcZ0YZ7a6icL/X3YCLgJ+piCU4p2NgP4WFOTzCJM4FZGeSCkGeQw4PKRfCQrHUbgfEERehv1MbPsSMFpxCEmJr76iSWpT7gmnZERcOCAn0MR0apq/Q0UT16gAfBY/Yg==
Received: from BN9PR03CA0118.namprd03.prod.outlook.com (2603:10b6:408:fd::33)
 by DM5PR12MB2454.namprd12.prod.outlook.com (2603:10b6:4:ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 17:07:28 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::74) by BN9PR03CA0118.outlook.office365.com
 (2603:10b6:408:fd::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend
 Transport; Fri, 21 May 2021 17:07:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Fri, 21 May 2021 17:07:27 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 May
 2021 17:07:27 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 21 May 2021 17:07:26 +0000
From:   Ariel Levkovich <lariel@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH iproute2-next 0/2] tc: Add missing ct_state flags 
Date:   Fri, 21 May 2021 20:07:05 +0300
Message-ID: <20210521170707.704274-1-lariel@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d8833c2-3fa3-4782-534a-08d91c7ae9b7
X-MS-TrafficTypeDiagnostic: DM5PR12MB2454:
X-Microsoft-Antispam-PRVS: <DM5PR12MB24541AB57D24A06615D772CCB7299@DM5PR12MB2454.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jd+sDZ/K2qBHTBaP/UK+CWSklxtN8Lvm0XlxSss5Tikx8cwV2leynEsAMYVJh2QSMDOw4a1RhNDGs/RY5Cs2LgM+XwD9C47FwIYA240f8WjXGjUsjoeVBO2tRs1JGvdW8/OPgozdtgbXh3RmycwphzIYhbMUEZzYVR/A9h5Q+h2/m7A1NVggBwrJC+Aj/5RA9SflzaEkoIjT0Ib5YV5377ciwGjFhZOataPlCWr/oCjPZxkNoAdZjP+pi7vC9sCitlQIkfiXEOIoov8sHT0JXeDJtTo2p94Zz4NtBBa1WjUhcrcnV9x38XLFHMzg/oIgFOmuv86duudWEyth74tKN4CoI67exnDnNqt+rAUUIDBM9jC5nwA/VJc/RpYDeCNcangdJPcCIbW1LPbvLxE0QgrBcXPCOMJ5wBnQEHkKmc95jzAYZYvekdhacv1XjQYMH+L5LdbbWf5D1kMd9ZECDjVLEZE3XDFyAuu2lK1bOg0h87NnYf8k4eSwXUtAVz2WASqkBTWDkUkikR6VhGRvvqRoMaDhCaSxSsbAYsc34h46TaJrCq/O+7/PTCP+2p8EQI4ReZV4+DXTqSymjH8CS/3g553Aqv7Z9KLaCYEjhLGbCAoK54DiOUEpL1Qniaq1RQ+PipYuBF9CM6W4ZH6aMw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39850400004)(136003)(36840700001)(46966006)(26005)(70586007)(107886003)(2616005)(8936002)(6916009)(426003)(70206006)(6666004)(5660300002)(36756003)(82310400003)(86362001)(8676002)(186003)(4326008)(4743002)(478600001)(1076003)(4744005)(336012)(82740400003)(356005)(36860700001)(47076005)(36906005)(316002)(83380400001)(2906002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 17:07:27.9451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8833c2-3fa3-4782-534a-08d91c7ae9b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2454
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This short series is:

1. Adding support for matching on ct_state flag rel in tc flower
classifier.

2. Adding some missing description of ct_state flags rpl and inv.

Ariel Levkovich (2):
  tc: f_flower: Add option to match on related ct state
  tc: f_flower: Add missing ct_state flags to usage description

 man/man8/tc-flower.8 | 2 ++
 tc/f_flower.c        | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.25.2

