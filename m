Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E0A3EED46
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239865AbhHQNXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:23:44 -0400
Received: from mail-bn8nam11on2080.outbound.protection.outlook.com ([40.107.236.80]:24673
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235463AbhHQNXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:23:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEJ6ZZuGMDm2jQtZdH+6Eu5CkOrvrh53wn6Lp5+aO5cYsfKMpiMWLc4+l8EuHXt7058AacDeBXmRkVqUBJIronvWw/170znrCi4N26fCW0qLJ1pyJfasuOXZzXU0lq6c80EOIDUWNPxnP+Wm20zQMtonIJKH0ohEheEQ6gJViZKP/mW+mZAL/+nHbfOzK4vhFjiH9f72jtGQhKr5kYm48ousUrz6xzOjnS17hs9LKvxHZV174JO2zoVesg9ljUloMlgI4rZMlNvWb6CwKuskJfIR9Z31pdfN+VTUv5l72sIhhKk44wqPDJgBU4vvv1D1K5ZkZo9LdmWnu9+Ex1F4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InKcy53BwtY7WozzMh1EJUSGK6wDWqcuOVQWasYaNQQ=;
 b=lAlL3NlbrfacsU8dxaR7gviKsjVqxZagKqtgHlaUgW9+N289QMU8O1RRK73p6D90KTdqHjVoUkOrOfHnrEH6vAjDsrXS2k1oNY9ENxz92+5MpRjwN71f/K9dsy0NHGiPCh0pwhkfV6pw2whJmrQK3onRUABGIh+6Xo8GVMw0pYzJOmaQ3EQ/iKuH1G/ebJ/FGmBGJyCk7ONKDgKTk6xQcgOZkZGRUjpBm/p1dxfqtfb5aG+wlw+gm3bHV+tvVvl/7PTvSFtihPI9fV7EAQ7cOTmUKj9/3tPZSXH5G0H0fiwB9ab/10Nc9/vtCC/3rcglf1L4FhU/dbJaKsYHhuOA+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InKcy53BwtY7WozzMh1EJUSGK6wDWqcuOVQWasYaNQQ=;
 b=oyqhBITVcZWY1v4103ctE2yjXivDW5VkIfqm75TLEBm76gPr9Dz1wwVRoGH4XpDJZmDhQNe7CGFvXh5Ed3T37+zginS83zsqXHxs1tOHViaEpOPN04/IOac/ZjxuBqLN2vA0kOYoW19GxWUEAR5BZIl9RjYcs0iVkHCyAnDKGSMfaOdVtizc7c8N1tY5X7B9S+ssdN9/pwISEgbrgJO5Yx7/jhZbtytFYc44uu28+l8Iqt17VPzd11t+QgyDSpB/k+nuNBb1mPOLhVs8qYrmEevgH5eB9GhyZclzqUvEO8k+eoPxoJhL4pHA2zxcVHo5kOhLKz3lxeDgV5QwzGGHHw==
Received: from BN6PR18CA0022.namprd18.prod.outlook.com (2603:10b6:404:121::32)
 by BYAPR12MB4725.namprd12.prod.outlook.com (2603:10b6:a03:a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 13:23:06 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:121:cafe::f3) by BN6PR18CA0022.outlook.office365.com
 (2603:10b6:404:121::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Tue, 17 Aug 2021 13:23:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 13:23:05 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 06:23:04 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Aug 2021 13:23:03 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <elic@nvidia.com>
Subject: [PATCH net-next 0/2] Indirect dev ingress qdisc creation order
Date:   Tue, 17 Aug 2021 16:22:15 +0300
Message-ID: <20210817132217.100710-1-elic@nvidia.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bbbaf72-6129-4452-0832-08d9618225d1
X-MS-TrafficTypeDiagnostic: BYAPR12MB4725:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4725646F7FD440B570C6B15EABFE9@BYAPR12MB4725.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/geddLY6Uu5XWVXN8a/ReIKrEmwT+rNcTA/yGkEPrtrDMWl23/5rw8ZHVN1ikhEvNVhiSu/TVnC1DJ0PgVUNIcobAc3u9EY545AkovTQCchk8gxx1EOf8eQ3yRQLFwUKzzKUNyeIwraRut6ZXk7bYsjjBzSymCIgzjg14rWJBQsb9P4KCm5cEodCwuNZAd3gQVaCBUTv8POdwVhJU/0gMksZapIfPV8yzmvKPbdKVLoSVcP3KvoaBRrQ4pws3Cvpg3SmACKGvkAwTpJkpKfdnBS+Zq2b8mdqp1e+s4feysAJPEV3cLNbp6L5szzwtmbUA2vRsfrFR3rdsvfrtmBzOR+pslH6tztZZH84b0jx83Jy1Va8/KkdINTBlr/aOtYg4kO9naig+ZxRLeX2m/shhzpoETJlUbZIGLkVHJdlW9ixGdAL+JTdfPr3+oIXlGveVcDROqKUigmsMqhmfiQorVuV6M7UEQeQf4G7fm9Awr1kPHp+McJqRViVVuQ4Z+6jDtkqQuwIzev4I2o6QiOe3JaSELJgdyRBX7B30fZF7jtS7ovC2yWc+X0cD2IMHzCZULIzUQ+VOKMXrdNcCH7yTtY6cGUBx9XhXud3HkA496Vm51ed4nZ6WxARUto1eW/0BfApZkupnZ2b3fERp6v8xckCqYzjTqwTPfggS3ywOBB21sTJV7cV+h2TPytcGpJvp9gv7qq2Wc/tpwuUkonGA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(36840700001)(46966006)(70206006)(70586007)(2616005)(2906002)(26005)(336012)(186003)(8676002)(5660300002)(426003)(36860700001)(110136005)(107886003)(478600001)(8936002)(54906003)(4326008)(7696005)(82310400003)(316002)(356005)(6666004)(83380400001)(86362001)(1076003)(4744005)(36756003)(82740400003)(47076005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 13:23:05.6075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbbaf72-6129-4452-0832-08d9618225d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch is just a cleanup of the code.
The second patch is fixing the dependency in ingress qdisc creation
relative to offloading driver registration to filter configurations.

Eli Cohen (2):
  net/core: Remove unused field from struct flow_indr_dev
  net: Fix offloading indirect devices dependency on qdisc order
    creation

 include/net/flow_offload.h            |  1 +
 net/core/flow_offload.c               | 92 ++++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_offload.c |  1 +
 net/netfilter/nf_tables_offload.c     |  1 +
 net/sched/cls_api.c                   |  1 +
 5 files changed, 94 insertions(+), 2 deletions(-)

-- 
2.32.0

