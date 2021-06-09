Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7EC3A1717
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbhFIOZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:25:06 -0400
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:21345
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237849AbhFIOYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 10:24:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+5dsQJt2pzeDgxsX5iXLLJs6nknIEY8dmDUoF6+irfWVHcwN8B/SCJrVaZnHJFadXve+r0KZRLkPRqidG56kGdCPPIlqxAxEOcKYpXxK+2pJUNYCJZOgSRfsI1bPNm3VLpA7gEimt1whhzacaZ9IZt+o3uC2eSoWF636magQ690zprEboCrYxfa0Fr0qqHx2z6DXTEKR3GJBgq054ZzJit3HJf3PzH2IqnO2Y7ZvxXiyYDoaNobl2uXQUmsnXQYuysoTPbcE1S+AqGViF/GG78EYlPrD2m4mJWuBCeeQgkAup+F1VLrlVC1nHP8nVLC8VVgUbotOCH+hWJ5AjGwYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QYR+S9r80f57bvrxBVwzzjQpZL5NkbBqrMjIadmWq8=;
 b=MVSDfhdNF1CRqmulNYtOuPKs9UiE6FqF3NxD79/BNv5+UgYQf0j5SL7FFJ1RIAwUrOZUZ4zwox8iWV1a+SyfPrEyZdYOPseiDRwB03TXY1NqcrYZ5gxiDMh1mq4mUvb5g8xekmglINoiaIB9BEOTF/rQgxIh3kGCepLB+WRPtltWmOwJpkoBaN+4QmHOR4LPmf4AbXljImj6iUPs1m7V7LKNFqTM5AJFXZSCDrSNnOzY9yai6YAsmRIbLCsVhoFuK4sRgyfwJ4XvSX4lGurqE/WYgxkNQdBlSz5DDYJe28gdnkydU6iKJus/P8OlI0odqWiUn5Q4nSY7FSUp0SCQvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QYR+S9r80f57bvrxBVwzzjQpZL5NkbBqrMjIadmWq8=;
 b=n0ToKBV7TiDY1X4+yS1kUKOyKftOJapz6519u0CQDJIkzlH2D066dKi9cEIZf8zRpVa1aMZuzgfg+NJcvq/i5jtxA74Eoq/WvAtLlI4HY5sWtdLzYCM28DdpReFUFWs6asRFtc1VQrma8rEvynMwh1rju2MznJuZ36jrfVCHo2iKMqE1I06JuLyzjun3clIcKdggvibG/iqYEdOi1DmLXZ2/fZW++SmNyQtcBENFPgz1d3b4IQdmq1Qh7UIT+x8wBMdSJfRYvjmVuYjSwnnHt+Np5rdkrA3sW1eJo+cCo2mhSo0xSN4fjwWxARG6vBIhg3hDH9FutQ74tOAjCsqUSQ==
Received: from DS7PR03CA0284.namprd03.prod.outlook.com (2603:10b6:5:3ad::19)
 by MN2PR12MB3533.namprd12.prod.outlook.com (2603:10b6:208:107::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 14:22:56 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::fb) by DS7PR03CA0284.outlook.office365.com
 (2603:10b6:5:3ad::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Wed, 9 Jun 2021 14:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 14:22:56 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 07:22:55 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 14:22:51 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
CC:     Young Xiao <92siuyang@gmail.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net 2/3] mptcp: Fix out of bounds when parsing TCP options
Date:   Wed, 9 Jun 2021 17:22:11 +0300
Message-ID: <20210609142212.3096691-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609142212.3096691-1-maximmi@nvidia.com>
References: <20210609142212.3096691-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56b2b811-9eba-4d5f-fe9d-08d92b5213a5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3533:
X-Microsoft-Antispam-PRVS: <MN2PR12MB35334B934ED7D41BEDDEF763DC369@MN2PR12MB3533.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aU/dFOxRgIrUdKNuIyoSsfSOq08Ozygstcj49ybvguXNyAf9oC1+seEQbErOD6f/xGRoY/jeZNMMLytKZ/69LSArNEOT+naeIQrnj9zdkQI9l6eYBcyHKFGKCztQ0CGwqvjxbO/VrAOWc0UJAfrCPA6epEC8ZqjnHe0WWpqf29xi4ELIrmHMkOrk0E5rS3RLt6LMT3psELyeIiOqX2oT/umBtN2PO+8b15weWcRg8eADNL19Xo4xB5t/f4j89w5sp8bzRGBuwqAa0QXN8pMNqkmvh3VeL6x0i5j7KHx8on9a6MDLnYL3QLPEb147XTMMH20Kav5QuyYrMzCKT1FfZP8BgetANhutbCHJsJSwbxD8e5zf0UHSYcqLqsXDh4gKXiiUFmQifNc7OtdyfcjRk3OpXer/Kt8gznqJgmNP/QwuUfotVTGbCDD8tjDFCvjLS2+dGm5NfpWGpjI+P5xOGZNxG9sp8i0jduClMbAIJ3mrjzWUyP50vy3vd3ddkVuCxijlO/5M9UHIh/lab4ZUM+3x1wUb0vizNK9iT9l6twP39QSBG47s0Blb/DUDhANVsxYptSbc3Tm9Z2Z+5cJxi1/0B+ucvC0HHRtuZmYvCDN8NVMaX9s5zQ3zt1HtqkJnyg+Wqw3NdRaED11dyA3iQU8VrlwbZ4M3hsfJTVNlJco=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(426003)(110136005)(7636003)(36860700001)(478600001)(6666004)(54906003)(86362001)(82740400003)(5660300002)(7696005)(4744005)(8936002)(83380400001)(356005)(186003)(36756003)(2616005)(7416002)(70586007)(70206006)(336012)(2906002)(47076005)(1076003)(107886003)(921005)(4326008)(82310400003)(316002)(8676002)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 14:22:56.5554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b2b811-9eba-4d5f-fe9d-08d92b5213a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3533
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCP option parser in mptcp (mptcp_get_options) could read one byte
out of bounds. When the length is 1, the execution flow gets into the
loop, reads one byte of the opcode, and if the opcode is neither
TCPOPT_EOL nor TCPOPT_NOP, it reads one more byte, which exceeds the
length of 1.

This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
out of bounds when parsing TCP options.").

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 net/mptcp/options.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 6b825fb3fa83..9b263f27ce9b 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -356,6 +356,8 @@ void mptcp_get_options(const struct sk_buff *skb,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return;
 			opsize = *ptr++;
 			if (opsize < 2) /* "silly options" */
 				return;
-- 
2.25.1

