Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93124F6CFE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbiDFVkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237678AbiDFViR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:38:17 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2041.outbound.protection.outlook.com [40.107.101.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2DB13DF1
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 13:56:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmhIG89hLqfmRsgbC2oFiMncS90vQRsN44BAW7pY201Ptl87zUxTvIzl7P16KsH940j6PdKP6bBlvnwuUJzhhEyFBf2gXsQXFC/qZv17y9qE2ta2BMJvBlgQ1cr0NZuSsOTQJ4vgP0u/ahJQMsG11xWYm3hYbf4E2uGynUPLBap2S6vyPpJanrlPuTrivPrbW7DHLQHLJ3aWsoU/pkyjXBaM6onwPXEAKnPIJhKkbFUzzCLqg7Um85IoUKdwL3iKrbPGqPl7ADI9ngNO/EJxfXBlEsjALRYUd9aeXxQGu8IsUln6rZUQf1hggslb7v2OfCcU/WltuyWoCshJEKEDUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CqEhIte15IjY/I5Rd24VD6yc8NwF1g5aE8evS40j1Q=;
 b=n2hwdAZXZe9Cy6WcpmGUYI7X4+B9pz5gBoBRea9BB67c28uBQsDMvdLJKXMBnKXHRQ3R+ljGztorkkbSsf7LtWbYhG1e/TtLv4VAMLUnwPd3gmVKi8for/xAifCJsBCwbde7y6SCa6vlyjPqVi8FbgoJB5GDYQ80y1+OeMir9s1DnJUwqTfpSI6c4RSWhQ9nW5lJX44PtDeD2BnFGrTN0gvHljs1ES+Ks6YolWKeqhFZVA6OXu478IJSthMHM6xNAGBJ7hfw6inLBlriqpkABk/A7jF14aB6roI05x+bE0Kd3pBX8RkTzZTugNWqmBHWD6ydbN6zkToOFZOcfM5Mgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CqEhIte15IjY/I5Rd24VD6yc8NwF1g5aE8evS40j1Q=;
 b=qEyxrmsPpdHAt7t+Azd68eeWMbl2jyqUlXjcVbsg6s1uW9vdfC1Xcc6Uh9ovcvlQbR+BrlEHhn9j3dvdjGvkqtsg/GIRJLwEPASqCkKl+uC/tZ2/s1dQ8x4pQLirpD6d83Tv7423K+nM597k5SFs3oiIdvvwaapcXux6H91Bs3Q7dTewItaHKF3BA+fvU7QdqWJySbeCEizYh0YISi2bduTvAFWoiKBZTMOURH4ZHYI+aVgfHlUGi9BND3ZvAs3rkRPcM1QrQtlEKQXpjGx4r6BMycfU2zeLuDxD5r6tq6IY+C+yMW467uztM4JRiYHoGHkJ/Rp+Ph+KxmCOJh4aJw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MN2PR12MB3551.namprd12.prod.outlook.com (2603:10b6:208:104::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 20:56:43 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::9d86:35e6:f740:d3a1]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::9d86:35e6:f740:d3a1%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 20:56:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Michael Qiu <qiudayu@archeros.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iproute2 v2] vdpa: Add virtqueue pairs set capacity
Thread-Topic: [PATCH iproute2 v2] vdpa: Add virtqueue pairs set capacity
Thread-Index: AQHYSZnj6I3D267e8kGf02HvBXENa6zjXcNA
Date:   Wed, 6 Apr 2022 20:56:41 +0000
Message-ID: <PH0PR12MB54818242978506271F2E79A9DCE79@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1648113553-10547-1-git-send-email-08005325@163.com>
 <1649237791-31723-1-git-send-email-qiudayu@archeros.com>
