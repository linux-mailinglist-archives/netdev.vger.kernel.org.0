Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3AE62A0BF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiKORxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiKORxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:53:32 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7E921B2;
        Tue, 15 Nov 2022 09:53:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MrifsGhS8xLpzkMuvNtbNs5bqtRjVZZMidSTiLiShrh0jVFHEDNY1TqtaZRdhjaaeMwS5ZQ+48DPMSltsOzyZgg9nCdmJKExlOjfaCP6qop5vNy1geGIazfpXtGs9Al/Wsj6y1RGDnNhryzLDptt0MMb8dO1afymUUShYTzvQObsafgRIEJ2Md2Hftk5Vdj1R+3GivcLkN2MfdISNYL88CPZS14BArXtxRGCZ+SRbOac45ij0kvCQn0mILomO3muZ8xkRLZbCgblk9IAN9YjNGUhXq8yKt5dCGTWq7SqreM2ahjC6tMDnHHHthOiJJc0hJ7U+2gyC0KkE6i+asTbTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3SnbIe2Wtx2Czf5x1EnKdZNngCPChpveYTUrG46fTk=;
 b=Kr3VHsvNgmZg5GUTBwSM6tBq8FpxGTqO+AVgpvzR02EJ3xOUbYj3GwlT7vPPiNWe0jMzeKC4KA2jaY9sSmr13IxU8f485ddDC/nL2haOzv0PdFS/KyjTueQPb06j6kXe5fDF5AEURALla7VRe0bjROBGv00Klz/l8quMe2kogTnuSpHVj9J3IENPSDP1YVI7taEMytW3LEb6nsdOBaBADb7AUBoOFoljhbz+R7AGCn77hp8flUmMBF4ijwKoteF88avkIXi31+iAQpr80SxXsgc6uz+X2F+PDxMAkGIa+sKH/YcN8iU6J1MYW42IJQgcSH5RPuYAt9LBYnAiYLLC/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3SnbIe2Wtx2Czf5x1EnKdZNngCPChpveYTUrG46fTk=;
 b=o4vFZHs7UYto8xIv0kXabTQ8ElkgVtMlzBN4yooShYEWyoHGoMuNTYR/3+37N3IJAnGBaxJefLijobm3oUznsMJbfb/QfXgdjfBaoDbvUj/6XR1LkKPWAk1GjVbydJme9DgGlIlL2jjZcHNstqXtpoaGhFu795cneO1E/Jl8Dqk=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8143.eurprd04.prod.outlook.com (2603:10a6:102:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 17:53:28 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 17:53:28 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: RE: [EXT] Re: [PATCH v4 2/2] net: fec: add xdp and page pool
 statistics
Thread-Topic: [EXT] Re: [PATCH v4 2/2] net: fec: add xdp and page pool
 statistics
Thread-Index: AQHY+QsXk5KqzdTauEq0snVUKlqfZK5APU+AgAAGw6A=
Date:   Tue, 15 Nov 2022 17:53:28 +0000
Message-ID: <PAXPR04MB9185DC399BA10036C0C7930D89049@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221115155744.193789-1-shenwei.wang@nxp.com>
 <20221115155744.193789-3-shenwei.wang@nxp.com> <Y3PMRwstfJkUiYwl@lunn.ch>
In-Reply-To: <Y3PMRwstfJkUiYwl@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PAXPR04MB8143:EE_
x-ms-office365-filtering-correlation-id: 5c1fe3e7-e11e-4e98-2929-08dac7324d33
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gezs1/hL7R7amr9bMW8RF4iXD33r6Geint2SSLEa83kChgFZSFiRViOYMCR9dhwZ5MsOdX3A8sTBTSb8g2f+oZbh6uSWTv5oGhOCZIHnicpLc6+RXBbz7q2D18aNVcTtOzYrpZF1pFy65som0TUGzeP0YcpTK1E60PdIUg41v0+R4PocGit+3RigxyYMx9/C4kbN8bNtBxzh3uwHx3zm5WqsEyoxKdw3qxxkxoxPUZ9tpybz5wxZW9Fk9OqCHU+hevPgNXwlytChl8EzwanZXMgklYNgGSe2cIeqDJxYu7Ry7M7zgHLm5+k50bjS9XYezPkrK1EpvI0eFBM0IEa1DJaIchOcm5R4A/LA/NujHSqgnTH5rUn9K8TnXkl1qXQ1+SGLhp9WHuY/XW/eYq20c3wXBkF3sEJq1YzAljI9qxyPss585DQAuKHK7SaIemPKZvQF9jVKxaLchOV9QgkRLb5w0T6kT3alJC6DqvYKEeQvwz6Lszan26jfr9POsDzQtDEBDgWSDdNIB18PmdhwzpRgIN+7f2yW73zwajl0dqoFwGA9S5UsN83AULrmGIE9QJcLfJdUqg6agnA99lYdoqLHphdb07amhxMYn9eL1E0a3baSvjBZyrsKTqYUW3O2bkaVFNJl+x9uRspMDormGPDFGZAzWkft02cq8eFBEl2oNgygASomRR9CNr5zaeKIIrTjKwNKQKtG3rxeFgPUsbQFsFR0iOpHdqZjMDnTABghWqwW9LmagopC46O/QIDYvAKfGqd9yWwp4/4MmRX1+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199015)(478600001)(6916009)(54906003)(83380400001)(71200400001)(8676002)(4326008)(38070700005)(66946007)(66476007)(66556008)(76116006)(64756008)(66446008)(26005)(41300700001)(86362001)(53546011)(55236004)(38100700002)(186003)(8936002)(52536014)(5660300002)(316002)(7696005)(9686003)(6506007)(44832011)(7416002)(2906002)(33656002)(55016003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LDEr9pEAt3stpfDltY2i3N9bny5IV39/l7jmDM6dRqkVOiFc9COwkGxPX+gH?=
 =?us-ascii?Q?LDiHDyAuFPhu451IZxA+A6EhtiEh7a8i585G8tYyO1C/wJKiKn0awy8XiHWQ?=
 =?us-ascii?Q?LJTHDMQ5wpmPQ4H+8zYsWiOSbFPBeCErZDG9YiMhbDroPvF0hTqHCrc/6NCp?=
 =?us-ascii?Q?BLvBkCVZc7Y0pdmp5YK+Kw8HM45B+eu4Z5VbFOth4Bu78epzg1EBNtg8lekO?=
 =?us-ascii?Q?UQ9U5JCOilz4AlbW1MBvLVIAAglEPrGJV2LKwDtuX3VAm64SZdRxgI6bk8oM?=
 =?us-ascii?Q?EbnUnuhxjDIMt0XpP8lMgThxYk7tKjIYRydaiR4nBbRQ7Yz00B3WVdhkdzmn?=
 =?us-ascii?Q?VJv2pVwzMGX+PxacbRK2ETZMVCW/1NuRkUmE+yH7wScbhY398ds2k1sD4Pk2?=
 =?us-ascii?Q?2TG+iuZB4qYpneX8ALovZoLR9lk8U6SREy1I1PuaYXpGi/89auU1azzf4UaS?=
 =?us-ascii?Q?Wk5k+5xYZMFCJeSVXjshn2pqgrtuDk84tpfxg9iU4fSBwYLlDxk5kEaryL8U?=
 =?us-ascii?Q?WQiatu+ZZx4Y3GDWrH8tgnyikcXbvgfjZ1zIDvE7NJxwIjGy+KWyEM5L7FPO?=
 =?us-ascii?Q?0vqaxB0tA1ku0ZznXxIi+CFGjUir6Q5tTbZex6rLWNeT58E66n6Fw4YetQuE?=
 =?us-ascii?Q?keoSZt7WeYUMcznzcy+r2h9jTWtF3EJaAQVBNbr3n9e2t6o9j1RQI2sQos7q?=
 =?us-ascii?Q?bgcBhlIyWRTu83VKl+jr2GYeGUdrvH9hjVbu5Sb+J8VEV2R0hnRmpjISQI6B?=
 =?us-ascii?Q?zmXd3ulUKC9kNQwC9naytZM9h7g4rgs/sd4f84DjqVxD+AHOj9W8WoZtQzwP?=
 =?us-ascii?Q?fvEwrI+1y7Jptb2Ia23k44SGh2VRruMagBdpMUFdZokIOR5Z3D9ClSMFJPcZ?=
 =?us-ascii?Q?WDGoFqbhYFOsXVeE0bb4higGOJpix6CSmvCuCuOq+4WByRC1z8Jo/NRQwaWZ?=
 =?us-ascii?Q?ZPRyYXm45uDPMhsTsNwzaDpGGoEwZGnK/QuxVGCob3mizGZcKzvKm6Wiulo/?=
 =?us-ascii?Q?30iR472PRZWLlAsSbEcFarrm2leqw8mcW5gRQ4Mu3YbCJC36/CC+O8mKwZpp?=
 =?us-ascii?Q?XyZ5E3XW4ZofCOXHlI+VhXKErHAeaWSY9QXQqLP3+UMaGdMNqoEcPIWvahDv?=
 =?us-ascii?Q?bKtvwCbuqqmfu9zxjxxzzdLXmZ7dcjS/HrVGvwblUU3gUFgAPop8471Qj9Ig?=
 =?us-ascii?Q?IZcSqo/DEjxaLv3EFrFun49WvB3SNFz3C/VnSO3EltkRAFs+kIa/44FMO49R?=
 =?us-ascii?Q?Fx863GnoX4SOW1E+he1MN4qTPg4KrT2lFjs8Ap6EShklKTDDwNDw5VnNgV25?=
 =?us-ascii?Q?Ds20FRWNEC4gniaRG0og/HqWx28zwCZXY6TjmahmphLKg4vYaq/9WTAIYHRl?=
 =?us-ascii?Q?+6hjsNQ+v0J+dwd8slqTfiTDXiMIem+O5geUkCZgl3zTW2w+7SYfanTyDWIj?=
 =?us-ascii?Q?JPXY33xOkugedQqUIf0yXhbYQWpdrSI7iY83nqt3QWsjGR6j4jn6zEunhCIr?=
 =?us-ascii?Q?6cBgSyIZ/QsmEi9fbO3f/uJOVbCX5arc75H5yIYitt92bAzmo2XsYVGCm1Bd?=
 =?us-ascii?Q?1e7QDi3B7l83hVlkzz65CapdusnHimMRls8RV2hR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1fe3e7-e11e-4e98-2929-08dac7324d33
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 17:53:28.3212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1iyPDKLVbmMeqbEkcjrFiTXuHXrSOdpocPA0F6/o+gOxJeIjZ1Nods0SG/ZaB1wmDgtSzlY/x8tVaW+ADju6Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8143
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, November 15, 2022 11:29 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Jesper Dangaard Brouer <hawk@kernel.org>; Ilias
> Apalodimas <ilias.apalodimas@linaro.org>; Alexei Starovoitov
> <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev; kernel test robot <lkp@intel=
.com>
> Subject: [EXT] Re: [PATCH v4 2/2] net: fec: add xdp and page pool statist=
ics
>=20
> Caution: EXT Email
>=20
> > @@ -1582,6 +1586,7 @@ fec_enet_rx_queue(struct net_device *ndev, int
> budget, u16 queue_id)
> >       struct bpf_prog *xdp_prog =3D READ_ONCE(fep->xdp_prog);
> >       u32 ret, xdp_result =3D FEC_ENET_XDP_PASS;
> >       u32 data_start =3D FEC_ENET_XDP_HEADROOM;
> > +     u32 xdp_stats[XDP_STATS_TOTAL];
> >       struct xdp_buff xdp;
> >       struct page *page;
> >       u32 sub_len =3D 4;
> > @@ -1656,11 +1661,13 @@ fec_enet_rx_queue(struct net_device *ndev, int
> budget, u16 queue_id)
> >               fec_enet_update_cbd(rxq, bdp, index);
> >
> >               if (xdp_prog) {
> > +                     memset(xdp_stats, 0, sizeof(xdp_stats));
> >                       xdp_buff_clear_frags_flag(&xdp);
> >                       /* subtract 16bit shift and FCS */
> >                       xdp_prepare_buff(&xdp, page_address(page),
> >                                        data_start, pkt_len - sub_len, f=
alse);
> > -                     ret =3D fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq=
, index);
> > +                     ret =3D fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq=
,
> > +                                            xdp_stats, index);
> >                       xdp_result |=3D ret;
> >                       if (ret !=3D FEC_ENET_XDP_PASS)
> >                               goto rx_processing_done; @@ -1762,6
> > +1769,15 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16
> queue_id)
> >       if (xdp_result & FEC_ENET_XDP_REDIR)
> >               xdp_do_flush_map();
> >
> > +     if (xdp_prog) {
> > +             int i;
> > +
> > +             u64_stats_update_begin(&rxq->syncp);
> > +             for (i =3D 0; i < XDP_STATS_TOTAL; i++)
> > +                     rxq->stats[i] +=3D xdp_stats[i];
> > +             u64_stats_update_end(&rxq->syncp);
> > +     }
> > +
>=20
> This looks wrong. You are processing upto the napi budget, 64 frames, in =
a loop.
> The memset to 0 happens inside the loop, but you do the accumulation outs=
ide
> the loop?
>=20

My bad. That should be moved outside the loop.

Thanks,
Shenwei

> This patch is getting pretty big. Please break it up, at least into one p=
atch for XDP
> stats and one for page pool stats.
>=20
>     Andrew
