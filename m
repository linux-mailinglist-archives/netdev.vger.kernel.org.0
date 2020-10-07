Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD306285C6B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgJGKGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:06:54 -0400
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:65377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726598AbgJGKGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:06:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpzXRhSil5z2qI7HSn4MiTHNp04vY/IkrcDpdrJX5VnWqwKcUgP+V57DqZBjkRdOCVyKvn6Y0x/GhYVLixUNHfsAf3EDueHqkBhWeD6z5MofkW7LPhEgM6YTCqJmfjKUKfdaZ2l0dv7PMa1b+UGG2zuUeZMaBJcv/1HDbGIc8/Rcx/cCzwSx1bijX/uGRp7NaeVDLdNIJaytFf4uZxocV0i+7ow8JlNrwhCrgF8TDh0zgqte+BZTulKLxCfc8LMaXHvnOdqyzgM7vdMY/ElOYJ0sIfFteNiVB/tu2VsfGqvMU6yUjvlLkBdQqM26oVc2kDV84wbMlseCGz24C0eqng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iw9uOpsl5aXab4KX9k8oDHUUwuHyCpdDLMXxeNADGsY=;
 b=cVUAds6I7Cpr12aEnSB3MTMd9WHCssqS72eRGcts4FU2XQJYqiOU6ljiKRl+6+BDHIaqBoDsrjmyuLHd8ZdXPh2VyWjRzP0l0fIMSot3pWJJoWSPwuFhIflnhHdaX+t+xnjeDEUTDB93WAqQ4Ds8wB7oy2iR1Y3XJCJEq1jPFkIrwdCSgMPa6tSClhTmjahBovsEqTxZpgV/eM+fF+HMlIQlcrIEexI8y8OCLksEHMaL2ktg2+rRgDkxxLmMFkhgIHrX4JlC+oJC/DzecSQyjATBMDqsPdontUHaiAjdwewa1Mgp+HtTbMHrwUVmclo4tCBaCA+QA3AkmvDs68b3NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iw9uOpsl5aXab4KX9k8oDHUUwuHyCpdDLMXxeNADGsY=;
 b=LU5NRIAC/95cprNKJngfJSfZntKXH0pQIlOPQbVfHPlCHTvaep0gLFnSwlce+HKXU4m/vTtvCDUkZEY58s2IEtQiQagjUymD4ICXJIoS0igJz+Qg+WUciSowgvqVgNH+xn0PxpcRjbzOLTJASEgF0YrXLZKN6buUd4hg70DefbA=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB4116.eurprd04.prod.outlook.com (2603:10a6:208:5e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 10:06:49 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3455.022; Wed, 7 Oct 2020
 10:06:49 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next 4/4] enetc: Migrate to PHYLINK and PCS_LYNX
Thread-Topic: [PATCH net-next 4/4] enetc: Migrate to PHYLINK and PCS_LYNX
Thread-Index: AQHWmyPOS7KmvbhZkkOlRbGxPpEGhKmKGBUAgAHUEzA=
Date:   Wed, 7 Oct 2020 10:06:49 +0000
Message-ID: <AM0PR04MB67547E9C44B1203314D5AF04960A0@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20201005142818.15110-1-claudiu.manoil@nxp.com>
 <20201005142818.15110-5-claudiu.manoil@nxp.com>
 <20201006060859.hapkjgcv4pwzhkrv@skbuf>
In-Reply-To: <20201006060859.hapkjgcv4pwzhkrv@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b46680b7-fe16-45a2-7bd0-08d86aa8b525
x-ms-traffictypediagnostic: AM0PR04MB4116:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB411657F22F8922934BE31EE2960A0@AM0PR04MB4116.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7d/sYvPL76fG84yZ3aEvtU4o/sWsvcivQzu0A0eWyZlz1Ck64tn1EaOy10DMA6iT9gmpC29UqmePJFm2+3ss+bClUb81cBBFFvBj6e3h/SIJBq0VEEy11Nnu4ZtjCaUfHzsjzBohZwmlizOvTLuAIBX+vdXTQwmGR4QlHAgc/ubM1KKOaqJBaNS8Pe+rNQGHzKuOvPI4d6xe7/x/EnL8WI1mxHLviErdWFmF1LfyrozI4pJqEU6wQ6+gSrz/ET+56KDxxC7tF4V4CrrMw5n6m5neUA7AVqlUwTqjzcLoLrCUdMPLUIi6QUv3gYa+Znb7awPE0ZN3P6tY8bTLCKylIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(7696005)(52536014)(83380400001)(71200400001)(2906002)(66476007)(64756008)(66446008)(66556008)(6506007)(186003)(26005)(76116006)(66946007)(86362001)(33656002)(6862004)(8936002)(6636002)(4326008)(44832011)(9686003)(5660300002)(55016002)(478600001)(54906003)(316002)(4744005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: oj1r1iBs9BkmWPPUY1VWNuHLocJQ/+f2QkkG+7eDVc4/DLj32ZOU35lQjhgfyBJeaEgi1tFYbNad+Zn4IR5Zbebsnj03eMc2lVC3Oj5dKUnlYpTjcwz/OopnoR9RImX6hRZcXnvMQkqQpmxZUWqNF/teCQY6K4SI0zxw4TybNhYM5fay6T9NwTWSBhl0AybqZp9VKjMu28+1MF6aN3xMBlcDi7b30AVTzwOg+4ikkP6uIgBU+OghV8PYeoXk/1n8GZb7mcNFvnPlJbl0/r4JH7cKnOsh0mdEtqXYbJRHQG/Trq5NSiBcyaglZMlzLGkXZU5kU2tO35K1cAgas+ggG9X/mxuwDKUEUy5Q9J008PtPhNjrASgETiXsRFqmUsXJvQxCTN7bbA1pY6YnociwYNE+9wuLb+Qxi6FvK6YlNvxM7HhpskfzzdYxws4TKIGTiRe8D5bLlRwtkTtDoqdmifbrGOrhpzgV6OnwCWvJNr+xyINqRHgh8QzguR6glyHB1RY/PLcE3S2QAJIDYXTYnImminKKQ+RsrBE0vn8Z4d3cj5LYAfs7n8BuqfIPKjm/s2S5edf88PEceXFdlcPlLUb2mR/ljaXQ+YzacYl9ucEKQ3fA/aTa0zlRMti4oo82xgFTFBGwIS3hoe54mw1ixg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46680b7-fe16-45a2-7bd0-08d86aa8b525
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 10:06:49.8508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W5GvKzrhrTt4aLrguinx4mvbRRYTZnI19h5KnsQ/JzuRhDyKOO2kUr789bUCAZ5d9W36dobDq65s9lhd52Fuag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Ioana Ciornei <ioana.ciornei@nxp.com>
>Sent: Tuesday, October 6, 2020 9:09 AM
[...]
>
>Shouldn't the driver reject any interface mode which it does not support?
>Either here in the validate callback or directly where the pf->if_mode is =
set.
>

Agreed on the 2 findings. v2 sent. Thanks Ioana.
