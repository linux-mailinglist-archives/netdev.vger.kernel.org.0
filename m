Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BBC55E9D0
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiF1QeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiF1QdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:33:20 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282A732EF4;
        Tue, 28 Jun 2022 09:26:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdjwN7C6552Fyxi6Cudhf4DCKwacU4j/CgrlPsOdqrxfG186ZyyKMJwHQPmBi5+LRVL+/gjEv5OXaae33Xy2jDPJDKrLgO6HF2RdHLUHY5zCUnZtMZH3hzJsZdJTI9qsHUqlfImS5eYjaipjY+ifGwsBoZ+HnKgmcyjENWYoDVka4eIZYjuzrHiKlCBw7XomFUBHAHwtEFg4wZlNuqGmZ0hIV6ueWAO301FDsl49GvyEZAUCKAUR/RLEnET94BBMzI85Z2oapcm5TV2/f2k4RhAapA7borpvsAKazq0+XRVGfrnSbUxisf+iPDJCatFGg6hZrKE/wAkoNxL72gP9VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjsoKb4xNdz7SEsp5DrK7/0xuSh+X5ymvZ62id+fOGg=;
 b=d1vDKhgn/enHpZxtresOq8Mq85MOm1gsIEe5wdTg1tuevacg+cDsD/wN8gP6bUA3UtyKINDWeezRTewAKk0+Tal005WlIEhKu7t4QCAzaFsy6cL/W7pvPADVU5/VwXVf3mO/Z5tguLxFPonOEPUFumMamUPKyvPyiIsHn5ULk2/sqVMR1XyOEDe7YCYE5AN/LPN/Xj83P0KRS5U3Z+rsTVKZGb8qtgIVL4WjhhOrRmpNF5jPXZsYGOuHRCuhTe1P4hoDOep0IHBrpyifmwnftU2u+8hP20sOSNZDu1D8ODLwWlZNQZa+ZWQnRxzEXZU0+8P9u0hFoGmK7PxAP3t1bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjsoKb4xNdz7SEsp5DrK7/0xuSh+X5ymvZ62id+fOGg=;
 b=PRoXTkz7lDDAH4d5p0qZVMdfTIu9ofoUfw5dvcyrsOCr5yV5lZxszqRvqty5hczPTGAHsDWZ5WVQjf/BZqgPiaW+42RZ1L5kLNPqwNYlhtJjCLVdpBAXeQYyQu3X27VDbPH28OzpBH6sBnfor3wW3QqY5zuLGrtAFLtoiMe0mOA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2367.eurprd04.prod.outlook.com (2603:10a6:800:24::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 16:26:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 16:26:05 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v11 net-next 2/9] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
