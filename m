Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC40960792E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiJUOFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiJUOE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:04:57 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022024.outbound.protection.outlook.com [40.93.200.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804F4501B1;
        Fri, 21 Oct 2022 07:04:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsLfEeptk+/s6utk/GBGHD8k15WWGJJBoi7WhQzqS+WzJruscUOal3AuwnvmlhHhNPAqrcaL0kWN/2L093p9v5K09uBrGUKvjXlWMniO7VcKTNDzntL12OYKSEbJStZhs4le97QzXIQxuaq1s3mfIq56jSQG2ku9xu5hN3bqwdjfa/VVlr0g5fkviJ4lQZAIYhSxBIAPL6hXRlAbt4edkpMi88WmgST4IOEaMeWjGjWU3h6rHjVytGxmTKGxX3lDZ9agwXfbBEBg7WLzlE43k6Ctz88RbSYfSrC22e/jagDQQeqbvOqFjdfrsOfvrF6lSBQn1YF+vRZ7lCknnOS3lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/HpdaHK2pUaI9JDG/wCYtJpF9sNzdQkPSbxIUaM818=;
 b=f7Gide63hlEgCm55XfMJD24uqToCnnsExUaf7V16NADzxddgM0AL4tM1JcqD9xhuNRkhEsuDIYNv26ycQdZKBvU64xXMaEWk4wn7aJcm2tZJ4KamAqejJUn4IO+tijxrTn6EFBt+EFlR22+3Te0yO0h8QwKmcL+ws/cpnIIi41T5Q/ELWwxbrw5vreTq2jDR7cF91DHDmMtM9MWgWZdXKeAbZYUXhuk5ysYPMlCq+85CEBIjPMePoC/3Q0KXcQX9d+fJFx8y6xPij2ZzwgzGP4A6aOrIubLo15FtMQ2AwGFoWwG5fa/kT04TkztWZ4BYh/F9/R+H359voHXa02fEJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/HpdaHK2pUaI9JDG/wCYtJpF9sNzdQkPSbxIUaM818=;
 b=QFmbb3hx1t2zc4a27WCR+8pGg840S9YS29WUGEjrmB2rbq0CWmmNR1l2Zqt9mdeNPNH8IQLey78+PXPpT/HNvaQCXPmUxnJxR+FwYu11HsCnaHhw3MYgeUO4C5vxE5q/ZykIExv3Ec/xC3Rk5xCzF4OcPY+uFzys0GqlEmeexZk=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3692.namprd21.prod.outlook.com (2603:10b6:8:92::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6; Fri, 21 Oct
 2022 14:04:52 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::f565:80ed:8070:474b]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::f565:80ed:8070:474b%6]) with mapi id 15.20.5769.007; Fri, 21 Oct 2022
 14:04:51 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Subject: RE: [PATCH 11/12] PCI: hv: Add hypercalls to read/write MMIO space
Thread-Topic: [PATCH 11/12] PCI: hv: Add hypercalls to read/write MMIO space
Thread-Index: AQHY5K2aiO7H3wTya0WAgYUxXMGXe64XpC+AgAE9nNA=
Date:   Fri, 21 Oct 2022 14:04:51 +0000
Message-ID: <BYAPR21MB168877CB0C775A89F6B9DDA4D72D9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1666288635-72591-12-git-send-email-mikelley@microsoft.com>
 <20221020190425.GA139674@bhelgaas>
