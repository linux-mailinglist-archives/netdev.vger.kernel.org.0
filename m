Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489164B8D8E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiBPQNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:13:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiBPQNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:13:13 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BBCAE1B7;
        Wed, 16 Feb 2022 08:13:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5V1uiX9H6JR9SXw6BeA8nic7dcNHAn7vNA/HBGeFWWXnFLTqLL1euI+/5JTzPD7X4qsFbfLsyRNK2n7yVmmVoPp5frccwUgGoG8CuTVdTOznSbGDZwdbO6p0gM8yyyq57Ip9NGCKOB6t/kEUBbtOCtdLdlueIgCBc5w1u3SAOgX00iapz88F7K0on/VHN47vbpG9yEpfjKWHqYy42DnJGlxJiLdqA+qgHCRqruv3wq+ktTXYI58+WfBc1sqnnJ0hr6ET91AhYQ312yAA47jubtP8su0xSKJfo06cOvyphAsgaEqd0WmvAVreT6GueYgjAP+biLFRsuIR8RGtA1joQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfQ6deoec55/yPMz6fyZTxoHsSd9jTI+1vrHdvoofZw=;
 b=dAbSHvMk16ms0Bp8UDEzJyvqqd9WJ7hv+cYTxkdVzILTryo6AFvJ7yZwEW11OaABJFPZPf0k4nVHzkZOCNsXj38bMvznF/nzP5/uYRfk6Y/Pif+uFbJfVxVdSaI4WRrQkqUCGBLBLNjyA8jcRVyweb33s0wP0zVuU9LGkAnV7JRGzf4qImY0Cy6eZbsufqbJqaEftcUJt3l1wO7t4ATz4kVhBrk5ffko4/9SrTlE/biNLBh/g0FgSOHkzNUAo0mTO0iM/gYzDWo4E0R69Gax4VzGK7f4pYAXiy8e85jU5lhPl2VzTAlijO/FrCdci0HRlPSFA8O/FpMTjrLJMe2A5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=armlinux.org.uk smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfQ6deoec55/yPMz6fyZTxoHsSd9jTI+1vrHdvoofZw=;
 b=r8blttlwQLjtfdRVaPtQmfulvC8cxX1L0WmbbMKSuAlgaHNixiySd2ijvpKpNlmEXqr/L5Wvx8nKw4Pa8PUujTKnsnkDaaDxS6aPwl/fIM8DOdEmDKpv7Xev0SMKWDccnek7mqtDff+r8bFg7LdoszQPCt4935+4INEMsD5Wl/oXAYVgzuYOcavJKjfIlX/W7J6VcIrC+0nAVjF42M4MxxPMJueh335UznIzlR3uKbky0CjoI6Bj9llE3Em9HwTRGL47iFYHltMx11/3aNLUPt5pxL34pg6tvs4AnABMzZhhwIMh2ume5JpD9n39zrn5oDswtHls5RWudrAKQ7WTig==
