Return-Path: <netdev+bounces-9062-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F35726FEC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77E7E1C20E6D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E32B3922F;
	Wed,  7 Jun 2023 21:03:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A99134CC3
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:03:15 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021022.outbound.protection.outlook.com [52.101.57.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F522703;
	Wed,  7 Jun 2023 14:03:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG2SHbHmBKa+4qRwFPrALVvqk7Uh2L9B6Ho9KyAN8SpXU/vDhmbAj4APRmnDCtL+rci+srjdCuKH2uyomZu/2IUmdIuacK+U889ZA20yop1olQB0QAfNCuNDeftpBbyhAF8NpVtanvCs+rYSApqfOi+iAprq0CbznFY58tjsJ3343egoO3C9LlYyngDVnTpW3y6SCYCYAcHLmmZafmveEeyerD0VRniWeWY1RX+e1grqPNF3WwpWEm+raF+HvfIcASYY4Tm33fuajah5t9TsVw8T9gjJOkNTUDX7NpsxxsktW+YMl2xGoT6H+EmYTnYFWcASRMOysU8zqpFipvMHww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhBj+/8BqTeSE9lYn+CqBF14RT3762idI8J8M1OFCyk=;
 b=cPONF9hhhDjGmliDO2BS+rdIxS0dc86rGTz78DdtjMUx7khavwhjGfqFvcF0H3rhaWc4gbP3QNi5RSJvbwXv/YiHgpwBqWkPml7A0ClTJ1YK1TO6v3PXxwyqH13hpliTerWd++ev/9gn2gtqrw5V1/krl+UNBJYpnp/IPsehZ3T2bdw5iIEe7LLS6TQV/NbQ6NkQfyQwcapKCAORD6/nx9jWM93GPnBJ6ZAm7BhIui+sZW6skEwK8+zi9e6POWz380pczg8uObvFQjbk/dYcbmKb9uSq/fxn+UWM1FtK6T/pkoHRer6xeBHpVnnIWz9/ZNJ7Wm+D2VNmX/06VHMEfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhBj+/8BqTeSE9lYn+CqBF14RT3762idI8J8M1OFCyk=;
 b=Yvwm7POlTqVpBxlPMbZQhusUJcxhGMdO4AUFgxEjcuBJ4pjc6dcKzT684b7Wp5qe4ZGZL6rju2fzx6gmnFi7hoXZUUAsszpl8I/gXZ6WX9FQWDj7NXRsobyvPr+JNVcUl2wPtK13f2YJ8hEitJK8ga5R9XSNBaAYb3UslQxu9vg=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by CH2PR21MB1398.namprd21.prod.outlook.com (2603:10b6:610:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.11; Wed, 7 Jun
 2023 21:03:09 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::86cc:ee17:391f:9e45]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::86cc:ee17:391f:9e45%4]) with mapi id 15.20.6500.004; Wed, 7 Jun 2023
 21:03:08 +0000
From: Long Li <longli@microsoft.com>
To: Wei Hu <weh@microsoft.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Ajay Sharma <sharmaajay@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, KY
 Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "vkuznets@redhat.com"
	<vkuznets@redhat.com>, "ssengar@linux.microsoft.com"
	<ssengar@linux.microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>
Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Topic: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Index: AQHZmIoxGgRZCanZmkK6Z33s8kWpWa9/0eVw
Date: Wed, 7 Jun 2023 21:03:07 +0000
Message-ID:
 <PH7PR21MB32634CB06AFF8BFFDBC003B3CE53A@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <20230606151747.1649305-1-weh@microsoft.com>
