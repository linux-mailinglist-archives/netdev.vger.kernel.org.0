Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0985467DAA
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 19:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243267AbhLCTDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:03:04 -0500
Received: from mail-cusazlp17010005.outbound.protection.outlook.com ([40.93.13.5]:31537
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242639AbhLCTDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 14:03:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwvvorw3+A+YYcD5vSTxaajypwrEDSblNTf15y8nBuFDxy9pl2iteCEGoAzTWU4+Neck9CAlJlGg47Syj+46hZmHGC/VuM1nJnorGizfpa3YGQ7PRL1h3YiB1/qEJmHDWkMQ482EA17hW3AleMLlfOuDeWwP8Nyu5aUbUukOGtZ3tPnHW/O7MDCeN6hIDbARVOttrQ/JI620sN9+uWOwdoyTZ2vviv+IjXg1WCqJkSNZ44ASHtV0Y7+AusIHsiR6i1Mm8l3crOpaMOCcBtSdIgBOOE+Qp6Sw/cUT5fzB1Yhai29RBKMKh2BNO/rKXE2Taev5aufAcAHKjWcAZ/ReWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zvSmGZWeL7RWAEcBm9oIjTfTcaBDiK4JIFwRC9Z5qI=;
 b=DmA9wQkU4WWD70vdJ0rTD7Utt4ya1UcV9DrNvYAkSwSk2FZMOWwb7QsIbs6cRwzxRUCFb0k8LE0mhH46wwrUg2hWxz2JuLz52YzNKugvjGUe47SerHwK52YKCmlCOIf11P/6hxKHtgJTE0NoqHoKaShnDpW45eXETGCYLFLzNmYvS8UKHw+QSX8B4nIefEWx5rw72hvJ02EN7KGoLcPl8NUjzuHAxWbYf1+t0xA/BipuZc6sHKj3/UR1Xwy+LkfWRc6/kuZ1GkQ+NDGyAbBFOTwQfq3BgH2R524Arty1KNdNkfHcUiaBCZo7XTMGw0022uI8t2S1AtgCTd7N866Z9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zvSmGZWeL7RWAEcBm9oIjTfTcaBDiK4JIFwRC9Z5qI=;
 b=BiC27HDQ44LRg9RXfOjZHExAaPOFEGxSNUX1P8QoDaUcBh8HcGtMWo/XjI9KTkBpjCqf829atRtTQUtzU285LfbyFmgSUL9mKjzGT9hjoee1TATPnI0wcuCFKA23nyxvxREAKRdkP4vidPKJBTbfCFg+6WCUAN4eXASP+yAtXSs=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1019.namprd21.prod.outlook.com (2603:10b6:302:5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.4; Fri, 3 Dec
 2021 18:59:29 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::40d7:92be:b38f:a9cd]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::40d7:92be:b38f:a9cd%3]) with mapi id 15.20.4778.007; Fri, 3 Dec 2021
 18:59:28 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
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
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V3 5/5] hv_netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V3 5/5] hv_netvsc: Add Isolation VM support for netvsc
 driver
