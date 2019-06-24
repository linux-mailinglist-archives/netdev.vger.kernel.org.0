Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D726650A2B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfFXLwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:52:13 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:33255
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727979AbfFXLwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 07:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNoFTa8xExQf7G/x59hhHhHHRXbVW5oqRFz6KoiZjPA=;
 b=BJZ4xzPdldSEQEs8hqM/eWu1nnaxnPm1ieBbSmjuDyXP0o6C9cGgrmS8En5AQJReJUQUBjQbB0/Ul+gtYKbjR1KHAuXDieeyJotVbObRTXX+rihqY1FXpxB4Vo/YqUt/n8Sew3wEiUANbrhypUQ+NPHXC5Ou6jiuF67SNYlppHk=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5485.eurprd05.prod.outlook.com (20.177.63.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 11:52:09 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 11:52:09 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 09/12] IB/mlx5: Register DEVX with mlx5_core
 to get async events
Thread-Topic: [PATCH rdma-next v1 09/12] IB/mlx5: Register DEVX with mlx5_core
 to get async events
Thread-Index: AQHVJfmSu0XgQnFVQEaPQvnXI+7VUqaquooA
Date:   Mon, 24 Jun 2019 11:52:09 +0000
Message-ID: <20190624115206.GB5479@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-10-leon@kernel.org>
In-Reply-To: <20190618171540.11729-10-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:2d::22) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [209.213.91.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e29ac30a-9254-46d3-a01b-08d6f89a6324
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5485;
x-ms-traffictypediagnostic: VI1PR05MB5485:
x-microsoft-antispam-prvs: <VI1PR05MB5485C235F05417B8E5535829CFE00@VI1PR05MB5485.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(346002)(136003)(396003)(199004)(189003)(5660300002)(478600001)(6506007)(53936002)(33656002)(2616005)(6486002)(81156014)(86362001)(14444005)(3846002)(256004)(8676002)(81166006)(7736002)(229853002)(2906002)(446003)(66446008)(11346002)(68736007)(66476007)(6916009)(486006)(66556008)(36756003)(71190400001)(71200400001)(476003)(73956011)(99286004)(64756008)(66946007)(54906003)(76176011)(102836004)(6512007)(1076003)(4744005)(52116002)(386003)(25786009)(6116002)(6246003)(6436002)(316002)(66066001)(14454004)(4326008)(8936002)(186003)(26005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5485;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PKEXMpCZjCkzPpqWIMrXwq8FqFBGuDtPLAnaXc0EEJHVWZ+bWQRSGWoEUOPE4QJZmHStReQ3Txg+WmrEEj6+ctB6Wa5jNEfjGbF/ikKpqlhFXDYZh0LaYU/VbiYErUqozXSp7QhnDoad3vXs7mkkBc9j0U4CNDLRtmhuaeqXJgB/7Avp5XVALjsIrnoCFWhjDXYzdy1zWWO0lJR2LyveCmErr0M3Oz3IlY+bkITkghqpzgCPzPklpPJ+Y6NVLeSnLH5OGNqB2IrLunT75w3mnhn1i4KWPTajMHgPpifAnKWuIH8wZPyILegs7gO92V7YmKqQQqRy/aEkKQfmZ9AW/GbO4rT5UydTWmWs87k2xpxFglnEAuGICU9wfVEFOfK/RcgiQQjzW6B/qRtbWhdGlNldxnyd9DQIfKYx79wJwAU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1F657B3CC5700043B1A9E3388CC60FC5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e29ac30a-9254-46d3-a01b-08d6f89a6324
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 11:52:09.4029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 08:15:37PM +0300, Leon Romanovsky wrote:
>  void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw=
/mlx5/mlx5_ib.h
> index 9cf23ae6324e..556af34b788b 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -944,6 +944,13 @@ struct mlx5_ib_pf_eq {
>  	mempool_t *pool;
>  };
> =20
> +struct mlx5_devx_event_table {
> +	struct mlx5_nb devx_nb;
> +	/* serialize updating the event_xa */
> +	struct mutex event_xa_lock;
> +	struct xarray event_xa;
> +};
> +
>  struct mlx5_ib_dev {
>  	struct ib_device		ib_dev;
>  	struct mlx5_core_dev		*mdev;
> @@ -994,6 +1001,7 @@ struct mlx5_ib_dev {
>  	struct mlx5_srq_table   srq_table;
>  	struct mlx5_async_ctx   async_ctx;
>  	int			free_port;
> +	struct mlx5_devx_event_table devx_event_table;

I really question if adding all these structs really does anything for
readability..

Jason
