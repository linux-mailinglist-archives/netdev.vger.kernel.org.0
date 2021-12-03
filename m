Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEC2467D30
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 19:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382660AbhLCSZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 13:25:19 -0500
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:48225
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1382656AbhLCSZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 13:25:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYpKaDLbzwGzINwas9jOBjejl87KKC53Q9MvND/6ySsTAjeKUjk2hYeS25FVoD3YwSH6Q0hS0cskz+K1uG0lrcpYB7qHjpIw/A1pI7UUAq8e0jNMyTDOACdAtCYvYDDq/LBW8frWCY4OmHsFfBQP7C2yasbSVZeibrfJaA2/sxIIGfU451OUjl0vCQuR5OKYolQcbNlkSBeERWZAM0VFFvW2UqtU9/kHb7O2l37/jpXy6Mp23D2j219AJVktl2cl1gilEl8COVrScPYLO7iqfPk50WbcDPB/T9FNiw+qbsFBrPF2L8agLIahGfTqya6N5rGTDcCWiYng6yV8xskkiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1X7lYXYiJuEp47Tymit/+fnL6hlrOKS1tbzMjQpDiw=;
 b=jg4s4UauGr/2h9TifkAZec1vBrxfFzLtuojy24wUhXa1z1n/A/lHHPmp5Z2/pFWKSlGwpSl/h9cb9kxQ0HAHof7TQI7LrYENue7WlQ/zHyHOCQ3BljvOsm8X3tFp9cAo+OG34gQcop+GAKNks2GSM5Aq0DUQ6E43RVvnvx0rh4JCeo8DI27CKwamfkEtvSrptRsJrGUuybf5jODJ5ZZrwgm33yRCvQK1UJ1VaR0lPxFlTZzPSCpvtCnTfodkI1FW9QwyNEf5iZeZL8vTb5xMdlLvG+x6MCNfD+FX1+HVzaAChqyv6Qu8ZguJrpcxqs8xVoGn4P8qyif2qry1Am0gRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1X7lYXYiJuEp47Tymit/+fnL6hlrOKS1tbzMjQpDiw=;
 b=CwEIcvFA0SA4iG+XjVOf+Mm5PF3zb5qvqS2Vg72RXHZlF2VS6URSovGYHsPRE2ErhCo10tHnAmcUNsYgo42CTYiR+Lddbka6vI0bIHDS1/REgE4I2lJxrbla5chIleIhxZWDnAE9zi9AygAdXauEJl4ASuok0xSjd7I2PFPn9jG7/v7OEGvPzbzvBlzS7fQJb1zaK968K/aIKCoF05dwOuIcgpovUYru9S8dBYEysRZujT95MJnMkPCnohfAmttj9JNDpGOM36LsSXq5IzhPDuSGvZEp2zHLYrNQ7RGSBPmeJ2VDmeA/0/0ZmwORdcBuFG1vPl0EvuxB2ntJ9OPpIQ==
