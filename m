Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B77D56CD45
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 07:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiGJFlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 01:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGJFk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 01:40:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28B91181F
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 22:40:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grEnSJ8seeV63lhoqWaS+hCPvwOpvBYdmjCdb1HrevQRYZFxD2HaPOVl6OItGHeh6QdhRZ238F3cgp1DJUqLYyoFUISChy2IZhS8kNc/OHgA6ytjhMxy+KPrst5GNfh53N3SqmPjF0TSxc9tOEu9pAZHr7+56OxWXgQRP1MMVLSVgHBEVwpmKKKR4Apd1wMuUzK9OxmnQrwlhw2+UZnVZIb16pCFFqVUmSXEAgqSfaAhkyF8S92KYhqYIyRpJLlb0464+ZNYypDhDLr+fBaiDTe1xSWUuXKqNK8kV+5zd3O0kGb8l70+Ia7IUzIdwECdT+OKRj8a04PTaO3IXkUGKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGJ7iaQondeqftPEZBRChDw4C703puJ8E59hPp/t/IM=;
 b=Drty5LstDrwMdZYz0huxMbhv3zipDVyuC2MJaWvc2efJYzV0Ux2db9k4TrfnmanNo1TztBmD2PFcJhVtybiX9rF/k+G4Na4/SUA4PV5aQwlZU8C3z1/XpBbqn6hvDwk4OBA5ow/VrwR9RaEuL5IRKF5N70Xm8YE1Dy2OEvr1eviT5ZfQtV95qYNeTAYip3eeEScn2siWPTHlYCxC8WV2yTHMpgiL6gpeBPXj+jsQ1Q1NVJSF/N1v/DXIpm8zhgibDn4WnCVMaA9yziOroPj+vwDlaWVxJzBm21ZNvQ9QIP8UpKD21L2imCQTXklB6bB3bEfH347RBc/Yc/Z0x6DU5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGJ7iaQondeqftPEZBRChDw4C703puJ8E59hPp/t/IM=;
 b=V0aBDa8SVHDgbG6ApfleNADNdhg4Gc9P8pSun767Sc0vrN6lfK7qGN001aHo5yWYEICaZmW4owSj4yYJmwMcQaRUVUr+WYS3FhlrgMIxWvepEjHfHMuPwMfgubetwl22bBS6aaSETwic+m0E56+5047YbShOACOONBZ+10i4bCCQe/f21MyxQglLzDaQM2HdJVmYAPqq0vWIoHFXOjEApK3eIR9vV77+wzQeYHC47sZM2c1sg75VOfUY0/gGa54Ccjd2BqGMeDvdt8fK/P+dB6L9EeiAoAs31wFhGK9YBGbpn+Ociz3ew09AotrM6itxK1+WlvaXB/Bfq+lzDiMMDQ==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 BN8PR12MB2994.namprd12.prod.outlook.com (2603:10b6:408:42::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Sun, 10 Jul 2022 05:40:56 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::fd63:3074:ae57:c82f]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::fd63:3074:ae57:c82f%9]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 05:40:56 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>
