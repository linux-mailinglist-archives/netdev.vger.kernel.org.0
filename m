Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996BB5366B1
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 19:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349943AbiE0Rv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 13:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiE0RvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 13:51:25 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60065.outbound.protection.outlook.com [40.107.6.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6058D12A;
        Fri, 27 May 2022 10:51:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBKEvgQGMWCYzjkfmG42G5FhTpRJrSmWVBR9ZXNd2a6dasfneKbG3cK51wP12XADeNuHjV7wyCyYf428ca4zYTLqoT3O5ft5OcX2MsV3DZeDltFDN9mWV0diZHFA03ZFYM8AHOT4JXdgNfxv6ya7P49j5GMLqGj+Xenq/73mLeUZKFN9UY1323Tq3++q9fzp+hYBnEhcHvhHmTX474/VSNo//QbS7wrq8Qh8gaVCzWIaelFm6moh1KfCxnEfZT7VkNYS2X55N58Nr59hwFrc//jUWSsdYgeY89MoMpwYpB32RnwP1mABVsltx2lYuqijhTQCSu2cp+94vMH438AaFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLr293ciDS4H+MfdiOONgzGiv1kwf86LLKFK58rH0y8=;
 b=mh8AR7w250RfYpFIgt+Nl7qWEcYuKeM9E6u90ernvdG3MRvx5thKtgf8bIC70/qkoSLgWGJKcJBv10RbWaiA23XJuKW6YcJS8ZMVk/9iny9h0ZeLgoym9PjedmAbafo2RbUJ0k9HrhFSl7FDtNr8JwN7uIjBG9UG3G9yvvQ8wJLIZdpJz+RDuFk/7MSC8QqmTTHBsJoLAjZDt3Zydx6u7o67WUNluYFwIRVYjH7cFqilMq9FHNgJ3vy3qUIopu+FpxWelpvSdFCRcrUdRqNmZGl8WFVCQ3+b0rGF2uMVY5jBc08JF0eY7jaU20gadR2L0LPv5RiDc6hyw9oTxE5iIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLr293ciDS4H+MfdiOONgzGiv1kwf86LLKFK58rH0y8=;
 b=dT6Ow04/Zu0JSJx89GwPu65OYt5ez3W/rknVCswhcrnOElMK1k7J4fO7KxHkxNQUV51GXKoKpMTNauGZeM5AA4SmM4IcL0puQYB265TbKQBSZ6+VEw4afBHWKF+Im5g5h9k370/CNguk1C9Cm/4TH9ZFBi5YCF8SDr6OyiGCumE=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AS8PR04MB8499.eurprd04.prod.outlook.com (2603:10a6:20b:342::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Fri, 27 May
 2022 17:51:21 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1%5]) with mapi id 15.20.5293.016; Fri, 27 May 2022
 17:51:09 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: enetc: Use pci_release_region() to release some
 resources
Thread-Topic: [PATCH] net: enetc: Use pci_release_region() to release some
 resources
