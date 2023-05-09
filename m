Return-Path: <netdev+bounces-1009-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A4D6FBD09
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24DA1281100
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A561395;
	Tue,  9 May 2023 02:19:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26388394
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:19:16 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2040.outbound.protection.outlook.com [40.107.22.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B4DCD;
	Mon,  8 May 2023 19:19:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTQgVBPrNS6ddygEqSkXfDyJw+EnBK0ZGA6kvewGyWr4mjiEH1UDUoEcYpXAXOGv30MY2HPK31/TVP1DmlA3jlCN9Arb6qCCK9wcsNTl7yjnsR36FpgjCVzB+IiZqVpzTzJuE/IDWBZKlPjcmxGSom4uUc1ioch0b7HGHz/kPS3mNZtI4k3rWYlBI/QfTx8485GeXvb/dGRUXjiZadBtQr9oOkRDKb3VwbUS7obtBlQ+qSUOnwdwfSyWPMHmYoNC4IGf73niDiFASmuRdyUrqIT2i2T6pLcTSzQWGoJKPRiKM6Gq3ZqcFVjgYArxOXicIFAqyuYE7A0I6Lwdbf9A5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74Mm29NpkmF8dCfdLYIx4ZS4Ew8hGAIvKtKHeAvQJC4=;
 b=VAbuCJ8JJDctrWXgLr8+cxPuvH0d2jPdnAgXYa+haHwscuf5v8UEfu8uC2Z2W/CkaPNGGHgbCIcpK09NYXMDXo95FTh4RGZdoZYrNSQQhp/9vVnghba+J4unk+Uv4k+YqyAiHfeW6TfLlCdwdLo601yE7s8ZnH73md9ePcmk7BP0P7gM4MKyDciaVMPcXtkmRyZj3Vk2PpLFbA4Gz3No+vXe1vqwK7+GMDScXatkXz4jlU97B8EiCnciQIfjIotdkvo71wE0fGmvBa+rfE/0kb3w11Q1iuXLnRj+pT0E8DHu8o5g/D/aoOgNlvZC1zFAAiDk1wM94cNgsPUHYKU9MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74Mm29NpkmF8dCfdLYIx4ZS4Ew8hGAIvKtKHeAvQJC4=;
 b=GuWeRqHgqCnbUKpTGSrjaRb2J0RPpsv1ZoTofLexalov0G2pUwMlGvZuC+yOnHrbDJZcm5dbGxwbmZpFIhukFSUlqNBX5l+0upHcWG8An/aD+39vBFi9kGUXtv4S/j+8tWSI0u5jMHTUjoAKGbaEtuD3S6LRiKUSW5gP1zDcerc=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8702.eurprd04.prod.outlook.com (2603:10a6:102:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 02:19:10 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 02:19:10 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Clark Wang
	<xiaoning.wang@nxp.com>, dl-linux-imx <linux-imx@nxp.com>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard
 Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>,
	Gagandeep Singh <G.Singh@nxp.com>
Subject: RE: [EXT] Re: [RESEND PATCH v4 net 1/1] net: fec: correct the
 counting of XDP sent frames
Thread-Topic: [EXT] Re: [RESEND PATCH v4 net 1/1] net: fec: correct the
 counting of XDP sent frames
Thread-Index: AQHZgbrN16SLkw4tAE65/IBK8uQZyK9RLJYAgAAIr9A=
Date: Tue, 9 May 2023 02:19:10 +0000
Message-ID:
 <PAXPR04MB918576423F921E8F826DA7E989769@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230508143831.980668-1-shenwei.wang@nxp.com>
 <20230508184608.43376a10@kernel.org>
In-Reply-To: <20230508184608.43376a10@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PAXPR04MB8702:EE_
x-ms-office365-filtering-correlation-id: 8d5615c5-e143-4967-f7bb-08db5033c62b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KUvjmf6WeokZ/jWBypUsTqEWRSzerpUfJxdDnSnskpag5zPyqqtoK6jwHDteh7GJTduSuGXO2aL4O/xWqzlQ0PbqPVy9txxKKFuIELpVukoTIxGyukgoONA8bP079o/MxXPBD3dJRDFxtZqp2ykwSnXSLhAm3BDzUj+IeRa4W2xGcwHHtVIo8NvQga5UBAUceALcuTsGJvf1pbdQtFeI7GlR4XhS30Z9IikPNR6ZwRRWc26kjTptLiZwBU8KDESs4y/CK+evw7Ud5K9bwlJh96td+prFfNIR4BHMzIR0m9dhUoO6qqAKL/yTZCtUZvF1KMvaGpVsvCFEc4nOdXc6ZVV6getfyRXXZddS+QB+b9bugLx2ZoQTDXHs/TkRmf9om1+8RY3R12+61FMKNbefSdH7/6/DvB2sSePOyQO8dH6X+9kaAYkW0yGZkmXvDULIbG4T1MQmEYSgfEO1dA6QAOgJUbp4PP5US7gHKRXwn363a5jZ20wunWkEmqAnYa2Dp8lHxwNxVXKjhpN/Y6yVnB6qJIoT8LPIieMJJjmu4KLbYd2jL1wXD2y4eDU5MEGmIIaZeTS8+IQApiJhSFOz0tlhZrd7rxhZRO7C1wQqqmE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199021)(2906002)(186003)(26005)(6506007)(9686003)(55236004)(53546011)(33656002)(38100700002)(55016003)(83380400001)(122000001)(316002)(41300700001)(6916009)(66556008)(4326008)(66946007)(64756008)(76116006)(71200400001)(66446008)(7696005)(66476007)(8676002)(38070700005)(966005)(54906003)(86362001)(52536014)(45080400002)(478600001)(7416002)(44832011)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?8/wDmWzmUZCNMSzPMth7d/mI/NCtzHcTCeRa3KIrCOfaRP6i9ulJbedBT7R9?=
 =?us-ascii?Q?8dcPptMse5OgrRQrTD2QupR+/8MvUOgPMVa9Z8o94YKADidPv2OJV+gvwV4v?=
 =?us-ascii?Q?7tvGLr3r+iMzvMAs18zCNiKqKM+fpNLUNxi/UB/ki6xDnEsQqVRrJ+mTzYgI?=
 =?us-ascii?Q?ZzGtI23RiNcOQ1PsaS3uTt9/20H8qXMewz3QmiRu4UPNInjQiHnPSs7dONjT?=
 =?us-ascii?Q?VjSEqeN7kMP/4EncGbXpO/gi/nORQXH/vvPS762mghHRHaux4GTLy2ZC5+Z6?=
 =?us-ascii?Q?/60kwRobT3ds6l3DEbcsBWBudDaSdmOI8p/zNNQ0C3rc8fPDDVeHxafW6R+U?=
 =?us-ascii?Q?fVz1iifpDTAXxKWd+41QC0oIssEskLSJq7h6QxnPDozGZPM7Sl0gZHcVCIPW?=
 =?us-ascii?Q?ERlIcKSbUTLDXBLp7RHP3Fb0ryG9www3SPNum3HgRDLa4ERoUtl2fRtDbv1B?=
 =?us-ascii?Q?PZCcavewsDb0znGcIytFL+jkArTTQ7KQ+gwInoanKnCd6HEP75WxWRO1w7C9?=
 =?us-ascii?Q?2nWvdwTKJUJ/7vnik/0mMk5akE8QN8Hx1Va6E+XK2PErwR2uoYbmwDeFUI9B?=
 =?us-ascii?Q?LUzLvHPSDWVfqR1850ivBx5p54PZRtJR6RUO/Rrb04NmZjqH2wa6+Pi8924j?=
 =?us-ascii?Q?LcgnezNSAGJLBqYtZRqeyNhe3XKRc5HuDPiarOEmpVvsG3BBrsU9fE8F03Eu?=
 =?us-ascii?Q?HKHPdbSJbHQ90sbEcTwGVUE4KqxLv6eultBtfzcSeZ4VQhTg3u08ljhhX2Ip?=
 =?us-ascii?Q?IysPJqfvntE00tDbw/laKVdSVjTjmapTwnl2bH4jRZV3ilBb0QlIv2W+D/as?=
 =?us-ascii?Q?gVg1F+6WWVS0GfdDhVw9TrXcNvwaOMYdR+UyoVBLc4uTwl1skS6kIIBEcOFa?=
 =?us-ascii?Q?+xpRsLQz0U6kRuoWRClcUAhSu5Ss4VzSTwqeRxGbpvsMIRFhU6Eg5Bg6JIo1?=
 =?us-ascii?Q?FHJtasxB7sWiOh87wKXYKHM6srW+BibLzZ05kuu45hb6KV04vPFIZdsaWJDX?=
 =?us-ascii?Q?t90X5L/NZXHpkxFt/hEXdOGtiE+bpWo8q8+OWmfQXuPyMt1Xm/SMwWJD7zIF?=
 =?us-ascii?Q?Unqkq0NNRs72T1dy/S0jQp1lUqTQUkBjmxDsHRHlw3ByR5Kw9IuSCAdgjj2r?=
 =?us-ascii?Q?/baF1nYJQmVD7zjLXG0Z4gB7gIT7STUWKEw2gDCFvSni9hgK+LCQX07iB7tm?=
 =?us-ascii?Q?m0exAPtukjE6/WsaIiu2pFFGOK06JocD9FGvgfLZpHWKf/WhISDPrLjW+T7Q?=
 =?us-ascii?Q?W0pdrztUGOO5GtUdJDumm1JlpILzSlT6YaonOnwQPoAol6FTPOGja5vrGHgO?=
 =?us-ascii?Q?3vNW0IQEh1TA+QCBs/q96wyuQysOYWQH/l3xIsCmV4igdd4DfriKfGG2DXxx?=
 =?us-ascii?Q?lhJRD4YhoS8kxdfNXAqkMNAJP9fKVCK40EkgayrhZeTz+quSHwUUkl1kvQpF?=
 =?us-ascii?Q?2HX4BX/MFBqEZ++QzhRMbY1zDFAorqtB7sHV0unyVb+tnfiUHoreA6cSBjPh?=
 =?us-ascii?Q?2WNxEUCFetqM1wj6Dz71Vkm+8zQvTs1BTKt3OmalOoEoX91xZ0s8eRvBXuxr?=
 =?us-ascii?Q?+gxD55paGH42rMlkbCUkzJfgoNdlumYCGjTDTOWi?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5615c5-e143-4967-f7bb-08db5033c62b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 02:19:10.0852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aWRFgL124ZhdLk1iofMNPxS/rEjtQMM38dslm9+HNGw+asQ/IVn4xLh9fXHI5ioEEh6SnO7BDgsVy3cLIaIGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8702
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, May 8, 2023 8:46 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Wei Fang <wei.fang@nxp.com>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>;
> Clark Wang <xiaoning.wang@nxp.com>; dl-linux-imx <linux-imx@nxp.com>;
> Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.ne=
t>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; Alexander Lobakin
> <alexandr.lobakin@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev; Gagandeep Singh
> <G.Singh@nxp.com>
> Subject: [EXT] Re: [RESEND PATCH v4 net 1/1] net: fec: correct the counti=
ng of
> XDP sent frames
>
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>
>
> On Mon,  8 May 2023 09:38:31 -0500 Shenwei Wang wrote:
> > In the current xdp_xmit implementation, if any single frame fails to
> > transmit due to insufficient buffer descriptors, the function
> > nevertheless reports success in sending all frames. This results in
> > erroneously indicating that frames were transmitted when in fact they w=
ere
> dropped.
> >
> > This patch fixes the issue by ensureing the return value properly
> > indicates the actual number of frames successfully transmitted, rather
> > than potentially reporting success for all frames when some could not t=
ransmit.
> >
> > Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
> > Signed-off-by: Gagandeep Singh <g.singh@nxp.com>
> > Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
>
> Unfortunately the previous version was silently applied, it seems:
>
> https://git.kernel/
> .org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fnetdev%2Fnet.git%2Fcommit
> %2F%3Fid%3D26312c685ae0bca61e06ac75ee158b1e69546415&data=3D05%7C01
> %7Cshenwei.wang%40nxp.com%7C50d9af4da79646cf2d2b08db502f2b7d%7C6
> 86ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638191935747226987%7C
> Unknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6I
> k1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3DO2uy5iy4QJa9v8TN9t
> qM7jqIgVhBY7pMxl4K58abj9s%3D&reserved=3D0
>
> Could you send an incremental fix, on top of that patch?

Certainly, I will.

Thanks,
Shenwei

> --
> pw-bot: cr

