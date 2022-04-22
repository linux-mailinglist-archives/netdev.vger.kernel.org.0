Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B28150BE9D
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiDVRas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiDVRar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:30:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB018DFD66;
        Fri, 22 Apr 2022 10:27:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUOD38dWQXO4GlY90Ocniye2C2h6lFDuEeIwh/3MFVOmQTTUb9tCUQzXFardyUMLs0z/4lN3YBJFju2LCgAIwZOM+zq+JmnibXK7XVAiVdt7psJjzVpvMVjvOnedFmnsM81plZWMP/fMt5HVS1z8G8AylGBw3QAML7JjmrUYrQpF16KH/jUroarEv0Ivo8ujjhEqwmOpbF7zevxJAuMb1HNYopppEo3eWSQdf1/GcdqBaNt9bshmBvr8HZcg8dy6/j8oBzFIeEaZD2VS4q5j8p+Z/22Q8JLzrAH/GOuyaKCYuHo7eDQVdwbdE3m/uj1U/EQ3kWO2L/bsmJp0+CfX6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uq0pnxBXQ68eX7qJLAZxR5XuuIDPguXAFeeSXP55jXE=;
 b=BY3fhcYqNdp2hs+TYkMKy9JU1s1uIOTsqYlO3EuxYBpOQwc26/oexsQR4gKVp65W0e8qOrVjysPQyqPw6554hzLSEOstI1gbCRMdmZzZHcRDekkUVP6dxteCtBq2BNg2rhuWoAZQeTFW4MvB18Nw81JUyVPF/q4HhhazwQi+uKsrKKNQDzchLwizc2SpYqo3MYs8c49vv9+roQdGwjNDABpj1ZTJ0l2VUHuSkh2j6sgFIJAih9AeaxX3F19Z7xdLo9an9Mf0be8wxm+ECqrmTgm9Qxm+RXWv9QIth2rAOFWqdR2r+FqUw84x5Rfbqwepa5zWy4MKQvXUEWx/awKzzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uq0pnxBXQ68eX7qJLAZxR5XuuIDPguXAFeeSXP55jXE=;
 b=bHBk4/D4aYc3VdoYAMNOC8gS/hmMvMgBQYkN/W9MlXfO5hjROg+Eaq16r6j4+mrY/y6lFT1OYwVdwAIi1Cii9SE8uBxmNasZhyEZrMdZpWgkaLACUjjEBZeEAXitVNF16lGpaQCrmM2tcqup+xdoW18Mhl7++Cd312N7VR6DhUCZ3oN2mb0bvIpC9RmgwBtByCMWhxJ4b3gXaSg5G2r9eiqDGwSc8hLfqBG6wvFXW5Hopi190ZO4sCMswvcQR9T5/2IYvZAjC5Tv9Ww7Z2mZ+xYLdHBmSvpAHcFqgiufhIYKQwAHLMSKvf9Tnd1vTueUbWinIF+WATrucyfDSsWmSg==
Received: from DS7PR05CA0048.namprd05.prod.outlook.com (2603:10b6:8:2f::19) by
 DM5PR12MB1898.namprd12.prod.outlook.com (2603:10b6:3:10d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 22 Apr 2022 17:24:36 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::cc) by DS7PR05CA0048.outlook.office365.com
 (2603:10b6:8:2f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6 via Frontend
 Transport; Fri, 22 Apr 2022 17:24:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 17:24:35 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 17:24:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 10:24:34 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 22 Apr
 2022 10:24:27 -0700
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
Subject: [PATCH bpf-next v6 0/5] New BPF helpers to accelerate synproxy
Date:   Fri, 22 Apr 2022 20:24:16 +0300
Message-ID: <20220422172422.4037988-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edc8a0b7-7241-4b29-42c1-08da2484f917
X-MS-TrafficTypeDiagnostic: DM5PR12MB1898:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1898F138667AD3CF9F9E990BDCF79@DM5PR12MB1898.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cvGXVqR6WMJwjxVJHA214l3Mi+kcb6gSpO7pkzkhZsIJeYWiIPeaSPAUC7/4cAaDtKtqx/yRCMejWG2RN6wleYleI3qUf+HNxComZQ5TVd8L1SrwHwjyMLjfFVwQcHqnXXjOvfmCa9J0HLLjyhf0Trg/GdlEH2oFrqBowGZFDffYdHwGCsikUTJgsOubW1QjZ8Hy7PsEI5GIQkWCUMDijw371wY83rVq8pYmLauKG2ASdvYGp1lTRxCFvRYcHGY+JI2j7VKE05YTtHpBipC7M/6tWxpgezfW3JpjBrxC4/c9JuE5GJtlboqmv4H/w17XJH4vq9ApC1z6qUViQOx+5KhBGFcFNxjzbQWhaEPwZGtuS8/jujxmlsAi7KkTnWBZeouf22shnPTYh3jcY4C1sB8rL2/+ML3Y1uXpD2W9AZXX+8GBNv15sVO286wS3seX6/Jz70nSXT/UNK1ay3V4//MrfdvbYPLY6Rr+ilglguNJkM47pw0UrTxwLaHQ9ppsENUEdW/k2ZZoEttbB+1hopvg10VPTqDzqsvgN/Hokgxffyz3oildyrpsFfKCJWQ8+Bk5NtwNEbpA/+q9FxqRGB3MxP6DKrMO+W0ubjcXSzb7sh3uZAdzChXXz8JeEkUzplYvE5ibqgvbsLF8T0l2SMvTU7N1NcZdjyZgA0IUlNy2cuoEtQbO81EfarwZsuAIIa1fo/nfOxYZRkSf1XFBsXPzWDrGo2d17XfmY/n8tRXpjcEUfKd7cRflsMZYjTBn4BjQDFFJt28j62pMrFnqHwEhUxKu/gL09YAk6D3gKhVOZygF0opEJ1icZyAdwtBOSLoVYUEGHNFlR7DxRgeIkg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(2616005)(336012)(426003)(47076005)(508600001)(1076003)(186003)(107886003)(4326008)(966005)(6666004)(2906002)(7696005)(36860700001)(83380400001)(356005)(81166007)(82310400005)(70586007)(70206006)(8676002)(86362001)(110136005)(54906003)(8936002)(316002)(5660300002)(40460700003)(36756003)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:24:35.7962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edc8a0b7-7241-4b29-42c1-08da2484f917
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1898
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

