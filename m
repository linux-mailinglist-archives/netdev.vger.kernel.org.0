Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8487C474B00
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbhLNSfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:35:43 -0500
Received: from mail-eus2azlp17010006.outbound.protection.outlook.com ([40.93.12.6]:40655
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229517AbhLNSfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 13:35:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTzroPUAWlig2Mq1z64KHZky12s6Sp/jmDdgsCZegk5jfg3Qqcs2yCcmpkkMXl2lUuQPvbIwbGxDicLWCsFxJYyvpQeuyHrbMqzD4SxVneFALJtXNq4+GSCb6UY0mmburqc47er4dTtwNVE3ADukKh7X/nmG8ze0DQnzVGTMd3uuKrBfRu+zMBLtYKm3E6VYzQp/mBTYNZT2KEszPfo06wUXEAX9R+ZBuO3qBK5W2aiQzy4G0dcC+ZPZeWMCHhl2yrgc/L+K5UXqNG7F+vUrecehe+RAnkwu3EqFgjl6vluV3iGZKBv110uLXftn5PlnUPIBbeqCiDqlUAUomHzTag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCqJ65rAGJ8t36bAwkGlABLkhqtrZ/HHn/H1zS9yd0Q=;
 b=nF+x9x2xhtFpfSGBp2iTxOCeXjsNQm3Ov/otu4ozwR3abj8NchCiMawUMLCTmHoDxuMCCItWKRK1dOR/BV1a2P2ZnRIrA6QKP1ui0oFHWcVfHNgVDaCPokeUGI2808c1AXz9Yp6hP+dHTfOITlLt6/kf/eRIAB7j9FBtakpElb1FvU3YOCXBZiR6r2mj230/K/xlqVUWhCWC6BBpYjFpmqbbi6IU4e69bJ61HD2uhc/9sofNGYNmPl71y/P8/TpreuJTQO8qW3LfRXakrJBT5UBnLTZ62V3vZs7YiUmyoG6SdiQ3Sh2/0+Vd0yJG/oKLG3N5TKQmIhUO6sVCGZZJzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCqJ65rAGJ8t36bAwkGlABLkhqtrZ/HHn/H1zS9yd0Q=;
 b=BDLsbWM4B4/EBdThn7H+it35hu2cIuR7ze+qNV2874Gk+VmJroDEuJ52OO510UbloWM4ycTPsdNwOcdO1SjuKi5HBqFsa1tDBRR183Yz1m6zlSBZj3eQevSDuZFh7NUqmMDIVITg2TGSO4mvo8IziegSxX8motV8rLCG0CEmAMU=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by BN6PR21MB0276.namprd21.prod.outlook.com (2603:10b6:404:9b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.6; Tue, 14 Dec
 2021 18:35:35 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e%6]) with mapi id 15.20.4823.005; Tue, 14 Dec 2021
 18:35:34 +0000
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
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
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
Subject: RE: [PATCH V7 0/5] x86/Hyper-V: Add Hyper-V Isolation VM
 support(Second part)
Thread-Topic: [PATCH V7 0/5] x86/Hyper-V: Add Hyper-V Isolation VM
 support(Second part)
