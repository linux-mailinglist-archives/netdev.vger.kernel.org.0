Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D3543088A
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbhJQMBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:01:19 -0400
Received: from mail-dm3nam07on2072.outbound.protection.outlook.com ([40.107.95.72]:31008
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236245AbhJQMBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 08:01:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeujKHOvwK/JzSw8Fa4wz9/FCOrv6sMzgXqRdNSj+tD0HKk9nPdlcqoLmGJLuqzgfwwU2znSCQSOVqXORbQhsngt4HYxFuSfvow5VixOEnBRGXo/7G4SSCgKlJTpXjptcipsBTl5x5xjSP6PHPMe8Rw/8fHYmfP99whLDZg0XtCEB35v13U7Fm8zKOS6WMr2n+LvqQ/teNqaoc2yzmdt8dSdumqQYJkH7+7yUv8ljPlVQPsNqX4G2KInwYeYKrQrE381yOb7ygmhbGAK4x37u5Rtd7/TXWTnp+ZjGMddLNZRIS2r6jeW5JwLteGLD9OT1qbslrfTyqzlUbEoqtGtdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOL22fsA9titt54VAadJT1xIhN1xBuA03+gP8fy7B94=;
 b=ne8VJZU/9oC3N+5nzmFa0J4I4gloVhxNwiE49NXs4uzF+69SqErDQv39qSTtEFhPAvFr53fUYWETDu1F/kqCvAMPczykXfZEAWl0qMqisEITWqXxTjI+MEMA37NhLG1bIyW/MxdQMJIGQM4tRDniO9IGKWn7VsMmpN7dePg3BIcARYskQ+XBFr2/BfZNgTrphDeontRmKPT/+ulYAHa3KeD973Sj+AI2ASRiEJx553lyoeadEPnwTpag9Logihak3V5uvFyzSs5FmSl9rp5vZUN3W23PjCaDwGFDsrRb95iAzGUFi8/AD15XkK8GkbVok3JhhoBQAoE5bs5VklQc7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOL22fsA9titt54VAadJT1xIhN1xBuA03+gP8fy7B94=;
 b=DC+FFbmq6v3XDrPHC9bx1j16rvKQLbrZ9ON0fhNiW1RhVEgbG5hfZFmJLm3vrJQQZD4yvrUetswgiePBxyxMm3/kj1Nju4wdoczwhjf7VDWZFHxeHIwCpbxzartYNO1rg9If3PK5oGAS2ZsSvYEooVIbtjkxLcPXQ8h1dlNRMlG+8vRKBk8RPxJIzezLpcAOb+SZPi4gdg2KU4yjKE6NCXRXxKKgXwGO/21UMg0FdFfFGXPdqRufzM5Ef+KnLG6q8+7XmaxW3X1IzfnQozOP59NqTkcAU4A6ouhU4oUcfFN2OBds6tCmps6FZaO55SRHQ7kPYiUd9mCTdv1ynDF3gw==
Received: from MWHPR21CA0029.namprd21.prod.outlook.com (2603:10b6:300:129::15)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 11:59:06 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:129:cafe::2b) by MWHPR21CA0029.outlook.office365.com
 (2603:10b6:300:129::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.1 via Frontend
 Transport; Sun, 17 Oct 2021 11:59:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 11:59:06 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 17 Oct
 2021 04:59:05 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Sun, 17 Oct 2021 11:59:03 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net] net/sched: act_ct: Fix byte count on fragmented packets
Date:   Sun, 17 Oct 2021 14:58:51 +0300
Message-ID: <1634471931-18098-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 544447c9-bce8-4e43-8481-08d991658547
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362C4D4B03CEFD0BAEC2CFFC2BB9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCrtguwVgn1odsUYTvIw6MC+ABFbg78vjdxSw5YijnJypqsBrCe6Orjp8D4Bnu352cwuwu5eliecUROYu84Zw8+tQt3eF8w4FPBUeXG9uYeHQeHMZdxqoFDu6s+8jDkkLBN7RY0VX8cjUEJkgLeSeeXNpk6tOHH78Q4oSbnTIQIzmV+8vpKfltixor6FF5oAyO+vDWosHo/Op+6zS1CfyPGHbRzoB0lXHCE9Jg69HwctqiSX1Wcibi2jpN02XYCCGppykHv8ZqMdGUyz/4qHci5cITKPrdeFG7OfqeV6UMph83GWB23thq/p4QQA4ec8TiAZ4cg/JwFNKfm7xufsvnvKjOrZbcSo/PDKCRwMYIqlu9rGU6Rulg0M7FdQygplq5HFu3j/dqS5m+sMF3ZiVJ5M57S0UFOcAAGbVNHNqQzpGwBt4kruvzg4Be1uqI7J4cpMz/UEVOSSxqRtzKFSo4++eooEOfqXcQCd1Ho8477kQ2DjWzUX0xsAGHWlbLpoivT/hSnIdqXhglTeYnW1VT3tduglTbF8t6eDOkyEehIdBl+D88kNRP+Lpdwkf7E1UmINGpNV2WJbk8gYQ0FZTpBbrJ48PtYk65jjXqI/yEJG7XHVCq66hqAhYS3GZh/at4N4eyW0IyGFhpyo+1l7D+OPNuzPRKYJWMhX36HBUjIP3ZGEs4P4//d6w2utTli+BHPQ5CifEbAOPnwubiIvoA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7636003)(36860700001)(82310400003)(4326008)(186003)(2906002)(47076005)(5660300002)(8676002)(356005)(36756003)(83380400001)(107886003)(86362001)(8936002)(2616005)(70206006)(70586007)(336012)(426003)(508600001)(6666004)(6636002)(26005)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 11:59:06.2343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 544447c9-bce8-4e43-8481-08d991658547
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First fragmented packets (frag offset = 0) byte len is zeroed
when stolen by ip_defrag(). And since act_ct update the stats
only afterwards (at end of execute), bytes aren't correctly
accounted for such packets.

To fix this, move stats update to start of action execute.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ad9df0cb4b98..90866ae45573 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -960,6 +960,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	tmpl = p->tmpl;
 
 	tcf_lastuse_update(&c->tcf_tm);
+	tcf_action_update_bstats(&c->common, skb);
 
 	if (clear) {
 		qdisc_skb_cb(skb)->post_ct = false;
@@ -1049,7 +1050,6 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 	qdisc_skb_cb(skb)->post_ct = true;
 out_clear:
-	tcf_action_update_bstats(&c->common, skb);
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
-- 
2.30.1

