Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CAE461B68
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244609AbhK2P4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:56:43 -0500
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:16481
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234066AbhK2Pyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 10:54:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6fBsY1YWAwFY6/GlajCjyhPDv4dJt1dBE4fnmuKmvrOYBpmeontiQePUYYW71WgQw4Kbqr93I1RwRInAOSm0lD2ljw31cc1nJUKDpKZjVF/jCNlqw1dbymtHgQaOBldIAh5WNdfU3nbHHxAfjPxSy+XUZlGESi4o0tlDG763iPjUMgvwjkVr1UnVUP6yVDXmlbXgq6S7Ezagk1MiOC0B4CyzIWjKGzmHjdXERgRaPKXNoAP9Mq5WP6U4473nfvGPwUMM/4SNnRJixkEKBPE9FrbjDCjVyh6Jk3bHr6FSx3K6Rbi1N+2QZ7n2kONlbuKNaoVUtLAPgswSe7kK2WyIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXbrP4c7i2pWyd7UqLWXXvDaWK5hW3AKekFEqHb76BY=;
 b=P2pHw7/ySSX0OwvV1lKOMQu6CrSRVyRGjhfxuGyk19kRjqQ7uir61ugfKfaQOzqzDOgXZnZJeCJVGNZzSk0R+ajxYMX8f0KoxM0o1QubQXqZQDBaCpYK387CllK01Sg5OgTijvVAccR8EKudN0I6qMWOw2e7/OpQN+M6pAfoAodm5QCYSP24ECc3cnCBwjP9qQJcXPIvYp+0tYrS09gHz2C7TPb20awwLhRqb/DXKiItvz0xJzn04/FeZ5DP91+PWGaDr8Ojdd+cKVGo6apQ93wLlG3nbRuBgCDKH6WZIGe9x/zWkiZ3f8E60hwucz+tDr6X6jx7qeUgJe2De8D2TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=nxp.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXbrP4c7i2pWyd7UqLWXXvDaWK5hW3AKekFEqHb76BY=;
 b=ANEmOyDa3euPRRNhHm/hi+rfZm7EGW0Y8ZSXJ6t525THr1dMAThigzW+jnv16m103kc6B1kjNUOIvX6I4BvcWauhcG0EVjqYqdVqKy7x840/t0+/xs5VvZbo0/9iVIVbpS/+cEXznI60CnvE33iwvaQzZFG+CS86zXMGa6PvxIaUIvoLORJllWCJymeokMpOvVbMYCFFxW3ZNjE++4svNkS/q26S8Xxh1IfPUnO9vb/8vreAnIslSlsjuZn5ooWE8+JT2wjztsAtECKE6gPpbc8wiBr3BzBEt0edofizvUpC09ctAeFFsog9fYwE0WaGlnGXM5T7vqmYnLkzC7Z1pA==