Received: from BN8PR03CA0002.namprd03.prod.outlook.com (2603:10b6:408:94::15)
 by DM5PR12MB1947.namprd12.prod.outlook.com (2603:10b6:3:111::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 18:21:50 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::fb) by BN8PR03CA0002.outlook.office365.com
 (2603:10b6:408:94::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Fri, 3 Dec 2021 18:21:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 18:21:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 3 Dec
 2021 18:21:41 +0000
Received: from yaviefel (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Fri, 3 Dec 2021
 10:21:36 -0800
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
 <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
 <Yao7r4DF7NmobEdp@shredder>
 <MW5PR11MB5812AB9B6E0CAEB6F9A84ABAEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
In-Reply-To: <MW5PR11MB5812AB9B6E0CAEB6F9A84ABAEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
Date:   Fri, 3 Dec 2021 19:21:33 +0100
Message-ID: <87ilw5o8gi.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: befee90a-32fb-465b-d66a-08d9b689c691
X-MS-TrafficTypeDiagnostic: DM5PR12MB1947:
X-Microsoft-Antispam-PRVS: <DM5PR12MB19472FC6FD09170DC3231B7CD66A9@DM5PR12MB1947.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +KunQzdO6sSAMO+hqLsXqgWSZGofbwUSxB0iqgZxFG1SDhsykEWXSESpNp/CYXt9D3jex4ABfHypQRSOJ3wQyC0+j56HUQrYgnP5ryOOJPc3pDr5P4jQMa8Ls9DjVCASzSmIw9GlOV/u7PbPYzSXFqYmlp+k0cI//wwhSK6pdCqevsHEYQQdeA0PC50AWEX1STihuQL5ayj1mPDxDWxP0uSFT/c3lZmiMTQBGhnzhNVeLu8AmK+S2rUpvZWfiakxnKsaN1t8JDiN+/8460L2aBx7OdZ6kdwpZFntG/HbAylWyBgVV84R45EjXxS++XAqqf84aRNmfXOKYETrwhICioi2b9Xj1/DOjehD+XPSwtgp5TqB0QnRhwPjLhZeBVtwowIriKtINr0lQECeXfAYeohp8Ylu3Qhlp4uufwuMMDGRtUUoLINcb4nsTX8ttBtVl/Ky6j4fmugOl59JcUm0nZq5Xc9DJSOE2mUSyokBiFEntrVVb8B9c5VUlvg7faEbERywn1YUUAl4RQ8h5Xqfr7ozopFtdZbO0oP7y4xPswbkXgKLo5zirECsl79GNCrvzWlp76fpKlaIipnwYYlXVIhc4p0xsk+vGB3wEFXrMte4Mpj1asFAmLtxn3SaqrmOL5EbhodjS4sjyyZXZhApgX4Dwtr/UePohuSIaTeiSA8zYMhWxbcjz9FYEUbI9Gyw3zyPmbnvpDkFRcSjnOcq4D0hNnDub710dqh2nixtdIf/Lt9UCvUi4EehOfLO8mdQXM0K0vm5o+ej6FdQeRtq4w==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36860700001)(336012)(7636003)(16526019)(70586007)(26005)(86362001)(6916009)(47076005)(36756003)(4326008)(5660300002)(316002)(82310400004)(53546011)(83380400001)(508600001)(54906003)(8936002)(30864003)(6666004)(356005)(40460700001)(107886003)(70206006)(186003)(8676002)(2906002)(2616005)(7416002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 18:21:50.3638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: befee90a-32fb-465b-d66a-08d9b689c691
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1947
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:

>> -----Original Message-----
>> From: Ido Schimmel <idosch@idosch.org>
>> Sent: Friday, December 3, 2021 4:46 PM
>> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
>> Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
>> recovered clock for SyncE feature
>>=20
>> On Thu, Dec 02, 2021 at 05:20:24PM +0000, Machnikowski, Maciej wrote:
>> > > -----Original Message-----
>> > > From: Ido Schimmel <idosch@idosch.org>
>> > > Sent: Thursday, December 2, 2021 5:36 PM
>> > > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
>> > > Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configu=
re
>> > > recovered clock for SyncE feature
>> > >
>> > > On Thu, Dec 02, 2021 at 03:17:06PM +0000, Machnikowski, Maciej wrote:
>> > > > > -----Original Message-----
>> > > > > From: Ido Schimmel <idosch@idosch.org>
>> > > > > Sent: Thursday, December 2, 2021 1:44 PM
>> > > > > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
>> > > > > Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to con=
figure
>> > > > > recovered clock for SyncE feature
>> > > > >
>> > > > > On Wed, Dec 01, 2021 at 07:02:06PM +0100, Maciej Machnikowski wr=
ote:
>> > > > > Looking at the diagram from the previous submission [1]:
>> > > > >
>> > > > >       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>> > > > >       =E2=94=82 RX       =E2=94=82 TX       =E2=94=82
>> > > > >   1   =E2=94=82 ports    =E2=94=82 ports    =E2=94=82 1
>> > > > >   =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=82          =E2=94=9C=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA
>> > > > >   2   =E2=94=82     =E2=94=82    =E2=94=82          =E2=94=82 2
>> > > > >   =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90 =E2=94=82    =E2=94=82          =E2=94=9C=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA
>> > > > >   3   =E2=94=82   =E2=94=82 =E2=94=82    =E2=94=82          =E2=
=94=82 3
>> > > > >   =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=94=
=90 =E2=94=82 =E2=94=82    =E2=94=82          =E2=94=9C=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=96=BA
>> > > > >       =E2=94=82 =E2=96=BC =E2=96=BC =E2=96=BC    =E2=94=82      =
    =E2=94=82
>> > > > >       =E2=94=82 =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80   =E2=94=82          =E2=94=82
>> > > > >       =E2=94=82 \____/   =E2=94=82          =E2=94=82
>> > > > >       =E2=94=94=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=
=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>> > > > >         1=E2=94=82 2=E2=94=82        =E2=96=B2
>> > > > >  RCLK out=E2=94=82  =E2=94=82        =E2=94=82 TX CLK in
>> > > > >          =E2=96=BC  =E2=96=BC        =E2=94=82
>> > > > >        =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>> > > > >        =E2=94=82                 =E2=94=82
>> > > > >        =E2=94=82       SEC       =E2=94=82
>> > > > >        =E2=94=82                 =E2=94=82
>> > > > >        =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>> > > > >
>> > > > > Given a netdev (1, 2 or 3 in the diagram), the RCLK_SET
>> > > > > message allows me to redirect the frequency recovered from
>> > > > > this netdev to the EEC via either pin 1, pin 2 or both.
>> > > > >
>> > > > > Given a netdev, the RCLK_GET message allows me to query the
>> > > > > range of pins (RCLK out 1-2 in the diagram) through which the
>> > > > > frequency can be fed into the EEC.
>> > > > >
>> > > > > Questions:
>> > > > >
>> > > > > 1. The query for all the above netdevs will return the same
>> > > > > range of pins. How does user space know that these are the
>> > > > > same pins? That is, how does user space know that RCLK_SET
>> > > > > message to redirect the frequency recovered from netdev 1 to
>> > > > > pin 1 will be overridden by the same message but for netdev
>> > > > > 2?
>> > > >
>> > > > We don't have a way to do so right now. When we have EEC
>> > > > subsystem in place the right thing to do will be to add EEC
>> > > > input index and EEC index as additional arguments
>> > > >
>> > > > > 2. How does user space know the mapping between a netdev and
>> > > > > an EEC? That is, how does user space know that RCLK_SET
>> > > > > message for netdev 1 will cause the Tx frequency of netdev 2
>> > > > > to change according to the frequency recovered from netdev 1?
>> > > >
>> > > > Ditto - currently we don't have any entity to link the pins to
>> > > > ATM, but we can address that in userspace just like PTP pins
>> > > > are used now
>> > > >
>> > > > > 3. If user space sends two RCLK_SET messages to redirect the
>> > > > > frequency recovered from netdev 1 to RCLK out 1 and from
>> > > > > netdev 2 to RCLK out 2, how does it know which recovered
>> > > > > frequency is actually used an input to the EEC?
>> > >
>> > > User space doesn't know this as well?
>> >
>> > In current model it can come from the config file. Once we
>> > implement DPLL subsystem we can implement connection between pins
>> > and DPLLs if they are known.
>>=20
>> To be clear, no SyncE patches should be accepted before we have a
>> DPLL subsystem or however the subsystem that will model the EEC is
>> going to be called.
>>=20
>> You are asking us to buy into a new uAPI that can never be removed.
>> We pointed out numerous problems with this uAPI and suggested a model
>> that solves them. When asked why it can't work we are answered with
>> vague arguments about this model being "hard".
>
> My argument was never "it's hard" - the answer is we need both APIs.
>
>> In addition, without a representation of the EEC, these patches have
>> no value for user space. They basically allow user space to redirect
>> the recovered frequency from a netdev to an object that does not
>> exist. User space doesn't know if the object is successfully tracking
>> the frequency (the EEC state) and does not know which other
>> components are utilizing this recovered frequency as input (e.g.,
>> other netdevs, PHC).
>
> That's also not true - the proposed uAPI lets you enable recovered
> frequency output pins and redirect the right clock to them. In some
> implementations you may not have anything else.

Wait, are there EEC deployments where there is no way to determine the
EEC state?

>> BTW, what is the use case for enabling two EEC inputs simultaneously?
>> Some seamless failover?
>
> Mainly - redundacy
>
>> >
>> > > > >
>> > > > > 4. Why these pins are represented as attributes of a netdev
>> > > > > and not as attributes of the EEC? That is, why are they
>> > > > > represented as output pins of the PHY as opposed to input
>> > > > > pins of the EEC?
>> > > >
>> > > > They are 2 separate beings. Recovered clock outputs are
>> > > > controlled separately from EEC inputs.
>> > >
>> > > Separate how? What does it mean that they are controlled
>> > > separately? In which sense? That redirection of recovered
>> > > frequency to pin is controlled via PHY registers whereas priority
>> > > setting between EEC inputs is controlled via EEC registers? If
>> > > so, this is an implementation detail of a specific design. It is
>> > > not of any importance to user space.
>> >
>> > They belong to different devices. EEC registers are physically in
>> > the DPLL hanging over I2C and recovered clocks are in the
>> > PHY/integrated PHY in the MAC. Depending on system architecture you
>> > may have control over one piece only
>>=20
>> These are implementation details of a specific design and should not
>> influence the design of the uAPI. The uAPI should be influenced by
>> the logical task that it is trying to achieve.
>
> There are 2 logical tasks:
> 1. Enable clocks that are recovered from a specific netdev
> 2. Control the EEC
>
> They are both needed to get to the full solution, but are independent
> from each other. You can't put RCLK redirection to the EEC as it's one
> to many relation and you will need to call the netdev to enable it
> anyway.

"Call the netdev"? When EEC decides a configuration needs to be done, it
will defer to a callback set up by whoever created the EEC object. EEC
doesn't care. If you have a disk that somehow contains an EEC to
syntonize disk spinning across the data center, go ahead and create the
object from a disk driver. Then the EEC object will invoke disk driver
code.

> Also, when we tried to add EEC state to PTP subsystem the answer was
> that we can't mix subsystems. The proposal to configure recovered
> clocks through EEC would mix netdev with EEC.

Involving MAC driver through an abstract interface is not mixing
subsystems. It's just loose coupling.

>> > > What do you mean by "multiple devices"? A multi-port adapter with
>> > > a single EEC or something else?
>> >
>> > Multiple MACs that use a single EEC clock.
>> >
>> > > > Also if we make those pins attributes of the EEC it'll become
>> > > > extremally hard to map them to netdevs and control them from
>> > > > the userspace app that will receive the ESMC message with a
>> > > > given QL level on netdev X.
>> > >
>> > > Hard how? What is the problem with something like:
>> > >
>> > > # eec set source 1 type netdev dev swp1
>> > >
>> > > The EEC object should be registered by the same entity that
>> > > registers the netdevs whose Tx frequency is controlled by the
>> > > EEC, the MAC driver.
>> >
>> > But the EEC object may not be controlled by the MAC - in which case
>> > this model won't work.
>>=20
>> Why wouldn't it work? Leave individual kernel modules alone and look
>> at the kernel. It is registering all the necessary logical objects
>> such netdevs, PHCs and EECs. There is no way user space knows better
>> than the kernel how these objects fit together as the purpose of the
>> kernel is to abstract the hardware to user space.
>>=20
>> User space's request to use the Rx frequency recovered from netdev X
>> as an input to EEC Y will be processed by the DPLL subsystem. In
>> turn, this subsystem will invoke whichever kernel modules it needs to
>> fulfill the request.
>
> But how would that call go through the kernel? What would you like to
> give to the EEC object and how should it react. I'm fine with the
> changes, but I don't see the solution in that proposal

You will give EEC object handle, RCLK source handle, and a handle of the
output pin to configure. These are all objects in the EEC subsystem.

Some of the RCLK sources are pre-attached to a netdevice, so they carry
an ifindex reference. Some are external and do not have a netdevice
(that's for NIC-to-NIC frequency bridges, external GPS's and whatnot).

Eventually to implement the request, the EEC object would call its
creator through a callback appropriate for the request.

> and this model would mix independent subsystems.

The only place where netdevices are tightly coupled to the EEC are those
pre-attached pins. But OK, EEC just happens to be very, very often part
of a NIC, and being able to say, this RCLK comes from swp1, is just
very, very handy. But it is not a requirement. The EEC model can just as
easily represent external pins, or weird stuff like boards that have
nothing _but_ external pins.

> The netdev -> EEC should be a downstream relation, just like the PTP
> is now If a netdev wants to check what's the state of EEC driving it -
> it can do it, but I don't see a way for the EEC subsystem to directly
> configure something in Potentially couple different MAC chips without
> calling a kind of netdev API. And that's what those patches address.

Either the device packages everything, e.g. a switch, or an EEC-enabled
NIC. In that case, the NIC driver instantiates the EEC, and pins, and
RCLK sources, and netdevices. EEC configuration ends up getting handled
by this device driver, because that's the way it set things up.

Or we have a NIC separate from the EEC, but there is still an option to
hook those up somehow. That looks like something that should probably be
represented by an EEC with some external RCLK sources. (Or maybe they
are just inout pins or whatever, that is a detail.) Then the EEC driver
ends up instantiating the object, and implementing the requests. And the
admin needs to have external information to know that external pin such
and such is actually connected to PHY such and such.
