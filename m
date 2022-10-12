Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D325FC482
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 13:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiJLLqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 07:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJLLpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 07:45:47 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14200C355D;
        Wed, 12 Oct 2022 04:45:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoZqjs02aUxrtDsfiXIBuCnR9f9FuTlqhEy2NZYSCMv9Lwy2FhlJlKZGpKK5D+inhjV43TpFc1kFoooxadOI0/z1OHtlNuXfItETaolvi8Pj2HUsFc2UFp2nGdI7yXzpja7IBQ64SEA679T1LhPllq4ETmNC0GD4kqFVGkzbb0EUxk9J4xb3jcq2AsB30scToN5NWv6ZL9yLkafDJ/mvjKkU494Q40J8Q0TgfG0/Xg+g6WL65fHbz2vxeSYE/jSlWai9/yo2W0gmH46YLenI/mBtMyl1hVaIJ0MlR763em8Wo5xNDYGbmRvT9jxed1zs9x4SHjIsRmlIoupnhnKB5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozC32EB8q1MDZFH1nA/hVHbcgXJWqlAt6y6+2HQmWLo=;
 b=hKgnm7rOaj50MJpwXOEQz640NXYM7yy2mAINcIBoIc7+G3Hu98DJmB5BaQA1ljqkl0U3hmgxncJv6WaqxYcqysOfrHm2vrb41OOrtirkwgVNb7upriu+7m4KRgaYVr4albOSFVj8VUr8AYqo5NGESblOmQeU9K88GkCaxWRpykHMTeSdUDP7ve3NWBUN7DY2gXWAuJ/ctJ3sgWE7NOMp5tj0K9u//qSgU+yrI3MDixqV22Psn8ur7tU225mvX9ijHDL7iz4DjRg+VK8sSNaPwwfA2mU0y39L7DYzDB8KUBZ6KhM6Zpsr/IBwEO39Pef8e4ay8Z6q5l57qdca6N+8Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozC32EB8q1MDZFH1nA/hVHbcgXJWqlAt6y6+2HQmWLo=;
 b=nhuLBhwU3Hmpse0hgX8TAwndVJ52VbeMRWs0c5M22/OeuMzDblDntioB/BFlqAgyFI4NILsHtZEPfitVI35VgFybPvspBrFU6gKKQEafB1s2XbyynpNgiCYhDVKK2tiGqCfHEqcmJy+yxJqPs/oveUNESFr68T29nFr9h/h3l1U=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by VI1PR04MB7168.eurprd04.prod.outlook.com (2603:10a6:800:129::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 11:45:33 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::ba6:d7ae:a7c9:7a3a]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::ba6:d7ae:a7c9:7a3a%4]) with mapi id 15.20.5676.028; Wed, 12 Oct 2022
 11:45:33 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Vinod Koul <vkoul@kernel.org>, Abel Vesa <abel.vesa@nxp.com>
CC:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [PATCH v9 08/12] dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL
 compatible string
Thread-Topic: [PATCH v9 08/12] dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL
 compatible string
Thread-Index: AQHYemAk3FcpcWNM7Uqo5rQbmdVl3K1FszQAgMW3X4A=
Date:   Wed, 12 Oct 2022 11:45:30 +0000
Message-ID: <DU0PR04MB9417A516C062EA7E40C9349888229@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
 <20220607111625.1845393-9-abel.vesa@nxp.com> <YqDM0umwk6QizT/b@matsya>
