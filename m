Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AC92D8ABE
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 01:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgLMAuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 19:50:25 -0500
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:59148
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727165AbgLMAuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 19:50:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4qfFK53Tp0OEgDQ/n98QCUzIznee3BTxx0Ff4VNAfFxK1bDwwN+rYXd5oouZHwhzS7Krpy3bC1KIaK24qh+Jo6q/p+G8SboZzHauOr5cRsnc099O6lar75eafS8/fEtkBECPeSEIDUXDCyw/lFzna3pZZWUCZU5CA/HsS/38WAHnhanRFOjaVdVZM+U06nM/01RxGhm7yG6FbTqxfLK7Rf+UdiYrXW4hwCKQb4EvTqeOFvR6LB/pAzdWAFYxZ6h3Vlz2l0ESQ/IGBlq7xUvZUvlHi8x1G+eOzrDoJqMtuZd1jrq3j8/75WSNS+9U/sRgKF6cvdtvaXjq+w4CTMKBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3+UjNV0h62PQh3ierNrXe38tWp2i3bkkUW0bZlkP4M=;
 b=KKre/t8kzMA/CEjV08fpOwMf5UD7eG4EL2uPtz5F+oxnZ/a/ED2wn1gLXSd2weyjJsiyvWELKjFREby7zS/tnpqNPIWqD4Dfk4zv2iX7M3a5M8J5RLlvpwKr/iGOuPG6vEx1hS9hqQSORx8Xbz3Q5e6HwM+eJZZPs7IqsTzyCErMQNccQy2i9SIDDLjgeGTVd9opmNc64B0l+z0hpmoNVgK3VRMR6C3FN+OnsroRUNVeePcStKkh1js8sm39uJEZWZ91TcrX2cxnaDb4tySr/xUwcSe5XhHDOtaP58sQ7sRNg8JbVwASxfpU8iNzBucCeVcsI4QOHBHMU26AGPGatg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3+UjNV0h62PQh3ierNrXe38tWp2i3bkkUW0bZlkP4M=;
 b=pcmXzXEfF7ZLwSya+7cSHZ9NB+bBzua24JYeGtv2txcucj4UV7y9RmYOwLRiSHL8lsyxJ4aqiPMUfp5CkLuG4n4Vqi8KfSbCRKPazNNTkUBu/+1UxPONTgwKlSPwTxrU0bTLYKkhkNwn9HCQ51KYO/KqMK7in7Rs/XL1fx+Bz0A=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Sun, 13 Dec
 2020 00:49:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 00:49:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
Thread-Topic: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
Thread-Index: AQHW0MbaD+Wb9ZfykEuALlETOMXISKn0BJWAgAADbwCAAB64gIAAAYEAgAAFjQCAAARNgA==
Date:   Sun, 13 Dec 2020 00:49:33 +0000
Message-ID: <20201213004933.pbjwfltwudvokrej@skbuf>
References: <20201212203901.351331-1-vladimir.oltean@nxp.com>
 <20201212220641.GA2781095@lunn.ch> <20201212221858.audzhrku3i3p2nqf@skbuf>
 <20201213000855.GA2786309@lunn.ch> <20201213001418.ygofxyfmm7d273fe@skbuf>
 <20201213003410.GB2786309@lunn.ch>
