Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD66C599BB9
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348642AbiHSMLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348495AbiHSMLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:11:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9039100F22
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:11:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsuB+9LZeh9aU9sxlaSxqjTzwp6z8Dx3rNRm0z5O/RIp5kb1G62X+yFOim3wr+Ar72WdwQw44jHa22OpFA4hp/r1wram2Ivfd8PqELz8/WROnF8QSir8wJoZXlZHRdWehwyNBU0mHwqKd8e7Mdcn6TVkItrzmf8jTEnUdQeK9LSxPCr8gSzlgALXyMWn/IBx8GVU3zQq+zEdwkm0rCicSU3k78/dzEBhQYFYf/9u0i48nKyMWfIf9hN5AgHn4CMKpnf4yeaP3r1/9wSgCiRZGnNox25pmf8YEYs3jgL5laXCTMZtj/t08earsdPuZHt75tZXRzypcHKmfP5/DlPG9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYl9aqJYrpSPbvWuN9I41SKAo+GelJkzSWhAcoEgHjE=;
 b=JnUf7Tgegu5wDxU3oLlnnYWRW8FmharA03NMWxDgJFwRwQ3Z2k9HPg9gXUy3bxmmf5RP4qDBuYHHmnWLH9ZwOkZXIklU6tAXY232b3xPzuYpJHjBk6S9BA2SUHtTHjTei7gMuJHLOs89bTd7lezgb4kh0ANVs3/IGC9p2kOv+HjSbogE7PDt9/yZltBtyGh/63AceeRQVWcBmlaotU7vc5judc61NWufx+E8l4QTm7QcxWBybNMSw087P6ffQIRbp8nJF5pSiALRQcWTdcXjGIfiKBWVl8irVqpgB8TMjeNucJkZTLupBVgMXH57ZNs8tP4TMbTtfc3akFE4T604wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYl9aqJYrpSPbvWuN9I41SKAo+GelJkzSWhAcoEgHjE=;
 b=K8O2kDNRyVHVWct/t7JCsjONDPZBbUDIA7PzjV8gFu402AJ7SZtxw9oytmEmVMynSarWElxXbwlqQxR3XOUEfGThGjjaFzLhw2HtMCJ7kOoBBvp6MrJ5ss6wvUGaApWOVVlzz/GLeQetYID/9N1Ixl599fF2hzQXX7jBqgs1pK9UewwRv8qiAjaxJ4QLJJF91SShbZHBqqVfvm1mIt9DzORAhMnbI/jzD344+BQcc6KS6yS1/6Xr/shtxRuIiMh9zbnXBMyWIjtEWjG/XDd9F7JRMY6F4jYSxNHtIx9aY0byk/fJ0P8WfEsvB7g6ZGhLs/WVYggrRPat6nM99R2yzA==
