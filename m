Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FDE3CB042
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 03:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhGPBHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 21:07:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:49170 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231314AbhGPBH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 21:07:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="207630366"
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="207630366"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 18:04:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="573247686"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jul 2021 18:04:33 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 15 Jul 2021 18:04:32 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 15 Jul 2021 18:04:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 15 Jul 2021 18:04:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 15 Jul 2021 18:04:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpE6SYI6Wj5YEhsyFWTtN5Q/Jf7stnwgjUrhUbnphFOn1Z6VRn5AA1fqD1yHWKooAWxo4lvzrFby2/cDvg+crsEwE9kllF44Ld0iLPxTNt9gxAiHXjSvabyLqoiMCutyOlPGZJFbO0AT+s30/KWruhHPb43NMInk9ANGr7JZNNy1YxDivF/0Wol+k1DblpSkzmzqs4iUE3MXc9sa3QCvMWUKBwN6WgfPz6d2KUiFRBLvr4NGKobUu6DNnIIR872M59SwBw5/jq3VzyNedmBpY1I282uYlORd3yhNdKsUjRLhkxrmNlltSUtxe/z20sRWgdrt2Rf1WjoIp3VUMezrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CiVfGMMDx+Digi6jv+AnhiYtn74BjqEbNg9V7Wfho1c=;
 b=FYs5snA8jLmimGKh7sDAIuB1CDR0vVt52TQP1FWPYrkbfFoMSf8+P33Veg+5Eh6r/jbdFsi0YqkDwa0KjWQqNd35mruGx0Kf/oRCaIIKfPgax6DxhQ9iDHcezPe27swQY4F9Rdypmjzic81oHDhGHC8/QYb4TLgOtwO66nWPPGWv0pU3PdYaEffBb48WyXqs4V1XmlHnpwsSgD1RcXxYBBXXlU+OFzsmS/9zNBCrAowY7rypcOPokFSh90nLGA8s3LE8fSqA4blSAvvHQnB/67BGIOknj0cHeUu/auNREaBjJCRSnnpw2br1EFl4JBG9NjAIb6F7np1vEhI7fjfllw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CiVfGMMDx+Digi6jv+AnhiYtn74BjqEbNg9V7Wfho1c=;
 b=wrVvW6qqq3Qw6ur8TU82UZMylb9j/+MaadoA13suMXwQFMxpEEIRQ9gqqM/u2WGaomssqMZDULihYueu81rGf9IW2Pyl+yeKxESwZBg2kmtT1UifybI6nxKABQsB6cXWOJPlr3MsQlF8/HivsPl46A7505ddMTxmInc8VmFFl8M=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by SJ0PR11MB5103.namprd11.prod.outlook.com (2603:10b6:a03:2d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 01:04:23 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::59c1:1d11:445a:3942]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::59c1:1d11:445a:3942%5]) with mapi id 15.20.4331.022; Fri, 16 Jul 2021
 01:04:23 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "Pierre-Louis Bossart" <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        KVM list <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v10 00/20] dlb: introduce DLB device driver
Thread-Topic: [PATCH v10 00/20] dlb: introduce DLB device driver
Thread-Index: AQHW/9Zt8wdlPnXnkESxoD5/CU9Koap9GIKAgAMHmACAAN/QcIAAU8sAgARar7CAANe9AIBaPk+AgALX+oCAYh0MMA==
Date:   Fri, 16 Jul 2021 01:04:23 +0000
Message-ID: <BYAPR11MB30952BA538BB905331392A08D9119@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <YEiLI8fGoa9DoCnF@kroah.com>
 <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
 <BYAPR11MB30950965A223EDE5414EAE08D96F9@BYAPR11MB3095.namprd11.prod.outlook.com>
 <CAPcyv4htddEBB9ePPSheH+rO+=VJULeHzx0gc384if7qXTUHHg@mail.gmail.com>
 <BYAPR11MB309515F449B8660043A559E5D96C9@BYAPR11MB3095.namprd11.prod.outlook.com>
 <YFBz1BICsjDsSJwv@kroah.com>
 <CAPcyv4g89PjKqPuPp2ag0vB9Vq8igTqh0gdP0h+7ySTVPagQ9w@mail.gmail.com>
 <YJ6KHznWTKvKQZEl@kroah.com>
