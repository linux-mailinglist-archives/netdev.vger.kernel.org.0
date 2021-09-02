Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614343FE76D
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 04:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhIBCJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 22:09:42 -0400
Received: from mail-oln040093003004.outbound.protection.outlook.com ([40.93.3.4]:39453
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232517AbhIBCJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 22:09:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUpSChkKBWMqyiukbEC8IxJNip992xfSXG5TmpQZhkTvCM/aDZMzscsPteLJxO9Z+5nnAwfCHVRJ2W0YK/xFtjDjwHurm+0Uoqtr6zVSPfMdiMi6cSkgOZkktBCMP8rEmFLNUaWJ2Dhp7THgrZYlneAqfo9iUKClaU0aHvP1AmlX3TXvz93tpYlHU/qOF6/hlZFIwPYBV7ek4LskPSoO3CPFQvILuX9vbB3Zbp+hxpChe0+AufmBZ5o6B+FBxq9NEGICdotV83xIIWBC64c6PrUYihGmPpQEwMmJhcJtqBnnwvbmXJY6CGbXFBAY1rdoHC5K+nZ+RhLtZij0t2NT7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=m8Z4zZgDo/ng30TsOukCORL2mWs0iQjFTdzvLSYEXk8=;
 b=j3uJ/vgN2Svy1/0rRfkdPjkX3676/Ve/pCQkW24hZX2cQlqfjygR2sWm6x9pTpyd/XcmeLGdWLTF+9XdRWXSrHmrmRKXNRiIpyX8sH81E5g2zkeOIQqEanzEwbrslp+dKshg/BmJ/bhCENBW4Vz9E1KcigFSaLX90cGresqjzboZ4X1nTRmGBYJQnQDEfcQbAdE6tGxM1l7KMRhs43sQkkktASolHwV/KUNZ4JC07adFBSl020syB2TBtyEkp/uLGjdjYd5Ds9bgq9aDxTDkXVrAReL86MfBx9lPiT8heE/mPlRzU24k276JY4geouUHknOK91hgN4/lTs/Zk4rzWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8Z4zZgDo/ng30TsOukCORL2mWs0iQjFTdzvLSYEXk8=;
 b=bd/JOGRzT95HRhvOUNcHOfelq5cct9xFQv9lwJCNx7oSiw34v9MsYGLbyVgS39nixvvJ8lcvmPh920F5WnTGKtg3zCvRIW/DKiesmXiXZ80gITl9JyjYcJHTfA5qIhgnqZS859ZT4dw1V+ArSVbyybPU+uOdhKiAKbZdBI1rOf8=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by CO2PR21MB3009.namprd21.prod.outlook.com (2603:10b6:102:18::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.4; Thu, 2 Sep
 2021 02:08:38 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 02:08:38 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V4 13/13] hv_storvsc: Add Isolation VM support for storvsc
 driver
Thread-Topic: [PATCH V4 13/13] hv_storvsc: Add Isolation VM support for
 storvsc driver
Thread-Index: AQHXm2gLgD2LnlrK1Ui6MWEQREt+OKuIA2QQ
Date:   Thu, 2 Sep 2021 02:08:38 +0000
Message-ID: <MWHPR21MB1593CB6AD9521190CA0AB0DED7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-14-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-14-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f3fb0eb4-3fe0-4fc3-9520-c93e315d7a42;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-27T23:41:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ea2dd65-3c0f-43cb-0521-08d96db693fe
x-ms-traffictypediagnostic: CO2PR21MB3009:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CO2PR21MB30092A47D1401DE9FFD4B0BDD7CE9@CO2PR21MB3009.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ndTLqZdHuCSzY96whS6o3zQp5pWBl/+LPOxouGx7MvdNaYKuKvaFNQwUMEMZfwmHr4jOi6oWBYiz3uNN1AIyg7MhnWomwEL0ihAtK7DvmJFI1pwN23oEItvoA9pfELcTzjHqzto7bCclgTX/tL8m2FVSWS9DznLZ6SL5bED36RZkXCgWoZ61O2xsYrmNK2BYGQJZqTbGKL8JnYl6a1VckOlhVdTcP0kloEzheeMPbCao6ltZge2w3RTnxLv22Ap1BXZKd5XelSzST1sQ2afXyEbqeK+gHzbQeItQFBGpcdjBoy4bU1Ou2Bzw2Ywm9ZmzAgYWhsQCsjwaUgtTmad6fEEO8kOVFKE3mNsXM/zB9yvCObJ1w3dqn7fesYfaweLGMdsWkx80wNt87AjQS+VuaML7txbgbnsj9Sh1pTWE8BQru7dwe3i+e4HyJQSi9RzvoqBvVNbd+n2Wn64j2hrkR7K0QiRW25kzFfeWGwxqIrxhyQ00KRYF8fVPVWDn1zrJUc2GjpQdJuUvR6pQ0ibrmPBeMJgLnb2KDAC0KCTMtEsB1uXDSF1BfkvUnPbYlQv3iq1KsDsPYIHFz7oKMnTKE2KvuGVD8tYcxf/YQdJAN3jNDLQWWp1ORhABKivtbremVstJAU2ihezQYo77y3CPHdlF81y59pgSoKUtaskzqrOzL8EWJtkpNf0UmCBSDzCuYTmwjdSI/nxE35dzdARuaGYoiP+gfuPjhNpq6jMqsI8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82950400001)(82960400001)(4326008)(186003)(76116006)(316002)(8990500004)(110136005)(66476007)(83380400001)(7406005)(7416002)(7366002)(66946007)(66556008)(64756008)(66446008)(54906003)(6506007)(9686003)(55016002)(122000001)(26005)(2906002)(52536014)(921005)(86362001)(71200400001)(5660300002)(38070700005)(7696005)(8676002)(8936002)(38100700002)(508600001)(33656002)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DolnhatuDAmIAaAz1/YX4Nu77VLxLJi5Z5u3+A6UHOQkEZWqwmLzr6hkf5h6?=
 =?us-ascii?Q?mVAM7sfILM0sb62t/FIdI2R41We7PR+TF1q7yPx6JbgXnRJQjOGD7e6VAlL0?=
 =?us-ascii?Q?VYlx3oYPMhMWiZoMNmNhSz2nfZTsTT/s8eRHAg5yZtQHCyQJGnBRXvLo2ZT0?=
 =?us-ascii?Q?zllaDQdkxQxV7ukn+Bt6fJgbkj8n2gr1b/uO4SQXC7NISFP1EyxCgQ6JQ7Fc?=
 =?us-ascii?Q?jV4VmCJP8+JQNgbqAyardqPmpig/GBcw/1UqOeybTfbfoSVxOsatsZERTnP5?=
 =?us-ascii?Q?UxSKKL6MuvTM5sTNREAIy2bYLBDu4U0OhiPvTlUJpnYMfyXYNKH267zIFzCM?=
 =?us-ascii?Q?PldhdohAzJfsYI0h6w2kOSo7q8IBiuWm+zf+aaRpA9PB7MlLaixaNGZcU4lE?=
 =?us-ascii?Q?gjYWnJJoud5x0cHcwyYxq8sUexK1uweGy3v6UEKjsTVj/m4FyZ2vXqirFf4H?=
 =?us-ascii?Q?JkbMuFrXswddWR1K8OpAK1204L0MPy5x9yuzN7+maWBfL+enrzX3W+tzdxs4?=
 =?us-ascii?Q?f/1SdBIJEDEM3OYuR9P/7zhpNhHDIL++WxG8hrWBN7w3IkOCRGlCO0rUW/hX?=
 =?us-ascii?Q?E1kEuquD99AvKjJK+AGHbABnEfuVNY3viHqFns4Yx0N3O29ES8uVUvwVSY/q?=
 =?us-ascii?Q?+l3hpQlfW1lBAVS/zySdayy9k4GLK6ubKQfh9vHhnx7ccUqzzuw5w18Pgs3W?=
 =?us-ascii?Q?VRTWWM2CMj5YA1zbaCKGqvuXdOyY0XYRog8BcGfUdaczLPsyPQCLGNqwQGU2?=
 =?us-ascii?Q?AqEnxtXliDQDWBFJSrNj/c1k911nSNH4BGyPKYlT4zHgcDL+97I4sJ2OoBp9?=
 =?us-ascii?Q?KyBj4U1Du4CbFvWCafngd6ltxm1/GKtYyAEZrP7Qya5gxRfabpq2pmyMcAmf?=
 =?us-ascii?Q?lbXmuOj9wMIO2kVGMbHqdvd2octK5nt3V+7yNs2wI876Xq7lDMRF2Gee7USb?=
 =?us-ascii?Q?ZpRrKueEWAIPyLJKQ26Kj/f8msXqtX6JMPvdt0iunoCn5X0YJwFET5D9eDn8?=
 =?us-ascii?Q?GWtR1tpnTxey2vk4daEsB2DBReKe8Hj20zwcaezjVCEwUo7/evMJ4lxdeSv2?=
 =?us-ascii?Q?9pmAy+NcK9mp0y78xdFmLKyXxk82K2vRtiOA7SxTlAFsleQE4DHwPMte4tfC?=
 =?us-ascii?Q?kN+9LxsXMpZ8Z1qM7k5Pf/nedS/xTbiRCsjqmXAwwMjgPtQKTgPVY3xLtLjT?=
 =?us-ascii?Q?bybW5G1aOMa+Vf7yWoRXHxa/Ha4Sans5gAcg2zsEFAIyoTy4qGFChbOT0mGz?=
 =?us-ascii?Q?CiPjKJ3SsfvxpRmVUTLDus/nOnN6kdsW79nDuLhkSL3No277Wu/5FMMUS18+?=
 =?us-ascii?Q?+15h35tJ4UXVtGV1HnHg+BNj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea2dd65-3c0f-43cb-0521-08d96db693fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 02:08:38.0541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tXT0bjcyirvjVG/opzOIdPJBrRMiRaNV9Y9VlcCS+iP2p9aRelS7uwRI97sbYAJCtJayrUXtfu+t7qPz3kutGOq/HYyGfA8POko7JlWeOqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR21MB3009
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20