Received: from MW4PR03CA0124.namprd03.prod.outlook.com (2603:10b6:303:8c::9)
 by CH0PR12MB5284.namprd12.prod.outlook.com (2603:10b6:610:d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 12:11:30 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::5f) by MW4PR03CA0124.outlook.office365.com
 (2603:10b6:303:8c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.12 via Frontend
 Transport; Fri, 19 Aug 2022 12:11:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Fri, 19 Aug 2022 12:11:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 19 Aug
 2022 12:11:29 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 19 Aug
 2022 05:11:25 -0700
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Date:   Fri, 19 Aug 2022 12:50:46 +0200
In-Reply-To: <Yv9VO1DYAxNduw6A@DEN-LT-70577>
Message-ID: <874jy8mo0n.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c62fda66-1c25-4abb-d0c8-08da81dbf312
X-MS-TrafficTypeDiagnostic: CH0PR12MB5284:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJ8HWkLFtQcapOzcv19t/bPGfv/ndDF8Yc3j+mLZz2uOqB8zsjbUTZqxfSX/ShudQpffsBs5Ve+MS0dD03X3ow2spv1g01CfSPDKNuM/AUw1MPzLwZONtLxIUtp6xxqkQ+bpiOLPV7CHhBgnU4AK5so2FzzZ967civaFWeB0WwEkoL/SXIApZzoOX7hD63R9kDGrbuXHvewvxrDCFuDFcrdYGASftCvbGtJOOapvk+E08I8BL68+9LI5G+8gml+fkm/amD4on/L43jyPVljCDPdLyrvjM3Ock8tSBHUKb5FrXqhPUmwR57kavWAz6USY2RBQxGXIdFH9hPLN507PPKXfngteJs2379+ocZohUJsV+Wd6wUmSejJ0eu08fbPvklrB9+G3DswMLG89JyluK6kJWaK95NymBvu1S9KKjAv7m1GTczZ/NHhCG/NtttMO5Mh8kGqXNPfG3BXSV760tQk8CAyHgBOQLN0gIkgQuF+AYNkpXe7gdzJGTNiNAyLbTGAIzMKbw1r2BBA1mrNaSpsFeVosLx2tdKtcDjhl2nJRc21U9UkVdAQIoys+JyCtFXDt8/YVwDbpTbBRwbK7meC1Q4JP225kuQN4vtNsMZfjar7ZNibFkJZKBGb0XaibL/Ueg735kNbBzRWBgAeg8h90r7HI8h3BK9A9jdqBGO7WE+ollGO7PwrcP7GBYPDt72byVblV4m+RnTd0QjmEr45fUHXOB23tCX4SPxSAodYoffAEvisGOr+/bZ0k1dBj6iuchDeJ8Hee2JDRfRGkRXH2Bc1YcqLe8G1MFQTIZNYXbTWWlolSOcpMN1zalRA1TUMotSaJpVdfUDs2+9IsocqJVhY64x9Q9lv7HT3TZhp3rDkZ+Eda3ie3PBPc+8ew
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(346002)(396003)(40470700004)(46966006)(36840700001)(86362001)(36756003)(36860700001)(82740400003)(6666004)(83380400001)(107886003)(426003)(47076005)(81166007)(356005)(186003)(26005)(2616005)(336012)(16526019)(478600001)(966005)(41300700001)(316002)(54906003)(40480700001)(6916009)(4326008)(70586007)(2906002)(70206006)(5660300002)(8936002)(40460700003)(82310400005)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 12:11:30.1326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c62fda66-1c25-4abb-d0c8-08da81dbf312
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5284
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

> Hi netdev,
>
> I am posting this thread in continuation of:
>
> https://lore.kernel.org/netdev/20220415173718.494f5fdb@fedora/
>
> and as a new starting point for further discussion of offloading PCP-based
> queue classification into the classification tables of a switch.
>
> Today, we use a proprietary tool to configure the internal switch tables for
> PCP/DEI and DSCP based queue classification [1]. We are, however, looking for
> an upstream solution.
>
> More specifically we want an upstream solution which allows projects like DENT
> and others with similar purpose to implement the ieee802-dot1q-bridge.yang [2].
> As a first step we would like to focus on the priority maps of the "Priority
> Code Point Decoding Table" and "Priority Code Point Enconding table" of the
> 802.1Q-2018 standard. These tables are well defined and maps well to the
> hardware.
>
> The purpose is not to create a new kernel interface which looks like what IEEE
> defines - but rather to do the needed plumbing to allow user-space tools to
> implement an interface like this.
>
> In essence we need an upstream solution that initially supports:
>
>  - Per-port mapping of PCP/DEI to QoS class. For both ingress and egress.
>
>  - Per-port default priority for frames which are not VLAN tagged.

This exists in DCB APP. Rules with selector 1 (EtherType) and PID 0
assign a default priority. iproute2's dcb tool supports this.

>  - Per-port configuration of "trust" to signal if the VLAN-prio shall be used,
>    or if port default priority shall be used.

This would be nice. Currently mlxsw ports are in trust PCP mode until
the user configures any DSCP rules. Then it switches to trust DSCP.
There's no way to express "trust both", or to configure the particular
PCP mapping for trust PCP (it's just hardcoded as 1:1).

Re this "VLAN or default", note it's not (always) either-or. In Spectrum
switches, the default priority is always applicable. E.g. for a port in
trust PCP mode, if a packet has no 802.1q header, it gets port-default
priority. 802.1q describes the default priority as "for use when
application priority is not otherwise specified", so I think this
behavior actually matches the standard.

> In the old thread, Maxime has compiled a list of ways we can possibly offload
> the queue classification. However none of them is a good match for our purpose,
> for the following reasons:
>
>  - tc-flower / tc-skbedit: The filter and action scheme maps poorly to hardware
>    and would require one hardware-table entry per rule. Even less of a match
>    when DEI is also considered. These tools are well suited for advanced
>    classification, and not so much for basic per-port classification.

Yeah.

Offloading this is a pain. You need to parse out the particular shape of
rules (which is not a big deal honestly), and make sure the ordering of
the rules is correct and matches what the HW is doing. And tolerate any
ACL-/TCAM- like rules as well. And there's mismatch between how a
missing rule behaves in SW (fall-through) and HW (likely priority 0 gets
assigned).

And configuration is pain as well, because a) it's a whole bunch of
rules to configure, and b) you need to be aware of all the limitations
from the previous paragraph and manage the coexistence with ACL/TCAM
rules.

It's just not a great story for this functionality.

I wonder if a specialized filter or action would make things easier to
work with. Something like "matchall action dcb dscp foo bar priority 7".

>  - ip-link: The ingress and egress maps of ip-link is per-linux-vlan interface;
>    we need per-port mapping. Not possible to map both PCP and DEI.
>
>  - dcb-app: Not possible to map PCP/DEI (only DSCP).
>
> We have been looking around the kernel to snoop what other switch driver
> developers do, to configure basic per-port PCP/DEI based queue classification,
> and have not been able to find anything useful, in the standard kernel
> interfaces.  It seems like people use their own out-of-tree tools to configure
> this (like mlnx_qos from Mellanox [3]).
>
> Finally, we would appreciate any input to this, as we are looking for an
> upstream solution that can be accepted by the community. Hopefully we can
> arrive at some consensus on whether this is a feature that can be of general
> use by developers, and furthermore, in which part of the kernel it should
> reside:
>
>  - ethtool: add new setting to configure the pcp tables (seems like a good
>    candidate to us).
>
>  - ip-link: add support for per-port-interface ingress and egress mapping of
>    pcp/dei
>
>  - dcb-*: as an extension or new command to the dcb utilities. The pcp tables
>    seems to be in line with what dcb-app does with the application priority
>    table.

I'm not a fan of DCB, but the TC story is so unconvincing that this
looks good in comparison.

But note that DCB as such is standardized. I think the dcb-maxrate
interfaces are not, and the DCB subsystem has a whole bunch of weird
pre-standard stuff that's not exposed. But what's in iproute2 dcb is
largely standard. So maybe this should be hidden under some extension
attribute.

>  - somewhere else
>
> In summary:
>
>  - We would like feedback from the community on the suggested implemenation of
>    the ieee-802.1Q Priority Code Point encoding an decoding tables.
>
>  - And if we can agree that such a solution could and should be implemented;
>    where should the implemenation go?
>
>  - Also, should the solution be supported in the sw-bridge as well.

That would be ideal, yeah.
