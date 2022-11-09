Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93EE6221D4
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiKICPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKICPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:15:31 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150058.outbound.protection.outlook.com [40.107.15.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4B853EE3;
        Tue,  8 Nov 2022 18:15:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnvYyDCYqrITViwopRGM/rUtdXp+Jvf+MlLChlO7WUA9C11u7G6KrosWNlUaCUd4OY8ZGJ9XN9SAoB5fgQ0/yTc8+tevOUqFs+3QSruPnWB+zZPl+VP2YZTUJ36n+Nresz8/XS7yDvDXbkaS4P94mxQZwUXl9qAVFnCxnEj4v9e6mVuFhGYYIkXEMIvoP9kKnNrIagWwdzYNl567HeMJ6l2sSOMiMkm1mctc4OwZoJY/i3+bJVbTDognXczTUAtbHNgGi/PiA13WMvEkI9I6KwppO2PjKOo7L/dCcyVpRNEfHwfTh4vVYz52jEqjMiafpGz01ngNVzuCzEvmienlEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qE/XumW5LKOVH3iWhM2ctKTET0gI99slNiPHaQtTpcM=;
 b=AA+1qxr1i9C6We774SdZTRPJOjsPo0jfsYwftH32tLREnKVzuqDN56s/jqYjPtsoUimz3mOFrOhhdi50AYjjRcXslJx61rX7OiKkzIYKKUE/Dc02lfHW0ZcevwqZrPA9O+t6MIRhcuX6rN4e2Xkn6HMOw9hYD4JvRvKt0chLS/NhZMjHKoHTq7lXVvo+Ch0V+V+lAmCgbijbTKJvR71trcVGkueAjpO5IHZarpwq40cOvpUGoHnQx/YyYUSrTQzT2ILIF5xt5LZZ6IeRSq+cM2krqL79/LhE/qVgJEbvkZlUpdV4OKpFxqAz/kwi4krSPhYaTfL2LWJxQjpaWlTmiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qE/XumW5LKOVH3iWhM2ctKTET0gI99slNiPHaQtTpcM=;
 b=d8POytt79H/MSrjtM+laWFO/RmQLIwztOXPR41e2C3ZUpRgwFku0RPbleSxriStallAD/xDPpD+SnxRQrIT9XZp949AvjX2dK8TWv7/B0PIXBTfGi0x0Xkl7VQONxbTdLCaK7eaF11IJYleZey5xgrLOepPw5Q0LUgU33D6hT3g=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB7957.eurprd04.prod.outlook.com (2603:10a6:20b:2a2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Wed, 9 Nov
 2022 02:15:28 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 02:15:28 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 0/2] net: fec: optimization and statistics
Thread-Topic: [EXT] Re: [PATCH v2 0/2] net: fec: optimization and statistics
Thread-Index: AQHY85aEDXDZHtbpuUeudX+XbjRKua411fsAgAAEGxA=
Date:   Wed, 9 Nov 2022 02:15:28 +0000
Message-ID: <PAXPR04MB918598BE192BEF2B5E7CF678893E9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221108172105.3760656-1-shenwei.wang@nxp.com>
 <20221108175710.095a96e8@kernel.org>
In-Reply-To: <20221108175710.095a96e8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS8PR04MB7957:EE_
x-ms-office365-filtering-correlation-id: 76aa001e-1897-4c81-9d0f-08dac1f84561
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u2Bx5+QRCmMXWRO6wLcwi8LSi55BmUF4zafyqKiCOFQql1a12HtUEUnImuOi6u/BMiqh1IFLivOvOR9TIUK7GaEafOa8w4SPEwDnpS/UMNus46XTmMLb5O6Qeuuqh+v5uY60lEEHHKZQnceISU1mcFoD76lZxog2jiKrpq4uvvJbL5ddN8nbz0ja9Sy3Idg/p8Qp9fCv1oYR/gVIuHmOG51G2PATil65ksKBzU+8f4Awg/J3AZuxMoP+4gV+dVyyRSYsEndfz8TM4gxQu9IfAqVhuLY4NxQrvAQYvn/VAaF4g1dxR/G53t2xP1vji1zxTYFOeid+nDxfW6ygseZOrccwVEzEtNnflh8eTUSlk7dgAvdb5ZrD9ITlA4R+cL6M8LfaNmay5IPNuespx0nuJwfEAWm1Eow/xDyfHvglVcLe97eCW0NeeUrQy6sRqKn6i8S/ewllUEJyKE/+qXQ9sG9Wb3d07XBwrauI5jqYYSRN2P+GtsgMOWxo0+vfiiBZbl7pvBVUaFLAy8U4MhEnU5N/5cvdc4n/WICW0HSaGwItLF2mtTGq3M63z/NJELx9nCzoRr7IyN4cBjl9bdvLA6Kugk/cse5h5YZXnKslr6JAj7gOZnkj1t3IKWarMjPDKBmoYAWwwbnVkr6dszwmzNY6SqS4BVQWc6c+RWk7ZO6Rh/cD5ZPRmUtHGiBrzdOslcf0hhbO7QlGJYFfBL1v42hqfg6IjRqbm7XobNNg482oMCb/WOU++XIIIyPNTkhimHdv454bQeYSGEkLeq7TUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199015)(54906003)(186003)(38100700002)(122000001)(66446008)(5660300002)(83380400001)(8936002)(8676002)(44832011)(4326008)(7416002)(55016003)(52536014)(4744005)(86362001)(41300700001)(2906002)(33656002)(9686003)(478600001)(6506007)(26005)(71200400001)(6916009)(316002)(66556008)(53546011)(7696005)(64756008)(38070700005)(55236004)(76116006)(66476007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lrCgUSI0LGqH7IVQPib1WfIgXRDxNX5vC24z62JpY+uJRkHxNr0aYKGWQuCz?=
 =?us-ascii?Q?Ldcnj0+bF/D0N/v6rJFRx/PJx0lXqRhMnFr9MFahlpbZaxZ5GbkAlPk8OtC7?=
 =?us-ascii?Q?P1Hj9G187MvbJNrR3Lk/+M/Zm22PHRqiZ83BMAAq1AymmlWNriTWfPXK0oG6?=
 =?us-ascii?Q?6pZpvm5fO+vCUAyZs8FSREl01oShEq42hJmHNC9KFs6NimYuOMRIy/YsaKeD?=
 =?us-ascii?Q?GGSljg7RCALYHg/BoxdKiglBWE8rebIEDSvXeL2klbtVTTtBJpnIfAGi3jQb?=
 =?us-ascii?Q?1QpiWDEp+3F2tk/GyWr5DB64V/ZkivOBSAnLr+ExUTsnlU+XVDN17BxsqAc+?=
 =?us-ascii?Q?tD/5WlP7r0inyVe0vREpckJDpSSzOhlxBJZYSuNfjkcYWEPnEH1XJKbURCtr?=
 =?us-ascii?Q?2xCTCf0JBtXEG6MTCJEIPI1XvRWn3iyr3GF3beQVsuRVaA5rvbygBJlWgeny?=
 =?us-ascii?Q?Y9Fpk5WxKXT/T1A/D4XU/wcmBkC/7CF6SUELtQSVqIuVSDYBYbnPuliySR/L?=
 =?us-ascii?Q?UYNpH9SPenOypqKWFHLkrHE0cPkWLFugVnPtkr6CdRDrn3jLSCBXN8NP8Y97?=
 =?us-ascii?Q?StLMdWcEtD//XBXrrRMezAd5jYFB+6jNm+bvPMfiJQC+1qTYMD95IqofMCPw?=
 =?us-ascii?Q?V4gnx9ugulA0dav/hFtS2tAG2e08y8m9xgcPaMcnQiQw7nI5wS2VU76njr08?=
 =?us-ascii?Q?nALc6VCSVn7/PPzY2SiIW7t/rTcE4I/raqjNetbc567uuOkmMPugmjaKQ9fh?=
 =?us-ascii?Q?kN2c0SXZTkVRY7+CfA0JCLxy4FPv9d1vsU89i+lrJcuffhtNQ/85YlzsdfFy?=
 =?us-ascii?Q?18V8NGXnBIG9xB6cLYfDlnfbuNdf6UiHGN/xj/RLoPKZJRyHhtJeM/SWuuoA?=
 =?us-ascii?Q?/J6kEwOtZcB7Ulae6hp4gTaXK3bAIh3gXFQbOfFMgjndJrQlXM//SkMEqsmQ?=
 =?us-ascii?Q?7dItk3SLnM+jsmElkxW5I09y629ClXsYt9mmjSCPk956zjR9Wtmmw6sWTPSE?=
 =?us-ascii?Q?xYtLg8P3vMragBI0ZH32Hc84hcQEarOw5LBOcyFYd5knDswzDty4lMxvdDSy?=
 =?us-ascii?Q?jSEITJuAiqJ0AxM15w+TD1qIvcgWI1MF86YN4xYvxVlwgJRa+pCKA4qZdIlS?=
 =?us-ascii?Q?i4sqROaUptz8aWx4w08y0xQcFBqrZcMkME6EDpdF71d2FDPKHIHEaR+MWx3d?=
 =?us-ascii?Q?phokdo9natvOzNeHKUtVn7WjPXN3TEfpbqyzN5rcQHjDYXpiRSpHQKkl4aQU?=
 =?us-ascii?Q?DJu/nJIn8oUmmP0vPEehN0bz5ukLj407W8IFlZfPLuPcjyQ9a0SEWs9ngfM/?=
 =?us-ascii?Q?C2h5mzbip7av+9O+zEdrD0oT1RxjwpUZz2ofTpUlMiL2MLlBWv6B/rAr3YLf?=
 =?us-ascii?Q?Qw+7N1ENEZ1oPrY8sW0UY8OWiR2XZZ/pcaLclSEGhLYQQaTZv8KwjfmS59h5?=
 =?us-ascii?Q?y5EEiBQkyD437sXyXOwdnrv4nCf+0Kmh31iixb4e5a8AG6lczI5lF9GHW+fu?=
 =?us-ascii?Q?FpVLdISL0s0JlCs7GceRFQLLIj8I6LFqKLG/R48/avwhcl64MfGTQ8jq03Gi?=
 =?us-ascii?Q?YFjfzD12Vke0Sfy+ELNBhbeRamrjPRjEhADaQGFi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76aa001e-1897-4c81-9d0f-08dac1f84561
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 02:15:28.6265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k/i/Na06GrfJXB1dQarJ5YOArjUv1npafB87fRo0/iubuuMWTWoz2lm3O5P1oEbn0m9prrA+JYVnhfThFyGcZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7957
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
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 8, 2022 7:57 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v2 0/2] net: fec: optimization and statistics
>=20
> Caution: EXT Email
>=20
> On Tue,  8 Nov 2022 11:21:03 -0600 Shenwei Wang wrote:
> > As the patch to add XDP statistics is based on the previous
> > optimization patch, I've put the two patches together. The link to the
> > optimization is the following:
> >
>=20
> This set doesn't apply to net-next, is it on top of some not-yet-applied =
patches ?

I saw the first patch " net: fec: simplify the code logic of quirks" had al=
ready been
applied a day ago. May only need to apply the second one: " net: fec: add x=
dp and page pool statistics".

Sorry for the confusion.
Thanks,
Shenwei
