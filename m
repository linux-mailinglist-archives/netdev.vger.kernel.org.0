Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6700293258
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389429AbgJTA22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:28:28 -0400
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:37440
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389215AbgJTA22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:28:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYlFUewdtRpwBSbdOSxJAvqsVnh1yTfZCUGKRIngrXLOycxNrKzr5Y8zjcMkL2Fz0U2H0nEEH1aO+x8edN9LCvLR2OPJOn+LBxza1ElDZ6Y928TSf9CuhwYIucZDWyUcvsc9HP3DpxKd6r+BEmTCJzmh1NUPia7pj+qPRnX6MGZeptzPVsHqZ9T5k4pEqH7St8ayJVnryH9f9WdkDAX4YwKcNhVIrBRtYKQ35pS1dY5qIkz+vvub03KoFwpDOKpYOpJY30PQd0EtcEA5GFL5PHmYMj14GhBCuWuVZ/yz/R/wD+upvLzD1QxEi8IR+w/BrAKcgz6Ku0CAYem+qU6+eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dPrOhxfNqPCvrokyrXB/NjuZ+L0PVu1sLi8U7XuUh8=;
 b=O9dS0WurJ8gFRZMG2ecD41hNELo3BcZdcDXqyOiQxDxviLNL5BXdW88wP/We63M93v5KwPdC2wq51qezfQ/8jb5LBU40k5zkUPjsmXTNe/IHygjGvsql6qxRI9Uu+1pYsFKditLsyj5rP75AbqbGin0x73Q03hWbcxkuhXKvEtbiX6CjvRVuT04eGVTE5y/BC5kr/0fIFjBkQM0BkLvNpBHXXWyMkLWhilRYZE992R3bUuG5RwePITLnYkSilf24AyzmHBQcY1zPifQ2S8XTCZXGrRD7OSI9gN5HVjTbSL9Ft5PXef2nbVxlR/dxjTsSkO1N9mGX9upwINJ+voc0hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dPrOhxfNqPCvrokyrXB/NjuZ+L0PVu1sLi8U7XuUh8=;
 b=K4RvramG4rJOMeyz/8+UpgSPUNZOHNoeCAmPQ4F8RWpzpjN1JVgWT1ut+UixeQy+HGpmJkWKksxPeCx5En6GWYl6QGC67co7iw/E2AwWCD3NCmfHu5iEehL+YTgZWMHbAaxR8Iwsa2/dLesYM/drglkmLqg1TV1Nu6Z21N1xYRw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Tue, 20 Oct
 2020 00:28:25 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 00:28:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
Thread-Topic: [PATCH net] net: dsa: reference count the host mdb addresses
Thread-Index: AQHWozn45OsHCx59Jk67oCoKlCMeg6mfo0cAgAAGG4A=
Date:   Tue, 20 Oct 2020 00:28:24 +0000
Message-ID: <20201020002823.jedjcn6hp5gyfdib@skbuf>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
 <20201020000632.GQ456889@lunn.ch>
