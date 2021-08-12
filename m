Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781543EAC40
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbhHLVKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:10:43 -0400
Received: from mail-dm6nam11on2124.outbound.protection.outlook.com ([40.107.223.124]:17761
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231270AbhHLVKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 17:10:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAFSKyy1Wwq/aEngCLmKgpGO2v96s7o6pZWUYhj47UfaYAtb1nFXqb93lAZ91LCDOWMsRzSbmk6fWcddpy1oRJEqS16alKnMNW18YDDSYSB8o/+K1+ldtqscgrnkF/fLmt5sD+wkE0THUviLZZc0BY87/Lsdkh8x0btJM3nC1RUijQrPpfr9TaJ6EM7OouRkkg9kg0Zr0PwTdBcK34UbrMy3hYg0h9r6nJsaFNAQEN/v+Z8Za2YTvi5xzx6MhLxbz0IS7IccYdozJjK+uNkZsCf03QusKYgaRcYG1YXK7xhea68dJ++pzN+uwuSkXrMdwRHc+NDjn4K1gYZKJaDi/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0YAk3Z5trLg6GO81eYdvJZXwxwS/QbJTJ56Ic4R8to=;
 b=foSgRqY7+JhYQLI6VVBfOorAAH9l0EcRJlh+F9LDo6Oaww4OyLyRUK+V2hyP5qF+aoaJHiHgqO3d6x9oNa2X104/4lQoWufQBrs7ZTh6QkIkvT6jMKH2MYqLx8ASOsDwbFe00NXEWqyZBnXwrLpn7HgSBPKjEe0JAWqMcm6iotGbsflg+o9sZQZpxbxNNYNTQ2qB4mtq0H9jv7TVgIU7fl/3VwFQ9eCz+GxA55tSHUnqdLKr9upbDlS/OyPvZucnbSM/h+6fyOWh8ookHUNbVyx+c4dxthlZnMAK8zOcZkw7sH2mDgmxO6PCs8CwrZKbiy0BDvBPsIJLAa1qNxiUTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0YAk3Z5trLg6GO81eYdvJZXwxwS/QbJTJ56Ic4R8to=;
 b=VfOrovqCfHN1M+Ezsfdr5sd6q2oV5uxX+TBB0Z7PN8ZU5F6R7VBPwmXFZ8iwja+GSwzYAhi5+rVGCK3LpGfrMvLaLROUX1SuIPJlXi7iqI0sOfnhhJdbAwVE3kWJJnLRkiDDnvdUW/1+38PfCaJuK6+mtu70uvGPABlgvscZuII=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1972.namprd21.prod.outlook.com (2603:10b6:303:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.4; Thu, 12 Aug
 2021 21:10:03 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Thu, 12 Aug 2021
 21:10:03 +0000
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
Subject: RE: [PATCH V3 03/13] x86/HV: Add new hvcall guest address host
 visibility support
Thread-Topic: [PATCH V3 03/13] x86/HV: Add new hvcall guest address host
 visibility support
Thread-Index: AQHXjUfncf0WY7cz0E6uX1luWMHXpKtwXLrA
Date:   Thu, 12 Aug 2021 21:10:03 +0000
Message-ID: <MWHPR21MB1593764639725AA5B777F8DAD7F99@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-4-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-4-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=467437d6-f82e-42f0-8c74-6bc6e6910b3c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-12T20:50:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c40f350-fb33-4410-9cf8-08d95dd58db7
x-ms-traffictypediagnostic: MW4PR21MB1972:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW4PR21MB1972A75CA89454C6D0972EF2D7F99@MW4PR21MB1972.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZH2QQTQ5QJlpRKPh9NNo3oZVxP+pmVI/xNE1unAfRsXcr9a7E60vukqXaEOk3sqMcC++8qdG2dhq5gmb+yPVZoUHxY6T2Ck3GD1FTVazmCb5a7sC4u/KVTGmL7gllnqsFjg+qfIWr5v5wmH4qxh9dWecVZsOewrjr2eRou75SjhnaqoE17cpSEHOHDieZbFHTZq6GATOrzISwcWQcy7g3Mcz7qRdvFbqstkKEOlX9T2q5vVpPvcQ1eLY3p50nLH5qz4Iz0aaVRSWwdQFiCWPR8FgYl23/2M+W2WSylhSIM4IjcSid2sdDMWlFMhOLTUcia6yhqKsN5rrTiZNi9ZWfQ1VBweHyXoFgmsZ6HbbT3OMroIR3/EwU8sjy63AnbCg2JYen8JvTO5oc2gWquOkSAdWb40pkRg3DrlGxEYjJbVSAWt2Hjo8+rgpyubDJyUHDo6nxkw/M/WggrJskW8PzjP+Fyy/eFBTs+THKHUonNjvEraX2UxJoASiIvHtSAEj7tNuIZB3KatA9uVi4nLvVd8kURDxPohiTex6dMYYNerRutxP+XFAHeoKcNdJlGYnHe3ROkWdAtnGGL05Ha1VVv5ArIlDadULltsA8b6xdYovTyt9rZYztLmkXay5OD9i6UO4JGCLZ0MKWjOG3Lpe8S+5k0zOejk4+g7H/f9IRcANswHAekk5gH3LpsUR2mOfV9rLHOY0C6zORLmT5TZhLKxRwuGz/Vye/z3ZeIf5ihzBwiX8nr9B3bEq6r5Ou+Sr6Nntt/f0IjG+Sn2v2aJ0cAnBNc7dV0AEJ5qsKDxycu+DZRvheCn01XJgHLKxXk4r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(9686003)(38070700005)(82950400001)(110136005)(10290500003)(86362001)(316002)(71200400001)(64756008)(66556008)(82960400001)(66946007)(8936002)(66476007)(54906003)(26005)(66446008)(186003)(76116006)(55016002)(2906002)(7406005)(921005)(4326008)(8990500004)(5660300002)(7696005)(122000001)(6506007)(33656002)(7416002)(38100700002)(52536014)(966005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GFUPMdIah5HICk16JE/lGvZF9aDaDEAoaJR3dV1rTGvzhQe0GLD0bT1S9VGp?=
 =?us-ascii?Q?d3Tqq21ulLg59jmxst86678vsocurFjDr38mI8ArRilM+NuZ/ZBE3oCbXfg6?=
 =?us-ascii?Q?tSmeDaF6dnko2fsMJK8YCE1Wo8wObavhrcDqPgdDJXbnlKdlNaolTo1Lxqdm?=
 =?us-ascii?Q?9SVFP4xhq2wiuAoBh0MbXYKrEVIP9OBrMLZe9CWinoPZPXpXOPm6FEUsy+Tx?=
 =?us-ascii?Q?zGG+HiLxcg0fN8E3ceoLPSXk7OrzNS/g7WaE8DYurq92lRV6oBcFX0E7rteH?=
 =?us-ascii?Q?Q4/48glkXSTsnulh+GZR88yEs/60Ip3FTfsIJK10xSCRVQubNAlhRqLDUjka?=
 =?us-ascii?Q?Olj+t9pw19CFaChsyhDSVA6jGTaJEBxLL1HjdODhTIqsMlzs37tEiMmODfOa?=
 =?us-ascii?Q?TJeAUq7pPsN4EDQseiPUVHtFqLnBvoumoUOMd7XdEBRZQa7s3ktJYa4r+qMW?=
 =?us-ascii?Q?UdJPdYy+MwfaHouDObdYVGRtWsfY3Knmw7nhfJ2xjpo/Xy3fkvk9xmg+foO7?=
 =?us-ascii?Q?mPdDX63HLFjAmCNKz3Dd8NMgp3Yv+ZDS3IZ2nvNY1QJIyNedBBZZBc42yYRk?=
 =?us-ascii?Q?rnt6ymQvmkqZMW8hWhFO/iY+EJVw0tcV0p0iR17DxUukwCmscs3yuTxraJqV?=
 =?us-ascii?Q?HZlIZ73j3g4k1dtudPGnZx+ytnVnIweycbQaxDx+4aPT85ERd2DyZ91aWkQE?=
 =?us-ascii?Q?F0xeDebGZ1zVZFnmde2zQQc+ejtbPdD2Imk0jDHaPhAPBg4UPcDpHVWk8eQm?=
 =?us-ascii?Q?xHGtYyLYX8j79NA3l9WIw02AFxNHyDXNGQ76Q3zNc0aBSZbMLNrKHf5o6TKH?=
 =?us-ascii?Q?HNfySZweqUNjTcZ5mU5dvJgo20qN7HCl7/6Db+sTKPYwTnBYAYJKi861PCnx?=
 =?us-ascii?Q?PTwDxa5mSWcTxTL7oVPZVr/xZeyFPjMAaW+ppXvi1f2xlkP9EtPWXvNFwyQJ?=
 =?us-ascii?Q?ksMAJ1IO9uj2adk2aqI4iVZHCdKygts9ek6WH8PBdZDZqiD+6gm7TUttKTt7?=
 =?us-ascii?Q?IkVURoAAH/NzIghhzONXb51+5cMmbByVPMM46z9mg0YBrbm7VnWpWSpwEVEh?=
 =?us-ascii?Q?c+3Qc53qtZCwIC1js6FKMhhaQllVetUXn5yXL6KZWFsNMlO2rLh1Z2oEZnRr?=
 =?us-ascii?Q?8URRNZAcU3VVmQH5Gb9hUy782PmTFWQbhIK2T49Jb6zsblblqk/3zmuX/H/r?=
 =?us-ascii?Q?UUVbPM8J5HpWH41t96kPhHbW+zawrigAyez9LOf8VzjUIqjk/o/ZZ3+Q1cKH?=
 =?us-ascii?Q?9ygpENM+pyvRjqZRhi8yT7mxpRNvOKIzc1Z4y3QFKN4yIcMCbW0s5fviPz3G?=
 =?us-ascii?Q?gDnO6Z20w1pIOmKvJyZtMCIi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c40f350-fb33-4410-9cf8-08d95dd58db7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 21:10:03.4015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bHTYbuxmShv7X3eptuEZ2EnHpyfYQCQZ/KOGBMymmy976HxPEgsvKyXHDX/CgTA4Djc+cG64qiZPGYbPeoFiWOVqJo6C/gJpYF9zJXRwWjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1972
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M

[snip]

> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index ad8a5c586a35..1e4a0882820a 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -29,6 +29,8 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/hyperv-tlfs.h>
> +#include <asm/mshyperv.h>
>=20
>  #include "../mm_internal.h"
>=20
> @@ -1980,15 +1982,11 @@ int set_memory_global(unsigned long addr, int num=
pages)
>  				    __pgprot(_PAGE_GLOBAL), 0);
>  }
>=20
> -static int __set_memory_enc_dec(unsigned long addr, int numpages, bool e=
nc)
> +static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bo=
ol enc)
>  {
>  	struct cpa_data cpa;
>  	int ret;
>=20
> -	/* Nothing to do if memory encryption is not active */
> -	if (!mem_encrypt_active())
> -		return 0;
> -
>  	/* Should not be working on unaligned addresses */
>  	if (WARN_ONCE(addr & ~PAGE_MASK, "misaligned address: %#lx\n", addr))
>  		addr &=3D PAGE_MASK;
> @@ -2023,6 +2021,17 @@ static int __set_memory_enc_dec(unsigned long addr=
, int numpages, bool enc)
>  	return ret;
>  }
>=20
> +static int __set_memory_enc_dec(unsigned long addr, int numpages, bool e=
nc)
> +{
> +	if (hv_is_isolation_supported())
> +		return hv_set_mem_host_visibility(addr, numpages, !enc);
> +
> +	if (mem_encrypt_active())
> +		return __set_memory_enc_pgtable(addr, numpages, enc);
> +
> +	return 0;
> +}
> +

FYI, this not-yet-accepted patch
https://lore.kernel.org/lkml/ab5a7a983a943e7ca0a7ad28275a2d094c62c371.16234=
21410.git.ashish.kalra@amd.com/
looks to be providing a generic hook to notify the hypervisor when the
encryption status of a memory range changes.

Michael
