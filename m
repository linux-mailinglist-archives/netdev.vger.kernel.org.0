Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FB1461C7D
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346986AbhK2RNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 12:13:49 -0500
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:32353
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233837AbhK2RLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 12:11:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuTOaxvpPOT27APLLACjpUR1oPwcxYT4IYISuC1l5qErxzimTF8+j98p+KWScZlzVQcriETZQzkjUZlDwWdkc3QrR+JqsB1MGJRjTyY3G3SXW2bwEKD0+Ipdwh6WKHZ5mgnAzlHhCP2mqtTqfMp6U07KtTZV3MyQjtSqBAepLVjixmwQiC40JtMDJT/sX1CiEavQJW8zAlFFEP2PeKHjGgjceznhHjkeAJ7UoaJYnXQhKAzb5NkMdWX1u8PIiWHjO/YBF6qQwBzD8PGp2XXWWti5R1DQ/vwz523Uy1IbIRZW9Uq/eflfg5L7YrfkLBuPpH7PsMzzVs0b/rYjz9RD2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyBqx02PFyxR62KCHS6bSeaWgSgXL1F8Cp86rnw26Nw=;
 b=SbPqm0NTsVhiCgmjSEGIDtFIHXv/Nbxq1iG6VOAUxvNbEfpiYA9VQidFeIUUho8wGDQDbnbc+x7iz4SYk5Eh38JjOERma2+z+A86tVBGnEn9iDYmvyk2Ncdm27uTyGQvyDh2eSOkX2qDmbMso1PnXZNW3aVXzwYWMsWjR6GQuOl+6PqHCrJC0hz148Bv3nl3cch18QjtIW19jVh5ce8l0bi+cvTiksBYBgm1zKpDX1ZBqvQpYUx+u713pH+KsC76dCEj+fyVu2kOCpGJnCUMD6oLeMQdZowE9mdI5YqlL+LzaW+aCJz5qBmridR6ZMsOOmHXQY/s08p3XPA+TjX4Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyBqx02PFyxR62KCHS6bSeaWgSgXL1F8Cp86rnw26Nw=;
 b=JMIMKoMc6JbnCaUm8USpFplMBx8l/hLK4mWHPPaFuvxM22EbglUMIXBlMc2PTHaKujAeyOcz2TTekUK4IOJcigIKdANJ/9MOvfQIzhqW0oNve34DEqWVxaDdl2R0YbDros3wFjS55AJzx1I27uTx1IF1laiKVnFdFDIbwgG++7POOLjzdVUic+mXH9Zx1SNbCw8M5E37kckxP8j1QRsxysCnKw72lID5n2sXTkxkCZPFxj8KBmkLteBO4uq2ZEDN5uLHsW3hRZUjGU/D+FHjZ9z9CNlNaWgwG/tVx32weZ7l+DX7mIRwKXliCxjcef213UD0UXmKn1V8lPFDHuaBew==
