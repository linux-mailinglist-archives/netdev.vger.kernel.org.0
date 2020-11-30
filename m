Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5212C913E
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbgK3Wf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:35:58 -0500
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:48883
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730753AbgK3Wf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 17:35:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+m2CioLV/xJ+aYEkb9RmcM7JMBQIGkdW7ueKkpLIZMAqud5O1pHjuxjbo3vd5GQP7Zeq4rO5a72ev/AnWymllAB6zIwPArBPyuH6fwNfogcTbeU+8tUhmTPJmjc4TOj2g59IVpBxeSDz7J5HPbu2v3MTZk5mU+VZ5Aw+gXPMqmebSWei0Mq/cNH3HU63DHTFKtoMNFzoc1tOHRHTFM/61Zb/RiOmzvGbRFpW2HX8om6+UAjC7GCTlH7rO3r6MhNz7FugZOyavmzt5god2lcGaHGwh9OXj4gDcuhoyOO6smCEE3queEFYuAf5hnjELeCIK6SFPhcUYoAIxegSPXmJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTYBtK22tCSKWrdbaABeWU8mL74TTMejVITTS+wcZUs=;
 b=FXtfyRt6PCGHpQDA6mntr3PU2KomUAylKYnN6Xawy7rcX9eH2WWB3b4llSFq5ZXU1vevhYBYhfY1npPniN74NSvrvBgP9BAK/ucNivbuU4LKmTcGIok9FLcWcsfB4k2Z1myny2DFk6p6+/P0p46TIPhLMc7Ms+HOWTwAgKlGLKxsjx3e8iZL2HONwUOwfRly66p5cz1KSzswBuI7oJSw+TOn06qQ9999RHv/QiA8BLi4Tdj005pb/LVNA+wjbxX0DNRq40Lb2UABl285B5Y8oJ3ZvKt3qCbMkzopxKeLJg5U7h8K3AoYd9b4THcgBJ04ZTsTE+t7HuY3OJolJymFKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTYBtK22tCSKWrdbaABeWU8mL74TTMejVITTS+wcZUs=;
 b=RMVnCrEzrVxH+1Mo65l2eJRJODxt/Fh7h70Z0QcLvAIUHX9iYDrMh0a13ASAv20eD3ScO0QabZjZCVzEY+Z9EjFDvBA90ZwARnZ8aQWXev78E165i8+fOwlguNHkaXkECq1vnS9Kirh1PETBfhLP62X26EqKWnyoHIWMjLb/Y0Q=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Mon, 30 Nov
 2020 22:35:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 22:35:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: warnings from MTU setting on switch ports
Thread-Topic: warnings from MTU setting on switch ports
Thread-Index: AQHWxyVq1gSWQepkuUGwM5Q0zFNrPqng1riAgABnGYCAAAX/gA==
Date:   Mon, 30 Nov 2020 22:35:08 +0000
Message-ID: <20201130223507.rav22imba73dtfxb@skbuf>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
In-Reply-To: <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1224a31-4b4d-4c29-0e38-08d8958030e3
x-ms-traffictypediagnostic: VE1PR04MB7328:
x-microsoft-antispam-prvs: <VE1PR04MB73281409DC03741D234CB56BE0F50@VE1PR04MB7328.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kxm/KhGZ7bpA8frHOM1pPo12y0VOk/IBovDoMoJ76CLt2xJZKhq5LPSfA/niSwy6Uq5OilIchECNR3a7RDG/2P4/2+6yJ6pfVSRBTFDWpxf5hbfPO3DLzP6gPtjCDJdkeLKgGIEOnShEwO84un1xBsBUe7VveB5rrO2xNRAEgzUpnf+i2e10W3qqXeAmI7EHndg/VlkiGCtj9Ku0ykWTWK9C8BjY13xI52Vz6HMxCCFQDCuzopvt+NRd3UatRMbXhJoICjihp/iBVtVmZrhbvTUfJA57ooPvr4MXIBUIinwAvjtTcKRQfLWmgm21KnNPCMVcTRdYaBTPwbBkfHfRY7e7DDIDUllVbaOGHdSeUnm/QySyw52zqBQhTLLR/TeVOjnt7x6JnFJXsPlrEyaEyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(39850400004)(136003)(396003)(376002)(346002)(66476007)(66946007)(64756008)(66446008)(33716001)(6486002)(5660300002)(76116006)(1076003)(6506007)(66556008)(8936002)(2906002)(8676002)(54906003)(83380400001)(9686003)(86362001)(44832011)(6512007)(26005)(71200400001)(478600001)(186003)(6916009)(966005)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vI7YqF+cT/MEIp461U5lPSgxdQOjkCa6bqFK7WPFDSdwWsAZGYRAHe/5WG5d?=
 =?us-ascii?Q?KpvP7FsCCiq5PmsXfbvqhOMP2GQGny+O/aPRsPkhZaR8rwhlkxEtEofDB5gN?=
 =?us-ascii?Q?RntB5ydqJiqmhYpF3mk1qaZVCZV3KA0LquyAJW9nZo/VUEqQYk57ribg/707?=
 =?us-ascii?Q?Mi4b0SShHOq4k7whyGyD7XhcSec5XmcDJMlmnspGe/ATbbbVsbm03VUIZkaB?=
 =?us-ascii?Q?WSCsgpw1UK2S/OQGAQhqseTQGdrYRpD/a70uNuZtBuWRgvHGUqNeK05qBthX?=
 =?us-ascii?Q?TZhmKY8h40/66Oill9TX0FBqS+ZI9eSeUwl9jCMicaUH4kjtUnOSZFy9kPeF?=
 =?us-ascii?Q?JKb5zBWhco0y/kaoSXfrBcuJMOBxb2Kb0vfRqhJxLTlMCiIWavEqFq0ewyJr?=
 =?us-ascii?Q?Ejlkp/bRoIq2P6pDS4LzbgC3A8AW6H0khCidGXrg0XXf+XWrIczyJJZCaUvL?=
 =?us-ascii?Q?N55RPXqBHULifllxuM8C4U17kvzXoOvTAIDfzy/FsxWsUxpcf4GTsz+t40i2?=
 =?us-ascii?Q?Q1K/MTt1GOp/5KR/t4ue5oE6OWrhaQqSoPg4urqlLd2DiqZApquREDMthG1t?=
 =?us-ascii?Q?nMYVAZTIYyYmhz9tBKZ0JO5Wz3XBNPFJJiUSGxHNHtLSq1R/HmW53iJlFmA3?=
 =?us-ascii?Q?H8Qjd/hW1FH+VsXCKLIPwc8J70Xu9q5mf+zWCSVEKPSD+DtB7Bwp4UKu3IKF?=
 =?us-ascii?Q?6BbpyrpNYxbN0b9xsR8qGN3lO0YJwiV741dOjB8QVTbycRmo5luJW64xNeXq?=
 =?us-ascii?Q?GCPCQsqerohUW6hqCFJ/mDINKRK3gaLmaqGC8C9Cxita/Aj7Hwsq8HoQwrM7?=
 =?us-ascii?Q?Lmv5GoAzcM7bOuvXqNfY612I5MVosoh8b/r8cf9OiqsXCpFicGj3JJjSx5xP?=
 =?us-ascii?Q?myhvCNfrJHq8VKFBoZG18nQR5Duh81XV8n0RJKjeNoz1iKm9waPuwxBqwbme?=
 =?us-ascii?Q?Bq4W9fZZ2/Bd5twa9HxfAlIHnEpv2y1i16E1KQxkRJvuGS4spFzYRj0aNEsQ?=
 =?us-ascii?Q?vMGt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <284620BDF0A8584DBB4DD8628000399F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1224a31-4b4d-4c29-0e38-08d8958030e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 22:35:08.0664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vcDlfWzM6pImlBuxc7vPKa7fo/Yk1BOD26d4LsbYm4owCxlvSDDdDhvFtaQezFrSFF6i8bTwTYAGvFPOnQjJsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 11:13:39PM +0100, Rasmus Villemoes wrote:
