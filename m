Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A007B40B395
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbhINPvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:51:10 -0400
Received: from mail-oln040093003011.outbound.protection.outlook.com ([40.93.3.11]:58808
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235069AbhINPuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 11:50:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVpYj/cHMGnqw3aZqz3CXub/GCyOE2J+snAOvN13PN21RYy+XKkUABQQgY9faJh3oIhurbFh8GVXyzWq7ysq5bSFE9jIss4vYw2r6IzDbjZaOCRmYe7yvbk4OHX52wTdxmh4bwj4XbTZTGdvL2T0jQ3crvPcSOjlbuivofTA+DTNvpD1LfHoeBCX2600QIis1DsonUDjwfRdcMa3V73EQRF7DgmaSNWFt9H4xYo5lkdoSEpz3a4FdgV6jDYMTbh1IoBz8PVDyBGsd0dme6CS2BlSj1UjNRZZ0y57AKMx2onrgR0irV/nzAJkOfEkdABExuPLrqETpa5pzMBDxGyYQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=F1OIXYjt1pXx+hzAgzU8rYjUG5YvunZwpM+CWxD9qNA=;
 b=A0gw6NlIUkBR2crB4hPIXSukhrZZo5gTUw8lReDD40jzWxeecOlQuElVzasG0f0PenKOn+KqekhvQ3r69AMCqiQ0Czuw2QZMqYrnY7A8KnDvdeajn3qlw0FeES2RlFy0cs/JJGHUMMYJ1mqkqZNYvVC1nI6d28ihqX7JqXWj7aP6pzakKe0BPhG0hyDPF94EVsgiDOXg80Vp2VvGmekkqYZqeT2OCNun9It1AEAgf6vCFEqGPonmHN/zr+kiO0NmykBfMsmqTyhWRZt4YdwiQYz+ZBqJOudCkidmjJiZ3gDPpl6vqL6PL5bJrho8b4nc+UpmeKNWBqLpO4VVWhEmUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1OIXYjt1pXx+hzAgzU8rYjUG5YvunZwpM+CWxD9qNA=;
 b=aHx6tePt+bfF9MDFHVxp06gNV+r5+IlTaCjIuaEUdLR9q15DKvn/c91O5froQl2Bz+UOQkts25lPvRjEOj8peFlNIrDPpKWTdiFa4qDxJAFUq3LTN4YxvnXS6HCdmBP4veQPtsX2Lw3XQpwMHezvtHrl4DdPSzt7F9eTpjKY2wo=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by MN2PR21MB1167.namprd21.prod.outlook.com (2603:10b6:208:fe::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.1; Tue, 14 Sep
 2021 15:49:29 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::d804:7493:8e3d:68d3]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::d804:7493:8e3d:68d3%9]) with mapi id 15.20.4478.015; Tue, 14 Sep 2021
 15:49:29 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
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
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for
 netvsc driver
