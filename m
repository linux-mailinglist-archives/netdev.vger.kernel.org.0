Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E88E54CA40
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353549AbiFONtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 09:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353327AbiFONti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 09:49:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBC83E5E6;
        Wed, 15 Jun 2022 06:49:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+hD/bRheDJ7wUWO63GyZRmN36ytj8ZoVi60u/9PSQcMmEU/1uuj7ZgD7s66VQsPcT/Xgpic1nOVutZO/MERCwL++xhOcJZPAPXNFiO4E724aDVBoy88gKnuWZ6QGZaVfQzkiSPxNTwfIK74yUeoTCOP1M4PKHQohQv5hcPS07ixNI2SWCO5FZHUTvhMxuEd0VTXBOQ+C77zZAnsq+BsIGhYb5UwXMAShI/otb4ieBnkIPiYiuWbknw93QVyyA7lZbZmy2NC3QYWIL5CcXawjDH1cPQ9RCSmGngKgRQXNZFaZFMXz6P9lj/VTxlAkUJmLOLhQIDEyn09wo5uvgL8Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7Hqc7T5i2GQkc6jhk8vqiVIbJItE3+A1M60GE5Rqmk=;
 b=cxvNprbVfCvWhI8dqYyRmQvj9g4q3shSwW/64xT4tpOw86rjJVbDtSaHwxuxqq0/5IXWYiZ7fU2lD8BaBpHTpSiYSI9TpBwNsoY1kOCl2/WS8c7q7HNiKYMjr/7j0NxwTyZlXeThZddvLw7bbgS1ZyUt0K4sVIFR0bizsGaseUYzfbjWdCTiFSW+Q/qZQYNolOvEADkJj2aQtaKZ98DGoxHQ5QegomGn7SRlZAgDQwDHFML0OXeLy10LhlPTsXTiAgdNUQZFsa0M1oF6UZ6va51X4D8paZ24iTj7LfZMa/CslxHYJYOSXfMFKDlK2AwxTWhXrwjHTK8qZ+lVFgGAPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7Hqc7T5i2GQkc6jhk8vqiVIbJItE3+A1M60GE5Rqmk=;
 b=Beuzu+wRsvfeiK/YTNIJvCdRaTL6eJFn2hRQiDK9sYgsb7jCP7PfY2tEVswzUtBf2GVz5zTBBXV/bXRPKUjRuEgAbWHIRkbj75auYQFy4XGXMOYeoBShQbYVBgP6TNBEoIyl8txr8OHUIc5YDXtDuUBzMW8QvQ8qIGAFcMC5VhTYWVcqpovr+EKcO7h69xg+yvenW56pWEUHKcsHI7q2up7iDHXlZnxKZutYSSu+Au4O/DG+TlUb93su6oLae4w6j9Zhqw5bgT8U3cMh0iHc0eX5rGZrPtWJ8vKrm7G2HDrV9BIfXX+pHTwBw1CjNxK6Q8Sy9f24CQp/k4KcgsK3vA==
Received: from BN9PR03CA0066.namprd03.prod.outlook.com (2603:10b6:408:fc::11)
 by MN2PR12MB3038.namprd12.prod.outlook.com (2603:10b6:208:cb::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Wed, 15 Jun
 2022 13:49:35 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::7b) by BN9PR03CA0066.outlook.office365.com
 (2603:10b6:408:fc::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 15 Jun 2022 13:49:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 13:49:34 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 15 Jun 2022 13:49:34 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 06:49:33 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 06:49:27 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        "Florent Revest" <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next v10 5/6] bpf: Allow the new syncookie helpers to work with SKBs
Date:   Wed, 15 Jun 2022 16:48:46 +0300
Message-ID: <20220615134847.3753567-6-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220615134847.3753567-1-maximmi@nvidia.com>
References: <20220615134847.3753567-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a27cd3d2-4486-4bb8-fb8c-08da4ed5e1b4
X-MS-TrafficTypeDiagnostic: MN2PR12MB3038:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3038B7A2BF55A689D03DCC36DCAD9@MN2PR12MB3038.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LeSxJ4XOfCxqGTbdiW3jCo8oISz5e42+zaYHRFeUytfdIWl3D9Vlerr17Qpm9gXVhyuBFxBnm8hIixsx5jhrNOqIG3g+mlC3ctgVlxGlCQfamMq6pT2UZCkeB7AiH6jbob4gcJF+kfaFgY3gDDsET6DU8HkQWb780t9mdnNUD5OEkMp0emN5QF5/iHvEPD6yr9UBwXOPV9gpYvcAlEfWzR7c7rukDqoxR6x3lUo4yR9dtofESpivcsDFDjiuGr5ytDtfo+VSCZvwo9dQLU5GQqnP6RCHXYMH3cvQzVxEzDa9ixHDqyctCxekIH6tR027GR+A0QNtIYCJ2/cnwj2Yp2lXjDZ4yV1sNXMU4QZsvvLSFkyhtH+++Grg3UbCXrlhVOhmoL+7qLOp+8jKOIC6pvjoEVYoVaECXrJlWh+xVyOdL3T1eMLU2Crw7HSB8U2IGCIJrgmwWqREkpqHo6x1OU//b24rCipE///y3ACZHhgTQ6j/UTWOat5U6v1/vcwb3p38ImHPZ/8AgKHbvOD2YXGa9jky9Z5dsmxmZdtqDXGrlrU1fDQF3rPtkS20CFTWUdeW8nICxiyqQjNB3yx3JQStVaVcFAGRIvVBCZPoSRmZlLcngX+O7IKvCBEgnaZb1OD+7GLJgbogZRO3CiPpnV6ohf5vazw6He/CTBz9CXzQvKxgdSFWVK5SIiZXz13OPGn6ypOz/bYlw7WsAAEfFw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(2616005)(81166007)(26005)(316002)(2906002)(6666004)(356005)(508600001)(7696005)(54906003)(40460700003)(110136005)(86362001)(186003)(47076005)(8936002)(336012)(426003)(5660300002)(4326008)(8676002)(107886003)(1076003)(36756003)(82310400005)(70586007)(70206006)(36860700001)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 13:49:34.6362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a27cd3d2-4486-4bb8-fb8c-08da4ed5e1b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3038
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit allows the new BPF helpers to work in SKB context (in TC
BPF programs): bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6}.

Using these helpers in TC BPF programs is not recommended, because it's
unlikely that the BPF program will provide any substantional speedup
compared to regular SYN cookies or synproxy, after the SKB is already
created.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/core/filter.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index b62d4126a561..423f47db84c6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7915,6 +7915,16 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_assign_proto;
 	case BPF_FUNC_skb_set_tstamp:
 		return &bpf_skb_set_tstamp_proto;
+#ifdef CONFIG_SYN_COOKIES
+	case BPF_FUNC_tcp_raw_gen_syncookie_ipv4:
+		return &bpf_tcp_raw_gen_syncookie_ipv4_proto;
+	case BPF_FUNC_tcp_raw_gen_syncookie_ipv6:
+		return &bpf_tcp_raw_gen_syncookie_ipv6_proto;
+	case BPF_FUNC_tcp_raw_check_syncookie_ipv4:
+		return &bpf_tcp_raw_check_syncookie_ipv4_proto;
+	case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
+		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
+#endif
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
-- 
2.30.2

