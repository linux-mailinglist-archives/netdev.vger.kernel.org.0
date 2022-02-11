Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECCC4B2703
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 14:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350502AbiBKNYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 08:24:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiBKNYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 08:24:15 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2064.outbound.protection.outlook.com [40.107.21.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0905FCCF;
        Fri, 11 Feb 2022 05:24:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kpi4/zeSGPG+GYZbSHGndh8xSd1DSyAki5bDt3aBhbbQlIwfSMjlJI9Fdi3tN6Biy8UFmvLiy2oGkeIPp4dc4OIoZsUg1M1gMqjQjr1O3O3LclNDWa+02svvnRLmOesBd0LWj9SFn2Te3RzhWCUg0biP6/0+CjTo+mmVg5tiM3s7qc7/wme7qZAU5cHN1oj+ccmaLS3dMCXxVwhFRmbFHKIeznwqh+JJMg/CrUYsFz9q8l76YtNphuCO6cPPIT6oLLvgvLXYP2c9VqvPETklfKiWUVIeXZCVkusRT8QhiwT3WYsNZ9U0EjtppjtS7abfa6L7n3f87NirqEhOYLVkkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7RDy8hAhNS94+CVKyfX8L8czHMv/FA7kjHsI+TXK6o=;
 b=E5LBOpjUDQqV8HwZmAcwr4uPHfFBa7osUAy3mwn9oLJSSEIZ+3jQiViSZqyFgdmsgpbWCcsgEYr8+5CkG/Hvs6g5ONGuZg0X0oZ3uDmWRH56YZ1SqyzM1suRVlCca38j54H/o5xZUDnEOYHaud6xNI2Dj0EVhth+yLlu1by1wF0+W9881MtVL7vFbJVzhbDPFwK8STk2cGl9rE6kZTS7Tlrwo9fbMA+gq70O/LFIRqUnE5kBcOdyHryUVqBq79sIwSurzhAVer0shX0ygE/INct+bSLs91H1sgN7+AMVNn7pYUsf0W5FUGmj0cDp87xC7yOZTcbs3MX9PxpTvIv2Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7RDy8hAhNS94+CVKyfX8L8czHMv/FA7kjHsI+TXK6o=;
 b=fF4hX3wHIF9ln+H2h/izJthUNYPv3uHRLzgijnsEBUq+2PGso5EOI5C5+5zicKYuV1iFzVgTynHbq0Iqbj7QomsxF3xZpS/Swvexl531SQ3qFqZXsA17EwRDLm7RUMT+0+d5kJOuU6+7ynTITaPSb0YALaVq3hwWqo8FDAg/Yzc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB7009.eurprd04.prod.outlook.com (2603:10a6:208:19b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 11 Feb
 2022 13:24:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 13:24:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rob Herring <robh@kernel.org>
CC:     Shawn Guo <shawnguo@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Michael Walle <michael@walle.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] dt-bindings: mfd: add "fsl,ls1028a-qds-qixis-i2c"
 compatible to sl28cpld
Thread-Topic: [PATCH 2/3] dt-bindings: mfd: add "fsl,ls1028a-qds-qixis-i2c"
 compatible to sl28cpld
Thread-Index: AQHYE6JPJsttfCUAAUS/+BKErg2nQKyOZ8IAgAAGRwA=
Date:   Fri, 11 Feb 2022 13:24:11 +0000
Message-ID: <20220211132410.3qldvlpznlrxsgzg@skbuf>
References: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
 <20220127172105.4085950-3-vladimir.oltean@nxp.com>
 <YgZeNqAbdisyeT+s@robh.at.kernel.org>
In-Reply-To: <YgZeNqAbdisyeT+s@robh.at.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbfe0b17-99d7-4fce-4c8d-08d9ed61ca5e
x-ms-traffictypediagnostic: AM0PR04MB7009:EE_
x-microsoft-antispam-prvs: <AM0PR04MB70099422C40EF0B8392FE22CE0309@AM0PR04MB7009.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J567cxrqNk7uFnU8qONxlOx2AcsUKmEIVafpxJsK8PLqMdmT27fforNO6Cj0W2qhEc6MaxSxhhA2buWGePjDu17UDdYLoRTw1ololZ4kxaXG9TuR05CEeorh08Oy0EoA5UtEJbgfVpKg0UmA5OOyca9BXlGwkhUCoXi4dzM5Zi3yBrP0V+h9/QLOw5d6XXCvAks0n9gqbc5thoJWEUrkODtI6y4j14LDiS2wWKtXlRO/x0bvQ/ZEUt6i7yqAEVzO58yxei+kQZO3MghLPszfL3w4Y+QmL8VGWoQNb8O0bIXHGN1aei6MUyCpkkOIrQ2zImI96Xj95TAf/+E+MPaLBth/ZNUY52hftZolxDjvUo15am7a73rSHpeRmxD/pfef7tvkZkFQiGBQyRyw+SszhmkJHBZD/K4UYjV2hxZBdNV0okXI1PKfjHZ6iLX1T1iQ8VvUTjS1E2vgRK34TYFaEj37ORb3wQiubSJc755eGNDDu16mSsy5kmKb/+v+FIK+NHqREQZON1xV+ZrpKpzXIySUPFESsPjFAUs+Bx0KAy0AhzV1eWVvDigw/WupJWU8u3Fn5vNNmsxaG8L/ka+D1z4oZEsu9Z/ADAT6P4wMJfQAcxYut9xef36D6i5qdnjRk75jvUNnVPTqGhPyQl0ttncRwXOZT3NEzkJeJyhgsb6SyK5zb2DiCWSfYUMrGAIGGcPsQT7J0Lfz4mbFBKpOsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(186003)(26005)(33716001)(1076003)(66556008)(86362001)(66946007)(2906002)(38100700002)(508600001)(66476007)(44832011)(9686003)(66446008)(83380400001)(64756008)(7416002)(38070700005)(54906003)(316002)(6916009)(8936002)(76116006)(8676002)(71200400001)(6506007)(6486002)(5660300002)(122000001)(6512007)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UppBvJ0okN2NRA00YSYEgcNib0Y9YQ+WAtohB/FA44aigWiSCU8HiUDojSfZ?=
 =?us-ascii?Q?w+9ZlClwclasBRQdx3U4i8IfsdpBGW4VzQJh5wzXnGo6dxqbPMAlQF65aWiZ?=
 =?us-ascii?Q?Rjkx+jgUkfD/KiRTCqTyO0LKCG9APeNOKraTuHZ0LzJQBfKw7ItkMI7LxB39?=
 =?us-ascii?Q?fu/45rdcpfMcOGynGztK7T3MWzeEWE2wZSwMzX3KD1xnoOmPHvv53fd1YQM3?=
 =?us-ascii?Q?jbFuM6dd1+egHLiM9K4xxnghJxJQ7kFdNIocETkAtifduDy1pV9EcSlZ8GZl?=
 =?us-ascii?Q?XJU0G3QT3YTKvG1UtXAL1f12t5eCHZIWRwkpSxCMrVTo71VxZMcomkxBuuhu?=
 =?us-ascii?Q?jkFM6crul5rUmlRc4/ctmyUYhTLq6c0mfrxsBoyy0PgEyb+9ZhlAl0gCMFCK?=
 =?us-ascii?Q?mqfnXce2yGqSBP8rkV/gGL5HBL2GpXxkW+WBPpLNgRxtZ4BFZ0avphHNYPZ1?=
 =?us-ascii?Q?GJBvhqSoOc8Fdv9lpFsvawj6QV57qX1vuAjU+Wxacgq1CD9DjPmZRyTCROwu?=
 =?us-ascii?Q?dA0ChEG8/L0lg1pNVM1+jId56A9IJue3rEL945CIa5mrUgMX3tePvX9iaT41?=
 =?us-ascii?Q?rcicFR82DTt/zYxaiqqfr49RwFRkvdH9MiL9VFc010zsbl+prs/qP7lm6Va6?=
 =?us-ascii?Q?4Yej6pT5jscyfq1HNCxD87FPVo2lYTbbXLucD4bfVddYOtJX+a+lV2go8RPl?=
 =?us-ascii?Q?xJAdsEoCF0rQBOug5M1ukPehDfBXjxq9vaF4QaTjsWDy1Y92jNN6FfRg+dA2?=
 =?us-ascii?Q?9JjkYKeTaHzYspN4zt0EJ7YKhhBNOERY/Vz9zVJSAZ4KjugPVG9TmxfnzKvS?=
 =?us-ascii?Q?lDocxLFJvEV6HB8EmbgkxJX26xZLmjQ8eJbWMXDMhwrbBWnlLDoQM44DPdP2?=
 =?us-ascii?Q?JaX0mMqODstWZFalm7nj0jMXRh3mtj/vGl1YmOG5H1NyJDk81HsC98zY/AeT?=
 =?us-ascii?Q?CfDJ1mAZoF0IJ8P0FhkxhJqgo572+RENSO7pLgyidwBOlxEehVKb9GSuS7Sj?=
 =?us-ascii?Q?txYNS7Ji7pElfecuphd0qeJrCaZ8/AgxIT9TQjw1/Mz9Z8Q79YfFrPFTaXwv?=
 =?us-ascii?Q?ZjV11wVAY1bvDvVFDmPSuGaIRk8SuZ7ZpJ5u/ve6MxI69A3b5L/ruGAbb3tP?=
 =?us-ascii?Q?kCrd4vbLWAFivORqlk+oW3uMBnHUGjCGD/93YoJwCUiYK6WjaVkKML1YGwD4?=
 =?us-ascii?Q?xy4pZd7BzRoHMGwoYFoguEKe2Ld6raeykZ32BGT/usDJYt7rxAtcQrIHiQN8?=
 =?us-ascii?Q?BMHHIgJfnijAQLJh82EvZSfHKuqR0WUTjTb2f1ktqR4P/llA40wHrs6NVRz/?=
 =?us-ascii?Q?KMqqncETZyqNFcMG97uyBPyF7o3uxQzwfceJxUxQafa9e5RvlxmwEHFRDw7s?=
 =?us-ascii?Q?OXKidH4BphCxpK+mB5i0fGZcTIJmpyPkGwmZsESqbfnU5E9hWQI7AW9hNvbs?=
 =?us-ascii?Q?bE4HKVU7eK9CiSVDiuHFIRAJB9O87M/L8ll3aQ3+Lb+XbqM/uPXo8aegXUfa?=
 =?us-ascii?Q?nhZG/2RXy9JpGlfnNFgoIm92MiiA5iLOcxTlIJ9uu7u8TOOT92GPqV2JOVmJ?=
 =?us-ascii?Q?K9gy4DSE8hoSeYdQo1Jfh00mB4rzm/JRSEf2/6l2+pMdA15Qdllrpdk4hLyS?=
 =?us-ascii?Q?WTxroNsukLAzgdf8YRYl49M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0DB778AC6052874E919507B14AF9A7FC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfe0b17-99d7-4fce-4c8d-08d9ed61ca5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 13:24:11.1174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paPOCuIuMWMgNUGarx6fyrQATqHLsEbaXQBA8eQHOXHHgZwwi2UeqoMC7N4zHCY0xaMiNcoRKK6sX5tMaHJSnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7009
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 07:01:42AM -0600, Rob Herring wrote:
> On Thu, Jan 27, 2022 at 07:21:04PM +0200, Vladimir Oltean wrote:
> > The LS1028A-QDS QIXIS FPGA has no problem working with the
> > simple-mfd-i2c.c driver, so extend the list of compatible strings to
> > include that part.
> >=20
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yam=
l b/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
> > index eb3b43547cb6..8c1216eb36ee 100644
> > --- a/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
> > +++ b/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
> > @@ -16,7 +16,9 @@ description: |
> > =20
> >  properties:
> >    compatible:
> > -    const: kontron,sl28cpld
> > +    enum:
> > +      - fsl,ls1028a-qds-qixis-i2c
> > +      - kontron,sl28cpld
>=20
> Is there some relationship between these besides happening to use the=20
> same driver? Sharing a generic driver is not a reason to have the same=20
> binding doc.
>=20
> Your DT has a mux-controller which is undocuemnted in this binding.
>=20
> Rob

I'd guess they are both programmable FPGA's/CPLD's that are used for
board control. What I don't know is whether the sources for the Kontron
bit stream are derived in any way from the QIXIS.

I can look into adding a separate binding doc for the QIXIS anyway.=
