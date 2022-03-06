Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA85D4CED8A
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 20:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiCFTu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 14:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiCFTuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 14:50:23 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4920B286FC
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 11:49:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3/yMFl0YHg9kCJZMH6VlJNY/NoFnijC3j3y+frfNkAMzbFkBByKEpQtln0ZNhoTD386OmgG19CDuYCiNjPzXJtrB3/Np5SUpqeQvaMZOY02FRyf8iTOXAi2KCM9vo/MEgmvpj16UfNvklUxFuUV1TymcLHyxZw6y8EVLEwD2XtlIPjg4rzsrzQbzSqhC0aCc6hb2htFifzUpBaXrNOmIlxqLWgUxACJ49avw5yjgnezC2+mRgRL8DZIK1pkVrKkdSyZMXmN5ZspsJZ0AXFdQxUMUcJiRHvdeqfZ7IuOIsw6Zk9/dDqNtR7wiM4zvvedUIsHQJe1py+/50Nxqb3Fxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KG1nqa64OaUn4OrkkQkk12JKQkt0wlu7WoaA3AVgipo=;
 b=LDNXcGOY6w+hhZbbtyvqcnq4U8rDTpk0ULn5L6CBhSgZ5XiboXtviw0dV4wmi+wsVwTnPM/Afr32YrybNk2rRdn0jRoe0Rxxf36yVfllnkpfP5A0qbtS3Z009kVAIeOMBpUTC8RF0iCH/yyPSeu4LVXt9Rh+yQJ7AMfMWkeHksyXpwXLVfq6jVSkVl8C3+uHMwIc0k61jqJvY65khIxpBIGoRW+oIJZk1NN4ojY5p+s+PZCkUI0qpt+qGJhatCK4eF3rbpJmtpchhGMjCi2UEqrk2nxWAZPHMii/19pZvFkBb864y5KFZt5jhvU+8H+eN4FrpwSCOHg2wHqARF4xew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KG1nqa64OaUn4OrkkQkk12JKQkt0wlu7WoaA3AVgipo=;
 b=ftlUzCq6b4T/CZsaNr8L27bhmayKFzJ/4LIFHT/GwKtykE+PYq2ufEt5NlpmetUoDi5yN76VPpQ0k2JFWxDwPSjpzY8WvVpSScWz/XeUjtv5GwDBV9i1wHh49uqCo8Y0g8M9QYmL2NFmuLtPXASP3RoyEEczg05GLaukKVHaguQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6375.eurprd04.prod.outlook.com (2603:10a6:20b:f6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sun, 6 Mar
 2022 19:49:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 19:49:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Tobias Waldekranz <tobias@waldekranz.com>,
        netdev <netdev@vger.kernel.org>,
        "emeric.dupont@zii.aero" <emeric.dupont@zii.aero>
Subject: Re: Regression with improved multi chip isolation
Thread-Topic: Regression with improved multi chip isolation
Thread-Index: AQHYMY6FEYmKllMH+0Wl8t71qS9nN6yyw3QA
Date:   Sun, 6 Mar 2022 19:49:26 +0000
Message-ID: <20220306194926.hx7kcivrrssnq7qz@skbuf>
References: <YiUIQupDTGwgHE4K@lunn.ch>
In-Reply-To: <YiUIQupDTGwgHE4K@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4f4072b-3678-4837-d0f1-08d9ffaa6c03
x-ms-traffictypediagnostic: AM6PR04MB6375:EE_
x-microsoft-antispam-prvs: <AM6PR04MB6375534E3750F48DC4DAD4E6E0079@AM6PR04MB6375.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AcgZCv4NT67rDhZcjWctwfAL9s1Kr6rfWGfvKH+Tf2DAQClraPfblJ8gM/0OzbSAadds5QyrZ15S0a4nMrY2tf4LYgEiJ+6SRY7Iuwx8arK19GuBqDVFgx5XRCo15LEYtk3xOaf8FRS4YlB8QjCfZka68kRScKbEwzFu2L9Ne7a9b/BOfjnkAIdqzKUGfdvym2gvhNMPZkXtF8TwgtRatMkJS602cQYi42ll70Oob6EkSQKWGC4qfoDYgUD62JK9pN7N13EG7Mz9GyDNJwraA/t1Nulhnbw6cl+lg9FhTuOJ7ONvwHvMfpNBP5fYv0flYJ8qkxqvh7vkoEeNSwGzdp1SiYz5gowbyAbT8ZAiChs2vhvdgCCkx1McfpmkIe8W1ORJ5NxN7trhrXc9KLv9xGJsIAxBSWUXRs+s/lMqn1SBHfeGvrqVKLRrBjS2/U06HqiU4o0wH95EmJH0fFMv/L3hR8XjmCRSa5LS4xG0wWcPssP77vOddFa+eBPB+aiDC3U3fp+0tgPvtQ8RVbxOSl1X6I+OpiqXvWX1c+3p3n2Kn7h9YhR8qKZ9ak5v3XTFZ5JBpoS392QfKFWtSfjF85JzEHdND7Rzk0QWEceXrU5EqCtc2FgYARMEq5XWkUALVJLCIwqPAjyorN/9BTIfhaeItwjgJEQbRkvlnejcXJqY9ufYH7zXLq5842wwd3VsDEjPBULGABeRalytNaXdUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(26005)(1076003)(186003)(4326008)(38070700005)(2906002)(38100700002)(498600001)(66556008)(54906003)(6486002)(64756008)(6916009)(8676002)(66476007)(66446008)(91956017)(122000001)(66946007)(76116006)(71200400001)(6512007)(33716001)(44832011)(8936002)(9686003)(86362001)(5660300002)(6506007)(83380400001)(66574015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0W80d2BavAcDmobsqu/fhGOeuulSnwDwd/tZ1i96MJQO5NXJTT/pVkgE769U?=
 =?us-ascii?Q?F9LFVJwUtmlprfeeHJ9w4LYSkJunRfRsCoHdeHjiD8tf0VRx51lpuzS9JE1W?=
 =?us-ascii?Q?Qkhi+P7l2rwToYTho1aaGhmLKfg7Im1gBDiMeCu97xCS0Ki1jbjfu+RR57Qu?=
 =?us-ascii?Q?sKNL/uMgzbtmSMZOmopsy/sQu97IMNYUzLQEqj1zvzoREi6SneYF/sDB8uhM?=
 =?us-ascii?Q?nNWA6JR/TuV9AySNauDse2A5soPeJiKEsunh1bnCV/y/COlyAKTbvQ5ulcEO?=
 =?us-ascii?Q?1BMybYdeMhm34vf3cALJDTjW+zPJ/+jJyg7n9224rrGz0a5nV1+TodlagCS2?=
 =?us-ascii?Q?a3CL3fGizVkA3WC8LLw/LSQfNBmomg/UBkCIopiun6akYuhMU9jaRmh4hik5?=
 =?us-ascii?Q?kDgbVSSoxXJ85NddZBgS6MX9B4jFcTxWyrN5e3lARmrLBnVRn4ZVYU3k9KCp?=
 =?us-ascii?Q?KwRJEb4VbCA/XqN3KPtDt7sUjg0EMC+/RAbDyt1Y3ritWJf7G3OkIkeV+kzp?=
 =?us-ascii?Q?RUmciokPb9vbacyGiZFpehUqBAB4Ta7v1ANg15MoYpkxUybEwvq9Ee4xKzki?=
 =?us-ascii?Q?WBQ3TgEBSQrISoxZTwm2PVkEDLl338oxzdVpX/j376r+erIdyhTpJSeIx4U0?=
 =?us-ascii?Q?RxDzViRhWelnXn81bylBvcfRKl/X2lNVFfsI3rivNyqKcYlP1NxaeHNgB3QT?=
 =?us-ascii?Q?j/VTqPQriTkvARk/onwZGZ0xYfl2ThUH3/utk+jAn0q0qt8L4Q6Ofji2USA+?=
 =?us-ascii?Q?ZGMTIlWq0o/b3TnaWk8xcQOdD+r/AXdr9XyzurjUI4HrfVBe7xQSWTuaedfu?=
 =?us-ascii?Q?1iUKwmzdP31K7YzQxO6KZzukYYBIuuTj8pwhyXMq4EcCY7iedyl4+7dpVt9g?=
 =?us-ascii?Q?+1Izh8HNjx1VQKXsIQnpP6oARr5JlLZN0CCcnFhYz6VFvGmdsWsFJbYoWokK?=
 =?us-ascii?Q?PJ2bKzQUNgfiq4rnvu9C7W7VHM6nXR73nej2erWmHlzhEhv8zk5lLCvvxHic?=
 =?us-ascii?Q?JeqYP/FsUOJsC8AG+cIOQdQMbHlZB5GXzTSAk0WGZ5YPrefmlE5sPJLnabpN?=
 =?us-ascii?Q?HvuhxaKoQijMOCjSx9ocaRqIKpp3ts82ywQsZqqB3zib1pLx8zaw/THZLNvd?=
 =?us-ascii?Q?cd/pJ/WrRhSvop3jw1oeaD/ufMxOj6RTK1gMebqfIeSFsZG1TX90jJu9R0up?=
 =?us-ascii?Q?H4OHDfcgZs24lJPU3xR1xezK4AtwgrgjwOMRcgkbbUTltpTHWm4NVwq9viTl?=
 =?us-ascii?Q?p3ts7mOAZKRXFzxSw+IfhZ39ONonqyz7MO+oI8sZkdukpzK5ljhvBtoEBdDd?=
 =?us-ascii?Q?lwS2xitoW7iPkLfqaPX/aUNLQPOOAIjSeRm7thsFMv04flQoCJC8rlc+Us4r?=
 =?us-ascii?Q?4KY4hlcTMogWw6FVQofTQWAVUuUfKq03riRTuQW4BjXiLO/wn8rCF6l2G0f2?=
 =?us-ascii?Q?pzAwl0utq0A47qdBTZ0BG4wXICihkKb+GmzCKdrfuk0CUgSmvCt6YE4L2uVE?=
 =?us-ascii?Q?hth2zFytPa+CmMFfsTUUBM/rHbBpOnBSrG2UcwnKlzCwTc7fc7XVOJBzuElO?=
 =?us-ascii?Q?p0G+nER/ZbJ96ZcOX4qjLw3BWedc1eNE57n3kRS/R9s4AIkVXBAHDZPj/rM4?=
 =?us-ascii?Q?J7hBC2Xrxnd+qS0AZBBOaSk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A9CFB18C589A354BBC0ECF5153CDCFB8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f4072b-3678-4837-d0f1-08d9ffaa6c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2022 19:49:26.7130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EHIVYY28RGU35Tmvs33BBnzojjA7CErrX5oXXFBEKA2vzC8c9DTTGMT3oGatzhJwJ1prWbdym3W4r7HfXLpHng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6375
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 08:15:14PM +0100, Andrew Lunn wrote:
> Hi Tobias
>
> I just found a regression with:
>
> d352b20f4174a6bd998992329b773ab513232880 is the first bad commit
> commit d352b20f4174a6bd998992329b773ab513232880
> Author: Tobias Waldekranz <tobias@waldekranz.com>
> Date:   Thu Feb 3 11:16:56 2022 +0100
>
>     net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
>
>     Given that standalone ports are now configured to bypass the ATU and
>     forward all frames towards the upstream port, extend the ATU bypass t=
o
>     multichip systems.
>
>
> I have a ZII devel B setup:
>
> brctl addbr br0
> brctl addif br0 lan0
> brctl addif br0 lan1
>
> ip link set br0 up
> ip link set lan0 up
> ip link set lan1 up
>
> ip link add link br0 name br0.11 type vlan id 11
> ip link set br0.11 up
> ip addr add 10.42.11.1/24 dev br0.11
>
> Has it happens, lan0 has link, and i run tcpdump on the link peer. lan1
> does not have link.
>
> I then ping 10.42.11.2.
>
> I found that the ARP Request who-has 10.42.11.2 tell 10.42.11.1 are
> getting dropped. I also see:
>
>      p06_sw_in_filtered: 122
>      p06_sw_out_filtered: 90
>      p06_atu_member_violation: 0
>      p06_atu_miss_violation: 0
>      p06_atu_full_violation: 0
>      p06_vtu_member_violation: 0
>      p06_vtu_miss_violation: 121
>
> port 6 is the CPU port. Both p06_vtu_miss_violation and
> p06_sw_in_filtered are incrementing with each ARP Request broadcast
> from the host.
>
> The bridge should be vlan unaware, vlan_filtering is 0.
>
> $ ip -d link show br0
> 16: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state U=
P mode
> DEFAULT group default qlen 1000
>     link/ether 8e:22:a0:47:66:f9 brd ff:ff:ff:ff:ff:ff promiscuity 0
>     bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 300=
00 stp_
> state 0 priority 32768 vlan_filtering 0 bridge_id 8000.8e:22:a0:47:66:f9 =
designa
> ted_root 8000.8e:22:a0:47:66:f9 root_port 0 root_path_cost 0 topology_cha=
nge 0 t
> opology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_=
change_
> timer    0.00 gc_timer  295.16 group_fwd_mask 0 group_address 01:80:c2:00=
:00:00
> mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 =
mcast_h
> ash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_sta=
rtup_qu
> ery_count 2 mcast_last_member_interval 100 mcast_membership_interval 2600=
0 mcast
> _querier_interval 25500 mcast_query_interval 12500 mcast_query_response_i=
nterval
>  1000 mcast_startup_query_interval 3125 addrgenmode eui64 numtxqueues 1 g=
so_max_
> size 65536 gso_max_segs 65535

This example of injecting traffic through br0.11 is interesting because
I think that Tobias' patch merely exposes a shortcoming of tag_dsa.c.
The tagger should inject packets into the switch in VLAN 4095
(MV88E6XXX_VID_BRIDGED), because the ports offload a VLAN-unaware bridge.
Yet my guess is that it probably does so in VID 11 - this can be seen
using tcpdump and analyzing the DSA header. Hence the problem. Tobias' patc=
h
basically enables 802.1Q secure mode on DSA and CPU ports, so any VLAN
that is absent from the VTU (here 11) will be dropped.
Sadly I am not at my desk right now so I can't work on a patch or test
one, but if I'm right, I'd go in the direction of refactoring
dsa_xmit_ll() such that it considers "skb->protocol =3D=3D htons(ETH_P_8021=
Q)"
only while the port is under a VLAN-aware bridge. Hopefully this makes
some sense.=
