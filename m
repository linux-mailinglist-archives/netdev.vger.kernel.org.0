Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DAA3F4BF9
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhHWN5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:57:23 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:58785
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229625AbhHWN5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 09:57:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bs5zxybiHaNhpIQQLH+DS0OtXspCVwQLK8q3E/9Ku65nOpd1y+y60UPs2Vq9rn+RfmWriz9KloxejTs14BnsjcqxSIZz7klQYz2HK6JOmSA6G0+Fu0BwMtSHOmrw17Vm9yFPy8e2K5EmYxeV8S3AQc9S2i1i6dI92UZYdBmEfGtP+M9HalgUrAYVV9+jWMLdN73ldNkS7pjas2B494NXOEq4FIcZ4VMbQWbxKVis9WIJBsrx0XKCzFCVKgp/Ki4PgDrhuP3TMnVg5VgLektWNtHdCc89IxLZOWoH0ssIGf6tYgX27yjt5TjGpOuwNqYMzDnfIbjVnNwJAzCYXGhcEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOb5t4CRFW5UCTAuV7Nr2l5OJtiT6z/gGgbFEzEfEkA=;
 b=WYDi8HSTmYPLYVse6vkbYTcwEn+entZmBCvky4X/3oIicyNrKqkp/fQT79+xqxTEIIyqOTGlSd8v4JUY497qQRAPZ27japA5BC6sGg1phNrjtbHQcURS7GzeJK1/7JWLUA+tkbqDArQIQCZRuepVCav0nvu5t/poFcH0hxAe6NtShNmAd8Y2+6E6L8SC1E0Spjqp815/fwVut2v3S7t1/aTOWO7UgTYa5rzG1KYEJcCORpdLlvBAfFMWXa4pdaxZa07jMgD02lBcWmcdfjq/7eENrCD75yw2T1PfeEdgwZaQUc1qF+MJ8q76OyxnGfMZxH+EQQiPOd1PQeYU/Z5LBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOb5t4CRFW5UCTAuV7Nr2l5OJtiT6z/gGgbFEzEfEkA=;
 b=rqtXcKyrQ7Zj4wjVowXkYPTbQzgHV98KEeB+P45RWuAZ5bprMga9qX9tepbC1l81FVBjfNGWtCaM6hot8Po6BCpXFieZz958UX/amK9Pys5ZyvkrVEzRpAsK+IVxCgPr0PuInYFSj37MEChkcL4Tr9XqX4H64fd5rQV8IiBjDsM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 13:56:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 13:56:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH v2 net-next] net: dsa: properly fall back to software
 bridging
Thread-Topic: [PATCH v2 net-next] net: dsa: properly fall back to software
 bridging
