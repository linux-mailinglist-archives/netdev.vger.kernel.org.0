Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32168440A01
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 17:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhJ3Pj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 11:39:29 -0400
Received: from mail-cusazon11021025.outbound.protection.outlook.com ([52.101.62.25]:27619
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230086AbhJ3Pj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 11:39:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdljTS/ADThvRwZf+Qn+B53MFQrI5KR8BZ9SYv8mI3IJpZGwKBX/nmJ1yWnrpUqo3LY8lfQein4fyCO/9vBYnNE6FPxAhU7yjhVQX9UxO8sm9dkePFoN1Hfh6SeIYYle/EWo2AOOMD3OrEAHy9f7BCmyMwBm8UJ8dPpXeOjoDRtHXDpI9gRrr3dSodktZnCuOrV+tOIifc1YeEeLmxZ/t1Z3ZeSAAtaav2wqBvGjTiMBw6mE2z4/s3Y3UlVi8XD1MImW3tiFmEtt3+IQyieK/BfrXZ2trSHGUSGYVi0HfdREFHFzfOiyGb/VRg0s2i/LX/Ex201FB32Kf9E29oKE9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcqhGJTAcei4yK/OcSatqhTzxOmed3p6YFyIkwHHEsA=;
 b=RAvaroaLP7ssNuEXyjV39MdsyzT/IsrJQDccvVzktCWj9Ht7KgqqTbfG25EVHHFtsVhePgr7ILppPecyL2slNMWU8JHeNQ1RU0+YIkd70D9HDb0H8+G/ebinXhTK0YHIkSC9zPc40bdyWWRX5GM1pP4N/ehglKEY/S//cNHQT1nVQtURY+SaajD9ZVpaQYZZFd7kROnZaeasCUAoXLLOylg3JLV2RL6JTshnvOOyxGNP3B84EW8HPpP9q00wAGMz2eeNfOQNWu6FGLiYyz5So0Z3G4C00jiB6t2Y8XlK9n7xO5dNoV6BdDTUXtkG/0TxsZYtLtwbOoWyWrW8SbOmTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcqhGJTAcei4yK/OcSatqhTzxOmed3p6YFyIkwHHEsA=;
 b=Dgsqm4lAQk96RqT5a12i45r/KloxxpNSD1HreeeBsy6BaJHeyyYNiVnvWpyXIAcoO3kPJASg0yLOmTBLK4GtsyBvGf0d99yXyxRNb/u5fit6iTfhQbFGfRrx2HEVGYDFhaPUVc/3WXsxvTAIUY5+Q/GKCxnaz29caQLxFS2lXk0=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BN8PR21MB1234.namprd21.prod.outlook.com (2603:10b6:408:77::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.0; Sat, 30 Oct
 2021 15:36:55 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018%7]) with mapi id 15.20.4669.004; Sat, 30 Oct 2021
 15:36:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next 3/4] net: mana: Improve the HWC error handling
Thread-Topic: [PATCH net-next 3/4] net: mana: Improve the HWC error handling
Thread-Index: AQHXzSi4XYNK32EGdE6DVoKM725FOqvrrVPQ
Date:   Sat, 30 Oct 2021 15:36:54 +0000
Message-ID: <BN8PR21MB1284C84F87CF19FA60E52B71CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
 <20211030005408.13932-4-decui@microsoft.com>