Subject: RE: [PATCH v1] vdpa: Add support for reading vdpa device statistics
Thread-Topic: [PATCH v1] vdpa: Add support for reading vdpa device statistics
Thread-Index: AQHYgGp9IbpSHDHW6EuvFbzMKlhYba13PVcQ
Date:   Sun, 10 Jul 2022 05:40:55 +0000
Message-ID: <DM8PR12MB54007939BDF9777A237A4981AB849@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220615034616.16474-1-elic@nvidia.com>
In-Reply-To: <20220615034616.16474-1-elic@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b532b20b-1945-44a3-3f7c-08da6236c2b0
x-ms-traffictypediagnostic: BN8PR12MB2994:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 17lgoSQQqPhCPYHPA6+17xogmsaPaMpbm2OUEqMQqlqD2oH8SKVfh9kNelEoywiwrIRtsAf5W+3h//6kDW84AKvyoXGVyDf2VKtyXyTrvElmJwRMUi7vbe/GazsWoXk05ouv2DqwA/lN/TqDs5GL35JUtILBPO8PH0IVV6U0tAU72X00EDnlJmr/3d4E916exhQz53JSnp0IbOZTcSl/rB5VRfobU0NM4wOPHR34PQh92XndeJc6sTj+Y9Knpqzx81NMo6iGuc/rmOedH6dJlNl6Gh3JSBf9tAULUNtml+TVwWv0jRjvgEs0LWTNeCQpRZqGNqD3WtEA1Nmm8YY7Y1RrbCN8EWMmCJWpdQZBBJqQHmdSAq5TmSZikcAVOXY8RsSn9U5WR5DnyH+2zIalHycfHogH2jXnC5jcnUqiyuH7hqgJMuaCFGYVk2acpMQ99QWk2M+mz+YCUb5IyAvlIv1lN1n9hqT19H2+Wr6yzOIW5tPQeB6ZIrgcIKgKVqgt0/sYy35/xcYd5B0g5SVJzuzWMD6EAnjtS5hYBZli6PsydaPeFaHyv7o1yDF6i10YHftWWDNkow2TPmnYgSaPZSfMo62/3zJT+rVdvG/O6ohzEp/lEJkmJ7Tdvsehty7Ch9XMbxKUGR6C410xwp9xJtzS14AfuOwQlXoIMtJPqT9OAs3C2pZ2BMObz389ykqnbenvw7Vg7r8g+gJ/bRyosbvyPvmMi2SZwa04kIdxr3iL3om0Bn+Sguc6ipklNuCKzgl7HTnNIPtAraMVVARR6JAgWN02Cuk6oBUOuCLSXaUEy3ITkNC38d0wVIWWvZen
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(53546011)(8676002)(316002)(26005)(5660300002)(64756008)(66556008)(55016003)(110136005)(6506007)(71200400001)(33656002)(186003)(7696005)(9686003)(8936002)(66446008)(52536014)(86362001)(478600001)(122000001)(76116006)(2906002)(41300700001)(66476007)(66946007)(38070700005)(83380400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VGenga7LXSGCkeXh5fioulyzfWLg0Dx8ZTw00McDRQNPuesbsZdjLaAFX4mK?=
 =?us-ascii?Q?VkY/OAR8h+3eiWbKkMwKvEYkNsZ4ri+h9GMT/FohOuAT3gFlKynSkxwRDOLs?=
 =?us-ascii?Q?5btXOaOyi7E17J7fYU4zOi2P5qSmgF3lur+ZReqJ5VAH5dqGYf/qik++jmrO?=
 =?us-ascii?Q?pcPx+Vf0W9dftHePkHmQ3Q6RPeg4Yp/UCu9dX8RZ4FCNTS9qeIUk5p7RVInH?=
 =?us-ascii?Q?Ohoyj4cLz4dxoYJEpROn+P+2fuoYVGmPUV8I2FyzgTF7P03IudDVAQ9R9w/R?=
 =?us-ascii?Q?j/J/ecwrYS68SfPB+8cUIFjNXmr76+bpyw8+xEp/TaODEYXgAoWtrnfak0hf?=
 =?us-ascii?Q?cCs2HgphKa+R/rMhAeZGUA7MCzsGN1ji5uYYjGBhfcdmgxRu35rrQEB4nFed?=
 =?us-ascii?Q?RvIN0V5llxMFTF6iNLf/MxfTQGROWKWUzD8Dp/gaSbAdN8TJY3ssFcMu4DHC?=
 =?us-ascii?Q?7I0dQJPomBpsaReMT9ruCz3qxM/O0K49kfV8dpSZ6iY0JSbr/Loj2GxYKhVY?=
 =?us-ascii?Q?zFXYmHC3L+Bl1DzdPhwjcQJYIUcgaUdxA1sXB0gkSpCP3p/VS1mgAO624nJP?=
 =?us-ascii?Q?qtuWjG5R0MkMpPgPLwbPSplkk8xBGNKwKl8wkBTpsP1QfkAnn4en2d+nu8cu?=
 =?us-ascii?Q?amXU8I8KZiG6wy8DvYG9DvYpWWDAvyNZ/8isWsRu5GhEQSnl/GN+k9w2IPl9?=
 =?us-ascii?Q?q/K9y2bzdH+W6dObJUTbrYxTTz3QAj6NDBewv0rIfNUR3Rcaqnn44PemYQS2?=
 =?us-ascii?Q?PL13S9RqRUTxuWDN+T83fkk/hXuJ4TOZO/W+biVVGXFgg+ntd4EauJT0k98g?=
 =?us-ascii?Q?AeSmI758fxbbsqG+dRDR39HcwPoPcoLQBcEG7KaNbo9t0yHVyiTfDXraFfa6?=
 =?us-ascii?Q?m58V+KiU8ZivEPlgThnzQu0nX/LzdmDr8bq7yuSrUO/tinpeQn6lxm2Vcn8L?=
 =?us-ascii?Q?vK1OlAs2H/lduxdUS8wuYPDxq987264q55JnmL6s5zY38APndpIOP1V7wO1z?=
 =?us-ascii?Q?4DLIcwi5taP8T651HeLcOS1svm2QAv1EeSYH6054kqypR4CVvKr4bFi2xj7Y?=
 =?us-ascii?Q?LhAhnWwr/cNGSVLKNjHgaqGtU90oi5RSPK9e4grzkLpM+DTBdvrxistAa1Ko?=
 =?us-ascii?Q?kmOjlJnkvuu/yggQB1RqqJKonVLkP26LcoE5QP0//K+BRHbm/QaAJ3FmkyVd?=
 =?us-ascii?Q?WxtcRmP3+wBwOekYlp7XRrsKBgEV5RITd3DzbqaKSx0qr13I751eajAtDKYv?=
 =?us-ascii?Q?CwTPXJ5QQHf7NGoTu4Mt1bcIigNJkr13+7SsxmQ806NcZCaYcXLyQGTgLifA?=
 =?us-ascii?Q?MNbJpmp0itei2xtDtGI3DDYpassCwd4XzlyzPCfy4tjXXsQM80oZsghRxp//?=
 =?us-ascii?Q?mm9z1VYKGnBbtLAZK6TqNauv71aCVXfrrN/Pa8wQprqdIae2+T9BiXOggGSp?=
 =?us-ascii?Q?jThb0MSIkbX4lTnaUi41L9ZDqAJggy91DIu9HkMiIK7edURylZXZXYopmfvb?=
 =?us-ascii?Q?rOskD/eN7ZoDBSeJZs0K32Caf+pBQeompzazxg9h6ew50euwbMbv4rB4AeuA?=
 =?us-ascii?Q?wPFNTXIg+Ia4f16/RTU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b532b20b-1945-44a3-3f7c-08da6236c2b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2022 05:40:55.9964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/p7qtQ08nvTlJkkMZtdga2sL1FtaL2q+hayECCLExn49SnD4p2xcoxANknLJccA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2994
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David.
I haven't seen any comments from you nor has it been merged.

Is there anything else needed to have this merged?

> From: Eli Cohen <elic@nvidia.com>
> Sent: Wednesday, June 15, 2022 6:46 AM
> To: dsahern@kernel.org; netdev@vger.kernel.org; virtualization@lists.linu=
x-foundation.org; jasowang@redhat.com; si-
> wei.liu@oracle.com; mst@redhat.com
> Cc: Eli Cohen <elic@nvidia.com>
> Subject: [PATCH v1] vdpa: Add support for reading vdpa device statistics
>=20
> Read statistics of a vdpa device. The specific data is a received as a
> pair of attribute name and attribute value.
>=20
> Examples:
> 1. Read statistics for the virtqueue at index 1
>=20
> $ vdpa dev vstats show vdpa-a qidx 1
> vdpa-a:
> vdpa-a: queue_type tx received_desc 321812 completed_desc 321812
>=20
> 2. Read statistics for the virtqueue at index 16
> $ vdpa dev vstats show vdpa-a qidx 16
> vdpa-a: queue_type control_vq received_desc 17 completed_desc 17
>=20
> 3. Read statisitics for the virtqueue at index 0 with json output
> $ vdpa -j dev vstats show vdpa-a qidx 0
> {"vstats":{"vdpa-a":{"queue_type":"rx","received_desc":114855,"completed_=
desc":114617}}}
>=20
> 4. Read statistics for the virtqueue at index 0 with preety json
>    output
> $ vdpa -jp dev vstats show vdpa-a qidx 0
> vdpa -jp dev vstats show vdpa-a qidx 0
> {
>     "vstats": {
>         "vdpa-a": {
>             "queue_type": "rx",
>             "received_desc": 114855,
>             "completed_desc": 114617
>         }
>     }
> }
>=20
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
> V0 -> V1:
> 1. Avoid using matches(), use strcmp() instead
> 2. Put some code inside a function to get shorter lines.
>=20
> References kernel commit:
> commit 1892a3d425bf525ac98d6d3534035e6ed2bfab50
> Author: Eli Cohen <elic@nvidia.com>
> Date:   Wed May 18 16:38:03 2022 +0300
>=20
>     vdpa/mlx5: Add support for reading descriptor statistics
>=20
>=20
>  vdpa/include/uapi/linux/vdpa.h |   6 ++
>  vdpa/vdpa.c                    | 163 +++++++++++++++++++++++++++++++++
>  2 files changed, 169 insertions(+)
>=20
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdp=
a.h
> index cc575a825a7c..7f52e703f1ad 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -18,6 +18,7 @@ enum vdpa_command {
>  	VDPA_CMD_DEV_DEL,
>  	VDPA_CMD_DEV_GET,		/* can dump */
>  	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
> +	VDPA_CMD_DEV_STATS_GET,
>  };
>=20
>  enum vdpa_attr {
> @@ -46,6 +47,11 @@ enum vdpa_attr {
>  	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>  	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
>  	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
> +
> +	VDPA_ATTR_DEV_QUEUE_INDEX,		/* u32 */
> +	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
> +	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,	/* u64 */
> +
>  	/* new attributes must be added above here */
>  	VDPA_ATTR_MAX,
>  };
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 3ae1b78f4cac..6ded1030273b 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -26,6 +26,7 @@
>  #define VDPA_OPT_VDEV_MAC		BIT(4)
>  #define VDPA_OPT_VDEV_MTU		BIT(5)
>  #define VDPA_OPT_MAX_VQP		BIT(6)
> +#define VDPA_OPT_QUEUE_INDEX		BIT(7)
>=20
>  struct vdpa_opts {
>  	uint64_t present; /* flags of present items */
> @@ -36,6 +37,7 @@ struct vdpa_opts {
>  	char mac[ETH_ALEN];
>  	uint16_t mtu;
>  	uint16_t max_vqp;
> +	uint32_t queue_idx;
>  };
>=20
>  struct vdpa {
> @@ -174,6 +176,17 @@ static int vdpa_argv_u16(struct vdpa *vdpa, int argc=
, char **argv,
>  	return get_u16(result, *argv, 10);
>  }
>=20
> +static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
> +			 uint32_t *result)
> +{
> +	if (argc <=3D 0 || !*argv) {
> +		fprintf(stderr, "number expected\n");
> +		return -EINVAL;
> +	}
> +
> +	return get_u32(result, *argv, 10);
> +}
> +
>  struct vdpa_args_metadata {
>  	uint64_t o_flag;
>  	const char *err_msg;
> @@ -183,6 +196,7 @@ static const struct vdpa_args_metadata vdpa_args_requ=
ired[] =3D {
>  	{VDPA_OPT_VDEV_MGMTDEV_HANDLE, "management device handle not set."},
>  	{VDPA_OPT_VDEV_NAME, "device name is not set."},
>  	{VDPA_OPT_VDEV_HANDLE, "device name is not set."},
> +	{VDPA_OPT_QUEUE_INDEX, "queue index is not set."},
>  };
>=20
>  static int vdpa_args_finding_required_validate(uint64_t o_required,
> @@ -228,6 +242,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struc=
t vdpa *vdpa)
>  		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
>  	if (opts->present & VDPA_OPT_MAX_VQP)
>  		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
> +	if (opts->present & VDPA_OPT_QUEUE_INDEX)
> +		mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
>  }
>=20
>  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> @@ -304,6 +320,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int ar=
gc, char **argv,
>=20
>  			NEXT_ARG_FWD();
>  			o_found |=3D VDPA_OPT_MAX_VQP;
> +		} else if (!strcmp(*argv, "qidx") &&
> +			   (o_optional & VDPA_OPT_QUEUE_INDEX)) {
> +			NEXT_ARG_FWD();
> +			err =3D vdpa_argv_u32(vdpa, argc, argv, &opts->queue_idx);
> +			if (err)
> +				return err;
> +
> +			NEXT_ARG_FWD();
> +			o_found |=3D VDPA_OPT_QUEUE_INDEX;
>  		} else {
>  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>  			return -EINVAL;
> @@ -594,6 +619,7 @@ static void cmd_dev_help(void)
>  	fprintf(stderr, "                                                    [ =
max_vqp MAX_VQ_PAIRS ]\n");
>  	fprintf(stderr, "       vdpa dev del DEV\n");
>  	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
> +	fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
>  }
>=20
>  static const char *device_type_name(uint32_t type)
> @@ -819,6 +845,141 @@ static int cmd_dev_config(struct vdpa *vdpa, int ar=
gc, char **argv)
>  	return -ENOENT;
>  }
>=20
> +#define MAX_KEY_LEN 200
> +/* 5 bytes for format */
> +#define MAX_FMT_LEN (MAX_KEY_LEN + 5 + 1)
> +
> +static void print_queue_type(struct nlattr *attr, uint16_t max_vqp, uint=
64_t features)
> +{
> +	bool is_ctrl =3D false;
> +	uint16_t qidx =3D 0;
> +
> +	qidx =3D mnl_attr_get_u16(attr);
> +	is_ctrl =3D features & BIT(VIRTIO_NET_F_CTRL_VQ) && qidx =3D=3D 2 * max=
_vqp;
> +	if (!is_ctrl) {
> +		if (qidx & 1)
> +			print_string(PRINT_ANY, "queue_type", "queue_type %s ",
> +				     "tx");
> +		else
> +			print_string(PRINT_ANY, "queue_type", "queue_type %s ",
> +				     "rx");
> +	} else {
> +		print_string(PRINT_ANY, "queue_type", "queue_type %s ",
> +			     "control_vq");
> +	}
> +}
> +
> +static void pr_out_dev_net_vstats(const struct nlmsghdr *nlh)
> +{
> +	const char *name =3D NULL;
> +	uint64_t features =3D 0;
> +	char fmt[MAX_FMT_LEN];
> +	uint16_t max_vqp =3D 0;
> +	struct nlattr *attr;
> +	uint64_t v64;
> +
> +	mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr)) {
> +		switch (attr->nla_type) {
> +		case VDPA_ATTR_DEV_NET_CFG_MAX_VQP:
> +			max_vqp =3D mnl_attr_get_u16(attr);
> +			break;
> +		case VDPA_ATTR_DEV_NEGOTIATED_FEATURES:
> +			features =3D mnl_attr_get_u64(attr);
> +			break;
> +		case VDPA_ATTR_DEV_QUEUE_INDEX:
> +			print_queue_type(attr, max_vqp, features);
> +			break;
> +		case VDPA_ATTR_DEV_VENDOR_ATTR_NAME:
> +			name =3D mnl_attr_get_str(attr);
> +			if (strlen(name) > MAX_KEY_LEN)
> +				return;
> +
> +			strcpy(fmt, name);
> +			strcat(fmt, " %lu ");
> +			break;
> +		case VDPA_ATTR_DEV_VENDOR_ATTR_VALUE:
> +			v64 =3D mnl_attr_get_u64(attr);
> +			print_u64(PRINT_ANY, name, fmt, v64);
> +			break;
> +		}
> +	}
> +}
> +
> +static void pr_out_dev_vstats(struct vdpa *vdpa, struct nlattr **tb, con=
st struct nlmsghdr *nlh)
> +{
> +	uint32_t device_id =3D mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
> +
> +	pr_out_vdev_handle_start(vdpa, tb);
> +	switch (device_id) {
> +	case VIRTIO_ID_NET:
> +		pr_out_dev_net_vstats(nlh);
> +		break;
> +	default:
> +		break;
> +	}
> +	pr_out_vdev_handle_end(vdpa);
> +}
> +
> +static int cmd_dev_vstats_show_cb(const struct nlmsghdr *nlh, void *data=
)
> +{
> +	struct genlmsghdr *genl =3D mnl_nlmsg_get_payload(nlh);
> +	struct nlattr *tb[VDPA_ATTR_MAX + 1] =3D {};
> +	struct vdpa *vdpa =3D data;
> +
> +	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
> +	if (!tb[VDPA_ATTR_DEV_NAME] || !tb[VDPA_ATTR_DEV_ID])
> +		return MNL_CB_ERROR;
> +	pr_out_dev_vstats(vdpa, tb, nlh);
> +	return MNL_CB_OK;
> +}
> +
> +static void cmd_dev_vstats_help(void)
> +{
> +	fprintf(stderr, "Usage: vdpa dev vstats show DEV [qidx QUEUE_INDEX]\n")=
;
> +}
> +
> +static int cmd_dev_vstats_show(struct vdpa *vdpa, int argc, char **argv)
> +{
> +	uint16_t flags =3D NLM_F_REQUEST | NLM_F_ACK;
> +	struct nlmsghdr *nlh;
> +	int err;
> +
> +	if (argc !=3D 1 && argc !=3D 3) {
> +		cmd_dev_vstats_help();
> +		return -EINVAL;
> +	}
> +
> +	nlh =3D mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_STATS_GET,
> +					  flags);
> +
> +	err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
> +				  VDPA_OPT_VDEV_HANDLE, VDPA_OPT_QUEUE_INDEX);
> +	if (err)
> +		return err;
> +
> +	pr_out_section_start(vdpa, "vstats");
> +	err =3D mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, cmd_dev_vstats_show_cb,=
 vdpa);