In-Reply-To: <1649237791-31723-1-git-send-email-qiudayu@archeros.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 928164ac-fab4-4641-7423-08da180ff499
x-ms-traffictypediagnostic: MN2PR12MB3551:EE_
x-microsoft-antispam-prvs: <MN2PR12MB3551DAB608AA76D9C43B3541DCE79@MN2PR12MB3551.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JMx+tnIeENO+ldW+0XzTGpNb4edKNhXBb+pSNdeZOwfT5PnVQKEv+QDXx42oXPujGEvP0mGTBj4dGq9OXZmlCg/1vEgM0RaCgYwYitfKKAn1882Zyarnyf+EfQqQWqopWDMhx+5lGa0QGz1NSE/EkJ8F1ZEGM3324ofWuYW9ahbkOB6W6MoEMVIQ6LTk2pmkLG5mH7dNltHt6uwIbFgC+iDXfI2TTujhjp/b2sggdtYMimVQIX3lHVYzcUMtYohXr3cWm2am7wgOqy+LwJAkQiljt0PpsJOZrNqe437ZOr8poY6uXMQVVlparz7Vt1L0cZXT2zGfjB3wJVihIltboRf2bcdoRejPUBcLOBH+HFnLyALlwYIthtXaenNhfbolBIRY66v9ZO3jJwQwL6ognNKAhDdkdih7j7GQRqSjJgK9qQD5Iw9ccroSWRgWv7CQSPUqZonjczBz63KiDTdiUvJiMbKXVToEg1o/KoRd9tpRd3FZaEbNCdmed1HXVpg7BQdP23vvIo1pJkAhw4ytgptM3DvxApRTVjSn23NmTO69yin09ORkWnGBbfhwMLv1AonJmzUyl0ZShZPnTY3SwqvnsRSU/K7bEJDyn2Yyn0hb4899+Snof7SeCj4hAIzDz9c8v4V9/AgQvgPcc2kD18laqW3qNJSGqF9SfqBiU4e3RyvncmYNcLxj1QkDgGHTBmuPeyTmCAQDxA6g3/cpLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(2906002)(66556008)(64756008)(76116006)(66946007)(66446008)(66476007)(71200400001)(110136005)(86362001)(8676002)(4326008)(316002)(5660300002)(6506007)(7696005)(9686003)(52536014)(38070700005)(83380400001)(33656002)(38100700002)(122000001)(508600001)(8936002)(26005)(186003)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VvKXSQTtFcMRODvGjQpCe2POOGCNVrmT6dz2jqvHFx+ksYQ/+bl/S2hx672n?=
 =?us-ascii?Q?cN3lPjsLtBt3QASmPVq7JyWzsMjreCcC2fiGz4VzGk8NNMtlPVZ0EY9CETZI?=
 =?us-ascii?Q?pdVC6dm0SgLrrnj715PrduY3RED+3NtU5ZsmXAP5nvpW1O7apTM3dHf6oKYf?=
 =?us-ascii?Q?Cj1DEW4qVmlOaeQMFWelRSY1P+/9lWAtE9SKipli/IQ1X1Qsck/aiWmjM4g0?=
 =?us-ascii?Q?kNz54Q+44MkXluQl4BzaEPjzk2dO05ErUdEOYNd0pgJAYZcu3CZjsmduD27I?=
 =?us-ascii?Q?wQUKpibcrjw3IrwoBvQCw69Izw/GDe5y6DEKIw6FZ2BLY3CRluxVOcbCxlQQ?=
 =?us-ascii?Q?XxQc35GqLdCxQkbHfbEYNzPG9gC0tPBKcoaFqVnf4xuG6jKWxis/zHYVw2Oj?=
 =?us-ascii?Q?OowMYZMaJEaujU893scSGLnNGAmMT5lujWwY5KlfQiaPRZc3Y8kVmhHcRnhl?=
 =?us-ascii?Q?X38puVIPP0eCDyMW2FUsAeJ7OA11c2rRR1r1VMVG3o8APxFM67OuHW9FEGvD?=
 =?us-ascii?Q?f+lkid2uq40es3ha3HzJCE0n2JPWWJvJ3pmPHsrP8ljHiQetlX3f1Y4oX3zh?=
 =?us-ascii?Q?GA8VFwJf4m96KqrOCgr0ZE9iRgJ/jn6Q0fQoYh14KGWZerVlODy+DAKtwFPf?=
 =?us-ascii?Q?l5K2D1W6T4sKdE1muFV3/v4dDjSLbmnFKhhXEJLvC2tWxzchTCC00SMPZKOh?=
 =?us-ascii?Q?9kKVRAMIRhxufouqvZ8n31b/b/p0MIIK1MBKfiGVg+ZrYxdDEx8CNlxRgUkT?=
 =?us-ascii?Q?om9YoQdhQNIy14SesWDcHtUlyx4FfirAcRPObIpXFZdOsKLgmnio67hQnw4Q?=
 =?us-ascii?Q?2Z0RYqNvsp8bJxA8eMj1shO/aDrz1VNscGl5nwW4Yy0PXL1Qfn+PuXr5DI+M?=
 =?us-ascii?Q?zhqJqTcvkj5JBEdvXm3SWHTzG/UqM0ynIkWp790aOuqDM2L8jpjfwhTcwer9?=
 =?us-ascii?Q?64YKM/nK6A9aQOPyaOyrkTJmrqmnis2TrL+KlVgzmY3bhoxRJtwYCYCI20By?=
 =?us-ascii?Q?Y5HwCOHebrO7A8bQJ9wYss8FCrpv122aaCWLOWRdgLOhqRBJGyIvso7R7+vw?=
 =?us-ascii?Q?y6N2mf3G83i0mCyg4WQUFagq25i5aKqJGIgOHsoapoOPpj3938eiZSnpLlIN?=
 =?us-ascii?Q?fmiJjWhZnmmn1RrclBB8jUabTXlwexr9kZ/BhRzJ8e4U3vQZdyeB6F1oGSL5?=
 =?us-ascii?Q?CEGpDWY0IQThLTBIOKTEU9T/aKtUAL/Bs0lKlQyvpGh4B4qiYvnMvVzsWuwK?=
 =?us-ascii?Q?AJfmcuk+fdfhV7KQKAI7yqko5pO3+oTIsGDLJQk2iihdx5tBGlXHEnbqZ/1r?=
 =?us-ascii?Q?sqo36SCeFT4CvH6xIlKG2pk98aGQcRFB2QYJrn7fKQItF7FqkCA3+seTbUEy?=
 =?us-ascii?Q?CSn4pjjV9bbxdcujrnLeuMjzDFv6Uw4hjKV5ATmRIycLA7TjjNZEUh4qdSMx?=
 =?us-ascii?Q?Me0yRkIaYM4/I4jFim1TnjZ8RhqlkptKQmFBTE6JdEhPIqvgMTzBijxPv3cb?=
 =?us-ascii?Q?d+XiGeyY5rIu3Vv+QjdC9yedEGQ+qYcSWiNJFCSGxJKkRu6YviV8w6U8Nmfy?=
 =?us-ascii?Q?Yor4Zl/FVjbeh/fViu5Q6+7EJhZ4qDZnoRwlyuxBFWvsNcNwqYeibbQxbmUo?=
 =?us-ascii?Q?iflHBVj+p8Jin3vLIcdOpmGF1r36PHLQUN7fy5T4ncL07x/LcucRIvpBYEKN?=
 =?us-ascii?Q?8gOo0rQv9aDnyA/ihyRMm/4nNZkQ93JeNN0JGjk46sy8V76P?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 928164ac-fab4-4641-7423-08da180ff499
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 20:56:43.2838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: miE6NRNexpsE7/qhXwdMGs029asNiqHkDKJ1kWteOuLKwbO5SArHJhWON0itze7S169NIyDTX+gC3k+e6sWpQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3551
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

