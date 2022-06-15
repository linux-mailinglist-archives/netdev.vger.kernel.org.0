Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F3F54CA34
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348876AbiFONtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 09:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347477AbiFONtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 09:49:10 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368FB3A738;
        Wed, 15 Jun 2022 06:49:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RugtIfv24+lTiTazO9HG0gUSvcd8wzZtyuQLzYGB1/6XaSxJkPUiSJ7TzafPzYs2IJphbW9ywIGX1Cm40H8vxvlsditzFRmTivu+mu0O+GBsPEAdD4IDO09lA23MbE5Hn0LAhu9QHfjZvEzQHc5ed16MP3DONASZFhpgKYjwIszO+KSvK0YjkLTFUrtBLs3zAu6u3hSVhwhyBsPQ03GokMZPYkyF/B5PEk/gtrvaeBfMp0c1NMmhj6cj70JgsUn3OVrs5uTPLumg0BsO8NL/cs8lB3me+tjUrmSU0atNy7cKltxIVpP7YjZYIpYcuyPYApy3SURe5J7ZJW43BTNi3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/wSlEmdkr7/M96u23Frnzi7u/G9YPxcWeHpOH554pU=;
 b=nx/3xO+WvNwAv5IyErU6vZQPs+svl/hdKA+KChfNM2lDk17w/Tzu1vHlWqYeN4A6lgY1UVA01UOJog5/yPLCPQf9wO7i7gNGT+FyCm9gIV2Gje04u+0wmRHR1/MdoKBljwL0cdJ75tI8youqW36C8JGR+uQWF2BcNW11p/VCByqcW7IuhXLzYiTLVWvDVmmxo7xBLoGO01XJh1eURSEpVbHY5E5pltnQFAuGEOtQKQ9GrWNy4xMJf4JSPH4nXhc59fsJLu8x2OSJoD3LAiMz3eEzJeyrxJmrovOWIY4zYA7nP8D9GpWdC+qf5xzh1tXrnnhKyezHTVHy78TUg/R76g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/wSlEmdkr7/M96u23Frnzi7u/G9YPxcWeHpOH554pU=;
 b=cwuMzQqrxqiGAXrNqv4s0JNBmfhZ3uzmC04yzQ6SKjMmyjEKYc0xhu4qtymw2u0qQu8ojYJzxc3HCTKMJeY5JtQ9YUhcufzqJx2WCGcBY4HDJe23+l7rciymsXCOnpCUnMCW00AyNT+w7PNKk12Om3zGhUXJAiWdlFawGfTSFjVPahJX1pjQlw9Y9kb03SwNc5N4S7JQS44Bol/Kw/EAOfS/VZ2J6UMrWBOIDpc2wBwCYDWmxOp4PNVdUouCRc0f28Lp0B32iU2PsfhIgqsQhl43Ro9HMpcf1nwx2yn4RYx6Di1VLXFP0o6OQPEKkGqVVZDzkcmy+zPdvAS4GTGGpA==
Received: from DM5PR22CA0013.namprd22.prod.outlook.com (2603:10b6:3:101::23)
 by DM6PR12MB4895.namprd12.prod.outlook.com (2603:10b6:5:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Wed, 15 Jun
 2022 13:49:07 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:101:cafe::f2) by DM5PR22CA0013.outlook.office365.com
 (2603:10b6:3:101::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 15 Jun 2022 13:49:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 13:49:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 15 Jun 2022 13:49:06 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 06:49:05 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 06:48:59 -0700
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
Subject: [PATCH bpf-next v10 1/6] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Wed, 15 Jun 2022 16:48:42 +0300
Message-ID: <20220615134847.3753567-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220615134847.3753567-1-maximmi@nvidia.com>
References: <20220615134847.3753567-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67b8eaf1-8113-4a57-e422-08da4ed5d14f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4895:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB48951E50A2C17120EB439FAADCAD9@DM6PR12MB4895.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5bHXqKioOuuSIFDC+Mk6/s1sa9H/9LoFBMkOIN0Dg0Xt6P/yzPZ7q46IAMqMz3bL7rUOVbvrapmnwBgB+RtxD6s6mRf4/N4LTADCzn/eb0sMkQAUxxxFwhVAyodKmvy1+odD+ZoP/791W2pbCyqsz9FlfFnmXAc9fbctQr1WoMeD1+oyr4GpU8yZMCFjf3PfChFXeOGHFYNv+mVpCNcUL8k/BJVCn7UTK/U99KJhL9DEtHorrI2dwWyhGqkkY1ar9jBsHUctsc07ska85qZHhflie2KlVqP/hufI+mcJ1zYB4FrzzUgKdrtSNy/TYH//MDc30Ax7wyxH0clZRxwqFW7bz++JsNSMJF7Rt9ViUvlAlaPxUJM1YJXlUF/18oVSFxbtdoYmoazCzSwyYac7CrUELnOmV/ANdIvT+p9ZkLzFASrRedMlcvboUhMNERd5dvuqnzqthxQE6whH5gQ6ejaMjmsoeXF/KhvvDNv7kJj+uv3E9RAdwGtEiB3QvV13Po3JqoTaK4temNsM0pj1ZKPcwWzmLUbRYr9z7/dUDLkXbPUqNYpFN+xh7SvWO9sL35wF/HLpJQHP5zfpz6U0nEr62nVCpfne0nA6mIsXv0dCHG17REiNWMyzRo/B26nTs47wqNslNXNHTBChCja5TgFj2Eye6Olu1xvCNlvYqjFd7NY+nBGIRIHAC8twbpeRIpnXY35yb/9jRatWLkRuLw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(8936002)(316002)(36860700001)(5660300002)(40460700003)(70586007)(4326008)(8676002)(7696005)(7416002)(1076003)(508600001)(36756003)(26005)(110136005)(426003)(336012)(54906003)(47076005)(6666004)(2906002)(186003)(81166007)(83380400001)(2616005)(82310400005)(86362001)(70206006)(356005)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 13:49:07.1771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b8eaf1-8113-4a57-e422-08da4ed5d14f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4895
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index f4009dbdf62d..f545e39df72a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3597,10 +3597,11 @@ union bpf_attr {
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
@@ -3783,10 +3784,11 @@ union bpf_attr {
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
index f4009dbdf62d..f545e39df72a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3597,10 +3597,11 @@ union bpf_attr {
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
@@ -3783,10 +3784,11 @@ union bpf_attr {
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

