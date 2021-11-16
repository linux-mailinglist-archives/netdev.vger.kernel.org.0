Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F86645317C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 12:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhKPL4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 06:56:23 -0500
Received: from mail-mw2nam08on2071.outbound.protection.outlook.com ([40.107.101.71]:45277
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235713AbhKPLzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 06:55:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOmITqNyFdHvOissPuKJwy6ETC9K1ZUzYCEbPkgymJegph9K3ORiOP6bAQRNFs8rNsiUIYql/ocSp16eNlZCPunc+f+ozgmm/ARb41qcjjmkstjzRsyK2OYqnsdg2I1VzdAUsofaW25U8/VKHhfbwONDyQ/4vy8CoVy+0fAPKZCB6SnVXHi3QmeRwC4IJuVbZcmHVH07w2HHssvWXDfr2EOJ5VnKd2Cw+XyB4LBV/RdRb0GVN2faZ77UUPodmCUl7D610VRABOPEJKOmlvduskt9ndi5MKZc4u5vyLc7EUVr6zIWJayICkRXZKDfV4t2jXNt2I8VB6lml8nKIr8wRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdzP8Pl81znlfKt/oYDXUm5LzGKuvSo7nFjEE9ZvTus=;
 b=YIRXOxiRb5n7ITfjEZ8EU7AwVF0my3tlq/TThCxyV8/8MNRai7jvk61zmoqu1JGLSO8jgB2q9gAB655OqQ53Bdxrz/HH1McrXn7/F+k5RQ2KgORhJZeajxhl9ZRQi/8EknlIGNN2c2bnWOczXNO/VxLiPmOz46CZGNlxkhTbBp6qenVQ9P865yL4FcXt17PCep1sHvg3QdKJqk+LBy9bV5tq5JjpHgbqq1JKRTMYy71M+RIpiLV9Vqkp9vVXYkvPNrfxe4eEmqkcTfrex6rGn91HVAkRZKRcF7lNg/tUlXxgpAgMxWAvBpcjxeqaJScw13WLqRz6g/qoaFYeOpcVYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdzP8Pl81znlfKt/oYDXUm5LzGKuvSo7nFjEE9ZvTus=;
 b=mr8eenWwlAPMapkxEiFV5MS02d/1TtD0+JJ6+XlN/LDEYNgjgzqye2/A8oYikFw2U0322jxXmNqJS/soXcyTsI2QBJRv6/NYfrc3OBCXC2sVL/uJu34RHlIHUx+ThCwg8C0+9DRNPGxFWcUAQ3ulgtBjAOm4c3Z1l81/aiNZBCfNovJk4pKvuWN1wEio6x9F8iKhrw7vGRuvHFa1QZ3ieSGUVu1KOjkVDDsAW9xD0XmWRJZoVMzF6WJCsO9+yWKqh2V0rLhUD9PXM5Vo82nuVWvs5Itp8IAiUSj42AKAmB3fIQRkd2zmUOZkgJatsfjo3I8PKCpz0w/WZLGWzT6QMw==
Received: from BN9PR03CA0170.namprd03.prod.outlook.com (2603:10b6:408:f4::25)
 by BN7PR12MB2803.namprd12.prod.outlook.com (2603:10b6:408:32::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 11:52:55 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::2c) by BN9PR03CA0170.outlook.office365.com
 (2603:10b6:408:f4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend
 Transport; Tue, 16 Nov 2021 11:52:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Tue, 16 Nov 2021 11:52:55 +0000
Received: from yaviefel (172.20.187.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov 2021 11:52:45
 +0000
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-7-maciej.machnikowski@intel.com>
 <87tugic17a.fsf@nvidia.com>
 <MW5PR11MB5812E733ED2BB621A3249CD5EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
CC:     Petr Machata <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
 interfaces
In-Reply-To: <MW5PR11MB5812E733ED2BB621A3249CD5EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
Date:   Tue, 16 Nov 2021 12:52:42 +0100
Message-ID: <87fsrwtj05.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c797e935-1d5d-4504-fbda-08d9a8f7a0d0
X-MS-TrafficTypeDiagnostic: BN7PR12MB2803:
X-Microsoft-Antispam-PRVS: <BN7PR12MB28034180114AD7A730A15ADFD6999@BN7PR12MB2803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/2WpkLbJUGumdFlFrMQm1vIecCxaREUq2U4V9hQ1I8CCO8/9au5co/mqAMaN3V7kgHgL4498mGXrOaRx6xx0XznChZCy4sB2zoWnznlnqEnMX6l8WJk5km+Z/ynMkixVm7zTRGKMDiYRHsYBbLBSHFxFTK1Gjm12L2NqJ0Ubn3ypwhkmFngUQ/eWdYkQQrBn0pTSWrWfJolImhS+NcEM4JEPaIcd4ppp01dULw6YNSWIuwDcBZIl9YD+G4GZT22fB2uq9hMidBcjmFAVM6E0AJUNJFnZqN29BeGtjOUH3LnYp7En+bZccLcmidxwjpj3CXy2zTiPq3wc3q17Me8DBKyQw+vgHc8DJdL9s0HvWMt3XYYoP+sw40kROssBAcLgfsExPQbzCoSBstTCW+GxEHTux+FZuzoqscGm++q17QWn2MFD0mbX24biHUDqwZGm75t790PA7nKqnjiwx5PJJ03rcsdpsN8IylqgzIpwNOc2iutV64Is40pNOulJgRvCJS2oVAarlOdfZiC0j4urc3CIUoZqgznS6SfmniTPTUjC6x2F/5/hU4UKc8L95ut0mxvEBNhzUdKl/ZNcQbHqtIhAmEK8vQsN5c+jw9kav91+fWd0CoWA0bXfKqrfQ34q40PBt804uBrZm6eb4zEwGsyUrN4xlhfcV6lX1TX/Uyz8QUKabiWEM2fX0qR0TDIEOKBHMVTZv6UAlQ5pm8udA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36756003)(8676002)(2906002)(26005)(6916009)(5660300002)(16526019)(2616005)(7636003)(82310400003)(70586007)(186003)(70206006)(4326008)(336012)(426003)(508600001)(86362001)(8936002)(356005)(316002)(83380400001)(36906005)(6666004)(54906003)(7416002)(36860700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 11:52:55.6415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c797e935-1d5d-4504-fbda-08d9a8f7a0d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2803
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:

>> - Reporting pins through the netdevices that use them allows for
>>   configurations that are likely invalid, like disjoint "frequency
>>   bridges".
>
> Not sure if I understand that comment. In target application a given
> netdev will receive an ESMC message containing the quality of the
> clock that it has on the receive side. The upper layer software will
> see QL_PRC on one port and QL_EEC on other and will need to enable
> clock output from the port that received QL_PRC, as it's the higher clock
> class. Once the EEC reports Locked state all other ports that are traceable
> to a given EEC (either using the DPLL subsystem, or the config file)
> will start reporting QL_PRC to downstream devices.

I think I had the reading of the UAPI wrong. So RTM_SETRCLKSTATE means,
take the clock recovered from ifindex, and send it to pins that I have
marked with the ENA flag.

But that still does not work well for multi-port devices. I can set it
up to forward frequency from swp1 to swp2 and swp3, from swp4 to swp5
and swp6, etc. But in reality I only have one underlying DPLL and can't
support this. So yeah, obviously, I bounce it in the driver. It also
means that when I want to switch tracking from swp1 to swp2, I first
need to unset all the swp1 pins (64 messages or whaveter) and then set
it up at swp2 (64 more messages). As a user I still don't know which of
my ports share DPLL. It's just not a great interface for multi-port
devices.

Having this stuff at a dedicated DPLL object would make the issue go
away completely. A driver then instantiates one DPLL, sets it up with
RCLK pins and TX pins. The DPLL can be configured with which pin to take
the frequency from, and which subset of pins to forward it to. There are
as many DPLL objects as there are DPLL circuits in the system.

This works for simple port devices as well as switches, as well as
non-networked devices.

The in-driver LOC overhead is a couple of _init / _fini calls and an ops
structure that the DPLL subsystem uses to talk to the driver. Everything
else remains the same.

>> - It's not clear what enabling several pins means, and it's not clear
>>   whether this genericity is not going to be an issue in the future when
>>   we know what enabling more pins means.
>
> It means that the recovered frequency will appear on 2 or more physical
> pins of the package.

Yes, agreed now.
