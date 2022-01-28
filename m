Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4E44A01F2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351310AbiA1UaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:30:11 -0500
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:58880
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344402AbiA1UaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 15:30:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPEPuL+rx+JSkuXYMjaCx+tDdZuj1ZRbR854/Kyq08pydcz6ieKxIDm7ULYu51x+1xH630gL/rD2madhlUkEvMWFmofqBxyhWL/CEbBcSTJUiZh2tPQptU3nnvQuVRBQgFJPBr+v/v7c52WyPc5Kg4DDvrrs0BkMIf9svJh7XYOFaSCp06014DlSyLJ5H4kPPxtOxJkFBAsGAVvtkU9GZVRSRSESKBbl5L5T65/mYprFRkpibxtBdSW0xTDgZWwb+tFezhswQIMENRh8TLCJnFxPDNT4qZRVHVf2TWu+Dq88ufF4l2/d3RdoNNFwNynM8RXNmao/CF+DO/zPhrr6IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DqZzpYpaq4kq5iPQyQ44D4TmXWs6a0Ihu+vnQvYuII=;
 b=hGJIDjYCquiwxkoDTmRVNXlIbAT5NtieSvGbZerQApnrYXE0TH4no4yvtOzJTju4io3S8iEkMYgzU5osiSlYCjp4hBiT7zY8sDm78k3Jz1YKXmDYzyKMhLZxrH4ve684QtzLB8jSjSAxIjsympV4dei+3nkNEPoYnZmlH7vTkaDDkrDnWnfG44Qg3nhAopUvq/F++8yZJAsDvnLBBkZXO/HejZ9ufhD0PoyIIYq04vTHgFnFNlo5hz96KCT95h/uj24mOHcqg3J2lgNeF9h2ffBh5d+cp6knYKiD4WCDmIRKr+qUI0pL3qWq/lLdPvF5NuptWmSX/j043SCCUYuDJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DqZzpYpaq4kq5iPQyQ44D4TmXWs6a0Ihu+vnQvYuII=;
 b=ZEeYMjpz4EmOq5Ep4ONXvn/oGrMqQFeWpT4yxAUEl61jPy21SJWMyEqQqipOmljCgI2SWHndEHvamhVKAJOaTLGZOtWOLZq1tv+hGX6rSXFJhAGi420VPYma95kJSgC4OfaMenPHFCSO4m5w/G4DP13wSsrtPZHhBVLwt1oaDgQ=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Fri, 28 Jan
 2022 20:29:59 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4930.018; Fri, 28 Jan 2022
 20:29:58 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Henning Schild <henning.schild@siemens.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Aaron Ma <aaron.ma@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hayeswang@realtek.com" <hayeswang@realtek.com>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: RE: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Thread-Topic: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Thread-Index: AQHYFAALP4fXSy15IESwbHMcR00FLax4F/qAgACjk4CAAACvgIAAJLoAgAAAruA=
