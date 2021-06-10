Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45A3A3103
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhFJQn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:43:58 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:43841
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231465AbhFJQng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 12:43:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1RD7CNYC7F86x5xRee3OFzdA4zpgMAd34/IvdaAaaSIcKuuEc/1WqUbNSJY8eqkfFOB8cso7LLQsfdaDgGWEU3JGAqolKgG+rq4WBkhB6DQA0QZGjIYDWMnfr7EJrVI1L18ADdUhGj5b/g/pApZzwPQ91g2rrcz37Ebg+cmWLszw5gMlnGQxgdxjKCJJJLGQeUQmTVzRVU8xUmOEG+Xwqj8mWR2drstv30LoHIXO+Ug6MEAWcrvCG9am1luo9HI++SlCAqucBtjQQO5WYnR3OSUIPuCKqKnuxVqs5xfBkDDzgESOcNA4FvSr57cfIG1x7NQN2+UrUof9oO84sGRbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TtELPH2XDXSmApLmukK1vEoxEaLRnYib95Abanrr4ms=;
 b=B5HDdvu3HVPBpiIAmD8aWZKepnWT6VE6i6yfWYLugecI569KcowY1APlBP9/49QQdQ0x8GzwSv5mzzEazpuAflqHHEgC1hvaWfmBf8rl5u+yDw7OKyM7jkV163mH97z4ymxIB7uw/gPkLE1z9etgzPWNKJCGh2yUWWRbWOOrxSRLfm5YTOJgkvbkudM6zeqKdxv2jgsIPrPIQkktFqqcSXaBZbI8yTxoQ/1ihn4s+G9zzmakUOG0bUj6tTOZfC2K3TXCODJFzVQQwRhPc9Iuearnl0S8lWoDppk6WaYQsbwizmDV+MeKgaz38O5V/fbD6kUAdBVWk3Vk8vmOhfj1Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TtELPH2XDXSmApLmukK1vEoxEaLRnYib95Abanrr4ms=;
 b=fQ1X2KPvj8e+X9rNg+X9oFvpp11NFt0BcX8jPICIHQcisUf4bexU1tChL/GQHR25zP+zyde6IQQPVWriSyHtWwQQdzWtZh9e6rJytg9DsP68Fd5eGDiUyzzGFe/E8ymHD1Zxm2dXM3bl9bYO7Tv6YxnLdwBYFN8b7gh3jZbYWqQ7h2vF0mCMSIKz4sewGIIeXUYNiMANV0uWezX2V7kBKvk8zx4PJcVfGORDrcY9UW+sGYQFwy+NASUUYmiVfomsP8tVLmtmKO9RBL3rE0tAouDwHpM0ywtz067k3ATAiSC5L9eXlErn8i0pV7r34xz5LEaBKG2jgYiprs7Eggs9yw==
