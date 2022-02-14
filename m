Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CA74B4FA6
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 13:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352629AbiBNME6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 07:04:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352539AbiBNMEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 07:04:55 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2060.outbound.protection.outlook.com [40.107.21.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857BF2AE9
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 04:04:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOMTCqzThRH4An1TY5qxarPT/IRPY4QrhCE05jBNmjoL6zzKHJMa7TEHoLw2c6fbYWhVCIvdx8cSVIUFzrFY4Dz8pvxru532z577E7TitHb26/yr83iZrIQEEXmUsdg18XWqZ3JGG+hspX+W98TVlezaQP3rFxFfnqVQFs8QUNUROpr1PKhyocdzoniBUUK/iU7HbW5EOdq/kzdbCg1sIw7Bx2edWa1IPiEKK/BumMzwFt6qgpJKx4vmyIQSoKAkNAJSv5aw2OksgchbGJE7Yq4yn4UfE8h3yxt+KbEENaDXAGNESNgfNN6evFdvDOom6y065F/8NoOFNVHJolps3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Wp7ujgyp8UgSuOfv4025lFWprCxyT2dlr25qHjDidA=;
 b=DbW/qiEOnOLRUGFar3Ixfxe151IBCZKsLF89uu9FNe8FxyIRSH3kxo+crJU3W84VBUO4lDwZ8sVlSpzwwKzzfLNhyYzjO16pbkQZZ94gSmdJWqleZvKDX8IO/yBpqE0ILo1tVYQSjTT+n0IRcA6x28phsZUf88pNFZZeCc/bEKvzagkjtR91YnN7sgAMByaxh33MKB3AP1vM91V00ZUsPovUO1GNqevWgf6D6sY7QHYroCFsuS3ukzjHs39Y7HIuHp6dn4q8v+fUTPDVdFy109z7OwBGxXriJ0wwGfM5+Ld6TNPCg0dWADKT3xrlG10ig79m/ADYJT9R49UdIzQQUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Wp7ujgyp8UgSuOfv4025lFWprCxyT2dlr25qHjDidA=;
 b=j0KNl2R+NAPnZcQmWfOdz4eH+/CF15n+Ct9AclM018buuxM8KLIb8zlXqyxXhq5yEWNfX6CwsYiGco81PXItE8lQwLmO6ioKr1/JiOVYhipHckktEWskpu9wL3wE4hczmCiiLDSU/KASVIaNhBeBckJyn+IGr89pLSVp8dGQoFw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3776.eurprd04.prod.outlook.com (2603:10a6:803:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 12:04:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 12:04:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Topic: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Index: AQHYHfxXQePXs1M3lEOTgYyrlnmZbayR2mIAgAATBoCAANrDAIAADtgAgAACXYCAAAW4gIAABAGAgAAIB4CAAA7ugA==
Date:   Mon, 14 Feb 2022 12:04:28 +0000
Message-ID: <20220214120427.gngyotzetmj6b3c2@skbuf>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
 <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com> <Ygon5v7r0nerBxG7@shredder>
 <20220214100729.hmnsvwkmp4kmpqwt@skbuf>
 <fb06ccb9-63ab-04ff-4016-00aae3b0482e@nvidia.com>
 <20220214104217.5asztbbep4utqllh@skbuf>
 <bee3d33c-1c66-2234-2be2-f0a279bafc42@nvidia.com>
In-Reply-To: <bee3d33c-1c66-2234-2be2-f0a279bafc42@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e93af9d4-0cfc-43d9-3901-08d9efb226ba
x-ms-traffictypediagnostic: VI1PR0402MB3776:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB377671E7CCD798DB75DEE922E0339@VI1PR0402MB3776.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l32jELWF9PMfqcWSnvYPGUFt090QCkd4jZHO43LH54PMw8cjR1Etr0Q/m/xIyXI/nXUSWBKtT3SOLXYp7G+z7EwPMrH8/upx+YZh9vsaKKnAQPmXfm6kFpf4yTrkm5+ZkJBxJDr8paggB9i6TyaMk1Vy5r7A+1/yTY/cKcwU9Cup3Mzo87Lj3l9gWVRnmliag6I17KQswFvu8vob6wHTQ8d5p385zrHikrZDOj+jJjB33DuAKWH/a/vNKD/XJC5QcB4wyVPRoBIORY0LQCnmk+tO5HZ1EwC9tFZyo+BgZB9RvlhNFPJXcjXIYWDq07WTQ9FKXs/IqGT1cyd159F9u3OStpYKeIy+a4a+sNOxWHjAruFcA+8yeVummZwdrkdOHjXUxz+Q3YXI6364NfnL69H0/WhgDnvIqRrIhy09GO7REP0gDhi1lnrd1bcIkJM+A4YCaXAB5ARY/ZnEDu5K5GVotSZKpL4H6DvbNbpxZ9fonMuagR5ban80x8AdcPV75ieGijimrUQKiPoRUk5ezkmiVW70enLXBV/EBO1MVPrwb8A96frc9xXB7EGa11NBYfMTC6hvWYB8ZL6wxtsCYhJQalwoi1oOcZX24E1Vy8HZTEvPqduRaD3Kjh7frASfqbzZw65tqeLGyiIBwnW+DhfW2WOtvO8jWY1JMiQrMcvGsvctcsopDhLsbpDXVcMcxzbhwIJFH83vbCUKvGT8xA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(122000001)(83380400001)(1076003)(7416002)(71200400001)(53546011)(186003)(26005)(38100700002)(54906003)(64756008)(66946007)(66556008)(66476007)(66446008)(6506007)(508600001)(9686003)(6512007)(316002)(6916009)(76116006)(91956017)(5660300002)(44832011)(86362001)(33716001)(8936002)(38070700005)(2906002)(8676002)(4326008)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hMaGZzaFi4BMjn80+5ApwoYWAYf2Sd1++6txkrlYOm352Wuf3QMY/WC3jihS?=
 =?us-ascii?Q?cihVjynEL0Ok/0maH9t7mX8KSgz12b9/l/LmjG5hgBkmzTfkpGVPtE7GUPp/?=
 =?us-ascii?Q?Lqf1GkF5P8T/vrOs+VP+HSnzIB9Me+e7lY8Lc5F6dGAU/C+lmnqLDQxNs951?=
 =?us-ascii?Q?UqAtT4KmkZsgH2msFPSFsEg8FaGlst3iFk7qOIGo1d31X41kxh6Lz2J5PkGq?=
 =?us-ascii?Q?/5JPoTsWT/J3Byu3rKjTR+SGGb6Rx/890Ijuu8CiaT7tKOCDN3gUsGNfEaAA?=
 =?us-ascii?Q?vj4S+rarOURMJI7wW23Mkh6HV222cxujJKgMLxXrEemvEq8yWFCBaPS1DnaR?=
 =?us-ascii?Q?dd7gyS+3YU9TSSqPKlHAxfAbkuKTXc4j6qj/rWN5+MCwZRlNB5E2PC4+wo2V?=
 =?us-ascii?Q?5w/4fJ60nuZz4/cJ4ehd18gG72CXk+V01knukoCc8YZKHB/7gyVIi0cKssAh?=
 =?us-ascii?Q?7yOYW8ENc+tFR9CRAUGCfAEFaG0mBdOvngCxzjFlndDCAsH3X9PetqZ9sX7t?=
 =?us-ascii?Q?x4gxT6DWpv+iBHXuAtKn+mHF7rV6C6DbOsbkvF1mknYrH1a5aTAi6rtuzscr?=
 =?us-ascii?Q?HpOjc0ekM9xO4JpovkbVynmLDCg9EJOuWQevypTM2AugyfmdW9+TLH8hKCtA?=
 =?us-ascii?Q?EKi0RGY1ZdlNUaVX5exE4N7Zhc08t0vbcCH9YJ64BViPfE157SxOLcRdWuGl?=
 =?us-ascii?Q?UvtjVOCGtCi1+YN9cKXPBg3o5YTlw8PMzqi5q5R8x3NWiyKLMCQhpc+bNgO4?=
 =?us-ascii?Q?y16BL4oWIXQvOupfx75kI6xXxqTB5UYsqyXGDAoBgTnr4+t65NzBUwQmpRIg?=
 =?us-ascii?Q?SwICLirDt1yTkZiuSCX77GD91N0DVykOu6sO+faKlw43mW0IDkj+KwTzFQEs?=
 =?us-ascii?Q?d/8lRYGUWuTkzw9j6AKDeU135N5eFzb10eVNfzGw7hWb3BQ1FzZ2UQsUvSDo?=
 =?us-ascii?Q?VufZbGcDOwQjbrsRNAnjwZJtA3QQkSNfktFgk/+uRzMuqdWSFG4LkjzciOnC?=
 =?us-ascii?Q?X2jZZHtZ46AWEtHGXquQW9irNPdBHvS3kuGm9KDlLjSTnM6BAAGLwWLuw6hL?=
 =?us-ascii?Q?zFM4htyUhr4yMjRxRm349i/RtBDhJK8RRmjTU9b4DWEUMnG3Ofj/TcV6LBK8?=
 =?us-ascii?Q?ZSArIUw8XGGaHmFMQ3yfz6Gysa5zaQ4Y9F6LoSfnMp5pBEiuvzZ00h3dp44x?=
 =?us-ascii?Q?8J8IxF+686i/xBqw7wovGxavh+ZchtrtElsEb65fCYd2UC6y5WQ+iz2P+nMq?=
 =?us-ascii?Q?08dCPzZjjOqVWXrnt8yqQR+Sp4756a+PBDEDy/C/N8jWahrjvGFcOPlE8iIc?=
 =?us-ascii?Q?/28ZnN0a+ahnHJeLjgSnvav2nPJTyyjAoG3oqC9Kr6jM/zr42Kzl91srSZMf?=
 =?us-ascii?Q?CAd7xubT2Aku0bdvy+N/x8lhYTSkPZRJ3tuG4u8qPBDWciSUqw5HfuFmaHTs?=
 =?us-ascii?Q?KmzGnd/R0C7Fe5Cq2lPe9oy0chHBSqJcwLhtc2d2t66m+vARmPcf1Qqhqxa9?=
 =?us-ascii?Q?GiB18Gw+nvdjXYIkU/kO5Z1rhRZhm6uZd/pWR0HL/qgp0pBFHFekcA0bViy/?=
 =?us-ascii?Q?CeMIn2U6Sqo/AvdA9PiP9l1UkLCWWRH8TXgqBzY23e8wPShPjBAkQ616pZh5?=
 =?us-ascii?Q?ge3gua24AYnmuUxwgyqrEVg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B53C4273F91ED4B87E91FEFA2F95EF3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93af9d4-0cfc-43d9-3901-08d9efb226ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 12:04:28.1497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5C5YrHUbxHJzwSorhl2zwlE+vH2ZZZ8mU4oyP3NHkWcUTQTJ17q3KRilV3M41GTbxU6fsVxZN4UvffraKsahYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3776
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 01:11:01PM +0200, Nikolay Aleksandrov wrote:
> On 14/02/2022 12:42, Vladimir Oltean wrote:
> > On Mon, Feb 14, 2022 at 12:27:57PM +0200, Nikolay Aleksandrov wrote:
> >> On 14/02/2022 12:07, Vladimir Oltean wrote:
> >>> On Mon, Feb 14, 2022 at 11:59:02AM +0200, Ido Schimmel wrote:
> >>>> Sounds good to me as well. I assume it means patches #1 and #2 will =
be
> >>>> changed to make use of this flag and patch #3 will be dropped?
> >>>
> >>> Not quite. Patches 1 and 2 will be kept as-is, since fundamentally,
> >>> their goal is to eliminate a useless SWITCHDEV_PORT_OBJ_ADD event whe=
n
> >>> really nothing has changed (flags =3D=3D old_flags, no brentry was cr=
eated).
> >>>
> >>
> >> I don't think that's needed, a two-line change like
> >> "vlan_already_exists =3D=3D true && old_flags =3D=3D flags then do not=
hing"
> >> would do the trick in DSA for all drivers and avoid the churn of these=
 patches.
> >> It will also keep the order of the events consistent with (most of) th=
e rest
> >> of the bridge. I'd prefer the simpler change which avoids config rever=
ts than
> >> these two patches.
> >=20
> > I understand you prefer the simpler change which avoids reverting the
> > struct net_bridge_vlan on error, but "vlan_already_exists =3D=3D true &=
&
> > old_flags =3D=3D flags then do nothing" is not possible in DSA, because=
 DSA
> > does not know "old_flags" unless we also pass that via
> > struct switchdev_obj_port_vlan. If we do that, I don't have much of an
> > objection, but it still seems cleaner to me if the bridge didn't notify
> > switchdev at all when it has nothing to say.
> >=20
> > Or where do you mean to place the two-line change?
>=20
> You mention a couple of times in both patches that you'd like to add dsa
> vlan refcounting infra similar to dsa's host fdb and mdb. So I assumed th=
at involves
> keeping track of vlan entries in dsa? If so, then I thought you'd record =
the old flags there.
>=20
> Alternatively I don't mind passing old flags if you don't intend on keepi=
ng
> vlan information in dsa, it's uglier but it will avoid the reverts which =
will
> also avoid additional notifications when these cases are hit. It makes se=
nse
> to have both old flags and new flags if the switchdev checks are done pre=
-config
> change so it can veto any transitions it can't handle for some reason.
>=20
> A third option is to do the flags check in the bridge and avoid doing the
> switchdev call (e.g. in br_switchdev_port_vlan_ calls), that should avoid
> the reverts as well.
>=20
> If you intend to add vlan refcounting in dsa, then I'd go with just keepi=
ng track
> of the flags, you'll have vlan state anyway, otherwise it's up to you. I'=
m ok
> with both options for old flags.=20

I understand it can be confusing why DSA needs to keep VLAN refcounting
yet it doesn't keep track of flags, so let me explain.

First thing to mention is that VLAN flags on CPU and DSA (cascade) ports
don't make much sense at the level of the DSA core. These ports are
really pipes that transport packets between switches and between the
switch and the CPU, so 'pvid' and 'untagged' don't really make sense.
An unwritten convention is for DSA hardware drivers to program the CPU
and DSA ports such that the VLAN information is unmodified w.r.t. how it
was/will be on the wire. The only important aspect about VLAN on DSA and
CPU ports is the VID membership list.

This isn't the major reason, though, so secondly, I need to introduce a top=
ology.

               eth0                                           eth1
           (DSA master)                                (foreign interface)
                |
                |
                | CPU port (no netdev)
        +----------------+
        |     sw0p0      |
        |                |
        |    Switch 0    |
        |                |
        | sw0p0   sw0p1  |
        +----------------+
            |       | DSA/cascade port (no netdev)
            |       |
            |       |
            |       | DSA/cascade port (no netdev)
            |    +--------------+
            |    | sw1p0        |
            |    |              |
            |    |   Switch 1   |
            |    |              |
            |    |sw1p1  sw1p2  |
            |    +--------------+
 user port  |       |      |
(has netdev)   user port  user port

-----------------------------------------------------------

Example 1: you want forwarding in VLAN 100 between sw0p0, sw1p1 and
sw1p2, so you issue these commands:

ip link add br0 type bridge vlan_filtering 1
ip link set sw0p0 master br0 && bridge vlan add dev sw0p0 vid 100
ip link set sw1p1 master br0 && bridge vlan add dev sw1p1 vid 100
ip link set sw1p2 master br0 && bridge vlan add dev sw1p2 vid 100

DSA must figure out that the sw0p1 and sw1p0 (the cascade ports
interconnecting the 2 switches) must also be members of VID 100.
So it must privately add each cascade port of a switch to this VID,
as long as a user port of that switch is in VID 100.

So the refcounting must be kept on the destination of where those VLANs
are programmed (the cascade ports), not on the sources of where those
VLANs came from (the user ports).

In this example, sw0p1 and sw1p0 will be members of VID 100 and will
have a refcount of 3 on it (it is needed by 3 user ports).

-----------------------------------------------------------

Example 2: you figure out that sw1p2 should in fact be pvid untagged in
VID 100, so you change that:

bridge vlan add dev sw1p2 pvid untagged

DSA doesn't care about a change of flags, so it needs to change nothing
about the DSA ports. It just needs to pass on the notification of the
change of flags to the device driver for sw1p2.

-----------------------------------------------------------

Example 3: you realize that you know what, you don't want sw1p2 to be a
member in VID 100 at all:

bridge vlan del dev sw1p2 vid 100

DSA must decrement the refcount of VID 100 on sw0p1 and sw1p0 from 3 to 2.

-----------------------------------------------------------

Example 4: you want local termination in VID 100 for this bridge, so you do=
:

bridge vlan add dev br0 vid 100 self

To ensure local termination works for all DSA user ports that are
members of the bridge (sw0p0, sw1p1), DSA must ensure that the CPU port
and the DSA ports towards it are members of VID 100.

So sw0p0 joins VID 100 with a refcount of 1, while sw0p1 and sw1p0 just
bump the refcount again from 2 to 3.

-----------------------------------------------------------

Example 5: you actually want to forward in VID 100 to a foreign
interface as well:

ip link set eth1 master br0 && bridge vlan add dev eth1 vid 100

DSA must bump the refcount of VID 100 on sw0p0 (the CPU port) from 1 to 2,
and for the cascade ports from 3 to 4. This is such that, if we decide
that we no longer want local termination (example 4), VID 100 is not
removed on those ports. Local termination vs software forwarding is
identical from DSA's perspective, but different from the stack's perspectiv=
e.


The way this worked until now was by an approximation that held quite
honorably more often than not: whenever a bridge VLAN is added to a user
port, just add it to all DSA and CPU ports too, and never remove it.
However, it gets quite limiting.



So the way in which VLAN membership on CPU and DSA ports is refcounted
makes it not really practical to keep original flags of each VLAN on
each source port it came from. Your suggestion of keeping each vlan->flags
in DSA practically boils down to keeping an entire copy of the bridge
VLAN database. I hope it's clearer now why it isn't really the path I
would like to follow.

I can look into pruning useless calls in br_switchdev_port_vlan_add()
itself, if that's what you prefer. Before looking closer at the code,
that's what I originally had in mind, but it would pollute all callers
of that function, since we'd have to provide a "bool existing" +
"u16 old_flags" set of extra arguments to it, and most call paths would
pass "false, 0". When I noticed that the call paths I'm interested in
already compute "bool changed" based on __vlan_add_flags(), I thought it
would be a bit redundant to duplicate logic from that function.
Just reorder the call to __vlan_add_flags() and I have the info I need.=
