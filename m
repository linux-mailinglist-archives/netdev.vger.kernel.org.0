Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361054633A6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhK3MAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:00:42 -0500
Received: from mail-mw2nam08on2045.outbound.protection.outlook.com ([40.107.101.45]:58086
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241234AbhK3L7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 06:59:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBztgWDkpPsJtttDKJnC7MqTDHoN+OudBdm2ozyuRx5lQ8ITl8NGfmMmcOxEgIalR57VhL/OqtXIkSMjKINORzGp7LyuquUuxUSQ95la5kDKK3xTd5DArQD559f8f3zHzu3SMf0/K155mVvQe5YtVBwGmJGWDQf5K+XNENfEqkrEpKDUhHanOvEjs8cL6T1EtT6Ce+wSDgVLeqyxVA5TlXh+hWW71cIH2rxfcMFIoTm4cZynIVdzCq8LkhmEAjgw9zhDaj5WOhqvhiwxSAQASaC4tODpIHd17tPYnawyYYnt8qRkt+yHIkmZ+ZyZ11z6E93EPF+uSCDBnJ90Ly0opA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UV5jGAM8nykz5JaNZNxdaIYXv4GwUIcQmDKA21C4kQ=;
 b=EFdtp7LDcDQY3HcSpVcZ4FbOIDvOtiHrIdAU8P+VfI3bBaIl4DPAFZz+yAh27xQ2dvGjj7fPCw7RBs3ItXm6EbOOnvBfOPc7kOky6/R7nQOYfTELZD7+bDI7gDb0msib5AyRObE1RZdnDhJMj8teIRaQ2Ysv5wVGafTFaAlBV6HAkAS1D+v6OrX6dq7bophV5jN8MZotMF2sr0jwLDNchgwXlOzULtuMEF054SI0fQiPsXb0bwUYB6qcMwHkkWdvvFlGIR6uPYNNSj8Oe9A84HVBaF3S9DohgMkL1SPPzlY3kUypjK6ytLn/CgkzdpqiDrrObJukkDQZw6+/WcEyGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UV5jGAM8nykz5JaNZNxdaIYXv4GwUIcQmDKA21C4kQ=;
 b=VrHV+mnjPfqdmKMve2jKi3pofFtaVPddiVAdLoXj3s0+bW99HqDbR2rbSTH481JU4f4JdyBB0gXzNdy1MLSqSWPggU6GuX2jpUo0IVAhsoaKBhJL30J2mcJmFoREvxy/uPB/PEe2+PcZKHiuTW3jJdyrDNHkbaYa0lz0b8luBGFzTAg5sLJtwnEcIfSScn9+LVhCL7VJJghzmrDvfC7326y7DpdcV2v+TtYjrM3Y5fyP6RRr2SnJgXD7C8fByc8juRTFykEofzy1Xftv4bsIw/a9FcF07IKk/0f6ibUuwLRdBh/OLRwvffO3xYMO+TS85P3/3tDUUnbiPG8YaczH2Q==
Received: from MWHPR2201CA0042.namprd22.prod.outlook.com
 (2603:10b6:301:16::16) by MW5PR12MB5569.namprd12.prod.outlook.com
 (2603:10b6:303:196::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 30 Nov
 2021 11:56:03 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::f3) by MWHPR2201CA0042.outlook.office365.com
 (2603:10b6:301:16::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Tue, 30 Nov 2021 11:56:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 11:56:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 11:56:02 +0000
Received: from yaviefel (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5; Tue, 30 Nov 2021
 03:55:49 -0800
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
 <20211129080502.53f7d316@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87sfveq48z.fsf@nvidia.com>
 <20211129091713.2dc8462f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
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
In-Reply-To: <20211129091713.2dc8462f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <87o861q2m4.fsf@nvidia.com>
Date:   Tue, 30 Nov 2021 12:55:47 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5f96cce-8bec-426e-6b13-08d9b3f8628a
X-MS-TrafficTypeDiagnostic: MW5PR12MB5569:
X-Microsoft-Antispam-PRVS: <MW5PR12MB556900652589D899CA4FE743D6679@MW5PR12MB5569.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +UJhJXBWd/Na8clRxS5hb5jfQewiLZUHfz+JYrRbbaaw8wwSFUgadCS3c8AIZGT7VfPAzqu9jb3VC3DGI02RDOzU/Yj/EmON/VwWdR9ZXqkw2uKIMUg0PKGHUuYl8f1GQwmYXE4jH89hun2aN2Efl2VtdMWDxkRvVoZqo4irrdwspHHbLZhaDAR5yZLPPfIwNnt/4PHajAeRUGxIFAx69qTlvyLATWWg0o8OLyg4W/ZntifhCburz8hdLB79+8GHLVU/b+3UlNt9cczjI7kzCY5B0jhkHgG7l4IoSmCHf7UdDdD7K+9r5AnY9FDK3zqrZrNimuLRLkZK+IBwZztkMSMoh3RS41mbL9ywxN245KU5VvESUgxMiSs8kIacSjHDowwplXYLiMxS4S0Rt4xGv7lM8Uc41/KOTjUwSFRYZaik9j/5C8LS6yYT0egvJM/4vBm4lskYAi0P59T7ROuhZHmBL0hOJox2GxIA2JmNkvQ4GL8EWmadMpVmr9cnwO2Yu5QSA9hlqJmbJUAJzmIPrmfOvtDzyoNkCuDphSuR0BJbJ1x1HBpdv3lK9SFl8swfemqhAjVZuw3EPwNmmXJvXAvpKcHyYDNYldvo7V3LjAkPOY+bzqst4u6Vh/04/C193YiPXWolOLOA7L/89SWb5eXfJNuWly98LU0SQePJQk0v+fKMCWv4ErSgg6KLlNdLSXyNUQ3DieAdkbqvhQJjL574Ryt5dU0bayy/fOaaWgCVE6GV1bt10vI+R9Oc65a3ls62NYhF6seyleqYLwRlfM/jolw5epc2dCC/qzbFEiI=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(107886003)(508600001)(82310400004)(83380400001)(7636003)(7406005)(40460700001)(356005)(316002)(7416002)(54906003)(36756003)(4326008)(5660300002)(2616005)(336012)(426003)(8676002)(70586007)(70206006)(2906002)(6916009)(26005)(8936002)(186003)(16526019)(86362001)(47076005)(36860700001)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 11:56:03.5027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f96cce-8bec-426e-6b13-08d9b3f8628a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5569
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 29 Nov 2021 18:08:12 +0100 Petr Machata wrote:
>> For those who care to know about the offloaded datapath, it would be
>> nice to have the option to request either just the SW stats, or just the
>> HW stats. A logical place to put these would be under the OFFLOAD_XSTATS
>> nest of the RTM_GETSTATS message, but maybe the SW ones should be up
>> there next to IFLA_STATS_LINK_64. (After all it's going to be
>> independent from not only offload datapath, but also XDP.)
>
> What I'm getting at is that I thought IFLA_OFFLOAD_XSTATS_CPU_HIT
> should be sufficient from uAPI perspective in terms of reporting.
> User space can do the simple math to calculate the "SW stats" if 
> it wants to. We may well be talking about the same thing, so maybe
> let's wait for the code?

Ha, OK, now I understand. Yeah, CPU_HIT actually does fit the bill for
the traffic that took place in SW. We can reuse it.

I still think it would be better to report HW_STATS explicitly as well
though. One reason is simply convenience. The other is that OK, now we
have SW stats, and XDP stats, and total stats, and I (as a client) don't
necessarily know how it all fits together. But the contract for HW_STATS
is very clear.
