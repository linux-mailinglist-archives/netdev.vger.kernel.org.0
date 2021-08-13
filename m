Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E21F3EBD49
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 22:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhHMU0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 16:26:55 -0400
Received: from mail-dm3nam07on2120.outbound.protection.outlook.com ([40.107.95.120]:12224
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234037AbhHMU0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 16:26:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6g6l9cYis25WihgKlGKU/RZDzLQjOKNlvRAHPr3qeWLroP+nVKXkTefKHtCJYvIKHnQmTMlaBXOQ3GRPa6EXXTGKP9Eh1Y7VaMjMsfrY7Acj0/7MMaX2tKAF0EndebJNjhNBk8dIITXIsrtXjz0CbhbSMYhZASakOTK4C3mZ4VOyMl6ldknmeFgY+z6uIqxTCgmY560r3aUrChk0p9AuD1y0rzLFwHqse4WR/OLP5ZYxdqhFlQe54yw/7HvaSpFoGHrzf/MyNZD7SRvKTg2Ao6tJpuh+vNPV1+HFahiTvRUywNJ0SNb5LiWRap7V7sYPKzgm9fzJeUGOj6N3q+PFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSjZFw4IYdkuV55KvpmYCB+d8Z/zYCy0L7lVeoa3LBM=;
 b=K947ukP0YWv+I2nRFEcIidwNXTLXNVTGv5Z96kLDRrmBSJQJB+pwI7NF4drCuTLNN0Pr61OAhRGh0vR9x5wQBd8fJayjMT4FyNUjfAjvC5spVhH8TyRL8Adr35FZKB5FY4l1U3tkERSWMmJxmOwWzbHEfj6YQbhN6arVypA0PWxCeehLOfMaSAvLCUIxB/KkiUfR+M2APQElmRzCq+0N1VeI7Af9/kQz/tMu7M/QBIHFyfvnTumQV7WBpzVgeNcVj1gCCNeJLx82gnltOaQUa+HU675I+Ig0zV6crusNPtGjcysAULQt5awd8WMavZvY8BTcKcJ/atkjX8XdmtBGag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSjZFw4IYdkuV55KvpmYCB+d8Z/zYCy0L7lVeoa3LBM=;
 b=YuF1pqVifVtgz4pRoMPWPtGqUXVt56tmGUa6QHC62OZv/io67f30CvM1oct8P+C9HuodCsF4xqRldBii0gl4lFqJR77IVGToFHvGg9mavvJWDuVktIYy+2yexJ5VMqQdkROw6NZj5gLXpNd8ELUoLbDIEUvZ0jg7xSRC6DScYdU=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1972.namprd21.prod.outlook.com (2603:10b6:303:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.4; Fri, 13 Aug
 2021 20:26:22 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e8f7:b582:9e2d:ba55%2]) with mapi id 15.20.4436.012; Fri, 13 Aug 2021
 20:26:22 +0000
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
Subject: RE: [PATCH V3 05/13] HV: Add Write/Read MSR registers via ghcb page
Thread-Topic: [PATCH V3 05/13] HV: Add Write/Read MSR registers via ghcb page
Thread-Index: AQHXjUfuQqXPk5/9iUqTH41i8so9wqtxzWQQgAAaltA=
Date:   Fri, 13 Aug 2021 20:26:21 +0000
Message-ID: <MWHPR21MB1593964D1B17870038EC2D2CD7FA9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-6-ltykernel@gmail.com>
 <MWHPR21MB15931FEC5CE9383B385C263CD7FA9@MWHPR21MB1593.namprd21.prod.outlook.com>
