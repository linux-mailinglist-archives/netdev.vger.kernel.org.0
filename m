Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEA1498346
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240628AbiAXPNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:13:54 -0500
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:51393
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240533AbiAXPNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:13:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdyorE6NVmCabQqjXfYRWrGH3J4EEhJmdZVHn/shWWzTg0y9Q/wBmRRu4EfSF61hLctKV/llGmePndLUU+vAo/jF9u1lnKv52IPX3KFquknpxAYlV8q5R1il7tqTuzJC/W4sokXUCiay80OgLAFzvn/sO9xkYa666zw/JIZY/lB/ZPk45ZgmxaDvW6EpUdwXLvZTLlrQxKAbDbVA92/MuQ1qZjvH1nTmZcDteNjux/+NIa86iTD8J/RZEzmpa56OaoNOB2khp9F+x1Cm0S/W+bl4Cnt78TyRKshp8BljeTwFQSRvcOdx5XoZhqRVY0NtYboII5xZJ21FpfDBaGYNBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wix0i5uWXQX1vhRW8LIW1NjaKF8l7wcuUohhrqeVGgw=;
 b=eO+mfyqDzCO8NBUIsiu8lq0DY5QNiAFURcnw/alsged9pkz5xuBy+PpnNXTKbNdoPYo9LPF1JaXfrHC9x/PIsWQWxZA3uAOUiAsO1TmKRxiHzD6xpOH1wx/CkQkVo2+FoH2UYlS7MCkWuSc0eo6K8lmqxYAepir8MO9nw+BYahdJol8iPGUsxhoLM0i9HeDAwZBtWkYGT1tv8rbFFTJ9nSjyUk1pjr6ECuOYWeYa4wLS6Wyg32r25nEyxdtgBKqmDDLSuzVHwQZu+VoZXmlUowSDQStUccP4hZ49g58EsKIOGUpnMzzaXs56IaWVbf5eBp97xUDKQ08tJock0rPL3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wix0i5uWXQX1vhRW8LIW1NjaKF8l7wcuUohhrqeVGgw=;
 b=NtR+Wo3hOHCO7bgWkVsJBn6OK/4C1Xh0aHashYd6anLABSHPfJpuB0N8lf0IX2eDKISVOA59W8mj/e6JiGDQjecZ7rbY5Gyk/4/Lyyo6fhjGXjZPYzG1/m/aQ5COp+uDXFTdt9OChpNe3uwkMKqCgmf8jXPDp6XLZjrnCUrLWTFWBI1DzSSgFVVUmX5dtwHubs1/hY6xJfPoF+BCbrNUnP/UjjAbhBX2PvgXXjTWBiA4jIZAiZ7R27iam8KE4E0gJ8UO/knjndKnijdxAD78uNLZIikpg2g+Ir9WZusrpGaGBJIE3oL2EPyeYdCIbWH/6SCtdHLPeIGWR93/M5hNyQ==