Received: from MW2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:907::20) by
 MN2PR12MB3086.namprd12.prod.outlook.com (2603:10b6:208:c7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.24; Mon, 29 Nov 2021 17:08:29 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::ee) by MW2PR16CA0007.outlook.office365.com
 (2603:10b6:907::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Mon, 29 Nov 2021 17:08:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 17:08:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 17:08:28 +0000
Received: from yaviefel (172.20.187.6) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5; Mon, 29 Nov 2021
 09:08:15 -0800
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
In-Reply-To: <20211129080502.53f7d316@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 29 Nov 2021 18:08:12 +0100
Message-ID: <87sfveq48z.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c9c2dd5-6395-4204-cb7d-08d9b35add3f
X-MS-TrafficTypeDiagnostic: MN2PR12MB3086:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3086A71EFF94466D7385A030D6669@MN2PR12MB3086.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gHZWiMyMV8qZ8ARMtRO3jjwtpaqws6zwOnx3PlUjKnIbiwk6PfySOfSddZ6Xcd8HRU4BJvlpbbEl19TxPmU0JWgjo0HehGq82hemi/xjdA7jcLjPxuxu9Zs5Wt1qJMVdLmnk45vveWsixAqYI8GNngOQk8mEetx/xBGRf9NmXacVk2p4PA0TWhp59TzZbyxjNuJUDnrGWUN9a6Rk3mougKuZalgel4Q86UthKn1n5IJkSXRrzachYkmJHnitOxXrCMx1XOoKxoRGdB8TSPq4hjXp4hFAy7tLKyFrfpNya/+jSusYdx4xc1a6mQ64JNUwNYoKlKj/uO17sNpX9tPhY4YwnjUud4y5uSet7yvg33TEBQL/YOHKhsLV5qWQYNkdGqSuA5AJPevqZmmMDR9xJ/w04+wwEEeDByLvhBOQDhaufTMgK2BJMqsWZ3zCmFAp5NU6i4Hh+79oISe4slFE7HbLX7aAevROj5xSun/UtGsVhboGdrP4fVsetFITVaxINc8HBbsRJQyyAxDtbJ1rYsb68jN5M20Z+Iw3HjBfj+VsR3rNcjJc0n8mRWB/ZybHO1GIMOMLxSz+jqIDkzh+5G1Eshds0f8lMEOdfCoNcZvLnZMJqXymfIMrQYzXxIVngwP9Z9kSasiurNaQPu/5rDRN7mHqIjFM/1bTx1gcYNqirfQQ0pHRbZU4CqLuOqtrx4PhaUGBe5ugY65RU5oyPdIfjD1Ux53wwP+8gZukP3M=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(4326008)(508600001)(2616005)(8936002)(8676002)(7406005)(47076005)(107886003)(6916009)(6666004)(36860700001)(86362001)(336012)(36756003)(54906003)(16526019)(82310400004)(186003)(26005)(83380400001)(2906002)(356005)(316002)(70206006)(7636003)(7416002)(5660300002)(70586007)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 17:08:28.9336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9c2dd5-6395-4204-cb7d-08d9b35add3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3086
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 29 Nov 2021 16:51:02 +0100 Petr Machata wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> > On Sun, 28 Nov 2021 19:54:53 +0200 Ido Schimmel wrote:  
>> >> For query, something like (under discussion):
>> >> 
>> >> # ip stats show dev swp1 // all groups
>> >> # ip stats show dev swp1 group link
>> >> # ip stats show dev swp1 group offload // all sub-groups
>> >> # ip stats show dev swp1 group offload sub-group cpu
>> >> # ip stats show dev swp1 group offload sub-group hw
>> >> 
>> >> Like other iproute2 commands, these follow the nesting of the
>> >> RTM_{NEW,GET}STATS uAPI.  
>> >
>> > But we do have IFLA_STATS_LINK_OFFLOAD_XSTATS, isn't it effectively 
>> > the same use case?  
>> 
>> IFLA_STATS_LINK_OFFLOAD_XSTATS is a nest. Currently it carries just
>> CPU_HIT stats. The idea is to carry HW stats as well in that group.
>
> Hm, the expectation was that the HW stats == total - SW. I believe that
> still holds true for you, even if HW stats are not "complete" (e.g.
> user enabled them after device was already forwarding for a while).
> Is the concern about backward compat or such?

I guess you could call it backward compat. But not only. I think a
typical user doing "ip -s l sh", including various scripts, wants to see
the full picture and not worry what's going on where. Physical
netdevices already do that, and by extension bond and team of physical
netdevices. It also makes sense from the point of view of an offloaded
datapath as an implementation detail that you would ideally not notice.

For those who care to know about the offloaded datapath, it would be
nice to have the option to request either just the SW stats, or just the
HW stats. A logical place to put these would be under the OFFLOAD_XSTATS
nest of the RTM_GETSTATS message, but maybe the SW ones should be up
there next to IFLA_STATS_LINK_64. (After all it's going to be
independent from not only offload datapath, but also XDP.)

This way you get the intuitive default behavior, but still have a way to
e.g. request just the SW stats without hitting the HW, or just request
the HW stats if that's what you care about.
