Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE545679E5
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiGEWEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGEWEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:04:37 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10063.outbound.protection.outlook.com [40.107.1.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA5D18E1E;
        Tue,  5 Jul 2022 15:04:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLrKgDz9CjZExVbDQ3ChYDcxvxU4/rrA4zMJVpUMsU//w98NANsfY2rxEX+agzvBr3vJPEvlII2wOOPOIJLpYZ58VCWt9jPPMXqoGDRFvtNJlsSL8N04+Qm06kcxGTixfQr5ZwdqiddLUTzsQp4Vi602ZKbGWVzAMyKyYcU73qPA/r67MbfQ0SOn3NcU5Lv2SUAy2mRBlIRpAkpCFAeCXrPSTTOt0AxjXO1HxzxzrHbUOsmce9nSKDjrtACR9ruf2Vmnsv67p0XA/8LQeMqIQOe9LPHBkNmPMbRHnWxq89FiiC0AyoTRHkECz1EkTurJACB3GPkzd7OWVo2skfZlOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiVsQocCpdpefrfJ2SCEatDmMGtizAJ299mYXYv3xk0=;
 b=gNgP2TUE/rAhATjsSOcGIG+01vC+omzD/U1KUjxnT2EoL91nhW17o2itYFy1A5WalUgeCY46RAKH++i9COOCXPlupo7+tEGWBYbu9eZLGH6tSqWaurFs27wltBkiyTNs5pBclhS9QTqSYEDKzlyEuonFO7d3Ng1BNP/zilbAaK2+Xl04go+M8ywmqMe9zC2c6yQk9QTeIBaszVkDcP2tsq0GN+zzjVCvkhAWVABE1iOIGJt7UYZHv0+CHzoAmdS3pJugDeeXLGi3gnBMAHCZwfbLjDGU586yIzeSdxgX9orHQJEWo19RB2pLGeLuW9L2LxCz67KvRqNJl33AG7fMGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiVsQocCpdpefrfJ2SCEatDmMGtizAJ299mYXYv3xk0=;
 b=efhgH9RR6PV6Eq6qWOMhXcOO10dEYv2ScDIMRn9yfU+7Bpe7KPpZOTWmwrCmG1vy0G7rAwX8qCo8b3+pVI2ZiPO1OZf1WPPguggB1tGhbew3v87xhCKV4TtWXEI02yn2DdrguGiPd/bE0JnU3Aj+JHYAKUuLEUTTGz+onOP/RyM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB6330.eurprd04.prod.outlook.com (2603:10a6:10:cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Tue, 5 Jul
 2022 22:04:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 22:04:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Rob Herring <robh@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v12 net-next 0/9] add support for VSC7512 control over SPI
Thread-Topic: [PATCH v12 net-next 0/9] add support for VSC7512 control over
 SPI
Thread-Index: AQHYjYB07kRKEY0yCEKC0I+GdNLs2q1wP2sAgAABpYCAABpXAA==
Date:   Tue, 5 Jul 2022 22:04:33 +0000
Message-ID: <20220705220432.4mgtqeuu3civvn5l@skbuf>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220705202422.GA2546662-robh@kernel.org> <20220705203015.GA2830056@euler>
In-Reply-To: <20220705203015.GA2830056@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7551d611-ffff-467b-87db-08da5ed257b6
x-ms-traffictypediagnostic: DBBPR04MB6330:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1sZL7oZTtFIKH28GVYRpAucjCSoWoxGB7JaspCBU7TLGQbrfDmeugcwCF5b0k9AnqREK7CNbST0W7YNoZmiazX0SKFzaOHIFEldps0SEvwPz7WOPp/ZgzQJAzR+m+Dq993jS1xmPqse8V8IaCHa1unaC/6enjJ4nSPjZaOVpXRye9mMVz8Cs6Ilba83nKQNROmf3STZ4QnqaF/5et7D1z6NAdNfiCD2mFhChFMBTRsOC/XPXwnoeMblsrGaHEDzhBc5Rzzvh4JkVpyMTYQ0+gIKLE8sEHc+v+rRKsZ4GiuyEZCN3BldQSoFHOuItpl/54ni2Ym4rsF+oX/92LijT1Yo2TEfdEM/AG/2wAoEGC9QF6DRfxn10bd7nVkSEXN56+vMO2nOYTlq2eWZ8jt5ktboj+qgAyk+S8Q/RPOcF9ucRMiUWYweT3oIO2QGsj14USxoJZBwxJHzEdtWr7xa8dl8RB4Xb9FYeP39brEvpOH31AJlgflsZ2/hqOyyBlVQzdE7OU5AY8tUXx7400WvzpDxKuvGKco694r1o1bDSee+DANuT+ILCuexeSwm4C81BhXjamYYC5i/uMRoTtfPabJFXSuY8M5NFOWvBKqu8vwDcbAtor7c2wECFWGDmCEptAelMWMnb7rnaUYPOJyyrwQqjeRdfD9EAb6qxQQXrlLCeImynfJZVU1gfaSTp+HvY9P6qLGFZzkdhrD2+VNwuh9f3109mwoEqQXX32bnp9tRQhBDACZ8MvcyFrRMjA9sOHQ14OYLsSM6tIx/o3QDTrNmSq5dnfEc+HIKfu2tFCPGm4fGH5oarzgwFxiKGFme1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(346002)(376002)(39860400002)(136003)(366004)(91956017)(54906003)(5660300002)(6916009)(8936002)(9686003)(6512007)(33716001)(4326008)(64756008)(66476007)(66556008)(316002)(76116006)(66446008)(86362001)(66946007)(1076003)(8676002)(6506007)(41300700001)(71200400001)(38070700005)(38100700002)(26005)(122000001)(6486002)(83380400001)(2906002)(44832011)(7416002)(478600001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PF7dEWGBLW4LqITh5fCvVYUW7i1VzyzwJf30LLj44c0jDLrYRuRefkkfs9lo?=
 =?us-ascii?Q?Q6IbG48RNFNAn4MQZPPv4ifqw78m8I2cJQRyYB5/Ub8599cKarvv7N2fDs6X?=
 =?us-ascii?Q?WFaHJ7TXOkcFj7C7w+AqEtWCdV3I5ESYuaxExr4t/UVpVIiGWoMTrJ8VTIyZ?=
 =?us-ascii?Q?70HflxR8P2eBK7O7V/1y3Mx58b6rDU4kUcRQ2C7qY2M6GMDUQpcqPDt2JYyI?=
 =?us-ascii?Q?atmuYScTjaa7s+/RkcIvTTD4qRB9MH5XgM2nH/UWyNBK/oAC4rreAfg8MjCo?=
 =?us-ascii?Q?5Tje6cWRLJqTUxJvnkSiTxOISnkjZqQ+Oxe073xbl1mnSewZCj0Nlojcw3h0?=
 =?us-ascii?Q?CaLxZtb0CZlMKZIbzF2Z4Z8I3Gcthfbly4bjhz0qhKCzXlwHSLyubZSvUDas?=
 =?us-ascii?Q?Tf3g0+Zb3BAcTkvi1G32TvgZo32X0Kwe285YF5wuuPGk4Bflo5K5L9pLnrz9?=
 =?us-ascii?Q?qFh1BfJ+MYo3X7gZ4v/YOQAk5m2D7KiLAZVXJLxBrQ8LjrsIE8myZ7aj4pM8?=
 =?us-ascii?Q?S8VHeJ8DIKH+K3y8qHFD39Nt6e/y0WXGxpyrc6eXL8fLK/NvnR+w5hRG/URU?=
 =?us-ascii?Q?XXgA18M6AnUcfxEXMZjZGDtWH3eOx+dHe3qY6+dSSSCp4i+n8PsV64vl5DwJ?=
 =?us-ascii?Q?VboHm9pM0T12IuPw7X3NUSeRf/d57w2q2N+/7AmcC6U7aNqgz3P9HnlN3H6w?=
 =?us-ascii?Q?FiejzD8gOa/givb61HySDvu0ypJip1i03z1elFkC6WJiZ5RPZ1FChur9RD6e?=
 =?us-ascii?Q?kGRPzD96/bE1WCyqrscK6kWGfXHQO2bdaR9UFShnATGCeQsGxhj8TyudHXcw?=
 =?us-ascii?Q?XfI82zyj3FHhcsPnDZ4eiwRAsDQbrh63U19IB+JkSpnnw0EDgslkoSlmTdRu?=
 =?us-ascii?Q?cXi0wU5edmEaLL+ZnCe8LuCKH3Lg/upxhb1V4kSdxLRJZX7PYPHC9/sm3WE0?=
 =?us-ascii?Q?TVmmX7T40ktnKonpP8qjT7B77jouwcsUlVFZdbAAeam7GTFqIsBruwvQOG8V?=
 =?us-ascii?Q?2J4+aUWSaqj5ic7dcF5KuqNHJd+0WlG71pmls4BcVuhDrnPMwtMDNkKsICGZ?=
 =?us-ascii?Q?LCbp2jLV6iq26A3fZ9C4+Xv7sSufoBgm8YrJ1HBNiDcvCkGJMHHI9eFRV7yO?=
 =?us-ascii?Q?hITBRPLboG3FImQEI4nsawHDJv30IuB+ZwBC83RHtqN2YmpERpIvQiaScA+i?=
 =?us-ascii?Q?VEjqT54VU+dJRcSSV2y/+xXFaWHLDz+H4kPqo9c+GALY6ryYNJYt/n9d3/Yt?=
 =?us-ascii?Q?Ao0jpV4u9Zho9bl4z4KKT891hGkUHGQA8nDEHGSd4eED3N9XzjzErqGoYFO7?=
 =?us-ascii?Q?LmOVP+W3f4EHT5PziSvjY782S3oeNIefBVbRwmf3NznscH9vXDrnEG+EE3Lj?=
 =?us-ascii?Q?y0pIL5bbW1G5DPAeOU076u5uH1Cs9dgnOMkPDs77iGmt+hOCX3ro6NS6yPwA?=
 =?us-ascii?Q?uqzm88060xo08l3mXfkhmxbHTMX2noPIqH53AvU6XOnJdhKdQrmySCl5G/w1?=
 =?us-ascii?Q?VLKWcTzoRbOJxIZFKVyGWH2ueWlJLESRIfW6k6vV4PPM0F69gQqS/Mr7Lmhu?=
 =?us-ascii?Q?Nxw2YOb7Mdg/AKjsZbXo3J0iLmsOgOB2gAzhY7sVwEoXG8MCDFD0VzhHxqox?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <479A535E7B25B341A665D5BBDD609C40@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7551d611-ffff-467b-87db-08da5ed257b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 22:04:33.3601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YiZZKAInaizuTXNvUP/Mbe8PLHh4Rq8qReGECPluFjyw0dHVH7JqmB/1tyURxMBeUTNTXNxZl04QdBOksU/apA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6330
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 01:30:15PM -0700, Colin Foster wrote:
> > Not all that useful as a changelog. I have no idea what I told you as=20
> > that was probably 100s of reviews ago. When writing changelogs for patc=
h=20
> > revisions, you need to describe what changed. And it's best to put that=
=20
> > into the relevant patch. IOW, I want to know what I said to change so I=
=20
> > know what I need to look at again in particular.
> >=20
> > And now that I've found v11, 'suggestions from Rob' isn't really=20
> > accurate as you fixed errors reported by running the tools.
> >=20
> > Rob
>=20
> Good point - I'll be more clear going forward.

I have to say I agree with Rob, and no, you weren't more clear in the
v13 you've just posted.

First, you need to understand that a patch set with 13 revisions is on
the long side. You can't honestly expect reviewers' attention span to
last months.

Now, ok, you're at v13 already, entropy goes forward, what can you do.

First, you can link to previous versions in the cover letter, and also
parallel series containing sub-groups of patches. This information needs
to be carried throughout. I spent too long tracking your patch set
numbering system, with change sets that sometimes cover DSA and
sometimes don't, then they sometimes fork into separate series.
I lost track, let's put it this way. I'm not an expert, but I spent my
fair share of time with VSC751X datasheets and I am theoretically aware
what this patch set is trying to do, but I'm still lost.

Then, each patch needs to contain a version history of its own, in
between the "---" marker and the git short stat. Look at other patch
sets for examples. This must contain a description of the delta compared
to the previous version, including commit message rewording.

In extreme cases of large patch sets with essentially minimal changes
from version to version, maybe even the output of "git range-diff" could
be considered to be posted in the cover letter (that's rare though, but
it might help).

Generally, what you want to avoid is changing your mind in the middle of
a long patch set, especially without traceability (without being asked
to do so). Traceability here also means including links to review
feedback asking to make a design change. It may also help if you reply
to your own patch sets stating that you've found a problem in your own
code, and that you're thinking about solving it in this or that way,
even if you don't intend to get any reply.

You may even try to ask someone whom you're not working very closely
with to proof-read your patch sets and get an honest feedback "hey, are
you even following what I'm saying here? could you summarize why I'm
making the changes I'm making, and is this series generally progressing
towards a resolve?"

You got some feedback at v11 (I believe) from Jakub about reposting too
soon. The phrasing was relatively rude and I'm not sure that you got the
central idea right. Large patch sets are generally less welcome when
submitted back to back compared to small ones, but they still need to be
posted frequent enough to not lose reviewers' attention. And small
fixups to fix a build as module are not going to make a huge difference
when reviewing, so it's best not to dig your own grave by gratuitously
bumping the version number just for a compilation fix. Again, replying
to your own patch saying "X was supposed to be Y, otherwise please go on
reviewing", may help.

Also, ordering. I don't necessarily care what changed between v1 and v2
when you post v13. So you could start with the changelog for v13 and go
back in time from there, so that reviewers don't have to scroll more and
more for each revision.=
