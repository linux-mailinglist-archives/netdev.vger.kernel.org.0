Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88213C2590
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhGIOM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:12:28 -0400
Received: from mail-eopbgr50048.outbound.protection.outlook.com ([40.107.5.48]:30606
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229499AbhGIOM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 10:12:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lruIolHffb5woFCcmULrK0Ke3Hgyz3/r0Xd9Tze8jSnZKM0l3komgT7niiYDrWjkwJSFxowijzcYPR3TNIkLpTeK6UnsE4BCOwHfLMj5Sq4ZkkwqW6GVBRGareGYbBFH+z1evnsoIZOqOK/jE+oWv3Mh5rlWSa+61MKfkx9LyIpzsmNBuwCUM3nkp2HJs6qDMYdUyf3cyUeQYSvVybqviDwEZucI+gzOgTp9wcOk4FJvyyhfdlJmE2qaQWLjAyopz5co+DborZXbgwiG84WAhTJyM5pmSOoFBH/0L27F9FG7RGPfRfMh0fY1K+UbnxbdDVvaOH5RNgxVpdlVFOeR1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNubTA80KkJEBJTnXMSdPrbQG1opxuYL3shRlQ4bCYo=;
 b=lr3YN0Jsz/Zjh+w0QGpCFkoXiBb9xaaIB42UZjRo+pJypr7Z/NWox2zEaYtepNYdFFx0hYoREMG45N7K8R8n7Z2W3BbX8MikVaQQ5jsMYpn8m8tANIWqbvs2GcFytq8E42ChiPtl/RVyNR5xzT9hObmRj9dDMWvmHQko6LEFP8grWvDGI2btgySDF2olkTO1959k0oSgUqhpmRT0veCjOcaDDImXTfVYea5WVxo2kHhq6falG7jttwrGXuNMiaS7BOixOhNl6VqRGHXPM376m3tfPUllgDDeRuy2Z46wz/ynWG20tSmq5Vi6RA5jWitNY3CuNrCppZd2k2J/2i5fgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNubTA80KkJEBJTnXMSdPrbQG1opxuYL3shRlQ4bCYo=;
 b=QAF0FVboE9qf2hQYHc1TT+RSSmzomT9D+B+gLMT1G2o56tZ3BXXHvCztHMcKc6Zke52w3UtM9NE2isRBa8SsRb2Q9cTU7DuEndwdZNG0HVk/ob3dtlTeocWOyIqjz5dk6V7vBQkMNp8TjYdZGJzK7McHXP5hMLaRvmDm9YZp438=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 9 Jul
 2021 14:09:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 14:09:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
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
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 04/10] net: bridge: switchdev: allow the
 data plane forwarding to be offloaded
Thread-Topic: [RFC PATCH v2 net-next 04/10] net: bridge: switchdev: allow the
 data plane forwarding to be offloaded
Thread-Index: AQHXcAK+Sk3ggVyTikStfTUZ9SvpWas6qSiAgAAO7wA=
Date:   Fri, 9 Jul 2021 14:09:40 +0000
Message-ID: <20210709140940.4ak5vvt5hxay3wus@skbuf>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
 <20210703115705.1034112-5-vladimir.oltean@nxp.com>
 <3686cff1-2a80-687e-7c64-cf070a0f5324@ti.com>
