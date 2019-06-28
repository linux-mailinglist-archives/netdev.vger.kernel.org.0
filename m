Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0966D59123
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfF1C0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:26:53 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:3087
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726476AbfF1C0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 22:26:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=XDJAR6K4cRJQQxnK3+tVBD3yXiPT+luj5+UIq+WtM6Ua2ZZCwB/nCB2dcCZ5Fnh0Ewy1dovP/O/mouD3lMFVyZTguRDdoTp5CBviCFF3lWprq1NrS7DPcUy2E6HI3Qzt2OeJv8PmanoLXmnpi0g7XZ6rXoHRa7GYwJNnys9zxkE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNe8FQY0oO0mUyMyJHV0bS74mcC1fkFw8/32dVb065k=;
 b=DHfbxZ2gFKMSAjX6r8Wnh7QxaUWsOqHvbfFx5Flr136zqJTw03IijxKQrBQVAFKn7yQkRokWblCEkUUP7opRnIVx617gu1tnCv2GtCGnf49KLSpBZ5nrdkxNzXsqzUJ/3OPMMgKDtquBPw5jnorfM8V8mr/wKLzVTB3FAujC9+U=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNe8FQY0oO0mUyMyJHV0bS74mcC1fkFw8/32dVb065k=;
 b=aeU3RBjfPQqkTp9njQsbtv9ye1OpsVKR+Y6FuI4egCEVySu6c75j95FU340fo4dotqA5aBhDQKXvEqc5pe9qyUqIPGLMicaJBt7ffexxUEMuNZF4Q0XybLsnB2WIZ9vsFiWV3paQq1nS7FeFUJVP6V7THLJchQycjfVkRJFSsJk=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2863.eurprd04.prod.outlook.com (10.175.20.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 02:26:49 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c8a7:d048:2a1a:8b67]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c8a7:d048:2a1a:8b67%7]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 02:26:49 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH 73/87] ethernet: freescale: Remove memset after
 dma_alloc_coherent
Thread-Topic: [EXT] [PATCH 73/87] ethernet: freescale: Remove memset after
 dma_alloc_coherent
Thread-Index: AQHVLRBMPnd9CZnblUeiibuiURDi+qawV5JQ
Date:   Fri, 28 Jun 2019 02:26:48 +0000
Message-ID: <VI1PR0402MB360017A5AA5A0E8470F44DE9FFFC0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20190627174641.6474-1-huangfq.daxian@gmail.com>
In-Reply-To: <20190627174641.6474-1-huangfq.daxian@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edc8f6ec-bf25-41f9-7102-08d6fb7012ea
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2863;
x-ms-traffictypediagnostic: VI1PR0402MB2863:
x-microsoft-antispam-prvs: <VI1PR0402MB2863100506235ABB81FF8FF3FFFC0@VI1PR0402MB2863.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:37;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(199004)(189003)(86362001)(2906002)(256004)(478600001)(446003)(76116006)(73956011)(33656002)(52536014)(99286004)(5660300002)(3846002)(6116002)(54906003)(4744005)(66446008)(74316002)(7736002)(66946007)(316002)(4326008)(66556008)(66476007)(66066001)(71190400001)(71200400001)(6916009)(64756008)(55016002)(6436002)(8936002)(6246003)(76176011)(229853002)(186003)(68736007)(102836004)(8676002)(25786009)(11346002)(486006)(7696005)(81156014)(53936002)(26005)(81166006)(9686003)(6506007)(14454004)(476003)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2863;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: u2tDQtCAIUxvZvrQ0uJq95qaXU9UY13Dp3aMtrjsTWtppmhzHijwOCN/KXJdL4Gowjcmut9aVucI/aCV+CMWoPEPL5szm1DgYL10YEc4+b1qSNKUWYIH9w9wk5N5XG+GZh8T6IzmbZkkO1z2t7BvwCV36B3tUitikqrNZdQVc3Pq8TIhfHV0soKXUhyUpFcB7SQKqz7+2RUIOHNmF4zkWBfFPsybLa3GCn9QxPfSWRWuLA+TmR+7mMQIIe5qzS+xB3rqmli8Z6jUhcf+oZuq4GuHQCZFZhs1xcqnQ9UNPjWkFvhEhtoJUZtNUEfKQfhTT0aLXZ51pYS3221VIjNe3K9B2ckReQl2Lj1ZreDpjD7++6yyrjfUWH6X67Te3vF8busiBsxSleyJSfNgoFVF+9DwDlbiVQ3CYekYGDNYzZU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc8f6ec-bf25-41f9-7102-08d6fb7012ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 02:26:48.9068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fugang.duan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fuqian Huang <huangfq.daxian@gmail.com> Sent: Friday, June 28, 2019 1=
:47 AM
> In commit af7ddd8a627c
> ("Merge tag 'dma-mapping-4.21' of
> git://git.infradead.org/users/hch/dma-mapping"),
> dma_alloc_coherent has already zeroed the memory.
> So memset is not needed.
>=20
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 38f10f7dcbc3..ec87b8b78d21 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3143,8 +3143,6 @@ static int fec_enet_init(struct net_device *ndev)
>                 return -ENOMEM;
>         }
>=20
> -       memset(cbd_base, 0, bd_size);
> -
>         /* Get the Ethernet address */
>         fec_get_mac(ndev);
>         /* make sure MAC we just acquired is programmed into the hw */
> --
> 2.11.0

