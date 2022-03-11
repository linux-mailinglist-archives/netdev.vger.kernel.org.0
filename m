Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F036C4D667E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350551AbiCKQiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350472AbiCKQiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:38:01 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082571C65C7;
        Fri, 11 Mar 2022 08:36:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkIIWILguk7Usy3Cb822oKURiD4pfavhxHy5bWLjz5jVUSTDyEX3pQXgNYQ2WhS2WBNve23Tba2JqUAHP73c0t1S0ZsIqPf3yPEnuoZkNVkP9XlzP2VSf/2zrflhUfMYBTEdEFQfncOJ0atBRVwK71tAWlYn9CjBDaK9lE5VQIuo1A4svLqv8sY0xBOslxN7NR06Y+hbn8FyqKXOEGa28lcGYgiczCbzhd6fBb/G1K+La5+BqsbTee9wh6p5heErRsTSoLOZxewCt5BuAoYfAHJsl1iq6NaBIwyzNJKJp/hSDZter1UR4Lcmfxl3ozpsCUlAdsu4Wx6CLaGHiaON+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOYVMCjQKyoek5cFUMuEZyeqIZWxgl8K1PvYQdZjJ8I=;
 b=IOrPig2DiwbPXw61QLvcjbVvHY5p4Rc8fmXI1PYj0pUkv+nQm0/US+a2/qfvuGtnM0OjeBtDqGQxUeLfMG0/JWNhh0cMdQV0aadaF59KF5QPwL3XL5gLrHxev4uaHHUejvO29J7OFnHbeIK3/SIs533QgRI01rbO0nE5Zkpug+EJEdjRohKeO+pN2FHxv6iWlLpeiGXVEXy9A+w1id52P0Zd43zNF1ZJi7Cw/lQK2R4aycygDchZME+MojkaUzW2lQW9zcabZddCb1RE7m8iS243K2uhxt8pEiVRtBeaRvtiGTc5Jg4pcvsubKFddx7KAVhY1fwxmXjBylo7QymiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOYVMCjQKyoek5cFUMuEZyeqIZWxgl8K1PvYQdZjJ8I=;
 b=UzRHpOfEdB8Cx5lqT1QTU5xwO9Pk63cOBPDBA/1uOGE1aOLkqoNq7QgrmKECFzC63eByPRPV1aki1tpaXP8R2vm4JyS29LsB0HkLBz3UP6htazJqNwdgI0MqjCD4OB7oZ27MwkIvNxcRsann1JKr5QsD9EvalWR7sUoNQfV80t2xTJ+9L6DP1OPmHtjfYd09umaW5RXSoc4aUjIRfZAWvIgHFSVbbAtrfbkZrprc+sdNsh58vZGj+/iprL9iNBsCKiPTFGQE0kIdOCuw3q7OOEbQHh4KDrHK56guXiwyjEqyV9r0ESLwIT89FC0tl59Odkd/782TGEXTZdB3LcqE3A==
Received: from BN0PR04CA0178.namprd04.prod.outlook.com (2603:10b6:408:eb::33)
 by DM5PR12MB1212.namprd12.prod.outlook.com (2603:10b6:3:74::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Fri, 11 Mar
 2022 16:36:53 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::3b) by BN0PR04CA0178.outlook.office365.com
 (2603:10b6:408:eb::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25 via Frontend
 Transport; Fri, 11 Mar 2022 16:36:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 16:36:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 16:36:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 08:36:51 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 11 Mar
 2022 08:36:44 -0800
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
Subject: [PATCH bpf-next v4 0/5] New BPF helpers to accelerate synproxy
Date:   Fri, 11 Mar 2022 18:36:37 +0200
Message-ID: <20220311163642.1003590-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67d068a3-3765-4e1d-66ec-08da037d59c0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1212:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1212083BB730AE24A284CF3EDC0C9@DM5PR12MB1212.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TbYKkZWRa10ELS7+ugafUGkLNfM+mgcDU6U9WpoBlDfhCNjnt4cF4yeVRd7WwYZANlvQkon5q7JMLhuQW6cXyzTQWFu2mbxi9W94P/3+jXevtvty7gS1BZgJBc2RHdvxZm5Ixb0r8UOGzp4byD24EuzLOQ4OOnvebHv9flvsDwRUc/W7wRvrTjrtz9/cZc/g/NkuaqQSFJksLybiY/DCQNRGMfhngePDFDoVI8oMU5+GsVtYJVvbtSOAooLZOM3tKA3l0Gpjc1l6KZMhGDMja6YYhX61B8N6V2vKsMqmpihWK32YpDXS1Nf6rcY+DUIMGE4nxWR/+OQrziKPuMUtKlJi1rpcsq0iusEgyPzh5Zq3XMHzDedYNNCTg6+YNI1MSnttoqHzo8U3BIwA5+oTU4NIV+kwe05mPbWXe3FRNFKmYbBgd0cNLDJ291XcYfUVLlYZGM2GJRbMJL3vumsZowwEMnKK1bKYyAZZf87UQUvVwIiYnz3e1PYrhvKRi8PKLTWFNg8QpBvDauj/YibiLllQI3xEFF3ctiODTsvwhZgUFePzoiB/VZ4NLxSctbQ3hI2CACKLOIiFNTCh3UuW7qnVINDCjla8x98V8Cjf7Fk7h/lU/jEqWGn+1R4+z+w/hXxPZwrtSCder+GOgjkyS/iOmmaAMImuM9JG5TkBsDhRONyGARXhLCOeoAM7+19b/SYkxDb7njuh/x8zDdZFGcY1R14B+mXIZgLmKqY4XN2B1MHAwtFf8FtveYuVT8AEavNIBniamnSbwVj2D+MGdf/DIbKq7Ts4+awftBzN0ANFBnloiOWxcNVvQxYsPJlblJTZsH6p2lGCmN2R8qv/EA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36756003)(54906003)(2906002)(70586007)(70206006)(110136005)(316002)(6666004)(966005)(508600001)(7696005)(8936002)(7416002)(5660300002)(4326008)(8676002)(83380400001)(426003)(336012)(186003)(2616005)(1076003)(26005)(81166007)(107886003)(40460700003)(86362001)(82310400004)(47076005)(36860700001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 16:36:53.6048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d068a3-3765-4e1d-66ec-08da037d59c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1212
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c   | 101 +++
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 750 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_synproxy.c    | 418 ++++++++++
 13 files changed, 1622 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c

-- 
2.30.2

