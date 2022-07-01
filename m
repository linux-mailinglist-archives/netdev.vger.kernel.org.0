Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EC3563C23
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 00:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiGAWCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 18:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiGAWCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 18:02:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419E834B8D
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 15:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTChxqBfRe45p9i6Md5MkXo/HnR+P+H9lSEZe7GdSrY+4Y4D0BAOKz7OliYWe1+cEq7Ja/jW8BcmbJ1x2kMa/dJ71zzor/eWEhdpn4+sbWTZhUEHED71QcLEi7LxjLUkin2G9xXnyRp7lqa4P+icSg4nQvtQSWsP9UEif+N6iTMqzLv4FWAT7QxGXeLF9YR2b0PMkHrHNxdb0JYrBOWkHUgqRJGLCRHg1uq9FTFleOwBGYCUvLxLrz7SS/u03S7r6UIHHTWpUbK7tv2p088VimhCx7GRT51+aIC69KBvTiyie5Xt7XfyaXd+u1AJ5ParZuDQT3/JBmC1MMV1K68fDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNa3U95dcgCpq68d7tHlRE4W1bSNJ1iXChOdNaDZKOo=;
 b=YHdG+StRtJp1M058ak7M1y7v92aEDKwF353MCrvGPGBb5dM3d2aWlJU45QmrEC+mv0lrIWvZ44E3TwvDlB+7DF+kJ5gtzf9+y4uP9dn2cdtZoWxrChVxNN3azC/zW9SC1KPudojjNz2FQYz5rRzFPFT3EXhKU6WF0RQc+mYs7jBQyIj9bes2UV9EtbluEUn1FA7Eynp8rTGRZbpZ05Oe+bsaQ6X+I/zJoEPG4AI2SYoAHZ4gw/V6bp+dEoTU0ZiCUWQSe02XfmrTVUDNkUChSrgXEvdAR/cFDmfPPZGT90T+zl68DZlvWj0fsgKcDib+Q5dfqqxcE4TvSiXp7OePMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNa3U95dcgCpq68d7tHlRE4W1bSNJ1iXChOdNaDZKOo=;
 b=MFQh/hpivfaOZcmK2YZqgm18HkRwtll3/CWPlyAbGYSKxF93ZPODKKI6LJsVNe5DQyxIFBWMpvbB7iC3nk9xpzXpRrfFfeX3vi2kQR1p1HcepSHJtasdrSGhFsfwOHwtfgcuNCvIhp6260dk4spwa7O9ADxYUraL9ejJ1OTlq3j01110XjHZonhFueh1NQNpOvdYcXVFolCJvz6jkeA959iVlQUCicrMElwmSRGRUpCej3SuhtqZ0OkFN2S7I2mUHOiGHIBZDj5r9qX4VmXCpq8QdUG2NVG8zbz9gLk+zJnuNwpsB0rT8GO0/gEVMHl+W3bUemruA6rCsSzxrgdZJg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY4PR12MB1255.namprd12.prod.outlook.com (2603:10b6:903:36::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Fri, 1 Jul
 2022 22:02:40 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5395.017; Fri, 1 Jul 2022
 22:02:40 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYjU+MYrbSKcBokU6ni+IvOk3zwK1qDqQg
Date:   Fri, 1 Jul 2022 22:02:39 +0000
Message-ID: <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
In-Reply-To: <20220701132826.8132-4-lingshan.zhu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d75d183-99f3-4d93-d0ff-08da5bad6a80
x-ms-traffictypediagnostic: CY4PR12MB1255:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xWbSRgqmp9LJO6/QijT0CBp9E5U+wBlNKTpBOLhF1zR6cs0AkXRh0qHjOcjauRE6wody0fppatx1d4z3Im42OoUSUddRyd3y01NqNgRhX+WSdL9qlXErW1Rlo+FAjJMr8xld8cBfKRmeHsnpaD7PH4oZh+LzQtPK4+K6Dg8cJMP+jFIsEGkUQeZT8e99s5Tosw9525wku7353Y8h18hlR+tNz6O9sHICue7iviYM11Iv3Od5vBQki5LFSZXC+z3qoI5EcPVeEM067NaFMOSuR9aQCpvho8MW/Zx22ilU8Hvz68pNwYSHwdkoQy/8uPFzWdQ0pnJBCuHVFtKzO7sB6gZOhnrVr7aw3ocGKSmNy8QR3S0gT48XvLaRbyJl7DgVMszUS3XHsAo4KX3ym61FMSrLDPWmlbVtrrgdMcb9b4hwXORF/ck3Z+NwO6wslMMxJfWFN5Ikfx666WfJnqsKFL+actCHoZqJMzehXGO/I1nh+8qA25Q/UJ3Oc7sQFOSWVtGaG4A6HGqZOnUug1HwzGmJv2XPoNl7pc/SldO50IM/fjiFZUM0pH+kjthiVeC7MuWoixeJ6iWb+XHDEfB3i+/SXmtwBosGcizt5WpDEkVClhJv83B5e6UBiHX+9dotMz7oG8n1BMrEeJk7aYbnQ1uZGCfBP6fMCYhtA1PmyYw8IKUWdY5H/BECHiPGkoUKzCgeaCY2NvAF2gTA0hPyY688w5VihxmUmUGqCah4hyyTa5Egsl0PWQWirdckWWBlLM50GltUh9ww3hCCOaZ/as6wREfB8M3RcOU63QZheCiQZshh07/GlpCdQ191PW6a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(52536014)(186003)(83380400001)(38100700002)(76116006)(110136005)(66946007)(316002)(66476007)(54906003)(66556008)(5660300002)(8936002)(7696005)(66446008)(8676002)(4326008)(41300700001)(2906002)(6506007)(9686003)(71200400001)(26005)(64756008)(33656002)(38070700005)(478600001)(55016003)(86362001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M+h/49B3R//ShqmTkrjtS49dfddT79Qv6WHhw22PCM9BlxHpoDHiv6rnhied?=
 =?us-ascii?Q?Sk0fIA8rRL6oPgWdqjKgasaFxfLw4Epw9dSPSP5bkjw6ypdBx0WfUqaN41vk?=
 =?us-ascii?Q?MR4P4726snK1ktnf3KyPCy0BfrKUfaxksAd69Qm5FTVg1sLsjdSjvbTulSCD?=
 =?us-ascii?Q?Ym7wpXpetrnaONhxrWaC677ImJgwDxw1w2GGeln49g6aCGS2FoqCMqDTrhQi?=
 =?us-ascii?Q?+TxvzsUia8K9V86In0LxCudH6RH1O1MMdZ7k/jRQ/FUVu8CgnhshUbcbdo2g?=
 =?us-ascii?Q?0EagMhwZMlcbfh4uLccARi6hOTPa8cxxK2DxAqIW/HJLrTWBFKQmAX6pOAWI?=
 =?us-ascii?Q?UFj8gw0+DB4TWoWBKDAEGXQAaqLDjAeYRw/L9nepVVFANvB772nh0E52AYBM?=
 =?us-ascii?Q?+8X2pdkk4YN9Y/6gHFJQF2VKYmv7Rz0gvry9pFfq5RrCNTn4PFVEleKcsrgR?=
 =?us-ascii?Q?3XjY6x6qmevYpFNQfczgwN+Zf2gmIP2+MSR5s9oT0bdL5hdofs3sgsAV9hOP?=
 =?us-ascii?Q?Rxg596SKch5Zj90H+uSyZUP/EXzlzD0cI2PF8lxX0xpscQtZbLjI24Kikl8Z?=
 =?us-ascii?Q?UrbhvBYoT3Sfz/m92VEpy+oaaf21Zx+72cETNsXvNO7KcnFllMLnkL/nTFrX?=
 =?us-ascii?Q?q6DapiRYMf046mcGoimxF9WKvs00heET/I72HNKZtm83y9vtDjVDhaRR0wvh?=
 =?us-ascii?Q?/eezUMaio94t20UmJE4f99xO3I4iycz9JE84WB1w8qjmkgfq8+m/wUAe20ww?=
 =?us-ascii?Q?IxxphY650IhV1CrPyL6AtPWOaHEvNQSmZkKSb5uTjAPHfe07MVu89RPbTIWB?=
 =?us-ascii?Q?egDiT9UveKO37kJtkezA/+NT7S9Aup+GLd6tfI5HsUIq1+PnPBvtJFghWqHH?=
 =?us-ascii?Q?i8RqQMSk/LdLM/1Db6aXJOWcDtcZT0Izsp6SS2FoN2rZmc3j5/P+K7l3yk4q?=
 =?us-ascii?Q?4emQm2SeL3FC6fjNRXAfP82MV1n/SLOgknX1ujSPVE2HHK2PAXq6fYBflRgN?=
 =?us-ascii?Q?Ta6pK3iv/YSrnGc/XJwnVGIjWuPxPS87RQ4fGbITKaH0vFGP5OXYRd6jMusr?=
 =?us-ascii?Q?/1a0xN+Zh8CG1dosVLkmEci8m6vOeMQt/hdD7GN4fxMfETwUsTjOQdelOJdF?=
 =?us-ascii?Q?ojJ4hN8KIpiBSxa8FLSYXn4CnyfX3KGlYRJVIgv+Qe35f7WNUFv7PwSnVUR9?=
 =?us-ascii?Q?nSL1ozbGtWOVcM0UCGgGEAMJ31DNWKytrntSA4dQDZyeqoa/2eK0+i3n+oW4?=
 =?us-ascii?Q?SXk03oBN4DYrJbu4RqM+KUgQrPKKVydJB3qPIsyds9Vn27DCzI88IHWsiBUa?=
 =?us-ascii?Q?Y4axzc6YB1Vq30fTqBuKC3GzrO57P4BMbAQQfUFD5VTHDZjXhqZtkum+wFDO?=
 =?us-ascii?Q?jv0GOxQhJRlUl+a0T1ELlF3eFHm4xUM2YvJVPunrxRs8519b4XA4CX+A/EMz?=
 =?us-ascii?Q?IiHib4X0+MLK4cw4CoQ42K9p9gLrV39m3I7BI+VlGYWC5gViwPFv+n7ZkpI1?=
 =?us-ascii?Q?7WLDxt99K/UkQfdO5uMIs9ljJpCC6spezD622KmEKXZu88b/X9SazZ3HTO15?=
 =?us-ascii?Q?894L7a+GgYSy2fsjIbs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d75d183-99f3-4d93-d0ff-08da5bad6a80
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 22:02:40.0018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2rcVruDyg/5puhuDzmCULjoBMltU/XS475wRCLd16R4JJfvQr6NwWryOpga3EkIViwB/0LdI0AkGa1Ie/ivbBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1255
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
>=20
> This commit adds a new vDPA netlink attribution
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
> features of vDPA devices through this new attr.
>=20
> Fixes: a64917bc2e9b vdpa: (Provide interface to read driver feature)
Missing the "" in the line.
I reviewed the patches again.

However, this is not the fix.
A fix cannot add a new UAPI.

Code is already considering negotiated driver features to return the device=
 config space.
Hence it is fine.

This patch intents to provide device features to user space.
First what vdpa device are capable of, are already returned by features att=
ribute on the management device.
This is done in commit [1].

The only reason to have it is, when one management device indicates that fe=
ature is supported, but device may end up not supporting this feature if su=
ch feature is shared with other devices on same physical device.
For example all VFs may not be symmetric after large number of them are in =
use. In such case features bit of management device can differ (more featur=
es) than the vdpa device of this VF.
Hence, showing on the device is useful.

As mentioned before in V2, commit [1] has wrongly named the attribute to VD=
PA_ATTR_DEV_SUPPORTED_FEATURES.
It should have been, VDPA_ATTR_DEV_MGMTDEV_SUPPORTED_FEATURES.
Because it is in UAPI, and since we don't want to break compilation of ipro=
ute2,
It cannot be renamed anymore.

Given that, we do not want to start trend of naming device attributes with =
additional _VDPA_ to it as done in this patch.
Error in commit [1] was exception.

Hence, please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to return for device f=
eatures too.

Secondly, you need output example for showing device features in the commit=
 log.

3rd, please drop the fixes tag as new capability is not a fix.

[1] cd2629f6df1c ("vdpa: Support reporting max device capabilities ")

> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c       | 13 +++++++++----
>  include/uapi/linux/vdpa.h |  1 +
>  2 files changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
> ebf2f363fbe7..9b0e39b2f022 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct
> vdpa_device *vdev,  static int vdpa_dev_net_config_fill(struct vdpa_devic=
e
> *vdev, struct sk_buff *msg)  {
>  	struct virtio_net_config config =3D {};
> -	u64 features;
> +	u64 features_device, features_driver;
>  	u16 val_u16;
>=20
>  	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config)); @@ -
> 832,12 +832,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device
> *vdev, struct sk_buff *ms
>  	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>  		return -EMSGSIZE;
>=20
> -	features =3D vdev->config->get_driver_features(vdev);
> -	if (nla_put_u64_64bit(msg,
> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
> +	features_driver =3D vdev->config->get_driver_features(vdev);
> +	if (nla_put_u64_64bit(msg,
> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> +			      VDPA_ATTR_PAD))
> +		return -EMSGSIZE;
> +
> +	features_device =3D vdev->config->get_device_features(vdev);
> +	if (nla_put_u64_64bit(msg,
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
> +features_device,
>  			      VDPA_ATTR_PAD))
>  		return -EMSGSIZE;
>=20
> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
> +&config);
>  }
>=20
>  static int
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h index
> 25c55cab3d7c..39f1c3d7c112 100644
> --- a/include/uapi/linux/vdpa.h
> +++ b/include/uapi/linux/vdpa.h
> @@ -47,6 +47,7 @@ enum vdpa_attr {
>  	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>  	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
>  	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
> +	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
>=20
>  	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>  	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
> --
> 2.31.1

