Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06ABE3A1713
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbhFIOY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:24:57 -0400
Received: from mail-dm3nam07on2047.outbound.protection.outlook.com ([40.107.95.47]:13920
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237794AbhFIOYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 10:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEt0mdwyVBzehEIIktD5x4mI8gaj5PWCzLb60ZZvs4fJGMn1iA+Nfb7wAvZFjRaNVEGxZKPy8zw/q3U37ggGPz5Bi1b38dV25MURGqH0KJLh0CWgasSaRco8ix70MRGeRMhglVCOw7eMR/A7pl45U3Vuf5Kk21LEYBJ/bCauJAfpOvocyDR6pd85Gc+NSwIsz95zAal/DdZFYlJEFwYKpx+BTBm3IWbTO4h54eytiSyDYM9JbIF6avhk3s6oNpcqpHhl3tVW/1bZ+LMyl366SwACy3csFHGwKQNW8ivKUTWypBfnHBTSWnjkmA5cFE6IS/S0liZDbVf6hXwBM/aIMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yMCxIxZol2c+lPp7M0M/1j3OtKTnf2YOuTKQI2ug8c=;
 b=ODZfNwZFPK+sMQg91xo2hcq7snAQ7lKTpqQ5DYQpQHP09cX0Hwxri2IeQuwRjqlrfk4gyTEKrUElcO2FNZ2Gofu52gue5VeNoD28N79MP8w9sdhGYkVsVJLLXT702jRBBUHjLr9ZflEfdSZW1ctgralRf+DNtFtLjL7xAcunVKLhHMQ1OPf/VwRcYCI3E3k71EiQzUuIQoUXuUo3tVOD8jGsHkl652elVMb6FKgMYoqw6ziY5JQ/j8M0t8/HC8iPzV6na3fWvX0ixtzBykR+2Zt8CnCQI/hgIAdTsMILPaV145nuSS42TOfYU9+gA35ms3025kqB+0ZxPUAUjh0z2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yMCxIxZol2c+lPp7M0M/1j3OtKTnf2YOuTKQI2ug8c=;
 b=pvrQPY1g5UNUdarHwzdrVN43+eMhpuoG45OZ+eu72oUVPcWvKPtbg4NHvAINZ4nGjRkgelHFDpCnV1Bil6PaGx+4ZZcXv+vD6Bj85AzO0dOefxLplar47xqlFz6MTmEg6XDcZiNkvOOGUYJ7TD1334XSqUahQLAP1dW61oS20z+GwxgtIvxIgWkMkLCbBTQ0Ck3jVQ2Yt8GLmdJflsuvivsHyuO1/9vK5L3Ylmmc11NiBJYsy/XINOPUMBvAZmFkYTvBSYqd+WcHJJSl1RvHYdI/f8SMxWovCj+8TTHbBIEBtlPzNsfxc1aRJ3mxvSg2vCoq9Xg1DSVIp2w1dDR+Xw==
Received: from CO1PR15CA0102.namprd15.prod.outlook.com (2603:10b6:101:21::22)
 by CH0PR12MB5106.namprd12.prod.outlook.com (2603:10b6:610:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 14:22:52 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::d7) by CO1PR15CA0102.outlook.office365.com
 (2603:10b6:101:21::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Wed, 9 Jun 2021 14:22:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 14:22:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 14:22:51 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 14:22:50 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 14:22:46 +0000
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
Subject: [PATCH net 1/3] netfilter: synproxy: Fix out of bounds when parsing TCP options
Date:   Wed, 9 Jun 2021 17:22:10 +0300
Message-ID: <20210609142212.3096691-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609142212.3096691-1-maximmi@nvidia.com>
References: <20210609142212.3096691-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d3327c2-8ce3-4958-3a67-08d92b5210c2
X-MS-TrafficTypeDiagnostic: CH0PR12MB5106:
X-Microsoft-Antispam-PRVS: <CH0PR12MB510675318E2B10D504661045DC369@CH0PR12MB5106.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:538;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U4r/ZE+kv1twrAOvB/76znE0xC77Se79sepeAVVPmkCprN1CIK5Xpovt5Sd+a/YQbQ1EN+CzPmAxkdlVxcR8kH26oLgoQnTKKpMVQlx+vO2S6sBE5faw4Z1H5883H6j7MGcrWlNHvSe179wUyUaLd/IBePRfQDxr/92uvNzlOHHc4Y8TzIoWFpKxfHG/a2GSPCm+u4KAeXp7R/fDajfRyy02C3wHTG8L0aIRWgE8uKlBq9W+Q/o2PUSAA5aWG/mUVbf91qo1FwraCw19YT28jG1LLnC9uC/J0ssF+R7euvSsQZBjvnd9UXhs3uiMcMQhAZhRv35UbwxoL1oHNUJL6BsTWfTAS+mtr/Impotf/DqziHLehDZUn3xWCmIV8Cg44Bl6w1WrZx+92sKkhK5+xrL7cv8Vp+T9stD8aIt4JSxjCgYcTLphjs0vynLmeoN4iOLkccXy23hxnGNG0RI/XBjsbduUxN4q6TjV6sj9gRnhOY419x/ihe2K9bTfaE8qIXDC3/vhJfYeC2o09eNKkI45kKkrnjprFMn4MwQOOyEJCRKy3I+hr0YoEtOwbLLr6V+GoBErBMjCeq1yeHWvzwqqAdJvyEeh44uRGmVIb0KOQm0EI9ovafUQb+8Yk+g90A1myhDTQGeOr0nlhINsMXSww4fYRQLotf+ByRUEqTQ=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(46966006)(36840700001)(86362001)(426003)(82310400003)(7636003)(316002)(356005)(6666004)(186003)(7696005)(54906003)(47076005)(110136005)(8676002)(336012)(478600001)(36906005)(4326008)(26005)(83380400001)(1076003)(5660300002)(921005)(107886003)(70206006)(8936002)(82740400003)(36756003)(7416002)(36860700001)(70586007)(2616005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 14:22:51.6963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3327c2-8ce3-4958-3a67-08d92b5210c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5106
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

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 net/netfilter/nf_synproxy_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index b100c04a0e43..621eb5ef9727 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -47,6 +47,8 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
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