In-Reply-To: <20230606151747.1649305-1-weh@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6ddf424f-7835-43f4-b969-27a83fd42970;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-07T20:49:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|CH2PR21MB1398:EE_
x-ms-office365-filtering-correlation-id: 236e2a01-0e66-4fa5-fb33-08db679a9830
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 0DAQKGtxLAlGPs4XoGasl+GdLWnsBkGajSolIiCTG/8dbNZDlqFgcQxNoAFjhxPajPrCuBxugRmhDPLeHsHxm5CVR3/wcaPdhYGXo4vYZ8+VU1uR9UwJe/bSN6/7GHjV2N2UghEmbo2+8LQ6uUw1Yasu74fEyZ6mCHCAGvdKiy9ILG1hJksnLDJ2i4a+BoqWe3xbV7/2YrfUkCRJA5/AJ9lkbVGCZllgrEzoz7VKBEfYUbxi+AbKyE43ciwx4R9jg03vuAxQnkbOJp7Ws3tZffRrGeKM/nUR3FlbAqk5EbSAsEDEa++KiWqCRmuCy9atNPGjYO86cM/Ktb185SPcePEtcWT5KuSAHME2HA0x9CY/9G7IcOdZNl7MhjzsgjNTjy4XFPTdX7eOjS6yZPWG3tAJQkDj8/B3y6P75dgl2KhlSWbpHIsQucTBquwxxXmPg+AUsfPVkEEIiDT5fqgww0AJ3nd6XOjkbe8/VAyinzjXjL5mBAVgzerg7QjiCueu4hmWTsJUweeWZDTksvUEwnzt8vTtAofRirXgrjm8Qj0aPCI09J5MW5G5eIlLuFuA7GPYQESueqUXA9HXebPi24ElVnPUBBjdTmtCyvVZ6tbIjjq4TSX8iqZGqSLiDK8rXUHHhvENHFMINhWNckV0zruXfaCD8/i9DWnVvIhLYUBaBcXP1BwZ5TcpV0ECCjPx
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199021)(76116006)(66946007)(8676002)(52536014)(5660300002)(8936002)(66899021)(71200400001)(66556008)(64756008)(66446008)(66476007)(110136005)(10290500003)(478600001)(41300700001)(7696005)(316002)(38100700002)(55016003)(82950400001)(82960400001)(921005)(122000001)(9686003)(38070700005)(6506007)(186003)(26005)(7416002)(8990500004)(83380400001)(86362001)(33656002)(2906002)(30864003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Mrea/3MQIhVXBmjmnLxlt8Q4oEKVwm0oS99G0SUCCBwDOuoMscfkXQjtF8En?=
 =?us-ascii?Q?oIfOqcYAMe2gU8micJwbo04qy6x4GirLdRbgak6YbMUM4xJP7aQfDfpWqSJl?=
 =?us-ascii?Q?X0KB3wR72ieT6y1SZWlcQ/cC5RZjKzrY7bW6dnQ5wRP7/kEOl+HEGDl7WuIA?=
 =?us-ascii?Q?NUq1tIDcltCyMDkQYwssg8gOMWQ2uRhmQyR68uR4jstA71Gly/8NLN2YafjZ?=
 =?us-ascii?Q?uZnaXPnVhdsTd2L+I/hAIAaR/AzdCKGhCymG69NwVgmjzT5V2V3mkl1qEQqe?=
 =?us-ascii?Q?thzaU8cA8pSJk3kR/GAZsVAqo/UxDtdB3Mq1fhrRHCurXvTJjWAV6y75en7T?=
 =?us-ascii?Q?EHmSLDi4taiOoD4h0DndSTTvG7tMIzjrqAD3vwdQp3ybZaJcsa/sGnGfp6tb?=
 =?us-ascii?Q?Hr463lKK5Wb36SJ7s60f5Ic2ahY98SUzQHRexCkLt8B041L5bmjjrR7jKP4a?=
 =?us-ascii?Q?LXRW2keuHUdRzddQj3EDHbndtjWWPcUfFCcav2dakbDMo1hE4p67U4cnlr7C?=
 =?us-ascii?Q?loyVeH7sWwM9xwG1IrPqUQEGIxBYSLZv/avu+UbZ63Ifiv7i+EMaNHw5FqGj?=
 =?us-ascii?Q?XCaMprQx82tnxsqSXQnRgBVflgu3PetgvwXE4jNNULEdzJs6knj67zg6BnaG?=
 =?us-ascii?Q?tjtxWPvFv2jILS6Nz2WoZ5npBsgjuOcS6feQn1L871TmwEL2hcJNLBaqP1es?=
 =?us-ascii?Q?p7hMrYn+YkV4YByaLktkPFsh1aGxvJo1gSWrjuyjagoIxE3G3iZTlnolDw+p?=
 =?us-ascii?Q?0Vq9zC4lRwRl5mlcE43rSHCCOlmTwwyMaPfqrfycCUC+VxYGPRVDV7RqdcSF?=
 =?us-ascii?Q?QhlBEVv3Rf077O9AGl7jrrA/Olpx46GuUEZ6DXO5Eq1GoJat9CR9fZlyE+bD?=
 =?us-ascii?Q?9RI2GR8w+DlP+C1Rcw++d5sxwbJNm4naYsv99mnO5Es+c9CVXHgK8UmADk2k?=
 =?us-ascii?Q?rFgiBTCTbt2pQ2MgZOdjIZlOyBOQ5D4HfV430mh+2oYqMU1pMt6hpgI2LhAk?=
 =?us-ascii?Q?0EHhgDCfeSd1l+ptANXlu4Czz34JELvahzWBAql6Yv8cMAyalQ2zz/sOb1jh?=
 =?us-ascii?Q?pgD+oIIC53A2T7iudbYoSLW8JlIlr9/im/3yVT2YCAUubptBt80mhsWsAaZ3?=
 =?us-ascii?Q?oF+BFGXIyHnF0O8EypfWEKjMkMt3wmXMSHjmxeAx36VwlSglIp2PMaeav28k?=
 =?us-ascii?Q?SYGGQqNE8P50OholtjkhPs2lFjei+K5ngjSJc4B/m/yQOJl2kZFmkIapFo3u?=
 =?us-ascii?Q?0v1Z/3RHsLMoGr+XKGbNUdX3FqTWAL3L/Lkz8efwcjZ9KsTqOe47LESCqT1J?=
 =?us-ascii?Q?sQ7/K5gmePa7+JAtSxlTPbPTxvEEuRG6vjeY/C8vM/wjbBY10RAQvpwTeXfv?=
 =?us-ascii?Q?pnfFdGWwIQ9Tccj1xx1SIkdNytbdTrjJOvFBPaetd/Wq0cxRtmzZ27kFZMr8?=
 =?us-ascii?Q?SWpPgAbaaJRuIX5l570++ZlMqeB3RPs2I80hYxGX2fK+D5U2Kfqhwf1rPk24?=
 =?us-ascii?Q?FkI+DZoXANlFNQOviKAMbq70KTIGYVdlTTHSA7z3xi5GHyIrlW4wcFy90p64?=
 =?us-ascii?Q?h7jse/3NVPy2w6REBKu6pgE/TcRMa8HquXyd4SPC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 236e2a01-0e66-4fa5-fb33-08db679a9830
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 21:03:07.8867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0oamqxwCuc1XF4m/jHE7ikadvcGyOxmGH0gehSWQsArZrcVw/x6J0zApazhPX6+PNucwXvbGWd2hR/qMS78R8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1398
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Subject: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
> driver.
>=20
> Add EQ interrupt support for mana ib driver. Allocate EQs per ucontext to=
 receive
> interrupt. Attach EQ when CQ is created. Call CQ interrupt handler when
> completion interrupt happens. EQs are destroyed when ucontext is dealloca=
ted.
>=20
> The change calls some public APIs in mana ethernet driver to allocate EQs=
 and
> other resources. Ehe EQ process routine is also shared by mana ethernet a=
nd
> mana ib drivers.
>=20
> Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>
> ---
>=20
> v2: Use ibdev_dbg to print error messages and return -ENOMEN
>     when kzalloc fails.
>=20
>  drivers/infiniband/hw/mana/cq.c               |  32 ++++-
>  drivers/infiniband/hw/mana/main.c             |  87 ++++++++++++
>  drivers/infiniband/hw/mana/mana_ib.h          |   4 +
>  drivers/infiniband/hw/mana/qp.c               |  90 +++++++++++-
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++--------
>  drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
>  include/net/mana/gdma.h                       |   9 +-
>  7 files changed, 290 insertions(+), 64 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index d141cab8a1e6..3cd680e0e753 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -12,13 +12,20 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struc=
t
> ib_cq_init_attr *attr,
>  	struct ib_device *ibdev =3D ibcq->device;
>  	struct mana_ib_create_cq ucmd =3D {};
>  	struct mana_ib_dev *mdev;
> +	struct gdma_context *gc;
> +	struct gdma_dev *gd;
>  	int err;
>=20
>  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	gd =3D mdev->gdma_dev;
> +	gc =3D gd->gdma_context;
>=20
>  	if (udata->inlen < sizeof(ucmd))
>  		return -EINVAL;
>=20
> +	cq->comp_vector =3D attr->comp_vector > gc->max_num_queues ?
> +				0 : attr->comp_vector;
> +
>  	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata-
> >inlen));
>  	if (err) {
>  		ibdev_dbg(ibdev,
> @@ -69,11 +76,32 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct
> ib_udata *udata)
>  	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibcq);
>  	struct ib_device *ibdev =3D ibcq->device;
>  	struct mana_ib_dev *mdev;
> +	struct gdma_context *gc;
> +	struct gdma_dev *gd;
> +
>=20
>  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	gd =3D mdev->gdma_dev;
> +	gc =3D gd->gdma_context;
>=20
> -	mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
> -	ib_umem_release(cq->umem);
> +
> +
> +	if (atomic_read(&ibcq->usecnt) =3D=3D 0) {
> +		mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);

