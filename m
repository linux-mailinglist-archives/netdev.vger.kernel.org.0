Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA444D212F
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 08:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732980AbfJJGzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 02:55:36 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:11329
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbfJJGzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 02:55:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxaD0tTPPf2D5i6TKxKc60zGUE0sakDWtw56kiqzqEoxfR7aesQ+0TPY2bnNe9xNSpputR56+AYi0dS94+bZjrj836tQpnzV13n7C8PZyvgdqvJMqwT/4tgjxUuQJvcSfsNIkeZkgR33AOzFRqKKW9zXsACAoUg+JhjDyF8YeoYZRpq++aF2g/T6Nis2H6mcF2MYewFOdRMHGvJ1kv25+FcGQIJs4n2mJKVmei6t5dQsVrhNMLBNXPKrlDqXmLxiMj2Xjbxh50tLMtgr7NC+JWls6WBb7C1xlIGMVTPaH3hVblUd6QKQsCYyJN2vqG2w9LFe3OMu0rjMvq/1CIvi4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ob2FvfEp8iv9stfQyT/MLFxLj22SWZPv9pjnuFj6zw=;
 b=MOqZd7s2SZToAqVJu7U1j14W+/ze2CiJ3oj0DTD5LX4/gMx5p71jZAO83vKovmSlEMSloGkzXBbJuvVLN+DGmYnv4nB2ULQ5ESffLza2ePMf8gukp254288rzO5v4KHZbq1+stHABNETwTLm36JnPPASWvNsfscS9iI3BabExeP2junUmvPmS8ShrngJjGrquEQZW/at3GYAqvDVO8Urjfd7ld3plVaw0xTP08FDkUzvQxOuoQ27kJFkM/dFh/kP7dvx7uchXcWACLjBnZ3vnKIYMEJUzVcEfN9RvijcVnAcu1oxg01VLemGFKsyXz1xoDLelgZ2Gt81ircGHwLsoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ob2FvfEp8iv9stfQyT/MLFxLj22SWZPv9pjnuFj6zw=;
 b=I4e8minnM9GK5IiTxNDPuvboe7Fc/iweOmuBAQa+qvXJAVys7vIakMBJeX8skBluweh6PGmtzxgFfKH2oGhKz3MEMh4kT4m8+VicMbvOSZqIUkDUt+/xi0erDBwo356IpJ6Xx0ql1MSuh9W0bu6hd8tafFbbSdRJ0NfC3w9M5p0=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2925.eurprd04.prod.outlook.com (10.175.24.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Thu, 10 Oct 2019 06:55:32 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9024:93e:5c3:44b2]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9024:93e:5c3:44b2%7]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 06:55:32 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Anson Huang <anson.huang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "swboyd@chromium.org" <swboyd@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 2/2] net: fec_ptp: Use platform_get_irq_xxx_optional() to
 avoid error message
Thread-Topic: [PATCH 2/2] net: fec_ptp: Use platform_get_irq_xxx_optional() to
 avoid error message
Thread-Index: AQHVforamvMhoeXRzUmo7L8WJtBhgadTcjyA
Date:   Thu, 10 Oct 2019 06:55:32 +0000
Message-ID: <VI1PR0402MB3600BABFA79F76C65FA511ADFF940@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
 <1570616148-11571-2-git-send-email-Anson.Huang@nxp.com>
In-Reply-To: <1570616148-11571-2-git-send-email-Anson.Huang@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5dff17fc-8b28-4401-11f7-08d74d4ed85c
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR0402MB2925:|VI1PR0402MB2925:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2925A793767A0E7982D0585FFF940@VI1PR0402MB2925.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(229853002)(446003)(7736002)(66066001)(55016002)(11346002)(64756008)(76176011)(9686003)(7696005)(2501003)(15650500001)(66446008)(14454004)(186003)(478600001)(305945005)(26005)(74316002)(486006)(476003)(52536014)(110136005)(6436002)(71200400001)(71190400001)(8936002)(81166006)(81156014)(66476007)(33656002)(86362001)(14444005)(2201001)(4326008)(25786009)(6506007)(8676002)(5660300002)(66556008)(3846002)(316002)(66946007)(76116006)(99286004)(6116002)(102836004)(2906002)(6246003)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2925;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OnKh5Tc1T2l+7hUWVtL7E1WzGAEkkYRK0Dift7Nbgz07G4v9T/7AvcLxkQqPFQJ6yPpCsdO2v3vlJe3YALBv+ZvRZWFqK0iymGf1kdJM7wPfWGNjZm3S4cdzp9YckU6BqoilKneZOAkGcAO824n43XMswOMWw3PXbe2SA+WJ0N3OkJXV0fBQRABHJLuQgebEDGxH1rQGXeo39dGLIxpfPCdciBjeiucbQFC/Qbp5shsV0KqLlbr5iaYSzZLnZri7WqtgNDZbvYa+1ni3Mxd/MJy7AzqkKtICz0EdPdhF0CN74Jnlp28vJe4EpyLcs65NYhpJF4oioY0lSFmt6aRwx+vtxvpiRAFSybLDqdZZ+uDt/+oJ03fpdCbUIFsmVkHhVNnMPLXCy7wcTTxxaI/6pdbgcUpo+VFIOSGG9/qHT6g=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dff17fc-8b28-4401-11f7-08d74d4ed85c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 06:55:32.7655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i29pEoMnH+CJqJR21Jyc2nC9iA3sfUwtHSERO+UPY/t3+m1sTVynKQ2E6Qsxuk5ggshc9DsU2kbjQqs8VriiAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2925
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com> Sent: Wednesday, October 9, 2019 6:=
16 PM
> Use platform_get_irq_byname_optional() and platform_get_irq_optional()
> instead of platform_get_irq_byname() and platform_get_irq() for optional
> IRQs to avoid below error message during probe:
>=20
> [    0.795803] fec 30be0000.ethernet: IRQ pps not found
> [    0.800787] fec 30be0000.ethernet: IRQ index 3 not found
>=20
> Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to
> platform_get_irq*()")
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_ptp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
> b/drivers/net/ethernet/freescale/fec_ptp.c
> index 19e2365..945643c 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -600,9 +600,9 @@ void fec_ptp_init(struct platform_device *pdev, int
> irq_idx)
>=20
>  	INIT_DELAYED_WORK(&fep->time_keep, fec_time_keep);
>=20
> -	irq =3D platform_get_irq_byname(pdev, "pps");
> +	irq =3D platform_get_irq_byname_optional(pdev, "pps");
>  	if (irq < 0)
> -		irq =3D platform_get_irq(pdev, irq_idx);
> +		irq =3D platform_get_irq_optional(pdev, irq_idx);
>  	/* Failure to get an irq is not fatal,
>  	 * only the PTP_CLOCK_PPS clock events should stop
>  	 */
> --
> 2.7.4