In-Reply-To: <3686cff1-2a80-687e-7c64-cf070a0f5324@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c0dca47-a38c-4585-d486-08d942e331c0
x-ms-traffictypediagnostic: VI1PR0402MB3406:
x-microsoft-antispam-prvs: <VI1PR0402MB34061F1783E87871E355CF26E0189@VI1PR0402MB3406.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EoJ7CO0MYhgYmAcTHo9GWiOkt1fdqqMtEk36BpAMAXwLJumH3Ylmy4tH3u1NWHZr3aQVTbXDN3TxpshbjgBl3CHS7Pk56yVyiSpRUZBJ29EoBa/g0hfg9xCxB9ItoZnlqy5+/CkLDf9XBDBJuqrKJKqjBFqiZs94ydU0i0khOAQ2grdnXSMlXfaQZbpNWYaP2mR7CqMFGlItm677ry/T6k/Dhgr1YnT1wnJ4hlLvhBjUmw7Mt8f+xUI7o9XfqBPZau9rVAf9Jgt0y0hpmbrHIAGpoiCgLtJd0Nk6sFILZhpHIf5hdpL/QvavplJsyta6qY8cwtZ/09pHwIl7QHLj5pNviEz2qFh+7I+KOBWHVvxNgwxnmltMUnTIyNkvcqRu2QJ6DI0kkAJmLuLQ2An038LxN69OOxHxzL5eBJ+69iyXO6dGs/CKJJFfij3395zi3phyjRBQft7VqHAqGTXAsHKStRtd7EvX94PQOePgG26J+hNHBDYffiT32t0Fl8ZW6mLLuXZxX2A5TDb76LUfDuzma3zNW5Q9ycdcz9Hl8rrxhkhOIVwMy4Oao3oTrscGpCcMXVaGoYLpMuAhvS7Y8VPpZ71TXEzVa34X5xmiRRFViq+MhrJhNTNx7whX7Ju21c8iv8JXnuj0WdRsZ8BF64UuHfgvxsk8eno1tvn8NvWUqZc+3/1M5ox8zUHSfOUhPfTL/vBn6pkef44Txme23nsP4nEixWfzSmYXmVM7qlw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(366004)(376002)(396003)(39850400004)(136003)(54906003)(66446008)(66946007)(6916009)(64756008)(26005)(66476007)(4326008)(53546011)(38100700002)(6506007)(2906002)(83380400001)(8936002)(9686003)(6512007)(66556008)(33716001)(122000001)(1076003)(86362001)(71200400001)(8676002)(76116006)(186003)(966005)(44832011)(316002)(7416002)(5660300002)(478600001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EbAs1Dee3fTGjLp8fY1nBYpDApmNhDj82t2y9FooXF5PQIuGdDLbEYVwZvQS?=
 =?us-ascii?Q?XyGTUyw+nWd+WLgbsWmuf9RFDXhX57Pv0D5hnKk6+5YyuFKihF/9vqeoZnCC?=
 =?us-ascii?Q?vbRmX67S/+HeJdTeeBJWpiC4NDEd1NZirtPat80RjnDIuAiYnGVdaNxb+Hiu?=
 =?us-ascii?Q?eX43rbQg5Yuoe/4oCEzOm71SEQoLz9vXXRLXnk6ImhqH1TnC+moOEai9+O1d?=
 =?us-ascii?Q?ZsTmzfajMekOiwEg474OryJOsCjAVcRQQQdhsV2jRJEIBNY3AQfGFISKcriE?=
 =?us-ascii?Q?5qr3cTKGYjek/+LilhYhLH1gjdt4aPadzaKIkdhy3w06zkjAHloQNR6YwOhk?=
 =?us-ascii?Q?wqEnF+Uc1qQeEdNElAdH/nDIGeTsAYWrHqVFof1+mCNyiOasLVJgxK3a1K5C?=
 =?us-ascii?Q?tcsbTcn3zuuNIA3Fq1cgRvtK+8QcaCxFC/uTzg1ki+bvwEcov+5dBZHz6d/N?=
 =?us-ascii?Q?SpSDs2k0UeKOzIOpHe7xjBwJjpB/d958W4T/YDuAAX69i8JSYwLQc09xgzmo?=
 =?us-ascii?Q?Xe7RcXRwL1IGvLfzQtN17avN/e2X4h36RbM/uDaA2lFUESbudhdMJPSmAv9T?=
 =?us-ascii?Q?XJTL1SRhx5xSrB2HX3yEgklIiQFt3YFAnFPn7bUYk7wksTf+xasfD0UJrFja?=
 =?us-ascii?Q?vhXBNnT9AtiIC+3ZZ3iJksF0p5ojfspPtEOx96wNublPFOmar391nW4pYM2E?=
 =?us-ascii?Q?IcxqVefprYMb/3Hkdkakku2SuTdaBA3IPxisel0S/nWIDX5LJrlCX7TnCuna?=
 =?us-ascii?Q?S96ctHPmD3ioiF/sjCXYbhsgHGE80vzwZ9cSp6b9dgn5snhA7UR0Uhb1rqye?=
 =?us-ascii?Q?wIBaAmSzvO+QcURGO68/CloW+WLIhbff55kfaiAQElQibdYZCJ7ThC66Mx5U?=
 =?us-ascii?Q?Qb3qObPZ/l3MVkxmYpaBcRAjVeR0dqBtZuDE+uroZye5szEWq2okJl/pR2n0?=
 =?us-ascii?Q?Un079pe14Q6Yi4dMtvWzR39Tohd9bwf7X6LD5/zXUL7vK8X9rXUVgoGBuCCo?=
 =?us-ascii?Q?ug0PVy6iSrDrJyi5mjTT/k5b+rWZ6RE1D5GiPehClWZkDSgSPel8rGAVXndj?=
 =?us-ascii?Q?TmlQL5+nbNJ/Tnqx9YKrta293PmqADkjBX7T7kzKd6ozIrMn7JnRCyoyOYC4?=
 =?us-ascii?Q?n0ykB9JDhIKO9RX17oKB1trDLGR2OtRKmrHCJvcIbI/PJigdw+NzGSXJAXTQ?=
 =?us-ascii?Q?2/YWND1p76mmXag1HyZnTAPXGi+6HpXh8viNy2vi06ajUTkvIT+MHUTx+5bM?=
 =?us-ascii?Q?TGO7ulgrqd+PFsWXkCaAF8MtvNphUq9OQDjS4v1zr4pYvcA1E65GOow/TVk6?=
 =?us-ascii?Q?1EV9hV8YAXicdNejxBJzrSJP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <128786DB20964047939743928E4C7CAF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0dca47-a38c-4585-d486-08d942e331c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2021 14:09:40.8576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdPr7F1CgqXDPbu0Kw9r0OJK6PEIpPVtornk8R3hoqihPeYa8HrMxuTtTkA3c33Zuo/SHgdgQxvv5zPgkHB40Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grygorii,

On Fri, Jul 09, 2021 at 04:16:13PM +0300, Grygorii Strashko wrote:
> On 03/07/2021 14:56, Vladimir Oltean wrote:
> > From: Tobias Waldekranz <tobias@waldekranz.com>
> >
> > Allow switchdevs to forward frames from the CPU in accordance with the
> > bridge configuration in the same way as is done between bridge
> > ports. This means that the bridge will only send a single skb towards
> > one of the ports under the switchdev's control, and expects the driver
> > to deliver the packet to all eligible ports in its domain.
> >
> > Primarily this improves the performance of multicast flows with
> > multiple subscribers, as it allows the hardware to perform the frame
> > replication.
> >
> > The basic flow between the driver and the bridge is as follows:
> >
> > - The switchdev accepts the offload by returning a non-null pointer
> >    from .ndo_dfwd_add_station when the port is added to the bridge.
> >
> > - The bridge sends offloadable skbs to one of the ports under the
> >    switchdev's control using dev_queue_xmit_accel.
> >
> > - The switchdev notices the offload by checking for a non-NULL
> >    "sb_dev" in the core's call to .ndo_select_queue.
>
> Sry, I could be missing smth.
>
> Is there any possibility to just mark skb itself as "fwd_offload" (or smt=
h), so driver can
> just check it and decide what to do. Following you series:
> - BR itself will send packet only once to one port if fwd offload possibl=
e and supported
> - switchdev driver can check/negotiate BR_FWD_OFFLOAD flag
>
> In our case, TI CPSW can send directed packet (default now), by specifyin=
g port_id if DMA desc
> or keep port_id =3D=3D 0 which will allow HW to process packet internally=
, including MC duplication.
>
> Sry, again, but necessity to add 3 callbacks and manipulate with "virtual=
" queue to achieve
> MC offload (seems like one of the primary goals) from BR itself looks a b=
it over-complicated :(

After cutting my teeth myself with Tobias' patches, I tend to agree with
the idea that the macvlan offload framework is not a great fit for the
software bridge data plane TX offloading. Some reasons:
- the sb_dev pointer is necessary for macvlan because you can have
  multiple macvlan uppers and you need to know which one this packet
  came from. Whereas in the case of a bridge, any given switchdev net
  device can have a single bridge upper. So a single bit per skb,
  possibly even skb->offload_fwd_mark, could be used to encode this bit
  of information: please look up your FDB for this packet and
  forward/replicate it accordingly.
- I am a bit on the fence about the "net: allow ndo_select_queue to go
  beyond dev->num_real_tx_queues" and "net: extract helpers for binding
  a subordinate device to TX queues" patches, they look like the wrong
  approach overall, just to shoehorn our use case into a framework that
  was not meant to cover it.
- most importantly: Ido asked about the possibility for a switchdev to
  accelerate the data plane for a bridge port that is a LAG upper. In the
  current design, where the bridge attempts to call the
  .ndo_dfwd_add_station method of the bond/team driver, this will not
  work. Traditionally, switchdev has migrated away from ndo's towards
  notifiers because of the ability for a switchdev to intercept the
  notifier emitted by the bridge for the bonding interface, and to treat
  it by itself. So, logically speaking, it would make more sense to
  introduce a new switchdev notifier for TX data plane offloading per
  port. Actually, now that I'm thinking even more about this, it would
  be great not only if we could migrate towards notifiers, but if the
  notification could be emitted by the switchdev driver itself, at
  bridge join time. Once upon a time I had an RFC patch that changed all
  switchdev drivers to inform the bridge that they are capable of
  offloading the RX data plane:
  https://patchwork.kernel.org/project/netdevbpf/patch/20210318231829.38929=
20-17-olteanv@gmail.com/
  That patch was necessary because the bridge, when it sees a bridge
  port that is a LAG, and the LAG is on top of a switchdev, will assign
  the port hwdom based on the devlink switch ID of the switchdev. This
  is wrong because it assumes that the switchdev offloads the LAG, but
  in the vast majority of cases this is false, only a handful of
  switchdev drivers have LAG offload right now. So the expectation is
  that the bridge can do software forwarding between such LAG comprised
  of two switchdev interfaces, and a third (standalone) switchdev
  interface, but it doesn't do that, because to the bridge, all ports
  have the same hwdom.
  Now it seems common sense that I pick up this patch again and make the
  switchdev drivers give 2 pieces of information:
  (a) can I offload the RX data path
  (b) can I offload the TX data path

I can try to draft another RFC with these changes.=