> On 30/11/2020 17.04, Vladimir Oltean wrote:
> > Hi Rasmus,
> >
> > On Mon, Nov 30, 2020 at 03:30:50PM +0100, Rasmus Villemoes wrote:
> >> Hi,
> >>
> >> Updating our mpc8309 board to 5.9, we're starting to get
> >>
> >> [    0.709832] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting =
MTU on port 0
> >> [    0.720721] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting =
MTU on port 1
> >> [    0.731002] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting =
MTU on port 2
> >> [    0.741333] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting =
MTU on port 3
> >> [    0.752220] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting =
MTU on port 4
> >> [    0.764231] eth1: mtu greater than device maximum
> >> [    0.769022] ucc_geth e0102000.ethernet eth1: error -22 setting MTU =
to include DSA overhead
> >>
> >> So it does say "nonfatal", but do we have to live with those warnings =
on
> >> every boot going forward, or is there something that we could do to
> >> silence it?
> >>
> >> It's a mv88e6250 switch with cpu port connected to a ucc_geth interfac=
e;
> >> the ucc_geth driver indeed does not implement ndo_change_mtu and has
> >> ->max_mtu set to the default of 1500.
> >
> > To suppress the warning:
> >
> > commit 4349abdb409b04a5ed4ca4d2c1df7ef0cc16f6bd
> > Author: Vladimir Oltean <olteanv@gmail.com>
> > Date:   Tue Sep 8 02:25:56 2020 +0300
> >
> >     net: dsa: don't print non-fatal MTU error if not supported
> >
>
> Thanks, but I don't think that will change anything. -34 is -ERANGE.

Yup, I thought of that after responding.

> > But you might also want to look into adding .ndo_change_mtu for
> > ucc_geth.
>
> Well, that was what I first did, but I'm incapable of making sense of
> the QE reference manual. Perhaps, given the domain of your email
> address, you could poke someone that might know what would need to be don=
e?

Well, you could poke Leo Li, the QUICC engine maintainer, yourself too.
What exactly from the QEIWRM.pdf are you incapable of making sense of?

The MFLR register appears to be at offset 0x4c within the Rx Global
Parameter RAM.

> > If you are able to pass MTU-sized traffic through your
> > mv88e6085, then it is probably the case that the mpc8309 already
> > supports larger packets than 1500 bytes, and it is simply a matter of
> > letting the stack know about that.
>
> Perhaps, but I don't know how I should test that given that 1500
> give-or-take is hardcoded.

Very simply, you could run iperf3 or any other TCP stream (ssh,
whatever). That will eventually increase the TCP segment size to the
MTU. If the TCP stream doesn't hang, then the QUICC engine can receive
packets over the MTU.

> FWIW, on a 4.19 kernel, I can do 'ping -s X -M do' for X up to 1472
> for IPv4 and 1452 for IPv6, but I don't think that tells me much about
> what the hardware could do.

IP will get fragmented by the stack to the interface's MTU.

> A thought: Shouldn't the initialization of slave_dev->max_mtu in
> dsa_slave_create() be capped by master->max_mtu minus tag overhead?

Talk to Andrew:
https://www.spinics.net/lists/netdev/msg645810.html=
