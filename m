Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56AB524177
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345344AbiELAUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349623AbiELAUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:20:24 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2074.outbound.protection.outlook.com [40.107.21.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EF01654BD
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:20:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyl24wCq77L9rzzvWskrS7snMeZYND7oA0fxDNPqcClxZyRhsz3yZMZ3YLaXl9Uowfcs3PdyGQ9Dq2vESi4cZKGHEE98rZxd8kZpTlWoUViDkxXOnTuZFl/4Pmjk3G9G2esQYWimng2Ls42HjeOjDyfw1vlm99jIgvQCqlq2hFEpkNRGQATz3EKGq1vAxlOcvxB8C8C+1DEb4Ogn7Wzl+YMeT8VVrdHsFC0VwSJMDCcNAZU42RTHhUM9OGcV3fy0X3y/CDTNCdVO7yeXotgRoJsvmtrnEulTIauvkhQp25y6XSQle8OxHZqJeQJ+KbI8EfDUt0HE+D7gKEFg54OJ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1xKU38dgvc4idvNJOaZVYTOuYlOLI5vhOS3VkBSx+U=;
 b=ZN7WBoh7InejuzhDe2Y5Dv7dCeCrBeZYyyt7Xz252cPgzPCyOquLw7+boSp/fSYid1DbG98RlG8IiKrois2R/0FPW23iRQH2S6Uzn0EpcUUR7tMzUTOwGXtSU8+0rNkz7y8uQK6MrOOAOq7kjVx3JGUHGccQuCImR0X7rAPFSZY/rRh4410j44ErKOCy4z9onyyrhZ8V10SPQ8Ykzv4lBv0BRVGRwOo6R7toQAf6G1qO0nTfc0ndCo5mXeVYw+dBUx41n/0bSwn2PIu49svfXDfEDoQCysz35XYTU0xUMMipzNMxloSnmu1pwIzMz1DJsFxQAGcaikAUFhG8PhBPrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1xKU38dgvc4idvNJOaZVYTOuYlOLI5vhOS3VkBSx+U=;
 b=QG82nzfqvjZMy1rLeXoTKLyMBUxvMWzfPEM5n26y5X/8m2UxzBOepUVa3RKvKMGz2Vzpj+r6YySlr9iS9DjIyVEHNbSTBZ2xSW1wMWZNkD3f8bd+xsdKluSh5qBG/26dTbg3lQdbzEiNvfrQ6eKkeozbfc2yA+IUa8eDmpCDDFQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5936.eurprd04.prod.outlook.com (2603:10a6:803:e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 00:20:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 00:20:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window drops
Thread-Topic: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Thread-Index: AQHYZIwYAyud9yi3kkettoRjyMxmN60aQ40AgAAIaICAAAR6AIAAAR2AgAAFWoCAAAwegA==
Date:   Thu, 12 May 2022 00:20:18 +0000
Message-ID: <20220512002017.qxhyc5vautnrakni@skbuf>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
 <20220510163615.6096-3-vladimir.oltean@nxp.com>
 <20220511152740.63883ddf@kernel.org> <20220511225745.xgrhiaghckrcxdaj@skbuf>
 <20220511161346.69c76869@kernel.org> <20220511231745.4olqfvxiz4qm5oht@skbuf>
 <20220511163655.08fc1ebc@kernel.org>
In-Reply-To: <20220511163655.08fc1ebc@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9920e826-8873-4fad-394c-08da33ad31d9
x-ms-traffictypediagnostic: VI1PR04MB5936:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5936A0920A43DAE82E11FCB2E0CB9@VI1PR04MB5936.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: abAdiZNokV5iVSH6rdAmGdckABxWSTPzuES/kXGjtGLnDv1hA0InlofxIi/PLfDn8ROMJc3srKZKzB85HLJZhLu0p9IId0ylispbdzR3870YD3BLToPeAMs3IPnTJqvWnhFxQwkXr/BZBJyIkNRVDXvdCazqhJdPdG8rHaZLqUVXG9Rq1758mP8GVdsvdQy/jStXmxn9vS5s4PKCmlSiJGVdlmSUodhAhpHwPrwsu7xKYZjuNjQYAy74DLXpU6Mp0+404rMX3Z7wSdnMn/UB2J4bIFx2E/oby7/BepduEr1926bHgzpABc/EIvoCYu4dacPhm8s7tY5KMgz83R2x8nFlDuYXnEc7kd9aobxuLq/ABTRXnwVQG2nH8Cj/34kfuhwpTPJgCVvXUwdCRdEywreVNNEotrgJGrPPUkk96XsFz5IBvGEhlvz2Pmqb6ZN9VMzIT2sWCC1CwnfpznoDBJXFqhi44hmzCEuiJZ2n1t/neWKxrJeSZjDlTXezhM/AWGqcQg6051CmQWrhxXqpm5k205yb+h4xFX4SQCq+pvPg70I24OeSZwjBXnNzlrBdSr+tArxpYRkOBIxXNNQSxRn5KGg81ieklOB6+ibbZoZsuhnRu4mdiF28YtqXFXkogIHXTds6+7ty3x7KCEnIcaCvoPwthVd3+BbYtE2BzXSHAS/7f796hLbo4g3210RxhhbsaCXiETU1QIsA34oznQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38100700002)(54906003)(6506007)(186003)(1076003)(44832011)(76116006)(38070700005)(316002)(83380400001)(6512007)(9686003)(33716001)(6486002)(5660300002)(122000001)(8936002)(66556008)(64756008)(86362001)(8676002)(66446008)(26005)(4326008)(66946007)(508600001)(66476007)(2906002)(6916009)(71200400001)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ra0zlmXjw9J6NwLZbeYhy8JmYg7HwTgF4woOd5+LofARGFUFXF7FQfd+94UV?=
 =?us-ascii?Q?lTT3gkvN7CumhDPYqFyb6r0hU8DQs2DVLlzJpF+0jJkIAnjMph0iDF9r6H9x?=
 =?us-ascii?Q?V3Ujf19cPWFj4P9jutudVDdJQsCxjS2skPRBYz2vV5yUwMdK622VtwDvfzz0?=
 =?us-ascii?Q?s/q5xfyzNfCaamdKBNFlatXxZjj62hRu88WZs9aUnle/8J8ifXpa9nYEuWrO?=
 =?us-ascii?Q?rQJVgHMh6ZphhxlIOssIGFuWC+Dle08RLy+0kuuQBCxanOc8q2SQ+mcdgTpb?=
 =?us-ascii?Q?cq0H3fGlE1Sh3FAgO6CXO3iJJUNRMUur22h0jKFt97IVqYbpyVT0bJ2cXwvm?=
 =?us-ascii?Q?Jq8bVdAQoSeqO1dj19Jj2K+KflnFrRmlh64Zpp0d+VK30G9hJ3Qhf3J6AWiY?=
 =?us-ascii?Q?6TCf9FfAwseWwfM0eXbG9EUnzGNlzPIYv2/ig/9M33w9czYo3xEDew3jjETW?=
 =?us-ascii?Q?GEnQX3j1i+slYPO/AD/qDSWtqrLyiiMPONku5wKtx6dqADM8aTDBVKh7J4Be?=
 =?us-ascii?Q?9pidcHwrK2WJExnVCzaKmphRGpnz+RROBfu+hHhKpYwZ2dG1gS2tNvv7nKkV?=
 =?us-ascii?Q?lWJVBNYxtNPM7WqAfGRzUqKdDUc99UEMeZ38/pfiFnLOhKpi2GUwL9e0TOGn?=
 =?us-ascii?Q?7WtX6yacz6UYdFBJwh/nK3oaxTaoGL4Xryjy31RgHtS+skE+BMptg82q5514?=
 =?us-ascii?Q?lXDOVSGvSuCsmUWGsGpt4BbVZIn0mylpizm2omWtR8HS+r2TduuvT74m0SV8?=
 =?us-ascii?Q?b8l0XUjwQ5Ar3zBRH00UQ9j6DtnyvopxRS3VWNE9fkBuayS0JDcqS3PJV/JS?=
 =?us-ascii?Q?0McSuJRyJiS94ppVstaNjO6CgTBnUoVulEL6MYDASurHZQ9fRTAE2lYyYaRc?=
 =?us-ascii?Q?lMAylDlvv6ttqLh7/rJI2MKqQAnO9AWvFqRsGQ/SCLSS07w6aNlxQkwoL3UK?=
 =?us-ascii?Q?6SZ+fd2vSzhHEiqYmZ6WwZ8Mh7L4NC4XgjO3aqplhJlt3jUT9DBgtYS2tkEj?=
 =?us-ascii?Q?1fDsm6HkKTGq8Wnv04CC+5qcx6pMf13/xtELq+G/fski5v67c6tZS5PtqRc3?=
 =?us-ascii?Q?5L+egi8a/cxWVZo5S+xshbayqvsFcxlwQybeivjsFfGnPo8CWwNFA1NrJa+W?=
 =?us-ascii?Q?8n65ajewQBTkWSsYnKtxUBROsmvEu8d9mBBGyzV9uM+XikIH7mP97DQaZ6Hs?=
 =?us-ascii?Q?RnP7x5sQl9I70vWMMo1B17PAfk93x4YlDpb/0P1OlJKuAn4adDEg9EVNomff?=
 =?us-ascii?Q?QbDlCFbGudL+NJFrMjXehCYEhiLddjWqzfSbpB2DWQyXUAGODSToLZBFQ+Ok?=
 =?us-ascii?Q?UTRGd+DWd5DSXWBnMUcQY/hj252G9xSbPBpnpntZWiQJzQLAI049Ic5BYYEX?=
 =?us-ascii?Q?L12YHmt3o8+k/hC8Btl82Wb8zQOA30q26RAgFJL3226vjRfJY5z26Fcu8p1E?=
 =?us-ascii?Q?/xe1DQAJ6JVEkbwHeIOmhPFnH+Gjnig4wK1/Gp+Gg6dmipaipurILJ8xvs6j?=
 =?us-ascii?Q?VghV6FPTergX2dNT+kX2InNqQ9aSGZM/xZ/5Cf3OEZ5cb9TgLYOJFz2wCoFj?=
 =?us-ascii?Q?I7JlkVtjJYKIAxF3djRxlyrJS0tx91Q7/MJJDObfIYIh9+d0h0CmWtAxONE0?=
 =?us-ascii?Q?cqrJNXmlBusPoikjHsw/JwvURpBf+rNA+8SSqPRYuT5D+uMjoFUI8lKv32l2?=
 =?us-ascii?Q?gT9c4U44V/sI7P3coIvPqWjpbMbveCaWNkAChD/UVgZ14fO2eO7deR/OhN9o?=
 =?us-ascii?Q?S9lsBlZq6Z5wjW/r6RZu3qMZ1f8VZzE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7D59CAE5B66A14F82C369D2F54C16CD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9920e826-8873-4fad-394c-08da33ad31d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 00:20:18.4712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kSkNjJy/Uu6Iii9LDXGbr/c60/6a3iQvTmQARCnCEjlM1cIW69vCmK3FV8EFLUF9oUkFzfMjw+VUYHJSfPUZJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5936
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,THIS_AD,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 04:36:55PM -0700, Jakub Kicinski wrote:
> On Wed, 11 May 2022 23:17:46 +0000 Vladimir Oltean wrote:
> > On Wed, May 11, 2022 at 04:13:46PM -0700, Jakub Kicinski wrote:
> > > On Wed, 11 May 2022 22:57:46 +0000 Vladimir Oltean wrote:
> > > > The only entry that is a counter in the Scheduled Traffic MIB is Tr=
ansmissionOverrun,
> > > > but that isn't what this is. Instead, this would be a TransmissionO=
verrunAvoidedByDropping,
> > > > for which there appears to be no standardization.
> > >
> > > TransmissionOversized? There's no standardization in terms of IEEE bu=
t
> > > the semantics seem pretty clear right? The packet is longer than the
> > > entire window so it can never go out?
> >
> > Yes, so what are you saying? Become the ad-hoc standards body for
> > scheduled traffic?
>
> We can argue semantics but there doesn't need to be a "standards body"
> to add a structured stat in ethtool [1]. When next gen of enetc comes
> out you'll likely try to use the same stat name or reuse the entire
> driver. So you are already defining uAPI for your users, it's only
> a question of scope at which the uAPI is defined.

The trouble with over-standardization is that with a different driver
that would use this ad-hoc structure for parts of it, you never know if
a counter is 0 because it's 0 or because it's not implemented.
As unstructured as the plain ethtool -S might be, at least if you see a
counter there, you can expect that it actually counts something.

> What I'm not sure of is what to attach that statistic to. You have it
> per ring and we famously don't have per ring APIs, so whatever, let
> me apply as is and move on :)

It would probably have to be per traffic class, since the media
reservation gates are per traffic class (TX rings have a configurable
mapping with traffic classes). Although an aggregate counter would also
be plausible. Who knows? I haven't seen this specific counter being
reported by the LS1028A switch, for example (I'll have to check what
increments on blocked transmission overruns).

> [1] Coincidentally I plan to add a "real link loss" statistic there
> because AFAICR IEEE doesn't have a stat for it, and carrier_changes
> count software events so it's meaningless to teams trying to track
> cable issues.

I didn't quite get what's wrong with the carrier_changes sysfs counter,
and how "real link loss" would be implemented differently/more usefully?
At least with phylib/phylink users, netif_carrier_on() + netif_carrier_off(=
)
are called exactly on phydev->phy_link_change() events.
Are there other callers of netif_carrier_*() that pollute this counter
and make it useless for reliable debugging?=
