Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACAE52040C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbiEISCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239971AbiEISCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:02:12 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150057.outbound.protection.outlook.com [40.107.15.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8D220791C;
        Mon,  9 May 2022 10:58:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7S5JFQhFlS2eZTQGnF0NmaRx3OQvZcTRh7RK5bWLHZaIU6yxRmuHbjWJldA/CDq0iEnLINOMy87lbgOLHK33O7u/f1CGPX+YTGr0k2ma/efCmwQ8TqPI0LYjUiVW2VaGDnctV/1FyDpJ7gwIvmSxr9WdWXzEeQlJBZZg+ctsrhgunrU88Cj2yhc2wS8y4NyRoa/JJV9fNaIgZo1lcVjIoqWfxYNLx9V+qlEKpUeXSwZxj0krWwvtckc3vsKTlAOZ/I0HXNSgcOkQbbg9q2/Rlv5xZgrWoNbfr6ea3ERi0tNCbKj8sV9Fg8pCZFLRx5wzHtdQmdaPKHIfjpm3kz8kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaEFp+yrAVaoEBiiwOPVgyIa9O9dQ/eJ2RwdwCaugPM=;
 b=Q0YCJdD6QmqplDwHLEsFz8dY4sgdM0fJ8RiAjv6F1Hu2Lko1P1EdXiybOWEtCWRGCY0Uyz5o5/YjysFzB80B58xI9cMhEbQiTeNptp0e2O6S4MvJqP2Aazb/zMyNwVpIoTcw6rm4JpLPE2ff36QvNoKdx4b3ZEpmdkLzTUBMxXMqgbXiCgXLQSZNsVGGxFyHAxI7+3KkBjfQlezE3L8MCcVNHtH9Y4EaGiCMZxsBD8ibXvf5obvFrSfNBURQxa9GOTJrLLWGaU+ORpZBvjZrVw1HhaqKXfHEEAgNMkRZqjdmzSQtN9B03j/GlCgg3MqmJGuhR5c8aPvnVWeuCl74mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaEFp+yrAVaoEBiiwOPVgyIa9O9dQ/eJ2RwdwCaugPM=;
 b=rutXl+thx/Gj7vs66xih4XOHm6iQSVd4NL1+bn32Dv9ec29KJJ12hrgloq7WLpJUQkY471i4kcLO5v+YBmtexm8PnR889Lm7yrD5WXoXqTEVFZbBdorZHNTE5njz2HYwhEtYhT3FCXScbeNGt3K3db/bZTsSTZNwMKY5jqSIWSE=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4595.eurprd04.prod.outlook.com (2603:10a6:208:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 17:58:07 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 17:58:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Thread-Topic: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Thread-Index: AQHYYwz+Nv3GsOP+t02gQrIoyWAlJK0WWrEAgADnkAD//4yZgIAAfF6A//+LWQA=
Date:   Mon, 9 May 2022 17:58:07 +0000
Message-ID: <20220509175806.osytlqnrri6t3g6r@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
 <20220509103444.bg6g6wt6mxohi2vm@skbuf>
 <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
 <20220509173029.xkwajrngvejkyjzs@skbuf>
 <20220510005537.GH895@COLIN-DESKTOP1.localdomain>
In-Reply-To: <20220510005537.GH895@COLIN-DESKTOP1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c21b2d9-4913-4931-7636-08da31e5792a
x-ms-traffictypediagnostic: AM0PR04MB4595:EE_
x-microsoft-antispam-prvs: <AM0PR04MB4595AF75BCBE8D52F961CD61E0C69@AM0PR04MB4595.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NtKeLHigHJPPKmCEb+yMjcn5cBo0rjffcGAq0+upLjWED2m+CQHfqfVe1+2G9qMpaWfNxxxehqaAZ5ppM0LWS+HT2RgY0/KKFBa96vdGzuTE89jax/+z85KUFHBA5S/CgFhfsbVdkc4u0QgPpe0H8AhGWRGgWZBFSG7bQ2fLCdj8Hl4B3aYqIlNgjO4JYu75c5R/lYfPr/XM58mCBXEY9lC5wcrif2spfKklu37cCufKo62l6YWq5LNjfkjAS5+Xs/UziVPuGNRc2CoiD7xEPeq9fbUp9koXecmQmLSrK++AF1RyTRdVThC6s93gaw0xh7TPz/hSISKNxdX/JwMAYpcuXGf4tUlI/5K68dJFwTTEu+ddfkkdMqC99BMooim7ffIuZH57l/YBLOaf/MqZd8XpN1TIhNiMB3pPWsUoBKAv9PH9YhO4PW/866FxM9ccGbN6/tdJIb/D1N0OGv4Pgu0mbFEQo8o+BAelB+5NKY5SjQ16FiORAsR52XXlRpwOZkVS98SgfQ515545w7GUNsmTMrlKtBx4naaV/Gl6AUDBy1H40hR23qkAlRPPqfKlmqsYukxVrfwBFOeFsLbuEvhWs6beFDaLLlP274+FIY8MFYhxnccgEj3MGjoiNRFdEvS/i9Pc3OWUsOzuOlFhlj59wr+Wykary11OFPxYEf9JI1VB9iJKwWylcT7ZlfjkyqQGjV8nw5m9LeOKOMmtZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8676002)(54906003)(76116006)(66946007)(66556008)(64756008)(4326008)(2906002)(6916009)(66446008)(6486002)(508600001)(86362001)(38100700002)(316002)(122000001)(38070700005)(71200400001)(83380400001)(8936002)(6512007)(33716001)(7416002)(1076003)(5660300002)(44832011)(4744005)(9686003)(26005)(186003)(6506007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0Bq9ba0GmfqimE7IatOf1LPDxDeRcl8SbnNOBJEuCT6Belg/TWuIQYkkM+8W?=
 =?us-ascii?Q?vHDByFrd8t65knZDZkwtaQkyUQIKox5COvvE4o8xS+/2o2qnfs3im9YzGYdW?=
 =?us-ascii?Q?2yruEYOjO4jfVZZ8dQD2BlH/YaG91CrjF94DXhs9zPfUvwiP2k1XHSSp3EA5?=
 =?us-ascii?Q?9kZqrFF3TOCMPA3xN5v+INZi3z/XAlx+GOJ8JgvXS1byqecopXXJl01oERB1?=
 =?us-ascii?Q?I3NwNZoGTisn8Qu8TuZhUxl30Smk8qOgXZjNwSwDMjNjXWaPTqNKNyKDVQCO?=
 =?us-ascii?Q?TShyX5fAtQIDfj1Cz6MpGPLO5gYSuMNHMTPaSXj/wH2Iz/O819wV3nYUDTST?=
 =?us-ascii?Q?WZB6LYNGSQHzYlDtBON43snSylVv2Ukca2bU5N4Bsmdb4tTILCt9gMkUt0Dx?=
 =?us-ascii?Q?hNc8xJvHgTsIFL2WBixc9MFPO/dO25h/RO54Bc0WZVK557ZmBBSwfNIogbFk?=
 =?us-ascii?Q?FLAmu797cwIyV0RaKbiffguxpMf/MaUVZ5oVtsZFXGYpAEVSSox943ATRfTq?=
 =?us-ascii?Q?IB23fIAzsGy8IJBAqPo6MoGyJQt8pyXd1RWsqdN3zKb0m0yfbqlKy7CFAKvE?=
 =?us-ascii?Q?uHOWNEBEd/U56Ho9Wo3vvavNo43NvFUV4HX51Fpaat2VZZo4yUvS2igNdH7B?=
 =?us-ascii?Q?dKIJGQ0PjW2gqfOYkYJoGaZfGvNnID8IMoNE1lF36WRWDhBRyApHjHTTuw9t?=
 =?us-ascii?Q?fAiOoysro0EKMnU5/T99qrnhcuai7iLhblQNrhmKux/YOkoDy/VxIRXMtk0/?=
 =?us-ascii?Q?cKSJiiMxtS72cT1nrOc216kU+tFM4Dfp//fL2iOoENiKWJ1k7F6BdBkl4dzC?=
 =?us-ascii?Q?CJ481MgWNJEPL4X3AUutZTwB9sDgZFyo9/bKnZ9L+uWbuczaao3tRSRWgo9d?=
 =?us-ascii?Q?qRAA05a5mSIa0ZSUavWW/7cI9f/ErBIV4sQm0gxjQffKek0pFOXtOw6EBk0O?=
 =?us-ascii?Q?d2yAPqCRT/j3G4goIb7GdC2oXBua9C/bnnXXCltVaUTIs4ynFaxYUv/9sOH7?=
 =?us-ascii?Q?AEKmrHs2o0AoIqI1PMVjtG4VcGXivxE5FHdzCOX3b/obrzb+zItHo9tMOfB+?=
 =?us-ascii?Q?3OelRDANzg/HT6CJByvOaaiIyLLmJ8+yGcM3/yLUB2NaQoknxM2TXotAQIYi?=
 =?us-ascii?Q?Cxi5rfJzpM1dMvbPQtfxYO4d5IxuRp12vyyPRxdP4Z4y4Wr/tyGbxeA1UBlc?=
 =?us-ascii?Q?N1jAT/SiicN6aUqVgS5B457exVbIebJwu+w/5QTPaHMkMjARZCeq69y6u08a?=
 =?us-ascii?Q?eDchYwtFv7AXJxLDdEm/EbilBcCLrWLgp5JRfU4PkGlVaodAB2/fpaQ5pt9Y?=
 =?us-ascii?Q?Cn8Diy+Z7eQZMTdkXf5xobjORDCGd4gkdTwJ4+qcnDf40ujsNUHfcZKnIGCQ?=
 =?us-ascii?Q?GbTo4KwFQMi4azuKxH+ydxaWktgS5mvOwpCWg7Kx4ksa9Mivj2eOSGRLpeH0?=
 =?us-ascii?Q?erKH3kBlV2fpeXdFO+73XMIaij6pvh63jDXgF6cy5EQ/sc6xMtJGdk8lMqjP?=
 =?us-ascii?Q?8SicNLUgLd1I941NKilbclrrMp2+BMBPLZc4vK3b7rFPP7Ks6/pnF461x1lu?=
 =?us-ascii?Q?oMHgjCqIMWKaHyGbOfPiGuQTPS21gpvnGm2KoT248DEUIj2b75kPXPk4Jsx2?=
 =?us-ascii?Q?n0N+LP0aaHwZRrsR6Rv7OsVCtKIpTHuFQcDER/S2a7wQeY3T53Ooy1BxI+uo?=
 =?us-ascii?Q?O1udxvnIgE4ocvzZKaWHVMkg5uYbnYOtso6ywCLV/YyUxX7WtSEK5H7yDSRc?=
 =?us-ascii?Q?BuKCKHOV6UVzxYS63Od2blVX3igfCPI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C409FDC4BB55534AB60613437489AD78@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c21b2d9-4913-4931-7636-08da31e5792a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 17:58:07.6131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T5BjKnclOYZEMcWkGOTnyZ+pe7lxY6cyv7RXD6UwIX38jd2mMUQKu6kSqNHw0IKeh33YEqPXrLRONk17DTiFig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4595
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:55:37PM -0700, Colin Foster wrote:
> Hmm... So the main reason I needed get_caps was because
> phylink_generic_validate looks at mac_capabilities. I know I'll have to
> deal with supported_interfaces once I finally get the other four ports
> working, but for now the main purpose of this patch is to allow me to
> populate the mac_capabilities entry for phylink_generic_validate.
>=20
> Aside from ensuring legacy_pre_march2020 =3D false, I feel like the rest
> of the patch makes sense.

But still. Just populate mac_capabilities for everybody in the common
felix_phylink_get_caps(), and use the generic phylink validation only
for your driver.=