Date:   Fri, 28 Jan 2022 20:29:58 +0000
Message-ID: <BL1PR12MB5157796F50C523D32F0F3C5DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
        <20220128043207.14599-1-aaron.ma@canonical.com>
        <20220128092103.1fa2a661@md1za8fc.ad001.siemens.net>
        <YfQwpy1Kkz3wheTi@lunn.ch>
        <BL1PR12MB515773B15441F5BC375E452DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
 <20220128212024.57ef9c59@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220128212024.57ef9c59@md1za8fc.ad001.siemens.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-28T20:22:56Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=5d6f02cc-d066-442b-93e6-fa60efcbab03;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-28T20:29:57Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 630936a8-057b-472d-8b8c-36a6be607381
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d945880c-0a57-4539-ef99-08d9e29cf428
x-ms-traffictypediagnostic: PH0PR12MB5607:EE_
x-microsoft-antispam-prvs: <PH0PR12MB560739197072F98D232CA0DEE2229@PH0PR12MB5607.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vO3s5XLjonNaVAGc4EmCi1wd1zo6T0E3ItR+Z26Nk4kkAoA5sUTqVADsfjIM2iRxinmt3bjtBxh479UNQ1wms/mknnMgMyQ6YtlVjvOgoBX34Urx/7D2Y1E4t/Zo+03iV2C79I9PBklwULsQZuqdyDrMdpLvDLhLPd66tqcxQHMw0MZoEzwFnJxlbDZHOq39tYOoKmWkSWt9SLj6MGYVM+l+7C1Gmnfx793+E0QxktQfSwbf0t0Nfn8CjSsNYS4NV6WdBYQJ0ORfWADPzl4QwXu4njXGtp+Pd0JamsrorsGcNbfBtnr0ca9rKFjuKYV8wutj/XRmZbJKknDWD1OTC/1CI8Nkp4c3kgdLdXA1oM0hK3+XfJGsk1B+W1Y/QMv2yL97ycqeNlyQcxfkwfsM/KNzUxoEoEnd+9ewttyymrZOlzGfiwYiMqhwziw6+J/WqRFvUyKb/+OCfC9wlvMTVWLL30A58iAqt+9ShtClxYPb0N0GoCWNmyaqSd3zX/q+wM87c21WbcBADLlYLnnqiEEtP2Q6ClgC4U+uqlrYYNYzTTmo+wCvr8HLzgD4nnTNgdMUOuJP6CtcjJh9KyJwf0aMlMogaWayKRYKo/UupMy03EPnASa3HXomzHJB2lASeShsYVAeC2HgwY4YAzj+dxYS/dTPDi4lIxI3qme2PPzP5BziGDMPCy2nca2LF+SIeWZG79iEJhyVzzlaQC+E3TljM3/4859VPT/pjNw3/jgh/wJ3HpYvwkfX3TBtxIxgRjwUREpmX1XH66u3WjYQGh/xd/otWII50JmtnQa4HT4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(186003)(6916009)(54906003)(38100700002)(55016003)(52536014)(38070700005)(66556008)(966005)(66446008)(45080400002)(71200400001)(122000001)(316002)(5660300002)(83380400001)(2906002)(76116006)(4326008)(7416002)(26005)(66946007)(66476007)(7696005)(8936002)(508600001)(9686003)(86362001)(33656002)(8676002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JfiA1onfVzsYTsqty7fBWR1+o+/eF3+/bLhANcEA7CVd4ya90FSMOmneOFkd?=
 =?us-ascii?Q?DIENHBlwTwBTXHgk3Z0BcB3PS/QA8DNWVfRbigsftGCIn9zG8bJivM1Tav/d?=
 =?us-ascii?Q?8/Osi2vzZQ+cQA2iecdtPF85qWb8dowa0uOmt821VSiJYC06mk3I+RaTLgfG?=
 =?us-ascii?Q?uEsvFY/GUSo9l2J9COW9XI8iwXGIILUeGxPAFey/8Etsq1oO1eccCQCxAKq6?=
 =?us-ascii?Q?MMj/vHob+FRl1bM/CijtfEx9ukopmreZMHTTF4CzqilOVRyAj1ByrJ/Nj6Mg?=
 =?us-ascii?Q?oWAxzSVX4DbOVlphfnQS1f8dBiDjt5Z9otDz17gLG77fgKUatOuqzQaVe7Ux?=
 =?us-ascii?Q?rM4pb6RtajLJ/cK2qwro+HJvjA7b9UGZm1xcoowzXD63cPQ+oZ02WafKbI0F?=
 =?us-ascii?Q?ByDfvXUDK+k3av+j6U3OmeVwj15hUomdR3DbWXTHv6upiY50XuY4VrN5ZE9W?=
 =?us-ascii?Q?HYipup84TsvWR8pfdffbWQFNmfE9Xfxf8lPCVG5U4pl1UsfcqAL3r2joAj3B?=
 =?us-ascii?Q?vGS2T7xdny+UatAJj575dj799Y2vYFMUcYuOq8y/KjzOP6fpoFszQ5v3RgYi?=
 =?us-ascii?Q?i9edsQVv+EWMzgPGoKU6MsGWnj07oAjOMXkhgzuFbI/jQLJUfFYCPAoM6dV7?=
 =?us-ascii?Q?H0LelcByonZTWUf0w2eQ5x3KpLaV10rN5q1YevphCqF3vJYJyVUzBwmvxq9V?=
 =?us-ascii?Q?yIky//OqXMNe/gD/BopF+2MyITmMUaiVn2AFN6o2OiEgoedjPKs9FLYDfO90?=
 =?us-ascii?Q?2yZcItu0wX3ntH9I9+lbT12Z6mNIqyK0mYkNl5+Bgfeu8sXu8mZZh8HOaTeF?=
 =?us-ascii?Q?PPeo0hwW4CABp4lkzxVCQ3TjWNC2bJkwQJLoh1F/JpaRyfLJOeeWI8Mnrh4g?=
 =?us-ascii?Q?/+ey7Vmf5sPXMKYS9fzdFozw2mG9cegQKHOZrKLJF2h4lWJ9K5OfatzfkATv?=
 =?us-ascii?Q?pn4hAQxKj6CuzYhzE6q7f3Bq0hQNb9DD+FIIZQ1qITQnxIeRVqgF6GirzsU0?=
 =?us-ascii?Q?1aPBQPJS2YVfl7zx5eQ54Bt+9LHZkMaMHs7OkaVKMku4tj1LIfARCtqtoFA7?=
 =?us-ascii?Q?oaJ7BOAjzWeXR89MGK1kvFwAki/bSQ2UZuulJu7KBikj4tbPrWhEgz9RKSOh?=
 =?us-ascii?Q?/ncXcMdmDVlBy7skyuvGF3AAOMM1Sc3I02ccuX7UdcI2XHBiq7pfzR8q0SPs?=
 =?us-ascii?Q?4peawri9Qsglcx2lOU2yV3HDADtPRtxOfvxu6VLrUhB0Q3CYqrgTa9CVINzJ?=
 =?us-ascii?Q?0nKS9l2edtnJ2K7p9YIk2X9OMVAzZKdyRPjYDQyfyvZWHYfZNJ5H65CXvXTr?=
 =?us-ascii?Q?fk8uMEh3h9ia9N5t8KtTcheIjG8bUBvFzOt7OS1ePkOTXsMFtgp5Vsxjfg1F?=
 =?us-ascii?Q?7VoN6bBqJ4+UZajZxBhG0UrtXzDbNL1sLbE1zpl6OyZ0xyirajhTa8siEJjb?=
 =?us-ascii?Q?rCxQ5NocKLvoQEoo2r9h0OFLQg5ejE1DEO4VzwFZhytQzMF47Pdk4bTrA4zH?=
 =?us-ascii?Q?o259XVf7sLuDGXRfV0Cop4JK14Gh+HL00KZ9vZIeTfXxlmOIVtLCtWlw0sNU?=
 =?us-ascii?Q?V3nuLMvzqGpfkJwJf9/2CURZCMt3+jTM7pTfQ3aUS4Bnll3BV00nmjaPJOmZ?=
 =?us-ascii?Q?apbv2cQyZO/RssXyGjxwQH4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d945880c-0a57-4539-ef99-08d9e29cf428
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2022 20:29:58.7641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qjJfSBgeUy56Sw9fl7/pKi2nPR9I+mplwdjUwAIGWKqY5E2tjr0MJ26rBM6fqTQ3M4vT1w6MgA512vSf1ZWdVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Public]

