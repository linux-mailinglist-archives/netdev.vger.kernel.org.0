Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828CD47618A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhLOTUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:20:00 -0500
Received: from mail-eus2azlp17010004.outbound.protection.outlook.com ([40.93.12.4]:43041
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231524AbhLOTUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 14:20:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLb+s1yFxi5GwqN0XETE8IKYqGGP/Cpn28OHpnDf2Vv9vhDaEbn1AOIP77hw84eDb325JOJkS8TzwV3op7TuUKFyfi9dIXFlMgXMVUPGn20VtVpw5j2xGVXjkRteVGUwCVy/KucAYLBnqKxV55t+eOagnxF2jr2ee1TQIYP6gFvJM0l4mRXzjaEIqliE1541t1JsaokRZjc0+8KNkYQ8bKCzY7XPldJWIY4XVoSXfRBixNS2Qcrvifj+HoRQR+HHNfLhFasJAaMuexk+50JWw+3Z3X2JYxgz+av7rV0zcRwxmPUvTdFPQYLnCO0dXDKM/0LRF85wcnuag/eYi6IJ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1kERPv9Zzqf9eVV5U9VVfmsZMs1BVi1o9ttEtw7Lps=;
 b=Rfx8kezHiWzxfaRYAzBbv9CnPSafD7P4l3v76vddaSP2vkK0XAqhRzigv9hgxHmsC8me3olWWWEjr/URrGSA6MG4T+lDKpJFYzw4Kt/0SxdfHWrVdLPoDCUv/SBlmf/h4q+xMUwVzraJhW+uemyCdRh/QNb/8KilR+xvdcAHEjB22IatMsd/YgK2Th+Zul/Ay/bF7Mz0r3Kg2D5aGnsOYdMjeg41TaDVDTqBuzYTFwJkHjpwa6oPbcCDtTZNebrfW1scfkQ5u4RCxU4eiVhAJOrfeKPZ75VERm9fNd185fx19U1gyIcaPN9s1dPQH7E3IUFTnbzkEnhEdPiX3Xexbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1kERPv9Zzqf9eVV5U9VVfmsZMs1BVi1o9ttEtw7Lps=;
 b=OY81af/GM3bjezybgd2OjNh5DS6FceASDCawQX6wPdsAfaH6O5uKG7b/osg50pdW/X9ggmsbOicQu59DCzCuI8//0b6i1SmSdtOaXpqVeMxqL3sIdJLzTTE93QlyzWPWN1HEkKap/Wrzy2wy1bESMLhiFDAJ6bVMKHI46rID2sA=
Received: from BY5PR21MB1506.namprd21.prod.outlook.com (2603:10b6:a03:23d::12)
 by BN6PR21MB0467.namprd21.prod.outlook.com (2603:10b6:404:b2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.7; Wed, 15 Dec
 2021 19:19:52 +0000
Received: from BY5PR21MB1506.namprd21.prod.outlook.com
 ([fe80::7c21:a7d5:6358:fcc2]) by BY5PR21MB1506.namprd21.prod.outlook.com
 ([fe80::7c21:a7d5:6358:fcc2%6]) with mapi id 15.20.4823.006; Wed, 15 Dec 2021
 19:19:52 +0000
From:   Long Li <longli@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V7 4/5] scsi: storvsc: Add Isolation VM support for
 storvsc driver
Thread-Topic: [PATCH V7 4/5] scsi: storvsc: Add Isolation VM support for
 storvsc driver
Thread-Index: AQHX7/EuQvEqmJT9gE2vRBvqkGA9oawz8H4w
Date:   Wed, 15 Dec 2021 19:19:51 +0000
Message-ID: <BY5PR21MB1506E3E49544F172150A0471CE769@BY5PR21MB1506.namprd21.prod.outlook.com>
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-5-ltykernel@gmail.com>
In-Reply-To: <20211213071407.314309-5-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=07d20581-ed30-4599-a2c3-63e94a1d3b68;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-15T19:15:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89b615e8-47aa-44b3-6bdd-08d9bfffde7e
x-ms-traffictypediagnostic: BN6PR21MB0467:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN6PR21MB0467BA69F8FC3B321C7B9B76CE769@BN6PR21MB0467.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R+8OWuqquAZvR1JG//vhQzX3wneKMJlEp+AgTShWT/dMK5xo6ERPUqEEivsEOg8XBXxh7g78EtdgeTiwyLyVZblacD9a6hX/HL21Em2PsdbNotjyAj8kkWedQs/FCR+rTxsZO9+CLqQGIIWkE3lpZmPDPnNPYojuOYjcIqM3N1ewEACyEX5KC0TD4lsGvvB588aH2hHXeMbHcDMAkCKWiH/jIoyXrkW8lKktZUu+hhlmPIRcXmGEv7C5hDsuOJxMH5R1bvGRB1JEouzRLCFP6dYslfuIupHe9nZL0DCA3TkpJc1KHh21Jb1k8BFmnGkYbT8iSpLMQ3Z1fKtqNOssZNUCNiuXOL5VwUpHMfvb6V0pcQYCUkilnF2i0VPVwDVQScyTc9kyES/MAnupntuwsYPbgX5lPXU55yWqikTNFpXDhoovyEdMCjzpygOe1fWRjNBY06Cn+gJWnROBHTFz8WRfCd6nd6QiXR8t/hNo5djdm7xl8mLgap0ukDAJDvV12YsNMeOs1KGGvBE3sTlkm7TFIUbcKRiWWSRwYETdViClVGzdqNRjyjstw829n6/25ZY33SeUmCWMeRGsVb5mSFa/n+V/tYbVgVfHDmYwc5kmzvHJADngC9QBFW3pA2QLQmjRupKYIKbp3LTeNN1XnVFhaMoqUhtKljARkS4JgVoUMBbQy9gmAS8R5XU/ZMEo2Hg7xnlI/5l/WWCkN52vDfcg7NXxg5VpWh0dK2TNgagXj0k/ZMFffUleyUTCpJb9tIWid/dSHfaXmfFeAC2QJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1506.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8990500004)(33656002)(8936002)(64756008)(2906002)(66476007)(4326008)(66446008)(38100700002)(122000001)(66556008)(55016003)(186003)(86362001)(83380400001)(26005)(7416002)(5660300002)(10290500003)(7696005)(38070700005)(921005)(9686003)(508600001)(53546011)(52536014)(76116006)(316002)(110136005)(8676002)(54906003)(66946007)(6636002)(7406005)(82950400001)(71200400001)(82960400001)(6506007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZC+52mSMvyPPpDpwqmkMYzfOGQH0jxMbxrtbM+cGNnk8XFz1rvbzVhtLnpRg?=
 =?us-ascii?Q?18QkCkq1I7r8yMdqXZsjUg7nDHlDBoaBpu75HZq/0Qnfsj+0T+BFRH7rgqvM?=
 =?us-ascii?Q?mFMXv+iZKvGUWU+LpZ1lzZBkikPzV0heY3eUuZEjfatUpMNUtpCeD+X1cC11?=
 =?us-ascii?Q?JPPk/loigWE/F8bmOdtkoZXFJZVnwPp/c5rNkRq8TR7PU/r6QtY6UV+pbi5/?=
 =?us-ascii?Q?g36nx0w2i+5XuHd6nEJEsVH5UX/7o6Uaic8MkLJToRdo1xAKoaDQaestd89K?=
 =?us-ascii?Q?sYzlEafH04OGsku3CLYgC1qVS3CnxKMQ98tTWIA/PjMo5gHyiGDjllruGAp+?=
 =?us-ascii?Q?F0PibN5gC+zjoa6xX3TAuO7Kpz8JqC5LWjFMsKMX5Gzl9gk5vyGRy5Dr6Xjp?=
 =?us-ascii?Q?swh1nzqUbQaJkkCsw4m1Kr+nKqqV6jckn8GAxy7J8YvdPGPjzrf4Z9EqqU4/?=
 =?us-ascii?Q?GwuyO6WoyCvuoBbYhnZZXARbmyiesUNoNKNu1Ujvz3uGkmYs+PSHryI4WosV?=
 =?us-ascii?Q?t3ElFCgXPoXF3sho5KGvh+4yTTVL10JRh51JFF/RfOjFvCK1RwI5lN0b8vCs?=
 =?us-ascii?Q?k9qyNuTT8sqoh3uKJLb4PyPjFFdedwGvaTtuoYhPc/nD5ZOUNgLoUBmtNzQt?=
 =?us-ascii?Q?bGg2baAd9b3Ju0z0wgN7/1a2AdZPaQQMqgQ+4l48NkR0LTJWyJf4hyLeAYBT?=
 =?us-ascii?Q?dfhdAoW2d1W5Aclzt8L5UJPrMwRdOHPRLGvSKn3vzRw8f2MqH5uFYhoQSq+K?=
 =?us-ascii?Q?kmo0PpnCAOthmaoUbNvJz8/OQDE7VXX+E168GEUbhZOMXxVSliMiRENprdpX?=
 =?us-ascii?Q?Uhs7Ek0k+TVlzfTZi3Eu90yyzqyoEJrHlci19b7p371X1MG+BMKxFHazf7gw?=
 =?us-ascii?Q?8dxGpoARTL7Rvgn4O2406AymtqUK8sd65hoocuJ3gxItC6FDOwPJ3CBIB4rO?=
 =?us-ascii?Q?XlYeKNwNuEJhBl9GAqVBeWVrDRUnZhx4PGe6aKIiL/em/oaRtvjd3ncTybxk?=
 =?us-ascii?Q?XyCV1Sgw2e/Xx1kyOxbcC9f94xWfRAsCzos3qY7UpBcsz9PJWUUitsW9s2og?=
 =?us-ascii?Q?B8G3OquNnUWFWUUq/OvCGWF8jIP/ESCU+O6G592EO4luLw6KJ8WiWcI9/TDR?=
 =?us-ascii?Q?eYtX+puO9qD+sShJBPkwXZuZds9WpEXcaFkxcfVVdVp83zwAP7+rhOoZ2iAi?=
 =?us-ascii?Q?ejvkCMQBcLgN0DNG9BKsIX92R0WMURwfVEn9LN1BbExqq8RuCpeqvkU38wh1?=
 =?us-ascii?Q?eEmeB/qGCkVg0JVRbrW/hCGzipoc6At8wFj5ZdgYQyNkwxUW5zHvnH+LJ9Tb?=
 =?us-ascii?Q?VSPqWTh2b++wPGkCNtXVXsjZUFqUEf8/1HD5/hpRITh7a9vGQA0grZZj+Me+?=
 =?us-ascii?Q?E1m03F/FQzNNw1CC9kWwyHqeNbOXP7mZFAYBnJZgLmRSAThHIfFEBftesspC?=
 =?us-ascii?Q?U6x+OCwnJ7ytpg04SvnZ3KfPzEodt4N7Knc3IENnBhkOF5JxCvdOiAQlnEjn?=
 =?us-ascii?Q?QLxLytvHS1lP/En5Jce7s8Uw7b6AohnEe0yStkXiJkSU9phWEA+aDWYBwPG7?=
 =?us-ascii?Q?PRLjey7d4VO0rqGWvzoLeEM3jeHIwgrNs6PZbD21N/RvqObnQ07z74RMPjZX?=
 =?us-ascii?Q?mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1506.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b615e8-47aa-44b3-6bdd-08d9bfffde7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 19:19:51.8867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HFHBsyTXCvGdqm4D8kEry5Cgn3TArQ91r2qykFoey0F6F5BtQu3kKWTS46jDqerbtRBnmv2D/NiMFf4vweuGBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0467
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Tianyu Lan <ltykernel@gmail.com>
> Sent: Sunday, December 12, 2021 11:14 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>; tglx@linutronix.de;
> mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.com;
> x86@kernel.org; hpa@zytor.com; davem@davemloft.net; kuba@kernel.org;
> jejb@linux.ibm.com; martin.petersen@oracle.com; arnd@arndb.de;
> hch@infradead.org; m.szyprowski@samsung.com; robin.murphy@arm.com;
> thomas.lendacky@amd.com; Tianyu Lan <Tianyu.Lan@microsoft.com>; Michael
> Kelley (LINUX) <mikelley@microsoft.com>
> Cc: iommu@lists.linux-foundation.org; linux-arch@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org; netdev@vger.kernel.org; vkuznets
> <vkuznets@redhat.com>; brijesh.singh@amd.com; konrad.wilk@oracle.com;
> hch@lst.de; joro@8bytes.org; parri.andrea@gmail.com;
> dave.hansen@intel.com
> Subject: [PATCH V7 4/5] scsi: storvsc: Add Isolation VM support for storv=
sc driver
>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>=20
> In Isolation VM, all shared memory with host needs to mark visible to hos=
t via
> hvcall. vmbus_establish_gpadl() has already done it for storvsc rx/tx rin=
g buffer.
> The page buffer used by vmbus_sendpacket_
> mpb_desc() still needs to be handled. Use DMA API(scsi_dma_map/unmap) to
> map these memory during sending/receiving packet and return swiotlb bounc=
e
> buffer dma address. In Isolation VM, swiotlb  bounce buffer is marked to =
be
> visible to host and the swiotlb force mode is enabled.
>=20
> Set device's dma min align mask to HV_HYP_PAGE_SIZE - 1 in order to keep =
the
> original data offset in the bounce buffer.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>

Reviewed-by: Long Li <longli@microsoft.com>

> ---
>  drivers/hv/vmbus_drv.c     |  4 ++++
>  drivers/scsi/storvsc_drv.c | 37 +++++++++++++++++++++----------------
>  include/linux/hyperv.h     |  1 +
>  3 files changed, 26 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c index
> 392c1ac4f819..ae6ec503399a 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -33,6 +33,7 @@
>  #include <linux/random.h>
>  #include <linux/kernel.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/dma-map-ops.h>
>  #include <clocksource/hyperv_timer.h>
>  #include "hyperv_vmbus.h"
>=20
> @@ -2078,6 +2079,7 @@ struct hv_device *vmbus_device_create(const guid_t
> *type,
>  	return child_device_obj;
>  }
>=20
> +static u64 vmbus_dma_mask =3D DMA_BIT_MASK(64);
>  /*
>   * vmbus_device_register - Register the child device
>   */
> @@ -2118,6 +2120,8 @@ int vmbus_device_register(struct hv_device
> *child_device_obj)
>  	}
>  	hv_debug_add_dev_dir(child_device_obj);
>=20
> +	child_device_obj->device.dma_mask =3D &vmbus_dma_mask;
> +	child_device_obj->device.dma_parms =3D &child_device_obj->dma_parms;
>  	return 0;
>=20
>  err_kset_unregister:
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c inde=
x
> 20595c0ba0ae..ae293600d799 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -21,6 +21,8 @@
>  #include <linux/device.h>
>  #include <linux/hyperv.h>
>  #include <linux/blkdev.h>
> +#include <linux/dma-mapping.h>
> +
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_host.h>
> @@ -1336,6 +1338,7 @@ static void storvsc_on_channel_callback(void
> *context)
>  					continue;
>  				}
>  				request =3D (struct storvsc_cmd_request
> *)scsi_cmd_priv(scmnd);
> +				scsi_dma_unmap(scmnd);
>  			}
>=20
>  			storvsc_on_receive(stor_device, packet, request); @@
> -1749,7 +1752,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host=
,
> struct scsi_cmnd *scmnd)
>  	struct hv_host_device *host_dev =3D shost_priv(host);
>  	struct hv_device *dev =3D host_dev->dev;
>  	struct storvsc_cmd_request *cmd_request =3D scsi_cmd_priv(scmnd);
> -	int i;
>  	struct scatterlist *sgl;
>  	unsigned int sg_count;
>  	struct vmscsi_request *vm_srb;
> @@ -1831,10 +1833,11 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
>  	payload_sz =3D sizeof(cmd_request->mpb);
>=20
>  	if (sg_count) {
> -		unsigned int hvpgoff, hvpfns_to_add;
>  		unsigned long offset_in_hvpg =3D offset_in_hvpage(sgl->offset);
>  		unsigned int hvpg_count =3D HVPFN_UP(offset_in_hvpg + length);
> -		u64 hvpfn;
> +		struct scatterlist *sg;
> +		unsigned long hvpfn, hvpfns_to_add;
> +		int j, i =3D 0;
>=20
>  		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
>=20
> @@ -1848,21 +1851,22 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
>  		payload->range.len =3D length;
>  		payload->range.offset =3D offset_in_hvpg;
>=20
> +		sg_count =3D scsi_dma_map(scmnd);
> +		if (sg_count < 0)
> +			return SCSI_MLQUEUE_DEVICE_BUSY;
>=20
> -		for (i =3D 0; sgl !=3D NULL; sgl =3D sg_next(sgl)) {
> +		for_each_sg(sgl, sg, sg_count, j) {
>  			/*
> -			 * Init values for the current sgl entry. hvpgoff
> -			 * and hvpfns_to_add are in units of Hyper-V size
> -			 * pages. Handling the PAGE_SIZE !=3D
> HV_HYP_PAGE_SIZE
> -			 * case also handles values of sgl->offset that are
> -			 * larger than PAGE_SIZE. Such offsets are handled
> -			 * even on other than the first sgl entry, provided
> -			 * they are a multiple of PAGE_SIZE.
> +			 * Init values for the current sgl entry. hvpfns_to_add
> +			 * is in units of Hyper-V size pages. Handling the
> +			 * PAGE_SIZE !=3D HV_HYP_PAGE_SIZE case also handles
> +			 * values of sgl->offset that are larger than PAGE_SIZE.
> +			 * Such offsets are handled even on other than the first
> +			 * sgl entry, provided they are a multiple of PAGE_SIZE.
>  			 */
> -			hvpgoff =3D HVPFN_DOWN(sgl->offset);
> -			hvpfn =3D page_to_hvpfn(sg_page(sgl)) + hvpgoff;
> -			hvpfns_to_add =3D	HVPFN_UP(sgl->offset + sgl-
> >length) -
> -						hvpgoff;
> +			hvpfn =3D HVPFN_DOWN(sg_dma_address(sg));
> +			hvpfns_to_add =3D HVPFN_UP(sg_dma_address(sg) +
> +						 sg_dma_len(sg)) - hvpfn;
>=20
>  			/*
>  			 * Fill the next portion of the PFN array with @@ -
> 1872,7 +1876,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host,
> struct scsi_cmnd *scmnd)
>  			 * the PFN array is filled.
>  			 */
>  			while (hvpfns_to_add--)
> -				payload->range.pfn_array[i++] =3D	hvpfn++;
> +				payload->range.pfn_array[i++] =3D hvpfn++;
>  		}
>  	}
>=20
> @@ -2016,6 +2020,7 @@ static int storvsc_probe(struct hv_device *device,
>  	stor_device->vmscsi_size_delta =3D sizeof(struct vmscsi_win8_extension)=
;
>  	spin_lock_init(&stor_device->lock);
>  	hv_set_drvdata(device, stor_device);
> +	dma_set_min_align_mask(&device->device, HV_HYP_PAGE_SIZE - 1);
>=20
>  	stor_device->port_number =3D host->host_no;
>  	ret =3D storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h index
> b823311eac79..650a0574b746 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1261,6 +1261,7 @@ struct hv_device {
>=20
>  	struct vmbus_channel *channel;
>  	struct kset	     *channels_kset;
> +	struct device_dma_parameters dma_parms;
>=20
>  	/* place holder to keep track of the dir for hv device in debugfs */
>  	struct dentry *debug_dir;
> --
> 2.25.1

