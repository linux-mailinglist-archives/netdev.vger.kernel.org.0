Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08C6461B72
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbhK2P7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:59:37 -0500
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:39626
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243254AbhK2P5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 10:57:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wn8F/+BHmf8c0w87XRqaHN8OXuBT/uyLt8JoT4neuAtSYew8f5ShZqwq4mWhiGR2VrKj0xBOALfI4bqP+uR5AUsFJagNEtSsbfCnQOjRE7+sL//SEUKesspEm9BejTDlqd/jCjBwBKJ4kzIwS7oAak/xdp3sD2iItCDcjJj6bN3qL9fyhl424bAIedvcNqQyKcD0zB9gLLZKe55dsj+4Nfmb4Hl50OU4vEexFHChQ4FwZC2zXN8cKVjwTeSNSLHbt5yVzfuQCLOiD/7GYxD1TnjUXH3YQGsZlmTCazYM+d2NDK2CFUG7YElX4wUE/l4dRKBMHmdpKD456qxc153YFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05IzV4atmWg/ao96fyu1ife/Oy1yXpSTfde2f8fSD4c=;
 b=LE9JSo8aDP45CYJj2aSl/MgR/awvFw3X8ltMJISkFmmiyLeCrQQAukgb/WCxnL9EnPL3P1LYISOiCCQaEvJXfajHLVkM3ggugtCgKYDcuhCxU72rYRYJYB1EarR56OOm2x6uLJFxonqLK+FSgzCzkgWB22yxE5XW+47wfyiLk9DWfyfU1xsPykuFWF3/+op756SzHDSdnpd6zfVWuD+fziLvOUiDzHGRb720vUD5XYa7LLNG3r74gp27a7sUSBkob9u2zn5vQtbWB1bCOjPMf9rBspRAe0Fo4uRHJCgyfMi8gAiP9jNGcc1Z7XpnZ7+T24iyG0QAGxzliBKTAi6nbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=nxp.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05IzV4atmWg/ao96fyu1ife/Oy1yXpSTfde2f8fSD4c=;
 b=q9GrYlM+sn4cZo5aaX7U9KnXSSJUwqhlYwc4a6LpLmA1UmDPz1UugCsSGKWB/4Y6g5ALrBM5CqeVqiwvAyvM1t5Uum0x+7JfBQ9UgJ/3Eq/SFiixvrJMpmoDfljy19k71zJ2P3aiUJLWSjvfmnrtCVlJLgKqAWAeQA4aRT3qcfVZnvYBbnQwV9qrzQiuOjjGGxPHKl9UmBCn3n62RwTsiU6Y33D41AiC2gLHzX6UdzYNfe49+CCaQecBgALOZSclTKEpQF8hSNoN7JeMj22L4hweCktmi3NKxzc4LY204aGGJBhSOjFvN7UPtpPzedSwqDS2Kq8Iz0XTB3zOlCrXqQ==
Received: from BN6PR19CA0100.namprd19.prod.outlook.com (2603:10b6:404:a0::14)
 by DM8PR12MB5414.namprd12.prod.outlook.com (2603:10b6:8:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Mon, 29 Nov
 2021 15:54:16 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:a0:cafe::8e) by BN6PR19CA0100.outlook.office365.com
 (2603:10b6:404:a0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Mon, 29 Nov 2021 15:54:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 15:54:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 15:54:15 +0000
Received: from yaviefel (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5; Mon, 29 Nov 2021
 07:54:03 -0800
References: <20211123163955.154512-22-alexandr.lobakin@intel.com>
 <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
 <87bl28bga6.fsf@toke.dk>
 <20211125170708.127323-1-alexandr.lobakin@intel.com>
 <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125204007.133064-1-alexandr.lobakin@intel.com>
 <87sfvj9k13.fsf@toke.dk>
 <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87ee72ah56.fsf@toke.dk>
 <20211126111431.4a2ed007@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaPCbaMVaVlxXcHC@shredder>
 <20211129064755.539099c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <874k7vq7tl.fsf@nvidia.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "Alexander Lobakin" <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Shay Agroskin" <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David Arinzon" <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        "Saeed Bishara" <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Martin Habets" <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <nikolay@nvidia.com>
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
In-Reply-To: <874k7vq7tl.fsf@nvidia.com>
Date:   Mon, 29 Nov 2021 16:54:00 +0100
Message-ID: <87y257ot47.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e535f1ff-1677-4a79-c040-08d9b3507f6f
X-MS-TrafficTypeDiagnostic: DM8PR12MB5414:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5414E235B36A38A989D4E2DDD6669@DM8PR12MB5414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 74RVFjkWGin3p+OD+fHF6ctqb8Ny7pTcfXrmr3wK9kvEDPqtfqomrRiQBzd8Bhh2aMHc8OINLP27Bo3H42K+OIZhEGlwks/Sp2XVRTMY3QgqgXPcyOdOg7V10Kzv1SwQhKilKzGhbp7039PrJTsKL0ggZyfcBFU+bit3XMnVKRXZ0YYWjXUybDFL1E/pHhhC1y+RIAmghSP9ExAaIFxVi1DPhEfFeRaAhIHkzA8frSYUC36jUKckb01zVgpg8qerUOUXo3N1Tjgsfdnjb+hzHijSIbrrqeXHihvKNoBiOKdD4iH45rp90kaKWKmPtcs/AvlwTmDjRRJfE+566Prc4FLuV5G19KSIPuAFDJxrBklEFbqg0bcn/uj2XL/gOWNoPo7DNPGZKzv/jzZLL9S7jnkZtfaZOZEvWAa5IsUv6r5Rryk+XnGW0MUTB/53olmQaX9CF7sB8+8Q541INPtv+4+41/pgcEFzzvFWyAU0ARltY1ORPRY3p7ivRIGZak1O3nQaudxshw/Id2nbHk7/Bfa46IPzNQ2gzvKRibh0dljS1o0lwb9onqdLnwYwr/i2CDKmyrcksm9wsOJU0uD1CI4FmVTVOlgCdJ6L3aYTCPgbUg022POhpbDWhxSC1LsIv4isCEVv5QPaG4XK7aHn0d7c7+d6oDTIw8WPzE5x4SgbyyUIoGzp4EftuXnM+MTQ3ozxK4CurcEA9WHGgR5ISuwbkNqF36MXZDLKgt0yRpc=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(107886003)(36756003)(356005)(70206006)(5660300002)(8676002)(36860700001)(508600001)(70586007)(86362001)(6862004)(47076005)(8936002)(4326008)(82310400004)(37006003)(54906003)(4744005)(316002)(6200100001)(16526019)(186003)(7406005)(7416002)(2906002)(26005)(2616005)(426003)(7636003)(336012)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 15:54:16.0974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e535f1ff-1677-4a79-c040-08d9b3507f6f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5414
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Jakub Kicinski <kuba@kernel.org> writes:
>
>> On Sun, 28 Nov 2021 19:54:53 +0200 Ido Schimmel wrote:
>>> # ip stats set dev swp1 hw_stats on
>>
>> Does it belong on the switch port? Not the netdev we want to track?
>
> Yes, it does, and is designed that way. That was just muscle memory
> typing that "swp1" above :)

And by "yes, it does", I obviously meant "no, it doesn't". It does
belong to the device that you want counters for.

> You would do e.g. "ip stats set dev swp1.200 hw_stats on" or, "dev br1",
> or something like that.
