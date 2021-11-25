Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEF445E2D8
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 23:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344490AbhKYWDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 17:03:39 -0500
Received: from mail-cusazlp17010005.outbound.protection.outlook.com ([40.93.13.5]:11406
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245083AbhKYWBi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 17:01:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyzdog9TP2newNdztC9VMfhTW/ilr0c4/cL4x0YfMozL4IJenkKkFGGqJ2d3LafeGtV62z+hhqmzVv6Lt9txnaRVGUsOU15bdE+SDrgk52nRH7Y92K50ztsqlnN1MVqP7l1SH6MJxrqwdrOEIiR7DrXtERQiNKVV/CI+C+6FJXcbNkps3ZRUx/3MnTdxLF++/6+6j2oHVgHpaMR5Q4XmtAAKtCnSd/XEDbyQgmgCeU+Jt0BR7mEB6X1pe9bTKz1YaGoPjSgD47DMXqrbmpIOAUvZm9gdWhfEoT2FT0/rP+JlsfYcB9OTW59rk147sHo9SLleDXpcliMiXXCI9hvaSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TGhSUp+GC5hi0nhdB6SHKVvlB9ZF8FWDxwhyYXwBSU=;
 b=HrUaYT46h+24XRCqqDSlgoUG0CnKqNnseeC+NI6XE5YHtxOVreZCxiq/P424diVAC+IeBI8ixsXJKHTcLf/yDwM3PS/4DI1VAfdDVZ1+B6MJuZr/pCGgktrHqvGsiPK+4SRE8Jaj3s2cHDVdxOLJlFI9IeerQUobTw6rj+bGzOifxzyYkONMBasNpLW7zqEYJyXgRXpbCyw9nL4xNu/ZfKXSEo69rLiVjbB7VCStOBWW1aXtVVFmDMFZa+7LzBAGHisDU89x/UUYbcpmIFcSoi+0vRlaBA46dM5KVb/kRrSANjYN6HXf4rxfFbOEnqBAsrBFAjZ++Qq03qM2XBkanw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TGhSUp+GC5hi0nhdB6SHKVvlB9ZF8FWDxwhyYXwBSU=;
 b=XtyDvwpKrI29n7TFOetnHFPtEwPCKIX76ytEXuJbhyCRTrhrdpJqiUtYeOVBa2pkUpTk3qvPN2C9xVJxANmKGNAQHj051yy6sb4xzvjQODg75mZgvYzFsCl2F4+n64ROZ/gyjLPR86HaY7p9mY9CJLPMUgNIN++HTV+yOXlInJ4=
Received: from DM6PR21MB1292.namprd21.prod.outlook.com (2603:10b6:5:170::19)
 by DM5PR2101MB0871.namprd21.prod.outlook.com (2603:10b6:4:80::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.9; Thu, 25 Nov
 2021 21:58:17 +0000
Received: from DM6PR21MB1292.namprd21.prod.outlook.com
 ([fe80::c95a:f84f:ded0:b8e6]) by DM6PR21MB1292.namprd21.prod.outlook.com
 ([fe80::c95a:f84f:ded0:b8e6%7]) with mapi id 15.20.4713.010; Thu, 25 Nov 2021
 21:58:16 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V2 5/6] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V2 5/6] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Index: AQHX4HeZrm8ii8lkM0eh2/Yg8KcHmqwS6XUAgAHkSoA=
Date:   Thu, 25 Nov 2021 21:58:16 +0000
Message-ID: <DM6PR21MB12926C3BC4766C78C57D9210CA629@DM6PR21MB1292.namprd21.prod.outlook.com>
References: <20211123143039.331929-1-ltykernel@gmail.com>
 <20211123143039.331929-6-ltykernel@gmail.com>
 <MWHPR21MB1593093B61DC506B64986B14D7619@MWHPR21MB1593.namprd21.prod.outlook.com>
