Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556F33F1FC4
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 20:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhHSSSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 14:18:30 -0400
Received: from mail-oln040093003005.outbound.protection.outlook.com ([40.93.3.5]:21631
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229549AbhHSSS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 14:18:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwoZtuZ56poBUOAFZDpPHGy727LmeVpInTf9G53/pto5ISJpdkF8h4T0ttB83M10dk8c9mXechzbN4AwtCOWv8TQgN2/tafxbl0JFntG8SWGg33wQybtmc3AguccxS7pYiazTS48aJIpCAX+bCJ9tcdfjVMfshyG4zWtAYPThG85Q54NJZBBuyCBWoNSdOP+snI4mO1bg3BmLHMtpAB+ZEj8xJfhg1mdrw9okMrn+Nkp7c9BZKhxHL6f5OZ9Kx/+jXJgnhw7moiHVecjMSRxyBoQBNQT4+caQD/6LH3B8i2Ng7eN03v8ZNsi1vu56vX2OrDkypx3URU62sNFKwOHfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH7nccGMyVjmseQJK2PILp+62BP0KDo4OBuH+BbYWOU=;
 b=RkgbBJWx4eObCYmg0M9uj9K5g3M1a4vzjE5DnEhCwfmxkeaa8bUl8jySyVqxgVp2HI7pgStXV1DqNo+VWuAAAxav0ADDiNlSUkrfLVPLVyewo7U2+QmsmIe+OpyYkCDcMSPUY4Yi+WLGBcGDwgsB1j6pC3YE+pExxCzRM0R+r/NHv+9beiBbzkD0xIV6L5LClJKwzgNUbY/dZHkaB0pJ8k+Lnbfru1jUrS7UTx1+DsXhJ4cP1+4vD6UsZ06NlmCIg8+nHoa/9r7x5fV6GzrdjWZdplaFxl7ynl/bKed5jG4QmNeZyjb5SP6Msq0dsatjkeOTzcp2eD52BT8R8uU5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH7nccGMyVjmseQJK2PILp+62BP0KDo4OBuH+BbYWOU=;
 b=hEwmvbxWcOW3Ug7G1e6GHsLdGSvXjC7cquF8FEnH/WFmo9aVmASk3i007zdJwwj5ap551GdTJCXFfSoiGKXGmi2p9Yavm6fJFTy6VQfM+5d6iQauIOa35zoy1YNK7pNZEXkOrt+Lu3ejACktL3oUOgulADIFtKuvvQDk94jsH7A=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0157.namprd21.prod.outlook.com (2603:10b6:300:78::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.0; Thu, 19 Aug
 2021 18:17:41 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Thu, 19 Aug 2021
 18:17:41 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
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
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for storvsc
 driver
Thread-Topic: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for
 storvsc driver
Thread-Index: AQHXjUf4MnryDC/QY0a+heAsfHsxAqt3v7Vg
Date:   Thu, 19 Aug 2021 18:17:40 +0000
Message-ID: <MWHPR21MB1593EEF30FFD5C60ED744985D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-14-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-14-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1ae64eaa-5064-47d6-83ad-1e0f1430f884;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-17T13:38:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d025336-aab8-47e4-b431-08d9633da1f4
x-ms-traffictypediagnostic: MWHPR21MB0157:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB01577B563FAF54CAB3B8CA01D7C09@MWHPR21MB0157.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ScXcwsXWhrmaFAN8/2i2kKNj108qUNyE2K166GSD9aPFvRa3jK0e69/YKrtsdCQjTN03Mjd7Ti0oK9rgH+yanH/ed6/9hxxkrGx+4b6eCazcp4wxO+H9mGMt+maLZ+5Y85nzjQ1IQFumdCEnr7hYQUYokAm/3Vl9h1X7CikshcCi4yov+WWEbegmUDaMzxwFK076WGlj+O3uW4zjguMOqNpFOY9e1N6kijFbQOuMGk58zdF2h04Yli2fliZ2c5HvW4CqIaE0BCSvBcie5xqsPM0zNG0O2w65oOEybWtQ5eoXvk3HD/V3wBKRzzxlhmPMPfODC6gZUCvhaitsjEd4m9JsX6rYUol54NiJdZFbBInIxfg9ALnmx2oiYSHYHEowHCpRnbc0UNLNUSricJFlMC2AJqxc9gTwFNx0j21dTV1eFsi7LkIUpV8ffpPU+yZF3BjKmc4yvOxbJ7mjaHYor5C6YrVfr5YGBK8GXxI5OPlnVbQcBlxSJYx8durwTVSBDEiGyf7fRTGTbqU8/bFu97GNNKcK2ieFBq4wlluZ6DVGjKT8wIiH9q1XY4ntgGQSWiGm0fCDoQcJNxFto+LZnT+XmRV9Bic2yibDWKLq7+gQ4nw1LC5v6Bo/QaRUA3WlEm6dtkhZQxqTOZSSUfxrCnl+9tW6q1fDmbCThGyy/+4IYxUmpD2vuxbggLx3a5be9ZD58RGaqoODWYN1sY5HYjf86l/0B6EvzUo/IzzGNA4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(82960400001)(82950400001)(7406005)(4326008)(8936002)(921005)(64756008)(6506007)(54906003)(76116006)(52536014)(66476007)(66556008)(10290500003)(66446008)(5660300002)(9686003)(38070700005)(66946007)(508600001)(186003)(316002)(26005)(71200400001)(38100700002)(86362001)(8990500004)(55016002)(122000001)(110136005)(8676002)(2906002)(83380400001)(33656002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aRG0iUVklSuAwUfBH5qJHOcPbkC2NrBtDsBCLSkID9XrcymfQwAnM0p1s4aH?=
 =?us-ascii?Q?ayIs8eKXmVoREMXx0tJ5psyVGRZpaSjImNiC+ql3NL/sOhAOSQErqB+8huN7?=
 =?us-ascii?Q?5AueEWK6SHl2tn65S4R5BFyYJEwPa0ShHubzZ94bON8dYhBKqg5nL/VyE5pZ?=
 =?us-ascii?Q?nykGs6kivUHi1oV1E32a9+4KeiH1j0EirOtjuWONRrXuHEjba7wCRu3sclxk?=
 =?us-ascii?Q?mXfXwHoOvNEG1fVL3lAiwazbd+QWe0wEkb5qYGqSlcc3SwrHkqkdNnc0GWVG?=
 =?us-ascii?Q?MsniUo3pV/3jV8aHbqkVoCmBb/tuIL7k2uEzWak9i/6UwzeHXxPis6kRoYXj?=
 =?us-ascii?Q?5hcfghMjyjmqsgAjBx3m932SrOfxk43abSQeYQjG+UqQPwMG8UNasuACU/39?=
 =?us-ascii?Q?M0ryg1ouf6en+A0tmz023Q8G9/V3ZR+8k5AYpDHk+eRGCLM20Z7OjEPHPDSJ?=
 =?us-ascii?Q?l27eVJbil/rkFzBJqbx9Q4p+/A01rpYWcg96y+v8WMOJD8QxBQyFgUXP32sp?=
 =?us-ascii?Q?PlV/OOgllavbjk66lBUd/Ywknwux4sKWZHTOgL8vdlQVHYXXi8uXhpqe2a+P?=
 =?us-ascii?Q?fE4VsT65V9rR7Ix4WTRG0j7aPOJpJA7BLmlQ/qpOX5Kh0LTlBOsB3HO+MrIh?=
 =?us-ascii?Q?TJG2Pzz6i9q/0+CZC8TG27rbH7NIK8B8rHnBKcaGW/aQnis/1ZogZffdUjxp?=
 =?us-ascii?Q?ezawhTI++zNbUDGIzpisi2Cz4fh3l5UlgKVMdFQGG790lfTQ1gxVUTYE2M52?=
 =?us-ascii?Q?p/53KlgUc6peD/gYKXHXiHcl0dHJyCdkvlAQj8HEd1nmvIzopkprmprhkr4y?=
 =?us-ascii?Q?ygpG9dXonzxJD+bb56GNug83x4U3UO1FvDZvdeHPaKjGyT10yu4naSRz86Mv?=
 =?us-ascii?Q?1NXVgseQA/24gxFG81Fpi7ZYX2QzpoDQ5XuPcqpB0QgvQ5ZsvGNVH/Nz3J2E?=
 =?us-ascii?Q?hHz6AYfPrPUvc4zgk1809DK3q2Y2KN99JCaL+1VCH9TbI4YZ5MpklVCm8lJJ?=
 =?us-ascii?Q?R23piGdNkdsFs26/UJhj/btxx7Zno1Is5HQILxrtb6vIAMcu3uqtPKcw8IBp?=
 =?us-ascii?Q?sGYW6vJTC4F2CfcuAo6j6ike2Xzay4ISRf8ApYMVQKzi2TT0/4ymi33KQF+h?=
 =?us-ascii?Q?BmBug6I/zu5uLUE8qfyQQf3oaAErEF3xL+gnyW6fTEdmEMbOm+4IoPoOnGen?=
 =?us-ascii?Q?ZsIrSMlm/FHaST+mKTLaWUR16a6iAdfSRSgj5Mx03d0CaMbhhye3e/GPk+uO?=
 =?us-ascii?Q?cW+fgT/NRtDUJBvQJVreGSFoMD6L3B8AZekn29yRxzZHRhepId7fjmOeNeN/?=
 =?us-ascii?Q?Wx/0SD7wgUW1SJ9OuDuFhv4J?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d025336-aab8-47e4-b431-08d9633da1f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 18:17:40.7071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxCcduKUuq1yHcc8BsJo2y07vKDxnuPAOoqjd/EdOBhLTw4z1rxs+qoA6XlnF0e5Uwp/eRboma6yR4YImauNFpMjY24DH0n1n0/wzhvT2kA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
>=20

Subject line tag should be "scsi: storvsc:"

> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> storvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> mpb_desc() still need to handle. Use DMA API to map/umap these

s/need to handle/needs to be handled/

> memory during sending/receiving packet and Hyper-V DMA ops callback
> will use swiotlb function to allocate bounce buffer and copy data
> from/to bounce buffer.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 68 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 63 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 328bb961c281..78320719bdd8 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -21,6 +21,8 @@
>  #include <linux/device.h>
>  #include <linux/hyperv.h>
>  #include <linux/blkdev.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_host.h>
> @@ -427,6 +429,8 @@ struct storvsc_cmd_request {
>  	u32 payload_sz;
>=20
>  	struct vstor_packet vstor_packet;
> +	u32 hvpg_count;

This count is really the number of entries in the dma_range
array, right?  If so, perhaps "dma_range_count" would be
a better name so that it is more tightly associated.

> +	struct hv_dma_range *dma_range;
>  };
>=20
>=20
> @@ -509,6 +513,14 @@ struct storvsc_scan_work {
>  	u8 tgt_id;
>  };
>=20
> +#define storvsc_dma_map(dev, page, offset, size, dir) \
> +	dma_map_page(dev, page, offset, size, dir)
> +
> +#define storvsc_dma_unmap(dev, dma_range, dir)		\
> +		dma_unmap_page(dev, dma_range.dma,	\
> +			       dma_range.mapping_size,	\
> +			       dir ? DMA_FROM_DEVICE : DMA_TO_DEVICE)
> +

Each of these macros is used only once.  IMHO, they don't
add a lot of value.  Just coding dma_map/unmap_page()
inline would be fine and eliminate these lines of code.

>  static void storvsc_device_scan(struct work_struct *work)
>  {
>  	struct storvsc_scan_work *wrk;
> @@ -1260,6 +1272,7 @@ static void storvsc_on_channel_callback(void *conte=
xt)
>  	struct hv_device *device;
>  	struct storvsc_device *stor_device;
>  	struct Scsi_Host *shost;
> +	int i;
>=20
>  	if (channel->primary_channel !=3D NULL)
>  		device =3D channel->primary_channel->device_obj;
> @@ -1314,6 +1327,15 @@ static void storvsc_on_channel_callback(void *cont=
ext)
>  				request =3D (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
>  			}
>=20
> +			if (request->dma_range) {
> +				for (i =3D 0; i < request->hvpg_count; i++)
> +					storvsc_dma_unmap(&device->device,
> +						request->dma_range[i],
> +						request->vstor_packet.vm_srb.data_in =3D=3D READ_TYPE);

I think you can directly get the DMA direction as request->cmd->sc_data_dir=
ection.

> +
> +				kfree(request->dma_range);
> +			}
> +
>  			storvsc_on_receive(stor_device, packet, request);
>  			continue;
>  		}
> @@ -1810,7 +1832,9 @@ static int storvsc_queuecommand(struct Scsi_Host *h=
ost, struct scsi_cmnd *scmnd)
>  		unsigned int hvpgoff, hvpfns_to_add;
>  		unsigned long offset_in_hvpg =3D offset_in_hvpage(sgl->offset);
>  		unsigned int hvpg_count =3D HVPFN_UP(offset_in_hvpg + length);
> +		dma_addr_t dma;
>  		u64 hvpfn;
> +		u32 size;
>=20
>  		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
>=20
> @@ -1824,6 +1848,13 @@ static int storvsc_queuecommand(struct Scsi_Host *=
host, struct scsi_cmnd *scmnd)
>  		payload->range.len =3D length;
>  		payload->range.offset =3D offset_in_hvpg;
>=20
> +		cmd_request->dma_range =3D kcalloc(hvpg_count,
> +				 sizeof(*cmd_request->dma_range),
> +				 GFP_ATOMIC);

With this patch, it appears that storvsc_queuecommand() is always
doing bounce buffering, even when running in a non-isolated VM.
The dma_range is always allocated, and the inner loop below does
the dma mapping for every I/O page.  The corresponding code in
storvsc_on_channel_callback() that does the dma unmap allows for
the dma_range to be NULL, but that never happens.

> +		if (!cmd_request->dma_range) {
> +			ret =3D -ENOMEM;

The other memory allocation failure in this function returns
SCSI_MLQUEUE_DEVICE_BUSY.   It may be debatable as to whether
that's the best approach, but that's a topic for a different patch.  I
would suggest being consistent and using the same return code
here.

> +			goto free_payload;
> +		}
>=20
>  		for (i =3D 0; sgl !=3D NULL; sgl =3D sg_next(sgl)) {
>  			/*
> @@ -1847,9 +1878,29 @@ static int storvsc_queuecommand(struct Scsi_Host *=
host, struct scsi_cmnd *scmnd)
>  			 * last sgl should be reached at the same time that
>  			 * the PFN array is filled.
>  			 */
> -			while (hvpfns_to_add--)
> -				payload->range.pfn_array[i++] =3D	hvpfn++;
> +			while (hvpfns_to_add--) {
> +				size =3D min(HV_HYP_PAGE_SIZE - offset_in_hvpg,
> +					   (unsigned long)length);
> +				dma =3D storvsc_dma_map(&dev->device, pfn_to_page(hvpfn++),
> +						      offset_in_hvpg, size,
> +						      scmnd->sc_data_direction);
> +				if (dma_mapping_error(&dev->device, dma)) {
> +					ret =3D -ENOMEM;

The typical error from dma_map_page() will be running out of
bounce buffer memory.   This is a transient condition that should be
retried at the higher levels.  So make sure to return an error code
that indicates the I/O should be resubmitted.

> +					goto free_dma_range;
> +				}
> +
> +				if (offset_in_hvpg) {
> +					payload->range.offset =3D dma & ~HV_HYP_PAGE_MASK;
> +					offset_in_hvpg =3D 0;
> +				}

I'm not clear on why payload->range.offset needs to be set again.
Even after the dma mapping is done, doesn't the offset in the first
page have to be the same?  If it wasn't the same, Hyper-V wouldn't
be able to process the PFN list correctly.  In fact, couldn't the above
code just always set offset_in_hvpg =3D 0?

> +
> +				cmd_request->dma_range[i].dma =3D dma;
> +				cmd_request->dma_range[i].mapping_size =3D size;
> +				payload->range.pfn_array[i++] =3D dma >> HV_HYP_PAGE_SHIFT;
> +				length -=3D size;
> +			}
>  		}
> +		cmd_request->hvpg_count =3D hvpg_count;

This line just saves the size of the dma_range array.  Could
it be moved up with the code that allocates the dma_range
array?  To me, it would make more sense to have all that
code together in one place.

>  	}

The whole approach here is to do dma remapping on each individual page
of the I/O buffer.  But wouldn't it be possible to use dma_map_sg() to map
each scatterlist entry as a unit?  Each scatterlist entry describes a range=
 of
physically contiguous memory.  After dma_map_sg(), the resulting dma
address must also refer to a physically contiguous range in the swiotlb
bounce buffer memory.   So at the top of the "for" loop over the scatterlis=
t
entries, do dma_map_sg() if we're in an isolated VM.  Then compute the
hvpfn value based on the dma address instead of sg_page().  But everything
else is the same, and the inner loop for populating the pfn_arry is unmodif=
ied.
Furthermore, the dma_range array that you've added is not needed, since
scatterlist entries already have a dma_address field for saving the mapped
address, and dma_unmap_sg() uses that field.

One thing:  There's a maximum swiotlb mapping size, which I think works
out to be 256 Kbytes.  See swiotlb_max_mapping_size().  We need to make
sure that we don't get a scatterlist entry bigger than this size.  But I th=
ink
this already happens because you set the device->dma_mask field in
Patch 11 of this series.  __scsi_init_queue checks for this setting and
sets max_sectors to limits transfers to the max mapping size.

>=20
>  	cmd_request->payload =3D payload;
> @@ -1860,13 +1911,20 @@ static int storvsc_queuecommand(struct Scsi_Host =
*host, struct scsi_cmnd *scmnd)
>  	put_cpu();
>=20
>  	if (ret =3D=3D -EAGAIN) {
> -		if (payload_sz > sizeof(cmd_request->mpb))
> -			kfree(payload);
>  		/* no more space */
> -		return SCSI_MLQUEUE_DEVICE_BUSY;
> +		ret =3D SCSI_MLQUEUE_DEVICE_BUSY;
> +		goto free_dma_range;
>  	}
>=20
>  	return 0;
> +
> +free_dma_range:
> +	kfree(cmd_request->dma_range);
> +
> +free_payload:
> +	if (payload_sz > sizeof(cmd_request->mpb))
> +		kfree(payload);
> +	return ret;
>  }
>=20
>  static struct scsi_host_template scsi_driver =3D {
> --
> 2.25.1

