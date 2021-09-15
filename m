Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FB940CAFB
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhIOQsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:48:24 -0400
Received: from mail-oln040093003011.outbound.protection.outlook.com ([40.93.3.11]:45638
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229489AbhIOQsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 12:48:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpXMWDJWITqLlHVuVUlYkGNdC5zpr0MKrRTLiu7PxXfOHYPqUdmzQNOK+VDHRDdnaJz01Zl0c+562eTkkvq0R6wNXrhU1nLbY3xczKq01/daRhqO4LKNHcl3Bsni8GjTIeqrzRTvJtGqX6ORBg8haFA8oB/hTQ0wE/JxarZrzfOszCtf4F0G1QIrFHYU080KTRBbUh1tUBmMbd+DOFBCUvDvHlll56yl2QEbqm+fZdSZbnOXZS2iWHdCGxQII2YSFjvtXgost/8fLZn8oYTWfPNZLjcYTLFusppsgo3VvFgY1xwfmTDvAc4zRoApxCYrPwLG3b55W9aDb6Gyl++a3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kjTAfamJN+Enx+YU2cWRaztjgL/WJp+2S1JsOQ69j48=;
 b=CHkdhF7/0Tq3At5Xe198lDtLqc28PZmOjFBy+Y1B5I2Zr1tu6wIsOs2ZDdpDoVcsogFaOoqDTCRYh74+nQAzGDmczg1jpXaYdrjqPWfWiGuGOUFQYUVesVHn3cjzINX53zYkrPdNCfjJoDNisCuASQhW8lVNgMLiUbtBDBMHiJhmMGLETSBf3XVBYleO0vQjFZJtSsA5ZOFk8VyBX5XaDGhcrmiBB+Tcm5nOnTH4mU972qRLol90SZGNWb0O888Aoq2cJz1AnQ90bJmqzrZQC4gFfkyjVheXfhdVbeVk31UmxscngwTzKvgqYEvtXWhezWPI+BQClyQe1yZa20i5kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjTAfamJN+Enx+YU2cWRaztjgL/WJp+2S1JsOQ69j48=;
 b=WGxDtOIHHtg9DTaJGq84oDMuvZDhrqCE52/DZ+mAONT93w8N/L9H46mTdPGe0plm7rfGfD4TojdeP4QMpwPE1TVCvuQIkNlAgp50N+MOz/phMdKULz9HE+b3IWL6DtEj1rRZ0uhFX+z0GudtP/ULc7qat8QnPJdYep7jpWxFZSE=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by MN2PR21MB1455.namprd21.prod.outlook.com (2603:10b6:208:204::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.0; Wed, 15 Sep
 2021 16:46:57 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::d804:7493:8e3d:68d3]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::d804:7493:8e3d:68d3%9]) with mapi id 15.20.4478.015; Wed, 15 Sep 2021
 16:46:57 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
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
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for
 netvsc driver
Thread-Index: AQHXqW4FQ8MnKzPhAECYP0JKGb2C7qulSMAAgAACvIA=
Date:   Wed, 15 Sep 2021 16:46:57 +0000
Message-ID: <MN2PR21MB12959F10240EC1BB2270B345CADB9@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-13-ltykernel@gmail.com>
 <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
