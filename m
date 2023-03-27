Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D766C9D03
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbjC0H70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbjC0H7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:59:21 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2078.outbound.protection.outlook.com [40.107.247.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0A3422A;
        Mon, 27 Mar 2023 00:59:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsGbq0vRqK4/A6AEPH+k0SZvCc+y539EyOWlqCR0za8y1aui0rjIy/9i1KdyvTi52y4/EqgKLiSfWyvv+eLHhkBf/qL3O1Uwlw7m/j3g9uho/z437XV699r5XRbjMhgH4vatlTot6Cw5x3VULbO1NTZUChw6KzCyek8zzx0YZRRSJDqUSNlut2oIlBdcHHR7TIR3KH9Kq3ncoQxkFC+mxNPimTynRDrQgvjaKW50DlMj4+4kJo2auiQ2ZQNsdISwlup1p9hxDdVjOkj+grr8gdNoz1K9Bd8d3WeluB6QKYKM/ZGm+CQfaGPVeAXKGmsKq5hKbG9T59Zi8nXpX8HRDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPB+P7HQtKmtf260nk2S9Ch2ZsHgLRGsMUHEun8wVCs=;
 b=S/yKb7Cuqs0y5p6c9h1jCOVFsTKwIRYnpt3zXq6oOg6gQ1FY903FEFPl5rjSIY4PWU1zuOGUYwdgJeCAJNszQ+rShUrsvXmLEjcIQNbZxCDGtaggVuS+JDxm915ywZAeQvu82+GO2H9dn5ezZtgd6M2pVQ2pKHJDmDevTvC/yHyLb/ru2avYH9oCqv8UkmV+pLOqX3I03GSbKO8B7FvRz+d3xgynrQdQgtR+ZA7bnJqOXYwhPluMdj9FWB/25KjQERZMYjhtCENYUzn4M6opcljfzNzAgTdyGfgE0XrurZmyrxkdEpg1XufO/U6K/Wi9Go43yO2xZiS8b1uSptOzFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPB+P7HQtKmtf260nk2S9Ch2ZsHgLRGsMUHEun8wVCs=;
 b=mDCxj3NDM0ojp66k3irlxVrp83ynRhscv/PxQJQdzYj5fzyoTGEOwjTV5uMXA0tTkz8lXVMCn3XANZWko+lqGisBcxVBRVqJwLrXqI4YV2BOm6SFLRxJWSK/71FzJIS3k4C21QrklyN5+8Wq8Gxc6QTIAQWr3mIxspznS9yLhG0=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by GVXPR04MB9974.eurprd04.prod.outlook.com (2603:10a6:150:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 07:59:15 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::806:4eb3:88bd:1690]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::806:4eb3:88bd:1690%7]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 07:59:15 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: fman: Add myself as a reviewer
Thread-Topic: [PATCH] net: fman: Add myself as a reviewer
Thread-Index: AQHZXZgyACHcbx6CnkqQ3J1c2utP+68KwoKAgAOGGXA=
Date:   Mon, 27 Mar 2023 07:59:15 +0000
Message-ID: <AM6PR04MB39763EF394F6994E28E207ABEC8B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20230323145957.2999211-1-sean.anderson@seco.com>
 <20230324190937.17f83c4d@kernel.org>
