Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE7752037A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbiEIRY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiEIRY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:24:27 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10040.outbound.protection.outlook.com [40.107.1.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BA024F0E0;
        Mon,  9 May 2022 10:20:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdwGfe+GFBKolOdccTeoNCNqZ29mI+Ofxlxw4VuYugmnRD3gxw4egetyQNpdTDmMEWnGuhKpX10qM2bHFai3+7HCwmtyWgxyn65FFpD+Za/uEQcOpAisoSG2JLm/rjsGpYElcfuSCnYsvySRFRZOo56KBAem3+RAzmyTOtnRpflEwt+5KiZLAbl5Mtrs8aTOxlxslyETx5ik/rcWM3ncjMCqh/fCT5tE9HIvj0EL4DsC64EqTWn29KtXxo/wYd1Xfj4r11FFDJR5RLuWdStR01iaNA7U7gY8t4vjmmpCx0du9Qp6yPj3EbRy5bA+lKgCUYAPc42jsGdTvWh0LBAnqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKOJJaa/m7+lAQKyQfyutWour/FE/NruRhGUnSshDdI=;
 b=iaTE3/Usv5bRe2QoFbgtH4NeXrIE6hNeenrbUpENPk5CnyqLhpgHUiX6n9BOG7OVRlAdeqmCIXQ26KVi5RzcwpYcWGFfUAVk1qpGVqo40bpt2fVX8k+b0gsnIawATqKFG6aFSITiXOCpDZKh6R2X8tceJ0HL8RXLlKb669ITSGX5jkCotAXMnwGZBqdnibiCKgHZdTu1XV0S8M8V0uXtFx5/pDVgkMIiQZeI0YaYu8JmP52LSQ2BrLD4uQ76Sota2sANyYC/3Le6zd7PssBSoC6LH2qDrrJ3QbWMmjaTauCluBX5YPrm8XSr8u9uTFLp46XqjKTfAql3Ach8A/4lqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKOJJaa/m7+lAQKyQfyutWour/FE/NruRhGUnSshDdI=;
 b=DOFYqgWIYa0eKGOW/VC9D4msSdLr5FiGoyaNwnpouJNyijIk2hBoMmnm3ttGYp7n5p0Nx1fkOB1v8WLLrlY+YSHiZtcgNfcOBsaJW/OONFhUsrDwnD7vsxkCNjjB9eWikTBW63fXbhrdOU3KfGeF1jr6+OKf1TAlPDINYMAiBbw=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB6991.eurprd04.prod.outlook.com (2603:10a6:803:12d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 17:20:29 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 17:20:29 +0000
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
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Topic: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Index: AQHYYwz1YnOGgXOqGkauFg8TINDh2q0WX7KAgADZBAD//5NXAA==
Date:   Mon, 9 May 2022 17:20:29 +0000
Message-ID: <20220509172028.qcxzexnabovrdatq@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <20220509105239.wriaryaclzsq5ia3@skbuf>
 <20220509234922.GC895@COLIN-DESKTOP1.localdomain>
In-Reply-To: <20220509234922.GC895@COLIN-DESKTOP1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a586e0df-b068-45de-683d-08da31e03718
x-ms-traffictypediagnostic: VI1PR04MB6991:EE_
x-microsoft-antispam-prvs: <VI1PR04MB69910653ACC177A8887815CBE0C69@VI1PR04MB6991.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VdKg5t64M1nBzIO7SpEjQ4Fizc+kg5UDfmsIwEB5HF61b5vI3NIsMw8O7syJhkXtAcLb+z22ySu/EA9M5J/jbbN0dN9mN/JzLbqZZlS5KWNXgadvuzr/Dp5J094btaEpOwrVhMLco+aZUAcmoO/glEbkyHTVOFKfEgDp0kH5EZ3OaVqh+u3vb+W1nnxllRwuwXnrktFru84KrGyhRLySZuSOvkWgfsawqnwzFMzWpmnydQDS8d1kKrZQEV9pKJWOTeScqppTK0pOqTsyJbhlfYQyUdJwjiEZFZoAHf6WqGUR4rnv9fPFfNV5G43zjiIipjxwBkVau7MOkdcSN8YUUXOrtjNp9oBaOF5jhEZc7dyzQP/ewygjm8BiG2BFya7p0ieY+gjdTLpxiiwwrnQXgnqZm8fHrIB1pfD7P9pvGUvi4KTy4XpGCEJ8zFdQEyQkFjjWNtnvvhczzFrKL7JAKhjS58yMxJYlwzBJeutPNqRrl28BLeIjE7g03d83BWUpz6Fh9dI0GJV4/WhC/nYWNSUeZDw+VnyqXx+MHN8l9UDTkZs6iXwN7lFimS148LlaAepIvhRL9SPrHENeuuZNtjsukY7b4UDeqIy+3txk91sTG4/M1YrtOUcojvKcEu0ZgEsnT8TG99GLcLAfXN1zLOVZnSSCBGBAazHACJrxfsenPuV/ZLjI9KbFx62zrpSnfbAxVZvuXpGXpnGCZrKz+IIKsp5qWLIgZUgf21mZM45Sk2diIjH/cT9G8LvKIGPaA+efemTUc7QXeUANdwTLPGPNfmq0wXIQHgsIAjXUiIs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(122000001)(66446008)(8676002)(76116006)(66946007)(66556008)(64756008)(54906003)(6916009)(38070700005)(26005)(33716001)(38100700002)(4326008)(66476007)(6512007)(9686003)(71200400001)(1076003)(86362001)(3716004)(83380400001)(8936002)(966005)(2906002)(6486002)(6506007)(508600001)(5660300002)(7416002)(44832011)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AWmDXfmlS5qRja8DRQkZNqOK4bJtwg6gfB79uL9/4zD7ULtY8lLM9HI0q1Da?=
 =?us-ascii?Q?tJR+QhXNfnBQMRc5QMPJutOgkzBl7Kuj63nQn3uOjOqS3WJikuHp75y0uqBK?=
 =?us-ascii?Q?vweHCpjvD0tprsYF0mBYyAZ4QSI3GZXFQ32GX42N6wH4EfR2aTZ6nXmyxL3H?=
 =?us-ascii?Q?ZLxdg5ZIsMZiZAoslEFCtJNMohQ6QQgZ4ET7XnfWhxiJRC7UUYjrQaoVsUHv?=
 =?us-ascii?Q?F9hL46kM4hIdlTtTagf17Wa/0ZAeb1El7SnpO/IFgGEdKdjaLpidXtuuFl6J?=
 =?us-ascii?Q?9edHiV6EekhVQocrcnR3jYtAjrQT7smJWrkoFoABy6LXDFNsgedtY0WiPU+D?=
 =?us-ascii?Q?hC9HOFjGDOCkSVFw+SruTNXitbClWueQ8aPEx571zU0cXip/QUHv7N34tC81?=
 =?us-ascii?Q?y5DocglRIJvqVjV+anysUikOxaPuFYDjCbsKbODgP1cw3pwesjWBwnkHO0qB?=
 =?us-ascii?Q?/XYejSVZD4BiAQlZhNtM2mrbqKGeH8c5Oa01nXY/S/CvsDEdXrTLIAr181Sh?=
 =?us-ascii?Q?QQRrQlXyxMmWxYs3Qb9a0nLr2jgHExmgYha9muDfBXhImHTJalqjqtwTL/ox?=
 =?us-ascii?Q?JW6VO4kGUEECCeTv3hTfMAeHp9GO34Xow2t/XuzLeZ6fuCUqDWbnCQuVFH7w?=
 =?us-ascii?Q?bv2m2TnAG3Mv0LiPEjpSmS/ib7IY1F2HSRauo+cpyZnWqdkP37RMyufaUYRn?=
 =?us-ascii?Q?LLZIAPviAOBr3ZylwBJoO++ZgJYcH5SskyRqEZNhawJCO3nPznRN520OYBrf?=
 =?us-ascii?Q?cmxVnIrvc0SQOJtH2ZNVkQVAs4B7xDKgg+C5Au9R6MqTPWxLUQXThkQ4mSll?=
 =?us-ascii?Q?oo1B0oe45FxFjX0YQb1cuOnH5m/WTRlh0g3899waq6UN0hGElAA3IwxaK74T?=
 =?us-ascii?Q?hmdaDAK0HszBdwJZqu4FLAAyzN/WuXXKYeHWvcaG0Wb3T9u7nED5eGrhPv6q?=
 =?us-ascii?Q?unq98LrBWQ90usCt6pvobHCL5lPcJzaFzPCtGjTBJZj5WLTQxKGYwlzS3vF3?=
 =?us-ascii?Q?0OtZ0JyF+8W8hYqxQ0Rg6tEsElDWOfxqZfkV4KVmu/65BHcz6+KgKgqEx/Uc?=
 =?us-ascii?Q?GKcdCBpfqOe/OD6pK8TAZxSlXuRiRe6jMmPRr/OVm8mFeeAOgZpz9K7na3hl?=
 =?us-ascii?Q?DTla3u289K3Y9HPf9Z5hauCrWu2Nt1dVcJLzVcoaijYQZ5Oqq9TnTF54RX44?=
 =?us-ascii?Q?6+CV9iMqIU4kdipiAGtAwqU8lbmXT43eVNwDzk81FGYyToxMkRibr7dTh0nT?=
 =?us-ascii?Q?nqAeaCciBF/0eIXEXDFwmkrx+bOb1bYn/p/yIn+g6EPNPqR9KPtfn7kilX8N?=
 =?us-ascii?Q?egsZvNoC/jGILHDl/AF3/9SzKPKBPiFIKxyKftTEkD1zBrwV12rjXuh6hPQZ?=
 =?us-ascii?Q?NgWB8u13XZ4ZsogRayBloSAwqmqj6OGJ/SsgyNHjc6/gr/I403j/+zRA48RQ?=
 =?us-ascii?Q?TMaTY45DWMvzVs1aHPWyrXzD7hp+C2cswz+nP2en9n1Uv1Wi8RYr2wd9XzyJ?=
 =?us-ascii?Q?qDMTEYPgHu3AiaA6Rd1HAxop38hcvY9oBS6jindVn9XqoGZ2y+EpQpM3G8bu?=
 =?us-ascii?Q?nl0NdTHZdhRSoCDFmRVE7oafTCzgF8SuaqqXcr+U3gMEEIvtVAGj0S7QpsFE?=
 =?us-ascii?Q?XPthfom10Api/mn7a+0OkSGZMFcsyi0WBQs3i04QP+hizaWMX/NwINPazT5C?=
 =?us-ascii?Q?ZDZMFVqz+THK1bE3AmUwnWk43JPsqTFYHVGCoxMZ3IS35LTIdBYU0GZ89S6P?=
 =?us-ascii?Q?AFdHhgphX+0jvncT/kJBB+3XpTvmUyc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <90DDEC718E4EED479164D50F1FECCE4E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a586e0df-b068-45de-683d-08da31e03718
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 17:20:29.2659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pcf20jrErGSy371kYxC/JIl5JLt+22Fl9lGXa6dnhieHUhV2qI2mC/4MPeEFjF2IGMcl6dmeTZEhMrq6QJEyUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6991
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 04:49:22PM -0700, Colin Foster wrote:
> > > +struct regmap *ocelot_init_regmap_from_resource(struct device *child=
,
> > > +						const struct resource *res)
> > > +{
> > > +	struct device *dev =3D child->parent;
> > > +
> > > +	return ocelot_spi_devm_init_regmap(dev, child, res);
> >=20
> > So much for being bus-agnostic :-/
> > Maybe get the struct ocelot_ddata and call ocelot_spi_devm_init_regmap(=
)
> > via a function pointer which is populated by ocelot-spi.c? If you do
> > that don't forget to clean up drivers/mfd/ocelot.h of SPI specific stuf=
f.
>=20
> That was my initial design. "core" was calling into "spi" exclusively
> via function pointers.
>=20
> The request was "Please find a clearer way to do this without function
> pointers"
>=20
> https://lore.kernel.org/netdev/Ydwju35sN9QJqJ%2FP@google.com/

Yeah, I'm not sure what Lee was looking for, either. In any case I agree
with the comment that you aren't configuring a bus. In this context it
seems more appropriate to call this function pointer "init_regmap", with
different implementations per transport.

Or alternatively you could leave the "core"/"spi" pseudo-separation up
to the next person who needs to add support for some other register I/O
method.=
