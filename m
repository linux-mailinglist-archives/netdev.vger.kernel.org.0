Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0AD3FE8A2
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 06:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhIBE5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 00:57:44 -0400
Received: from mail-oln040093008015.outbound.protection.outlook.com ([40.93.8.15]:21027
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230168AbhIBE5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 00:57:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diHzAfLzvHkLnGDBA77CxjILWQ0f4yi16eeG/tktyrNTahSkFhlY4zM/KqPreJW5GvOG5lnHcmdLoGHxu/GnypUBLdOuwXZrB5X5iaY5ZWEAeYUkQ24CYeU4XYbHPPdY087rZ66Koj/CtdHhpbAoLdiv29fYui7rEWaz/E27FLQq4rbC/Hllk84wAkRx508cuEPKqwMTKZ9ljCmxYaY2YO6mP13CeUCYq73ntFtINifFfzfQQOEVAET6RG99JNrSjos94yTmg/FFPHJilJRaADS4sL0ziwKi/JCEUn4vnRovq4pAbFLothJaUzEMLrmrFw6BTPrd4QxTnwBYH+m9hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/g+2tfLa4TWsUYnWx7YAfFpKGu7PCDx8XRRyHbecAJY=;
 b=ISc15lW0YFYaIzGaYZcf7eSaag/OIA6d2PDby2AN03uuws9YkkDRS+BeaCF7hDi7FXbNdZOTM0OfreC8gKqKzWfX72n7NrfVJkN+FO+NSX+QZpPgRCRrzp/FwD12TK9KxuxOlMpaTsdTwoHKRTgr2FH8j8Y7zzTqzjQe6nVTtLjFrs8+Wm+27I5fNZzWXR8yPUJSbfJ1edY2u8maoJ1GatLGyKvvc9eNya/tFT8wmytGJc2cQdEffaAcKbISwnCgxSxNy3F/um/brEfwunRTOYzzOUAta2qrVU9LIMuRmx1daNCem7Pv/NVK7BGArSXRwZFRNbAvhSKwV7BBI4gW0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/g+2tfLa4TWsUYnWx7YAfFpKGu7PCDx8XRRyHbecAJY=;
 b=GmQbcuvDU5mYwcbUJ2PC5qkKcAeHuBop+hvo5IULzB7MP/WHRrNX3ze0EQRNBGFccqbV1wj7garo8nxApCLffgPlbZhUM1lgqoD4lOwClaPJmtlvW4qaERy1vXfh3eAXrbLY/sLKD9tYs/o8RhHB94SvVCQcDPRLUSRNJ5CQP9M=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0704.namprd21.prod.outlook.com (2603:10b6:300:128::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.1; Thu, 2 Sep
 2021 04:56:41 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 04:56:40 +0000
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
Subject: RE: [PATCH V4 12/13] hv_netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V4 12/13] hv_netvsc: Add Isolation VM support for netvsc
 driver
Thread-Index: AQHXm2gP6jy1GRuc+0K7S1qphPLgHKuQCC+wgAAtP2A=
Date:   Thu, 2 Sep 2021 04:56:40 +0000
Message-ID: <MWHPR21MB1593A3909B3DB49EABB78CF5D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-13-ltykernel@gmail.com>
 <MWHPR21MB1593CD9E7B545EF5A268B745D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
In-Reply-To: <MWHPR21MB1593CD9E7B545EF5A268B745D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=24c2ad3d-af1e-4524-bef7-f93352ae7e8f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-02T02:09:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f4c007b-0072-45e0-73ee-08d96dce0d9d
x-ms-traffictypediagnostic: MWHPR21MB0704:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB07040B6B69FEF6567783EBCAD7CE9@MWHPR21MB0704.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 64n9ZHQNFsz+NZtjmS32VhXFDsqb8zSWHHkpOgEAVkAOEYbK/lXOyJqt83v3+p/qJhmo1s4vtVRa5OFw+A80IEGG56thQ86l8sHgNWJJZzk+y80rlDn3zM74xtFvm0zFR9PXp4daK9ZEV+5x4R12LF0mVAAAh3i5Jx/ncYh1K73KkVgtBS7G0aAgZ33DJ0VLYZixVKxyZgiqIrr4GKstKHTQf7oSCByGiv8ykKVEeRYQ2zzX3FKEJ46WvygnaZWc2/i27ylRxUqCsE3FVujK4swpkfIEBbT3s9hFiufZ/agR0+EuqeuPdnKwDYPZVFxdqm+4yElIMyN4W9TsEXbaHohZHwwJJY/nHZhrJSTEWqDD5Dn4Tk01ukOe4E5rhnh1tQXionIjcAm13RTUZSWBP3ceRArg3r74e/XGA5YEmeZBWoDg79JJJY/GBwB5DtR8C/7RRvG4463rpwlG4oEoEv4WfOeTY77ikav98zTrcOXnUoUbLksknqpkwvAinPOTTEjyJFVNhdtZIZVD1ekXcbgKONHpVy6VLyiRqONqcq9w81ZRlRtw15+42oi4QhLpgK6ve5dokzz7q0iGJRtEWq6ELDLbn5OCOJH7SQEBBvP0iNNOJO0uRpAoYPaYvQTS8fdYfyvLbuoAFRWyyBAK+jOA/k+AyczCL5J1FGCb1Dk7wjVYuBSEnCwmvmwStG7YOfHdthwm2QC9hE9j7GdtYa2fO0PngUipTC7szx/U3Q8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(9686003)(66476007)(66556008)(10290500003)(76116006)(64756008)(508600001)(186003)(7696005)(66446008)(122000001)(2940100002)(5660300002)(8936002)(316002)(921005)(6506007)(8676002)(33656002)(83380400001)(110136005)(8990500004)(2906002)(38070700005)(26005)(82950400001)(38100700002)(71200400001)(82960400001)(86362001)(52536014)(7416002)(7366002)(7406005)(55016002)(4326008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6EXkemG7X07lxyyEVGMWnZY1RJrvvTxJhOuuA3ahPWNi/QB6p2Fe1JSTWrhL?=
 =?us-ascii?Q?zNvbAB2OIg6osr5Wcg38XUQKN95LY8icqsTsmNQQMyPhQ4WqC7Pr6I/YnHIY?=
 =?us-ascii?Q?kAehk0612De9pWwHx2JufPylsK+6aLdZxTS0kOFlVuYHJMfyTZA4QrSdFTRb?=
 =?us-ascii?Q?l941Wi26kmgYfHho1pRjLJdBU0+3HBfO9MAQ54nGFq+cViyI5WFZO14ywN4P?=
 =?us-ascii?Q?dkf05ljqyoJeEqKb5ODxUl3MaE1NDDXlwsPTSqPi+YlKhtU3nw7LqFRuPv77?=
 =?us-ascii?Q?fva9x9vDPH9wRGCJMZExTTl3ffVGILZJtmp48Eowql8wJoTBxp0L6d+ibw7l?=
 =?us-ascii?Q?yLI5Hicoqgvp1GGDioypge+6qDJMQW3p+06HR1ethl5meh8SS+549sQzSOTh?=
 =?us-ascii?Q?t7XFV1DVuKl2ZTt6+u3mm3gcCb2vuwWsbSEltgn4Pjgs3zS+U8EPGnNNMckG?=
 =?us-ascii?Q?dpFxBEq7P3O4xwgINCk80PSIhLFeHsmh55wxSyArjayop2e5MY9fQ0T/7YGn?=
 =?us-ascii?Q?3o229iwTW5zpedYah+f4zMkX9MQfQ8P9CGN7t4pqXnb/JTSmjwdbPy0L4+A5?=
 =?us-ascii?Q?aiyR0LAlWMcZhk24zw+TYSBVEbQ36LBikmKzICRL+5TyimSGEXmuVDOxsGyu?=
 =?us-ascii?Q?zOeylCJ70LTnZPR+0xx+nxTBxhyAnfTpImGYrPiye7uhk11aiVwWbGaxaspe?=
 =?us-ascii?Q?Dci8Tu62eUS8EUGCGQo/G3x3DqcR7fStDnQ1Fl5pvV9NCC/+ou91D4q4U8yC?=
 =?us-ascii?Q?GYHb9sAC9MIMG99g7i8RvZ5XArm25QKCu5+tz9pcp3C3so0F5/TPlkgePyf8?=
 =?us-ascii?Q?bnNPvwFJQrA4h7857rad4qC1K//+ntDXp3mso0Gf4k1NoCs30CW7ha2+MObm?=
 =?us-ascii?Q?VT+LZay4wDOgoQDEfWO+LRcd0wWHB9ozah3a2RRt7HRdrCbZSFY5Dyu6+hN5?=
 =?us-ascii?Q?SE4Uo7p0YZyONhi6oLj2T1c8+/ou7hxoNYwTfW/QER5yN6ats56gLjLR9F8e?=
 =?us-ascii?Q?ycfJhEcfMewHC/123Moiy6lcUUHPmXehUFwNhAaGrnyXPTOOE9LqLAlL8GaC?=
 =?us-ascii?Q?GpHY00fVHl0FhFa9Zw3mMJ1rBFGi7ysY9atT4KZGRwSt4OaacwO5CJyTvSVu?=
 =?us-ascii?Q?NXsRm7QwfkenbM9NfewkB8NT8LPagUyTMthGedIdo+kyHF9e4UCwbElo+A3t?=
 =?us-ascii?Q?lDGdJ07HBcp76BT7Fz2zHC0T/mlvuwEBTdapFc3ts6fOURINtJ5pir67PgHa?=
 =?us-ascii?Q?oOPkvGdqPu8l5XwHFt1lY0aemWmDCUyFohffPqTqvMLEX0jgNifasxn5Jt3Q?=
 =?us-ascii?Q?XjnOeVB+bdznBYzrnkKcTU01?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4c007b-0072-45e0-73ee-08d96dce0d9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 04:56:40.6250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQFrIKEO1/7vXPGsi6Dj8gkGAUk2kVTDMG1CDEjqxBoLGRSW2nnJEeXs7PCEgMxxQYhcC5DNiGsb5npNJkcRdevFW1BZIHUZ93h3srjzPa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0704
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com> Sent: Wednesday, September 1,=
 2021 7:34 PM

[snip]

> > +int netvsc_dma_map(struct hv_device *hv_dev,
> > +		   struct hv_netvsc_packet *packet,
> > +		   struct hv_page_buffer *pb)
> > +{
> > +	u32 page_count =3D  packet->cp_partial ?
> > +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> > +		packet->page_buf_cnt;
> > +	dma_addr_t dma;
> > +	int i;
> > +
> > +	if (!hv_is_isolation_supported())
> > +		return 0;
> > +
> > +	packet->dma_range =3D kcalloc(page_count,
> > +				    sizeof(*packet->dma_range),
> > +				    GFP_KERNEL);
> > +	if (!packet->dma_range)
> > +		return -ENOMEM;
> > +
> > +	for (i =3D 0; i < page_count; i++) {
> > +		char *src =3D phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
> > +					 + pb[i].offset);
> > +		u32 len =3D pb[i].len;
> > +
> > +		dma =3D dma_map_single(&hv_dev->device, src, len,
> > +				     DMA_TO_DEVICE);
> > +		if (dma_mapping_error(&hv_dev->device, dma)) {
> > +			kfree(packet->dma_range);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		packet->dma_range[i].dma =3D dma;
> > +		packet->dma_range[i].mapping_size =3D len;
> > +		pb[i].pfn =3D dma >> HV_HYP_PAGE_SHIFT;
> > +		pb[i].offset =3D offset_in_hvpage(dma);
> > +		pb[i].len =3D len;
> > +	}
>=20
> Just to confirm, this driver does *not* set the DMA min_align_mask
> like storvsc does.  So after the call to dma_map_single(), the offset
> in the page could be different.  That's why you are updating
> the pb[i].offset value.  Alternatively, you could set the DMA
> min_align_mask, which would ensure the offset is unchanged.
> I'm OK with either approach, though perhaps a comment is
> warranted to explain, as this is a subtle issue.
>=20

On second thought, I don't think either approach is OK.  The default
alignment in the swiotlb is 2K, and if the length of the data in the
buffer was 3K, the data could cross a page boundary in the bounce
buffer when it originally did not.  This would break the above code
which can only deal with one page at a time.  So I think the netvsc
driver also must set the DMA min_align_mask to 4K, which will
preserve the offset.

Michael