In-Reply-To: <YJ6KHznWTKvKQZEl@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ed337b1-27ec-4972-9443-08d947f5a68a
x-ms-traffictypediagnostic: SJ0PR11MB5103:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB510397942DE5D496B2136D97D9119@SJ0PR11MB5103.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UJSHPdYfXba3IkgOJM7HgLkj2t5Y2LL14QPlDG3OHVYRv04tYnvH5qYZfw/QybsR10b/M4hRpXBkFj3o+e6zXm5ahQas3JFU4smAtevaHsyRKCWU1Ov8aHPwxqcj10GtabRudIhrjpiL7Qvbo+fa5222dki4FBwLr/BLrftaLvIpu+9oU0pNSo3aILoYYUITIhT+9xN0looakfllj0Bs64QR58LdTCPGsGDBBvOGelleLXV+Dm3VGyKkAXPQCojfOCadb8JIf3Wlhhcfn9SE2pqRPEG4qtvf+1o990VpmoT9yfUDsW6jErv6Cm/PKwTgKa7EMMINcoDiVBK8nv3vdz9n9exnK2HJvNq0tYFdOG6mnJuI2NfSwGBZksCxDSSQBF+LCDbRlEcJc8CUjZyQOc/y/MKG76TuL0qCh6+S8leAyb6filfNAa3G6OKbb/WGq5Lm8LO+i470vES7z5eeoHuLql6kU8ncuIyKJXxmpnckaCeTCj7eZ2c9GkuT6DnU1GIF6P51S5k3W/XJv8m2vM1KfXWhOG6IKDlrEIMUQpZXllNwFVKaJZ7050Pihc61JPAYmfZoEwm0TsZ+Y/lItOU0YWJuA0em/xKUVPwGdHsKd27kOYjEpDzQJJe6C5RsHbq+fGEwan3GVxyW4a6N4jP8NDuIabd10jLvodfJyOcMZhcF9THoGHkRvXDUiGeUjdRM+AHOEGEuQLYNbQ1N073+Dd67KB7tvIX13DvZz6GGZ4V4u8/u4IhZjw4RvevfJfC4T3hW0RAvSeuKJHTcRwIRt3ietvOO51d009/a5EM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(9686003)(8936002)(7696005)(52536014)(186003)(26005)(38100700002)(5660300002)(33656002)(122000001)(4326008)(6506007)(86362001)(66446008)(2906002)(316002)(6636002)(83380400001)(478600001)(8676002)(76116006)(54906003)(71200400001)(55016002)(110136005)(64756008)(66556008)(66476007)(66946007)(53546011)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?svgXwsmeLsmyo4jg0Y1w+i1GA2oJsz5UQenyIGhSMH9+FCqXu1lkqnUMpy2i?=
 =?us-ascii?Q?oU2VJ5R78QZHI3UMzqiHibBrGB8vOc5WT/5r7bGpO0gA8Q3knyBTvbHzUwgE?=
 =?us-ascii?Q?l7DwXVYvflxHirUhXoehlJgLuqAmN2Ltr7eIz6Xoq5fhQY20CJeOsPXJLUhA?=
 =?us-ascii?Q?G3zTU2EhLMkn3+A07FptcOjcUKGkCqL4RDgqQXH2oJhatwALfGAw6x/gS51V?=
 =?us-ascii?Q?MvpXOT6aGQLJXIBNRcJ6f205RFCok1uolJCIFguf3wvI3EN0az6rTfWsczC8?=
 =?us-ascii?Q?NzEIWIawwrnc8c1HPLMEXLGquf+tGJXwREQFQe5AZjSe5t1Wb3+GD55HhtOJ?=
 =?us-ascii?Q?FL0Z3Wm/AVt709QZOFsA23hCfC89XPeJKN80jGbifuDbeqmfi8FKA1i+Lj8n?=
 =?us-ascii?Q?4EPTsN03+bLRBq1cG4kpwOwFf97uKb0rVfPMHT6BJIk3xUMOvYZ+WxHLukFZ?=
 =?us-ascii?Q?cJ3PdPRP2J0rYiK+QBqqYjhfktRI5KinFEa2AeTVG/4C38guggBXzVCdZKji?=
 =?us-ascii?Q?awYDwcTElze0Tb03B2gu4YDZ3SxPtjyFFLAJIUeOJlnUQ9mkYvNIz04a7/TI?=
 =?us-ascii?Q?V2uA4UMRJpTOHsg8igc0SG0UsDc5uKe5zkzGLDmCNxOHhNDU4OAgOT0cJTEA?=
 =?us-ascii?Q?G3qVKZ/WpJbUtJ3anNA4ZJGLJ+WjxPh/PEd3gUpYeShswHU0MM7hHVBiQsbv?=
 =?us-ascii?Q?gC6+n5FJr71X7monkNrH2YLRFR2NwVGyshkqL9umdij61xF9GgB7uv2RJFoK?=
 =?us-ascii?Q?g1ociaCvrtfJKwiHKiMPJiGhccaP7fDFH4XMGqoMIWqpNkxEFJz+/Lq8+fKn?=
 =?us-ascii?Q?Kct7qZMuUQK1qKgQj7H4qW/t/pea2v4bknURIWkfA11BC1w62aXNm91QkSKh?=
 =?us-ascii?Q?QrQ/gdlQmxkG8469TI3rovxCL0ZsF7603Kz8uFyjX0p1nQuKP22OGCC3AzEB?=
 =?us-ascii?Q?EHCedANu2uTooIShmR+3UispqqvCl/KF6pLovaWEPWyNWbQH8qYekfRtszdc?=
 =?us-ascii?Q?/YmpmF4rBB/G/GeZx09ps9FxTrZDUd+BNp1NzsCCMmyXqIHoJmPKnU8qNS6V?=
 =?us-ascii?Q?a1RGwOyK1xjz82kj6Pt2JgnaV022IxT0fmpyMGX8pFu+8vXe8Pjsd+RoTOQ4?=
 =?us-ascii?Q?fU1/IC6+ufh9xhX6EwCdxamOm8DxeD+U3KjZgZtj5tALK6i7pdY9aQ6tNGNn?=
 =?us-ascii?Q?zwgGHh5ssdzycDacKZtA4snXOAtlUvmIt/Ct9Ei4p/2SMkwe/lxlbBk5vT6L?=
 =?us-ascii?Q?b41Xh/o6TssUKfK15zCjoxlGfB0vvEQ35kE4U+XSyxmqyYNGTf/OhJxe9/CN?=
 =?us-ascii?Q?sXXsFPOHgr8rcArFUjyJqBCs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed337b1-27ec-4972-9443-08d947f5a68a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2021 01:04:23.4875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8E8HvH1WuKZWDS1rmwOAN7Jg/mQ48D2+EHhC4j0RRSOK2APC7WM0JWRmvxLU/u2bXjow8fTIc6Yx8GokY9Jl8blYavGh2qSFcHsVyvCIf9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5103
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, May 14, 2021 10:33 AM
> To: Williams, Dan J <dan.j.williams@intel.com>
> > Hi Greg,
> >
> > So, for the last few weeks Mike and company have patiently waded
> > through my questions and now I think we are at a point to work through
> > the upstream driver architecture options and tradeoffs. You were not
> > alone in struggling to understand what this device does because it is
> > unlike any other accelerator Linux has ever considered. It shards /
> > load balances a data stream for processing by CPU threads. This is
> > typically a network appliance function / protocol, but could also be
> > any other generic thread pool like the kernel's padata. It saves the
> > CPU cycles spent load balancing work items and marshaling them through
> > a thread pool pipeline. For example, in DPDK applications, DLB2 frees
> > up entire cores that would otherwise be consumed with scheduling and
> > work distribution. A separate proof-of-concept, using DLB2 to
> > accelerate the kernel's "padata" thread pool for a crypto workload,
> > demonstrated ~150% higher throughput with hardware employed to manage
> > work distribution and result ordering. Yes, you need a sufficiently
> > high touch / high throughput protocol before the software load
> > balancing overhead coordinating CPU threads starts to dominate the
> > performance, but there are some specific workloads willing to switch
> > to this regime.
> >
> > The primary consumer to date has been as a backend for the event
> > handling in the userspace networking stack, DPDK. DLB2 has an existing
> > polled-mode-userspace driver for that use case. So I said, "great,
> > just add more features to that userspace driver and you're done". In
> > fact there was DLB1 hardware that also had a polled-mode-userspace
> > driver. So, the next question is "what's changed in DLB2 where a
> > userspace driver is no longer suitable?". The new use case for DLB2 is
> > new hardware support for a host driver to carve up device resources
> > into smaller sets (vfio-mdevs) that can be assigned to guests (Intel
> > calls this new hardware capability SIOV: Scalable IO Virtualization).
> >
> > Hardware resource management is difficult to handle in userspace
> > especially when bare-metal hardware events need to coordinate with
> > guest-VM device instances. This includes a mailbox interface for the
> > guest VM to negotiate resources with the host driver. Another more
> > practical roadblock for a "DLB2 in userspace" proposal is the fact
> > that it implements what are in-effect software-defined-interrupts to
> > go beyond the scalability limits of PCI MSI-x (Intel calls this
> > Interrupt Message Store: IMS). So even if hardware resource management
> > was awkwardly plumbed into a userspace daemon there would still need
> > to be kernel enabling for device-specific extensions to
> > drivers/vfio/pci/vfio_pci_intrs.c for it to understand the IMS
> > interrupts of DLB2 in addition to PCI MSI-x.
> >
> > While that still might be solvable in userspace if you squint at it, I
> > don't think Linux end users are served by pushing all of hardware
> > resource management to userspace. VFIO is mostly built to pass entire
> > PCI devices to guests, or in coordination with a kernel driver to
> > describe a subset of the hardware to a virtual-device (vfio-mdev)
> > interface. The rub here is that to date kernel drivers using VFIO to
> > provision mdevs have some existing responsibilities to the core kernel
> > like a network driver or DMA offload driver. The DLB2 driver offers no
> > such service to the kernel for its primary role of accelerating a
> > userspace data-plane. I am assuming here that  the padata
> > proof-of-concept is interesting, but not a compelling reason to ship a
> > driver compared to giving end users competent kernel-driven
> > hardware-resource assignment for deploying DLB2 virtual instances into
> > guest VMs.
> >
> > My "just continue in userspace" suggestion has no answer for the IMS
> > interrupt and reliable hardware resource management support
> > requirements. If you're with me so far we can go deeper into the
> > details, but in answer to your previous questions most of the TLAs
> > were from the land of "SIOV" where the VFIO community should be
> > brought in to review. The driver is mostly a configuration plane where
> > the fast path data-plane is entirely in userspace. That configuration
> > plane needs to manage hardware events and resourcing on behalf of
> > guest VMs running on a partitioned subset of the device. There are
> > worthwhile questions about whether some of the uapi can be refactored
> > to common modules like uacce, but I think we need to get to a first
> > order understanding on what DLB2 is and why the kernel has a role
> > before diving into the uapi discussion.
> >
> > Any clearer?
>=20
> A bit, yes, thanks.
>=20
> > So, in summary drivers/misc/ appears to be the first stop in the
> > review since a host driver needs to be established to start the VFIO
> > enabling campaign. With my community hat on, I think requiring
> > standalone host drivers is healthier for Linux than broaching the
> > subject of VFIO-only drivers. Even if, as in this case, the initial
> > host driver is mostly implementing a capability that could be achieved
> > with a userspace driver.
>=20
> Ok, then how about a much "smaller" kernel driver for all of this, and a =
whole lot of documentation to
> describe what is going on and what all of the TLAs are.
>=20
> thanks,
>=20
> greg k-h

