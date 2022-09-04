Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4335AC630
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 21:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiIDTeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 15:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbiIDTeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 15:34:23 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20088.outbound.protection.outlook.com [40.107.2.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198652EF23;
        Sun,  4 Sep 2022 12:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVgPR6qdlbpuUkKNEwTnt2zcT+vYZuCHB0+1r7IVWso/isiE0rXj9BWrAA0al1ZWsqgwOOCt23uwwp5d9KmOWbjFSDgVRHxw6OJ3Kb8DwQEkIeT0RwHPcN6BHne4pxsLDDXK30EgMUKFtBrfC34eSeSenHcsWgTEpaMwGPJD+Iyzsl37i4kEA6mf32g41zuYEBq9tR4KLqarowlu5kdTse3upqKuUqXTR6xp5FNq4YfDQJRDQVFi/2N2wlPo//x7jHEeDOqfHkLT8Rnw6f+XQ+m5bnXTcISdlE01wHyor+ae8bT5duWL6Cd9WV9gfWIkqeEK/DdnOmg3nmK31Z6eiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFQ7dysNSRStX5f/7iLSHwefMSmwWFepYXBSK1iFBYw=;
 b=WuVlodrVckYoeYjPAqcMMdmXs0nt/jmU4EBD/zgpPCUShMwdb4dZ5jxn1AGHmiEso7cNzA0KhQIbvzk+t0DvRbr3FiVW8/uL8QjDOPeWEPceGEMiZfgOVpGGzdweLIUgkvN43SLVLixwry7axlQ6e+u+rlB9dl4puBSpEOtWxkqKk8Xk80odtDVdAVtCWYMa1wh9CERZUTmRxhfELv1/hDRP/UqwPddXaXDSXDrayi3jIKESz1Wq/o4tuJ4XP8b6qmyuG9ht6vcIt5TYErYz16CcJeVc/Bc6LR5zgVFCtl2dkz9+Qs7A3LquOLX+Q8jdvkBYFHSztYeG15s5V+0Iyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFQ7dysNSRStX5f/7iLSHwefMSmwWFepYXBSK1iFBYw=;
 b=aftk04xRBTuTbRVnSO3da+POAWjoQ4rhCLCcI22p4N112mDOO2ULrP77203zjDueP086WUyxpzdmCcslLKPXXjQ4Z2ckxRn4MBGkLmPJHv+Txd2exw73aXj1gUMUZebX0wkDzve0hQ/Yfc3vF9gdaPe3Wvozs+Sk3dgx0VfEXd0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9045.eurprd04.prod.outlook.com (2603:10a6:20b:440::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Sun, 4 Sep
 2022 19:34:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Sun, 4 Sep 2022
 19:34:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Thread-Topic: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Thread-Index: AQHYvKsLmg9+Fvc+3E2TksPGMZq+1a3MfsSAgAMyhYA=
Date:   Sun, 4 Sep 2022 19:34:14 +0000
Message-ID: <20220904193413.zmjaognji4s4gedt@skbuf>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
 <63124f17.170a0220.80d35.2d31@mx.google.com>
In-Reply-To: <63124f17.170a0220.80d35.2d31@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f7ace81-4c20-4453-8ce1-08da8eac734d
x-ms-traffictypediagnostic: AS8PR04MB9045:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gosi+1nZaPt7VfOCljcbz4WMAdxj0+WlSum81MwHjCenF0V05AmV5NUPcwRfVz1+l33WFUddQ8JRRyZ+HrALA9vCQZAO0r/1Y2XAo/FfQFpKbobUfo5RREXCzQge1D0r/UHymesXIOE4FEVs33jlDB+54prKUebZ3d0eB6xxdJktc5P4606G9DACaHTRhLqdaY/ZvS1HUnJwKA03OuoqVoJkxtABJBWMgon5ZnzzSviDjNZhf3th24G3XpvBsqtCXt6oXZ8EY1iYALFljyinnQoTPh5F9AZvWj6MeBy2bGKwQfiS8r7MCIatxc74qgtURMqS4JX8tcc5LCXhT+K2czmk0FpiqFZ8J5JgYrf3c59vrsHu5rMjcH5WxpcJjrrwk25vviyIX6pzJrlzUNvq69vun52I/P9AZspiUgca9+YnE0m1zRt2BMnklNXchz85C/by0rJsJ1KQwfRJ/3SJ3Ld+QPT0n5FqPjjaHg9FKkXJ/JifAa7GDxjkarLG9dKPXcbzdPyl4B6DsG344pwD2tG1US0pajfMJtDVH9iyHophJ7sP79Cs7Ru5SJD3adigz3XpKgZ1mTcGsUaPLYl++D/QDKzTzT+3VR7361Ke5byQwMwZc35pNOBiQ73XkHh5JZxkGGeqlfMYClHiqqV0+aH5Jgoh/hpWh5s8EIYyWS1w/VLCn9efN+1n19wfWIGAvG68QU9TiEm+msZzQefJ1yDXIA5tuQB3msqDd7wLeBdkEVLR8il7UcM414YEf+kcC0CtDNCoy87cv0VfFHjXcVvzBb0vAhtuMTlPWBa8RoZJMTRDEqfa1dHzRfACR6zQ6VtJmP5h/pA4UUvzwlifvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(966005)(6512007)(122000001)(54906003)(33716001)(6916009)(71200400001)(6506007)(86362001)(2906002)(9686003)(6486002)(76116006)(66946007)(316002)(66476007)(8936002)(5660300002)(8676002)(66556008)(7416002)(91956017)(4326008)(30864003)(66446008)(44832011)(64756008)(478600001)(41300700001)(38100700002)(26005)(186003)(1076003)(83380400001)(38070700005)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Bpxhf4OmYqsDNDcFU2Tx3H44bgDG0wQH3b+18Fo2B592xvPDk2YtlKG6?=
 =?Windows-1252?Q?2z97k+U943NqAF7rpofVaOOaZmS29S3k1seSKcaiSup/TGFXs08J0IHY?=
 =?Windows-1252?Q?hLTAZr2cLnGETiSFmjWA7nV/Qnil3q6dzyHNgR5idbybAerzOKdEotcD?=
 =?Windows-1252?Q?ehZY6ZgV0xYTp+W0fmU7Y1YagduHu324r32Bca2B3Ra/0jmNElGdkx5o?=
 =?Windows-1252?Q?j10eh2rVtsOPZyllQ4M3RENvgTvdsRrWSmBFG53LFW4ys9mnSw4lV+Bj?=
 =?Windows-1252?Q?V/EuzvawCCDBDEGEgNPmMDq4V8Iq9Hns+4ajnFKlBofun1FA9kpxc0qP?=
 =?Windows-1252?Q?NngFLVItElKMpp3WOUcifzI7xtcXRv58szR9D2cNl0x37d7gnG7cwIRQ?=
 =?Windows-1252?Q?jHYkDGls7fY/7B/ZFTiqRp6MhWUELaSOBpoxXQ7StO/WlSQbfg2dXuA1?=
 =?Windows-1252?Q?E4+tGvOjPlbeEdaYiaLn/2pxu0gVOIqetnvKLLTlqMHi3QHxxd6P99k7?=
 =?Windows-1252?Q?P0+EPGQGMbuMoWj63jjoc+TVn7zarQh9ty1XsIObRjA1aYcrYij4+z6q?=
 =?Windows-1252?Q?GWnEGHCOZlwFh76vYa5pe+1dDrJMRw1Ei8ZjCxtjNP4UkdTi2P+K8e50?=
 =?Windows-1252?Q?SiRRNRwHPXAQI1OEm0FdylxqUw+5Ea7HdtBvothPotwA/CfNRM8ODPf9?=
 =?Windows-1252?Q?rXQD/jNAzpdqUemnurMTwWVKpjZNSIVsF44cVLKbM+P8dVq5EM1z2E1v?=
 =?Windows-1252?Q?wZTRUVdVJjJ+nTThFWMbobLRIaz5bUT+qcWpHz203Cn/Xo+KIReP6cFc?=
 =?Windows-1252?Q?3meQMyh22oGRLyGer2tBrQ224KFgBEGakkHkCu6kGVkPgLjW7NaGhjeo?=
 =?Windows-1252?Q?NZyjQ+3ltxsVUdr/J3EPpUry+ZJIDb9yciw1CfaY5AN+/1Z298/jAG4j?=
 =?Windows-1252?Q?q1J0flDCBd0baKEMHot00jOjEgi9V0MReVLgepLvL2tFmwE07EiUgAmB?=
 =?Windows-1252?Q?h1aEGZeyYZSWFeQLDywvnZxv/m8mLY1yloZGpBC++6kYYwK2zY58N43S?=
 =?Windows-1252?Q?JTBZuua7Rz6U1DpsL6PaafvotY288zRYrC2yhPtVD2m3TbojINkSMZYT?=
 =?Windows-1252?Q?2Gs9WyD2j/rTNzWtvkzNEb/KpqQ/zf8uAX88zCqKYxCLt6mmxpoDKd+u?=
 =?Windows-1252?Q?X8ziE5xdSjLlHiXCVEeA33WxLmFc6w/i8fM77KTjB2eh8/V3eBCGwmLM?=
 =?Windows-1252?Q?nGCNTspK5gQsZYfbQOqG1gvLM4loV86XN1ogaYpuQAgttD+RkDpU8bhp?=
 =?Windows-1252?Q?lyFiCii0Joi8Ql3R2Jb/n+5LF8lLk1rTJNgY1gQDvKVjvHODUxMPNfE+?=
 =?Windows-1252?Q?xOFDpxtGYbd22h/BsCXCOiCtiY/O2R6qx+oXfYHABhbzqMeLSWsCGjrl?=
 =?Windows-1252?Q?I0eCEe1F0hMT4+lRgDgttD+2xlahF8FQa589y8KJVPoarB3Ohki1J3bU?=
 =?Windows-1252?Q?UDMMaWFq8kF+rJZ03JpWjhkoI4T8fl9s9cQYPgnWfBYKrLjyLHsoFYKv?=
 =?Windows-1252?Q?uGQJrG4xZuCK/7btZDNoqCkX7C9c4SWAtBz5QlOv2I3INXgFkDC0JxQI?=
 =?Windows-1252?Q?4h1V11sbbj4kPiQnnXVmeV26t6nBpbgG/4kNVQbTzDkHn9U5jRqF4fhl?=
 =?Windows-1252?Q?HH5iazDSaMnB/dt1gpSzIksp2+6NRzSuZhBZhZZ0N78NMMsTfLQwgA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <498F42DEAD643F4CAF2EAB9D9ABB1250@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7ace81-4c20-4453-8ce1-08da8eac734d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2022 19:34:14.5859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2KUGMhxGGi3N9gh7RrvJuJzaYN6JJ8Gd6uKOp4LJb7oWg+1+KGdvpRAKt13fbxcBH+0Vs82YBbWH3ZWjzgVZfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9045
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 02, 2022 at 08:44:37PM +0200, Christian Marangi wrote:
> Hi,
> I would love to test this but for me it's a bit problematic to use a
> net-next kernel. I wonder if it's possible to backport the 4 part to
> older kernel or other prereq are needed. (I know backporting the 4 part
> will be crazy but it's something that has to be done anyway to actually
> use this on OpenWrt where we currently use 5.10 and 5.15)
>=20
> Would be good to know if the 4 part require other changes to dsa core to
> make a LAG implementation working. (talking for 5.15 since backporting
> this to 5.10 is a nono...)

For testing, iproute2 patch should be coming up soon here:
https://lore.kernel.org/netdev/20220904190025.813574-1-vladimir.oltean@nxp.=
com/

I tried to backport something on the current linux-stable/linux-5.15.y.
https://github.com/vladimiroltean/linux/tree/dsa-5.15.y

Consider it a work in progress. It compiles and boots on NXP LS1028A,
but I can't guarantee anything beyond that. Furthermore, I've only
backported the merged patches, not the patch set discussed here proper.

I think it would be nice if we had a collaborative tree with DSA
backports for 5.15, because here I just tried to backport the DSA core
rather than all driver changes (since I would be unable to test those).

For transparency, here is the commit list I used to produce the backport (t=
op-most is most recent):

$ cat stable-commits.txt
5dc760d12082 net: dsa: use dsa_tree_for_each_cpu_port in dsa_tree_{setup,te=
ardown}_master
f41ec1fd1c20 net: dsa: all DSA masters must be down when changing the taggi=
ng protocol
7136097e1199 net: dsa: only bring down user ports assigned to a given DSA m=
aster
4f03dcc6b9a0 net: dsa: existing DSA masters cannot join upper interfaces
920a33cd7231 net: bridge: move DSA master bridging restriction to DSA
0498277ee17b net: dsa: don't stop at NOTIFY_OK when calling ds->ops->port_p=
rechangeupper
4c3f80d22b2e net: dsa: walk through all changeupper notifier functions
be6ff9665d64 net: dsa: don't emit targeted cross-chip notifiers for MTU cha=
nge
4715029fa7e9 net: dsa: drop dsa_slave_priv from dsa_slave_change_mtu
cf1c39d3b3a5 net: dsa: avoid one dsa_to_port() in dsa_slave_change_mtu
b2033a05a719 net: dsa: use dsa_tree_for_each_user_port in dsa_slave_change_=
mtu
726816a129cb net: dsa: make cross-chip notifiers more efficient for host ev=
ents
8e9e678e4758 net: dsa: move reset of VLAN filtering to dsa_port_switchdev_u=
nsync_attrs
762c2998c962 Revert "net: dsa: setup master before ports"
8e6598a7b0fa net: dsa: Pass VLAN MSTI migration notifications to driver
332afc4c8c0d net: dsa: Validate hardware support for MST
f54fd0e16306 net: bridge: mst: Add helper to query a port's MST state
48d57b2e5f43 net: bridge: mst: Add helper to check if MST is enabled
cceac97afa09 net: bridge: mst: Add helper to map an MSTI to a VID set
7ae9147f4312 net: bridge: mst: Notify switchdev drivers of MST state change=
s
6284c723d9b9 net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrat=
ions
87c167bb94ee net: bridge: mst: Notify switchdev drivers of MST mode changes
122c29486e1f net: bridge: mst: Support setting and reporting MST port state=
s
8c678d60562f net: bridge: mst: Allow changing a VLAN's MSTI
ec7328b59176 net: bridge: mst: Multiple Spanning Tree (MST) mode
0832cd9f1f02 net: dsa: warn if port lists aren't empty in dsa_port_teardown
afb3cc1a397d net: dsa: unlock the rtnl_mutex when dsa_master_setup() fails
7569459a52c9 net: dsa: manage flooding on the CPU ports
499aa9e1b332 net: dsa: install the primary unicast MAC address as standalon=
e port host FDB
5e8a1e03aa4d net: dsa: install secondary unicast and multicast addresses as=
 host FDB/MDB
68d6d71eafd1 net: dsa: rename the host FDB and MDB methods to contain the "=
bridge" namespace
35aae5ab9121 net: dsa: remove workarounds for changing master promisc/allmu=
lti only while up
06b9cce42634 net: dsa: pass extack to .port_bridge_join driver methods
c26933639b54 net: dsa: request drivers to perform FDB isolation
b6362bdf750b net: dsa: tag_8021q: rename dsa_8021q_bridge_tx_fwd_offload_vi=
d
04b67e18ce5b net: dsa: tag_8021q: merge RX and TX VLANs
08f44db3abe6 net: dsa: felix: delete workarounds present due to SVL tag_802=
1q bridging
d27656d02d85 docs: net: dsa: sja1105: document limitations of tc-flower rul=
e VLAN awareness
d7f9787a763f net: dsa: tag_8021q: add support for imprecise RX based on the=
 VBID
91495f21fcec net: dsa: tag_8021q: replace the SVL bridging with VLAN-unawar=
e IVL bridging
961d8b699070 net: dsa: felix: support FDB entries on offloaded LAG interfac=
es
e212fa7c5418 net: dsa: support FDB events on offloaded LAG interfaces
93c798230af5 net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
e35f12e993d4 net: dsa: remove "ds" and "port" from struct dsa_switchdev_eve=
nt_work
ec638740fce9 net: switchdev: remove lag_mod_cb from switchdev_handle_fdb_ev=
ent_to_device
dedd6a009f41 net: dsa: create a dsa_lag structure
b99dbdf00bc1 net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx=
_lag_sync_masks
3d4a0a2a46ab net: dsa: make LAG IDs one-based
066ce9779c7a net: dsa: qca8k: rename references to "lag" as "lag_dev"
e23eba722861 net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
46a76724e4c9 net: dsa: rename references to "lag" as "lag_dev"
b9e8b58fd2cb net: dsa: Include BR_PORT_LOCKED in the list of synced brport =
flags
a21d9a670d81 net: bridge: Add support for bridge port in locked mode
acd8df5880d7 net: switchdev: avoid infinite recursion from LAG to bridge wi=
th port object handler
342b6419193c net: dsa: fix panic when removing unoffloaded port from bridge
8940e6b669ca net: dsa: avoid call to __dev_set_promiscuity() while rtnl_mut=
ex isn't held
ba43b547515e net: lan966x: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
e42bd4ed09aa net: mscc: ocelot: keep traps in a list
85ea0daabe5a net: mscc: ocelot: avoid overlap in VCAP IS2 between PTP and M=
RP traps
b9bace6e534d net: mscc: ocelot: use a single VCAP filter for all MRP traps
36fac35b2907 net: mscc: ocelot: delete OCELOT_MRP_CPUQ
c518afec2883 net: mscc: ocelot: consolidate cookie allocation for private V=
CAP rules
e3c02b7c655c net: mscc: ocelot: use a consistent cookie for MRP traps
164f861bd40c net: dsa: offload bridge port VLANs on foreign interfaces
134ef2388e7f net: dsa: add explicit support for host bridge VLANs
c4076cdd21f8 net: switchdev: introduce switchdev_handle_port_obj_{add,del} =
for foreign interfaces
7b465f4cf39e net: switchdev: rename switchdev_lower_dev_find to switchdev_l=
ower_dev_find_rcu
b28d580e2939 net: bridge: switchdev: replay all VLAN groups
263029ae3172 net: bridge: make nbp_switchdev_unsync_objs() follow reverse o=
rder of sync()
8d23a54f5bee net: bridge: switchdev: differentiate new VLANs from changed o=
nes
27c5f74c7ba7 net: bridge: vlan: notify switchdev only when something change=
d
cab2cd770051 net: bridge: vlan: make __vlan_add_flags react only to PVID an=
d UNTAGGED
3116ad0696dd net: bridge: vlan: don't notify to switchdev master VLANs with=
out BRENTRY flag
b2bc58d41fde net: bridge: vlan: check early for lack of BRENTRY flag in br_=
vlan_add_existing
ef5764057540 net: mscc: ocelot: fix use-after-free in ocelot_vlan_del()
5454f5c28eca net: bridge: vlan: check for errors from __vlan_del in __vlan_=
flush
867b1db874c9 net: lan966x: Fix when CONFIG_IPV6 is not set
1da52b0e4724 net: lan966x: Fix when CONFIG_PTP_1588_CLOCK is compiled as mo=
dule
59085208e4a2 net: mscc: ocelot: fix all IP traffic getting trapped to CPU w=
ith PTP over IP
47aeea0d57e8 net: lan966x: Implement the callback SWITCHDEV_ATTR_ID_BRIDGE_=
MC_DISABLED
cddbec19466a net: dsa: qca8k: add tracking state of master port
e83d56537859 net: dsa: replay master state events in dsa_tree_{setup,teardo=
wn}_master
295ab96f478d net: dsa: provide switch operations for tracking the master st=
ate
a1ff94c2973c net: dsa: stop updating master MTU from master.c
77eecf25bd9d net: lan966x: Update extraction/injection for timestamping
735fec995b21 net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
d096459494a8 net: lan966x: Add support for ptp clocks
108dc8741c20 net: dsa: Avoid cross-chip syncing of VLAN filtering
381a730182f1 net: dsa: Move VLAN filtering syncing out of dsa_switch_bridge=
_leave
5cad43a52ee3 net: dsa: felix: add port fast age support
1b26d364e4e9 net: dsa: warn about dsa_port and dsa_switch bit fields being =
non atomic
63cfc65753d6 net: dsa: don't enumerate dsa_switch and dsa_port bit fields u=
sing commas
11fd667dac31 net: dsa: setup master before ports
1e3f407f3cac net: dsa: first set up shared ports, then non-shared ports
c146f9bc195a net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teard=
own}
a68dc7b938fb net: dsa: remove cross-chip support for HSR
cad69019f2f8 net: dsa: remove cross-chip support for MRP
4b026e82893b net: dsa: combine two holes in struct dsa_switch_tree
b035c88c6a30 net: dsa: move dsa_switch_tree :: ports and lags to first cach=
e line
258030acc93b net: dsa: make dsa_switch :: num_ports an unsigned int
7787ff776398 net: dsa: merge all bools of struct dsa_switch into a single u=
32
0625125877da net: dsa: move dsa_port :: type near dsa_port :: index
bde82f389af1 net: dsa: merge all bools of struct dsa_port into a single u8
b08db33dabd1 net: dsa: move dsa_port :: stp_state near dsa_port :: mac
7aacb894b1ad net: lan966x: Extend switchdev with mdb support
11b0a27772f5 net: lan966x: Add PGID_GP_START and PGID_GP_END
fc0c3fe7486f net: lan966x: Add function lan966x_mac_ip_learn()
0c94d657d2a4 net: lan966x: Fix the vlan used by host ports
2e49761e4fd1 net: lan966x: Add support for multiple bridge flags
811ba2771182 net: lan966x: Extend switchdev with fdb support
e14f72398df4 net: lan966x: Extend switchdev bridge flags
6d2c186afa5d net: lan966x: Add vlan support.
cf2f60897e92 net: lan966x: Add support to offload the forwarding.
571bb516a869 net: lan966x: Remove .ndo_change_rx_flags
25ee9561ec62 net: lan966x: More MAC table functionality
5ccd66e01cbe net: lan966x: add support for interrupts from analyzer
ef14049f4db9 net: lan966x: Add registers that are used for switch and vlan =
functionality
7f2973149c22 net: dsa: make tagging protocols connect to individual switche=
s from a tree
e2f01bfe1406 net: dsa: tag_sja1105: fix zeroization of ds->priv on tag prot=
o disconnect
b26980ab2a97 net: lan966x: Fix the configuration of the pcs
950a419d9de1 net: dsa: tag_sja1105: split sja1105_tagger_data into private =
and public sections
fcbf979a5b4b Revert "net: dsa: move sja1110_process_meta_tstamp inside the =
tagging protocol driver"
c79e84866d2a net: dsa: tag_sja1105: convert to tagger-owned data
22ee9f8e4011 net: dsa: sja1105: move ts_id from sja1105_tagger_data
bfcf14252220 net: dsa: sja1105: make dp->priv point directly to sja1105_tag=
ger_data
6f6770ab1ce2 net: dsa: sja1105: remove hwts_tx_en from tagger data
d38049bbe760 net: dsa: sja1105: bring deferred xmit implementation in line =
with ocelot-8021q
a3d74295d790 net: dsa: sja1105: let deferred packets time out when sent to =
ports going down
35d976802124 net: dsa: tag_ocelot: convert to tagger-owned data
dc452a471dba net: dsa: introduce tagger-owned storage for private and share=
d data
857fdd74fb38 net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}=
offload
b079922ba2ac net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_joi=
n
d3eed0e57d5d net: dsa: keep the bridge_dev and bridge_num as part of the sa=
me structure
6a43cba30340 net: dsa: export bridging offload helpers to drivers
936db8a2dba2 net: dsa: rename dsa_port_offloads_bridge to dsa_port_offloads=
_bridge_dev
41fb0cf1bced net: dsa: hide dp->bridge_dev and dp->bridge_num in drivers be=
hind helpers
36cbf39b5690 net: dsa: hide dp->bridge_dev and dp->bridge_num in the core b=
ehind helpers
65144067d360 net: dsa: mv88e6xxx: compute port vlan membership based on dp-=
>bridge_dev comparison
0493fa7927af net: dsa: mv88e6xxx: iterate using dsa_switch_for_each_user_po=
rt in mv88e6xxx_port_check_hw_vlan
872bb81dfbc3 net: dsa: mt7530: iterate using dsa_switch_for_each_user_port =
in bridging ops
947c8746e2c3 net: dsa: assign a bridge number even without TX forwarding of=
fload
3f9bb0301d50 net: dsa: make dp->bridge_num one-based
bb14bfc7eb92 net: lan966x: fix a IS_ERR() vs NULL check in lan966x_create_t=
argets()
cc9cf69eea48 net: lan966x: Fix builds for lan966x driver
a290cf692779 net: lan966x: Fix duplicate check in frame extraction
12c2d0a5b8e2 net: lan966x: add ethtool configuration and statistics
e18aba8941b4 net: lan966x: add mactable support
d28d6d2e37d1 net: lan966x: add port module support
db8bcaad5393 net: lan966x: add the basic lan966x driver
ef136837aaf6 net: dsa: rtl8365mb: set RGMII RX delay in steps of 0.3 ns
b014861d96a6 net: dsa: realtek-smi: don't log an error on EPROBE_DEFER
1e89ad864d03 net: dsa: realtek-smi: fix indirect reg access for ports>3
b3612ccdf284 net: dsa: microchip: implement multi-bridge support
96ca08c05838 net: mscc: ocelot: set up traps for PTP packets
ec15baec3272 net: ptp: add a definition for the UDP port for IEEE 1588 gene=
ral messages
95706be13b9f net: mscc: ocelot: create a function that replaces an existing=
 VCAP filter
