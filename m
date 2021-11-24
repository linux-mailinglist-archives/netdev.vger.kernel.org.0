Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615F645CA93
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243584AbhKXRGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:06:52 -0500
Received: from mail-cusazlp17010001.outbound.protection.outlook.com ([40.93.13.1]:26802
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241709AbhKXRGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:06:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJSew702kt1SBq/iP+d0p4PpwIrVLZwzRSwBbg1PWN4NPsgCv/+v9GiYcp9Yvs1HjpMV0WV2TPEb/8hwN7SE0cDQKiaB+jtcUpEtYvIemIDeQtqpd1Yc3/aKvtoOIyoAvtd3PLSGZCKGso02BeV9f5X+UjJSWUAorYuOz2Shz1WOjRHW4qiijWUiknKAmr/kGGS0tNGYZyaWxaDSDSVskAJUrpmmEeTwNrXRuIcxjFMMrhARtuO8hkmNIFHhOwYHHyRP5PuC8P8n7+uqWuCd4UtSUUjrvRoEcDp0sONT9hDTGtO/zzgQIs9tH+EA8Nb3RUxY1l/XA8OQbsaO83cYuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BD9wKKo11ShnaAQ2qihISDt0mNPkCMxLNXXSL2rmFyE=;
 b=A0qXvqeGYO36sQXuR8NTZYeJjezeZniCtq/HxfHg3OevkFYSGCBxOGrybjWAhGUyLpE68/pVUyYH9uvzA6Hy9X+aHNBG73lJ6B9M9PQJ3dCIHFmGThkwzIMQd8lYUoG2B35zZIoBuaoaqKdXI9HyiPJUqi8dK1Rm9byLLr8RUXyminrAKhxCnlJix1p67NFCiIqFhvylPkkyazaFOpvion0DqvTwRu8eZy57bPaw39UA2fobUPdwxmaMMe5wIfMoOEajzuuP063z3jnpJejY+SuP22a8P5OM4X3eSR2pRqVoTK189HVRtvTLereFL7LkKpoenboqpQ7ohNMmwHBcYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BD9wKKo11ShnaAQ2qihISDt0mNPkCMxLNXXSL2rmFyE=;
 b=UkUcwtpQTsE3e/3mDhS9QbXgBnLY/1K3N7504xrxZvVrf9luaUQ3kEvpqloXPVUSmx2x0qHXhmzBuFoiqbFsUttiyr3QqXvbEOJVNcbn3RfUJzFOZAJK5OPbW+y1YZGROwduvUBcJgOCx13A7WRwA+AH0yUVEDtvfnkGl9/PALQ=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0160.namprd21.prod.outlook.com (2603:10b6:300:78::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.6; Wed, 24 Nov
 2021 17:03:27 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9401:9c8b:c334:4336]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9401:9c8b:c334:4336%2]) with mapi id 15.20.4755.001; Wed, 24 Nov 2021
 17:03:27 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
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
        Haiyang Zhang <haiyangz@microsoft.com>,
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
Thread-Index: AQHX4HeYtAEila+YgkS3X1o35FDXYawS2g7g
Date:   Wed, 24 Nov 2021 17:03:26 +0000
Message-ID: <MWHPR21MB1593093B61DC506B64986B14D7619@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211123143039.331929-1-ltykernel@gmail.com>
 <20211123143039.331929-6-ltykernel@gmail.com>
