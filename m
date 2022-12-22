Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA9665446D
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 16:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLVPlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 10:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiLVPlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 10:41:05 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2070.outbound.protection.outlook.com [40.107.22.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61863BE23;
        Thu, 22 Dec 2022 07:41:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBY7r+7dcnaN8TomWEfkm/d3A1GrDsUOIngZNBBIHjyYq6PFONqCJ4iE89i0FF7Vom85zAGCItmoY1qaj0fo+kSLGVDaWqqKSbI7BB6dP/167u+KDiwjYBZ7/+3NyE/+CEeexJF3+uy5QUxj9ApAo83IwPJhSohFSTm7nnTmCj7wF14JX7ttlWY8kMFlpgVrf2RejN4KM7yCMua6mg49i/bexwBc21CSi/b5QZfhmoeiq9LZBQOS/g6HanycHX74FzSArSeajWaPpobF/GCe3IWXFD+YclmOb5o/ut2T06BZ9O+j9jYm1cjcjStBF65WEO5xmszPz4VivTP9lZFDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49H+3yrgq/xF9Q3aB733Xq780HCQBjI+zAEaIn5tUPo=;
 b=jq0rMdleHnELNZf7sboOsWft+MQ+X9u4iOu7tQxVEFU8Dbo90XftSRPxvLR7Kbzcz4BRr99oih1TGqPY1XEN1XR6DYEbGDTSk86Hs1wGSHBi+baWit7Lmr0NidbfRbe1BIzG00zj8++G+UUbSwY4tm/TbSuPFmllljTl/lctnXL/uIdzZ/j7XC82Hn/YqGWam8Nj4YxeZzkW1jwYpt/Jjw6WHioR/kRpz2J0xB4mktC6cFh8K43VitvC9Eo5QDmoQMmx8bdCQZJrzWpOxAhWWmH44z3Bot8sebEsu2v2+ZUW1pnnBtP+qbRCVvMUXW5CrtCFEPvjVtO0UFESgsWBVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49H+3yrgq/xF9Q3aB733Xq780HCQBjI+zAEaIn5tUPo=;
 b=KWjXDPm/WicgEcVFjTF7nldeJ8BNqkbuKiURLTFSgbcD9nO97KOjl62/ECg6aRaesV3VGDFdq5TcskdL8ENlT/WrpE31ikoTyzii5+lfzIJOO4sbImneyYgKpXZNPWSPDF0wnSOXl256ZoKyFNudbNa/7R6/AlOrmZNQ5zJyZ+E=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by DBBPR04MB8043.eurprd04.prod.outlook.com (2603:10a6:10:1e7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 15:41:00 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::75ca:4956:79f9:6d69]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::75ca:4956:79f9:6d69%7]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 15:41:00 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
Thread-Topic: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
Thread-Index: AQHZEXQBPotIqLiZVkqXNZXBHISHtK51Z8xAgASou7A=
Date:   Thu, 22 Dec 2022 15:41:00 +0000
Message-ID: <VI1PR04MB5807E65FA99FE10D53804445F2E89@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20221216172937.2960054-1-sean.anderson@seco.com>
 <VI1PR04MB5807014739D89583FF87D43EF2E59@VI1PR04MB5807.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB5807014739D89583FF87D43EF2E59@VI1PR04MB5807.eurprd04.prod.outlook.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5807:EE_|DBBPR04MB8043:EE_