In-Reply-To: <20230324190937.17f83c4d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB3976:EE_|GVXPR04MB9974:EE_
x-ms-office365-filtering-correlation-id: 8a358df7-a71f-4787-5f96-08db2e9928b6
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1j90pL/tuHilFiaDleu5DzsClLn1E0h18feujUe93Ec/gwGzlJ3EkkBQx8OepC6s/8BAy1D7tmwwT8UWCXuB+7D1WQYZFvm+BS9meEVraQC19C24w0YDR/cwaxWIz/2+Qh2THhv+f9w6xTES/lfSGzBUQVT0fL9Qkvk3f8fpZs0gTsY7b0q97KWdY8zsqAxMThaLr1Fy7mtz1f75MRDhb21KzrATuMjuXSLAaCgZ+EL8F1b4sSt2E1fIJnz6LCjR0sc1jD+An26Xi7yMujbiVTqyJrBCdiJt7dX/OalfD+c5aobgwcEIGENe/QcxWHPNqdcpt51/fpEk6UUqZjgTTeVHu4K5LimJl95Xl2WsLy8xpyncu7k65d/LMhWYiY1r2rtvRCtzQfQrS7lizux8xxSsbEdc9BXsWSwiMF5UFn5wJscnvP9+RetnD5b7AH2z6tYxUGlAF5+02RGLSfpBUHjhHaM/5gsPTokFRti92IgX1W2UWe81ZvWaDJcF7QhB5qh5wPNpi+6dF3RaNBh1oxD1VQyDSADqakRJklIGdm0wdCO5BsYMLw+EKgEFcq02z2aThP0P2Jt6LxRIUuwBprlc7i314ZrOIL7JL9JDqHOaSzCv1zYFEJzFcKUCab15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(316002)(54906003)(478600001)(52536014)(5660300002)(122000001)(8936002)(38070700005)(86362001)(33656002)(44832011)(38100700002)(4744005)(2906002)(4326008)(66556008)(66476007)(66446008)(64756008)(6916009)(8676002)(76116006)(66946007)(41300700001)(186003)(55016003)(9686003)(6506007)(26005)(53546011)(83380400001)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UZEjbFkA9zdCGTdo/F7CR2XtUwv/+qRw20dD0pPeD3C/XjQgp16n3I2CltT0?=
 =?us-ascii?Q?PVXU8awwNFlxrXMj7RS8DPzhlWUXwt4Y5B1bvVtUoWW0y2sSCmSiaQgtq3N0?=
 =?us-ascii?Q?YHoTc2aoPLodvGwhPeyLnK+Q3oOdmCSbGWpj1YqBpZzs3d6XNF9NBvdXuoOc?=
 =?us-ascii?Q?MDGkcPv+X0ah0/ysaVI1J3OBOwndPufNZlTTLyfV61jffjhdscVa4MHGEPrD?=
 =?us-ascii?Q?WS4mYucguCfgDPS9uEyxcoPbWZx4M9tqiOUu+H9GthWmexpys8Ro31vS4rYm?=
 =?us-ascii?Q?DEeHBexVju5QYYKzX6HL9c6xWOunPUuBWs5fQ98aT/7jj+I9+1UxqjXFyaOV?=
 =?us-ascii?Q?IJ2DRVtmvKPD6RIVioconFjnjwzOkTXihQhE/pszigOzEpKOedtqc0yobLmh?=
 =?us-ascii?Q?jTWpvhQr2h96TXsj4jg9LL/U9Sw1Ec0GutYr80D6WZwEmMjIMAvFAutsGM/S?=
 =?us-ascii?Q?leBVKkLiZYc6AaC1EWLuH2hZTbeWzJrb3EB9k2aPh+z5OcX001Q3cGz6E+Qi?=
 =?us-ascii?Q?WnONxvVZWVMU/2g0T9MPp756gwnXiL/MSW08YU5H1m70sjf+C+f+EQ4E19yE?=
 =?us-ascii?Q?1YpR3kUUkmD8sKA0OX7xqSTXYhpVzRLlz6XXA/ZC3mJ054rzchdDT7FEdKeN?=
 =?us-ascii?Q?Q36HAvyunZ50q9TCZ7CTDV0OBoiKDxzPfpLZ9Q2GNM2vSRvt+3JRMSy0hm/V?=
 =?us-ascii?Q?vrYe8IXcDBFz33V0/xx5twREorL6pMg/RF3kmqGxkHocXh3TkI1fe8y0xari?=
 =?us-ascii?Q?9O1zhs+RnPNzICaAo+pFMTKUmsPcMhJp1gsu4AImDCh68rrLkeslJdtDlqwt?=
 =?us-ascii?Q?nG0Uqs/KtLP/Q/w8B17U46nHKPIqyMSeliHP5i8rW4QzTeGkgjzs6gYfpco9?=
 =?us-ascii?Q?86DdFhi15g99MDX+M1k56QlHNaEsWBOuSoY/9TLoKxB33TCygw/nKSCqBt17?=
 =?us-ascii?Q?KfGMeT+Zd4uvnbEIl9p/lVzLqEKFOzveC2bHv33hVL0feE+Hi5iGsM2lMEiy?=
 =?us-ascii?Q?LT3HaB9SqIMVnm6lt4HwAfYA5JKihTgaCEVB/l3DZHMAfGSJeWmSDzPeGa10?=
 =?us-ascii?Q?Db52sYg24yN+6hIedvYGu2OZ4BW2DrJJfzRd1evaqC1EMCbp9Oqlc5QhCgqz?=
 =?us-ascii?Q?tvQ0AErthxmtGT4C3huoq8zzrDuNmLPVD9SQRr3Fi9kJakj9qUkfzN4C927r?=
 =?us-ascii?Q?X2D+6Yvr9g3nh1KA1LejTVnjB3t7Kt3oxEI2OY1w/LbVLIgu8jHwg+wqikzH?=
 =?us-ascii?Q?nuR/X3Y1eGPZXKyRK98dwsu1uMFTGnOc+QneT96iAt1+2Ue+BvsISE+2FUuI?=
 =?us-ascii?Q?+88rxG9s1npo0HNmjiD5r1CI+tZE7JuRtJH46hht/jzt4maq53btoK+JJzeD?=
 =?us-ascii?Q?lTDpYmo9MBHxPSjSEXw90i3um3FBCHam2c39+qBbNk8bwPpJlH+TdW2l7TJp?=
 =?us-ascii?Q?wRdcondIBbI4II0bTvUkYiK+o7qyjYGirNO6Ja0n1IyUv26aMAfQ4ZDDO2UH?=
 =?us-ascii?Q?1t//MKgSBhHh7kPfn3ew9JMU9qpOExvQVa0wONAC+u7S7OZD6y00CqCcdKIf?=
 =?us-ascii?Q?2TO56+s2ZJrXnlwepnh5rM3xivfcFcvLOmmm7c5t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a358df7-a71f-4787-5f96-08db2e9928b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2023 07:59:15.0548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BywKWc/uXSQz5djW230QjLmeIAJ1Fe8L1oXIPmmwGpuXEB5Yjdl5nK9WJfVq2f4DlEAFdisxO3DGCaDPXOtUfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9974
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: 25 March 2023 04:10
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: Sean Anderson <sean.anderson@seco.com>; David S . Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Paolo Abeni
> <pabeni@redhat.com>; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] net: fman: Add myself as a reviewer
>=20
> On Thu, 23 Mar 2023 10:59:57 -0400 Sean Anderson wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 9faef5784c03..c304714aff32 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8216,6 +8216,7 @@ F:	drivers/net/ethernet/freescale/dpaa
> >
> >  FREESCALE QORIQ DPAA FMAN DRIVER
> >  M:	Madalin Bucur <madalin.bucur@nxp.com>
> > +R:	Sean Anderson <sean.anderson@seco.com>
> >  L:	netdev@vger.kernel.org
> >  S:	Maintained
> >  F:	Documentation/devicetree/bindings/net/fsl-fman.txt
>=20
> Madalin? Ack? Should we read into your silence?

Ack & thanks!

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