8abe19703825 net: dsa: felix: enable cut-through forwarding between ports b=
y default
a8bd9fa5b527 net: ocelot: remove "bridge" argument from ocelot_get_bridge_f=
wd_mask
4636440f913b net: dsa: qca8k: Fix spelling mistake "Mismateched" -> "Mismat=
ched"
0898ca67b86e net: dsa: qca8k: fix warning in LAG feature
def975307c01 net: dsa: qca8k: add LAG support
2c1bdbc7e756 net: dsa: qca8k: add support for mirror mode
ba8f870dfa63 net: dsa: qca8k: add support for mdb_add/del
6a3bdc5209f4 net: dsa: qca8k: add set_ageing_time support
4592538bfb0d net: dsa: qca8k: add support for port fast aging
c126f118b330 net: dsa: qca8k: add additional MIB counter and make it dynami=
c
8b5f3f29a81a net: dsa: qca8k: initial conversion to regmap helper
36b8af12f424 net: dsa: qca8k: move regmap init in probe and set it mandator=
y
994c28b6f971 net: dsa: qca8k: remove extra mutex_init in qca8k_setup
90ae68bfc2ff net: dsa: qca8k: convert to GENMASK/FIELD_PREP/FIELD_GET
b9133f3ef5a2 net: dsa: qca8k: remove redundant check in parse_port_config
65258b9d8cde net: dsa: qca8k: fix MTU calculation
3b00a07c2443 net: dsa: qca8k: fix internal delay applied to the wrong PAD c=
onfig
a7e13edf37be net: dsa: felix: restrict psfp rules on ingress port
76c13ede7120 net: dsa: felix: use vcap policer to set flow meter for psfp
77043c37096d net: mscc: ocelot: use index to set vcap policer
23ae3a787771 net: dsa: felix: add stream gate settings for psfp
7d4b564d6add net: dsa: felix: support psfp filter on vsc9959
23e2c506ad6c net: mscc: ocelot: add gate and police action offload to PSFP
5b1918a54a91 net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
0568c3bf3f34 net: mscc: ocelot: add MAC table stream learn and lookup opera=
tions
02d6fdecb9c3 regmap: allow to define reg_update_bits for no bus configurati=
on
5f15d392dcb4 net: dsa: qca8k: make sure PAD0 MAC06 exchange is disabled
ae0393500e3b net: bridge: switchdev: fix shim definition for br_switchdev_m=
db_notify
326b212e9cd6 net: bridge: switchdev: consistent function naming
9776457c784f net: bridge: mdb: move all switchdev logic to br_switchdev.c
9ae9ff994b0e net: bridge: split out the switchdev portion of br_mdb_notify
4a6849e46173 net: bridge: move br_vlan_replay to br_switchdev.c
c5f6e5ebc2af net: bridge: provide shim definition for br_vlan_flags
716a30a97a52 net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
fab9eca88410 net: bridge: create a common function for populating switchdev=
 FDB entries
