Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD22722A6FE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 07:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgGWFkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 01:40:53 -0400
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:43119
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbgGWFkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 01:40:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSmH1szUoLQ4zeuZTaUqMHFI53nELhNVmgERYr3mEuDT52TH8tYnsjnCMP0502IslY/NacXFcx+h+3VA/f17qsOkLoarIAZ190mpl4NeYSz3pKlF/zucEkZK/MHiuzRucoP9q/EsTot2Ty98FQP78KOcONo7YUlBW6GV44qj846lIUBxkwRJnY4FUYceBx+ZQDZM3fqVcOhRqSwI9qFuP9e9xxi/5S4MSoWVecYHCsyeo/R/INAmZHsI38dCTHwh03x2IdgG/KoZRPrGmeJrcPeqx6S6lQGgeEzIRjj9yMsEBE1mM1/Jv3CiLT8Xym7JtZ3yRCNA3aujJokgSGvOIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaS/TlDo7cqi4FbDalwnmowouBaF73RbMKLUTJpPgcM=;
 b=RHZyHb8yQTJWZyWE/++6Q/79KwGyostRlDsTFZBXBkLhkPDZtGyMAZX1oIN3uUJ+fSxVHW2xVXhrLgxwl6HaLBW7l73HrRKK1w8HzEQf668r0sbBMJ0hdOXZUkYxBigitA01QQYpfgJm6h6weKbI3zV1OhB8fliejd2Cjhvz9keXpCquNYy/IpICKwyaV1uvQypR4eyQtavuHoTXp5kBlrqRQbftnjjO7lXrQGhisTinHXm8T2t2Uk2Zt+ApydXnXmV5xT4iX4+CTGAZ5ihrLQSJFY1NtCEJ7StbMEgtr7c9g1G6rR5szjyZ84osYo+eG/0dAumDCJYuYc6jzKLA+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaS/TlDo7cqi4FbDalwnmowouBaF73RbMKLUTJpPgcM=;
 b=bImpdVRp/VzcFN4ysZDyAbWMJoYyYtBqk8JvB1X5V26CBHAeo9hKHbkbJTyY1pNrMa9vO6O0FcQqOH5e0G13q3rE97iTZpWzyvfNg2E6FH88q2L4OANMik1ademJaeXgRAWGoIbJX5Sq1M+CA7VhSvLarLtqzulh7TcaJcOb9O8=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB5079.eurprd04.prod.outlook.com (2603:10a6:20b:4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Thu, 23 Jul
 2020 05:40:48 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::51e7:c810:fec7:6943]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::51e7:c810:fec7:6943%3]) with mapi id 15.20.3174.030; Thu, 23 Jul 2020
 05:40:48 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC:     "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Radu-andrei Bulie <radu-andrei.bulie@nxp.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>
Subject: RE: [PATCH devicetree 3/4] powerpc: dts: t1040rdb: put SGMII PHY
 under &mdio0 label
Thread-Topic: [PATCH devicetree 3/4] powerpc: dts: t1040rdb: put SGMII PHY
 under &mdio0 label
Thread-Index: AQHWYEz+LgZibInI10i2/O6ewv0daakUplWQ
Date:   Thu, 23 Jul 2020 05:40:48 +0000
Message-ID: <AM6PR04MB39763CA66048BD4F221D0DE4EC760@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20200722172422.2590489-1-olteanv@gmail.com>
 <20200722172422.2590489-4-olteanv@gmail.com>
