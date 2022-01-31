Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778EB4A4CBE
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380714AbiAaRHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:07:54 -0500
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:43744
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1380717AbiAaRHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 12:07:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMTVTYErgNL9FssyyX6VmLnOi7785fqpI/QVApQSqE0MJqRT8ZgrQrv+bgSPqUuICfSWVPTgfCdPuwnK7FY+c+k+o3RqOV5ic1WSoAO/lcPqlPxSp2CkVQjsonV8Zs0n45zUVM4PI1KJcD52YO2+Y1QD7FPFq/jcGo1QYZU3WuR2KNVlfRQZosCe54Vvc+VT0bL4Ph5vyTZaHIBFe3mcBrpiMB0uFauItybgnFgl467DfCLhO7SFb9/O1quQB/oCrqXDk8nnwG9GswQNeU19sk4EgYV/4GKcnHCIWvPwkZBxOQ4NlsudHjTfbaGn1loRd5rQvicXcLQoa8jEbgPH4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/pBfhZiYvrpaI0x4KmA8dhcAGOB46eA5HOxTVlrUDw=;
 b=oJZ0uhJRn5REl75yK7EusX6wFAvXi5I32tHMVNHayupprCJFftArZKTA6NSF1JHBgPZxFWgCUT5eRkzOZMjhzRF4NjIlKNZ/Sx+zhB8aHKBe8J7HwJqm1Nruq5bGeLSUEGditdlAUPsCJDTH27Dr0i7veCCUbsiz3DTVCfJO3ukN7hHk01UktyTiEpyBNSo13pYDwz03smFSTm9mVSwRQSOy9V0GTfCb+l/XNMiAVGyZqp7PSA0JcVlN+PmZsUGSVUznhWOCMhxBx5q41GdoHXTMobAF7yeM95/3XFO6mYjVob1BxiZtHlMt1vbMGC293I4MlWTQ5YbXQPjM42qpBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/pBfhZiYvrpaI0x4KmA8dhcAGOB46eA5HOxTVlrUDw=;
 b=SUGlt4ODR1Xsxme73cUqnYa6AegmrxdiDQrilsp0PmWaeur4E3gUgwfG3/BFYUzP8twBV3e8ULS11fMeWz3hHoCZqhQehPwTHiTnhAcaDnJpux9HEqPWcQJvA5CGe0cDbQVmdtdSTpQN3XrHgmUMhweVd06Yo9pZ9/PqhcJqkxg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3941.eurprd04.prod.outlook.com (2603:10a6:209:23::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Mon, 31 Jan
 2022 17:07:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 17:07:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v6 net-next 3/9] net: mdio: mscc-miim: add local dev
 variable to cleanup probe function
Thread-Topic: [RFC v6 net-next 3/9] net: mdio: mscc-miim: add local dev
 variable to cleanup probe function
