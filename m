Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841D756CB25
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 20:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiGIS5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 14:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIS5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 14:57:30 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1568211A38;
        Sat,  9 Jul 2022 11:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGLt1CsRV9VJGi9krmKBeDphNnBh+HP9GHVu87Jk+9386FeoXmSgAiu3D7en7XR7A09pXrBfBeuQK9WwX88RAYs08xYqBx2pur5CTpzO1g3pXIArMkSeHsARdV2kBVWWn8Ro7mJBLAdrhXowYJ3z5VDWMEZngUlhp6iKHynT6VgNqq/8R0/eqsGtpB4VAnqcIvMhvHq/s1V+AFzoRCtHsqyWvtQsE7EaoXrfiij5niWoMDm8a/85pYI7j+tL0LoLwICtoPKkpRFnSBXZ1zMcVOYkuNim5q0JDO38jpZ4Kou1ZzNARYR3TVufJJVIP4yfjl1VwiQTdguNV0OonGf0jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6IftdU31lBcEMJ7uWr0Jm5auIVBw7c4JJYp+LVA8KI=;
 b=nKwhaQ1K5mcPeE0XiHAFQdVpIKX6ruzeNknSg3IJiWKzQky4rA6VCgwkj9mKwNNa1IlSjgk0rYeQsBQRjNPFZo5F9yQLuB4f4eWAgynBmz+QY0z1AVBNg3IbABpQ2r4/oeGir044uOelWVy/BbgZbGX9T+vq5jYVSC6gv2rn7AI7gigsciogYxdt+q1knkXlGgvxMc4oy2KWN6bKRteScgkZkuxiTEiYGEBWx+ADsTa9tQmtr7su3XpahPbuQ421N18T8tEfW5pMfkbQF/LF2ZRIDAtpQdm54nE4AKHU6xcidxbS+EVQ+58uRelK5P3e3hIBDBcx4p2cxMtvcc4dJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6IftdU31lBcEMJ7uWr0Jm5auIVBw7c4JJYp+LVA8KI=;
 b=a3uXHsdkNJ/qVP8sT/iRU+yQKYSUWyj8fwhiXIH0hKT4jyyAb/S7AIUm2euI96Hn7UoHgiIPuLvIPlegTzpC0augvWutMhdyxutHzEkFy/Up1Pcj/3suMpqwPEauwDoX42DUDrkraIGseDQ3blqaVL/8jg8BPwYKfkztKSF9mbM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9462.eurprd04.prod.outlook.com (2603:10a6:102:2aa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Sat, 9 Jul
 2022 18:57:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.020; Sat, 9 Jul 2022
 18:57:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v13 net-next 2/9] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