> From: Michael Qiu <qiudayu@archeros.com>
> Sent: Wednesday, April 6, 2022 5:37 AM
> To: Parav Pandit <parav@nvidia.com>; stephen@networkplumber.org
> Cc: netdev@vger.kernel.org; Michael Qiu <qiudayu@archeros.com>
> Subject: [PATCH iproute2 v2] vdpa: Add virtqueue pairs set capacity
>=20
> vdpa framework not only support query the max virtqueue pair, but also fo=
r
> the set action.
>=20
> This patch enable this capacity, and it is very useful for VMs  who needs
> multiqueue support.
>=20
> After enable this feature, we could simply use below command to create
> multi-queue support:
>=20
> vdpa dev add mgmtdev pci/0000:03:10.3 name foo mac 56:d0:2f:03:c9:6d
> max_vqp 6
>=20
> Signed-off-by: Michael Qiu <qiudayu@archeros.com>
> ---
>=20
> v2 --> v1:
>     rename "max_vq_pairs" to "max_vqp"
>=20
>     extend the man page for this addition with example
> ---
>  man/man8/vdpa-dev.8 |  9 +++++++++
>  vdpa/vdpa.c         | 19 ++++++++++++++++---
>  2 files changed, 25 insertions(+), 3 deletions(-)
>=20
> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8 index
> aa21ae3..a401115 100644
> --- a/man/man8/vdpa-dev.8
> +++ b/man/man8/vdpa-dev.8
> @@ -74,6 +74,10 @@ This is applicable only for the network type of vdpa
> device. This is optional.
>  - specifies the mtu for the new vdpa device.
>  This is applicable only for the network type of vdpa device. This is opt=
ional.
>=20
> +.BI max_vqp " MAX_VQP"
> +- specifies the max queue pairs for the new vdpa device.
> +This is applicable only for the network type of vdpa device. This is opt=
ional.
> +
>  .SS vdpa dev del - Delete the vdpa device.
>=20
>  .PP
> @@ -119,6 +123,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
> mac 00:11:22:33:44:55 mtu 9000  Add the vdpa device named foo on the
> management device vdpa_sim_net with mac address of 00:11:22:33:44:55
> and mtu of 9000 bytes.
>  .RE
>  .PP
> +vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55 mtu
> +9000 max_vqp 6 .RS 4 Add the vdpa device named foo on the management
> +device vdpa_sim_net with mac address of 00:11:22:33:44:55, mtu of 9000
> bytes and max virtqueue pairs of 6.
> +.RE
> +.PP
>  vdpa dev del foo
>  .RS 4
>  Delete the vdpa device named foo which was previously created.
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index f048e47..104c503 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -23,6 +23,7 @@
>  #define VDPA_OPT_VDEV_HANDLE		BIT(3)
>  #define VDPA_OPT_VDEV_MAC		BIT(4)
>  #define VDPA_OPT_VDEV_MTU		BIT(5)
> +#define VDPA_OPT_VDEV_QUEUE_PAIRS	BIT(6)
>=20
>  struct vdpa_opts {
>  	uint64_t present; /* flags of present items */ @@ -32,6 +33,7 @@
> struct vdpa_opts {
>  	unsigned int device_id;
>  	char mac[ETH_ALEN];
>  	uint16_t mtu;
> +	uint16_t max_vqp;
>  };
>=20
>  struct vdpa {
> @@ -219,6 +221,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh,
> struct vdpa *vdpa)
>  			     sizeof(opts->mac), opts->mac);
>  	if (opts->present & VDPA_OPT_VDEV_MTU)
>  		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU,
> opts->mtu);
> +	if (opts->present & VDPA_OPT_VDEV_QUEUE_PAIRS)
> +		mnl_attr_put_u16(nlh,
> VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>  }
>=20
>  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv, @@ =
-
> 287,6 +291,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc,
> char **argv,
>=20
>  			NEXT_ARG_FWD();
>  			o_found |=3D VDPA_OPT_VDEV_MTU;
> +		} else if ((strcmp(*argv, "max_vqp") =3D=3D 0) &&
> +			   (o_all & VDPA_OPT_VDEV_QUEUE_PAIRS)) {
> +			NEXT_ARG_FWD();
> +			err =3D vdpa_argv_u16(vdpa, argc, argv, &opts-
> >max_vqp);
> +			if (err)
> +				return err;
> +
> +			NEXT_ARG_FWD();
> +			o_found |=3D VDPA_OPT_VDEV_QUEUE_PAIRS;
>  		} else {
>  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>  			return -EINVAL;
> @@ -467,7 +480,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc,
> char **argv)  static void cmd_dev_help(void)  {
>  	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> -	fprintf(stderr, "       vdpa dev add name NAME mgmtdev
> MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> +	fprintf(stderr, "       vdpa dev add name NAME mgmtdev
> MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [ max_vqp N ]\n");
>  	fprintf(stderr, "       vdpa dev del DEV\n");
>  	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
> } @@ -557,7 +570,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc,
> char **argv)
>  					  NLM_F_REQUEST | NLM_F_ACK);
>  	err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>  				  VDPA_OPT_VDEV_MGMTDEV_HANDLE |
> VDPA_OPT_VDEV_NAME,
> -				  VDPA_OPT_VDEV_MAC |
> VDPA_OPT_VDEV_MTU);
> +				  VDPA_OPT_VDEV_MAC |
> VDPA_OPT_VDEV_MTU |
> +VDPA_OPT_VDEV_QUEUE_PAIRS);
>  	if (err)
>  		return err;
>=20
> @@ -603,7 +616,7 @@ static void pr_out_dev_net_config(struct nlattr **tb)
>  	}
>  	if (tb[VDPA_ATTR_DEV_NET_CFG_MAX_VQP]) {
>  		val_u16 =3D
> mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MAX_VQP]);
> -		print_uint(PRINT_ANY, "max_vq_pairs", "max_vq_pairs %d
> ",
> +		print_uint(PRINT_ANY, "max_vqp", "max_vqp %d ",
>  			     val_u16);
>  	}
>  	if (tb[VDPA_ATTR_DEV_NET_CFG_MTU]) {
> --
> 1.8.3.1
>=20

You are probably not using right iproute2 tree.

I already see existing code from Eli in commit [1] that supports setting th=
is field.

The iproute2 tree to use for upstream work is [2].

[1] commit 16482fd4d ("vdpa: Support for configuring max VQ pairs for a dev=
ice")
[2] git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
