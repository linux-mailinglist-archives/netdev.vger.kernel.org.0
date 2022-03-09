Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BEE4D3553
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbiCIQps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbiCIQnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:43:49 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60067.outbound.protection.outlook.com [40.107.6.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253082676;
        Wed,  9 Mar 2022 08:38:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJpZgyYwrhTdrNn+XfQ5nTdpcEGO917jXMYLItzvGQAPRsnu+KUuxmsr2c1CX8zH0UCkvPsNxqAyi6mLpD25B0R/0lFQN7Xgg5khexxvwz7EqziwqzFHsgX2eeKHQg8cc8JAZhfitXdHyJtKa2OuY99Q4g2NHeHY8GhxI3vQkPquFpEr7vn3GYfF4Ud4ON/Cc78DGKH5AVX6NFfwlsyD0A4vxEBNyugr+1o7Rhsf8C9QMQCNfdw96NwHEHvwKM9MJYR1w1V+75cdGsIru2dMoL4KUSS0XiH1lv5n+31/AJzKjYhbJPG12LqBtLQq0HqcHmimApn0/xRgI/mRV0alLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubcFvqjSO9LOnq25sHAW8Dwa5SqCZVIBR7Wt8LAvzaw=;
 b=Opn9GkLnugK+jIqfLHkShiIYat09SJjOpR0ABv3fS0oIyp8DvX0A3tZ2je3BtyQ2W2OqtogCkMuWkNuiCatmq91SAOSl1BSuDKWUUS0JMwuNXkO6IUxu7jf6ln9J+hl0lW8t07tMiNLUrIW9GMTiKwnj3iI7VzDimEPh3bcmQS+5+6MgNnMgAhy+VZwNUjqsftTdbJP5Ucme+NUfVgYPf1no4uepH8Rb9aP2JOIsKf/Tb0TAHkz0B2q+fhUlmwr+WJbeeitF+s4YqyxHuvBbFpg8hIGt+nQJZHnGUJviYN2VpPCIWOAVTt/TBX+j9T9HN3JoPUhE4w147UUCUjCQLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubcFvqjSO9LOnq25sHAW8Dwa5SqCZVIBR7Wt8LAvzaw=;
 b=rnmAVFl6RqpOQXouyYTRgpSRr5MRmArb16fw6XGelkKt5gMj/3Sl+Xlb/l85SpzYxK2gEp2s4bk29+60yyGxE0BNcMZXBwdZ/i/+rqC0FVPzHQ6lWJv28s77WgLaN786nq5V1erii1jgr4jE9fQwIMj23LASPMuPlqKOmwPtLhY=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM5PR04MB3124.eurprd04.prod.outlook.com (2603:10a6:206:c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 16:38:10 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 16:38:10 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 0/8] dpaa2-mac: add support for changing the
 protocol at runtime
Thread-Topic: [PATCH net-next 0/8] dpaa2-mac: add support for changing the
 protocol at runtime
Thread-Index: AQHYM8NQPgkHy0kr6U+q/h+MUbTmgKy3QJeA
Date:   Wed, 9 Mar 2022 16:38:10 +0000
Message-ID: <20220309163809.5hzapz7s2b44iw2l@skbuf>
References: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7606b862-2700-4df9-94f0-08da01eb3275
x-ms-traffictypediagnostic: AM5PR04MB3124:EE_
x-microsoft-antispam-prvs: <AM5PR04MB3124EC21CC278AD1D04801F3E00A9@AM5PR04MB3124.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sQvYSmdPFtthUVLb54g4hAbuhN9xWK0zJ++Ml7zii1WCMPWnU/BRXgBqMOLKqkAQ/FUVCfi9SvfWgWT7NUUKTU38jmDR9OYoSLqqYyXO1ECIjo1ZarvlnpHDARu6Hb1/frK/UTXBVFLJPwAcbF2iNOut6oDKIs1SvKSHIjjjU9axSW4xVt9skFMqv0jLPGa5P35/KoAbFjLzgEw370f7TB0M0zeR732tEz4+1m8u043YvgVwIVUfQR4btS26QyD5xSnQaAvVB24nsYTLK2YuDI/h6tKP6bfl4H8nhPIcsv6+bW2Ddq43iGASkE7F9eFQK7zJrbkGWDqrO+2319fnL9+kmFv2GyYx1Yjuh2t8icLtzOg6++KZeady6sT5G6kIPEIrwDoaOt7Z2EmtSGwBckKRNMy2UQp91OJhetye9DQPCPw5fnuOsh+pnF2zx8gTJBBd6fyiC97xa60rkx3b7NOx/Xpi2ABpfEfXA6yK5u/0gSLGv84r0CSq+5o0DJn9prXz+nEUR9oRbK7yJCqzZAgCS1R8/XlZAXnokG3EvYbR0gOFQdJ5WQZHF3kLLqLwklRvGRd01ItZ0s09lCBwPLJwPmhxHA9YnV/vXOCxFslNT0bEE09nJKtQygq0TaXCiwr2h3nBsJZNlMLuUcGRkac2vBxGCBut4hUntuFvDqh+afXgdUZBw47wnpgq46qTZNvO4SdgbWfJvwNLR27mJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66446008)(44832011)(71200400001)(66556008)(64756008)(66476007)(66946007)(6506007)(8936002)(9686003)(6512007)(316002)(33716001)(4326008)(5660300002)(86362001)(54906003)(91956017)(6486002)(110136005)(8676002)(2906002)(38070700005)(76116006)(122000001)(186003)(83380400001)(26005)(508600001)(38100700002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FWbgRQw/eMM1p3Jqj+HpLO6aWNsYKg93u5N3qZd21FtLnPWwg36fSV3wD14k?=
 =?us-ascii?Q?6tG+9p1Z2rtqgicchcLBgfAX1Y+ZsUA6MOMtinWeiH4mYrBa4HR6kxhOK5ED?=
 =?us-ascii?Q?9wqx0QvHKSNTlVXWssq244MuyuX/WG65HT1dPHIVImEeQ9BMHYZXKn1tEFBR?=
 =?us-ascii?Q?CANySIV7XEHo/snws6N+6NXfsWDs6ccggoPoFAz9L0tomfAkvw+jBsnLWThQ?=
 =?us-ascii?Q?DdLLiBa/Nxs1LC+upFnYWwwF9R9FVlxECSwWboq6ADG9KDCjAxFYAyOeZTwc?=
 =?us-ascii?Q?13h+Sx3v1GrQorAbhHuI5NN5291WPgN46Pwv/Qad0MxCyJSlV205onTxRDa4?=
 =?us-ascii?Q?c3hU54IBtl2NS0dS9d29iuae4rQb8UW8Mb7sf8VmsD6SFbu2CKnordrmNtLX?=
 =?us-ascii?Q?ZsSX4D+R2HtcLN1GeFiwqgJdrCeWX6Hzlwx8VEpTYFQnG7WddeXYm02xguz8?=
 =?us-ascii?Q?UOwhJr1aMkcY/SbRVS0tMRcAHlFQm1fONHCyQCDakWVL7GPYLgOJnnFBFA3k?=
 =?us-ascii?Q?LDHNpBVmxtxygAx/v9+/GG608Vs40n0ZIV/3CnQi5m4+qUY53Rn96uqaMjpO?=
 =?us-ascii?Q?/RGUmk7T1JjE/xf51Tx/3ptoQLpls5srV67QhGolo5vqJKTatfdzjaDdQ3nz?=
 =?us-ascii?Q?JawXKcALu0hgtApaeAyBksFlTdfjBRP4UpqPjmWUbjzXWzBN4nnGoz+nsV+W?=
 =?us-ascii?Q?HcejxQhmNz4SZHgPs+ODsRBLcZXvCVuFdScn7obEceF440OVtKzZHWmCA3Y8?=
 =?us-ascii?Q?JjnR5oNsUN7RIZLT2O7sUvbevWjmAfJ0XHcSqgWivTwwXnFO5FSaj2BSd+wc?=
 =?us-ascii?Q?7Nw7j5mTP28/QK+rD5nWStdkwkb7ZxXJLUmT+yGhYRRMo0kOAkSaj7iCk5VJ?=
 =?us-ascii?Q?wK2VwJsPRz3MFbXM8NCUMXZG3M0enapMXmfuhj/ms96u9Hy58EXTIMJZIE7o?=
 =?us-ascii?Q?ZdJ22fyzS9vrPCuqr1SNInKgYCIfbsHbtv8tzISsVXgVdRlKquNcDRTCtV4U?=
 =?us-ascii?Q?bQmLtes9kAkBvyHi6Re9fD4C+DoFooneD+uzkfodE63M+5AkPhO5xgrqNzoy?=
 =?us-ascii?Q?HVZe6XgPgTTYwokG4Zb4kaOZ5gNJxcN8yAe/urrRc4OvtBZo1km+MhH1U76R?=
 =?us-ascii?Q?3dRuN2KiimC0U8yDSQcC5Qq5IyV+ZpGbFZopZ0aefwGRV7l4OF2H5M49aOL/?=
 =?us-ascii?Q?OOYHN/g3np0Z+8B0dr3elREVC7+MXGLVz5hSyc95UDmkUCe0ueFSTgFjZz0c?=
 =?us-ascii?Q?sUo+dODfFpW3w1E2Wtb1GCAEgWkj/83UF/tXI1ck03GwKN0kmDxHvCExNGvU?=
 =?us-ascii?Q?MMrzH9kLAbuNmK0xipOnWVUzGuVxT5iJyVxrGleuNP81L+7O8YnrT6VhXD1b?=
 =?us-ascii?Q?AJE/n0audfk7uGqGIEjtgXDTXwajz9gciOWT9LeUuB7NVt+vxCnj7/xeP7SU?=
 =?us-ascii?Q?vxUEtdU4WncGR8pzSJJ/mjSrTCCOr8SXTqvhzYpFTenUh31NJxYQzMMcxjLp?=
 =?us-ascii?Q?2cdABrSMY/GrBUgGxlOuant/bd+vmWqKXZg9zR97AzzR7/Yx75Bo5iAw1DG9?=
 =?us-ascii?Q?5ZMaFlL8BzW71lcbB7DmHOInsrva8aPvkjP/DXZWmh5MmPcNETALRpWPZ3Ez?=
 =?us-ascii?Q?xfnz/zKEljuU8d00dBX2FMY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <911ECFB7A35BD944A345D849CE02670D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7606b862-2700-4df9-94f0-08da01eb3275
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 16:38:10.0761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HEoJ09z9icpoVhKLS9+4DWE9usq07bQzG0vStpygEqbOXdcv62fjmSV/T6gtCy7pkg6oI4woJaz0fP0yI/wqXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3124
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 04:37:43PM +0200, Ioana Ciornei wrote:
> This patch set adds support for changing the Ethernet protocol at
> runtime on Layerscape SoCs which have the Lynx 28G SerDes block.
>=20
> The first two patches add a new generic PHY driver for the Lynx 28G and
> the bindings file associated. The driver reads the PLL configuration at
> probe time (the frequency provided to the lanes) and determines what
> protocols can be supported.
> Based on this the driver can deny or approve a request from the
> dpaa2-mac to setup a new protocol.
>=20
> The next 2 patches add some MC APIs for inquiring what is the running
> version of firmware and setting up a new protocol on the MAC.
>=20
> Moving along, we extract the code for setting up the supported
> interfaces on a MAC on a different function since in the next patches
> will update the logic.
>=20
> In the next patch, the dpaa2-mac is updated so that it retrieves the
> SerDes PHY based on the OF node and in case of a major reconfig, call
> the PHY driver to set up the new protocol on the associated lane and the
> MC firmware to reconfigure the MAC side of things.
>=20
> Finally, the LX2160A dtsi is annotated with the SerDes PHY nodes for the
> 1st SerDes block. Beside this, the LX2160A Clearfog dtsi is annotated
> with the 'phys' property for the exposed SFP cages.
>=20
> Ioana Ciornei (8):
>   phy: add support for the Layerscape SerDes 28G
>   dt-bindings: phy: add the "fsl,lynx-28g" compatible
>   dpaa2-mac: add the MC API for retrieving the version
>   dpaa2-mac: add the MC API for reconfiguring the protocol
>   dpaa2-mac: retrieve API version and detect features
>   dpaa2-mac: move setting up supported_interfaces into a function
>   dpaa2-mac: configure the SerDes phy on a protocol change
>   arch: arm64: dts: lx2160a: describe the SerDes block #1

I forgot the MODULE_LICENSE for the generic PHY driver.

I'll send a v2 so that we can actually see if the build step is clean.

Ioana=
