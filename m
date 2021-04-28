Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F273C36D201
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 08:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbhD1GG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 02:06:28 -0400
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:39043
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235991AbhD1GG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 02:06:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMakct3mU4guwKfDdTRcpVS5O+SVpYhZdPO1/ptitqt4B1ap5SMMEJ2lJuQ6tRntmkc9wv6Q5t1RtWhuMnnychkWLfekz7/QXd/mbHgRW4Y8mjszaNJM1Hge8/DoxT6tSAcbT2DYd9zamenJh7gXICGcptQwWCtKwtXzgJFMeJJ4XkPPWNLXGTpEdWNwwfYvdysdh8c1He4fBBDSxsChvofGnEvt+a9tlvsVqElArosWqzdPHoT2H+kI+DeveUQUczNbJIbxL2IdWz86gUBhBZLPUIyJIupUaveysxX9jrwz7XaJUVIUqYDRHKzvOaITdDouQbNMowFpSxMf2qWnvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laC7KtHaZ3vbk2CSyeSoqZiC8RSJyyOUlHYgn1sm7iA=;
 b=FQQA2BcUV4bkYDcUGQ9vNgzICV86x+2C7HyS1KUmcOtTYjpPXrmlatTAQ9jc5SCX8eg8nQY6Oa65pCz3IwJCaKQNjRhxDPnB5qfPgron57R1+Amr8hNQ33Q9sTxk64Gn7MQtVxLsEnpf8K/hH8W6Ny2SZS+oV66y3NBbyHNxzU6eTXV9OxmLa2DQnxdFsnDxfrS+4pNkFYbWNTSESu0iIs1prjHI/4rPRHPxLr9DXVVagR2afwtUm7egJTPmpgOIFEOEqmHRWE4ntfyb91o/y5/VydkOXJxq9FDixb3ETnUiTQVrTAObBq1dqK3Nbw+Z7uAcsXytv+5Ke3JcJImWpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laC7KtHaZ3vbk2CSyeSoqZiC8RSJyyOUlHYgn1sm7iA=;
 b=Da06BAlfytQYOmN52EQGLdcTMjcVtpzmgmN+K3iFTkB6F+GoeRVJUlEf09d+c0XHcUki6jcY5SrKbb6Etf2UjaOw+80BFFYa2fDEodIQiZGJ+bywZ3yUmkotbD3h/QWXm/EzZ/Y0DdZLDbb4bAcihQt4wllGnkTgVE+Uf5jWi8nEmLCBGK/VdCmK9MEhUmq0uHj+9fEsSQVzDZFIKoDQVN0DhHFZWJPro8+0dGstJ7Avg46OP8gOVPUnOv+GeK3weU6jhE2pj3GaRPNyzbe+5UwWJ/oIIy2UJeeo78BbM9YGFzZLZA09o2mgVvEvcF6cnlYvlpzDtENHHXyP4aQ2cw==
Received: from BN6PR17CA0028.namprd17.prod.outlook.com (2603:10b6:405:75::17)
 by DM6PR12MB3418.namprd12.prod.outlook.com (2603:10b6:5:116::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Wed, 28 Apr
 2021 06:05:42 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::fd) by BN6PR17CA0028.outlook.office365.com
 (2603:10b6:405:75::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend
 Transport; Wed, 28 Apr 2021 06:05:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 28 Apr 2021 06:05:41 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Apr
 2021 06:05:41 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 28 Apr 2021 06:05:40 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 1/1] net/sched: act_ct: Remove redundant ct get and check
Date:   Wed, 28 Apr 2021 09:05:32 +0300
Message-ID: <20210428060532.3330974-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 240877ee-df52-4aaa-5929-08d90a0ba788
X-MS-TrafficTypeDiagnostic: DM6PR12MB3418:
X-Microsoft-Antispam-PRVS: <DM6PR12MB34184153C99664CBA0C69EB8B8409@DM6PR12MB3418.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BAwgPdDJiFoeNMCtj5GLD/TGDnlVgxPz5TNh6kuB3rRReEsuHU7BWHh0n+ajERrFgy9IMDblYuszbrjEKbFEeEuRkJ/24iV5i6QcU7TOUPv6IcpNeit8lrRAs+STY3TJzdL95U5pPVdHA+FckgZPL0O6pz+mQxNtrHPsvs/MJS1raJE8tbGQnlCweIrBOyrEYeLC6WAXr81AleGu1MZWTMFSALkS6RCXZ7vH4R3wjjCKUf8ExjfYnLQjsY1IcbLAn8UJAiAc7OkHcclvV83GtujRfj5u+vZFaiqNkGdyMH8wDl1/IPwaNWRXB03P5qr6EXKf9EM12gnkoUGdcgTModSqyoTUGJ+t3eh6NHxSfEk5RiIUdEV2XM7LqknzHVw6S5XmLr9jkwtvodV4v5fcVTvmlcG3iISIDS1fP9uGluDZlohJSxjKacOkGLfcltU94dxngy6rHqQCgVi9HkA+qYqMgC/us1qYNTazRy+B7WvVe5cFJILvaOr+M0HsQYQRwoY6vSAvnEoQkCob3Pc01YJE/Qbw6WVu0hKJjYBn0AJyYfVsvEb77MEuvPP3sUWgp1qoZNtlCoU5y/okl7xW0RymIo+I7y6/V0CYYYGFWi9euDNuhtgB40h96e4tgiyq26Tn7cbGqvT89UcH8Cq/pw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(46966006)(36840700001)(336012)(2906002)(8936002)(426003)(356005)(47076005)(4744005)(36906005)(26005)(5660300002)(4326008)(70206006)(70586007)(2616005)(6666004)(8676002)(36756003)(83380400001)(86362001)(1076003)(36860700001)(7636003)(478600001)(82310400003)(107886003)(316002)(82740400003)(54906003)(6916009)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 06:05:41.9435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 240877ee-df52-4aaa-5929-08d90a0ba788
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assignment is not being used and redundant.
The check for null is redundant as nf_conntrack_put() also
checks this.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 net/sched/act_ct.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 16e888a9601d..65e9ffe6cf7d 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -990,9 +990,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 		/* Associate skb with specified zone. */
 		if (tmpl) {
-			ct = nf_ct_get(skb, &ctinfo);
-			if (skb_nfct(skb))
-				nf_conntrack_put(skb_nfct(skb));
+			nf_conntrack_put(skb_nfct(skb));
 			nf_conntrack_get(&tmpl->ct_general);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
-- 
2.26.2

