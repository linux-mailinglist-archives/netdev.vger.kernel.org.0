Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110BE3FF09C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 17:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346013AbhIBP6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 11:58:37 -0400
Received: from mail-eastus2namln1000.outbound.protection.outlook.com ([40.93.3.0]:6598
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234335AbhIBP6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 11:58:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCAiBFS/0mCgB2qMN5U9gBLvp1U2Cyy92ELkvrC9T80fD4TYG+I/WxS/YPZIKOugn6fTW6Pj1TpRJhi8gbS00Rafsetoy/2Lc/w1ZJMpyW4OumOJrPFbLXen/VOsuYhCh/DUAxmh2ciewoPS3lF5hgJT1D3ot0TXIrZAhfvxqNONTMHKG31ePfmhU8tpvYJfR565aOA5fy6W4F6zaITNPWME2dsxbWFvzFV9oBHuH0cTJtCUSQmDwr29IfWXJb5vplgKPkmMDOvTJUwhljbHlUTQbz1jKcxZhiVsSFojaRwLF9nkpec0Hk8QT0b08MjR9jMcUDbOTp1M1SVh0RIoDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HuvGa1HIbj6xCIKr0VB/aMjA6tx/V75cyR5Rtnz4Cmo=;
 b=hX6PpM7beSSZeEmz9DUmaJ9pJyIkwjNdkTKfArPGom7dxrRA1MWEz+4y9+uxPH1xQ/w55bLGHYhFSX8eB7yLOh/u5NoGkyzrihATJth2kpIKd7wgGTrnYPm6XhYWHW3R6dG3+Bczq1WxwxsNMIT2fj8jVNsiYSXTsKBZU4KP0yZJ3/ZNPiweFdkQnQC1sa9fA/hrNf2LbPnbT74N1UwNPm2bPx2k1XgOUhJNsEbGH08/G2BFUfnfJsqUguv0tdXM5VWeaiCWbg/Y4tu0r0A28CTIR+MgpTwTUVZejfrljk9hc+LJMCKPO8t5vcxRvLaT/ZWJ4bBJAyk0vmd44Vs00Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuvGa1HIbj6xCIKr0VB/aMjA6tx/V75cyR5Rtnz4Cmo=;
 b=BhPPiDHloa926sA3o5SBOABnbTxqZIOEXuJsLh4eYXVBnNr3+we4lcCH70qJWJ0JCTR7n6Zfsr/aBchdBEGRJnifOfVKLZFJwmT3UcPf2WTgCWs7k+jTugtAj/FRWa6bLqb+AbqkWGkRbtrf1n477usdwrbmPsPiBl92NdaCHys=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR2101MB0729.namprd21.prod.outlook.com (2603:10b6:301:76::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.1; Thu, 2 Sep
 2021 15:57:25 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 15:57:25 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Tianyu Lan <ltykernel@gmail.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
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
        "ardb@kernel.org" <ardb@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Thread-Topic: [PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Thread-Index: AQHXm2f20hs45o24pkmChnbOnB/NPKuL9ngAgAHkV3CAAo9WgIAAfS2g
Date:   Thu, 2 Sep 2021 15:57:24 +0000
Message-ID: <MWHPR21MB1593060DCFD854FDA14604D3D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210830120036.GA22005@lst.de>
 <MWHPR21MB15933503E7C324167CB4132CD7CC9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <20210902075939.GB14986@lst.de>
In-Reply-To: <20210902075939.GB14986@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=341860f6-2dd3-4e6b-aaea-e3d22051d2db;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-02T15:27:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29e260fb-9419-416f-e7a1-08d96e2a5b72
x-ms-traffictypediagnostic: MWHPR2101MB0729:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR2101MB072932751EF6DA0A12A9586DD7CE9@MWHPR2101MB0729.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mrF4oMoXJSuRKL/XGzpZTJvFlKLDUPlBxhocIR348p9dCVr/qB/aSYqavDNWBtQhLYznx6PnBdzPIzuEu8muiihXZRDhc0FVPy5XsTO+p1l7SRkCY+mB0m63qcViFQhmw+6PAzn/E7FipdBaK4AhK5ZQ3dQVtrVE8aPoT4EO1UxWSIixV2cMtArTkpfY/t9Ek37zSyD3LzpQU26GYD7Z54ukfHYYdrSGOtxlDa3/caqm176zYfa21Mm8pcy2zPWa6iAASleD2A19TwfTcmBZRQ8q4SXTcT8o5UbAqeE9OsPy4IBrj4Yx7dfUaDLRdS9lySLGdIKsrcCFQ82KN3/11kJJWQ7GgQr3nl5JYk+5jezIGWSnvD3m+J4xMfPdwdjoBRtFfOnKx35p66gL60qd6WZIftZKspfKOGvaopwP+aBRbYXZIPcS6xvyhimqjR/CIWZZSgZhzSz3ho0/hNZP5IRZyGWU0TUhfzTo779XK5VIkzkHOi/I+wQKABXNOnIAzz4gYMyxGSA8wI4/XXSBH34OTNsHPQ3ufEXjWuwlXD5QLQ66kzcINxj7ivfCDzFL97r6bid/nlSlwuWg7B98nE8K4phLCDpmtLPECZZSRqt2XA4p99Vv24InBJBv5lGKFyTQOnTCY92zkMs3Fybe5w8Kl5GpNBPwECoMT2ofOdySGAqFHos0OzDlHss5FJ/cbS2KYfWc3Lw0lww1z+fA4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(9686003)(86362001)(10290500003)(8990500004)(76116006)(26005)(66556008)(33656002)(186003)(55016002)(6916009)(38070700005)(122000001)(54906003)(82960400001)(71200400001)(82950400001)(66476007)(64756008)(316002)(66446008)(4326008)(66946007)(38100700002)(7696005)(7406005)(2906002)(7366002)(5660300002)(8936002)(6506007)(7416002)(52536014)(8676002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?txgEKNhptKnTZhKRFxE9zXxPdblEEya4z3HY9Y9W+T8Go+v0NzILZI6Antk2?=
 =?us-ascii?Q?0AjU8L6C4+Pdz9J9yNTP3+W6bvhC6KHsZFFftpbRs8qBExE4XF1rEyej6XB6?=
 =?us-ascii?Q?TF3LP39SbQevIVDByyzHpIGKh0wRn8kGGWsI8RmMHR7duippFZbzzS+u5Omz?=
 =?us-ascii?Q?a7UpgUKenDyv008SIWttlg1AxbeKp8XDdLs02JClXg/lX55zviivWx25oqLq?=
 =?us-ascii?Q?h7wlY28mwkatvnzabVvfb+joZ2jgbo4wT4HBae10bX9QJJ2tD3+afv2tXXuE?=
 =?us-ascii?Q?ZJCBsAw09QlZVcG5X7AlVJP/Z54ztWI7perLhH243k87s00vfSlT6LYscL9r?=
 =?us-ascii?Q?rc1Nfq3Va8ZBovRoxJrhyMpY9TjA4zYDGKStDrQ0kTEcdGms2WHd1od6G1IW?=
 =?us-ascii?Q?5eRQoPhVcgWECYRILtl0370PKfMyQ01/zxJ5rOtXMqxuOzo959qRirNoWTbL?=
 =?us-ascii?Q?CvaUsKCwb81UHtb8QTr5BjfFG9tck0NsyXaB3NbaGN2zgMpZtkqZrKnmsM91?=
 =?us-ascii?Q?11vggvJNKD4erPN+76nEVLmrNJh7mGpPOfx9xWMwuY/nLbovZtZrAWsJ4i/I?=
 =?us-ascii?Q?uIJE1RTX1B8Ws09qDeD4AhxVR++baJjCDtKVcCxJd7GzbUR4UKxetYyHnoyW?=
 =?us-ascii?Q?+YZXn93BjZpK7W+yn8YuX5vlWh0gO1CUOqu9z8nIEJn4PNxo2q7pj9mYbElG?=
 =?us-ascii?Q?NGJeuXowqYgtxlBeiYiBdXUc1JNo5kpAXE/IEB8iSm8fuF5rE+h+LM1hpI0X?=
 =?us-ascii?Q?n5Cl5zan+tlWbr1vS9ZLyGUvgFUz8Oku3XCvIUybVz/m9cGbExAnrC0xzM/r?=
 =?us-ascii?Q?cpR3HBgNuJCQcEBBWv5tXPKrwBdeNwRvHsWwpT56Cjurg8BzAK9bLLXITIp6?=
 =?us-ascii?Q?KfBprR6CCu0wXbPU6GXdFSOI3R5V5ULB+jlscT8gBDf5vCAx+PlkQ2LLuc8u?=
 =?us-ascii?Q?gBiCPsLGalJ8FdBPXg7MpCUr51oGQI8SKyWqIkih++ORzKKulnjiNv2L2lO2?=
 =?us-ascii?Q?FMxdWIvmKSgHezvGgLE7QHJIBmFZvqW3mwOOLxKRJqSIEagN9abdW+cq0gCR?=
 =?us-ascii?Q?96OMxcP+W0DAtNyS8xUGJZnV5NIoh9fegO4HEWPwT3TRHRfoXI02MnKCLulT?=
 =?us-ascii?Q?kFe2v/kRAS82Ap2d+DHv9bjTGE/7UoPoxzd2rDZaFQ1rsfKFo5qWlXnjvcHd?=
 =?us-ascii?Q?nwqm4i88XU1RnK0+YolCKjff+k3PVg0Bk/Z4lvADn0xx80ridOQj2QBEFHyF?=
 =?us-ascii?Q?aiy4NeMdes3ZbGoZn69+7RlIE9s7Oe4NVOZnzbyJ52agJQbDEAWM5lA5osLb?=
 =?us-ascii?Q?uVjlCOUPx2PqzbxSIQG8WKYA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e260fb-9419-416f-e7a1-08d96e2a5b72
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 15:57:24.8646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afQic2r0Oqvq+TKsAMcY2JuSksSLHirOl2XxJoYethj2b0nNTqDhmPNgN8NTmSHtCHvfeYm6BzmB8XhsRqMeI40O8olSiY1StN/gd4EMzMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0729
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de> Sent: Thursday, September 2, 2021 1:00=
 AM
>=20
> On Tue, Aug 31, 2021 at 05:16:19PM +0000, Michael Kelley wrote:
> > As a quick overview, I think there are four places where the
> > shared_gpa_boundary must be applied to adjust the guest physical
> > address that is used.  Each requires mapping a corresponding
> > virtual address range.  Here are the four places:
> >
> > 1)  The so-called "monitor pages" that are a core communication
> > mechanism between the guest and Hyper-V.  These are two single
> > pages, and the mapping is handled by calling memremap() for
> > each of the two pages.  See Patch 7 of Tianyu's series.
>=20
> Ah, interesting.
>=20
> > 3)  The network driver send and receive buffers.  vmap_phys_range()
> > should work here.
>=20
> Actually it won't.  The problem with these buffers is that they are
> physically non-contiguous allocations. =20

Indeed you are right.  These buffers are allocated with vzalloc().

> We really have two sensible options:
>=20
>  1) use vmap_pfn as in the current series.  But in that case I think
>     we should get rid of the other mapping created by vmalloc.  I
>     though a bit about finding a way to apply the offset in vmalloc
>     itself, but I think it would be too invasive to the normal fast
>     path.  So the other sub-option would be to allocate the pages
>     manually (maybe even using high order allocations to reduce TLB
>     pressure) and then remap them

What's the benefit of getting rid of the other mapping created by
vmalloc if it isn't referenced?  Just page table space?  The default sizes
are a 16 Meg receive buffer and a 1 Meg send buffer for each VMbus
channel used by netvsc, and usually the max number of channels
is 8.  So there's 128 Meg of virtual space to be saved on the receive
buffers,  which could be worth it.

Allocating the pages manually is also an option, but we have to
be careful about high order allocations.  While typically these buffers
are allocated during system boot, these synthetic NICs can be hot
added and removed while the VM is running.   The channel count
can also be changed while the VM is running.  So multiple 16 Meg
receive buffer allocations may need to be done after the system has
been running a long time.

>  2) do away with the contiguous kernel mapping entirely.  This means
>     the simple memcpy calls become loops over kmap_local_pfn.  As
>     I just found out for the send side that would be pretty easy,
>     but the receive side would be more work.  We'd also need to check
>     the performance implications.