In-Reply-To: <20221020190425.GA139674@bhelgaas>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e4eac2cb-c74c-476c-94e2-7f7fce9f444a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-21T14:01:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3692:EE_
x-ms-office365-filtering-correlation-id: 22da442a-f870-4714-e87e-08dab36d3926
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CE2tB3ifGVAsbbi8ypiyCj6wSW6gJgr4Sb6WTaVpOezmuFRQhOSZ0wQGeVtavlTjByYFGLmEuVqGZ86GbVNfxFEgzKD5SJm8r9xbCCRAp4eacIwj3CD3oAkrjszWQrCwg7woECDG2PZDURU5gUpvBSQjCunxotpgfwQaCKa0AHRghZTw/VKjuWr4D3u1xiy/SpkJczZsYgzchGkHpCkzujl9BLyBQV1GTocWrwAjOc3ibrjOsOR7a25IdJ+JARkqlE6/JwV/PAsi0cNVvhtXDDDWmns0gSPWlyts/Mlg89u9ojyB3paYFxAg0+NHtqxiG6K/zMH83g0511GjB4g5vK8XDwXnprxXpY74fVZD3fa4N8c72VCJgje60/1BfaSSeCBcGWQz5qtYpdO4h+a230NLk5thb/7jeUjDU4EtoezG5LSrBio2IM9JfQlbPuhVEMDfkHHQ4yEx9VYXSvtMDdIZh+T5xX/pdml/weD1KbYwSO3NSGSVSuiHFkfTCeePNLGGQTtVbCBFhqgGx2vtQVECh/H6dbvNE8jQYwW2BsjdaElqQvT7QPU0Qkl2l85/tdVAjI9j+jUSTLbpPr5MO5HyxB9t+PGDOxn85poLChct4IOuGuVIFYN09hVaDJ3OVsuTIALIoF4y2/w2UjCUK/RC8fmPeS6NsCs9wWW4KWbFnN3GI8obOAhuVkohdpkaHB4429UQP0shmEFLJ/CbouPMd5lgvLFL3+aWfwN++eeySvKkAVsOR2gHscYuI7h17HotEeV7to1otnRx7EGBjyO2ESfiKiTEeiidEVCkhGOcSbzrmT+3E+83sesI0nFj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199015)(8936002)(82960400001)(86362001)(8676002)(66446008)(83380400001)(76116006)(66946007)(186003)(41300700001)(7696005)(316002)(122000001)(82950400001)(6916009)(478600001)(55016003)(26005)(6506007)(71200400001)(38070700005)(8990500004)(52536014)(4326008)(7416002)(9686003)(64756008)(66556008)(2906002)(10290500003)(54906003)(5660300002)(33656002)(7406005)(66476007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yu7WIEtDlE+jV+hW334cJvQihs4EAFmRiSW3vzCurskUaiGZKtEz7jFOdycy?=
 =?us-ascii?Q?bw/DjGZtOb3mru2EdhGThps5aI41EhRq2GMs+VcVWgCj/Yw0KDqKV33STFgX?=
 =?us-ascii?Q?Y6lZYwRAJY7WQ8Y5/8wrxGXSkYNzKTijHlj0zGR9k9UO4HkPT5QLg2Q8YnfW?=
 =?us-ascii?Q?sFrVwbd+2cpaoJfZfabInVdb3+Sm8NTC5t4MKxSEhcvC5TWpWDEZf/KXnlxx?=
 =?us-ascii?Q?IcUK/3dN/nRO1ZImU7MNbHpWNx87MNczexGVor0uP76IBsmvEe7freLCBaDs?=
 =?us-ascii?Q?ENFXUC/L3woxn4ll4rLNr6eiY34wg6phGohMYjk6fsVsxAposhMxmurxgRAQ?=
 =?us-ascii?Q?jlTwyoTB1klWtnH7E+cqLRkghxPZbse+pTH4n584Y3wwlJKl/TFVT9jPgKop?=
 =?us-ascii?Q?uLUnE8iGeDAlBDR3NpopHEDp5J4k/G/iMdmySIT/w2B8R1tkFbJD3JGaT+r8?=
 =?us-ascii?Q?JM7P/PCvVIhSAILsrPJQNgiN20n/a3sYH+KeHdFuhdbkQPg5uh5rhbTts/h8?=
 =?us-ascii?Q?84NqYKOhBHDHzSeRul7TNSFTjPoPFrL4sTfh3brJaWYipSiO+2zjkZOmtwIn?=
 =?us-ascii?Q?ZeVVjwuseLanOhFXGxgzYqYHKYGxTpIuqAjL7U1IReGYchgAHZ9hWRO/UOxE?=
 =?us-ascii?Q?VocqREoadfLz4vxPXc1b6NS2da25jIGFI07abAI0pjL+GCxg61J4lapMDGUF?=
 =?us-ascii?Q?PrxmDvgwZPhpqTF7W4nLY1eiHAqBnRFoHogn1wYDdsieA5Zzfo6+dMwhRCZh?=
 =?us-ascii?Q?vx33zHT4VWpK0Dtf0/aRfylGdiGDy5lTnWNVKg2rJcRiSdAKPlYhLHy3vU26?=
 =?us-ascii?Q?GXZxCo/BzswAs7DngCDDON+nBwQ10wsZw2MHRtAZOOJKrMWtoqqzUtGq+wTE?=
 =?us-ascii?Q?uixvCUSgze/f2ATXHY+95wyKXX7+DLYuWbZrWS8RUf4usevwqGOOTiiDS5gq?=
 =?us-ascii?Q?+avdfRzHocxKBvlYLA+dQR8lFpXXLR29DDGIXuJpzwGr64pFpQmzykO3l9cA?=
 =?us-ascii?Q?6SBzom6gvNQuTXXesi/YIqImZDlmSwJPatxHtnTWrArwVE3+IelKCE4F//yb?=
 =?us-ascii?Q?dn6wAf5IfDTGnU+h6PrQBLvAT/Eik9ucRZKOeDiaF0ipoWvwaVrVfyYJHDNH?=
 =?us-ascii?Q?gBttCTpIU6fHJQONt6xHAEwN23bHgH5Zx02PkyUp39ZiuZOe/UnEzm53xjQM?=
 =?us-ascii?Q?TOXJrXZlVNz5CoO7oZnsGi8jrw3ZxVVS60lV+yLK03Z1vPYer2kMWhg1oNVN?=
 =?us-ascii?Q?8qzreIR/g+ZM2C0fmauFwXgrSGGjnWvig57MjgjZL89CpnPwUOE6BrQdVtQi?=
 =?us-ascii?Q?oB1DJTG+eLoLoAYWm0eQBdPlmZzBK/m1BbbobaBKdybu1tnN3vOhF2YHK6Eh?=
 =?us-ascii?Q?lBJGRCyEuS9rroC692hxw1i0IrrH14+px/OP8i3LpAFPW3FPMS4Sd27oH0lI?=
 =?us-ascii?Q?rfuN23oclGQenuGBjCo0LTBGWCE0HXV2mbYd2FSv7B+H99AbXmOLn8CcN+in?=
 =?us-ascii?Q?I7NZNaFORBYIXQjJu8O/wL8s02EMsmg7g6Ufis628TTc7NGn0rfiZMnu2Hsu?=
 =?us-ascii?Q?q+7ET0CiH+hUEAx9wS+ny16ZTAjwmhXgTT/+wBoHOgPUkKkp89tRHmbx5mwl?=
 =?us-ascii?Q?+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22da442a-f870-4714-e87e-08dab36d3926
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 14:04:51.7379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6sBwWfbTBvkJ11ZHmezPruEIZwlu7Iy+xQXpIvw03pmSF34jpzMq+HtzG0Aup1CeU7gY59v0JkJetmNKGVgAtnKWWnmeLrtD4monKaN5PTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3692
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <helgaas@kernel.org> Sent: Thursday, October 20, 2022 1=
2:04 PM
>=20
> On Thu, Oct 20, 2022 at 10:57:14AM -0700, Michael Kelley wrote:
> > To support PCI pass-thru devices in Confidential VMs, Hyper-V
> > has added hypercalls to read and write MMIO space. Add the
> > appropriate definitions to hyperv-tlfs.h and implement
> > functions to make the hypercalls. These functions are used
> > in a subsequent patch.
> >
> > Co-developed-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > ---
> >  arch/x86/include/asm/hyperv-tlfs.h  |  3 ++
> >  drivers/pci/controller/pci-hyperv.c | 62
> +++++++++++++++++++++++++++++++++++++
> >  include/asm-generic/hyperv-tlfs.h   | 22 +++++++++++++
> >  3 files changed, 87 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/=
hyperv-
> tlfs.h
> > index 3089ec3..f769b9d 100644
> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > @@ -117,6 +117,9 @@
> >  /* Recommend using enlightened VMCS */
> >  #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
> >
> > +/* Use hypercalls for MMIO config space access */
> > +#define HV_X64_USE_MMIO_HYPERCALLS			BIT(21)
> > +
> >  /*
> >   * CPU management features identification.
> >   * These are HYPERV_CPUID_CPU_MANAGEMENT_FEATURES.EAX bits.
> > diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controll=
er/pci-hyperv.c
> > index e7c6f66..02ebf3e 100644
> > --- a/drivers/pci/controller/pci-hyperv.c
> > +++ b/drivers/pci/controller/pci-hyperv.c
> > @@ -1054,6 +1054,68 @@ static int wslot_to_devfn(u32 wslot)
> >  	return PCI_DEVFN(slot_no.bits.dev, slot_no.bits.func);
> >  }
> >
> > +static void hv_pci_read_mmio(phys_addr_t gpa, int size, u32 *val)
> > +{
> > +	struct hv_mmio_read_input *in;
> > +	struct hv_mmio_read_output *out;
> > +	u64 ret;
> > +
> > +	/*
> > +	 * Must be called with interrupts disabled so it is safe
> > +	 * to use the per-cpu input argument page.  Use it for
> > +	 * both input and output.
> > +	 */
> > +	in =3D *this_cpu_ptr(hyperv_pcpu_input_arg);
> > +	out =3D *this_cpu_ptr(hyperv_pcpu_input_arg) + sizeof(*in);
> > +	in->gpa =3D gpa;
> > +	in->size =3D size;
> > +
> > +	ret =3D hv_do_hypercall(HVCALL_MMIO_READ, in, out);
> > +	if (hv_result_success(ret)) {
> > +		switch (size) {
> > +		case 1:
> > +			*val =3D *(u8 *)(out->data);
> > +			break;
> > +		case 2:
> > +			*val =3D *(u16 *)(out->data);
> > +			break;
> > +		default:
> > +			*val =3D *(u32 *)(out->data);
> > +			break;
> > +		}
> > +	} else
> > +		pr_err("MMIO read hypercall failed with status %llx\n", ret);
>=20
> Too bad there's not more information to give the user/administrator
> here.  Seeing "MMIO read hypercall failed with status -5" in the log
> doesn't give many clues about where to look or who to notify.  I don't
> know what's even feasible, but driver name, device, address (gpa),
> size would all be possibilities.
>=20

Good point.  We can pass the device as an input argument to hv_pci_read_mmi=
o()
and hv_pci_write_mmio(), use dev_err() instead of pr_err(), and provide the
gpa and size in the message.   This is one of those errors that should neve=
r
happen, but when it does, having the additional info will be helpful for
debugging.  I'll do this in v2.

Michael
