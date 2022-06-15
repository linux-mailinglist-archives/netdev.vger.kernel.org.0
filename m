Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A746954CA31
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 15:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344457AbiFONtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 09:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238566AbiFONtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 09:49:04 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2048.outbound.protection.outlook.com [40.107.95.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA28A2E0BE;
        Wed, 15 Jun 2022 06:49:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMU7dkjnkMZPLQd3380ivUsKIrmI4elLm835teYfdedWjLDcWsvNWzS5Ibi0pGUqIfXMZdu15EpkAsiijq9DUMa1/4hQSK3H0qdXNy+6lsnjXoJmPTglcORpY+quKVzZfP7/qqPN/EEEzyLNAObHw7pCwwREitrJoaVxPW9IPnoNrYRQACZdltuTnoUBr7m/PzI49xxN1a3SIwFlUcPRVk8NrCWoSh1QBen62TJuURMSte04g6Wq8vdIrdjedtzRhElaaX8UvU0e30wUjhm6uLaokTYUF0jI9oyE3YmaBN1cTbmUSmUqSE3YR70nIb9b7Xg1nH8qygSZe5yhulyo2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B34WQPbsi0GH2dwchTh78p88CTpjN1t+3oIYgGzcWyA=;
 b=ha/wUwTQXbS6BEPupqAtclE5c+aOezAEgIMW5/6g7ZRj2RjC4wW3M5JBXyWByGLmOGvZ/B38WDVRp/tMeS+Vw/4vUP4YO7IjvpbLLwngKAnBlg1Of0RyJ7deedcdjkjp8a9ribzyeipanhYW+zhxScf0+52CiFHX1L/JYje5Wm10O0go/rdpzDXFI5McxT8BwXAX5dXkWSGeqAj46T5rtUHvSNAVe7I5bqTgYj4VfVxYZ0tEqBOwdhpWzn3CbdeydZGryfxkFVKEACP6GACrvCvNgzCQDikwwP4QP3h7qLGfDwYN24Ud0XGzxX4xPkN2sW//PCtrxGebJMjuwZANxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B34WQPbsi0GH2dwchTh78p88CTpjN1t+3oIYgGzcWyA=;
 b=pSIPcwMqt8jrFlcim2+aFNCUN0EgxZBiuIrkNvxyEMirzUurk1MzzGfsy/vC3r44IS8S5Frf9yiZqOtOiJ4nDJKT6sANEIO7F5g1KuXFDcWVOOdSpsFt/KPdjwC6R24UahHI/Yp7Cr7EYr7xC+sxrJkNCmTS2qN63hTjFMBj/D7Lk6DWox0sML+rL3SF0UjI7P3HMam+VfY0uX+jX7Tr4aNbVGoXvDNVcPOkWHYDL1gUQzikfDOFo0q3XjYNhNiVwJSkCKt3umq0OVzR0kiQ6p3YzB1TnbPxijaQyHDeappx2ePcViJhQDwCjT+xcNgb0GTdQRyq4pWEnzwEbVpJLA==
Received: from MW4P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::27)
 by CH2PR12MB3989.namprd12.prod.outlook.com (2603:10b6:610:23::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Wed, 15 Jun
 2022 13:49:00 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::68) by MW4P221CA0022.outlook.office365.com
 (2603:10b6:303:8b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Wed, 15 Jun 2022 13:49:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 13:49:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 15 Jun 2022 13:48:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 06:48:59 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 06:48:52 -0700
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
Subject: [PATCH bpf-next v10 0/6] New BPF helpers to accelerate synproxy
Date:   Wed, 15 Jun 2022 16:48:41 +0300
Message-ID: <20220615134847.3753567-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d71aa688-9ce3-4a68-8fe6-08da4ed5cd0c
X-MS-TrafficTypeDiagnostic: CH2PR12MB3989:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB39894BF0198A254B7D5B4B83DCAD9@CH2PR12MB3989.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9IqRiyx8qZus8u4qX32yjyNagtFPOZWKpKRgvuSya8KsQjPL9qhnMRqkSgI/ZPfvna4T3K4nNi7l+kAL+19sOQGlZXOJTE0dX3a8czYSP6/7o7lZw5gZPWBh2eNl0Z3VBm0gTOSdby+lmV9p/ZerGDinXeRqna2wrcRpnhQK8W/9bQkkEJscPqE4S2NwnFOipk5HJU6BwzbR5iGoAFXoq/wGeIqqC2wgfK7x/q373Po3e+/2fGSI9wXAA8wsqu7gM7jXhEFYJO1vkY789+JlCVXIVxUiTENKi6KycRK8sKV8bDRzCu+exr0juI4mRRgLFlId5bRDKdfKD1gpv9GR4Bb2L4R3DgHqv6McddYOPn0FX1TbpVnoaWZWBIuDH+qJNmZDJTswuPjzQmowU5mJBgFYsqZOdXhanp0RTzdpTvH+dTanrBRnaYDC4yF4MSpT399/cTGxsqTQsS8TAD8gm52mRl4Mev2c0O7y/eKUWdNDxJ/r7HufSBgh0o4s624ODGmYoewjuHbAXe1Yfj+tTuDp13vH5a3ZM111TAswJcbH5XyRgE5+CCEuhYuxJ24SXiBH03XW1FQX6qAohHRB2de9hXmRM4R2EX9tFa8ft01THzP1UkkdK2LgOFfAEprJq8pntwIs8GTSJGfzwleoUQ/WG45KLKRANX1l2askyte745jfWg31zToHs3fUv3sm1M4tW1jh2Mcs6w5X+K2AYE5iw1ESqj0xCG1kewoUq2XnclbTUjNcY9yu9ekapxc9cM1XDovTWjoll++GgKE0I/EnYvKCO4jE6e7EbHlChAEcLE4go7/zXx3qbRkJc7wbu5U6Yc7juLl3SE900Igv2A==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(186003)(7416002)(47076005)(8936002)(426003)(356005)(82310400005)(83380400001)(36860700001)(336012)(5660300002)(2906002)(966005)(36756003)(81166007)(508600001)(86362001)(8676002)(2616005)(40460700003)(7696005)(70206006)(316002)(70586007)(26005)(54906003)(110136005)(107886003)(6666004)(4326008)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 13:49:00.0405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d71aa688-9ce3-4a68-8fe6-08da4ed5cd0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3989
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

The last two patches expose the new helpers to TC BPF and extend the
selftest.

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

v10 changes:

Selftests for s390x were blacklisted due to lack of support of kfunc,
rebased the series, split selftests to separate commits, created
ARG_PTR_TO_FIXED_SIZE_MEM and packed arg_size, addressed the rest of
comments.

[1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
[2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
[3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP

Maxim Mikityanskiy (6):
  bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
  bpf: Allow helpers to accept pointers with a fixed size
  bpf: Add helpers to issue and check SYN cookies in XDP
  selftests/bpf: Add selftests for raw syncookie helpers
  bpf: Allow the new syncookie helpers to work with SKBs
  selftests/bpf: Add selftests for raw syncookie helpers in TC mode

 include/linux/bpf.h                           |  13 +
 include/net/tcp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  88 +-
 kernel/bpf/verifier.c                         |  43 +-
 net/core/filter.c                             | 128 +++
 net/ipv4/tcp_input.c                          |   3 +-
 scripts/bpf_doc.py                            |   4 +
 tools/include/uapi/linux/bpf.h                |  88 +-
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c   | 183 ++++
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 833 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
 13 files changed, 1833 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c

-- 
2.30.2