In-Reply-To: <20211123143039.331929-6-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4391e0e8-47f1-4dc5-aa3c-c57814906b25;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-11-24T16:08:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 645ba359-8c0b-4f2f-7b48-08d9af6c554b
x-ms-traffictypediagnostic: MWHPR21MB0160:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0160D2B6E06F66610394FB38D7619@MWHPR21MB0160.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lgCok9YPWjAorBazHS+K/zK0iUKclUi/gDhMV1adSOrVIzDHGcaJeLc9mWOtg5DFOjPG2BjtBuEz9a4nsye2BSa/saMA1zBZjXmh7WAae4okWK5XD2+lm0SiigzSQzGL+VKFCbGTd7t1tPeWJUmc5E63Cbeg9IdIrdHkzw7SYTkVXOhc0LtNSKLasHs/FD/M+nwB5Z6D6lqvESYdChEADB+5LHr6jPOqHwiVUp6+GZ9VS95bKo0mCZv1UD9zNxd++gxK0Evx8uxgUpCX5+O8m7eQXny27KQ3b1oMCge95Ijx2RM9yI3qFyQzypEQdJqeFyjONfstRR3ztpSKgDLWJ/y6x4TjUJDTpgOtH3HawjLrjoggMoatL55AcgXrr9nersomuAezohLes/8W2KePLvIGKfb6AUUg0o9UmO1LSD/FZLz3d0OBYBVK4C3P8iRnYP1IFWg0HW7fhR3X9itBzooTHhTIysNZfChaY0rCbkvBFmD92Dk1BLorb26CgHdLaWyGfTuaFwc62Ldot+XMic80/UKwIYzvw47SJ5fffxUW4uCNJc2fKOR/u1bcenUVVE9iajcB4aJqX7agdBwMvnmfgK0i+aORU0ZGlXqmRc/jeYD7cqluGJCVqrbDx7cqKm89I/lfGAeh7TMELgvmxks/sU13zSfvNGDfxCuHGo6E0YEL1MvMp7TaDLLM/kk/zunkwiuafrAb+k3+WBfplbbPVyA3rEdCWrNiqwPZinBdoio8yUDlEyASDkr7ZDfNcE+xmvPzCOkaUZbFrezmEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7696005)(71200400001)(6506007)(508600001)(82950400001)(8990500004)(55016003)(10290500003)(33656002)(66476007)(66556008)(64756008)(66446008)(8676002)(4326008)(83380400001)(186003)(2906002)(8936002)(54906003)(7406005)(86362001)(5660300002)(7416002)(122000001)(110136005)(26005)(316002)(76116006)(9686003)(52536014)(66946007)(82960400001)(921005)(38100700002)(38070700005)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AwExHU+M29eSnSe5BLN2W/8ii8uIVdNmFv8oHC+RkSnXcHjP36HUkX+PaTU4?=
 =?us-ascii?Q?H25bZgnMWSEygiei+0jPiJE50Jq32E9pKjqctjxK0pEmXAJL6Rl7jSwwA+5k?=
 =?us-ascii?Q?VDxphfgxPSOwWLZJ73FRZsITZnilA5QRrVDgUsomXr7ApvNg537Sc1W+5oj3?=
 =?us-ascii?Q?fmj+qvljLh+Dte8BngcvUY2l4Wh2NwozL6RhdwyxxZk3TYdwFiMbQJGSDMfJ?=
 =?us-ascii?Q?wviKLA0WrpNudd61XGpwHiClzTM/g6j9FE1iIOgaJFbGfpwtQM/1D5o4FdxK?=
 =?us-ascii?Q?shSL3/EzQFqacqG6hDvJtGUvxldK79sn13sJA1chUjpLfjY9mSXyQr/gUjcc?=
 =?us-ascii?Q?YqPgoIR2mHBbnxF4kYsgkkRHIejQZNXZrf7wgvATddtOXEpJF2F1PZvtDdvb?=
 =?us-ascii?Q?EMwZVTyTlW5hY+UYk9Z9ZENM+NLCt851qy0B0V5NiIpK8X3gIwx0/+6D7FuY?=
 =?us-ascii?Q?sqRO8dDviPsslQJveWn0FUUf/k4rmRFEmq2VoRDleKpYX7mR512esQDxvgsF?=
 =?us-ascii?Q?eYV3J24bFO4zhPkt8L6WfPWYwqzWfxeNf/7bWzdImiQB50VYGHCVeBoLBeP/?=
 =?us-ascii?Q?oyTNpMXwIgngjAbNxHUAowi7NsrZ3HcD/dedi9L1sb7jmta3GgIxaTwPZVNS?=
 =?us-ascii?Q?CjIoX61Hnrr+AyNbXS0ifdbiPcW0Qm54fy6ec+s/WUSHypUutpT2espkFFYq?=
 =?us-ascii?Q?XnTMytXLiMuBbNQBbCW5McHkZZJbs2w+J6Fp5I2TrQRBksI2NJg1ldPOCTax?=
 =?us-ascii?Q?d6hDsdbXpHttpIjHLTl5T1l+7IdhQwCQSkcOWznccUjaj8G7vnPZMlL0kkWB?=
 =?us-ascii?Q?b3t35lSvZ15wZBQWqnMEWbW3zzAHwS9/uJZ+QCzjgenjGWlqgVMSPekKjjP/?=
 =?us-ascii?Q?dI6MSG4Yd7oHPkI0f9F0W6v5ZP6l4CJ1q776PUFSRB3cD0Wv11QYNfiMvKFk?=
 =?us-ascii?Q?vpU/2Ke6280PatYJ8kiB0+yNF9f9qKtBfA3rQucSl9rtD/Y9K0Tive4qf69C?=
 =?us-ascii?Q?Jm3qIRyvFyLOrEA4YmvCuxMs6MpE+nXAFf9OsXda3O4P9z5B1KhiQrvvMrtr?=
 =?us-ascii?Q?+GWAVb+JkkL1a+kuq4Fx1qEezMeD+kyFaLzV84zZfLTikgdJjS6DRhks9k5T?=
 =?us-ascii?Q?wgFapZXNg72Ww3tEX35HmX5BpSjhPSsSj5XqvODVG9LEVLnztLvBFLSj5NI2?=
 =?us-ascii?Q?6HMwsOzsinDjly33+sqaEIUaB4/+X97kg4KOYKR5jooRPDzaLvPDlHbD4YUB?=
 =?us-ascii?Q?G8Jw5wqbh3VbYQWP44TS07YhY7buoS+fiuY02Ic1yenN4psAiSCe0NaF7f3Z?=
 =?us-ascii?Q?Uz4i3N/smEpuAM4yf7SwMug2aiiMKJrFHrzr6KtkpD3EF24hg5RFu1Qsm9L7?=
 =?us-ascii?Q?EwqRMGm9QFWcwpbgrQURnDh6SYlhuM1foch9MzA/l099HA18X1IR1Fv77QO6?=
 =?us-ascii?Q?Edd//vvaOFI+3524x/IVc2M9OhGwxQjYBzeyxyrtVZn886YxUV+KZPQqt98+?=
 =?us-ascii?Q?I2Pi3V6cYfoMbl7LYP6T+U+oQIwJd27KaEX57gnKVTijaJCtnx7AKqqMHJtk?=
 =?us-ascii?Q?tZvES3IOLJ7mNUnpZymggJ/cks9moO8Ntx3g8B1rW3dDIh1osPTUN8MflkbT?=
 =?us-ascii?Q?9FJk/Z4DwoggfhKZI/57+yOwnasNq+pZuO5t602X/oJvRjh1USkAgNmUlJzK?=
 =?us-ascii?Q?ZJ0WYg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 645ba359-8c0b-4f2f-7b48-08d9af6c554b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 17:03:26.9566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mssEEe4NcS1WKOFFxFXYt+L4MFp7zB/b0GO6xguhSCkVDE+e9DLJeWgVrPf5wyWnWE38To/33ZeymL6sVo2/EASlOOtjmwDP3druvvzuWBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0160
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, November 23, 2021 6:3=
1 AM
>=20
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() stills need to be handled. Use DMA API to map/umap
> these memory during sending/receiving packet and Hyper-V swiotlb
> bounce buffer dma address will be returned. The swiotlb bounce buffer
> has been masked to be visible to host during boot up.
>=20
> Allocate rx/tx ring buffer via dma_alloc_noncontiguous() in Isolation
> VM. After calling vmbus_establish_gpadl() which marks these pages visible
> to host, map these pages unencrypted addes space via dma_vmap_noncontiguo=
us().
>=20

