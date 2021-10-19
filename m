Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B444338FA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhJSOtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:49:39 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:34112
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232993AbhJSOta (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:49:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAda/mSzlt1aYjWsTY4+dkuvzvgbQAZ7hwrXihfWA/6dlpFvPFFMXrejo+r79PVH7EWce+B+U3N87sSonFQKxKze7WNKLfad50GRwOhJkp5X5AWR6/IiTOx3Tyl3wrvN6vqtF7e00NeyAjJgYgvhvAoMS9SVoxyS0Bn1e5X/fQ9PgRo33jrYugytLTgwOJBuE/DeGWwMN7j58scSwqK/H3BfImNJk9I+LJEO16B3+6RYpqi0wsIaVtoQ0XeX97id2HCP8dZajyyMWAhBsYGDv/3oEbZBOILX8Zp1/NtdZBX/0c2oAsTSXsXnMOhg3aANK9tCmgTdQTe/PcXuAyq7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auIJVvcekKeADolNmqbnZfwt4cA/dEQ2G3LBJ3YKrqQ=;
 b=aEqENf5KAOoU1+GNEPUylXf4LUqQ03ydKIAzyxbGWGaukB5dQi3LUQiMK+Gc+nhYSvK/3tPIE/xkrJ4Ev4tAvvKxo6PdC99Dak9klD/iHwPC7wDdpwbVhMzG1HDGDfd4tJetjKciWrNCXh5s8adTKGa4BShOavVe9GdwiePYhbYr2I5DOXHpzB1SOqo1Ice8ITVeATJhCnm2l6lCmvDrywbyNFe+IP5rxiyKMDcGAsUcbm2K+2d2KDu4pk3a1zSgmks6cVx8GGfV77sAqWwSFupmtMYMiCAcTkxdsTcb+V9Q51FvqkliCfkLzmAEvLXlcL5rZrf93mANMM6CQW5x6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auIJVvcekKeADolNmqbnZfwt4cA/dEQ2G3LBJ3YKrqQ=;
 b=qAKUAVZc0gv9YmQfzgGP4OPNFPXHfEh8R7rC+I/uupLSQvuPm3H+1ng8xOFDxEeMm4SvYiRuEe7j2MFyfwWbpDKfxd18Krfe5rz+QBSMMuIXW3Bk2vJXEnSruwl/fCIw/p4TlhEoEH7JQOSHp3930Iegn3AV1AVX8aBhxy61mUso8Lz2SsJcOXJwXkBvLgHHxWSXxsuYHESDfay1xszSkxBUuzgaRIl3QxnwPvfGTDQBUDWacW4cmz9zpvJlltXRnMXUfdzH6RdOiuMzz/mM5KPZWW5aZy2Zv983SGK9IuyKRswIIwT1JVPHKz0K35uMAxP5XjSNTC5SpN7vwGSaAg==
Received: from DM5PR2201CA0002.namprd22.prod.outlook.com (2603:10b6:4:14::12)
 by CH0PR12MB5386.namprd12.prod.outlook.com (2603:10b6:610:d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 14:47:15 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::f0) by DM5PR2201CA0002.outlook.office365.com
 (2603:10b6:4:14::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 14:47:14 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 07:47:13 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:01 +0000
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
Subject: [PATCH bpf-next 00/10] New BPF helpers to accelerate synproxy
Date:   Tue, 19 Oct 2021 17:46:45 +0300
Message-ID: <20211019144655.3483197-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48377360-7e95-44da-1e44-08d9930f575f
X-MS-TrafficTypeDiagnostic: CH0PR12MB5386:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5386245CB04E3BDE40791D73DCBD9@CH0PR12MB5386.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nzU552Q26CMms9xobNTDp9Oam2m9QhXo8qn8V1TUpXzmro8qwBMz8q0x0FdDZigOnNnzh3ccNC+UogzjChZEzdTvtAJQl1Eg7Wpqq+U5hDdmC6w8OYlMIbww7mVW0A8QrlkvFU6x7ABAE0lSAyOY3SmKeRtGqRod3wyjJ01HrG9NQ+GkvIxZaKA/PZYoRRubG3v7MNUdE1AmiPjbxMXrwGjTNdFz3SIf94psKbuh+UEBseMtKH5sC2Vm4mwU5U15uu5zDS8e2qKVeggNqVNT/Olnh2S/tvGFYyun9CVCb6k+z8KNj0AKrNq1iwUcaKeBpS5rQKdmEAqHgKDHfQpJ2OYfxn9/2kkDWIhCYqNbe4VZjkxJkElWHEzIlHgPrqu2QvTc3RFmVePiaUbk7+Lp3NrhivUk2r+nJfq2DeuXSaBawl5pQ+pYZMKdfMr/tKYIiKUn6juZymOwXyiYMQz40HjZgkmrk4+N3tHFAHWa1HU/fhnIv9nOC1INUcrhwz6uMYcj5XOPtQbu+2gxoWh4EUehANH24dmChhkfA6DQ2G5zKFOggsKmzRTVFdltmjUJuQGND+cnu8YpleA+TURJHJ4yspZKyJKqGwLZm/sZ5vuvagD/K0jXXVR/mXVfLJiXZCqjjqP9KHQNlULlqLJIuUSP2WnnSWvzxlJA80yvRruvHkRipsIjiMvxICFxfxuurp/NmACKmzjJ7t+iZdmxEUUuCXkdANmi1rbuer1od7udKAnjPeFc5uqTrpEinkBeYfUZ2Xak+mm7Gahy7icjpO9juYl3NFHBqqFPy+hLn5M=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(82310400003)(2906002)(186003)(8936002)(6666004)(8676002)(336012)(316002)(7416002)(36860700001)(4326008)(83380400001)(26005)(107886003)(356005)(36756003)(5660300002)(47076005)(70586007)(54906003)(7636003)(508600001)(426003)(7696005)(1076003)(70206006)(110136005)(2616005)(86362001)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:47:14.3116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48377360-7e95-44da-1e44-08d9930f575f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5386
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series starts with some cleanup and bugfixing in the existing BPF
helpers for SYN cookies. The second half adds new functionality that
allows XDP to accelerate iptables synproxy.

struct nf_conn is exposed to BPF, new helpers are added to query
conntrack info by 5-tuple. The only field exposed for now is status, but
it can be extended easily in the future.

New helpers are added to issue SYN and timestamp cookies and to check
SYN cookies without binding to a socket, which is useful in the synproxy
scenario.

Finally, a sample XDP and userspace program is added that show how all
components work together. The XDP program uses socketless SYN cookie
helpers and queries conntrack status instead of socket status. A demo
script shows how to deploy the synproxy+XDP solution.

The draft of the new functionality was presented on Netdev 0x15:

https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP

Maxim Mikityanskiy (10):
  bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
  bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
  bpf: Use EOPNOTSUPP in bpf_tcp_check_syncookie
  bpf: Make errors of bpf_tcp_check_syncookie distinguishable
  bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
  bpf: Expose struct nf_conn to BPF
  bpf: Add helpers to query conntrack info
  bpf: Add helpers to issue and check SYN cookies in XDP
  bpf: Add a helper to issue timestamp cookies in XDP
  bpf: Add sample for raw syncookie helpers

 include/linux/bpf.h            |  46 +++
 include/net/tcp.h              |   2 +
 include/uapi/linux/bpf.h       | 193 ++++++++++-
 kernel/bpf/verifier.c          | 104 +++++-
 net/core/filter.c              | 433 +++++++++++++++++++++++-
 net/ipv4/syncookies.c          |  60 ++++
 net/ipv4/tcp_input.c           |   3 +-
 samples/bpf/.gitignore         |   1 +
 samples/bpf/Makefile           |   3 +
 samples/bpf/syncookie_kern.c   | 591 +++++++++++++++++++++++++++++++++
 samples/bpf/syncookie_test.sh  |  55 +++
 samples/bpf/syncookie_user.c   | 388 ++++++++++++++++++++++
 scripts/bpf_doc.py             |   1 +
 tools/include/uapi/linux/bpf.h | 193 ++++++++++-
 14 files changed, 2047 insertions(+), 26 deletions(-)
 create mode 100644 samples/bpf/syncookie_kern.c
 create mode 100755 samples/bpf/syncookie_test.sh
 create mode 100644 samples/bpf/syncookie_user.c

-- 
2.30.2

