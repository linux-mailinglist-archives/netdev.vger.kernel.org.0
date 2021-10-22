Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92453437FED
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhJVV1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:27:37 -0400
Received: from [52.101.62.20] ([52.101.62.20]:48602 "EHLO
        na01-obe.outbound.protection.outlook.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S231997AbhJVV1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 17:27:36 -0400
X-Greylist: delayed 1630 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2021 17:27:35 EDT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpqTqc+zLzim6icfMSypetRliukrmRUq88oszqr9RhNLjdzKYsygFeBRKMjzu9Y52kqO94hIITdUVLWj0Wd/4t22jrK53AT/cEfAZoolwvTAq/YL02KnKbjHKqdm6bGFYGCTuB57yNdA4cFrAKm1NC1sAwfyG4fwZc1lSVj5wJPzjP22JHRGvI9WN0qA93o9xq8/OJr7ycd0qTycZw56cRCJ3LHi0nw3o3txky3vUHTn5joV1/xvHMOPBKNNg2k4fziB9Du5paGPFAzDS5p0FYJHQ2IOcWoNrMRi3RLClO+m/xrwmVN5bSgct7EpiMhkDk/XvCl+mDNGchqo8Gmgbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1X2bRIwL2ArIcgvlyxRsepXU7oHXLcWCl6zFJfqFlT0=;
 b=I4FGM/PkFpxpTcLBDjn+l6Y3l1oq5ujDlvdFs1HTTUGXbGKsdj8OlA5Wg0nsYaqkXnU+bo16H0EMJ4DQSmHIfsFI/1rGJl/SknN8fvitlNJMtWnJ91ImhyoSk4fXWXDbr0t50wnDCf8VfFXv7aUs3HVyoShvCa/pF6rK6GjlBaxthPEyhQqtV/uHKurKeFMMFbBhYL7hZOeTvuQ1dr/WabKaFJ1vR7NgHm1l4xzi3/zeDrvZ3swnetvGAfU+wjRHiKFIfPRAHbmYSHLZuQ5odrFUtQy++dhuVftVSGiWciS7WdCDJt9AEDdwJyNWqrH45UdrQX3ftc9V0ZNcnrWbsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1X2bRIwL2ArIcgvlyxRsepXU7oHXLcWCl6zFJfqFlT0=;
 b=DheOTKxJgVwo7mAM+G/dKUnLXStVYJ/aFtywNBktAQyRRwFYuGhAiM0eW+zXcNkQjtMphXssf4CLuPG3iuLjMl7iMVSrwPxBGMHPs2HSDr3SN1X7d9IIkW1zYFXJugTt0J/vLXJfg98dbBExYIRI9zUZfuUZgmD4xQSplgz0AHw=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0704.namprd21.prod.outlook.com (2603:10b6:300:128::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.4; Fri, 22 Oct
 2021 21:25:12 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::240b:d555:8c74:205c]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::240b:d555:8c74:205c%4]) with mapi id 15.20.4649.011; Fri, 22 Oct 2021
 21:25:12 +0000
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
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>
CC:     "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V8 0/9] x86/Hyper-V: Add Hyper-V Isolation VM
 support(First part)
Thread-Topic: [PATCH V8 0/9] x86/Hyper-V: Add Hyper-V Isolation VM
 support(First part)