5cda5272a460 net: bridge: move br_fdb_replay inside br_switchdev.c
9574fb558044 net: bridge: reduce indentation level in fdb_create
f6814fdcfe1b net: bridge: rename br_fdb_insert to br_fdb_add_local
4731b6d6b257 net: bridge: rename fdb_insert to fdb_add_local
5f94a5e276ae net: bridge: remove fdb_insert forward declaration
4682048af0c8 net: bridge: remove fdb_notify forward declaration
425d19cedef8 net: dsa: stop calling dev_hold in dsa_slave_fdb_event
d7d0d423dbaa net: dsa: flush switchdev workqueue when leaving the bridge
0faf890fc519 net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
338a3a4745aa net: dsa: introduce locking for the address lists on CPU and D=
SA ports
cf231b436f7c net: dsa: lantiq_gswip: serialize access to the PCE registers
f7eb4a1c0864 net: dsa: b53: serialize access to the ARL table
edc90d15850c selftests: net: dsa: add a stress test for unlocked FDB operat=
ions
016748961ba5 selftests: lib: forwarding: allow tests to not require mz and =
jq
f239934cffe5 net: dsa: b53: serialize access to the ARL table
f2c4bdf62d76 net: mscc: ocelot: serialize access to the MAC table
1681ae1691ef net: dsa: sja1105: serialize access to the dynamic config inte=
rface
643979cf5ec4 net: dsa: sja1105: wait for dynamic config command completion =
on writes too
992e5cc7be8e net: dsa: tag_8021q: make dsa_8021q_{rx,tx}_vid take dp as arg=
ument
5068887a4fbe net: dsa: tag_sja1105: do not open-code dsa_switch_for_each_po=
rt
fac6abd5f132 net: dsa: convert cross-chip notifiers to iterate using dp
57d77986e742 net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
65c563a67755 net: dsa: do not open-code dsa_switch_for_each_port
d0004a020bb5 net: dsa: remove the "dsa_to_port in a loop" antipattern from =
the core
82b318983c51 net: dsa: introduce helpers for iterating through ports using =
dp
d4004422f6f9 net: mscc: ocelot: track the port pvid using a pointer
bfbab3104413 net: mscc: ocelot: add the local station MAC addresses in VID =
0
0da1a1c48911 net: mscc: ocelot: allow a config where all bridge VLANs are e=
gress-untagged
90e0aa8d108d net: mscc: ocelot: convert the VLAN masks to a list
62a22bcbd30e net: mscc: ocelot: add a type definition for REW_TAG_CFG_TAG_C=
FG
040e926f5813 net: dsa: qca8k: tidy for loop in setup and add cpu port check
9ca482a246f0 net: dsa: sja1105: parse {rx, tx}-internal-delay-ps properties=
 for RGMII delays
