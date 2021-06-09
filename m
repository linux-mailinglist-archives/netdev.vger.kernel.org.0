Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9E43A171A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhFIOZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:25:15 -0400
Received: from mail-dm6nam12on2056.outbound.protection.outlook.com ([40.107.243.56]:42592
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237943AbhFIOY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 10:24:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1AEw13tSSZxizQ1R1PRmBASZEBC0xnGmWtpbaSZI2OgtYBHv56Gq2rZgoU+QFNMmDFq0OECKntKAEUqmpN4IrhnZVtoiCw7YCDKEcbZhNJEr0jzIxaQbzwpjbadp7ZFqXw6tKVxkjTzcYeQaAHiX+zPRIRU18jbvFJAKC95HHa3f2S7WR6UiDBEWrHKYdjk+q/xV7KgLY1jmru1AJPAxexaJWFMBPXn8VLsa03U4wF+ljbVRVaCm1FeIds8OueL5TDiQEIhEPNkCYXTE2bycVfIWiDANF7xLskRz+hhBH24xX7/Z9ahOxITyDz3JSA/4T2Ddi0oOkr/EhsoUlwD/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Jgsp9z8kv7HHd0epraP0WbSUXnHIhdoS2jee3r6JgM=;
 b=Xdga4nF/7+3Q+I3LfC8oJ8ZwxtqYHTEzv15xl58lKZdJanbaV/MdsrE/QkGL4R0fRgMFUgav8vBu0xcSPOlQY/yCAPypEeorbFNgZ0Q5n0Sn6Tlj/aqHCeH9Hw7ruKvEOHZzjvvE2/qIu2K1bx3NlBh9JpwoqyLvpmcHupQcr/F+E6/qo6x5Bh/qIV1XBwX2LGgoziOWV1DWeahFhycBaURRwrW+OkY2gTJTAnu+Z9XcVIjQn9+EaB3LmzHhw1r+5v/wWVxAcyPUo17u52QTJagWlXfhBBzF9Qq4VAspaLv0kSCke4E17dR5wJzBq7BoLipH3mCZB7jRiv+Ady4nsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Jgsp9z8kv7HHd0epraP0WbSUXnHIhdoS2jee3r6JgM=;
 b=KauCc76Bhke8rClGBm6f8Y+oiw4s9/dLAQ4SGhDSHcmH5RXjUtPvLyfop4C2f8oa1syKTfVxESmPkpQh4gBzsB4n4JubGyqxkw096tx12LgXB/O8hXlXPO+8jMvqUOnZbrS0ve94o9tTk7ZtmQZEhvGR9HYSaDY36AZLm6oB7LhoIZ+AS3ZQHewCdg7gADENMXLOBdBYwArxP5bHrJKpwOF9gf3ueSvMrXm2/z80FHes0N6YSNM41DVSP/ldjNC0E/LF5U8TNAngwNpmOd/UwxiDzObQ932IzDqD2ZHB52YhjUWS4TrEC45rHXQ+L2iViVeaUpBQ/RrlqIU0HVsHGA==
Received: from MWHPR01CA0043.prod.exchangelabs.com (2603:10b6:300:101::29) by
 CY4PR12MB1623.namprd12.prod.outlook.com (2603:10b6:910:6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.24; Wed, 9 Jun 2021 14:23:02 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::8d) by MWHPR01CA0043.outlook.office365.com
 (2603:10b6:300:101::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Wed, 9 Jun 2021 14:23:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 14:23:02 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 14:23:01 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 14:22:56 +0000
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
Subject: [PATCH net 3/3] sch_cake: Fix out of bounds when parsing TCP options
Date:   Wed, 9 Jun 2021 17:22:12 +0300
Message-ID: <20210609142212.3096691-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609142212.3096691-1-maximmi@nvidia.com>
References: <20210609142212.3096691-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68104536-408f-41b1-8e4a-08d92b5216ff
X-MS-TrafficTypeDiagnostic: CY4PR12MB1623:
X-Microsoft-Antispam-PRVS: <CY4PR12MB16236BC4394E8FC4E96AEEF6DC369@CY4PR12MB1623.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:538;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MV3AivStOcdF9IuRo/BNfLbIwXhIoEn8txTpaSk1K+yeQ4FZ0sCpcBJ88D005gaK5eJiFYhodx3RAcVrDafzg4IDHjipxA08k+W1G6uewhLJkMRNNCjV9JUxlT9boVCL/vdv7XSL9jx+xJShL7t6uTIWyi3HAxDq1tCUMy7tnUJnGoXGDPNMtV1SvMG0AJBuUj/8vSlBG1yvixEmoS5IH5wYKiYeEvunJQsrJuX9WzUJYtoPgWTBgUoROz+Nzs7kQP7tYeclU2NLh4o6W0AmKOvZmHNIUqgDc91cwlPQDh1PzGLqbzcie3yCznd/x2PRMCRAPg3H79AzV5Tojw7eZ5/qktFDHTDbDV4KcXrdlgxOFlAND0ExNpVwHOuQSSxjfNGLU8+FBGY9cj8G5rsQfJ2M+qOdJ1di7xec+DnWalZt0IG/qvo7pIlZPmFozRbI58VaJck5q6oWmg6xnZr8EYXQaKi5RbPtrMmSG2Cl7wCcw9m19MYtY5e25aAy005QkfbuBma+BfRZwxkuAaeNG0Pacm25wIo+iYargan8um+1vl5NWdUWYadFFCodXXOrDJlehswBwcDsMtdok6aJUK79+0bRRmaNx+Zvt/BzPHfeGw6MS8DlPOdBVMkJKKp3AF65tzkGSyYJ+EK8G2DVWdcwUajEaS96AIh3wWvMkG4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(36840700001)(46966006)(5660300002)(110136005)(36906005)(54906003)(4326008)(107886003)(316002)(7696005)(2906002)(6666004)(336012)(47076005)(356005)(83380400001)(7416002)(82740400003)(1076003)(26005)(186003)(8676002)(36860700001)(426003)(8936002)(2616005)(70586007)(478600001)(70206006)(7636003)(82310400003)(36756003)(921005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 14:23:02.1196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68104536-408f-41b1-8e4a-08d92b5216ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1623
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

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 net/sched/sch_cake.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 7d37638ee1c7..6b03eebf0a78 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
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