In-Reply-To: <20201213003410.GB2786309@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f58e7427-22fa-49ee-df86-08d89f00f585
x-ms-traffictypediagnostic: VI1PR04MB4222:
x-microsoft-antispam-prvs: <VI1PR04MB42226713EFFC9B96BBF911EDE0C80@VI1PR04MB4222.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rsnZKjDkyK+raS3tboHo62rKcJV92OnwMD+YrbJAjCZj7jXdzLJQXNJ/ry/LkU3XxoK5UYD9+DaQCCvSskxpdC90NMo/yRdXGZrGYEXFeQmYF6T495D3mzK0lVQmMbp7c//GAcQShmtypEQV/kAUeqFhMQ73UgnfR+KealXis9zLjtp7ZwegQsOeqHXz8029VCcjjeoMt7abhLVx031lZlKoBdTqmLY9B+PqTGaPPpJbRMeABbZJ5w3pdzWXTwDNZBGvrES77qYxy3ebJAFoQaZFYhfzRxirICvDjK+c8Xk9kgOyL76Mx/QEc40D0kRhkP+FC5ubf/fRNm90U/gSVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(396003)(346002)(136003)(376002)(366004)(83380400001)(66946007)(1076003)(76116006)(86362001)(44832011)(64756008)(66446008)(2906002)(66556008)(4326008)(9686003)(6512007)(66476007)(6486002)(478600001)(6506007)(26005)(5660300002)(8936002)(8676002)(3716004)(54906003)(316002)(110136005)(33716001)(186003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UvamGm2129Dc6OmQlYIG5zfXuHf5s6AWnmIMfwDlERbXQC5SPRAFJzqrBm1L?=
 =?us-ascii?Q?ja33+OKsK6y8GDu71E/iyWhn3xwN1SHWzO23cVMXvo0gLkbvRVT+XuqTGKvx?=
 =?us-ascii?Q?AmWEo3D7uUhXx/rNnCqxrvdIZNDujBEPzkPBH9HSE/boMHU/nFVsgavQHwAR?=
 =?us-ascii?Q?TA+5lvz5Gpy6V7iWL1PLpQLRuCE1852um8YLWU6hhGHruJL0pTpmtrkKIaLs?=
 =?us-ascii?Q?SPX4DpobOV0ddix/Jx8OzcmO17U4PLe2sA357agapzmmoVOEmkktq9q1adOn?=
 =?us-ascii?Q?wADtlbB+69Y9IO8YqoG2zlPXBXW6z1LNXxljjylbqL+tEpbR12GiI4MtXfY9?=
 =?us-ascii?Q?7Zqo8V6FMT4jWuJNpNbMZtRl9dijepz1kFKHPxqnb128ZUUTUYHv2SIomLyX?=
 =?us-ascii?Q?IS0wGywYNq2906Bv/zq06E/nLdNIL9D9jQPoOtgZZf6Cy290M4aEBSpLQB5h?=
 =?us-ascii?Q?xv5jV7Sqajn7AaU3yKl0Kl9H7fJqTLkuZSiDObJqglfbuhoCO4kjuJY8oNUG?=
 =?us-ascii?Q?L9bnePcUH+MY48AdV7rVwDbzQRYzJbWV6xjhm3yXoyrRFUe3s3ibr5UWORSy?=
 =?us-ascii?Q?Ojy0obb9JT4RhgUxciSM4cyhshi8R5SrfC0Tu4ktCEmvNLyAVXF1CuHgam6s?=
 =?us-ascii?Q?OOZvthnMQO8sDjecBp8IC+XZz356aq489LdBLep+EKQ64VNVdfr7veyqaLDA?=
 =?us-ascii?Q?+sbFeaYIj5d36mn004TcYuB2tjgKDurclr2E7mBf9oC0blhVdL9sLk9hIjta?=
 =?us-ascii?Q?gbbd8bewSdj/mocXxBKWPuD5ttj8lhFLUKwHk0aOYa0YLJ4qIAtKFXwNKZaC?=
 =?us-ascii?Q?THj83Zo4WpsGyXZTLmTPM0cghWpSkmAuOiqko2YUbKaWeBjmCg1NMhamm+eX?=
 =?us-ascii?Q?WcG0vvjh5OWYxdKi6lACkExu5lthLhL4AthmzZGrkZtD8WvYD2A5VJ9n3NVO?=
 =?us-ascii?Q?Rdg4kK+WHI3kR503Kgk+/b0jqcuFXmcpU1FVG/ScrGpTy62P51Kzq2PMHIzQ?=
 =?us-ascii?Q?AIcS?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3AA0C56C1CCF94D94D17679D9A66672@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58e7427-22fa-49ee-df86-08d89f00f585
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2020 00:49:33.9593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 656MZTYjxModlQEfSk+cWY1r88h/Z9MAKvGTlPjlYN5pwf+nqMhNYGfw1LzF3VvdP/Vj3JKd+c+oc8wwIKAvEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 01:34:10AM +0100, Andrew Lunn wrote:
> On Sun, Dec 13, 2020 at 12:14:19AM +0000, Vladimir Oltean wrote:
> > On Sun, Dec 13, 2020 at 01:08:55AM +0100, Andrew Lunn wrote:
> > > > > And you need some way to cleanup the allocated memory when the co=
mmit
> > > > > never happens because some other layer has said No!
> > > >
> > > > So this would be a fatal problem with the switchdev transactional m=
odel
> > > > if I am not misunderstanding it. On one hand there's this nice, bub=
bly
> > > > idea that you should preallocate memory in the prepare phase, so th=
at
> > > > there's one reason less to fail at commit time. But on the other ha=
nd,
> > > > if "the commit phase might never happen" is even a remove possibili=
ty,
> > > > all of that goes to trash - how are you even supposed to free the
> > > > preallocated memory.
> > >
> > > It can definitely happen, that commit is never called:
> > >
> > > static int switchdev_port_obj_add_now(struct net_device *dev,
> > >                                       const struct switchdev_obj *obj=
,
> > >                                       struct netlink_ext_ack *extack)
> > > {
> > >
> > >        /* Phase I: prepare for obj add. Driver/device should fail
> > >          * here if there are going to be issues in the commit phase,
> > >          * such as lack of resources or support.  The driver/device
> > >          * should reserve resources needed for the commit phase here,
> > >          * but should not commit the obj.
> > >          */
> > >
> > >         trans.ph_prepare =3D true;
> > >         err =3D switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
> > >                                         dev, obj, &trans, extack);
> > >         if (err)
> > >                 return err;
> > >
> > >         /* Phase II: commit obj add.  This cannot fail as a fault
> > >          * of driver/device.  If it does, it's a bug in the driver/de=
vice
> > >          * because the driver said everythings was OK in phase I.
> > >          */
> > >
> > >         trans.ph_prepare =3D false;
> > >         err =3D switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
> > >                                         dev, obj, &trans, extack);
> > >         WARN(err, "%s: Commit of object (id=3D%d) failed.\n", dev->na=
me, obj->id);
> > >
> > >         return err;
> > >
> > > So if any notifier returns an error during prepare, the commit is
> > > never called.
> > >
> > > So the memory you allocated and added to the list may never get
> > > used. Its refcount stays zero.  Which is why i suggested making the
> > > MDB remove call do a general garbage collect. It is not perfect, the
> > > cleanup could be deferred a long time, but is should get removed
> > > eventually.
> >=20
> > What would the garbage collection look like?
>=20
>         struct dsa_host_addr *a;
>=20
>         list_for_each_entry_safe(a, addr_list, list)
> 		if (refcount_read(&a->refcount) =3D=3D 0) {
> 			list_del(&a->list);
> 			free(a);
> 		}
> 	}