The big unresolved topic is how best to do the allocation and mapping of th=
e big
netvsc send and receive buffers.  Let me summarize and make a recommendatio=
n.

Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1.  Each Hyper-V synthetic network device requires a large pre-allocated re=
ceive
     buffer (defaults to 16 Mbytes) and a similar send buffer (defaults to =
1 Mbyte).
2.  The buffers are allocated in guest memory and shared with the Hyper-V h=
ost.
     As such, in the Hyper-V SNP environment, the memory must be unencrypte=
d
     and accessed in the Hyper-V guest with shared_gpa_boundary (i.e., VTOM=
)
     added to the physical memory address.
3.  The buffers need *not* be contiguous in guest physical memory, but must=
 be
     contiguously mapped in guest kernel virtual space.
4.  Network devices may come and go during the life of the VM, so allocatio=
n of
     these buffers and their mappings may be done after Linux has been runn=
ing for
     a long time.
5.  Performance of the allocation and mapping process is not an issue since=
 it is
     done only on synthetic network device add/remove.
6.  So the primary goals are an appropriate logical abstraction, code that =
is
     simple and straightforward, and efficient memory usage.

Approaches
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
During the development of these patches, four approaches have been
implemented:

1.  Two virtual mappings:  One from vmalloc() to allocate the guest memory,=
 and
     the second from vmap_pfns() after adding the shared_gpa_boundary.   Th=
