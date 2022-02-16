Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BD54B8C6D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiBPP3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:29:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiBPP3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:29:25 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABFD25FE72;
        Wed, 16 Feb 2022 07:29:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJAh8UzzmmO+RJtBHo0rHaPXWlhCaNCgHKZdxqfX8/AAq4RipLu1AWf73KTorfyK0foN1hiubqlotQKLIPpJ83hQl+CI2L3FC3X/ugLUwwxv0HGr+GdyS5SqzF9fQvWqGKIBjTkHoU5ZHBAF8C3Ve3BWVmzFJC0m+7HNDREgRNC50qMRsm4ev5bsX9hAdhc5tY4YM3XACKAPOf7aTeWXOh4jjaJX4ujL17B5Orp41MDdPF+ES2nc1D0mVfU2uC+xud24y6IS2wm7zjEtwg7jIXu69DgWDDxYHXingGkCXkMGX11GBrx7a0vhXQDSgqYaXtk/d7N/fo7ELVJ8UDST3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ew1arzHTuKB2Dk0aDjj9WdWXGJ7HDJOPRSZGhhw+UgM=;
 b=ff90YsbsIObJw/x1fTgCq9o4M5gCZ07z9yhCoVcY/qOjR+ZKsk+SXHmrokC+3UA+T2b5k+8BDhMVUo+n7vge97zkDh2Ilm8OLwBC5pnw4hthdYDU5hnzY6Kq4FpVxLHxSIT9pXjQx4Sv+6S/jaNj8kU0vUj2IL6rm0kVRIzNZafs7p7NZdijNmC5PWBOdp5BQvZryb4PjgSMAJAbka3j+UYlw4AIZH23/1s4526bkK8au+KIQA9XQpbsETYOfy16S06GGjORQp5Fws4S062aCccqpihQOK0m1uzRrxjmqGk20GPCN3b/niknxnRp3Xj9OVyTyuKyiBt4UHRtjBVAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=armlinux.org.uk smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ew1arzHTuKB2Dk0aDjj9WdWXGJ7HDJOPRSZGhhw+UgM=;
 b=KqMdGUOGGiLUwCuPsgAg8bWqkE4cz37WcPsCEPH8GjjOWK9upcCS9iV3EfOpGsxYdfmk8nUV2QxO0JMy83v6NVxJd1QKkYKjJr1ZMACl9Gy4eV3S8FWGS5nsLn4r2U9lY6+qmANIyA0+/YuRf+VrfOoSn3lOvIeW45Ej7uUNxq3nujLeDMEtbcD7AwkyAayTaxPN9lV4zXygfs3F2uMw/Q92JxgPwKuEPqFYRODW90Ti1yqRo1NaLNcvzswrGMFtt8q0qeTmG9b5Zu5m5/wKIwp6ByxxMAi+7LtmMc+gJkWhNHKzs2sbYlxVVBo+L8kifs9LGGczWCpp5xoA6PjGLA==
