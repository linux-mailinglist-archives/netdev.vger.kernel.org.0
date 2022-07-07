Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49244569E25
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiGGIwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbiGGIwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:52:35 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60075.outbound.protection.outlook.com [40.107.6.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1017E50720;
        Thu,  7 Jul 2022 01:52:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnjxWc5cxmiy+MkdFBpBp8Jmo8NeJGZFtS5hGqGbvvRRntP7g+N3gmfwtOaJpQKkkiBqVTuk0Ng1EzEqnjTiibqEdGrpI88BskQ4DUsOSQC1YqLtcWDrmHEOj8c6074wRzqB+vBFOPjJIIZmgRtgY3mxsQ58OfkDehjvZWM3kqc4/stUG2M5BWq8sN8exeSJz/4Yynu/O4zOFZ+wWnT4/E9eBjNP1O7+HfyNARRoeAUSz7zoze+qZedo7/FT+6njrrs2gQsFMeW22RRFuimwCUT8iaj4gMiki94mCFlxtbL+5b4y788J/e3k8xBPIj+MJlVYFbULTk8zQfugeAcZXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvWbEzeEI2RuSIb4wnJuIdt0DjPeUOPG8udzp28ulP8=;
 b=fbM8Mhxyx8wg3xEDjiHld7wBa3JSn/i2bcMUDmzK4O4uGMvyG7mx5ZGWHbEmS8QE4DQQXru601/1LAJhvez+jePkMItPIg+91NrJ+/VCgicdWRcvVBePEPRSLTW6p4+lCHRrNdVDoTJ4/vWWbuxwrI+E+HbTtuUsCHahtaUPtFpZRuLaOLSluWp9AUMirtXu7WVATDonyyatcJFyGgjmyXnDf0+9NjgOp76ankzrTsvtNgTxMRzpBvNHxksg+KNLSveYL9jeMcvwJrCcPUmoAcl53qMB3EqbbO3KHQzqrQWwZJ/d2rwgNbwC+rPwEGdFd5ViF+ROMpuSspxLqU+J1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvWbEzeEI2RuSIb4wnJuIdt0DjPeUOPG8udzp28ulP8=;
 b=dum50hMR53iN/3ZZMLxzXtLL5fGmATZHstU1gURznm46lYuVtV0Hmwa9T+bDEgHbqxirvon18FA1AwuPqCaJhAUBcKfxSV49VWF8keae8QR+zJkRhJwvCxp6Vsdj5vSCuqbUIXXlHNsxV6UgTfoVQsBUSrG8B0isisl9loNdpso=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PA4PR04MB9343.eurprd04.prod.outlook.com (2603:10a6:102:2a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 08:52:23 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Thu, 7 Jul 2022
 08:52:23 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 1/4] dt-bindings: net: convert sff,sfp to
 dtschema
Thread-Topic: [PATCH v2 net-next 1/4] dt-bindings: net: convert sff,sfp to
 dtschema
Thread-Index: AQHYj6x0ixunGQ4a40qQixFLFVbFVK1wTSWAgAJRQAA=
Date:   Thu, 7 Jul 2022 08:52:23 +0000
Message-ID: <20220707084925.tdi27tvfcnvzqoii@skbuf>
References: <20220704134604.13626-1-ioana.ciornei@nxp.com>
 <20220704134604.13626-2-ioana.ciornei@nxp.com>
 <20220705212903.GA2615438-robh@kernel.org>
In-Reply-To: <20220705212903.GA2615438-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 780e78fa-aec7-4cd1-b956-08da5ff60299
x-ms-traffictypediagnostic: PA4PR04MB9343:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n+bWQ7BikveXiaxEGnOjy02UA4GAOBKtH4BXG2oeuz5Z+0rk1pFUnxCUNEosE9OT0rVYVDQXIU5q1jZGlZABP8lFgbGLBVgi8OXVXteK7HVMNgy8hO8SsetzMUWvXwm0A5CzpSRjqx1QNOEiaL0YEC1LcG2Rw1ZUggkxZ9DaMfFJ70S2UtSCsC2gF3x2o1ZGkZl2pF382jy9EyjEJ3SyvNnqa3ZX5aQdAEr6nrv85T0/C9B443l/HMnw0mW4VXGE6N6aKGp7cvvzPQFbiC8YQOjGMu4D84scwR6zywLmT6JqoARgi/7eXDSQTV9AyvxKm4WA0ryvCf8Zwd57/enieTSw7b57LVbWOxWV9b73tT1tLqBif/lgtmbllCilcVieAQvT6TOrBegnCxu9ltuHAJS/hWfLnUrMiGF911P8E5YPxmYS5NCSv2TRNWCM8pmCnIg1+1o0GYAS31l5YnOo4q4oBBBFteMEr/Kg8jOjelX645+OylQTykmHwKfG/d0L4Cil8BZJIKjz+AaksbhEZ93d+tU66CCvQCeHknt9uD5b/YInt+DjNLpeo9gWTpfvu1mhYRZx86s9Jv4lyVZBWTyNfs6XdbCf7hJ9HBxYBvA85IAdgzIlBgcIfyCoT/fhszAANDBrwm64l/OwOEpKhoXy1a5PHVTHIuq1q2OJOdqN/wrTNKT9Dgaw5u6zyxLHBvkDeHVptUzOhPgVsdKXxxIXLWcu70NzBIzBmtPqK4scdfticvy9aUBWFmnTLl7OyKUz1/uBiQ4qpFSrrNJ0i4gb9CcGm+77xyD/vbIAoQ2mGCctLE8JE8zgHGNvfNum
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(44832011)(5660300002)(478600001)(9686003)(6506007)(86362001)(26005)(41300700001)(6512007)(8936002)(33716001)(2906002)(6486002)(66556008)(122000001)(316002)(38100700002)(38070700005)(186003)(76116006)(64756008)(83380400001)(66446008)(71200400001)(91956017)(54906003)(8676002)(6916009)(66476007)(1076003)(66946007)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZBQjng0KjV97W1BuK5MRjXvq6ocpZaj9AStj97tPktTpua9a7UoHQ+QQJeZO?=
 =?us-ascii?Q?5iA1MiKO90BqssGIyDFhAZJ26CCgttTx/DofH4Bs9avVw9RgVeTnNFTappQx?=
 =?us-ascii?Q?JDL8MzX6E3a26WtZUlsNgJDF7XwUMmU8dpJ/fg++Mok3BU136bv09jTPi7/O?=
 =?us-ascii?Q?/qfGg/iphLLV6At8Hvh/ZDg/AKIVinpGsh2qORt4vpn5bYNOxg8Snx95z/NN?=
 =?us-ascii?Q?yDSFhvLK/nXO58rVrBh8QoFbJN4baT7NaAJhaLrIsxoRXmKXLO2VFA9xJbjj?=
 =?us-ascii?Q?lQQ1yhZ1GdZ/oebNlQfiDPQyf1pm4I6lG6HrNoouWC61ZQfGC3zNCIuzfeKM?=
 =?us-ascii?Q?9QAIR0EE02EVK1ao1g1V65xfDWraNeuxMtWPE94bDBMIXrlO9/7IwcqeeDDk?=
 =?us-ascii?Q?ZrOkIKrUGuQc/HQ1TaKgh4xmx99bkCc0MRbd3idX5kghdq621LYisuhBVTeC?=
 =?us-ascii?Q?KpIndGHz7t61kQGQAJBBKwm1+eIk7gnsSBXQ0DMfpv6qNYeCGy4+L8lytDSu?=
 =?us-ascii?Q?eLvXvD3NaQnkPCgG4+lF044dLsqc5tTdbNtIdr3CV/CYHV9mwGRLvRiPeVZV?=
 =?us-ascii?Q?uh7Jy7xAzDclyX/Xd178A8actXejW81eQfvpK1hVCYR5DNCfgB1pXIgh6Vv8?=
 =?us-ascii?Q?SMCNJo3XdbltWUaJ2pI5VAYeVAsr2ubWkIJsYVQGfxMTjA2Um0OvvRNm4VpM?=
 =?us-ascii?Q?3cIUD6okPuOdYv0CgixUolReFiqHevMbL4FY54JRp39DfIx5WHFaeBL96mjD?=
 =?us-ascii?Q?ctR/XdsGWdxDrvAdUI5f65gVlPWPt4D7eYy7Aji64kGUl3dhhoevGPtlOf6u?=
 =?us-ascii?Q?EJ32FIIgB0248cKwP+M2J71GsdgUXG8qCCmlMIr0cbRUzhk1CHLX+1AlmXG8?=
 =?us-ascii?Q?JN221TZfHvN+xeeC25E1ALGelAwsjE159Zr6EHrl8uio6dm0L76qMYnRW2qm?=
 =?us-ascii?Q?tpGBA/8kfNzVJqWw2yggOBw121SzSTwvY63+ucDXKzUPK16J1iKE1FVTPjVx?=
 =?us-ascii?Q?3Ms93hNcZkqSjpHH6nYzC8uGIgKa0y9cQ+OtFzeTbsxnZa8dJeTtmKS0OTrd?=
 =?us-ascii?Q?e3Lo9MlN4DftspFQYTVewCNNr9B2uUMMD84RcDg/n42A0rHxO6T9NGzN7Sl5?=
 =?us-ascii?Q?DR6CCsv2YhNPvfeWONEJw/GBwiuCGPSQU0ilG3WC0J+LBOv2GsmkF42NJ1uF?=
 =?us-ascii?Q?L5I6/YFdPtxt46SooZqgUDP/603p2AzNlW2o9hSYvBzTyPAk12UK5Z4OOv32?=
 =?us-ascii?Q?FUc2Hqicc/HaZxGW2aD7BoXPPdIpNjoW438TlVpecZC+MMHK/VQTHsoDU84W?=
 =?us-ascii?Q?bwiegz3i1miyANg9OCrHv8c+ju6iITWmP63SpskK7cGASrDjmdkJ5yHG6hTd?=
 =?us-ascii?Q?nlpRcREGuOC/axJqUWMCIMd/F18VyUitu3c2N0bEiZXKoUAkCJcBaDeBAreZ?=
 =?us-ascii?Q?ca5VU5tz0npZwfDAiBDomPUzffc0W46FfIy/S0B6Elmp1qooQK0JOb/ujBCu?=
 =?us-ascii?Q?lTgKvg33gk0JQv5KyYSpnuIk6jPawn3hdlVCkkXtzv+QBoQnx1T+nXUtYEFh?=
 =?us-ascii?Q?O6fQgN3XgTUUc6fISPoU303m2MyGYDHymPWPtEr1uBsrLWNUxAWtsH9bR+/t?=
 =?us-ascii?Q?gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2BAD24F0CF001845ADB0A3BA2F1DA5E5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780e78fa-aec7-4cd1-b956-08da5ff60299
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 08:52:23.6412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzPA1CA5cqgBPpZDLZE5KPJpZ8VtNSozQ/YI/dEsFkyxtbLPbaaYI8oQCXYv9Gu7wP0S7GADJ4/DyfNn5m+PQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9343
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 03:29:03PM -0600, Rob Herring wrote:
> On Mon, Jul 04, 2022 at 04:46:01PM +0300, Ioana Ciornei wrote:
> > Convert the sff,sfp.txt bindings to the DT schema format.
> > Also add the new path to the list of maintained files.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> > Changes in v2:
> >  - used the -gpios suffix
> >  - restricted the use of some gpios if the compatible is sff,sff
> >=20
> >  .../devicetree/bindings/net/sff,sfp.txt       |  85 -----------
> >  .../devicetree/bindings/net/sff,sfp.yaml      | 143 ++++++++++++++++++
> >  MAINTAINERS                                   |   1 +
> >  3 files changed, 144 insertions(+), 85 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
> >  create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Docume=
ntation/devicetree/bindings/net/sff,sfp.txt
> > deleted file mode 100644
> > index 832139919f20..000000000000
> > --- a/Documentation/devicetree/bindings/net/sff,sfp.txt
> > +++ /dev/null
> > @@ -1,85 +0,0 @@
> > -Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
> > -Transceiver

(...)

> > +  maximum-power-milliwatt:
> > +    maxItems: 1
> > +    description:
> > +      Maximum module power consumption Specifies the maximum power con=
sumption
> > +      allowable by a module in the slot, in milli-Watts. Presently, mo=
dules can
> > +      be up to 1W, 1.5W or 2W.
>=20
>        enum: [ 1000, 1500, 2000 ]
>=20
> Or is it not just those values? Maybe 'maximum: 2000' instead.

Keeping in mind Russell's comment, I think I will leave this just as it
is since there is no enforcing made on the value.

>=20
> > +
> > +patternProperties:
> > +  "mod-def0-gpios":
>=20
> These aren't patterns. Move to 'properties'.

Yes, I forgot to move them when I removed the '(s)?'

Thanks!

Ioana=
