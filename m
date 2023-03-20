Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C176C209C
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjCTS66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCTS61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:58:27 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021014.outbound.protection.outlook.com [52.101.62.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BB21E5E4;
        Mon, 20 Mar 2023 11:50:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuyADjDsFiRJiDS4e4Q6PHNScQVbSXmyuMgHH93VLSwgHB0EsOQElClbqq2KJwqi03XkPnSE/3zpoqGivSujFfxEKu0kMR43ejk+zjA3T+LB610FsEhtDc7pKDsmnVWMMTTmI4dQJOjTyNYgzpOYoqBCg3BVRXeq0DgiwHP6Umyu/yLaiLtXt7Txn+SfXG9EurRdNTw/1eDFqUf4/MNdPZ7ao9sjoo2CPb/TJRUhvgR6MEhcttEUUEiEBG/G0z/8x7BTsFadkofzUNT16AgnPrw/2RSJjGbPR1avpsruRUiLDK+wJ1mU+psUmUdN8XYs7hzaSl/JMsKYxMDoEszIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gZRTzVSlbHFnoNrGyrXo/+dPb70cMkkVwb5uYlUzZE=;
 b=HcSKgVz4nFyzpkFYQiPbKri7HQc9Kpxe36iQX1kSVolUMXecBWV+0Uebi2/NAIgBmj2s/qaViXMrMogqiDOgju49WCy37dHCwu4u3o+R5sHqPNL0MR4oev/sGUw3BVqPz9syOFMsdz4LYlRKVD66x8dNfmF4hg3ZZT+wl8sebpUnqWzIK1OnrTTRs5ui8u/aL+cfO/tDEHonauTXKR9Ad/Pz8KFDLtTvWnVaULS4v+8+XeyMAYwGCu5pTw+iovnxN0yNWSxp8slvqiFnjXZzS8MiFM0DlgwtENduVsJJKecl13qnHy1nfz7Ixgq+4t7LEgqd6xOTChOgoahYr4mqzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gZRTzVSlbHFnoNrGyrXo/+dPb70cMkkVwb5uYlUzZE=;
 b=RRSytm8wdo0d6yCbhhwOZSNdXTuvl7W8NZeqjRloGqYVDVdiMY8NA5TzAO+G1UibRuNuHSJ27u08qcmn/hZujYk87GMQYNO8UPYf7QZ0NLWjzMz+GmhQHI+W5pC96dLKjz0WmPq+kRnCF99IbEFejV3f1Flc4KOj2uLTJtylDjo=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CH3PR21MB4039.namprd21.prod.outlook.com (2603:10b6:610:1a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.5; Mon, 20 Mar
 2023 18:50:02 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6254.002; Mon, 20 Mar 2023
 18:50:06 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHZUjCyCpporLk3zkiXtyclH/4N+K8DmEQAgAAZtaCAAFnoAIAAAQEA
Date:   Mon, 20 Mar 2023 18:50:05 +0000
Message-ID: <BYAPR21MB1688DF161ACE142DEA721DA1D7809@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
 <20230320112258.GCZBhCEpNAIk0rUDnx@fat_crate.local>
 <BYAPR21MB16880C855EDB5AD3AECA473DD7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230320181646.GAZBijDiAckZ9WOmhU@fat_crate.local>
In-Reply-To: <20230320181646.GAZBijDiAckZ9WOmhU@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5e65d818-196c-4bce-b0b3-5392a10c9611;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-20T18:20:21Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CH3PR21MB4039:EE_
x-ms-office365-filtering-correlation-id: 395c34c6-72c9-4452-fd17-08db2973ec02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aYAbpIe2ODiQsDmgEJv31e9FOAinnA3fWDMDrzVM0OrxShUNAv/kiUO3eFLjSDmu3ebALXG5+E+wxTC3ZLQWvxYBQ13LaSJUUw8ieIsTtd/7BzjhYa9soaNjBM/+ktM1ToZ4GTQwb05UiBjN9Vf39XEfkg3nRSkRmBkt+/ooM991FDPkeCFnbh3zYbYmOzLcIIruNgxTZ3iY38EWLCZnTC2d55SaRgUIfVi0FDw8rpVm8SMJ3IazqI5ca/IX9PDX08OhWmH+guXx5HwgEwxbJi0nJ25ThwKaKo0WXpo2f3p3b0i0QrygICZqyG1Ng9CkoscqE4vOrFa8/ifuMiD1ocYO9+OTYLQrCPC6iRqnVQVrCjHDsz1KyKXUt76XHVW+SZDovE/VpbWjP9av5tCMqokQXjBxfyJw3Z0d/TcksmjVOhZK5iOQpo8Mq86DJeeYA2+8CJV/LIfqc1mLA+3LrZTnK6AwWH2ZirXom/kH+7FWF4zsThj548R1bFotGFCr7JNyoP0Lg+Uf5kX4kB3hzfyctl30uZKTjX2dSX60CW40M4NYcntKDxEFKL5FH2l/lKbgqUoGnXnOipYz24i4zeymAi5YK1kG/D0jHh2x3mZ3hCTTT1j7yt58AEOEIEbeLF/FjDdibEkuHWG/qj2cCt5Cro2sUVbqYUeWl8Iag1bCKk4deiSoTCoeIi3zHw9MnM7BQJisYywg48ul9JfGvtX33hhLvcG/yq2r53xAa1/3b0nZ//RI4fXLu3WEvdTD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199018)(33656002)(71200400001)(86362001)(38070700005)(38100700002)(82960400001)(82950400001)(7406005)(8936002)(52536014)(7416002)(5660300002)(122000001)(41300700001)(2906002)(8990500004)(4326008)(186003)(6506007)(66946007)(83380400001)(9686003)(26005)(316002)(55016003)(54906003)(10290500003)(66556008)(64756008)(8676002)(66446008)(6916009)(66476007)(478600001)(76116006)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oyZqsZm6SYs4SKZk1uCBcv6ImwKRCSaQkkOuARabTbKNpku0lII3GWMiwhMZ?=
 =?us-ascii?Q?TTb/XOrMS8vqxv+6KBx/r7XrmzKbULotkqTXV+qDKAKX0d0ZSJqxBlS3sOss?=
 =?us-ascii?Q?ylOnDp+w799aYMOY5PSHePF0BRiGTkrN1Kvo2+9AXtToqj7tlBoDsUFBW2Xz?=
 =?us-ascii?Q?KUodvVBYVghZmAyKKPytl5bgvIX0xURd1zqEUSELUDbOGLMBRVwm6AeFTVq5?=
 =?us-ascii?Q?ZtGb/A38T0NeRHDeOO/XVnMhkCTDQwQwKrD9wAW4Kd6KZleKdJiogfQyCJ1l?=
 =?us-ascii?Q?9+7voG74+emITNoupVRex6NdbMWX3RMX7oZRrHbrWcJRvKR/mfLOssF07xKm?=
 =?us-ascii?Q?1eoZgjAIHyN9UWYnc1ENJfHD2cWVAHM8Ui4JgNBfV3LlzcUN8PM3bo4bYScq?=
 =?us-ascii?Q?lKgVpOQkLhveR42G5adXlDUXy/rvDmolK3Y3WYfowbN2vLXXs58CeToTqY+Q?=
 =?us-ascii?Q?kzXl9ciRU1aIHGAghjA4GBjZeI/nP+dC+qFoORKcEwk0izPIxWMwJKFvnnik?=
 =?us-ascii?Q?A5aDb81+7Bd6jtyq5ANVzQPLJtjMeESKz6ighJQpV8GIbdocJNDkHt4W7qfV?=
 =?us-ascii?Q?Q7EK9zlNw1Ryx0eVWNOON5LZn92dNnBEYzZFiq9tsCJuYL8Gcv8xq08YWgvf?=
 =?us-ascii?Q?XmJr9qX7v3+h+6MY2MuHxh4fz0/AcGj1PxzRcABZS5enfJWFDITiUPePpYu3?=
 =?us-ascii?Q?puiFuLFxrrGtKJR0o7mG+9od2cLA1B832qaqvlf2c4fivTM8VKJmUJ213ilk?=
 =?us-ascii?Q?BzkPDHoE6GBTZRPzJmB46kCJSQvqoKme1a50FJ3NGjJzn6HnH853Rhn530R4?=
 =?us-ascii?Q?rYANByypcWCZ1aHb67BenkkOFMqukMBRouuO40LmIq3wG0OibtcA9Pz0o7KI?=
 =?us-ascii?Q?lA3dagAm3rNsQvY4xR4D+nbYgXJQVGt00WMgzXUAkDWJ5oMZK5blhte4pOwz?=
 =?us-ascii?Q?ZZKJoBb6yxd8KfKFaoouVSj5qXJNOQYalF0tdm4ukhUj1tBGEBSeDCyo8fTI?=
 =?us-ascii?Q?Ivyo7CkQE6IANVPW+CNSyYcNL0/I8rwRkry6mdKYxfOQz3cg7PoTwXA8/T36?=
 =?us-ascii?Q?nogR/V1BGRlegT5Ek5j1b33+EuVQGtIdny26DSPBoFge8bYbNtKvG4D6Hq1V?=
 =?us-ascii?Q?GxU/520SHLLFyEA4LJKt9cBq7lpI4B2Ofu3H44Gg1YzW0/GalgNw1jR3Xw4G?=
 =?us-ascii?Q?24I0bpYRmCUUIvPJqn2NlMvQdYoKzNe2vKuZAmCN04Sz1xvXS5cFz594YEZm?=
 =?us-ascii?Q?Us8DYKQCJ7H14x4b8YcFqPo5brP7G0m/jI6rkvlulz5+H72z+p8Cy/9w6o6z?=
 =?us-ascii?Q?vzoR02bl74zvuUNvDyVNRthxnAB7wHCQBs6VEf+W7FC8r7KaZc/2nUKC6IJ1?=
 =?us-ascii?Q?/LndEGkZw4BHL34IDdg0Nlcb5DTZbi1adkD0C9AOLI1liXkKOOiqQMwM1Z6g?=
 =?us-ascii?Q?YPz9cH+y+qbYsLCbgVhfaCxTF7UtO3JD+trL6KBl5roqfC4atz0FRGbI7I/m?=
 =?us-ascii?Q?Gyo1iE7dVB8ZXJP/1XszDpqDLq+fdTfZ2CfslPUx/3Uti6PV7Z6uSg38jHHy?=
 =?us-ascii?Q?gCgVZBXM2BprV6XrG7l5+wnS4wqiyoNO95BUxx4+Gi2LwglJXuOMAa+9oj+z?=
 =?us-ascii?Q?Iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395c34c6-72c9-4452-fd17-08db2973ec02
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 18:50:06.0108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: azWddMHBRnatfJGuUCMPdyOQHY9BO8u3OXFvmc6NRga/6hNZCIhH5fsdU7p1DWzcTCiksZg3vQLSQlMxuxXf0BOJWxzOCfegxRGHZrXm2B8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR21MB4039
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, March 20, 2023 11:17 AM
>=20
> On Mon, Mar 20, 2023 at 01:30:54PM +0000, Michael Kelley (LINUX) wrote:
> > In a vTOM VM, CPUID leaf 0x8000001f is filtered so it does *not* return
> > Bit 1 (SEV) as set.  Consequently, sme_enable() does not read MSR_AMD64=
_SEV
> > and does not populate sev_status.
>=20
> So how much of the hardware side of vTOM are you actually using besides
> the actual encryption?

vTOM mode in Linux is just turning on/off the vTOM bit in the PTE
to create unencrypted or encrypted mappings, with encrypted being the
default.  There's no other hardware dependency except CPUID leaf
0x8000001f reporting that SEV is not enabled, and the GHCB protocol
(if you want to call that "hardware") as mentioned below.

>=20
> Virtual TOM MSR (C001_0135)? Anything else?
>=20
> AFAICT, you're passing the vTOM value from CPUID from the hypervisor so
> I'm guessing that happens underneath in the hypervisor?

Correct.  Linux in vTOM mode is not reading MSR 0xC0010135.  The
PTE bit position of the vTOM bit is coming from Hyper-V (or the paravisor)
via a synthetic MSR.  Presumably Hyper-V or the paravisor is reading
the vTOM MSR, but I haven't reviewed that code.

>=20
> I'd like to make sure there are no more "surprises" down the road...
>=20

The only other vTOM changes are for software protocols for communication
between the guest and Hyper-V (or the paravisor).  Some hypercalls and
synthetic MSR accesses need to bypass the paravisor and are handled
with the GHCB protocol.  The Hyper-V and VMbus specific code in Linux
handles those idiosyncrasies.  That code went into the 5.15 kernel and
isn't modified by this patch set.

The vTOM case is down to the bare minimum in the use of the hardware
functionality, so it's unlikely anything else would turn up as being differ=
ent.

Michael
