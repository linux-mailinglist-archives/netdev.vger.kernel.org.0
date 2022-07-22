Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1647A57E218
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 15:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiGVNM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 09:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGVNMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 09:12:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FCC18B35
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 06:12:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CK37BdjjaaXRFw+WgKdIdOYSXtI5xmFYmiq43mjnJCjT8wYHZ1YER2rl8HXn528Mj6uo5fpkjnXHpuF+JJ+IdbE784pRKHqx06Vs4LTagIkhgoXmfe+CVvuXmGHc/uEMDPa4RCL6jqA9uJsFuDIEOahJt4dURqL9IFxB+6SIr2lxhDSTouY7lanN6CDRgmbvYX3rRTxQqTb17dKnPSpVjgWchTt/2CXDenL/Kqp6oegDSwLgh9dsrckHNmzC1Amv/WMo+7eNSANJQEp2iu6cSHopt5T7ntVJNAKr4H5VnGXqZwCixvS31W+dce+73QsC0CUISfcBMym3rmaUPFG5RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7a/X655N88yBa7mmTChUsDHTl06PUBRU8r3olzpFZdM=;
 b=km6sKnev3ddwZBcrmtvxTpmHpoHLHy6b6927qIARXiCFRIxsIse7WztJhqf+3B0GyOQ2EZ3y8kUkW8cHeptt5PLrw6H31u06ztIWKxksU0UsE06+5k6bb53orJ5Atapm6/CHL+jlnYgYiLnTFaA6LMb6CTVY5hR9bu9iNhmsduHGCdwlFSPi82L2LBlNc6XCLssgOElZH+61P9kjuekr0hhuUFunVvDuQYRNNLkh5HIZTeOkKUUM9otWLVYUoe5QGtC7AvSt7eIj02Qj1+gE7baemQfCoXaS/os0faLCEZXXEuHV1PydFAXit05bCT6b9nkuPeA+I7htRsNeQxu1Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7a/X655N88yBa7mmTChUsDHTl06PUBRU8r3olzpFZdM=;
 b=uD0XGIqHKNiILf/Zn0/BXn7sJIfRQl8LUG27f3Tcj5z7eMI9sj2lOlCvZJsscOMeqAh6GoZCAgFk2bizFplF3eL4nxyFBCEl7xuP4+jZ8HfsR4asWxOHb1Z81x57alFV5lTND//8BEZfokBJRu6q0fy6qtml5Ug/V5Z/GFM1+z9crF7iRoMZ7qZFAFnVwUiYggwmayI4n7mgmpGi3xh7Ygv7GCNDpQM1AwGWZHjZ0VbY3unheOx9vIt1I225KaOk+VNCZhZStfcmOKMqWMMlbswZ8L8Bd2EGg+FrX5ZJ0j3FVZc4lAaQ8FzV4NfBgCBrceO+vXCM9hvw0608aGJO5A==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SJ0PR12MB5485.namprd12.prod.outlook.com (2603:10b6:a03:305::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Fri, 22 Jul
 2022 13:12:50 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 13:12:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYncLBTkGC7Q3QJk+hIdvX3SqZ2q2KXRuQ
