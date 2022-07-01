Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7ADC563C31
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 00:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiGAWIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 18:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGAWID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 18:08:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA93461D52
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 15:08:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Su2PjpK2ifOFJbfq/ApiMXf7UqKAfFcKDe2QTeIx2FWAdHQsp0fRgowTAITUEYMKhLxkgkpmUtb99asAUtkp9Y3XmbCftCvoTofz9klt8UHKVb0Xhjhzz9FJLcJwGP6UOoWJa8VTO2LDL3ExFRNZ9WHz7i21LKVnKdJqSp68eXX90KHrRzP1Ph2lsOMTddDfH2GyQhGcOGZ6ckgs7QIKq9S+z9SJN524bMWC63NdPPvntTzzvSOMX/yRj2LK6DNEgrWPNcMv6FMWl0JG8VKMjfMTMAO8K1AbNwX6S9yCLnHbli/nHGWMHtOVC1aZP+3NzMowXt1jrRFDl+ptgemGJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KowlBwQf/GROEKoHqgXYX7FGWvyeuXWp7TiWh9Y43RM=;
 b=NKYX7nz34/WWRmu3KD26F70YiQdR3D7ughPQZGsD4PsiESkm227+qNhDJNapNYGidUHkxKVN+FKUEaffnrawqFhAyVbCuG9wyOFY2RPuDMS30rl8ZC17TwJgLUOr/WftfQxr/rdnCG02dLOBkoHNAubwln/0H2ENfzPTOxkfDmilHMQ866hDxMjo9xXYTEamU82wAfrRPR8BVlPyacVLn8hVmy6rp+muh+YbvbdarEbI2N62JJyCGr/0+N2Wjd8TO5GRoAyYoaXHYv7MkXylUemkcj4LFHwC2XNC9wZYof0x5oAMHwyzronZswNszjv4RSX/QGeUfcENhNVVYQWsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KowlBwQf/GROEKoHqgXYX7FGWvyeuXWp7TiWh9Y43RM=;
 b=N5mAbvH4bTSkyh82BGInc+V/8omtmUMv1YLQhtXuZWc1zPLql0RgGJoHyIT/EA10AxPMS5mCWAsFomXwLnxuwt1rszYieQzZBQUVdW4sBsxbeHzt624aW/EOtafWpbBZLRgoCJb/1eh5yUIOA1V1KJOG7EKVFLCLuE3DWqgneCEN5MD6asao5IVfIeQp47ctpw3r5rPN2h35JeOm/XD7UQEY4NiaEXhu3lvx2l6zPVA2TgVbrf9SUSnM+bf8e2sSUfCqrsI0mh1HtOt3wnZI7xBwMUyfam5BN1qTNGryqlX51bT6s/z01WiJkDCEjf43ForSBJafxmfFrRFMR/IMTg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BYAPR12MB2677.namprd12.prod.outlook.com (2603:10b6:a03:69::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 22:07:59 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5395.017; Fri, 1 Jul 2022
 22:07:59 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Topic: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Index: AQHYjU+OpP/4aLhN20eCCMO4rbOEoq1qElog
Date:   Fri, 1 Jul 2022 22:07:59 +0000
Message-ID: <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
In-Reply-To: <20220701132826.8132-6-lingshan.zhu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0cf26a3-675a-43ca-fd69-08da5bae2902
x-ms-traffictypediagnostic: BYAPR12MB2677:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4SoVgryz5LCUsGxmcJBpbufETux/3a0Yl8yHSC7DcYUlVE1+4S72bQ/xAtvE7VBCqOmv3Wr0i6e/UiLdwwPPIwqaXcz7NAxAXN2P30xk2m7Vcif2k3Q4VMRHImazg9DVIG2LhdDIs+1SQhZWSdkJjDHo72FoISY9rSRHqPECWs/CYWj+3MUiSgrTqzDmWUfSVIpTV4ncjE+6ZSFpaL+pXFE+MzrzXWV9B/7duMYFjYWtUBMjaVfbJlk53jhJog+dKnX32MI9PKTFsIZNfNcZwLWLUaY+ZjFi4OzNJ4ej9cYIyqx4w2DtKzPgQGnqfgQOnMfMnh6By1y76DnTp2kvhOfOOjopZenjS+IQzYJ7DK3DNskjB3ln+oJbxtwz8iHzYtve4NqYuHeCrTZD/7P3DpbzSGsTz+4nqqOgHdpJpRaZdp839xaPJJ0R6JHXaJ97uW0OqKXoSyrG9zBwWPMS110UEYcHo1XIf4xg3KfbO3aotY7GqnpEcFlbdEgu9inXIPe3Uzte4sv+uHmzbIKWupX1C1ki8UtKhZDrefMqbkbDzQOHIHd3urt2ya77rCCBZ24qn1oO04kwhe2Ije1B6u0RetbAuD8Mdyl4+hMwFcsRiOL0farweP57GgrBoznzgAAKh2tsZENsd8H4IItECedGlxlXPd7FoybNNMc99fu57CxmSR21par/lwvH3vlf2ZWdAaklVrC7lqvwI3R/E0kS/9pbVOgPNPRw3Ysn76j03FTzNVKh3LjSrQl8foVccSOPjP3O+82gp1K3guZu4SG24WNu5ttaUjnlVY2Z1Z+0b0XJFe5f1nwbj+Mmj6eM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(2906002)(8936002)(38100700002)(5660300002)(76116006)(6506007)(26005)(478600001)(52536014)(33656002)(9686003)(41300700001)(7696005)(83380400001)(316002)(55016003)(86362001)(110136005)(66556008)(54906003)(66476007)(64756008)(4326008)(38070700005)(186003)(66446008)(71200400001)(8676002)(66946007)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?keuFRjbQDV4JiLommJmKsBfWofBNCz4J1wHK2g/pJqthlFYA2eXbWU9aZL5j?=
 =?us-ascii?Q?zu3i+nyfZtwZZmM+hr4D5ligjpFavxwnKThJRiqND21hA8ulPbXHCV95/Mmj?=
 =?us-ascii?Q?TvkB5fORsXDY/dnz8n9N4PnXCpDQvB3vDWz4lHax7Hp1xkY96sjAuC78Cv3a?=
 =?us-ascii?Q?Ob/DzWRoYR1gaYqu1rlJ1BsgzRI2U5CzgVyDSvVXYmbplgCHXmX9tYGil9ol?=
 =?us-ascii?Q?AoilPqm8/1YzBJG5UwCDBuJJLyD8t9i7skHBZcuPNquulGOWw+Njp8bWhdDy?=
 =?us-ascii?Q?z9faJBrgw4J2mntALaOGk+MfIKw2X1/goVESxffgCKpmTVPzPv8ZsnD1HFw+?=
 =?us-ascii?Q?G5avcI1uRn91TuhbQYA475bDMixR7Y6pZ7yiZQkSeQC+0yvlgr/uno5iieU7?=
 =?us-ascii?Q?FexT0pSQrgkcTgNqdDLBO6Do+AE5LNv7f8mrV0Au97ZpZdTuUBQ/Xz6fJ9vi?=
 =?us-ascii?Q?IS8k1xGG0IMghsepdIBp2S0OSBQfFrxpkw64F7FuT3d1nN4NsBzOyzHPP91I?=
 =?us-ascii?Q?KWHKs1odHJI5tsnGzOkwkXB/8xftp7TdfDb4y6Dn7HqyIFL2UgWo8SJ/J4Hr?=
 =?us-ascii?Q?YOMnRGBvcr/A8k0O9GvkLRdrxkXcAezEMiAVeVlW8XUsI3DP0FGyr9bCYgc8?=
 =?us-ascii?Q?no925nDqk8VoHcTpR+GZ7F/fD6ildkIyYO4vbJjo2FwTFx49YPPsc5xFUwpR?=
 =?us-ascii?Q?78F1s/WrdI/ISqFSQarZwEAcLroOMXXYJwxKGSwoBOQPzrF2BNuB9/zhrrhp?=
 =?us-ascii?Q?UWyhUiVKQK5lh3JYqfE6e1RchbYazjkLqOX144+b1+JV0BT5/op+iF5ENzrg?=
 =?us-ascii?Q?ZI2YGTAG13njSq+JH9apUh003zNfPgM/sbyl6awPXuNQbsjPZPz1yVAg10/6?=
 =?us-ascii?Q?lYj+SWLbjsiEbQbmKlm4M67pD8+8RUTCFlPxXabRI+gqC2SCcsOqiGD0D30Q?=
 =?us-ascii?Q?1NWde746iu2pYk0hPt6PRyf/7CAdAhdvo+aPM9QHXSsnvOI/HvBtO8YNDxaM?=
 =?us-ascii?Q?Dg2uO/bgWFHPZQ+9V4sNLEzzNqBXHFW386P2rg4drKJVg/RFASQlnh6waq5d?=
 =?us-ascii?Q?qkLvkzSSti/FOoo+Rkyv3BmA7JuM7d2U5k5xXXFVlcPYkimA5O+b88Hp0Hs+?=
 =?us-ascii?Q?F69InkQqwd/iH/1avSK325uxRi8niTFb8ZMoHD/cl1yOxLMwalr1yHYVCEg0?=
 =?us-ascii?Q?MZ0zEMO1R9aOjFg2JM0nplVgoYQQXjYgRuN0LJldql9xrtPbQpuMvOx3QLjc?=
 =?us-ascii?Q?flKoNjghrS8eQD1+OIzuJF9tyhBJXnAq8VbnbZYH5YZndsstIBnaNAqmw4cp?=
 =?us-ascii?Q?R5C3zBYA+JRZ3UDEsZRjzFj3rD+55a617F9IhQWV470eTQ7vwzF3CpNjjLs7?=
 =?us-ascii?Q?JF216mF/NluSOEQXULVqFSCOg6eDdnWfB+Cy9gwzyyLMnGR2fgUHbPJTIpZK?=
 =?us-ascii?Q?UJVq/EkVVfL49eeTk1qeO1m9ALTFb52Ub7hx82D1PNjygCJ4IDS3MVe/WulE?=
 =?us-ascii?Q?Jp2r7+A+LCAxELsAFtQTQUgjffr4LEbJzouysvIzoZHp1t5AygTV/JOVTb+s?=
 =?us-ascii?Q?5gb4R53HeZZXQpa6Zgw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cf26a3-675a-43ca-fd69-08da5bae2902
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 22:07:59.6532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ku+9dR6G6/HFavolS6OI9piGGj++eJtmCr3XdzwLvlFM+9m+0akeOqTBb4y1vie3LUQN0K5vAhu8fbJ19/PazQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2677
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Zhu Lingshan <lingshan.zhu@intel.com>
> Sent: Friday, July 1, 2022 9:28 AM
> If VIRTIO_NET_F_MQ =3D=3D 0, the virtio device should have one queue pair=
, so
> when userspace querying queue pair numbers, it should return mq=3D1 than
> zero.
>=20
> Function vdpa_dev_net_config_fill() fills the attributions of the vDPA
> devices, so that it should call vdpa_dev_net_mq_config_fill() so the
> parameter in vdpa_dev_net_mq_config_fill() should be feature_device than
> feature_driver for the vDPA devices themselves
>=20
> Before this change, when MQ =3D 0, iproute2 output:
> $vdpa dev config show vdpa0
> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 0
> mtu 1500
>
The fix belongs to user space.
When a feature bit _MQ is not negotiated, vdpa kernel space will not add at=
tribute VDPA_ATTR_DEV_NET_CFG_MAX_VQP.
When such attribute is not returned by kernel, max_vq_pairs should not be s=
hown by the iproute2.

We have many config space fields that depend on the feature bits and some o=
f them do not have any defaults.
To keep consistency of existence of config space fields among all, we don't=
 want to show default like below.

Please fix the iproute2 to not print max_vq_pairs when it is not returned b=
y the kernel.
=20
> After applying this commit, when MQ =3D 0, iproute2 output:
> $vdpa dev config show vdpa0
> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
> mtu 1500
>=20
> Fixes: a64917bc2e9b (vdpa: Provide interface to read driver features)
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
> d76b22b2f7ae..846dd37f3549 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -806,9 +806,10 @@ static int vdpa_dev_net_mq_config_fill(struct
> vdpa_device *vdev,
>  	u16 val_u16;
>=20
>  	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) =3D=3D 0)
> -		return 0;
> +		val_u16 =3D 1;
> +	else
> +		val_u16 =3D __virtio16_to_cpu(true, config-
> >max_virtqueue_pairs);
>=20
> -	val_u16 =3D le16_to_cpu(config->max_virtqueue_pairs);
>  	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
> val_u16);  }
>=20
> @@ -842,7 +843,7 @@ static int vdpa_dev_net_config_fill(struct
> vdpa_device *vdev, struct sk_buff *ms
>  			      VDPA_ATTR_PAD))
>  		return -EMSGSIZE;
>=20
> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
> &config);
> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_device,
> +&config);
>  }
>=20
>  static int
> --
> 2.31.1

