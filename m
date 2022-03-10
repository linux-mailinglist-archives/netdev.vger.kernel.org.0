Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7326E4D5096
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245191AbiCJReK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245382AbiCJRda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:33:30 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20065.outbound.protection.outlook.com [40.107.2.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208F217A91;
        Thu, 10 Mar 2022 09:32:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxRdYFRTIOUKyBzLX4R6LrM/9IJJwB52plF+U+WhHoVvRPlc1O0p0vgx4kcBGhhcFEpnk07DagsYRJCOB6RL51QkMTHbMEaR3K9wZuoEHykAwedy4bqsPOOkKw21AyQZ+FQ8p7mhNix4CrjxlQtvMPZKROt7u1SSOe6Wa+SJIaTLEpLiNiKcTFe8YyDxtlkaKXxr7F+BdIWRlngz9LLzvE3lYgaTFZ7eMv2d2NpNz5Rbnx/J57ISqyCvA6UGBosFIVu/zG5BquBNIdr4oS38/13hBnXfWtNfty2s69vQKm9ucXx7f1lEvlHWAjD1Hx83PfoCWUgYCOBiwGa/ITR6zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZprOkzcm5d+pDYNUxv/MrJi/jmZnt01JElGt55q8oE=;
 b=M17IoKlAlswfFOg984zMBMzjKwdST+dxIZjlTDqaIlLoWzm0fQ2S1Rv3zv4/NGw95/YXQ7E9/4ywLI8qHfBlHYAWjDuC8mfWDcwD+o28rSoiUM/9zmcFtXVsF945qcn5Efpz9Bu35ejsSNBjPyjgmQBF1O+oLBvYs0OB+JI+0EReFrd/QXu0XsUayBCk5gXuYhGze89ynTIMj1dbbForTdDAXjlsFzibUWEarnt1jT2WC+At9X0aFhomfZ4bUas8ErdMvE+GB0ps8CKpf3UYr9L2xSTBT27Zn4N+ocYpyqARbfAJKs0SwNH88omS8wyEBVTKK0VyF0U090C27N4Lng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZprOkzcm5d+pDYNUxv/MrJi/jmZnt01JElGt55q8oE=;
 b=Nzy/9SrK6rBw7zwNk7k3DDI6sH33L835M4SkRjYQOvtrjJ26ma9oWGk/yAB7gl8bT+Lj7m6a2OjjXxvsMJalGLDDnCWrLk7LrHXL4VSAP0GNpsBFhvnuIBy0CnGkbHEVT1BF3m8PMg1qhXy5skiVbOmbwX8Ms8q/NAHWyT1KBY4=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DU2PR04MB8951.eurprd04.prod.outlook.com (2603:10a6:10:2e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 10 Mar
 2022 17:32:25 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 17:32:24 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Hongxing Zhu <hongxing.zhu@nxp.com>
Subject: Re: [PATCH net-next v3 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
 compatible
Thread-Topic: [PATCH net-next v3 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
 compatible
Thread-Index: AQHYNI5zaHxB4i/pbUitMandv5pwdqy40/SAgAAMiYA=
Date:   Thu, 10 Mar 2022 17:32:24 +0000
Message-ID: <20220310173223.pl2asv55iqfmbasq@skbuf>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
 <20220310145200.3645763-3-ioana.ciornei@nxp.com>
 <a32fa8df-bd07-8040-41cd-92484420756d@canonical.com>
In-Reply-To: <a32fa8df-bd07-8040-41cd-92484420756d@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c027f5b1-4f8a-46af-1317-08da02bbf076
x-ms-traffictypediagnostic: DU2PR04MB8951:EE_
x-microsoft-antispam-prvs: <DU2PR04MB8951840F41ADD60FB5236389E00B9@DU2PR04MB8951.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Iz5Z6PpPmERbdRpw3b8kx3y9VvxrYSsOZjYzI35LAntClaOmA7b7+e5pWuyggc6ZsSP/S16m5xxXOcXMJxvU3sftL49VVSCdI2Z225nNgUWT5X9jGksl7M2JZ2JTsZ7tIUup24leh/HKDWkiz1EDqIeeXrQFxNRpK5vJtOeULp5p8ponhK2K4DVtjWNkCU6NqRkBHIIEKUZ5qmYnGSJMlv093VPs4NpSGUS4CfDown8PQhk3E0CPx9hkCHVb6fu4Ry21jkTpcOY8TdKUx3gd58I0lEYTzXUt8xohYJVKj3/+F/iDHoO+/sI2ELZevRicLO3f8ImE5MCXGenzONziEewV71+3Pyi+AE7kCNOFPoAWHA5ymWCBn892A8Cu5FMRyK780ygaoZbYDxqIAl6E7XkksQav4++ZKS868svacoFgFcBcqiATygcu3Fm4ugA19LnCFmqHBRb2YIDZWDe3xXmmnokWyNGTacoJYc3S1NKHnTThhjREOGIlArjT4MWSFsN5N4s71Zu36Gq798y7ZQSWiX68NgoEcGKZS3zQ3wsXb5Ra0Ky7PhO66i1oBP1TM5Tcuxl7iqjB3o1EElIx+omu3MmpPSBLG3ZmHqrtQIoh/4HmkZ42R40us9K3NImfZ4BLoK1l9O4Ul5v5Phe3qQv/b9WErfpu76kP2P/c5MC1FeLI98mAQFEShkUpMiJwmKBbwwubwnddpyL2wMNDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(7416002)(38070700005)(8936002)(44832011)(5660300002)(6486002)(91956017)(6916009)(86362001)(508600001)(83380400001)(2906002)(71200400001)(6512007)(76116006)(122000001)(64756008)(38100700002)(66446008)(66556008)(1076003)(66476007)(8676002)(186003)(26005)(4326008)(6506007)(33716001)(9686003)(53546011)(316002)(54906003)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZRaZoLFf49zFcnmeT38XHmtUx1jRoaT9ma0KLUST2vT0L/VlCgN5abGQWTV1?=
 =?us-ascii?Q?GcDZR/6sKcAro1WBJzTXbFioqAo3p6mCnD+MxYtpbcVRd/ZWuYYSEPjDRvaI?=
 =?us-ascii?Q?fBtyioMZIKcO5Xnj8oqR9KXQ4Ye8v+2JqY9yLF6dtvej9DaPUIGDGm3TNKTf?=
 =?us-ascii?Q?xNdcVRqmfd6/5nkfz9sXJ9mPdPU9iotuziWmXIQj7ks3imJfefnhvyFzD5Ul?=
 =?us-ascii?Q?3p0E1lEtjR2cojxMGpT1+Qh3gAKVl4AX8wviu8scyTurBCu3n+yTRgFWK5UN?=
 =?us-ascii?Q?TAQswbOEOPzvCKlIxq4EUqJqCqw/YgWGVaO1xZDEw8DfszoHRGkKWfFscZIF?=
 =?us-ascii?Q?Vcgn8/P9a9sXorvjuzSEAt/AmQAq9Xwh3tAUtfsNK1izewfc8N/FT94Su8RH?=
 =?us-ascii?Q?eWx6JCxLoTaNVP1yuZieswfkMgh9CYUntfVHNfw+y56gHCqOmetZ16xytcRu?=
 =?us-ascii?Q?49Js055oaV2QJkjCAGUGeznJAFmeJJQY9nH/gtFajbc4X/5JuLr1Ngg0L4EC?=
 =?us-ascii?Q?GrdsW1Wu6SZZZsqbELIalyeZqxyaO2XrXvdg/IFCByKtzMZrvm9XhHctiZpC?=
 =?us-ascii?Q?ekI0wrsS+kZJtECm2L9ot81ES81SYbAEEikEP9hrh55r/eMbIOdMDl2sxLOi?=
 =?us-ascii?Q?glizKpu7yXN1wapbwYgOjQVQAUIc11qgj+2LNGKlJY/FPyN7GLzzsjDOARJQ?=
 =?us-ascii?Q?9S2Hy9TtHu1ItPvkYlb+xMQztBuzPMPzb2LtKk1YlcYtYv3Za5wCZruIIwLC?=
 =?us-ascii?Q?qYFRXkfVfZbj6x0zoLi1TD0bnC9LJjXUwadMs+MPdYSTe+YIqZGt1JR+Ba3n?=
 =?us-ascii?Q?NofxPUhmCKAgxw8eifLUvX0ESmi4ikCIlSDURiK3SwMaUn8IVOVjUj+1obuT?=
 =?us-ascii?Q?lsutzF+WFHozWvddM3ipNIRKSFC4gjX6z6w4Q76As2d3KvkNQeNzP74U90wG?=
 =?us-ascii?Q?170ieY9U8YUwf6FBcUe3oGf7LSTDcyCvK+BXuBAaRVD8PtVa0s6Ls6OblyRT?=
 =?us-ascii?Q?9HsADEvIFEnjtNNRS56ocKOJiItsKlvhgbVxtd8szJtIgKOg+C3oxZEZIpLR?=
 =?us-ascii?Q?IbVJK0O2Ic2C5TXPE58D5OKIsJDTba2ki33DcoISCVEm6ozDdlytiZ2LYjxr?=
 =?us-ascii?Q?BEsuOmn66LNe7fSGaDi07dChgULu0epR0xJpL+OsQM9GwC5lIjn6IgXCsSZR?=
 =?us-ascii?Q?QpB30VFZs5mooYoP2XEMakEMNTnUl3aTQi6NHZ7SLLTSFLK6bpMRZwDf6+Ha?=
 =?us-ascii?Q?yNWqLkC8okotZ0eBSc3KQhAg10IqMMsA9a1fXmRrQG41D/edYwWiuWjhyG95?=
 =?us-ascii?Q?cpofhkABOmJU54tZCdk7pColrncUP6tCEJEYhK9uhZSTlrnDbQooNwfVjVCx?=
 =?us-ascii?Q?Hg2McxowvzQeTlKltE6Rq7MnhRPd08L2gfY8m1ElGOr6W9JwLMW3MA5onK7F?=
 =?us-ascii?Q?eQL5kRWq+RFsHD5hwqSDpoHN22/nenZap3lqblOzL2kX4XPTAkD2Qdn6CQEw?=
 =?us-ascii?Q?8URJJRCRyC+eKh7c1dXL71EWS9EJhIHS+O0k623ccPASxb/bPVqqc7Ez0iE+?=
 =?us-ascii?Q?9FqnCr/56dSH8Tu9GGlZ8EtPEe7espUFldha5pcDofcSm7cL/qfSs9K6Ll/N?=
 =?us-ascii?Q?He2JB1ISeL9rrLQYRqERrTw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <127FD7552CA0AA489F953AB95AD365B0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c027f5b1-4f8a-46af-1317-08da02bbf076
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 17:32:24.1975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mywe32/82HnnHjL6QPY7KusU6m4fW+eFfRowBa9P5FuP0USImbZctPoSTrg9TYqNae40OpoiW6E+5NVGQ/ctcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8951
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 05:47:31PM +0100, Krzysztof Kozlowski wrote:
> On 10/03/2022 15:51, Ioana Ciornei wrote:
> > Describe the "fsl,lynx-28g" compatible used by the Lynx 28G SerDes PHY
> > driver on Layerscape based SoCs.
>=20
> The message is a bit misleading, because it suggests you add only
> compatible to existing bindings. Instead please look at the git log how
> people usually describe it in subject and message.

Sure, I can change the title and commit message.

> > +patternProperties:
> > +  '^phy@[0-9a-f]$':
> > +    type: object
> > +    properties:
> > +      reg:
> > +        description:
> > +          Number of the SerDes lane.
> > +        minimum: 0
> > +        maximum: 7
> > +
> > +      "#phy-cells":
> > +        const: 0
>=20
> Why do you need all these children? You just enumerated them, without
> statuses, resources or any properties. This should be rather just index
> of lynx-28g phy.

I am just describing each lane of the SerDes block so that each ethernet
dts node references it directly.

Since I am new to the generic PHY infrastructure I was using the COMPHY
for the Marvell MVEBU SoCs (phy-mvebu-comphy.txt) as a loose example.
Each lane there is described as a different child node as well. The only
difference from the COMPHY is that Lynx 28G does not need #phy-cells =3D
<1> to reference the input port, we just use '#phy-cells =3D <0>' on each
lane.

What is wrong with this approach? Or better, is there an easier way to
do this?

>=20
> > +
> > +    additionalProperties: false
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +      serdes_1: serdes_phy@1ea0000 {
>=20
> node name just "phy"

Sure.

Ioana=
