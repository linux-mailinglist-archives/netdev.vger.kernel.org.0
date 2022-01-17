Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4784904D1
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbiAQJ1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 04:27:48 -0500
Received: from mail-dm6nam08on2077.outbound.protection.outlook.com ([40.107.102.77]:10560
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235665AbiAQJ1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 04:27:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+WsezLT6IZYKtLtM62hT3MHL6ncWWczfD9BJ7xfPilsMFSmOuyGx0AezKZ3VfLjJjk5vREYH19mZJkiIrHdZU3FgF5DHuWA78wyMhnJ0UaAvwmSJvJfUrrwNGb1d/TCQVScxbnmc6cP42ImbE9wgwi+dL8x9io2REsq48VGMrlh+2fw7bbLjNXqkeEG3vxc1Jh+USDqzgF4RomS8T2m7lnh7VL9GXZByEjaeOpbmSraYeHZ4D0WaAjDzrEGQpNeUO+fykW0NSRyOuMWmlhXu9tOVaquhjUd2jpXZZqizXo6SsooaNh8IYxDGEf4EKKYs1J8d36vtLFyA+XtLUXRsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4Hca/mPzt8LKlHjkLZVM2SH0NgxhXx0at9GMf4Xryo=;
 b=myLVTNrtT94+auPihgTOLR3e3ih2QEHpMcOoHZxFvb0cq1zHm4ZqB2XbUZ89BKOnCIEgX5iS7n3RJL4oCv/+bEz7CMysExb2Cnw3/zRgWw+IRNYpEtxa6k58wQbnUcJyK4YEZPtUuqikavU+Htu2d5dMCkLHXhd/TiK64cbPmb6F+Mgpd5pxwfmCznmHu6QRAHxtX9a+Eu3YnyoIPGRKzuoeXcatPsPMNcJ5da7cECCGtgCqMPg0RZHY00r/f6Do5G94FhE9XKpnVmE7lOo3/VZEddjCN2jtC+zgBkJgabQ+QRBCaqSyM5rXKxram3XstN8bvv5xkFNU5z4TNhV0VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4Hca/mPzt8LKlHjkLZVM2SH0NgxhXx0at9GMf4Xryo=;
 b=Eq2keX3DEgINNlUbJLFeI/om+weUOHTTTDocMdsV3ltLYpLqxd8fCK4lYJw0fL2eCwRUMyUtp1QPq3eHlyrtP2VbHNvZ00rQGI2R5Hi7ylM7anqhp2xAsu3GdzLsf+cSF3UJ2wHj89SHFRTIxjJfYfl5f7mgNhwkJjdoCRnevYzFe1shdtHfHCr3TTc3il93UwRHYwmfadvblfCDBW6KTzDudX2yaKT4ZZFiCp0F7FhVLSWKeSBXXghNmatWeHkN5R91Ck0jlB5ySp0ty994TRYIvMkh67E/4xRxkgRRPSopugyALybhUxhbAbxdhDjWBIMZkFl3wcJa4PVz9IuEyw==
Received: from BN6PR17CA0048.namprd17.prod.outlook.com (2603:10b6:405:75::37)
 by DM6PR12MB2796.namprd12.prod.outlook.com (2603:10b6:5:50::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 09:27:46 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::2d) by BN6PR17CA0048.outlook.office365.com
 (2603:10b6:405:75::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Mon, 17 Jan 2022 09:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Mon, 17 Jan 2022 09:27:45 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 09:27:42 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 09:27:41 +0000
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 17
 Jan 2022 09:27:39 +0000
From:   Gal Pressman <gal@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH net 0/2] Couple of skb memory leak fixes
Date:   Mon, 17 Jan 2022 11:27:31 +0200
Message-ID: <20220117092733.6627-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70a002f7-bbe2-46a7-b06f-08d9d99b9edb
X-MS-TrafficTypeDiagnostic: DM6PR12MB2796:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB27963F43147EE9FB98E59D46C2579@DM6PR12MB2796.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SXNW8AuAhVVLaWNW7EKrzFP9tOuDQow9a4UfXkUWNCVCdpVoKvN2sNlQo8sBFbpHLvNkKDvb20wNyoUVstqnAAFEFngt5zAPg6dC+/C1U005AqzPIpaYQsIfwxRqknk+nsgYFgwzGI+37XfIpuOBxVAuq6MbgdW473SoMdjFEI0FzmiOzZx/D6DZ1E4ejI/QVradQOU/+A61bCc6yzKK9Ont3+1ICdQsrG4q2OP2wiPboDnlWqlLGHQUmKupiOo30iT/BiujPU5BfpsvzcyJ7YALy1bJrvNvEZ8yL7LHFbDu03fdy55WkqJSQGPijgCl3Hrm70TCCWrz0auPKEKJ0GSIJd3kj1+93A34fRMONklzde/n5OKniQCFIELNIUwxRrpcE+6YGOzNxyQ6OdMOXH/VwGNg2O4T1p5R91I9phd1CmOCQn1tSOw3OPuvC/HfrGeB+8KOM6oIVtyjHrfx7to/HmrmrB8p7vozAoXt1/wVZSrdu+oXUWtagRj1aV/C5E9tZxaK6jlbzIZ4u1+xQe5dq9oDSmDZLWBUWsVwLGA/twrTsfuUEq341v2HNoapVCjUAqTFy6BVJpqsNf5nsGN/dQulVF9h/Daw6RtMDfhgfIlQGgqy11Cna5KZI8wuEohglIqDiArpPncM4ffx+mj0lewCEPLt3CNsYFmJ43QCbKQ/Ov07XxPAifi7qjn9U4EJDOi1NmTzIFbvYdyGyLaLsEYvnLNGwW29HZmXNTOcY8P384tAJqX5t95czMvsrM92MBfvxDVbtiL/JVR0+6vzGH1PgANM/IF0fQtXA/3zfNPiCMcFcLhn3qFwupkFWaCe14O1DTgFmFbHBJ7bBrQBQBwsoDIY+LAzC+Q0QhawIwscf/yTUAw6vLdGcTIS
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(82310400004)(7696005)(70206006)(4744005)(6666004)(70586007)(110136005)(54906003)(316002)(2906002)(26005)(36860700001)(1076003)(83380400001)(4326008)(107886003)(508600001)(8676002)(966005)(186003)(2616005)(81166007)(8936002)(5660300002)(356005)(336012)(36756003)(426003)(86362001)(47076005)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2022 09:27:45.6273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a002f7-bbe2-46a7-b06f-08d9d99b9edb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed in:
https://lore.kernel.org/netdev/20220102081253.9123-1-gal@nvidia.com/

These are the two followup suggestions from Eric and Jakub.
Patch #1 adds a sk_defer_free_flush() call to the kTLS splice_read
handler.
Patch #2 verifies the defer list is empty on socket destroy, and calls a
defer free flush as well.

Thanks!

Gal Pressman (2):
  net/tls: Fix another skb memory leak when running kTLS traffic
  net: Flush deferred skb free on socket destroy

 net/core/sock.c  | 3 +++
 net/tls/tls_sw.c | 1 +
 2 files changed, 4 insertions(+)

-- 
2.25.1