Received: from DM5PR13CA0055.namprd13.prod.outlook.com (2603:10b6:3:117::17)
 by BN8PR12MB3044.namprd12.prod.outlook.com (2603:10b6:408:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 15:51:18 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::ce) by DM5PR13CA0055.outlook.office365.com
 (2603:10b6:3:117::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.8 via Frontend
 Transport; Mon, 29 Nov 2021 15:51:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 15:51:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 15:51:16 +0000
Received: from yaviefel (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5; Mon, 29 Nov 2021
 07:51:05 -0800
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
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8r?= =?utf-8?Q?gensen?= 
        <toke@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
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
        <virtualization@lists.linux-foundation.org>, <petrm@nvidia.com>,
        <nikolay@nvidia.com>
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
In-Reply-To: <20211129064755.539099c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 29 Nov 2021 16:51:02 +0100
Message-ID: <874k7vq7tl.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75633514-1b5e-4af4-ecbe-08d9b35014e0
X-MS-TrafficTypeDiagnostic: BN8PR12MB3044:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3044EE47FC32AD5B7F7FF257D6669@BN8PR12MB3044.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJ3JvKbsMpDxcOUfvJy8Ae26I9aL4/DQM0XJ+m/jz1qsU551x42qlQ6fpypQGciEYB3JhS1zKoBb1JwkYgc8yRbzAeIxgvUZ3q4awa2F240ulzW6t6WLmQ17zMtxvWmOPrQO631qn68dgzh3cLGiZMAUSWSaDMmzAot1dqX8ZpINvWHgalns8wRfdg5Q5QK0EAbwAJLIz/eBc34i+FKTaKbMdZhh8NHhcpaEH5QA7/zDCAeciYA5wxCrZPxMPA96q7rocrXu91XvSwX5PTD05dff/YkRnyT2UdA02UC63uhJOi3fLjrfvz8G+yh+AjwyDYO0VdoGqQhhAoSw5+TfkOhIpOp5z+qC7f7YTxVrcRd5is5LhO9LUFetN5G777UIi+K438QkeFV/4gNyBMhTjbY1p6mPw6vY4S+rIMTaTAfQnDFFMOlvxfdpQj/UA+8LdUpzJg3SJE79JB7nf8v8WC1j9IK/KIlpCKY8jpNFg0HM5s+7diPCwFMH1A0rKfe2oMrVr0HI/oXY3EUgmj1gG/4q/UtNmDc2HXz+ccUkM4NoQRvkNaZjXhd/9NM8ll7twKQG/oBArlxExUWHszksLD8SVc/vL0mileH6UxKU2hhkkkAtSSzqDZ5tdsYK66DLAkzLqry3FL/B2oDQfRH8i1gcx2sIuqt0hARAJbH7SpCUbKJEqhw0u2W8GjByMeGdzRfe2Yo7betYBFHYXYppxNjrO/zdNxIO7J7FPBn8rjL037lV/OhguBBSBpuxu8IhPA0LjwJayNmmIkMYNiFbZCcT4QOEN+d3HY0Okufh10YWEVWrzeD2AIpqMKGaEIuDNdhuiBEwY90nS44HmUh5Y00Av1MbAnh3XFoORtodPiQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(8936002)(8676002)(7406005)(86362001)(70206006)(966005)(5660300002)(26005)(356005)(7416002)(70586007)(36756003)(54906003)(83380400001)(82310400004)(7636003)(186003)(107886003)(6916009)(16526019)(2616005)(336012)(426003)(47076005)(36860700001)(4326008)(6666004)(508600001)(316002)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 15:51:17.7597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75633514-1b5e-4af4-ecbe-08d9b35014e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Sun, 28 Nov 2021 19:54:53 +0200 Ido Schimmel wrote:
>> > > Right, sure, I am also totally fine with having only a somewhat
>> > > restricted subset of stats available at the interface level and make
>> > > everything else be BPF-based. I'm hoping we can converge of a common
>> > > understanding of what this "minimal set" should be :)
>> > > 
>> > > Agreed. My immediate thought is that "XDP packets are interface packets"
>> > > but that is certainly not what we do today, so not sure if changing it
>> > > at this point would break things?  
>> > 
>> > I'd vote for taking the risk and trying to align all the drivers.  
>> 
>> I agree. I think IFLA_STATS64 in RTM_NEWLINK should contain statistics
>> of all the packets seen by the netdev. The breakdown into software /
>> hardware / XDP should be reported via RTM_NEWSTATS.
>
> Hm, in the offload case "seen by the netdev" may be unclear. For 
> the offload case I believe our recommendation was phrased more like 
> "all packets which would be seen by the netdev if there was no
> routing/tc offload", right?

Yes. The idea is to expose to Linux stats about traffic at conceptually
corresponding objects in the HW.

>
>> Currently, for soft devices such as VLANs, bridges and GRE, user space
>> only sees statistics of packets forwarded by software, which is quite
>> useless when forwarding is offloaded from the kernel to hardware.
>> 
>> Petr is working on exposing hardware statistics for such devices via
>> rtnetlink. Unlike XDP (?), we need to be able to let user space enable /
>> disable hardware statistics as we have a limited number of hardware
>> counters and they can also reduce the bandwidth when enabled. We are
>> thinking of adding a new RTM_SETSTATS for that:
>> 
>> # ip stats set dev swp1 hw_stats on
>
> Does it belong on the switch port? Not the netdev we want to track?

Yes, it does, and is designed that way. That was just muscle memory
typing that "swp1" above :)

You would do e.g. "ip stats set dev swp1.200 hw_stats on" or, "dev br1",
or something like that.

>> For query, something like (under discussion):
>> 
>> # ip stats show dev swp1 // all groups
>> # ip stats show dev swp1 group link
>> # ip stats show dev swp1 group offload // all sub-groups
>> # ip stats show dev swp1 group offload sub-group cpu
>> # ip stats show dev swp1 group offload sub-group hw
>> 
>> Like other iproute2 commands, these follow the nesting of the
>> RTM_{NEW,GET}STATS uAPI.
>
> But we do have IFLA_STATS_LINK_OFFLOAD_XSTATS, isn't it effectively 
> the same use case?

IFLA_STATS_LINK_OFFLOAD_XSTATS is a nest. Currently it carries just
CPU_HIT stats. The idea is to carry HW stats as well in that group.

>> Looking at patch #1 [1], I think that whatever you decide to expose for
>> XDP can be queried via:
>> 
>> # ip stats show dev swp1 group xdp
>> # ip stats show dev swp1 group xdp sub-group regular
>> # ip stats show dev swp1 group xdp sub-group xsk
>> 
>> Regardless, the following command should show statistics of all the
>> packets seen by the netdev:
>> 
>> # ip -s link show dev swp1
>> 
>> There is a PR [2] for node_exporter to use rtnetlink to fetch netdev
>> statistics instead of the old proc interface. It should be possible to
>> extend it to use RTM_*STATS for more fine-grained statistics.
>> 
>> [1] https://lore.kernel.org/netdev/20211123163955.154512-2-alexandr.lobakin@intel.com/
>> [2] https://github.com/prometheus/node_exporter/pull/2074
>
> Nice!