4af2950c50c8 net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-V=
C
1521d5adfc2b net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
9cb8edda2157 net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Ma=
kefile
7bbbbfaa7a1b ether: add EtherType for proprietary Realtek protocols
fd0bb28c547f net: dsa: qca8k: move port config to dedicated struct
cef08115846e net: dsa: qca8k: set internal delay also for sgmii
f477d1c8bdbe net: dsa: qca8k: add support for QCA8328
ed7988d77fbf dt-bindings: net: dsa: qca8k: document support for qca8328
362bb238d8bf net: dsa: qca8k: add support for pws config reg
924087c5c3d4 dt-bindings: net: dsa: qca8k: Document qca,led-open-drain bind=
ing
bbc4799e8bb6 net: dsa: qca8k: add explicit SGMII PLL enable
13ad5ccc093f dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
5654ec78dd7e net: dsa: qca8k: rework rgmii delay logic and scan for cpu por=
t 6
3fcf734aa482 net: dsa: qca8k: add support for cpu port 6
731d613338ec dt-bindings: net: dsa: qca8k: Document support for CPU port 6
6c43809bf1be net: dsa: qca8k: add support for sgmii falling edge
fdbf35df9c09 dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
d8b6f5bae6d3 dsa: qca8k: add mac_power_sel support
39e222bfd7f3 net: dsa: unregister cross-chip notifier after ds->ops->teardo=
wn
339e75f6b9a0 net: dsa: rtl8366rb: remove unneeded semicolon
e674cfd08537 net: dsa: rtl8366rb: Support setting STP state
1fbd19e10b73 net: dsa: rtl8366rb: Support fast aging
56d8bb71a811 net: dsa: rtl8366rb: Support disabling learning
5ca721c54d86 net: dsa: tag_ocelot: set the classified VLAN during xmit
e8c0722927e8 net: mscc: ocelot: write full VLAN TCI in the injection header
de5bbb6f7e4c net: mscc: ocelot: support egress VLAN rewriting via VCAP ES0
55b115c7ecd9 net: dsa: rtl8366rb: Use core filtering tracking
d310b14ae748 net: dsa: rtl8366: Drop and depromote pointless prints
a4eff910ec63 net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
7776e33c68ae net: dsa: rtl8366: Drop custom VLAN set-up
d5a680295be2 net: dsa: rtl8366rb: Support bridge offloading
bd936bd53b2d net: dsa: Move devlink registration to be last devlink command
6d709cadfde6 net: dsa: move sja1110_process_meta_tstamp inside the tagging =
protocol driver
68a81bb2eebd net: dsa: sja1105: remove sp->dp
db4278c55fa5 devlink: Make devlink_register to be void
4dcd183fbd67 net: wwan: iosm: devlink registration

