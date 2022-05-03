Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E895F518AD1
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 19:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbiECRSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiECRSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:18:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629DF3057E;
        Tue,  3 May 2022 10:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9g0+PDBMUEAXgEtUgsCOJT5URkk9IH17/tXdo2YrHZ6Kh4lifOhIaiWvEFSlgGsKEM4damBCJa8xBF8iNtPH7V0h+tNb+8BQYHzrsxObk5BRxt63b5tqX9glMIc90u2C51hThS61jQsSigiPk10fUbP+GX7Vm3+SNXkGDbcDAfl9AshhRo3jc95KJJLfE5dAfFovz9TJUP0ICruEiUNw8ePxk13foaNlOhoJzyt/smfVN7ycPazFbGjpc6eIXjQvO+h8WhwRWUw4uPk+DPh6NNZXJQqv0gRXxvtEtNrMzvuiP6ai5eH+KXcFTPmlGLTe4qF6vNOdP3zzgDbHaLVSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVcXeJFBzdAfyc1VJUkS0rSVbHO8O5qZd0lWX5ESavI=;
 b=ItavVAfKrI37PDAfU+502/baPxT8LZWLdtU64gabZLOAwkVjD7HJEtuXDT7v5sIchZvsvv4NnFitlIv22JXGwSXH4fPjlOA8xUSW0j4wUwaTNa5G8YYNc83rhLfKUGmICy+3/RaNsUIv3aC81xLvxrwr/Wcu4ynMvL8RoK5KjMJZdDHzYhHLx1sYKaVBQRoqyxf5tfF+mQubO7FAFQ+UvkifODH81DUEj5MVeFQCJSzqhmgtPAHKtHbX2AIKMiXdVZmjtWmwrAuPUj7aVljV5XFQroUyIu9o0zZDX1R/jX5sVEJ51VQE5pK430Ix6IB+UDdwm9EEezFyuca0stM0WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVcXeJFBzdAfyc1VJUkS0rSVbHO8O5qZd0lWX5ESavI=;
 b=ocpKz4T7yqH5r0lUM3f7w2Q3wZ4yiq7JnHacVRDacbrOgvtcrbAa2t2Kn1TrOqJkAIgpT5Soqesx65FiF+9GDq1sgqmFktKHmTC5cddVFqye0tpIiDFehjy1D/bmo/RXD5wbT/41arFgL2IN+1BsM/2RuMGQx+aX/LAyTZX1gkrdENRncrujcl4WUBbxOVfKahRqBc6lQRwnixmOWdYsrbbqeGWCVDWXaJfYO9nw4zreq7rAZflIBnGDvXTmnbejV8ueWm5MTxnQ/zGtSzuyUSeqkMBqligodm2rUkHoIwOt/ZJFT6YbmqD3aBreErwmBIoE6d4FefyD6reHTpnJTQ==
