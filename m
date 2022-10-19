Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2716D603926
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 07:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiJSFU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 01:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJSFUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 01:20:55 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60041.outbound.protection.outlook.com [40.107.6.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4556685C;
        Tue, 18 Oct 2022 22:20:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxjRHOOh0dY58Bwhd3i5GaWNyUvYW4uwbOSvQrv5lu+aELP4KG+R88C+Nc4YOS5hwOypgGjQ36AkkpqQa8C27bjM/TgabAICfPSlYf538CO40CrBOtqTfmLA7P+kL77qV84PTGKWqjTJjxo2z5iivASiS1D7LG5uimYcKaDiWc78CzelEOcqoTHQq4nXUSLg2tYP1AxaU8Z1nptZ9cPezG2CN1cxIjaABv+onHtXrJrBCB7QvmGQ12Y6XvG6CqKE58EC4hmGxbpWhiavvlPbiYcHOHbaDs7iepKSDOOHVbDXNTlIRvhHE0V04rjHP1KA/vfMjr4/rLvPDVmv/NsGkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwRh2EiNXN9RltWLe7vSjS1M6nw5yi+MRnaBRhHUUbs=;
 b=hz7X7OiIcAe2vkkfwW7XLnBiq/xgf2R33VPmyejZ8bO5saA4aZDqPT/kloqiZPdFXxsYdwAyoKkAmuOL8eswS0/RXfGgAInirO6tgPM6BhWadwQSDYo8XsQPsTBD5cOMn98VAuy9zYMRe3ysnXkUbG+4Mam1FjH9H8ydOY1Sgd0exKjV/WpMEgeY3nT/pn2wKzPBuLhVi6Ey+hE8SSnaTyCn3M+UDpw8BTyTmCGuwZ+SiM6zI3DEYylu8eX/uFusEOT8bFlK7eKQ4NPBxmejz7/xEfAJceS+A7NR9cjrRcO5Aj0WBV2JN+ET9y5BMqsl71W++JGaa1u1dWZAQgh5gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwRh2EiNXN9RltWLe7vSjS1M6nw5yi+MRnaBRhHUUbs=;
 b=XU36Ai51MMdv1m90/qOc+GpucJ9Lsg9izWCUJtt5UOefWBCI6/lvzP9qq5bmw5s74k76YF7LKwwLLOtAKsDHqyeKkDmyYpMibOYSnd6nGbYa0JMPBSYOwyd10LQwSLKWGncBJ/yLjZ02PAC8I/ZIKh05kCcmFhiwMwuu/ib3S/M=
Received: from AM0PR04MB3972.eurprd04.prod.outlook.com (2603:10a6:208:63::28)
 by DB8PR04MB6777.eurprd04.prod.outlook.com (2603:10a6:10:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Wed, 19 Oct
 2022 05:20:51 +0000
Received: from AM0PR04MB3972.eurprd04.prod.outlook.com
 ([fe80::f556:1796:cafe:909c]) by AM0PR04MB3972.eurprd04.prod.outlook.com
 ([fe80::f556:1796:cafe:909c%6]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 05:20:51 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>, Andrew Davis <afd@ti.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: RE: [PATCH net] net: fman: Use physical address for userspace
 interfaces
Thread-Topic: [PATCH net] net: fman: Use physical address for userspace
 interfaces
Thread-Index: AQHY4kV4CTBQ6TpejkOf0p9IZqtcYq4UbByGgAAPtICAADPXAIAAAjSAgAB+mtA=
Date:   Wed, 19 Oct 2022 05:20:50 +0000
Message-ID: <AM0PR04MB39729CFDBB20C133C269275AEC2B9@AM0PR04MB3972.eurprd04.prod.outlook.com>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
 <Y07guYuGySM6F/us@lunn.ch> <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
 <97aae18e-a96c-a81b-74b7-03e32131a58f@ti.com> <Y08dECNbfMc3VUcG@lunn.ch>
 <595b7903-610f-b76a-5230-f2d8ad5400b4@seco.com>
In-Reply-To: <595b7903-610f-b76a-5230-f2d8ad5400b4@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB3972:EE_|DB8PR04MB6777:EE_
x-ms-office365-filtering-correlation-id: 15ae7dae-e6bd-499e-79ad-08dab191b021
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b7GDiR6J7audWZdeTk0qf3vV6NkkJdYHmjlJ5DaRLLE+HGBhsODJsMAhfplgLqcvIuKI6DDCAwh2ACBR6X2hKhg83+Z2QUpr2VAKGGCOyNF//drFEdo9x+tFsDwy+SDejYB0gbmhj/OvJnwlKhJc3byXLC0uMhx1QLtLq0uC2j2ba+RK1vYcRqh8nATJW4NJNTMQt5JP1LaSWoj6jb+4oDQdlSbMyKBiZLi3VADMvbnPxyfLMw8gtNGgIfl+i6RMT3WAOEa5dRGHrgNmI6AGrjcDRTKIa70K7sCfjH4cUfvEcTwfaJDFwWHlUUsEY6i1VM+vODlUxpaYYMmu+Ssa+XZWUhI84HvdfOPZo9oJdnqM4D2pa7x48x70350kcN3y1Lx1Tyq9JqcGsizuRf+FfIoUG9n1gMG1ofO4BNrl/Lmq12H02cpzlcU3vjawIBeBjUmxAshVVXxfhKyf6obCPppDCNyK+uQ9cB0c7ZiGtnr48L5Vl5Gtqy/F40LUTyvLmdJBdfOInUyxqQpXCE1gt/xJih7c0Dk6nHJjwqBi3IeLov3BAsc3ImX0guMUw270StUtneJ/FTwL5+CBHes+9DgBv7dQHFxi+htwVdW/s12mdqjTuiXFusHWVUB3rZfl//BtJdaM/Cx4RIBUOvn6WD2XWgtE8Gq37oca7/egTgN5rtNw5vbNUTZ0yFpx5HOY2oxUYU9pdfWvSRXG+TZR8S+o7sFv+gSihcihpLkxpT/twvOPq8fcvK8MUGHOtbvIg2lVNZ2cYT3ySo00uaxy5OwDG6JkIlBjLZ2nrfo/sgI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB3972.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199015)(83380400001)(186003)(38070700005)(2906002)(5660300002)(52536014)(86362001)(122000001)(7416002)(44832011)(38100700002)(478600001)(41300700001)(4326008)(55016003)(64756008)(8936002)(26005)(8676002)(966005)(6506007)(7696005)(316002)(66446008)(66476007)(66946007)(53546011)(76116006)(66556008)(45080400002)(110136005)(71200400001)(9686003)(54906003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MJ/EcrDBs9abrHWKY/rHHeR03QcYa0ScxC0tWbHMneoWK8XZ3t5OQSpz8T23?=
 =?us-ascii?Q?qrECWlE3gxqSGfzxtE5NXsHagtHy7kKePaUSjbkTmqFQBW2Ju4KYGGZImRVv?=
 =?us-ascii?Q?70cR2xu0wFrjoQT0x0Pc3jdOfont/VnhudyPQEwelV914UhV46fxa+w/DtVw?=
 =?us-ascii?Q?lgbNtLANCDwyGVGJPM+XYkOLSfZZ8vjy6JG+bc7Ir0fUykmoD4bLN5skY22F?=
 =?us-ascii?Q?6YhFZVxXqkifkd2pwWLkQSVJpV3BlWNHmKaMWwJj+0zRy30EmIzXdT+awENR?=
 =?us-ascii?Q?5txUixyOFw26P5TWPrZVkEdQnivVj6ReGcaarbezKYqEsCOsiZeA8BCMh+aW?=
 =?us-ascii?Q?NV6axt9wsr0nkHgNN7xRLDMMm2iokgBgw2XvF/Xy3p/9TXxSN1/9+5Z/2N7J?=
 =?us-ascii?Q?bjYPiYxFMAV/5aVG0tEOoLnZvLdu39ooSPcA76V/j64nrEBsK6H7G+cp8bsP?=
 =?us-ascii?Q?+OUR1FQxjRbK3uCqUwVcPDYOFyBf65rkFzeILwCPRrL00vfhbMgC0WoultcF?=
 =?us-ascii?Q?VuHRb+Q0DipWJ4p6VD5WUQzGeNH13A93sTha75s4TZna/wXiMNLNQ2CGt4KC?=
 =?us-ascii?Q?0zDTxaep7XODqs8mZvNjBX92P/UxzGtgWsyxoqMEUBX3zdHuj2u4zH2TxdNi?=
 =?us-ascii?Q?MNWdYZrrqf2I05i5UMFWK3SKq2xhoEpyHF26A1H9x6/Ntm4zGQWdP06EKvRh?=
 =?us-ascii?Q?leXq0dclyBAd0gOv+eLVRRaC6zLMErFjQePrkqEhrfqBGfRqvKpKIk6goHC/?=
 =?us-ascii?Q?zhoEVvyQPPBA8OVofqylqzG8qnDIIE1EP8g3EO0OClmv5QhC6dKCX32KsKFI?=
 =?us-ascii?Q?VmMH/x3EGttt/u1cw3lesMU/2+wIOCPEWD3w3hs06dcpThOCCgcpI3Nqd4vh?=
 =?us-ascii?Q?wfA154+cwVVhKKR14jyob7nVwzQXgvFoquCvtmPpwrD13703iNIeXwlPxGT9?=
 =?us-ascii?Q?5ewmXJ2rMJ8JcWe77OzdEDVXcvdMWZJppvlrW8vdpsdj6qsY712MKRAcd9cw?=
 =?us-ascii?Q?De2wWybNF1rjspBKdoTUA5rDF/GpiZTvBHKejDlA0khI3kv1LGKwoFxlhqA/?=
 =?us-ascii?Q?mycoBWuQBgOBcGJNnzz3B4cd0ph2Y5IWhB773bXabqmPsWHxMjegAf7uJjBL?=
 =?us-ascii?Q?Emajz3ceLsxa7dtsxA0LJUxAL22lvqHTjMk4bGfYUbFG/Luam52GUCi8uIv/?=
 =?us-ascii?Q?QeYVY9n1Ve4BvZuIsNrXQW/2y5uNJTFDeczw0L31tzcIgiS1FHMT6uqqhHM3?=
 =?us-ascii?Q?pL1zAGUNTNDxecfIIgkHYWzZhbgiFKV6yAmn9VU73+YK4P3ykjAt9Me9LAW4?=
 =?us-ascii?Q?hEYZaN7k3Bep/Bkw7VJF+wFeqWwp655yRXhKAhbpj5ZWsUioAye7txp/0P9y?=
 =?us-ascii?Q?goEHjPOK5nzIp2kIsChObOi01OCq2GmQmsmUA43BEL8SWeWo4VzuJs4FzcGB?=
 =?us-ascii?Q?fjpjbc1s4fodnooZDE5tCSHJgfzNtZj1V9vZDfzdP8o4UHB66U2KYtYQslV5?=
 =?us-ascii?Q?gusimcCvkeGAtD4Z8737e+PA4xaezkvsqKnNjNhnd5bLjldWF+6bYO+n8grv?=
 =?us-ascii?Q?sMb0D9HUJsoDCFR2KmwDh4CX/OodxrTcQcRHyNDJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB3972.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ae7dae-e6bd-499e-79ad-08dab191b021
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 05:20:50.9079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nK2mJx6i4lL9jO1mEpvlth5tIRvjY91fS8UiDQua/KTKNVCqH77pw3Tl7MeW53/mBJ8US+q9lYvcBMNfwd70tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: 19 October 2022 00:47
> To: Andrew Lunn <andrew@lunn.ch>; Andrew Davis <afd@ti.com>
> Cc: David S . Miller <davem@davemloft.net>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Madalin Bucur <madalin.bucur@nxp.com>;
> Jakub Kicinski <kuba@kernel.org>; Eric Dumazet <edumazet@google.com>;
> Paolo Abeni <pabeni@redhat.com>; Camelia Alexandra Groza
> <camelia.groza@nxp.com>; Geert Uytterhoeven <geert@linux-m68k.org>
> Subject: Re: [PATCH net] net: fman: Use physical address for userspace
> interfaces
>=20
>=20
>=20
> On 10/18/22 5:39 PM, Andrew Lunn wrote:
> > On Tue, Oct 18, 2022 at 01:33:55PM -0500, Andrew Davis wrote:
> >> On 10/18/22 12:37 PM, Sean Anderson wrote:
> >> > Hi Andrew,
> >> >
> >> > On 10/18/22 1:22 PM, Andrew Lunn wrote:
> >> > > On Mon, Oct 17, 2022 at 12:28:06PM -0400, Sean Anderson wrote:
> >> > > > For whatever reason, the address of the MAC is exposed to
> userspace in
> >> > > > several places. We need to use the physical address for this
> purpose to
> >> > > > avoid leaking information about the kernel's memory layout, and
> to keep
> >> > > > backwards compatibility.
> >> > >
> >> > > How does this keep backwards compatibility? Whatever is in user
> space
> >> > > using this virtual address expects a virtual address. If it now
> gets a
> >> > > physical address it will probably do the wrong thing. Unless there
> is
> >> > > a one to one mapping, and you are exposing virtual addresses
> anyway.
> >> > >
> >> > > If you are going to break backwards compatibility Maybe it would
> be
> >> > > better to return 0xdeadbeef? Or 0?
> >> > >
> >> > >         Andrew
> >> > >
> >> >
> >> > The fixed commit was added in v6.1-rc1 and switched from physical to
> >> > virtual. So this is effectively a partial revert to the previous
> >> > behavior (but keeping the other changes). See [1] for discussion.
> >
> > Please don't assume a reviewer has seen the previous
> > discussion. Include the background in the commit message to help such
> > reviewers.
> >
> >> >
> >> > --Sean
> >> >
> >> > [1]
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.=
ke
> rnel.org%2Fnetdev%2F20220902215737.981341-1-
> sean.anderson%40seco.com%2FT%2F%23md5c6b66bc229c09062d205352a7d127c02b8d2
> 62&amp;data=3D05%7C01%7Cmadalin.bucur%40nxp.com%7Cb35d8b37f9224e4b793408d=
ab
> 1525b5a%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638017264524356126%7
> CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haW
> wiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3D%2BcoXaNNlcqzKLsGC5WKuk8Mwet=
te
> D51cCbzJvHfG7Vs%3D&amp;reserved=3D0
> >>
> >> I see it asked in that thread, but not answered. Why are you exposing
> >> "physical" addresses to userspace? There should be no reason for that.
> >
> > I don't see anything about needing physical or virtual address in the
> > discussion, or i've missed it.
>=20
> Well, Madalin originally added this, so perhaps she has some insight.
>=20
> I have no idea why we set the IFMAP stuff, since that seems like it's for
> PCMCIA. Not sure about sysfs either.
>=20
> > If nobody knows why it is needed, either use an obfusticated value, or
> > remove it all together. If somebody/something does need it, they will
> > report the regression.
>=20
> I'd rather apply this (or v2 of this) and then remove the "feature" in
> follow-up.
>=20
> --Sean


root@localhost:~# grep 1ae /etc/udev/rules.d/72-fsl-dpaa-persistent-network=
ing.rules
SUBSYSTEM=3D=3D"net", DRIVERS=3D=3D"fsl_dpa*", ATTR{device_addr}=3D=3D"1ae0=
000", NAME=3D"fm1-mac1"
SUBSYSTEM=3D=3D"net", DRIVERS=3D=3D"fsl_dpa*", ATTR{device_addr}=3D=3D"1ae2=
000", NAME=3D"fm1-mac2"
SUBSYSTEM=3D=3D"net", DRIVERS=3D=3D"fsl_dpa*", ATTR{device_addr}=3D=3D"1ae4=
000", NAME=3D"fm1-mac3"
SUBSYSTEM=3D=3D"net", DRIVERS=3D=3D"fsl_dpa*", ATTR{device_addr}=3D=3D"1ae6=
000", NAME=3D"fm1-mac4"
SUBSYSTEM=3D=3D"net", DRIVERS=3D=3D"fsl_dpa*", ATTR{device_addr}=3D=3D"1ae8=
000", NAME=3D"fm1-mac5"
SUBSYSTEM=3D=3D"net", DRIVERS=3D=3D"fsl_dpa*", ATTR{device_addr}=3D=3D"1aea=
000", NAME=3D"fm1-mac6"

root@localhost:~# grep 1ae  /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,=
dpaa:ethernet@*/net/fm1-mac*/device_addr
/sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@2/net/fm1-mac3=
/device_addr:1ae4000
/sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@3/net/fm1-mac4=
/device_addr:1ae6000
/sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@4/net/fm1-mac5=
/device_addr:1ae8000
/sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@5/net/fm1-mac6=
/device_addr:1aea000


Have a great day!

Madalin
