Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF91433911
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhJSOub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:50:31 -0400
Received: from mail-mw2nam12on2057.outbound.protection.outlook.com ([40.107.244.57]:53729
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229641AbhJSOub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:50:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuaITKXVjeV2xeMUkmILYlBI0mX+fNub31B9JBT3Ms5+x1lrgOkZxrCKyQSpuvO+Y7++DhBo3x8ByJDYEAyk1fqIWecUfIYUpQRQ9Vwe2xrrJwXDlDiMH6iRA47mVQNWWuH4bVTqYL1QxOm2l/mgbQv8c9CjKpeCxGRWjWPTm/P+PFsBF4TCW5zcLejr86BlLhsl9FA8nOwYBL+fJwfsMOlYkQEMw0VmtDA9DeYQkMdoNqrgt/vH0PTU5kM1IyRb8V/l6VYLlqbuP0Uk/gsYDdbgsRdUJ4uOLmU+XtKXjWDzdV2AmmgEepdYLGjbhvcVc73qF84hmxRMQQqp12SVeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jb1uETqWVAaoOM305t81Q0H2Deol3CCp7nQLsSHbUSs=;
 b=cUV0fWxbR1yJgKF7ATeDn3LWL70Yw1Kvlt75aXJj4Xg/NmfrgpYw5Vx5kj7h7TQxTCnvoKYlQHinMJtSph7wJ5i6HiEq33zotDHGQM/VEXNbnn5kobBV7raE6noLkiAlge+BvvB+nAH4D8J5HqjWOYJs39qxRsB0+D0FFFd0oaoA877P69doPwo2wDR3moL+i8ELAponwAihIcDOSx7RNBCBrBtvFDL0p0zbme2PGSS9mMhCBzjEdwIC2fY5svrXB3JyokgJ3vcJSF1ZcO2xMemPqDZT6RZ6lsbxW5FHhvFwvvbsNUD8dRomcNspaB6EDtl5XTe5xDUl9Fy3yti7XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jb1uETqWVAaoOM305t81Q0H2Deol3CCp7nQLsSHbUSs=;
 b=noWFWeo9pLoWmrfVQOwhYqjqqjBknTiqkbtOZQMqy8+JWpk7tTM+ySx+K0c7Hm2up8HNc/3XxZujMCjlm6aV19Idm2aY+4+cmxsTumhea6GSbkzTlgiwzxQDK+sibOJSzd52h1ITqEiWDgLcrkH6UqtOShhUbePiFsLNGkVPRM7FSTflhDkaGX/Bu+grKVw08wK9puWID/X9it6vNGygk2ifrYl2UntMbSPEiH/KiioB9sm3MkeN+1PKJUnXl36sEofdF0WXrDDeSfRQYUSNtWJD0rbxyWeksNlzyWTPp1bEXAXQNVcfDB2ij3FnWP08p32PdVLPSvWkVnkECUNBoQ==
Received: from DM3PR08CA0021.namprd08.prod.outlook.com (2603:10b6:0:52::31) by
 BY5PR12MB3684.namprd12.prod.outlook.com (2603:10b6:a03:1a2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 14:48:16 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::fe) by DM3PR08CA0021.outlook.office365.com
 (2603:10b6:0:52::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend
 Transport; Tue, 19 Oct 2021 14:48:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 14:48:15 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 14:48:14 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:48:03 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next 05/10] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Tue, 19 Oct 2021 17:46:50 +0300
Message-ID: <20211019144655.3483197-6-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019144655.3483197-1-maximmi@nvidia.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea5932fd-8d1c-4ff7-2166-08d9930f7bb1
X-MS-TrafficTypeDiagnostic: BY5PR12MB3684:
X-Microsoft-Antispam-PRVS: <BY5PR12MB368401FA52943580A4C36C28DCBD9@BY5PR12MB3684.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C6RKjhAPiBOoyuhWSy0Kg2ciyNFQdhKI0nlgpZbbsRhdrz94GzU5SXt9UvyEStw/+eQYsI+znpIg3vjfuZCtKgIu9oeDh/aEUXo1KlHx9g1v2GpJcIfW1xfcM4inUsYOi546LPU3TuVybGZo4YQzt2mcfDy8M3/wZsgTykhjD2sBA11EhpO05oR/GTobdnecCEUCMtIhk0ITlsffjHkpPLZp/4JnRGq4nqP61HfewNCaRi7qzdOx04O2QmsTb5W+anW1zCcMYKCmUaJIaMetcQa2KkNBrz8D7YOmCjJyEn0cpK4whMR4kaOfjVve66S8uroXGdtU8owLIHKvOqAzuddAfZiyWlzt8re22OyTHliUelGlmQ/ug2ejSPUYrfSZpTKZGz6AhbGcAU+QKIvbp4DP04/z3lO/t/iWJh0XAknIpF7W2L+4XBoceN2QXifZrH8/VdPNLCDiUY7w531MmmaoaNlVnqF/eTiKsJflJ//idWMz0OHy+8UP0coM1UvlPuWQGknyK00awGzg/gfHD3p91BQipUeGLpZjbd5t0UQKfJXrXl08Fyfq9IZiwLLB8vM7wPM6CEFN4TREDM+y+h5fJE/e+fFM6PvQxSXrmcb9INHUvAw++yS297cvxswb2iZ10/NO9IyLYd0QDTEmqOKV3AtS2KEDVVDgxA2c7HyhvN7fyjag2ATfIrk7rWmbeKCFWxejAN6CoZvCyiD53Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(107886003)(36860700001)(316002)(6666004)(7636003)(356005)(7416002)(83380400001)(82310400003)(2906002)(336012)(47076005)(2616005)(86362001)(70206006)(70586007)(36756003)(7696005)(110136005)(54906003)(426003)(8676002)(5660300002)(508600001)(186003)(1076003)(4326008)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:48:15.7135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5932fd-8d1c-4ff7-2166-08d9930f7bb1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3684
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie expect the full length
of the TCP header (with all extensions). Fix the documentation that says
it should be sizeof(struct tcphdr).

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/uapi/linux/bpf.h       | 6 ++++--
 tools/include/uapi/linux/bpf.h | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2f12b11f1259..efb2750f39c6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3543,7 +3543,8 @@ union bpf_attr {
  * 		**sizeof**\ (**struct ip6hdr**).
  *
  * 		*th* points to the start of the TCP header, while *th_len*
- * 		contains **sizeof**\ (**struct tcphdr**).
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  * 	Return
  *		0 if *iph* and *th* are a valid SYN cookie ACK.
  *
@@ -3743,7 +3744,8 @@ union bpf_attr {
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
index 2f12b11f1259..efb2750f39c6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3543,7 +3543,8 @@ union bpf_attr {
  * 		**sizeof**\ (**struct ip6hdr**).
  *
  * 		*th* points to the start of the TCP header, while *th_len*
- * 		contains **sizeof**\ (**struct tcphdr**).
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  * 	Return
  *		0 if *iph* and *th* are a valid SYN cookie ACK.
  *
@@ -3743,7 +3744,8 @@ union bpf_attr {
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

