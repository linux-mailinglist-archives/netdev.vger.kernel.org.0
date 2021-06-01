Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0882B3972FD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhFAMJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:09:53 -0400
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:54368
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231201AbhFAMJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 08:09:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ne/F5W6UpoeoayP+k6cQ5dP7hXJ9u8YIrkmDimNKrHRDF7x7bSNwm1W8c7JlwOCxKqdKd+WAT7ryVFfAOBRlpKUJjq0rAO+J2PycoTKDbrzk7K4da7h2wI7HpwCwhP0cJ4ijsM1G5yHba2r/2uKfARGT+1AVTmE7qb6aT5itXuWA3HNsAQ4TWqTbNQa1ZnvwMH05dpGpyCXJlcIX+eIcxWW/BO0djn3blwr+XnPxrKJQrblMgQrQA4umD4jKtAe4T8+4823kdGIIg5KVSWKyFZbsPi2CxMybxTra/gT7aleoIKzmsisaNL/+f/1HZM+pIMQYjIqixnhGVHhQSfujpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21qtYD3KbEkkUtEsySYGSuag91s2V8KPuPailqiiVE8=;
 b=EUpFXbNQdzU4mVftTW5seza7+FqypeOYb5wwu0RXHnQS1pCk65oM1tQ8VGEaTe8YP6lvz8pk0dOcE42f9PDzeffRvs1ECV4HYS6Y2ythghTJD1Tc9rr8JhGenhjgaj2SCenCOVsyYlUd93m73I+GsTsSE9/927REZ4T+XlqRUTQJAh0BEwM57CNDbQ7dTTm3zXXIb/hHOdeprB75ChoOkP2eDVwBim4xXdTRFPneD8tEDn3miVs6ByRE5NkDwLbGgsNTxr79xnLKKcof4D+Y1ECoGCE2h9bFjbSkpgNABMFmM77/EBI+PYvq8m1M1pd+icUA8CISWdIuYosdvM7F6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21qtYD3KbEkkUtEsySYGSuag91s2V8KPuPailqiiVE8=;
 b=dGxlh4y6dUk5JmjWDlv5H1uDdML/B2d/OtDv00hQMuqFLsRDYNSrFdA6BfIuwI62JZUkmHVZg/euQsROtJ+mN42MwqrOdTdV1OnkWUron7BL3aF/KmZAl6/3HmgiOFNNfG8XV1q22oJ3U/NQpWyqNPKhgdtIvGv8i/hNPwKBjRBC0mb8MdJ+9c6p2LdxIV40TPmnZ46m6EI1JP7pQFlSy3nUz7o/yfgama4es6XWqIU2tWK6bGeNFitRlnhuiBxHsYkNPeUNKo6G5XBAoDeCGFxRTlmdxqN5kDDbaxTeJC/jKWKhHbo+oSenyDEY4WyidUrNnohcp6ShHZMTkVygIw==
Received: from BN6PR22CA0026.namprd22.prod.outlook.com (2603:10b6:404:37::12)
 by MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 12:08:09 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::e8) by BN6PR22CA0026.outlook.office365.com
 (2603:10b6:404:37::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Tue, 1 Jun 2021 12:08:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Tue, 1 Jun 2021 12:08:08 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Jun
 2021 05:08:07 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Jun 2021 05:08:03 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net v2 0/2] Fix use-after-free after the TLS device goes down and up
Date:   Tue, 1 Jun 2021 15:07:58 +0300
Message-ID: <20210601120800.2177503-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 143a1adf-367e-4b75-f1af-08d924f5ebb5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4206:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4206D4F466FA0A8FF244F9AEDC3E9@MN2PR12MB4206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9z6N+DWpnb2JPZ9DP8lwnb8hdL9tv6/xYP9Kt70f09LwaMUBrGznuavGBB1fKMEhvcu/9m/QyhGOO7Xl3fFYCYSOT727aO4gpLEW/jnuVuV+P9ndA5mlY2UQy1/yT1xmo5b1b/EcVMdITBEVdH8pHjy3czVIycbmimitix9CHJngMTBSdmLTGwkpwvguz2IZuIZ5mK85LRulpUYtBRuT7ttDS/tqtyEkuqkRbWd/qBliasjlQUQ8OtSnvGn+tO2uvq7z1vL2i9+OYdyd1xf0joUtdUJu+tnKJL1ctZ1XvpFvP6IXl6zIh0ROUZgHZonWY51YCchQc/jjlBBoZyBdvWh70dL6teRB09993uknO/zGYgXoa73jQYvglJ+tTxsELUR5x/h35LwhBYgzYumbFpHbNvhuiBf6l0mlt2TR2PoF0DdeLKVoiLJ0yUTfMwanY/Tk2jDIaDkpWGeYCLJx5eIV7OySPxkJ8pqZzEExxHLdR8mabnXck3cznup/mEJ6fqg5uHQ+ra4msiRGv5VG6sXUhIBLt3svqcTcMUkKCzimE6esQwxMwK3ly2tHqV2JUWLLDvxCRgjzCxjxC/H8/fZPqoLaPUXAt0c7iRTNYhOQRbbZc1+roF/aFSVxZclY687KOACw86czvyOoH5TSoCUIrGlDXijpbNOJ09mVie4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(46966006)(36840700001)(316002)(70206006)(4326008)(70586007)(426003)(83380400001)(7696005)(2616005)(86362001)(47076005)(478600001)(5660300002)(110136005)(82310400003)(8936002)(6666004)(36756003)(6636002)(54906003)(7636003)(186003)(8676002)(336012)(82740400003)(4744005)(36860700001)(107886003)(2906002)(356005)(1076003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 12:08:08.8121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 143a1adf-367e-4b75-f1af-08d924f5ebb5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series fixes a use-after-free bug in the TLS offload code.
The first patch is a preparation for the second one, and the second is
the fix itself.

v2 changes:

Remove unneeded EXPORT_SYMBOL_GPL.

Maxim Mikityanskiy (2):
  net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
  net/tls: Fix use-after-free after the TLS device goes down and up

 include/net/tls.h             | 10 +++++-
 net/tls/tls_device.c          | 60 ++++++++++++++++++++++++++++-------
 net/tls/tls_device_fallback.c |  7 ++++
 net/tls/tls_main.c            |  1 +
 4 files changed, 66 insertions(+), 12 deletions(-)

-- 
2.25.1

