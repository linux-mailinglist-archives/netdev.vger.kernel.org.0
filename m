Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05B23FE7EB
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 05:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhIBDPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 23:15:19 -0400
Received: from mail-db8eur05on2072.outbound.protection.outlook.com ([40.107.20.72]:29792
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230369AbhIBDPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 23:15:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjGGn+gQ5Nkfsu+JTlgS7KQe94/zKQlSQgxgY1GXY2BeSsnsyNH0lTPobICDQvabY0MwdS4wjji8nCJIkgitGInVXbrI7EcGsgRcli6JvDJ2AYKU30c0u088+sd4lAGTlGi5aHgoH4BfqFA6l0RXWLK5Efkhr+Xl+8vLq1PbXcYYovp2RvNm3gNu7kv1WIsRtyUF4ppRZKDbPZyfn39/+2tJhLQzgPqYzQJ7UlkklEFLuktKgXPVQytJUO9WhKDnYyj9+eRpCclUak8lyeZHeDXXyqUqsVw1kgxM8j1Sd7hQJraQRjAuMYrL8LWU87jIXp8ifsgBKU5TTcBIHoqSKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKHfNWBpXSfd9NoZw9w9r5FOSYzlr+dp9qzbtbLLG4g=;
 b=ce1LthEjTHPegTXmFFDLMkKJb5S4Jn3L8CIgdqn09YVuPcEmEX04/pc9ik956k8P9tcaHbJmZgI0kA63dPF8mmgt7dvGaz6JY/rKIZLnOYyiLaupGb9+J9BYx6Ud2pFpqJY1WkfykoReQWTkBYCIy8d3F+COhkVAclkV26+Ath8yxC11luqNlZYy6KrFwk6a+UPNIs1ocCmMZKGm15d8TPpnwZqcgWsyrstSCk3J+ko0LOVnchcfOATYirdBHa54UTp/JOnjfmTA/VtW8Gn5+S+2Kq/IBkSU6UsADMl/KJGXdzpA+6TSghb8uxjKETIkotSSz3WFhLabyZl3kzWqSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKHfNWBpXSfd9NoZw9w9r5FOSYzlr+dp9qzbtbLLG4g=;
 b=eHIB8+H1JFYi9/FUtoSo8pacyGgArUI1Xt6h1NJMfZZxEj0FqKTzB6CjBH2v7uha/Ul61K+Tq9faq2hNArZ3bbCQvEP/do7BsBHL8lyrruFRLCn0JvIY6JuMAr//vYCR99xMSHhq4GoLV9oTFxE8erKELbtPlRnFExC9Gjsz/Z4=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB9PR04MB8204.eurprd04.prod.outlook.com (2603:10a6:10:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Thu, 2 Sep
 2021 03:14:18 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc%7]) with mapi id 15.20.4478.021; Thu, 2 Sep 2021
 03:14:18 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3XLn1mK+aKEKIkxNIly6FZauNPsGAgAADucCAAAqfgIAAAG6ggAAFpICAAALSAIAAA8DQgAAVvQCAAp+xYA==
Date:   Thu, 2 Sep 2021 03:14:18 +0000
Message-ID: <DB8PR04MB578560774FBE36E6CCDABE02F0CE9@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831084610.gadyyrkm4fwzf6hp@skbuf>
 <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831090754.3z7ihy3iqn6ixyhh@skbuf>
 <20210831091759.dacg377d7jsiuylp@skbuf>
 <DB8PR04MB57855C49E4564A8B79C991C3F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831104913.g3n6dov6gwflc3pm@skbuf>
