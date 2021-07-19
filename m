Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2B33CD0B4
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhGSIqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:46:03 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:63808
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235740AbhGSIps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 04:45:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2LWUcbcePXlpdtr7gKqkSLMdEpa1aTmTrdNzIzs33CbX7WsAQBnTRcSqd7w5F840UnhTAWgXvHLo9syGdW+GerTgsa8pjd2bg75tvBa+PLztK43B/qnoKJ8iljLpZdek7ffj8YHbgPg8BxaVEh9ZGNzdOXGxg1y1hlFZlDsRSbeC+k3C9R4b9vBcPAwQV5sa2oyUh7jD5t8SshAJkxOMlZIJ3MMmSS2nigBeg5PIOEWiAKWNhdeT4b0qEB8EcKbB8GOayfWujyJ6N+nOw6495yoHVYj3pJMU53Bluif7zwZ+8OLPz0uCZnDSERZjGqTBjJdkVJU7mqMnmRK1yPhDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDk7iu4bU+NNj8YO6A31AIaqXeSoGpD6DvY+AqknM9Y=;
 b=lyPBmIoFf4bp1Va7KqwapauyaWOWyIaT+p78XQS/Kt8LrQGM2vDpEXgJaoB8L0CiRUzA/Lf+QW9W/ueuYrw2PNEhmI8239afz/XibRCed7b6j6grLV3vKLdqN8ygCuZcJAEIuEeloVBu2UeTGnYmyVeCSDSq4u4GCHnFrr81JQvmvSzbRAHKrSCTn1H3zNTeeUbzwmhBMK8ePGpk6r/ZhEMa1BEazPkGTy4E3QgV+ddz658lWn3MGAFlEFWj73UTx4+/nprztBXsNxKmTubexhvHpyzVtnNIT29CEQTllmNSRBkkG7hkZMa35j2tOwYmPWRABwr4M3TvNbX71X6Ejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDk7iu4bU+NNj8YO6A31AIaqXeSoGpD6DvY+AqknM9Y=;
 b=KO6iAO0Tr3WDYHA4G7HCGJeI/tQzfAKVzLXrwKw/RJEP7CGDr2XGi2XF85vEAeCpeC0BP0HqnEriVkTR5OUYSxL0uZTnkPnm7YWgEq5HaSS6lGulC1YB/czZtKYOM3FRhplPUWDtZpvZuo8dAFuCi3dn3P8pxE3T7goTRPrkaK4=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM9PR04MB7553.eurprd04.prod.outlook.com
 (2603:10a6:20b:2d5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Mon, 19 Jul
 2021 09:26:26 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601%3]) with mapi id 15.20.4308.027; Mon, 19 Jul 2021
 09:26:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v4 net-next 10/15] net: bridge: switchdev object replay
 helpers for everybody
Thread-Topic: [PATCH v4 net-next 10/15] net: bridge: switchdev object replay
 helpers for everybody
