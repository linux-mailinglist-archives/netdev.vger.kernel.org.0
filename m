Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDFA1BD1E6
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgD2Bxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:53:38 -0400
Received: from mail-eopbgr30061.outbound.protection.outlook.com ([40.107.3.61]:32617
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726158AbgD2Bxi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 21:53:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFE/tlEmD/sOE8Tx/aH4t5UsP3jTnRq8DaiVoFPzHJ5nVMDf33e8ft5NhtE1tcPJE18vCFqdgEUaDgSQB8eMyrjN39dJftRUDfpwdxk5FdN3Jm8npGNryREiE4DnWjZARi/2MwXis7g0hz2qfQ4RZkC7jqtCGq4Rm+IcNuE5t3GAjEVqKBbkAhJuJl7PDHoTFQHxEOQZvN38rNgEcVbz9rsoCdtCUGw6ycZdTmlQ8QIU8UtDdZzbCJooROUQ66ini0HZq4PkB3byRrryRmA5fnTbSjFTffo8DIMMUK4SqVYImJjuufUfmTohnK1Dg0K1gY7CAsz0RZjr5LhWJMGQ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AS3K50AYTtPx2qxrtq6s4uSO8YhkvfzHVMFRJyM76w8=;
 b=PMzGF+tfuB7g5ni3uxSZbld/YFUoeDQx/znK+ew5Uqee48aCkHgb4qGjk9TzL4JuljJcV/Mh4rt+GxEaecj99yWT1AmuXw5Q30gwRzXtl0h8TsoJJLLs+8tugKBMwCu2Rsmc0QDl/04y0b/1/XLUBYYnFc9JfR9Wz7i7ipdIsNaKYw8y7zYBE0xu86qa48GWNsGp17dUvPV/k14snq3+csFtSxvpKHhg+UmI7q5Iiv0VKwm6+W31Ube9n3npiyd/BIFzfIEOjgVMj9MX3At/kUl0QFLY84Sh12Eh7u6NRKAn9/rbsyAVBomV76xFySqKvxL9QVrhyp5PY4tjImH+Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AS3K50AYTtPx2qxrtq6s4uSO8YhkvfzHVMFRJyM76w8=;
 b=N6EyXMzFJTsdtQPYwtvFF/1f8uXVUC5/nrTLbC6oc9wyopzbGq4TWjOjet0Cry52pzD6vC7WhsgLE0k8wuZZ+e1+/UwFx7LjMdElaujlyVZl/SMZSd47m4jYmUIUKKZEAmyDhbyB6eyGg/qzexRg8uTlYCXxaQZOyj0P7qx2KdE=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB3355.eurprd04.prod.outlook.com (2603:10a6:7:81::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 01:53:34 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.023; Wed, 29 Apr
 2020 01:53:34 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>
Subject: RE: [EXT] [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Topic: [EXT] [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Index: AQHWHYa+pwUztU1RBk2o0X/Zptbkz6iPUvKA
Date:   Wed, 29 Apr 2020 01:53:34 +0000
Message-ID: <HE1PR0402MB27459F85A4F7DADB491B5505FFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200428175833.30517-1-andrew@lunn.ch>
In-Reply-To: <20200428175833.30517-1-andrew@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d14949a6-7d73-4ac7-58f2-08d7ebe02037
x-ms-traffictypediagnostic: HE1PR0402MB3355:|HE1PR0402MB3355:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0402MB3355C01898BF989B60EC2EA0FFAD0@HE1PR0402MB3355.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(186003)(478600001)(9686003)(8676002)(110136005)(5660300002)(33656002)(71200400001)(6506007)(76116006)(54906003)(316002)(2906002)(66946007)(55016002)(66446008)(66476007)(64756008)(8936002)(66556008)(26005)(86362001)(52536014)(4326008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7rm+kEAWN2UbfFkDZB+mUC779zZnuotP+dJuuAwJnImR9egUXE/Qo9XXAko9HNZ7RLGRaL672DikBuGrmNGr7pZTGrYwX+1nsxggQilcjmbOtn6Icni+9YMRwR5QTYsmm2m74ykv6TQ35haPTmioWDBpis+6m6MlFkvVTyZOG3czgR9Se9yQTsbL6r38tMhzYN7jrZ+w5E9wTSJFhSt5xzkOWWV+N1ub1mVg0+Ml8/VKOSn7HiMptDCA6exgdW1buH5niYS0SV5HCzPhdAdvz2vILF+UCGUk5GkhfgOjYCLhKhqv/6JIE99I2mNcqdKkvYUj9weH38/fKnQCmMtAP3vx5DmJ9kxhpyVNOQ7oQRILXUXkh7CVnU+FNnBtFgEWptyGZOdpxk4b3ljSkC4x0zAKM8/HWFEp1muYK8gsuo7ZskhrIWhZuOHIRtgep5GK
x-ms-exchange-antispam-messagedata: bI3wAFnSsvQfhGB9zz9om3/I52UGeH7jIJcoamKB4VQsybxnAtHkCKL4/uL6uLCHizlcB3JQzDyGgLz5CpN7zShayEnhbIOYfTvU1mUMTK20bNep3s57NF2nZeGt8peoVIkSfjI+HiwhxXK3kFHM3wnyZM3cSTOl5D5ZauUnIwh4J8YGmMrh4jL7oGbZ+J7Dg4sQkuKn57O/yQ7HkIc2b1MiHbR/6S/DwLURlxVd1+S+jfoUsTH1C3QDMl9ZXTDwtyl/7I3ZVCvyBMpYqqCPZSnIUJWliJlXuHpDq5xWmJVVieBY+qY0GJy/hLeYQu+tWw0BZYEsUM36A5HyqCX9f3lK4y9MshzV0IONooCFoWnTDUBKu5mG3F/GWJdIA6sGYFvUAMWC3AcG5BSziaxNScN9QrFYyT9jbh4NSELZOd1TIk4pXjhaKOTqQ9KmGt3Fgt8HQ7KSwpbwNGiLLHGq+9qbUPzAEa+iP6I9z9a0FHSB1/L9RgQB7wqmWPEBe+Ntd/Hi8UGgX+R1fUkDWMJaHmFBzKIADOVfgNKlruWzEdmFYp6w+M9thUgh7fU4OtY2k8YPUEmpbuHbks79M9hKC3ANV6DUe+YUIVaSKw/IJ2Q5x3VvcqzKeKLGsil+FpvHRgpoJJXXgbTsbo/KCH+yda1RihExAJWN+lCbRbAkf+DTlIsYmF/oicoWGzL2GY5Ps9ZMBWqwrfmlag4xLKyYHaxPviaxEzVh7lzNzcIU7b+i54FCSf6sqYR0IvNIowul14gEcu/8UsMOE3+3LWiWtz3xmQ4N48ab72/MLXVZUCk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14949a6-7d73-4ac7-58f2-08d7ebe02037
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 01:53:34.0834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7MGgnwUfh+1GL2OQMGDlpVelHz1dNXLOxPcSwqG79ZUeudJVcsNB/TW/OGnna1wtLJxX9TsFd7/NQkzXiL7rCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3355
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Wednesday, April 29, 2020 1:59 AM
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
> Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven MDIO w=
ith
> polled IO")
> Reported-by: Andy Duan <fugang.duan@nxp.com>
> Suggested-by: Andy Duan <fugang.duan@nxp.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 1ae075a246a3..aa5e744ec098 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -996,6 +996,9 @@ fec_restart(struct net_device *ndev)
>                 writel(0x0, fep->hwp + FEC_X_CNTRL);
>         }
>=20
> +       /* Prevent an MII event being report when changing speed */
> +       writel(0, fep->hwp + FEC_MII_DATA);
> +

Andrew, my suggestion is only add the change in .fec_enet_mii_init().
There have risk and may introduce MII event here when wirte value
into FEC_MII_DATA register.


As I said, if FEC_MII_SPEED register[7:0] is not zero, MII event will be ge=
nerated
when write FEC_MII_DATA register.=20
        * - writing MMFR:
        *      - mscr[7:0]_not_zero

>         /* Set MII speed */
>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
> @@ -1182,6 +1185,10 @@ fec_stop(struct net_device *ndev)
>                 writel(val, fep->hwp + FEC_ECNTRL);
>                 fec_enet_stop_mode(fep, true);
>         }
> +
> +       /* Prevent an MII event being report when changing speed */
> +       writel(0, fep->hwp + FEC_MII_DATA);
> +

The same here.
We should not add the change here.

I already consider normal case, suspend/resume with power on case,
Suspend/resume with power off (register value lost) case, only add
the change in . fec_enet_mii_init() seems safe.
The patch "net: ethernet: fec: Prevent MII event after MII_SPEED write"
brings some trouble here, we need to consider all cases when writing
FEC_MII_DATA, FEC_MII_SPEED registers.

Again, please note writing the two registers may trigger MII event with
Below logic:
        * MII event generation condition:
        * - writing MSCR:
        *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
        *        mscr_reg_data_in[7:0] !=3D 0
        * - writing MMFR:
        *      - mscr[7:0]_not_zero
        */

If interrupt mode, we don't take care this logic and dependency.

>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
>         /* We have to keep ENET enabled to have MII interrupt stay
> working */ @@ -2142,6 +2149,16 @@ static int fec_enet_mii_init(struct
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

