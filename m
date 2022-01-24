Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3804498343
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbiAXPNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:13:18 -0500
Received: from mail-dm6nam08on2087.outbound.protection.outlook.com ([40.107.102.87]:52289
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240599AbiAXPNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:13:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsy9OgU/WmGaO4ryFyuqVUMk5uuzU/sfnBBNWaZ90z6+5KKMwvPBIZQJDqBOPWNaQve9bqpX47eN4X0wRmbsp4ubmZ8vsgErP1FrbjqL6hXP5Sh9/FrgIWNcXcSASZSWHhY1YNXZ1URG1wbdR3NtA0Pwu4K2qHuwijy+Grk09bJpVUnYUmzca3sNDr9DG5XYXUFIVsiq3RoIlqRpqMEakySwEq8W5RTpvLE8WDmgZIKjpug54NvzVEhiyxmVKmyx/5dEiLjBYUsuZidIUdwjx9CIVFjQeScPe6xdYyOfV0AYNaAkjRBSP0z/6c5kvifISzFYIVKDmb5foVZufzUI/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8pGPkeKFB2fwW6nVl+IHstHP3XdoLL44R7qMXvc4RQ=;
 b=Ym2AP46wGVPc3o+Hk5hL1pbwskzD+RtA4Fv1eenGHy5U81lEwmEgG8+axjypHQZjH8UDr692XGYLDv72pa3vcXu1MBjAbly1wcrvWfvH2FB4i8Hwsu6NQxxnMM4BCLtXYkZUbN1JFYtU2X7ulAO6CYTh5Yvpb9tIGpZopRlw+GpLYdUi1/yjRJdAH1tazEBqgw3ANWJ7fNWDsB8jf+JypRCe0X4J3n3OMUFcKEtBPmwkuinr3POu7xsBWZM/FRxtdOD3JWd0P4BHIeRKBhvXL7HGo77H18E8Pi1m1mazNpgkoLQYm7eJVxrExOPFzOIMTeKtt8Mx0BEuRf6KyeQEEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8pGPkeKFB2fwW6nVl+IHstHP3XdoLL44R7qMXvc4RQ=;
 b=MnqSrXe/JpdRnjaoOFtB9I500QCESNroHRRpe5Bx4t2HEDAt6YLyCL32eeGUln+2KSM9Y7yj8wkLi4BC9MQch4H4xJtdQ4X1dg2lAiq1J0rYA4yQa08dEeVkNR1gMhQRK6HMWaRkXTeOXS5Rky5w3VFedKCtEhJJp/3IO5uu3jlqpU3iR66REmcaX+yOzvGnvIX0G6jlyGqpayqClaFcYSAwWobszbOSpdXtoJmnvzTmQMMdr2K5eRBWpV7lbrf4Qizq2Z6pXsXgLUVscdE6XWC58tF91t46xUpq76z9bG8uDNR/TvUoghE5PmYxhN1N7xI/EUOHE9+a+7JC+Ung1w==
Received: from BN9PR03CA0607.namprd03.prod.outlook.com (2603:10b6:408:106::12)
 by CH2PR12MB3831.namprd12.prod.outlook.com (2603:10b6:610:29::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 15:13:14 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::13) by BN9PR03CA0607.outlook.office365.com
 (2603:10b6:408:106::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Mon, 24 Jan 2022 15:13:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 15:13:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 15:13:12 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 07:13:12 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 24 Jan 2022 07:13:08 -0800
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
Subject: [PATCH bpf v2 4/4] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Mon, 24 Jan 2022 17:11:46 +0200
Message-ID: <20220124151146.376446-5-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124151146.376446-1-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc14715b-d894-4b05-b2f9-08d9df4c0a9e
X-MS-TrafficTypeDiagnostic: CH2PR12MB3831:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3831D61A575CA741FD3DEFEFDC5E9@CH2PR12MB3831.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ub/yR0zgynUXGnJ8oR8/91wvR8F52C4Zun0Zn40zgEh4uwgTlcSCDnB9U/5bNWejvfMcGTVjzv+HATH+io4JCUTA+rbf//W1vie3BjeIvTSS+ReGVOfrxvnQiZNPNktT+wnP6ZdP18Dzjs5y0PFXLNlb9DzN8AUwtL2Erl1jP4HDMg0HuXraBLaJndLqj3jQsd78oIh26eE9rHWdhUw0OyBrcyho8bUMYIu2XBD4RYrtCfZ+hxkMkU8pxPMfJXI48xY2D9laW/iVaXLkiAlrm2gi0ttrHGoEPBXFHMxsTT04tYsjjWH1mWDPfF5b6GOy1RsWA9snO5LGXYPTgz69eNcuTLgkQJ55fYpGqOQYje52r+tfIbVrTGB1EbpQePFYQuTSL2iiwz4Krc54jtndBYLFiiDPMB5VmDRsT1D0jMPzQHQAljCBKNdgwzPITK592dFBUiY2FzeDaWLnR2NzY5W5aDxbeGxc0TOnV4YbNBoWRev/eGAbJyPkl5hLt1U+3kLQYqpjxzAPNO0899/3xx5hMMEX6kJ/SlpUim2XmfiCxcU19Q0Jjn/p86s67v8cp8hwUkklSVj2vIAIA74dakubTzHCeXmmYAl77LkxKil2Pn+c8G2q1yq1DpsQhSX+XCT4zLYWdSzyRqethaAGrFYU8o1NqewbHMKUUfPSW8l1spECQ8qaME3EGx6MnYXedEmMx59ZyvIqVPUQpJ1i2YBpshbcUWeR1/cMmj7XBXcE6LFsYBsjnx8dP86iwcPlA+P/IHhLghxztR7JSQDG8g/EU87CFbcn9pZlAKqYP1M=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(336012)(8676002)(40460700003)(36756003)(2616005)(426003)(36860700001)(1076003)(7416002)(26005)(70586007)(7696005)(508600001)(82310400004)(356005)(186003)(70206006)(8936002)(5660300002)(83380400001)(81166007)(54906003)(4326008)(2906002)(107886003)(110136005)(86362001)(316002)(6666004)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 15:13:13.6598
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc14715b-d894-4b05-b2f9-08d9df4c0a9e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3831
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie expect the full length
of the TCP header (with all extensions). Fix the documentation that says
it should be sizeof(struct tcphdr).

Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
Fixes: 70d66244317e ("bpf: add bpf_tcp_gen_syncookie helper")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/uapi/linux/bpf.h       | 6 ++++--
 tools/include/uapi/linux/bpf.h | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..520f1e557dce 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3553,7 +3553,8 @@ union bpf_attr {
  * 		**sizeof**\ (**struct ip6hdr**).
  *
  * 		*th* points to the start of the TCP header, while *th_len*
- * 		contains **sizeof**\ (**struct tcphdr**).
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  * 	Return
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
@@ -3739,7 +3740,8 @@ union bpf_attr {
  *		**sizeof**\ (**struct ip6hdr**).
  *
  *		*th* points to the start of the TCP header, while *th_len*
- *		contains the length of the TCP header.
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  *	Return
  *		On success, lower 32 bits hold the generated SYN cookie in
  *		followed by 16 bits which hold the MSS value for that cookie,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b0383d371b9a..520f1e557dce 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3553,7 +3553,8 @@ union bpf_attr {
  * 		**sizeof**\ (**struct ip6hdr**).
  *
  * 		*th* points to the start of the TCP header, while *th_len*
- * 		contains **sizeof**\ (**struct tcphdr**).
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  * 	Return
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
@@ -3739,7 +3740,8 @@ union bpf_attr {
  *		**sizeof**\ (**struct ip6hdr**).
  *
  *		*th* points to the start of the TCP header, while *th_len*
- *		contains the length of the TCP header.
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  *	Return
  *		On success, lower 32 bits hold the generated SYN cookie in
  *		followed by 16 bits which hold the MSS value for that cookie,
-- 
2.30.2