Thread-Index: AQHYFVv0sXEJGX07hkuoOxykEY1ac6x9X2uA
Date:   Mon, 31 Jan 2022 17:07:48 +0000
Message-ID: <20220131170747.kv6cudnahld3ssvq@skbuf>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-4-colin.foster@in-advantage.com>
In-Reply-To: <20220129220221.2823127-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b444578-a06e-4930-5e13-08d9e4dc351d
x-ms-traffictypediagnostic: AM6PR0402MB3941:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB3941EF4DFD7DB3ABD5C1A46FE0259@AM6PR0402MB3941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zgfbeDopT4E8m6Hz5iJVu7L7RAYbaWlX/bE4TaDWsWirjdIWHjHttrP2iElOZVAgmj2J7ZaYviMpNWVHpbn2UnOULjFsS8GBQX42pd4fVwHwcsdRPDnfd1lz3tntGGILX7iQoXIe7+hT7PQTRtIxIjLn20Jp6VjKDonsygYsu1wT9KOWzrcJ9mTvF3zSccWnWZxoJGB0AFb/qk8iwMERMshI5Ekh5auQOGg7IKPHOwYrEOi7s/fmf0oaS+ohDvmH1wRrgCH1THvtnmXVQxN35YoWBwJ9oO5lLJck7ccGXViXutlByrXgi7PeRxN05J032FJn9fdSUvLqXgMnwlO7QGB5orHq2CsH8Xoh6CaouB3YEMDFFwGgPmhnwDttKayaXL0jF0tv5YjkoNru/DA2spg0+c7vMhmjcp4hRdFp3/Rb2KWmXOR7ZR1TqbqBLAtFFtGmajoEOpvzz3peiii/mkNGq9201DQxnEwjCACHl0jeFWT8dWhLbZtVnjoaqdKYazK7nYv6EvvY9ManGiajdfrhidpqetvTqMw/6SudhlEbcTzNSRRhNrqm2JctWVZHKj6igh/llti+OCTDwPqp79118pX4gykMnLdaTZFrPXpLA8On3tRU1xeueIL7yeraiHk7Gp73U58JEbD0+bOmwMOo7OFmKDudu68QXHl7jIbwcbPIaL5vEDiXN24SJbW9BFTr306TudtPPcJ2oefUbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(1076003)(186003)(86362001)(66556008)(71200400001)(83380400001)(26005)(7416002)(5660300002)(44832011)(76116006)(66946007)(33716001)(66476007)(66446008)(64756008)(4326008)(38070700005)(122000001)(508600001)(2906002)(8676002)(8936002)(6916009)(6486002)(6506007)(6512007)(38100700002)(9686003)(558084003)(54906003)(316002)(91956017)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zyS/rYZK6SrvBZpwoJM+txBgjjau3Ykg7eTNUqufNd6O2xjXihJUM2Ax29KX?=
 =?us-ascii?Q?8sSDEIyUECj6haOwfz4KKAMrHFqVOGkYiI97nwCx/O1wUqLj0nsuliNqhVhW?=
 =?us-ascii?Q?j2Q+WEIMOQYP1jbr+0vqRfXWxp7KKI8Ch7rnmaFyaZvBQYdss8nI4oUNqz13?=
 =?us-ascii?Q?Q4So2rBVaiFEp9CZHsgwIQoyKjPipwY/YUqUHR6+nbtxuAioQgGENw2tKOeC?=
 =?us-ascii?Q?nIJ8WHfebGqlH13jyJJ5Vh8edWw7HAZSINHgDQsVAFnej4pQu+jpi7VkFfAN?=
 =?us-ascii?Q?8ug1oV14rhcwd4s5Xex4k+4kQ0wlcL5BdRV+A3yQxQHhFaCEP3ooP0o80Evt?=
 =?us-ascii?Q?tcaxYgY+xqSiMEGYais7uaEuXR/ud2NCloXCAdj95UsbVeGncHUjtmanslw7?=
 =?us-ascii?Q?ug5+2ZnSaQnIQKB8ej+fYiLA3FF/UYkjPWZpyxJSIxfKqdqvlZruS/3ChjCI?=
 =?us-ascii?Q?hVZx4mbI3K06wTIFFOHjA0bGX4TABWyBbRKKvqFLPV41zcMlijrftCILKTrV?=
 =?us-ascii?Q?e0E2mqEoP4dpN61TW4AohCOObSEgX0H84ae4OFDOj6+u9xImk+b5NTUPlSYw?=
 =?us-ascii?Q?jcGOp5t9aamqY13zJIwsWaxi70hmYsSHdKhu2kYrPcLq6J8um/ghI54+ARSl?=
 =?us-ascii?Q?Oog/dDRD5o/GslHg6Pr/T1ofg4YyZCPonEfHxBaBd+RJUsWWqGAj36JSSu9r?=
 =?us-ascii?Q?K99p+4KQD3HuD5Gu8bNvqiokv1/Co2FjiSzIjtLkB4g6K1sDNm0ougytGRBV?=
 =?us-ascii?Q?CEphyESu3eBlX2KhubcbSZyAs+I/P0THtFT+TsvQMWPB0dyvq443cy9sAjNF?=
 =?us-ascii?Q?H3bIeMwET1hDjrZ1wWm15F+0EpPHOUtToOR5cDSeG5IkHj/4/gxTshMpWGV1?=
 =?us-ascii?Q?DspB1l2mtyBOhUotUFZSgGDvqMRzgSra9r3RpXBHi/rA44KzflMysDvCSkkH?=
 =?us-ascii?Q?8XUQ1O7Q/l8a8o7BmFwRaZPH+2dZIsrv/JRNDi5KJQS2RfncUS2TbGzfHtZt?=
 =?us-ascii?Q?USXbxZQJHoCe6vGSjzmMdtp5lJu2dF8tARzymtO1BctYmQgTPtow4YuWSagw?=
 =?us-ascii?Q?fOw3yWE38bwKaCdddTYth+J6dTptNj5MsqyKkcF5oP6WqvWKc9SwnG7gEEGr?=
 =?us-ascii?Q?vd8e+9BSeZG5yQUr45dFf85iM3tpJAyqcZVQHcGqknF8Ay2cAE/gMVdjW09/?=
 =?us-ascii?Q?i9YjtywnzZPBBRSAaRLHIM0BqvkZel6UyfjhYxjZPiLBQbh2aT5JRiis/S/2?=
 =?us-ascii?Q?pXJgxf9QRSY8lakOoa6Cxd2REHrPPtM3TKt5bO+rlOZcJl6TzaZJS2q18Qaa?=
 =?us-ascii?Q?D4dqy7FrzX1qC4PGpxVCeBPROFdatEwwaWTRJ1XVO9AAMVPk/wfOmruC4uaN?=
 =?us-ascii?Q?4kw4SB+pdYzy4xhvgpaciFULIrlpUBEwXM5z7AM8RFq4zUl2IPF1QBB/YeSF?=
 =?us-ascii?Q?xyvNHcIsZmbvn05iILL83vCRhGt5isKA192gkYJQ02NTCM6+205QVPXLBUaN?=
 =?us-ascii?Q?LGhb9Zmcr/tbRtm95SLbnPgv+xWnSWo2JZU2lhRbEdcKkMQfkiiDHx0gMLmf?=
 =?us-ascii?Q?mVDSsIhK44H/lu7NPlEWNqe2jNKVvh83I3KEQkATNkzO2N6sUjiJlMiATEkI?=
 =?us-ascii?Q?ADCz2+szw3NNJAs+9SUBh9E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB70584662C622438793E0C307BA6C8D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b444578-a06e-4930-5e13-08d9e4dc351d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 17:07:48.3441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rvwbz/XSvmWw2XvDBFXYNYmYWZnq815sK5jMHhjGJRCcrt0GsCiw2HQkCzDmK26SgExUE8W1+AS0CPBypdFfvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 02:02:15PM -0800, Colin Foster wrote:
> Create a local device *dev in order to not dereference the platform_devic=
e
> several times throughout the probe function.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
