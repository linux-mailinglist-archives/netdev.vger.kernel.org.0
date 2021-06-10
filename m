Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8201B3A30EF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhFJQnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:43:04 -0400
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:31456
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231511AbhFJQmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 12:42:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PH0sE5dEiJCAU1m0J50/vXWMCDg4eGuZzArcJ5JRMNyS0bJmmnQc2bJelgf4c/RcVIn+8Fmdnqv0EH4HEpRd94dLKO2oReHtWEmxqb6tAM7eAaSkjnGAYnxFqsxV75aFgMPRp0ofFiXNO5IKxKQWtrnjI3h6qcZoUgFZDw/IzL3p3jUZjNZK61qC4DhK2gtzLD7cJotp4TOmEAR+gIH8D2CDGyB5IlafaxOQfcZ8T65P4Vtlsp/z0UChrTawemm+8Rrtd/8xoaRjAT+/WfZx+wk0aqWA17W75ez04xNI2px6SKABjuIdYkEb+0PfBQDtZyvAjalTnpgnh5etyhhR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvprJ3L3ICGKaIPl1rU7+Izgeni2jORQKxGDmpweAGg=;
 b=dUSKeQrIJ7QtfI3EVa6ltlx67vzNrumxjcF6fZ2v0IoM+j+a7spt2yrPsdkm9Av6zBir2HeyyO0PO39aIGSxKZq541llrKEVG+BzngrXzX/KKf++UcaNTnpKNSleRlcCJvaWMoNZ1zpjCAB3zeZ0+zCXGI5MocJWLjVlMEBxoIotOc9AFY1s1Oo+tBcuvo6Mdg+ed9YPOxF8yfJbAPGdFZsuDxaoIjULtdIPuL/kfWvpj4kaD/hBajcPuuNStCofiiIUHs1luXU7IzYqwNC0RBLdQmYlHf+MHELC3DRWwgqtpv9o6YUddK11FijLfD1UQ08oh+OKATPFIhrcw6zMNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvprJ3L3ICGKaIPl1rU7+Izgeni2jORQKxGDmpweAGg=;
 b=U9ZxXw/EqDDfXBqJFfa+cYdol0tsqJGXcXIgMr3+9CJu87j0UtyZE+25hTTdQfKUnRziRsL7eT2YJodHnsvrpDC3NdNJbg9nawXKQxMaVp+x5j4fvwwK41btGq/Q4Ag4yP0yO6FHPyei8ulBnq53yTwAih0o51hVKTWItxQWh7feaPxgmQwjq37EIZzQYuJGQ2iuArUjepMKb7uECTum9mb+YIQV9PrG9HVdzmwXOaNw6IowJJhAGJcuRhUp/llvEm3ezW0fn36jwmKzyFFXZ5bKgzAjGESJtvxYrvLJOlNENEJou37y4NQN/jkclPOwBX06hGs5VaERwSrgTdfwBA==
Received: from MW4PR04CA0386.namprd04.prod.outlook.com (2603:10b6:303:81::31)
 by BYAPR12MB4709.namprd12.prod.outlook.com (2603:10b6:a03:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.29; Thu, 10 Jun
 2021 16:40:53 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::c7) by MW4PR04CA0386.outlook.office365.com
 (2603:10b6:303:81::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Thu, 10 Jun 2021 16:40:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 16:40:53 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 16:40:52 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Jun 2021 16:40:38 +0000
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
        <mptcp@lists.linux.dev>, Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net v2 0/3] Fix out of bounds when parsing TCP options
Date:   Thu, 10 Jun 2021 19:40:28 +0300
Message-ID: <20210610164031.3412479-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b07931c8-d78c-4d87-ec05-08d92c2e8382
X-MS-TrafficTypeDiagnostic: BYAPR12MB4709:
X-Microsoft-Antispam-PRVS: <BYAPR12MB47096A6C6BF7D924C99F32CADC359@BYAPR12MB4709.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:541;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSdTlIlbTsbRYwfnXnMW76N+iZlw6BVHT6N6ZsrBw/0SP1tDIDRnYSZCe1XFUlfj1Yz+FfcsLEWPLKjhsbMplMCbilhTdApk7TM1ot739FpfaUdIEJM1r+XK02w35rvGi8im007A9+LkuQQQHuqar79mmjxLHFkJO75p/vmYx+iAvwFMw6EiSQDTbF+HCEWpOjQndensSP6CSxSQx3fAz6NCyz8P6PQj49kz/qowIKwHGRnQAS5FcknxDrmls9W3zBlOP/IffRQGPb9o/B29457aruXTiT/pA6v+CGjQvN45MzBjXqZmSXjGEz/y8GK8WRoGFmzKkI6/s6t3sJ9riPAaz4fpuQYfD58x1owq5oKrEdWvGu/deWDrClWWqu43o32WqHi13RNk3JD0S92uhvLnUFIy2C5PP3jPAT3BHVxX/XUcZxxBsbBOEFutxdw4QAgmwaU8fw3pY0sc2SYIeclxZh2BLJOrHwMqa9HhsCC11Q95hQQiC5HSMh/TOjt246kBlNl8ayKZLgOHEzwysSwM+ZPtAZ5xHhLOfYNEKUv9bhn1bqKzGm0879/PXJd0PHFny+vWVGWSpKNch3yChP7TkKaD+2zVMvLNFnBja88vEdo0KbZ1n6DEHgZj1kNGQG4GPDFbJ3SE/8tPcAdY8wxS6pqiVnjYmHH38TRZIBM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(36840700001)(5660300002)(82310400003)(186003)(7416002)(82740400003)(36906005)(2906002)(26005)(70586007)(1076003)(4744005)(6666004)(921005)(316002)(8936002)(70206006)(54906003)(36860700001)(107886003)(7636003)(110136005)(2616005)(478600001)(83380400001)(356005)(36756003)(86362001)(47076005)(426003)(7696005)(8676002)(4326008)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 16:40:53.5089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b07931c8-d78c-4d87-ec05-08d92c2e8382
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes out-of-bounds access in various places in the kernel
where parsing of TCP options takes place. Fortunately, many more
occurrences don't have this bug.

v2 changes:

synproxy: Added an early return when length < 0 to avoid calling
skb_header_pointer with negative length.

sch_cake: Added doff validation to avoid parsing garbage.

Maxim Mikityanskiy (3):
  netfilter: synproxy: Fix out of bounds when parsing TCP options
  mptcp: Fix out of bounds when parsing TCP options
  sch_cake: Fix out of bounds when parsing TCP options and header

 net/mptcp/options.c              | 2 ++
 net/netfilter/nf_synproxy_core.c | 5 +++++
 net/sched/sch_cake.c             | 6 +++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

-- 
2.25.1

