Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A20467D75
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 19:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241624AbhLCSsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 13:48:33 -0500
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:61728
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233187AbhLCSsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 13:48:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKKxROA6G8N8fWKJczFQhztE5qoetApLlsuMSl1VQGJMNqjLtl9qeQyl4D3q1X7VurYILjznRlDWVTU6RGefFPToL7IgL1Cv6cenH0z8YQU9deQ+cfrZLH2x5n6P1SuRdb6gG6B+J+kO7zFvR6wp9hUu8yeQVGSZf6H87S5Jwuv12M4qsaggFwPW1T61cJqQyp6iXtYl9Knh03t//gN/qVniSKPDKUDUSCt2iWLqFml2hqQ5GAyIGeR0BRuR8zKXWC4xDsm1okEXltsj9G46YTDr/bPL14Pdu4f/OJXKkRGEt7RXrw2Zvw1AJLaSA2MQE+LZVrMu3Bda4B1nYBZMoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mUC72Xw4PiEgi22f1i6MVaGN5WAFoXfO0HFHEVbdQc=;
 b=Q6HRsk1RkLh+KElXLoTPfICk9CYN2PtV2CgQZwTqattcJ4E8IYv+CyBMIIksrpGvm0QdfnWYwOfEe6VVgOHzJ1W/X0a/iI0tccu07nUTXZNW7FWVt3vVj/cpgfT7SaeW9IbouMOs54nmHd715cOQxWiX4X0/EXontMW7NDm+p4r1E8aGsnLqI//E9eOqP8vTel+z6V/IW4wS/ZpJWN9E7QGI7SSJjazrMqaNHoA3z3mRSemsEMji7DzqoCMoeVeOvwNPZeSkBxZNrWIuE7KU0wRYY/SJAqfMSXkejLTx/NVSTIglHUUT7+IV5yofS2nhpe7nHaYa6YazYpZjA41C8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mUC72Xw4PiEgi22f1i6MVaGN5WAFoXfO0HFHEVbdQc=;
 b=uLtp73cE8ia94ijemuLLByiJwwyWZNfLdxWi30cYV9ZvSJqE3jlQ1CcsPr3HCZfFI/0Js+0hfnEDafkd1OuoFWB7/KwbVsm+V16XT7v9n/kAn09cKigLDNc6YugTNIouz5+RIHrNg1eM6wYHEyqMpyLNx94R1kU0tZNL7O6PXreTdXhniNs9leNDiCQwfWv/Q38T9+0tyDo0835ra7totMk+X7wkijDYf2o84sFBdyyCPMEURx7L/heEWHLRLJyOmF6eWnPUnM9Em8breBXgoKb2y0oETnfMbHfewc7iHGngNgk0vBJyTWtqZYJwMEvyLIVfHxih+lfd8csJ/Vxmdg==