Received: from DM5PR07CA0033.namprd07.prod.outlook.com (2603:10b6:3:16::19) by
 CH2PR12MB4055.namprd12.prod.outlook.com (2603:10b6:610:78::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Wed, 16 Feb 2022 16:12:58 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::9b) by DM5PR07CA0033.outlook.office365.com
 (2603:10b6:3:16::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Wed, 16 Feb 2022 16:12:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 16:12:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 16:12:50 +0000
Received: from [172.27.13.137] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 08:12:44 -0800
Message-ID: <ae47059c-400c-3141-d3b1-42804b2468b5@nvidia.com>
Date:   Wed, 16 Feb 2022 18:12:40 +0200
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
 <d59ee33c-79f9-2622-cec2-987a35f4ec1e@nvidia.com>
 <87mtiqajqj.fsf@waldekranz.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <87mtiqajqj.fsf@waldekranz.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b4e4c2d-7ca6-4892-490d-08d9f1673241
X-MS-TrafficTypeDiagnostic: CH2PR12MB4055:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4055B4AD65069FC1FE6D1042DF359@CH2PR12MB4055.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DqoOMbNG/qq9ZhdCFgcLj7DoFjnWVGYw8VUsha4au08f4dIoST/DVxp9SSCBIgigcaPtMkKzhy61E8UmuxCy+3TuV7EnJZXmYcOzpVHYF8J/CLLnIzaMNuaScY2OqkF0aHY0pjruA1/qjT+a3BsAUlMrd7m3JAzv98WjRw8YsL/3ydM+a3dhyTSwhXRIuEMtSpLonUb4XpaYwTZPNRU44Ww93ywM0Wf/Qu3p8WWsmBWiHWBygKUKBJQyr66d2VaT4Vf59IWCNf3aHh53Tfh6XGFHloU7STN3yfpQ1E/Me+9wYUegNEAQPBlgyxJKd4+rjq3CYOJYqxcVVBFAkHv/yEYYYtYKlinavds2GphUHYjusEToJeNSMhb24FU5cfwKIvWINIrEtYY91aPEU/xptljKsoQDZGoPSOT3jkwRq7NvOo48iMV5cyEri7PZqpBb0D3PAXL4k0YM2nV6ebPkOfVt/rrbl8KjQPU+EgBB6bzLTcvpFyFjP1W7clPNYi2OMyKtMTHpo4Ou8B/3HuVEuoc5wCJaqF1k/mp9x7RwbO/ikGGfm94HGRQedET8BGtu/lJzmFq+u0WQ+ex+r8bzYFoWMpQSjKeS92TKX/ZNj4CvIGmEJspCOwrD59ZSf9ffUsK9Q5rCCutqwrZxBh6qE0RMLB6re3NLSjQuOxXbrtJ7SELpEIP5zwzkWPFmOLqzi0RcLy1/u+idcj8VtS1QQvhaPNcvOnKQhNrtcK31tC62yjYPFHD/+C9phPaQukT0gHWViOm/c13HXS0NxjGxVmVfIWuECR3Z5aqfgbiovkb3msKn36fNKmmZW1mr0KYw+XVde+8vlHZNBe5jHy6usg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(316002)(16576012)(110136005)(81166007)(31686004)(26005)(83380400001)(2906002)(31696002)(36860700001)(36756003)(336012)(966005)(426003)(508600001)(7416002)(53546011)(86362001)(8676002)(4326008)(5660300002)(2616005)(70586007)(70206006)(82310400004)(40460700003)(6666004)(356005)(8936002)(47076005)(16526019)(186003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 16:12:57.5450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4e4c2d-7ca6-4892-490d-08d9f1673241
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4055
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

On 16/02/2022 17:56, Tobias Waldekranz wrote:
> On Wed, Feb 16, 2022 at 17:28, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
>> On 16/02/2022 15:29, Tobias Waldekranz wrote:
>>> The bridge has had per-VLAN STP support for a while now, since:
>>>
>>> https://lore.kernel.org/netdev/20200124114022.10883-1-nikolay@cumulusnetworks.com/
>>>
>>> The current implementation has some problems:
>>>
>>> - The mapping from VLAN to STP state is fixed as 1:1, i.e. each VLAN
>>>   is managed independently. This is awkward from an MSTP (802.1Q-2018,
>>>   Clause 13.5) point of view, where the model is that multiple VLANs
>>>   are grouped into MST instances.
>>>
>>>   Because of the way that the standard is written, presumably, this is
>>>   also reflected in hardware implementations. It is not uncommon for a
>>>   switch to support the full 4k range of VIDs, but that the pool of
>>>   MST instances is much smaller. Some examples:
>>>
>>>   Marvell LinkStreet (mv88e6xxx): 4k VLANs, but only 64 MSTIs
>>>   Marvell Prestera: 4k VLANs, but only 128 MSTIs
>>>   Microchip SparX-5i: 4k VLANs, but only 128 MSTIs
>>>
>>> - By default, the feature is enabled, and there is no way to disable
>>>   it. This makes it hard to add offloading in a backwards compatible
>>>   way, since any underlying switchdevs have no way to refuse the
>>>   function if the hardware does not support it
>>>
>>> - The port-global STP state has precedence over per-VLAN states. In
>>>   MSTP, as far as I understand it, all VLANs will use the common
>>>   spanning tree (CST) by default - through traffic engineering you can
>>>   then optimize your network to group subsets of VLANs to use
>>>   different trees (MSTI). To my understanding, the way this is
>>>   typically managed in silicon is roughly:
>>>
>>>   Incoming packet:
>>>   .----.----.--------------.----.-------------
>>>   | DA | SA | 802.1Q VID=X | ET | Payload ...
>>>   '----'----'--------------'----'-------------
>>>                         |
>>>                         '->|\     .----------------------------.
>>>                            | +--> | VID | Members | ... | MSTI |
>>>                    PVID -->|/     |-----|---------|-----|------|
>>>                                   |   1 | 0001001 | ... |    0 |
>>>                                   |   2 | 0001010 | ... |   10 |
>>>                                   |   3 | 0001100 | ... |   10 |
>>>                                   '----------------------------'
>>>                                                              |
>>>                                .-----------------------------'
>>>                                |  .------------------------.
>>>                                '->| MSTI | Fwding | Lrning |
>>>                                   |------|--------|--------|
>>>                                   |    0 | 111110 | 111110 |
>>>                                   |   10 | 110111 | 110111 |
>>>                                   '------------------------'
>>>
>>>   What this is trying to show is that the STP state (whether MSTP is
>>>   used, or ye olde STP) is always accessed via the VLAN table. If STP
>>>   is running, all MSTI pointers in that table will reference the same
>>>   index in the STP stable - if MSTP is running, some VLANs may point
>>>   to other trees (like in this example).
>>>
>>>   The fact that in the Linux bridge, the global state (think: index 0
>>>   in most hardware implementations) is supposed to override the
>>>   per-VLAN state, is very awkward to offload. In effect, this means
>>>   that when the global state changes to blocking, drivers will have to
>>>   iterate over all MSTIs in use, and alter them all to match. This
>>>   also means that you have to cache whether the hardware state is
>>>   currently tracking the global state or the per-VLAN state. In the
>>>   first case, you also have to cache the per-VLAN state so that you
>>>   can restore it if the global state transitions back to forwarding.
>>>
>>> This series adds support for an arbitrary M:N mapping of VIDs to
>>> MSTIs, proposing one solution to the first issue. An example of an
>>> offload implementation for mv88e6xxx is also provided. Offloading is
>>> done on a best-effort basis, i.e. notifications of the relevant events
>>> are generated, but there is no way for the user to see whether the
>>> per-VLAN state has been offloaded or not. There is also no handling of
>>> the relationship between the port-global state the the per-VLAN ditto.
>>>
>>> If I was king of net/bridge/*, I would make the following additional
>>> changes:
>>>
>>> - By default, when a VLAN is created, assign it to MSTID 0, which
>>>   would mean that no per-VLAN state is used and that packets belonging
>>>   to this VLAN should be filtered according to the port-global state.
>>>
>>>   This way, when a VLAN is configured to use a separate tree (setting
>>>   a non-zero MSTID), an underlying switchdev could oppose it if it is
>>>   not supported.
>>>
>>>   Obviously, this adds an extra step for existing users of per-VLAN
>>>   STP states and would thus not be backwards compatible. Maybe this
>>>   means that that is impossible to do, maybe not.
>>>
>>> - Swap the precedence of the port-global and the per-VLAN state,
>>>   i.e. the port-global state only applies to packets belonging to
>>>   VLANs that does not make use of a per-VLAN state (MSTID != 0).
>>>
>>>   This would make the offloading much more natural, as you avoid all
>>>   of the caching stuff described above.
>>>
>>>   Again, this changes the behavior of the kernel so it is not
>>>   backwards compatible. I suspect that this is less of an issue
>>>   though, since my guess is that very few people rely on the old
>>>   behavior.
>>>
>>> Thoughts?
>>>
>>
>> Interesting! Would adding a new (e.g. vlan_mst_enable) option which changes the behaviour
>> as described help? It can require that there are no vlans present to change 
>> similar to the per-port vlan stats option.
> 
> Great idea, I did not know that that's how vlan stats worked. I will
> definitely look into it, thanks!
> 
>> Also based on that option you can alter
>> how the state checks are performed. For example, you can skip the initial port state
>> check, then in br_vlan_allowed_ingress() you can use the port state if vlan filtering
>> is disabled and mst enabled and you can avoid checking it altogether if filter && mst
>> are enabled then always use the vlan mst state. Similar changes would have to happen
>> for the egress path. Since we are talking about multiple tests the new MST logic can
>> be hidden behind a static key for both br_handle_frame() and later stages.
> 
> Makes sense.
> 
> So should we keep the current per-VLAN state as-is then?  And bolt the
> MST on to the side? I.e. should `struct net_bridge_vlan` both have `u8
> state` for the current implementation _and_ a `struct br_vlan_mst *`
> that is populated for VLANs tied to a non-zero MSTI?
> 

Good question. The u8 we should keep for the quick access/cache of state, the
ptr we might escape by keeping just the mst id and fetching it, i.e. it could
be just 2 bytes instead of 8, but that's not really a problem if it will be
used just for bookkeeping in slow paths. It can always be pushed in the end of
the struct and if a ptr makes things simpler and easier it's ok.
So in short yes, I think we can keep both.

>> This set needs to read a new cache line to fetch mst ptr for all packets in the vlan fast-path,
>> that is definitely undesirable. Please either cache that state in the vlan and update it when
>> something changes, or think of some way which avoids that cache line in fast-path.
>> Alternative would be to make that cache line dependent on the new option, so it's needed
>> only when mst feature is enabled.
> 
> If we go with the approach I suggested above, then the current `u8
> state` on `struct net_bridge_vlan` could be that cache, right?
> 

Yep, that's the idea.

> With the current implementation, it is set directly - in the new MST
> mode all grouped VLANs would have their states updated when updating the
> MSTI's state.

Right

Cheers,
 Nik