Thread-Index: AQHX7/EPrVKNVndzlEOmds811YMwUawyUrQg
Date:   Tue, 14 Dec 2021 18:35:34 +0000
Message-ID: <MWHPR21MB159370A7BC145DA18D0CA938D7759@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211213071407.314309-1-ltykernel@gmail.com>
In-Reply-To: <20211213071407.314309-1-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bf8d5b8d-2191-425c-955b-76a1ecaafd20;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-14T18:34:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f52d8092-05a0-4e0b-031f-08d9bf30845f
x-ms-traffictypediagnostic: BN6PR21MB0276:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN6PR21MB0276E21F560411CE14ECE28FD7759@BN6PR21MB0276.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V51gMJtHBb94j6r3ENHQ0cnmlcr8O+CE+qZzFCeyLMt42uLIORt8ZdebQv+dveY8uA4EA2RAJg1tFlh6ke3Z59typE/PT0Q6/MKqfHb8HD93SDBQDGovMZd8SRuIBcGeBeVwggJ++4Xti2HnxvOIncDvKwg1Sn1CY1j6bnbwS7l+q3f8dKIVWn12Tz11BeiDr1gR7Q3hYm5GVP9WWC4oMC9KhLqP7oOmwV5bbWZUtaDptoY52u3gW21JsFlcuzCGdOEM7BcaU3WP3vrNbcvIs/Y9Oc6RDIxWkLeiQydUNOcyf2TEeVGVuhnrZny8sxIDGHlnQJSAE6oySxhY5xLGSJpAyYBh+/gauruE/V9GVRTgBe+mrLB7pYpuENBj8pd1NdMLMMi+NhMbe8esX/at5//z07rNg5hrVywourt/VI8+iWIBG7bxf30vG7NMNsTx/1ATklC+MTf33Uk5w9rKIQE8e0FmP7FMH2345HgRYqNImeGcN8S4s7MTyXslLiDZ6qycbPjdS+YJsX2jmccwRLGXpsfXNeX0H4jvNByG6HgZphaWb1ox0LPMILQmWHnh9kIzsRvuq8VIZXu3vubG+Nb5O9oiX0w4kGNYbV22XuF26VYWfY3NZCGI8Nx7wdYmnMv+c0bjmNFKBRZO1bD6Ry2hio6CivrsBn4bDXzLHuCHnXsr1eTCY3/DS2hOvIbYOSZRSLkyy/7cPRpXEzlKbPifLGtx5WdJSrmidu0i4u2j7IK6lovNmQL9CxI/k2iL8f7Qp91XYsmVCM7Y3AapPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(54906003)(9686003)(76116006)(6636002)(38100700002)(71200400001)(122000001)(66946007)(508600001)(8990500004)(10290500003)(86362001)(316002)(186003)(7696005)(6506007)(110136005)(8936002)(8676002)(2906002)(5660300002)(7416002)(38070700005)(921005)(83380400001)(7406005)(55016003)(33656002)(82960400001)(82950400001)(52536014)(66446008)(64756008)(66556008)(66476007)(4326008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fJ3k3OiLzR0X/HgMljlbzJ1mmnNBNEJcQ18jf5ANKSbEfIbojAFk2kXQGmP1?=
 =?us-ascii?Q?Fq+7/NVWMq6BRAqyce7idQ0Ffm98vtYZZasgxIygFsQipEFQtuy3yNCsJZ2C?=
 =?us-ascii?Q?Sv/6rmZVy6NbPBfThPlmO/rFkwItHjHe3DZquQf59TQZPehhr0x0xIjxCb3V?=
 =?us-ascii?Q?4SVN5u4EL0w8/O1bKZ3aDtYlAYlFy66vXPEfO0cam9yeOFx7xaRoXO7uUjMC?=
 =?us-ascii?Q?xw7dHCjH/P09FMbuHXwiXdgPTWOjMSGiDh9hqrhfowBgc7JG+u0O87Xv4Ivh?=
 =?us-ascii?Q?GqO8w9Gy1XTZhZzh3DgPGaQ5HPNsGymwDMdIUqZsSfaiMrhPLE88U45xAzvq?=
 =?us-ascii?Q?LjdFX5+lWfQmHX8WoCYZpy+dPFydwbMN0NIY3R2KtbuogiWXFaOyB5/gErcy?=
 =?us-ascii?Q?ce1QHNdUGtY2Jsy9e+S3FMiO8y5iKYP3Hk3EbKkPhsHqM+HZUdGuKWOqXOgs?=
 =?us-ascii?Q?ux4OXDQ/kOKdf+Y6BiNqCO3A5nrjV+vnkbmq5pjxOWdxh6SZhlPxx2577xLW?=
 =?us-ascii?Q?K0T4eKIlaKQJPvi0Bti55rgg8PqpxIQO5qv83yGgkcEDhDHE9YtHJn/WeRan?=
 =?us-ascii?Q?lE7e3XgSwGpuywjwWqUWIeogb0OU8MZ3ADE9cw2bBQ1OanfIC+8AUtlTwS0y?=
 =?us-ascii?Q?VvIBTbvlEp8fsxJUNgYVC4MOTM7u7NZsOSm6ZFZnOPyNfPl7YUe6wogIyc1T?=
 =?us-ascii?Q?n/37Fij7eFV4yLCszzu8ciNoAoGInyF2Yv68eTlmvFs9oLVyoygT61ANjOe/?=
 =?us-ascii?Q?U+FAJGZZhy0Hj2x0rkHfKk+z8mrjYw21Rip03LF+C2ykvXNLGKzPImPTtoKu?=
 =?us-ascii?Q?70yjUJYrINsITGKHbn2tVsiaYD0AL42bRTXf3e7yVSSlOEiTyEbA8vRDFtm2?=
 =?us-ascii?Q?95VMWlGgrnOrGNT31JuOVjdnlGzu2lzQA0qJSAk9BwzPMfkx/+MsQrwOHrQh?=
 =?us-ascii?Q?WPLVfUFXbPnPUll8yY18a1IDsGeC/h8GSioWrMxCFXcfeFYsI2SlDAZFO1HE?=
 =?us-ascii?Q?CxQY7AErSCmh1StGFPC2RfIvPo/FBGGPccEO2c5SBlTbXLA3241nJq0WpQXa?=
 =?us-ascii?Q?3nF2e3c/6sArtUCMFQFs3P5Dvb+v6AxDMF+Loi4hkwC3LPwDO7lJQ8IpmKrB?=
 =?us-ascii?Q?s6DDFVjnGzZRAyKmzP9FK77IzUw+niArOOJvdUErdPJ+e3Wge9FzzY9oUtRJ?=
 =?us-ascii?Q?9S51S3zsF/c/3jJhqAMRYeUGO0EZuP7OEEe5P3bdtRnTyjnsbFnt5dtRLC86?=
 =?us-ascii?Q?v1oj3Hqxwi8MByamaXuLArVJoAcDQLEc9Gsw6MQrE0BazaZLTBb5hAbfjjGg?=
 =?us-ascii?Q?aUm4x6AZYiJvuWiqt6H+6Y4kef/Qfp4Cja5q94XjUqc38grSC9xnfv1ila2D?=
 =?us-ascii?Q?4WfFCd4xZm1+/WqIQUL5OvjEM7lt1Lpa94h/sbtHRoizqyWUHU2pmIJFfT/a?=
 =?us-ascii?Q?5LEj9vhlcMFaeIAPn6uJgW41D0HgsfFzAhPLhqeG0Fbi0onbm7ekgMN/dQtK?=
 =?us-ascii?Q?2OUeYFcLK5lDFOVWYDoUBKEWwBSEO4YEySI00dVkkDE0ybiCo1YxAK6A0z2W?=
 =?us-ascii?Q?OuZssNKcfuoETvv7IgTfzc+B6fT/E71RNaGp4/uypcqiEVT9VTKldrvMNcMa?=
 =?us-ascii?Q?s08vhdVANBn/4HIGDQBeognN2FAjss98Dd/HSwxgiCqFODoy82gHovwwQmqk?=
 =?us-ascii?Q?BCRNXw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52d8092-05a0-4e0b-031f-08d9bf30845f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 18:35:34.7390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1liVnPOvSufH3aLWzkbjCKqmM209WOYN+gNvxg0vRrMYhm5c2jbCQzZn/gSn3Cw++y6ihrMwZ2bZTKIqV8jxgqYdb/BZrw7Cd9CzRBqLFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0276
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Sunday, December 12, 2021 11:1=
4 PM
>=20
> Hyper-V provides two kinds of Isolation VMs. VBS(Virtualization-based
> security) and AMD SEV-SNP unenlightened Isolation VMs. This patchset
> is to add support for these Isolation VM support in Linux.
>=20
> The memory of these vms are encrypted and host can't access guest
> memory directly. Hyper-V provides new host visibility hvcall and
> the guest needs to call new hvcall to mark memory visible to host
> before sharing memory with host. For security, all network/storage
> stack memory should not be shared with host and so there is bounce
> buffer requests.
>=20
> Vmbus channel ring buffer already plays bounce buffer role because
> all data from/to host needs to copy from/to between the ring buffer
> and IO stack memory. So mark vmbus channel ring buffer visible.
>=20
> For SNP isolation VM, guest needs to access the shared memory via
> extra address space which is specified by Hyper-V CPUID HYPERV_CPUID_
> ISOLATION_CONFIG. The access physical address of the shared memory
> should be bounce buffer memory GPA plus with shared_gpa_boundary
> reported by CPUID.
>=20
> This patchset is to enable swiotlb bounce buffer for netvsc/storvsc
> drivers in Isolation VM.
>=20
> Change since v6:
>         * Fix compile error in hv_init.c and mshyperv.c when swiotlb
> 	  is not enabled.
> 	* Change the order in the cc_platform_has() and check sev first.
>=20
> Change sicne v5:
>         * Modify "Swiotlb" to "swiotlb" in commit log.
> 	* Remove CONFIG_HYPERV check in the hyperv_cc_platform_has()
>=20
> Change since v4:
> 	* Remove Hyper-V IOMMU IOMMU_INIT_FINISH related functions
> 	  and set SWIOTLB_FORCE and swiotlb_unencrypted_base in the
> 	  ms_hyperv_init_platform(). Call swiotlb_update_mem_attributes()
> 	  in the hyperv_init().
>=20
> Change since v3:
> 	* Fix boot up failure on the host with mem_encrypt=3Don.
> 	  Move calloing of set_memory_decrypted() back from
> 	  swiotlb_init_io_tlb_mem to swiotlb_late_init_with_tbl()
> 	  and rmem_swiotlb_device_init().
> 	* Change code style of checking GUEST_MEM attribute in the
> 	  hyperv_cc_platform_has().
> 	* Add comment in pci-swiotlb-xen.c to explain why add
> 	  dependency between hyperv_swiotlb_detect() and pci_
> 	  xen_swiotlb_detect().
> 	* Return directly when fails to allocate Hyper-V swiotlb
> 	  buffer in the hyperv_iommu_swiotlb_init().
>=20
> Change since v2:
> 	* Remove Hyper-V dma ops and dma_alloc/free_noncontiguous. Add
> 	  hv_map/unmap_memory() to map/umap netvsc rx/tx ring into extra
> 	  address space.
> 	* Leave mem->vaddr in swiotlb code with phys_to_virt(mem->start)
> 	  when fail to remap swiotlb memory.
>=20
> Change since v1:
> 	* Add Hyper-V Isolation support check in the cc_platform_has()
> 	  and return true for guest memory encrypt attr.
> 	* Remove hv isolation check in the sev_setup_arch()
>=20
> Tianyu Lan (5):
>   swiotlb: Add swiotlb bounce buffer remap function for HV IVM
>   x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
>   hyper-v: Enable swiotlb bounce buffer for Isolation VM
>   scsi: storvsc: Add Isolation VM support for storvsc driver
>   net: netvsc: Add Isolation VM support for netvsc driver
>=20
>  arch/x86/hyperv/hv_init.c         |  12 +++
>  arch/x86/hyperv/ivm.c             |  28 ++++++
>  arch/x86/kernel/cc_platform.c     |   8 ++
>  arch/x86/kernel/cpu/mshyperv.c    |  15 +++-
>  drivers/hv/hv_common.c            |  11 +++
>  drivers/hv/vmbus_drv.c            |   4 +
>  drivers/net/hyperv/hyperv_net.h   |   5 ++
>  drivers/net/hyperv/netvsc.c       | 136 +++++++++++++++++++++++++++++-
>  drivers/net/hyperv/netvsc_drv.c   |   1 +
>  drivers/net/hyperv/rndis_filter.c |   2 +
>  drivers/scsi/storvsc_drv.c        |  37 ++++----
>  include/asm-generic/mshyperv.h    |   2 +
>  include/linux/hyperv.h            |   6 ++
>  include/linux/swiotlb.h           |   6 ++
>  kernel/dma/swiotlb.c              |  43 +++++++++-
>  15 files changed, 294 insertions(+), 22 deletions(-)
>=20
> --
> 2.25.1

For the entire series,

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