In-Reply-To: <20200722172422.2590489-4-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.14.204.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30811635-b75a-46a0-1b37-08d82ecaf405
x-ms-traffictypediagnostic: AM6PR04MB5079:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5079AD348F569C950C4E48B8AD760@AM6PR04MB5079.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Bv17ujXPqbg74Cv8yFInypvDL1dKa09B0vWwYrgJNpBwuDc14pPIeWHnURs+korboP21mBrOgjuxrFxZyiqqMz12riMx/m1/jp1gdUhb4JL7lRw/PQAzcsqPwRINAgUMamZGpeEaZeQW3ifQ/TB7zczvZexmi7o+z0TQeoNKhbdOWeai6FFcTeUOgH9n7VS3hHRhy4FcDyWZ2473qVQnrnyHPR8OA2goMYjJpntLgd/aB/d9mCFuVBliJ2egIm0OIibWkjaKJ80LCDLxAxJHbEQnoOrgZgmSDhiUVBPxfJnzx9UraWv1RCI2bYAH54+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(186003)(8936002)(64756008)(66476007)(478600001)(83380400001)(66556008)(2906002)(5660300002)(66446008)(7696005)(7416002)(316002)(33656002)(76116006)(52536014)(8676002)(26005)(110136005)(54906003)(9686003)(86362001)(71200400001)(53546011)(4326008)(6506007)(66946007)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: JYal8yjGjhmUpyCL23LXjXcejFQTZ8ako1F/2UL7OOQg/n/HQ2Ew+kIZrKc0/MVxlaw5RSFcDC9XKfxDaCzl4rs6U/2bRo404kTjj+HoXI2r5Oj4++WH94xQdtyH3WnNtUbjS7G99jDnDNHbW6742skjsSM2MfI1kBw9/uFqOCEMH9RdX40JW60hEBY2H0lgkxJisxllhhQxGUneAK7mofLwqPDnz2Oe4gz/NF4KoR+ifqUAysSbbMREgRKQg9sNMGUOmw+kWKak1bL4JtMoxAY7Isi2xrVYj8ohi58kojpQmB4pCK7TQ1UtpQAus3pLSwvnkfCy3ndiP7V9rJg5uvhn10pVtb8gZqT6ttMOseixs+tJDr8YDlExMR2SFCkdbPLRoIuLEKUUskV2oUUHY9kph8L6mQogLDCK3ZrYgZl+D9VTA9m8IauTqDNMyxcgi6uGZM5ox09AWHeCFoQEWOJfa7kPKv5kg1/5EriKLsQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30811635-b75a-46a0-1b37-08d82ecaf405
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 05:40:48.3732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Ov+hqQMBgJgE5yGTDeKqx9QweO+ZPr4vLyDMnKPW9WCiT5K6cPcI7WqIxksXVo8v49Y3q7v1RAyLmj3FhzUlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Wednesday, July 22, 2020 8:24 PM
> To: robh+dt@kernel.org; shawnguo@kernel.org; mpe@ellerman.id.au;
> devicetree@vger.kernel.org
> Cc: benh@kernel.crashing.org; paulus@samba.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> Radu-andrei Bulie <radu-andrei.bulie@nxp.com>; fido_max@inbox.ru
> Subject: [PATCH devicetree 3/4] powerpc: dts: t1040rdb: put SGMII PHY
> under &mdio0 label
>=20
> We're going to add 8 more PHYs in a future patch. It is easier to follow
> the hardware description if we don't need to fish for the path of the
> MDIO controllers inside the SoC and just use the labels.
>=20

Please align to the existing structure, it may be easier to add something
without paying attention to that but it's better to keep things organized.
This structure is used across all the device trees of the platforms using
DPAA, let's not start diverging now.

> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  arch/powerpc/boot/dts/fsl/t1040rdb.dts | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb.dts
> b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
> index 65ff34c49025..40d7126dbe90 100644
> --- a/arch/powerpc/boot/dts/fsl/t1040rdb.dts
> +++ b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
> @@ -59,12 +59,6 @@ ethernet@e4000 {
>  				phy-handle =3D <&phy_sgmii_2>;
>  				phy-connection-type =3D "sgmii";
>  			};
> -
> -			mdio@fc000 {
> -				phy_sgmii_2: ethernet-phy@3 {
> -					reg =3D <0x03>;
> -				};
> -			};
>  		};
>  	};
>=20
> @@ -76,3 +70,9 @@ cpld@3,0 {
>  };
>=20
>  #include "t1040si-post.dtsi"
> +
> +&mdio0 {
> +	phy_sgmii_2: ethernet-phy@3 {
> +		reg =3D <0x3>;
> +	};
> +};
> --
> 2.25.1

