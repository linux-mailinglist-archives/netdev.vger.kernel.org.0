Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21201137125
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgAJP0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:26:12 -0500
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:20245
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728141AbgAJP0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 10:26:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxVHubgsWjeOSoIkWP+f5d9AsY/mV59/0bPCoY4BzS/5FKh3wwMxY7oFrXFyq1NQ4G1vboUUksddRqW/CErCOUX6VSXEkB82XZ4b3Z2rG6P6xIbIUBlD/j9JyBCkybf75v8EYNwdMcd6DsMt4tEX/5C30L6uV52WivchxYII50wPAr/y0hWevztclgGMIiE1IlmOM/XIwP4OLtDYf/7//Gu/LzlkrxmzO0uIkP8ScqR37h0vuMK8yeVjjhLerUzcImdqhYpdxIF4kaCqsIHbF1/a086Mr92PJkTQXDtAG5mGaH69f+dnjH2NA+maJQ8TJlaIe8l25mnH5cKPxjNY4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5ZU/2wNnNvO5tCKBY6bDVys832k2AyReblQh/5hf9o=;
 b=HZ/U2lUig1vvm8yCe/p/lvIyh+GBx1yCrey1bHZ4LZ6TvlM1qFrk9EogmboZxEGLBcv2drUYIH3X2ek6KmQVM+7JDPjA5IOCzegDRXV+4wLFZyEMjtFUFxaHTcuef3PUlKnTqGQw7VPAzCRDiy0swz1T295Of5DKt1Q6VrcuWfKTzj5aC4mbhFjn2hg0BK77+todbu2iEdtyARivJ9o2fe9sHxtdsCwtzEWf7mAne1Q4EBkYhWGDRtbLjbfaolBcrlDVL5bUJhMQctMXCDatU6/uAbB07LAixZIOU9UKjvHmvsIANQxJZeWIZIDRhW0ku/4n2gE4zPfrLfKB90EsLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5ZU/2wNnNvO5tCKBY6bDVys832k2AyReblQh/5hf9o=;
 b=ffgEfOeHutMlhUOZh6GzAmlhl4g6XFjedoASU0Fc9EplHMS+0z5dsy6zlbLJrtTzw11ylIBkHNNXVU98EtX4atpfsceAZsDyW62xBnItSklq9esiMbb7v4E9KVB7zngg5/W7fW9CQTFjAd05IoXzobYVvmglDxY66sTfpxCaGLg=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6279.namprd02.prod.outlook.com (52.132.230.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 15:26:10 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 15:26:10 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 04/14] net: axienet: Improve DMA error handling
Thread-Topic: [PATCH 04/14] net: axienet: Improve DMA error handling
Thread-Index: AQHVx6y35Khes/KcW0SEYqGJBhT9tafkBDWQ
Date:   Fri, 10 Jan 2020 15:26:10 +0000
Message-ID: <CH2PR02MB7000EDAE2A7D85D50A52EE81C7380@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-5-andre.przywara@arm.com>
In-Reply-To: <20200110115415.75683-5-andre.przywara@arm.com>
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
x-ms-office365-filtering-correlation-id: c7a45f9a-8fea-4b2d-fa69-08d795e16bc4
x-ms-traffictypediagnostic: CH2PR02MB6279:|CH2PR02MB6279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6279620A1D61B3CD01C3C1E9C7380@CH2PR02MB6279.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39840400004)(136003)(346002)(396003)(13464003)(199004)(189003)(5660300002)(110136005)(8936002)(54906003)(7696005)(26005)(186003)(33656002)(6506007)(478600001)(66446008)(8676002)(66476007)(64756008)(66556008)(2906002)(76116006)(66946007)(316002)(81156014)(81166006)(86362001)(4326008)(52536014)(55016002)(71200400001)(53546011)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6279;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U7O3K3+EKD+Y7OtMrumMHxohZXAf1FUhxmPSKpK6wfinI7k3SS0mivphgUCMiZHcPitAA6CI55VzR7xJgCJpzHsGXj4rb12t2IzMyDIV+KDqaMnkDE2YAQqJ72eFonYfM9+IKwuRhJ3HdKSpngb7Z82rwK+GlRqN7THb9GhQ/FsErn+RM+BwJVWJpWQFAKBbCHJq8MxfVgXfSLQFKtUdrgUZihPcfBOcJjP617+8DaSOBHzTzv0UXZF9ckYAJuo6de/ZzofNJkz7RwBbgEBv8dihvB2rZxIOykAmBtKJZLGuP7jSfbIEwTNWnqQ5TV5VzHLkmbyfbXMusosF7ixjsUplq4yqxacHMqZlbNHVCo6YMUwzflgxfLQCXMKVEl38dOzcKY4jBIprHiEiGXVtkGepo52zK+RsvH67qkXwhLF6D/DK13PXLH5HoRThiacyXLtp4A5qY5MWpcWB0YpB7TNm1BH8AspcmHQrkSzDi18rcuAc/qrMBXyKfYMBkbkF
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a45f9a-8fea-4b2d-fa69-08d795e16bc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 15:26:10.3042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KNZUMPr9ikTgkfwSVtMr9y1pZ7Y4SqNM1MJA9Idj2gMnKu43Y6uR1oBqRRvKfhRwmsUnDpQHMJcR0XNrSqvDEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6279
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andre Przywara <andre.przywara@arm.com>
> Sent: Friday, January 10, 2020 5:24 PM
> To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> <radheys@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 04/14] net: axienet: Improve DMA error handling
>=20
> Since 0 is a valid DMA address, we cannot use the physical address to
> check whether a TX descriptor is valid and is holding a DMA mapping.
>=20
> Use the "cntrl" member of the descriptor to make this decision, as it
> contains at least the length of the buffer, so 0 points to an
> uninitialised buffer.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 7e90044cf2d9..ec5d01adc1d5 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -570,7 +570,7 @@ static void axienet_start_xmit_done(struct
> net_device *ndev)
>  				DMA_TO_DEVICE);
>  		if (cur_p->skb)
>  			dev_consume_skb_irq(cur_p->skb);
> -		/*cur_p->phys =3D 0;*/
> +		cur_p->cntrl =3D 0;
>  		cur_p->app0 =3D 0;
>  		cur_p->app1 =3D 0;
>  		cur_p->app2 =3D 0;
> @@ -1557,7 +1557,7 @@ static void axienet_dma_err_handler(unsigned
> long data)
>=20
>  	for (i =3D 0; i < lp->tx_bd_num; i++) {
>  		cur_p =3D &lp->tx_bd_v[i];
> -		if (cur_p->phys)
> +		if (cur_p->cntrl)
>  			dma_unmap_single(ndev->dev.parent, cur_p->phys,
>  					 (cur_p->cntrl &
>=20
> XAXIDMA_BD_CTRL_LENGTH_MASK),
> --
> 2.17.1

