Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408EA469935
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245057AbhLFOoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:44:25 -0500
Received: from mail-dm6nam12on2087.outbound.protection.outlook.com ([40.107.243.87]:36530
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233437AbhLFOoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 09:44:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oddpxvy2BQqXQPNWe3tQTiLDIQZxC1R0un2jep1TEREVnytE8nxNIkLj0IGuuAMHZBX7vOLUZ7Vsp+5Q6O1ROJftBy9d1oYYf2b2sHuiECoiWq1dS+48bABFKUJHhUJz+Xw4enxZHfbR6dkWbCV10Yw2bHl/FhY7x21Wco7uVT5IQSI6Hq8cGNCrjFdKeBiJ7P5aS9g2E6iqBPZxvHEwiP6AY2pn/AY1yrRGJKnrJxHM2xJH0u5f3LGBO57/xrd7a8N4AeqF7Utmpk/nbHBGnFnpf+/Ioo2L+ZSrHcEtheOwhvYvSAMpbpXG61E00humtXeaeHJWFVR9tA5oANr5Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/p/rkaEB73iPU5AEkixjpdTwNbTFI06t3eLCQyvzpI=;
 b=Ok2WFJpMyLrfE3VlX17LPHdjHIsFouGLKNqJhpveEAuA2AgAIUXdReIg7ETVEY3oUukdWwlV7qrXVWIiqFHzgLoGEOuJzaLl3TZPe1C/bexHAbL0emQQRiatLlXtCKdBGq3CajiINzxiamPr5k0J9jMVdOSeCigCdQhrsEseq5KE9v8qRrQlyHQIx1+RMI3QOhSYxI5ePg+1/e8AGnr3PfRkL8D0RUBhfCHgIxOWLjrHNNhHGS2sSUqqF2RnRxp9I+gzrLNpLYQEyjafJwKMDsl0i3RjLX+hdHSpdKU/Qe4CQWZIT87YL1n/fCQ2ZyApxE0QmCpzqKfYhlMhcJEx/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/p/rkaEB73iPU5AEkixjpdTwNbTFI06t3eLCQyvzpI=;
 b=Sdlr6dFXyhMj4URFiC8CpGsVdgAnwC2VjMnHcTgR0qqadFgo4cWltDVw1aU6FQ32htbGQEx0eW4qLM3Sps7+SuX7WcDAEGw5DQzgBbKpeG2ALToPN73euQtYlD5IPn4i0oFAOssTrk351VF3/Jgr6I2AK5N9pmgalfzlg37P29r29JTddCmIton9VFGE+VEe9lCv8xRWfmd4TsulHmMtNh8FQ7/50R9JG30UcDmKsrMPacZub3yvcgws3AjJqJT9MMp7Fu3gKS7Qz1DOxdBrlCTUIMYvHYKPz7BC1G0wFx2OlakVKNSOQA5rQ1ZwgMFon9ZgQ0fxtgU6iwUQv6oySg==
Received: from MW4P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::13)
 by SJ0PR12MB5502.namprd12.prod.outlook.com (2603:10b6:a03:300::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 14:40:53 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::b6) by MW4P222CA0008.outlook.office365.com
 (2603:10b6:303:114::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend
 Transport; Mon, 6 Dec 2021 14:40:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Mon, 6 Dec 2021 14:40:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Dec
 2021 14:40:51 +0000
Received: from yaviefel (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 6 Dec 2021
 06:40:46 -0800
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
 <87fsr9o7di.fsf@nvidia.com>
 <MW5PR11MB5812AA2C625AC00616F94A2AEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
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
In-Reply-To: <MW5PR11MB5812AA2C625AC00616F94A2AEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
Date:   Mon, 6 Dec 2021 15:40:43 +0100
Message-ID: <87czm9okyc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5721ebb9-c67f-4b61-ca74-08d9b8c667a2
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5502:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5502210962659B77B15C57E5D66D9@SJ0PR12MB5502.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3pnKEDJGqRB/+7LhzdSYK5/pbUA1MhBP4K8jxFdTMK5HLJR9/dGHnkE+wM7ZYHBNWYhoHfHUcSJAuLEYkDPOsKGk58Ce7aOs0ONAWl2AIMaLSbZxLl7YzgISi1Uudo9B2208i27cXIusyMnUnnSQv7GTDsz3He5QaEG0zpUR4hrtAWt7uui5730coKEJLLgq0V2r1oSZYGmkMhNtdIIZw7NODMZkxYkFarKYoF0erzFazDP7oKbRIM+4oX/QI27NyClPUQACufI0eLqU4Pn+eZY1ghUzqhA/LOVjOfgA/pZNlB4q/wxhnQqa4fhJC3fyhnXO3qwL+N3Dfb9SPzNqxj95lDatPUJ4qR6YPk80CsUQrwH1nAR9PMdTcUyRxJfSSY/yKJVF4Rp5O4bR2EZHn8U+RoFr8qwbwIh3Wp8o3un6PxCPn12yKcpbZkS5oeROMtA5JJqIjw2FW0xHBRtbvGktTnqvjvDvQ2n1HZ2vGZyqMnLAeh1ngy2Ex9kR0xJDg/jpTDxV0nrqY5DM5pwGfC3IG/rkB39XvgY+HYzr5LPQ/VT/HOyMOSGbowyHDroUWljSB97HIioYEMtQz4KaRCWtEzuyT+2W4nGRpv8187ZlraJX1aGckV5cHt5ApAgiv3Ca0SoUP8wGrDfD6M8L8KMPcvy+rHZ/cmkesRHcCrmO2qsDZDsJ+nfP+u1eTpfAXPx903Kez8FiaBAgyoz2WvHzj62qgNu4hdtIifFH2XkuLP9SqKoMKRaIeTyinB17pAAIDm4hgfpd0ENfnYIjfQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(86362001)(47076005)(70586007)(6916009)(26005)(70206006)(508600001)(186003)(8676002)(16526019)(36756003)(2616005)(6666004)(426003)(5660300002)(336012)(4326008)(36860700001)(2906002)(316002)(8936002)(54906003)(356005)(7636003)(83380400001)(40460700001)(82310400004)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 14:40:53.0455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5721ebb9-c67f-4b61-ca74-08d9b8c667a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:

>> -----Original Message-----
>> From: Petr Machata <petrm@nvidia.com>
>> 
>> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>> 
>> > Additionally, the EEC device may be instantiated by a totally
>> > different driver, in which case the relation between its pins and
>> > netdevs may not even be known.
>> 
>> Like an EEC, some PHYs, but the MAC driver does not know about both
>> pieces? Who sets up the connection between the two? The box admin
>> through some cabling? SoC designer?
>> 
>> Also, what does the external EEC actually do with the signal from the
>> PHY? Tune to it and forward to the other PHYs in the complex?
>
> Yes - it can also apply HW filters to it.

Sounds like this device should have an EEC instance of its own then.

Maybe we need to call it something else than "EEC". PLL? Something that
does not have the standardization connotations, because several
instances would be present in a system with several NICs.

> The EEC model will not work when you have the following system:
> SoC with some ethernet ports with driver A
> Switch chip with N ports with driver B
> EEC/DPLL with driver C
> Both SoC and Switch ASIC can recover clock and use the cleaned
> clock from the DPLL.
>
> In that case you can't create any relation between EEC and recover
> clock pins that would enable the EEC subsystem to control
> recovered clocks, because you have 3 independent drivers.

I think that in that case you have several EEC instances. Those are
connected by some wiring that is external to the devices themselves. I
am not sure who should be in charge of describing the wiring. Device
tree? Config file?

> The model you proposed assumes that the MAC/Switch is in
> charge of the DPLL, but that's not always true.

The EEC-centric model does not in fact assume that. It lets anyone to
set up an EEC object.

The netdev-centric UAPI assumes that the driver behind the netdev knows
about how many RCLK out pins there are. So it can certainly instantiate
a DPLL object instead, with those pins as external pins, and leave the
connection of the external pins to the EEC proper implicit.

That gives userspace exactly the same information as the netdev-centric
UAPI, but now userspace doesn't need to know about netdevs, and
synchronously-spinning drives, and GPS receivers, each of which is
handled through a dedicated set of netlink messages / sysctls / what
have you. The userspace needs to know about EEC subsystem, and that's
it.

> The model where recovered clock outputs are controlled independently
> can support both models and is more flexible. It can also address the

- Anyone can instantiate EEC objects
- Only things with ports instantiate netdevs

How is the latter one more flexible?

> mode where you want to use the recovered clock as a source for RF part
> of your system and don't have any EEC to control from the netdev side.