Thread-Index: AQHXfB5Xoyt9FGwHYEeMQf4CSmo1dqtKCA2A
Date:   Mon, 19 Jul 2021 09:26:26 +0000
Message-ID: <20210719092625.tnbgghblfqiwtrwl@skbuf>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-11-vladimir.oltean@nxp.com>
In-Reply-To: <20210718214434.3938850-11-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d88d1b9-29cb-4e60-a3ef-08d94a974882
x-ms-traffictypediagnostic: AM9PR04MB7553:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB7553D7E97FB29658AD4F2A61E0E19@AM9PR04MB7553.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wGXKK20R4VEiqhDXat1gAexkF2pEQEUOCXT8pGss4XgT2RAadibtSPfx8o4Xg+LIpJT5FRKsDJ16WKMWTkcGez+O8MHEmy4IzQBhrHmAH+VmL/CnxwjuPNOiHRrUDL+6nvbMCSR4q+dSi/uo5f6LlU+yXZlI35CHM6VMG7bUtG5OlFH51O2I9xv5wIQdKkk7SVoCHL0js788U26bpo3PBVdT3lf/VySDKdijNu2o58rGDg3AFEzbk0HaPTDS8zkM6mmo3pFlTAr0GsoRlovGX4OG0PI09/CWDY4GEwxmHQYSYqszQKd6y2qfBqI9gh/JlbcR7qhxlSY269o8YT+YmoI9xd6B65UEUExxXLQqKZ4KRlzC2oGLhKPkmMcj52/hBBotszaoSiLOGj8TUXGTwxDdXokTJfGS9M+X/UQSRUr/Bi6asXirydLFr8Df/fHrFyk0blnQCtBQsPlmh+pWkejTb1TomWG/qIzVrYg3ig+Xiq9Tamrx9JgkACdXwh7oApdq1anLDZTRVI06Z5MG2hUh6g1QQocDsUtTYAmsAQ5LlWvJjGfLHd4mHbu8sa5STYm4MA3dtvOSzLI1DfB6Ynf+f0ULjBT9DFESM91pYeldzvr7SUcNRxun+AXa7MYSwXmLR+vbZxuZ1qARycZeiv/DFJMZdvZwwifLmIl4qXjsq4cEV1CeJxChQuhy7EuZlKU3oQQCPNulv4nlI5oIeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(186003)(71200400001)(86362001)(54906003)(8676002)(4326008)(2906002)(33716001)(122000001)(6486002)(38100700002)(64756008)(26005)(6862004)(9686003)(6512007)(6506007)(316002)(66946007)(66446008)(508600001)(76116006)(83380400001)(1076003)(44832011)(8936002)(7416002)(6636002)(3716004)(66476007)(66556008)(5660300002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nUJItMYjThvDI829m3+z0CmaT4YEIHHcSi3zHYK05Hp5u9wI9AEw5Std32/f?=
 =?us-ascii?Q?5DpbMYEnFimA0IlKf7XTI4qANeQWb+91GczpUixNzjW6hm3khQ9FJiKyV3kU?=
 =?us-ascii?Q?KhXIzsav0p0ek7kLeRpsUbdqg++gYB37x0F7wkhiKsRNAydMEmaUWIdiZd5A?=
 =?us-ascii?Q?AxGOuA1jBZFfwQd7ia9w4w7a5uc5S8t7WTFwvTWFg2ag0tGjkQY3LJi2HwV0?=
 =?us-ascii?Q?Ga+/f4iE8INM8iNsH5gk+UeEqR2nVbSAXFQ5iJrztcW7hbG+OSqUJzO3bYqN?=
 =?us-ascii?Q?IGv2xcOjxJmd1KB1pIXfx0TBafJz5dT6qddleXUTmNomPVsID/h0YvhBeD41?=
 =?us-ascii?Q?1LolsTtnEMPumXaQFITyzERjgWKTRMA07lFRObDIjmfgKadLI7Mow2YevF/n?=
 =?us-ascii?Q?6khUnR92tmrd4UlEn5yVhhRN17qkcBguryS4aLg4X/0NPEgtXZEz49Wbv3xH?=
 =?us-ascii?Q?0LVrwgP1bUA7JMH0GEckndNzibnFBBWgifMWnNZbNhA4R/Vv6+5OGMBFV7b0?=
 =?us-ascii?Q?lJvot/Tl2Rfsh3F9rgT2vw2IPYigXBY8pKEgW9EpWAxn46oG8/pS19Ho+NKV?=
 =?us-ascii?Q?lD8vFv4dcaZ5wZd7bd4/Uv+BdeTznv+ONREC7Bq+Ixcy3kW3P25EHYH4FMEP?=
 =?us-ascii?Q?kkodtZ9cAmE/kNrL4gVWALk44Ym2E5LuxegcFaxIpIO93nCSpkva+4rbKOC+?=
 =?us-ascii?Q?8/SwitG0KH9kP0iqP451XJV0RlCepk2FG8sBr4HOm4KOfjMpU4GYvE/19W+V?=
 =?us-ascii?Q?zLQVpOirktzscW8BcRPcEl7lExTwYClpKZ0JDw57L5/fmuaYDfeTdhuuOEAA?=
 =?us-ascii?Q?Yxlp5TFsRHoWs/YwtYN96VTunmRTK1dqWMIJKxtQnxOMG3fLt9KfK8wrZBP8?=
 =?us-ascii?Q?WwaCqAjMxpXYl8jlt1DZIncYGtWLfPGtJquSioCqIyHEhMk3PiWnO9aebdIK?=
 =?us-ascii?Q?eKw8dPFXA5Dq1yP7aOt9/9+s/qI6yIvpWrJKsBoLD1R0i+R1IVaouX3ybvF7?=
 =?us-ascii?Q?NIdo2X/CnNuGDGiHjiMxzL0kNWGZAjDE7aAhVMyM1x//eXVTpZSx/FCHmmGr?=
 =?us-ascii?Q?+gSCfRgmGJ6wu/1SX3FU3Jssse9YeB85yQsapbV/0kB2WEseMsq1a7LvlaVo?=
 =?us-ascii?Q?54YUJoVLuGumdTLAZynjPAWu6ZWbtIGfHaJPRo3a+Q4SX18IfiHBAhrKNG+z?=
 =?us-ascii?Q?0uU5UedBU8VLoW8qsgD4cZAxkWnKC3QW4XerF15Z9t1k5ilbqKwnRKzJ9uEm?=
 =?us-ascii?Q?exjM7+5n+bt7k4IvupOfqwUBRwfnoHMVoKoGGFB5okF8iZM6UCLS/2fpIVcC?=
 =?us-ascii?Q?rLci1QOT9HXRDg8/F1q4xP6F?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F50B7B1BB8BB4E40956FFE541EF2452A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d88d1b9-29cb-4e60-a3ef-08d94a974882
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 09:26:26.5194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jDnBUvcyifIQzjhU87A8G6UhggsXudDNHxQiudsO7KdBPvFbBE1WwNs2hOZpanVQlt9b0KFcmUekwkzYGmTv2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7553
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 12:44:29AM +0300, Vladimir Oltean wrote:
> Starting with commit 4f2673b3a2b6 ("net: bridge: add helper to replay
> port and host-joined mdb entries"), DSA has introduced some bridge
> helpers that replay switchdev events (FDB/MDB/VLAN additions and
> deletions) that can be lost by the switchdev drivers in a variety of
> circumstances:
>=20
> - an IP multicast group was host-joined on the bridge itself before any
>   switchdev port joined the bridge, leading to the host MDB entries
>   missing in the hardware database.
> - during the bridge creation process, the MAC address of the bridge was
>   added to the FDB as an entry pointing towards the bridge device
>   itself, but with no switchdev ports being part of the bridge yet, this
>   local FDB entry would remain unknown to the switchdev hardware
>   database.
> - a VLAN/FDB/MDB was added to a bridge port that is a LAG interface,
>   before any switchdev port joined that LAG, leading to the hardware
>   database missing those entries.
> - a switchdev port left a LAG that is a bridge port, while the LAG
>   remained part of the bridge, and all FDB/MDB/VLAN entries remained
>   installed in the hardware database of the switchdev port.
>=20
> Also, since commit 0d2cfbd41c4a ("net: bridge: ignore switchdev events
> for LAG ports which didn't request replay"), DSA introduced a method,
> based on a const void *ctx, to ensure that two switchdev ports under the
> same LAG that is a bridge port do not see the same MDB/VLAN entry being
> replayed twice by the bridge, once for every bridge port that joins the
> LAG.
>=20
> With so many ordering corner cases being possible, it seems unreasonable
> to expect a switchdev driver writer to get it right from the first try.
> Therefore, now that we are past the beta testing period for the bridge
> replay helpers used in DSA only, it is time to roll them out to all
> switchdev drivers.
>=20
> To convert the switchdev object replay helpers from "pull mode" (where
> the driver asks for them) to a "push mode" (where the bridge offers them
> automatically), the biggest problem is that the bridge needs to be aware
> when a switchdev port joins and leaves, even when the switchdev is only
> indirectly a bridge port (for example when the bridge port is a LAG
> upper of the switchdev).
>=20
> Luckily, we already have a hook for that, in the form of the newly
> introduced switchdev_bridge_port_offload() and
> switchdev_bridge_port_unoffload() calls. These offer a natural place for
> hooking the object addition and deletion replays.
>=20
> Extend the above 2 functions with:
> - pointers to the switchdev atomic notifier (for FDB replays) and the
>   blocking notifier (for MDB and VLAN replays).
> - the "const void *ctx" argument required for drivers to be able to
>   disambiguate between which port is targeted, when multiple ports are
>   lowers of the same LAG that is a bridge port. Most of the drivers pass
>   NULL to this argument, except the ones that support LAG offload and hav=
e
>   the proper context check already in place in the switchdev blocking
>   notifier handler.
>=20
> am65_cpsw and cpsw had the same name for the switchdev notifiers, so I
> renamed the am65_cpsw ones with an am65_ prefix.
>=20
> Also unexport the replay helpers, since nobody except the bridge calls
> them directly now.
>=20
> Note that:
> (a) we abuse the terminology slightly, because FDB entries are not
>     "switchdev objects", but we count them as objects nonetheless.
>     With no direct way to prove it, I think they are not modeled as
>     switchdev objects because those can only be installed by the bridge
>     to the hardware (as opposed to FDB entries which can be propagated
>     in the other direction too). This is merely an abuse of terms, FDB
>     entries are replayed too, despite not being objects.
> (b) the bridge does not attempt to sync port attributes to newly joined
>     ports, just the countable stuff (the objects). The reason for this
>     is simple: no universal and symmetric way to sync and unsync them is
>     known. For example, VLAN filtering: what to do on unsync, disable or
>     leave it enabled? Similarly, STP state, ageing timer, etc etc. What
>     a switchdev port does when it becomes standalone again is not really
>     up to the bridge's competence, and the driver should deal with it.
>     On the other hand, replaying deletions of switchdev objects can be
>     seen a matter of cleanup and therefore be treated by the bridge,
>     hence this patch.
> (c) I do not expect a lot of functional change introduced for drivers in
>     this patch, because:
>     - nbp_vlan_init() is called _after_ netdev_master_upper_dev_link(),
>       so br_vlan_replay() should not do anything for the new drivers on
>       which we call it. The existing drivers where there was even a
>       slight possibility for there to exist a VLAN on a bridge port
>       before they join it are already guarded against this: mlxsw and
>       prestera deny joining LAG interfaces that are members of a bridge.
>     - br_fdb_replay() should now notify of local FDB entries, but I
>       patched all drivers except DSA to ignore these new entries in
>       commit 2c4eca3ef716 ("net: bridge: switchdev: include local flag
>       in FDB notifications"). Driver authors can lift this restriction
>       as they wish.
>     - br_mdb_replay() should now fix the issue described in commit
>       2c4eca3ef716 ("net: bridge: switchdev: include local flag in FDB
>       notifications") for all drivers, I don't see any downside.
>=20
> Cc: Vadym Kochan <vkochan@marvell.com>
> Cc: Taras Chornyi <tchornyi@marvell.com>
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
> Cc: Lars Povlsen <lars.povlsen@microchip.com>
> Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com> # dpaa2-switch