Received: from CO2PR18CA0052.namprd18.prod.outlook.com (2603:10b6:104:2::20)
 by MWHPR12MB1391.namprd12.prod.outlook.com (2603:10b6:300:10::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 15:29:10 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::83) by CO2PR18CA0052.outlook.office365.com
 (2603:10b6:104:2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Wed, 16 Feb 2022 15:29:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 15:29:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 15:29:08 +0000
Received: from [172.27.13.137] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 07:29:02 -0800
Message-ID: <d59ee33c-79f9-2622-cec2-987a35f4ec1e@nvidia.com>
Date:   Wed, 16 Feb 2022 17:28:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC net-next 0/9] net: bridge: vlan: Multiple Spanning Trees
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
References: <20220216132934.1775649-1-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220216132934.1775649-1-tobias@waldekranz.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10548c70-e403-4f72-19da-08d9f16113ac
X-MS-TrafficTypeDiagnostic: MWHPR12MB1391:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB13918E9972ADADA824CFB637DF359@MWHPR12MB1391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9YxcwBEtsZg3KdD30cWWUkoAVEuBtU1OSduAWGRdwaEI/l3NBDk3ktDvZDIkp9gr3ZtGL1JJiB0sGbUcEU85vhq0ngDNLcDWLCOW3xULs0HI+rWxVhhW/5ltHkrAYsxIDLCKPDezU9DnZd489zibQgbDwKg4hJEWuLm4IUZHXS3nobKyhLc5+4lxmnC0cvvepqu/L6WTj5+xqzL3YPLI7/fo4lnjbZbKDmRVzu35oJXPW4a78xH1J97HmCmUJ/amk7pPyEu/V1jjMVh3D1RXn4MihKnj8Hye00uO943CzKVifSudOpw87qSNSN6II+BD4jwgwzSccMlU46+aZJ1fBHcHKDolQRZqAWWjtUzBf/Ky6DQSwPKCBMEbbV/STJe9Mtu2cqpBz6FK885M1+9W2fMVK2N4lOsrhLjmU7OPG/1ZEx0r+BHqZEQ+nrNTaujKuFOm7eInXsLLch4rLwgN2YzMx6WpQBTpAm4k+ItxcRp7qcJVTzJTrLeHyxAm6LPZgSwXm6szMetyM3vYCL2GodH6NHoYgqKzy9NE02viylDl5X5bJ4+otfSex5jZTHuPI5MSepWwmcMScbhw8UT9b5VgFkygzp05/uzR9nyxm2zLh+AN1BPGs5QcKj8sAHNj6kORDisfjpLHcQq08X7L8iMOLbBWUdx7oHnIagM6DZExk6T/YLtu90cLf8tYZ0uRYgJbkZPzDboWtIQcqpSAL4htTxXzW6qLFf3ExGxe8rFrAW5yf2UESlzsjOsKi9sGhAQVYCgvWR8jR+IW+JjIm2zG08W42jaJfzKEATctRPoQSJRp0NKBI3+A6azZZ6SBE7sLHqk96w2I9644UYJLjw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(70586007)(508600001)(86362001)(70206006)(36860700001)(110136005)(54906003)(53546011)(40460700003)(82310400004)(16576012)(316002)(31696002)(6666004)(47076005)(16526019)(2616005)(26005)(336012)(186003)(36756003)(426003)(31686004)(83380400001)(966005)(8936002)(7416002)(81166007)(5660300002)(356005)(2906002)(8676002)(4326008)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 15:29:09.2709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10548c70-e403-4f72-19da-08d9f16113ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1391
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 15:29, Tobias Waldekranz wrote:
> The bridge has had per-VLAN STP support for a while now, since:
> 
> https://lore.kernel.org/netdev/20200124114022.10883-1-nikolay@cumulusnetworks.com/
> 
> The current implementation has some problems:
> 
> - The mapping from VLAN to STP state is fixed as 1:1, i.e. each VLAN
>   is managed independently. This is awkward from an MSTP (802.1Q-2018,
>   Clause 13.5) point of view, where the model is that multiple VLANs
>   are grouped into MST instances.
> 
>   Because of the way that the standard is written, presumably, this is
>   also reflected in hardware implementations. It is not uncommon for a
>   switch to support the full 4k range of VIDs, but that the pool of
>   MST instances is much smaller. Some examples:
> 
>   Marvell LinkStreet (mv88e6xxx): 4k VLANs, but only 64 MSTIs
>   Marvell Prestera: 4k VLANs, but only 128 MSTIs
>   Microchip SparX-5i: 4k VLANs, but only 128 MSTIs
> 
> - By default, the feature is enabled, and there is no way to disable
>   it. This makes it hard to add offloading in a backwards compatible
>   way, since any underlying switchdevs have no way to refuse the
>   function if the hardware does not support it
> 
> - The port-global STP state has precedence over per-VLAN states. In
>   MSTP, as far as I understand it, all VLANs will use the common
>   spanning tree (CST) by default - through traffic engineering you can
>   then optimize your network to group subsets of VLANs to use
>   different trees (MSTI). To my understanding, the way this is
>   typically managed in silicon is roughly:
> 
>   Incoming packet:
>   .----.----.--------------.----.-------------
>   | DA | SA | 802.1Q VID=X | ET | Payload ...
>   '----'----'--------------'----'-------------
>                         |
>                         '->|\     .----------------------------.
>                            | +--> | VID | Members | ... | MSTI |
>                    PVID -->|/     |-----|---------|-----|------|
>                                   |   1 | 0001001 | ... |    0 |
>                                   |   2 | 0001010 | ... |   10 |
>                                   |   3 | 0001100 | ... |   10 |
>                                   '----------------------------'
>                                                              |
>                                .-----------------------------'
>                                |  .------------------------.
>                                '->| MSTI | Fwding | Lrning |
>                                   |------|--------|--------|
>                                   |    0 | 111110 | 111110 |
>                                   |   10 | 110111 | 110111 |
>                                   '------------------------'
> 
>   What this is trying to show is that the STP state (whether MSTP is
>   used, or ye olde STP) is always accessed via the VLAN table. If STP
>   is running, all MSTI pointers in that table will reference the same
>   index in the STP stable - if MSTP is running, some VLANs may point
>   to other trees (like in this example).
> 
>   The fact that in the Linux bridge, the global state (think: index 0
>   in most hardware implementations) is supposed to override the
>   per-VLAN state, is very awkward to offload. In effect, this means
>   that when the global state changes to blocking, drivers will have to
>   iterate over all MSTIs in use, and alter them all to match. This
>   also means that you have to cache whether the hardware state is
>   currently tracking the global state or the per-VLAN state. In the
>   first case, you also have to cache the per-VLAN state so that you
>   can restore it if the global state transitions back to forwarding.
> 
> This series adds support for an arbitrary M:N mapping of VIDs to
> MSTIs, proposing one solution to the first issue. An example of an
> offload implementation for mv88e6xxx is also provided. Offloading is
> done on a best-effort basis, i.e. notifications of the relevant events
> are generated, but there is no way for the user to see whether the
> per-VLAN state has been offloaded or not. There is also no handling of
> the relationship between the port-global state the the per-VLAN ditto.
> 
> If I was king of net/bridge/*, I would make the following additional
> changes:
> 
> - By default, when a VLAN is created, assign it to MSTID 0, which
>   would mean that no per-VLAN state is used and that packets belonging
>   to this VLAN should be filtered according to the port-global state.
> 
>   This way, when a VLAN is configured to use a separate tree (setting
>   a non-zero MSTID), an underlying switchdev could oppose it if it is
>   not supported.
> 
>   Obviously, this adds an extra step for existing users of per-VLAN
>   STP states and would thus not be backwards compatible. Maybe this
>   means that that is impossible to do, maybe not.
> 
> - Swap the precedence of the port-global and the per-VLAN state,
>   i.e. the port-global state only applies to packets belonging to
>   VLANs that does not make use of a per-VLAN state (MSTID != 0).
> 
>   This would make the offloading much more natural, as you avoid all
>   of the caching stuff described above.
> 
>   Again, this changes the behavior of the kernel so it is not
>   backwards compatible. I suspect that this is less of an issue
>   though, since my guess is that very few people rely on the old
>   behavior.
> 
> Thoughts?
> 

Interesting! Would adding a new (e.g. vlan_mst_enable) option which changes the behaviour
as described help? It can require that there are no vlans present to change 
similar to the per-port vlan stats option. Also based on that option you can alter
how the state checks are performed. For example, you can skip the initial port state
check, then in br_vlan_allowed_ingress() you can use the port state if vlan filtering
is disabled and mst enabled and you can avoid checking it altogether if filter && mst
are enabled then always use the vlan mst state. Similar changes would have to happen
for the egress path. Since we are talking about multiple tests the new MST logic can
be hidden behind a static key for both br_handle_frame() and later stages.

This set needs to read a new cache line to fetch mst ptr for all packets in the vlan fast-path,
that is definitely undesirable. Please either cache that state in the vlan and update it when
something changes, or think of some way which avoids that cache line in fast-path.
Alternative would be to make that cache line dependent on the new option, so it's needed
only when mst feature is enabled.

There are other options, but they way more invasive.. I'll think about it more.

Cheers,
 Nik