is is
     implemented in Hyper-V or netvsc specific code, with no use of DMA API=
s.
     No separate list of physical pages is maintained, so for creating the =
second
     mapping, the PFN list is assembled temporarily by doing virt-to-phys()
     page-by-page on the vmalloc mapping, and then discarded because it is =
no
     longer needed.  [v4 of the original patch series.]

2.  Two virtual mappings as in (1) above, but implemented via new DMA calls
     dma_map_decrypted() and dma_unmap_encrypted().  [v3 of the original
     patch series.]

3.  Two virtual mappings as in (1) above, but implemented via DMA noncontig=
uous
      allocation and mapping calls, as enhanced to allow for custom map/unm=
ap
      implementations.  A list of physical pages is maintained in the dma_s=
gt_handle
      as expected by the DMA noncontiguous API.  [New split-off patch serie=
s v1 & v2]

4.   Single virtual mapping from vmap_pfns().  The netvsc driver allocates =
physical
      memory via alloc_pages() with as much contiguity as possible, and mai=
ntains a
      list of physical pages and ranges.   Single virtual map is setup with=
 vmap_pfns()
      after adding shared_gpa_boundary.  [v5 of the original patch series.]

Both implementations using DMA APIs use very little of the existing DMA
machinery.  Both require extensions to the DMA APIs, and custom ops functio=
ns.
While in some sense the netvsc send and receive buffers involve DMA, they
do not require any DMA actions on a per-I/O basis.  It seems better to me t=
o
not try to fit these two buffers into the DMA model as a one-off.  Let's ju=
st
use Hyper-V specific code to allocate and map them, as is done with the
Hyper-V VMbus channel ring buffers.

That leaves approaches (1) and (4) above.  Between those two, (1) is
simpler even though there are two virtual mappings.  Using alloc_pages() as
in (4) is messy and there's no real benefit to using higher order allocatio=
ns.
(4) also requires maintaining a separate list of PFNs and ranges, which off=
sets
some of the benefits to having only one virtual mapping active at any point=
 in
time.

I don't think there's a clear "right" answer, so it's a judgment call.  We'=
ve
explored what other approaches would look like, and I'd say let's go with
(1) as the simpler approach.  Thoughts?

Michael
