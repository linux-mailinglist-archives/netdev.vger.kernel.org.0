Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4FE5160A7
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 23:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbiD3VhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 17:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiD3VhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 17:37:12 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60AE27154;
        Sat, 30 Apr 2022 14:33:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScBjTn8l/O3tRP7a+zio9OMMtzBPEV4u+jiNEVB+Kt47lH/PoEVrm4f2WUws0xPvQfOstlSXO7Tog0TE3RguUVTM7RKzPYlbUlQ8gRZ+I6JxsRDMTlcKY+0ANIuEge+q7Oy/BjHHBEnhY7qn0qkW0cVt4Vz/EKegy4CodYB9n25M9NodwcUaoVYH67s3lS8FfMSIfebLPU+tNOlfC7Z7KsqDKLdnOWE4oHx0OfAdZhIZYY49XttiXxiFAVo9E9xFng2+gTnnoV0U4kjY9JJzNZx8IqHqQ0eF1N6uJI3vXER+0VY71tjlIdFsmlN+pT+TJLcmGWfC5uWAt8tnENVuQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CO4V1rFWMiICdnrLMvuXpUuxwKd+uVbVHh8RhCdd6+Q=;
 b=Ft30QGLO3s6VyoFmHy5PyTlZybMFl040KdU1Zm4iArF5FjowDj/7FMZMyyIoIhGGUH0vIgM/dLMEi2ld1BTRPS8qXemoWkiWCUG34+fsFPpAlmyIRzcvN1bzTnqmE7E3cQQm/5dovsZ9ecX8/q+sU3+N6PQl3747xiP7uXSfGV7ZICNOyfo1G49nmpMta6eUgFhBkmIHScUN2XcZXhybEhrKQzzeJGkj4nmP1OEsaVM74leQwRzU0rymc7tLNeXvR9k7Y6ChdlYEpDCvK1c3A7aTNr70YqUW3qzFTDFuEihllwa5RUGbqBKE/jX+7RoL9JapOGCkHGhOrMlZHZ/mEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CO4V1rFWMiICdnrLMvuXpUuxwKd+uVbVHh8RhCdd6+Q=;
 b=edBA3TKI7BGUgFEIEcxHLUnwlvrqJEDwI9F+XXd2+A66eDcHV1eEUYjVegBd/Kubhk9hsNvQEI1mqpEOVPsOLnpkQzCR0AIOgulSsj4L+cdpw0JI94bmUp/fzhE2i20H/dXWKNLV/YWUFPOhZ+6v8fJnhBIOmgpYem5LByFToVM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB6154.eurprd04.prod.outlook.com (2603:10a6:10:c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Sat, 30 Apr
 2022 21:33:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sat, 30 Apr 2022
 21:33:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        aolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 1/1] net: ethernet: ocelot: remove the need
 for num_stats initializer
Thread-Topic: [PATCH v1 net-next 1/1] net: ethernet: ocelot: remove the need
 for num_stats initializer
Thread-Index: AQHYXBBpaZvHdMSucUK2oh2cKAMiLK0IkiEAgAAqfYCAAD8wAA==
Date:   Sat, 30 Apr 2022 21:33:45 +0000
Message-ID: <20220430213344.ifiw2wjtxqd2dqbj@skbuf>
References: <20220429213036.3482333-1-colin.foster@in-advantage.com>
 <20220429213036.3482333-2-colin.foster@in-advantage.com>
 <20220430151530.zaf7hyagln5jqjyi@skbuf> <20220430174735.GD3846867@euler>