Received: from BN9PR03CA0379.namprd03.prod.outlook.com (2603:10b6:408:f7::24)
 by SA1PR12MB5669.namprd12.prod.outlook.com (2603:10b6:806:237::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Mon, 24 Jan
 2022 15:13:50 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::8e) by BN9PR03CA0379.outlook.office365.com
 (2603:10b6:408:f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10 via Frontend
 Transport; Mon, 24 Jan 2022 15:13:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 15:13:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 15:13:49 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 07:13:48 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 24 Jan 2022 07:13:42 -0800
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
Subject: [PATCH bpf-next v2 0/3] New BPF helpers to accelerate synproxy
Date:   Mon, 24 Jan 2022 17:13:37 +0200
Message-ID: <20220124151340.376807-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4193cfae-5cdb-4020-d9ed-08d9df4c2049
X-MS-TrafficTypeDiagnostic: SA1PR12MB5669:EE_
X-Microsoft-Antispam-PRVS: <SA1PR12MB566904A65685802C13DEA911DC5E9@SA1PR12MB5669.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+m5f36K6QIuHBdpImPZ3jISNTkFZQdA1xUSbgWKjcLmZZ5H5tph0mpw5/e/ndOK8eX41RQPmsnTx/elbLcsV3kqSyXRcc4qoLh9PG7ciFG+Lr+N8ltEjdv/+92pEyTZkfz7mT0NzY9r1ijVxW2PZk+MuPnQxenB/8nsTrehFDD8p6xLJ35Iq9+MVU58qJ89A/n7Sy7xRqMjxGDaFeqnrmw4wNWn3v/7rETaaMKZ4MV3xr8zvCozUNElqcthA2nqLQ6ESrjW3zDM6q/XobH7YPlTA0Zopf+0zrGY6nRyod4CYr2Oe27AC94Yn2V6325yGIzttrP2k75bN19qlVHmDT25Py2A6NqX25/yxOHLbD4KSE3SRa19+YHRIL1pKYeSErHtZ8SJi+Ke3wyeccqeZh/FPl8VuMk93nfp0CanDpKDqfdH/lAfyMiZF73+mWd6D3A/RMVPwXOyOAzmE/KvN5Cj79BKeKX5ooJDdKB710ex/mgeCAYCIezw4ojNpiJbeF8+FpXG6opERFdtSlQx5b7L5pzLHVYLKFZZV6RRBOhv7YMe+w+qKgBOOfXohIglPwL2bHBzV2encrpvQoYJeXJiMwe+rlB+LDTQPsDwssBGEHezbglgTdmarp5E2R3bcWNuYhIKwrcBaw1lSNHYyUP/NYr4brHe3OCBWbFiELzjAKhLZ86GJsJ5l234yAV1m8Es5pag0tldbgwM7qBD3W6wvNqFjLAsxW1ipjKXPGMPWACz1+FIqB8CmAuUQgEbdGb/oYiJGtf5fCfIWzyC766pD56ZIfmmTld1b8n4TWVKylwphF8LLT6Pm9ML3wU8QU6qISGSRv9oB1n97y0pB2+sMscDdsPgb+N+JjseUQVXoUPVZVtrZvMm9M1WwiXQnm+Mu9z819H4YRkFX3MyIRX+AUW6OlwPYjVVMp5jKoo=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(1076003)(7416002)(5660300002)(40460700003)(110136005)(36756003)(966005)(70206006)(86362001)(2616005)(508600001)(356005)(8676002)(186003)(26005)(54906003)(2906002)(316002)(4326008)(336012)(8936002)(6666004)(47076005)(70586007)(83380400001)(82310400004)(107886003)(81166007)(36860700001)(7696005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 15:13:50.0292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4193cfae-5cdb-4020-d9ed-08d9df4c2049
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5669
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch of this series is an improvement to the existing
syncookie BPF helper.

The two other patches add new functionality that allows XDP to
accelerate iptables synproxy.

v1 of this series [1] used to include a patch that exposed conntrack
lookup to BPF using stable helpers. It was superseded by series [2] by
Kumar Kartikeya Dwivedi, which implements this functionality using
unstable helpers.

The second patch adds new helpers to issue and check SYN cookies without
binding to a socket, which is useful in the synproxy scenario.

The third patch adds a selftest, which consists of a script, an XDP
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

[1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
[2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
[3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP

Maxim Mikityanskiy (3):
  bpf: Make errors of bpf_tcp_check_syncookie distinguishable
  bpf: Add helpers to issue and check SYN cookies in XDP
  bpf: Add selftests for raw syncookie helpers

 include/net/tcp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  75 +-
 net/core/filter.c                             | 128 ++-
 net/ipv4/tcp_input.c                          |   3 +-
 tools/include/uapi/linux/bpf.h                |  75 +-
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 743 ++++++++++++++++++
 .../selftests/bpf/test_xdp_synproxy.sh        |  71 ++
 tools/testing/selftests/bpf/xdp_synproxy.c    | 418 ++++++++++
 10 files changed, 1510 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_synproxy.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c

-- 
2.30.2

