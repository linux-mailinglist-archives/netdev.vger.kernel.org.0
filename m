Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5636F59E471
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240444AbiHWNIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240218AbiHWNIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:08:07 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A9A131A30
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:10:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtamT2sOj2sqBiL7iwr86fdLF1cxHSkzfB73riaMTypPHOFfYmPWFhLHIm/GP80lYTx5PSTJa28kahiNw9YS1dJjcfJj1HzuHafkGtFB4u71VthgKXugjdHQs3O9yIOmOkkjiAItiKNR4Y4EISkJrV+6RCPkaP1UgDxpmFAYIRCILh9UsVkDfNhTTcoqMsONNVKiE+T7IebcuJFKyWpBhw2LRKBYCr3H3Vpf0C9EIikRZqdyMynOzGYeiCD2MTwiqFBVjU+jmyeI8X+8NZas9+LKwAVKuwp/mfx9akbhjuqiPogK3t8a/F0Eb8hUhTLl76asp+txAxhNZKj8SqBNQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPoTSzSF9cv9B8r0BkrD1ShEycgRn0hDXnShPbPuFQg=;
 b=ii/XZR8bP8f4EDSkwpANJCI46A9i+viLIs+jJVx82PSNQjEyapevxU/GaBUj+6jLv7FQtA0JNrIypc6qAgKiuULP8ymFmCzjtMy+YPm6kCKxKjnBxhfwumoPKuPORmpLwOpejXu32NL7BkAIkCPr5D3/s8QpXyQeFLun9EyQMNMsVHXB0Cd//RWOQD+3YHkTyCQ7Kk4Tlj3l1vv/mZ3D/neJVXoq33SXm6XdXAaajBS/IvyHZvWxNIJqiHvkxLA2NhWO8T8enp+Pua5HNhQHbtKRL+qnjSUcUJQvFLZ0rHdvQsff7QGwy0dALpSFJnMD87vYo7kuxaAA16HAnsCJ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPoTSzSF9cv9B8r0BkrD1ShEycgRn0hDXnShPbPuFQg=;
 b=U7m+lVeGreMVMF9FXfer75EFjzabU30kaCfedZ8lKjvPPV/R47zHtfi/LskzXq5hkO/xYYzxwIUjcr+1BTPkQ/S5kPs/bb0Gz2jRsrygRKo5NAeXKXBjkWn+2hWcSOyLxB3g/YaKQXe11/Kw7LIrR8Smrgb+7MEPcEi6/W8hfIQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7039.eurprd04.prod.outlook.com (2603:10a6:800:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Tue, 23 Aug
 2022 10:08:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 10:08:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: Re: [PATCH net] net: dsa: don't dereference NULL extack in
 dsa_slave_changeupper()
Thread-Topic: [PATCH net] net: dsa: don't dereference NULL extack in
 dsa_slave_changeupper()
Thread-Index: AQHYs/Km0aA/T/MwZUaFOoR28hESBa27tomAgACSLQA=
Date:   Tue, 23 Aug 2022 10:08:34 +0000
Message-ID: <20220823100834.qikdvkekg6swn7rb@skbuf>
References: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
 <20220822182523.6821e176@kernel.org>
In-Reply-To: <20220822182523.6821e176@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62ca1698-495b-44be-b0ce-08da84ef70b4
x-ms-traffictypediagnostic: VI1PR04MB7039:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OWJl7G3ohVYCd3XFY1dl9WDB2djrn5MKFGw+Xh0Poo0tCVzHH8qd/ljklOIH2k65vt0Csbwn1/a0QH/zB0q8JFIiGb7XRN/Y77L+uAInNajpbYDMjwcI1FuHVgH8dnr1olR5VgVXcc3ATc0DUFD3dN8Mo7AynA+We0ny/TswgnsTbYRTQc++j3uSWILpXVCCBetJQEikPNkgnhGpbGwTzdGx2APd4XWR5dMmgK5aHrbc4BOOuJkdRVnh92QtQH7A4BqhRSQYw+VtCiOK7iJebvJIJlvQaVLYcXS6rNbXtKUntOTXveEw3wAPrQl0Z2eS+pkCXbbOBXu1LK6N+qacVyOK9R3vDzB8uxsAT43sJIt5Kh3KJPuZmPpNS3cYD9kgADApQsLGz8lImPeSrQf7CZMUlaVQmQMfV09H0LVLhZkZj5s1vksWYSSL2y4BO60Ci1Phnfs6CKvvIARdS0EgL1qjFCsJdRCDQWKD+Eetym9Vz4a6CWmerCW5j7JOxshPwGAzo/OeMHKuAM86HxDF1iwoHeYLlhEfT7OAXaegooq9CQNT7xTmQBm3hHUwW9l6BTq5BfW0BKRQNdvOj340weAeinbhAdExVI+9Kz/VYTNMj03uGutvireGHw9bcbcdwuJOwEEXnrSMQbmQMgQN914pJbsOpgv/eg7+EJ4my+iC1LYQzWW4Ye5aqNAFZXgwr1ax5fnoppw/cyhGJeRU+rvhIs/NOi0BjSydFZ/AUI9uoTw8CN+j0IxFhNLT7KHO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(4326008)(86362001)(44832011)(66476007)(66556008)(66946007)(64756008)(76116006)(66446008)(8676002)(122000001)(6916009)(54906003)(91956017)(38070700005)(1076003)(38100700002)(26005)(8936002)(6512007)(9686003)(41300700001)(186003)(6486002)(478600001)(71200400001)(6506007)(7416002)(316002)(33716001)(83380400001)(2906002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?zJ9WGZ/lWDRYbzFYA1qfg+oFlIm3e8DRYPrcmBzomYH9VZqbfGUmGTdP1N?=
 =?iso-8859-1?Q?Tn8t6K1/gpWUvynXCrlOpgamdMUx9nNZ2Te+llxVNS1zHhM91lR+7iEDbX?=
 =?iso-8859-1?Q?eRpKqbvlZe9pajYKYVr895JCaNPv6pgNzVJRsS9dQabFL863bQsHnv1k6M?=
 =?iso-8859-1?Q?qD1cl9LWaSpjxYi5dtNDXlJLim+n6S6BLxONxiYcVwJRUNei0YJVbsbWuc?=
 =?iso-8859-1?Q?OqjmNfk3vD34h3hoeOGD7UQTRBq+OW/RrK8BNQiaR9/Amfjbd3IQTKE5Px?=
 =?iso-8859-1?Q?h7QDmrnPPEOLR8VYn9sb4+QGwB4yuuV91UzTuGd732ykZXjnSj9R3K4WNQ?=
 =?iso-8859-1?Q?lAByNzbj2gjlAjxjkp0MTIEB1Ju42djOclCdyIwg/mPILruAX6AJs6b8/M?=
 =?iso-8859-1?Q?GFDR7ebbPW5UmL3SCWHdMivu48ZO66N+ihlXi9l4aKiTQDUxdpVYO2mzOF?=
 =?iso-8859-1?Q?w9bLiEpdhkvRlJMXH0nwGZIQl7C2+FSRZYsp0Ue9mZhWmQt/jXQt4bTRH5?=
 =?iso-8859-1?Q?/1MZCjaS1gssWPmbbqW+F5StCav2k2D53Iui3eaySRsdlE7gIwLzVFIRwM?=
 =?iso-8859-1?Q?mkV9QJavGkT9O1XFjOFJbE/U70YbSLPWlXyljtUGsPD4zMY2d7w1Hdcy88?=
 =?iso-8859-1?Q?0hPe3BqzhNkYej7DHEC5MFx6OUbOWeo0JArbkbghCSwT9UB/f+Yk4PspTQ?=
 =?iso-8859-1?Q?LtfH9t9gCezWBYey1AVzulk023+ref9Pb5Wn2Ct7j52TYNd9e/+QetKuUN?=
 =?iso-8859-1?Q?Vhu9hmkokD8Mi5y+WsX4yLUoFQWzshareUYw0ADxJozq4TgRArp0MIdAjI?=
 =?iso-8859-1?Q?mI91Q7qOqT9SHZtsUIzZtadu1jaDYQ9IAxQ6GT/yBT33W97yxAY5WdPqxQ?=
 =?iso-8859-1?Q?1kOC1AoRTy1RtPM7P5u/DUFwnNOTXJIeQnt9Jtojwz6gKqp+wi3ClYBg+W?=
 =?iso-8859-1?Q?hN1Zt9CeLhbwTvl8SjzJd5yozLJMxTnc1xR7bstN4g2kTy1YVaBfqSxrZn?=
 =?iso-8859-1?Q?xsC710ziqJ24+WRbb+vtKveEUUJppotkENhaxF+lmkAtCajKHoPedl6sJ0?=
 =?iso-8859-1?Q?BdP7897MkteAENo02sE8UuJ9NOlj43gWAOqR3fAqnSCYM91MKxuunnGHUU?=
 =?iso-8859-1?Q?XCvOzWuw8X2TgCblw1MdhOuQbnnn0BPlYqQAcWS/Ld3LjXPASSbhxVTD6z?=
 =?iso-8859-1?Q?NH3TFoRE9Ymn9d5UWf9pidgYy/XjsEGnE7dx8R4ADAvvQ8uwCE6MBLYJaz?=
 =?iso-8859-1?Q?Fy4NUQNtwBWFabIwysYm9TWRnwVoEJJt7CShhqWYHpEjDnlS0p1CvLdkLd?=
 =?iso-8859-1?Q?xbnOo15x0VXSpKKtwFtLVn3Wo7O7C5HucW4n/r1q47xmOiRkjZxiSNqsxc?=
 =?iso-8859-1?Q?YLnp/fRiAFBSsFa2DteqDrD8jcapXRHmKRvuRQuhNfhXuWmcwWu/6BVmU2?=
 =?iso-8859-1?Q?PAHVy3+/hUNie5FIk7xK3vVzSP/ej30qBpD7P9ly6z/R0Yez2G6r+hWkGD?=
 =?iso-8859-1?Q?gaw56CLk+vfRy4rVhyPbnTANwPwBHK6y4xzMHW9CZEyvHs5DT417gnSBVp?=
 =?iso-8859-1?Q?t6t81ZXhktyWyy09OvoAJuUoT3CQ+tCECluVFKyB9siDhrqzCc3aDU3JfK?=
 =?iso-8859-1?Q?gyP2CJ7/nUVADjnvvJWwZW4x9EphqY1RXVWaVPqxFA0bjs/T7ZUuJuag?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <257CD2053AFAA747976404F75A5EFCA4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ca1698-495b-44be-b0ce-08da84ef70b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 10:08:34.8974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NVnZSXY8L1MmHjlbXS0Ps7ZUDeWIURYiEUZuN+USbS1c8dPmuu5rfAZwDMi91YZ+n13uhTayydKwPuWsL1jfCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7039
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 06:25:23PM -0700, Jakub Kicinski wrote:
> On Fri, 19 Aug 2022 20:39:25 +0300 Vladimir Oltean wrote:
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index c548b969b083..804a00324c8b 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -2487,7 +2487,7 @@ static int dsa_slave_changeupper(struct net_devic=
e *dev,
> >  			if (!err)
> >  				dsa_bridge_mtu_normalization(dp);
> >  			if (err =3D=3D -EOPNOTSUPP) {
> > -				if (!extack->_msg)
> > +				if (extack && !extack->_msg)
> >  					NL_SET_ERR_MSG_MOD(extack,
> >  							   "Offloading not supported");
>=20
> Other offload paths set the extack prior to the driver call,

Example?

> which has the same effect.

No, definitely not the same effect. The difference between (a) setting it
to "Offloading not supported" before the call to dsa_port_bridge_join()
and (b) setting it to "Offloading not supported" only if dsa_port_bridge_jo=
in()
returned -EOPNOTSUPP is that drivers don't have to set an extack message
if they return success, or if they don't implement ds->ops->port_bridge_joi=
n.
The behavior changes for a driver that doesn't set the extack but
returns 0 if I do that.

> Can't we do the same thing here?
> Do we care about preserving the extack from another notifier=20
> handler or something? Does not seem like that's the case judging=20
> but the commit under Fixes.

Preserving yes, from another notifier handler no.

DSA suppresses the -EOPNOTSUPP error code from this operation and
returns 0 to user space, along with a warning note via extack.

The driver's ds->ops->port_bridge_join() method is given an extack.
Therefore, if the driver has set the extack to anything, presumably it
is more specific than what DSA has to say.

> If it is the case (and hopefully not) we should add a new macro wrapper.
> Manually twiddling with a field starting with an underscore makes
> me feel dirty. Perhaps I have been writing too much python lately.

Ok, can do later (not "net" patch). Also, if you search for _msg in
net/dsa/ you'll find more occurrences of accessing it directly.=