In-Reply-To: <20211030005408.13932-4-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=500a2d4d-8f11-4aa9-9388-44382762cb65;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-30T15:35:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee7bba06-c1bd-48bf-e444-08d99bbb1a3f
x-ms-traffictypediagnostic: BN8PR21MB1234:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN8PR21MB12348AF435524729100C87A5CA889@BN8PR21MB1234.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jD3Xx2FlOZ/sMtd4CA6d/6Lu2GFx4yXPr6W5pxbs/hwar6qsgDlqaqoasgIERqWyAabYVMIByOD3W0V8ul4mNJbhRBRbEIE8WHFO2sDxFU1bwqvEjOMdzsNxR+KorHQdo8z+9u6buppNoWQ+TfbPN3jO08VdvUn00U2eapWtCioY5ryz0h0aHG4Kipdx4idIG1z5bwkSkRBzNM1oNMDvBTDCHEhr1footUG+0GSfbowusoaFClYuZKxyCekoln7BpO/bPKPtKI+veWaOa0dostSgTdZfBNC/znTZN8si4fkpwyd6IbP+8F2AJiqJ4uWjo76wX//kUsWu39Imnk8FM21l9dr7Syks/BQY5Y9flecLZsi2AyshcXZVmkTrOf6axT8v71S/KN44U20g3d0ahev6doSxQ5EsMc2sUJ2K3LW5hPHWw/3cRZwmmwaXiHROu8NQucrPXmn45AT7odNm6LpyKnKqLPwCV/mIxLIxjjhwUOp2j09k/pUH+BLYiyRauf+Eb3L+ReuuvZC94Yzr8IOU4NUcaPfcCJ6ARIwwYzFSQ7Ft0f7bDCO6WG8l2OSxmTusRMbP4WbRsBcdt/3fOQk3EnK60zX+DvgH/+yForJG8aUFJ+s9Ze4U4DigSllahvCIya2k16EoLFdHQUhj2zwmaZc+vov/BU9n02djIQj8BYD3ZNGpkzKQn3iXyyAbXVB0L6OFCkTTmdKJhXHMlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(55016002)(71200400001)(8990500004)(2906002)(82960400001)(54906003)(8936002)(186003)(66946007)(66556008)(66476007)(66446008)(64756008)(26005)(9686003)(110136005)(8676002)(76116006)(86362001)(82950400001)(52536014)(508600001)(6506007)(10290500003)(38100700002)(316002)(122000001)(4326008)(7416002)(7696005)(5660300002)(83380400001)(53546011)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uRtmmu7SB2rnULgYcE0pElpZECAuI17gRNswDtEhym/BcY9ZbX5W6AiwAFuy?=
 =?us-ascii?Q?YWxRe/jckEBHyL3YLlQH+kLSFpJL/+jxo7dXQkeuy4rROqE1LH3uBOkyqXwt?=
 =?us-ascii?Q?7mYe71NeqmPRxJI5mDzokHxUJJ5tvL8KJ6Zqd0ji+X8/jJkbFyCsspU+B8mV?=
 =?us-ascii?Q?1KPcg9KvDH2Fyr0mlMsTgwuA2slVCnW5wDOXirt+tMibUTTeEzd6kGFwBm43?=
 =?us-ascii?Q?X9OY7f0ZzAjKJOydZPYkEC1Z9JhJgpZEHC2eZ5MHx74O09DaHZE/gKbXswCM?=
 =?us-ascii?Q?pYtuPy8ZhzN2EJLrHhxX2cbWTXLcl0bta5nhrRSgc9daJIgExf/U2BoQYEQu?=
 =?us-ascii?Q?hveQjONMWArJrzQECxuhSzpjp9SApwfui6d8Cp3OhEHKCJzRId3ltOQKAaVt?=
 =?us-ascii?Q?0lPzztGULmsCrMzFgkWMqXSVD3c8nJU3ShiiecgdjSDhb3F9jQNk00GbrRUY?=
 =?us-ascii?Q?QG/y9S1CRC67Xz0rUFZFh8NeXBCUbnTYqXX93MZ4gG91or1ZWQgbN28OYxRI?=
 =?us-ascii?Q?ESm3erzexe/sGZhSTQRFkebu08rtFqP0fWWzTDYhCUqeXKUg/DBW2p5aTksz?=
 =?us-ascii?Q?FCA4kzccK/oo8LyqvZ2nw9cbJ2PfPnzbg+UEtCvr5vVOZg+uhWJNH8jLPOGq?=
 =?us-ascii?Q?H7fqv9rfdCiMefTOdydcg6B+uzPi1YCflU+vADwqjcqsnHsq9LOZ9h5qzikg?=
 =?us-ascii?Q?iPqgZSq/Sus392E5jZMSz/0awWCEx0UuxwUuSXJtgpf4zpH4LCrJO1l+8FPv?=
 =?us-ascii?Q?HYLe9+C2r/RCwxX7caKIlKUSVkSH2mfjc8YZjxU/mrrCLyuj+OeWYYgfa27e?=
 =?us-ascii?Q?O6ZK0qVGRH1XXejtumt6+0vHgk8UAj0bJS/fUdCxL9Y/BTJgXsaTKMxaoa2P?=
 =?us-ascii?Q?3v5otaXZDvnbuMyLkzyb6dC/misCuvXiiMnjoBSBYeTypOUTm4c9t7xicFlC?=
 =?us-ascii?Q?IFUcGC2oZsk1unSwNmgqYLlgba9CUF8x10GmIvv50SEUnC5DgkDQ4mrLFqds?=
 =?us-ascii?Q?Fh83A/YjsnAtzzyqYTlv78HsULXR271YB2ZtnUIMIJCHZ1SuTmy1FlJUvbRt?=
 =?us-ascii?Q?4HHAULKOpM+er3Ik/QKmDPCFg3POfbYPsvLGMwi6+ABXCgNR7xNULXCmnRQg?=
 =?us-ascii?Q?g3Qz8wrpEM9uLZ8fZGX+74Q3oxqg1AMIHwahQ6MoDXT7bUA+I680m1JP13DT?=
 =?us-ascii?Q?3OOPqRHMySHGeqF7dzm/TnXCXfCnxCrPl3WwpP40hxdJAwUyQaNz55Q2ZmTa?=
 =?us-ascii?Q?6tFw9KNHNGGH3f5z253+XD+C9U826QyaE955VcLSt8Ql8J1pLOiyhi6JdvcN?=
 =?us-ascii?Q?E27m47pEbWtNful+QYdSlp06HmdOK/JujVcmuJ3aNCmq5vdqadjhyiWVO/PE?=
 =?us-ascii?Q?ycshUI4iCBVLKHEnLnbOXFPA5y7pnboXK50VnwERPNB1UPOnp/RD+zSUN/d9?=
 =?us-ascii?Q?TYbbwhsFDlyeqxFS9Vdr7qtz/sfeXZFx/gQuQXY8D+y/xhvoqTIQ5CC8Dn8R?=
 =?us-ascii?Q?ZKSEJFdUu87SJz4CDWVoEudo7aAmK3tO+yVsaUZM+IKUg1ygQVexUiTRd/7/?=
 =?us-ascii?Q?do3BnUQIbdIP/zhmqRoz3YQo5j3QTYVcr2oSy3xNXzv4stRqrWOxSVAvyBRG?=
 =?us-ascii?Q?MA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7bba06-c1bd-48bf-e444-08d99bbb1a3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2021 15:36:54.9351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3wXcxGqvagBLN8QoTFXuWsFbgH8XPujh/4lP5uDVu0eIDDpuWMGQ1nl/x5Lcc+9XhOpoAqMpi9PgJb1DZPa3nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1234
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Friday, October 29, 2021 8:54 PM
> To: davem@davemloft.net; kuba@kernel.org; gustavoars@kernel.org; Haiyang
> Zhang <haiyangz@microsoft.com>; netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; stephen@networkplumber.org;
> wei.liu@kernel.org; linux-kernel@vger.kernel.org; linux-
> hyperv@vger.kernel.org; Shachar Raindel <shacharr@microsoft.com>; Paul
> Rosswurm <paulros@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; Dexuan Cui <decui@microsoft.com>
> Subject: [PATCH net-next 3/4] net: mana: Improve the HWC error handling
>=20
> Currently when the HWC creation fails, the error handling is flawed, e.g.
> if mana_hwc_create_channel() -> mana_hwc_establish_channel() fails, the
> resources acquired in mana_hwc_init_queues() is not released.
>=20
> Enhance mana_hwc_destroy_channel() to do the proper cleanup work and
> call it accordingly.
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  4 --
>  .../net/ethernet/microsoft/mana/hw_channel.c  | 71 ++++++++-----------
>  2 files changed, 31 insertions(+), 44 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 8a9ee2885f8c..599dfd5e6090 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1330,8 +1330,6 @@ static int mana_gd_probe(struct pci_dev *pdev,
> const struct pci_device_id *ent)
>=20
>  clean_up_gdma:
>  	mana_hwc_destroy_channel(gc);
> -	vfree(gc->cq_table);
> -	gc->cq_table =3D NULL;
>  remove_irq:
>  	mana_gd_remove_irqs(pdev);
>  unmap_bar:
> @@ -1354,8 +1352,6 @@ static void mana_gd_remove(struct pci_dev *pdev)
>  	mana_remove(&gc->mana);
>=20
>  	mana_hwc_destroy_channel(gc);
> -	vfree(gc->cq_table);
> -	gc->cq_table =3D NULL;
>=20
>  	mana_gd_remove_irqs(pdev);
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index c1310ea1c216..851de2b81fa4 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -309,9 +309,6 @@ static void mana_hwc_comp_event(void *ctx, struct
> gdma_queue *q_self)
>=20
>  static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq
> *hwc_cq)  {
> -	if (!hwc_cq)
> -		return;
> -
>  	kfree(hwc_cq->comp_buf);
>=20
>  	if (hwc_cq->gdma_cq)
> @@ -448,9 +445,6 @@ static void mana_hwc_dealloc_dma_buf(struct
> hw_channel_context *hwc,  static void mana_hwc_destroy_wq(struct
> hw_channel_context *hwc,
>  				struct hwc_wq *hwc_wq)
>  {
> -	if (!hwc_wq)
> -		return;
> -
>  	mana_hwc_dealloc_dma_buf(hwc, hwc_wq->msg_buf);
>=20
>  	if (hwc_wq->gdma_wq)
> @@ -623,6 +617,7 @@ static int mana_hwc_establish_channel(struct
> gdma_context *gc, u16 *q_depth,
>  	*max_req_msg_size =3D hwc->hwc_init_max_req_msg_size;
>  	*max_resp_msg_size =3D hwc->hwc_init_max_resp_msg_size;
>=20
> +	/* Both were set in mana_hwc_init_event_handler(). */
>  	if (WARN_ON(cq->id >=3D gc->max_num_cqs))
>  		return -EPROTO;
>=20
> @@ -638,9 +633,6 @@ static int mana_hwc_establish_channel(struct
> gdma_context *gc, u16 *q_depth,  static int mana_hwc_init_queues(struct
> hw_channel_context *hwc, u16 q_depth,
>  				u32 max_req_msg_size, u32 max_resp_msg_size)  {
> -	struct hwc_wq *hwc_rxq =3D NULL;
> -	struct hwc_wq *hwc_txq =3D NULL;
> -	struct hwc_cq *hwc_cq =3D NULL;
>  	int err;
>=20
>  	err =3D mana_hwc_init_inflight_msg(hwc, q_depth); @@ -653,44 +645,32
> @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16
> q_depth,
>  	err =3D mana_hwc_create_cq(hwc, q_depth * 2,
>  				 mana_hwc_init_event_handler, hwc,
>  				 mana_hwc_rx_event_handler, hwc,
> -				 mana_hwc_tx_event_handler, hwc, &hwc_cq);
> +				 mana_hwc_tx_event_handler, hwc, &hwc->cq);
>  	if (err) {
>  		dev_err(hwc->dev, "Failed to create HWC CQ: %d\n", err);
>  		goto out;
>  	}
> -	hwc->cq =3D hwc_cq;
>=20
>  	err =3D mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_req_msg_size,
> -				 hwc_cq, &hwc_rxq);
> +				 hwc->cq, &hwc->rxq);
>  	if (err) {
>  		dev_err(hwc->dev, "Failed to create HWC RQ: %d\n", err);
>  		goto out;
>  	}
> -	hwc->rxq =3D hwc_rxq;
>=20
>  	err =3D mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_resp_msg_size,
> -				 hwc_cq, &hwc_txq);
> +				 hwc->cq, &hwc->txq);
>  	if (err) {
>  		dev_err(hwc->dev, "Failed to create HWC SQ: %d\n", err);
>  		goto out;
>  	}
> -	hwc->txq =3D hwc_txq;
>=20
>  	hwc->num_inflight_msg =3D q_depth;
>  	hwc->max_req_msg_size =3D max_req_msg_size;
>=20
>  	return 0;
>  out:
> -	if (hwc_txq)
> -		mana_hwc_destroy_wq(hwc, hwc_txq);
> -
> -	if (hwc_rxq)
> -		mana_hwc_destroy_wq(hwc, hwc_rxq);
> -
> -	if (hwc_cq)
> -		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc_cq);
> -
> -	mana_gd_free_res_map(&hwc->inflight_msg_res);
> +	/* mana_hwc_create_channel() will do the cleanup.*/
>  	return err;
>  }
>=20
> @@ -718,6 +698,9 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  	gd->pdid =3D INVALID_PDID;
>  	gd->doorbell =3D INVALID_DOORBELL;
>=20
> +	/* mana_hwc_init_queues() only creates the required data structures,
> +	 * and doesn't touch the HWC device.
> +	 */
>  	err =3D mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
>  				   HW_CHANNEL_MAX_REQUEST_SIZE,
>  				   HW_CHANNEL_MAX_RESPONSE_SIZE);
> @@ -743,42 +726,50 @@ int mana_hwc_create_channel(struct gdma_context
> *gc)
>=20
>  	return 0;
>  out:
> -	kfree(hwc);
> +	mana_hwc_destroy_channel(gc);
>  	return err;
>  }
>=20
>  void mana_hwc_destroy_channel(struct gdma_context *gc)  {
>  	struct hw_channel_context *hwc =3D gc->hwc.driver_data;
> -	struct hwc_caller_ctx *ctx;
>=20
> -	mana_smc_teardown_hwc(&gc->shm_channel, false);
> +	if (!hwc)
> +		return;
> +
> +	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
> +	 * non-zero, the HWC worked and we should tear down the HWC here.
> +	 */
> +	if (gc->max_num_cqs > 0) {
> +		mana_smc_teardown_hwc(&gc->shm_channel, false);
> +		gc->max_num_cqs =3D 0;
> +	}
>=20
> -	ctx =3D hwc->caller_ctx;
> -	kfree(ctx);
> +	kfree(hwc->caller_ctx);
>  	hwc->caller_ctx =3D NULL;
>=20
> -	mana_hwc_destroy_wq(hwc, hwc->txq);
> -	hwc->txq =3D NULL;
> +	if (hwc->txq)
> +		mana_hwc_destroy_wq(hwc, hwc->txq);
>=20
> -	mana_hwc_destroy_wq(hwc, hwc->rxq);
> -	hwc->rxq =3D NULL;
> +	if (hwc->rxq)
> +		mana_hwc_destroy_wq(hwc, hwc->rxq);
>=20
> -	mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
> -	hwc->cq =3D NULL;
> +	if (hwc->cq)
> +		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
>=20
>  	mana_gd_free_res_map(&hwc->inflight_msg_res);
>=20
>  	hwc->num_inflight_msg =3D 0;
>=20
> -	if (hwc->gdma_dev->pdid !=3D INVALID_PDID) {
> -		hwc->gdma_dev->doorbell =3D INVALID_DOORBELL;
> -		hwc->gdma_dev->pdid =3D INVALID_PDID;
> -	}
> +	hwc->gdma_dev->doorbell =3D INVALID_DOORBELL;
> +	hwc->gdma_dev->pdid =3D INVALID_PDID;
>=20
>  	kfree(hwc);
>  	gc->hwc.driver_data =3D NULL;
>  	gc->hwc.gdma_context =3D NULL;
> +
> +	vfree(gc->cq_table);
> +	gc->cq_table =3D NULL;
>  }
>=20
>  int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
> --
> 2.17.1

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

