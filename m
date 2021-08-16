Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B923ED946
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhHPO4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:56:07 -0400
Received: from mail-dm6nam11on2121.outbound.protection.outlook.com ([40.107.223.121]:40225
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230078AbhHPO4G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 10:56:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYPZPBrdoT8R74rquah5lgauhnvLokIe1ecH3IW6S3uPQ7n52fbAAJWhapP8+ma3nufYH/vlSCQumPCHEkpB/nzS/63UiVvh5SzzhRTYZ7KMqA94/GZ826qjWBZs8y1wpokliXyyXQRmzBFmEdsoZtnfVNFw1ekFCVTSJQg4UFdmNia2jKW460YHk+MzxZCG2KfPGWvPxF9Dl+t4v4b4kNu1YfEEksuAhX7+97dB5JFJ9N6/Cg1Qib19kkJc1ZLOyCw4R8ITvTCjguAAAIBy/pyuH085twdARrHuWoGgqliQv8SMYwzdWSJdYnX8f73Zwv9l45FKtNP4CzybOheAtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKzz6N353kemN5JnE9uEYBWK6Hu8GEiFzCv6Noxw+q0=;
 b=akUcDZ6JABkJw9sdzpfnYA2FpUiLGIYRBdlkWit/+cUVYR8hQLOiWYy1onjBdVpK1fRzl+2XtN2Q9SJ0WP6ElZ7iGXgOW4VoPS26JFF746HRRpbgDeqJ3CO8Ua66iPENOzeu7dGP9KX/B129//OShLXJh8VH2JfIBUVfo/gGH9dFfO14crQGetxaeD4anGOIxRlqNvIxIi1zljP7CiJrsQ3wTnFV9bLvgFiXQZMvuyhrGPqjbMgnbQZD4LKxJ7ZfsMZz9kyKl8RrmB8JSkIT8FT2lqFiXD9U6LY3YxExdbxDuQ2GOK+F0+wkWhlYFfnPu1aHiX5Aq1I+lBrh2R5BIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKzz6N353kemN5JnE9uEYBWK6Hu8GEiFzCv6Noxw+q0=;
 b=HcdiBg9E3fV94D/anNUZhTlbtIU9eQJ0+IDKiTZCDbyImD183D1Y5vCKfkOwuulkvcPGF+BK/zIna05Hkdr64cFYPjlZ4+macxrAfuX6PmsIQqWSlE+91rJs9SBzEJge9HJsCwHZbfsoyKpG0OIL5OSaN57rPIdrnkhpertJlog=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1985.namprd21.prod.outlook.com (2603:10b6:303:7a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.1; Mon, 16 Aug
 2021 14:55:31 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Mon, 16 Aug 2021
 14:55:31 +0000
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
Subject: RE: [PATCH V3 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Thread-Topic: [PATCH V3 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Thread-Index: AQHXjUfkLHG5EyKjREma0XuJC95pyqt2O57g
Date:   Mon, 16 Aug 2021 14:55:31 +0000
Message-ID: <MWHPR21MB1593FFA5FD713BF42D4197F3D7FD9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
In-Reply-To: <20210809175620.720923-1-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e5108425-7e30-462e-9c4f-9a4d55c1d719;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-16T14:29:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cb51cd8-4e1a-41ad-3182-08d960c5e4da
x-ms-traffictypediagnostic: MW4PR21MB1985:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW4PR21MB19850244BC52090E5955B0BDD7FD9@MW4PR21MB1985.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LXdGonL+GQ7wkn9qSGEuLb/pD/790fWt7wYOmALo37wzWnjOcZ/Xc3ZLgvqLlueIWCUOvJ/Rj9RwG5baXYuboLTBAiTq9VN0YmcQohZu/hFb6LWPaPmjxZ3YwNbov78fJn+3BYDWUWHHQbkDPBYY/crte26xqnDFgZw10P71Lb1QHCICOr6xJSELER8qs2n/us2UWUeBy9BSESAOnFLP44sQD1L5PMXNXbap4Ur3mRezoa4GxemwECKudpcuq09Gm4xxZUWdnF9+29xNyqgxF1c1rb90CSpCYxZTprDn9X63Kc16iKNi7k/STajc6QQJZsmRXjn1qwDQCuNMAebIBcaR7wpg5TwESXe+IxE6HBD6JN1RPsIuUYh9b4M4KHuIIKoXhY445PkBPooMOGf61QO6Ph3mQ2vC55sWd74VMpWP79v9grwbm7qRQtGitrP4QkVwlAP8pQSRl2CXefZGgdbnk6St7w+gtS2Fl3peUXTVenTr6EB71e14EY5htt4F43p4tdi81OASxYKn9mWcx5xgiSYGI+M3bxXVCPmcr3mlzqOHZmXp2SvGTG91bmQY86srDiJqQ7uTxC2Vhy0qzPxVjJ0ALnIe9dyz04rLwwFxTEUTASgx7xRY4meCoNI3/PYrg73UVn9+5C2cw3PXCX8akPu9HEqWvnLtkdv83LFpxianauK8ldEx4BY6dE0eJLhU5wIAg3q0KPbdGvVSDu5ZLtDl0KiILMD6vya/RTI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(8676002)(8936002)(186003)(86362001)(7696005)(2906002)(26005)(6506007)(9686003)(38100700002)(122000001)(55016002)(71200400001)(82950400001)(10290500003)(82960400001)(33656002)(52536014)(7406005)(83380400001)(66946007)(5660300002)(76116006)(54906003)(316002)(4326008)(7416002)(110136005)(921005)(38070700005)(66446008)(64756008)(66556008)(66476007)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YkqcmjMKPb3HT/QrqCP4mnZgrNiTeEOLvYLS23s/yWEIohQd7vhVvJ03xobV?=
 =?us-ascii?Q?DKTG56hOOAlWa63ymtq2rDk05ToSdxbDZMYouS2yvIAnRnthmBikcVWfBr98?=
 =?us-ascii?Q?2veinR9pm+ofHLqP8xJeL4+QW6y7fQ4iB68wM/K7DdQ0MRPXUQh78Sth4cai?=
 =?us-ascii?Q?36iqIwM+Q5viDsH9Fu8Snc+IHZSnqiXnNEcEWXbxF0vNN+3Zb7ojwLElTsW8?=
 =?us-ascii?Q?8jIr3iFEMX29vauhDKff+P/cRiDT9YMsIEk4D3YxPp0KA16svmW5dNZoEPdf?=
 =?us-ascii?Q?zrETSvhrgKjcS/U6jZCt1b+VoIo3PIlRoU2wAGbI5bVwmISAgYcmqJzzYCP3?=
 =?us-ascii?Q?pOjjqLKr3LlT4xRk4XYID5gyuKIpjLJXZ0GV+O2bWCsCA9qV1qz275FsAb52?=
 =?us-ascii?Q?FKHQlr5KA0ME82dyG1phfAukrpY1ZwA2AVsewLqqC+fDu6G/55PQeTzzgor8?=
 =?us-ascii?Q?7N1mXV+qYHwdzFCQBDH2Bad/4H7WVt24C6oroHjdAangjC1qKltZEMhjOnHL?=
 =?us-ascii?Q?8/HzWNaRtCCvV187DrMRqvjwYTYPVqveayp3LGU4/tb+A6NBy2DN06oPlmOI?=
 =?us-ascii?Q?onLsduZx2HmMOJJxA+uGMGERqIvrKlYuHrBqf7vnAQx1eLJ8Ku7yc4gZCqqI?=
 =?us-ascii?Q?BICj4bMjGS28A9fKQW9/ifwIfpNUa5PqQkKsWC7fwCn1IS5Jv0Rfshv0w7mk?=
 =?us-ascii?Q?uWqYUc0xUEAhch4TnRDuxCYvDEBKji/TpvziimW/TA8eDRwp8tLA4kRzEdJ/?=
 =?us-ascii?Q?25XH+ebiDDKC56cm4NITU1AkvAAEF03u+yfsJmHv+957Rk7Hc1JEh3ocwCIm?=
 =?us-ascii?Q?UyVg2t80I+vIa1v4mzPRJgi4vO3tvc5j6FISY75d/ByjbvfAB4T58nrV0IqA?=
 =?us-ascii?Q?jFMmhLnJw8iJNky8gzeJKIziWxRGlLLJbq3pE9pe7IjyWZl6Pc4322ZM+S5H?=
 =?us-ascii?Q?o2zSIsM6KBNBjKR6EX+ZkBJ/NqVEdc+kBfdp2HuOrhhgVE+9nF836hvX6Hb2?=
 =?us-ascii?Q?czHqpzm26M+r/J/Hk32Asg+TYNVfh6eilGR/jjTFKy78rs61UttZLTYWUu/P?=
 =?us-ascii?Q?+vuudZFW32MewTRkSgukyZGY0n5if4Di5WuqaLCSdOhI2fpxZHQDg9YiegMr?=
 =?us-ascii?Q?Hrbw9JAo/k5uiUfOckSeV4qt9XpgeA8Cb7CG85NcqsyqoRAiscRWuyOC2g5v?=
 =?us-ascii?Q?RfQjq/5HIoh6WG+ex+wqUQ9dGqFsVKzMuxoUxhzSUG2RLATtYnLFc6U/rPHW?=
 =?us-ascii?Q?B7wJQH4mMHEKj/td+ZupRNwCXEDjy4yX8l/Ap0UZQHcksnbMnXhORIMRqnVI?=
 =?us-ascii?Q?uwEneH54fAvzvEtP7wrzth2/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb51cd8-4e1a-41ad-3182-08d960c5e4da
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 14:55:31.1315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mNMDXffLalYM6/VJnYA1mgeiJVxoSvIRZZJOCsjpNwoRTVAC8hlzNEeA3ZwUw1FIB7SuPQJ5Hve6JAKWWDXpfGDppi9IMIpgHtJ4BFsCcR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1985
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 A=
M
>=20
> Hyper-V provides two kinds of Isolation VMs. VBS(Virtualization-based
> security) and AMD SEV-SNP unenlightened Isolation VMs. This patchset
> is to add support for these Isolation VM support in Linux.
>=20

A general comment about this series:  I have not seen any statements
made about whether either type of Isolated VM is supported for 32-bit
Linux guests.   arch/x86/Kconfig has CONFIG_AMD_MEM_ENCRYPT as
64-bit only, so evidently SEV-SNP Isolated VMs would be 64-bit only.
But I don't know if VBS VMs are any different.

I didn't track down what happens if a 32-bit Linux is booted in
a VM that supports SEV-SNP.  Presumably some kind of message
is output that no encryption is being done.  But at a slightly
higher level, the Hyper-V initialization path should probably
also check for 32-bit and output a clear message that no isolation
is being provided.  At that point, I don't know if it is possible to
continue in non-isolated mode or whether the only choice is to
panic.  Continuing in non-isolated mode might be a bad idea
anyway since presumably the user has explicitly requested an
Isolated VM.

Related, I noticed usage of "unsigned long" for holding physical
addresses, which works when running 64-bit, but not when running
32-bit.  But even if Isolated VMs are always 64-bit, it would be still be
better to clean this up and use phys_addr_t instead.  Unfortunately,
more generic functions like set_memory_encrypted() and
set_memory_decrypted() have physical address arguments that
are of type unsigned long.

Michael
