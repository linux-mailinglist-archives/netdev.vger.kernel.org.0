Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8903EF095
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhHQRGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:06:01 -0400
Received: from mail-sn1anam02on2070.outbound.protection.outlook.com ([40.107.96.70]:24261
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229723AbhHQRGA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 13:06:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3fQHOBWe1E+qT6r3QB5OfUBSCZxaaJRbL9s2HmAIIXs3uQzNdInfasssF88N3EADxKbjYzecpBUCvkdUtEGVUIJIctiEQ9R9V2K/xY2yUISqioqHB9Vde5e3d/2AkNRsvjeMIYXfb53S5pV+9P8Zav1QoDHH1QzGZxXvlfYILaU8KQcQ8EEQPbyZNqTSzh1ON+tKmNvnGNntXyWpwrpP6MeFowHm5vbXcjPCq7ab8lLCxfVgp6hJzvrxTwowMkpIv8QgtNED927lLPBgLmv4KntupmkEiLY0H9t5y4Wplq2P8brtePD01suf3+3lBFvgYZ+oaYKEMvV79Mjt8TeSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Nn8t5Cy2owE1iFFXS1CdAupg7wB/MjpZ5G38ylW/yw=;
 b=DsKdWb7jd6gkCMO89ODkFvZBv9I2Ou70hOkWF2FMFO5riQJc8xySUUWCGDPcXNXNi2BaDPFZJkIx5woW/j+drztpbjxEP/eVRKtQieVcBvZZQlOlPqFg+67zbSYme4IPo6IjDMx/qM8iyPT79tuiLem1x6SA9JH7rTm6mrYOBEFrcaaEj3adP5rdRULdmlpT8//hcQayT8sF23oq82VAUxpz+rHherm/zNIe+LS21xk5iktu6D/2ko854UwMFoDrM4hZOqYts0oNK75JFR+BQ9TrQIwFIMla/OpGtT86JR6j0+TBMT/etgADbJ04SDADLH6kD/y//VkfN5UXtHbK3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Nn8t5Cy2owE1iFFXS1CdAupg7wB/MjpZ5G38ylW/yw=;
 b=FeIwPF79kRusLRg07yWi/rWK+3S4QYLtLd2eDpcRNRpKbIPgAZMIygDp7S2Kt4wHIoNEmHW0KZd4QsvhwdZ9+17yCFe8354yy7rfsWiUIIQJQ2LnaaA1pR/qCxUQ4xUDPM1krID26l7MGzxKo4Ad6uPZgxaBaPGtqx1oQoJiiCco0SefQ4afcfkkPuw2moDd/q/cEKzm55aRLUgFm/lqyk0T0S0a8Gzomg6a7yCc8eXhmqaelh2+ehIbEcnwRHTWvFqbQPGJPr6gR3T8T2TtvffAO+tqcPVcBC7PbTtgTJ3QuXZETXO7tA/BxjIIonqujKBVgO3OhRIOethwJ2n2jw==
Received: from DM5PR18CA0076.namprd18.prod.outlook.com (2603:10b6:3:3::14) by
 DM6PR12MB2713.namprd12.prod.outlook.com (2603:10b6:5:4c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.17; Tue, 17 Aug 2021 17:05:26 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::e8) by DM5PR18CA0076.outlook.office365.com
 (2603:10b6:3:3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Tue, 17 Aug 2021 17:05:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 17:05:25 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 17:05:25 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Aug 2021 10:05:23 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <elic@nvidia.com>
Subject: [PATCHv2 net-next 0/2] Indirect dev ingress qdisc creation order
Date:   Tue, 17 Aug 2021 20:05:16 +0300
Message-ID: <20210817170518.378686-1-elic@nvidia.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4deceb80-1724-4b6d-05b9-08d961a13508
X-MS-TrafficTypeDiagnostic: DM6PR12MB2713:
X-Microsoft-Antispam-PRVS: <DM6PR12MB27133CEAF6B4CBA0F2EEBD07ABFE9@DM6PR12MB2713.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RVzYOLGMRiESnvdBqE8j65ZyoEnGXaJ+1O9cwIzME0eFdiN6Vpxqj+eZHBQ4Y5pSauEDVQnJR+/ADEcwhP78/YkusSxHgA5nCF5byztITU4yYzT1z1OqxLL+Y99imGnLW7B4VeeS4/IETO6JNWxFIrm0t7xmbFi7YVbDvvDIoToMJ5AxLjlTeSP1okRoJ9wRKRXvYteroWLXcB2TCV6/01ceoN0PuBsSAKyOeke3s63sScMlcldF2VdpZ1UeevBYih3SCxOPI39oFoeura4kmd3S5SwZLINDuZGhkimAQayPk8OFrE9sLjcuse51TW9OGQCTVpTtYixkLL4A24UAeeMhqRSG2mbPrlltjoEtVfSSEm9JvU55HKlohv/b1TJBmYypLhgSlrhoSShrAJVeGKsofv4AhDXHV2KXs61vRDERsstQp+EbaxcTB2yZ45HUt+Wuzyt8FwqaLVguH6jI9QOGjbNuQqNGxLqaeYf7Stc4/IdBf43gpmrvxkYBDyZHjk3kc8XDOUPvBZuSjIPd+Cg9lgFb0kghakembVJ6sD5DuZR5jMFuB7xLVPn+TvICQSx21YnPCCknHL0GXom1/5JueZZtbiDCfYFPWXO7ppTPcPI9TlI+Fgkcz+zgw8Tj5ZyDWC+loy91O9TNZzLODHraWyWS5+E6c90V+K2YkqWkMtsy51G/wqG3EAjas0vGqy+jA8Ow2PARgIIeh+YCzg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(36840700001)(46966006)(8676002)(86362001)(2906002)(47076005)(6666004)(8936002)(82740400003)(356005)(426003)(83380400001)(82310400003)(36860700001)(2616005)(186003)(316002)(7696005)(336012)(26005)(478600001)(107886003)(5660300002)(110136005)(1076003)(4744005)(4326008)(36756003)(7636003)(54906003)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 17:05:25.5913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4deceb80-1724-4b6d-05b9-08d961a13508
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2713
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch is just a cleanup of the code.
The second patch is fixing the dependency in ingress qdisc creation
relative to offloading driver registration to filter configurations.

v1 -> v2:
Fix warning - variable set but not used

Eli Cohen (2):
  net/core: Remove unused field from struct flow_indr_dev
  net: Fix offloading indirect devices dependency on qdisc order
    creation

 include/net/flow_offload.h            |  1 +
 net/core/flow_offload.c               | 90 ++++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_offload.c |  1 +
 net/netfilter/nf_tables_offload.c     |  1 +
 net/sched/cls_api.c                   |  1 +
 5 files changed, 92 insertions(+), 2 deletions(-)

-- 
2.32.0

