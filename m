Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC6A54A0BE
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 23:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344939AbiFMVCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 17:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351476AbiFMVB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 17:01:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D062870C
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 13:36:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dk6YTbGoqOSRGgM82G658vYBXZDpk3fh2ZHelL+Xy7X0Gky+CD+RZciO82wKsuT4H98ggXkzextA8iLhsSX1/Q5IKYtSNFjha2sd7hlEiKXSppu1GWgGdL9XtDEy9Kt6Zq2CT3iOtBC9yKnu1EM49OmTJA6pwV66+ldwgKfatuI3DVFk+4wgPldQ3D1zW3hAe1P3Armb+DG5oJaZO8O8tz9i/tNuenPM/tsbAMk4jRZQ/joGEqoZ0Kp87i9NdreB4FKcA6PmFW5L+WqcoBsmXEM52uFaw1r+GqfT8IrMNqYofB2delMNweeZYzaODxkjMoMirEHRxCMvlxqxEaIyyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QM2JsMQ7iUJtkHtlXgNRmMPVqfEITu+rEmYwekv/OAk=;
 b=K1qY/KG/jB0fWXlbAgE5MPin3mM7R57G8udV7TY/H5PFOzgSKhCM6fmlel8J5P315i2d5siyU2IUAUZD+9I8laisHwWbE3UjsPxmntWxAl9cgw3JYFc+1EWpYCjqJTVHinx5cWEI4SJaNTYJ/lwiCXm5Dr9JLVXHVIrsYzQbAjC8VJuPxYmCJMonGdkSSUOjUDJIVCJHywz7vE6/GHguutm0UzgxFGVKiEC3DsR+ZNeMm5XtLXoNPMRJBIUHZwpfr1qAhgGk+RvyJDWyGzDrCdu2/M4bA5saAUewBL4lPRrSkOSoKQgUwGFfJi5RP4us2tpCaNjlVDSCuqoFvOplug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QM2JsMQ7iUJtkHtlXgNRmMPVqfEITu+rEmYwekv/OAk=;
 b=ZbKWH3BQ/QvPQU0bGrrAWU5neEiUMAJlSgW9aK8IXhqEsVCJmlv9I97FuBMrE2mIXlPeLdGb2Jy9RyfZS6PQ2UYlImBc2bq/MzhwBX3VnWm6j15zjOzYuG+ke/MOFdqOTHgLgPzLh/acX96y89aoyJZxCrm+K4mv6YDdIjKIicZN3qlZZ9tdNK3JBwS2XASqoMRCT9ioylISRFi3dCit04Mp1vNkIEdvfJa9ei3CgmDfqjKUYedToRG+anDaWg1CTvUiPPKZ5+JoHcDAAemJZWdpqjCFYAHqaBerA5QPp3AA+wdqAO8j3RBffOpxEW0VYl+afLIOqPCYEJBwQtKwOw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BL1PR12MB5141.namprd12.prod.outlook.com (2603:10b6:208:309::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 20:36:13 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e%3]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 20:36:12 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Topic: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Index: AQHYfw/TaqeKf3NIjk2lTwhHry2CmK1NyyuQ
Date:   Mon, 13 Jun 2022 20:36:12 +0000
Message-ID: <PH0PR12MB5481D2A01569549281D01411DCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220613101652.195216-1-lingshan.zhu@intel.com>
 <20220613101652.195216-6-lingshan.zhu@intel.com>
