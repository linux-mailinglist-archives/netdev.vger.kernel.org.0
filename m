Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD691621F0
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgBRIAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:00:16 -0500
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:63582
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726114AbgBRIAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 03:00:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mm0FFtPa9O6KHYZQCNbFULmz0AwZCUXtI477Dd3msB0awGAed/IKCjflcYhU0SkxHci3+3mCFPVVxXIvPmAzDBja16hoLYm+RUP9DZoXevVmAvBghk4o8dFkqnoiHj5d5By2F7d/kC1wfCdwG76lqneFFUXBcYGHm+W1nNQ2dUOA/XSkKXfcuTWe8y/+jF7YpFizARgXx+VlCcHvTOIeNvuphju0A1NFW+SggHLuammWnmPNIFg7s8BQrUCZ9UTQ0Z6cxdhq7fQa38oxarey34XNG/y1a2NLb8V3uRBBx5uLqvfGUReV2Ac74ZtAjr6kB0OgdYhPERu9hzH76sp+Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qlk1ZiZoBNb/lJ/o5xUare6dE2mny+C1umuC1cIS14M=;
 b=Q7WLrW4wwocD9lEvrwtEMJr+PZvLErEdHLdiKEmFsVLt4ZVIMxSCg/OTY16Ri7mTLrTCVgz2CArNINpaH7yyYzH4KxkfP7Q8d5hrTmoRvnu9n1qnaUTAK85FenKk0BTlIcUoqB9LrvjYzAhntwdGtR4TbpPbOLsEAKnm9f4nGZ3Z26TFEVfpqm2uCvPMTui7+uOk1G8i3Tck7aVs5xKldkbZbe2ivApSEj+gmKGGa9XF50IlGlERLkpvQ9rMKseZdxeVZhaBBYH9WHvcE5xZVJnc4Rdvkn2U5oz4hcgnGBk1M1omsl/8zT1ehKQbwJ2n5uehB0mcXERr9HMRl2jV+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qlk1ZiZoBNb/lJ/o5xUare6dE2mny+C1umuC1cIS14M=;
 b=IbA7fTZvcovqH3zpMRsrQ7KY5mNTW9b7djcn2VRJ8uRCiGnD5b62paedB9z7Ooh496ioCZefhLGHB+PhYFwcCjex14I9fCEt9MKC33qTqfO/UOD2mDcv5TUzgg80TmMuf5e9U/MNhHNfxfd2QKP+wm9jplG2+oEz36IX+WOW/Uw=
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com (20.177.52.139) by
 VI1PR04MB5742.eurprd04.prod.outlook.com (20.178.127.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.24; Tue, 18 Feb 2020 08:00:10 +0000
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::ed73:9d46:d34:5e19]) by VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::ed73:9d46:d34:5e19%6]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 08:00:09 +0000
From:   "Pankaj Bansal (OSS)" <pankaj.bansal@oss.nxp.com>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        "jon@solid-run.com" <jon@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Thread-Topic: Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Thread-Index: AdXmMUccpWvJlrLjQUGeP0U0UIbIhA==
Date:   Tue, 18 Feb 2020 08:00:09 +0000
Message-ID: <VI1PR04MB5135D7D8597D33DB76DA05BDB0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.bansal@oss.nxp.com; 
x-originating-ip: [92.120.1.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e92bccdb-3a4c-4cc8-31d4-08d7b4489363
x-ms-traffictypediagnostic: VI1PR04MB5742:|VI1PR04MB5742:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5742B89C0CE7B8A32ED828C2B0110@VI1PR04MB5742.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(199004)(189003)(52536014)(86362001)(4326008)(8936002)(53546011)(478600001)(33656002)(2906002)(71200400001)(6506007)(7416002)(76116006)(186003)(26005)(6916009)(54906003)(316002)(55016002)(66556008)(64756008)(66446008)(66946007)(9686003)(7696005)(81156014)(81166006)(5660300002)(8676002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5742;H:VI1PR04MB5135.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MZwTz5ilBGZp+jrKZKmok653Z788XK5FgE9eWpSuaDKcU2e4ZpPUGcFUH6SQCa8klhJ3Iy1pesUMyrXO+nyyIDa9wm7vWQkmiJEXEY7aKw2FT9CFR+ew0HSH24ic1IcQty4SN8VMZW3pWXvzn2Ce+iY2bz9sQoAt/wj7XinfaDQdynWFjtDfiVPxBzDQPQsVMLN31T+RrL168csQnTBRhYqVQeFOCBdrgd3yY2lLJVJeRZzufLmjq4F/Bft9b623JD7Qx4bZMtvn8k+4FWj91p0pfnh9pqJR9NVcWCVY8pskAl1WCA1BpFXwVhijI6mxDxQmd+tfdU5VC07GP+OeeQHZmbnstdbCl19Et6xVjX7J+Vh4PzCFbO8akqRtdnPp70kapE+/+WF4sRPfOMqifVAVMA8i1auVH7RUxCF7AYnN2C1vOq5Ptxp70DxwGY1G
x-ms-exchange-antispam-messagedata: mcyelNs2qq81YkqBG3XFVATPZY+sb+/gLCwyJW10se9YDBWtcJPE56cOE8qDYuVZC2EWo89Mu1xYCOlj6MZlN8ImRXNQsEeh7C+3Db1zHZQRRt35H3GUxboiJzD5GnJNpyBNAHlS8nVY+mTi9kSRFg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92bccdb-3a4c-4cc8-31d4-08d7b4489363
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 08:00:09.8101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K5oEvqF13PEX9ZLjQjOMz496G3e/kSaElM9ZrGlZ8qzMJ4N7LUrclrDnfy2CUlVXhMQ8K5A7sQXVyTuVMpU2LzvRf4uVRl6q/xbfM70O9a0Sg04skChF2La4abUPY9yd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5742
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Sent: Monday, February 17, 2020 8:55 PM
> To: Pankaj Bansal <pankaj.bansal@nxp.com>
> Cc: Marc Zyngier <maz@kernel.org>; Ard Biesheuvel
> <ard.biesheuvel@linaro.org>; Makarand Pawagi <makarand.pawagi@nxp.com>;
> Calvin Johnson <calvin.johnson@nxp.com>; stuyoder@gmail.com;
> nleeder@codeaurora.org; Ioana Ciornei <ioana.ciornei@nxp.com>; Cristi
> Sovaiala <cristian.sovaiala@nxp.com>; Hanjun Guo <guohanjun@huawei.com>;
> Will Deacon <will@kernel.org>; jon@solid-run.com; Russell King
> <linux@armlinux.org.uk>; ACPI Devel Maling List <linux-acpi@vger.kernel.o=
rg>;
> Len Brown <lenb@kernel.org>; Jason Cooper <jason@lakedaemon.net>; Andy
> Wang <Andy.Wang@arm.com>; Varun Sethi <V.Sethi@nxp.com>; Thomas
> Gleixner <tglx@linutronix.de>; linux-arm-kernel <linux-arm-
> kernel@lists.infradead.org>; Laurentiu Tudor <laurentiu.tudor@nxp.com>; P=
aul
> Yang <Paul.Yang@arm.com>; netdev@vger.kernel.org; Rafael J. Wysocki
> <rjw@rjwysocki.net>; Linux Kernel Mailing List <linux-kernel@vger.kernel.=
org>;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> Sudeep Holla <sudeep.holla@arm.com>; Robin Murphy
> <robin.murphy@arm.com>
> Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
>=20
> On Mon, Feb 17, 2020 at 12:35:12PM +0000, Pankaj Bansal wrote:
> >
> >
> > > -----Original Message-----
> > > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > Sent: Friday, February 14, 2020 11:20 PM
> > > To: Pankaj Bansal <pankaj.bansal@nxp.com>
> > > Cc: Marc Zyngier <maz@kernel.org>; Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org>; Makarand Pawagi
> <makarand.pawagi@nxp.com>;
> > > Calvin Johnson <calvin.johnson@nxp.com>; stuyoder@gmail.com;
> > > nleeder@codeaurora.org; Ioana Ciornei <ioana.ciornei@nxp.com>; Cristi
> > > Sovaiala <cristian.sovaiala@nxp.com>; Hanjun Guo
> <guohanjun@huawei.com>;
> > > Will Deacon <will@kernel.org>; jon@solid-run.com; Russell King
> > > <linux@armlinux.org.uk>; ACPI Devel Maling List <linux-
> acpi@vger.kernel.org>;
> > > Len Brown <lenb@kernel.org>; Jason Cooper <jason@lakedaemon.net>;
> Andy
> > > Wang <Andy.Wang@arm.com>; Varun Sethi <V.Sethi@nxp.com>; Thomas
> > > Gleixner <tglx@linutronix.de>; linux-arm-kernel <linux-arm-
> > > kernel@lists.infradead.org>; Laurentiu Tudor <laurentiu.tudor@nxp.com=
>;
> Paul
> > > Yang <Paul.Yang@arm.com>; netdev@vger.kernel.org; Rafael J. Wysocki
> > > <rjw@rjwysocki.net>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>;
> > > Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> > > Sudeep Holla <sudeep.holla@arm.com>; Robin Murphy
> > > <robin.murphy@arm.com>
> > > Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-=
mc
> > >
> > > On Fri, Feb 14, 2020 at 04:35:10PM +0000, Pankaj Bansal wrote:
> > >
> > > [...]
> > >
> > > > > -----Original Message-----
> > > > > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > > > Sent: Friday, February 14, 2020 9:50 PM
> > > > > To: Pankaj Bansal <pankaj.bansal@nxp.com>
> > > > > Cc: Marc Zyngier <maz@kernel.org>; Ard Biesheuvel
> > > > > <ard.biesheuvel@linaro.org>; Makarand Pawagi
> > > <makarand.pawagi@nxp.com>;
> > > > > Calvin Johnson <calvin.johnson@nxp.com>; stuyoder@gmail.com;
> > > > > nleeder@codeaurora.org; Ioana Ciornei <ioana.ciornei@nxp.com>; Cr=
isti
> > > > > Sovaiala <cristian.sovaiala@nxp.com>; Hanjun Guo
> > > <guohanjun@huawei.com>;
> > > > > Will Deacon <will@kernel.org>; jon@solid-run.com; Russell King
> > > > > <linux@armlinux.org.uk>; ACPI Devel Maling List <linux-
> > > acpi@vger.kernel.org>;
> > > > > Len Brown <lenb@kernel.org>; Jason Cooper <jason@lakedaemon.net>;
> > > Andy
> > > > > Wang <Andy.Wang@arm.com>; Varun Sethi <V.Sethi@nxp.com>;
> Thomas
> > > > > Gleixner <tglx@linutronix.de>; linux-arm-kernel <linux-arm-
> > > > > kernel@lists.infradead.org>; Laurentiu Tudor
> <laurentiu.tudor@nxp.com>;
> > > Paul
> > > > > Yang <Paul.Yang@arm.com>; netdev@vger.kernel.org; Rafael J. Wysoc=
ki
> > > > > <rjw@rjwysocki.net>; Linux Kernel Mailing List <linux-
> > > kernel@vger.kernel.org>;
> > > > > Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> > > > > Sudeep Holla <sudeep.holla@arm.com>; Robin Murphy
> > > > > <robin.murphy@arm.com>
> > > > > Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for =
fsl-mc
> > > Side note: would you mind removing the email headers (as above) in yo=
ur
> > > replies please ?
>=20
> Read the question above please.
>=20
> [...]
>=20
> > > > As stated above, in Linux MC is a bus (just like PCI bus, AMBA bus =
etc)
> > > > There can be multiple devices attached to this bus. Moreover, we ca=
n
> > > dynamically create/destroy these devices.
> > > > Now, we want to represent this BUS (not individual devices connecte=
d to
> bus)
> > > in IORT table.
> > > > The only possible way right now we see is that we describe it as Na=
med
> > > components having a pool of ID mappings.
> > > > As and when devices are created and attached to bus, we sift throug=
h this
> pool
> > > to correctly determine the output ID for the device.
> > > > Now the input ID that we provide, can come from device itself.
> > > > Then we can use the Platform MSI framework for MC bus devices.
> > >
> > > So are you asking me if that's OK ? Or there is something you can't
> > > describe with IORT ?
> >
> > I am asking if that would be acceptable?
> > i.e. we represent MC bus as Named component is IORT table with a pool o=
f IDs
> (without single ID mapping flag)
> > and then we use the Platform MSI framework for all children devices of =
MC
> bus.
> > Note that it would require the Platform MSI layer to correctly pass an =
input id
> for a platform device to IORT layer.
>=20
> How is this solved in DT ? You don't seem to need any DT binding on top
> of the msi-parent property, which is equivalent to IORT single mappings
> AFAICS so I would like to understand the whole DT flow (so that I
> understand how this FSL bus works) before commenting any further.

In DT case, we create the domain DOMAIN_BUS_FSL_MC_MSI for MC bus and it's =
children.
And then when MC child device is created, we search the "msi-parent" proper=
ty from the MC
DT node and get the ITS associated with MC bus. Then we search DOMAIN_BUS_F=
SL_MC_MSI
on that ITS. Once we find the domain, we can call msi_domain_alloc_irqs for=
 that domain.

This is exactly what we tried to do initially with ACPI. But the searching =
DOMAIN_BUS_FSL_MC_MSI
associated to an ITS, is something that is part of drivers/acpi/arm64/iort.=
c.
(similar to DOMAIN_BUS_PLATFORM_MSI and DOMAIN_BUS_PCI_MSI)

>=20
> > And IORT layer ought to retrieve the output id based on single ID mappi=
ng flag
> as well as input id.
> >
> > >
> > > Side note: can you explain to me please how the MSI allocation flow
> > > and kernel data structures/drivers are modeled in DT ? I had a quick
> > > look at:
> > >
> > > drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
> > >
> > > and to start with, does that code imply that we create a
> > > DOMAIN_BUS_FSL_MC_MSI on ALL DT systems with an ITS device node ?
> >
> > Yes. It's being done for all DT systems having ITS node.
>=20
> This does not seem correct to me, I will let Marc comment on
> the matter.
>=20
> > The domain creation is handled in drivers/bus/fsl-mc/fsl-mc-msi.c
>=20
> Thanks,
> Lorenzo