Received: from BN9PR03CA0149.namprd03.prod.outlook.com (2603:10b6:408:fe::34)
 by BY5PR12MB4210.namprd12.prod.outlook.com (2603:10b6:a03:203::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 17:14:49 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::84) by BN9PR03CA0149.outlook.office365.com
 (2603:10b6:408:fe::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Tue, 3 May 2022 17:14:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Tue, 3 May 2022 17:14:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 3 May
 2022 17:14:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 3 May 2022
 10:14:47 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 3 May
 2022 10:14:40 -0700
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
Subject: [PATCH bpf-next v9 0/5] New BPF helpers to accelerate synproxy
Date:   Tue, 3 May 2022 20:14:32 +0300
Message-ID: <20220503171437.666326-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9d02cbc-6697-4914-c11f-08da2d286dbc
X-MS-TrafficTypeDiagnostic: BY5PR12MB4210:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4210B0958CCB15D50D98F722DCC09@BY5PR12MB4210.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grIo83EO4QzdS9n3VynFXSN/xzGnRyz5hq8JtEB3EpGcvYPTVLHQWu+JUxLX+4+VRpb1czInHScLTujbZQQW924WI8TCQe6UAU0IGFQgYw4aF96O5fcMFqnAO4VTrKPn9j+mg6aU3+JLYuGb6Nq2SusIHMq5ZGZJgPx96+PCFACL2y/2G2jlPnDti2euvVM+t9uBJ5trM/aOSXrSx9I598U4FBIIHgDOKRu5x1Hno8C3Pg0Hc22CE/E1kXiWZhX8c2uZDVi6U/ojBBqGEQv8z8mTewJ+Lqk/kCsaZ3cIDxMuiGuT8eEinFzAtJ4PbGWNoiDFRhqfAHA2Gdx+NePVEDaNcieQoBtY0NxUvmh4kXZHgix3XPeG6NNMW5scU+GzGHyi2KMVUuT2MQzPIJ2+pQE/zr2s4wZdr+MmSR12fLJzkx1cAlmdnRXLzlg4WMoBJiypwDXpTHi+2j4b/ELhHdaJSL7TPotioqXaCQp8DhpxGIldxxXwBl1Gil+KcsL08VZICbO1kM54A5CTAV+MajlZkQZ4DxBaeaWHivXYcGfn9MH4MQqm9p5q+rqiwnzRUrwGhjdlSN2pTQ/yexngNRtTQxm9VEJzHtfQqAIHuf/gpmdoJjeshC0fagjqQUEHWJzsxbqrz3HqTBxy9raRMPZ8VHwlqS+1YtE/0Xp32joFpXv11FDGZafmL0lUPje334/IVEriXNBx3YFgS1vhl1O9AIBomRXPh/GA9Q5KEjwrGR+8HJg3c+C9zDjgIOXmH8V5dH5U7vSC/fucA2qi12j3FHnaYF6oNL9ZR4IXOPLrzqH8Z595k1LHNL2R+COdCrLoRREw6p8BY+wxeML3qg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2906002)(8936002)(40460700003)(7416002)(82310400005)(5660300002)(2616005)(316002)(70586007)(4326008)(8676002)(83380400001)(70206006)(186003)(107886003)(36860700001)(47076005)(426003)(1076003)(336012)(26005)(6666004)(81166007)(356005)(7696005)(508600001)(54906003)(36756003)(110136005)(86362001)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 17:14:48.7656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d02cbc-6697-4914-c11f-08da2d286dbc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4210
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch of this series is a documentation fix.

The second patch allows BPF helpers to accept memory regions of fixed
size without doing runtime size checks.

The two next patches add new functionality that allows XDP to
accelerate iptables synproxy.

v1 of this series [1] used to include a patch that exposed conntrack
lookup to BPF using stable helpers. It was superseded by series [2] by
Kumar Kartikeya Dwivedi, which implements this functionality using
unstable helpers.

The third patch adds new helpers to issue and check SYN cookies without
binding to a socket, which is useful in the synproxy scenario.

The fourth patch adds a selftest, which includes an XDP program and a
userspace control application. The XDP program uses socketless SYN
cookie helpers and queries conntrack status instead of socket status.
The userspace control application allows to tune parameters of the XDP
program. This program also serves as a minimal example of usage of the
new functionality.

The last patch exposes the new helpers to TC BPF.

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

v8 changes:

Properly rebased, dropped the first patch (the same change was applied
by someone else), updated the cover letter.

v9 changes:

Fixed selftests for no_alu32.

[1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
[2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
[3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP

Maxim Mikityanskiy (5):
  bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
  bpf: Allow helpers to accept pointers with a fixed size
  bpf: Add helpers to issue and check SYN cookies in XDP
  bpf: Add selftests for raw syncookie helpers
  bpf: Allow the new syncookie helpers to work with SKBs

 include/linux/bpf.h                           |  10 +
 include/net/tcp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  88 +-
 kernel/bpf/verifier.c                         |  26 +-
 net/core/filter.c                             | 128 +++
 net/ipv4/tcp_input.c                          |   3 +-
 scripts/bpf_doc.py                            |   4 +
 tools/include/uapi/linux/bpf.h                |  88 +-
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c   | 144 +++
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 819 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
 13 files changed, 1761 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c

-- 
2.30.2

