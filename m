Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6EB2920AE
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 02:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgJSAV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 20:21:29 -0400
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:11239
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729789AbgJSAV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 20:21:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mho1wxntNFSDoCQqUHdhDLqszflAFwNz3CNQh+1/u236CAuGAJZFKGgRUUHcxai/hM+ASvoRA4DINfpY/D2sneWlSE1KAEbzJpqlSKgvCj6TDjbUsmM4Pie9G2Z0r1A+CLvoTThQvFJfdcCZYG97nfe0PGuhidddlLGfgPf7cdsrcqRyAHBZeltW3FvAxKVl1YLZ25yJJgKizvTrclA8d+epmxHe5+X8aX29fsDJcR0wSTGSNqqiDGq3IMJ22pxfemVbVkcNAG0i+wCr7LppwFqwG+yZbzHrHLU20bMeMR5MxD7Wu+whYFDodsd75jJ32VlwY0DbwA3NNvBdcvnVBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WV9TTb6B6AurHCagsySCPCeGg94pUSyIS3zrLWXLk1I=;
 b=BSWA+nQ5FYFEZPTZtlWSiWGofR3JQ2KY4P0ROc/9x7rUnPkup0TA79dkFjMUJY2lcGRKVgEInr13kwb1kRQVC08cjH9iQEdkR2YlYN9U+ipeVEbmE+sgT4RSdVITa3rRV24a3SPmH+Yz4Q3o5ZpX5//j0TOIRSyrqiZt7SRonlTxHSCdRaQmUWVSTL0uU4RV6KD5/1j05xgcbbWW41LMf858QCJLxxGEFNDrQW5ahLQEmv3JEJqVaS+1N9YjH7GrLyaEuFPAXuh3E8yosGx6ZwiLZs/r8X5GovXIqiuQKsVXjKuCe72C+oT0d+IwXf2Qs3OMfNBVi8n8eWCerA3RIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WV9TTb6B6AurHCagsySCPCeGg94pUSyIS3zrLWXLk1I=;
 b=E0XQrHP+6uCyr4HXHi1ij7FNq1n8eR8LVPT9E+77tfL6TTAAagvjVSjkx6od+QdmzKK37UjV+1F8CjCcKN8lPj+QsBH+CbB456R5KXF3709CFoQTGbkBY1QmYxI8yTB8AEnDEHFA1u9FepYY3oUZKZvKxp8aHosQOmce9BfBQVg=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3840.eurprd04.prod.outlook.com (2603:10a6:803:22::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Mon, 19 Oct
 2020 00:21:24 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 00:21:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Topic: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Index: AQHWpM2VvXEF3YqeV0mNLAH0H5Z1UKmdQ5MAgAAD4gCAAA7GAIAACvKAgAAG6gCAAJKmAIAAA5sAgAATmYA=
Date:   Mon, 19 Oct 2020 00:21:24 +0000
Message-ID: <20201019002123.nzi2zhfak3r3lis3@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
 <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
 <20201018134843.emustnvgyby32cm4@skbuf>
 <2ae30988-5918-3d02-87f1-e65942acc543@gmail.com>
 <20201018225820.b2vhgzyzwk7vy62j@skbuf>
 <b43ad106-9459-0ce9-0999-a6e46af36782@gmail.com>
In-Reply-To: <b43ad106-9459-0ce9-0999-a6e46af36782@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 054a3f34-1953-468f-5dab-08d873c4e9b6
x-ms-traffictypediagnostic: VI1PR0402MB3840:
x-microsoft-antispam-prvs: <VI1PR0402MB3840FFC81C51C4E90B387C5BE01E0@VI1PR0402MB3840.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qlFU7uPO8n09b+0a8OOQf7n4bNZt3PoiXmNM4zBnpnwQaq8WTxlM5yAYYLYr2R/el8b2OoxEJe6K6v0c+jTRvI+fkSpdgFCLan/v9UrkPLd5rhQfWpsjQ+65W2Dg7E8dUeuTVlx87zFdQUaimGy5K8GVtjAVMeY4fRyAExuA9CdICTWzAeWAT/j7FQfv++TSmlnBz9L7OPts7kB6JLCSKP+sIqyeTGHYRBqbjiysWim1Ii5Ls5wy+0qmuXWifJjcyS7j3T8m050KufDpwzJKHG62Ojoz8hBbu6xweFCqofIE8jPvM9NWAqeSyXNMIHnCdjhFoJ6nP20SBBITHG7UyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(39860400002)(346002)(366004)(396003)(376002)(9686003)(6512007)(8936002)(2906002)(4326008)(6916009)(316002)(54906003)(6486002)(8676002)(33716001)(6506007)(186003)(478600001)(86362001)(64756008)(1076003)(66446008)(91956017)(76116006)(44832011)(66946007)(66556008)(66476007)(5660300002)(26005)(71200400001)(558084003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: evHpKYb0lAGD8GHFuNCTmK/P1iDs9DhrOv4p1oj+Wr09Anfz9lDMrgr/BGSLgAXn7djVqdVNlg7cyEkKXhk0WQMsvpZotKJ9ahjiF3ixPL8JHqSPhj2XEqY3VYGhZo1CI+AyhR5vP6LGic1vkqdRm23GXvtzNXpJDHLUXGCmyz6o1nEhY2Mcu2jHBF3JiVs3T6xOtWdGp2JaJLvx68HSvDPFfYjzmfkB4aacg/QLrr4bLQ2Ug6CsMSKOdAsnVtx1VX6irBAtPs47HjLXx6QCy5JM/Zmdgm1oJIm4Ezw2HSChBcIUClFS2mZm1I8mnypOxDXc1iwDR70Pg3a55bsiJqXVV5lbhkDnZd5tPikrktFrskqpL4QpFkpSrgNjlh7jIlMlFQ0e9rZqxXTSVr/g84352m0CSe22bM6okEvO/Gh+z1aiq6f/x+qxYeXTb8uqLtRgQyViU9uCrAr1NvCzh+FfeL98eZFswRFudlkw54d/3HaNYr/vHj5Inkyx7FoXXbu2vhvQLNZERycOf9bt5wvxcavoTHjXr8HFErLYFzeZgonhRVEW0P3LbqepMfZma7wwUmvw8q72ZPmEcYj8JkqOwANDTkOPHBQcDFT+aS4sIWvJ94R1OCQ/HHHCFWkDoC3rz3y8UDkl4ajjzSUzrA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2513ED173CBC784197CC3725EBE8B3FF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 054a3f34-1953-468f-5dab-08d873c4e9b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 00:21:24.3632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gB4OKZIg9DhGaYZhJCQ/Hhf9TKjxwpgCYiVI9e40QJkD9PhovxWA8zsMaEKUvo45zbZi1w+4vUeTrxrJU+bUjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3840
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 04:11:14PM -0700, Florian Fainelli wrote:
> How about when used as a netconsole? We do support netconsole over DSA
> interfaces.

How? Who is supposed to bring up the master interface, and when?=