Thread-Index: AQHXl8QeOm8U3eWAykGLv0EZXKt9jauBHdSA
Date:   Mon, 23 Aug 2021 13:56:34 +0000
Message-ID: <20210823135633.3h6io6ajmfh6hjzp@skbuf>
References: <20210823021050.2320679-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210823021050.2320679-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e04d81ef-042b-4908-a8c4-08d9663dd1a5
x-ms-traffictypediagnostic: VI1PR0401MB2686:
x-microsoft-antispam-prvs: <VI1PR0401MB2686FD2E41035498E6BE00F7E0C49@VI1PR0401MB2686.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WJIV2yrcW7QC+EHKAowFIstEEbE/gzTDTLIZED1VxkW7fm5QhhKPiqNb7IieNRqZfPERwfjAdJmsyz7aZSuSeujoyfdGoh7lJkX+cCtDkAhU05ks4jyDBeRhpO7GWwwmxi2TAUcEjBu3x/hb8HQtW2hvHl8VY2AdCL9JWwmzgfjKzED1wN7A2eRiy2kCgxDbxuoIbZFU2up29/vRvPXYbGMb3tgNrnS5PEN4ok4eQ2V51JmMkkqPqavr4q7989+7i2uRJE6lFUOBg4trKz/IbWuOHaicA+iYcLpClAhSKCaoaBVV9sloAeI7mJXa3+UIMMUvj77Y17Pl0kExbs29m/Gmndv1jM0vmwfLpwSftP2kdKIhjbNAFNblwDy0kFKZuFDp4LY+koVPwu7pjRZb2P0pOKlLWffGeS1XiBUOyLAigXd8pM3WaWx19jmv/mTRp2Mfg/eP5iHVaOFf0TaBrwE6YN7o52SrVjn1/DGhJEcYimIlXAx7Uv5ptH6GrIFTPqdRi5b8B35ZBJ/AJ/cY38MEstuMoNQNqhzPjuGsUmnzp6fjQzSo9H4R8MQlNw8OB3eLeN//5VRrzjzXNvwIkHtzC2RhsVNO4AcWyw9Lg1Op5vWdAz7Q6Bh33j6TZADh/lzvIqheflxBaRb05GQvGxkZ3230P3g6P5bRNHbi3eFs43dTWifcaLnTsgkw++LzSOVbL9LfslKGuirRJAB9xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(376002)(39860400002)(136003)(396003)(66446008)(66946007)(76116006)(66476007)(64756008)(91956017)(26005)(38070700005)(478600001)(1076003)(316002)(66556008)(6486002)(54906003)(186003)(86362001)(6916009)(5660300002)(8676002)(33716001)(44832011)(558084003)(4326008)(8936002)(38100700002)(71200400001)(6512007)(9686003)(2906002)(122000001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Oh+SGifVHzYu+UmDyXa5uV/MYNfsrxcyxYTo/DUIwn79GdPGezxcsuPF?=
 =?Windows-1252?Q?AXWVBriMH6luaxrUX0BTKUejjL9/xESSOvdlLjGxupmbi/mh0cMQETtt?=
 =?Windows-1252?Q?G6sq3KkL8I7kStnHPVozWG5iYOsgq2yLrpWmEaS6t+B2eDWnw5VbgBsh?=
 =?Windows-1252?Q?7TLb9LCHVQiGjWBLdz6PfsnpVK0X4zaCs0MzqKIpMVKnNxJv71swlAYR?=
 =?Windows-1252?Q?X/yldg4joBKJblvry0QqzecuiRg/T0eEawE49q+XRxlvLTMgLAzsM6zi?=
 =?Windows-1252?Q?ES5jikM9bU3qENEkN8DcXrmnqpfNP1h5792p7t5wdXsJQUxng0tmyS9U?=
 =?Windows-1252?Q?RMgKz9gu6AIipRVVZnOH1JpKjfOgEJ8pmrYeU+zBlZdPOj+2KlfeRReE?=
 =?Windows-1252?Q?by0Z9HP7PwFNi5+cCPTwzJYs+5UjMLMQ8Xx5G4RrLNhbAEtHjsnr5tN7?=
 =?Windows-1252?Q?Hcll0/RDGnmH9J0vxQQ1U9Xbm14/i+OGDEsv3ZPMqcYfKY6+s5SFqY6w?=
 =?Windows-1252?Q?z1D7iI4PYKB4s2n1CiurZmH1HqKmylrxCOgeoDONJyrT6khjt62HaFj+?=
 =?Windows-1252?Q?3kq2J1iefTUxYR6bNF9re3N4eOXMqKsPPvNLlqez/RDyeEOAEzyhbVen?=
 =?Windows-1252?Q?ujQN6mn+Ir/BBgsg0948RJUrNyK5tUq+rQYg26EuL41RlOH8kc+sA1rk?=
 =?Windows-1252?Q?SnMSBUewfFyvl89ZVMGQBBI2cpD12+/aQZqxV/uT/CbuhocGScThbXqN?=
 =?Windows-1252?Q?7ehYEcd0KJ/hEtO0sKwCRdK/1AmO1Cy57dJ/d8iBR721ypVt/+8AeXkz?=
 =?Windows-1252?Q?3fN81+vYC2WA+AMwaZBcWlEZ1A2LUjNBJE+m7ZaZo9tG6jvFrRvmhHYC?=
 =?Windows-1252?Q?ek6Hn4RFGM4Hqz46x+vgiVoms9y8+a4MXH++lR4Njh23kU7+ji00jX/D?=
 =?Windows-1252?Q?SvX0xlmuIVkr9PVlaMF58+/UYFNcM/O3tPyJt+l/J1lAwVrx0q0xmTbY?=
 =?Windows-1252?Q?2xJTBAHVDYfyWK5WIAlKRZlAyBP8LnCuOZluBtiezM+ZWdcPMATCdbgC?=
 =?Windows-1252?Q?AFrnnc4OBMp/lCZ8kYGyQCBmZ3wQPatuIOm3B1aaq7y+C54gPGRjy6CD?=
 =?Windows-1252?Q?kTwY/oOh9E7KLBewd0aiJIUOJWJAUgoUya/wkONgmZXbrAjqYpJ1vlH4?=
 =?Windows-1252?Q?GGqENmPUC1OjI+fdJxsq7vb3Z2n2OnOeL06C3V4HOioXRNUCn+H1+OwN?=
 =?Windows-1252?Q?FhW5XFUNdebZmNUAREo/UoMLh68ehIoROkdXVAp24/7fseGWQyDQUNVo?=
 =?Windows-1252?Q?3PPwfbMLK+uKsHl9Xe3eLYFXKNUkfydvUQLafxP0u5GqNotYWmCXuKmO?=
 =?Windows-1252?Q?+YKfvuziRYgak9lJTqZcoiBXBAiEm3c0H4yCcCeBaAiHNF6a4xx7NDLB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <3ED40BD7775E9C468655D89333C2D423@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04d81ef-042b-4908-a8c4-08d9663dd1a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 13:56:34.4729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJdFEXqlfcPhLitvM4IroArafyIdwiD0jm3afinRLmYp2yNLbEaRAlnhbeMFoHwvUhtReKQdUnRcF+kWpwAT+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This needs more work before it fully addresses Alvin's issue, please
drop from patchwork for now. Thanks.=
