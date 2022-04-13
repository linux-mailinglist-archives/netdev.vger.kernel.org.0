Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836684FF804
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiDMNoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiDMNoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:44:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF395FF31;
        Wed, 13 Apr 2022 06:41:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyrBns9WHYMH2GUhGALzcXgUGS3ttm/38EssszmfneeGdLgFepSfOxwPgZ/hIHAVPkONKhQr1b3wdCqRmVSnD8Z77TrsF4fHSSgMJedzEB/vUQd7l7MLHFrjSueUmtEn01kNiET4I1DeNa/cswpZ5/xaHHVwP24zMgL2qHDRIXyyMGQ+0cqDNXqeNEuVs2YYy4uzGP3fpqEQ/psaEPyKsO3R5hUvD2ESFe0EjWq4CgsUNhS7Hz/TKtVo9nogiBJVguS1e8Do0YnpN66tZYUhW/6LT1kiaUl0wtQ2VKi9a8zqAGsyVgubiN+Gb4OxdgAnLGafyQL3n0wnK6eNte+9Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXCauEaoc6x+FUdiLBVK8dMrQzI+24hyxHf+00pZQOY=;
 b=XR+dCXAX+pDF/ktQ+RRoOjrEPYxLotVxAHYtXG7Ms8yDoBDZ2S+hc0v8ZKQM7cVICKgHjHp+ZqpyPj2LHXGCnu+NhUmQQVZcb2Ihj7t91sd2RQdn5pT1N+15qefPi/MX5exleED/uSUeGY6wOtYezZIk0tsaFYYeIRwsVuuiwqIMkoBWMwAoZsjPmHUc5pSvUQPCi0+iX+ahD0pGmm+8Hkw2Jaoechnu2YIQlqVpHHfKBNw2rCV8c7Vy87XlwiXheaxIN57APUB2KEGs/awyxF8wSekhep6Q2KoGhewkJjbLKkvxsb6CDnk7AwhOcHtJgvigXgFqRAUJmml3LcG0Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXCauEaoc6x+FUdiLBVK8dMrQzI+24hyxHf+00pZQOY=;
 b=KRvc1CCSHChJ8urgSI6NIj1JN7Z8tNH9q2KEROyVwvbIsNomW1Hlx2hhGHWnjKpyvtiw1DJ3M5sU+OuuWvz3pGCsFqdBKqzy77BUDFbrV5koGqDHFDl6XthSsIRidZjiDya87JtVpFPlyIEa0WP7jQa43iEkXkdWBiVQUXYD6XxJH11+JRlXsOtXDcW5uMTh41bMOfa2QlDWTW6d3YG8AZaRlJAehHVKcR3gt8ZUAH6r4aV3TXDWQkc0MY+VFpEKyyWTawztF5WUpCcI/A03LDzS3rvX3wZeNLzPmO1Snxnx1KudIullsXXTOJceYj26QjjRH8z2gcSK0GQH5AJy1A==
Received: from MW4P223CA0016.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::21)
 by SN1PR12MB2495.namprd12.prod.outlook.com (2603:10b6:802:32::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 13:41:44 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::82) by MW4P223CA0016.outlook.office365.com
 (2603:10b6:303:80::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Wed, 13 Apr 2022 13:41:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 13:41:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Apr
 2022 13:41:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 13 Apr
 2022 06:41:42 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 13 Apr
 2022 06:41:35 -0700
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
        Florian Westphal <fw@strlen.de>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH bpf-next v5 1/6] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
Date:   Wed, 13 Apr 2022 16:41:15 +0300
Message-ID: <20220413134120.3253433-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413134120.3253433-1-maximmi@nvidia.com>
References: <20220413134120.3253433-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bbe826c-ea00-433c-c90f-08da1d53590b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2495:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2495306E2449D7464DF2E514DCEC9@SN1PR12MB2495.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAlHWq3tDZfkSo4gHjxF0hdY7EgK9mmDC94I2mdzBQWnwJvuUg8GcDLs1y/a7tcmyofO/8WQy6Wv81gX8NQbZlEpegXEW5Rm1IsmULbFlIH9Oc/ot5CeJGTgDMh8RgZpLsQEJ7ycTF0XPHQoRDDTOxyM1nVlDwVn9k0Y6au4QASu6zNLBjyFzrgPw+YRBav+GUd+yD+ApogrlkcOaGsQ8kEkobuI7/6u5a/vV4PJiM5rt5RQorwjNIi/K9AWN/OsrIJ4yS9MT5UV+WMSQwoTPW9cGqru8LZ9xYEQGGSprH51nDLD2t1iZnU/k47uBJwchNJUvxrXdAvjrl2lgAb5uWEQQjKPjQY8TYkGA3X415EyBhNikbd2TIDFxcT1pNf95wYBPxNuExCWnS97CvJ6frB3ozU0FaZUBBeLrj9OQfJLyHG/i5cUj8IuGk5GfATpDdKgA7E620e6CbSTChk5pHeeEVhYQs2bgDMicmZJ1DGDZ37EMx6I9QJamrDfXwnrQEtSyUO4mfN90PJiLs1fkFIbSdIrCoHApGpA3GslVoYZgGTY9iITYtvA67jGl1PZvCpzgqHi1G7orWMv3scHRp3aWbG7rWvL3u2rXS3qGV7E+/6hL+TxoBq44s1PLlbhBg1Xo+hMseRlbcQWfTujssijO18tHYYAiphrXoeSmWjaoe+JXPtThWLC07d3dfhrURQWmOIr7LCl2VCJ5gFfVw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8676002)(107886003)(26005)(70586007)(70206006)(1076003)(4326008)(508600001)(36860700001)(6666004)(356005)(7696005)(54906003)(81166007)(86362001)(316002)(110136005)(186003)(2616005)(8936002)(40460700003)(47076005)(2906002)(83380400001)(7416002)(426003)(5660300002)(36756003)(336012)(4744005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:41:43.8688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bbe826c-ea00-433c-c90f-08da1d53590b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2495
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index a7044e98765e..7446b0ba4e38 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7090,7 +7090,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	 */
 	switch (((struct iphdr *)iph)->version) {
 	case 4:
-		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
-- 
2.30.2