Received: from CO2PR04CA0186.namprd04.prod.outlook.com (2603:10b6:104:5::16)
 by MWHPR1201MB0206.namprd12.prod.outlook.com (2603:10b6:301:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 18:45:05 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::41) by CO2PR04CA0186.outlook.office365.com
 (2603:10b6:104:5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend
 Transport; Fri, 3 Dec 2021 18:45:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 18:45:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 3 Dec
 2021 18:45:03 +0000
Received: from yaviefel (172.20.187.6) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Fri, 3 Dec 2021
 10:44:59 -0800
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
 <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
 <87pmqdojby.fsf@nvidia.com>
 <MW5PR11MB581202E2A601D34E30F1E5AEEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87lf11odsv.fsf@nvidia.com>
 <MW5PR11MB5812A86416E3100444894879EA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
CC:     Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
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
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
In-Reply-To: <MW5PR11MB5812A86416E3100444894879EA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
Date:   Fri, 3 Dec 2021 19:44:57 +0100
Message-ID: <87fsr9o7di.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad63c61c-688e-4d18-b4b8-08d9b68d061d
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0206:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0206B6DC63A2615B41138792D66A9@MWHPR1201MB0206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NxnlQ6hD20QJx62VYkxKLbbbsyOHviTahQ17bF6fPUTf7/gezgBYN8CUj/ITG0DSHxRpwlz7GTdbaxzebbhWagtB8d9HGu11eA5SsxaupIRWPGhT9QoLOcScUZqSZG87N94k4YPoR0/GMcztZH97T6aAZyY+rx9twwC9vxt0VDxT2NgcZ2wm5KeU5DL8YWjDfidXiQNkP+BsB5C0ooUZezKISK8K5XYwYzuNgzUGBFW8dF+GiULCLuPmKdAEMCcs6FwUz9oRp+VYA+33cDb5cOnT3G9WKycqarELZwtIlD8dYfxMJKTcc4CowpTEEKz+RZ1jajSyd3lBszMSI4F481C/037ZfAFDZxVLXjHqm6cjqh1SfR4kdo/AXIBtRCEeweD2HyWMr+/MLevqsi19lNkSybbddSvWC7eJQXwupSJAGn4odAZ+2Whg/J0093JZASfaR2Wf6p1p04yhrFTVcrM9klCHFNq8LNX6oE9ibhYZAkyoNwxKqbCX1uPPnxZjdzTIxr6atlaAZUdZsPG6ckSjWOufNqbzZfGLdKvaE2pKNjMp8IqBCD77AOcAUvc8qJz4amUHH044KkZSvsZ+262R2S+ERRBQTmeImBvKFK45rEiyDiJpfNdfGTmTcfE9mz3Ob7kui1FHeHhHjYGBH3a6T0Q4/pIomPf6LfvDzJKj7Qvo29YPxGi+yzeFuQMJ5jJ1WVwZWmlFw4dNONfVf8f0r9ZDxtHodDNNPPhpDwTZRW8hOuTvaPFCb9qjxf1ivfwLMosFiDpjteQ3T8oIaw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(7636003)(40460700001)(7416002)(426003)(336012)(316002)(6916009)(356005)(2906002)(36860700001)(54906003)(2616005)(5660300002)(26005)(186003)(16526019)(8676002)(47076005)(4326008)(36756003)(508600001)(70206006)(70586007)(86362001)(83380400001)(8936002)(82310400004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 18:45:05.7639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad63c61c-688e-4d18-b4b8-08d9b68d061d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:

>> -----Original Message-----
>> From: Petr Machata <petrm@nvidia.com>
>> 
>> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>> 
>> >> -----Original Message-----
>> >> From: Petr Machata <petrm@nvidia.com>
>> >>
>> >> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>> >>
>> >> >> -----Original Message-----
>> >> >> From: Ido Schimmel <idosch@idosch.org>
>> >> >>
>> >> >> On Thu, Dec 02, 2021 at 03:17:06PM +0000, Machnikowski, Maciej wrote:
>> >> >> > > -----Original Message-----
>> >> >> > > From: Ido Schimmel <idosch@idosch.org>
>> >> >> > >
>> >> >> > > 4. Why these pins are represented as attributes of a netdev
>> >> >> > > and not as attributes of the EEC? That is, why are they
>> >> >> > > represented as output pins of the PHY as opposed to input
>> >> >> > > pins of the EEC?
>> >> >> >
>> >> >> > They are 2 separate beings. Recovered clock outputs are
>> >> >> > controlled separately from EEC inputs.
>> >> >>
>> >> >> Separate how? What does it mean that they are controlled
>> >> >> separately? In which sense? That redirection of recovered
>> >> >> frequency to pin is controlled via PHY registers whereas
>> >> >> priority setting between EEC inputs is controlled via EEC
>> >> >> registers? If so, this is an implementation detail of a
>> >> >> specific design. It is not of any importance to user space.
>> >> >
>> >> > They belong to different devices. EEC registers are physically
>> >> > in the DPLL hanging over I2C and recovered clocks are in the
>> >> > PHY/integrated PHY in the MAC. Depending on system architecture
>> >> > you may have control over one piece only
>> >>
>> >> What does ETHTOOL_MSG_RCLK_SET actually configure, physically? Say
>> >> I have this message:
>> >>
>> >> ETHTOOL_MSG_RCLK_SET dev = eth0
>> >> - ETHTOOL_A_RCLK_OUT_PIN_IDX = n
>> >> - ETHTOOL_A_RCLK_PIN_FLAGS |= ETHTOOL_RCLK_PIN_FLAGS_ENA
>> >>
>> >> Eventually this lands in ops->set_rclk_out(dev, out_idx,
>> >> new_state). What does the MAC driver do next?
>> >
>> > It goes to the PTY layer, enables the clock recovery from a given
>> > physical lane, optionally configure the clock divider and pin
>> > output muxes. This will be HW-specific though, but the general
>> > concept will look like that.
>> 
>> The reason I am asking is that I suspect that by exposing this
>> functionality through netdev, you assume that the NIC driver will do
>> whatever EEC configuration necessary _anyway_. So why couldn't it just
>> instantiate the EEC object as well?
>
> Not necessarily. The EEC can be supported by totally different driver.
> I.e there are Renesas DPLL drivers available now in the ptp subsystem.
> The DPLL can be connected anywhere in the system.
>
>> >> >> > > 5. What is the problem with the following model?
>> >> >> > >
>> >> >> > > - The EEC is a separate object with following attributes:
>> >> >> > >   * State: Invalid / Freerun / Locked / etc
>> >> >> > >   * Sources: Netdev / external / etc
>> >> >> > >   * Potentially more
>> >> >> > >
>> >> >> > > - Notifications are emitted to user space when the state of
>> >> >> > >   the EEC changes. Drivers will either poll the state from
>> >> >> > >   the device or get interrupts
>> >> >> > >
>> >> >> > > - The mapping from netdev to EEC is queried via ethtool
>> >> >> >
>> >> >> > Yep - that will be part of the EEC (DPLL) subsystem
>> >> >>
>> >> >> This model avoids all the problems I pointed out in the current
>> >> >> proposal.
>> >> >
>> >> > That's the go-to model, but first we need control over the
>> >> > source as well :)
>> >>
>> >> Why is that? Can you illustrate a case that breaks with the above
>> >> model?
>> >
>> > If you have 32 port switch chip with 2 recovered clock outputs how
>> > will you tell the chip to get the 18th port to pin 0 and from port
>> > 20 to pin 1? That's the part those patches addresses. The further
>> > side of "which clock should the EEC use" belongs to the DPLL
>> > subsystem and I agree with that.
>> 
>> So the claim is that in some cases the owner of the EEC does not know
>> about the netdevices?
>> 
>> If that is the case, how do netdevices know about the EEC, like the
>> netdev-centric model assumes?
>> 
>> Anyway, to answer the question, something like the following would
>> happen:
>> 
>> - Ask EEC to enumerate all input pins it knows about
>> - Find the one that references swp18
>> - Ask EEC to forward that input pin to output pin 0
>> - Repeat for swp20 and output pin 1
>> 
>> The switch driver (or multi-port NIC driver) just instantiates all of
>> netdevices, the EEC object, and pin objects, and therefore can set up
>> arbitrary linking between the three.
>
> This will end up with a model in which pin X of the EEC will link to
>dozens ports - userspace tool would need to find out the relation
>between them and EECs somehow.

Indeed. If you have EEC connected to a bunch of ports, the EEC object is
related to a bunch of netdevices. The UAPI needs to have tools to dump
these objects so that it is possible to discover what is connected
where.

This configuration will also not change during the lifetime of the EEC
object, so tools can cache it.

> It's far more convenient if a given netdev knows where it is connected
> to and which pin can it drive.

Yeah, it is of course possible to add references from the netdevice to
the EEC object directly, so that the tool just needs to ask a netdevice
what EEC / RCLK source ID it maps to.

This has mostly nothing to do with the model itself.

> I.e. send the netdev swp20 ETHTOOL_MSG_RCLK_GET and get the pin
> indexes of the EEC and send the future message to find which EEC that
> is (or even return EEC index in RCLK_GET?).

Since the pin index on its own is useless, it would make sense to return
both pieces of information at the same time.

> Set the recovered clock on that pin with the ETHTOOL_MSG_RCLK_SET.

Nope.

> Then go to the given EEC and configure it to use the pin that was
> returned before as a frequency source and monitor the EEC state.

Yep.

EEC will invoke a callback to set up the tracking. If something special
needs to be done to "set the recovered clock on that pin", the handler
of that callback will do it.

> Additionally, the EEC device may be instantiated by a totally
> different driver, in which case the relation between its pins and
> netdevs may not even be known.

Like an EEC, some PHYs, but the MAC driver does not know about both
pieces? Who sets up the connection between the two? The box admin
through some cabling? SoC designer?

Also, what does the external EEC actually do with the signal from the
PHY? Tune to it and forward to the other PHYs in the complex?
