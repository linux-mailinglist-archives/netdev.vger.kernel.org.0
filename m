Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5089F4FF800
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiDMNoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiDMNoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:44:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728195FF0F;
        Wed, 13 Apr 2022 06:41:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdwKj63iCZnSOfhv9bEdHmxq65SmoFas8dEzpNNKvn+U0zKtRZq/7RoNyTID4IqUex8PKR55twIfKDhCp9gu4tT6FGkosjZAEuDLUc6nxyna0lkf+Yo6e33MoahgfOTafr8AaplBAg73h/fSwDaQbuJ5r5Z3aaZqmSP7HfUU3jk6Lan58NLMRB91uAbZuQjfDq3XLmmMdoTXFtN4BCzZg+ViHTJeLpzDsMQJ2di5qsQnAqVlpo6KFb8ggFjHr1v9oazn6n7ie8L9kOYcSTd2Rxf2r2yIeXJ4Tx1TkOLtADV3QxJVQAFHgTqUvAxF7ZZF5MuGZtJEZaDjTZH2anzhXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VTusb6wnxsNZC2cakXoa8W+UCupmZQQVApU43+RyZc=;
 b=jiRJdNMfZFTFQsZCGGL8QRdh7DjqFOpZL3U+v651ijWBPuQ8tp7L6Qgu8urSMuf0Z3APDvsrquh6qa2/sDFgCfyxJFEWFy6Y50mIMEOq9WtSsMWqdsUe4rF7ks9Pyrn5K8ETBrHg4yZ0kfC5NqTYOLYtM0oI/loD+vJKzRhoXmeLXJj/sAJ1Xo5oIIfpx8fZf/FaqWwOAt8IGlVY4GARgDD5sLmXv+Evay+7JdgSioRmyJLa4nnJjL+PosGUjSQPKST6Og0KI/w9iFlcLbYwI/2B4Xgxw9xmqaUZ4RoBajwPH37GvWm9m02zwUGpjp44x8DVEtO7LY0q9jjmL+tlyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VTusb6wnxsNZC2cakXoa8W+UCupmZQQVApU43+RyZc=;
 b=KRUC2ClArH+yVEjoHnpSCqPKpkmAnVp7pusMtcMhJeDTTdNzrDJKaM+xiisr9BdW1VhmGI1fM73kuNoPpHYHnsD5L6YIlPEPie2Ymp/bxqE88sOH4Hh62qnc5FBLpzWJeggVLrsPgkltCmoCkB/imAOIt6Yg/4kZ1whP+w8YTVEY6I6a3lhPTiLAlSrhsFN4MDeFcr+TWbVz9fa26PQjFBQIK5Ao4nT0r/GhRHcCZtlCHDQbWl/KU2ouzbxeF6/YuUC/GovWaF4TP2rR4mDBTfynjJa/JBoB/mAPEQnjaMEk9IXEJDs3RKtYibybRmehKGCQp7lQrbGpivbXMtS1Lw==
Received: from DS7P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::26) by
 DM5PR1201MB0041.namprd12.prod.outlook.com (2603:10b6:4:56::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.29; Wed, 13 Apr 2022 13:41:38 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::dd) by DS7P222CA0017.outlook.office365.com
 (2603:10b6:8:2e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Wed, 13 Apr 2022 13:41:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 13:41:37 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Apr
 2022 13:41:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 13 Apr
 2022 06:41:35 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 13 Apr
 2022 06:41:25 -0700
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
Subject: [PATCH bpf-next v5 0/5] New BPF helpers to accelerate synproxy
Date:   Wed, 13 Apr 2022 16:41:14 +0300
Message-ID: <20220413134120.3253433-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af6490ad-f206-4629-d710-08da1d535579
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0041:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0041B595B770F0E9626CF65BDCEC9@DM5PR1201MB0041.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zOBHgqkNI9BqaOv6SR+ZAJGhxDC2He/Sg15ALJUhJwA12TJ39U9HERrDr8Grzkpr+Tsh5rmgSN3sm/N9q+i3wu9kfdYcpBWJRID1FLlCGh755irmPjN33ll+tvP6luBAHjmGsCf1iKV8EFo+5lZlnbM36/NCOS1/BX/JgBhg7VIfdDdTFLWvKUwBPAVmQFh0AKlwrMTFQvQZh5o6PIHr+ZQh9yReEr8bgg38pXzgMr7iBSJpR57srlCZ/LhZrriN7Fv7+gz9ZZvhqeM4SlWEGwlWKjwxH8ok8iqvGNxRCQbPN5x2rlSdiv0+XL+7YM7PEY8IiF8k+vZGOYt4Oy/8Zp/SbEOgUPrztLOhiMV/55/bBtCZpjVAkOEqhLyC7JabAJH0b/hQ1BVl7Lm8cNXR3xbq0L2pTVAtH8p344tiHuSAWSxICwR4KLM3R/ma/xstF90YUJu0Fgm+K9LTIQj6gjp4CCVQF4n4PhAysQDiR8il/Aa+EUJMh0/4ky0iWsv8stjnBi1wGtHd4LnXMGK4PFRnkNfIKH7IQDpJah0IcNLVbXkbnb99juI+ulPJ22vBacmQVH3FnPaL7YyHqteQFP+aI02W1/LbScEYQ1vf6m4NfMmOV1nEsGn4TGObQtuqi0KZXKjUKCrZjR4siREKNnDi9zcHV+j6nUMzWDa3qIWdvvm1FMCo4/kM/xXPIuaOG4DPJvwh8bTY119HQjn2ui53RZnQN8467qjhHmTkHdS2/tIWUFEXeOnZrgkkYLIr0sD8iuBFBMBKZWNR7+ZSs5B7F4Kbpud2wWJM+tQRvgXGO1WKvRrxnmsWxWqMqa6173QpJTIX3qwoC9yvtjuPVw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8676002)(107886003)(26005)(70586007)(70206006)(1076003)(4326008)(508600001)(36860700001)(6666004)(356005)(7696005)(54906003)(81166007)(86362001)(316002)(110136005)(186003)(2616005)(8936002)(966005)(40460700003)(47076005)(2906002)(83380400001)(7416002)(426003)(5660300002)(36756003)(336012)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:41:37.8635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af6490ad-f206-4629-d710-08da1d535579
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0041
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

v4 changes:

Converted the selftest to the test_progs runner. Replaced some
deprecated functions in xdp_synproxy userspace helper.

v5 changes:

Fixed a bug in the selftest. Added questionable functionality to support
new helpers in TC BPF, added selftests for it.

[1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
[2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
[3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP

Maxim Mikityanskiy (6):
  bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
  bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
  bpf: Allow helpers to accept pointers with a fixed size
  bpf: Add helpers to issue and check SYN cookies in XDP
  bpf: Add selftests for raw syncookie helpers
  bpf: Allow the new syncookie helpers to work with SKBs

 include/linux/bpf.h                           |  10 +
 include/net/tcp.h                             |   1 +
 include/uapi/linux/bpf.h                      | 100 ++-
 kernel/bpf/verifier.c                         |  26 +-
 net/core/filter.c                             | 136 ++-
 net/ipv4/tcp_input.c                          |   3 +-
 scripts/bpf_doc.py                            |   4 +
 tools/include/uapi/linux/bpf.h                | 100 ++-
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c   | 144 +++
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 819 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
 13 files changed, 1790 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c

-- 
2.30.2

