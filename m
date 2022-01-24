Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F3949833D
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbiAXPND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:13:03 -0500
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:10208
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240539AbiAXPNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:13:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRADE14xrUD/NNVwKxyCXWR0jddr99aoKP1SZmeyw+H3rRhEZkSoRxsHJrdTVCYQ1YvAMmf0tTa/nhgwua0dGCh4n8g73NEZ1/weDiL1Z17d62nuEyo7hJaHf0W6Utvb5HCQJNwDCFwb+wtdqtuGnHi91np7js/Q/IWyvw/qsHu+K9nEkJ86Uf8LL3kc9WXhVYWLMuYBcbGzInB+vJ6xvTm9k6fZSfYH9y7GQBShQ6nMQ2c2DSmpnPGMr7gxA0eYsiALRCxvn5sRamI8V9Ul6MBTvrztblla9f6VOqguARfD7+bNCGHA6wt5WRM5RVmE9NVnLJBhMFenCJC5iUPItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41QmeqrzqpdDyAPw1FXDzpbBfKGkWN1TZ2S78qV4CjI=;
 b=SAaJOetOFOCpeXJ7kHgjz2qcShO2IbIV2bjjJV4DWdogCmx1hgEYQZOZe3TKKC8plkwifDQnG57xJshz7BbF8VhBuup3wn4JFmT12M9IdasOqkT7f4GngM1uGQNNcL0xkVRJ3SDZ+xkg/b+4/nJwTwE8HEMJSbq3eZwcu/orjEFBr6+LupU9BGBBOhDaM8iVneCDfqJ2gjezBffsrOZZwp0/Ioozo9ht5Hnx7NiljX4JFvsEZxc5XdphMTDQpqqgPZasT8GqWONZjrFiaNilSSPgW+VnfZGEHAYpwB0If1wEVsR6rPQ9FAEy7yZX9FIMwwAukZr0YeQt0tuu5kpiOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41QmeqrzqpdDyAPw1FXDzpbBfKGkWN1TZ2S78qV4CjI=;
 b=TmKq0ytNaBOqox3Jb+CnZSPfD365oHYOTPqWNj1TUCrd6ZMb9qpWwQwnbSmBNgRAGp2TqvVFan9gL5Wvl80/7fAYXzujroC72Sjd8K57h6FIet2MuXgZzUghr7EMLBT2d420SZU4gm1AduO0ODLodL4WU5Fp4PFIRJr9hHFgyqBXMaB1bPB/AHiRC6TGckZkz8SGMMsdWOW1tiMB8ILaS7jNjtp9L9idGYQSLo55QdCEWtocwYoGalXLqxxP8Ogf4Go5xHDbA9qENpBydi2AcpNbCdiG++v62u13I7XtovxBApPPgdMqdxsMafdR4QLQqVIZibuPEtTfdIuvXuS97w==
Received: from BN6PR13CA0057.namprd13.prod.outlook.com (2603:10b6:404:11::19)
 by DM5PR1201MB0012.namprd12.prod.outlook.com (2603:10b6:3:e7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Mon, 24 Jan
 2022 15:13:00 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::34) by BN6PR13CA0057.outlook.office365.com
 (2603:10b6:404:11::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 24 Jan 2022 15:13:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 15:13:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 15:12:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 07:12:59 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 24 Jan 2022 07:12:55 -0800
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
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf v2 1/4] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
Date:   Mon, 24 Jan 2022 17:11:43 +0200
Message-ID: <20220124151146.376446-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124151146.376446-1-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0d78fd4-1ad9-4db5-c384-08d9df4c029b
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0012:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB001234C3EA4467FEDD6CB546DC5E9@DM5PR1201MB0012.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNx10GC2Ai9zeuw6HUf/58hddHyJSaJUfAZQxgA5QLIbCoYHYDWazFkXK2Yi0hGvok3lgsC0gTYBltl+OLpI6QW/XQAB1+ToJRr+pilhbm5xkugTMR7SP+gLBnacRILku78uwJK1I0UMJkReU331/lqdrdUnSE6kQrQeM9srZtXS240JRo+jey4pea9tEMHEn3mzPuaUjDBytSYRxjHqq4deVhmRlTPmdmialAxiRc8YbipVFcS7Ad/kFTQxjuj1gpdn6dbJR9iTuzK1ucQYo4kMWR8SKf9wkFdWH3KXqCLls2ciPNqZZkKm/clEQ4vJM1WidrAHeWt1REeSEvdA49N4k3LVQzxYwR9ZwR7cYcGNm/LHBBpPAFNEAQtB2moIRG+/Y7nX844KpPQcAB+ChGmbGjwp9iySm5AAbwFPI3dgbuolXXUAIEu25xquJg4eLZsDbrhZtHnAo0IT47UlKtf3ZPstTeqPiF9DheJFnklapzMD/W4VCmjFaLKfP25y+JHPD7wPdB7UOngi208ROEYMNPs+eovTL+H5qC81uBJkVhC+D6XwOc63PsEtDax236uinmt8+RTHEtk6W+hIZ14NAerOR7F4wPOtOOqTI0IWdGSTBSvRmJhVbF44Rr+CBEF28IEBDy2aGqgUsLVvpH8F2erXuX3d5x7dT174Zu7Y1OcYPoWAPUTTfHr1wY/vjMDnr4/RAgk0M7bGfXxki3ghNxmlq+0vkJvXEYJgnCHtLK2TczSoeEDAYea4IpLiY6ClMiHKvXy56hTLWp9ReBudJ3c4Ie/HH4iGg2uevCg=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(8676002)(7416002)(5660300002)(2906002)(86362001)(81166007)(36860700001)(4744005)(107886003)(4326008)(8936002)(1076003)(356005)(82310400004)(7696005)(26005)(54906003)(186003)(316002)(47076005)(110136005)(426003)(336012)(36756003)(508600001)(83380400001)(40460700003)(6666004)(2616005)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 15:13:00.2188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d78fd4-1ad9-4db5-c384-08d9df4c029b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of querying the sk_ipv6only field directly, use the dedicated
ipv6_only_sock helper.

Fixes: 70d66244317e ("bpf: add bpf_tcp_gen_syncookie helper")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4603b7cd3cd1..05efa691b796 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6848,7 +6848,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	 */
 	switch (((struct iphdr *)iph)->version) {
 	case 4:
-		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
-- 
2.30.2