Thread-Topic: [PATCH v13 net-next 2/9] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
Thread-Index: AQHYkLCNK3WxPMg6GUCk5CitPvfw1612ahQA
Date:   Sat, 9 Jul 2022 18:57:27 +0000
Message-ID: <20220709185726.lm6jmsheafxj3ewo@skbuf>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-3-colin.foster@in-advantage.com>
In-Reply-To: <20220705204743.3224692-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eda1cc3a-9b75-436a-200e-08da61dcde5f
x-ms-traffictypediagnostic: PA4PR04MB9462:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cuUZCEeRF1XimBVHDKffVaMMrTykasb/JMRKDFWi0bd45eJkzywdo8oi6VW31tUafX1ZeyO2/8ip8iMZ0BKAXT0siBfP/R+Q1UH8wvxalRLyCRI8DXrJ0BgOs2r7aT0677iFtrTDYxgm0hLDhU2nufCR/QruzIMhVID0CS1rcCsVQ/P5gjWlXprOGx+l1IZ6lpoODS3hERf0xdYaKA1POFp3iG4wtidCu+8zcuyH/ITQ/xqLl+36jJ8R491qjbVAVolTZp2+eqzdRrgFlFqocvwOEkQSPz8+VwbUwmgmez3ynKXoGia2fBp27JKO6k8tfRQqTifo8P4MM3kMsVGUrtzjJSx+hQ/D4slLCX0J6x/DGMknmC6U1aYtMkZ1VwB5CPr0XWbWXv3ZitNAzRIo+hvV1VRGAJWzQ9wWW/+piJbPnFufJOPKmq6DTa61GL9ZqnhgMBUob5Fa/FqnB0J26C+Cpm6nG3PsL469q6cEf3ClD/vxpe52Mp2mX4/TlhXmmPI5+XraIRjU2jscYoo/mp7rw+juWmHFTtExOivPAw3xJn2IkbjrW+XCk7x82cYE9mu1SUbEqQJM99FfJAX50OzYNhnjK5OxJ4tFKwEd/7FnNEtlErPmHAgBPRkb2uOCPbplskxNMwm860HlIw5Vzy4Yxtl1sOUmYDayJnYamXGe4i81FDayt8UgryAZ0Q72bpEAKchGwhhFTOFIEVgoyl70qhZaBBSNaDX+60fcVdDHYSBjCUKmoOOq49r2Fb2F3/rRrXzo4DZcUS2mqUV+0ocTJK53PoSG9ONWtT9srtBQony7dx6DhpGTjzFhx6du
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6512007)(9686003)(38070700005)(26005)(86362001)(122000001)(38100700002)(4744005)(6486002)(6506007)(76116006)(44832011)(7416002)(478600001)(4326008)(8936002)(64756008)(66556008)(66946007)(8676002)(66476007)(66446008)(5660300002)(186003)(33716001)(2906002)(91956017)(41300700001)(71200400001)(54906003)(6916009)(316002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XolZO+DlRCkQ9iiruTYIsIrTbC27vazHNZ2rgxlNLyCU3yys4TQ+qUM6NtAh?=
 =?us-ascii?Q?UJHe2f/j8x9nonXdOk8vWYz9kgfPIoolzQmaHu8i6+P+B4Y3sfm7cmd3qCv4?=
 =?us-ascii?Q?VNeFIXwMJuAa+2NdD5kPAQb1HvWgXUfgzRS11yTGWghxnsY4gPKja3j7Dq3y?=
 =?us-ascii?Q?wLpnv39rkkHgvjsrbRLLHmSk8+Phoe3emPzonpGU67fs1RhsmbW5757HUOFM?=
 =?us-ascii?Q?URfnGG+Lsvc/vIDkTNHMyhD3rtIisaRhyoCna3wMGm8EnwENfjjqdIkTeqjC?=
 =?us-ascii?Q?/9Uu5vY9rWE4l6pEqVF14XTY/lzx1sbiurp4skaxyWRD9dIIOmclt/PqoljE?=
 =?us-ascii?Q?nM+dmu+spqiPjTYHjl5Q8Civq80HKIUmuFkbDoq3V0Qa4VwHFuiMSLinpZN/?=
 =?us-ascii?Q?SuMaOJ3vvKL5WgI+I54fn3FgoEPYoOl7SKaKsQx08lqrvS7Dy4s1/9E7MlQD?=
 =?us-ascii?Q?4z/ZshaByOvtMwUHNlOsbnTd7Yjp37BKpScQ5B64zEA5fSjXBDVjyd/aZojV?=
 =?us-ascii?Q?AMZONgoV7LHppxnQTp33DPFY4mJNe/CFaKEQVtvrcsLMXocQ09e2HeDFbsli?=
 =?us-ascii?Q?legjsBeCQDUv0enw23aKnGQ1JbaQOidjN1JrVY8RELiLTYVFQdHL6B0FMN5C?=
 =?us-ascii?Q?h4dzSUoHV+xBdbHGQ2brMK1N7x11hEGZkSXRHtnmOUkaOvbwTB10yMFGRwur?=
 =?us-ascii?Q?ntU7lLuNXwuvUUXS31L2sJsbhhSeKMdR43IxN0raYOM7zLliqrYodkxio3nt?=
 =?us-ascii?Q?jqpmvM8z2/m40DO0m0SfmH/KN7tbcR80mEn0uYjqSrf2HZJLk4Al7y+aFeib?=
 =?us-ascii?Q?hv4oMfSqR62BaixiZAMBUDfGpMA9QITo04R2fEIiOYnA+JlNqeVpQcHCBFab?=
 =?us-ascii?Q?l/0cJv5opisLV5ivmoiGBkyLSEucSnM3agKJCjCoCD2V+Tb5f9MblvAMFCk5?=
 =?us-ascii?Q?llcq6d6Zsfs09XdylH/24tXPVvpfSNyEaOmAIoSFcJ2EkbwqCZLmsD4VtwDO?=
 =?us-ascii?Q?ZnilW+1urhTucoAqhnV6nTRZgPovB7RWwlYCo9GTteP64ScdAwlwmIfjwkQp?=
 =?us-ascii?Q?1Db15e5z6ZyCtPwVtXNKaQuDLgZ9fqDVCQE6vE85lry76+1lrC5mNwRWQrxI?=
 =?us-ascii?Q?i/R1EdIc/+UOyo5r2279tfk6fU5d9W3E9pFRYB5slvRvO57Otkdqg8vNSVd5?=
 =?us-ascii?Q?KAn0UAgCcnIg21uUY6AE0hKoCjtHdqNLs8HX9YVXWwUUTEQtPdjZAHDLmKR4?=
 =?us-ascii?Q?tNAL1g9YnuewRA+ZywCTy8k8WOF/T6RvC88Y3l1d01dPcmbkLOi1VnTpU2LY?=
 =?us-ascii?Q?COzl0RbhmL5Ckzt92xDPvT+NxVHTKUsPAfhGBPnn/1KXSFctiQP9Irtk7J9n?=
 =?us-ascii?Q?8oDdn3y7Q5J36PkswD8ogkLyzBVE+KMBHdJh2mxXDtgAhS0BNxRtvYvu4eEM?=
 =?us-ascii?Q?sE2BcaSkP46e5n/kHot/F7Mc1r24ADvlB47wypQjaBYD6rUJ9HUIEXJ3Fi3Y?=
 =?us-ascii?Q?nTb7imFS388iq4CMOewE3zekikjoijYCaqO3Lx3jw7X9euBHYByH3r60Mbp3?=
 =?us-ascii?Q?lyMjeAqhpwKYqnS5erHs85zlfmPMazl1qDS+/qB1Zt0249eHQTSya5ny8Tpz?=
 =?us-ascii?Q?QQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <719B4EE4D826DF4DB494A5A452C82407@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda1cc3a-9b75-436a-200e-08da61dcde5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 18:57:27.7197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vjb7OarnZUVe+hxuf8stSW96gxdpc6ydK6Cm59/siZxEM3N9i0Wzh+YSCB5eOGORyf3k8Uf/o8rrqJAkfPNNcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 01:47:36PM -0700, Colin Foster wrote:
> There are a few Ocelot chips that contain the logic for this bus, but are
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>=20
> Add support for these non-memory-mapped configurations.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
