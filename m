Return-Path: <netdev+bounces-6512-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F11716BCB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5BA91C20846
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624022A9CC;
	Tue, 30 May 2023 18:01:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2CA1EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:01:23 +0000 (UTC)
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020025.outbound.protection.outlook.com [52.101.56.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259F58F;
	Tue, 30 May 2023 11:01:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rzxw208emYC3tOC9Pvf3fsh4JDxajTyHPmFrQW+W1pYDEb9S6+wOlcZNMEvGuJFtCd5cVW6lCqzU6UZrvpY7GlscMOVW9KFQAlHXb4gwMbbVoH+mRdSbzwfq/mUJFAxlET99obSVYV3eij8flr22d+YNvYhq02JrtAQVK0O5BJ9HCOnFHNoQ1pOo6v5kz05cyPkysLkzicOGoZSfHu5ToykHk8bUHnJ1e5v54LZo0j+9lpk/powpGPYUy1DTjaalxFk5mFkHGY3Sn8dGW3yNhGmiPmuGBjQna/Kd45fjn7MJKXXvyo67sh4xhUZretmMTx8II2YqOU/UbCRlIp6SsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9PTtBfrkz1Czkr0bfwVxSMNubhlpO87yWIENZcJ2qI=;
 b=UPHwl1lQO4LhGL5OHsAd5d+HvCKnSUrKmPjkvUnt06x1uwv2NdQK9zdfTB7awqQfa/dsQ7H+AcVxX5afv34hfXxCADG3DxfeVWIpClGD7GEw/FnBhIb6su8Sn7o1HkegAZan7zCIQqYDa07McW9CzBtE/mpsHM6DDVcluf/iM6qf167+kLIEMzrJFdaJE8MxVR2LXOnPsEP6fxXAMHfPZSZe4IOboi5zdimOSg4SMZ/YctkiLlMfsynZk19VX09HJUoyTXN78VA9X0scjsF5tOZ3fU6ti0VLiMgg68ZefuN8pVkpCzRKUk01R8QwmsbSNuWuTO5HdWVCh1h3SCYgzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9PTtBfrkz1Czkr0bfwVxSMNubhlpO87yWIENZcJ2qI=;
 b=JgdMckURj7PLIj/UbUO6bOivBq10eyOg3OMy2iPYNludd3+YETBRbQDDGj+bKykf/g59oxzUy21qMA3XGExjlEcyVtdg+BHkko7m0g6htBGkyZXpmerSEP9rutbtOMLmaFuj6NULKzncmOhDp5MtNqxN5cqIgiee6jzSPZVSugQ=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH0PR21MB1325.namprd21.prod.outlook.com (2603:10b6:510:100::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.6; Tue, 30 May
 2023 18:01:18 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::804c:6583:2027:9e91]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::804c:6583:2027:9e91%6]) with mapi id 15.20.6455.015; Tue, 30 May 2023
 18:01:18 +0000
From: Long Li <longli@microsoft.com>
To: "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Ajay Sharma
	<sharmaajay@microsoft.com>, Dexuan Cui <decui@microsoft.com>, KY Srinivasan
	<kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Topic: [PATCH v2] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Index: AQHZhivtGKm6wcRr/UWubeSwATzZe69zNMgQ
Date: Tue, 30 May 2023 18:01:18 +0000
Message-ID:
 <PH7PR21MB3263791EA3BCB216183889A8CE4BA@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1684045095-31228-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1684045095-31228-1-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7e5ff0d2-7d6c-4c77-a651-bf14c6417a81;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-30T18:00:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|PH0PR21MB1325:EE_
