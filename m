Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4DA50BE99
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiDVRbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiDVRbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:31:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635EA96807;
        Fri, 22 Apr 2022 10:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBz0XOslKpNwVJo6O4bKGFO1RQcbz5rq39Diy63tSXMsS8xA58Uyb/O1+aYjE+6GsIq8BJbLDBQjBlpCS4L+9lAyqCRuwF44BFllRwVrDSfgzpvuJCJadweIxecLB69vxtRuFLSHgwjUsETCqa7fijcEG410XBxLUNzMOzx1YpC9UlBEkuFStXh4EQs5/cyZh+MI3UWg9UfEm+jCdB8uSJ8/gJES6GeIbap6XmdrlikvUCGsWxMneJiupfNn+ptHCeKcp/TIfmOu0wxYMkvPN7uunDVmkNohCqjHh/GBSaEdRr0oaExO7QdWMhoSdwkaZaKTiCqNcmKMHp8HUxFVaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFQwhPnaKv6Borx7fkXbGSMbgkP1qrsQyquN1OU7cpw=;
 b=PGGtMvkkLJvj4WSV983k/Hv4MTSQXtybdhRxaF7Ake3MDDTQmwSOKJkTFR9WFcZfsLWVKT+8Yxz5O1z29fXcMWBKt3z7qJ8qtEslJxnBo4p5rmp3wshYmJcX4xHx41OWjyPyDkWN4117HqPz0IKhDRNu4V+aV6ccTF7v6nnbP2sQZSDS3USNxJMZUQEA+gqP27AD1y2cOxTL3HxFmX5Cuvar5gyhyxNRloUxz1phG44lao86VNsInKSJSeKJ0zFfodAfzwG364+dUgO8/9Cw7dZsJJX2j6fs6K4LbeQPpgCWbIYIXZdMP/kNxqLfLXa98TGzddxCcleUDMf6c7ZkZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFQwhPnaKv6Borx7fkXbGSMbgkP1qrsQyquN1OU7cpw=;
 b=Z+uPWzWdgnpl4DylgYmrOLW+F53+hXwYBMClsmNrArrAmRr2chlgPATy7JOtcbON0MxOJydSjtZveGASSXD8ZbhSAq1TIivsMY+Ej5ITziesFS0o9RJGHOJqsQ70vfpZOOkFX9Nc4AGQhf44rjEwKTAbp1DcVo3vjKbjulwP8hyp2rErXq44wl7qOyg9cGx/m8LkHlokxk3Oa6OgCP8y/V4QZWaK8cRTtyIkcsvgZEyI4JImg+/VmBcRWuC6tHv3zW0tQZwpu354oWAK07kpibOApGwOuH1VE4Btw72DD4JxUVfRXX57Nyn44a2ki84+/qtu3oBLGqNMOOOlyeADSw==
Received: from DS7PR05CA0057.namprd05.prod.outlook.com (2603:10b6:8:2f::21) by
 DM5PR12MB1227.namprd12.prod.outlook.com (2603:10b6:3:76::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Fri, 22 Apr 2022 17:24:51 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::39) by DS7PR05CA0057.outlook.office365.com
 (2603:10b6:8:2f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6 via Frontend
 Transport; Fri, 22 Apr 2022 17:24:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 17:24:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 17:24:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 10:24:49 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 22 Apr
 2022 10:24:42 -0700
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
Subject: [PATCH bpf-next v6 2/6] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Fri, 22 Apr 2022 20:24:18 +0300
Message-ID: <20220422172422.4037988-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422172422.4037988-1-maximmi@nvidia.com>
References: <20220422172422.4037988-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d12bb455-ffab-489a-8c6d-08da24850237
X-MS-TrafficTypeDiagnostic: DM5PR12MB1227:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB12274E34D73244E108655BF6DCF79@DM5PR12MB1227.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IR3M05sSOktLkmsyf6KS9wf45AaoUIqKRqAcML9azIR/BgalFKqZjYvdORJ0WbcXwJNDrmMc51dqeWd2q652dWIag76Rm8i1hMXqlPg0Eaa9EVgHMl8xAx6jnmviSB7eNgtSFuFPOeYt8D6bJ7nngaKqBBoa30R2CeyQT8HIB+EcIdZG03a63wU2rtUEaFSoTgqqnFY9AiL+wdTrZ0cLGz98AMiGe6NAKrorcHlgOkfKyA0+evkvVoacaLvqt2DIZAjD5IzqlJOW0wQR+6kx545/wEKA8ZDFSu5HMf4xSFwK0GevBtezjhrz7lYrJ2K+6SSsyROsVaRSxH5m3l2zQFGLelCSnHJNb/zYRWtqTy2dz+xTjxAhMjm5yGo4ABh42B0K7iYaBFyhMDwBB9J0uTzjYAK+5/tV847Qa6bkOqluX0Bh4Mb+FN7fmBZRnVdrC23Kslua6BeNcyOHSqS3PwbvfoQkiCdXx3JtqO5ht44sBvtDPEhi2Qdo/MMacQyJCutU/r/NLD0miWlZzWTwAPgIEi376cZC3Ipkh5gwF3xXnaTCl/qjLadWs1XqaTqXittuZGznPSyGSUMtafmxODSLMyMBuEqq4P446gSCy4kCo+4rKJ0mXa+K0mM/gAP3pekqYAvFCSMX8+SDyRoYn9H0ceRGyiZfClt3nADxqgUIgM4djLV7JRrsM1mcc0/VLIo+6xUmB621p4xSi8peOA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(5660300002)(316002)(110136005)(186003)(8936002)(7416002)(54906003)(1076003)(36756003)(107886003)(47076005)(426003)(336012)(83380400001)(26005)(7696005)(2616005)(6666004)(508600001)(36860700001)(86362001)(2906002)(356005)(40460700003)(82310400005)(8676002)(4326008)(81166007)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:24:51.1385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d12bb455-ffab-489a-8c6d-08da24850237
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1227
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index d14b10b85e51..5e1679af8282 100644
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
index d14b10b85e51..5e1679af8282 100644
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