In-Reply-To: <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=131cd4f8-e33d-45d8-94eb-3fa8bffaa59b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-14T19:30:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65fcef49-2bfc-4abc-9a1a-08d978686e90
x-ms-traffictypediagnostic: MN2PR21MB1455:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB14556F18B555DA028D4C2EF9CADB9@MN2PR21MB1455.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xGl1C0Su/tD+WOaQChXs8rzYHOsiTb6SivahjGE5kjmdTc8hP9NgTlOaTCET+LqroRb7MIhxhzdyHAysilDMNGnbZuFV6mN6pBzlz87RadM4TPmTgdGX6IVVCZywiM6YHjW2WMVtH5PxXu+Oy/2AFit29qvXSvX9sBfTQcbTUD/6WnqZepiear0iBM81id7fDrx2g6W9TUSU6O4MirUdYdH4AOvjgQTsbIlhJwiOCRdTFwdssvyJRTP9mqcGUhhUsaHZ5dNDHXDNlt3ghjzFtkrKWNSR4H+oAAEnOkVP7HvV4MleuEtAEqbSR2ZRqy7e1VMUjJSnAtUA0aTPfD7kXsA6qDBqn8JoiNS43PAgJATnJHrY1xJGt63lQi8G6OyGykzlTRzPWqQYZxrtLHLE8/FS17dUYe8A6JdY/h+ZzG+kZqQX4xpr8lGfcxau8JnPUICI5eZO4HSD/MQDiifehrUO7L5RfK7ctMoXdThWwhWr0il60Ej94prC3IhBH3+ccPXirTXnyCqeAZgmiX+KuLnPQuwssw1Omw4mHiHVL5Xh7HJaZVSGwvu1L1odlbz3PIWRQWynV62IOulmsm8tf+dOuuIhi2OyyJuADtmRnpryk/vvmqLAUbSfjcw/oWgPsd8VUknskrdC9uKgHxwOq6NuRTvHbrARI1G3zQKJ64d7s6+BZAvMP7go+N9H1p7Tk2Bk9T6ULJKbKZf1X+PzP6b+scpn0llycirurm0mUSg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(7696005)(82950400001)(8990500004)(508600001)(82960400001)(5660300002)(71200400001)(26005)(66946007)(54906003)(9686003)(38070700005)(66556008)(4326008)(186003)(10290500003)(2906002)(921005)(7416002)(110136005)(53546011)(83380400001)(6506007)(122000001)(38100700002)(8936002)(66446008)(64756008)(8676002)(66476007)(316002)(7406005)(76116006)(33656002)(86362001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0q2FR5kBUsiHGn8VbWhX7EDw1OB0uXP/oD1rM/XhCIvpmI8fc3j2b9++DdZR?=
 =?us-ascii?Q?/QGDa9anxw38L13zRnzafY3JdiV7PtD1SyyYiBt+qV/xif3hUTN+AEyZnytS?=
 =?us-ascii?Q?wVkd6cOeLSdsqwUtgY+OGKyqqMkvFFfmx1xPBbPQWjIEYnp/8gdpZtqwn8Js?=
 =?us-ascii?Q?UKyuFZjK1BxDkYflgvLuhl1tTQRIHZmSNTeJhOqOhcFrxSgWGbeRz1N9822x?=
 =?us-ascii?Q?Z5DRy+fVkAS64W4Ku3uqLcG7mtnk78COlFsTGvl7A+D0GJakK2UVqz136dtB?=
 =?us-ascii?Q?6hBELlgsY4oqvtjZ54CxhPEcy/ye03MBgUxHH9nA98mOw+KNzn+Qsb+CIt1S?=
 =?us-ascii?Q?H0ybkOMVXaRKwLzjosnyEefBLFx3h4g2DnvDeT7REBN01NpsrAtNEjMD9beT?=
 =?us-ascii?Q?bQncdkaDpS/hoHN4aKop7UqQxXO7MR22XajM8w5ix1zcYnOHaty60utyXXr1?=
 =?us-ascii?Q?syH+BiYc4sVnqOb6JYLE+b2XcZZSJgzfyTH9OANK2AMg2IRIWbte+54Qsmdm?=
 =?us-ascii?Q?X4RdWSSIhVereLBEeVhooh+79bAfO+fkXaQcM3dP1Ikj//4PqNlFkG2ADOYB?=
 =?us-ascii?Q?BU92zEee9pYGD5hag2fYtnpgTrVtVG/9UPsXjtF72eySFj6J3olhVHeMrBB+?=
 =?us-ascii?Q?yrDMy4mo/2cE9De6SK932A1FICdu0HQ0X96sb5ozkGsmO+MpnnekF6KiXMgg?=
 =?us-ascii?Q?qD5OyQea/TGfbMp49h71v3+zUxYxLSqZu/Yc7dTSUMc6YKz3DeMN852w7lSV?=
 =?us-ascii?Q?vfT/Nom/gDA8qYP1lPOZm3UYYTbYdjW15MnE7W357On9T+s3A/LQO7nOCKyz?=
 =?us-ascii?Q?WhI+i+00esKNAG7k4E2R7nQXNVwx4kVuA5xKicqxOQm9hBNpFSd93nVHedcc?=
 =?us-ascii?Q?C5iJ7MawTgv/Q5nEArqQQV+6vN12x2dXnAlOV1C/v7TuSPB5NH8cfPZU795v?=
 =?us-ascii?Q?LO9TtYIDRbuWOXT84eqf+N0r/JjYIp57XDuOgDKbTHYL4FugnJKCiyFPH4EG?=
 =?us-ascii?Q?UtV8MnmBxujLuLFLfoYlocN6+tWx6L1hZHGYE8eew0d2ZRH+cgQ5EjrAbovF?=
 =?us-ascii?Q?S8Yff10ScEbMctALgybHNUclMjXEnRkCL25pTdQzaGSnNmn95xPwTneIxoKb?=
 =?us-ascii?Q?JuyqWTxOnUWt+Pf9MnMUzhftDFWXZe0wIqcvssHF4T3O5eKSvLOTp5YdhMaS?=
 =?us-ascii?Q?ZQ1v8XR5eD1iRcEKnO/aKKAzhaPwS0UnbTdQKaiAc7RrbPq+hsqDksjeD6v0?=
 =?us-ascii?Q?v357YMl09zW91F1P+vwp9DVHsU1MVbofYOaV6wdkp07Q5sE3yjYX45SxbdaK?=
 =?us-ascii?Q?iUMuwk13GMcDKglnttym8iNx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65fcef49-2bfc-4abc-9a1a-08d978686e90
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 16:46:57.5268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XHlmYxUxbmdLdPSH5H35ZgFxyje56csxvRzpdGEKZVJtlsm+u8WV25TtsJyZeKdAPgAsjdM0HUeAigA+Ad5SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley <mikelley@microsoft.com>
> Sent: Wednesday, September 15, 2021 12:22 PM
> To: Tianyu Lan <ltykernel@gmail.com>; KY Srinivasan <kys@microsoft.com>;

> > +				memset(vmap_pages, 0,
> > +				       sizeof(*vmap_pages) * vmap_page_index);
> > +				vmap_page_index =3D 0;
> > +
> > +				for (j =3D 0; j < i; j++)
> > +					__free_pages(pages[j], alloc_unit);
> > +
> > +				kfree(pages);
> > +				alloc_unit =3D 1;
>=20
> This is the case where a large enough contiguous physical memory chunk
> could not be found.  But rather than dropping all the way down to single
> pages, would it make sense to try something smaller, but not 1?  For
> example, cut the alloc_unit in half and try again.  But I'm not sure of
> all the implications.

I had the same question. But probably gradually decrementing uses too much
time?

>=20
> > +				goto retry;
> > +			}
> > +		}
> > +
> > +		pages[i] =3D page;
> > +		for (j =3D 0; j < alloc_unit; j++)
> > +			vmap_pages[vmap_page_index++] =3D page++;
> > +	}
> > +
> > +	vaddr =3D vmap(vmap_pages, vmap_page_index, VM_MAP, PAGE_KERNEL);
> > +	kfree(vmap_pages);
> > +
> > +	*pages_array =3D pages;
> > +	return vaddr;
> > +
> > +cleanup:
> > +	for (j =3D 0; j < i; j++)
> > +		__free_pages(pages[i], alloc_unit);
> > +
> > +	kfree(pages);
> > +	kfree(vmap_pages);
> > +	return NULL;
> > +}
> > +
> > +static void *netvsc_map_pages(struct page **pages, int count, int
> > +alloc_unit) {
> > +	int pg_count =3D count * alloc_unit;
> > +	struct page *page;
> > +	unsigned long *pfns;
> > +	int pfn_index =3D 0;
> > +	void *vaddr;
> > +	int i, j;
> > +
> > +	if (!pages)
> > +		return NULL;
> > +
> > +	pfns =3D kcalloc(pg_count, sizeof(*pfns), GFP_KERNEL);
> > +	if (!pfns)
> > +		return NULL;
> > +
> > +	for (i =3D 0; i < count; i++) {
> > +		page =3D pages[i];
> > +		if (!page) {
> > +			pr_warn("page is not available %d.\n", i);
> > +			return NULL;
> > +		}
> > +
> > +		for (j =3D 0; j < alloc_unit; j++) {
> > +			pfns[pfn_index++] =3D page_to_pfn(page++) +
> > +				(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
> > +		}
> > +	}
> > +
> > +	vaddr =3D vmap_pfn(pfns, pg_count, PAGE_KERNEL_IO);
> > +	kfree(pfns);
> > +	return vaddr;
> > +}
> > +
>=20
> I think you are proposing this approach to allocating memory for the
> send and receive buffers so that you can avoid having two virtual
> mappings for the memory, per comments from Christop Hellwig.  But
> overall, the approach seems a bit complex and I wonder if it is worth it.
> If allocating large contiguous chunks of physical memory is successful,
> then there is some memory savings in that the data structures needed to
> keep track of the physical pages is smaller than the equivalent page
> tables might be.  But if you have to revert to allocating individual
> pages, then the memory savings is reduced.
>=20
> Ultimately, the list of actual PFNs has to be kept somewhere.  Another
> approach would be to do the reverse of what hv_map_memory() from the v4
> patch series does.  I.e., you could do virt_to_phys() on each virtual
> address that maps above VTOM, and subtract out the shared_gpa_boundary
> to get the
> list of actual PFNs that need to be freed.   This way you don't have two
> copies
> of the list of PFNs -- one with and one without the shared_gpa_boundary
> added.
> But it comes at the cost of additional code so that may not be a great
> idea.
>=20
> I think what you have here works, and I don't have a clearly better
> solution at the moment except perhaps to revert to the v4 solution and
> just have two virtual mappings.  I'll keep thinking about it.  Maybe
> Christop has other thoughts.
>=20
> >  static int netvsc_init_buf(struct hv_device *device,
> >  			   struct netvsc_device *net_device,
> >  			   const struct netvsc_device_info *device_info) @@ -
> 337,7 +462,7
> > @@ static int netvsc_init_buf(struct hv_device *device,
> >  	struct nvsp_1_message_send_receive_buffer_complete *resp;
> >  	struct net_device *ndev =3D hv_get_drvdata(device);
> >  	struct nvsp_message *init_packet;
> > -	unsigned int buf_size;
> > +	unsigned int buf_size, alloc_unit;
> >  	size_t map_words;
> >  	int i, ret =3D 0;
> >
> > @@ -350,7 +475,14 @@ static int netvsc_init_buf(struct hv_device
> *device,
> >  		buf_size =3D min_t(unsigned int, buf_size,
> >  				 NETVSC_RECEIVE_BUFFER_SIZE_LEGACY);
> >
> > -	net_device->recv_buf =3D vzalloc(buf_size);
> > +	if (hv_isolation_type_snp())
> > +		net_device->recv_buf =3D
> > +			netvsc_alloc_pages(&net_device->recv_pages,
> > +					   &net_device->recv_page_count,
> > +					   buf_size);
> > +	else
> > +		net_device->recv_buf =3D vzalloc(buf_size);
> > +
>=20
> I wonder if it is necessary to have two different code paths here.  The
> allocating and freeing of the send and receive buffers is not perf
> sensitive, and it seems like netvsc_alloc_pages() could be used
> regardless of whether SNP Isolation is in effect.  To my thinking, one
> code path is better than two code paths unless there's a compelling
> reason to have two.

I still prefer keeping the simple vzalloc for the non isolated VMs, because
simple code path usually means more robust.=20
I don't know how much time difference between the two, but in some cases=20
we really care about boot time?=20
Also in the multi vPort case for MANA, we potentially support hundreds of=20
vPorts, and there will be the same number of synthetic NICs associated with=
=20
them. So even small time difference in the initialization time may add up.

Thanks,
- Haiyang

