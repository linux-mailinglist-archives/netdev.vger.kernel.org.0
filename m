Return-Path: <netdev+bounces-1820-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C486FF373
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5301C1C20F39
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B72719E6F;
	Thu, 11 May 2023 13:55:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB24819E6A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:55:02 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2049.outbound.protection.outlook.com [40.107.7.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F3330C2;
	Thu, 11 May 2023 06:55:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFsT6neM4M2QX8cESGQuk4JSLUpf0OQOrWDdgs7xs+IAQrcTL+eBSBZHzonpD9pvFjXP14Z+DKWp7fxTZlFmpAPWPk+bDfS8YfxyPgT8/NDXbhtKTricEGNFvyj5L7UvcU0yJ/3c9rS3gaiiRpsKofBqEX5tqd0h8Xq7arnZV/BCxlzQx3QJWoGUGcXuYu++E/pplTAujiA1YRKVpkU3IRY8TqWjsY50JIJ6yLrgJ2aG5mHBdj77cq023vIqWmLq6VjBCcBLXTYUoS24GYR13Qlhh7oRtRl5fyK5JFzawgbOl+d4tIFWJ/hY7ei9oVxdsLko/QRM2RpMJbtnUoOMOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEh6hYasODyrgeqklx3HNg/pIsQ+qf7/IomLuKJzSF0=;
 b=hxA14qJp5XtpQzyIXnwSBKV59jd/+97cdTYQM3XLrPcDZy3lg+m6MK7exM/QNtrDnaM2KCt5lWXUUz8zEcUTQywUlVpaZLEl0Zo+5E8b/6Rcl0TUpkZDg1SlCbLAWMgQI4Rflvu//3nvUGrJJuyGb+314AuDzxOg830C7G2frBIcECkVMNDSQ69O2xmc0aubQAU28/lyw3li151vYiytLaTPX7IR2s2/mqRZX0AJNV9FdXf/tzlIuah2JF5Vr99QHUMB0TdvGb0zU5eW/chsX6ZNA2eTXhfOxvtiposW+YNGxspptkyn0fJ8WGPcSwM87sptHBXe4amnne5kIPy23A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEh6hYasODyrgeqklx3HNg/pIsQ+qf7/IomLuKJzSF0=;
 b=VM9NeK/9AP14NrVnfOLHH950lBwRGZJ0FSV8+ubxaZ/7eM4YSUZ7Ebr4rrGR5DXDQh+OEsMgYa14x/QRkum5lpb6NOwGCWaIfmaadUWnfXSqFeGaFw2npqHyhOAqqcAgUFCnONh7nkbfab7Irl1YxNPTLheVvUn0MkLFlWVqjx4=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB9PR04MB8137.eurprd04.prod.outlook.com (2603:10a6:10:244::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 13:54:57 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 13:54:57 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
CC: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Clark Wang <xiaoning.wang@nxp.com>, dl-linux-imx
	<linux-imx@nxp.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Alexander Lobakin
	<alexandr.lobakin@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 net 1/1] net: fec: using the standard return
 codes when xdp xmit errors
Thread-Topic: [EXT] Re: [PATCH v2 net 1/1] net: fec: using the standard return
 codes when xdp xmit errors
Thread-Index: AQHZg3rJKrtAA7Kf+0qgpTXACE0A/K9UrGQAgABqq+A=
Date: Thu, 11 May 2023 13:54:57 +0000
Message-ID:
 <PAXPR04MB918534FB41385DC5353431E289749@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230510200523.1352951-1-shenwei.wang@nxp.com>
 <20230511072452.umskoyoscsxgmcoo@soft-dev3-1>
In-Reply-To: <20230511072452.umskoyoscsxgmcoo@soft-dev3-1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|DB9PR04MB8137:EE_
x-ms-office365-filtering-correlation-id: eb8723ff-15b1-4d73-7ce9-08db52274e38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 vbuCxmRuLNG73reOpTD8a0dD3zwoC1yiOCtv8v8bIlgILp+2HlBpinGJHabfz/v7Z82Gwt+hUicMnT37CsLPB7UsJc0GJiHAT9skvETzrblgWWAOC/y7z4IwXxNt6DqEf8EQ1nSO/jHHJcpjngJ3QNtog0eQj1RhCIAdUodqiLCioRmzPnrYJLIkfyTYQoKLTB5XsIU6rZiTzTovvikImog9zt5wzsHtpKRibg9w7tTZw3HRd8+s9j7hIa3Wks7d0UbL6P3nPSXU1NvRm6SouS1JK6FhOxJw79b33hyrAugbXyqvETgsX7HNA0mQd8dPjiJcbZ7t0T0vkuzU6t6arS9Ib3lIVe4V3ztUIYoO0KGGhPxBoF7tnkPIorCcY3hZUsoMvMwykQ80okhw/fuopox3AnqoPqKMqcga9F1/PYpEPcLo+OBH9g7tOzsd/CEYh5H+NcLhuMWFjJ0WdH0O0hIz3a+ktemQ23rNvArDRUbsLI+x743RTTsixWYfWt4r3uzvrgeqLkLs6s4/K/29C5cFH8WBcXwsTtNscJkT6RdV9Lluc5NarWSJACAC/b8RDlJexq4jmdOD6Bx8u1skjrbkTZi1MZLjO+ODAEpz3ZU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199021)(54906003)(316002)(6916009)(45080400002)(478600001)(7416002)(7696005)(966005)(86362001)(64756008)(4326008)(66946007)(76116006)(66476007)(66556008)(66446008)(83380400001)(8676002)(41300700001)(122000001)(33656002)(8936002)(38100700002)(38070700005)(44832011)(52536014)(55016003)(71200400001)(26005)(55236004)(186003)(2906002)(9686003)(6506007)(5660300002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?X7vCkmM1JGhtu6RUMQgMfDnx7wWygTwcuOG24yf2s57YTowKdzM2QCSqpRgW?=
 =?us-ascii?Q?CqZ4KhpfAWgNky3ZeZVehlTiMp0oQFe9KVlHxRz9y63XNX57hFSg34K6rva+?=
 =?us-ascii?Q?LRiyeFdgf3c8QbRr61zujqme4U98cLEHiAw/KKQrZ6t3UXe7KKoKe/5nvehS?=
 =?us-ascii?Q?kV5udpCfm0LhXmc6LfuxdTLFGZJVYccQOXjoiUO1qoxr42uJgvCqvx3T9GTS?=
 =?us-ascii?Q?fzPZKR+MWjHEYuPpuNYtb58Ab+lFbAU3DXVuSNcZXqny2v1OKFMq8/A4TkmD?=
 =?us-ascii?Q?Zs/WblqHb7+jGIQKyziOJ6RHY9zOQf0liBBJVEyvIrmKjSEY8fyvGLUwdDX/?=
 =?us-ascii?Q?HXAKuuJVIY7ROjNbfc+LPYPkvsfOISHz9vKOiHZ4/KQDnvURqjWsAcrapeOo?=
 =?us-ascii?Q?Vq3cRdmi1DZMmWMGvuPhirQ44KL261Ces2zitY9zcN0NNiVHq+ZbgOQ/6yqt?=
 =?us-ascii?Q?/kp0iydy2VwzKl16VBR2abkweksxI5p7vBjQCaRpdxqkOoBiGtdEJDWOT6p2?=
 =?us-ascii?Q?X+AyTqOjYy6MaG/sVz8Wzr8+ym0fgcB1njA2NELBdmPrKN2n0ZtIqIDu5MhG?=
 =?us-ascii?Q?QpIM5+A3/XR0BoLFSTRuAvM+lCp4iuMXVjZxfFjJy0+5o8eEFZmkV9QWsA5H?=
 =?us-ascii?Q?C5rglxHgxgYYImdvh2rIO8wejBx9JR4iGQmPWzsmKC//uL/elLpp7dEVUHaq?=
 =?us-ascii?Q?pCfonYjOcJWYqwdiyVzyEEceS7jblWsdZd1G9FRDdUoW0fUDUlsyiOOaEuGn?=
 =?us-ascii?Q?HI6OunSuRBtKx/lg6T5bP9LZabngG2r2HC7XhirZpyZQcHo8CemHInuVMfDe?=
 =?us-ascii?Q?nKL1qC4sX723/2HiRSvE01yMBSnxa1zwx9eOpV/71O19itqrHSspeMvfiXm6?=
 =?us-ascii?Q?KPYP4h2J7nV8K/tqrAoAuGJ+q5xwkqsc85/RMDaZFiIlfMxGe/w8vX7zq0Oe?=
 =?us-ascii?Q?djL5gw6xrg/N6ij+QlJ0X2vM4vbxtKH6qHL14ubrIjvKqVCI8i94wAy/fNlm?=
 =?us-ascii?Q?7KpWbPF0hmkr8sFshbRozkdvTgMAOvDmBM2/7W+BG5/Ql6fADzxwTyDohSyN?=
 =?us-ascii?Q?mD8G62oiS2WhfnhTRok7kKv3WmJi7my7UU5VGk1i1z5BPt5KDDfXJSA0ZGXi?=
 =?us-ascii?Q?DcocaJG3XlymYOzlT5DD1k5GoI5pcF0p8iUXJgoh5ynpHHY+l30ZPuaqS7Cs?=
 =?us-ascii?Q?mZ+issXwX05f1z6vRCqoSoIOm4tws8Lvwmlg4ww4SWCXqyZTujq6S8RiBJ2B?=
 =?us-ascii?Q?hbmFQhrWUUo5LdOFR+2TDlZ8SdTAi7JS1t9hiM4C8XsG7VgwWQAYJiCkhvM1?=
 =?us-ascii?Q?yJz6Q14Z8Bx3735hQWqOH66rDZYM5MpT3PaqZNOrFcIQLvAdAkSFLbNtrsoj?=
 =?us-ascii?Q?PWJrSbXe7BLuMgJeCYqcDtezaxq8B55UPQ7jBrJEyOdImJGMTEc/uPwhALlC?=
 =?us-ascii?Q?dhsSUvtAWGX+EsOQSfRfOsCGudvJqtM7FBypVXeDQS1talUr8h0kD/kiBdLD?=
 =?us-ascii?Q?PpyKENewdK5Lvr0JKdCNRM5QNj1fkde8VTmnrOndLTi4w0A2rRzGA6TOUL3/?=
 =?us-ascii?Q?FCtes4djLWu9X0hh50B7wAXJw6Pld69VkbC08L0P?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8723ff-15b1-4d73-7ce9-08db52274e38
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 13:54:57.2566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W7XmZEKsgNgWu9OkypdL85cQv2ZcPEsaOTGLNPfO5r1QZGG8PSN97FLAeZ1oCfG15UhzcK5i8dMz3675ZGOAAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8137
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Sent: Thursday, May 11, 2023 2:25 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Wei Fang <wei.fang@nxp.com>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Clark Wang <xiaoning.wang@nxp.com>; dl-
> linux-imx <linux-imx@nxp.com>; Alexei Starovoitov <ast@kernel.org>; Danie=
l
> Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer
> <hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>; Alexander
> Lobakin <alexandr.lobakin@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v2 net 1/1] net: fec: using the standard return=
 codes