There are 2 conflicts expected during merging this patch set due to net
<-> net-next overlaps at the time. One is in include/linux/dsa/sja1105.h
and the other is in net/dsa/dsa2.c. See the resolutions in my git tree
and make sure to enable git rerere so that you don't have to redo them
every time you recreate the branch.

For sorting a list of commits chronologically, I have this:

$ cat ~/bin/git-sort-commit-list
#!/bin/bash

set -e -u -o pipefail

error() {
	local lineno=3D"$1"
	local code=3D"${2:-1}"

	echo "Error on line ${lineno}; status ${code}."
	exit "${code}"
}
trap 'error ${LINENO}' ERR

usage() {
	echo "Usage:"
	echo "$0 --commit-file <file> --oldest-commit <ref> --newest-commit <ref>"
	exit
}

argc=3D$#
argv=3D( "$@" )

if [ $argc -lt 6 ]; then
	usage
fi

cmd=3D"cat"

i=3D0
while [ $i -lt $argc ]; do
	key=3D"${argv[$i]}"
	i=3D$((i + 1))
	case "$key" in
	-c|--commit-file)
		file=3D"${argv[$i]}"
		i=3D$((i + 1))
		;;
	-n|--newest-commit)
		newest=3D"${argv[$i]}"
		i=3D$((i + 1))
		;;
	-o|--oldest-commit)
		oldest=3D"${argv[$i]}"
		i=3D$((i + 1))
		;;
	*)
		usage
		;;
	esac
