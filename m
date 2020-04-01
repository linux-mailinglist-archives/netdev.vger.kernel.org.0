Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE8A19ACF5
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732687AbgDANfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 09:35:39 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:23694
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732234AbgDANfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 09:35:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwZrNGASAEIMmi/Fbpp5720fehN0PqrILUst2exxxoCjM/jscohxt7W+rayT9l0kzix/UHaG59tPJxlKmMR9GpcftWJtn9y/NY4oT4omX+8MHsWb/jqfXoZiX8BlxD+061B+vWqvfgUWoM9sfZgyaMnOP6da2/EtOVBsFTw9MNjLzsgN39ZZCJJzCJ1rzEkEy18kjB+rvwGxb+d2bPnKblHFep6t3xhAgtrMVxC82CIDjqF01rWw1JJEymrrNC7/PqxJMaduKutYkZol3aWTZOZin/iYxiPBIlcykxwebwsPc9XU/3qG4QxzznHijd+GBTLAyHj5fkSxOLbXourhtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeVzIt7CF8mz3KyY0kXWw88dSf23A6KMONTj/JNY7j4=;
 b=KoRWB+tTRpyDOuyYeaeZSIDOflAQJXvV9/h5giEyPrK+/iIg4viYEEpITHFNIGVA6e0JGCoVSiTbaoFyQlnyrfbUDNwRGwHISQ5bpban9AcwKfO/XJCvOumBRSimTrq0b9fcBEpsp5Fh2JOE3JMgn9Cm3Kw8yYkXNJlqPqyA/4xIuNeF4yD9R8j92TZ8YRRD0AMmm0M66Att8JVY2OVvBHLei/CqIKvgJWXcNe3XfIzL4qeKx6v85LI1uo7FoaoH8/T4YQXPEBU6QV1FmmRv9K9zYaz3GS8X+wl8D5Mg/mMe5iYWPRqo66fb1mywwvlQjbD1tzn4wajJ0DyglNPCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeVzIt7CF8mz3KyY0kXWw88dSf23A6KMONTj/JNY7j4=;
 b=KAywp385sybYlT9YOn+ei49NBVQyX5Xmv0CEg0aSI+qkPgVMhtf73Aukfc9PzTJv05QWwEMehXyANgfO1erz+zQpMntt+/pmT98YaJPGVfGjG7cWZkhp0pGdPC0sKQNcx8oXA8NGav8QujLGqeOaHsHQrbOBJ7lsZgiuSQ2mjmg=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (20.178.114.161) by
 AM0PR04MB4162.eurprd04.prod.outlook.com (52.134.95.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Wed, 1 Apr 2020 13:35:36 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 13:35:36 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Thread-Topic: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Thread-Index: AdYIKJUsx3bt4MTYS3+XcE5ss4tWhQ==
Date:   Wed, 1 Apr 2020 13:35:36 +0000
Message-ID: <AM0PR04MB5443E8D583734C98C54C519EFBC90@AM0PR04MB5443.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [78.96.99.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7dc65ab3-0c72-45bc-2333-08d7d6418f58
x-ms-traffictypediagnostic: AM0PR04MB4162:|AM0PR04MB4162:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB4162D2164C984F7FD0E2920FFBC90@AM0PR04MB4162.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(316002)(66446008)(52536014)(76116006)(86362001)(26005)(33656002)(54906003)(7696005)(2906002)(4326008)(186003)(44832011)(478600001)(6506007)(7416002)(81166006)(66476007)(66946007)(64756008)(6916009)(9686003)(55016002)(71200400001)(8676002)(81156014)(66556008)(8936002)(5660300002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U+VvETLqJzsG0PXejmXRJI3YiO67BEJYZHh9EBnALJZxLoV2OX0q3RbfhL76eIJtenZsKDmGNXn974OIkwAkFn/wv91ng4Tnvajn5mD4UQ5REHCeePtVe/Qdn1qsjfybF3FglcXFGnowCicEdbtjZqVp8pS9QhUAiUKo6qSpFSEg4AIFtCZqyTzT6XPpKEIH6QUPg6F1F1a3f7NWoNPZxKfRwGquOnsBUxXs0FT1alcSTR/oAAlXvq6ZKoC33xKF1l3EUSnK/ONqxjyfsMV2kF3xbiO+ZsZELjJF9sAekd4HW+H2EGBv5tFLLLyAh1s6sp6ZTO7XVDQ+jIOM9bujqHRsyg66mAbQCLc1dMQI7ynN5QrhOlC0wDBH1T9lmudO9u7eVN1pictTaMfqg3FGF/6z+hzHJbKm8ZvZiuuvNX5S+KtyWk+WJfP0VwArJSev
x-ms-exchange-antispam-messagedata: dN1cRpkFrALDWn4dY7JJ3Z9uOUzfPwbIcnKmMcr/5bCQgPvF8LiX7TJd3f3JOBjlZEJLjG5PDg+iP0miF3Yqm9mvbDnEE0aLUBdh4GuOaKgzIV4ogWcgrTZVPs1ePKXXHPVDpSygWxM64uQBCEvIVA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc65ab3-0c72-45bc-2333-08d7d6418f58
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 13:35:36.0721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n3Mu8uAD0O44eAQQuicGWFMroX4NsW6uOM4mF6TwdoaXeuoor2GTpuhmi5dSw8tD68fm+JSrQXQNbpviSb7pnMnfth4hWmrNpMy8xHQDTuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4162
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Mar 26, 2020 at 03:51:19PM +0200, Florinel Iordache wrote:
> > +static void setup_supported_linkmode(struct phy_device *bpphy) {
> > +     struct backplane_phy_info *bp_phy =3D bpphy->priv;
>=20
> I'm not sure it is a good idea to completely take over phydev->priv like =
this, in
> what is just helper code. What if the PHY driver needs memory of its own?=
 There
> are a few examples of this already in other PHY drivers. Could a KR PHY c=
ontain
> a temperature sensor? Could it contain statistics counters which need
> accumulating?
>=20
>         Andrew

Backplane KR driver allocates memory for structure backplane_phy_info
which is saved in phydev->priv. After all this is the purpose of priv
according to its description in phy.h: <<private data pointer For use
by PHYs to maintain extra state>>. Here the priv is used to maintain
extra state needed for backplane. This way the backplane specific data
becomes available for all PHY callbacks (defined in struct phy_driver)
that receive a pointer to phy_device structure. This initial version
doesn't include accumulating statistics counters but we have in plan
to add these in future versions. The counters will be kept in specific
structures as members of the main backplane data mentioned above
and entire support will be integrated with ethtool.

Florin.
