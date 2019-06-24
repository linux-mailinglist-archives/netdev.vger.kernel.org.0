Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DC850A52
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfFXMEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:04:24 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:22859
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbfFXMEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 08:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azfQZcGsF9JLea3SaiQ1E4UT36SDCcxWndwBIoeclGU=;
 b=nD6lytFP9e0j9q8I8m3BtrmJncAUrof415CVU3VXyl9d+vof1xwd4Ct5ErF45kYF11U3WqSt6VrTPmLCO8k++7kbdO8ybr3NCRzRH45VKO1gI/vXWZfMvzOiD1Chhfa/vjmZKQkgCoEs+Zn9mHjDF1YbX1YvOycpUU5tR82khyQ=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4846.eurprd05.prod.outlook.com (20.177.50.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 12:04:20 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 12:04:20 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 12/12] IB/mlx5: Add DEVX support for CQ
 events
Thread-Topic: [PATCH rdma-next v1 12/12] IB/mlx5: Add DEVX support for CQ
 events
Thread-Index: AQHVJfmQvavTw2y7SkG9YQoAEAS33KaqvfAA
Date:   Mon, 24 Jun 2019 12:04:20 +0000
Message-ID: <20190624120416.GE5479@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-13-leon@kernel.org>
In-Reply-To: <20190618171540.11729-13-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:405:2::21) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [209.213.91.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4e26c4f-7417-403a-a647-08d6f89c1702
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4846;
x-ms-traffictypediagnostic: VI1PR05MB4846:
x-microsoft-antispam-prvs: <VI1PR05MB484658AAC08DB1CB25E8F22DCFE00@VI1PR05MB4846.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39860400002)(346002)(136003)(396003)(189003)(199004)(14444005)(71190400001)(102836004)(2906002)(386003)(6506007)(186003)(53936002)(486006)(99286004)(52116002)(76176011)(6512007)(476003)(26005)(33656002)(2616005)(25786009)(6916009)(66066001)(11346002)(478600001)(446003)(71200400001)(36756003)(6116002)(5660300002)(256004)(4326008)(1076003)(3846002)(68736007)(14454004)(6486002)(8936002)(81156014)(8676002)(305945005)(66476007)(66556008)(64756008)(66446008)(66946007)(316002)(54906003)(7736002)(73956011)(81166006)(86362001)(229853002)(6436002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4846;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y/kd5EKIWrgyxepRYRMxRHiT5W8qU2oaMyff9mR7WmMg07EkYwNpaK9KOJ5GCvSsbXGYY1AHOtDhzqp1UAJLUn8cZUliOnY8HYYC2fQ5oMaRXKuorcGR/V42OFtj3/mtadVjoHs40JDo1I+gI6CuaXXcPOMC8uCJXjeAjl1VzDw+AX03qrH+MHdICUdwqxL/0uK9T0yriD4MVhXVskpyt7eZDkqeGoIOdzl0g4IpYcKn2Ellf9A3iDw3QjTcaDFZMnVYOWRB8V1mn4bChbDz8hi8n+phfmvavWW3xI541gh6SiS4ICpSwL15ioAHYqxO4u6MT9RJaHJOQuhCBDLhLF2sIC+GedaGCVBnMZ3CND9aYuySRKIqIvhz5cGleZ4cw8mIHoZf+2ZbB4qI4ARfq1Iej9tZ3V9uCextQ1HTBV4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60761A0C778A3E4BAF0B53E1E2474CBF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e26c4f-7417-403a-a647-08d6f89c1702
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 12:04:20.6838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 08:15:40PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> Add DEVX support for CQ events by creating and destroying the CQ via
> mlx5_core and set an handler to manage its completions.
>=20
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/devx.c | 40 +++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index 49fdce95d6d9..91ccd58ebc05 100644
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -19,9 +19,12 @@
>  #define UVERBS_MODULE_NAME mlx5_ib
>  #include <rdma/uverbs_named_ioctl.h>
> =20
> +static void dispatch_event_fd(struct list_head *fd_list, const void *dat=
a);
> +
>  enum devx_obj_flags {
>  	DEVX_OBJ_FLAGS_INDIRECT_MKEY =3D 1 << 0,
>  	DEVX_OBJ_FLAGS_DCT =3D 1 << 1,
> +	DEVX_OBJ_FLAGS_CQ =3D 1 << 2,
>  };
> =20
>  struct devx_async_data {
> @@ -94,6 +97,7 @@ struct devx_async_event_file {
>  #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
>  struct devx_obj {
>  	struct mlx5_core_dev	*mdev;
> +	struct mlx5_ib_dev	*ib_dev;

This seems strange, why would we need to store the core_dev and the ib_dev
in a struct when ibdev->mdev =3D=3D core_dev?

Jason