Thread-Index: AQHXqW4FQ8MnKzPhAECYP0JKGb2C7qujrPRw
Date:   Tue, 14 Sep 2021 15:49:29 +0000
Message-ID: <MN2PR21MB12953A434D67350B4C80C2D8CADA9@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-13-ltykernel@gmail.com>
In-Reply-To: <20210914133916.1440931-13-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ec0b8299-6ace-4e10-940d-c2bfa0583e06;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-14T15:48:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31614527-6ad5-46a5-dfcc-08d977973cd4
x-ms-traffictypediagnostic: MN2PR21MB1167:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB116751FFC2720429D6E376A9CADA9@MN2PR21MB1167.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wSJCRkd0cIPW5RiB6Hy8Wq6KnUDIjL3h8musDztMljzwi3S4UOrYjSbWAX1KY4xrj8RHG4RxTY9fuzE/Pn0/tt7Zuk39d+9t6tz2kfSF6Tt84Apizls2wXUQvRp0omWDuMtTV1LMJK2+kxreafrZIamRjHliYh57I140ZXj6DtxN/Q7RPb61rYuD59qKHoFk+uDzp77AvLT8ZcVjFXDhUiuaWWedtSpssDBtov0rRSUHLnW06zLUa116qRCfC8isF5ztHIN7ROy7tvEa0U02TvsDDZH8vrZIDrOA51i1BrYZOus8V2jdsZm2EbArOtc1bcO3aUOS1Vx/e2ICU99J3T+cE8SQE63Tzfy5quZXIiTm/J8oPleuCGuma6+wG2VShOVcBz35pw3cCdTRzF2CmGW76u/a9ZthScCx3Q2r/ZZ218fmTkCP13HexIQitwKJT7mL0XeWSrqj6hM5t2sYh53PmmwzXiDY3SmBYYjke2WPXXqlLrg+U4yZDjwQyrevRUiGTvYudcBi2fRMPFHwe8KfKNBdyo5QbNba/f34OwvhaSZMrqiyXXI3hA2iAENZH/8iWi3a4OREPoN9RhL4VQQS6bzt40PaKfQDTLhdVP2Pt+y4+WMv5QcnREqFMTc7G08EJOf3SU8D1y804oE06ZGwVZYl4a3cJZ2osm6V+ICb+JnDchMSr9kfqD0l5BfMXkJwy1eDd+h0byEyqt4i4c84qqRyNGE7n7tMqKHxyr8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(55016002)(9686003)(6506007)(508600001)(53546011)(26005)(921005)(54906003)(38100700002)(76116006)(122000001)(71200400001)(5660300002)(4326008)(186003)(82950400001)(66476007)(86362001)(110136005)(82960400001)(52536014)(8936002)(38070700005)(2906002)(8990500004)(316002)(83380400001)(7406005)(7416002)(64756008)(66556008)(66446008)(10290500003)(66946007)(7696005)(6636002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VbT88gCNa2ZyW6pwzrLrtQuTO6cYgL+U6HzYbJCr1dL0GDoiBcGMdjEUJ2Vy?=
 =?us-ascii?Q?agTdnqM44iiB49YKumLaafY7Na7ZqkUYBBog+poLzvFVKmHGELz0ThYDVxUA?=
 =?us-ascii?Q?1OLzRK1z84a369F0ynOtDUsXFixwMKvIQAlPLCqvcfR29ElpahU0ZzAEkArD?=
 =?us-ascii?Q?z6nYGmqR3AED/WU/eS2ITwXIbUI76iS0bVWk0j0wv0chfiof3s+w1YRu4oai?=
 =?us-ascii?Q?UTaWt/MKmPBsYQS9pS+kShafgw9N1HUOU0cvHZOceelBOV+naLz8TmRE3EjP?=
 =?us-ascii?Q?YFW21N/d1ECqhu0jCzr50Aec0sdl0DLmsDqDHt6UukRSramMmR0zYiKLW11X?=
 =?us-ascii?Q?DAaF2oZyb4Q1sFIR8TW/fd66c7XAwgejZiSU9bEPIho1n7eN7BkcDrx2pZy7?=
 =?us-ascii?Q?NUwvIhzVYnYMn0mYH/HfUCMZ8PBtRZnO6fFEoTJ3SKeYPY3ySbKYhY0qW2XC?=
 =?us-ascii?Q?QmV/K7+3eBf5JAZY6T4FvplEzu3RlOL0MO0bbwLifI+wsBpTxnI+JDm5lae/?=
 =?us-ascii?Q?dy/LA54thkcXlnQcZwd/woHuhjXcyCKoaMDk5oxKba3E579urw1bVTBFDteN?=
 =?us-ascii?Q?Elc0EAGxtIUT/5M17mlVQo8DXc8kPToL3ShQuw/oXi1mWsPVUw4MRgIQtth7?=
 =?us-ascii?Q?eGTAhP4R+xLDAIb0GPbyK6S4fI/4k4Vg0rxpsnEDjhQnoBp9OcKMFWM1e0md?=
 =?us-ascii?Q?5fN2aEIbTv9oTRm3Wcnxdsn4rXJRZsukGJiK1yIuubdLREIF1WfQ2oPgj7D3?=
 =?us-ascii?Q?7oGWz/lsw2/pcKKQja3ZdNVoYm3DEwl3razbo+1IO0u7lPys6A9EMIoTd7L2?=
 =?us-ascii?Q?qZOmMFCu69PAmRuBtONteSDKCzJFcnGb+2DEseIukuSCKb3egenv5T4cVYz1?=
 =?us-ascii?Q?MQ5ULFcnLRaS1lKI+8qqL3j5e5vSY3VFKRVbtPoph5OfihjsS5QsiIx1pCN7?=
 =?us-ascii?Q?c+g36cdxL/wEv4PYNe9SM37lV5ufw7iUTaDL9C5CvNRRAvMp+JzxkCillp3Z?=
 =?us-ascii?Q?FGoo7m9dZ3ysfxtl27vazGUUl8HkadesHKQYdb6iCR31WTqPbthp7kgRkeZY?=
 =?us-ascii?Q?BwWeNCswSLWfJ66vAIDGmc3WR3gm23tmFQcnX7pWbY+inINiOnYISzC4DYja?=
 =?us-ascii?Q?m2n1OCrnDtp+NJBlj6B8qBpF/yeJqMWngWZiWU9WupLX/kHPeGsL3oX9e1kn?=
 =?us-ascii?Q?x3lnupCzCVLG0jkuuDVKqwb1zm24UMg8ubTgpdNjkBLskqEb4/CpJTJpNnpj?=
 =?us-ascii?Q?9kKrEpO/WfJ8eqaJo4J6GVPbrh+saoO1pZr/P/AfzxHaruq6Ww1OJBdK+4UU?=
 =?us-ascii?Q?k4x/jMEmn2EKUOgrHt4g7hxR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31614527-6ad5-46a5-dfcc-08d977973cd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 15:49:29.1987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7/zdvCskn8y0eguwZA7zusKyl7sZe+BazC1uD+5HblPJjRGcyQGn6dxnrXQ9O2+us+43B83NY99FRAlb///ZXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1167
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Tianyu Lan <ltykernel@gmail.com>
> Sent: Tuesday, September 14, 2021 9:39 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>; tglx@linutronix.de;
> mingo@redhat.com; bp@alien8.de; x86@kernel.org; hpa@zytor.com;
> dave.hansen@linux.intel.com; luto@kernel.org; peterz@infradead.org;
> konrad.wilk@oracle.com; boris.ostrovsky@oracle.com; jgross@suse.com;
> sstabellini@kernel.org; joro@8bytes.org; will@kernel.org;
> davem@davemloft.net; kuba@kernel.org; jejb@linux.ibm.com;
> martin.petersen@oracle.com; gregkh@linuxfoundation.org; arnd@arndb.de;
> hch@lst.de; m.szyprowski@samsung.com; robin.murphy@arm.com;
> brijesh.singh@amd.com; Tianyu Lan <Tianyu.Lan@microsoft.com>;
> thomas.lendacky@amd.com; pgonda@google.com; akpm@linux-foundation.org;
> kirill.shutemov@linux.intel.com; rppt@kernel.org; sfr@canb.auug.org.au;
> aneesh.kumar@linux.ibm.com; saravanand@fb.com;
> krish.sadhukhan@oracle.com; xen-devel@lists.xenproject.org;
> tj@kernel.org; rientjes@google.com; Michael Kelley
> <mikelley@microsoft.com>
> Cc: iommu@lists.linux-foundation.org; linux-arch@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org; netdev@vger.kernel.org; vkuznets
> <vkuznets@redhat.com>; parri.andrea@gmail.com; dave.hansen@intel.com
> Subject: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for
> netvsc driver
>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>=20
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() stills need to be handled. Use DMA API to map/umap
> these memory during sending/receiving packet and Hyper-V swiotlb
> bounce buffer dma address will be returned. The swiotlb bounce buffer
> has been masked to be visible to host during boot up.
>=20
> Allocate rx/tx ring buffer via alloc_pages() in Isolation VM and map
> these pages via vmap(). After calling vmbus_establish_gpadl() which
> marks these pages visible to host, unmap these pages to release the
> virtual address mapped with physical address below shared_gpa_boundary
> and map them in the extra address space via vmap_pfn().
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v4:
> 	* Allocate rx/tx ring buffer via alloc_pages() in Isolation VM
> 	* Map pages after calling vmbus_establish_gpadl().
> 	* set dma_set_min_align_mask for netvsc driver.
>=20
> Change since v3:
> 	* Add comment to explain why not to use dma_map_sg()
> 	* Fix some error handle.
> ---

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Thank you!
