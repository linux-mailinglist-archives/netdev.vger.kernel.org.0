Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A948513885
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243860AbiD1PmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbiD1PmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:42:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D88B36A3;
        Thu, 28 Apr 2022 08:38:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTq1At8rS70L/fu6RbxdMBoLMwPFqkD1ZCujtzetWYocTOmowHB6NcCfH41VEm/gAG5aJa9m+MVJuDv0rgfOaX+NAgytvVkAjtKqhnMcAGaSR3rzxDOgKsBC7suu2DjLA1YklUIvt12WkcEvCcKwzPxuD5HbXb4AQ2udkKlo6g6453rzlCGRCY45QAsT5wMnz0wz0X5XSdxXPKrPGwQ53/qSQGCSrq+EEOtFahCmr71wnQqRv4ZWhx9PtqJgJC59T+4m+aYJJowQ6FG4qUXLeP70s9GfGkaX4HCTDzp1Smpdy5JnVcVz+yxb3sZsHwG2gKZdINJ3WL6V3DcYm0GITA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAZFHtkuu4zhqhRuzvveP7TeQtXq21E2+JPjtxtIUrk=;
 b=im3i8IFiwLsiq29AV7gjEWp6CnrOSv9R5U0yzYDBvIC0+PxNIQ3f31EJ7LQrpA3eNKBuLdxlnOLfq52v8HZ3HUIkhLeq/wiwlYLXMBC1t43bdn04su9ppwsr6sXxZx7UkC9zy/cQ0SCJ+MwpCsjcOAuBhlESxzZi0qUmakkEzvYhyk3h/uPM4ECevMgICehBCMsI34BDt5ltJUxIxO0VVrIHpb9YolblLWl/Jh2tAGrJW+E4ZoUCi1aYCrPk4hzXJE+04msOn3J5aFBnFua3ste2sSlHNwCzJkVlnbHTYgfbyIWpEUeTeRmKsbX8u07BnE20yP9fu7saSl18eYlo9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAZFHtkuu4zhqhRuzvveP7TeQtXq21E2+JPjtxtIUrk=;
 b=HVndnuM6xgaYxSQ65yp6G4HkSPalrlz89TxNGVSUWOo1r6CnPQTiRHFwisPgpTJ5Vo0S/6CGN/bbULWJ7nCh1i96Iqep9DejXMkryvmo4Zy5N32S0sZR0eFmfKk4+o4S1IAPYRxi+w1bCul1m0r3Et6SrmoRP2FVt62COlp7u2wRzYQmmtG3tMtjdZac5DKyIYOZjzEMPhIh5mu6lUuRZQV3xKq1trY9gSABg7waUoD7OuCRBvNVgCW1Y6AIIETIg6xJEN8ur1hhT5t3cHB4RC8N4u4u+HOIwRUOz+Zmy8xBEc79p7MRjODN/sTalRKLKUSRpt9N/jwWXIZNjJm6Iw==
Received: from BN9PR03CA0710.namprd03.prod.outlook.com (2603:10b6:408:ef::25)
 by CH2PR12MB4040.namprd12.prod.outlook.com (2603:10b6:610:ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 15:38:45 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::e2) by BN9PR03CA0710.outlook.office365.com
 (2603:10b6:408:ef::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Thu, 28 Apr 2022 15:38:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 15:38:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Apr
 2022 15:38:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 28 Apr
 2022 08:38:43 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 28 Apr
 2022 08:38:36 -0700
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
Subject: [PATCH bpf-next v7 0/6] New BPF helpers to accelerate synproxy
Date:   Thu, 28 Apr 2022 18:38:27 +0300
Message-ID: <20220428153833.278064-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd64f2d3-3ee7-4fd1-0162-08da292d2e5c
X-MS-TrafficTypeDiagnostic: CH2PR12MB4040:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4040873C8791769B2AB987B1DCFD9@CH2PR12MB4040.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLoDi976KBF7FjhhKSlqxB32wm6a4ubwsrAcLuuViOqRSikYB9o2ylFwlzH9XS8uHkQzHxOrsYbIVLyXGU/ieCJMmPomhPQsprc0I3XTL4k2uR0EaMiaeXJ+uwnmYyUyP1WOkazI+alfLdhNDPXdeAXn4t5clUWet1c46Zyvipqoa/OszXE3GsLyqU3/7Jph9AWGRO7equyG+gF2jwk8JWcbHLeuAAyDU2WKgCcXWVmVZ0gDULHZD+LQgcJU8RGD2B3FHlmFvtV3Axd1XFXiPZGBoWFL0RLSQVd03EHCUcYFQ/f26WVUWej9HURACEWMNZ3bmxm06YenDxD8b8/6za0V/HpfeJTgM3oxLi6+Y1ulO8QW1eldseQQCCPWRBnDbqx/PDz4Vf4QKq65pi+rz34Rw1sT6vSlNll7jgXFgcRNsL2+0XycTtcVU6UZ+bXY/SfnDq624SKR+BARRO11fgbcAte84zn/i2KMvfxfjOwTK2qSoFRC1CTxnxT8+3JbaUhEZlbRporkdQZz7taZSmyGc99d+LEFwZ0sIJqN66riTk/aF2l5f4SqlnMokQ6YWyuOKb6aJEw8e00BRMRz4H7q6uVJkTH4pV4RUbFS8FtfsULJ9xgGRdBReOdaWD2oGUm2AFgdwsPahH/qTvlTlvp5ddBcO/e/0/bl4VMJya+H3Q4nL5JSieGs4wLvAhAYog25moHqlbSyBsUOpremdLyBAmdjDuuBSdGz91cPGB3W3xcqyqgE1LSXVsUJlBIhe5DH5GwwNuRyyWPE9t0JXgp/uWxOoP3bzgtzswtGzBCfvcly2DGK4iWKawotPAliDIflMguPxfz9EXKjlJIVVQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(426003)(336012)(186003)(2616005)(1076003)(5660300002)(47076005)(54906003)(36860700001)(36756003)(7696005)(6666004)(82310400005)(26005)(70206006)(107886003)(316002)(8676002)(356005)(83380400001)(7416002)(8936002)(4326008)(508600001)(2906002)(40460700003)(110136005)(86362001)(966005)(81166007)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 15:38:45.2520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd64f2d3-3ee7-4fd1-0162-08da292d2e5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4040
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

v6 changes:

Wrap the new helpers themselves into #ifdef CONFIG_SYN_COOKIES, replaced
fclose with pclose and fixed the MSS for IPv6 in the selftest.

v7 changes:

Fixed the off-by-one error in indices, changed the section name to
"xdp", added missing kernel config options to vmtest in CI.

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
 include/uapi/linux/bpf.h                      |  88 +-
 kernel/bpf/verifier.c                         |  26 +-
 net/core/filter.c                             | 130 ++-
 net/ipv4/tcp_input.c                          |   3 +-
 scripts/bpf_doc.py                            |   4 +
 tools/include/uapi/linux/bpf.h                |  88 +-
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c   | 144 +++
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 819 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
 13 files changed, 1760 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c

-- 
2.30.2