In-Reply-To: <20220430174735.GD3846867@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5918c7c6-072a-4d2f-ccd5-08da2af11b06
x-ms-traffictypediagnostic: DBBPR04MB6154:EE_
x-microsoft-antispam-prvs: <DBBPR04MB6154FC3C5ABFAA76A4FE4F55E0FF9@DBBPR04MB6154.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FnbyU3dkWR0gkJa/jpo/A75sWeIE0nU0Uu+31SVsQhIQpmQ/2uvuz/LCsp/1DkkjaE+x3/iha0SySsKaMRt30te0mQtta3DwRRGUmBt4NUPlquX6GSTnUAaOqX/sGuH/zzAEhAu1f6TKk8dEZNxrbTHYZHxr0UJKpWWOkBRoyutqoEa0IayzEDtQ6W4sZ1oiDB7ohT59VvpX5ageqTpfDTJAakHkbso1qVsc/GZUtW6GGSzfBZSOx3Bi3EiLriYFTbAhuE1jNiklEJx6ovNBZypt/ozLPdLrqllDE6MawldKct0vAM2NL0UwVC4jroi5vMTjwMools1/VpQ3+e/iiXOwbmVEaoL4JBc4XMITRGF0i0BcNruP0A/37lAZflveHubNCY2R1kxZacTdrC4a0bl7ywqgkQ1cNHyjoVe/tfe9tTOU7o9JjxNhvK++vtR/GjH3fdQ4K7DQByzU/NaSjpPoxSatTeAI0nRsDn92UT0yAvBzxJbIpoR5+LR7KL/DV+5Xx2Ema7j2Ue5eonh+GjRIKi0wbTX7iNlJKgsYifep5vakhpUmDbirCHEUJP4n6O160+IbIDYyuSFR6jGejJKxklt4lXQxU8ycP7RhKaSH0+SLXMgaNNtXYQTPyBnnS5b546zuZgZ9PWT4g8V6bf7AtAQ4UIAS+cUuWC3amCMO/wa9awdhpxBpuOinqUPd8z6BeIEQoKwaiuqq1R7hXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(5660300002)(6486002)(8936002)(86362001)(2906002)(122000001)(44832011)(7416002)(508600001)(38070700005)(38100700002)(91956017)(66946007)(66476007)(66556008)(76116006)(4326008)(66446008)(33716001)(186003)(316002)(8676002)(64756008)(6506007)(6916009)(54906003)(9686003)(6512007)(26005)(71200400001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aBvhmOkQ+UpEBHwBzxXgOzdKDdkscnq5GCuWY0LLdQOpaUwsYSYddQJq4GrC?=
 =?us-ascii?Q?jLF+hGa7LVfn34DMj+KoZNbWU8Xe2t2WsSndr/zdAw/6cqmpupY6+jcvPNhu?=
 =?us-ascii?Q?TTDXgVPUUZk/VSlljfE9xCJ7l1MFI4oMMvmcm6Bo2B+FfiFMPvVbF+kE9LK/?=
 =?us-ascii?Q?XWIUo7Ks0ZUiLLn6VENvktWOmYfsSrb8L69rW13ZgkHpvqdRUyXdsNEf9lhk?=
 =?us-ascii?Q?91prgLX5yjv9f5/kSCXw5eqNRFPdCWeBTjwfl4AE4sjEJYSxtgciOu3YZpwF?=
 =?us-ascii?Q?oajrjssbXoqUs0uKVNSnQpLlS2wxFV6XUyyvKaVKvT+SAYynsWjd701FoILp?=
 =?us-ascii?Q?2NyIzDISqyKntq23UZKTUWw1ZIFCOXTYZqWTnY9XnpW9nRUEuEVxiSVyp9Ep?=
 =?us-ascii?Q?r9oaEBpXlw7WpvgPBgY4qLoEVXNZVU5SCMWssOUN2/IihDORwdGUg8zN2l0r?=
 =?us-ascii?Q?tVQ711bG4iigmOmaPdAIqNbaafCmYRtL9tvNaYdxc3sovGqJ1N2Ipj2RnvEK?=
 =?us-ascii?Q?bQU+qrJPSaxkEexGE2u8G5TUN9pDo21d+08hv+tord+K/z+KwpjAyF0ZOTSr?=
 =?us-ascii?Q?wg22QmyI7jHGfJwQYFsId6QH4ih7l5ANZii03jaJn6/FVyHRIwHd4RTqWlTe?=
 =?us-ascii?Q?2w9BKDVT7iH0THdr/9dTj+nzfoaomUCUsiZ4qYPTfZt2C+KGhOS05xGOVV8t?=
 =?us-ascii?Q?690mDvrN7vB3yYxvUWYObc+nUi8/MfkeLRXM5gbVLgHxVGoV21hnW0dBRNGO?=
 =?us-ascii?Q?LHev2RVC9p1vK2PfM1AXYnFdDFy4YzhsYezA8oHFKV7+6VypKjNeC8QGreLW?=
 =?us-ascii?Q?p9YHU4rArVAEldIT0Tesin1bk2uW7EUZZmoctL9Jb2zw9oj6+6ObMiiQTh7I?=
 =?us-ascii?Q?40Z3oZAE2+OoYjTerTlSXK9gpT7xpPTYDn4qDMSk345Jrl3ty4WPhiv8CwNZ?=
 =?us-ascii?Q?H8yM6eQOSYD6bVMkKsax1zr8lDJunu/4WpbQAxPeWzhk4L4IqKAU6gaynjZN?=
 =?us-ascii?Q?6IfXQ6bbB+I1a0GSfoDSPsErrjF2Kwtz89nULfsMPNTlXTRPYZ+nwY/r1LKx?=
 =?us-ascii?Q?MV3RMXi2Bg5D7YQxf2sGEITv1noL0KctQ2kJ7z73QZTIgCSMb2Fb7DFkV2lW?=
 =?us-ascii?Q?pexSd9QRc0tqtZZFx1DLKPPdJPJyHUPa4ozMS4RXCysSKrftihpD99aay30X?=
 =?us-ascii?Q?311CRuIFIljbUxEH156rKmkJvh0+3vyx723iy10Omeln6MRLK4iLHEIi3FlI?=
 =?us-ascii?Q?b3iKOHU9mqrIC1cSzq6c2ddfxUCh7fl27RY1XIbtxNAlP5wlPRrBbYxAYQj7?=
 =?us-ascii?Q?+uJOGi2T4cCXwYmxohjHqXPj0qc9TpOCMZT36E5UX1KXqJV9hS3yqy6KX5h6?=
 =?us-ascii?Q?DxdtWEdQZ0mEI4dArxQd05cdvgQ1nSSD3o1fR3EoVTFGIAnBaH8WfpRqP2Qn?=
 =?us-ascii?Q?+5cwRB/MdrDYpkA0dzmb+vgLIGW1DN/J4QHEFyJdgVcOVy/j6zJOb5wWHq3w?=
 =?us-ascii?Q?bVunm1u/Tpn45Qi5fyIN3jTE+GW4qWUNUBOcWJCcSPNOoBZjYCmCrNswgvfD?=
 =?us-ascii?Q?W+LtiAbQ/qdxl3YenU9ZvIudG8TMhZWww5zsTqcuIlY+x06P+MlkzvE89XpQ?=
 =?us-ascii?Q?4S2T+TRhP0ATItKL/5BfrfTBQgWVWjmM/o7KocT7ucNFMNvraE7miqkxHxaD?=
 =?us-ascii?Q?WulEac/V7c9glN7Wsg3MJs5d8JXCVemMcaLQc3yEhKlH3a94DHGqf/tqyjub?=
 =?us-ascii?Q?NSAcrNTSLI1QcT4yN9quyxwvlu2MXeY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <921CB246049D6841B9597D3B23D963BE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5918c7c6-072a-4d2f-ccd5-08da2af11b06
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2022 21:33:45.4949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vFsI28kwtRjq6bSZrVCnF5wDRF3bxsZrul+bqWOlNWb91l4mFl3Fe9Jvq0nYhC7eHq+XdtKPWe0bgpmeD8bNzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 10:47:35AM -0700, Colin Foster wrote:
> > >  struct ocelot_stat_layout {
> > >  	u32 offset;
> > > +	u32 flags;
> >=20
> > Was it really necessary to add an extra u32 to struct ocelot_stat_layou=
t?
> > Couldn't you check for the end of stats by looking at stat->name[0] and
> > comparing against the null terminator, for an empty string?
>=20
> I considered this as well. I could either have explicitly added the
> flags field, as I did, or implicitly looked for .name =3D=3D NULL (or
> name[0] =3D=3D '\0' as you suggest).

No, you cannot check for .name =3D=3D NULL. The "name" member of struct
ocelot_stat_layout is most definitely not NULL, but has the value of the
memory address of the first char from that array. Contrast this with
"char *name", where a NULL comparison can indeed be made.

> I figured it might be better to make this an explicit relationship by
> way of flags - but I'm happy to change OCELOT_STAT_END and for_each_stat
> to rely on .name if you prefer.

I would have understood introducing a flag to mark the last element of
an array as special (as opposed to introducing a dummy extra element).
But even that calculation would have been wrong.

Before:

pahole -C ocelot_stat_layout drivers/net/ethernet/mscc/ocelot.o
struct ocelot_stat_layout {
        u32                        offset;               /*     0     4 */
        char                       name[32];             /*     4    32 */

        /* size: 36, cachelines: 1, members: 2 */
        /* last cacheline: 36 bytes */
};

After:

pahole -C ocelot_stat_layout drivers/net/ethernet/mscc/ocelot.o
struct ocelot_stat_layout {
        u32                        offset;               /*     0     4 */
        u32                        flags;                /*     4     4 */
        char                       name[32];             /*     8    32 */

        /* size: 40, cachelines: 1, members: 3 */
        /* last cacheline: 40 bytes */
};

For example, vsc9959_stats_layout has 92 elements (93 with the dummy one
you've added now). The overhead of 4 bytes per element amounts to 368
extra bytes. Whereas a single dummy element at the end would have
amounted to just 36 extra bytes.

With your approach, what we get is 372 extra bytes, so worst of both worlds=
.

> > >  	char name[ETH_GSTRING_LEN];
> > >  };
> > > =20
> > > +#define OCELOT_STAT_END { .flags =3D OCELOT_STAT_FLAG_END }=