In-Reply-To: <20201020000632.GQ456889@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f829c164-7624-4f62-71aa-08d8748f0ecd
x-ms-traffictypediagnostic: VI1PR0402MB3549:
x-microsoft-antispam-prvs: <VI1PR0402MB35491DE0C9C76B4922D8ECC9E01F0@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mW0+jrXxh33+mB7AOsXIpUXZ8mVE9C65qphi8Kk9swRHiA1lMijyqwrcxDF7nURxePcLjSEeMV/PKcXRO3cT3Pa0PrHTSu9I0wXLsAWcBfOlWIP4AeL/zlnRIy5hIR+gFznQHNSTx6sMNBu9gnjAuor2dlX/AE07uyJvoVZC6JF7VypvnmFE8gPEKwgytWA87WNOV1Q+iSdXdkhj2gG1JKMs7cjdYJ1tGdp3IL1E16dul1E8gnbxJ5E0DmA55AIJSyAlEf0EQ/UmoiwHGKAx3mehaGhuRl+WkwGjmCZOChhweASYVk67Nu8fOanoy9gl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(366004)(396003)(39860400002)(376002)(346002)(8936002)(2906002)(4326008)(6486002)(6916009)(316002)(54906003)(8676002)(83380400001)(33716001)(6506007)(64756008)(478600001)(186003)(1076003)(6512007)(9686003)(5660300002)(66556008)(44832011)(66446008)(76116006)(91956017)(86362001)(66476007)(71200400001)(26005)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QsDScgN1qbHSSEw+awUZWJwB8Bh2BXSVlityLS3Yen+IOMupTikOpB90ONKn8lxMH4tjCqofbUJ3Jxw6UxnNWp10tRuLTl8JG6gvVcQFU1+Oh3tEduPkG4+xhb8bAE+0xyMMY3yZLmeuYxOnfy3Sc3hxFf3KWCwGXRO6iNPdUeG4Nrze2vv/BtuuZfCwXMicO2TEfpZQkXZO02k/2veHkJyC3Zek6NHuqcXHbXdj/qgmC4800EJV/ZZZiizAr+Ypgh2bxp4FbYBs6rqNvqwtxw8buwjtYrL/em3vpFd0TT25MhIY15Rmp+/wDWtD61FG/lcRZt5gg0Kuz0xPVVmWMEPJFB5Sljo588SeZ/V2pvHsc0B6aA6kySCOwlQWgDX3Bqp1nr3AZ+OPvuqkY+Smi2v0QP9Y86TValb/XFjmoeIUG5xGU2p5Pj9AP4JdFzjea43KX+ScsHXmvx+9pXjELzcU8YuKRAtiA/GoYZb/39dUvGPZabfQwn/dw6A1wNvnMAp57Patr7JTFkeIWWEaobCapWv15JqOskFi250EgjWuENj1aVrdneTZv6Lg70nhZ5dTsVvIHvUsCRSzrfe4/Ds6sBCEGJcuRK6Do9nBOuj7TleXsPgFGpNz/uxESu+joKhrKy98LkJJdDYGAmqelA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5750201EC1E13F478B31964247D973A8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f829c164-7624-4f62-71aa-08d8748f0ecd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 00:28:24.9715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N4eMp+u/T5cfMqecuauEUwt6gbSJSvobvM4YP6StaDP79egqxzSwygIlsltC3W4N1FVv2xdlKJz7yyTwTqVzkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 02:06:32AM +0200, Andrew Lunn wrote:
> I agree with the analysis. This is how i designed it!
[...]
> So i decided to keep it KISS and not bother with reference counting.

Well, I can't argue with that then...

> The other part of the argument is that DSA is stateless, in that there
> is no dynamic memory allocation. Drivers are also stateless in terms
> of dynamically allocating memory.

And is that some sort of design goal? I think you'll run out of things
to do very quickly if you set out to never call kmalloc().

> So, what value do this code add? Why do we actually need reference
> counting?

Well, for one thing, if you have multiple bridge interfaces spanning the
ports of a single switch ASIC (and this is not uncommon with port count > 4=
)
then you'll have the timer expiry from one bridge clear the host MDB
entries of the other. Weird. And in general, you can't just "add first,
delete first" with this type of things. I actually got some pushback
from Vivien an year ago on a topic very similar to this: in the other
place where DSA is "lazy" and does not implement refcounting, which is
VLANs on the CPU port, at least the VLAN is not deleted. That would be
more correct, at least, than performing 6 additions, then 1 single
deletion which would invalidate the entry for all the other ports.

Also, I am taking the opportunity to add the refcounting infrastructure
for host FDB entries (this goes back to the patch series about DSA RX
filtering). At the moment, host addresses are added from a single type
of source (aka, a switchdev HOST_MDB object). But with unicast, there
could be more than one sources that a unicast address could be
added from:
- the MAC addresses of the ports. These addresses should be installed as
  host FDB entries
- the MAC addresses of the upper interfaces. Similar argument here.
- the local (master) FDB of the bridge. My plan of record is to offload
  this using a new switchdev HOST_FDB object, similar to what you've
  done for HOST_MDB.
In this case, having reference counting is pretty much something to
have, when an address could come from more than one place, we wouldn't
want to break anything.
Also, consider what happens when you start having the ability to install
the MAC address of the switch ports as a host FDB entry. DSA configures
all interfaces to have the same MAC address, which is inherited from the
master's MAC address. But you can also change the MAC address of a
switch interface. What do you do with the old one? Do you delete it? Do
you keep it? If you don't delete it, you might run out of FDB space
after enough MAC address changes. If you delete it, you might break
traffic for the other switch ports that are still using it...=
