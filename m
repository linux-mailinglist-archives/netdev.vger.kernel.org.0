Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9795AF082
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiIFQfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiIFQfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:35:04 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2131.outbound.protection.outlook.com [40.107.96.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E064B83BE5;
        Tue,  6 Sep 2022 09:10:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXI+5jpZ8kFLXGlvT4JKHq51Yy0w3Y2Bb1WwE7JRb5I5L8bxRhTI+DI7/oZAud56oxcyNohxNsfIKZliIMB1VViZqHuJK/zCY6YfcWcXZSmeWRtx0toMNfscIyH1Cuyy7+5C0cXSu0FHKEU4QO2Ub4wIyNr4iZaRM4JENTf+njJySg1jrpCfUAkn3pzzN4jx8nSoMcJZTn8zkgLRGs83a9w8EpxXNmiD6qIAsFutXm7QqziefEkC2f3jVKeqo7VcLClu0/MHnl+uzCwHNPPP+VJcr0w46GZLYvs9jV7Rwyu7b1fMh+0r1JDgl+OGMQUOWwhQBBJmQt5QUK4ICqm5IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGngKiOvNBEzp5oaYnUOfs+albTOX1IWs2lyAvVHWf8=;
 b=OKUlUv952CcJ6xnMOo+xcTbtHqhQJoDEhI+pIAlGWcFnTc/QSiNp2WszG7uUp88YSJs313FQXEkxFiDGuC/jkPUMzmJJ0Upnz/ZmwBR62SPPltCtkhp3PXWILk7RZBGJb6hVGXouoHJLvMrxidpHKnzGxnkhZsyxBSpXy/+M8crtPJA9+rPxR8h7NmqVsrmbtlk55aZf1580qOl4LRIQ+HDPHTz6xiNTpvAIe+OMecwd2uutZMm/73y72IsoZ+aq0vBTENJwr7xIU68XUX3DIpPueNrx2Dg/BSyIE8eTkUGkamajJIge2f+EwIubFU++zc76iWI20iHOHL4CRHis+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGngKiOvNBEzp5oaYnUOfs+albTOX1IWs2lyAvVHWf8=;
 b=ULNIdTyCJLLGn/a+WaagQtjTXp9dAQcIj33UbIMP3Hp7ZW4Ku4iXI4KMKECj4JvpQcvHzyYRi+Wfe79fJfCP/DrkuH/ipPJ9bJipu3tkMfYLJrxqd5cxFK2nT9l4dSTxthx5cfDLFb47Oo4T7TLLwawm5Ltrgkj7xRXUdpxSzD8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB5897.namprd10.prod.outlook.com
 (2603:10b6:208:3d7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Tue, 6 Sep
 2022 16:10:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Tue, 6 Sep 2022
 16:10:47 +0000
Date:   Tue, 6 Sep 2022 09:10:43 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Message-ID: <YxdxA1yrWOTwAZhZ@colin-ia-desktop>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
 <63124f17.170a0220.80d35.2d31@mx.google.com>
 <20220904193413.zmjaognji4s4gedt@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904193413.zmjaognji4s4gedt@skbuf>
X-ClientProxiedBy: MW4PR04CA0123.namprd04.prod.outlook.com
 (2603:10b6:303:84::8) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9ccfdfe-4c54-4312-e201-08da90225bb6
X-MS-TrafficTypeDiagnostic: IA1PR10MB5897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9IReyEzGd/wid7e8xgiow5dYLYoonSqQEGoDk/nyncfVfmuWpwPRe0jEOd+JhNzwExCjDEN9PluHLStq49i7HlqPm7D+G/NW3JG0chE7anx9AtzdXWBxjAaRMdD7iJTs3xFXfgd9LNjA95r0Raw5FiW7DRUq6KYGhWQ44LU2DXeJtNC8+JKgl5jQrdtVql6FDn7hXOM7jWNF50alAOhgzJPzkBu+7UbBPb7Wy03qmSFxv/MgDBG4M9M4eUsB7hDRPJWSrmQmiidPGoCIc1tHzZGN+ha/tWUtYWuyJRUEvVKDar35GiK+yY+74CNPNHDgwueZs3jJKJlmchdAy82QYQZBxMgTNR2EZQqTnktUfUekINqysT023PCjJgGzUXOoYyfeYHJiVWKnqgfzi4PkSsFn7UT2OoDd2Lgm4TZJ4p5pugZzufDzKF9VZJK/odx6SjZSz+WIUe6dOeM4/1rccPAzXsBHHC1ajJqaLW38bTKTu5nLH13MI+3XiFwtGD1ivcWJFoVAPfT0BzE1oJLpX7HY48eaOzTvl8dkcu0Gix4Yma/Y5MRdx79eo57bbxfxOwBD+w6wETkqR5gzHsBZF28e91sTeMAC2rTQwj28b+JiO55sxzlgDujkJbseC3N4kqixdsomx7c0PmFQo9FmYGRfmo1pk3jqo2ZO0MX9gB6GoYlZHhMts8pJcVuifb4wXvDdCCACc7PvNsLOGiSTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39830400003)(396003)(136003)(376002)(346002)(366004)(478600001)(44832011)(6486002)(6506007)(41300700001)(54906003)(316002)(6916009)(186003)(86362001)(9686003)(6512007)(26005)(38100700002)(33716001)(6666004)(66946007)(66556008)(83380400001)(7416002)(66476007)(8676002)(8936002)(2906002)(30864003)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0PZJHTcLzvskXKcmTacmolCPRIFrVH4CBEu5cTnB4kVO0OoVhZzeRsrThgLo?=
 =?us-ascii?Q?dfhyjeYJg5SI/TQ5KFQAbVYZjmWiDK6Jx29zixRAMQsUYo4YMMznkBO6YmSM?=
 =?us-ascii?Q?8c7zzuvXNiXJ/ilafHFclq0rUxyWKeQN/g5eJnY0Wv065R1XvGpYCaC70snx?=
 =?us-ascii?Q?g5M6jBGgnpkNihRHseOHW8X55ISK/vWE7zJSrV0ZfiIQBbXRIZyoTC8HXF8t?=
 =?us-ascii?Q?rwCZUJYXBDUb+m/iWYt9ZsE9kVpj3qSv/mLAixLBQN8QKciL51uD4Z64NfZR?=
 =?us-ascii?Q?vq9LuP1rYbHTyJJFVDKWQUI27pQruF+IARhLCychhtBOfCvo7UoIPLTjATj2?=
 =?us-ascii?Q?697RIaA4ISLZJhhaejDuMXh6iQgiyYJQzqQGn5txExgvVxVG2K8kIVgn97pR?=
 =?us-ascii?Q?OxrZ/r11iYPjr3We8xRO+jwpzp0dwzgv8MGPiQg8p8EqWzZuU2lP+60IqCEv?=
 =?us-ascii?Q?JYccqXQUvMkCmMbn24REDB72au1wFETjLcDYR+VZcn3c4PXRIuGDQSlRICuF?=
 =?us-ascii?Q?SBemUzi7WCPskc2KYE+DcYRyJhgWHuOK4BTzTwLvOMkskxfeZKZokEzP05jf?=
 =?us-ascii?Q?5GZlrjO3BYjwqLsuc8zLXuKYLjHOxuob1et9iFwQCgvKf4F9H+cLNGngrvzU?=
 =?us-ascii?Q?SdoWSzUJlKcXNmZEu2abFHaoJAYgV9I7NyKduFHSA1YklYcOurXkDHr96Gsf?=
 =?us-ascii?Q?OgbheI+AjZndg+wbnGr27dN1Xh/dQCBshaKapW5tXAGlUWPPlpUIs7QQLnQj?=
 =?us-ascii?Q?FBijWxij7ECTKCnilkoRnwYoE1jlV2CPZeMG+/rBZNt9DELqC+z1bwjzZxz8?=
 =?us-ascii?Q?WB/CP1WtjQ+23xYJk61oZEjZZ7o6Xx6WvGqeSlN8Nek/MfObgPAj4QKsVYHc?=
 =?us-ascii?Q?rjM13Zdjq+HGR9rA8/9dulGW79SoxnuUDxTng1doN2/6MLBKSXWU473sZ0H8?=
 =?us-ascii?Q?0cg4VoDoHufrs+OOPUMI3YQcx5xZC5dN3aaCSpJcGEq2nmLfPYtxcgTsdtvK?=
 =?us-ascii?Q?bLBfMAQbuM9n8/j1i6q1FQeJsU/tEzZeFlq34pToOmAo2HV2T8T9mmQlrUkH?=
 =?us-ascii?Q?UVc+aaRMIuGKEXHzzBHvrWrW635ZKLsryNQKw0UcY6EH6B6Vu163mLQ1LyZO?=
 =?us-ascii?Q?QQfhI7PecihTTX7pst3UUBn8ptWe2kXyZaEbNMcoSyY/WgSQMYZpVsYZleIh?=
 =?us-ascii?Q?HnU6+dgDms6ajOHhn+EAmlK+0xB7OP5yMoTJSrtCZLHftALPUMycT4HXb5f4?=
 =?us-ascii?Q?7e4H4T9f25TZ9/iYj8TirRwnad+kKs/vZPhzmudcU0R+tXkZKbXMiOx0ngii?=
 =?us-ascii?Q?BgrwTQjuZpg1CHt0LRnqWiZRrQfw8ebFrBHTa7EETDYpjMm5JJLZ7+VLosLx?=
 =?us-ascii?Q?tukXxc8gpsqMr69SLNzZRGBOlJP3Ji1QDVdu1HTbBGd1RTAdPgVsfTyJSSYA?=
 =?us-ascii?Q?dnZ2JYooNBzrGFQsK6zG0alrx5MBf0lzNxHapxGORRKjJqc92r3yGKpw93N3?=
 =?us-ascii?Q?Zl3G1f3y+njqKzyoUCq3+U3Yrpv0Xi6vhoRAt4IksCluw39+00vEhoFXqFIl?=
 =?us-ascii?Q?dSlc2rkhHyufvHLqUmiwfSkr0bsgEb8rhvkmgdCv1adHNUgvFw2NCvbVnKkE?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ccfdfe-4c54-4312-e201-08da90225bb6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:10:47.1627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ne0LNwrCutnm33Vp664IxSAhZXjIsc4An9zVj2Enb3LMyVbadtI94VtvFDHp5n/XQxuBmBcQEAps6YHfYb7TlPftbln2m3z8021/uYWeJTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5897
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 07:34:14PM +0000, Vladimir Oltean wrote:
> On Fri, Sep 02, 2022 at 08:44:37PM +0200, Christian Marangi wrote:
> For transparency, here is the commit list I used to produce the backport (top-most is most recent):

Tangentially related: how did you come up with this list?

I can only assume this is a manual process based on intricate knowledge
of net / DSA as a whole. I just want to make sure there isn't a "git
backport net/dsa origin/master v5.10" sort of thing ;-)

> 
> $ cat stable-commits.txt
> 5dc760d12082 net: dsa: use dsa_tree_for_each_cpu_port in dsa_tree_{setup,teardown}_master
> f41ec1fd1c20 net: dsa: all DSA masters must be down when changing the tagging protocol
> 7136097e1199 net: dsa: only bring down user ports assigned to a given DSA master
> 4f03dcc6b9a0 net: dsa: existing DSA masters cannot join upper interfaces
> 920a33cd7231 net: bridge: move DSA master bridging restriction to DSA
> 0498277ee17b net: dsa: don't stop at NOTIFY_OK when calling ds->ops->port_prechangeupper
> 4c3f80d22b2e net: dsa: walk through all changeupper notifier functions
> be6ff9665d64 net: dsa: don't emit targeted cross-chip notifiers for MTU change
> 4715029fa7e9 net: dsa: drop dsa_slave_priv from dsa_slave_change_mtu
> cf1c39d3b3a5 net: dsa: avoid one dsa_to_port() in dsa_slave_change_mtu
> b2033a05a719 net: dsa: use dsa_tree_for_each_user_port in dsa_slave_change_mtu
> 726816a129cb net: dsa: make cross-chip notifiers more efficient for host events
> 8e9e678e4758 net: dsa: move reset of VLAN filtering to dsa_port_switchdev_unsync_attrs
> 762c2998c962 Revert "net: dsa: setup master before ports"
> 8e6598a7b0fa net: dsa: Pass VLAN MSTI migration notifications to driver
> 332afc4c8c0d net: dsa: Validate hardware support for MST
> f54fd0e16306 net: bridge: mst: Add helper to query a port's MST state
> 48d57b2e5f43 net: bridge: mst: Add helper to check if MST is enabled
> cceac97afa09 net: bridge: mst: Add helper to map an MSTI to a VID set
> 7ae9147f4312 net: bridge: mst: Notify switchdev drivers of MST state changes
> 6284c723d9b9 net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations
> 87c167bb94ee net: bridge: mst: Notify switchdev drivers of MST mode changes
> 122c29486e1f net: bridge: mst: Support setting and reporting MST port states
> 8c678d60562f net: bridge: mst: Allow changing a VLAN's MSTI
> ec7328b59176 net: bridge: mst: Multiple Spanning Tree (MST) mode
> 0832cd9f1f02 net: dsa: warn if port lists aren't empty in dsa_port_teardown
> afb3cc1a397d net: dsa: unlock the rtnl_mutex when dsa_master_setup() fails
> 7569459a52c9 net: dsa: manage flooding on the CPU ports
> 499aa9e1b332 net: dsa: install the primary unicast MAC address as standalone port host FDB
> 5e8a1e03aa4d net: dsa: install secondary unicast and multicast addresses as host FDB/MDB
> 68d6d71eafd1 net: dsa: rename the host FDB and MDB methods to contain the "bridge" namespace
> 35aae5ab9121 net: dsa: remove workarounds for changing master promisc/allmulti only while up
> 06b9cce42634 net: dsa: pass extack to .port_bridge_join driver methods
> c26933639b54 net: dsa: request drivers to perform FDB isolation
> b6362bdf750b net: dsa: tag_8021q: rename dsa_8021q_bridge_tx_fwd_offload_vid
> 04b67e18ce5b net: dsa: tag_8021q: merge RX and TX VLANs
> 08f44db3abe6 net: dsa: felix: delete workarounds present due to SVL tag_8021q bridging
> d27656d02d85 docs: net: dsa: sja1105: document limitations of tc-flower rule VLAN awareness
> d7f9787a763f net: dsa: tag_8021q: add support for imprecise RX based on the VBID
> 91495f21fcec net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL bridging
> 961d8b699070 net: dsa: felix: support FDB entries on offloaded LAG interfaces
> e212fa7c5418 net: dsa: support FDB events on offloaded LAG interfaces
> 93c798230af5 net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
> e35f12e993d4 net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
> ec638740fce9 net: switchdev: remove lag_mod_cb from switchdev_handle_fdb_event_to_device
> dedd6a009f41 net: dsa: create a dsa_lag structure
> b99dbdf00bc1 net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
> 3d4a0a2a46ab net: dsa: make LAG IDs one-based
> 066ce9779c7a net: dsa: qca8k: rename references to "lag" as "lag_dev"
> e23eba722861 net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
> 46a76724e4c9 net: dsa: rename references to "lag" as "lag_dev"
> b9e8b58fd2cb net: dsa: Include BR_PORT_LOCKED in the list of synced brport flags
> a21d9a670d81 net: bridge: Add support for bridge port in locked mode
> acd8df5880d7 net: switchdev: avoid infinite recursion from LAG to bridge with port object handler
> 342b6419193c net: dsa: fix panic when removing unoffloaded port from bridge
> 8940e6b669ca net: dsa: avoid call to __dev_set_promiscuity() while rtnl_mutex isn't held
> ba43b547515e net: lan966x: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
> e42bd4ed09aa net: mscc: ocelot: keep traps in a list
> 85ea0daabe5a net: mscc: ocelot: avoid overlap in VCAP IS2 between PTP and MRP traps
> b9bace6e534d net: mscc: ocelot: use a single VCAP filter for all MRP traps
> 36fac35b2907 net: mscc: ocelot: delete OCELOT_MRP_CPUQ
> c518afec2883 net: mscc: ocelot: consolidate cookie allocation for private VCAP rules
> e3c02b7c655c net: mscc: ocelot: use a consistent cookie for MRP traps
> 164f861bd40c net: dsa: offload bridge port VLANs on foreign interfaces
> 134ef2388e7f net: dsa: add explicit support for host bridge VLANs
> c4076cdd21f8 net: switchdev: introduce switchdev_handle_port_obj_{add,del} for foreign interfaces
> 7b465f4cf39e net: switchdev: rename switchdev_lower_dev_find to switchdev_lower_dev_find_rcu
> b28d580e2939 net: bridge: switchdev: replay all VLAN groups
> 263029ae3172 net: bridge: make nbp_switchdev_unsync_objs() follow reverse order of sync()
> 8d23a54f5bee net: bridge: switchdev: differentiate new VLANs from changed ones
> 27c5f74c7ba7 net: bridge: vlan: notify switchdev only when something changed
> cab2cd770051 net: bridge: vlan: make __vlan_add_flags react only to PVID and UNTAGGED
> 3116ad0696dd net: bridge: vlan: don't notify to switchdev master VLANs without BRENTRY flag
> b2bc58d41fde net: bridge: vlan: check early for lack of BRENTRY flag in br_vlan_add_existing
> ef5764057540 net: mscc: ocelot: fix use-after-free in ocelot_vlan_del()
> 5454f5c28eca net: bridge: vlan: check for errors from __vlan_del in __vlan_flush
> 867b1db874c9 net: lan966x: Fix when CONFIG_IPV6 is not set
> 1da52b0e4724 net: lan966x: Fix when CONFIG_PTP_1588_CLOCK is compiled as module
> 59085208e4a2 net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over IP
> 47aeea0d57e8 net: lan966x: Implement the callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
> cddbec19466a net: dsa: qca8k: add tracking state of master port
> e83d56537859 net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
> 295ab96f478d net: dsa: provide switch operations for tracking the master state
> a1ff94c2973c net: dsa: stop updating master MTU from master.c
> 77eecf25bd9d net: lan966x: Update extraction/injection for timestamping
> 735fec995b21 net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
> d096459494a8 net: lan966x: Add support for ptp clocks
> 108dc8741c20 net: dsa: Avoid cross-chip syncing of VLAN filtering
> 381a730182f1 net: dsa: Move VLAN filtering syncing out of dsa_switch_bridge_leave
> 5cad43a52ee3 net: dsa: felix: add port fast age support
> 1b26d364e4e9 net: dsa: warn about dsa_port and dsa_switch bit fields being non atomic
> 63cfc65753d6 net: dsa: don't enumerate dsa_switch and dsa_port bit fields using commas
> 11fd667dac31 net: dsa: setup master before ports
> 1e3f407f3cac net: dsa: first set up shared ports, then non-shared ports
> c146f9bc195a net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
> a68dc7b938fb net: dsa: remove cross-chip support for HSR
> cad69019f2f8 net: dsa: remove cross-chip support for MRP
> 4b026e82893b net: dsa: combine two holes in struct dsa_switch_tree
> b035c88c6a30 net: dsa: move dsa_switch_tree :: ports and lags to first cache line
> 258030acc93b net: dsa: make dsa_switch :: num_ports an unsigned int
> 7787ff776398 net: dsa: merge all bools of struct dsa_switch into a single u32
> 0625125877da net: dsa: move dsa_port :: type near dsa_port :: index
> bde82f389af1 net: dsa: merge all bools of struct dsa_port into a single u8
> b08db33dabd1 net: dsa: move dsa_port :: stp_state near dsa_port :: mac
> 7aacb894b1ad net: lan966x: Extend switchdev with mdb support
> 11b0a27772f5 net: lan966x: Add PGID_GP_START and PGID_GP_END
> fc0c3fe7486f net: lan966x: Add function lan966x_mac_ip_learn()
> 0c94d657d2a4 net: lan966x: Fix the vlan used by host ports
> 2e49761e4fd1 net: lan966x: Add support for multiple bridge flags
> 811ba2771182 net: lan966x: Extend switchdev with fdb support
> e14f72398df4 net: lan966x: Extend switchdev bridge flags
> 6d2c186afa5d net: lan966x: Add vlan support.
> cf2f60897e92 net: lan966x: Add support to offload the forwarding.
> 571bb516a869 net: lan966x: Remove .ndo_change_rx_flags
> 25ee9561ec62 net: lan966x: More MAC table functionality
> 5ccd66e01cbe net: lan966x: add support for interrupts from analyzer
> ef14049f4db9 net: lan966x: Add registers that are used for switch and vlan functionality
> 7f2973149c22 net: dsa: make tagging protocols connect to individual switches from a tree
> e2f01bfe1406 net: dsa: tag_sja1105: fix zeroization of ds->priv on tag proto disconnect
> b26980ab2a97 net: lan966x: Fix the configuration of the pcs
> 950a419d9de1 net: dsa: tag_sja1105: split sja1105_tagger_data into private and public sections
> fcbf979a5b4b Revert "net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver"
> c79e84866d2a net: dsa: tag_sja1105: convert to tagger-owned data
> 22ee9f8e4011 net: dsa: sja1105: move ts_id from sja1105_tagger_data
> bfcf14252220 net: dsa: sja1105: make dp->priv point directly to sja1105_tagger_data
> 6f6770ab1ce2 net: dsa: sja1105: remove hwts_tx_en from tagger data
> d38049bbe760 net: dsa: sja1105: bring deferred xmit implementation in line with ocelot-8021q
> a3d74295d790 net: dsa: sja1105: let deferred packets time out when sent to ports going down
> 35d976802124 net: dsa: tag_ocelot: convert to tagger-owned data
> dc452a471dba net: dsa: introduce tagger-owned storage for private and shared data
> 857fdd74fb38 net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload
> b079922ba2ac net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join
> d3eed0e57d5d net: dsa: keep the bridge_dev and bridge_num as part of the same structure
> 6a43cba30340 net: dsa: export bridging offload helpers to drivers
> 936db8a2dba2 net: dsa: rename dsa_port_offloads_bridge to dsa_port_offloads_bridge_dev
> 41fb0cf1bced net: dsa: hide dp->bridge_dev and dp->bridge_num in drivers behind helpers
> 36cbf39b5690 net: dsa: hide dp->bridge_dev and dp->bridge_num in the core behind helpers
> 65144067d360 net: dsa: mv88e6xxx: compute port vlan membership based on dp->bridge_dev comparison
> 0493fa7927af net: dsa: mv88e6xxx: iterate using dsa_switch_for_each_user_port in mv88e6xxx_port_check_hw_vlan
> 872bb81dfbc3 net: dsa: mt7530: iterate using dsa_switch_for_each_user_port in bridging ops
> 947c8746e2c3 net: dsa: assign a bridge number even without TX forwarding offload
> 3f9bb0301d50 net: dsa: make dp->bridge_num one-based
> bb14bfc7eb92 net: lan966x: fix a IS_ERR() vs NULL check in lan966x_create_targets()
> cc9cf69eea48 net: lan966x: Fix builds for lan966x driver
> a290cf692779 net: lan966x: Fix duplicate check in frame extraction
> 12c2d0a5b8e2 net: lan966x: add ethtool configuration and statistics
> e18aba8941b4 net: lan966x: add mactable support
> d28d6d2e37d1 net: lan966x: add port module support
> db8bcaad5393 net: lan966x: add the basic lan966x driver
> ef136837aaf6 net: dsa: rtl8365mb: set RGMII RX delay in steps of 0.3 ns
> b014861d96a6 net: dsa: realtek-smi: don't log an error on EPROBE_DEFER
> 1e89ad864d03 net: dsa: realtek-smi: fix indirect reg access for ports>3
> b3612ccdf284 net: dsa: microchip: implement multi-bridge support
> 96ca08c05838 net: mscc: ocelot: set up traps for PTP packets
> ec15baec3272 net: ptp: add a definition for the UDP port for IEEE 1588 general messages
> 95706be13b9f net: mscc: ocelot: create a function that replaces an existing VCAP filter
> 8abe19703825 net: dsa: felix: enable cut-through forwarding between ports by default
> a8bd9fa5b527 net: ocelot: remove "bridge" argument from ocelot_get_bridge_fwd_mask
> 4636440f913b net: dsa: qca8k: Fix spelling mistake "Mismateched" -> "Mismatched"
> 0898ca67b86e net: dsa: qca8k: fix warning in LAG feature
> def975307c01 net: dsa: qca8k: add LAG support
> 2c1bdbc7e756 net: dsa: qca8k: add support for mirror mode
> ba8f870dfa63 net: dsa: qca8k: add support for mdb_add/del
> 6a3bdc5209f4 net: dsa: qca8k: add set_ageing_time support
> 4592538bfb0d net: dsa: qca8k: add support for port fast aging
> c126f118b330 net: dsa: qca8k: add additional MIB counter and make it dynamic
> 8b5f3f29a81a net: dsa: qca8k: initial conversion to regmap helper
> 36b8af12f424 net: dsa: qca8k: move regmap init in probe and set it mandatory
> 994c28b6f971 net: dsa: qca8k: remove extra mutex_init in qca8k_setup
> 90ae68bfc2ff net: dsa: qca8k: convert to GENMASK/FIELD_PREP/FIELD_GET
> b9133f3ef5a2 net: dsa: qca8k: remove redundant check in parse_port_config
> 65258b9d8cde net: dsa: qca8k: fix MTU calculation
> 3b00a07c2443 net: dsa: qca8k: fix internal delay applied to the wrong PAD config
> a7e13edf37be net: dsa: felix: restrict psfp rules on ingress port
> 76c13ede7120 net: dsa: felix: use vcap policer to set flow meter for psfp
> 77043c37096d net: mscc: ocelot: use index to set vcap policer
> 23ae3a787771 net: dsa: felix: add stream gate settings for psfp
> 7d4b564d6add net: dsa: felix: support psfp filter on vsc9959
> 23e2c506ad6c net: mscc: ocelot: add gate and police action offload to PSFP
> 5b1918a54a91 net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
> 0568c3bf3f34 net: mscc: ocelot: add MAC table stream learn and lookup operations
> 02d6fdecb9c3 regmap: allow to define reg_update_bits for no bus configuration
> 5f15d392dcb4 net: dsa: qca8k: make sure PAD0 MAC06 exchange is disabled
> ae0393500e3b net: bridge: switchdev: fix shim definition for br_switchdev_mdb_notify
> 326b212e9cd6 net: bridge: switchdev: consistent function naming
> 9776457c784f net: bridge: mdb: move all switchdev logic to br_switchdev.c
> 9ae9ff994b0e net: bridge: split out the switchdev portion of br_mdb_notify
> 4a6849e46173 net: bridge: move br_vlan_replay to br_switchdev.c
> c5f6e5ebc2af net: bridge: provide shim definition for br_vlan_flags
> 716a30a97a52 net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
> fab9eca88410 net: bridge: create a common function for populating switchdev FDB entries
> 5cda5272a460 net: bridge: move br_fdb_replay inside br_switchdev.c
> 9574fb558044 net: bridge: reduce indentation level in fdb_create
> f6814fdcfe1b net: bridge: rename br_fdb_insert to br_fdb_add_local
> 4731b6d6b257 net: bridge: rename fdb_insert to fdb_add_local
> 5f94a5e276ae net: bridge: remove fdb_insert forward declaration
> 4682048af0c8 net: bridge: remove fdb_notify forward declaration
> 425d19cedef8 net: dsa: stop calling dev_hold in dsa_slave_fdb_event
> d7d0d423dbaa net: dsa: flush switchdev workqueue when leaving the bridge
> 0faf890fc519 net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
> 338a3a4745aa net: dsa: introduce locking for the address lists on CPU and DSA ports
> cf231b436f7c net: dsa: lantiq_gswip: serialize access to the PCE registers
> f7eb4a1c0864 net: dsa: b53: serialize access to the ARL table
> edc90d15850c selftests: net: dsa: add a stress test for unlocked FDB operations
> 016748961ba5 selftests: lib: forwarding: allow tests to not require mz and jq
> f239934cffe5 net: dsa: b53: serialize access to the ARL table
> f2c4bdf62d76 net: mscc: ocelot: serialize access to the MAC table
> 1681ae1691ef net: dsa: sja1105: serialize access to the dynamic config interface
> 643979cf5ec4 net: dsa: sja1105: wait for dynamic config command completion on writes too
> 992e5cc7be8e net: dsa: tag_8021q: make dsa_8021q_{rx,tx}_vid take dp as argument
> 5068887a4fbe net: dsa: tag_sja1105: do not open-code dsa_switch_for_each_port
> fac6abd5f132 net: dsa: convert cross-chip notifiers to iterate using dp
> 57d77986e742 net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
> 65c563a67755 net: dsa: do not open-code dsa_switch_for_each_port
> d0004a020bb5 net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
> 82b318983c51 net: dsa: introduce helpers for iterating through ports using dp
> d4004422f6f9 net: mscc: ocelot: track the port pvid using a pointer
> bfbab3104413 net: mscc: ocelot: add the local station MAC addresses in VID 0
> 0da1a1c48911 net: mscc: ocelot: allow a config where all bridge VLANs are egress-untagged
> 90e0aa8d108d net: mscc: ocelot: convert the VLAN masks to a list
> 62a22bcbd30e net: mscc: ocelot: add a type definition for REW_TAG_CFG_TAG_CFG
> 040e926f5813 net: dsa: qca8k: tidy for loop in setup and add cpu port check
> 9ca482a246f0 net: dsa: sja1105: parse {rx, tx}-internal-delay-ps properties for RGMII delays
> 4af2950c50c8 net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC
> 1521d5adfc2b net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
> 9cb8edda2157 net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Makefile
> 7bbbbfaa7a1b ether: add EtherType for proprietary Realtek protocols
> fd0bb28c547f net: dsa: qca8k: move port config to dedicated struct
> cef08115846e net: dsa: qca8k: set internal delay also for sgmii
> f477d1c8bdbe net: dsa: qca8k: add support for QCA8328
> ed7988d77fbf dt-bindings: net: dsa: qca8k: document support for qca8328
> 362bb238d8bf net: dsa: qca8k: add support for pws config reg
> 924087c5c3d4 dt-bindings: net: dsa: qca8k: Document qca,led-open-drain binding
> bbc4799e8bb6 net: dsa: qca8k: add explicit SGMII PLL enable
> 13ad5ccc093f dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
> 5654ec78dd7e net: dsa: qca8k: rework rgmii delay logic and scan for cpu port 6
> 3fcf734aa482 net: dsa: qca8k: add support for cpu port 6
> 731d613338ec dt-bindings: net: dsa: qca8k: Document support for CPU port 6
> 6c43809bf1be net: dsa: qca8k: add support for sgmii falling edge
> fdbf35df9c09 dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
> d8b6f5bae6d3 dsa: qca8k: add mac_power_sel support
> 39e222bfd7f3 net: dsa: unregister cross-chip notifier after ds->ops->teardown
> 339e75f6b9a0 net: dsa: rtl8366rb: remove unneeded semicolon
> e674cfd08537 net: dsa: rtl8366rb: Support setting STP state
> 1fbd19e10b73 net: dsa: rtl8366rb: Support fast aging
> 56d8bb71a811 net: dsa: rtl8366rb: Support disabling learning
> 5ca721c54d86 net: dsa: tag_ocelot: set the classified VLAN during xmit
> e8c0722927e8 net: mscc: ocelot: write full VLAN TCI in the injection header
> de5bbb6f7e4c net: mscc: ocelot: support egress VLAN rewriting via VCAP ES0
> 55b115c7ecd9 net: dsa: rtl8366rb: Use core filtering tracking
> d310b14ae748 net: dsa: rtl8366: Drop and depromote pointless prints
> a4eff910ec63 net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
> 7776e33c68ae net: dsa: rtl8366: Drop custom VLAN set-up
> d5a680295be2 net: dsa: rtl8366rb: Support bridge offloading
> bd936bd53b2d net: dsa: Move devlink registration to be last devlink command
> 6d709cadfde6 net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver
> 68a81bb2eebd net: dsa: sja1105: remove sp->dp
> db4278c55fa5 devlink: Make devlink_register to be void
> 4dcd183fbd67 net: wwan: iosm: devlink registration