In-Reply-To: <20210831104913.g3n6dov6gwflc3pm@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31f9de97-0543-4e53-9927-08d96dbfc055
x-ms-traffictypediagnostic: DB9PR04MB8204:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB82045C7DC6B2FC3BA5064A18F0CE9@DB9PR04MB8204.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bnPtfdvQl/8G74C1ctaX5pYcAVjayb8a+IDe+Of3GKcAlWLipn18mxT6qTXKnVI+IgXqm2q1+ZbKrC/otR7hC4SUPKSgRoeYWsnyHn4dSM+zDEPfKbcrhrbCxLtNVQlQrT/4fdO1HSzKQxq/MIWc5o5mmloIuWafkITWBV9iddAs9TTaZIrU0XdifjxkngEyt1YM12NxJ2dI/O9fFs6cPCOtXsoSti8XJDC+TLhuYmKRQLi0vd3+7XmXv2XvwgUILQ2JyYJxWrhJuY4VbUk45TRUcEBh77vT+aPx24Uvef84Rd9j3Q5lcLqATmsQfhiTkqfrlLmUcpmHL+wWdzWUpvlFGirmeyJVnq+QolOIR9xAiZRDj3ulB/ZCr9JJ0gJpjLa9p4jiGIJaWzTYx08dts9NdmJma0hWkkzblZLxwTyeyjMW5IncLnDQyuTMAXp1U+FobRZmC9+vplU9lbQ0BgS4VKCILk6eY06zxrmdCPs6eNYXXAeGHbH+rkggM6CGy3oK6IeJMu1cB64tBHATKfBI88dqkBZzmlX59YINeaFNaL/XBO19wb53mVARq/sz/vzupBfKwTlF+m/Vlh3rvBFSPzHpIEJBxLpniAuEuACnDb+I0bzlWYKvfnQ/80xqsTBzi196yQfXxYE+KbfKcYXOOiHsTfXBrG5zgKLEMEIHqH3ceTjoISq8EV0gOJ2XKJC9wQCrrYUlNS3aj/U4TYMcnajRdsWTDjlD692uw6dt9ZVB5qU5XFPvaUgM+rItChWT4eX73wuTGfUS+XaAUVfGxHZo3qeAVcKDeEIa1OE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(8936002)(71200400001)(9686003)(4326008)(7416002)(33656002)(52536014)(66476007)(186003)(26005)(2906002)(83380400001)(86362001)(110136005)(5660300002)(64756008)(66446008)(478600001)(316002)(38100700002)(7696005)(8676002)(6506007)(66946007)(122000001)(38070700005)(55016002)(76116006)(66556008)(966005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G0EVDInqspihxCHP/qups6lbrfvZ0WrwMrFW4U22WOOojVGOhasEPXJOa6SM?=
 =?us-ascii?Q?v0UEVVI/LMUTq0SBreReW3Jsu5EerMiKh01mbyQ7Vd589cjzqg7WKBsmbcd2?=
 =?us-ascii?Q?iBW2Dwk0orCbiHNqivyHSJlYRD2nI7TSdkTLEVxH/ZVHGsCtI88BlZlhy4Ic?=
 =?us-ascii?Q?NGsmoIqxzqBkX6r6XL2gbjm7So5xnniHPLiCsWXemv8gUOaaqNfqAMw2k3Sh?=
 =?us-ascii?Q?dBUvH3b0r8izji5JhNc0kNP/kXyVahNp7kWdfiyjuqCjlx/e72z+AwRtkEbW?=
 =?us-ascii?Q?/Of+Eq4HzQKy7WjLjSMY9QOBo5AJQ7uZXXDIQ9aoVwjHWM2OHBi9HmkZXxT5?=
 =?us-ascii?Q?Pjncg2Iv6fAvPlArsP+6EjHL22fV+XCXm7oKF9Lr2MZcf9FxxlkTK38Xxq1R?=
 =?us-ascii?Q?YSUlUsJhZDgsPyEI8jF1DD0xUv5eADpMaFP82w54dqy9pZbhgjcfDNPFpyrV?=
 =?us-ascii?Q?8CRlYFRqkx6Tjrjev3Spe2q/aeYRxauKAEj4TQpSe0511WFaxGTqcDPRKECm?=
 =?us-ascii?Q?qKLt4r0k6PvvhZ0EjStY+tFjsT/ChOQPTgK2xJkPC3t1CoNzj+BmG98gUVIG?=
 =?us-ascii?Q?IX71pkHSNVIFoepQJEGiR80dDllcBs8PatpvXh5yKnJBsjr558mD8vbRf6OZ?=
 =?us-ascii?Q?6TUI1CJ9R6yq75PT+iiwCarL2QABom12ymZADtGmrvKAaShQKFNYQt0RDSay?=
 =?us-ascii?Q?aQrSUNfwNwVk+vK/S2nwZjE3RdU7VGtdHFTJPl5heNjLJVjV5ONbK5C/PDNl?=
 =?us-ascii?Q?L6Zg/F5nNstuB9ZIYJobgOYR7r5q6wNEz8C/S66iTbo86Ie1vsMgBOj0Xi17?=
 =?us-ascii?Q?VDGKFytpDSUzgTZijZHoPCUiJ53aRPJiw0K0t7ocLgB6Iwjvui2v+zJKcRvm?=
 =?us-ascii?Q?OlcKWfSBUexwMJw/Gwy3rYjIxRuRUpw7Y4Dw5Slz/WR11cgNVW0h9qa3YYdh?=
 =?us-ascii?Q?82tXC+GGCjsU5/QiDlJP8q3uP0q16zIaFLPgIPOjUXJnLqxYe80ULH8Y8oVB?=
 =?us-ascii?Q?KAiOkudig6M50br+KjqVqOlTV9/F6eWDbtSsrckt4nkkZ6zumc79YUjr9A5h?=
 =?us-ascii?Q?+uNlzBbREV00QPeIEIKGxCs1z8W+In77bRM+BQGO1A8MMePGtx/SQCgQ0Uqt?=
 =?us-ascii?Q?NcXB1/neODNrB8JfRwnQE1Cldd+fYyjZyb0nzXoodW6r3L5LGNF9U091wy73?=
 =?us-ascii?Q?EziAKIJKAPM1GFfqSwfzlrVk/4NlbAlkV3OTfMOfdL3GoqtMJfar6Xh7x8Q9?=
 =?us-ascii?Q?jJbZ+KKIxFyLtoaXNQ60BgYS09EfCiesKLomT3vZK2pdR9uJWpoXvQLn1Xfj?=
 =?us-ascii?Q?GRAXdo5alxFGywEzfYBXy0hY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f9de97-0543-4e53-9927-08d96dbfc055
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 03:14:18.0763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SS3QPYh29nUN79/wFH3CNDiu0thcQhPe2gdxVh+okbUV1tf9FhZmk4+it2fTy83vtPvnjL7cgvGkR/3jzYwA90VIvE1A8R3o4SPHPx9E46U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8204
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


=20
On Tue, Aug 31, 2021 at 18:49:53PM +0300, Vladimir Oltean wrote
> On Tue, Aug 31, 2021 at 09:59:11AM +0000, Xiaoliang Yang wrote:
> > On Tue, Aug 31, 2021 at 17:18:00PM +0300, Vladimir Oltean wrote:
> > > > > > I think in previous versions you were automatically installing
> > > > > > a static MAC table entry when one was not present (either it
> > > > > > was absent, or the entry was dynamically learned). Why did that
> change?
> > > > >
> > > > > The PSFP gate and police action are set on ingress port, and "
> > > > > tc-filter" has no parameter to set the forward port for the
> > > > > filtered stream. And I also think that adding a FDB mac entry in
> > > > > tc-filter command is not good.
> > > >
> > > > Fair enough, but if that's what you want, we'll need to think a
> > > > lot harder about how this needs to be modeled.
> > > >
> > > > Would you not have to protect against a 'bridge fdb del' erasing
> > > > your MAC table entry after you've set up the TSN stream on it?
> > > >
> > > > Right now, DSA does not even call the driver's .port_fdb_del
> > > > method from atomic context, just from deferred work context. So
> > > > even if you wanted to complain and say "cannot remove FDB entry
> > > > until SFID stops pointing at it", that would not be possible with t=
oday's
> code structure.
> > > >
> > > > And what would you do if the bridge wants to delete the FDB entry
> > > > irrevocably, like when the user wants to delete the bridge in its
> > > > entirety? You would still remain with filters in tc which are not
> > > > backed by any MAC table entry.
> > > >
> > > > Hmm..
> > > > Either the TSN standards for PSFP and FRER are meant to be
> > > > implemented within the bridge driver itself, and not as part of
> > > > tc, or the Microchip implementation is very weird for wiring them
> > > > into the bridge MAC
> > > table.
> > > >
> > > > Microchip people, any comments?
> > >
> > > In sja1105's implementation of PSFP (which is not standard-compliant
> > > as it is based on TTEthernet, but makes more sense anyway), the
> > > Virtual Links (SFIDs
> > > here) are not based on the FDB table, but match only on the given sou=
rce
> port.
> > > They behave much more like ACL entries.
> > > The way I've modeled them in Linux was to force the user to offload
> > > multiple actions for the same tc-filter, both a redirect action and a
> police/gate action.
> > > https://www.kernel.org/doc/html/latest/networking/dsa/sja1105.html#t
> > > ime-b
> > > ased-ingress-policing
> > >
> > > I'm not saying this helps you, I'm just saying maybe the Microchip
> > > implementation is strange, but then again, I might be looking the
> > > wrong way at it.
> >
> > Yes, Using redirect action can give PSFP filter a forward port to add
> > MAC table entry. But it also has the issue that when using "bridge fdb
> > del" to delete the MAC entry will cause the tc-filter rule not
> > working.
>=20
> We need to define the expected behavior.
>=20
> As far as the 802.1Q-2018 spec is concerned, there is no logical dependen=
cy
> between the FDB lookup and the PSFP streams. But there seems to be no
> explicit text that forbids it either, though.
>=20
> If you install a tc-redirect rule and offload it as a bridge FDB entry, i=
t needs to
> behave like a tc-redirect rule and not a bridge FDB entry.
> So it only needs to match on the intended source port. I don't believe th=
at is
> possible. If it is, let's do that.
>=20
> To me, putting PSFP inside the bridge driver is completely outside of the
> question. There is no evidence that it belongs there, and there are switc=
h
> implementations from other vendors where the FDB lookup process is
> completely independent from the Qci stream identification process.
> Anyway, this strategy of combining the two could only work for the NULL
> stream identifiers in the first place (MAC DA + VLAN ID), not for the oth=
ers (IP
> Stream identification etc etc).
>=20
> So what remains, if nothing else is possible, is to require the user to m=
anage
> the bridge FDB entries, and make sure that the kernel side is sane, and d=
oes
> not remain with broken data structures. That is going to be a PITA both f=
or the
> user and for the kernel side, because we are going to make the tc-flower =
filters
> effectively depend upon the bridge state.
>=20
> Let's wait for some feedback from Microchip engineers, how they envisione=
d
> this to be integrated with operating systems.

Yes, Since the PSFP hardware module relies on the MAC table, this requires =
the
User to manage bridge FDB entries to ensure PSFP works. Only set PSFP on th=
e
existing MAC table entries to ensure consistency.

Any comments from Microchip engineers?
