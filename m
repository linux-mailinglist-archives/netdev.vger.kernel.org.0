Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5B23A30F7
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhFJQne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:43:34 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:37985
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231607AbhFJQnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 12:43:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPsjL0ZfYLqnBVwH2esRgTkEO89kPCXcaK7SPbfPFzSxtKcfbcmDG1NenPsIMKGEKMRZrhccVdMG+r22hVkSuqER6IYt2QkKokax+5alDa8hU21dfG5dJNF7xnHOyrhWb1LIs1eZzrjV75U0M3ic4j4bHWWvsJ1N1JHlSjNu4ymcE/Y/7vzyTbRLw5mrRWxUDd54pgMrxLXJThM/e2U+ECA32IPkGc0sM8suFjy1CsrMQGDYqKq2LMAFH94X1oKQ+0SwXRyydhocpUtIL+7acCzh7PjdsV2yyODzRKFHcvYqXrNY1hZeI7wnPlo0E69mtHZfaersWWgI7ktIOk8DBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2wY0Wt2lqMPTtGKpjeTV9b4X2qBRYxq4hCDftLZM9g=;
 b=Al08csYL50Av7k+nj0T61/ZtHp1CyqbgZPIIibFX+R0yStCvZDPRMIXv8+Pm3ykYgjblYh07g+xKHWgw3rLQAIJ21+LjLTz9yu35uK9diUHglLBcJeDVJ+NJZm8PwNiWkKy//1OU5RV/VKzyhxLup+LC30GwB05bSSsq9hX+mpDR1NZ+bRqSWyjESFbnFlMljxQRQ4WV0ewiHngYNqwEsbbKyH6BUThokc6aYb8qgAhGDHG4JYDoPKdwSNf7Ts66HmzDTBaJTs6GGxvIAPD3YyHm28m18r+Y6UafosqnM2Y5uw8y9R2gn4XfLfCm0mMiqS+K91zKcGuJb2mptovveg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2wY0Wt2lqMPTtGKpjeTV9b4X2qBRYxq4hCDftLZM9g=;
 b=DJ46mVC2mA+k123xwzEs03yu5i3aQ1kRZrLH+iNdFyWKfAiGn/kkSrM5nlnhfC/O2EHq5v29qgHD9KPE5uHZ6e8DX+Cqf2YW/Ywxl1oR8M8OydycXnKtaSJy430lGHXgR04FEvpdP7A+73Bz/yyZ3B5/EdTyZBzxbru7ODYwQv/RlKz21WCykOvDZZzvtRjvxN848onL+Z+p0LbzDnIeH/+DvngPF2e7yeAJGh1jZXfqCKUBILt9TyhA8Tc/PWKMX3WQhMw3pAgkFYDkrpDvS9xCWuBLaSvzCyTtVUJF0ms3+mmoZBKecT+ZlkU2Eulf+AXaQg3+AxqKpN322XEdVA==
Received: from BN9PR03CA0405.namprd03.prod.outlook.com (2603:10b6:408:111::20)
 by DM5PR12MB1273.namprd12.prod.outlook.com (2603:10b6:3:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.29; Thu, 10 Jun
 2021 16:41:22 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::2f) by BN9PR03CA0405.outlook.office365.com
 (2603:10b6:408:111::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22 via Frontend
 Transport; Thu, 10 Jun 2021 16:41:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 16:41:22 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 16:41:21 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Jun 2021 16:41:09 +0000
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
        <mptcp@lists.linux.dev>, Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net v2 2/3] mptcp: Fix out of bounds when parsing TCP options
Date:   Thu, 10 Jun 2021 19:40:30 +0300
Message-ID: <20210610164031.3412479-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610164031.3412479-1-maximmi@nvidia.com>
References: <20210610164031.3412479-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfc3ce01-fe34-4403-1a4f-08d92c2e94a9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1273:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1273366B088B85D3BEF2727CDC359@DM5PR12MB1273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NnpHfmBejfgiULVtr9yo29XC5HeSEDYztHQh9pfO/UOJQdX4voOn1wUK+sXBVz+zsTYBmxTQuokndH0pG2qfxc8C+IP9fuPLogydB3247m7w99zGTwhBSfDVxERJIkBE3cQ7Y0e1dXwVqaSQBV4lcQbIHtU0VIfbjdJhLSG8z6czuH48c0kXwLH8CBcNPNxKl71H6Nyq2UvoJwtDGx+LAj54PeUvR8dpg4HlCpwM0npiEoK83O++psyRcQo0wLENC5yCZWRWCcfM5WsTaOGCuIO8AFnXic45rmJaeMdb/sVKulu/wrIeMPuhT9NlB3l7AOKiloI22wgutyP6ea9q3dfUSXIn6XxVIYqgCqqIhVfSU6gwRcjNk/5DkdX4USTdnVW7bHPFPtYvTEeCHTcPJZmHDFCRuvRTWmternpEHcg23AIqsjEuNIhITXyUowcKf9OVANS8n/y53igi/SUdm2K7LNW/OX7/+8pRz2RXnDyB6A2WWQLNf2VfqXnoNnPq2We/x5Gwxd66up2XSLPC+k1D+Z9abGn3+LzVS7t0didZ1KUBqCcaPuypm+/H2GYjTdHAVE8S15Nb2R5H7gBXhdbr3ssRPlwyYRc7xlb+mBUgbFK0xjNj3J74CrLNNqSnmnnuyZigfkQT2Mdtk0aUsZyHgvHU1zRPOIMXFyxHxfg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(36840700001)(46966006)(36860700001)(5660300002)(82310400003)(70206006)(186003)(478600001)(26005)(4326008)(1076003)(356005)(110136005)(316002)(47076005)(7416002)(54906003)(36906005)(426003)(70586007)(36756003)(6666004)(83380400001)(2906002)(8936002)(82740400003)(7696005)(107886003)(2616005)(8676002)(86362001)(921005)(7636003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 16:41:22.1984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc3ce01-fe34-4403-1a4f-08d92c2e94a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1273
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
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
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