In-Reply-To: <MWHPR21MB15931FEC5CE9383B385C263CD7FA9@MWHPR21MB1593.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d2377fda-39f2-4403-a606-910723ff0f1f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-13T18:49:42Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c56698d-081e-41c7-2bc6-08d95e989d80
x-ms-traffictypediagnostic: MW4PR21MB1972:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW4PR21MB197224FE64D6649E7A5940ECD7FA9@MW4PR21MB1972.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w21FqFgu2tAmBXktQZxkbrfccvEy0zOvJN6YSvT1ju7DfH7QkE22lowUbmO4XT2d7T3RLyS7ilggytk6Z1jqEz+VQadXgJm/pA3aNRLVuiV7YKYxf9WbUSgg8VXg9tGX2ccVERe8DE9rM4bIIYzT74X0R+AowG3j7aVCZg1izm9WGwdGY4EH6ItLcJ9h9X+417kzb4tE4lgPkamjzzgfVpT/eEZr/81TaXYiJwbIPXND0yR4magal+2uqWw9gv/MOH6aLo6O6vGGu1N2CTFX3+U5/ZG4c6YHcgVBoA8VMzaWrx2weJcnXwK7OKwQwlI9DSWT2Rwa0ZuqE5D9rWTRNbiFz+7x7+Vz8XSkBW0o1pwmPff3yFoIdR7YMlU+PAMGECfTwJZvorClzv6jV5+gb22Eblc2aRhwQkOaaZwWYq1nYDQ6yspWzxLxZQjDWA/rxhiEMNdC0gUnBsLG6ucebJ96jDhf3ep2tI6Md5CkcLhUN4XIwMIDrUTgRy2lCe2ORlAHvE/lskHzQJC9tX4LmspUEfT1wxtPSL/SQVp72Ylxha5Ac2v6OtkV+Jh6woAqBQtSDQcUUn9ANRfGTTKjjRSGECQUDyDZ7gYUv7WcDHQNC/KYwPDgI8J7qGSnYYv+yPbbh33tm+L4kZ7JH+oTnmg3e247z1rFItDnjSOxV5td3dc3vnnzO84cq2w9kq8aa/sIJb67OhrUHkJvWofW7n4Iad2CGNVf+dddUKh4bx8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(921005)(8990500004)(4326008)(122000001)(8936002)(66946007)(7696005)(52536014)(8676002)(53546011)(7406005)(38100700002)(2940100002)(5660300002)(2906002)(33656002)(6506007)(7416002)(86362001)(316002)(83380400001)(10290500003)(508600001)(9686003)(38070700005)(66446008)(76116006)(186003)(82950400001)(110136005)(55016002)(71200400001)(64756008)(66556008)(26005)(66476007)(82960400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HHnguf8k2A0ke1C/g43w8Bu1Ts6Hdd2fq+nZyXM2Vlyi6iYPhCNPJdZ1Q/Uf?=
 =?us-ascii?Q?M7OqArgQBB8UR0o6XdwdodOF7zMgx7z/7jvA98B2OgTJwKCx/lHgcqJLOOVn?=
 =?us-ascii?Q?RBKnuGZx/E1lp4OzQVoueFJ+5ntLf5oUGdytGG6Su+qy14KLL+7TSyIimCsO?=
 =?us-ascii?Q?Dc0nd44cU9NeOaE0Q66lZma+ShGkLA48A5EVkWpPsuaXCM912tYb5+QkahF8?=
 =?us-ascii?Q?zZYN+b4S71rtrj0yRYKpupMa3GSE5S6er3rX88RBRLKOWyq/Tbmk3B6X4PGh?=
 =?us-ascii?Q?ASYEwimno/wWrvw01ZYctpOut8yEKcP+Z1yuygM6shEo0c0uUeZgn2+rf2xG?=
 =?us-ascii?Q?8zTCBTM7YMT4PL9uyThSLrpoq7lhBSujoZr2uB/s8IstgDBilTT5QCE2TClT?=
 =?us-ascii?Q?jEpRlnVG/bmoWLyrYVzn11T/KQJOg1RmbuEN5X+q4TKz/rvmLYB3+aI43Ybb?=
 =?us-ascii?Q?NzjG+QxU+QZFWBe/st7opXSb5lXVy/DAqWZhjVTFozwNNi14kRWCvZS6s60f?=
 =?us-ascii?Q?gQ7DDuZCyTP45Kb61VTsWTMfJMfeX8SIlueXnAjKpUzF/3jjhzqfvNcIUQjP?=
 =?us-ascii?Q?hYNLXf9Lp68p4UfV3W4Zk3gA+EDZ1twkthiCeikHrX0A8zbLOlO+Gx+ib4u2?=
 =?us-ascii?Q?k1g/+vREUkO6u5gPSErkSYbMuhOyqRSulL8+vOD2JwwobIrFsZlf6dHeGKyW?=
 =?us-ascii?Q?KE/eDArLWCqKVJgQourBtgdmIBkhdj7t2BMejVSXrueAh50B+hbSr8gZpgvX?=
 =?us-ascii?Q?tOF+YxFrQ1WFahpo8vBajPAoBNsSKHTMKsGDmx6zvMIB2QYG6UDG2gTFVrC8?=
 =?us-ascii?Q?GhqhnmeINuvFwbp4vltyTua94yXxQvtRMeJOH82izjCW3mbFhFug2L0rRPEG?=
 =?us-ascii?Q?gfPji9aAsEUvlOSEIT5zUoRbaZiDUl7xb9Hn9haAoigcdr3SEnimFxQgfZoy?=
 =?us-ascii?Q?iPRJB0hY1Vds4TI3Mxd7CT1ySfKGGHL3lAjslHbpRcs0LD4rIf+vz7xtJ3L/?=
 =?us-ascii?Q?xcJlkhRcW9Hw3f7L3XzXFAqA4gS4NZEHAS7oEu2ctO/BoNT8ETdafjMox+S7?=
 =?us-ascii?Q?MADAs+wgwCVYJJLvmkkrY/W2Wx5TGH2zxBt+t/PkldZI+sjy2+359PLPgoWC?=
 =?us-ascii?Q?6StwsXBi5D3gdgiM9qQiiGCU+0WxuSMPoRRjX67KvBFf7UgfGkdfrMYfY1kx?=
 =?us-ascii?Q?MeMdq6Gg24tMu25K7HpB3D6MZrFgF/P+BybXaG7joub9Nmbr6YNzysjwQSd4?=
 =?us-ascii?Q?OnqrceeUQ5xTAeFtIGsE5ubJ+aYx/S3ngKD9AkK6qOZOL+Igy/NE1z3DQs+U?=
 =?us-ascii?Q?EbRyAa4Ct1E4YrOoD6q+8ax4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c56698d-081e-41c7-2bc6-08d95e989d80
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 20:26:21.8499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzWN79PcQkKD4LoVtmx3Si4TxYUrZymDvPd+0ZpDE3+bJuoVwR5oWB8lLB4IMuKobBU2cozGDSwdWjXw577Uj4mz9rpJqZsucZrCN72tcnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1972
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com> Sent: Friday, August 13, 2021=
 12:31 PM
> To: Tianyu Lan <ltykernel@gmail.com>; KY Srinivasan <kys@microsoft.com>; =
Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cu=
i <decui@microsoft.com>;
> tglx@linutronix.de; mingo@redhat.com; bp@alien8.de; x86@kernel.org; hpa@z=
ytor.com; dave.hansen@linux.intel.com;
> luto@kernel.org; peterz@infradead.org; konrad.wilk@oracle.com; boris.ostr=
ovsky@oracle.com; jgross@suse.com;
> sstabellini@kernel.org; joro@8bytes.org; will@kernel.org; davem@davemloft=
.net; kuba@kernel.org; jejb@linux.ibm.com;
> martin.petersen@oracle.com; arnd@arndb.de; hch@lst.de; m.szyprowski@samsu=
ng.com; robin.murphy@arm.com;
> thomas.lendacky@amd.com; brijesh.singh@amd.com; ardb@kernel.org; Tianyu L=
an <Tianyu.Lan@microsoft.com>;
> pgonda@google.com; martin.b.radev@gmail.com; akpm@linux-foundation.org; k=
irill.shutemov@linux.intel.com;
> rppt@kernel.org; sfr@canb.auug.org.au; saravanand@fb.com; krish.sadhukhan=
@oracle.com;
> aneesh.kumar@linux.ibm.com; xen-devel@lists.xenproject.org; rientjes@goog=
le.com; hannes@cmpxchg.org;
> tj@kernel.org
> Cc: iommu@lists.linux-foundation.org; linux-arch@vger.kernel.org; linux-h=
yperv@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-scsi@vger.kernel.org; netdev@vger.kernel.or=
g; vkuznets <vkuznets@redhat.com>;
> parri.andrea@gmail.com; dave.hansen@intel.com
> Subject: RE: [PATCH V3 05/13] HV: Add Write/Read MSR registers via ghcb p=
age
>=20
> From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56=
 AM
> > Subject: [PATCH V3 05/13] HV: Add Write/Read MSR registers via ghcb pag=
e
>=20
> See previous comments about tag in the Subject line.
>=20
> > Hyper-V provides GHCB protocol to write Synthetic Interrupt
> > Controller MSR registers in Isolation VM with AMD SEV SNP
> > and these registers are emulated by hypervisor directly.
> > Hyper-V requires to write SINTx MSR registers twice. First
> > writes MSR via GHCB page to communicate with hypervisor
> > and then writes wrmsr instruction to talk with paravisor
> > which runs in VMPL0. Guest OS ID MSR also needs to be set
> > via GHCB.
> >
> > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > ---
> > Change since v1:
> >          * Introduce sev_es_ghcb_hv_call_simple() and share code
> >            between SEV and Hyper-V code.
> > ---
> >  arch/x86/hyperv/hv_init.c       |  33 ++-------
> >  arch/x86/hyperv/ivm.c           | 110 +++++++++++++++++++++++++++++
> >  arch/x86/include/asm/mshyperv.h |  78 +++++++++++++++++++-
> >  arch/x86/include/asm/sev.h      |   3 +
> >  arch/x86/kernel/cpu/mshyperv.c  |   3 +
> >  arch/x86/kernel/sev-shared.c    |  63 ++++++++++-------
> >  drivers/hv/hv.c                 | 121 ++++++++++++++++++++++----------
> >  include/asm-generic/mshyperv.h  |  12 +++-
> >  8 files changed, 329 insertions(+), 94 deletions(-)
> >
> > diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> > index b3683083208a..ab0b33f621e7 100644
> > --- a/arch/x86/hyperv/hv_init.c
> > +++ b/arch/x86/hyperv/hv_init.c
> > @@ -423,7 +423,7 @@ void __init hyperv_init(void)
> >  		goto clean_guest_os_id;
> >
> >  	if (hv_isolation_type_snp()) {
> > -		ms_hyperv.ghcb_base =3D alloc_percpu(void *);
> > +		ms_hyperv.ghcb_base =3D alloc_percpu(union hv_ghcb __percpu *);
>=20
> union hv_ghcb isn't defined.  It is not added until patch 6 of the series=
.
>=20

Ignore this comment.  My mistake.

Michael