In-Reply-To: <MWHPR21MB1593093B61DC506B64986B14D7619@MWHPR21MB1593.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4391e0e8-47f1-4dc5-aa3c-c57814906b25;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-11-24T16:08:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18755722-ee1d-4ade-c5e1-08d9b05eaf67
x-ms-traffictypediagnostic: DM5PR2101MB0871:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR2101MB08714BB3CCD74813A004F8A2CA629@DM5PR2101MB0871.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xoYIzcAmGZEUIrcPE46VDKTqGfQ/03SBKM4jh0UmRXa4ymu6TUyP4ZLqLhuFIsKeMUZZ4vGIUjgANFxMRREBlW/ZKKTRJ99HuQDrJcYhzHWtzCJ6GiH6Va6NPIY2Ja4GImaKkPV5uBLdFhghwP1OX+H3ffPI+exGzJPhRVcNPo8aOQcwecQS5158HoxQGCtFkUb6sNavrcfau6WZHoRVGNMwV/O+FPjd4JGXLIBo8g8MVxpG64ssm8nl5sGfU6+CCodiDJ6W7GW1drCxcV558+FeeaReUK0KgPXmaenKFFhezbYatCqOd611v22xVGl6qBt2dF3zB0vazhKRDWgVass+/V7xSpADM1Xp97HF1myDgocmFfXERfnvw71I9DNhuH6lSF6xqa/7bSkfzPgn2SnUEK4/aYhijlkkQ5bFZJzM4w0DnqRNBlPNAiA4IwR9+yLiPCnHoXlSZ6fMlsmEt+Zr3xIVMeF7q3jGZJbpQsqWXCZ1/zxNALEiVYDXrfguB7WHdNiXC/jLGFOOlwxrVa89hch6A4C7y4/vxhE6koWidWFA/E6mhKbmWrqDc1aJmohO1ewyG8q0QG2q1vrWtHVXc9zGm9LMuthgam0iwZZeCq/1s6pghUlRB6a0TbvkB0qeAzl843SlnVdis10rpOWOp9zmzsAnbJr83h7YWhFlzcPITzJ7d5p2k4P5wajBZRIkDoXdmkywObDT6SRwkoWMCNvo9K0WQWrb5oJooQUz/2ORmXFiuCfjiYhgGoGAJOIUQ2344rjljbCRVl1d/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1292.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(38100700002)(10290500003)(82960400001)(6506007)(82950400001)(53546011)(83380400001)(55016003)(508600001)(2906002)(7416002)(7406005)(5660300002)(33656002)(52536014)(186003)(71200400001)(7696005)(921005)(8936002)(66446008)(64756008)(66476007)(8990500004)(8676002)(4326008)(316002)(86362001)(110136005)(54906003)(66556008)(38070700005)(66946007)(9686003)(26005)(76116006)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JS7hZGSfAYVAfOMB1vqvSmyBRrWHK7GuFyfQ0PgrZf97/KTPgUuk4OSkYhd+?=
 =?us-ascii?Q?GB/LlcmnxP2BVpg6z4r9+CZKvJFnZ5aI24zDZqLdAjDuWOfTAwOPcUHez14f?=
 =?us-ascii?Q?qapg3PSqVnUPh6NsZHkC7Qg6eDfqsNQNdqeAneImWyRkCQrk6n5rJT9YAn9F?=
 =?us-ascii?Q?tbTFo2dCQFnVMccKqqvM9j6W5vNSwiV7/4kr3vAkaeXXDqzBvuCubB6CsMDc?=
 =?us-ascii?Q?xvSq3djLdmDQf73CncwZS2PSgTpY8g4Q1vY2HvQ9QcqETooV90ppKnDUD+HC?=
 =?us-ascii?Q?sjFcgxOXQGr5LOodbmmZnBfiJDYg6xn1aPCPs8coMk88+5rMFuUQtsLT/U6T?=
 =?us-ascii?Q?GXgctjEjY6+um3SHuKjLkF5x8+EWzf4CgqKiX3OtQxGnMiVHR7ypbV+ALCh3?=
 =?us-ascii?Q?MLyYqnQfDFZZx5z+vpFG4sWYyxVY9wayqtU73Md7v2nEvWsJWcUJ6fqIO27u?=
 =?us-ascii?Q?yEJRFP1TfYCFEDW0Nw4W9eycQ2lwL/CI7YmIfHvGpHD1L7QpJliBwImO8iQ8?=
 =?us-ascii?Q?z6brmpqgoIltO2HGohjbhJAjxdAaMr4Xq9ScXkvAq/caZNY0HuETkcvcK/j8?=
 =?us-ascii?Q?fyt1rwvkroqskh2ssdBSnuWzCHw8gLXaeX3XJgVjMUzWNtD860bt8biNk3lY?=
 =?us-ascii?Q?9gD35LGiHy9TS+4HjroZiqUB2+t8T5q7FvbMdAqHsu7mWoos00HdSMzdWA5N?=
 =?us-ascii?Q?w12CuBFAbO0WVHrS4Rx4pzkFymjybWbbjb+SJQ1a84uMOzknzYa1vpkUJtdz?=
 =?us-ascii?Q?DmrBI+RVcrPjD5FPoFmOBTgihgUjutvzX0J/HM53tLkjWpm9aZerK+zSaRDp?=
 =?us-ascii?Q?vh4uGHY19+wRBM7GL2H0CcnJ721ZuwuUukl7Ce91AF3KLFpybpfBVo89nm1+?=
 =?us-ascii?Q?CPkaAbiE7eEUgSJI1JYekJQ0woIgaio5NUzdHoAxe42gWgGSDYhYeRwsoSYm?=
 =?us-ascii?Q?T+1M8nY+arhIlAgiMNYk9NYhHnHNyWEYi2XO441VvtwVTqI8TsNlOq1Y+H6y?=
 =?us-ascii?Q?ItkfXI8FYdSPqRz5hZmdFJ0hDIJPZWXdKlWW9kNqz2Q9QjKlMnw3P71Hukxt?=
 =?us-ascii?Q?KvoyltK5fkkEwCrusMI2xbMUgaowgUAwZ6rZQ4eI0cK+Wx2cf2IlInDmhVZq?=
 =?us-ascii?Q?VDCwpoieiXyFKKhhgdwnbxyNGgbZjYpllJ6CGaZ8DNHWzqQOkWA0vsDMJV5f?=
 =?us-ascii?Q?wZJ3TD8mmUqysmUg1mzzNclFgX78rw5OBxl/sjW7SwWsF97t8Qu8uMdXmk9n?=
 =?us-ascii?Q?Ry2jI3kPdMSi1yYZ1jScAUltDlJpPeZvSFAFzg70qyV+9n7r5WyhD0rmibvG?=
 =?us-ascii?Q?12trwECnRY3kVvXEtywnjCsgD8fs2iDY5R2itwmXJdeLorI7PRH/lvGYSGgd?=
 =?us-ascii?Q?fq/ziGYFoTw1hLE3BwlICX5IeALWGyKuB1gKdV3ebcWRQaYc7zADHbYpHycQ?=
 =?us-ascii?Q?02LR6QQCypfqiFj3SLy1ALKR/uoyLN9citVvfsMLG9S0Ng32+DpNoVIbXGBU?=
 =?us-ascii?Q?f75P8ewp7YXdWsbbdUiav4TFSQc+C2hTzyT4V2czqBbBVbK3CNR6sZjjc+aw?=
 =?us-ascii?Q?wr+WLMuLa6Lf57HmZiFI2gqoCkpHdMI8/DAuOmFnXX89j9wF7jAGGOK86Mzs?=
 =?us-ascii?Q?Kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1292.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18755722-ee1d-4ade-c5e1-08d9b05eaf67
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 21:58:16.4384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kYiE8U89jtj1r+9eugmKknWQYtqYQDXP2stSr/pxJeP8Ke1OvKRb3aa6YbktLXP5kF9T4J6Ed1JW1dhzqVktEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0871
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Wednesday, November 24, 2021 12:03 PM
> To: Tianyu Lan <ltykernel@gmail.com>; tglx@linutronix.de; mingo@redhat.co=
m; bp@alien8.de;
> dave.hansen@linux.intel.com; x86@kernel.org; hpa@zytor.com; luto@kernel.o=
rg;
> peterz@infradead.org; jgross@suse.com; sstabellini@kernel.org; boris.ostr=
ovsky@oracle.com;
> KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>=
; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cui <decui=
@microsoft.com>;
> joro@8bytes.org; will@kernel.org; davem@davemloft.net; kuba@kernel.org; j=
ejb@linux.ibm.com;
> martin.petersen@oracle.com; hch@lst.de; m.szyprowski@samsung.com; robin.m=
urphy@arm.com;
> Tianyu Lan <Tianyu.Lan@microsoft.com>; thomas.lendacky@amd.com; xen-
> devel@lists.xenproject.org
> Cc: iommu@lists.linux-foundation.org; linux-hyperv@vger.kernel.org; linux=
-
> kernel@vger.kernel.org; linux-scsi@vger.kernel.org; netdev@vger.kernel.or=
g; vkuznets
> <vkuznets@redhat.com>; brijesh.singh@amd.com; konrad.wilk@oracle.com;
> parri.andrea@gmail.com; dave.hansen@intel.com
> Subject: RE: [PATCH V2 5/6] net: netvsc: Add Isolation VM support for net=
vsc driver
>=20
> From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, November 23, 2021 6=
:31 AM
> >
> > In Isolation VM, all shared memory with host needs to mark visible to
> > host via hvcall. vmbus_establish_gpadl() has already done it for
> > netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> > pagebuffer() stills need to be handled. Use DMA API to map/umap these
> > memory during sending/receiving packet and Hyper-V swiotlb bounce
> > buffer dma address will be returned. The swiotlb bounce buffer has
> > been masked to be visible to host during boot up.
> >
> > Allocate rx/tx ring buffer via dma_alloc_noncontiguous() in Isolation
> > VM. After calling vmbus_establish_gpadl() which marks these pages
> > visible to host, map these pages unencrypted addes space via dma_vmap_n=
oncontiguous().
> >
>=20
> The big unresolved topic is how best to do the allocation and mapping of =
the big netvsc
> send and receive buffers.  Let me summarize and make a recommendation.
>=20
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1.  Each Hyper-V synthetic network device requires a large pre-allocated =
receive
>      buffer (defaults to 16 Mbytes) and a similar send buffer (defaults t=
o 1 Mbyte).
> 2.  The buffers are allocated in guest memory and shared with the Hyper-V=
 host.