Thread-Index: AQHYcavCsFlf4vEGkk+HPnY37e6cTK0y/S5A
Date:   Fri, 27 May 2022 17:51:08 +0000
Message-ID: <AM9PR04MB8397145BCF0042D9148417E196D89@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <b0dcb6124717d13900e48b2f1fa697b922f672b2.1653643529.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b0dcb6124717d13900e48b2f1fa697b922f672b2.1653643529.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 092463fc-2cb9-4490-0f40-08da40097af2
x-ms-traffictypediagnostic: AS8PR04MB8499:EE_
x-microsoft-antispam-prvs: <AS8PR04MB8499B7CCEE7596A8BA35B2C796D89@AS8PR04MB8499.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QnZU+mMWRoJMSPH1rPsiFtFJytvNGhScr9WCZRKHhTQI2LHxfLLUnZF0RVQtToaVEQV4w5BJc0DcUSignMWZ3F436x3m5My4m+3TeTutvhS2tq+UxlEDzWHcOg5NUcnEc3C2j1lkwkFFWyBdspFf3feZAl6VFm5OMAd3AzNXlhwxpLu/60vQx+yd56K3GRWmwWZ0O/Jva3frVhWz7KDW+YJbJvLYETEIogKJJ0whDdWfYjAY0xUnk5nvy/UAyreRQJF4KheBjzsvJsNRDrSukfT4pNZWfyqZskQmgXHCt9g2C6BpTwEhCnZNO+mwDtby+c8nsJIy/fxWay7wz6mNxGwEcV4HSuk27h1iS3u/aB6Um3YISniV+JIBxjk78pBkpbPCgs6waQ4e9pg2MSSTesYNyKdT0ALzkWq5/9emUa6obiUSTMy1mzE4kY7IhHmNz6pv998srN8Ruh24NVAdZHgfJglOK6GfGkFkpNn3fRbaxnP0HSlo3KMEDeO4ucO51CJDY8+cFogb2JrdpWrz1viikl1CKrs/zmwYsAGIHSH/BUalJDc4bY18RNFzhHgDQWr1Pxy/LdRQFEjVl0xv2Mys/W+iL0EQAo/pWcyIpHhHqMkPez9lk7QH8FIYHkkePbWYys6BO3jM+bD84wxMZRyw0KsgSOv4nDYOlYZuQUGHYeyZHaxUblttD7tYHytjZhB7cS/iBeSN8HuW6PQVpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55236004)(8676002)(186003)(508600001)(33656002)(2906002)(86362001)(6506007)(7696005)(52536014)(26005)(9686003)(8936002)(71200400001)(4744005)(44832011)(5660300002)(53546011)(122000001)(38070700005)(38100700002)(54906003)(316002)(76116006)(110136005)(83380400001)(55016003)(66446008)(64756008)(66476007)(66946007)(66556008)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L3N1NAMTgiMynfXnkqXkAltQA3o2VfiaUuuRHop+KVYMZaErGMnL1BUsUUmK?=
 =?us-ascii?Q?QrCW1paNiLjsrrItkBq/ADlLyIJH/FqYfZDq9AJ2ZKK5HkOT+LLC38sqmTv6?=
 =?us-ascii?Q?dFVHkOls0wHIIAwlv1e22pzQGeLkBF/ZVVcRKt80l16E1KyC2Mb4ssEjeJaN?=
 =?us-ascii?Q?yFWO73IHCg9kXlJa9XUPDcyGlvAhLnoMbYX0WF9YLlCkZB06h5dVD49AJzUf?=
 =?us-ascii?Q?IdGCiLoKPYMgJo2K9tnFyzw0kjUsGlERR+mKb5IeRjpi1CGsY20guNGEQD0E?=
 =?us-ascii?Q?xYfMJdpRmBMqfADwxaDUX4CLOiMcyqQEj5byb8hycSs4x+FjkMcBVczB0dhM?=
 =?us-ascii?Q?cVi8diJFUdaFzf+DDwT8EAsLqcRFBoGPqaaiS9kpGyTSNsEhHwDCLR1ZVZlA?=
 =?us-ascii?Q?9O28rc0jvjnuuKjk+pjBMNJSkTgQAT5zmrAe0TjNzKOROwui9nCvyG/4fhC3?=
 =?us-ascii?Q?IZrkD3vdyZQ4nQqCPnT/NVoM7d+FOF/2WlA52siQTunXcj77GnpiJ72YDJcd?=
 =?us-ascii?Q?MkRT4lNaEx1TBVq4ul84YJnVEWC7qpMenPI1ctdi+HSbGjIEExrNjnzFrkuZ?=
 =?us-ascii?Q?oS7r0A92+qNLdV1jG5i5ZB+ycj6t30J1MWYuvwH6/EwdLzuCs0TGW/A0BR4R?=
 =?us-ascii?Q?TcUz7qbwY1h9R3ibrqz5Pd3gi4mVkDaJdeixDOVU9n1YPPIrqIAuD+wDjkaW?=
 =?us-ascii?Q?kPWUfl2XBdwuVc+11W0neg/wfZNAH4chPoVH3oEawAYrWLTVZUHo/xokqG6h?=
 =?us-ascii?Q?/cND6rmp30pZ19Px7z/5Lh37oNM2+OdZTrOUghNnM3OIRwdhhhpol6q2iv1k?=
 =?us-ascii?Q?YMnyQ7meMlKTkyCGa37Jl74Mn9qM6pahyFyKxUb0IcRVgZhYMA0ipYloHABV?=
 =?us-ascii?Q?ZgddaJ3SOrJoUMc/DeGudu8+VTrrjGXW5X2RIP7TZhybJnVM3v6kFJBJHu3g?=
 =?us-ascii?Q?8PTYDyhVcu7jKt9GO2rwsuFO8AYVTAkubLvvUr54Uu7juGk3By4VuhxP85H6?=
 =?us-ascii?Q?o7k1phQJKFydsY/JyX3ABMfL7sT80n9QqoLsY8CtmBVjaNKdYfiILpvQx1AH?=
 =?us-ascii?Q?vL0r4DwUctx3CR6MIx3dAekpgd8nXHxZhluIb5OlUIvYyqn2nBtTvtxmehOZ?=
 =?us-ascii?Q?EbxLjOGle93qlVIV9pRiGReP5tWCy2zncWGAkDqlX9/29wBHaqBVACUePula?=
 =?us-ascii?Q?OUi2+chdqiojAGE4IEANAyLUp531iufjo74wP+CJ4rVtrf74JkaZhoVFSeh+?=
 =?us-ascii?Q?6cOXKUX18DRHD41NxAwtCA1sZBggaFQz1TtOQnH2TySY/v3RII8ubtT425nW?=
 =?us-ascii?Q?41rYNZ2tmoNxBsWVQMIrT+i2HKIgPcWVTXiReIQG/Eawhuy4EuE4sX7kPo/T?=
 =?us-ascii?Q?A8FREtJg8efXGDnGBfubxg9qYOpcHJ1LhgVuVU8mZTWM7/yPmS7Ty52VTptK?=
 =?us-ascii?Q?oqyVL+DkW033UPeMJhOTSeCSeniN3u9gwJ8mK77gFkEB2X8VZa9EQug8yu4f?=
 =?us-ascii?Q?sdhYNhys1YMy+vZzePhke1DRompqVRzXb01sfEC0ox7sZXtFalGKelln7hfG?=
 =?us-ascii?Q?IDS++A8+qQsI0vToDh2NrbG/5smekyrI2V0VCpeUPMv7u+h1WiXtCD8Y1pGB?=
 =?us-ascii?Q?A6BmtB063+r1Wv6dfr2/EoYIpaKVzwz1x85+fZ66YRXdXlbzd+/eOeChMYZu?=
 =?us-ascii?Q?69Q/batEh0JjZSKooFAMK4nPHrORmVVIlnedM6KHGLS89wafcU8mw3JjyHQj?=
 =?us-ascii?Q?36irSwwO4A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 092463fc-2cb9-4490-0f40-08da40097af2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2022 17:51:08.7288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fJlLjxULo5CmS301IXF44QoVhhELzPrw4+pwTRdc3JBFbDFVnwnRHMc5P6oDiebYrbBVg0ANNRL8sTTl6McDdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8499
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Friday, May 27, 2022 12:26 PM
[...]
> Subject: [PATCH] net: enetc: Use pci_release_region() to release some
> resources
>=20
> Some resources are allocated using pci_request_region().
> It is more straightforward to release them with pci_release_region().
>=20
> Fixes: 231ece36f50d ("enetc: Add mdio bus driver for the PCIe MDIO
> endpoint")
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is speculative, mainly based on the inconsistency between some
> function's names.
> Using pci_request_mem_regions() would also have things look consistent.
>=20
> Review with care.
> ---

Since the external MDIO registers are located in BAR 0 of the PCIe endpoint=
 device,
the driver requests specifically the BAR 0 mem region and should release th=
e same
region. So the fix is valid. Thanks.

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