Need to check if this function fails. The following code will call kfree(gc=
->cq_table[cq->id]), it's possible that IRQ is happening at the same time i=
f CQ is not destroyed.

> +		ibdev_dbg(ibdev, "freeing gdma cq %p\n", gc->cq_table[cq->id]);
> +		kfree(gc->cq_table[cq->id]);
> +		gc->cq_table[cq->id] =3D NULL;
> +		ib_umem_release(cq->umem);
> +	}
>=20
>  	return 0;
>  }
> +
> +void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq) {
> +	struct mana_ib_cq *cq =3D ctx;
> +	struct ib_device *ibdev =3D cq->ibcq.device;
> +
> +	ibdev_dbg(ibdev, "Enter %s %d\n", __func__, __LINE__);

This debug message seems overkill?

> +	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context); }
> diff --git a/drivers/infiniband/hw/mana/main.c
> b/drivers/infiniband/hw/mana/main.c
> index 7be4c3adb4e2..e4efbcaed10e 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -143,6 +143,81 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct
> ib_udata *udata)
>  	return err;
>  }
>=20
> +static void mana_ib_destroy_eq(struct mana_ib_ucontext *ucontext,
> +			       struct mana_ib_dev *mdev)
> +{
> +	struct gdma_context *gc =3D mdev->gdma_dev->gdma_context;
> +	struct ib_device *ibdev =3D ucontext->ibucontext.device;
> +	struct gdma_queue *eq;
> +	int i;
> +
> +	if (!ucontext->eqs)
> +		return;
> +
> +	for (i =3D 0; i < gc->max_num_queues; i++) {
> +		eq =3D ucontext->eqs[i].eq;
> +		if (!eq)
> +			continue;
> +
> +		mana_gd_destroy_queue(gc, eq);
> +	}
> +
> +	kfree(ucontext->eqs);
> +	ucontext->eqs =3D NULL;
> +
> +	ibdev_dbg(ibdev, "destroyed eq's count %d\n", gc->max_num_queues); }

