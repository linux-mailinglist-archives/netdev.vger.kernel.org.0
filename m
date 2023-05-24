Return-Path: <netdev+bounces-5122-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 063F870FB93
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A523328111F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B02719E56;
	Wed, 24 May 2023 16:21:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B1819BC4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:21:43 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020015.outbound.protection.outlook.com [52.101.61.15])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1320097;
	Wed, 24 May 2023 09:21:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpEeFnUDgp3xUA+KrlSYkTvzUGUXCzvhepfTWxZ5PkVuWFZN5rZseQ76FeAIkwifxr/UivHWupDY3ZQLlr3Itz0hFluNYQ5UgwxjSUVT5+fDT4ZdtGNuVUmv3/Ik6kmZ6iP1dlHt9ccspU3cQLDtd23kZe3jG3daajVSSopxU+2d9jBbEB4xVn1sGzMCxpEhKGbOCDo2fgMpQc/wSaZ7uqIrve7d4GA48Ofu+YUFg35zweWXbbk3/Si7L+/w5CJPzL4OZnJnU5rJHDAXu+4iBxgDdWY2z1NXySAkvx1QfwxxWGb85kDTdHx8rBM9lp0UV8UOioqtivXBUf8JISJCTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3u9zbkto3riJuIIb2/rm0jmK0uqkf71tI7awqUGZXEc=;
 b=DIHzKEReH47xO77mRs8A3UjNbzD3t05OmzJR+Bn14W8YPg1lXPWc6VJy9uv8ancSjyXj/r3uGVUZu8anKJU814J3oaObPob+8ceGG9qtHpYt915Rne6pEAB0mv3jxZqXCFcd54ju3bV4d6V+UPY0LKMWemv9TsqT9WMq+BqL3utFiqmzgA2gP8yBeVKrO1bf/lxK2UF3mcUPUI/sJzKaIAjkFQ9L/jcTc4+M3WVLL2b3M/z8DV1jEd2xfxaoSlTDw7HxAu2lHDjvPXgvTORXxYJWhSe174KHsv15DCpJH6zfCQ4R4y0l6TZeffcD44omi0s80oWqoQc21urONajDtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3u9zbkto3riJuIIb2/rm0jmK0uqkf71tI7awqUGZXEc=;
 b=M1sB2ZDJ6Bso7iv/BKboUXMNOO2i7fG9yIcUOpeq2pkZE6e0Kfr7sMJ+lS5cbP2czf1Yby4N/6treqPvW8wkEehAUnNnAOGCMdlMLc/INsbuN0G9AwGb8AadDUduyQCmGI5J1KEXVNqF9eHO7m+XI0J3d+FpYl3T9RZhGVQJSDQ=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by SA0PR21MB2010.namprd21.prod.outlook.com (2603:10b6:806:132::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.13; Wed, 24 May
 2023 16:21:37 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900%5]) with mapi id 15.20.6433.013; Wed, 24 May 2023
 16:21:37 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li
	<longli@microsoft.com>, "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>, Steen Hegelund
	<steen.hegelund@microchip.com>, Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH v2] hv_netvsc: Allocate rx indirection table size
 dynamically
Thread-Topic: [PATCH v2] hv_netvsc: Allocate rx indirection table size
 dynamically
Thread-Index: AQHZjiYfytjH4W3iikuEzMDvTxCQnK9pkECQ
Date: Wed, 24 May 2023 16:21:37 +0000
Message-ID:
 <PH7PR21MB31160E7158B9EA4FF9DF1D53CA41A@PH7PR21MB3116.namprd21.prod.outlook.com>
References:
 <1684922230-24073-1-git-send-email-shradhagupta@linux.microsoft.com>
In-Reply-To:
 <1684922230-24073-1-git-send-email-shradhagupta@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=839751ef-aa99-4b8b-b533-1e9e48e45e1b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-24T15:41:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|SA0PR21MB2010:EE_
