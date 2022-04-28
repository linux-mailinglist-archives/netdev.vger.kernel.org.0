Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A48513889
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349096AbiD1PmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbiD1PmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:42:10 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B19B53C2;
        Thu, 28 Apr 2022 08:38:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ailb65bu8OWeiv5pMxykD2xeWcVEArzuVhoZaqZQJb7B6yTgCBZxvv/iyABKFh7q2jHa8vH4dLy67s/lQo6mq3mOGPcbiQLKSDk1R1qvJgVDT3n7baAF3zxBRy5eBIbWkfqGHt0Jbfd//4qjZXrAumqXxjMBG/W1RbL/4WAJsMPT7GW5Ml3N3l3KfXDSWGwCRtQG9Za/vEG0Rhg4tDJJUuanDzDF4MvrwumMB/xOkskqgvNQvBLgIexmLi+hQvJyJtCHLaALJjLKd1FuE1bPSP07ilLkR6yXT6L0MlWa1jF1sZ9UnU/D3Xv/OmCASws+O2iWk9V1vezgskBxA3OBWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ceeGsQYgi1i09dOkw/xW9S/NUSgxrVXoQZ4vKjoj1Xc=;
 b=JNvnAdsqAAcA1bMS87OedHrVvxX8+rW1XGBpfcMaq7DhOc1aa/lmtK02v/l1AlSUNxQq2Pd2emdso1S7lLN3xOvMQSXKY0fAbX6JrQAR2d2LSLomgE3qiTa0HwgHiawpyELt6WWk5+HzwXfIxn8A912CMKmEdtuvItikqZbPJtATpi3Vn7lEx2MR07FNCHLhkmcPHoOtKbyicvWl7IjtAouVUEtKqgEh3/mvpOP2boFozKdZ9vrfkwSvYX2MN76EPY3ogvBnzRspvzRBkcKW6ZDqL+L8VH04aKa8l+Aa6F9HImHN0heHDuOuIhIeiWmr4+wp6sYwckW2Q1m2pcuZTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceeGsQYgi1i09dOkw/xW9S/NUSgxrVXoQZ4vKjoj1Xc=;
 b=VdP/kmR5B2SxNjLt2jYhaW8i7bR0FaBs6O/gKNAPTGayFhOpe73OIneOuboiIAxpbLFZN7nK1H7MSiOPs8mQb3fVXYSSDFfTk3um4Ds3GyKw8mfVzswNRdQvEGbqteAemYE6DgmIwNkelijdLqwSrEfmiCcZW0Gw3BMtL63JygN73XObahysSU/6Nqygy/dmUWhUnufh5eqO07DZFuFQNy0vR8sYrknSE886aT2A1jt8QdB62KeSXLfp2NjgliAr1/DDtb6UNtjJfSvFLBIUPu/xLvoP9adVFxDKyUSJgfk+7id9sFBpHCXdRbFYixQwyLPS9SmQ6r+rL6DMpB1BSA==
Received: from MW4PR04CA0342.namprd04.prod.outlook.com (2603:10b6:303:8a::17)
 by MN2PR12MB3854.namprd12.prod.outlook.com (2603:10b6:208:16a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Thu, 28 Apr
 2022 15:38:53 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::16) by MW4PR04CA0342.outlook.office365.com
 (2603:10b6:303:8a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Thu, 28 Apr 2022 15:38:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 15:38:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Apr
 2022 15:38:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 28 Apr
 2022 08:38:51 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 28 Apr
 2022 08:38:44 -0700
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
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
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
Subject: [PATCH bpf-next v7 1/6] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
Date:   Thu, 28 Apr 2022 18:38:28 +0300
Message-ID: <20220428153833.278064-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428153833.278064-1-maximmi@nvidia.com>
References: <20220428153833.278064-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87a95cf7-b59d-4ea7-2890-08da292d3303
X-MS-TrafficTypeDiagnostic: MN2PR12MB3854:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3854C880566D461C098AB481DCFD9@MN2PR12MB3854.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8JFgrxRMWBOH4zQr3qtgwOcIM+RWhdhBQejWM69PJsqKFwGRNnDjEaHyE31ZqiOtkHSLixQZW3ibCcauw3yEsStdd/PTAV6+ckgNCCi23Hp4eGTOl/l1VfvQ488i8JP44aV2XrYnJjkdg1W1A1XGMhocRcHYtdcPFScrh8DCnWPqjEY2lYnwRIdkDNbg394PLgcrsLLIDYMGmi4UeGNz2wRSLLL1QVU+HBaPtdV2cdSgzp0jtkxAqbe+Tp3cER12Yd3RWbJEDrMQqjDbsSbuKHjguKR9W3P79Wu+u9Kzy14BDzwM7iE1x3RSl8Oif2wKVGqAQUl5tutwP4zkPhzKHr46MaDy08An9xK3omtxBwVgpaV5P5AjwX/3uhJIkK0S/kA20v2I5AkD4p2RxVFxedwlBGNixcqi0//HKP4pr6R5gWvmSu7YZHjBNRTtjcFe2IbIVA7YaD2Di2j+1nMcJ/ASzfgsD83P085fmQKmkM9xXslyTQXmwkbNxNXimk+xEDZwLS3FZ7F+nL+2yf9BgFq+At9S+AyjTJWQ1M4if3p+0NDpZLl9aElbsELVbst064Ba1MrBbNL0bpr3IflD0xkhcuaV42+4wfQg7BloR2TeVHOPImNkrkpZBV/k8m8z+5U27B71godm8T71hBFqDpB8DypeaO57CPgjj7nPIF0TbwBaf1lzF+VEKi6bhQgD58F0IAy6HXk+YKH/Gwi6w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70206006)(70586007)(47076005)(8936002)(186003)(4326008)(86362001)(508600001)(36860700001)(4744005)(7416002)(336012)(40460700003)(5660300002)(2616005)(8676002)(81166007)(26005)(107886003)(356005)(2906002)(82310400005)(6666004)(36756003)(1076003)(110136005)(54906003)(316002)(7696005)(83380400001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 15:38:53.1208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a95cf7-b59d-4ea7-2890-08da292d3303
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3854
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of querying the sk_ipv6only field directly, use the dedicated
ipv6_only_sock helper.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Petar Penkov <ppenkov@google.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8847316ee20e..207a13db5c80 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7099,7 +7099,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	 */
 	switch (((struct iphdr *)iph)->version) {
 	case 4:
-		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
-- 
2.30.2