done

for rev in $(git rev-list "$newest" ^"$oldest"); do
	match=3D"$(grep $(echo ${rev} | head -c 12) ${file} | uniq || :)"
	if [ -n "${match}" ]; then
		echo ${match}
	fi
done

The other script is for the backporting itself:

[tigrisor@skbuf /opt/linux] $ cat ~/bin/git-backport
#!/bin/bash

set -e -u -o pipefail

error() {
	local lineno=3D"$1"
	local code=3D"${2:-1}"

	echo "Error on line ${lineno}; status ${code}."
	exit "${code}"
}
trap 'error ${LINENO}' ERR

usage() {
	echo "Usage:"
	echo "$0 --commit-file <file> --base-branch <ref> --branch-name <string> [=
--reverse]"
	exit
}

argc=3D$#
argv=3D( "$@" )

if [ $argc -lt 6 ]; then
	usage
fi

cmd=3D"cat"

i=3D0
while [ $i -lt $argc ]; do
	key=3D"${argv[$i]}"
	i=3D$((i + 1))
	case "$key" in
	-c|--commit-file)
		file=3D"${argv[$i]}"
		i=3D$((i + 1))
		;;
	-b|--branch-name)
		branch_name=3D"${argv[$i]}"
		i=3D$((i + 1))
		;;
	-B|--base-branch)
		base_branch=3D"${argv[$i]}"
		i=3D$((i + 1))
		;;
	-r|--reverse)
		cmd=3D"tac"
		i=3D$((i + 1))
		;;
	*)
		usage
		;;
	esac
done

git checkout -B "${branch_name}"
git reset --hard "${base_branch}"
GIT_SEQUENCE_EDITOR=3D"${cmd} ${file} | awk '{ print \"pick \" \$0; }' >" \
	git rebase -i --rerere-autoupdate "${base_branch}"

I run it using:

$ git-backport --commit-file stable-commits.txt --base-branch linux-5.15.y =
--branch-name dsa-5.15.y --reverse

You can add commits to the commit list pretty much anywhere, and run the so=
rting script afterwards:

$ git sort-commit-list --commit-file stable-commits.txt --oldest-commit v5.=
15 --newest-commit 5dc760d12082 | tee stable-commits-sorted.txt

You'll probably need to add more, and rebase onto a different base branch f=
or OpenWRT. Nonetheless, it should be a valid start.
Have fun and let me know if you have something useful to share back!=