>      As such, in the Hyper-V SNP environment, the memory must be unencryp=
ted
>      and accessed in the Hyper-V guest with shared_gpa_boundary (i.e., VT=
OM)
>      added to the physical memory address.
> 3.  The buffers need *not* be contiguous in guest physical memory, but mu=
st be
>      contiguously mapped in guest kernel virtual space.
> 4.  Network devices may come and go during the life of the VM, so allocat=
ion of
>      these buffers and their mappings may be done after Linux has been ru=
nning for
>      a long time.
> 5.  Performance of the allocation and mapping process is not an issue sin=
ce it is
>      done only on synthetic network device add/remove.
> 6.  So the primary goals are an appropriate logical abstraction, code tha=
t is
>      simple and straightforward, and efficient memory usage.
>=20
> Approaches
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> During the development of these patches, four approaches have been
> implemented:
>=20
> 1.  Two virtual mappings:  One from vmalloc() to allocate the guest memor=
y, and
>      the second from vmap_pfns() after adding the shared_gpa_boundary.   =
This is
>      implemented in Hyper-V or netvsc specific code, with no use of DMA A=
PIs.
>      No separate list of physical pages is maintained, so for creating th=
e second
>      mapping, the PFN list is assembled temporarily by doing virt-to-phys=
()
>      page-by-page on the vmalloc mapping, and then discarded because it i=
s no
>      longer needed.  [v4 of the original patch series.]
>=20
> 2.  Two virtual mappings as in (1) above, but implemented via new DMA cal=
ls
>      dma_map_decrypted() and dma_unmap_encrypted().  [v3 of the original
>      patch series.]
>=20
> 3.  Two virtual mappings as in (1) above, but implemented via DMA noncont=
iguous
>       allocation and mapping calls, as enhanced to allow for custom map/u=
nmap
>       implementations.  A list of physical pages is maintained in the dma=
_sgt_handle
>       as expected by the DMA noncontiguous API.  [New split-off patch ser=
ies v1 & v2]
>=20
> 4.   Single virtual mapping from vmap_pfns().  The netvsc driver allocate=
s physical
>       memory via alloc_pages() with as much contiguity as possible, and m=
aintains a
>       list of physical pages and ranges.   Single virtual map is setup wi=
th vmap_pfns()
>       after adding shared_gpa_boundary.  [v5 of the original patch series=
.]
>=20
> Both implementations using DMA APIs use very little of the existing DMA m=
achinery.  Both
> require extensions to the DMA APIs, and custom ops functions.
> While in some sense the netvsc send and receive buffers involve DMA, they=
 do not require
> any DMA actions on a per-I/O basis.  It seems better to me to not try to =
fit these two
> buffers into the DMA model as a one-off.  Let's just use Hyper-V specific=
 code to allocate
> and map them, as is done with the Hyper-V VMbus channel ring buffers.
>=20
> That leaves approaches (1) and (4) above.  Between those two, (1) is simp=
ler even though
> there are two virtual mappings.  Using alloc_pages() as in (4) is messy a=
nd there's no
> real benefit to using higher order allocations.
> (4) also requires maintaining a separate list of PFNs and ranges, which o=
ffsets some of
> the benefits to having only one virtual mapping active at any point in ti=
me.
>=20
> I don't think there's a clear "right" answer, so it's a judgment call.  W=
e've explored
> what other approaches would look like, and I'd say let's go with
> (1) as the simpler approach.  Thoughts?
>=20
I agree with the following goal:
"So the primary goals are an appropriate logical abstraction, code that is
     simple and straightforward, and efficient memory usage."

And the Approach #1 looks better to me as well.

Thanks,
- Haiyang

