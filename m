Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C5C55C281
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiF0KGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 06:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiF0KGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 06:06:19 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10051.outbound.protection.outlook.com [40.107.1.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F92B389D;
        Mon, 27 Jun 2022 03:06:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itL1ixLAm4RC3TqWblLFZqMIRGveCf6e7XFJu/4HXyZYpPJUxtmE4H4f5k4RDGO+geZlVfNjoD27fdxc9KCRNdNRDrP+LV6oxdUlHEusqXs1KorYvisho5lV2Y7pYL/7+UkdIHtN1exvLvtOVAUdRBreUMh71/GjckP3Yji6WaeHg+cwYVQJBP5u33aizshT9QOBz7nc1HtwhmgteC5ryz2GQQAjZx/0bTCg4tHtnoEFt7rnAFwfda0snntu4RkAsLQD0gDDH+Qkn9xaPyEeqQ+NRLEb6t010AmXXPliObkViednaLMJSNPbJ4n7y8TEPYMFFk/JjU4V+x7xh6/QTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISNdfFuLjLpvwqAW23vTQIKeDEGZsON6ISphPe0go4s=;
 b=g84ScREMCYsDdKgOBXhzlwLmpfcLzwQr3eSwHNtvRZ7FQfy7JOiJUGw9gmD4sbdO1PFjE3fr7yOkq1p64xOCz6H2GTc4dNJP2sREzuuv7XNS2nGXvucpzvefvjUBKeLngOBmBWKM8IzmE0ff2DcsjQGyGmlVqR0tTylKVgxMOa2W5J7+pvrOXbWmvuO7wNNtie0QdZKIvYA/y7OP+pTlnMmHgY32DScubHjLuHH73Yq4i/F4iDRt9sFm4fDoReNASzNNlbUu+t+TFeRQhSfYNl/1FrTuH3DodCFgmumaYvnBo5xumCgKMZU5HH2kwHJZSrLkPuG6uvZ8YG5uUpFPDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISNdfFuLjLpvwqAW23vTQIKeDEGZsON6ISphPe0go4s=;
 b=FDJI5eCSbuafD0WPXt7GObDBJ25ts6S+E0F+9czvoNJLCtaXpqlOpDIOgzh3rTMUvUeK6JzfuQi/QUHhPuqnZZJsrSDciRWrQ6rL0bo/a/haad4JwZJIi6CROnPAwbVKFMm3pyX4RXSR3gOlpDDXq1y9MQuAzcYEhQsYbqxqj4E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8293.eurprd04.prod.outlook.com (2603:10a6:20b:3fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 10:06:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 10:06:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/4] time64.h: define PSEC_PER_NSEC and use it in
 tc-taprio
Thread-Topic: [PATCH net-next 1/4] time64.h: define PSEC_PER_NSEC and use it
 in tc-taprio
Thread-Index: AQHYiVUJbQ995zeiIUiu+k9xTzwoea1i4yOAgAAQQICAAAmxAIAAC1MA
Date:   Mon, 27 Jun 2022 10:06:15 +0000
Message-ID: <20220627100614.s2arerirkmcnd37z@skbuf>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
 <20220626120505.2369600-2-vladimir.oltean@nxp.com>
 <5db4e640-8165-d7bf-c6b6-192ea7edfafd@arm.com>
 <20220627085101.jw55y3fakqcw7zgi@skbuf>
 <4e4b9e1a-778e-9ca1-5c15-65e45a532790@arm.com>
In-Reply-To: <4e4b9e1a-778e-9ca1-5c15-65e45a532790@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db5c84b2-d3a1-4807-cbb6-08da5824abdb
x-ms-traffictypediagnostic: AS8PR04MB8293:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 750zwV5kDp6dnIMnW2xjJe9gzCmSwGEpMqRuy1dD0UdKGjKWYNuZ0LZGVuXaCcF+coA3hdG4R9GzqQg233HSplD0TvXY9vAUb+GZ0ZXV8omASA6K+EN/dPxMs7MXUBS58aec8crcu06dX69s5s1DXAkXaHHr91oQ2kQZsPyoTWs2j1T1qtDIpNkYylTINNo2FstjE4GrAE4DKRqFr+HEFfm2IDdflr2T6T6+0dITc/8Ly5zm8wkzaHRfYsShNOWiWaWkq5X/CYpSfz6vmICMaZj75nEftwynTVZ0k+QHBnW54URvWHtknbIqlzlVPi67PK1cN2tq+DHZRQQiWwS39zJDOV6K7zmFREM6RrxSnXGpznyf/WXJW4A77htSfR8bN9o/W2ZS7Rne3KKy+wBrtIgqhyGrpS/fEISG4hLaouNtRN+8Xqu0KrIlmm7J6IL7SZqHjw/ussD3oPMDlzx8GdAqEpzN6A7Q7/8Zw4pMSxdp36EfKXe4XEQVqF+r7ZOMFtQBrOOMXFMNoXNKognnIApeBHunE1ZT3a1I9NT+Z61IXhNtKTwoxT/6mxVjOKYLSHyu8rMFKMt/ZKu/7ZWc6JYxw1l8z2moGoF6Wt5UsKp+2AAOfgQCMdQ36MXr4qwpd5OYQaYatUuhbyB36zsyU4VFL/H8Qo2kfi5jJJtfiBX3BztTA4TH8RpFRAe0iHyC6SKJ1Bfq7f3sd++f+mXAipETpKW9LlnfXd/kkim5Rvzf9neSxeUFwhnpefoYFIPD3FJNF7Vt3KmETu4Y5NY40OWUMo+co8QnIe48GTlKTFA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(66556008)(86362001)(91956017)(33716001)(8676002)(5660300002)(7416002)(6506007)(41300700001)(53546011)(2906002)(8936002)(478600001)(4326008)(122000001)(71200400001)(83380400001)(6916009)(54906003)(1076003)(6486002)(44832011)(6512007)(9686003)(76116006)(38070700005)(66946007)(26005)(316002)(186003)(38100700002)(66476007)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QcQuAYo3tDxIn0OwgohnL26zPjmYWIXIPyorRmQxlkun7sPvcbAgBwVo9gJp?=
 =?us-ascii?Q?HTykeTYB0GD2piNlzGxJ7c0N0kUxmMrnEO7AhV+LKXxEeVYvMFGdWRUQo+Y5?=
 =?us-ascii?Q?nmlYQRg/m6ROieGH6lUMBSV/QgTatP7m8dVFgjohcNaNItsUqvmjuwjSqJ8y?=
 =?us-ascii?Q?Fd7J0FtT2J2kSdcMVNxDHA9TcOQ0I98F/A9ISa+7ACV4X0Yf2RffOxkA1oUJ?=
 =?us-ascii?Q?yBisBnCU80VZRLd3TD6HyDkktjRhzPQJIPDTqt5etakisGrB7caQw3d7Ef0K?=
 =?us-ascii?Q?kEfaW5v/Qkm1laXQzyLymAn9M8X54bH3bItIAYYWvdbRkOdSO8BWW5p2tN0U?=
 =?us-ascii?Q?puqE/G3icQtv1ZgyWTke389YwE0ttyj8ADnOdCu/VNSbjIh6ok96cdePoELd?=
 =?us-ascii?Q?05ejTvy4xoUwybqAeDF+xDFmm0EnDfEJjYAHG4s4YK1uWte7c+w0twUJohjw?=
 =?us-ascii?Q?Lpoo3xpVzShUO5w3LufPDiHQ2FX2nwHz3wSRkrUlkNWfC0feVYOcBiEN/lnA?=
 =?us-ascii?Q?Ilyj/zzffPjnuTb8w6Bu5ijKZKEBEGPvpsQxTy6SMBcX4WOgQ3h8yhCt+aek?=
 =?us-ascii?Q?KHRCLpIcxDRl0CcE4yYZ9egMrA2zd15mnG+1HpocCZgCJ6ho71vgJeAhY5tz?=
 =?us-ascii?Q?Sz7dkeMALy7z7FFfPvQvN0N2Zch7w0ytZ4YZdeEKC9RAHMxOIBIPFCGGlQua?=
 =?us-ascii?Q?2mtZGytRqllsGp9iwutxNJPoLtTlsNo9BlVZM+4WEovNptTbquOyWNgnqPYH?=
 =?us-ascii?Q?LvzY7Y87zZ9TSmCPZsAKDVwjhixwV/JDkmNnMLKCP8IEzDtndBg7jN+y09eE?=
 =?us-ascii?Q?jD62YjMlea+KKGSao8Lqnucl4bZ6vXAoiJO8Mt7LSSOYRAIEW+iC5zpcL6fr?=
 =?us-ascii?Q?5NRhxY1v1/gF4rtKYZvPgscRKsw6wuzuMYfDCCInRKRFfEIcEUaB2z3PYYtJ?=
 =?us-ascii?Q?Nt+sAX0nNajL5iNnpBEvqZmoHCBYFvq/b/1TNo0RYjkH+sPMjXkBRDXwfNsw?=
 =?us-ascii?Q?uQPbYM6ozq7RQL/Cw02uDcXtl0ogJxHggt8vLNFYWyWyft3DwRXHrUoMYNbq?=
 =?us-ascii?Q?lQf8Al7DS5H7PVzoGZaQgleYlgDSY25FJQbzhOTZjk1KN4VLd+TtqW4Ck4Oo?=
 =?us-ascii?Q?95BbXjbD5vsQ0lAjoYxXkHZtQHtJ7ACH8mft/aghTGzLIvOPIRiODSdwDjR9?=
 =?us-ascii?Q?whhBgjKaG9KbwWmYwHZSOWJ2jLP4FmR39Pb4+sZLuYA4NitM3KsC2p7mbPZs?=
 =?us-ascii?Q?96/8GJh+83YLO2WR3+z8TxFRdwqeNQsOxhZEs4tN7Np4/eScHV8rsFPuIcTq?=
 =?us-ascii?Q?XIi7SycFSqbf2Eft1fCIz2LaBuDcaeBtxpobgYEzAlt4sn+n7Ey7A5hKBxvb?=
 =?us-ascii?Q?Qhak//gu/UT+WgQKMYB2OD9XGhWCyYiimX06bxknW/bH3t4QTdSmMehLvFV5?=
 =?us-ascii?Q?6VyQ8i4NC6H9UOaYhenKajlUhG33jg36CnvwdfFY/8JzCXjd5m7D9B2O2WCt?=
 =?us-ascii?Q?yRt+IyV5La7p8szEI4JHl8xajb+Hk9dKTlJZBuSwRYFiYRJiyKRnhgLPdGGg?=
 =?us-ascii?Q?OUcRzKkUZb4y24c70mR7UEDwiF61O79baU3gLWtIoQC3JBwJvmDT5BQrqhXF?=
 =?us-ascii?Q?jQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D0FD293E939B8E4C83FE657B2ECF2407@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db5c84b2-d3a1-4807-cbb6-08da5824abdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 10:06:15.1409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VfplS7vJJSmK2iusCIwGoMuyKqSawqus6sRLl7iMHkW//tputhks8zTfhzJuAo4kEArn7vUQUhqltc498QuESg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8293
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 10:25:42AM +0100, Vincenzo Frascino wrote:
> Hi Vladimir,
>=20
> On 6/27/22 09:51, Vladimir Oltean wrote:
> > Hi Vincenzo,
> >=20
> > On Mon, Jun 27, 2022 at 08:52:51AM +0100, Vincenzo Frascino wrote:
> >> Hi Vladimir,
> >>
> >> On 6/26/22 13:05, Vladimir Oltean wrote:
> >>> Time-sensitive networking code needs to work with PTP times expressed=
 in
> >>> nanoseconds, and with packet transmission times expressed in
> >>> picoseconds, since those would be fractional at higher than gigabit
> >>> speed when expressed in nanoseconds.
> >>>
> >>> Convert the existing uses in tc-taprio to a PSEC_PER_NSEC macro.
> >>>
> >>> Cc: Andy Lutomirski <luto@kernel.org>
> >>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> >>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >>> ---
> >>>  include/vdso/time64.h  | 1 +
> >>>  net/sched/sch_taprio.c | 4 ++--
> >>>  2 files changed, 3 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/include/vdso/time64.h b/include/vdso/time64.h
> >>> index b40cfa2aa33c..f1c2d02474ae 100644
> >>> --- a/include/vdso/time64.h
> >>> +++ b/include/vdso/time64.h
> >>> @@ -6,6 +6,7 @@
> >>>  #define MSEC_PER_SEC	1000L
> >>>  #define USEC_PER_MSEC	1000L
> >>>  #define NSEC_PER_USEC	1000L
> >>> +#define PSEC_PER_NSEC	1000L
> >>
> >> Are you planning to use this definition in the vdso library code? If n=
ot, you
> >> should define PSEC_PER_NSEC in "include/linux/time64.h". The vdso name=
space
> >> should contain only the definitions shared by the implementations of t=
he kernel
> >> and of the vdso library.
> >=20
> > I am not. I thought it would be ok to preserve the locality of
> > definitions by placing this near the others of its kind, since a macro
> > doesn't affect the compiled vDSO code in any way. But if you prefer, I
> > can create a new mini-section in linux/time64.h. Any preference on wher=
e
> > exactly to place that definition within the file?
>=20
> I do not have a strong opinion on where to put it. But I think that if yo=
u put a
> section above TIME64_MAX should work.

@networking people: do you mind if in v2 I move this patch to the end,
hardcode 1000 in the current DSA patch 4/4, and then replace it afterwards
with PSEC_PER_NSEC, together with tc-taprio? I'd like to leave the code
in a clean state, but remember this is also a patch that fixes a
functional issue, even if on net-next, so one dependency less can't
hurt, for those who'll want to backport.=
