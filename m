Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905813FE690
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbhIBAVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:21:36 -0400
Received: from mail-oln040093003015.outbound.protection.outlook.com ([40.93.3.15]:58581
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229898AbhIBAVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:21:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k83v89YVVc0G1XqbkkLj6dfEwTSojS2fSelG4HtWtU1ErvNnbw40jyjzblBtrkNATS2YsG9I2fHM94o5F7gTPrg0ny+D0wMYqlzjt9gVEKHym5j1sMKXGyDhWi/kDeEsFYQbR/32jRqxhltZnFoUBzpHd3jBt9Crv7PeSVZY2sDfC0+PsFzh8Knca7Ecm+Jh6jMQoydr9piR4OHDALSIRw5N+M4xoD5Z6Pj9lMBuzD+8Fpw2wiqUDg86OnmLiQmTaTS1Jfnck5dyum8oSlIv0Ey9pB0g7PTizpg23ILWZn+MIE/Ukoou77lOrbwWbCR3cZKPJWaupYzyYZdWOCQE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uSAcrrAsaLphArkTow8aPf5W91AfPrV8zL6lQf1PILA=;
 b=HFZXSuxknTm3S2CREWA+2VhMCRMANvuHegWkDgbrBCoSrJkX0DoGM08rOXtpsNkqZKNTyziWu2AZ4gOz5OoohBrZMEVUXilTEHQTtJIpWySnKI/El6N/xYBNjGEiTXx9dyxVp3XvV4Vd8DP/IJxSEoiIrFfc2g1TfoTGUrJr+xVKXB41y33Bv25nQSVK0pWohTmadHb4HKhcaSd+ugHZb0GnVDS07y1noam21lnvriqCH8BnSK57ba8UXmxJ3OhFWV/5B9IlEUxDu1lFJMO+Efub9AkIyrK09eiMi43MgK4gMjvsZmmQyrJYmvfxQoDSWGbCB5xa+lwoWeCsfFllJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSAcrrAsaLphArkTow8aPf5W91AfPrV8zL6lQf1PILA=;
 b=AeuGe5LwAEiMrZh5Cu8Mwsy+8XYsLsfMr0CCy6lIyi296lgyc3vps0FxLTvaSFjbS0uYUHIsqc5BI3nSN+2wuVWKzi1ZpmnrMHwQVxvK0do9f0aeRpi+bkoDcm9WY79tnsKMyYxGI5B8AFd3lf9ni2tgjTkIdDkxeN/6sG9Uy+c=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB1019.namprd21.prod.outlook.com (2603:10b6:302:5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6; Thu, 2 Sep
 2021 00:20:28 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 00:20:28 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
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
        "ardb@kernel.org" <ardb@kernel.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V4 06/13] hyperv: Add ghcb hvcall support for SNP VM
Thread-Topic: [PATCH V4 06/13] hyperv: Add ghcb hvcall support for SNP VM
Thread-Index: AQHXm2f/0mSKj2OCNkCC+r4DaEQmJquKug9A
Date:   Thu, 2 Sep 2021 00:20:28 +0000
Message-ID: <MWHPR21MB1593B1F15B489617F39E69F3D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-7-ltykernel@gmail.com>
In-Reply-To: <20210827172114.414281-7-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6d580330-91d6-4af5-96cd-a8d1305f2392;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-29T17:08:06Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ef6e0ca-5957-4140-2dba-08d96da777c1
x-ms-traffictypediagnostic: MW2PR2101MB1019:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB1019C1F8AA667275B576094CD7CE9@MW2PR2101MB1019.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hh48EIj+igbz1dMXOksKbSyyFrHFlI5LJftl0O2XFLfLUgWQoUQY+o7dG3cKu31K+5Qw055KqyXURz92W1+2KfZnMKi6fBkhlT1YtjLqke2U2qwjHGTTrk2C8Di8BFqsxE340VRpaRxpLqUa0HNwfZIwB8grGSABzGjQKajnFZfCP6ZMyiDwHyuoJXwLLwhci6qoUTePZTEC7YOsUKGRPT0k02KTDRddNI3ZcRZKo5RAcSVaFb1f9kxbHMJZorxewBJxTO37cJnIHbEYmwP+s9zgRaDY1g/lrLcTaM0ueULKPwYbXsX0bfvc28PRA41gwYNCex3cv1tTrVpfZ6gfA21kBWEuTItaZH832AGHqPTd4HXYVUly7MSKFND45t7piGGv3YvrBaU9vif0f2T88Ld04AXSqXU9+KDHvlS+VoKSSVghPyW+Pnrt3jRZqDIb/dr5PA5B9e97lKPfJn24CKl7vakZYKRSa/W2sLAMXpWskUt9Qb+sWlQxArdxzP5flFgPzL510Wsss17jYSOKbWFIB8nUP5AdgAj+QarEa2vVQ+dCMT8DvNfRJv8Tuo1pBkRMPvw5LgGRpvcMdKdePbIFdBhx5GngE+LZYl8FpWO+lBAr1L6SH88ZwgzZ5enyjAibAaIwOga3Q9w3l5bDgHcXQKiajMIuaUvn8aMch6AiXAKzOVsX51nRZ+ptWoBzOu28V9waKu8Mj6VkdejbA9LwFRIx3Bn1V64evmkF2Gs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66556008)(66476007)(64756008)(921005)(66446008)(10290500003)(26005)(55016002)(66946007)(2906002)(7416002)(82950400001)(82960400001)(52536014)(7366002)(5660300002)(7406005)(76116006)(6506007)(316002)(508600001)(8676002)(8990500004)(71200400001)(122000001)(9686003)(86362001)(7696005)(38100700002)(83380400001)(38070700005)(33656002)(186003)(8936002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m6hUatX3Wt0L18oS1Yu9aEWLCF2uuZMJfEdIY7AHScXfuZuS9Vn1i5zr0kMX?=
 =?us-ascii?Q?UyDb74sjV+Y/mJVP7pmDTaxal7lh4mwvOZiQ+VHsLiSIrG2YLVgJhWrr2r+a?=
 =?us-ascii?Q?Scr7JKHoBNz3+yZuxgbPZ1zFJxLGdDtxv6Y0RtMQS367vHuFXdFz04f3D+ww?=
 =?us-ascii?Q?jKgV2pNzpRaFyzQrQbeEfuTDmzNs655TEp/TFFA9YGf4cnyjYzTDOg5m+a5Y?=
 =?us-ascii?Q?S/IH++PysmFJsXjboHB8rN/UXWNR0lpaEoqE3h8UNWvp3lltNcsrcEhykJcJ?=
 =?us-ascii?Q?bAnyMXKIGdQzfobT7jCFyyrPoCFGlMCktNWsBM7OsNqQZT3Wg+TgS1aqpXDK?=
 =?us-ascii?Q?oLXIjMSAx7Q0pu3Ehjk0dAKJM/maCVFKFoY3OVmgmllXgi/WVqms0+m1tU+f?=
 =?us-ascii?Q?J+z1W0iHOMDQub++FmeOuRPgaXHMIRr57ktzcK1awLP9FoBruaVk1YLFbC7A?=
 =?us-ascii?Q?0RFLu73/0BzK/7z+pgSrAoCV2+SVWYyZa2hzyWZ0Ba0P7hLCubCJtoKA6ZRx?=
 =?us-ascii?Q?ltkynVtjd3Jd/gTU+cpguMpE+0eyX66vM8VubA+dBhpLnoE42G+LszgFRAMh?=
 =?us-ascii?Q?+uQjnXszP5rFOGJhddSIK2RlWeSPcwUXl6KMXsjBWR919E0N2yb0fGhgGQ70?=
 =?us-ascii?Q?nLNLetSBMA/oyydd6Sojj/aNxR9lgqya8cVLCNR53YwqO/9LakQeyvX6vj3I?=
 =?us-ascii?Q?qEjf2bmrS/F/P5+fc/RfzTKmQXveg/PgV+FRtYOhXclhfT+4BNeS28UvRXNa?=
 =?us-ascii?Q?NmT0vvuVDsZoLBbpZCJ63MrwsiP2GoS97FxfijKyvCcNJYEMMSx2RYvVc/xT?=
 =?us-ascii?Q?hRWHnNrVDJAjIlzLOeq4B+TTxqxq4N3ZqUEAhuNKu6q/Zf9eJpVB97LL022l?=
 =?us-ascii?Q?xJ1wO91ryKPf8U14K92Yyle6LGG4663Z7+/3zQiDFcD2eOH329G6aWwHuoyW?=
 =?us-ascii?Q?1QOynDuZ9fk6nfDE4uM/CFH9Pl7/ugNM46BidxO1RrsyRTN4gPPj6zdkGLgE?=
 =?us-ascii?Q?IBzAV4EzkqKKO9j6h+M2n+IE23ECcRiPMTyxlrjFEgwn19RwPRxdV4jBqdVX?=
 =?us-ascii?Q?jgRjeyEgAicEeBdwk/iOs17bgx3ovSZxgMmNGixKevcERWyjtnS4EdIH+iR3?=
 =?us-ascii?Q?Zt9iO7TL8VoNLbH8F1Uqdd1nzK3Kup7b+7Li7tdNirudyfm+aTRQbh4dG0ir?=
 =?us-ascii?Q?zl0VAIGENIVsisC2yxxoLrn3pidcN0VOl+BCd8ISSux3/3kKRccNT0QliUHz?=
 =?us-ascii?Q?37EN7y/zvGP+yOt37yjUsOqcpuB0at/dOrdrZ40fn2+e0tIPCJ5XC2ANZa92?=
 =?us-ascii?Q?dI4XwIEaregrSP4uNqlmiQPU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef6e0ca-5957-4140-2dba-08d96da777c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 00:20:28.3182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3eA+qo79/uH9Dbp62BmlOSNm51w8AwVRPXoN6jwWsBsxnooEZz+t3zwtKNtVVlv0ClKDK/DmKF0WXrAsb3MspbKkw+PcOVzmV2MNKBDKP2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, August 27, 2021 10:21 =
AM
>=20

Subject line tag should probably be "x86/hyperv:" since the majority
of the code added is under arch/x86.

> hyperv provides ghcb hvcall to handle VMBus
> HVCALL_SIGNAL_EVENT and HVCALL_POST_MESSAGE
> msg in SNP Isolation VM. Add such support.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
> 	* Add hv_ghcb_hypercall() stub function to avoid
> 	  compile error for ARM.
> ---
>  arch/x86/hyperv/ivm.c          | 71 ++++++++++++++++++++++++++++++++++
>  drivers/hv/connection.c        |  6 ++-
>  drivers/hv/hv.c                |  8 +++-
>  drivers/hv/hv_common.c         |  6 +++
>  include/asm-generic/mshyperv.h |  1 +
>  5 files changed, 90 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index f56fe4f73000..e761c67e2218 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -17,10 +17,81 @@
>  #include <asm/io.h>
>  #include <asm/mshyperv.h>
>=20
> +#define GHCB_USAGE_HYPERV_CALL	1
> +
>  union hv_ghcb {
>  	struct ghcb ghcb;
> +	struct {
> +		u64 hypercalldata[509];
> +		u64 outputgpa;
> +		union {
> +			union {
> +				struct {
> +					u32 callcode        : 16;
> +					u32 isfast          : 1;
> +					u32 reserved1       : 14;
> +					u32 isnested        : 1;
> +					u32 countofelements : 12;
> +					u32 reserved2       : 4;
> +					u32 repstartindex   : 12;
> +					u32 reserved3       : 4;
> +				};
> +				u64 asuint64;
> +			} hypercallinput;
> +			union {
> +				struct {
> +					u16 callstatus;
> +					u16 reserved1;
> +					u32 elementsprocessed : 12;
> +					u32 reserved2         : 20;
> +				};
> +				u64 asunit64;
> +			} hypercalloutput;
> +		};
> +		u64 reserved2;
> +	} hypercall;
>  } __packed __aligned(HV_HYP_PAGE_SIZE);
>=20
> +u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_=
size)
> +{
> +	union hv_ghcb *hv_ghcb;
> +	void **ghcb_base;
> +	unsigned long flags;
> +
> +	if (!hv_ghcb_pg)
> +		return -EFAULT;
> +
> +	WARN_ON(in_nmi());
> +
> +	local_irq_save(flags);
> +	ghcb_base =3D (void **)this_cpu_ptr(hv_ghcb_pg);
> +	hv_ghcb =3D (union hv_ghcb *)*ghcb_base;
> +	if (!hv_ghcb) {
> +		local_irq_restore(flags);
> +		return -EFAULT;
> +	}
> +
> +	hv_ghcb->ghcb.protocol_version =3D GHCB_PROTOCOL_MAX;
> +	hv_ghcb->ghcb.ghcb_usage =3D GHCB_USAGE_HYPERV_CALL;
> +
> +	hv_ghcb->hypercall.outputgpa =3D (u64)output;
> +	hv_ghcb->hypercall.hypercallinput.asuint64 =3D 0;
> +	hv_ghcb->hypercall.hypercallinput.callcode =3D control;
> +
> +	if (input_size)
> +		memcpy(hv_ghcb->hypercall.hypercalldata, input, input_size);
> +
> +	VMGEXIT();
> +
> +	hv_ghcb->ghcb.ghcb_usage =3D 0xffffffff;
> +	memset(hv_ghcb->ghcb.save.valid_bitmap, 0,
> +	       sizeof(hv_ghcb->ghcb.save.valid_bitmap));
> +
> +	local_irq_restore(flags);
> +
> +	return hv_ghcb->hypercall.hypercalloutput.callstatus;

The hypercall.hypercalloutput.callstatus value must be saved
in a local variable *before* the call to local_irq_restore().  Then
the local variable is the return value.  Once local_irq_restore()
is called, the GHCB page could get reused.

> +}
> +
>  void hv_ghcb_msr_write(u64 msr, u64 value)
>  {
>  	union hv_ghcb *hv_ghcb;
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index 5e479d54918c..6d315c1465e0 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -447,6 +447,10 @@ void vmbus_set_event(struct vmbus_channel *channel)
>=20
>  	++channel->sig_events;
>=20
> -	hv_do_fast_hypercall8(HVCALL_SIGNAL_EVENT, channel->sig_event);
> +	if (hv_isolation_type_snp())
> +		hv_ghcb_hypercall(HVCALL_SIGNAL_EVENT, &channel->sig_event,
> +				NULL, sizeof(u64));

Better to use "sizeof(channel->sig_event)" instead of explicitly coding
the type.

> +	else
> +		hv_do_fast_hypercall8(HVCALL_SIGNAL_EVENT, channel->sig_event);
>  }
>  EXPORT_SYMBOL_GPL(vmbus_set_event);
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index 97b21256a9db..d4531c64d9d3 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -98,7 +98,13 @@ int hv_post_message(union hv_connection_id connection_=
id,
>  	aligned_msg->payload_size =3D payload_size;
>  	memcpy((void *)aligned_msg->payload, payload, payload_size);
>=20
> -	status =3D hv_do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL);
> +	if (hv_isolation_type_snp())
> +		status =3D hv_ghcb_hypercall(HVCALL_POST_MESSAGE,
> +				(void *)aligned_msg, NULL,
> +				sizeof(struct hv_input_post_message));

As above, use "sizeof(*aligned_msg)".

> +	else
> +		status =3D hv_do_hypercall(HVCALL_POST_MESSAGE,
> +				aligned_msg, NULL);
>=20
>  	/* Preemption must remain disabled until after the hypercall
>  	 * so some other thread can't get scheduled onto this cpu and
> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> index 1fc82d237161..7be173a99f27 100644
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -289,3 +289,9 @@ void __weak hyperv_cleanup(void)
>  {
>  }
>  EXPORT_SYMBOL_GPL(hyperv_cleanup);
> +
> +u64 __weak hv_ghcb_hypercall(u64 control, void *input, void *output, u32=
 input_size)
> +{
> +	return HV_STATUS_INVALID_PARAMETER;
> +}
> +EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyper=
v.h
> index 04a687d95eac..0da45807c36a 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -250,6 +250,7 @@ bool hv_is_hibernation_supported(void);
>  enum hv_isolation_type hv_get_isolation_type(void);
>  bool hv_is_isolation_supported(void);
>  bool hv_isolation_type_snp(void);
> +u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_=
size);
>  void hyperv_cleanup(void);
>  bool hv_query_ext_cap(u64 cap_query);
>  #else /* CONFIG_HYPERV */
> --
> 2.25.1