Doing away with the contiguous kernel mapping entirely seems like
it would result in fairly messy code to access the buffer.  What's the
benefit of doing away with the mapping?  I'm not an expert on the
netvsc driver, but decoding the incoming packets is already fraught
with complexities because of the nature of the protocol with Hyper-V.
The contiguous kernel mapping at least keeps the basics sane.

>=20
> > 4) The swiotlb memory used for bounce buffers.  vmap_phys_range()
> > should work here as well.
>=20
> Or memremap if it works for 1.
>=20
> > Case #2 above does unusual mapping.  The ring buffer consists of a ring
> > buffer header page, followed by one or more pages that are the actual
> > ring buffer.  The pages making up the actual ring buffer are mapped
> > twice in succession.  For example, if the ring buffer has 4 pages
> > (one header page and three ring buffer pages), the contiguous
> > virtual mapping must cover these seven pages:  0, 1, 2, 3, 1, 2, 3.
> > The duplicate contiguous mapping allows the code that is reading
> > or writing the actual ring buffer to not be concerned about wrap-around
> > because writing off the end of the ring buffer is automatically
> > wrapped-around by the mapping.  The amount of data read or
> > written in one batch never exceeds the size of the ring buffer, and
> > after a batch is read or written, the read or write indices are adjuste=
d
> > to put them back into the range of the first mapping of the actual
> > ring buffer pages.  So there's method to the madness, and the
> > technique works pretty well.  But this kind of mapping is not
> > amenable to using vmap_phys_range().
>=20
> Hmm.  Can you point me to where this is mapped?  Especially for the
> classic non-isolated case where no vmap/vmalloc mapping is involved
> at all?

The existing code is in hv_ringbuffer_init() in drivers/hv/ring_buffer.c.
The code hasn't changed in a while, so any recent upstream code tree
is valid to look at.  The memory pages are typically allocated
in vmbus_alloc_ring() in drivers/hv/channel.c.

Michael
