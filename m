Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F283FC646
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241288AbhHaKuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:50:13 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:46177
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233966AbhHaKuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 06:50:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JU1rYKNy7FkvxO9kzG5+4Rse0VffJJ9Uzxa4b3wx2Jv1NbN8g1ma4FsifK9jjsunU4DpxeIeQYyh3Cco1OjD8wYQjYMXGH+jtn+zC3JWpzE5FbXipWE1xicHhTtHZphm8wgql5gxzn+DZH8tCwzoQXuz2rgn0GeaG+FolXHxO0ZjYYl6dmAJC/jSQYwnuPPP7Eo5kp2cVm56nEfXMkEMZ/HZMyTvibiPuf7O8Eg3+5WhszEa49PqGjxMI+x8UlZ06WRZY5lz6hvsaNWf1EuWbRMmK8VL1xIkoJhL/0vmGwFstYhf9CMlZVpQOq9jDkOWAkPIRUUxp5RJEuDCX7Xm6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRtK8UZ1nMTCduQ6uRGPlWkZbseb0vada0vuinTZqBo=;
 b=gAVNJ3dJWSIzjgAkd3d3YzBZ2qSAu3mSxz73WiKAP91irYWxe0xN64goy18Nmuqecn9rZkOw2GuFbojeRrjx0kmCo6PhHeZnMdqvRSsI3V9+dFdFjwvHr6rr9uKPlzxBOHcQNHI2cQgEb6Aw51sG6GSRL1RhvkcXWWXwyzNOXHv2FdiCRNc57dTfZMXn8qPYfEFDGaM4fN6+1Tmk1hw6EnwVbTVrNVlVBEg2dbemJXiEfu7BlinHvQatKHLadzkpsC4kbcZ/vhP6FsHCAgA5HxUa2ujcUaRoVhdhaA3cx4bhLT5ybOEycstYOSowl3PTtEh9qcf/0AG6rlYXyDXQng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRtK8UZ1nMTCduQ6uRGPlWkZbseb0vada0vuinTZqBo=;
 b=o5Xzt28o2SB9Oaf2Rn6mjYUaUw8l47oLRYbxrI2GqZ9cYx6QkI+GnvAOmYJbfhiqcY5qNHZR2hGnbJ074LXVnfMr0TAXlKaMf9PmhIVtbKcGVAjUkAQ8gdS4q4Oaf8ZWDyPU5KL4jV8nFopEjYRdzCm6y26KCgSPPJPxs0VMkO0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3710.eurprd04.prod.outlook.com (2603:10a6:803:25::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Tue, 31 Aug
 2021 10:49:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 10:49:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3bR+2BJOkCk2OO1PW76puEquNPsAAgAANEQCAAAFHAIAAA9qAgAACOACAAALRgIAAC4OAgAAN+4A=
Date:   Tue, 31 Aug 2021 10:49:14 +0000
Message-ID: <20210831104913.g3n6dov6gwflc3pm@skbuf>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831084610.gadyyrkm4fwzf6hp@skbuf>
 <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831090754.3z7ihy3iqn6ixyhh@skbuf>
 <20210831091759.dacg377d7jsiuylp@skbuf>
 <DB8PR04MB57855C49E4564A8B79C991C3F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB57855C49E4564A8B79C991C3F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adce67bf-acd3-4d95-44dd-08d96c6cf923
x-ms-traffictypediagnostic: VI1PR0402MB3710:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB37101B3F49F5C61E0196D5F7E0CC9@VI1PR0402MB3710.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cWHCC8p3adp5mNKYHWzwEyfdTGU0/NWyO70w5/4H+4I8FHHEy+Tq2V8+nVUWrR2wVX81QXgoNwIv09WDRnJXKaaxGgjaRRLsIoKMPb4yLPLYZNa2mqvBjace6Y1MH32d3dwpeZutkJxOjEQfpq+bSO6658edUebjSRmXC7yfEk5f9ayIgXOrBH1o8g9cYGr6JCm6APlJrDHmD1K8QUh54kwz+eX6gVVU44J6VKWEv1cecWGsNH/iEVlKo4E68uKvL6AWDaukAmfpQnwAunJ06Rl35Ibk7fqzfUGGuU3ZRfpm6AoDni2aZXNKXdUazFuhnKsPTXGTDYtQWz/chFf1bPOWPAXySltXFrmHsf2zLeGC1pAFEMXjPs7TIMoOhLLqbDhioVZClzs2A6lmax2AOclScwTae0YRQvDYTnnkfoMeJSR/ivH30N45lfzg8bgSim/sY0dwM/GpHaFZqfbbidsaaj181W3P7NKiFpP2G9qTw8r+HP2X3WZ87VcA1OGKlful6j8oeofZAsT8y0nsB9/J/aaO2ClJbmbeFvp0XeyZUsWg8NlnY0KEy1wx/XSBW5pVBQSi/RavKDejZbC0yLJTjUQvfP8ScAJnW5ts4eJCAeum2HUPKnGHCbLmYO2n0/8UcubabjuR0hJ37EDAQVlyrK/JV9+d29unRo6+FQi30BfRxrTbbdh1yh3nuvNsP7QfEf0VLTJHJTr0wZ9k3t9vfsrG55LMoxmAPRQbyPqFTWyt/RkJ65kQ7ibGxbx9PbY9T/0vl0FgbJRcvJ5QTPvANYLbsNgHVu17CGVLxpE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(396003)(39840400004)(136003)(376002)(1076003)(5660300002)(6512007)(186003)(966005)(6862004)(54906003)(9686003)(38070700005)(6486002)(4326008)(316002)(8936002)(122000001)(44832011)(478600001)(66476007)(64756008)(8676002)(6506007)(66556008)(6636002)(66946007)(83380400001)(91956017)(76116006)(71200400001)(86362001)(7416002)(38100700002)(26005)(2906002)(66446008)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?keuyo6NGImG846+fzcGC6jMywZQaqFw4tJ19AnDKg2Nf9qQ2TJYP3WRRivM6?=
 =?us-ascii?Q?Ip+T8TvsaIX5cM5Vg0AOJaRgnb97XOQbNkzcbzPB8iyseR1snvYj4ot/4As0?=
 =?us-ascii?Q?XjqqnLzKYgFWDVTW9LB7i3URTWQQRh7QqE0KllnAEGNR76DolUxrs/dRNjiu?=
 =?us-ascii?Q?sDBtbvM9SwBndIALUMGyte6rtlcS+TD8Sq5dhaZ+3OyWYMcQGYpBZt859n0V?=
 =?us-ascii?Q?ELRDSl2s+Oy7xzHqzZOReLsgyzqTw/6azigQ+pSS5p3o+pAn7kObxYBG9vb3?=
 =?us-ascii?Q?eFfzpvmfrPXmgDDOUPlnyb3toN6LW14DA+2CWJfXCeu71CNzCIInW4nk713d?=
 =?us-ascii?Q?rFVAJMXw/skWjd22SlPHmHW/JtUuVfgSWGPmin4eFde9kI2qs70Teoh0AV5T?=
 =?us-ascii?Q?QGFtesrzOzyZRHRX+SuXtnfjRiJgOmx6r1XCHMTNFiXuvD3naXPK3ybX9U2q?=
 =?us-ascii?Q?a9l58BMhN+UIzPAsO7UJwEK+i8tp1m1SYWnUfNMaYJ4vzKweEybWjS6X96rG?=
 =?us-ascii?Q?bLIxbzI2rU4dWgM0aHj6AnhvuGqiIy649r3TXBGwRidptcZ5h5WI+8ZgQuIQ?=
 =?us-ascii?Q?QA/er43K/kQ6eYtze2hOP4AH9CrbbTtY8z06z3nU6j5YOJqHmzYQq2ul21fT?=
 =?us-ascii?Q?ipM5ztfJEmBXRFju8VDdKfGkUqupmUviEiw++TzmRMSGiKOm0r6BUp3Qyi1s?=
 =?us-ascii?Q?dPPvt5FLDWhR5NWr/Kxuu61RT5VB2F+wZmGMauj9tSHNLB4p+/k9XtUQ2Xu2?=
 =?us-ascii?Q?W96zApKOblClCWt9K931OVMhpFygpjn8VqUoERN8XQT0gX87InvBIUJqSL4m?=
 =?us-ascii?Q?RxGIx6b79LSJnNhfThgmMX2ndTpsqqEkQ8+9FROjMDnGrs/8XnjsAAz3m1lv?=
 =?us-ascii?Q?UCNq7sQFRQppRAABvqOpB70pAeGiFz0lUolsBlhdCsvqJ3PwbSDYWcZAUQ8h?=
 =?us-ascii?Q?ZuqsbGt8qj4pFV3UIa6rMN7jES/jpxX64prSZXIpoULQSDsdlr7amH9e/I/t?=
 =?us-ascii?Q?u8XE3P9NKa97F+xrQS/zJLpao4o6BRDmgG6lESX0jfoLxKRaI37In6KDkjex?=
 =?us-ascii?Q?0ytHRkbQvqtJMu39LYrGkCQ2HG0OS+wV1N16ILmK00rakZ2zexvRVaApt9OE?=
 =?us-ascii?Q?OtMja9QvusoOfd178ILwTInNcMU3ZFLImQzDDQRvU5fzY7Zt2FUq7lUGrgS+?=
 =?us-ascii?Q?oJyXdxUSaWRc9h79OyZvHBmTW2pJ+SPqc+YcmMozMXWP4RrnMy6Z0VI8ZVti?=
 =?us-ascii?Q?iucR9mfSJ704nXW/i29/ObcS/++LHI7y70bjb0AL4ulYFmJlDNdzk4pIhCyj?=
 =?us-ascii?Q?be0Vw/6+uctTtIPROqFcXn7W?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52E3DAE4F3B6F145B0070E31435E5AC6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adce67bf-acd3-4d95-44dd-08d96c6cf923
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 10:49:14.0912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P7VnWROPs1jUF74rXFiM8z59C4LMYwe+ws33fGehI4YKEjIZKdDDs2WHN1IckfdzWXOo5D8eOdANKx+A2OJ0mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3710
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 09:59:11AM +0000, Xiaoliang Yang wrote:
> On Tue, Aug 31, 2021 at 17:18:00PM +0300, Vladimir Oltean wrote:
> > > > > I think in previous versions you were automatically installing a
> > > > > static MAC table entry when one was not present (either it was
> > > > > absent, or the entry was dynamically learned). Why did that chang=
e?
> > > >
> > > > The PSFP gate and police action are set on ingress port, and "
> > > > tc-filter" has no parameter to set the forward port for the filtere=
d
> > > > stream. And I also think that adding a FDB mac entry in tc-filter
> > > > command is not good.
> > >
> > > Fair enough, but if that's what you want, we'll need to think a lot
> > > harder about how this needs to be modeled.
> > >
> > > Would you not have to protect against a 'bridge fdb del' erasing your
> > > MAC table entry after you've set up the TSN stream on it?
> > >
> > > Right now, DSA does not even call the driver's .port_fdb_del method
> > > from atomic context, just from deferred work context. So even if you
> > > wanted to complain and say "cannot remove FDB entry until SFID stops
> > > pointing at it", that would not be possible with today's code structu=
re.
> > >
> > > And what would you do if the bridge wants to delete the FDB entry
> > > irrevocably, like when the user wants to delete the bridge in its
> > > entirety? You would still remain with filters in tc which are not
> > > backed by any MAC table entry.
> > >
> > > Hmm..
> > > Either the TSN standards for PSFP and FRER are meant to be implemente=
d
> > > within the bridge driver itself, and not as part of tc, or the
> > > Microchip implementation is very weird for wiring them into the bridg=
e MAC
> > table.
> > >
> > > Microchip people, any comments?
> >
> > In sja1105's implementation of PSFP (which is not standard-compliant as=
 it is
> > based on TTEthernet, but makes more sense anyway), the Virtual Links (S=
FIDs
> > here) are not based on the FDB table, but match only on the given sourc=
e port.
> > They behave much more like ACL entries.
> > The way I've modeled them in Linux was to force the user to offload mul=
tiple
> > actions for the same tc-filter, both a redirect action and a police/gat=
e action.
> > https://www.kernel.org/doc/html/latest/networking/dsa/sja1105.html#time=
-b
> > ased-ingress-policing
> >
> > I'm not saying this helps you, I'm just saying maybe the Microchip
> > implementation is strange, but then again, I might be looking the wrong=
 way