Thread-Index: AQHXxpIXIAA33+AVmk2SU9gTnEeBkqvfiKBg
Date:   Fri, 22 Oct 2021 21:25:12 +0000
Message-ID: <MWHPR21MB15931B80A8431CF46B6CE11FD7809@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
In-Reply-To: <20211021154110.3734294-1-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=086ca026-d4ec-434b-afca-8029c2bdd4ce;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-22T21:22:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7376211c-6d15-400b-1158-08d995a26ee3
x-ms-traffictypediagnostic: MWHPR21MB0704:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB070424E88A7A0FF6AF0B0C9ED7809@MWHPR21MB0704.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:404;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2OF/JB8YIYVTZOrEynm+10I0AGf0zyP9j9OaK8CmujAla5yZ1+2SYPZ/WKJrXyas+eOpGnGuhR7E0VwhrbvSJ9rKVNC9fvWupurdbv+hkzbT6BQwJo9yuxrEfZHRW6HLKUGJGjo3ux7DBeuaDTG5NaN+MvRranGWK+lb3w3IEAtR9HncEjSXLZPaVynDFjFRyEEv1QPkuBfZCxeBo3Oto7nLRFCIQpne6jzAO2UjMt78gBFik/9nYxJeoPpByYYM3UJXGWNoBLDraQcC842imLMUk3v1oemt5FBw5YyXH4yyEtwiPuXAYqnBuxhfgFShh7pcHCDtWV5BuOKrfypC1edvBbh4DbHvTB8f+Qr+2xZK0keY2so8eslIe6QilXxmRORrJxFU8RSVOzFBuG/5JF5a3c8No9Jw6ejFVrwNtsfq8I2YENROe3euLiLAppmdutsWcpzqjWUV6FraAthWcx88wVgCCLBU/a4QKpRs9oku/J4onQ6vwH8sCkuENx3bJO3oM4Ofj9zym1nAQKC9z5Jt3qQYZaO/Ed10uvA6pHtf4ue6b1Fpf8aKNYGCMYrGTgowsqNIlBjnDNfHfs2hldRI+G4YGhfyU+eGeGYgz+LMLca/Qsunj3zzXPNACyVieYHR0RFfMRT4zwVzrhi8+gUiUDd4CfzFs41h4zPlPI09XTqjja9rQSrN88bSKgJ9Ti99TeB6+wKB5N90sRaQrWdj+mBLta9hml1cJ0sCPjQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(4326008)(10290500003)(7406005)(5660300002)(54906003)(6506007)(66446008)(33656002)(316002)(66556008)(7416002)(26005)(2906002)(8936002)(66476007)(38070700005)(921005)(9686003)(508600001)(110136005)(186003)(8990500004)(82950400001)(76116006)(38100700002)(82960400001)(86362001)(8676002)(7696005)(71200400001)(52536014)(83380400001)(55016002)(66946007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IQ1Mg+xF6sMSDXD7Yv5bhe4YOY1rMEEv/R8O35I7W/PZboY1OqS5/b33h1h5?=
 =?us-ascii?Q?ekks1mLJCY7ol+J6nb6+0+KHm1+iegE4AvWthCg/UDd4J2E2icXZliTALgqK?=
 =?us-ascii?Q?QvemFHnpIlYH/iOErAzIm3r8IO86H93h5oUW/iWZHhZAJa3eecQTnYtnfjxH?=
 =?us-ascii?Q?DLXmZAT8NhO4B6brEHff7kFJmxXQdnXsVWnfUa3toYjGXsQl9/5uhn2eAX8B?=
 =?us-ascii?Q?CSo/1TREMkSzKKgyvZCmWv0L+tSNxmEm89hcuvml/FpAb5E4UXsSI/hzpAZQ?=
 =?us-ascii?Q?SZnbjU7D5S7kibBGE9oQd1pjAfxrcvWxCS98gzKUVswVifew3wsEy0JsN/oz?=
 =?us-ascii?Q?u9sAAGgsMY5c7d2QDZ3bul1gM6+8ARq7KoGtYha1FjekBJHLd6Y7i0s1c6Jd?=
 =?us-ascii?Q?E6RYSfd5Mgucuc1CeoV5CtCYMEAh29Fiu1p4rYwq8IkzJF3yvtMDE/bpQa1+?=
 =?us-ascii?Q?QmZwtfFOwAgStdF27TubCINs7vCctLxpWwAvthbTCIxS89VK+DoFT6RN1Fs7?=
 =?us-ascii?Q?JGRZX1Vz9Zp/eyXwL+vZNbtHsqkzap8bGSkXy5jBSL3c3pdbaYMAKCFGF7gO?=
 =?us-ascii?Q?LD4E6rA9KU4CTB3AaJAdvEzpXnfMrEAQddJmPnWlalMgEf76CHKOmWymtSLQ?=
 =?us-ascii?Q?CLnrIvT5fAxxY+w4M/JL39ViWOzys0sDGfx9S0IFk8c3KW8+p+fHY+1FksmS?=
 =?us-ascii?Q?hpPLThsH1ambsFk86/hSG6Iu0kEU5Ja2Fn+Ahz/WRVgmgfmCrKAs4PBOBC0M?=
 =?us-ascii?Q?9ZTBYL5gTyTMV09sK2KGNFV7Byybk9oNg0iIQQwxEdv7X3XfuGkOaWtnecsv?=
 =?us-ascii?Q?ltxp1bZsp1eRHwgzHbFbcWVgAZNQSGaO8TUY4fYok8BdpheZQbsFIXIuYGE/?=
 =?us-ascii?Q?bMXwS6Oyaoe7g4xEL3FOxMzRI4QlrUJ7W8/mkUoT21xORycnFBSXNe5cP2lA?=
 =?us-ascii?Q?PC4tJmEPK4m93Oy6iWT9Ptm9knCtjq1eyr/C9RcK/QliROpc+T3Dq+8OShlU?=
 =?us-ascii?Q?mIw/UnAkdb6xV9GzEKhUnEjafaUsdHWBKT6GzfDB+i/0+UUqzNVBxm6YKLyj?=
 =?us-ascii?Q?vpdjW976+plosnRTFb/noB8TzrBXk+g72+IBGRqHwibz6e32DktTK8yj3Eg1?=
 =?us-ascii?Q?RtR5D8u2yYWliWuXZ30ZRa09KeD3CCVCDg2XkaWHiILOfmFCZO2QrG31sH0h?=
 =?us-ascii?Q?kq3bxLJbBCKSFq1p3knecRcJJ6WXrUGt1bk8RxmaoRlWVQRhljDIhrE9kxw/?=
 =?us-ascii?Q?68lfI9pw0fUS5PH7Q6ZT8K6BV0HWYXi3YZjqd7qB2pOJ9B6Q7PilUeHqxEyc?=
 =?us-ascii?Q?eUieNUm9tybQKm4lb5k76eOo2DhV9N9Ovx24jPGCjMtbqv30Uu0BOZar5f+H?=
 =?us-ascii?Q?epv8/xUZxLTktxHCuwED/UHS1Cwklj5LwknX75h+C1yz8saQoF7DICdvqMdU?=
 =?us-ascii?Q?kC9CheuNR6kfKMkKkdbAdnlbWzcIEBiR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7376211c-6d15-400b-1158-08d995a26ee3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 21:25:12.4932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mikelley@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0704
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Thursday, October 21, 2021 8:4=
1 AM
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
> This patchset is rebased on the commit d9abdee of Linux mainline tree
> and plus clean up patch from Borislav
> Petkov
>=20
> Change since v7
> 	- Rework sev_es_ghcb_hv_call() and export it for Hyper-V
> 	  according to suggestion from Borislav Petkov.
>=20
> Change since v6
> 	- Add hv_set_mem_host_visibility() when CONFIG_HYPERV is no.
> 	  Fix compile error.
> 	- Add comment to describe __set_memory_enc_pgtable().
> 	- Split SEV change into patch "Expose __sev_es_ghcb_hv_call()
> 	  to call ghcb hv call out of sev code"
>  	- Add comment about calling memunmap() in the non-snp IVM.
>=20
> Change since v5
> 	- Replace HVPFN_UP() with PFN_UP() in the __vmbus_establish_gpadl()
> 	- Remove unused variable gpadl in the __vmbus_open() and vmbus_close_
> 	  internal()
> 	- Clean gpadl_handle in the vmbus_teardown_gpadl().
> 	- Adjust change layout in the asm/mshyperv.h to make
> 	  hv_is_synic_reg(), hv_get_register() and hv_set_register()
> 	  ahead of the #include of asm-generic/mshyperv.h
> 	- Change vmbus_connection.monitor_pages_pa type from unsigned
> 	  long to phys_addr_t
>=20
> Change since v4:
> 	- Hide hv_mark_gpa_visibility() and set memory visibility via
> 	  set_memory_encrypted/decrypted()
> 	- Change gpadl handle in netvsc and uio driver from u32 to
> 	  struct vmbus_gpadl.
> 	- Change vmbus_establish_gpadl()'s gpadl_handle parameter
> 	  to vmbus_gpadl data structure.
> 	- Remove hv_get_simp(), hv_get_siefp()  hv_get_synint_*()
> 	  helper function. Move the logic into hv_get/set_register().
> 	- Use scsi_dma_map/unmap() instead of dma_map/unmap_sg() in storvsc driv=
er.
> 	- Allocate rx/tx ring buffer via alloc_pages() in Isolation VM
>=20
> Change since V3:
> 	- Initalize GHCB page in the cpu init callbac.
> 	- Change vmbus_teardown_gpadl() parameter in order to
> 	  mask the memory back to non-visible to host.
> 	- Merge hv_ringbuffer_post_init() into hv_ringbuffer_init().
> 	- Keep Hyper-V bounce buffer size as same as AMD SEV VM
> 	- Use dma_map_sg() instead of dm_map_page() in the storvsc driver.
>=20
> Change since V2:
>        - Drop x86_set_memory_enc static call and use platform check
>          in the __set_memory_enc_dec() to run platform callback of
> 	 set memory encrypted or decrypted.
>=20
> Change since V1:
>        - Introduce x86_set_memory_enc static call and so platforms can
>          override __set_memory_enc_dec() with their implementation
>        - Introduce sev_es_ghcb_hv_call_simple() and share code
>          between SEV and Hyper-V code.
>        - Not remap monitor pages in the non-SNP isolation VM
>        - Make swiotlb_init_io_tlb_mem() return error code and return
>          error when dma_map_decrypted() fails.
>=20
> Change since RFC V4:
>        - Introduce dma map decrypted function to remap bounce buffer
>           and provide dma map decrypted ops for platform to hook callback=
.
>        - Split swiotlb and dma map decrypted change into two patches
>        - Replace vstart with vaddr in swiotlb changes.
>=20
> Change since RFC v3:
>        - Add interface set_memory_decrypted_map() to decrypt memory and
>          map bounce buffer in extra address space
>        - Remove swiotlb remap function and store the remap address
>          returned by set_memory_decrypted_map() in swiotlb mem data struc=
ture.
>        - Introduce hv_set_mem_enc() to make code more readable in the __s=
et_memory_enc_dec().
>=20
> Change since RFC v2:
>        - Remove not UIO driver in Isolation VM patch
>        - Use vmap_pfn() to replace ioremap_page_range function in
>        order to avoid exposing symbol ioremap_page_range() and
>        ioremap_page_range()
>        - Call hv set mem host visibility hvcall in set_memory_encrypted/d=
ecrypted()
>        - Enable swiotlb force mode instead of adding Hyper-V dma map/unma=
p hook
>        - Fix code style
>=20
> Tianyu Lan (9):
>   x86/hyperv: Initialize GHCB page in Isolation VM
>   x86/hyperv: Initialize shared memory boundary in the Isolation VM.
>   x86/hyperv: Add new hvcall guest address host visibility  support
>   Drivers: hv: vmbus: Mark vmbus ring buffer visible to host in
>     Isolation VM
>   x86/sev-es: Expose sev_es_ghcb_hv_call() to call ghcb hv call out of
>     sev code
>   x86/hyperv: Add Write/Read MSR registers via ghcb page
>   x86/hyperv: Add ghcb hvcall support for SNP VM
>   Drivers: hv: vmbus: Add SNP support for VMbus channel initiate
>     message
>   Drivers: hv : vmbus: Initialize VMbus ring buffer for Isolation VM
>=20
>  arch/x86/hyperv/Makefile           |   2 +-
>  arch/x86/hyperv/hv_init.c          |  78 ++++++--
>  arch/x86/hyperv/ivm.c              | 286 +++++++++++++++++++++++++++++
>  arch/x86/include/asm/hyperv-tlfs.h |  17 ++
>  arch/x86/include/asm/mshyperv.h    |  64 +++++--
>  arch/x86/include/asm/sev.h         |  12 ++
>  arch/x86/kernel/cpu/mshyperv.c     |   5 +
>  arch/x86/kernel/sev-shared.c       |  26 ++-
>  arch/x86/kernel/sev.c              |  13 +-
>  arch/x86/mm/pat/set_memory.c       |  23 ++-
>  drivers/hv/Kconfig                 |   1 +
>  drivers/hv/channel.c               |  72 +++++---
>  drivers/hv/connection.c            | 101 +++++++++-
>  drivers/hv/hv.c                    |  82 +++++++--
>  drivers/hv/hv_common.c             |  12 ++
>  drivers/hv/hyperv_vmbus.h          |   2 +
>  drivers/hv/ring_buffer.c           |  55 ++++--
>  drivers/net/hyperv/hyperv_net.h    |   5 +-
>  drivers/net/hyperv/netvsc.c        |  15 +-
>  drivers/uio/uio_hv_generic.c       |  18 +-
>  include/asm-generic/hyperv-tlfs.h  |   1 +
>  include/asm-generic/mshyperv.h     |  20 +-
>  include/linux/hyperv.h             |  12 +-
>  23 files changed, 783 insertions(+), 139 deletions(-)
>  create mode 100644 arch/x86/hyperv/ivm.c
>=20
> --
> 2.25.1

For the entire series, modulo a minor missing argument error in a
declaration in Patch 5 that I noted separately,

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