In-Reply-To: <20220613101652.195216-6-lingshan.zhu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5699cbc-f4a7-4839-4152-08da4d7c5b4a
x-ms-traffictypediagnostic: BL1PR12MB5141:EE_
x-microsoft-antispam-prvs: <BL1PR12MB51415630F7980DC74BF7490EDCAB9@BL1PR12MB5141.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VxgQlLW878Eos1e1YfQP3Af+XFAnF7DxPFWoZBWcrX/2ess9ePgOSwOGtG8K7PBSvdKWM4Rep6Xn+2jUg/NB7QI5kRoCPDjJv6u6RlIOxAP1RkD7zclkhdbtV15r6TVQwHFIWAOkWsThAYdL3g31Hf8Q/jgEwywla0+Q+fcPsd9ry3QvZNCdWqGJV9laDErVVe/blYbaYbKJomPttAxFf2o5zM3+iptvt7X6SJmOIwPYmNP4WrsdH1wpvChvY7f/fPMSiOMBD8GdozWbWzPk5oDJFfy5dkcEuOKfDbpPTEcXIbi02mTDTxY0HoSdFZbHA9BP9TWHT8vQfdAODwXTO0WaEW4JzamNFGx/qaA58hJMkvdKIqxlm+g6D9cwsC9FYlBDYJ1jMkBBTFm8sIILJwSTELmi0yl/PqSNEVym9VvEnfeVNiOlO356PtbQRjuRwjdIglfE8ezoXiT0PZ3qseeW7YNv4VIPiSFOgigkUH/zDLp2Cxf+SzciqALarxxxxCscPZpVQFWDMw9lC70PPgbr3ChiQm4vi/deMWK/hXGmpm9rgkDWw2HkNqEpiMTdVCiMGMktsVOaZqYLzCQ0pNX4bIJHx8BRsrTOxPEbSfxuP6sCICRqawUeclEu2Zmdq29S7n+JewoX6RxX03c55l1gVdGjVcTYOc8K/vuId8NgP3mk+eXbJsGFIuAd/NPIplZLfD4gJbPpt1LhNO5jBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(66946007)(66476007)(4326008)(66556008)(8676002)(64756008)(66446008)(76116006)(52536014)(508600001)(33656002)(38100700002)(2906002)(71200400001)(8936002)(38070700005)(86362001)(55236004)(53546011)(7696005)(26005)(6506007)(5660300002)(9686003)(316002)(110136005)(54906003)(55016003)(186003)(83380400001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y/h/SW0so+SeS4J38kbw/oL43H4GTbXbkE7ARe593DBTDRvNr1lo+3+O0O7D?=
 =?us-ascii?Q?XMXeSk550BiazKgnJeUkZSCRoqH3eD6JJU+CpQ0A7yKkcJOUARJsgAjsWTi+?=
 =?us-ascii?Q?qBGdgPGwrOhOgBc7SPisbOKjyOY/yFd8fNTvQ8lygFvn6IsHOZ1ZcXbPIKMQ?=
 =?us-ascii?Q?lVYI2gDJx6SuVop/RTQR8iH8ghI49asmqV2LbEfR+PZuLmier7zKjyQLlSiy?=
 =?us-ascii?Q?hdTt7DJ4dSJH14PY4zG420629I6A6eKSWkzRNEjNvt9uLqHPqwIEGsvAlvbc?=
 =?us-ascii?Q?95fIhJe+NZ+F3TczMZ3rBKs4uiZ8RPm0PTzIARB7vBqWxVHVEJA5AD0l7/BH?=
 =?us-ascii?Q?PWxSc8m5YqLTolbBxML1PTS690wYhJxKHSJX/Am8N7TjpPWnlO48m9nO81fK?=
 =?us-ascii?Q?36oPMermZRvYFA6R21wSKdTtx5OaSOZH9DS7Qntyqr2SZylk71kLxdmRPxv8?=
 =?us-ascii?Q?n+j9fJ/kWviTcqVUe6zrJAUOnvDt4ttbO6WYkLE6LAdbA1j8T/0qJCqeDkCO?=
 =?us-ascii?Q?dkAhdz8bvxovVy3HYuhcDCTSomcAPzf8KguflcxaGGtxCY+7Im/0de8s0vGW?=
 =?us-ascii?Q?IwvGp4mRhS+FXTVEudXGNnX7K+naynXuYuADSlwUnp6FVr2WvAtEb4adfZ5z?=
 =?us-ascii?Q?ttioCcKzYvGehvekHFnlnSuIFbyeyNnh4S/1sDsgPl3mzHgaA5jJ4tPNPqR9?=
 =?us-ascii?Q?ziLlZPgaZHLOjp5vNb+j9EmU91QGkaAtUmUKgd6Ncu0b/DzkApGRkd6oYZ+1?=
 =?us-ascii?Q?y2LUpphCdecH6Avkzj7rwjLuzLzQI7Pnw8HnuYu0dS/MBR3E+IiVSJkf05U4?=
 =?us-ascii?Q?5Zrpdj1oE1XaWaEHTC5IMZSfxYs4+GUx/FudL0QJ2aEhh9n5jWKLNYaTV289?=
 =?us-ascii?Q?vJwC0Kcqve0tMuREkclysaR89dQ6g8TXSyPK61El+6gcaQNFqR1JOoPXJW8T?=
 =?us-ascii?Q?+EFz6pFfLPfKXyWB7ucymF+OWjF67JCaij9TzvIy09DD8w5Ky7Yhx6H043kQ?=
 =?us-ascii?Q?m+1nRxi9Je42rxWrZTxmea5bsxiDj88fuDNFcyVG3NZEkrQkX0yu/yXkNG/3?=
 =?us-ascii?Q?aqbd6aEYkkY/Q5fwNCBa2DZAc5ErkpH1EcO4HTek/3mW5o4ait/toNJLdcJm?=
 =?us-ascii?Q?/bokO3WkY47tA3cUak04mVg0GCOcj6UwBIf49EZ6HL7n1ue+c4B0VlgQqw3p?=
 =?us-ascii?Q?vbl9h1Q15A9gQB98gMOamEYvD8gLQGUyrHBTFG3E9v6t2DoDbXB5NwguSnCz?=
 =?us-ascii?Q?0BoKszs1Q90rvaTuxfMWjkaKqgGNazdOSlusw946xEsUWoIHiQzibZ4Bs7oy?=
 =?us-ascii?Q?oXN1SwShRP7pNxyfJkAnCnhbXFMLVjp36hwewvAQW9u75hmA5JwtLXFOPxJN?=
 =?us-ascii?Q?Ept3HeOe7tUJSUpnJARVzDZ3PdWoea2WBgF2TaAphyYzNY1n81LsWjbELeDl?=
 =?us-ascii?Q?PdEPz2XE2NfMTsrF6X+HvQZYJEFJSMtlmRvg22Z96E5jDTAhHvzYSFjYaWXz?=
 =?us-ascii?Q?a22XjSd6X17d/z3KGoWkvWEp1OkrHynqaMZIK7e8t5U0EDAwH1xFLc5kgJav?=
 =?us-ascii?Q?MZz2v5rHPHJIdLby5VEDj5zM35JGSqkDxjBwvgsnxb6ZXpvOqyjjHf0TbSJW?=
 =?us-ascii?Q?WlXcW0tH6oOgDmuzwQdxbThYHVvtgNRM0Fw+2x+LAi6CFR9sg9R6ZCAfrxoc?=
 =?us-ascii?Q?LlZMXui60Q9nn0uG1kVwePTYlJM1rBSQ9Kx5iCBdmGr0y4yAtQlh68XcSftK?=
 =?us-ascii?Q?u+UzcsCUtA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5699cbc-f4a7-4839-4152-08da4d7c5b4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2022 20:36:12.8754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5coFGoLY44h0+pKJ5kxxn8J2TjztvphtEjURaZrH+63qKGH36V4giM+YSZC4byUGm9itHhBbw2y4ZsfsUVznEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5141
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Zhu Lingshan <lingshan.zhu@intel.com>
> Sent: Monday, June 13, 2022 6:17 AM
> To: jasowang@redhat.com; mst@redhat.com
> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org; Pa=
rav
> Pandit <parav@nvidia.com>; xieyongji@bytedance.com;
> gautam.dawar@amd.com; Zhu Lingshan <lingshan.zhu@intel.com>
> Subject: [PATCH V2 5/6] vDPA: answer num of queue pairs =3D 1 to userspac=
e
> when VIRTIO_NET_F_MQ =3D=3D 0
>=20
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
>=20
Max_vq_pairs should not be printed when _MQ feature is not negotiated.
Existing code that returns 0 is correct following this line of the spec.

" The following driver-read-only field, max_virtqueue_pairs only exists if =
VIRTIO_NET_F_MQ or VIRTIO_-
NET_F_RSS is set."
The field doesn't exist when _MQ is not there. Hence, it should not be prin=
ted.
Is _RSS offered and is that why you see it?

If not a fix in the iproute2/vdpa should be done.


> After applying this commit, when MQ =3D 0, iproute2 output:
> $vdpa dev config show vdpa0
> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
> mtu 1500
>=20
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

