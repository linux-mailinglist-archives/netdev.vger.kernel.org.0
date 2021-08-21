Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34E03F3C8E
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 23:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhHUVSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 17:18:39 -0400
Received: from mail-oln040093008001.outbound.protection.outlook.com ([40.93.8.1]:49843
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230003AbhHUVSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 17:18:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnfYTmFkSb8QVF2LJDMHLqiHU+c9wBPosyJOtO/8nFAlDb8KIONQrh/t8p4PJoVEH8+0vHBIMnjbuljSOjeu2BzJn6OC64wIM5sEF3TwmBHWFpVqwcXE0q/t14cvLUafLG6pKjkegn+agqG66hu4dY4898KXPAc6g/qBxdD9Pob7URLRE6RPIC9gNTgHi0a+DxBDPLnSldK+t/jo59FS7xqFmOOAJQXULezFx9pbrKvA7l429U30qCG5/nqGeaXCYa0uYusJ284alCd8EqBejvqnwLaE1Vs8mL7CZ6Auusk/0lvod4U1MolMa9ElR5nXVRyQPcPYoN4BW7g/AVco2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7YEDmzbsvRwxHCP5vnFhTqWBYogn+E7OeoUwoMYho14=;
 b=fsb/aBALi06L95PgcIOaEYxl35zpHiYXlfZjkya1VWxCtLejqPWbtd0nfWKJITfoVDHDHX/9vQvhNWm8EAg1xOcxV+aW6RpDHGK2uto79s4Ipw/aJlmtPL2oIxiRqD2FoEzIMkk5AX00NYnuJnpi7fSce/BQ3MY0T65zjghEkdbUMfrRkRy1gyGsZOymjh0/xK1Mba7cGR5bYMnNeZZycPBNj0s55feotTbn72E4BTJBBGcM0PxkZkr+NLnioO0l+lrnbr5LWaHJR+GwdptDIUFH52BOo4CPvHgNZlOFOGtAatSCyBPNB2mq7weL2mJlW5pgk2FBpUMMdtEhJZC/2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YEDmzbsvRwxHCP5vnFhTqWBYogn+E7OeoUwoMYho14=;
 b=jtrjubaJssj+eT2wylebi0UKNLq47UGWJCkP26f38lo+Yhwq2DpMYGUNFu8HSQD95fJ3wQUdIcTgUIt4cjJZAUjy9+AXoOwH97JCdu77kqjhKPaYXyre7s8eQt5A48EI2uRalfjMJAaGadHhaMzo8FEmkuorcZYGq3HjlyVR8eQ=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by MN2PR21MB1277.namprd21.prod.outlook.com (2603:10b6:208:3d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.0; Sat, 21 Aug
 2021 21:17:56 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::b5fb:5714:f890:e69e]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::b5fb:5714:f890:e69e%3]) with mapi id 15.20.4457.008; Sat, 21 Aug 2021
 21:17:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] mana: Add support for EQ sharing
Thread-Topic: [PATCH net-next] mana: Add support for EQ sharing
Thread-Index: AQHXlgQDWZC2thMJY02Y9szk3dkpa6t9HCeAgAFXN/A=
Date:   Sat, 21 Aug 2021 21:17:55 +0000
Message-ID: <MN2PR21MB1295573318B3897A2039B094CAC29@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <1629492169-11749-1-git-send-email-haiyangz@microsoft.com>
 <BYAPR21MB12708078CCAD0B60EAA1508BBFC29@BYAPR21MB1270.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB12708078CCAD0B60EAA1508BBFC29@BYAPR21MB1270.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=39af8494-2174-414d-b904-55e74a9fa146;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-20T22:30:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4ce24a7-65f5-493b-7a97-08d964e924f4
