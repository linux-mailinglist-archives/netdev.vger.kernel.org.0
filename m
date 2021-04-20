Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1869B3659EF
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhDTNZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:25:08 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:50816
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230408AbhDTNZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 09:25:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDHyRgglcH3DBA2s8BZusIDTUXtMYC0vQqCUs3o41SatZ9QcHPmu/MdhF29IP3CZsGvlm2UswOHZONcL37qSNI/uj4vVDwFiIxDUAUERXzRYPfJGEs5dUCZg6PK/eFuAFxkZr6ePIYKJ9kxNLx62c302WWeIm51qxGdfj1ZgnsvhaXTVtW4v6h+bqp9H9oryJjql6WvmflaJuamejvRyaS47PTZ+/sUR6HRgx0GRDeeMd7PquVYBrlrseew1sw9JJG3/xp5IGdzd6KQjEhQllX2SJrL8GL8kh0WtySabzDEfALz0m0DFeF8PucYdGxdM8NSQQNLtZHsAjhHbvMEGjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+dqvTnjuEQpoFBzT4C8/GxWCKT7tY8+nDneVmp5o44=;
 b=MHaAXRYsa7C3fKRH0zW77YZttXjtMN5GnwuuKlyvy7eqnxbcFvWTKetjE7VqQWjqWwl0iB6p4CiLkTc7HJ776h8XnWm14B/uvb2R1S1dRFDwhloOqOyHZ2ljRG9BskNQCV+1sMg0YYdSMbAzdfGDVAmJE1y4bGZL9NtxYmpzVETvZf5IIIgnkzKQu9CsvPjAQ0nXD5kppiScb2qE2IlJibckR53SWzGSnPlV6XRERJ4sdXTibvYStc+q0+KpO84JYArkwl2cnTVzX1nhCydXUZcuE2R1nF8KGTjcQEzzwTenuo4g5n+XWKfMqWj95e4UuxyI61PF2vW4asoHMNNYJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+dqvTnjuEQpoFBzT4C8/GxWCKT7tY8+nDneVmp5o44=;
 b=qe6c/3/MFhKft8StWmDWHkQp/zyGiQCxgI+lwfR4cjVJuiMujFdWf9ZHFX/D5JqDkfYb4sOr2VpBnU1QpeF4bvPy7kB+51pZCL+WfyEERBBXbZs1hMR6RyMF02ufeMsYq0xaTqrFaiPWscCg7n9/QdHjKtFqTn8fDBC2motcv2v0KBTak1R501JcQ2pQxjukNhj3+QiDu76mfrKCviSIB1MZUHRbW9wS+2t9JkLBZLYV7vnLDeymcbGrc+SnEGnc/9d5M4o/roR8NXeOdOcI+4uYzlaPDOThnoORmK8f97xN+U85IT1bczE9CZTAk63vPsi8df8y0CJp3PsIiHuveA==
Received: from BN6PR19CA0119.namprd19.prod.outlook.com (2603:10b6:404:a0::33)
 by DM5PR12MB1402.namprd12.prod.outlook.com (2603:10b6:3:73::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 13:24:33 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:a0:cafe::82) by BN6PR19CA0119.outlook.office365.com
 (2603:10b6:404:a0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Tue, 20 Apr 2021 13:24:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 13:24:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 13:24:32 +0000
Received: from moonraker.home (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Apr 2021 13:24:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Jianyong Wu <jianyong.wu@arm.com>,
        "Marc Zyngier" <maz@kernel.org>, Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH] ptp: Don't print an error if ptp_kvm is not supported
Date:   Tue, 20 Apr 2021 14:24:19 +0100
Message-ID: <20210420132419.1318148-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 263aedb3-19c0-4a16-2de1-08d903ffa2ea
X-MS-TrafficTypeDiagnostic: DM5PR12MB1402:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1402C8DC73CD0FAC97D2FFC2D9489@DM5PR12MB1402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 63Nk6g7gVPZYq8bZk3rbYkxI8xLYwagTiq8W6P9AOZByaWOpkxfMi1qGinRbLtKh8yaZPAKpbEXjGiL+JOhAY3dLEO5NDMdG3cSxN8IY9jZm9JW3w/9UcpOVmYcrTlOZwVPZFu329htHeJVppJO0PudV+IrCWkOLE4q2XyvH1R4xh+tG5Y+Ju/lcxCMrkWmEWEVoIEV0aIvdAD/fBz+RJCufv/TyhVA/r6Lt5bUlIDOKlXcBJcQB1f5dgh18aH3YS9PSpjKR0UDQ/62nUqsoRU/XoRDblWYpTkZRC+/Q68hBmbR3ojZw5Da3Bqrtkii6zFL/zUb5dEu2JB48z2CBU8qK77gsBjsu2cOg3x6ElU5N39Q1p7KsoBOv5/5NY0NG5WjZMru0qEJCut6i9z7mvLft8Ez+OldJfTw6XMrSwgiYYgfHulG746rtvRZMhqPixozdPC3ihGNJ6qHOI/9j15EbM+dfoU7ceIW0v/efCtL4PYsJQmYX+B/h2hat8AAq+8B7RHYbiGFXyXyaBmzUBo66pxiVEijgWx0kHje36zZYWXu/uLfnXh38r0/8pEs7bXyendQ66MugG75EFYmB1ncj467yc5wPTbpmB2GBX8TX5aU6dPvzE7ppoavTjTwOuvrXUx6MdmBJ5ckE+I8SAA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(36840700001)(46966006)(8676002)(107886003)(316002)(8936002)(36906005)(1076003)(82740400003)(82310400003)(86362001)(7636003)(6666004)(2616005)(6916009)(2906002)(5660300002)(47076005)(36756003)(426003)(83380400001)(478600001)(356005)(70206006)(36860700001)(186003)(54906003)(70586007)(336012)(26005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 13:24:33.2736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 263aedb3-19c0-4a16-2de1-08d903ffa2ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1402
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 300bb1fe7671 ("ptp: arm/arm64: Enable ptp_kvm for arm/arm64")
enable ptp_kvm support for ARM platforms and for any ARM platform that
does not support this, the following error message is displayed ...

 ERR KERN fail to initialize ptp_kvm

For platforms that do not support ptp_kvm this error is a bit misleading
and so fix this by only printing this message if the error returned by
kvm_arch_ptp_init() is not -EOPNOTSUPP. Note that -EOPNOTSUPP is only
returned by ARM platforms today if ptp_kvm is not supported.

Fixes: 300bb1fe7671 ("ptp: arm/arm64: Enable ptp_kvm for arm/arm64")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 drivers/ptp/ptp_kvm_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index 721ddcede5e1..fcae32f56f25 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -138,7 +138,8 @@ static int __init ptp_kvm_init(void)
 
 	ret = kvm_arch_ptp_init();
 	if (ret) {
-		pr_err("fail to initialize ptp_kvm");
+		if (ret != -EOPNOTSUPP)
+			pr_err("fail to initialize ptp_kvm");
 		return ret;
 	}
 
-- 
2.25.1

