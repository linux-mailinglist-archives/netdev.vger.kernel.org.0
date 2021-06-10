Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F271B3A30F3
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhFJQnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:43:21 -0400
Received: from mail-dm6nam10on2054.outbound.protection.outlook.com ([40.107.93.54]:43873
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231520AbhFJQnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 12:43:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5ohtPr1fhxdemA6cKYaKMW1I0yTGl5XmnquFEGKZ3qzQxsC2Xgp8M27UJ3c+gyYVuXJ85iQxSiVxYM4z257AJzGrm7u4LaooLwCnEtqae4EqqMBRJv6bKbU/a8WxlZ/ShfDxbyP792C2R4ivec3MzwPd23FZiVlw3UdV7WSamaRSO8VQZ/LKyDgXoHp6Apvozp87sP9wYaszcCy74f8l68I22Hh38GSh9oNyfnLh6gc8n6JL2gcDuV/xxy0P3G9AGv2HnmQMkHenkUElLGeUQePDXEpKmUVIV1YvI+jqodpun+0N+gpojrvVr+SV1us2p705SqecDqTw4v4LCB7Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2p8lpQ+bwtlwEIaQdcJVF54mwWaCH41v24HdDqFXTE=;
 b=M1FdTv/VbaNeFiYT2YfUY8AEmtT06EajVGvUPJYXwE37KHgUg3fhVsUZWDiZ98JPmn24iy/Hw48xh/gCKFkUVRoBFGg7drJQcxVvNQXS8b69fCvhUZycld4v+E3E0p3zL80DKVAqNGkG985rm1hjfB0Wez7SmiDsKEnuWmvzNHG3f//vwc0txCgKCo4PMVLXhoIJi8LW+/mztcVIy0STI+nfBngWnc02iPZ+GnXlhHMD0tBjoR8C5PszOKv3FjpM1p2mFrRRVrHjgUFEvslz32AzYIXC+1QbFBxc2Eyt7rsyxUnc/XdLTIUCVz6gLZRtQcYdIQYaOdDW3BQgufracA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2p8lpQ+bwtlwEIaQdcJVF54mwWaCH41v24HdDqFXTE=;
 b=o72j/WRKHmDJAewrOGdQBWxRI0GC78UX1IviVpbHxpaye3xquzWRkwgWfxExf+2EZuBfkY7HRb4ULTfIu/8KYmNnB5V52NrgHFPzXAptE/3xGr/uEui0Cpubyrd9qPDvEKPiAQ7TNvhvd8MIv/mfVRahs/bHnVZ8zO+xHy7XeJ3/nvWgDY3tp7ry+hLAKYvzXRC3Z0/TKvfyjmp0T3X+Yoce5W+4e7ggP8pmlPArS2OW79fR7GtG2A9xOlAAbeCbwQcNmXgTXA5suQuwuCbqQfLK1v4XBJYyLF1TfCXNZACSaD+LkTA+m+HSH+Tv4wEJ/neLBLpVopwo3n/EvBljaA==
Received: from BN9PR03CA0180.namprd03.prod.outlook.com (2603:10b6:408:f4::35)
 by BYAPR12MB2966.namprd12.prod.outlook.com (2603:10b6:a03:df::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 10 Jun
 2021 16:41:09 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::ae) by BN9PR03CA0180.outlook.office365.com
 (2603:10b6:408:f4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Thu, 10 Jun 2021 16:41:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 16:41:09 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 16:41:08 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Jun 2021 16:40:54 +0000
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
Subject: [PATCH net v2 1/3] netfilter: synproxy: Fix out of bounds when parsing TCP options
Date:   Thu, 10 Jun 2021 19:40:29 +0300
Message-ID: <20210610164031.3412479-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610164031.3412479-1-maximmi@nvidia.com>
References: <20210610164031.3412479-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 337c0952-1ce9-455f-5efb-08d92c2e8d0a
X-MS-TrafficTypeDiagnostic: BYAPR12MB2966:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2966169F04EC7C5F9672B594DC359@BYAPR12MB2966.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nu0k5q+uwJcbyfYn1xsqpj0FG5SsuCYjwWQyHfuXauRlzsZjnSW07xI7WUSrQrYBaBVow6igFabVUJoD2L3pIHrJlVvEJX17RteYRb1574Yaupg+be2SZmZal1x4Zu+ImJRKCqW6ZsCdcmEZ4UCTBf808lj3ybp2wNy3l7Vao7Qt6H/JsClql3HZZIGaukL+LiBCsXnnUEDP1v9I4MXC2/0p1Zgn5T2ofVxOCGfH7KgUoTSzo0ish82r7Z8Hej3j2U96PHao+xQ9N9RfUgr+y0tFlt9wTRfRSkxo64FEZFASrLJm6ZbRDZ3SzhmbW1TiLJT1r5uGJn258dkrROCP/ZMY6DmM6+1GnWWR7r6+qkWQYUP+1ovfEyvzDS+/tYzv2vQmzN2+XXWhBeQW9F9fYeLkgmub3QMbDzWbNofimOR5CVvWKHBG7i66B9TJtj6BXrg9lljzWGPcP25F7/cgVWnHtNIZ5rniPtCZwJllCl4UpwXwqth31mUSi6aCPZRlVWa9vupGRYOuwTYIhEZcOld+nolzt9DAcmk4XtIrnnIRsj07kytgZbAioL6MNKYLSqXzlKEeRAluIbppLuiOgOhtrLv7vE4CpOQaU7e/VqE3XEMhbl9PZQW+ESFb1BRLuf+a2atqYmtq8nbr29teKa8/ZzAMP0X/gwWIQ92z24=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(36840700001)(46966006)(36860700001)(316002)(54906003)(110136005)(83380400001)(36906005)(47076005)(2616005)(356005)(478600001)(336012)(82310400003)(70586007)(2906002)(8676002)(7696005)(36756003)(426003)(8936002)(86362001)(7636003)(6666004)(70206006)(26005)(7416002)(921005)(82740400003)(186003)(4326008)(107886003)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 16:41:09.4051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 337c0952-1ce9-455f-5efb-08d92c2e8d0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2966
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCP option parser in synproxy (synproxy_parse_options) could read
one byte out of bounds. When the length is 1, the execution flow gets
into the loop, reads one byte of the opcode, and if the opcode is
neither TCPOPT_EOL nor TCPOPT_NOP, it reads one more byte, which exceeds
the length of 1.

This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
out of bounds when parsing TCP options.").

v2 changes:

Added an early return when length < 0 to avoid calling
skb_header_pointer with negative length.

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 net/netfilter/nf_synproxy_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index b100c04a0e43..3d6d49420db8 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -31,6 +31,9 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
 	int length = (th->doff * 4) - sizeof(*th);
 	u8 buf[40], *ptr;
 
+	if (unlikely(length < 0))
+		return false;
+
 	ptr = skb_header_pointer(skb, doff + sizeof(*th), length, buf);
 	if (ptr == NULL)
 		return false;
@@ -47,6 +50,8 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return true;
 			opsize = *ptr++;
 			if (opsize < 2)
 				return true;
-- 
2.25.1

