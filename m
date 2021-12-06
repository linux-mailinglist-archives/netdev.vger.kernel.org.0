Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DAB46A11C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387046AbhLFQVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:21:50 -0500
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:35552
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1386830AbhLFQVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:21:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKUiV1suV9vyG59gry6ed3ESav3HwezCrIVlViKL5JCX9/QpgBtz590tPcwPBCDwNunxxKNNiKFzkA+EjAsdiqf4ika2bk1cx6879B7lOmEFbaYYHbeoPIEm0CnF40MAdVekrKbRvagJmli9V48Ws56+OeMUOWjp+sQYu+OGRHguy1mcIUO8L9xc6DOFeY3vAUi8pWfWmPEKPNiy795DvzO937cP+M3SRqafJQpFLoS5f07YaLZJ6tsjFVqlhKVcDX07WhrbYHEz16ysK2mZB3nfnkA9jigxoCiU+cu+OB/8GDCerapOrwI4aNKNPIRDx1uY3PNUDgjbfrz3kerB1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVHNkE8zK7nRohdoRCL+ubgHqpmKumWFMyry4/hfg/0=;
 b=lIKUAB1BN4EtYebTIEf4YdLahjPwRi79xDqgj1VR8vpYWPOzzdhONb5b1tn7KHCjErC4+wmuIshK1059+jKagR6QZ+Mo+GVI7Pag/BKwcOAz6/XjuHoj3veTchulTqwnzyo4as30RPmDJgHbXrHub7hfBLvdx7xlxFIpd8rS7u1qoLaxXsqqutg8KW4Bnbzhhmr8Ieqaj6QsTPU9klxY7RH6L3eboEUTH0fdYTeX5ucmwWg14U+jKPqWY31DIGDM0c8GOxenWrrTWQOJdQvobE1fv0wanh2fm1FMTdPZaapY2rWA8W2s1wVEXL61KBcJeQa0F3H9lCFg/mcXweGKHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVHNkE8zK7nRohdoRCL+ubgHqpmKumWFMyry4/hfg/0=;
 b=j+CF7kjplXaoJA+ubHwIowUj6PCHGAdJi3+sEc5vDF/hxAF8ELYHXb0J0SdviWEgGgt2MR9cnKBcV9RyZ50WtfrOZ1IGKkSqq0MpdKiOWM5edMlOhBnkVItWpj6TILAiK2CoZAy91NRO8sLsGyMicPlWnvkxhNsbOiZ3RjCCkETBNwt6SJqulM95/0H1wfXfgOOqelWR71Kyr6EHwyijBfN+GniyAWd5cy8a6YjWHkBNv3s8n4lxFIqrXUBGolewZwfBNIOam8lUAHpuGGGcH69KThVqfV0EccVsgZkYtNRmi0XZCDUBtJUCXdUJGurwY7rtPcjA44PhfjtzrRk26g==
Received: from DM6PR02CA0163.namprd02.prod.outlook.com (2603:10b6:5:332::30)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:18:07 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::73) by DM6PR02CA0163.outlook.office365.com
 (2603:10b6:5:332::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Mon, 6 Dec 2021 16:18:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Mon, 6 Dec 2021 16:18:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Dec
 2021 08:18:05 -0800
Received: from yaviefel.vdiclient.nvidia.com (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Mon, 6 Dec 2021 08:18:03 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] MAINTAINERS: net: mlxsw: Remove Jiri as a maintainer, add myself
Date:   Mon, 6 Dec 2021 17:17:23 +0100
Message-ID: <45b54312cdebaf65c5d110b15a5dd2df795bf2be.1638807297.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74c36b82-05a6-4558-0663-08d9b8d3fcd0
X-MS-TrafficTypeDiagnostic: MW3PR12MB4523:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4523E46F8EE05D668040A5E1D66D9@MW3PR12MB4523.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vgUPC3PfayG1kR8zJr6w8rWRZcKK8DS2pqVRH/emW9TgHU1S5Yp6bTIc/CABibkdJVN/r3oD370MVSR4W9iM2dpOwFofSRq27a6ONmMN1GElGl+NRNOJRqhMMg/pxXEcjs5pV+EXSRvMcU6auToQ7Zm+X03a953y/tlB52SYjRn6ACy4Fa07LKAAT3ioM265cq6qO6lOafKfLAZlyv7rvdtt9ElMgXcsecP3fKLf6FAMxsgcnJyvjQ6m7FV4HMOWCPD+OykoOdcJv5EL4PZpvGo3dnySPiuLu04m6BNUyfOshJ03JXpJ5086tE/5u0y9rNjAqQxG8i9NqxFa7dMnsf0DluKunXkuZFESWrToZNlV/rS9g/cKdYyxQNY7khFRxXj41JNMMSEjVm4tLHEyNT5fBkY96ntlKuvMmvk6GYux5o1Mj7QlFoUzMgDHkjVPMusxLUINFRYMgNszL8ezTC9xaTUicWOS7DUNGvMBPQX5x99ChY5iKmpueC/hCKP5G4oKCurk/EWYQ8r959yOu9oZRr15GQGxu1DNoH8pPANcLy5w4sdN0RXj5SCVLtNuSo2+zUYSGS6Im8BlqaAD9qNQid1p8ewovvYXg2I9IF2fSd0yqorEK0GqYXJD+ThNmOdKLft4Kd5KvozOXjlnba1TVdhtuCY0HOlgoZkbGC+MCkqFxyQUnQRmj9Ln/i70Vf48cv+gJL+INlA6/jDKNKd718R18n4SCBdI4kWVW/OdajodhPlrwoltD3n+kUPqZY+1X0fBgYBupzLgrXGcijoGkNztc3SlJ5CoPlmaZH9oFiZl9gFptkFc7vQp1kRsykKJgasZeWHjVLypbHe/afa8DX361ZVZc78K4j3KtBU=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36860700001)(83380400001)(336012)(54906003)(70586007)(2906002)(82310400004)(40460700001)(426003)(508600001)(4326008)(70206006)(966005)(4744005)(7636003)(26005)(47076005)(5660300002)(36756003)(2616005)(316002)(8676002)(86362001)(356005)(7696005)(8936002)(186003)(107886003)(6916009)(6666004)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:18:06.7609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c36b82-05a6-4558-0663-08d9b8d3fcd0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri has moved on and will not carry out the mlxsw maintainership duty any
longer. Add myself as a co-maintainer instead.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eeb4c70b3d5b..aa096a91f979 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11960,8 +11960,8 @@ F:	drivers/net/ethernet/mellanox/mlx5/core/fpga/*
 F:	include/linux/mlx5/mlx5_ifc_fpga.h
 
 MELLANOX ETHERNET SWITCH DRIVERS
-M:	Jiri Pirko <jiri@nvidia.com>
 M:	Ido Schimmel <idosch@nvidia.com>
+M:	Petr Machata <petrm@nvidia.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
-- 
2.31.1

