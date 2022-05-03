Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07993518AD4
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 19:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240171AbiECRSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiECRSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:18:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C47439816;
        Tue,  3 May 2022 10:14:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q628NgwmU8cddiupv1PQHeDeODg8AT8wKiaSDAm62Pr8YaatJ7rE1S7E0qeDJ75rLQg2y9BQQtl4RWLsmI2XVGmaAjSn9c2WCV89kuF73xRKkekcjUNb5GZK2cixbxskdXnEXMZ5gt+gTBwEVDXx8ZWcTgV/D2TJ9Drv3LKS9UPV9WqRjccpqWEyTgYa5uyQKJfIlSuVMNVnDDVj57FR+uvkZdEbQ5bXePPiGQ+TL0ucH3VTgS9+erUjj20SkxXNwXsYyCKGJU/baPoQ82g3nkmvvWusiE5HSRRqIDiw9VteAffxwH+iHdT0q04oVRJXfgm76gY5Cb/2i9Oqo2/BHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jFYVXsAiIAAMpp76D60LJxpRBskdYeGC3vhq/HqfIc=;
 b=Vwq4wKbIoSrHe6yBawd9C8vxyvgZ/nTTsskAzIwOviamu3dC+ySzqweYqXWs1+6qSLTcX4xxxpaizyDtp/eNF0SaONFIYObBAHnmsUjhwHJl6x8o0PGB4VJexaOIsBTX4HygeAVTzZ5kw0DNQSpRd0SIycqZDOmEWtYIld/yx2aAsg4pk9q+oU4R2iIThyUtTUtahsCpt81ODVzulgmxHDBOwbgdk4SOTFmWRS2enq51MhCs6sIk30dldoy4tw0BAxdCpA8L7h4UaKpmMuf1OFx4LBnGD/lqS43Vkd77IphAdNJ4qioGqLGIP5HRJptQZqcarFWKcM4KEHj7TyJfDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jFYVXsAiIAAMpp76D60LJxpRBskdYeGC3vhq/HqfIc=;
 b=hpTR+2sl92J2jz2+68vrCjHFSxCjC6Fl1l4UKU3uz2QjcSMAkJKlpvxCw9cA3HX8PPoppzveczDxL5uWtZ87mgsLXkRmmKa9Y5IqxrCMkJLBw4x5KDD4tBArKW7FvNwmfjVTGXIp3XjetWaaDI1+gO8vdzAMyNEL0TY55mqRMn3EaNftUcCfD4sNJ1rwR2Io0AJp2Yr61V09LiFVhbuQsP27efz7rVott67m43BTknR+zt7ciyTj2gQyis4unxUbDOZfDE7wiw+px/oHm64P2oHWgB4HwUL+/i0TybKsn1Ipb6omvuA728SzJ8vBRVqXqp2QiXES9pIZ0uqOzcqrKA==