> > > I've not yet been convinced by replies that the proposed code really
> > > does only match the given dock, and not random USB dongles.
> >
> > Didn't Realtek confirm this bit is used to identify the Lenovo
> > devices?
>=20
> The question is really why we do all that and that answer really seems
> missing. Lenovo might have a very different answer than Dell. All i saw
> was Lenovo docks that suggest PXE. While that could be a good case,
> bootloaders and OSs should then inherit the MAC of a NIC that is
> already up. But sure not try and guess what to do and spoof on their
> own. (based on weird bits and topology guesses) I am willing to bet that
> grub/pxelinux/uboot/systemd-boot would all fail a PXE run even if the
> OS to boot would spoof/inherit.
>=20
> PXE uses spoofed MAC and bootloader will dhcp again and not spoof. dhcp
> would time out or fall back to somewhere (MAC not known), Linux kernel
> would not come, PXE boot failed.
>=20
> In fact i have seen first hand how PXE Windows install failed on a
> Lenovo dock and the real NIC worked. That was within my company and i
> sure do not know the BIOS settings or what bootloader was involved and
> if that Windows installer did active spoofing. But i would say that the
> PXE story probably does not really "work" for Windows either.
> In fact i am willing to bet the BIOS setting for spoofing was turned
> on, because it seems to be the factory default.
>=20
> And all stories beyond PXE-bootstrap should probably be answered with
> "a MAC does not identify a machine". So people that care to ident a
> machine should use something like x509, or allow network access in any
> other way not relying on a MAC. If "Linux" cares to spoof for the lazy
> ones, udev is a better place than the kernel.
>=20
> > > To be
> > > convinced i would probably like to see code which positively
> > > identifies the dock, and that the USB device is on the correct port
> > > of the USB hub within the dock. I doubt you can actually do that in
> > > a sane way inside an Ethernet driver. As you say, it will likely
> > > lead to unmaintainable spaghetti-code.
> > >
> > > I also don't really think the vendor would be keen on adding code
> > > which they know will get reverted as soon as it is shown to cause a
> > > regression.
> > >
> > > So i would prefer to NACK this, and push it to udev rules where you
> > > have a complete picture of the hardware and really can identify with
> > > 100% certainty it really is the docks NIC.
> >
> > I remember when I did the Dell implementation I tried userspace first.
> >
> > Pushing this out to udev has a few other implications I remember
> > hitting: 1) You need to also get the value you're supposed to use
> > from ACPI BIOS exported some way in userland too.
>=20
> Sounds like a problem with ACPI in userspace. So the kernel could
> expose ACPI in a better shape. Or you will simply need to see what
> systemd thinks about a funny "sed | grep | awk | bc" patch to parse
> binary. DMI might contain bits, but without clear vendor instructions
> we would be guessing (like on ACPI?).

