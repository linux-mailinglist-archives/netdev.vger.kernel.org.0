Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4763A46F50B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhLIUl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:41:59 -0500
Received: from mail-cusazlp17010004.outbound.protection.outlook.com ([40.93.13.4]:43006
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232171AbhLIUl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 15:41:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1sTP7X4iLx6IudTRpWAO7By7ZTJZtImeDQOIgLo2ZPbjdKUMThEKgvNG9v3smO0zISJ0HvYSVUzsCihbPss9DQQP3+g76+R6i9gydwuYv7Azuj2PimmtJNWAK9+wcCgLR0+IX5nOtvDj1zRzePDExkLRJ2OBF39wBge4PnvONa1/eoYt6PAQx+8jfVN8ENuZ8bi4l6c7SGv1RAMDQD2DvnC0Rlaih4Dr9YW8zgoiOYOmpSPfIqwzVzgDumwQlL8o7uRbqXM7atAv0Npo1XVC7jNMlm49OW4LkpdHYfuI4mHVEHcR0vtoamimilrJqcl0lZZN+R50tP0Eyr79fK9/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUu3FYSxFeEu/PDLPv7n0CYLdmJU4WXK+GWQshnoGPo=;
 b=ThRkDdTihZVR5Cj+B1xfqN9D8aAE9q7/WOpcmmsoYq10OlWlcCjGYTQKumeRYrk7ftnQ1KeXahKsQ7T65IVLW45705XJHH7ilOX8qP2TOU1igN+1q+iO/UdM3QWAKiOiQbGJacXhLH4ZKOr/cvD09Rm53n0Yh2chLyWQbHr5uEeqzQRbL90PdqHBq4HMskX0e0SIOgY+9jErTLA7/D37C5u7f6JDmqamNsKEnIx15v+e8b4v5ivZWzmg4QqzR030KHr+dMmfcTnOsqoOs1VU+dO6q6/28rhyS6AWEbPoJ/iOuQEI/Y+HnGDY/BZq8RIrj4QOWqTs6gnCq5OAqXDWOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUu3FYSxFeEu/PDLPv7n0CYLdmJU4WXK+GWQshnoGPo=;
 b=RQ2CtIqQsKLQoCPCq0hmZGWgG2wi4Vvux64vdZKZ/NCYQuSLTf3B8BtmL3mJ7PelgDiTVhM4+JjdT8t6dvi4dOtANM2u5Ab5vs+Zz8dVE10yNTquH6p4KPt8BU3TeU0DMIEXhxmOv/iyYZh19PX8wr70KbWR6TupmtQIuN9Qxss=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by DM5PR21MB1830.namprd21.prod.outlook.com (2603:10b6:4:a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.6; Thu, 9 Dec
 2021 20:38:15 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e%8]) with mapi id 15.20.4801.007; Thu, 9 Dec 2021
 20:38:15 +0000
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
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
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
Subject: RE: [PATCH V6 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Thread-Topic: [PATCH V6 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Thread-Index: AQHX6z/mQp7Q97VSdEuLXOO5h6lQLawqnpOQ
Date:   Thu, 9 Dec 2021 20:38:15 +0000
Message-ID: <MWHPR21MB1593F014EC440F5DEDCFDDFFD7709@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-3-ltykernel@gmail.com>
In-Reply-To: <20211207075602.2452-3-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d7a24e5a-3973-44c4-9f44-e13525fb3984;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-09T20:22:50Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4835bb42-e8d2-4109-6cf6-08d9bb53d3a1
x-ms-traffictypediagnostic: DM5PR21MB1830:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB183052B931096E4EE6E9CF1DD7709@DM5PR21MB1830.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jNtvGvx2DevyblKCpubdjy5HovgJeR07X3x2XvjWiaN2STF8BC8EdgxtqCS0o9mJVI6Y97ervj3pcPL68yml8Rm8WbrSMg4wuzMt64o0Gd48hT3lX+RFG42yxxwuxzsdK0xTE/ytSi5mI1jR8pTo1spDdzh81g4uSSMNzhPqrVW5lU1gCkCOLjZ9PdkxWfgIKDXQgGOu81Qa7L6pl6BqL8Bez47a1v2/BB7Km+4Od5zUPFpTz5NS/QU3YM4POBHt1+HojztAedyhxtizNPA4F6mmnHMnCZVfpf3oaA5EKtXJoph71R1zX4Tmz2bplIbhHHUpKizKksX+nCNr5gDIY/+xqlwQzgIW4cJCAqk5E7JsxWKBhhALW2X/KUEwlB7NGXDUTPjWqTmZEYkay0IAc70PsC+f5FxO0dZ5ZESoR1tPj5x/E5DkhPK2UkmCR/sUcbpUV7MZwt16B02VoaeqOcZTXJVNqB+AlodLPrYfJ1epn5l63Mez+K9b1fmkuw6amjQDbcuVSk8GHJ/htUCZdDVArS7Hs1fSKOv/J/ZWqFoWswRpZxYAv37D6xjWVFXltVjKcyjLsHJ2QJCCfV6XrQ0SNGd4EP/OfwtFw05TupD19yKqj+WNDPssrosJ2TYy6AjMNdZVLMv0rsy0hVP00wSWf4vynmNRS/FpjkTkw+2QQQy0u6IyTKfsrxS8dT4l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(2906002)(9686003)(5660300002)(8676002)(7696005)(26005)(82950400001)(6506007)(7416002)(66946007)(54906003)(76116006)(4326008)(122000001)(64756008)(10290500003)(66446008)(508600001)(921005)(110136005)(66476007)(8990500004)(66556008)(52536014)(55016003)(71200400001)(38070700005)(86362001)(38100700002)(33656002)(7406005)(82960400001)(8936002)(186003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: llJBjAiKu3KeusbsQvDmO0C+gCwTlXlWsh47ApIhaFSw+s8oPVXJjmNw3UagCAeq9vCagd3r3JTAqoEGb+9CdiR/owWcEPBreW786P8v0/tlhA6TWilSatVn6ia3bNc4bhbD0S5GbQTp6ZjZetrI7GyPR1SiltuNjWBP4caa+SGhB9uvd5/BRZkQlh0/MwKwYttFwVvEqxt5zHqI4mPGdxwL8qGDdiPGaahc1ymBjnXtPY8u1kAA1zdOL/25kmEXQKNPMcyLEgogJT/+xCUTl/AigjJt5R4Nwrrj9GjbV3QuJsl9CWX6N/dky2Vio8/uTWYJdrchpgTzQNJSUuTEpaV8RXjK6Y+GAGSCbV8/n4Y+GTjlZxZWBeTbOYueu/R9/KYNQ8N9I88GX7rSfzqJoQ1Mfh+LkNHkwh1V4Ew+1HjIqWF6UfsJ8FcTGspfSI/RoQevJN9vWbpo/HdKrOZKuBWA/YLjVzuSOoUIor5kOG11y6gBCDHQPLePMFtuXkfX
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4835bb42-e8d2-4109-6cf6-08d9bb53d3a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 20:38:15.5187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 49YXTI3F8kdCpJ027zXTgoB4dc963a/LlIJn2r9JnCusLFd2arRJXl3snJ5DXPgl0KZ8DdUBAaiY6FxqidYJ2HRv0yYI0V6U60l0rjQGYPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB1830
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, December 6, 2021 11:56=
 PM
>=20
> Hyper-V provides Isolation VM which has memory encrypt support. Add
> hyperv_cc_platform_has() and return true for check of GUEST_MEM_ENCRYPT
> attribute.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
> 	* Change code style of checking GUEST_MEM attribute in the
> 	  hyperv_cc_platform_has().
> ---
>  arch/x86/kernel/cc_platform.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/x86/kernel/cc_platform.c b/arch/x86/kernel/cc_platform.=
c
> index 03bb2f343ddb..47db88c275d5 100644
> --- a/arch/x86/kernel/cc_platform.c
> +++ b/arch/x86/kernel/cc_platform.c
> @@ -11,6 +11,7 @@
>  #include <linux/cc_platform.h>
>  #include <linux/mem_encrypt.h>
>=20
> +#include <asm/mshyperv.h>
>  #include <asm/processor.h>
>=20
>  static bool __maybe_unused intel_cc_platform_has(enum cc_attr attr)
> @@ -58,9 +59,16 @@ static bool amd_cc_platform_has(enum cc_attr attr)
>  #endif
>  }
>=20
> +static bool hyperv_cc_platform_has(enum cc_attr attr)
> +{
> +	return attr =3D=3D CC_ATTR_GUEST_MEM_ENCRYPT;
> +}
>=20
>  bool cc_platform_has(enum cc_attr attr)
>  {
> +	if (hv_is_isolation_supported())
> +		return hyperv_cc_platform_has(attr);
> +
>  	if (sme_me_mask)
>  		return amd_cc_platform_has(attr);
>=20

Throughout Linux kernel code, there are about 20 calls to cc_platform_has()
with CC_ATTR_GUEST_MEM_ENCRYPT as the argument.  The original code
(from v1 of this patch set) only dealt with the call in sev_setup_arch().  =
 But
with this patch, all the other calls that previously returned "false" will =
now
return "true" in a Hyper-V Isolated VM.  I didn't try to analyze all these =
other
calls, so I think there's an open question about whether this is the behavi=
or
we want.

Michael