x-ms-office365-filtering-correlation-id: cfb61ab4-362f-4a5e-8d4e-08db6137de1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 dbxCoBjUI2LU7I6N/aRTcYUqNZL3hP3R23QuNcbCL0S6C1uZsDM67riG6g58U5ymY0sPBRnW4yiKhZWRcIl2J5fbaBFfyIHUsdEN0Tflm0NPZeCLYVwFBPBAlB9AAPtm8OsPvz4gFHqd/7tDgnRRxp/tNLKCvx6mrz/rcVTyEy6iIM4uwrFnBoQPGBDRrGosnw6fs66pn6+v3Q3QFk4lUnRIESOJHE6ycVHoPmL/7SZ3+rh3HEDQbQCzDEbWMG5kl+vZ1/5otmY/tMk2oGDhjeqP8NSYOEWYOROq55cx8KKfp/BzQQKQjWbiKIY1AYmfcv25bgZRrJUvhzXrNPHdyGZnP5G+nnDNJqY9tM5VkcM4A7qUkG6V3mLqXzQwtHvWVAo+V0X4XUic9vJ76oV8+TOc5BgNvSHdd176GECwhKZkO76nPLitxQ3kwHEKDDRZj7kw3j8uDq2+PSMPAJR4uPYZfHUA6mY1c8ESHzgAIuWQe3WH/zMknLQxbZYRinlmzFBeeCJVEemHm7dbiyFSkETcvMChOwixpG0xPmanuFkOJwWYvGYajzgct9CaOfULYPU9SSORk8aZVChIs34WFxbG1pJzhDqMiRIkC6Nlx99cdaZafkg9rTlzSxU6b+ubJW+YNfBNr+6ejKq8XjNGDg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199021)(8990500004)(83380400001)(2906002)(186003)(38070700005)(82960400001)(82950400001)(921005)(122000001)(38100700002)(55016003)(41300700001)(71200400001)(316002)(786003)(7696005)(5660300002)(86362001)(52536014)(8936002)(8676002)(478600001)(110136005)(54906003)(10290500003)(33656002)(64756008)(4326008)(66556008)(66476007)(76116006)(66946007)(66446008)(26005)(6506007)(53546011)(9686003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vtMz6iWrSmMDttxPWuiG82KXiP8cTA/LoWKaRYzVuDTq8oJXxM7DqEMdM2zZ?=
 =?us-ascii?Q?Hh28yvVf3wsMkYnYVbMQx12jYJgxSH6ttsDhPSxIh7IHObpdqAFXGc9cNLhn?=
 =?us-ascii?Q?DGyStXA3bjoBYPUGPq7l4oQ7CVzYtP3YYLQrWnsDMENARBdBiYEyxXprY5zJ?=
 =?us-ascii?Q?mipJxb3V1VbZBEoluTqW5iWV2G+cXzJXzBekewJBvA6BqyWfwoL6gg83ahw0?=
 =?us-ascii?Q?+G14EQexMH/0pw6H54+8U/+25rHIb1RzDwG6Gs7He/hfJNH+GPhntFC2eqqz?=
 =?us-ascii?Q?5JLYCti13o2+0qlvj66ALrGMCNMjKTB9Y5cdzrX6Cp3WGBKkumq3k8Frgsgg?=
 =?us-ascii?Q?Vs/qMUNqxij9sgEfBud2wuGFCgE6l6zYdiP4fuuWdZjExS5b4e6MuzSwsGcG?=
 =?us-ascii?Q?NoaQNCSTgFKqi2APYvzIP+pOgmCvREvIRWSzFnlt3Apyiy2us7sS5EtDtuSs?=
 =?us-ascii?Q?9a2AfYSwAZy2OmlFav45gSueXulWk4nnL14pAFtzKTmsFlu/cpZhOxJfQowy?=
 =?us-ascii?Q?2XhiUOXXakl2E0haVTb4Ph7oHve2m1EKPbFDmPsoZyuTcLX9SQHlITuSIK/a?=
 =?us-ascii?Q?93WJgbPj/xI8ut4WrFMpqayhDme2J5TkZ+m+tJsSWzGGmMI7WW2cX+HauB2G?=
 =?us-ascii?Q?yMm6G4vOKHSE3gXV5WVtQgcntPIm8teR/j2cDV3tgp3EdRs8e0IMPPgvTAuX?=
 =?us-ascii?Q?u5VYl/eR/lkB+HR3aGPcQh2Jh3ILEo6js8K9KVP9Iqe8AHLRuFbxWz8TilPi?=
 =?us-ascii?Q?fe6X3OcHgMfj3fmICEBd16lkKUc37ClDUt/rT7yP52iUDi8WU6RalIIdAT9n?=
 =?us-ascii?Q?Nce6cNoAK5wIgKTxUmgdaX9zLB6/rgnr4OwKOY9IzjziiCdKtnLHBF14TiCe?=
 =?us-ascii?Q?h9KbbRbFr6umaI8m41hNJpruhTEzFdg06m3BrhZuFdr9BSAZYcVbvO9hKnf+?=
 =?us-ascii?Q?n6Rz3OwfM8Bzhq8o2Nspmw4rirHePj5v+2/QvvRKH/HFS9xQr7Lz83bJH+KL?=
 =?us-ascii?Q?H9kaaSLe/z/NReqUusexZJ2Z/GRU4R1iZ564g++zbanOnfvRmIFOLH4J9oXP?=
 =?us-ascii?Q?EziXC4+LSpZFsM6rMh2uERqZvJ0Uwaes+t8QtELok61EPw6NcYqwf69IQ99l?=
 =?us-ascii?Q?h2sVuPQ0MGefcHecrAo77JvnLnrNS80hMcsNzk16r375maT+4RjYGgewtv6T?=
 =?us-ascii?Q?fJfrUuwW6diXKDaDMmY1tj+UM5wepisB58HQn55KQEU6qpwEfqVFKX1Lctu1?=
 =?us-ascii?Q?cS+CAE/d1wYUywESfUyChCvRQ+lwnPORQD3yuAoYzMOggbXum6ENA/Ojb1mj?=
 =?us-ascii?Q?6siKfIIyxXcexpcI3QH9Thspe3zm8AfJAMjnTFvlsqnEIXieB9N7qoSlzWeZ?=
 =?us-ascii?Q?xkS5sN1LCpSYrvguPk292l6GiRArL73VqtK/HO4/50L9Vu21/AQkndag8j19?=
 =?us-ascii?Q?rVHU81/Ab7dLoZUrOZNx7puQaw3JVkL5K5tdnxmVqYS/bm2d2YJxvW570lEC?=
 =?us-ascii?Q?IBeioHSoXD/z93YgM7iD3ryPvQeOK/37UO3aZflY9Q/Iv1Bynu0FNGdE0M1a?=
 =?us-ascii?Q?87cNC7S9XCcfzb42feI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb61ab4-362f-4a5e-8d4e-08db6137de1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 18:01:18.0445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2e2pcVPRi6UvhyLOazJ4bzlGl2xCNuzge0k6KgJegD9oB0gSKv2ZQEnQ+oF1bWKdcoXse2JFT7sroktp2mHZ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1325
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Leon,

If the v2 version of the patch looks good, can you pick it up for rdma-next=
?

Thanks,
Long

> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Saturday, May 13, 2023 11:18 PM
> To: Jason Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> Ajay Sharma <sharmaajay@microsoft.com>; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Wei Liu <wei.liu@kernel.org>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Cc: linux-rdma@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [PATCH v2] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
> enable RX coalescing
>=20
> From: Long Li <longli@microsoft.com>
>=20
> With RX coalescing, one CQE entry can be used to indicate multiple packet=
s on
> the receive queue. This saves processing time and PCI bandwidth over the =
CQ.
>=20
> The MANA Ethernet driver also uses the v2 version of the protocol. It doe=
sn't
> use RX coalescing and its behavior is not changed.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>=20
> Change log
> v2: remove the definition of v1 protocol
>=20
>  drivers/infiniband/hw/mana/qp.c               | 5 ++++-
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 5 ++++-
>  include/net/mana/mana.h                       | 4 +++-
>  3 files changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mana/qp.c
> b/drivers/infiniband/hw/mana/qp.c index 54b61930a7fd..4b3b5b274e84
> 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -13,7 +13,7 @@ static int mana_ib_cfg_vport_steering(struct
> mana_ib_dev *dev,
>  				      u8 *rx_hash_key)
>  {
>  	struct mana_port_context *mpc =3D netdev_priv(ndev);
> -	struct mana_cfg_rx_steer_req *req =3D NULL;
> +	struct mana_cfg_rx_steer_req_v2 *req;
>  	struct mana_cfg_rx_steer_resp resp =3D {};
>  	mana_handle_t *req_indir_tab;
>  	struct gdma_context *gc;
> @@ -33,6 +33,8 @@ static int mana_ib_cfg_vport_steering(struct
> mana_ib_dev *dev,
>  	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX,
> req_buf_size,
>  			     sizeof(resp));
>=20
> +	req->hdr.req.msg_version =3D GDMA_MESSAGE_V2;
> +
>  	req->vport =3D mpc->port_handle;
>  	req->rx_enable =3D 1;
>  	req->update_default_rxobj =3D 1;
> @@ -46,6 +48,7 @@ static int mana_ib_cfg_vport_steering(struct
> mana_ib_dev *dev,
>  	req->num_indir_entries =3D MANA_INDIRECT_TABLE_SIZE;
>  	req->indir_tab_offset =3D sizeof(*req);
>  	req->update_indir_tab =3D true;
> +	req->cqe_coalescing_enable =3D 1;
>=20
>  	req_indir_tab =3D (mana_handle_t *)(req + 1);
>  	/* The ind table passed to the hardware must have diff --git
> a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 06d6292e09b3..b3fcb767b9ab 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -972,7 +972,7 @@ static int mana_cfg_vport_steering(struct
> mana_port_context *apc,
>  				   bool update_tab)
>  {
>  	u16 num_entries =3D MANA_INDIRECT_TABLE_SIZE;
> -	struct mana_cfg_rx_steer_req *req =3D NULL;
> +	struct mana_cfg_rx_steer_req_v2 *req;
>  	struct mana_cfg_rx_steer_resp resp =3D {};
>  	struct net_device *ndev =3D apc->ndev;
>  	mana_handle_t *req_indir_tab;
> @@ -987,6 +987,8 @@ static int mana_cfg_vport_steering(struct
> mana_port_context *apc,
>  	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX,
> req_buf_size,
>  			     sizeof(resp));
>=20
> +	req->hdr.req.msg_version =3D GDMA_MESSAGE_V2;
> +
>  	req->vport =3D apc->port_handle;
>  	req->num_indir_entries =3D num_entries;
>  	req->indir_tab_offset =3D sizeof(*req);
> @@ -996,6 +998,7 @@ static int mana_cfg_vport_steering(struct
> mana_port_context *apc,
>  	req->update_hashkey =3D update_key;
>  	req->update_indir_tab =3D update_tab;
>  	req->default_rxobj =3D apc->default_rxobj;
> +	req->cqe_coalescing_enable =3D 0;
>=20
>  	if (update_key)
>  		memcpy(&req->hashkey, apc->hashkey,
> MANA_HASH_KEY_SIZE); diff --git a/include/net/mana/mana.h
> b/include/net/mana/mana.h index cd386aa7c7cc..1512bd48df81 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -581,7 +581,7 @@ struct mana_fence_rq_resp {  }; /* HW DATA */
>=20
>  /* Configure vPort Rx Steering */
> -struct mana_cfg_rx_steer_req {
> +struct mana_cfg_rx_steer_req_v2 {
>  	struct gdma_req_hdr hdr;
>  	mana_handle_t vport;
>  	u16 num_indir_entries;
> @@ -594,6 +594,8 @@ struct mana_cfg_rx_steer_req {
>  	u8 reserved;
>  	mana_handle_t default_rxobj;
>  	u8 hashkey[MANA_HASH_KEY_SIZE];
> +	u8 cqe_coalescing_enable;
> +	u8 reserved2[7];
>  }; /* HW DATA */
>=20
>  struct mana_cfg_rx_steer_resp {
> --
> 2.34.1