Thread-Topic: [PATCH v11 net-next 2/9] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
Thread-Index: AQHYiseFWqiBct4k00WOzITu2aZtrK1lAfYA
Date:   Tue, 28 Jun 2022 16:26:05 +0000
Message-ID: <20220628162604.fxhbcaimv2ioovrk@skbuf>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-3-colin.foster@in-advantage.com>
In-Reply-To: <20220628081709.829811-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69cb9347-e168-4b3a-bbdf-08da5922e651
x-ms-traffictypediagnostic: VI1PR0401MB2367:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dF3G/JbTcQa5VDWDVoR8Y/7FyEJcEmi8cBJjPYHuo7CDj2wHEyrg3dzLxPJHLhYYU7ldqMC8txGv2Y8yN5mtswaBzukrZH/9rKM0oJccCyLZ3/lvqsXa3CNZKJZEsZBsLSXbl4cQaO7GPQAcEUZIaMDI475lBUkRIAPb23PzYSoRYPPkDBcVsKVER0DTPCAEMO6VQTtaIKTJJlwGdQGypNOsNpPwokCuY+aMvkg1xf+uyVJhM30naFJ6F7OhkEWrh65CYQ9P3OqgJjTr1iZz0YS5g9jSETZ3k0aDsxLAcBBHCscSyv8N/x2I0oW62977wyH/FU+LQcUQ+RloZs0mdYEEiEmMrM6k890ACePyEaVn1fPEOZLYw53nDLaXQOLcSwYtfDDlrxTX5PY6G1XudYBvvI/UGFShDo327cF0uM5h+px+4htgEE2EtszvlJyR1NZynDRx2Fk3WDfrbpUR0TMUuyFYXU0FaQQZwgrqp47lrBmh37UWMjIsn7P6ubp0v6xHD51N2OUhO/a5iK9wjtGvXVcpJZBr7OZqT2gP77FlGsEIJ/hQkdgwE7dMSRgliTGLROIzupZS7dd+qm4XUig0CSNVFDSuBZ9pyE2JaFwW0SPGJoIbD49LijQlBlUj1YzE1vHFQlBQQCAgV2sRCZZNUBRhjeSKwMDQ7ZztqC3eI6jmZlhmrBTDrA21DGPa3oel7cF5eAm1+Iezy2CkfSb1nmpJ/l+FeOvvNvyts2gFhsbh8GOmm0KbkU7TtoaWIGaJ+LY2iBES3vFOrvfcPNCfYwW5JK+ASJ0tYgURmQw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(41300700001)(6512007)(6506007)(66946007)(8676002)(26005)(83380400001)(478600001)(66556008)(86362001)(76116006)(66476007)(38070700005)(316002)(54906003)(38100700002)(64756008)(66446008)(4326008)(71200400001)(2906002)(33716001)(6916009)(1076003)(44832011)(7416002)(186003)(6486002)(4744005)(9686003)(122000001)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PXcbKzKBL72uAqOjIIjpY+U9NsR4+xgZz/xLYHTF91S+ryU3SBOSPfT2edmf?=
 =?us-ascii?Q?xTPX7mAq7WYoTYn+/s1XIurYProf87Gl1iEuMzO9qGV4unV5jNHutQ5DmPMf?=
 =?us-ascii?Q?KOJiZzYw7Q6aMuE6gkyNvAxXvGDQ8PSS43NCHuJBWL0+OZZ4xrhWUlOecZQB?=
 =?us-ascii?Q?Zsn6x7Jq1XnZXh5LjRhLt/LFS2C/SBpDTF/fYClZ00vqLBJZXWypu9y5G014?=
 =?us-ascii?Q?GiOb0aBAWkbsk+/MbhbnloWAwnJKvuQ0SgjFj2/PGBBkWBczScwcqxCimF70?=
 =?us-ascii?Q?K1tiYQNel7Q82Sc/v9/BTDANFUnut3r2UUKGDRBl6IfUOOBVHYiN2qWvJBDu?=
 =?us-ascii?Q?68vXVT6nYx+PI3kBp/dUBo94u269XFLANMdJ1hfEcVwTTHr99ys68zy4rCt6?=
 =?us-ascii?Q?BDpi/zRkyNEsHI9cFXcRWX8IySlIi+BEn0xRnVGcbGYzRi6wdU+DSDEI7x2I?=
 =?us-ascii?Q?LzORFCZuS0Mnwh9mE3U3oHFG5OrYlrxgT3lxYtY2PXHA06SAObFUulJOA+0G?=
 =?us-ascii?Q?k5wrHPAeIqKMaNosGlT5QwZfij9mBC7nIbUwWHpKmOo6jYO6UWyhB/BL6uLJ?=
 =?us-ascii?Q?nWs/22UrEffNFMiineq8WXscNj9HbFsYHXQuuxXRzKRHGfL2iH3EO110bxY4?=
 =?us-ascii?Q?ck2rpCdfYbADp8binFWTFIcpm6xjvPt0z4w9OOxMIxXYTLlaual7hKPJtznz?=
 =?us-ascii?Q?k+FDd9eHvvuLsZPc+7e1pcqfNqIn2Kmb40lPKuRoB0y9CkTF/u/ixj2Ni3cP?=
 =?us-ascii?Q?BksF+DPoUfz/pI4m8mt+WNZAmwE/H/VZN4t/EoCfs0VHpe/T4K0Bsjb+x0yG?=
 =?us-ascii?Q?+X75ZvdKO0AtGdd3HRltjYjUpdWXk2Kwsb9HPZcm4nzjET6qIQgckiGrXwOX?=
 =?us-ascii?Q?xhCJL56ekRURRb24GQFQV9GEAB9cc4Q6hXDWys1/FBGMxpDdAIvgqNwqhGem?=
 =?us-ascii?Q?7HKsAVkfToZ+hf9XUowtHxBP4wDCORNI3ktyoKIZvs5uPjh/XNHOVkO0WCet?=
 =?us-ascii?Q?jJe9IXTWlEH1Qxnj7h2DnZZS1zp9u9oxtkwK/usvkT/0uFD7eHdRkjP9eLnn?=
 =?us-ascii?Q?fc34UecWps6IaDy8Idvx3OetkpIIY87exXx/3S034Wm2zgl1QJ7PIPKxik3J?=
 =?us-ascii?Q?YxFGjQ+Py9neBLS6ftVH1rx2XJctuYOEp5rY40AFSN6H2OK5SKgkOwKzqH+X?=
 =?us-ascii?Q?KvM2xy65uypzny5Pd1pk+M297znhUKqj/XyN4zWQb8es31/IU+gAcdl7bi88?=
 =?us-ascii?Q?6BY62vaB9bU8k1WAwB5ZJa2DftbdbK/zGay7Oh+wB+lVuTe+knOZzzraurNC?=
 =?us-ascii?Q?f5qEE+zeA7g3/VVMJYZWQYy6P57M9kKXFSmMLCqoBDA5p+z6niHgPUtBS3T6?=
 =?us-ascii?Q?A8gGZujGp1fe+vozUYETZtMehsdEUeUQ2acULBH3k9QBFasrjUpQ4mqRsuel?=
 =?us-ascii?Q?Ihnu0+PXI1sznKF0VJkqlvyLqc2IC1hcrIqa8kBBH2pJgAaIB5mhaPxmTIVe?=
 =?us-ascii?Q?B/pmwzg27sQmDIBkFUkkdChDtFL1HyF2+s2MxCQ/iAa+VFKEiEtQ9kJONUB3?=
 =?us-ascii?Q?Kjm8b+MNItJS+XnjEq8W5CXxmYcBXSqBbI40d8qzaUONiQTcAOrS3ed+fZaG?=
 =?us-ascii?Q?DA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DEA2719DD20A2B47B79AC3DFE36E58F1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69cb9347-e168-4b3a-bbdf-08da5922e651
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 16:26:05.4066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W1H54u0klSJghA+k5ITglc5heLoR9c1aPtEZT5xlJU841Stngl287/ugwUB9cX05DEsSqhO3n8tNFagkZsrZkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2367
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 01:17:02AM -0700, Colin Foster wrote:
> There are a few Ocelot chips that contain the logic for this bus, but are
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>=20
> Add support for these non-memory-mapped configurations.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

These "add ability to be used in a non-MMIO configuration" commit
messages are very confusing when you are only adding support for
non-MMIO in ocelot_platform_init_regmap_from_resource() in patch 9/9.
May I suggest a reorder?=
