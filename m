Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0323A170F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbhFIOYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:24:48 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:8224
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237783AbhFIOYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 10:24:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpscje2hnmp4OX6y48V2AzNFsfYYZCInt3JCo+2egu62Rf3qLKQMwe4yoOWVF0Miti/v5aDqrZjL6QftL26MtRe4Pba1EojeYA1WOLlJnaqgOpUsC10OBmfXezeokz9w9rMIdkaZ4CXdf6QHVWnqBBUEOwwS//U+JHuruSxhJhsa3bzTT0u8bcja3+zTeNorIm5flVTJN2j/xALPtJSYZLEv+etHi+Gygp23EaMaNED2Cic8kF0O6ezUkyOe0cPkZycmLS4fu70dUWIG+wIHLAA0iArbXNqsa1n8hC9E1kGGy41lkLN1pHOn8Ji7XZ1awQR1q49OiU16r1EZOm8v/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jKjatjtp4j+nEZB2Mp0fF84nkGSH4r0mtH6JmL1Jn8=;
 b=YQRz2X0TDWiE35h2rXWmHmIOhWyinHFKBJ6et3If4cvqK4DGoAh1s3iNQSPLX6aWBkaDZhz4rye/AqrDlrcnEcun+D1MmSJHVTgUYqvAoZxeG34ygLYR2ShhCohh4eE4bjNwQclRpvV9UvxXG0mBmuJT8ivxsfgTfVjg4Ysr8Rd2unE9cwD4dIOC38jf6Mt1KRJ51F7C0ADvmigbyADr/DtNm0gGLFGf9wRRlMWZS8+ig763VQaW9uaOERKmUe8NDEFPXikTT2oB+zDDaU4GGzNMB/rmLBg57iRhfuufqzHGcmJCCzbC/F5wOTdaxP/6h5UthGe6CljENxlDqIgs6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jKjatjtp4j+nEZB2Mp0fF84nkGSH4r0mtH6JmL1Jn8=;
 b=ZL/wsvWbEjVsFFrjz3rhe7V785ktoRTCBOSeidArSwRFR+Av7+Ho+Qip6Li8ouL9Nyl9DfmIWQmLCyTBCphg/K5a4plkcdSd//ttjw9uJTUJKwBlOQUlDNQ5O7eX6OMVI0NqJLOa9Uyk0JHmsrx6HUPeqj52ZRSxPC7S5FiAnWxGIjbFP3EdzHou98ndaEYwg4BJ/PUsl2T/JOMD7cwPcnN/8bsZA9rbNtTwb6OFUm7SdEPpkEJ0NOa1CHkGp7XGC7g1Q36u1SLznmgIL25xPjd32h79Yuftw0KerkEdqO/UvlP8XKdW0v3E6x/BLR3JchbNFM2ce55ATA7Guv0phQ==
Received: from MWHPR1701CA0002.namprd17.prod.outlook.com
 (2603:10b6:301:14::12) by BYAPR12MB4711.namprd12.prod.outlook.com
 (2603:10b6:a03:95::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.29; Wed, 9 Jun
 2021 14:22:46 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::1b) by MWHPR1701CA0002.outlook.office365.com
 (2603:10b6:301:14::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Wed, 9 Jun 2021 14:22:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 14:22:46 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 14:22:46 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 14:22:41 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
CC:     Young Xiao <92siuyang@gmail.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net 0/3] Fix out of bounds when parsing TCP options
Date:   Wed, 9 Jun 2021 17:22:09 +0300
Message-ID: <20210609142212.3096691-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 352daf34-ad81-457b-3510-08d92b520da5
X-MS-TrafficTypeDiagnostic: BYAPR12MB4711:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4711D4393E465405828DC1E9DC369@BYAPR12MB4711.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D1SWrP3hOq4XdXUKeJSI76BBRrQ4Ek2OWz3/j8lHZyOUUBXMDhwaR6DvZIRLjQCXvOBCqmPEbSyilrVg63phClhsx+MxXMaIecvEkedYqIptdUtkyih/VD88+1MBSqxElieOMDTMlmWM4/FgX/y3v9pQmvKKT05yBWT3qEus1oHdX7F8gBqXH8X5X9t2utQYdu6mAZimvUrrPZmwSgEf4sQ9tHTaCQ81C9rERFdwu+7C8EjIpngdyg6IXadchxlCpwvmODCcRP6YnWls1gO1z7Jn1eke6+TvjMR3mNmKM+Q4eW3RkHY7BV+ZjruhmQVI7ICpAdOwzdw82R5n+4M3DkyJLx8f3fvbWAtuQuybJFgqmm1AYqI+ve0T+RJmeZq0CHzTjRExk7joK8DTrgBKVXGKdwUiu0qvg/fl/t1b6iaFwkZUFR9s0bOvvoZJvicSu429dMl2D8HagDiR8G+dWBLy8Mi5j56MWQZrDNZatHyRDGGl5VURdCv/3iKUY+HGHaNZi0mhX84a/y/FILk39z+ABMOWsrDXRijVCSdtn5Qh2VbAp91zT+YLJqbij72uwYn7jnRps9mSqeuAlFAZp75Cpx0Cnr0gq6dp8ZWBmXtv3A3Bju77dphcbsfiwqVDIJJwsoZlG+puSJh0Q+auVFRBa+mR0fu2xU8pteR1slk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(46966006)(36840700001)(426003)(2906002)(8936002)(83380400001)(186003)(110136005)(47076005)(86362001)(36860700001)(478600001)(316002)(82740400003)(336012)(70586007)(70206006)(6666004)(54906003)(2616005)(82310400003)(36756003)(1076003)(7416002)(4326008)(356005)(7636003)(5660300002)(921005)(107886003)(4744005)(36906005)(8676002)(7696005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 14:22:46.4769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 352daf34-ad81-457b-3510-08d92b520da5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes out-of-bounds access in various places in the kernel
where parsing of TCP options takes place. Fortunately, many more
occurrences don't have this bug.

Maxim Mikityanskiy (3):
  netfilter: synproxy: Fix out of bounds when parsing TCP options
  mptcp: Fix out of bounds when parsing TCP options
  sch_cake: Fix out of bounds when parsing TCP options

 net/mptcp/options.c              | 2 ++
 net/netfilter/nf_synproxy_core.c | 2 ++
 net/sched/sch_cake.c             | 4 ++++
 3 files changed, 8 insertions(+)

-- 
2.25.1

