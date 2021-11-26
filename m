Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EBB45F2B8
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbhKZRQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:16:52 -0500
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:23029
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346925AbhKZROw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:14:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f51kzv02tbOKc7LH0HzMMemlRTR20TYgL8u4H2+zJ2+QrcLnW2MX8SmNxJYbgCPdfOd9AO/olcuVFpKnuKR2BSM5KmPJ9+Z4CUelkG8rkhX3yGGRz2KMgC8aPm+YKmlVog3Nh3M29ALFSgfKzvMOzBAykwg2xT0HaLxZLUzVUqbwLqVWoBz89kY7yrGDJub13AS4A0Zq28Er2hmuiTevFLk67SQVImZIXqjdAkM83WDvQYPfXEHsKw6CO+kixyMufDGibSQY1qcWVVzrOJ5fRRss8Wh7kOWBpbr1ogJyQJB5J+N6AyJxAMuuTXiirhCHlKnghqeg8SGu3NFrtqqebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=othBfyNAjxKXkxeaZsEM4bJx54Fs9bFcf2z0iKw21RQ=;
 b=LOX6bjU2WKM86wP6HN4AiS9u1NFqkuLMIL/7dFUNkvrD+p3FMK1p0CPaPSCecDo+yNiuatKC6Q+cuPta90gvxeM0XV8j6/uhVG2zegHYSuXU/aF4lnppzBtUaJyIiGdjwBOYnAbizi8azXW08lKEPZG7fQuBQuDXjQ+HedCXIIEErWSpD6Vj5AcaEDkG3THaGANu0nqxJjyubMqoDbezxrAuVH2I34Z3eBEmFkfv4c1o9JHYPn1PWX0BJICrsbj7kxHctxPKCaJ2w0vmokKaEZaaKrawQCvrGwd3+TOfZ1Q+Lq4pXufsHIFvWnrq3605i5rdABziRpR+04NxETOYTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=othBfyNAjxKXkxeaZsEM4bJx54Fs9bFcf2z0iKw21RQ=;
 b=qr90Jh8StJ6c5v+vRI0e/3kBfxE27vNKvdRu6mxuRQplE3m16juKrk3oVVFpGvsEedBMx1iLZn0Jq78gvDZIb2qMprpqJ7oZKYhqA4hFhkQyBlOp+I/1XipgHzk0ZPDxhH99pcYAbY1sD6ca9gFQpZeyfTCC+LOeFZsD69Vku00=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Fri, 26 Nov
 2021 17:11:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:11:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 4/4] net: mscc: ocelot: set up traps for PTP
 packets
Thread-Topic: [PATCH net-next 4/4] net: mscc: ocelot: set up traps for PTP
 packets
Thread-Index: AQHX4lM42QuMRV/jlUGB3MXS4i2cH6wWCRqAgAAArQCAAAHogIAAAP+A
Date:   Fri, 26 Nov 2021 17:11:36 +0000
Message-ID: <20211126171135.uvmlfmtf73zncpap@skbuf>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
 <20211125232118.2644060-5-vladimir.oltean@nxp.com>
 <20211126165847.GD27081@hoboy.vegasvil.org>
 <20211126170112.cw53nmeb6usv63bl@skbuf>
 <20211126170801.GF27081@hoboy.vegasvil.org>
