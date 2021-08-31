Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE483FCC25
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 19:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbhHaRRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 13:17:31 -0400
Received: from mail-oln040093003004.outbound.protection.outlook.com ([40.93.3.4]:38937
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229602AbhHaRR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 13:17:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOSiWaZOWP4FK2hV8gLe4admcsHU8TJBlLySdUxXlVZWT4TLw0qRe6GoS91QYK/H09GhSlylFox6l9SmjmXlMisnigRb1iDSvXsroDr/qDLBINAKqi9IFtSLEZNOqLUvnE28B93dv2OfU2fcKae7y6es0hf1vmW5Z4G1sW6I+idqCEvMi/BWz9caQpvqAG96ro/iVXN+kdZ2EvitlVv1ZzVAP1GtND0A1ySArO6BUAjZEjMKPO36+4XBgmCQE1g0vXuUYvv18mJSkeYwj/qTg1KFzFt5/sYfxq4KmMOSSK1rfWqrdjPHP3+hL4ghy4fcKEI3vrh+/X3hAN+4b64GLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/H29txM3OUaYa3KVICUvUz79p+FL+z9mvEvXiBfoyP0=;
 b=IbeUU6WJbRKXOoaZQN24eT4HePd4vZxgKS225h21rkeiDCLIEP3q7XKfyv2F+zjlpS1n5lprBvwzhsZ0oYykF5KF+AVhcPiX9Af2bGFXh8FnqvOJds972yXiaj2MziTW6zBH1WbkxeehrirnYeMPThmKU8wwTUEwJ6ATZ6arn9iOO/ZSdGEEvXXxJGcyDdIOlHVn90y8cOk0rPrA/spBBlTLk/pBUrU6cih6IYwmF4lMuKk7HvsLamHlE2A/a+F++ZsUsTM1JMVPudc19zUYTogf1EoBDc7TnQL50u8Q3Bu/p/+ICdBUnQtyEAYqTkdVbrTN1bLgPrKGkY/QiosASQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/H29txM3OUaYa3KVICUvUz79p+FL+z9mvEvXiBfoyP0=;
 b=DN9ww0J5Xu0crtSkTcc9Z60FeTciwbs6YIBkRnK7QwVKNsBmkvn+bJ5O4kNGtaKf5mbL+loDgarv94cwSq7V5FMzePDtUil2bhg6krpyWr/k4iHypcwwtXH/Fxz9rZeG6fVn+bPYBuC3LoiQjcZiJ6bAs3hGxtLICz9QjqII6Kk=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0767.namprd21.prod.outlook.com (2603:10b6:300:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.0; Tue, 31 Aug
 2021 17:16:19 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Tue, 31 Aug 2021
 17:16:19 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Christoph Hellwig <hch@lst.de>, Tianyu Lan <ltykernel@gmail.com>
CC:     KY Srinivasan <kys@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
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
        "ardb@kernel.org" <ardb@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Thread-Topic: [PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Thread-Index: AQHXm2f20hs45o24pkmChnbOnB/NPKuL9ngAgAHkV3A=
Date:   Tue, 31 Aug 2021 17:16:19 +0000
Message-ID: <MWHPR21MB15933503E7C324167CB4132CD7CC9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210830120036.GA22005@lst.de>
In-Reply-To: <20210830120036.GA22005@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b539bc2a-713a-4fd8-8949-a5b70949183d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-31T16:54:06Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36505fc4-57f0-4a11-2915-08d96ca30c91
x-ms-traffictypediagnostic: MWHPR21MB0767:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0767C8EF1F7C09EA1E1F15B5D7CC9@MWHPR21MB0767.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CF0vfIO1LdlXJlTTx9oLalyT0yTN7SiKnZT/4zUI+q0WW4VMi6QCh2Gb0hFVZAcyFn6bWaDyHALxhwPiuCgoNe7dy/qET8dSt+2RPwQ4QXkg/0A9e5oYCkXQ17yrDlkCnkUxu/6JdzuBBKoyPvhvy339/VGYQNb62Y+Vvv5gM7ZMQ97eJOsveQB6Diy+vvtU1jvJbpKoEkN3DyKonEgtyWLu7diXKSStoHJXOGmYG8sRA5Cb/z2w7kprhKN7wu9O79JK00A/COdpwxHS1orgE70BR/CUCJAy8bCw9W5tAGqEQRb7GeZuJeWHHnbDz8dcwb9Lkrb7TvLNKBJ7RLt6NokPQ+gWSO2I5xik/XeeFlJGR0M/aDShqWOsgZ9TO67g5vtIvoIA3LrIPFXbmrJ7budthg88JZfMSBRLDmYHwPlFD3LwDlSCMHIj4S1vB/kNts+wXf+VdeTbIaltjqWtuc+MT4POC4JUhBe30Rb2QkmBeX7aEsRdwPBTRZ+NN8TClWPI9fkgtvbyHw6U3DzpkCIelLryFPpxSDjgFokzMRZLqhovP96HG/EVYNE5JZrHXPyfxuM119QWNo6jbKc08BIZE8KoH/nKN+mfuRd7t3lm4OWdudRj+1D7FTXL+6eTLnOSdn5qXp+4jtOQTR7ji8v8tjYEqOqRtO85zSm52Jp1dpBEyyScBZhIYUwhPijMDZgcl9QrZItcTzxqRDM66XPH20mCphBLjbGo3kIBRpWBQEHc/7nfA3anyyi5NmOopLtjmx3MBsea+Dy28seo3jcrH2kn3nd3sUtsBLMu65Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82950400001)(7366002)(38100700002)(66946007)(316002)(83380400001)(66476007)(71200400001)(7406005)(966005)(86362001)(64756008)(33656002)(76116006)(4326008)(7416002)(66446008)(10290500003)(9686003)(66556008)(5660300002)(2906002)(6506007)(7696005)(186003)(508600001)(26005)(54906003)(38070700005)(82960400001)(52536014)(122000001)(8936002)(8990500004)(8676002)(55016002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jWFSDTs8NlkZWK0mHh4BFrwtbTX52OBhWdP78KAZa5Dnr/wYNJjr1ZvFADeM?=
 =?us-ascii?Q?kPmnHg6gGnRxwZ2O1fTucywtVROm/IXZgqp8cG+RikcFWM2KRD9gYaokGJwk?=
 =?us-ascii?Q?UmoBn/SGt2I+1wShRfRUU/P+UPLPShu8ngsazxf8tVqEMdBNB0e1ZFICtbMd?=
 =?us-ascii?Q?WrEuv/jB7iGfuYSbP8vPRHiAGPLMSjTtpjcEAKOCKfjcxJ94P2fp13S0VNf5?=
 =?us-ascii?Q?E73hxHTxfE3hTnmr1DRTZ9a1UjlW5Lf1fLww8EhuQ3NRuuetdJsgQZdcLhVR?=
 =?us-ascii?Q?fquwYNmj8aMzNGq+lM0xfPFNC8742bEJVQRftjGLOzWn/yU9hM6chl0RbMQd?=
 =?us-ascii?Q?CnptGGJsSCHWEJ/i6QA1Uiifz9WwcxRlTM4p6XLxmFl6Gg6RrztROXfjkO44?=
 =?us-ascii?Q?Xj5SFlBC0T9d+3Yz5WHTPXMosN8Fk+yR5of3bf+YZ/lOUkc1vLD7hOPVZmHa?=
 =?us-ascii?Q?zXXUBuFabsU1IxXavFtXTsnUP+Z0+mJtkIF7e2bgHwGqaTt1mIxmt3CFfLy+?=
 =?us-ascii?Q?lr9rhEalbmSmoMvUaw0nAm99eDqSpwylFCdi4nshZdgqbfIr++67wOUIiMgh?=
 =?us-ascii?Q?5dV971i/pyEVaZiDjbmpFREN4YR36LXuAXdSz/txUuPV4jCaw0CNzE5lKTYh?=
 =?us-ascii?Q?IJovgCJ7g7UMHzvtuGbH58Gqc6iSq/mVqou6fJLBXxo9o7aN1+IDtm5t50cc?=
 =?us-ascii?Q?rv0g8uVpMqIwJrBw4ZXJG6GKpVijyLEZIjT8nEqmd7fC1Tq1o4yGzjrm6LUM?=
 =?us-ascii?Q?wWpe90xIy8Fr4fKDsRDoAM3yQKd7qWN/iVyo1GWoBVJaZ7+hzVxyxDrAX8gW?=
 =?us-ascii?Q?81h6XSbNNzSEMqVZTYxSu0Nlgx1lVU5Cgnhnr7IicqOYrFklY/02DNiSBa1X?=
 =?us-ascii?Q?w3LR1ZUOmlOVn/+rGCgykN+NlGtzU+nfp7l2dXxgk8UmLcZZoVhRZdCRYkwV?=
 =?us-ascii?Q?S2bC/Jbw6CoBD4NRS3SvRGlOFZNJitiOuiXZOToV/+VONKgmX4TIwDclcChY?=
 =?us-ascii?Q?eimSIgAe6WQplJbyqpJNLchuJmzS0Gi6hGlONek54Md0puTtApmLt94WrHRx?=
 =?us-ascii?Q?asenluq/1fIip4Vo8PGgPeO7bcNm2yeoRR3RwX4YtzR9WG8Z5d0PSxL94sSX?=
 =?us-ascii?Q?nYr/5oTiawmbSI2aOwvJJjMkm5eH9HFG1nYONOJDYXi7JQFGxBhtG74rdASG?=
 =?us-ascii?Q?4z+6iDdLmb7/z11oGRk/Qj3OlJKwLvQtCUXrtuzA3+6UabfyyBRUZy91p5HS?=
 =?us-ascii?Q?tJVaBJK0nehasQa9enxvVdUo223R+I1UEyo56uSW0YqMbHG3bFn2IX9g1hD9?=
 =?us-ascii?Q?0t2cpZyG0hmS52/KWeMW6VD+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36505fc4-57f0-4a11-2915-08d96ca30c91
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 17:16:19.3066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3+xw4R8Ls05R1OBdw8FBnjyT990VeZRkopAnjFNL+0efE77ujKdVwcy7RpqGc1jiO5l9Iyjj48O2ZRQDQ/u0e1QsirZ64AlvSf6r6qfemFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0767
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de> Sent: Monday, August 30, 2021 5:01 AM
>=20
> Sorry for the delayed answer, but I look at the vmap_pfn usage in the
> previous version and tried to come up with a better version.  This
> mostly untested branch:
>=20
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/hyperv-vm=
ap
>=20
> get us there for swiotlb and the channel infrastructure  I've started
> looking at the network driver and didn't get anywhere due to other work.
>=20
> As far as I can tell the network driver does gigantic multi-megabyte
> vmalloc allocation for the send and receive buffers, which are then
> passed to the hardware, but always copied to/from when interacting
> with the networking stack.  Did I see that right?  Are these big
> buffers actually required unlike the normal buffer management schemes
> in other Linux network drivers?
>=20
> If so I suspect the best way to allocate them is by not using vmalloc
> but just discontiguous pages, and then use kmap_local_pfn where the
> PFN includes the share_gpa offset when actually copying from/to the
> skbs.

As a quick overview, I think there are four places where the
shared_gpa_boundary must be applied to adjust the guest physical
address that is used.  Each requires mapping a corresponding
virtual address range.  Here are the four places:

1)  The so-called "monitor pages" that are a core communication
mechanism between the guest and Hyper-V.  These are two single
pages, and the mapping is handled by calling memremap() for
each of the two pages.  See Patch 7 of Tianyu's series.

2)  The VMbus channel ring buffers.  You have proposed using
your new  vmap_phys_range() helper, but I don't think that works
here.  More details below.

3)  The network driver send and receive buffers.  vmap_phys_range()
should work here.

4) The swiotlb memory used for bounce buffers.  vmap_phys_range()
should work here as well.

Case #2 above does unusual mapping.  The ring buffer consists of a ring
buffer header page, followed by one or more pages that are the actual
ring buffer.  The pages making up the actual ring buffer are mapped
twice in succession.  For example, if the ring buffer has 4 pages
(one header page and three ring buffer pages), the contiguous
virtual mapping must cover these seven pages:  0, 1, 2, 3, 1, 2, 3.
The duplicate contiguous mapping allows the code that is reading
or writing the actual ring buffer to not be concerned about wrap-around
because writing off the end of the ring buffer is automatically
wrapped-around by the mapping.  The amount of data read or
written in one batch never exceeds the size of the ring buffer, and
after a batch is read or written, the read or write indices are adjusted
to put them back into the range of the first mapping of the actual
ring buffer pages.  So there's method to the madness, and the
technique works pretty well.  But this kind of mapping is not
amenable to using vmap_phys_range().

Michael