x-ms-office365-filtering-correlation-id: b8d067d4-009f-4de1-5dd6-08db5c72f30d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 QVL1CCfjX/o78BRnm/sfZjolNG9uyaThfIpfQFnNh2HZgVYf6E//eWIvyxri38WA2uJqky7DfKhEQXpRg6VUh3KGjmizGCKw/Y+SvjUOlO+cQ4wEPkB/EgCsmgiOoY2U8o/ToTe2twLxFfjhj1qMyvb5s7bCVs5sH6PzZZCkWekv3mspgY+5x8Vxnv6q4vG3CPaol1zEah8SfSKC0ReCET0ui3gQe4vkWz5OWsVIGyJmeZTJVxDP+tD9PJgY2v7kYgG8lFLEm82CR4AbCvza18IrED5+iPStffDju8V7VP7ZqJYgU1tid250ZRJrbCPo0i58XL13nwXzAdtIrTPa3zbMFoMfX8ClsIJMQQ8X2WoY5UCrI7wK3n4oO/Ua+0kxvHDrTB35tUdmFxbIcDAH0TrfVAeWS1fbTmxYqC8hMQG2WGEAgwYSSHkU8H9j5E7sd+xpN37rR9UDYchOy/FR0REBesQRddagodCh+Zpo/GT7rCv+cpAZHwMv5NoQq13GObf+4s2+e8lDDduKTCN2qMLDtXEONawXbIDqMy7NBtusMg4TalTVD+lmXVo8qqECKEa5WaPM1hXDRmuuqpB+Eai1oBQqdxIVQmeIX+dLyNQQ9GCf5jnW3cCWmHxg3jEu18PnmMYX4AVH7nntJP+XnECI6HozvGLNCyNuLS9B/ng=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(110136005)(54906003)(66446008)(4326008)(10290500003)(66476007)(64756008)(66556008)(66946007)(76116006)(8676002)(8936002)(7416002)(5660300002)(52536014)(26005)(53546011)(9686003)(6506007)(478600001)(316002)(71200400001)(786003)(41300700001)(7696005)(2906002)(186003)(8990500004)(83380400001)(82950400001)(122000001)(82960400001)(55016003)(33656002)(38070700005)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?dqTebIw0IOf/eOP9kaGo3JLYfDBIcDOZay3S4Bi4sfQt7Y7znQd3VUdgsUSZ?=
 =?us-ascii?Q?iDxGmHK9HoOkLM9v8fqMMgK3k5fdDP+DEqTZ7FYmJCQeczbqSxFj8OF2pPX4?=
 =?us-ascii?Q?z63FJCVNbLmVV6gRIP/NwUR1QZdrGCLdUDoiTxmMaBN8dJ3XIHWqINtYPG9j?=
 =?us-ascii?Q?gwiF2JAWPrUIGa0NFnrlUso8EDwICvTfAqMC3D/GBTYwvMnfjvDQrHl86dau?=
 =?us-ascii?Q?CEwAy2rAjCTEi8PwgOcSn5M1Q38LF7kYv6hNLc0YsWNKeNkF4UT5eAvtcOp3?=
 =?us-ascii?Q?NBaxlkvuGpEvvUIueXjdFS3A3zqUH3Dc+RDPI0P6xqr6FcAK2oe7inKOb5Dn?=
 =?us-ascii?Q?sgTUlAC3N/tvPNvnKiXqFV4sXohK9PznHUqOYBaJgYcmtOwFVQ2BmtbXimi/?=
 =?us-ascii?Q?a/ZfqLyOO7F/QBvacz+588iqTswCBXihl2ze9XxiKGyx++AHofRe5Pd1EDv9?=
 =?us-ascii?Q?vTWGYhFlpc3KRWv536NcIO299YXK0nctxUPL4DThwBgShfN5lwmM62MqSMNQ?=
 =?us-ascii?Q?X5vq9J/Q72LaI6WvK4r+DqemTzRkCRObXricCUaY7QIhpbOAIj0g9nSp0XWG?=
 =?us-ascii?Q?Kp3ZUvQp6racTAHlPX3wtgo6ACSxCpqbEdk7jJ0SyUH3qbfHP0iZNDFvPA3j?=
 =?us-ascii?Q?eLST80vu5jUeqTFdcxNqj3qIleX9f+Iy6lOpGVELJjRMsKDfcLIVzoMt5yEW?=
 =?us-ascii?Q?Eaawlq4gvM353ojqcq27YDxnITsTnjLrqkQt/IlppnuJTM7ky8rbOdBAZBd/?=
 =?us-ascii?Q?XqHhGBbdnyphbVcQnvT6BcbIOobiZOfKS9oOA8gQ7NpKFAg/KEVfEhW+8FRi?=
 =?us-ascii?Q?/b82SfbDBl3kWYUN4Mxlotn4Zk+V826R2IK0/huvNF5DytbxZLnhpC0tAckB?=
 =?us-ascii?Q?vJ/NWvVQR5Pl9zWy/dlMwoBALNQSV518Xla9EIlxWHgFj2iZMKiZuhlY1Fum?=
 =?us-ascii?Q?VYhRscJMPBnnYfII0WaaZQWX4vqUJEjClqeswjRVCeLfh9EDc8k3NE75Au2u?=
 =?us-ascii?Q?YdQSjPnBAhcR0duDp3hxETl7qqht7ZQg44SQNLBxema5LMIfLHwSEwA9bkBC?=
 =?us-ascii?Q?J8Bzo1F2FedtLM+TPSTlxxj7NBAW/g45CVQuNzKbx+LH/+Z0q8WYU0OqbKeX?=
 =?us-ascii?Q?zpElW+tLPu43v+x9hpP8/Hd1p8VmVwww6ifY6KO4EYcSIZgtbs4sjIZT4x/I?=
 =?us-ascii?Q?aL6Cajy7WwjlZFOtXDAwnCpd1AhFFE9t2qD9tGEyqZ1EICcsBYjf5hNsfFrZ?=
 =?us-ascii?Q?JqEY1djrj0iQssfvbwcWQU67iayNzveq/7+Ct3GWn5xaQgu2yw9wIXvTR4VT?=
 =?us-ascii?Q?xhf5335/69qGcOcbaTlBa46xdzhASl+woiPKV3H94i+9/qX4PNg4xDS2wjuq?=
 =?us-ascii?Q?9o9UYnpA9rikOHW+tj87WiNm4JZ56byxnceh+wljvGYjtCiSsD4h/dqT/J72?=
 =?us-ascii?Q?YclTWwHTxMDAAYHjnh3fqliCQgFn5qfVilmRJqzLljkkZFNJYMnib2BUv6s4?=
 =?us-ascii?Q?+cmqrPafXhO0iaZ4O1BldbkYgPxnAUkF3wm7nUKNwzgc4ItwUP2kXRk+WJCU?=
 =?us-ascii?Q?qcLytuBzHQH+Rb7HocwZKNZ/IomDYL7T4Q5i2qM5?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d067d4-009f-4de1-5dd6-08db5c72f30d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 16:21:37.6576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: veK3doc/1agqy/9kx++n/2mRQ1Ro/MBXLsby8/GzfWLDscOjbYhtwfC/rsWng/iIvaZbVKqXXc1/7eSAx6hivw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB2010
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Shradha Gupta <shradhagupta@linux.microsoft.com>
> Sent: Wednesday, May 24, 2023 5:57 AM
> To: linux-kernel@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Cc: Shradha Gupta <shradhagupta@linux.microsoft.com>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; Long Li <longli@microsoft.com>; Michael Kelley
> (LINUX) <mikelley@microsoft.com>; David S. Miller <davem@davemloft.net>;
> Steen Hegelund <steen.hegelund@microchip.com>; Simon Horman
> <simon.horman@corigine.com>
> Subject: [PATCH v2] hv_netvsc: Allocate rx indirection table size dynamic=
ally
>=20
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
>=20
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> ---
> Changes in v2:
>  * Added a missing free for rx_table to fix a leak
>  * Corrected alignment around rx table size query
>  * Fixed incorrect error handling for rx_table pointer.
> ---
>  drivers/net/hyperv/hyperv_net.h   |  5 ++++-
>  drivers/net/hyperv/netvsc_drv.c   | 18 ++++++++++++++----
>  drivers/net/hyperv/rndis_filter.c | 22 ++++++++++++++++++----
>  3 files changed, 36 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h
> b/drivers/net/hyperv/hyperv_net.h
> index dd5919ec408b..1dbdb65ca8f0 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -74,6 +74,7 @@ struct ndis_recv_scale_cap { /*
> NDIS_RECEIVE_SCALE_CAPABILITIES */
>  #define NDIS_RSS_HASH_SECRET_KEY_MAX_SIZE_REVISION_2   40
>=20
>  #define ITAB_NUM 128
> +#define ITAB_NUM_MAX 256
>=20
>  struct ndis_recv_scale_param { /* NDIS_RECEIVE_SCALE_PARAMETERS */
>  	struct ndis_obj_header hdr;
> @@ -1034,7 +1035,9 @@ struct net_device_context {
>=20
>  	u32 tx_table[VRSS_SEND_TAB_SIZE];
>=20
> -	u16 rx_table[ITAB_NUM];
> +	u16 *rx_table;
> +
> +	int rx_table_sz;
>=20
>  	/* Ethtool settings */
>  	u8 duplex;
> diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> index 0103ff914024..ab791e4ca63c 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -1040,6 +1040,13 @@ static int netvsc_detach(struct net_device *ndev,
>=20
>  	rndis_filter_device_remove(hdev, nvdev);
>=20
> +	/*
> +	 * Free the rx indirection table and reset the table size to 0.
> +	 * With the netvsc_attach call it will get allocated again.
> +	 */
> +	ndev_ctx->rx_table_sz =3D 0;
> +	kfree(ndev_ctx->rx_table);
> +

Please move the table free to rndis_filter_device_remove() which is the cou=
nter=20
part of rndis_filter_device_add(). So it's automatically called by netvsc_d=
etach/remove()=20
and other error cases.

Also, set ndev_ctx->rx_table =3D NULL after free to prevent potential doubl=
e free, or=20
accessing freed memory, etc.

>  	return 0;
>  }
>=20
> @@ -1747,7 +1754,9 @@ static u32 netvsc_get_rxfh_key_size(struct
> net_device *dev)
>=20
>  static u32 netvsc_rss_indir_size(struct net_device *dev)
>  {
> -	return ITAB_NUM;
> +	struct net_device_context *ndc =3D netdev_priv(dev);
> +
> +	return ndc->rx_table_sz;
>  }
>=20
>  static int netvsc_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
> @@ -1766,7 +1775,7 @@ static int netvsc_get_rxfh(struct net_device *dev,
> u32 *indir, u8 *key,
>=20
>  	rndis_dev =3D ndev->extension;
>  	if (indir) {
> -		for (i =3D 0; i < ITAB_NUM; i++)
> +		for (i =3D 0; i < ndc->rx_table_sz; i++)
>  			indir[i] =3D ndc->rx_table[i];
>  	}
>=20
> @@ -1792,11 +1801,11 @@ static int netvsc_set_rxfh(struct net_device
> *dev, const u32 *indir,
>=20
>  	rndis_dev =3D ndev->extension;
>  	if (indir) {
> -		for (i =3D 0; i < ITAB_NUM; i++)
> +		for (i =3D 0; i < ndc->rx_table_sz; i++)
>  			if (indir[i] >=3D ndev->num_chn)
>  				return -EINVAL;
>=20
> -		for (i =3D 0; i < ITAB_NUM; i++)
> +		for (i =3D 0; i < ndc->rx_table_sz; i++)
>  			ndc->rx_table[i] =3D indir[i];
>  	}

Please use the ethtool to change & show the table contents. So these functi=
ons=20
are tested:
ethtool -x eth0
ethtool -X eth0 ...

Also, run perf test to ensure no perf regression.

>=20
> @@ -2638,6 +2647,7 @@ static void netvsc_remove(struct hv_device *dev)
>=20
>  	hv_set_drvdata(dev, NULL);
>=20
> +	kfree(ndev_ctx->rx_table);

Move the table free to rndis_filter_device_remove() as said earlier.

>  	free_percpu(ndev_ctx->vf_stats);
>  	free_netdev(net);
>  }
> diff --git a/drivers/net/hyperv/rndis_filter.c
> b/drivers/net/hyperv/rndis_filter.c
> index eea777ec2541..3695c7d3da3a 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -927,7 +927,7 @@ static int rndis_set_rss_param_msg(struct
> rndis_device *rdev,
>  	struct rndis_set_request *set;
>  	struct rndis_set_complete *set_complete;
>  	u32 extlen =3D sizeof(struct ndis_recv_scale_param) +
> -		     4 * ITAB_NUM + NETVSC_HASH_KEYLEN;
> +		     4 * ndc->rx_table_sz + NETVSC_HASH_KEYLEN;
>  	struct ndis_recv_scale_param *rssp;
>  	u32 *itab;
>  	u8 *keyp;
> @@ -953,7 +953,7 @@ static int rndis_set_rss_param_msg(struct
> rndis_device *rdev,
>  	rssp->hashinfo =3D NDIS_HASH_FUNC_TOEPLITZ | NDIS_HASH_IPV4 |
>  			 NDIS_HASH_TCP_IPV4 | NDIS_HASH_IPV6 |
>  			 NDIS_HASH_TCP_IPV6;
> -	rssp->indirect_tabsize =3D 4*ITAB_NUM;
> +	rssp->indirect_tabsize =3D 4 * ndc->rx_table_sz;
>  	rssp->indirect_taboffset =3D sizeof(struct ndis_recv_scale_param);
>  	rssp->hashkey_size =3D NETVSC_HASH_KEYLEN;
>  	rssp->hashkey_offset =3D rssp->indirect_taboffset +
> @@ -961,7 +961,7 @@ static int rndis_set_rss_param_msg(struct
> rndis_device *rdev,
>=20
>  	/* Set indirection table entries */
>  	itab =3D (u32 *)(rssp + 1);
> -	for (i =3D 0; i < ITAB_NUM; i++)
> +	for (i =3D 0; i < ndc->rx_table_sz; i++)
>  		itab[i] =3D ndc->rx_table[i];
>=20
>  	/* Set hask key values */
> @@ -1548,6 +1548,20 @@ struct netvsc_device
> *rndis_filter_device_add(struct hv_device *dev,
>  	if (ret || rsscap.num_recv_que < 2)
>  		goto out;
>=20
> +	if (rsscap.num_indirect_tabent &&
> +	    rsscap.num_indirect_tabent <=3D ITAB_NUM_MAX)
> +		ndc->rx_table_sz =3D rsscap.num_indirect_tabent;
> +	else
> +		ndc->rx_table_sz =3D ITAB_NUM;
> +
> +	ndc->rx_table =3D kzalloc(sizeof(u16) * ndc->rx_table_sz,
> +				GFP_KERNEL);
> +	if (!ndc->rx_table) {
> +		netdev_err(net, "Error in allocating rx indirection table of
> size %d\n",
> +				ndc->rx_table_sz);
> +		goto out;
> +	}

When no enough memory for the table, it should:
	goto err_dev_remv;
So the device_add fails with an error.

Otherwise, it may continue to run with just one channel. The perf will be l=
ow, but=20
the error is not easily visible. That's probably why you didn't find the "i=
f (ndc->rx_table) "=20
condition error in the patch v1.

Thanks,
- Haiyang


