Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11ACC5147D3
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358145AbiD2LTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358116AbiD2LTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:19:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B508148F;
        Fri, 29 Apr 2022 04:15:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPJiCGLXdnyiXO3J6iC93nRG+RhjWSRJi7IOupFgffVIHB94YazROTJGsFYoUQo8dMJ+DD/O061lMxZExCpGmFWLTxp8CmoIOZRMgsA479ETm5XhVZy+gjAcWQtbZ0OfjQPYaitYbbEXEYfu+lxyPHtnREJLCh6UkY39z68kxKcC/mq84nqtComkiyhfWYwVOLM9GEgM5YGwNOyGBvOOSRXNrw8BT7vgn7SANlupT+oCDp+qqYg8mUqFMsWyhJ7+DklfhNyAab/GY/F4WlXxPlqBbV9ePkJ2D3qsOqrYkpLUJqUojsF1K9Elek2uy3q+8+dyWopsUsLZgNnb4WQ10g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/t7pHuQqrYgomxSYnFenZSthe+8MrJXA5BDXoVtNlQM=;
 b=KJ+jwPqm9TcaIr69B6pt7r+M8m4QswOm2eXQIlRDJPp0CfMA8BRvGbQ4zgDTmNspAMrUvSq7Vd/2aCIa8yR3xyCtPHgZD4pKSQJx+yJZ3Pm3f9qoSFY1q+EFCV22TyaxOvwx0KmRnH0xekfLZGcDzSdNZJ1soyVDe1VXITsdcWTfVfm2Nng3HpSKVZb3HLmmwWdOt7ccIOsyS/s/PJaPBG+BnxVNhU/47XC3AW9LfNGSGRq7NeOWr7agqdkeyRS1fNE/csPOofaC52Pkvd0N0YdAmyM1fP3VWvrsAdwGviQIdoLdJYFxwkAFUL+Z/E2MMOoQ+KVacKPBT9l0VACthQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/t7pHuQqrYgomxSYnFenZSthe+8MrJXA5BDXoVtNlQM=;
 b=DwZBXMgnTIplshhMUY90cwZ+7m5afZ5JZlW3UxVUZRdX0kdH5PL92lwVOLJcg5hxb+SWCFbSxBw8mc8ZED4k899Itr95YE5BOSM05o/BN2D5MjVtFWj8Mn7tRwha/L31cXgjMXQ22Qsy9vIsY6+5mEKN/wh3Nh38msdIZEgh80BmygIj2WZfI31BClmyeySRwMzpdxXDuj8ZRSsmZMjXE8rPProM6S3GA7kkcxEckZ3ubwaieqiI8P13XlE1aTlAk2jsirlXEG74cUDdP+Z0Phs36dSSzAZf+4SLOa5FMCPkVPITtki7W+hJW+Oy3FnYFcTZk8F4HfZLrvK0GmWk6A==
Received: from DM6PR03CA0045.namprd03.prod.outlook.com (2603:10b6:5:100::22)
 by CH0PR12MB5249.namprd12.prod.outlook.com (2603:10b6:610:d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 11:15:52 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::25) by DM6PR03CA0045.outlook.office365.com
 (2603:10b6:5:100::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Fri, 29 Apr 2022 11:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Fri, 29 Apr 2022 11:15:52 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 29 Apr 2022 11:15:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 29 Apr 2022 04:15:51 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Fri, 29 Apr 2022 04:15:44 -0700
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
Subject: [PATCH bpf-next v8 0/5] New BPF helpers to accelerate synproxy
Date:   Fri, 29 Apr 2022 14:15:36 +0300
Message-ID: <20220429111541.339853-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b441bc65-3b28-45be-a66b-08da29d19f79
X-MS-TrafficTypeDiagnostic: CH0PR12MB5249:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5249D91FBF3CA2A09BAD64BDDCFC9@CH0PR12MB5249.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtcjkedMZmI4d2cAVcdt9kyHdDCM90c1S6nFh3hTzthGh9FkQ+iVFiwH3QTyPvLRAGb9+uziteKp1YIhjYpsQ3Ep3C4XIwXok4egR7ICxU4/thZqjuYvECRTo5AiA2E4Yr9EC23CqHW28Uy5e4fw/l7y3cxxlONKip64pSueU4JU6B6eXQmq1oqV/Xf4OMtl4q9Fr1m98OzMsMCLUzEQk6G4nC+zD9tTzF09piYzj37rLEz128EgJ8vurA0kN+iC6z1hxcjeN8YqhFddIET/JosfW63SfOBJXRlkF+ip1OIGEX/GjmfVATgONdC275jSPDmfsvL1zgSizOx75mkOVT+8XIIe7ZTPJ2HKAlsEP//Z29YmYF/4XiLGMNYTX6YgaKZXRn2NpsNJBBW4/Cofc4Rg+OAAMtAqNJzychMt/m8SBIfcejYUTKf6+BnEYwL8c/6n5rAl/HFQRUdKdd0BSSPTp0mA5G3gZhdZqX6c/09dUxf4nJQfTlHSaZvHv9D1yBzFV21IrDWC+CaHaHbMvgezoDIXJhWv1KuMqjjh/r0iykRZX4qcfubhtX1OT20O57Vpq69qgWlT0L6eS+/4pZ6dnekmX9+BIEPwMqS+UkUWATXO8HCrixaN4j4Nqk83YPNgDfFEszKDbQ/5os4jyjWw3oUw903uVG3rPYglm93llCjyTIvFHDGTBXpJqZPr3ctqiIlwD2/0aSfPk9UeFRzfgAb/WIbrllhdyNLTe7Nbvr5mzSdBhlF/HIHqXUIfWN3MrX3r6ktm3q5GMsDyMDnaZf2VLqFHsjreqv2Uc1HvWHWgNG1fQDcwW1003u2gX119rc4cTo+PIIG3IE3ufA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(508600001)(2906002)(82310400005)(4326008)(83380400001)(36860700001)(70206006)(110136005)(54906003)(36756003)(8936002)(316002)(5660300002)(966005)(8676002)(70586007)(7416002)(26005)(2616005)(107886003)(1076003)(47076005)(6666004)(186003)(426003)(336012)(7696005)(86362001)(40460700003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 11:15:52.5550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b441bc65-3b28-45be-a66b-08da29d19f79
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5249
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c   | 144 +++
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 819 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
 13 files changed, 1759 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c

-- 
2.30.2