Received: from BN9PR03CA0655.namprd03.prod.outlook.com (2603:10b6:408:13b::30)
 by DM5PR12MB1578.namprd12.prod.outlook.com (2603:10b6:4:e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Tue, 3 May 2022 17:14:56 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::eb) by BN9PR03CA0655.outlook.office365.com
 (2603:10b6:408:13b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Tue, 3 May 2022 17:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Tue, 3 May 2022 17:14:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 3 May
 2022 17:14:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 3 May 2022
 10:14:54 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 3 May
 2022 10:14:47 -0700
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
Subject: [PATCH bpf-next v9 1/5] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Tue, 3 May 2022 20:14:33 +0300
Message-ID: <20220503171437.666326-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503171437.666326-1-maximmi@nvidia.com>
References: <20220503171437.666326-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13ddbb49-cf44-4f1f-6023-08da2d287220
X-MS-TrafficTypeDiagnostic: DM5PR12MB1578:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB15786D35D0F63013AAC92859DCC09@DM5PR12MB1578.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VWcGeMs6p7sLJeMSQLwmrZFdtj2SUDbtZFEE+QIAYm2CLYxBqhliEkzfmvPPipnPHFBKEUsIvFz6D+x5kcXUvW0P4Hfd0RGU6cvPLTVGsIbU4sNHJE92n3jyM6BPK1YJ4rtBItaQHKDd97PxcreZjj7kDe0REJK7NbExrTP3MbwcwHeTdvrYWUFx5PUHfsWAG8IhZiot/xOOwn7pKk4zNPA/JQlvEiYHezw5Q02egi1qM8T6ryWUZ1XHUOHEmx4TOB9np8hZj3aYeVtolLwgJL++ieRkVB9V+MWPcXN4zAnLZq0rJ5QFsMWepLuVpDTQiGUXrJF/DtPjS0eBGr1FNw8KJPJVH62NehrgPkLw5RdZMNqBer/dT+dOjLnAfVRTUOJa1c0ck4hTtp+0PYCtUzOfmqW1GSqIq6Em1czjiSelY2Fj7LdqbEr0yCQM0hSeI1r7no68xETbMkC88pycFr+9gGPaxzdsIyufyg2JgpWWn14X9TmuvXKoC2cIqtaPrkWtGycdp52Sh7WioZtobUNfgDaKcjdimRRpnLTs0SfdBOC/oMyOd+WgPL0lZvZOV5Js/5rUifWd9+0i+VDiFg7ntN7+8rzVEbJaPYnwRQHqbSD2Sm/4BZ+jqtrGCU0/2rREEEhoFuHj67c3TNuz5dOLvwMT4K+phKlI2TUXiV6CFxioD2ON4rv2oJGqdw4yi8ecIYHybAPgmSpcs07M2A==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(508600001)(83380400001)(36756003)(36860700001)(7416002)(54906003)(70586007)(110136005)(4326008)(8676002)(6666004)(70206006)(8936002)(5660300002)(316002)(1076003)(107886003)(2616005)(426003)(186003)(336012)(47076005)(26005)(2906002)(86362001)(40460700003)(81166007)(356005)(82310400005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 17:14:56.1294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ddbb49-cf44-4f1f-6023-08da2d287220
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1578
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_tcp_gen_syncookie expects the full length of the TCP header (with
all options), and bpf_tcp_check_syncookie accepts lengths bigger than
sizeof(struct tcphdr). Fix the documentation that says these lengths
should be exactly sizeof(struct tcphdr).

While at it, fix a typo in the name of struct ipv6hdr.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/uapi/linux/bpf.h       | 10 ++++++----
 tools/include/uapi/linux/bpf.h | 10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 444fe6f1cf35..4dd9e34f2a60 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3587,10 +3587,11 @@ union bpf_attr {
  *
  * 		*iph* points to the start of the IPv4 or IPv6 header, while
  * 		*iph_len* contains **sizeof**\ (**struct iphdr**) or
- * 		**sizeof**\ (**struct ip6hdr**).
+ * 		**sizeof**\ (**struct ipv6hdr**).
  *
  * 		*th* points to the start of the TCP header, while *th_len*
- * 		contains **sizeof**\ (**struct tcphdr**).
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  * 	Return
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
@@ -3773,10 +3774,11 @@ union bpf_attr {
  *
  *		*iph* points to the start of the IPv4 or IPv6 header, while
  *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
- *		**sizeof**\ (**struct ip6hdr**).
+ *		**sizeof**\ (**struct ipv6hdr**).
  *
  *		*th* points to the start of the TCP header, while *th_len*
- *		contains the length of the TCP header.
+ *		contains the length of the TCP header with options (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  *	Return
  *		On success, lower 32 bits hold the generated SYN cookie in
  *		followed by 16 bits which hold the MSS value for that cookie,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 444fe6f1cf35..4dd9e34f2a60 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3587,10 +3587,11 @@ union bpf_attr {
  *
  * 		*iph* points to the start of the IPv4 or IPv6 header, while
  * 		*iph_len* contains **sizeof**\ (**struct iphdr**) or
- * 		**sizeof**\ (**struct ip6hdr**).
+ * 		**sizeof**\ (**struct ipv6hdr**).
  *
  * 		*th* points to the start of the TCP header, while *th_len*
- * 		contains **sizeof**\ (**struct tcphdr**).
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  * 	Return
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
@@ -3773,10 +3774,11 @@ union bpf_attr {
  *
  *		*iph* points to the start of the IPv4 or IPv6 header, while
  *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
- *		**sizeof**\ (**struct ip6hdr**).
+ *		**sizeof**\ (**struct ipv6hdr**).
  *
  *		*th* points to the start of the TCP header, while *th_len*
- *		contains the length of the TCP header.
+ *		contains the length of the TCP header with options (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  *	Return
  *		On success, lower 32 bits hold the generated SYN cookie in
  *		followed by 16 bits which hold the MSS value for that cookie,
-- 
2.30.2