x-ms-traffictypediagnostic: MN2PR21MB1277:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1277E376001AAB650CB65F96CAC29@MN2PR21MB1277.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xA9A1+mYAfohHFi21KNpjrJYMdm23EuVwI7KO99OXk0kZvWe/VF7gUsGhgrfD8uhQodAw7EpCGYVd0qKdfaTOKZygerKjia0B8ZaW0nSCpKwT7125ISdFDLQhfNgv2k0YT73dgK83EWxppaeR5HssE0i11FWTaR0T7uCWtM85dXEEgSomRCZzE3tEgJ7pCJUdpRJ2H9n0yM2PXGtmJ6dmBPDU1Eo2fqVRtJV3D+Hk1CxfCNtd43WKb2Myuv2tKO9KLSl/aAZVcA25VfVms2tEaFD1Y0wz/I8dCHBdqYGuNuBBiDJn4a7Av24X+1n4xWO9vhFX/IxWK/lE+/S3wePRVp+wrxgO9cvgrfJCPx61hW5HK/cTcaxlg6c3vgpGWqc0kfE0WMy6vaR3h4KGd2DKofpaf07Q7TCzi/+VLP4N0BmUa66/ubPrlGyoLLH7Z/ridvBu8WndImcdo3R8a5CTl4Oo+jFaDM7WQbnQn8xDT8VWRF/dOmPRJh/wxzUIDSbqoMBT1ZmM4dS+t7Q5zO05oloPzkHlc6d2HSaqfd6J4G4wX4KC1rLV+4EdepvuglgsIg6SVNsdz6r4PWaX4fJSWWidEYG1J0kopf7c3bbdSXIQyaGx6vo/Wlu2tyzBkfO1X227HODqFyHjb/d8dHm/mYRxLC18HNloZ62x2UQbBocyuRsxGA2EXCQbrUMNXxyXkFYAwvH+Q49E4cYW5+1xw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(4326008)(66946007)(66446008)(76116006)(7696005)(66476007)(66556008)(9686003)(26005)(52536014)(55016002)(71200400001)(186003)(508600001)(6506007)(53546011)(64756008)(5660300002)(86362001)(10290500003)(2906002)(54906003)(8676002)(83380400001)(316002)(8936002)(8990500004)(110136005)(38070700005)(38100700002)(82950400001)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7x2dPOJxw3wFt27FVqTkK9ocYqci955pDRjakPybPmO51rubH437gK5hiol8?=
 =?us-ascii?Q?WS6i8TGLwDIzcvKwo6fQ5bQG6CSbeouOdGTdQzv1m+3I8fPWzV9oaQk3t/43?=
 =?us-ascii?Q?7iQYi6V0vuu49yLsrjeqDtBPm/XzcXPrP6iRFQW/O7QgY5EAYvTB1j1pND2H?=
 =?us-ascii?Q?xMZWKFguEDnYhl/iHeA1NdRd9OYedTZ3o2cKbQcYdD5/xiLbs7FLFtBAyadO?=
 =?us-ascii?Q?yfqhEHfwVLeiXilEq0Q0s7GA2D/q6gfCf0+ua1j2W9vJFaMND9WZS8KAx712?=
 =?us-ascii?Q?tXpc5fTgGuye/vhgFL1J4v63LC4+b8z9wX0iUgXik0goVN+loC5y+6vLbpKe?=
 =?us-ascii?Q?CE2cAxFKDAiPWxsMBBaNm1ke4rPvDSbxz/7PMC8EvDxZ4DRBYmz5YUO9r3mB?=
 =?us-ascii?Q?1QeHm0yZytYgR0aq2H8e04VoFDv6LOf9M63G+7Hca5zxuW9wpQkZ6cN1QxGD?=
 =?us-ascii?Q?psu5DS8Mx2VMux8jJWVcytQaZq6E51Q9svOV+053ZxSwReKfoXpVu1TaQ6WM?=
 =?us-ascii?Q?LrFeY5DuF89+MPZMOiTfeXA0lms7Ed2c66EGPUuuMKHe0iKLxEYpSwHhhjLZ?=
 =?us-ascii?Q?yPNxuc6qXOaHy6PZleKp9VojRcd7yeFfRXYl0pm52VMtJ+cUiV4mrHB/HHpG?=
 =?us-ascii?Q?gdSc5KIaf5Dn5UjrlwxdK6TFVeEbuJ+XwF+gBOphJb/OsPpuT+h1DPWkclOC?=
 =?us-ascii?Q?iWjCnaeK4r4vBxrKwRn/US3Ybod5WqhaqoDXGL59rAG3Sy1Ke38Mp3mgMtUR?=
 =?us-ascii?Q?mI3AH9QN1UfVxY50WeCujaYGO+AVL+TGmWOm20oQvOWtU8D6K/40Sx8ukqYf?=
 =?us-ascii?Q?Jh/caDiKhkeNCWiHf4/MJcUDV7lUgVSCW8wZCPQJcJ03bL3fxj1ypWIDhegu?=
 =?us-ascii?Q?rAyr2UhYs/3kKwPmmNAomr7RRxJH0JlKWyUjl0kzLgLVviqhz7TNZgX77qkH?=
 =?us-ascii?Q?eDwzVpwScZnNVvuC0EDfaOkEqioQEKP5MHRudnjSQQCS2BGaIeKUz9vnij5O?=
 =?us-ascii?Q?s/oMB6QUl4jcBQN9dt2Amij/bUCLNdeMMzTN4q9GqilWxrOhvnfN6IaloCYq?=
 =?us-ascii?Q?kRdne20fnTAFc8/j0t5cJwMWP99AP6o80dkMqsmtN5JkXTLkyiIOwpEGqMdj?=
 =?us-ascii?Q?xpW67Fo6uhNpErwLFiCvvk8OSOaUQs9RcnP9MqsE5ovib9fqzF3Mt58nmkMw?=
 =?us-ascii?Q?EcArsKXxIl7V3wJPi4yeurZTgyBxIOhjnE7uy0u6ohaXSwSLibasgmtEu3pr?=
 =?us-ascii?Q?bhBlIO+s+RrFlUN9kN8e8cAWQM66zgTbM0fU7hTdeOQxdPHUmsYCXULmp5KQ?=
 =?us-ascii?Q?nQo4L53z43oiOJ7bdHepfQdE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ce24a7-65f5-493b-7a97-08d964e924f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2021 21:17:55.8336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OEPStP9e28EfxRccdLSuNuX2IYvuTYYQPI4MgIN+yqgXYvUeSvR2T/IJgGgAKeKoQ7+PSYDOzmVt6nqs8kfoHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1277
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Friday, August 20, 2021 8:33 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>; Paul
> Rosswurm <paulros@microsoft.com>; Shachar Raindel
> <shacharr@microsoft.com>; olaf@aepfle.de; vkuznets <vkuznets@redhat.com>;
> davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH net-next] mana: Add support for EQ sharing
>=20
> > Subject: [PATCH net-next] mana: Add support for EQ sharing
>=20
> "mana:" --> "net: mana:"
Will do.