Date:   Fri, 22 Jul 2022 13:12:50 +0000
Message-ID: <PH0PR12MB548193156AFCA04F58B01A3CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
In-Reply-To: <20220722115309.82746-4-lingshan.zhu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a71ffb8e-88ae-42c3-10e9-08da6be3e0f7
x-ms-traffictypediagnostic: SJ0PR12MB5485:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EZ4qAXV7SIavixiWVlOkqf12PlDTO3t263RmWeTyPkc+ryMRFXOXGJB45K1ncCkdcJJ2VZI9GX4OQzxjSyvoBrmZyn2NzYuEIxBwtnnsMEhUKkYsVGW7874k80w31UU5BWzSNkWKM36I+95XSKy795JEVR1ptmLnrUUQdgPOlf+R0jhNffih8hrWMKOvwTlTM9MeRkHnNmJ9C61OCqYQraDnRe7j7YFBLXbUwRYGfRz6b77fchl+eBLr/qC99Oasd1YBhmKAc8cm1wHeEPuSVSFsBmovhqZIcQJGCtF/if5yyVSa4XB7DGtPO5yHOY/ARTf6SC/jPm1PLGLKz4ZWS9u6pIUEhL+bxMCFNnCpnK4AAP0Gq85GH33xJMDDHc9uh1n8ahM/qtppyfF/G/9YFrRI3W9+CUlPNvR/YBg8M15dCIf/rNQ2U+mtPGLMYkUCYYybRJS4H4NzNEz5tJ16QeceQDp3F6s+Jm/NVZt/C/33Ec27i5pk4eL1oYMv4DBjPMKPg2H2fYR9HT8XIHX7PAAqE260Xe5gBcNten3ywQjPyMoulJ8urxI1ZzeU9DXUeTd7ApL1hLbXVAK30CDUhJzANsZxnmYKjSHmmNu1hCb8jx/XZqZI94w1cXv2RpoUal1rJXudOyy39ViR5K9KTEqlgxH/yN9K+Z+IH9cErPzjxvuZVbrDzHXMt3V2tiJOfEtEZKV1BtS6e10t21d8BUqnnav5z44ie2ycNeqGgLZQOXPokroP0ezv1glzL76dNOZ/aBRDgiSdNg+/fqJCoCV1abhZrUXtK0KVx+vY28zadXPgxHybeXBQUUDGe++P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(186003)(41300700001)(5660300002)(122000001)(8676002)(66476007)(66446008)(64756008)(66556008)(66946007)(76116006)(4326008)(9686003)(6506007)(7696005)(33656002)(52536014)(8936002)(478600001)(26005)(83380400001)(2906002)(71200400001)(55016003)(86362001)(38100700002)(54906003)(316002)(38070700005)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1vQ+D/rKlyivX4Xdx6YOmOhllaKMRi5TegfksBuaqPy/iG1PWGMnHta4XTaD?=
 =?us-ascii?Q?Dke3NIHil1KhhnLFFVaKeDHwtm0GQYQIPMve/Epni0oJdjhAgXesiBaps+Hv?=
 =?us-ascii?Q?nNj8NB6C3T2ma60r/ujGHOluPtzmUXB8NzIHDZ3N7VaCtKSfZpxoR5dV8eGc?=
 =?us-ascii?Q?G8OZZ/m1Dva05rd+1lree5hMB5JRZcl6LWdQOcurEh4YBoTqGEKB/UB1Aza3?=
 =?us-ascii?Q?5uQ+0o5azcyz1Wsnu5jR6wTao7Qyj+dfLMw5lSXdfBw68zzgvbbhfRy9cdz6?=
 =?us-ascii?Q?NY3LJYZ8anHMWj+CZw8S6nQ4CS+5KkO/cdWxkZTBjVOVZjKZkA+KZfIwbvWA?=
 =?us-ascii?Q?7KMbFYwMxF03vYiVzQ8v5+gAq4mqUoMFo6kjG0C4Q78V+o9NTrJlBdZHM5Lc?=
 =?us-ascii?Q?JYkvQgCeyH2r/mlQ83eiPkmnXBh1aGHfdBArO/aCqtoAX+Fqbx83Gy8ePLX1?=
 =?us-ascii?Q?n/miRzpATsEau6aGjvysIzHfOBk1PcoSV9IPSz/bqDOgwMbm2zzwBTk5riF9?=
 =?us-ascii?Q?1FBFuSh8U2djqKmXVZgA/C2qNviF4X6vPDQogNtGJRFhmnVFGJIFH2ZU4BTh?=
 =?us-ascii?Q?gpmuSLtrn1yeo5Wo4Y4K/5DJxzidi21PPTm5zChcGfhxRJ0u4Ahpk3hDeH5j?=
 =?us-ascii?Q?QmbESzkR0LOyXBRs1YOhi2sLGLOWxC4Ne8sHZiRKTWiQ6RjCmMQvI98nlZtz?=
 =?us-ascii?Q?l9qnSiB1JlEmfau+KefXRC92dPPmYa0NwOenqF3fp8TZYCXPjja8c/aGE21r?=
 =?us-ascii?Q?aOWpau2r27FnKVV4SXM85xIfUT222i2IBvfhpt1/CpdEblzbDZDUN3eZCFGJ?=
 =?us-ascii?Q?4Lj3DfAV5y3+RIyyMKXgZumObGTvoIY1W5GcqHMz/q8ZYUXilkAW5l6VkVWy?=
 =?us-ascii?Q?E4to8gpg94bt02K9hEqrBmJfbt6Tj3ptHOIj72L/PPyHNnQYPYSnMVYpWc06?=
 =?us-ascii?Q?WdXUqJX19qfOsbOBs6OG5atUscIIcQAvawA/6K3zuI6WuKDAt2wOjAtvQ9EH?=
 =?us-ascii?Q?YWi7LX5R167HP/1kS1E7ywFnp0cNRgGcgfizYXDtNX2UwmYmaiuGur1nRcfm?=
 =?us-ascii?Q?G0kHmkzCaj8YR6/LoBX+sSQ0FQDN5jUoZ+wMKB+RDKJR8u/cLK9SX5kQvfVy?=
 =?us-ascii?Q?QU77Xxhv0VKzQHVV6IyOwWj7q3EZNYGrhkAnWg9ZuZ0sYZ5OD955MzKlHbFI?=
 =?us-ascii?Q?CxNfsdvL4xF0UlZtqtn5CX1eWbQ7HeHmxOdulfjda4xXSznIZZW2rC8QEfMH?=
 =?us-ascii?Q?azFerVZQqEJaiV2v5Q5l2/aZlMm57vAhEO4b6A2GlQkUIkvmdTrOEwJxLaM3?=
 =?us-ascii?Q?NO/9AeiaFUyQWo/krHLmzULEvduGE2NUH5qelFwioDJWC8Gj1GYfGKvDS8qd?=
 =?us-ascii?Q?YSDsiLD28VNSeFATrqKkQKc3v/dgINk6N5UTsVuQLMooyewmIsik02fcjB/2?=
 =?us-ascii?Q?7jjFodqf/dRzEm9TWfvmoVMpaGxcZXyuipxVbXrIJxDE0EQNNplw8xJwCeOl?=
 =?us-ascii?Q?OhuhupDwkaH8MFQ42cy2hyfQNxXHmfxJJ48tbqMy4jcsE8qvcOP15MKWzS9C?=
 =?us-ascii?Q?f6fU6/cphuHdNdd72Sc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71ffb8e-88ae-42c3-10e9-08da6be3e0f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 13:12:50.2070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B/G+LhufemYa5/T7ZHBisSLs2LFXczxaRKroOY8CBjirC/A5FWEzk2SwiIf0xhstlXnQAc1915bHMevLdxS5YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5485
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Zhu Lingshan <lingshan.zhu@intel.com>
> Sent: Friday, July 22, 2022 7:53 AM
>=20
> This commit adds a new vDPA netlink attribution
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
> features of vDPA devices through this new attr.
>=20
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
I have answered in previous emails.
I disagree with the change.
Please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES.

MST,
I nack this patch.
As mentioned in the previous versions, also it is missing the example outpu=
t in the commit log.
Please include example output.

>  	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>  	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
> --
> 2.31.1