Sorry, this seems a bit absurd. The code is already absurdly complicated
as is. I don't want to go against the current and add more unjustified
nonsense instead of taking a step back, which I should have done earlier.
I thought this transactional API was supposed to help. Though I scanned
the kernel tree a bit and I fail to understand whom it helps exactly.
What I see is that the whole 'transaction' spans only the length of the
switchdev_port_attr_set_now function.

Am I right to say that there is no in-kernel code that depends upon the
switchdev transaction model right now, as it's completely hidden away
from callers? As in, we could just squash the two switchdev_port_attr_notif=
y
calls into one and nothing would functionally change for the callers of
switchdev_port_attr_set?
Why don't we do just that? I might be completely blind, but I am getting
the feeling that this idea has not aged very well.

Florian, has anything happened in the meantime since this commit of yours?

commit 91cf8eceffc131d41f098351e1b290bdaab45ea7
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed Feb 27 16:29:16 2019 -0800

    switchdev: Remove unused transaction item queue

    There are no more in tree users of the
    switchdev_trans_item_{dequeue,enqueue} or switchdev_trans_item structur=
e
    in the kernel since commit 00fc0c51e35b ("rocker: Change world_ops API
    and implementation to be switchdev independant").

    Remove this unused code and update the documentation accordingly since.

    Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
    Acked-by: Jiri Pirko <jiri@mellanox.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

There isn't an API to hold this stuff any longer. So let's go back to
the implementation from v2, with memory allocation in the commit phase.
The way forward anyway is probably not to add a garbage collector in
DSA, but to fold the prepare and commit phases into one.=