Thread-Index: AQHX5sz1lOYUX8sXwkWf4jhcdD0xcKwhHfRw
Date:   Fri, 3 Dec 2021 18:59:28 +0000
Message-ID: <MWHPR21MB15934DE25012A8565256336ED76A9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-6-ltykernel@gmail.com>
In-Reply-To: <20211201160257.1003912-6-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7aa46730-7ac1-4f56-a342-d06f8d3c5a0d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-03T18:44:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4fd0545-1fe9-490d-11ea-08d9b68f0888
x-ms-traffictypediagnostic: MW2PR2101MB1019:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB1019D55A2C3EF51484B7E581D76A9@MW2PR2101MB1019.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ydoQvVlPfMxx+YfYtW+339jBk6xMiWetvoI6kXCiqRvtC6JfucpyOWfrd0a+h5RxygwYl1I15pZuDA/v6Wjcp3XaJ1B83XVnxyWcHSKltL3yJuiSFfAwXb7WKwZ154+PE8lS46uTBLyzoFr21VpaXTifhDJylakapYurHcVSWxqt7rOZkj9rlLmhPfRbTVUwUXqrZqjYrsGAY7idYxiUuG5Rj2qrTI+1Cvsqr3NbYEtWUINEvXyOYDmvWq0wC0c92gUaJX1U5XKYyeDdVq2OusotUAhVrhTXmkLb04/Z4ZBTzf2pZ3djvQczH1R0zfTcqyMZkFQ/HZcStt8NYkJ0cIa4AO2C2CaspPns3WLiw1h7hEbRVnUbAugzCm2Tm64htPq9XL8lIE9Iqgke5rYfmAMvVBfZwPVj9ZS/IqL3oc5A80gv+QQBaq5M0Zl/MnpPu1OcJBKmwqNVcJnyUiVuOS9RabA/rjQFKa63SHLSOfFl9lZwXAA7axn7q5ffN9ZlnJbLnoVSuw62EiPDZ+pyMTrB6z8uxekQq1O8CoN2H1lcAW/gNHrPHg34zJmH/TApJTIXZKHyl0XHBUZxx+W/a8U4OUzRedAdNFREgbEM52vLDdmUj8sbzjN4wjUH5SB4ovixqy060ke6VuebNhQBHkYGMhRIOHV2WYVJ9Tz+gv3xectNAtgHdZkeOiTk8egzDXvUNcIGI9n4GCeaSzB6uinDf7/YrcewVU2V2KDxWj2EcAQBIU3a0vW83ymH8zlCPHru2tVQ/LoBsV4dtth2iQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7406005)(83380400001)(7696005)(38100700002)(52536014)(26005)(122000001)(7416002)(33656002)(2906002)(30864003)(55016003)(8990500004)(921005)(76116006)(110136005)(10290500003)(66476007)(54906003)(508600001)(66946007)(38070700005)(71200400001)(9686003)(316002)(64756008)(4326008)(186003)(66446008)(82960400001)(8676002)(8936002)(82950400001)(5660300002)(6506007)(86362001)(66556008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zro05vSCjNhuL5MHhJZOTjES/UopVWOcpIskjM1HonsMdpJeWb4uyjKZK49+?=
 =?us-ascii?Q?sPTbWrp09l4kVjrnPUElkyQPSW2rCsjz9I0uqEYXSscsthBnmLBxIn9OFuIn?=
 =?us-ascii?Q?/ko3l7vahMQIWCVgMS/3clNRo8sbdGJ5KSN2jUawD6pr/3m+Psh7Jzpt1zEQ?=
 =?us-ascii?Q?Jo7rc1X4wPqQvquhEWhM0xaZf6BcSdmfAmq5oyLzqWxYdyTJMT6D3Nv1IZoP?=
 =?us-ascii?Q?G5S6svamQHo/NG72c6H1PIyRkVThXgCZ3TFHfTKL5mSGkbfMmz3L9ofEOVkG?=
 =?us-ascii?Q?hz4W72vOpX/2jIXdE0XrP1g7TOIt9Euax44m2MkDuaA5K9MegcMEjJjBMTH7?=
 =?us-ascii?Q?uEUas+uIia4ztMbRKx7d/v0XVEjHFiAfySOL7pCa0OLlQ30Att4f6rmBQQmG?=
 =?us-ascii?Q?eG3bdaBrnYhaxeD7M7lV/Nux6v/mcc4gErL5Ek2QWc8JizuQN/XpSsJdGg9y?=
 =?us-ascii?Q?NJQ3DVOjgBuhQBPIdd9BaeNTA3YuoZHCGdMnY/cgQxDqGqvm9go9EaA1/LfZ?=
 =?us-ascii?Q?QrlLu/dnubx1sw92+WypKQcH8BRbW/a6hCxKmDjYYO9kls5FWRsTllUzPQcQ?=
 =?us-ascii?Q?AjjfxzU/CReHsPVVAjj2X+8CozdfyXNgeU3F3vNpN7gmiSiEZ7IIwa69v2Az?=
 =?us-ascii?Q?ydOhQIzKdk2xL7PZup1Qi1LaEHZKNz/4zh9H+iH9aZg6KgxkZs1PbfbdgiI1?=
 =?us-ascii?Q?pZW9idJgm8kIDWzDfxW6Z4Ycyr66zEdbkrtcVnNY7O+5BXwlxst96aJAj+va?=
 =?us-ascii?Q?uGNSZu81g3h2Acq4GNRQxb/1fdEDa01z6/9Tiu73WxzTprkmlrqV8cTO3MmJ?=
 =?us-ascii?Q?I2GixJzZjMahihMWVm+gILXztvQQjyjGEQm+2JKNRflygrVIQllAzhf/FhCS?=
 =?us-ascii?Q?+247wG9pKiyt2JF7bph+WCgID9oRz90f/AqwVG2JSdM7Uj3H7IFuCXiibXw7?=
 =?us-ascii?Q?Z5CIgeeV0XFrHXT/1Nu1vAO9ceHSzVeEL/rHUDBp67rXjOutI2+lqgWTKTeO?=
 =?us-ascii?Q?f1vR1eEABitU9o9v3kHjGkgPLwF4V7aNHXqPmzLnpgTSCQ4cQzk2oal1cAJD?=
 =?us-ascii?Q?YN/2lAfhZCo/gwpodcKhFT9/R/sNpwGwtI0+4gbTXJ3b/U7jHJDY2ZhkDRDc?=
 =?us-ascii?Q?LwIW15Tg5VbdX+hcaVnPNvMTJFSbakCQCm7cOSh+4lNhi1dWe2mnuBBb3Pig?=
 =?us-ascii?Q?/6V6BEnNe/xjAuu0yO4fc8kRTSDXPv99wtqcMFQ4Ygsmd1VYaPGOHrk/7nvz?=
 =?us-ascii?Q?wyXUbAlq1VOevie58iYz06IJn0uRxxqzKCZ3WnD9X7eDNgCwJUUU36Bc0cBl?=
 =?us-ascii?Q?jQvDM79Xd8wsUD8PEGR8F0J0vKgcxSc+1EnINQRLjntgo1ELCmE2REZSZ/fN?=
 =?us-ascii?Q?GRseoeIIFNtDnDxO2JKwMGlnQIsKBY+nAH/Jp1VZ3NbYVxiNU7LuuwvZkEz6?=
 =?us-ascii?Q?76Mg1mInYSEe7Xh27WOuH1Av+0Shqefq64UumAWF4FB2m1sBvHvYXXfx8xHq?=
 =?us-ascii?Q?ah4Ul6oRzXrIQUL5/YXRuzb1yKj618fuHOVSq+UzA+6kToluDHd4w0XfFOOq?=
 =?us-ascii?Q?5cuYbfyBTSZnEyFbShNhPGM5BuhBHX/yNn/Pq4tMkSOwJjzQ2TTma10tmB9S?=
 =?us-ascii?Q?d402NcSXuQalpQsaEegUQG2pmbbC1GUqaMH59uPaQpgJqr25hurQg7ODq8ET?=
 =?us-ascii?Q?QmrLAA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4fd0545-1fe9-490d-11ea-08d9b68f0888
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 18:59:28.7049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NNhAqCcIO2/MvZ83887pIu/DkGlbprQSyQM4VAMD175E+8fHTfeqdSeFGghpyHZnawQeWGOLtdfagQjnJczuCNx+Z3JOc24ccqsSmogkqcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Wednesday, December 1, 2021 8:=
03 AM
>=20
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() stills need to be handled. Use DMA API to map/umap
> these memory during sending/receiving packet and Hyper-V swiotlb
> bounce buffer dma adress will be returned. The swiotlb bounce buffer
> has been masked to be visible to host during boot up.
>=20
> rx/tx ring buffer is allocated via vzalloc() and they need to be
> mapped into unencrypted address space(above vTOM) before sharing
> with host and accessing. Add hv_map/unmap_memory() to map/umap rx
> /tx ring buffer.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v2:
>        * Add hv_map/unmap_memory() to map/umap rx/tx ring buffer.
> ---
>  arch/x86/hyperv/ivm.c             |  28 ++++++
>  drivers/hv/hv_common.c            |  11 +++
>  drivers/net/hyperv/hyperv_net.h   |   5 ++
>  drivers/net/hyperv/netvsc.c       | 136 +++++++++++++++++++++++++++++-
>  drivers/net/hyperv/netvsc_drv.c   |   1 +
>  drivers/net/hyperv/rndis_filter.c |   2 +
>  include/asm-generic/mshyperv.h    |   2 +
>  include/linux/hyperv.h            |   5 ++
>  8 files changed, 187 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index 69c7a57f3307..9f78d8f67ea3 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -287,3 +287,31 @@ int hv_set_mem_host_visibility(unsigned long kbuffer=
, int pagecount, bool visibl
>  	kfree(pfn_array);
>  	return ret;
>  }
> +
> +/*
> + * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolatio=
n VM.
> + */
> +void *hv_map_memory(void *addr, unsigned long size)
> +{
> +	unsigned long *pfns =3D kcalloc(size / HV_HYP_PAGE_SIZE,

This should be just PAGE_SIZE, as this code is unrelated to communication
with Hyper-V.

> +				      sizeof(unsigned long), GFP_KERNEL);
> +	void *vaddr;
> +	int i;
> +
> +	if (!pfns)
> +		return NULL;
> +
> +	for (i =3D 0; i < size / PAGE_SIZE; i++)
> +		pfns[i] =3D virt_to_hvpfn(addr + i * PAGE_SIZE) +

Same here:  Use virt_to_pfn().

> +			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
> +
> +	vaddr =3D vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
> +	kfree(pfns);
> +
> +	return vaddr;
> +}
> +
> +void hv_unmap_memory(void *addr)
> +{
> +	vunmap(addr);
> +}
> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> index 7be173a99f27..3c5cb1f70319 100644
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -295,3 +295,14 @@ u64 __weak hv_ghcb_hypercall(u64 control, void *inpu=
t, void *output, u32 input_s
>  	return HV_STATUS_INVALID_PARAMETER;
>  }
>  EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);
> +
> +void __weak *hv_map_memory(void *addr, unsigned long size)
> +{
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(hv_map_memory);
> +
> +void __weak hv_unmap_memory(void *addr)
> +{
> +}
> +EXPORT_SYMBOL_GPL(hv_unmap_memory);
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index 315278a7cf88..cf69da0e296c 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -164,6 +164,7 @@ struct hv_netvsc_packet {
>  	u32 total_bytes;
>  	u32 send_buf_index;
>  	u32 total_data_buflen;
> +	struct hv_dma_range *dma_range;
>  };
>=20
>  #define NETVSC_HASH_KEYLEN 40
> @@ -1074,6 +1075,7 @@ struct netvsc_device {
>=20
>  	/* Receive buffer allocated by us but manages by NetVSP */
>  	void *recv_buf;
> +	void *recv_original_buf;
>  	u32 recv_buf_size; /* allocated bytes */
>  	struct vmbus_gpadl recv_buf_gpadl_handle;
>  	u32 recv_section_cnt;
> @@ -1082,6 +1084,7 @@ struct netvsc_device {
>=20
>  	/* Send buffer allocated by us */
>  	void *send_buf;
> +	void *send_original_buf;
>  	u32 send_buf_size;
>  	struct vmbus_gpadl send_buf_gpadl_handle;
>  	u32 send_section_cnt;
> @@ -1731,4 +1734,6 @@ struct rndis_message {
>  #define RETRY_US_HI	10000
>  #define RETRY_MAX	2000	/* >10 sec */
>=20
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet);
>  #endif /* _HYPERV_NET_H */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 396bc1c204e6..b7ade735a806 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -153,8 +153,21 @@ static void free_netvsc_device(struct rcu_head *head=
)
>  	int i;
>=20
>  	kfree(nvdev->extension);
> -	vfree(nvdev->recv_buf);
> -	vfree(nvdev->send_buf);
> +
> +	if (nvdev->recv_original_buf) {
> +		hv_unmap_memory(nvdev->recv_buf);
> +		vfree(nvdev->recv_original_buf);
> +	} else {
> +		vfree(nvdev->recv_buf);
> +	}
> +
> +	if (nvdev->send_original_buf) {
> +		hv_unmap_memory(nvdev->send_buf);
> +		vfree(nvdev->send_original_buf);
> +	} else {
> +		vfree(nvdev->send_buf);
> +	}
> +
>  	kfree(nvdev->send_section_map);
>=20
>  	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++) {
> @@ -338,6 +351,7 @@ static int netvsc_init_buf(struct hv_device *device,
>  	unsigned int buf_size;
>  	size_t map_words;
>  	int i, ret =3D 0;
> +	void *vaddr;
>=20
>  	/* Get receive buffer area. */
>  	buf_size =3D device_info->recv_sections * device_info->recv_section_siz=
e;
> @@ -373,6 +387,17 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		vaddr =3D hv_map_memory(net_device->recv_buf, buf_size);
> +		if (!vaddr) {
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +
> +		net_device->recv_original_buf =3D net_device->recv_buf;
> +		net_device->recv_buf =3D vaddr;
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -476,6 +501,17 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_isolation_type_snp()) {
> +		vaddr =3D hv_map_memory(net_device->send_buf, buf_size);
> +		if (!vaddr) {
> +			ret =3D -ENOMEM;
> +			goto cleanup;
> +		}
> +
> +		net_device->send_original_buf =3D net_device->send_buf;
> +		net_device->send_buf =3D vaddr;
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet =3D &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -766,7 +802,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>=20
>  	/* Notify the layer above us */
>  	if (likely(skb)) {
> -		const struct hv_netvsc_packet *packet
> +		struct hv_netvsc_packet *packet
>  			=3D (struct hv_netvsc_packet *)skb->cb;
>  		u32 send_index =3D packet->send_buf_index;
>  		struct netvsc_stats *tx_stats;
> @@ -782,6 +818,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>  		tx_stats->bytes +=3D packet->total_bytes;
>  		u64_stats_update_end(&tx_stats->syncp);
>=20
> +		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  		napi_consume_skb(skb, budget);
>  	}
>=20
> @@ -946,6 +983,88 @@ static void netvsc_copy_to_send_buf(struct netvsc_de=
vice *net_device,
>  		memset(dest, 0, padding);
>  }
>=20
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet)
> +{
> +	u32 page_count =3D packet->cp_partial ?
> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> +		packet->page_buf_cnt;
> +	int i;
> +
> +	if (!hv_is_isolation_supported())
> +		return;
> +
> +	if (!packet->dma_range)
> +		return;
> +
> +	for (i =3D 0; i < page_count; i++)
> +		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
> +				 packet->dma_range[i].mapping_size,
> +				 DMA_TO_DEVICE);
> +
> +	kfree(packet->dma_range);
> +}
> +
> +/* netvsc_dma_map - Map swiotlb bounce buffer with data page of
> + * packet sent by vmbus_sendpacket_pagebuffer() in the Isolation
> + * VM.
> + *
> + * In isolation VM, netvsc send buffer has been marked visible to
> + * host and so the data copied to send buffer doesn't need to use
> + * bounce buffer. The data pages handled by vmbus_sendpacket_pagebuffer(=
)
> + * may not be copied to send buffer and so these pages need to be
> + * mapped with swiotlb bounce buffer. netvsc_dma_map() is to do
> + * that. The pfns in the struct hv_page_buffer need to be converted
> + * to bounce buffer's pfn. The loop here is necessary because the
> + * entries in the page buffer array are not necessarily full
> + * pages of data.  Each entry in the array has a separate offset and
> + * len that may be non-zero, even for entries in the middle of the
> + * array.  And the entries are not physically contiguous.  So each
> + * entry must be individually mapped rather than as a contiguous unit.
> + * So not use dma_map_sg() here.
> + */
> +int netvsc_dma_map(struct hv_device *hv_dev,
> +		   struct hv_netvsc_packet *packet,
> +		   struct hv_page_buffer *pb)
> +{
> +	u32 page_count =3D  packet->cp_partial ?
> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> +		packet->page_buf_cnt;
> +	dma_addr_t dma;
> +	int i;
> +
> +	if (!hv_is_isolation_supported())
> +		return 0;
> +
> +	packet->dma_range =3D kcalloc(page_count,
> +				    sizeof(*packet->dma_range),
> +				    GFP_KERNEL);
> +	if (!packet->dma_range)
> +		return -ENOMEM;
> +
> +	for (i =3D 0; i < page_count; i++) {
> +		char *src =3D phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
> +					 + pb[i].offset);
> +		u32 len =3D pb[i].len;
> +
> +		dma =3D dma_map_single(&hv_dev->device, src, len,
> +				     DMA_TO_DEVICE);
> +		if (dma_mapping_error(&hv_dev->device, dma)) {
> +			kfree(packet->dma_range);
> +			return -ENOMEM;
> +		}
> +
> +		/* pb[].offset and pb[].len are not changed during dma mapping
> +		 * and so not reassign.
> +		 */
> +		packet->dma_range[i].dma =3D dma;
> +		packet->dma_range[i].mapping_size =3D len;
> +		pb[i].pfn =3D dma >> HV_HYP_PAGE_SHIFT;
> +	}
> +
> +	return 0;
> +}
> +
>  static inline int netvsc_send_pkt(
>  	struct hv_device *device,
>  	struct hv_netvsc_packet *packet,
> @@ -986,14 +1105,24 @@ static inline int netvsc_send_pkt(
>=20
>  	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
>=20
> +	packet->dma_range =3D NULL;
>  	if (packet->page_buf_cnt) {
>  		if (packet->cp_partial)
>  			pb +=3D packet->rmsg_pgcnt;
>=20
> +		ret =3D netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
> +		if (ret) {
> +			ret =3D -EAGAIN;
> +			goto exit;
> +		}
> +
>  		ret =3D vmbus_sendpacket_pagebuffer(out_channel,
>  						  pb, packet->page_buf_cnt,
>  						  &nvmsg, sizeof(nvmsg),
>  						  req_id);
> +
> +		if (ret)
> +			netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  	} else {
>  		ret =3D vmbus_sendpacket(out_channel,
>  				       &nvmsg, sizeof(nvmsg),
> @@ -1001,6 +1130,7 @@ static inline int netvsc_send_pkt(
>  				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>  	}
>=20
> +exit:
>  	if (ret =3D=3D 0) {
>  		atomic_inc_return(&nvchan->queue_sends);
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index 7e66ae1d2a59..17958533bf30 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2512,6 +2512,7 @@ static int netvsc_probe(struct hv_device *dev,
>  	net->netdev_ops =3D &device_ops;
>  	net->ethtool_ops =3D &ethtool_ops;
>  	SET_NETDEV_DEV(net, &dev->device);
> +	dma_set_min_align_mask(&dev->device, HV_HYP_PAGE_SIZE - 1);
>=20
>  	/* We always need headroom for rndis header */
>  	net->needed_headroom =3D RNDIS_AND_PPI_SIZE;
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index f6c9c2a670f9..448fcc325ed7 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -361,6 +361,8 @@ static void rndis_filter_receive_response(struct net_=
device *ndev,
>  			}
>  		}
>=20
> +		netvsc_dma_unmap(((struct net_device_context *)
> +			netdev_priv(ndev))->device_ctx, &request->pkt);
>  		complete(&request->wait_event);
>  	} else {
>  		netdev_err(ndev,
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index 3e2248ac328e..94e73ba129c5 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -269,6 +269,8 @@ bool hv_isolation_type_snp(void);
>  u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_=
size);
>  void hyperv_cleanup(void);
>  bool hv_query_ext_cap(u64 cap_query);
> +void *hv_map_memory(void *addr, unsigned long size);
> +void hv_unmap_memory(void *addr);
>  #else /* CONFIG_HYPERV */
>  static inline bool hv_is_hyperv_initialized(void) { return false; }
>  static inline bool hv_is_hibernation_supported(void) { return false; }
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 74f5e92f91a0..b53cfc4163af 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1584,6 +1584,11 @@ struct hyperv_service_callback {
>  	void (*callback)(void *context);
>  };
>=20
> +struct hv_dma_range {
> +	dma_addr_t dma;
> +	u32 mapping_size;
> +};
> +
>  #define MAX_SRV_VER	0x7ffffff
>  extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp, u8 *b=
uf, u32 buflen,
>  				const int *fw_version, int fw_vercnt,
> --
> 2.25.1

