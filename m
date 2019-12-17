Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303B4122491
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfLQGTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:19:50 -0500
Received: from mail-eopbgr770057.outbound.protection.outlook.com ([40.107.77.57]:1344
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726609AbfLQGTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 01:19:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLadBOlkAIFObRM4x4eX9G9Kl4Y7FTm0rq9pVaW+VaJ9OMYwKCV3O0c6+zApYp3XGVupPUXLfkpFEY7PaypOiKtr0qUV/JBY9xIWBCL7VINmooJOTp4orhVZ547RzIgugc32HAsvsHjl57x2uzoHnyNGrswCCFkFMwHXNr0kdM7kYXvVzuN7seMhzzq5YuSw6+NyJ6vmpVY8boubrwENcZPosY+J6tLaJbGEDtzKETUaK/FjGXzFG1wipXoCBbkxVZ7zN//WRbGBIzFWf7lWeQo6kXqmLYHjtZRR0NMf+qbOyaPrs/L7yn5HZsAGKSGk9zCHhMAIyOHeCwwyz1nyWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bn3AftZ8aEQ6YBn1crep78sVVHw+eqyfnUX3pyYDo2o=;
 b=I5oey8oFhpD4Q3jTlBGwMR4cHr6atyWt0MajsQFkNPNiVuQG2kC4wldIfbgpp76gF5iq6KAiHqAznN/5tYjun6Q1yd4jk5JVm1Erhm8GPsKpkOnjwGyw7ZZDeyrb9Gx07aT9ToF6Ak6ijM80UFMIdtEZe/DLIALprn25J4MM5X29/t9YSfWJ+OdDD1676onE2xo+T9hdiTPMSAf1BKWwFefUcuye5WdfVkVeh6yYAsLUeHlsgAEtK4YB/t3xPHZ124xCqN0cIU72Zi5u5Cus+wZhkOGjAahynZz9sOADcg+BF6N+Al1Wfpg9xpKspPvmLEzca15rfrJl3Ufxi6nG5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bn3AftZ8aEQ6YBn1crep78sVVHw+eqyfnUX3pyYDo2o=;
 b=suvUOvnGorVyBlbzq5qL1zUG/5Qos6YEtsF5HbDtSQ5BLYNoCgxtAST7F9XSn4237u8WFCC+3gDGSZBWoxmp4drZflkzX3jOtQUXdFvvxBZC31QyCMjBUrGPEeNFj1A0wJtQ+BA7sQTMmwe3gV4r8bKl+fLgVGuT08udMJNP3LY=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB7095.namprd02.prod.outlook.com (20.180.11.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Tue, 17 Dec 2019 06:19:48 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::5d66:1c32:4c41:b087]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::5d66:1c32:4c41:b087%3]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 06:19:47 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
Subject: RE: [PATCH net-next 1/3] net: axienet: Propagate registration errors
 during probe.
Thread-Topic: [PATCH net-next 1/3] net: axienet: Propagate registration errors
 during probe.
Thread-Index: AQHVtD8/PHqqoL6sF0eYA6GsnGF+CKe92YtQ
Date:   Tue, 17 Dec 2019 06:19:47 +0000
Message-ID: <CH2PR02MB70009FEE62CD2AB6B40911E5C7500@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <cover.1576520432.git.richardcochran@gmail.com>
 <42ed0fb7ef99101d6fd8b799bccb6e2d746939c2.1576520432.git.richardcochran@gmail.com>
In-Reply-To: <42ed0fb7ef99101d6fd8b799bccb6e2d746939c2.1576520432.git.richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 48e50fea-5039-460e-31ce-08d782b91dec
x-ms-traffictypediagnostic: CH2PR02MB7095:|CH2PR02MB7095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB7095B51D88DE50C413F49168C7500@CH2PR02MB7095.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(13464003)(199004)(189003)(71200400001)(6506007)(478600001)(316002)(4326008)(33656002)(107886003)(8936002)(8676002)(81156014)(81166006)(110136005)(9686003)(76116006)(54906003)(52536014)(55016002)(66476007)(66556008)(66446008)(64756008)(66946007)(26005)(7696005)(5660300002)(86362001)(53546011)(2906002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB7095;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7/akhXLfIYA9BbgZhV991FxQN0UzIBK3tCWNQ74nT2lHaOVTSlmyW1f5taT9c1+LXOVWVLt5bjAvMcfyhLgiEZBom9hn878o/p0dZm6+y1SRQ9TkL12s2C5HqicDJ0HHWQdmX1uFdxqHNjaYbwecUfbG4zc4W2SNei0lmnO+BD7kUdXvttj5YDrecnLL0JD7ojkSpmbww1SWqQUehFmzu9FVYPUk3adv5XmjqPCKI2Jsp1mD0+PlrsWLdUOJ/olR9dgo0TTJIiYGbZ3V1wZ67ttiVyFZBVUbDyQQOgRt5xWv6jYRY7W4HxaTyMyYbzpyDxfA3vPSVr1a2s4NOoHJ0RG9VNMgFxlLAFyZwfPiIai7FIazhBkrjyNbBAAdWVSuYykVkufywvS0AGL/IZ7SuVrKfo+iuvBXx05zYU80M075WVHENRX0LAqbWzUeIhkaWD64d1Jb0JJGSLzFEmnYE+6x9JLyUnIWDopqOZUSzMrqHgpXwkTkt0Fo04TbMi7s
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e50fea-5039-460e-31ce-08d782b91dec
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 06:19:47.6085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5IR5qIMVkgRRrpEoN6wkkQJrWwlHhD8P4OqppcK+j8qBHIGn4w7C9jEKMJ9mFSZN6923X2i981PWHsEuVxWhng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, December 17, 2019 12:03 AM
> To: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org; David Miller
> <davem@davemloft.net>; Michal Simek <michals@xilinx.com>; Radhey
> Shyam Pandey <radheys@xilinx.com>
> Subject: [PATCH net-next 1/3] net: axienet: Propagate registration errors
> during probe.
>=20
> The function, axienet_mdio_setup(), calls of_mdiobus_register() which
> might return EDEFER_PROBE.  However, this error is not propagated to
EPROBE_DEFER.  In which scenario we are hitting probe_defer?

> the driver's probe method, and so deferred registration cannot happen.
> This patch fixes the issue by handling the error code properly.
>=20
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 20746b801959..53644abe52da 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1835,9 +1835,10 @@ static int axienet_probe(struct platform_device
> *pdev)
>  		}
>=20
>  		ret =3D axienet_mdio_setup(lp);
> -		if (ret)
> -			dev_warn(&pdev->dev,
> -				 "error registering MDIO bus: %d\n", ret);
> +		if (ret) {
> +			dev_err(&pdev->dev, "error registering MDIO
> bus\n");
Error handling for _mdio_setup failure seems ok. Minor nit- skip printing=20
message " error registering MDIO bus" for defer case.

> +			goto free_netdev;
> +		}
>  	}
>=20
>  	lp->phylink_config.dev =3D &ndev->dev;
> --
> 2.20.1