>=20
> > The existing code uses (1 + #vPorts * #Queues) MSIXs, which may exceed
> > the device limit.
> >
> > Support EQ sharing, so that multiple vPorts can share the same set of
> > MSIXs.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> The patch itself looks good to me, but IMO the changes are too big to be
> in one patch. :-) Can you please split it into some smaller ones and
> please document the important changes in the commit messages, e.g.
Will do.

> 1) move NAPI processing from EQ to CQ.
>=20
> 2) report the EQ-sharing capability bit to the host, which means the
> host can potentially offer more vPorts and queues to the VM.
>=20
> 3) support up to 256 virtual ports (it was 16).
>=20
> 4) support up to 64 queues per net interface (it was 16). It looks like
> the default number of queues is also 64 if the VM has >=3D64 CPUs? --
> should we add a new field apc->default_queues and limit it to 16 or 32?
> We'd like to make sure typically the best performance can be achieved
> with the default number of queues.
I found on a 40 cpu VM, the mana_query_vport_cfg() returns max_txq:32,=20
max_rxq:32, so I didn't further reduce the number (32) from PF.=20

That's also the opinion from the host team -- if they upgrade the NIC=20
HW in the future, they can adjust the setting from PF side without=20
requiring VF driver change.


>=20
> 5) If the VM has >=3D64 CPUs, with the patch we create 1 HWC EQ and 64 NI=
C
> EQs, and IMO the creation of the last NIC EQ fails since now the host PF
> driver allows only 64 MSI-X interrupts? If this is the case, I think
> mana_probe() -> mana_create_eq() fails and no net interface will be
> created. It looks like we should create up to 63 NIC EQs in this case,
> and make sure we don't create too many SQs/RQs accordingly.
>=20
> At the end of mana_gd_query_max_resources(), should we add something
> like:
> 	if (gc->max_num_queues >=3D gc->num_msix_usable -1)
> 		gc->max_num_queues =3D gc->num_msix_usable -1;
As said, the PF allows 32 queues, and 64 MSI-X interrupts for now.=20
The PF should increase the MSI-X limit if the #queues is increased to=20
64+.=20

But for robustness, I like your idea that add a check in VF like above.


>=20
> 6) Since we support up to 256 ports, up to 64 NIC EQs and up to
> 64 SQ CQs and 64 RQ CQs per port, the size of one EQ should be at least
> 256*2*GDMA_EQE_SIZE =3D 256*2*16 =3D 8KB. Currently EQ_SIZE is hardcoded =
to
> 8 pages (i.e. 32 KB on x86-64), which should be big enough. Let's add
> the below just in case we support more ports in future:
>=20
> BUILD_BUG_ON(MAX_PORTS_IN_MANA_DEV*2* GDMA_EQE_SIZE > EQ_SIZE);
Will do.

>=20
> 7) In mana_gd_read_cqe(), can we add a WARN_ON_ONCE() in the case of
> overflow. Currently the error (which normally should not happen) is
> sliently ignored.
Will do.

Thank you for the detailed reviews!

- Haiyang