In-Reply-To: <20211126170801.GF27081@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5c334f6-fa40-42c4-1328-08d9b0ffcdce
x-ms-traffictypediagnostic: VI1PR04MB4813:
x-microsoft-antispam-prvs: <VI1PR04MB481352829CE7249D02235637E0639@VI1PR04MB4813.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Owm1bjycPgZ0nEA5jG2MmpChDDaInHZ4dTEgu6C2McA/eNyu31fuaxHSrHPr9VYAz/0uSJ0wg0/HZ7oBLXpS1TNdM0PvKBSVPui5txnP+3K6NrroccO3we/qDnSiOvlfniSj5Gvabe3lbNeIWlz76tANDab8dgBxLpTNO8wkQUP6ivItGDKO33VrFhqABHXbCZgbW/fnherV+NslZhg1/V0MxmDUs+Yq0ctlGdcXj2XgIsp9Gd99W0iPjfQFPtLQ+2GBbSBQLdgs2Azpb89Ex8zWUl+SfEhIwXixJ3qPw3CYJBGFakEEwmA0wH8ITt3upEMTLyuXoSHPAz4u7c8q8oBHMebF3vQgBNQtceawdBQjDNLbgQG8eCazxckd8izT3PGz/xfDvg1QuqmCfYNPOS2yjhWHFzEMGSKZvuXmYp/CWE5xei9OhnhlaKYZEHswib4pBb9FoodeD1eEauI7/tbCingZgxWAKdywjY0hWxuU93o1/s/TEY/GgioiKJrI2C9DvL4a1HVcwrEYZSWaXOuhlj5CrxvjxyxQVL6IYWXXozH0MfnAkP2/YoiHWZBTuIsb+3b9pzVf9XchCQPZszg8ZfMcxffObCXSxRMdz27wKIkBGvp9lRikhULTaNIXQqu+ttjhIdp8Gwyc8RWwdXPMl8DEGm6AU6qvvPH03ORcRI3CpRLRJIzMwtNXzLoGCxW7J29FYFdlB5hnzSyRHGlo6Ax1fSyX/hxoeL75o0W2L3bbuB3Xonx+gysqXcPaSblOp1Mgrhl7xxxTovhm4VK4QUSymb3zAsjFixkUrDw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66946007)(66476007)(508600001)(54906003)(76116006)(122000001)(66556008)(6512007)(66446008)(91956017)(64756008)(9686003)(7416002)(2906002)(44832011)(38100700002)(8676002)(966005)(6486002)(1076003)(8936002)(71200400001)(26005)(4744005)(33716001)(6916009)(5660300002)(86362001)(4326008)(316002)(38070700005)(6506007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?30GYb++DNAZ4LYxF120RHxLxtE4ZkHXNeHUPtYcOLdZeIaTyOmZvaEi4h9g9?=
 =?us-ascii?Q?/6Eh4OqzJrS3dFQ9tpPuMFDVgg+iD/3rX+j/Ybjm6hocrbm4vrzy1qtTc9Uh?=
 =?us-ascii?Q?bAxGgjbrFRN08uk+KbxvCWjHiZUty9uEzpyFNO9LLZG9lUO1BFwVLhES4NA+?=
 =?us-ascii?Q?13Yew3Z5yHw9/vcskHkZHX+qX62+8LXrDTjS2sxKHhQn8aAUcS7GHo29bn2O?=
 =?us-ascii?Q?V/4NAlRRcp4nOP+cnfpw5CuqUOdjwN4romFvurESyHsm+O6gmZ66kegwB9qZ?=
 =?us-ascii?Q?zPt6FjyfCYeT+og1cBrCssxvUp1LkWCbbSEtqYNc0I+7znVfB6eS7d6ewYjP?=
 =?us-ascii?Q?iKic6bxI9Um0TlE/a/vcpRYN+6hFLABmXCZfuvVsO+SF0qzYiYuzKA+ztZkw?=
 =?us-ascii?Q?5Ky35hu7/H6C5/ODiv+/eAgkJcGLX8f5ZAYuaDEFTmuItRruRtJl4jgQoO0D?=
 =?us-ascii?Q?NuQyINgCJv9dFmaqLy8BYiG3YQHxJIfWS1s4zT81KJCQ1rzbDPFTWMLte6sj?=
 =?us-ascii?Q?SG6UxBAs1slpNUzIVrF/98scvvk8/5iaUIXLaPlptu42VJ+rwiUx75VkgXfE?=
 =?us-ascii?Q?pY/saedRKtsDZUOZUI3b40NjmOem14+e5bLeKjRTOeH+9cHewURpaLjLKfWs?=
 =?us-ascii?Q?mQH7YJLhl6Vx/iDrQ2bNaDhsIz1lVihrfHeSG6Vb8n25x/u4449Qptne1x7x?=
 =?us-ascii?Q?ZKuLjhHNvzSwHFC0B20PMEGvK9WEk/FVkVMhPcqj7V5G1CA6NKbq8JwOSpJ/?=
 =?us-ascii?Q?Qn//qCqJU4UqL4EFYkQ59QEupsZW/+TrDD814TIilI11GbZamQJJ+fFtDI++?=
 =?us-ascii?Q?mv0SkXunkw3csywmyZ3SXhUTKGXdn9BqigQU/7/m6nVDZubG7tSbhFxrGAS6?=
 =?us-ascii?Q?TQkfMPr9OCjRBfsiVL54Tex8ULwvNMjX2wXgWR76kuZ2Dxtdc98kxT5lSyBy?=
 =?us-ascii?Q?7ctgBNW2d2vvVfxQh7Oc9Wy0aRqtoFx5LlZiBc6duth2n+tswTavBHffO8Mb?=
 =?us-ascii?Q?xy/QMi/U2yyI2BEmLjxJdZtU4r0pGq3OXPYRg7K4r17HPni+Y4eHEdbmaZ39?=
 =?us-ascii?Q?WKp9Nl8PFYT7uoydXtUEUE6y6YTp9WxrmUf1yE9hO7txCbHb30khVfRljkPv?=
 =?us-ascii?Q?X2ozNeD7nxdaDD9VuL/8W3TM+9PfEzSliLeRC9ecBzpy2imEpOzSwT/qyc6w?=
 =?us-ascii?Q?g+bHYG9TkuJfK68foXNEszAMnijbSWT+vujk7RsEe0liuzBuHuSw5m1nUCq7?=
 =?us-ascii?Q?MCZKdg983h3GXxEhhRgllspYoQ3c7eJPG+yzHW4MrioMIiYaWvYHG28cliNG?=
 =?us-ascii?Q?Avq/SL602XzjpUWUOygOFifuNuUscmKpwIMEzq4gfhziw+zsqPU6biiwyCv2?=
 =?us-ascii?Q?cDpeVMcSpFVksgds1t3OXbfC35Q6pvqNH/n15cA+MnoMi0QqOe5CdOjUS7Wg?=
 =?us-ascii?Q?7/7TWn8vFpDexEoI6pIaFZRxp0GodN94Ny/DNXRmMbFahkgx2bzIQZbUInRr?=
 =?us-ascii?Q?dsZXhJA4FzzpDCDwhEJSP/8b9LjGwga+QWKp/Cz+6490CBLcO+cbHu/4JvjS?=
 =?us-ascii?Q?e11nZCn6zggIHb6w2SFKtmb/yMkupKWVAijkNkFQFWKWg3EPYj6HiRsNGuZI?=
 =?us-ascii?Q?F/AgQSnElTglsJDQtGasgL0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4F13E7C90D63D4F97986E450C1C442A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c334f6-fa40-42c4-1328-08d9b0ffcdce
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 17:11:36.3900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r567I6QgvVQ+4iPT5JY7Ob6Ys/QtKA3N192rJzI20zZkW36rgzMJg6ypcCI0HBorjN+NjM9OFqIlKjNpoHfE7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 09:08:01AM -0800, Richard Cochran wrote:
> On Fri, Nov 26, 2021 at 05:01:13PM +0000, Vladimir Oltean wrote:
>=20
> > This, to me, sounds more like the bridge trapping the packets on br0
> > instead of letting them flow on the port netdevices, which is solved by
> > some netfilter rules? Or is it really a driver/hardware issue?
> >=20
> > https://lore.kernel.org/netdev/20211116102138.26vkpeh23el6akya@skbuf/
>=20
> Yeah, thanks for the link.  I had seen it, but alas it came too late
> for me to try on actual working HW.  Maybe it fixes the issue.
>=20
> If someone out there has a Marvell switch, please try it and let us
> know...

On the NXP LS1028A, PTP over IP, under a bridge, works with netfilter rules=
.
I have a Marvell 6390 switch which supposedly supports timestamping, but
I never got that to work, not even L2, and never had the time to sit
down with it and figure out what's wrong. I think I saw a discussion
initiated by George McCollister saying the same thing.=
