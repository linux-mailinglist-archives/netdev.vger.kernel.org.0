Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE8EBDD9C
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 14:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405246AbfIYMB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 08:01:58 -0400
Received: from mail-eopbgr800083.outbound.protection.outlook.com ([40.107.80.83]:53095
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbfIYMB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 08:01:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HG+HZ8a0pj3/t9oddYIGrS6WmNIbajnaDvoW4LF9Jn6LcQw+PjWYgZQ8zBFs266H3i2LYSUNgO/yJbI2Qir7QdcZmN+EFWwjXBOgTJ5rD//LrMglnLIXdH/kVC497JlWl1KFGVtqGkqQqHdEZ735i1psYx12PlHvXt3yMlT81VVq14NN7h43bp+KbEN3s0j+JOF3twLc8e5XCkce4uuKeHwas6GmtwJH7Y4LbRtg4yTOlHblj2ZbZCQDiqkphrifrI5IyxiS2AW06Gj5MOP6AhX0DVN2BCYRxTcpx0oSF3V0kLsrKNn/1jsQJiC8JqTHxL5/rN2t3Swc1p3tKdyoog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZUgDGohGlbkzjdA/WQfGQZMwmUyPgO6/6Aj8MxWaSM=;
 b=WPuH7VHQ/P9smCcW2Q8yMlN8+Z/3pv4n2Y0ZCYwcWe0hmWHzAh4S147qQvaHgP6VTHo6W4iay+fOqaXyzCL/uT4vSY+NVsx/HfqW8c9nkZWcOnTGheL+DjgxLonBc4cXu++ykTGxSn3Tn6sQTBmxkArHNSv5NqtdGSeJDOoZFvn186E4DaYeP46eHteK5QJrDI9LPoklCtxAZcwxWEkWXRp8xdYQTLXxKVMrlemzCfqYT0qymQYDr04WYmKgHGwLnAcQUJ8Xo6UC+7u5v1wn5fPs3/0M9I0lxyJ71w8bGNVwO99uxLVnaM4r37bxjUgSWfTCPepj/SykMeK6Js2kzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZUgDGohGlbkzjdA/WQfGQZMwmUyPgO6/6Aj8MxWaSM=;
 b=i6bEIY3ars02kCooqyl7nofCd2Tiuc4q8Y0sNRJxbFkfuewUFVPEZ0SFtXG06NhEa0/brh8in/OiIoxShA69icqqCMM0+GEHft+bBftx0IiGdo3GcOSWYjceCoUNCUdCJt2kjhNZKZmMaW2JbazJI0hxlFFEuQdi5Y1cWQwvmNE=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6582.namprd02.prod.outlook.com (20.180.16.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Wed, 25 Sep 2019 12:01:54 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::3515:e3a7:8799:73bd]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::3515:e3a7:8799:73bd%2]) with mapi id 15.20.2284.023; Wed, 25 Sep 2019
 12:01:54 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Alvaro G. M" <alvaro.gamez@hazent.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net] net: axienet: fix a signedness bug in probe
Thread-Topic: [PATCH net] net: axienet: fix a signedness bug in probe
Thread-Index: AQHVc5BUuzLTI9AvlEK4NG8QqGY9j6c8SdyA
Date:   Wed, 25 Sep 2019 12:01:54 +0000
Message-ID: <CH2PR02MB700081E7F84C502F36E6FBEFC7870@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20190925105911.GI3264@mwanda>
In-Reply-To: <20190925105911.GI3264@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a93abca0-6f71-4a18-bb4e-08d741b028ad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CH2PR02MB6582;
x-ms-traffictypediagnostic: CH2PR02MB6582:|CH2PR02MB6582:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6582F66C01AE31DE1508743EC7870@CH2PR02MB6582.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(189003)(199004)(13464003)(110136005)(229853002)(6436002)(86362001)(76176011)(14454004)(478600001)(7696005)(71190400001)(9686003)(25786009)(71200400001)(99286004)(66066001)(186003)(14444005)(486006)(256004)(446003)(11346002)(476003)(6506007)(53546011)(55016002)(76116006)(33656002)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(102836004)(6246003)(81166006)(81156014)(26005)(8676002)(2906002)(54906003)(74316002)(6116002)(8936002)(3846002)(305945005)(52536014)(316002)(5660300002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6582;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CVssfJpfdop3xzs7IcGzz7gaOtynGw+UlF3P0l5UzltYydaMoFwcFIG1PdypF4AwWY2RC2DScqvw+Ej50QevChLpEt9JVWelhtll0rGE8C2kCJwZ0IZTaRODDCKFVgQDXSBualWG2bDhLKhzHRuFCfTVnUq2+WH4gzNoeHGZWNNhRgjzeiXiE8+dF1mrCSwSdNZNGM6KR3xWUYeGeeGH3F4hZS+PS8IFf1bOxWVajgMfwTLU5foPw76wiSV4qSuFM89UhDd8IbqOgX3x5AIm5qrfEkb+sEj+XOaOBir/k40ThV6L9tQawx6WTkxlfAfSHLYIfJ75pj3h+WgGBi8ZGYgAeJyUu18KZMFm2vark3NzrZ4yroFp/nuYHTWQkng2rlR7PNxMP4hOQHErsHCQuyDt9BUae9V4U1L5lOMzmVQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a93abca0-6f71-4a18-bb4e-08d741b028ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 12:01:54.7707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DaC/BiFVxPRMI9Y2rW8sTv67kBuXB0g/tEFD5qRqSWNUl2CLWZ75s0BFx7INTakRRHjykPYiNu7IvPnwSgWFiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6582
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Wednesday, September 25, 2019 4:29 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>; Alvaro G. M
> <alvaro.gamez@hazent.com>
> Cc: David S. Miller <davem@davemloft.net>; Michal Simek
> <michals@xilinx.com>; Russell King <linux@armlinux.org.uk>;
> netdev@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [PATCH net] net: axienet: fix a signedness bug in probe
>=20
> The "lp->phy_mode" is an enum but in this context GCC treats it as an
> unsigned int so the error handling is never triggered.
>=20
> Fixes: ee06b1728b95 ("net: axienet: add support for standard phy-mode
> binding")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 4fc627fb4d11..676006f32f91 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1762,7 +1762,7 @@ static int axienet_probe(struct platform_device
> *pdev)
>  		}
>  	} else {
>  		lp->phy_mode =3D of_get_phy_mode(pdev->dev.of_node);
> -		if (lp->phy_mode < 0) {
> +		if ((int)lp->phy_mode < 0) {
>  			ret =3D -EINVAL;
>  			goto free_netdev;
>  		}
> --
> 2.20.1

