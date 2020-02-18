Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8331621F6
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgBRICq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:02:46 -0500
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:59934
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726114AbgBRICp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 03:02:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFgo+FvvNxYrEcMkdifG89brK8ghZhSkK3oGq7ORF7ce740UZwxUC833FchNSgec3liM/kOUob9eHUZPoXwuLnzIv2jCH0la20MHxm6k8naFt8ktD+0U59RQKdRLVh3M7uO4U/IsHPG0LaVCt5Fl0otVxcbupKgvsBphajZd4vCQiL+p1jbihjw6gmjsmBMUur3tEzPMbvd7SlVMj8+jHhnwZT4/5LINQ2BD1yPwMCliM38FBbngFtml9BhpTudqbwM9kMetzlxIq3JTIR5OpJn0Dp9pYEzI9xZoU4svc96pxrekJi3n0boP/UNwzoJce82t1ecUbksnmcG1Z/lWTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qlk1ZiZoBNb/lJ/o5xUare6dE2mny+C1umuC1cIS14M=;
 b=nOhlvY0dzvhs+8U5F4SgtYKmoI/8HInvnbRACbQ2tTBOv0Gjbz3NK3yR4Jebsa+jDlpKGkEox9ZRaR/1gvDq4aAocvpmeaqWJ6XZMOtRDdJWYqmyY1yxIkEGX3g8VUqtaH459BQuchJ7tIIkmljrNAY1mr7XwBqlQX/TYI/LbLwQ+XVSjuePl08dDOJZtXfluaQQMKuglYSiNtXgKmVytfcPCH/DGsoDPaWuXnYgY2cYDeTpXR/46kTp6GPz9+bkaw0s8DD7SBJPQ+WQA1M49RPgUxnRh0RygVsCLR/C3J+5DAKg/7K+8UriOi7m8aOn6J7p6rGp3D5YT1YO4t3hqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qlk1ZiZoBNb/lJ/o5xUare6dE2mny+C1umuC1cIS14M=;
 b=ARjyvK7mcpHzeSBG9kGsUGhQsb87FSf011e9yE2EXU0nvg1AtxQ8KoDZm0r0ut/NidJbJZakkX0EYVrHKbWLx3euhStp9/wqmXnqsza9sywWCs8+a85qjTMHDRpTxspCv78Rg+mK5hEk0I068cmRjZBv3smIaOgL2vuuwCBlo7I=
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com (20.177.52.139) by
 VI1PR04MB5742.eurprd04.prod.outlook.com (20.178.127.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.24; Tue, 18 Feb 2020 08:02:41 +0000
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::ed73:9d46:d34:5e19]) by VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::ed73:9d46:d34:5e19%6]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 08:02:41 +0000
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
Subject: RE: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Thread-Topic: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Thread-Index: AQHV1bJZgaFB40NXxUCtFFLRVXyi06f/610AgAStpQCAAAiuAIAAD1yAgBYviuCAABITAIAAAFRwgAAG0ICAAAEwoIAAF+uAgARaY6CAADQ7AIABFovw
Date:   Tue, 18 Feb 2020 08:02:41 +0000
Message-ID: <VI1PR04MB51353FF263391E5FBD1629B5B0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
References: <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <VI1PR0401MB249622CFA9B213632F1DE955F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <7349fa0e6d62a3e0d0e540f2e17646e0@kernel.org>
 <VI1PR0401MB2496373E0C6D1097F22B3026F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200214161957.GA27513@e121166-lin.cambridge.arm.com>
 <VI1PR0401MB2496800C88A3A2CF912959E6F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200214174949.GA30484@e121166-lin.cambridge.arm.com>
 <VI1PR0401MB2496308C27B7DAA7A5396970F1160@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200217152518.GA18376@e121166-lin.cambridge.arm.com>
In-Reply-To: <20200217152518.GA18376@e121166-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.bansal@oss.nxp.com; 
x-originating-ip: [92.120.1.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d1d4080-59af-4156-6a4e-08d7b448edc2
x-ms-traffictypediagnostic: VI1PR04MB5742:|VI1PR04MB5742:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5742D38E40438767CA2D6237B0110@VI1PR04MB5742.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(199004)(189003)(52536014)(86362001)(4326008)(8936002)(53546011)(478600001)(33656002)(2906002)(71200400001)(6506007)(7416002)(76116006)(186003)(26005)(6916009)(54906003)(316002)(55016002)(66556008)(64756008)(66446008)(66946007)(9686003)(7696005)(81156014)(81166006)(5660300002)(8676002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5742;H:VI1PR04MB5135.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xrbotrZibDrXthDh1JClh3LW2N2vJd+SmahCKxwrCxFtHskQId13Lel8o1U2FKtmXKlJ4TwG836wdg65wJNRc1wvqBf7iVzRAlHorOR3OY8gDC7x074+dld3OUwaC4JlPTChUCOAa4eDfOvE3pEGM1hbdf1eBAjdPNCRG82nWXW7h2CDi5qRsPHo2ThbzWxSMK9yQKPvULYfgTa2Q6PMG13p+FliDBlZHEJwxsaHtYHxvaoyZEFmJN//HyYUjKtT67apwYXC0J0hCa4KfdfdhKm5+oNpF6LYH/DjGB5U3r8LB6ptDw5YjG+3TezUt+WH0fNK58VjEP/CyTVc2v47x84gFsYzazXVucLATnWWS34GRlsfwmD/hBjX81qzINFLWbzQ/qIhdGLdiju9uJO7qIva20QhQT2dGMU9zGejQ9TRGubo5UJ8nnBUqOjNxAOC
x-ms-exchange-antispam-messagedata: +656RCIVDCsnK6w1MW7Zg/IMnkpvU3wFkHOCQf/PczEiw00cB5A3kzJ1tY5AU0in2Wl8FDqDEEsf0U1ywn229DB9d8xYHFFE/XgEDDLqmRnewgUGG5D0Ofdh+9AiMDSiFhXg68cm1ulhjx25edj/JQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1d4080-59af-4156-6a4e-08d7b448edc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 08:02:41.4741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aRZsIbLvRep0h0GSx886cB4/5el1kPYqVQaSRwmt6jX3/6cVK4c/3PdihmvG3PRuKp1xTNX67lAuEYe9PSO9EH77AEl8U1OHS9IHfsr/eNyetb2irxAxWK3tPcv6NJ/h
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