> > at it.
>
> Yes, Using redirect action can give PSFP filter a forward port to add
> MAC table entry. But it also has the issue that when using "bridge fdb
> del" to delete the MAC entry will cause the tc-filter rule not
> working.

We need to define the expected behavior.

As far as the 802.1Q-2018 spec is concerned, there is no logical
dependency between the FDB lookup and the PSFP streams. But there seems
to be no explicit text that forbids it either, though.

If you install a tc-redirect rule and offload it as a bridge FDB entry,
it needs to behave like a tc-redirect rule and not a bridge FDB entry.
So it only needs to match on the intended source port. I don't believe
that is possible. If it is, let's do that.

To me, putting PSFP inside the bridge driver is completely outside of
the question. There is no evidence that it belongs there, and there are
switch implementations from other vendors where the FDB lookup process
is completely independent from the Qci stream identification process.
Anyway, this strategy of combining the two could only work for the NULL
stream identifiers in the first place (MAC DA + VLAN ID), not for the
others (IP Stream identification etc etc).

So what remains, if nothing else is possible, is to require the user to
manage the bridge FDB entries, and make sure that the kernel side is
sane, and does not remain with broken data structures. That is going to
be a PITA both for the user and for the kernel side, because we are
going to make the tc-flower filters effectively depend upon the bridge
state.

Let's wait for some feedback from Microchip engineers, how they
envisioned this to be integrated with operating systems.=