In-Reply-To: <YqDM0umwk6QizT/b@matsya>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR04MB9417:EE_|VI1PR04MB7168:EE_
x-ms-office365-filtering-correlation-id: 93897313-9811-4cc4-e9b8-08daac474437
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QjCqGgfNWm4rNM+OAQKVY4J2qAKytK9Oi2opg2pQoZwEeUkNHjBU9c9XX84bnYP9j8RTN2k/X9L1iv48e5quA5EhPBCzJqmd6U8myRQdfJ2g7ddn/wQoPF1GYm1jGtjJTmWa0bJsIX/TmmuAdPuhY98nhDRHCFBOD6x68fFvsbj/o46yv/r1txD6MexdpWQyi5dgk+Wyb26TeNjUYBv0NImDej1dKwHu20MlLufeU14TDvMEyaSVQGNyflbBwM0Lrnqwt2EH4BK51zA6GViBHLFVqxUnaBP9SFVN2lduGGX0R/OinOMSS6kL1UD8efU3/ppT12TiBqgqHidyxK/rPl7Kn/ZLx81GieYRwJQuNLImBO2ArbJAO1DJRTPsfeuuaoGVm9irpQBCflyocPvVznA+2pMkBcIsBzhgZNBCvcX0rRiJ10E6awuP1mWJ2oqt59xO5F6/mYrkZsMlaz74lt32ToMtdBU0dj34VUHFx7PVQIBVvyPgSsxpM1AFvAPlE/FRo1ETXuJB4E8i5GtlsoWStsoaTYBX6D/yJ85iRMLLmkapYrTpRaDW7Pr0Hxq2YDjS0PdJpaoW0fBFJKwQZF5BROVF1+UxBy8o/Y8KAM9vHAUmO8kjkUMbh4DZcFZZ29UVYUyDCpKkeSlrszSdrUHBrmXbhickbmvuYwvoWqaH+uv3r/LIO6INboteiIWLwBrulEpN9EZNkblIo27mpPtrNDsum7PoK+KDER77MOQ5WJ+PSvYBmAMw6bNmE258GyYbbCaoIm+NPAICOrNArTkd6K8DZMRfeH/lEZFflzqV8XIkA0Z2KrRYVkA4v3rymQt1C9dgN2J4DlLT/VCUjzpuRFwZdWvOm/tZuEbrUag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199015)(122000001)(38100700002)(45080400002)(478600001)(966005)(38070700005)(5660300002)(316002)(8936002)(55016003)(54906003)(110136005)(6636002)(4326008)(53546011)(8676002)(76116006)(66946007)(64756008)(66446008)(66476007)(66556008)(41300700001)(71200400001)(7696005)(6506007)(2906002)(86362001)(52536014)(9686003)(33656002)(186003)(26005)(7416002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ao7yvmJuLdWsZ4oorsIq3f2DM8xFYUaRBcBRl6ItAzCFt5NJCCGNHu48nEJf?=
 =?us-ascii?Q?Z9LdnzZVRkYaKjHVS4aYFQxO7fCJcpd+JEC9LBuU5O1oMWgXr4KyOiV+F6Sg?=
 =?us-ascii?Q?nHfc/yxsMSGj3vmFHBLZRgubngmcyoKjhZMw8BwI2ouFoSY8MC8sNnXKHRta?=
 =?us-ascii?Q?xigg/XoAS/Wd2/n47UTWIaLrd3ZpPMuTVP7da+/jn9rjLrXJPVnut3QbaPqm?=
 =?us-ascii?Q?u11duhcoTpkUMHdtGaIIEJiAfAlPDTZx7Y8Eazu/6hfduUslyQXxYdH43PN/?=
 =?us-ascii?Q?8YtmL5tfej2dW5HidiEPYlZAxmQ3UDTDPmnIJgLXsCDZfgRjBCqsSaKeQdbw?=
 =?us-ascii?Q?yw9eYLQH2us9+a8UVhJc+t8ZA52kkgJ005icywXeQ2ZTb4AlPUlHfXgM8ieR?=
 =?us-ascii?Q?l6edGCk0SZ+xX9a2upO53p7BbkNSO2uOnZrZhUO76ctp9SCydZr76wlraAyZ?=
 =?us-ascii?Q?9zya+7Va/hYO7xv2FOza1fM9iFBnBrfDFHToFtS7JsA+qu/sjt2z+X8UpFJN?=
 =?us-ascii?Q?esJsL1NGCh7LvvDm62+xZcbSWhtEZpH6PNPXoqvct5QYVV3IhFfWtwMrXljI?=
 =?us-ascii?Q?WEt2J/GaH8GlEuFUKkxCKiDvQ1RGu2y83lPL/uvsheU9wK0kMR83INm6o8E7?=
 =?us-ascii?Q?dzZg/ToaBrvUz/omdlKSVrd2Q6QHINuigPnTDmgv7rcLynOmFtHBl4iHOkyQ?=
 =?us-ascii?Q?V5kkTiAdgMPIWxy5OeFvTdCgCFkgJYHPpfcVEQvVef+IuZHwOALCSjt7AiT0?=
 =?us-ascii?Q?T0nTw+CvHypds2TaCWq2w99jtBNM5gjJkOBZrS3C46jMpFgttdz81ObL86YN?=
 =?us-ascii?Q?zfXHAPSxEsFpvgCrlIfNzBykLHiWnXVnPl+rz58BaG+IhLuE53x+T98MklcU?=
 =?us-ascii?Q?UbxL3FZy4P3L3nqb2v4H3ePhW4Bqyn7/ycS3DWdFaFrv+m7EC8JNcAyLUZeJ?=
 =?us-ascii?Q?5JKsWNIVg+Hv0mDlzTtAC/QdWwKLxHRGcAuZHrKbVDHEDuZElSpvtqs4HHyh?=
 =?us-ascii?Q?eE8DK4lYVGgc4ggWbI3OzjZkaOG0xBLrWpTzqzykGfvN6ym/BGeWqoGYvnmc?=
 =?us-ascii?Q?4FC+GrQfSD6qRIOXonAmgXkRLOndIGZUlBxUGxi7ADPaLxQl5Gd6y9iskkKq?=
 =?us-ascii?Q?1e2TjGqeo0WIxHjZwoW/2DBZ1paZpzUmSo39BbOGH9SZLY0Sz8KOni/sLsud?=
 =?us-ascii?Q?nNyyEzuTarLBIHzFOVUTcbBapflaH+Yu49pDnIW39BVvHnaPxBIGv39nwHVa?=
 =?us-ascii?Q?fHPsj4PNxCWRY1ZhwkL1O6ACPPKYy2l469eomBYJVMXl7NoIUeuj/v6DDCtD?=
 =?us-ascii?Q?7razyQCLzvef/AYT5QjDUxZrX1ggswH9JnRi/YRc0qJQROWaXAxajmeS4DEZ?=
 =?us-ascii?Q?a2onWNGypJUEYEXeYkUxOplq6vR6V8htncgCORn+sZBMvxPGEAwJs3hC71dO?=
 =?us-ascii?Q?3wFqQaeaFZgYP8tyqlpkTOw2Eh1qSc57IHp5FobIpWI0kP2pNYdm2U4+QLeH?=
 =?us-ascii?Q?Vpok5eD1jmM1doxKGXvHaSYjSCO6egmSdm7Wv/lU97dIZXw/d0vCKeWmW91v?=
 =?us-ascii?Q?0soNuXM7o1iClPkWJfBzRgPpKr4OZWIR6PpFGxZs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93897313-9811-4cc4-e9b8-08daac474437
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 11:45:31.2892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YvOmiOzPBqVpats8zui8SplPBQyi0sbjtcFXZZ4Tg2PTKPaozghcBeW5mPFcLPbCnLdbytoCCh+hodhwnX0p2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinod, Rob, Krzysztof

> Subject: Re: [PATCH v9 08/12] dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL
> compatible string
>=20
> On 07-06-22, 14:16, Abel Vesa wrote:
> > Add compatible for i.MX8DXL USB PHY.
>=20
> Applied, thanks

I would like to know the rule that whether such new compatible string or ne=
w
property added to txt binding doc still is still ok to be accepted?

Or only fixes are accepted for txt binding?

Thanks,
Peng.

>=20
> >
> > Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> > Acked-by: Rob Herring <robh@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/phy/mxs-usb-phy.txt | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
> b/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
> > index c9f5c0caf8a9..c9e392c64a7c 100644
> > --- a/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
> > +++ b/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
> > @@ -8,6 +8,7 @@ Required properties:
> >  	* "fsl,vf610-usbphy" for Vybrid vf610
> >  	* "fsl,imx6sx-usbphy" for imx6sx
> >  	* "fsl,imx7ulp-usbphy" for imx7ulp
> > +	* "fsl,imx8dxl-usbphy" for imx8dxl
> >    "fsl,imx23-usbphy" is still a fallback for other strings
> >  - reg: Should contain registers location and length
> >  - interrupts: Should contain phy interrupt
> > --
> > 2.34.3
> >
> >
> > --
> > linux-phy mailing list
> > linux-phy@lists.infradead.org
> >
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flists=
.i
> nfradead.org%2Fmailman%2Flistinfo%2Flinux-
> phy&amp;data=3D05%7C01%7Cpeng.fan%40nxp.com%7Cd65b54c2406f44828
> a9408da496b20fd%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6
> 37903021707349724%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM
> DAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%
> 7C&amp;sdata=3DfPitVfeWmcSXvD3APuxTmytkTOS8Wt3z5ExVU4Ct334%3D&a
> mp;reserved=3D0
>=20
> --
> ~Vinod