Received: from BN1PR13CA0014.namprd13.prod.outlook.com (2603:10b6:408:e2::19)
 by MN2PR12MB3390.namprd12.prod.outlook.com (2603:10b6:208:c9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 16:41:38 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::5b) by BN1PR13CA0014.outlook.office365.com
 (2603:10b6:408:e2::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Thu, 10 Jun 2021 16:41:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 16:41:37 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 16:41:35 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 16:41:34 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Jun 2021 16:41:22 +0000
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
Subject: [PATCH net v2 3/3] sch_cake: Fix out of bounds when parsing TCP options and header
Date:   Thu, 10 Jun 2021 19:40:31 +0300
Message-ID: <20210610164031.3412479-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610164031.3412479-1-maximmi@nvidia.com>
References: <20210610164031.3412479-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3142fc6-19ff-42fe-f044-08d92c2e9dcc
X-MS-TrafficTypeDiagnostic: MN2PR12MB3390:
X-Microsoft-Antispam-PRVS: <MN2PR12MB33907DDC1DF761EEFD5663B8DC359@MN2PR12MB3390.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XX+qWSZdW1CrSIqGXCxg5NZvkeotlTmEGNHtDz46KLWVPIkhe3I2pOoSbpUSD4SvoCyDXHjOAGa9hUAiNNzN5sQtlL87InDdenzK2nQueXMRw6/cCini/RGsihjyLOYi8gRZJUOb0Qabz2hK+fi8yurB95XlIOeKhvz6WfkJ23cdgxa+M/mM9MXI9OSN9aJAnmkCi0yaZy4+0Os0Vm4mHnoBjNwUeJ0ug2oi2iDvtTeudnDZJDFDMJ2/ZAW9oKJDh+DqyM/vl1CFWH17NLKTEdfVUuUC5qPPw8cO6NsR/RwCMk/CfsxD+SVLY9AVg0v2LeFPz5nUyauzxjjPQhbK07qMYMsYcXou6elv7MPoawV70WzaCgrPNH0W+poGWPIcjt5OsWuny3z56aZ4TAm6OG9mXYxMRCB/YvhVCkXS0JZppQd/0Eesx/XeTgyKtv8l9UVcjK38yeu/nvWt94Wp7BcU2eGhD1V4UdXTGVLPPrIBZUVAuEWqGeLk/YYspAsLBzm2bsPOsusTUi+maWRFwisL/Ki5iYqH+6GlX+zC2ADONw2Wf0VSaLKylpMiBRyTr390P26BRGrgKD32ZDzkck0bYZqQMc6P2VGzgCyBdcqLRfiA7OHgVrzlaAZFVhArbUgr3D9vWkJ8u7XyO6B+qGQ/x4AJhumMpc0K8jqyf3U=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(36840700001)(36860700001)(8676002)(36906005)(316002)(426003)(110136005)(54906003)(4326008)(86362001)(26005)(478600001)(186003)(47076005)(356005)(921005)(8936002)(336012)(5660300002)(2616005)(7696005)(6666004)(7636003)(70586007)(70206006)(36756003)(1076003)(7416002)(107886003)(83380400001)(66574015)(2906002)(82310400003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 16:41:37.5078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3142fc6-19ff-42fe-f044-08d92c2e9dcc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3390
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCP option parser in cake qdisc (cake_get_tcpopt and
cake_tcph_may_drop) could read one byte out of bounds. When the length
is 1, the execution flow gets into the loop, reads one byte of the
opcode, and if the opcode is neither TCPOPT_EOL nor TCPOPT_NOP, it reads
one more byte, which exceeds the length of 1.

This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
out of bounds when parsing TCP options.").

v2 changes:

Added doff validation in cake_get_tcphdr to avoid parsing garbage as TCP
header. Although it wasn't strictly an out-of-bounds access (memory was
allocated), garbage values could be read where CAKE expected the TCP
header if doff was smaller than 5.

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/sched/sch_cake.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 7d37638ee1c7..5c15968b5155 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -943,7 +943,7 @@ static struct tcphdr *cake_get_tcphdr(const struct sk_buff *skb,
 	}
 
 	tcph = skb_header_pointer(skb, offset, sizeof(_tcph), &_tcph);
-	if (!tcph)
+	if (!tcph || tcph->doff < 5)
 		return NULL;
 
 	return skb_header_pointer(skb, offset,
@@ -967,6 +967,8 @@ static const void *cake_get_tcpopt(const struct tcphdr *tcph,
 			length--;
 			continue;
 		}
+		if (length < 2)
+			break;
 		opsize = *ptr++;
 		if (opsize < 2 || opsize > length)
 			break;
@@ -1104,6 +1106,8 @@ static bool cake_tcph_may_drop(const struct tcphdr *tcph,
 			length--;
 			continue;
 		}
+		if (length < 2)
+			break;
 		opsize = *ptr++;
 		if (opsize < 2 || opsize > length)
 			break;
-- 
2.25.1