Hi Greg,

tl;dr: We have been looking into various options to reduce the kernel drive=
r size and ABI surface, such as moving more responsibility to user space, r=
eusing existing kernel modules (uacce, for example), and converting functio=
nality from ioctl to sysfs. End result 10 ioctls will be replaced by sysfs,=
 the rest of them (20 ioctls) will be replaced by configfs. Some concepts a=
re moved to device-special files rather than ioctls that produce file descr=
iptors.

Details:
We investigated the possibility of using uacce (https://www.kernel.org/doc/=
html/latest/misc-devices/uacce.html) in our kernel driver.  The uacce inter=
face fits well with accelerators that process user data with known source a=
nd destination addresses. For a DLB (Dynamic Load Balancer), however,  the =
destination port depends on the system load and is unknown to the applicati=
on. While uacce exposes  "queues" to user, the dlb driver has to handle muc=
h complicated resource managements, such as credits, ports, queues and doma=
ins. We would have to add a lot of more concepts and code, which are not us=
eful for other accelerators,  in uacce to make it working for DLB. This may=
 also lead to a bigger code size over all.

We also took a another look at moving resource management functionality fro=
m kernel space to user space. Much of kernel driver supports both PF (Physi=
cal Function) on host and VFs (Virtual Functions) on VMs. Since only the PF=
 on the host has permissions to setup resource and configure the DLB HW, al=
l the requests on VFs are forwarded to PF via the VF-PF mail boxes, which a=
re handled by the kernel driver. The driver also maintains various virtual =
id to physical id translations (for VFs, ports, queues, etc), and provides =
virtual-to-physical id mapping info DLB HW so that an application in VM can=
 access the resources with virtual IDs only. Because of the VF/VDEV support=
, we have to keep the resource management, which is more than one half of t=
he code size, in the driver.

To simplify the user interface, we explored the ways to reduce/eliminate io=
ctl interface, and found that we can utilize configfs for many of the DLB f=
unctionalities. Our current plan is to replace all the ioctls in the driver=
 with sysfs and configfs. We will use configfs for most of setup and config=
uration for both physical function and virtual functions. This may not redu=
ce the overall driver size greatly, but it will lessen much of ABI maintena=
nce burden (with the elimination of ioctls).  I hope this is something that=
 is in line with what you like to see for the driver.

Thanks
Mike