> when xdp xmit errors
>
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>
>
> The 05/10/2023 15:05, Shenwei Wang wrote:
> >
> > This patch standardizes the inconsistent return values for
> > unsuccessful XDP transmits by using standardized error codes (-EBUSY or=
 -
> ENOMEM).
>
> Shouldn't this patch target net-next instead of net? As Simon suggested h=
ere [1],
> or maybe is just me who misunderstood that part.

-               xdp_return_frame(frame);
-               return NETDEV_TX_BUSY;
+               return -EBUSY;
As the "xdp_return_frame(frame)" should not be called when error branch, th=
e patch
fix it too.

> Also it is nice to CC people who comment at your previous patches in all =
the next
> versions.
>
> Just a small thing, if there is only 1 patch in the series, you don't nee=
d to add 1/1
> in the subject.
>

The patch was generated by using "git format-patch -n1". The strange thing =
is that
it appends "1/1" on some machines but not on others. The output seems incon=
sistent.
However, using "git format-patch -N1" can fix this.

Thanks,
Shenwei

> [1]
> https://lore.kern/
> el.org%2Fnetdev%2F20230509193845.1090040-1-
> shenwei.wang%40nxp.com%2FT%2F%23m4b6b21c75512391496294fc78db2fbd
> f687f1381&data=3D05%7C01%7Cshenwei.wang%40nxp.com%7Ca92a1dbe84f348
> 42e79e08db51f0d24f%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C
> 638193866998878533%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMD
> AiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&s
> data=3DMO7RbDtCUU82clB2CyltzpvEdc7%2FjwLWvcCzgGN8mDc%3D&reserved=3D0
>
> >
> > Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent
> > frames")
> > Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> > ---
> >  v2:
> >   - focusing on code clean up per Simon's feedback.
> >
> >  drivers/net/ethernet/freescale/fec_main.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
> > index 42ec6ca3bf03..6a021fe24dfe 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -3798,8 +3798,7 @@ static int fec_enet_txq_xmit_frame(struct
> fec_enet_private *fep,
> >         entries_free =3D fec_enet_get_free_txdesc_num(txq);
> >         if (entries_free < MAX_SKB_FRAGS + 1) {
> >                 netdev_err(fep->netdev, "NOT enough BD for SG!\n");
> > -               xdp_return_frame(frame);
> > -               return NETDEV_TX_BUSY;
> > +               return -EBUSY;
> >         }
> >
> >         /* Fill in a Tx ring entry */
> > @@ -3813,7 +3812,7 @@ static int fec_enet_txq_xmit_frame(struct
> fec_enet_private *fep,
> >         dma_addr =3D dma_map_single(&fep->pdev->dev, frame->data,
> >                                   frame->len, DMA_TO_DEVICE);
> >         if (dma_mapping_error(&fep->pdev->dev, dma_addr))
> > -               return FEC_ENET_XDP_CONSUMED;
> > +               return -ENOMEM;
> >
> >         status |=3D (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
> >         if (fep->bufdesc_ex)
> > @@ -3869,7 +3868,7 @@ static int fec_enet_xdp_xmit(struct net_device *d=
ev,
> >         __netif_tx_lock(nq, cpu);
> >
> >         for (i =3D 0; i < num_frames; i++) {
> > -               if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) !=3D 0=
)
> > +               if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) < 0)
> >                         break;
> >                 sent_frames++;
> >         }
> > --
> > 2.34.1
> >
> >
>
> --
> /Horatiu