> +	pr_out_section_end(vdpa);
> +	return 0;
> +}
> +
> +static int cmd_dev_vstats(struct vdpa *vdpa, int argc, char **argv)
> +{
> +	if (argc < 1) {
> +		cmd_dev_vstats_help();
> +		return -EINVAL;
> +	}
> +
> +	if (!strcmp(*argv, "help")) {
> +		cmd_dev_vstats_help();
> +		return 0;
> +	} else if (!strcmp(*argv, "show")) {
> +		return cmd_dev_vstats_show(vdpa, argc - 1, argv + 1);
> +	}
> +	fprintf(stderr, "Command \"%s\" not found\n", *argv);
> +	return -ENOENT;
> +}
> +
>  static int cmd_dev(struct vdpa *vdpa, int argc, char **argv)
>  {
>  	if (!argc)
> @@ -836,6 +997,8 @@ static int cmd_dev(struct vdpa *vdpa, int argc, char =
**argv)
>  		return cmd_dev_del(vdpa, argc - 1, argv + 1);
>  	} else if (matches(*argv, "config") =3D=3D 0) {
>  		return cmd_dev_config(vdpa, argc - 1, argv + 1);
> +	} else if (!strcmp(*argv, "vstats")) {
> +		return cmd_dev_vstats(vdpa, argc - 1, argv + 1);
>  	}
>  	fprintf(stderr, "Command \"%s\" not found\n", *argv);
>  	return -ENOENT;
> --
> 2.35.1