Yeah I think if this is to be reverted, step 1 is going to be to export tha=
t
data into sysfs from some Dell and Lenovo drivers so userspace can get it.
No funny sed/grep/awk to parse binary.

DMI doesn't contain it (at least for Dell).

>=20
> > 2) You can run into race conditions with other device or MAC renaming
> > rules. My first try I did it with NM and hit that continually.  So
> > you would probably need to land this in systemd or so.
>=20
> For sure you would end up in systemd (udev). NM is just one of many
> options and would be the wrong place. You might quickly find yourself
> in mdev (busybox) as well because of that PXE case or because of an
> initrd.
>=20
> If it was my call i would revert all mac passthough patches and request
> Lenovo/Dell and others to present their case first hand. (no
> canonical/amd/suse proxies)
> The "feature" causes MAC collisions and is not well understood/argued by
> anyone.

Reverting it has the possibility to really mess up machines people have in =
the
field that have behavior built around it.  I think a clear set of rules for=
 what is allow
to use it is the only safe way forward.  You need to "clearly identify the =
device" or
something.

Just FYI I'm not intentionally acting as a proxy to anyone at Dell on behal=
f of AMD,
my only involvement here is because I did the original implementation for D=
ell
when I was there and so I can speak the how things were and thought process=
es at
that time.

If the consensus is to revert this then someone from Dell probably does nee=
d to
speak up.

>=20
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fen.wi=
kip
> edia.org%2Fwiki%2FMAC_address&amp;data=3D04%7C01%7CMario.Limonciello%
> 40amd.com%7C385b6dd02672490749d208d9e29ba192%7C3dd8961fe4884e60
> 8e11a82d994e183d%7C0%7C0%7C637789980357612909%7CUnknown%7CTWF
> pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6
> Mn0%3D%7C3000&amp;sdata=3D9vmPi1%2FF%2BxrkqpjoYoLmmupAJ1vBMckLLo
> 5hDMqTuZA%3D&amp;reserved=3D0
>=20
> > A media access control address (MAC address) is a unique identifier
> > assigned to a network interface controller (NIC) ...
>=20
> unique and NIC, as opposed to colliding and machine
>=20
> Henning
>=20
> > >
> > >    Andre
