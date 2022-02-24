Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286044C2F10
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbiBXPNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbiBXPM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:12:57 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2068.outbound.protection.outlook.com [40.107.96.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F5420428B;
        Thu, 24 Feb 2022 07:12:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/JSQnOecOHeNVwLCTQ96ZWO5sjv50zcGJwEa3ZnbdD1AYiz9BFdlIl2FSb1Zd1lh1Jsh+UU867o5W7S9RhN9tgFeAZjP6GZXgBIPwHj0KOwecFimyccCNknwGjFRt0Yd9FM2B8EccLpI9DY1pfaj3DPDwHdvCAuBXMJoQjMLkIt26a6HykbWKrytSwmW/jNABl010NZtGw4Mll9o84MlhNUe52GLlS7uWear2QybpXX+icve8yqSpyVHX4oYtMgOjyxfFhekLrOUhjVEemSHtqAydeCJBXbskLCqOmJZAMsMtaOl3Kau09s0ctWlFb5OCc7IcLuf2/n3fGMpBRrIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgJ5Xe4z288cQZ0ilvHgU6L/8kSZR7OFXwiGlJsqQ7E=;
 b=l+5L5Fx8Uu0/RJFar66R6IHMwPygaXJl6Rlc8b3eYT4Yg0H26kmyc2ufaInADs/9WncqPuPNHVG5BmJm7WY+bRV5G2xcm/6FogZWEATLSXf5+0t/pu0ZH5w5UESZd59wklCcr4nrT1YqOYMsbvgBa47JpisNVWSzRnnCQtrpoXixlqAl6+xq2b7n4meCASMkgo8iDUo++p53dCrehdtm+Hxvj4Zxi10ZV666hVvXRvAy6IL5oHN606gsekgaRZOcdODz1q2LhcsAtp45RgcNxI7G2Y+wYS/wBnpAmwoepOju5gTBlt/AyT2lg6A/gz8BaRvJgaBNXU7muTceYt+Ebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgJ5Xe4z288cQZ0ilvHgU6L/8kSZR7OFXwiGlJsqQ7E=;
 b=jnapSSyaCcwTdxlzOO9szdXpSCl52dM7QTBPuZyt308Hd/UKAAdwn8uG8GJKi3K1MJorDDBQIEwSVAR1EqYs4klO+2+puBXukBSzMVJtNLGzpprYCiDFc4x2tPnaS+53KdAlHyF/qsct+Uzt8jQWmY1z7StnBWn29ZCgp9KUSaCmGsEhfVZzF2pqM69cHeojXC1WFPzc6WbrOWcYa8P7XQq4aObsTQjv+xuBdX7eYWTR4xgxW4RH/GnFtW6U8Up6l5fcGzHibFq1klbQL/Pyny56PcgLwHJaPE343KIW79REDt8hDEoZfIsT2N0NzRY6QlzyEmn9kvf0/L3SIKIKRQ==
Received: from BN0PR03CA0057.namprd03.prod.outlook.com (2603:10b6:408:e7::32)
 by BL0PR12MB2577.namprd12.prod.outlook.com (2603:10b6:207:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 15:12:26 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::d4) by BN0PR03CA0057.outlook.office365.com
 (2603:10b6:408:e7::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 15:12:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 15:12:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 15:12:25 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 07:12:23 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 07:12:16 -0800
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
Subject: [PATCH bpf-next v3 0/5] New BPF helpers to accelerate synproxy
Date:   Thu, 24 Feb 2022 17:11:40 +0200
Message-ID: <20220224151145.355355-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 552ca9a6-51f5-400d-6793-08d9f7a810de
X-MS-TrafficTypeDiagnostic: BL0PR12MB2577:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB257727459FC2AB6D0D84B89DDC3D9@BL0PR12MB2577.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u/pTCFmqh1ZcSpUlkNb0SXgmop7PYZfr5uG9L72f4v+xQ5wpfXr63oL2vszf2Pc9mjN0OI6kTJll7ZbOG60UwYzIIWPCl/4R0UoWyM7KhIxoqMaJ22chN4oVCps+WNfEw/k6SfJTryz9Wu1OBrjMhl/IEE/w3OTBG8ydyvfJOCRSy25pMb/BmvXOvlTyRiW7CyMX4Wv8LPkf+y/knokLogfMe3ao7R9SGgCT8D6xuZdbaCHnlwaP7hX/PDuPHJMpcbi5lpenuQJM/guwu0Ffer/0hPh0iYD1+j2CCRyFtPqXqLEQhCf8CfnEjfJIvjhppwAq7arihfAReF+4qh5DNG/a7U8k9SIHBsqWbccVvMfQ8sb3rUIEN2/KAccMA+Pi0sDTWk1yGAbttCpA8fuv3fJP+QFpD0cyJuvQPOfibUakQdmp48eoV6vCy6a1BMmGQ2+G84tXUcfB8ccXPlPETOIG3kg/nHk3R5K8GwrZT3zGw7ptln/LaldSTBp3pGRokpCvdese2d81yHby8dkLcW9Kzt8P1LaHmtQYzzKyiUe7tijlyJxWqtsT+1XSw/buzD2KtHzY/KQ05CwN4gE+owEgeGpVU0obFp6K8eKBdMyGX4C7sxtJZLyAAZTjeFGenj7jtnHVOvH7O+Rvm1jdKvL0wz//elAKKgyFa/jB+b1k8Le3YClzPl6LWFTyPN07zjoN8z9JZ/p9CjObgRf/ffRdbqGSeahzfmOsS11ij/MESdih9sNkLbLbRbCS3+YMGFAJqaLZyZyiv7RDz7Hp5usdem3pqOPQBib7ZCyyRS3Fyge9FPZDPJobg5mLp54JCBtJFvb0m1J/VKNln6e4zw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2616005)(4326008)(82310400004)(186003)(70586007)(316002)(26005)(8676002)(36860700001)(1076003)(70206006)(107886003)(47076005)(356005)(6666004)(36756003)(86362001)(40460700003)(7696005)(8936002)(508600001)(426003)(5660300002)(336012)(2906002)(966005)(54906003)(110136005)(7416002)(83380400001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 15:12:25.7494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 552ca9a6-51f5-400d-6793-08d9f7a810de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2577
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch of this series is an improvement to the existing
syncookie BPF helper. The second patch is a documentation fix.

The third patch allows BPF helpers to accept memory regions of fixed
size without doing runtime size checks.

The two last patches add new functionality that allows XDP to
accelerate iptables synproxy.

v1 of this series [1] used to include a patch that exposed conntrack
lookup to BPF using stable helpers. It was superseded by series [2] by
Kumar Kartikeya Dwivedi, which implements this functionality using
unstable helpers.

The fourth patch adds new helpers to issue and check SYN cookies without
binding to a socket, which is useful in the synproxy scenario.

The fifth patch adds a selftest, which consists of a script, an XDP
program and a userspace control application. The XDP program uses
socketless SYN cookie helpers and queries conntrack status instead of
socket status. The userspace control application allows to tune
parameters of the XDP program. This program also serves as a minimal
example of usage of the new functionality.

The draft of the new functionality was presented on Netdev 0x15 [3].

v2 changes:

Split into two series, submitted bugfixes to bpf, dropped the conntrack
patches, implemented the timestamp cookie in BPF using bpf_loop, dropped
the timestamp cookie patch.

v3 changes:

Moved some patches from bpf to bpf-next, dropped the patch that changed
error codes, split the new helpers into IPv4/IPv6, added verifier
functionality to accept memory regions of fixed size.

[1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
[2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
[3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP

Maxim Mikityanskiy (5):
  bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
  bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
  bpf: Allow helpers to accept pointers with a fixed size
  bpf: Add helpers to issue and check SYN cookies in XDP
  bpf: Add selftests for raw syncookie helpers

 include/linux/bpf.h                           |  10 +
 include/net/tcp.h                             |   1 +
 include/uapi/linux/bpf.h                      | 100 ++-
 kernel/bpf/verifier.c                         |  26 +-
 net/core/filter.c                             | 128 ++-
 net/ipv4/tcp_input.c                          |   3 +-
 scripts/bpf_doc.py                            |   4 +
 tools/include/uapi/linux/bpf.h                | 100 ++-
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 750 ++++++++++++++++++
 .../selftests/bpf/test_xdp_synproxy.sh        |  71 ++
 tools/testing/selftests/bpf/xdp_synproxy.c    | 418 ++++++++++
 13 files changed, 1594 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_synproxy.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c

-- 
2.30.2