x-ms-office365-filtering-correlation-id: 02b86093-0771-4158-a66e-08dae432ed50
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eAbbeH+HqSfeQutj9ya3G/vMtmshA59XvIRQh9jbOc1F27hW9wqylRBcsIXhLh4DQp4h3hRC0XRJOHKh1M0B+CneKxwtu+5/LWJm+IoZu3Nx67z669foGzdJwR5Hz8TmdAVLl9Hwn8YrEg4Ri14A3/u8K2dKj/PCF1xxzQxzHF6dQJTMytOPmWTCtWb0DMhuYZypjyemvghBIWFyl2U+bbHQZAouSMgCgh52yy60YFYOU+cywmt5z1YYObQwyAfLxNi9GqWhg622HyRT+fC3JyC7HI9V7KZ/63EwbobRwNVgrew7zyVGeGZO89QedIr3prfFf1daXMRSbAWYXCSiPrbiFVNE/jf7bcEk+eETFhz3tpZfhhTig0jKXyyh5k3i1iUfJKPCI/C/94XgVKxiXEb/oIeSpFpDJfq281l8BzwbVDhlW48q2MYRHSK3jKILV+cc0Vctoy2YbnS2U1P2LfWgDYebr02lcX+7YdMqp7aInh3qpXzRHreh3pfHjq3SFUIWfwpqji+IZjSLVC+2MryddlUnJriHHi/0g2ntYYR6u9vphJlRyDGW02E4SF/FR6WHKQ7pbcmTIKuDZEHnJTB6MB4dNkZD1nxnACf2ch3NhIL2HEKyT0waicYcWx0RTsxnGfEs6qtujzRcVvKtV6qiQwLbm5/zSlFf1iqf8ztfopJ3wnIbNIyQxirl/s6no63EyNsxYGKBGll0VSHhtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(8936002)(186003)(8676002)(38070700005)(55016003)(38100700002)(122000001)(5660300002)(7416002)(52536014)(64756008)(66946007)(4326008)(41300700001)(9686003)(26005)(76116006)(83380400001)(66556008)(66476007)(71200400001)(66446008)(86362001)(33656002)(2906002)(53546011)(55236004)(7696005)(478600001)(316002)(6506007)(110136005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oIbFAnND7+ezRzu3DVciswkXA2HjZQ+bNVr4fnE9UClY4PkqwPc5PmmYlBUP?=
 =?us-ascii?Q?wEw55l9JiPn+fIo48CrjPgqMzgj4sn4odFIDZ92pIMTK2fwSsx81obb4Aw1a?=
 =?us-ascii?Q?666ptXpPVO+SYn4lUxGOu+ixu5BgKvMgBEjz5sh24kQN2SgQT3TOfY27hj1I?=
 =?us-ascii?Q?pZDAipEdu3v4c0uVEjKZQagcFJlcssOd6ojVqz7YTmjeDuIpsSN1KVBiA0YK?=
 =?us-ascii?Q?fip8DU9nqd9YFi+K0LccwYp8wjipAgaX3YsZYlmO2jTVOdlvtiuXZ0wgTqvM?=
 =?us-ascii?Q?M+/76lnSEwRdl8iVAL9HJmyohLkYKgTu7HxnplcIf7OZEVDfJduG8mLTbA3m?=
 =?us-ascii?Q?xDPX7/lsVC14CchrHfMGBk69v9X/6LpBSTF+OJWXTE5HIXLoYp6OGeIMT3ev?=
 =?us-ascii?Q?P8qsmAW9Q7vQZGpQjgqDs9mBSg/UPEHTuQ1yskK6hbgpTAVF1NDqtxdZuDW2?=
 =?us-ascii?Q?tcsmdRnmf2YTWdHvmzZvZP0P7JYabEhDhzqvtvv8zuCG22Us9X/rNuIndLHD?=
 =?us-ascii?Q?5ACBAq4sxTW7dmuUEgGnReXHDmiXP1I2QkBU/zzPN1xRPB2mohLD+wWiGm9E?=
 =?us-ascii?Q?28Au4hpX2DYObCctDYhSG5dGEEXynVu+8W0mZXL0l7MraDtYVGzIuxHO19Nw?=
 =?us-ascii?Q?YhEpVGO4/YV9Bhf5RMPUqf/QgctViNAGuWFnxN1od6UbaI9C7r7nDA2jeZdI?=
 =?us-ascii?Q?r40mdWpUJ8oEatpekx8RvQqb39YzB8yfaLuZUMKNMKLIUQkmmasNcPw5B+pK?=
 =?us-ascii?Q?apblgtQfdvDPnnKZYXGlOJDw6kH3KWiyYJfP65e3XLytDWfwXm1JGhjZnrrd?=
 =?us-ascii?Q?Lj9i/bj4XIVoXcZoLHoWg3IhLwD2L8gGr0Vagjz52wwRdIK3BhqfsNAxgOmg?=
 =?us-ascii?Q?E/UnvuPTqUN/Nw93R7W0wNzQu43t+9tvRQJjP4dnvn7sTg6M6CiYVL6ohShG?=
 =?us-ascii?Q?NLMnH3/Eec/WslYMDHOwC+NTRw8b8qfmBEU2xhzlqE5Kox64DxYV0Tdl3xrJ?=
 =?us-ascii?Q?ZoDSfaUbDD2jFg5Mkwt2Edgg+gEntLC1Z3qQcXzxjJrzUJ5wjuSsSAqqqoCF?=
 =?us-ascii?Q?7b1Us6HaxcTVTwkQjVYM7Pnv4WuhnvfSVPqPOyyBZTlGiit9xN+I8NGkjQE8?=
 =?us-ascii?Q?RQlG9kAJA3gYeSRidlYABHTGmFnaPg9e+DUD7uuKLUusF6+3B+UAhTkhf6VN?=
 =?us-ascii?Q?W3glG1ONtUhDzzhFbDGng5pXKjS3cuPifNTiParfp5Hb58cOCYmwQQzdcL4q?=
 =?us-ascii?Q?OO/2+urma0LalOTrJvkdKUiKXdcuT/Yehp3R5qhBeh+5ijZa5XsTs4fPgSD4?=
 =?us-ascii?Q?ap0wyqcWxA9t5WCWcGnocUerSZGcm5BMNKHmpapdgf9y8pO/uirY6cE6WmPn?=
 =?us-ascii?Q?lNOM7OIaD1uLP5TU37QSaOxWq6xElsWtfELSJnGqN2pq94s4XQOPOEwLdI4h?=
 =?us-ascii?Q?sMnkJ3t4i9CEkFrbo5E0A0HlBO7t+BSHBOBomMFYAxnTjCX3JhPLnsVUYlet?=
 =?us-ascii?Q?ilqDtv2VMwYsZAtaLbhu+ZplMwYwx0IayCbb6p7GQ8TPKHNmhFrviX9S1UnK?=
 =?us-ascii?Q?4MA+qbG4UAD+WLOFlqXYhQRRdtE1TbeZGL7uGS/v?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b86093-0771-4158-a66e-08dae432ed50
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2022 15:41:00.6861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l+pCr340ciCMd8setf9fHB8G5TmtLd1b9eUlW9mjtZJ268vL5Lbea2ECQa5UKAK1j1ZXxOxvx+GyQaFXDEUF3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8043
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Sent: Monday, December 19, 2022 18:23
> To: Sean Anderson <sean.anderson@seco.com>; David S . Miller
> <davem@davemloft.net>; netdev@vger.kernel.org
> Cc: devicetree@vger.kernel.org; Rob Herring <robh+dt@kernel.org>;
> Christophe Leroy <christophe.leroy@csgroup.eu>; Nicholas Piggin
> <npiggin@gmail.com>; Michael Ellerman <mpe@ellerman.id.au>; linuxppc-
> dev@lists.ozlabs.org; Krzysztof Kozlowski
> <krzysztof.kozlowski+dt@linaro.org>; linux-kernel@vger.kernel.org; Sean
> Anderson <sean.anderson@seco.com>
> Subject: RE: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and
> MAC2
>=20
> > -----Original Message-----
> > From: Sean Anderson <sean.anderson@seco.com>
> > Sent: Friday, December 16, 2022 19:30
> > To: David S . Miller <davem@davemloft.net>; netdev@vger.kernel.org
> > Cc: devicetree@vger.kernel.org; Rob Herring <robh+dt@kernel.org>;
> > Christophe Leroy <christophe.leroy@csgroup.eu>; Nicholas Piggin
> > <npiggin@gmail.com>; Michael Ellerman <mpe@ellerman.id.au>; linuxppc-
> > dev@lists.ozlabs.org; Krzysztof Kozlowski
> > <krzysztof.kozlowski+dt@linaro.org>; linux-kernel@vger.kernel.org;
> Camelia
> > Alexandra Groza <camelia.groza@nxp.com>; Sean Anderson
> > <sean.anderson@seco.com>
> > Subject: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and
> > MAC2
> >
> > There aren't enough resources to run these ports at 10G speeds. Disable
> > 10G for these ports, reverting to the previous speed.
> >
> > Fixes: 36926a7d70c2 ("powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G")
> > Reported-by: Camelia Alexandra Groza <camelia.groza@nxp.com>
> > Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> > ---
>=20
> Thank you.
>=20
> Reviewed-by: Camelia Groza <camelia.groza@nxp.com>
> Tested-by: Camelia Groza <camelia.groza@nxp.com>

I see the patch marked Not Applicable in the netdev patchwork.
What tree will it go through?

> > Changes in v2:
> > - Remove the 10g properties, instead of removing the MAC dtsis.
> >
> >  arch/powerpc/boot/dts/fsl/t2081si-post.dtsi | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> > b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> > index 74e17e134387..27714dc2f04a 100644
> > --- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> > +++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> > @@ -659,3 +659,19 @@ L2_1: l2-cache-controller@c20000 {
> >  		interrupts =3D <16 2 1 9>;
> >  	};
> >  };
> > +
> > +&fman0_rx_0x08 {
> > +	/delete-property/ fsl,fman-10g-port;
> > +};
> > +
> > +&fman0_tx_0x28 {
> > +	/delete-property/ fsl,fman-10g-port;
> > +};
> > +
> > +&fman0_rx_0x09 {
> > +	/delete-property/ fsl,fman-10g-port;
> > +};
> > +
> > +&fman0_tx_0x29 {
> > +	/delete-property/ fsl,fman-10g-port;
> > +};
> > --
> > 2.35.1.1320.gc452695387.dirty

