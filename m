Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F01455C872
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiF0IvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 04:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiF0IvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 04:51:07 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C1126F1;
        Mon, 27 Jun 2022 01:51:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrUfiEXLCJOR6W0EKPwNJd6dQEzhLQuYbXDi+NjZvFAKo9uVcejtzLB2cl0AEctPM5y8n57cg5kKRowf9CttlfxIxWxbSZ/FtzYR6k6AG7W4DLWV5CwpRd9U4oxrrZtACRBpuPz2v3zUn4HgihPBWF49jHZ3CQmwFjiFc3v+EgyKE7tJBIOtmbYIK0xWbCoxRQlE7OVbYbxc7VvHCcCWrs8e/RLC05z2bh6nkLOK2DQNLL1OK7jaPJUIMBvaYBlLA4Elt6zV+F8g/aln1r8n0cRlTfDHoS4mgZEqaXpd3u0uElGRKpq1tDhb+odP6ZTr0El/E6JNxZA+Qrh7ao4lZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tOZeBKW4oaPYiYfzVSbojIReYnGXMGCeV8aG3IGMpiA=;
 b=AeQGnI7wS63Orh/zs+0+0DAaOMSSmcRHX69me2qh0kCqOIF1BDHPq1ugFYAAMIG2c0WxjZovKJ7QRBS+A6EDZQeCPtYtQRGcuU96lIyQBE0/E7wUrOzMJFTZ6qh8lqa3Lzcd4OyXxFRxiaq84cLlsVjWRtpqdj9vMHCHXAwUxbzd+1fhzYtdl/yaVLK6CUsJBJD7kSUDbrGf89LKHQ97iLe2kKY/VuzgL6g0UhQjSymvZFMD9CE/aYul4ratLvCCrBNbucwbRNxhaSAa1JFIWfTHOVU9GtCUzlGFDq7tDiHWtOiCFmpLPgTbV44hpQPVo0T34FjaBJ3n/kX4JU5pbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOZeBKW4oaPYiYfzVSbojIReYnGXMGCeV8aG3IGMpiA=;
 b=XnNSC7I6g4T9P49rwVFfpFq+mMJuvzw+yh/GRDYIJc2KPkysb6ZHjj/acgt56SOIVMEtArdP6GJuELkWzKsZ6lOQBL6my4Wg7Zz9kHp/1Do7TYmEse4YXUNXVngq/sTTw6v9BYSKdpw30/lVTy2VqbgqDwO85mmMg9iFMPysRB8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7606.eurprd04.prod.outlook.com (2603:10a6:20b:23e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 08:51:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 08:51:02 +0000
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
Thread-Index: AQHYiVUJbQ995zeiIUiu+k9xTzwoea1i4yOAgAAQQIA=
Date:   Mon, 27 Jun 2022 08:51:02 +0000
Message-ID: <20220627085101.jw55y3fakqcw7zgi@skbuf>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
 <20220626120505.2369600-2-vladimir.oltean@nxp.com>
 <5db4e640-8165-d7bf-c6b6-192ea7edfafd@arm.com>
In-Reply-To: <5db4e640-8165-d7bf-c6b6-192ea7edfafd@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32c58974-dc2d-4018-24e3-08da581a2a12
x-ms-traffictypediagnostic: AS8PR04MB7606:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +DuLN5BKpIOp96C7tp5wkiKY5b2zePcIVSMuWVM/pKYH/4/TUYZ27nU6wOKqSzWzAx+MMsUejEjB5uhhZigq5wQMaxGnD3Hz5kvCI4BnU8iq3iIs+jTTM8gyk3X63E9apaeWwQU1U/an12NXmVufl1+eKgfhghmugWKBc5rdcq9aSU/I4rh2w3c4Iu/9H6v3lQ5BREEqQd9LImg+aJ8RLmdHcZMj2Fz1aSGJtkX/tFv1oNoSw7lKqE2tqjY9ZknjpAy+3e702vbkVp2A/Q4jz+CHgtvA3rj5+TWqL3sBN/jY3UCDXV+punJH+1H0q1px0q0U6CEbkGjW9r1lBcLYy38JUrbKjm+CgLYayVIeCDIbQk2AsV4EkorbxwyKJthRGrVbadGEnPV6hg7H9+bZye56RCA0F6Z9YpXjgighTHnx8HQBVH5GHr8dDWVEydHF/l7OBrTiM3irYf7Vy17IEcIF4u0/2VewmJ0Su/bKhJ2KSenu6BEalGwspy9WaUPMUHsN7l6cnODBM/Few9vP4r0AOiUxqCkwku8hlyQx3Hkev4nYOzK45CeP9/tkXClbl9kMM63SPnC7bOVoxTmTuaPyOmJWVqsuUzIixYy4RoYkPu83hp4djbcFbHZXlBDldWctjqnUMSWLfqO0RNIuoxza4LXahj6vs5LRSrcCJ6vfRLPayXbiS01P8Q05abZ2DVz5bBl01xX5hZ/BqrRC2h5X0qlcrsVOjj6k9ilg9sMT3Kq976bpOK7NmyO5lKU3XQuzuxmzM52pWB3UzMYxJKZoOwyV50jFt5oWF212UEQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(2906002)(478600001)(186003)(26005)(6512007)(316002)(9686003)(1076003)(33716001)(41300700001)(53546011)(38100700002)(86362001)(122000001)(6506007)(83380400001)(4326008)(5660300002)(66446008)(8676002)(44832011)(66556008)(66946007)(8936002)(66476007)(7416002)(64756008)(76116006)(38070700005)(54906003)(6916009)(71200400001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6OV7A9Y/puirNhBWkIq7Qi7MjFFp/Y/tnR5BqVI2slTzUgP8/D4NFE2AARBS?=
 =?us-ascii?Q?Dq4D2JZSlhLXaZwDeMioA0aL4Lmo85JnFD4QEqSJzvVuuznXW0yMO6csszOd?=
 =?us-ascii?Q?oKcfsRQOfe8LC1QFRxvF4wPNpwdKmHfHoFMKgRfxrX+5DgTRbR8mOH2MnCDB?=
 =?us-ascii?Q?ZP4BnyVP0EkmZwzsVN5tkYsc5Ouk7hCSBTFktO3eRgE+m94OJJxeizs8oqeX?=
 =?us-ascii?Q?CYKcd7fsCvr1mb7+hhztlSqVCDs9cMvrMxdJEbddrVTtu2+dWR35hF3tsTUt?=
 =?us-ascii?Q?46c1PRYTB6JJigA70XTCLrGlReRAbbuhlqn4LJtGGxLpSjn29Zmo6Waif3Vd?=
 =?us-ascii?Q?JPGf2y5bgqtHyIOelRBqYugN6zrRvel5mR0/OtdEW203+zKzvyfYcRNL8E9P?=
 =?us-ascii?Q?LWwV1ZfLAlicwqtu3sPokIQM8hHOlZIowHpq7U+doBrNnNZdChur4/QzKAXZ?=
 =?us-ascii?Q?W+zhkD8RaqCcmyf+gO8vARYDmXQsp3KC80KbNYROfZaVjMiNOxNDgLBdpC5n?=
 =?us-ascii?Q?D3uUM9walBoWH5yUCa5sHcghihRRbu6vmyAKYsp3N6wHhjHy4UKGuUP4I1b3?=
 =?us-ascii?Q?rOH6fnEyvtXAfk7fvpgzCJGJf0OPeuxTMNtJHOO1asYKDr6RxDvhFDYOIQN/?=
 =?us-ascii?Q?E0URmEyLlVfBjpR7xHfZNEbpnvf3w4UI9lDuNYcSeBNeLY0Hpk9f0fUcDXG2?=
 =?us-ascii?Q?+CWerRFJ8tHDatwfBbKiAuNaLUBuLHdbbG+ffBir+MYGn9TdH9sYJLUq2Le9?=
 =?us-ascii?Q?bYcy4F4w4YlF+vXSQj0/ocF1LlRT2k3G5pCVzkM2yB1o5I137VBDc2jR1CXL?=
 =?us-ascii?Q?p0lV9romMa4TnL/MvLTezQAmHTtgZbkOlcQAmdXXrQU9yBO/xUWNq8izQIpi?=
 =?us-ascii?Q?CkVT/j2NdzK0hbujd75Hh1QVDIfLGhP/FNRTGK23iABEqVOxHLnRY/7wFYvB?=
 =?us-ascii?Q?1zJM0OvaP4jLJU+xFUnoQ3tUPki8xeAsiXeE7GsV0ueJrnPa8JF0OJFoPPpK?=
 =?us-ascii?Q?ausFcJT4WK0qDvVpxdcFBc/0KJsE23547OK5sv0SPsvplNyiZd8EMSvZF6GO?=
 =?us-ascii?Q?10nWTzwWzNpkJzs5CNhhuQ6kEf+OAxIUzNVo2QaHygi+29Hn6UZIA4UycSWz?=
 =?us-ascii?Q?jkcrKlw8/fjii+JqkbS2IIlNHkDMoRIbhCghPBndFlEbM+cH9r6Ynr4zkrbY?=
 =?us-ascii?Q?1rUmUkMgZoNj3QViSCc9/bYN0qAjdTfkJu6bfM8uJ6Msx0Z9mnVhbpZLjEQ0?=
 =?us-ascii?Q?dkviA4k0VCJGA4wqpbbS5NvKmd5fxreOjeuq0Wn1E/gWFvDrtBdvYgX37oW1?=
 =?us-ascii?Q?ev9AtruaKknpBf27Ha001uaUN41p9ytOvvFl1XC/ZxxEvwoLmFOlMFxGYy+N?=
 =?us-ascii?Q?yb/U6gtukE3SVcmHPa8Eo6QeVm0UEdessjvSEu3UiD1aiLVjAn7XgtWbO9Aj?=
 =?us-ascii?Q?Z9AqNadtRPZlChNSmVX2SsW5F3BV8uQAwiOdLj7XT/iJaEoWLuI1mNaWXuuv?=
 =?us-ascii?Q?UrZuiKdZzOABWKDa5Car27nCQOUTsXaWshaZRMFLC7qLsvctU52NOkgsyY78?=
 =?us-ascii?Q?0Yn7vWaXMIP2nPVmvQ5icGCuSRiPN7GKZ/993j8vpm5IFeFnwnlqCSob/lma?=
 =?us-ascii?Q?fg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C7F3037469438438D1EAA7C610D2FEA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c58974-dc2d-4018-24e3-08da581a2a12
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 08:51:02.4260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4QRpR1IY6nmg54pP+/YwONv+qBzgvw3EOg3cHx0/m6HYKekUHQXJcWTMDyrHSMK6wDFAtOerMo/sBbCYbyOzqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7606
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincenzo,

On Mon, Jun 27, 2022 at 08:52:51AM +0100, Vincenzo Frascino wrote:
> Hi Vladimir,
>=20
> On 6/26/22 13:05, Vladimir Oltean wrote:
> > Time-sensitive networking code needs to work with PTP times expressed i=
n
> > nanoseconds, and with packet transmission times expressed in
> > picoseconds, since those would be fractional at higher than gigabit
> > speed when expressed in nanoseconds.
> >=20
> > Convert the existing uses in tc-taprio to a PSEC_PER_NSEC macro.
> >=20
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  include/vdso/time64.h  | 1 +
> >  net/sched/sch_taprio.c | 4 ++--
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/include/vdso/time64.h b/include/vdso/time64.h
> > index b40cfa2aa33c..f1c2d02474ae 100644
> > --- a/include/vdso/time64.h
> > +++ b/include/vdso/time64.h
> > @@ -6,6 +6,7 @@
> >  #define MSEC_PER_SEC	1000L
> >  #define USEC_PER_MSEC	1000L
> >  #define NSEC_PER_USEC	1000L
> > +#define PSEC_PER_NSEC	1000L
>=20
> Are you planning to use this definition in the vdso library code? If not,=
 you
> should define PSEC_PER_NSEC in "include/linux/time64.h". The vdso namespa=
ce
> should contain only the definitions shared by the implementations of the =
kernel
> and of the vdso library.

I am not. I thought it would be ok to preserve the locality of
definitions by placing this near the others of its kind, since a macro
doesn't affect the compiled vDSO code in any way. But if you prefer, I
can create a new mini-section in linux/time64.h. Any preference on where
exactly to place that definition within the file?=
