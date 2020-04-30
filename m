Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C121BEE68
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgD3Cox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:44:53 -0400
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:44611
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbgD3Cow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 22:44:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DariR3upk7Q6+6cXFx2h26lAM8hKbyr7aSaQ/D1tYUBW5MVhM1wYNaGxWM16KSEbM15QjIYIPxHp3DNDxmhd0DFLPvqDC5CxfXIKXGY+aWO9Yg6oirmOht+oxwz4bVMmVUCR28LBDIa/+YJOJ8zbQZ+U2taSB7LMfZQXSonrYEeqEScJ6wZbISzmuw83Y8NtNLb1w7Qdtz7L1Wp4hyXSZiGchFj5UoQc8oOUmKtP/ETfJe9bBD3jAeJ2InMTVTniFEa26hTCsTr3API/mtd4MlIoFf8lZB2P1FYbkQUwNDxJvAA97j+kUwyYVTEGqbue+GAmtS9cju7Y/4wFCb0Yeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcSxMWKvv+HbEwc8A4dLH2oFpfx4JmYPp3rw2jy492k=;
 b=Puspo/CQ+3xqTwGvdnyp8jHn/4dQzcRfdwn2KIld66kssw422UZHXdGs7xFOpuAQPQdVbX28dk39E8Qe/pLZ5QTvkj3qhCklh3bTNOs6DC9fSrKUMu0a1Z/pcn4Rr/evBLzzmhGA+x7Q5Ii4ajOeE3yG+Wn37Qc3AzCfrDzg+ne38gUAViAiBwWfOQrepRVt+7gNXe+Ym86uCW3cxN/EE3YWcgWL4ojSZJFMC0A4DrDab3ZO4p8eT0k6otFXqjv1FqbjZTc7MgfS4mr3rG+2/tGO4ePFxtU7ksXRDQcOIZtKdUNDbq/WvqEzNoRrx08j5QThYA4QKMX017tzPmJrLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcSxMWKvv+HbEwc8A4dLH2oFpfx4JmYPp3rw2jy492k=;
 b=UnRM/tfDxwe9bUVdJUX+vH/5HWj/JFkRteQWLxJO6AR3WvAOy0/M2VmoEuSuDN3/PvBmOlZBy2rCRYKzc9JycZIq73QQArgWZbVdvlMixxty1KDSQugDse+HdAlbn5v4N/M548XAjzGeHnZUDgg56jmKzSADOFvWHd/117gcRNk=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB2827.eurprd04.prod.outlook.com (2603:10a6:3:e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 02:44:49 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.028; Thu, 30 Apr
 2020 02:44:49 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: RE: [EXT] [PATCH net-next v2] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Topic: [EXT] [PATCH net-next v2] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Index: AQHWHmhG/d7V52bSzka8asn6kLoCvKiQ9VMg
Date:   Thu, 30 Apr 2020 02:44:48 +0000
Message-ID: <HE1PR0402MB2745BA1122387B49F589794CFFAA0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200429205323.76908-1-andrew@lunn.ch>
In-Reply-To: <20200429205323.76908-1-andrew@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6626dc9d-0b04-49e0-b41f-08d7ecb07365
x-ms-traffictypediagnostic: HE1PR0402MB2827:
x-microsoft-antispam-prvs: <HE1PR0402MB282795C1EE23F239334EF273FFAA0@HE1PR0402MB2827.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(7696005)(6506007)(478600001)(33656002)(2906002)(4326008)(52536014)(186003)(8936002)(8676002)(26005)(71200400001)(76116006)(316002)(86362001)(55016002)(9686003)(64756008)(66556008)(54906003)(66946007)(66476007)(66446008)(5660300002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 26Un8u6JnApB9GGwkRQEqSdsPldHm4dZoRkO1NfRTLJdfg4QRQAUzq/Kz30BIY2xfuXVxQ6d2ahhHqTSUIwoLctpuvS3Iut8XQKk32Up0nyuva7EG4F7BXXNfO0knGMZ6OHOQ0SZfAJySaSjs6wV6DzW10g/rnHIL8vJcKleTj5/KCKErNbCzKPShZNuGhcFf8pgexJzaJNgcd8tTljExzW5MTfuNq23HMSj2JNFSXt96nAfHK5GUiPCH9W2esfMyhuQ1NqcXM33AsuOhEYoL7pcA5Mq5w32nWR3ngt8BVH3+prNxhgJqmUA5QPoc+vs8OKTArmQoccS9fpXZnlxA9kRPOf+0GvqhoGsu704tjS7kZW0aZZiqgOFh9gHyCS70IFduqsJzSZ/lPVquvNYRNa5NOJIBLf9R5X/NmTq4zdbjMjIonRal1S5DYEQ3nXo
x-ms-exchange-antispam-messagedata: M9iDuDt9pXDCf4OH9bxmWUm2zmAZmDpmkkcfmq8eAgYGINoNTSe5W7Cxgbq6vVK5yG4oElKVCbiSCl8hHT+XkFdb+9EFRnoYJgvMTsEpf6Zon+mwiBXhMqLc7Z5PUDRiHDLzAxhTuCZyRapexkZb3wSyjxAxBmzfE1PWiGUpe8iwPiSdSAt65B9uNe1TSYu4/UnI4NU2v9ctQo3s7DY5W5LKzfJzhy2lkqo4YySABYUbRAiIHA1utcYy3e574pJzkOfOZ54UDW71b6cGtIvbUG7a2VjnsjGRDckgY5iSjeYlxNAGty3quk1ZwSm245O0GwGKGR3RZXZrx+woU/8L5wYXrDemTLsNFvghPI7j8lldRy17uYCT/dKoezkI0fkgM+TP/1OZPQLxU1AtqJqtjCzBBqOwbVZJHmVDnF8geHN3zJ8RufQSpSyn6u0Am4QjT1ttYcPOb/FZt0D2a37Jpv3qj4umg8fnvpV8ItrHaPtjRqouWIR9wnVyofyVqHnLoKAoIMZLwl+lbs1rtDWBD9/Nwo3Dw3/UmT468IpQKynqv/Ew1AJNKGoWz/Y1zpHXVMstcsR9ECsWB+ESQOVJiXrh3MvBYdCZgH6bxyoGMA60+NcKNWD/aa7k9SuvVVucOR8LK3TRug1UH26XNrokXAoq7dMV5JKrn6hpziXEQOPVrRhKwLRDTipim11jugi8U9tw7TdIU3hfM16AKK2aySbWU+PSUHqaTI84YMpDhpbz1jxeNis7ebDU4Y2xzm0Gka8mmYV0DBX9qNRgo1mP3bxKS17Khl8Ho2BsUuDi0KY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6626dc9d-0b04-49e0-b41f-08d7ecb07365
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 02:44:48.9319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E8J0LwchaIFpKPFMgO9IfBEdvf4VVV38xQdZUizd73qkUQVJDKJw1T+wR038GIlO4OHj6v3tOf02t8DkpOS0NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2827
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Thursday, April 30, 2020 4:53 AM
> The change to polled IO for MDIO completion assumes that MII events are
> only generated for MDIO transactions. However on some SoCs writing to the
> MII_SPEED register can also trigger an MII event. As a result, the next M=
DIO
> read has a pending MII event, and immediately reads the data registers
> before it contains useful data. When the read does complete, another MII
> event is posted, which results in the next read also going wrong, and the=
 cycle
> continues.
>=20
> By writing 0 to the MII_DATA register before writing to the speed registe=
r, this
> MII event for the MII_SPEED is suppressed, and polled IO works as expecte=
d.
>=20
> v2 - Only infec_enet_mii_init()
>=20
> Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven MDIO w=
ith
> polled IO")
> Reported-by: Andy Duan <fugang.duan@nxp.com>
> Suggested-by: Andy Duan <fugang.duan@nxp.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 1ae075a246a3..2e209142f2d1 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2142,6 +2142,16 @@ static int fec_enet_mii_init(struct
> platform_device *pdev)
>         if (suppress_preamble)
>                 fep->phy_speed |=3D BIT(7);
>=20
> +       /* Clear MMFR to avoid to generate MII event by writing MSCR.
> +        * MII event generation condition:
> +        * - writing MSCR:
> +        *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> +        *        mscr_reg_data_in[7:0] !=3D 0
> +        * - writing MMFR:
> +        *      - mscr[7:0]_not_zero
> +        */
> +       writel(0, fep->hwp + FEC_MII_DATA);
> +
>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
>         /* Clear any pending transaction complete indication */
> --
> 2.26.1