Will gc->max_num_queues change after destroying a EQ?

> +
> +static int mana_ib_create_eq(struct mana_ib_ucontext *ucontext,
> +			     struct mana_ib_dev *mdev)
> +{
> +	struct gdma_queue_spec spec =3D {};
> +	struct gdma_queue *queue;
> +	struct gdma_context *gc;
> +	struct ib_device *ibdev;
> +	struct gdma_dev *gd;
> +	int err;
> +	int i;
> +
> +	if (!ucontext || !mdev)
> +		return -EINVAL;
> +
> +	ibdev =3D ucontext->ibucontext.device;
> +	gd =3D mdev->gdma_dev;
> +
> +	gc =3D gd->gdma_context;
> +
> +	ucontext->eqs =3D kcalloc(gc->max_num_queues, sizeof(struct mana_eq),
> +				GFP_KERNEL);
> +	if (!ucontext->eqs)
> +		return -ENOMEM;
> +
> +	spec.type =3D GDMA_EQ;
> +	spec.monitor_avl_buf =3D false;
> +	spec.queue_size =3D EQ_SIZE;
> +	spec.eq.callback =3D NULL;
> +	spec.eq.context =3D ucontext->eqs;
> +	spec.eq.log2_throttle_limit =3D LOG2_EQ_THROTTLE;
> +	spec.eq.msix_allocated =3D true;
> +
> +	for (i =3D 0; i < gc->max_num_queues; i++) {
> +		spec.eq.msix_index =3D i;
> +		err =3D mana_gd_create_mana_eq(gd, &spec, &queue);
> +		if (err)
> +			goto out;
> +
> +		queue->eq.disable_needed =3D true;
> +		ucontext->eqs[i].eq =3D queue;
> +	}
> +
> +	return 0;
> +
> +out:
> +	ibdev_dbg(ibdev, "Failed to allocated eq err %d\n", err);
> +	mana_ib_destroy_eq(ucontext, mdev);
> +	return err;
> +}
> +
>  static int mana_gd_destroy_doorbell_page(struct gdma_context *gc,
>  					 int doorbell_page)
>  {
> @@ -225,7 +300,17 @@ int mana_ib_alloc_ucontext(struct ib_ucontext
> *ibcontext,
>=20
>  	ucontext->doorbell =3D doorbell_page;
>=20
> +	ret =3D mana_ib_create_eq(ucontext, mdev);
> +	if (ret) {
> +		ibdev_dbg(ibdev, "Failed to create eq's , ret %d\n", ret);
> +		goto err;
> +	}
> +
>  	return 0;
> +
> +err:
> +	mana_gd_destroy_doorbell_page(gc, doorbell_page);
> +	return ret;
>  }
>=20
>  void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext) @@ -240,6
> +325,8 @@ void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
>  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
>  	gc =3D mdev->gdma_dev->gdma_context;
>=20
> +	mana_ib_destroy_eq(mana_ucontext, mdev);
> +
>  	ret =3D mana_gd_destroy_doorbell_page(gc, mana_ucontext->doorbell);
>  	if (ret)
>  		ibdev_dbg(ibdev, "Failed to destroy doorbell page %d\n", ret);
> diff --git a/drivers/infiniband/hw/mana/mana_ib.h
> b/drivers/infiniband/hw/mana/mana_ib.h
> index 502cc8672eef..9672fa1670a5 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
> @@ -67,6 +67,7 @@ struct mana_ib_cq {
>  	int cqe;
>  	u64 gdma_region;
>  	u64 id;
> +	u32 comp_vector;
>  };
>=20
>  struct mana_ib_qp {
> @@ -86,6 +87,7 @@ struct mana_ib_qp {
>  struct mana_ib_ucontext {
>  	struct ib_ucontext ibucontext;
>  	u32 doorbell;
> +	struct mana_eq *eqs;
>  };
>=20
>  struct mana_ib_rwq_ind_table {
> @@ -159,4 +161,6 @@ int mana_ib_query_gid(struct ib_device *ibdev, u32 po=
rt,
> int index,
>=20
>  void mana_ib_disassociate_ucontext(struct ib_ucontext *ibcontext);
>=20
> +void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq);
> +
>  #endif
> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 54b61930a7fd..e133d86c0875 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -96,16 +96,20 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp,
> struct ib_pd *pd,
>  	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp, ibqp);
>  	struct mana_ib_dev *mdev =3D
>  		container_of(pd->device, struct mana_ib_dev, ib_dev);
> +	struct ib_ucontext *ib_ucontext =3D pd->uobject->context;
>  	struct ib_rwq_ind_table *ind_tbl =3D attr->rwq_ind_tbl;
>  	struct mana_ib_create_qp_rss_resp resp =3D {};
>  	struct mana_ib_create_qp_rss ucmd =3D {};
> +	struct mana_ib_ucontext *mana_ucontext;
>  	struct gdma_dev *gd =3D mdev->gdma_dev;
>  	mana_handle_t *mana_ind_table;
>  	struct mana_port_context *mpc;
> +	struct gdma_queue *gdma_cq;
>  	struct mana_context *mc;
>  	struct net_device *ndev;
>  	struct mana_ib_cq *cq;
>  	struct mana_ib_wq *wq;
> +	struct mana_eq *eq;
>  	unsigned int ind_tbl_size;
>  	struct ib_cq *ibcq;
>  	struct ib_wq *ibwq;
> @@ -114,6 +118,8 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp,
> struct ib_pd *pd,
>  	int ret;
>=20
>  	mc =3D gd->driver_data;
> +	mana_ucontext =3D
> +		container_of(ib_ucontext, struct mana_ib_ucontext, ibucontext);
>=20
>  	if (!udata || udata->inlen < sizeof(ucmd))
>  		return -EINVAL;
> @@ -180,6 +186,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp,
> struct ib_pd *pd,
>  	for (i =3D 0; i < ind_tbl_size; i++) {
>  		struct mana_obj_spec wq_spec =3D {};
>  		struct mana_obj_spec cq_spec =3D {};
> +		unsigned int max_num_queues =3D gd->gdma_context-
> >max_num_queues;
>=20
>  		ibwq =3D ind_tbl->ind_tbl[i];
>  		wq =3D container_of(ibwq, struct mana_ib_wq, ibwq); @@ -193,7
> +200,8 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_=
pd
> *pd,
>  		cq_spec.gdma_region =3D cq->gdma_region;
>  		cq_spec.queue_size =3D cq->cqe * COMP_ENTRY_SIZE;
>  		cq_spec.modr_ctx_id =3D 0;
> -		cq_spec.attached_eq =3D GDMA_CQ_NO_EQ;
> +		eq =3D &mana_ucontext->eqs[cq->comp_vector %
> max_num_queues];
> +		cq_spec.attached_eq =3D eq->eq->id;
>=20
>  		ret =3D mana_create_wq_obj(mpc, mpc->port_handle, GDMA_RQ,
>  					 &wq_spec, &cq_spec, &wq-
> >rx_object); @@ -207,6 +215,9 @@ static int mana_ib_create_qp_rss(struct
> ib_qp *ibqp, struct ib_pd *pd,
>  		wq->id =3D wq_spec.queue_index;
>  		cq->id =3D cq_spec.queue_index;
>=20
> +		ibdev_dbg(&mdev->ib_dev, "attached eq id %u  cq with
> id %llu\n",
> +			eq->eq->id, cq->id);
> +
>  		ibdev_dbg(&mdev->ib_dev,
>  			  "ret %d rx_object 0x%llx wq id %llu cq id %llu\n",
>  			  ret, wq->rx_object, wq->id, cq->id); @@ -215,6
> +226,27 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib=
_pd
> *pd,
>  		resp.entries[i].wqid =3D wq->id;
>=20
>  		mana_ind_table[i] =3D wq->rx_object;
> +
> +		if (gd->gdma_context->cq_table[cq->id] =3D=3D NULL) {
> +
> +			gdma_cq =3D kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
> +			if (!gdma_cq) {
> +				ibdev_dbg(&mdev->ib_dev,
> +					 "failed to allocate gdma_cq\n");
> +				ret =3D -ENOMEM;
> +				goto free_cq;
> +			}
> +
> +			ibdev_dbg(&mdev->ib_dev, "gdma cq allocated %p\n",
> +				  gdma_cq);
> +
> +			gdma_cq->cq.context =3D cq;
> +			gdma_cq->type =3D GDMA_CQ;
> +			gdma_cq->cq.callback =3D mana_ib_cq_handler;
> +			gdma_cq->id =3D cq->id;
> +			gd->gdma_context->cq_table[cq->id] =3D gdma_cq;
> +		}
> +
>  	}
>  	resp.num_entries =3D i;
>=20
> @@ -224,7 +256,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp,
> struct ib_pd *pd,
>  					 ucmd.rx_hash_key_len,
>  					 ucmd.rx_hash_key);
>  	if (ret)
> -		goto fail;
> +		goto free_cq;
>=20
>  	ret =3D ib_copy_to_udata(udata, &resp, sizeof(resp));
>  	if (ret) {
> @@ -238,6 +270,23 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp,
> struct ib_pd *pd,
>=20
>  	return 0;
>=20
> +free_cq:
> +	{
> +		int j =3D i;
> +		u64 cqid;
> +
> +		while (j-- > 0) {
> +			cqid =3D resp.entries[j].cqid;
> +			gdma_cq =3D gd->gdma_context->cq_table[cqid];
> +			cq =3D gdma_cq->cq.context;
> +			if (atomic_read(&cq->ibcq.usecnt) =3D=3D 0) {
> +				kfree(gd->gdma_context->cq_table[cqid]);
> +				gd->gdma_context->cq_table[cqid] =3D NULL;
> +			}
> +		}
> +
> +	}
> +
>  fail:
>  	while (i-- > 0) {
>  		ibwq =3D ind_tbl->ind_tbl[i];
> @@ -269,10 +318,12 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp=
,
> struct ib_pd *ibpd,
>  	struct mana_obj_spec wq_spec =3D {};
>  	struct mana_obj_spec cq_spec =3D {};
>  	struct mana_port_context *mpc;
> +	struct gdma_queue *gdma_cq;
>  	struct mana_context *mc;
>  	struct net_device *ndev;
>  	struct ib_umem *umem;
> -	int err;
> +	struct mana_eq *eq;
> +	int err, eq_vec;
>  	u32 port;
>=20
>  	mc =3D gd->driver_data;
> @@ -350,7 +401,9 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp,
> struct ib_pd *ibpd,
>  	cq_spec.gdma_region =3D send_cq->gdma_region;
>  	cq_spec.queue_size =3D send_cq->cqe * COMP_ENTRY_SIZE;
>  	cq_spec.modr_ctx_id =3D 0;
> -	cq_spec.attached_eq =3D GDMA_CQ_NO_EQ;
> +	eq_vec =3D send_cq->comp_vector % gd->gdma_context-
> >max_num_queues;
> +	eq =3D &mana_ucontext->eqs[eq_vec];
> +	cq_spec.attached_eq =3D eq->eq->id;
>=20
>  	err =3D mana_create_wq_obj(mpc, mpc->port_handle, GDMA_SQ,
> &wq_spec,
>  				 &cq_spec, &qp->tx_object);
> @@ -368,6 +421,26 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp,
> struct ib_pd *ibpd,
>  	qp->sq_id =3D wq_spec.queue_index;
>  	send_cq->id =3D cq_spec.queue_index;
>=20
> +	if (gd->gdma_context->cq_table[send_cq->id] =3D=3D NULL) {
> +
> +		gdma_cq =3D kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
> +		if (!gdma_cq) {
> +			ibdev_dbg(&mdev->ib_dev,
> +				  "failed to allocate gdma_cq\n");
> +			err =3D -ENOMEM;
> +			goto err_destroy_wqobj_and_cq;
> +		}
> +
> +		pr_debug("gdma cq allocated %p\n", gdma_cq);
Should use ibdev_dbg

Thanks,
Long