Per previous comment, the Subject line tag should be "scsi: storvsc: "

> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> storvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> mpb_desc() still needs to be handled. Use DMA API(dma_map_sg) to map
> these memory during sending/receiving packet and return swiotlb bounce
> buffer dma address. In Isolation VM, swiotlb  bounce buffer is marked
> to be visible to host and the swiotlb force mode is enabled.
>=20
> Set device's dma min align mask to HV_HYP_PAGE_SIZE - 1 in order to
> keep the original data offset in the bounce buffer.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
> 	* Rplace dma_map_page with dma_map_sg()
> 	* Use for_each_sg() to populate payload->range.pfn_array.
> 	* Remove storvsc_dma_map macro
> ---
>  drivers/hv/vmbus_drv.c     |  1 +
>  drivers/scsi/storvsc_drv.c | 41 +++++++++++++++-----------------------
>  include/linux/hyperv.h     |  1 +
>  3 files changed, 18 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index f068e22a5636..270d526fd9de 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -2124,6 +2124,7 @@ int vmbus_device_register(struct hv_device *child_d=
evice_obj)
>  	hv_debug_add_dev_dir(child_device_obj);
>=20
>  	child_device_obj->device.dma_mask =3D &vmbus_dma_mask;
> +	child_device_obj->device.dma_parms =3D &child_device_obj->dma_parms;
>  	return 0;
>=20
>  err_kset_unregister:
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 328bb961c281..4f1793be1fdc 100644
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
> @@ -1312,6 +1314,9 @@ static void storvsc_on_channel_callback(void *conte=
xt)
>  					continue;
>  				}
>  				request =3D (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
> +				if (scsi_sg_count(scmnd))
> +					dma_unmap_sg(&device->device, scsi_sglist(scmnd),
> +						     scsi_sg_count(scmnd), scmnd->sc_data_direction);

Use scsi_dma_unmap(), which does exactly what you have written
above. :-)

