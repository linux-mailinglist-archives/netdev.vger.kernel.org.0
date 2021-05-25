Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8ED38FD8B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 11:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhEYJPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 05:15:13 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:8929
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232321AbhEYJPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 05:15:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6mo5po1dsQigcdO5rMVNMHKtyF6Tghe5q+ppCIgTy85dHtGOD2XLfPGQoPhyBv9UlLcrRof3XCqutkul2TAMWC8ek2c3BSAh9+21ZmSeQrq1pXnkCHoCQzY9835WEE2Ag4nDGsZEA4t3nrejTCqi5hn1WUPvkpx3MIWd5xTvwtI0X5qZepCJvKBzKR/HrEV8YjLo+7kuiWKByip4MZY3S2/5nKP5mKeO5TOZ+7457ae4oFdjibnGrYKa2UpFMZqCNINiuTRGHZuCcvT//NtgHT1w2/BPQivh3pPykQOvK6Qm1Ooly6EhYMjkT/+0/eg2SnQUPT69zpkMAyvdE3i8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZeqGoWLyVk9T2GxQjcs/r1iAu5gidxob83411YLymE=;
 b=ChTaiZqTTfRmxj+kZ3RNhG0+CgpMOdIwdG8imTkSMmpba4NIfQWMzrzwYaFZdWZCJdnco9W61l9lyjhoYR0sLPtkCeFuLFxRFvjEyYWSs7FMR8eEAxIru2uVGXRzcX6ji3XiNfJ5pq6+Ob/C+Aq1/HWQU5Acb7O0n2Dqsp6RiZsdm1eR37X5PEN7A7W9H+i3TeWxfjlZvzBjaoazH/BipZjhboOB+oI6BHI507ijXFb1IcZzYmt/6/n3KicWVtR1jlfzwn3ANnzbqkYSfKi6ccAYj5cLdpZAkqXMSIQnE8XaD19wS+hapScKfz2hOz3dhbqJW3CMBP2zPQw4HkyBzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZeqGoWLyVk9T2GxQjcs/r1iAu5gidxob83411YLymE=;
 b=Tgdi7l4tmyDacZqdchc+f73Ld8dl8cqYBPPVpgLuCGrNhlH85idhfD+BEH6mcyUkEI9AIBsTBw8sQIOnMZLumN7IXahBdOD5T/jcmUEPbP6+F9wtGPN/fSeA/Zwt9SpPOMEqSP4ARh0AMigx33Mqcg0rm67iJXRRRa0vAqA/BycYDQgd5Dp3m/0EeoOm5mfNlThGk7JFQhi5uwo6nThgBeNhJbaLRZMcT4he1rNQGv/Zbql++Qw2VbbO0MzNZZquwJd3PilWlCvxmf6JoL+0fuYIlrIrgKQQmY/4T/+saoCkNRWk3MvQO0ESxLMku6HI6k5IaN/3nPZ0KdWnjoigYw==
Received: from DS7PR03CA0285.namprd03.prod.outlook.com (2603:10b6:5:3ad::20)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 09:13:42 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::3d) by DS7PR03CA0285.outlook.office365.com
 (2603:10b6:5:3ad::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Tue, 25 May 2021 09:13:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 09:13:41 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 09:13:41 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 09:13:40 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.145.6) by
 mail.nvidia.com (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via
 Frontend Transport; Tue, 25 May 2021 09:13:38 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] skbuff: Release nfct refcount on napi stolen or re-used skbs
Date:   Tue, 25 May 2021 12:13:22 +0300
Message-ID: <1621934002-16711-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1a590a7-2ddb-4a3c-8e1b-08d91f5d63f4
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5422:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB542279CF437AED6D86F974E2C2259@SJ0PR12MB5422.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Vm+gEOSt0Sy3S/s6JiBix4FhskppVVr99g9K/HsCW0yd5Zp8NMk5mcv2N7jXwzJr79546xoi6LuInnkJ4PDsrrzlhVMJTmR1pWlZ6JoILwHJj/gsx621DPRteci8Irti8w28VdNfHK8Vb0OsMgzpbdf7vdN7Olq3IBqfDvkuDXYANhhUfkBfR1vOysmavTVimidjnjs4FvdzbNHGsPuu91O1cQB94kPDpbMXKJMi3x2jKbbKrZ5PePFSztBj2wjtGWp7HVgWuGPy5WqR0eO9WsZGsz8EnaG4A11ftbGdwbN0ZrNmfU/g0mc13cwLFQJ/y+vxmyzcGu0QmuJJY5J0EV1Ug6bxoAuvsQZcdoGO6ZRHxrEIKnt7b5Z94N+VjLIG8u+thLcocF/jPCsWLz29Ti6LBkmsTLQMiknD1t1xZ7MDxNzOj6ypLXod11Es6uxb1baRLdvo5ANnK4hy/iSYbcQ/BmPSz7Np07GAU7PeTdOYWQBwIEGooXfgOgloex8EH1/laiCT4xioIqTNHM45P/rNhGE8kB5/c2Nf6V0412S5lvfgv0gvaZziqbf3capjpMMv6JOsZIZEFKPiqOdr8f6pvbB7IV9wAJ2NwBW+HWojQB0+Lt8rhbWGMkcewU3QtnHmSiuC9tvV643P1f+GlP1D19iGQnqaXXAQ+JsXbY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(46966006)(8936002)(110136005)(54906003)(426003)(86362001)(26005)(2616005)(316002)(36860700001)(336012)(36906005)(8676002)(70586007)(2906002)(356005)(36756003)(82310400003)(478600001)(5660300002)(47076005)(4326008)(6666004)(70206006)(82740400003)(186003)(107886003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 09:13:41.7927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a590a7-2ddb-4a3c-8e1b-08d91f5d63f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When multiple SKBs are merged to a new skb under napi GRO,
or SKB is re-used by napi, if nfct was set for them in the
driver, it will not be released while freeing their stolen
head state or on re-use.

Release nfct on napi's stolen or re-used SKBs.

Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/core/dev.c    | 1 +
 net/core/skbuff.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index ef8cf7619baf..a5324ca7dc65 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6243,6 +6243,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	skb_shinfo(skb)->gso_type = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 	skb_ext_reset(skb);
+	nf_reset_ct(skb);
 
 	napi->skb = skb;
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad22870298c..6127bab2fe2f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -939,6 +939,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
 
 void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
+	nf_conntrack_put(skb_nfct(skb));
 	skb_dst_drop(skb);
 	skb_ext_put(skb);
 	napi_skb_cache_put(skb);
-- 
2.30.1

