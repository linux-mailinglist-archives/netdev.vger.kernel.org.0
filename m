Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531764ADD49
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381713AbiBHPp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381717AbiBHPpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:45:24 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140075.outbound.protection.outlook.com [40.107.14.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216B7C03FED9;
        Tue,  8 Feb 2022 07:45:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqOQxEIc/9t9xGSBSkjXfECwuAziKY9Oe/MvHy0vV8ADTGfVWq2uYWbgfBIx3fuSGeNzItPspI3VPqp3OQ2ZgyR/Ms4qlD9Swglsye4qcO3C0qT1xD6VROR2/EK1Nyp337cE8wfd0O5KqNAqgZpDe+kszz5TAvh8b2+skBhOubKCE+PncZwGnTveKQ5/Wv+Eg4nTekID2nZX2+rqLz6THvB8B4PhvBLdgEmOKleMnWA6BzP00pYo+7WdfAkjTAwql4otco42Ry6QSHNR4o/+wN1MhaynCXNGquT4zj+tmEVC7rqVR1FJ8y0jfAeTSN4wd6HFupfgRLHRfwImDKlHlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUxYheqcwJTUHir4nj02XNVT5N7PvHK6CYYisq/vGUM=;
 b=i22QbxTDQbzn9xsMjBePo7PuIDm1KWQ3aqIyX+C0DqF1yK5Nq/bKNLtOGw6ki7USd00hnaoo4u121uOS3Wjp+kXBq1X0r3CKm1hM+ilUZIf/e3KBHEb+DIZwJ/E8ducM89m6IHB4PCGb+HkjsG/gQUEkqu46u591y5hHBWdZJflyyC87sk+8GFLpxEIYbtRKV7+VS1lIsxbJzp7tMh5xJYHhp3mgpMC/jYLZjU8+30BjBG4BYDnuqrbEc962Tc00+50ztTJIIO7BXxQL6c8LLIWc8UNwigHFmZz+WfffQ5nLMU0svyBfhDXIvdFgdGSLdKs0y3mQch2Ax/sNh6VfiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUxYheqcwJTUHir4nj02XNVT5N7PvHK6CYYisq/vGUM=;
 b=RofB2wcEWC07oVhrSf/JpNTXBFGLu3/Yo0b9dUX3eyzMtKdDqwG02TyuJF/LUcoTmCbdOiVoaBshEmkIXiB2eILhG9IYhbL5JTlCOsjVQ1GIyYLwAyCkv+xdupSxsR4d3wkgxJ4epF+B8z1+rj8aU9qNXmnFBWI3sN4fGvJkZ+I=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR04MB3180.eurprd04.prod.outlook.com (2603:10a6:7:22::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 15:45:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 15:45:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYHKbq8GXukjoutEaxquFuvaFzqayJwKKAgAAK3QCAAADugA==
Date:   Tue, 8 Feb 2022 15:45:15 +0000
Message-ID: <20220208154515.poeg7uartqkae26r@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-4-colin.foster@in-advantage.com>
 <20220208150303.afoabx742j4ijry7@skbuf> <20220208153913.GA4785@euler>
In-Reply-To: <20220208153913.GA4785@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f10980e-d24d-428f-1de4-08d9eb1a005a
x-ms-traffictypediagnostic: HE1PR04MB3180:EE_
x-microsoft-antispam-prvs: <HE1PR04MB31803C48CF212B8E01E7357EE02D9@HE1PR04MB3180.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ROtcp7LuIlmgceQmTp+eQkchbyjEFJxseTDdk00JN/7+acDiwuRC3d08PFtPQuJHOCXl9vQpO2MhUJg7CIB0RAcfHgv1A5FeoK9/ItNqbcbjyazUHRCrq/oSgUalP8LSztPIEPgUbD2srjGz1fLszLzoygYY8cjekzjEr+pvjnoY+oXgInH4PC7jEclcxJRJ3UdqW8hCawATn7aFA598ONg/b1gHZXo54kTMFRvXPJKWKnBPqYHkz2ACeOxrV5ug6EHqrgqzcGPFEkx4UAiFCljrgaW5Mrmr2G+vs0BvGwQXKRlI7P4nT8oT2Y238gsra8pOPbg8hOnH0m4ghwd1acuf+9QOe5I4LYmwRDU+K6QlNbGuEp221ht6n3FpX5KHdUTDf8fpDDrpkGkpbY2D9ZA09394ZWRI4DBXU3qUJQqOWAMYpb+W5IUbQgM6i5irCey0UyEgCTae4B6Pioi5jOe3x4FMaVBNRemjdaeTtBxvJC9HOsD1fmWjVoq3R4oRJrsIBYs9w2jniQ4T5ttYWP5oupbNvQVEx+eEc+uqeQpGm+YiiMyEM3vp91FpVqbzgr1+f1hzHylyAMrAW4HEZrNb/1JekDXaEqiZps/exQ8fF/AM2cPEASUMkyHXUAb+JZvarMhguRj2mQoUA9gwJmzd2bxN1Q1eypBYfOPipPAsVvrY5++O5KEM49fBjP9AxNpmCEueZXve1580MNDZPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(4744005)(4326008)(38100700002)(5660300002)(6506007)(44832011)(9686003)(6512007)(76116006)(66446008)(64756008)(66946007)(66556008)(8936002)(54906003)(2906002)(8676002)(26005)(186003)(6486002)(71200400001)(1076003)(508600001)(38070700005)(6916009)(122000001)(66476007)(316002)(86362001)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oIPks6dKi5SvfmiRSSEcv5Fg4b481/ektWbFoFhphC6ywoT/7js4iaNoFtS9?=
 =?us-ascii?Q?elmxuzx2eDzb3U2frl/dU8eFgkEG7ndJHa9QvcBCHB9oMgeucSE0XaDMmrva?=
 =?us-ascii?Q?yIIbyug1JXHOctx/sK38gnQyQG/l2nKbUtE8zDtyBfS/dw+Mf+QwmNnCcNQp?=
 =?us-ascii?Q?tO08zQJ6h+xH3NhucMSw8JOcbtwMuGl1wjoOf4wHykUZ88+svgTClMcw0UYn?=
 =?us-ascii?Q?N1SHl7Osip7oX6xPafCvPlhIDArVAzv5X9n3J76um1oDVEiG528FRiLHcOwy?=
 =?us-ascii?Q?hoDAZnlLB3mjeXcB5aURKAT/NCGjs+BFZbNB4c91ubX4gfTp9CcbQvKCVBde?=
 =?us-ascii?Q?WQEwlz7X7nZeuz69qaEi9PweY6OIEyPchXIpt9MRr4NYU/AVDNbK7iKFsNk3?=
 =?us-ascii?Q?HmOCJ/67wTm61ZSpIfv5/CdOdjZKXa2BiI4DefTIyW+MulVCSkh5xsCFhn6l?=
 =?us-ascii?Q?8KgfeXsMgMXI9OucupFUJy9kDot3o3Dgq6ldFmuciO6OpmPxjiY4iskpLt1g?=
 =?us-ascii?Q?YCVmu4rhJebwDti6eWmn0U434lffHcQUp2nvy6A7w+8CzJLHAIhq8ACQfC3P?=
 =?us-ascii?Q?By+GiJtg4T4OliiiL8yuGYl9JLJO9c+Jp17VPFO22WMt7bWK9n0CwIPBI/d1?=
 =?us-ascii?Q?yycQsXfimzq7mr0dbv0zJb+sUswNIXchf5VejEdzIyu6eyvnHhk5oAbV5hhq?=
 =?us-ascii?Q?sKvp+bLHnesZhMDvJfKVXDEwTYl0ggunb6orX4KR4yFRwi3C022p3/S64Zqs?=
 =?us-ascii?Q?j46m4J3RK6RSCK2rCkwlVXePt/NRH0/3i8PCf4M4hfduID+mxjQEF+4OCvDY?=
 =?us-ascii?Q?osA1vrOBTBrV/9/9yn7WOlh+IHrexQnCliclDoM4RLozcuWySwsrLXAlb864?=
 =?us-ascii?Q?jsMGQ4abDJkiuJ6QaD9i51F7LMDSrokTMX7+BXrLi+g/7lngabl3kfYOhnML?=
 =?us-ascii?Q?4ITa0NWT4szpH7Zi4hb7FavkHc2M9CCdquFAlJ31VFXKAAu8MFVDhn/Fc5as?=
 =?us-ascii?Q?UG20p/D9bn2YoogE5Zak2a5k/Nxiovq/yDDaEC4KnuMsobm0F2OLs7S2ibyH?=
 =?us-ascii?Q?yfaZtct3Vub+72KcmQy3XSxr3nobAa7yuZgI5UM8+K5nlfsI4dQR/z1xXkpE?=
 =?us-ascii?Q?ygetSGY9rAcFGcF3k0sIck+qvuErXtKLISdPlnN6IHW10a2wnzKjgroLcpiq?=
 =?us-ascii?Q?kQ2ZYz2QWlMqpsnvVftI3/AeV8j4iWKbf4KcPt0gxWNC7U6L6LfWJAAPVFqs?=
 =?us-ascii?Q?CKuXdOKOoAXec5JWXwv2s6ObUJO1nMQs1r0k/lXwhPSShQtCCpx+H76WnJqb?=
 =?us-ascii?Q?nPK/M7gQI+hyAADRE3SamhcSAZcHHZBO5EPo17ZLXa8r6kiExqD5VIpjIf12?=
 =?us-ascii?Q?cRhh4yvyIGr3WFWJ8+B0TchyCvGDumcKD5UsnW/+TpFsd+3prd9ZZeCnA56m?=
 =?us-ascii?Q?js0dml4CUGyGXVoxV+UhHT845OzAwoF33IxHz8TQLpItPYeR2P6LsziLE1xV?=
 =?us-ascii?Q?qmJUoyyg3McuCFP4euHHnYjB+6mZjtQObCgZT12Pkmah6cwDP1/NTmY5aTBP?=
 =?us-ascii?Q?5fVhmk5voq1wdJhsJeXon2sk/23uJ/frZFTGWIz+pYYChLzIAbSs0pn5JA5e?=
 =?us-ascii?Q?NF6dtEu+Nw3Zn1tn+io4MlaJq3tHPLi4qGl7Lr3qu82/?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <869712DA8CE1F247A49672AF7F1A13A3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f10980e-d24d-428f-1de4-08d9eb1a005a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 15:45:15.6125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dC1O+vsOqrYKxSzimJsvdWypEhkcDCMnDZUpZqbZDLgG+jAp0q4rr1il5/FDFdkmF8XETsSborPsh6jekD7qfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3180
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 07:41:56AM -0800, Colin Foster wrote:
> I see that now. It is confusing and I'll clear it up. I never caught
> this because I'm testing in a setup where port 0 is the CPU port, so I
> can't get ethtool stats. Thanks!

You can retrieve the stats on the CPU port, as they are appended to the
ethtool stats of the DSA master, prefixed with "p%02d_", cpu_dp->index.

ethtool -S eth0 | grep -v ': 0' # where eth0 is the DSA master=