>  			}
>=20
>  			storvsc_on_receive(stor_device, packet, request);
> @@ -1725,7 +1730,6 @@ static int storvsc_queuecommand(struct Scsi_Host *h=
ost, struct scsi_cmnd *scmnd)
>  	struct hv_host_device *host_dev =3D shost_priv(host);
>  	struct hv_device *dev =3D host_dev->dev;
>  	struct storvsc_cmd_request *cmd_request =3D scsi_cmd_priv(scmnd);
> -	int i;
>  	struct scatterlist *sgl;
>  	unsigned int sg_count;
>  	struct vmscsi_request *vm_srb;
> @@ -1807,10 +1811,11 @@ static int storvsc_queuecommand(struct Scsi_Host =
*host, struct scsi_cmnd *scmnd)
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
> @@ -1824,31 +1829,16 @@ static int storvsc_queuecommand(struct Scsi_Host =
*host, struct scsi_cmnd *scmnd)
>  		payload->range.len =3D length;
>  		payload->range.offset =3D offset_in_hvpg;
>=20
> +		if (dma_map_sg(&dev->device, sgl, sg_count,
> +		    scmnd->sc_data_direction) =3D=3D 0)
> +			return SCSI_MLQUEUE_DEVICE_BUSY;
>=20
> -		for (i =3D 0; sgl !=3D NULL; sgl =3D sg_next(sgl)) {
> -			/*
> -			 * Init values for the current sgl entry. hvpgoff
> -			 * and hvpfns_to_add are in units of Hyper-V size
> -			 * pages. Handling the PAGE_SIZE !=3D HV_HYP_PAGE_SIZE
> -			 * case also handles values of sgl->offset that are
> -			 * larger than PAGE_SIZE. Such offsets are handled
> -			 * even on other than the first sgl entry, provided
> -			 * they are a multiple of PAGE_SIZE.
> -			 */

Any reason not to keep this comment?  It's still correct and
mentions important cases that must be handled.

> -			hvpgoff =3D HVPFN_DOWN(sgl->offset);
> -			hvpfn =3D page_to_hvpfn(sg_page(sgl)) + hvpgoff;
> -			hvpfns_to_add =3D	HVPFN_UP(sgl->offset + sgl->length) -
> -						hvpgoff;
> +		for_each_sg(sgl, sg, sg_count, j) {

There's a subtle issue here in that the number of entries in the
mapped sgl might not be the same as the number of entries prior
to the mapping.  A change in the count probably never happens for
the direct DMA mapping being done here, but let's code to be
correct in the general case.  Either need to refetch the value of
sg_count, or arrange to use something like for_each_sgtable_dma_sg().

> +			hvpfns_to_add =3D HVPFN_UP(sg_dma_len(sg));

This simplification in calculating hvpnfs_to_add is not correct.  Consider
the case of one sgl entry specifying a buffer of 3 Kbytes that starts at a
2K offset in the first page and runs over into the second page.  This case
can happen when the physical memory for the two pages is contiguous
due to random happenstance, due to huge pages, or due to being on an
architecture like ARM64 where the guest page size may be larger than
the Hyper-V page size.

In this case, we need two Hyper-V PFNs because the buffer crosses a
Hyper-V page boundary.   But the above will calculate only one PFN.
The original algorithm handles this case correctly.

> +			hvpfn =3D HVPFN_DOWN(sg_dma_address(sg));
>=20
> -			/*
> -			 * Fill the next portion of the PFN array with
> -			 * sequential Hyper-V PFNs for the continguous physical
> -			 * memory described by the sgl entry. The end of the
> -			 * last sgl should be reached at the same time that
> -			 * the PFN array is filled.
> -			 */

Any reason not to keep this comment?  It's still correct.

>  			while (hvpfns_to_add--)
> -				payload->range.pfn_array[i++] =3D	hvpfn++;
> +				payload->range.pfn_array[i++] =3D hvpfn++;
>  		}
>  	}
>=20
> @@ -1992,6 +1982,7 @@ static int storvsc_probe(struct hv_device *device,
>  	stor_device->vmscsi_size_delta =3D sizeof(struct vmscsi_win8_extension)=
;
>  	spin_lock_init(&stor_device->lock);
>  	hv_set_drvdata(device, stor_device);
> +	dma_set_min_align_mask(&device->device, HV_HYP_PAGE_SIZE - 1);
>=20
>  	stor_device->port_number =3D host->host_no;
>  	ret =3D storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 139a43ad65a1..8f39893f8ccf 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1274,6 +1274,7 @@ struct hv_device {
>=20
>  	struct vmbus_channel *channel;
>  	struct kset	     *channels_kset;
> +	struct device_dma_parameters dma_parms;
>=20
>  	/* place holder to keep track of the dir for hv device in debugfs */
>  	struct dentry *debug_dir;
> --
> 2.25.1

