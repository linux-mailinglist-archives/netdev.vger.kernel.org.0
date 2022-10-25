Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0ADD60D7F0
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiJYXb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiJYXb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:31:57 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150081.outbound.protection.outlook.com [40.107.15.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9684F11150;
        Tue, 25 Oct 2022 16:31:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCHMT5Vmhl0ZuWfP3bzDwJVI71R2WALeGjlc9WiosFsQUA0fTWv6MST5OIXGjJx3QyfQScnAWZBvKpKQo+z7phzrwuFPsQnXz7fzQM7CpdOb8XiTR5F7R7gFgoasJEbJwglX0LEpUpsrAiJuu4NtUi6a9YS56LM4faoOhJO4G6yaQWC8xOibg9mKc02Pnx7ksGA/xZUplJwJ3TVjCSzftD7ExOOqr4AUkAE/1D928BTys5rAfVXix3K+7nnHcfPnX8oQuWnu2lJRiqNdWN7HDjAceQdSsFSTGApgjU3HqLyY3gz85yV2tpilqtPjNGNXrccVx3zxbDFCKYKiyLphJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4JkOl+OkTT2aRblFMhbu+isRGHmWibWJX8IlHVTxWw=;
 b=b0+m4p9MdrgHOhMqI+LiyXvyptn3lj2hGXDDcwyWwRLKg7x+s2CYS8S7B0CoyBsPewILmCT8buH74BTRtMMwv2rBoM0k6q7EZFVeUbv4f7dK3kR/EX8qH09/IAgfyWalmPc7EVtugH3AuIkyPMW79mE0dBbpWZRE6MJ3/ZEx+D0XizncM1dD4CRzhzYfUPNB9Eg0md7x27TKUGWOZBGLW4KtCbWA6l7RwHg4TXqLvij/Usap9N6pOijS5pxF5YX5NIh9SatwCYEXYw+l68SwTigyrh8ApZGmfkCvpnTXicrjiyC7tio4K8s90B2gCMuf59ACKVV500RnwlbKK3UjLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4JkOl+OkTT2aRblFMhbu+isRGHmWibWJX8IlHVTxWw=;
 b=D8RkOsumRURIHeOya4Viem3auXzgwd3fo7sxUZbm7+S6gv+TfCTnRhfbM/PDCXdAMXh/5GmJRxasV3ppU6B3Jyd8nZd7HXNEP5gVe/ci2rnVUEl3S4k+zQoUs/IbBUZSGZp+lvIzvhLVTdRjhEejyiAjC7AoKnv2CR0PhizH2jA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8749.eurprd04.prod.outlook.com (2603:10a6:102:21f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 23:31:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.023; Tue, 25 Oct 2022
 23:31:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: enetc: zeroize buffer descriptors in
 enetc_dma_alloc_bdr()
Thread-Topic: [PATCH net] net: enetc: zeroize buffer descriptors in
 enetc_dma_alloc_bdr()
Thread-Index: AQHY58z/UOKKnjnr/UCCCxbobVhRlK4fxFEA
Date:   Tue, 25 Oct 2022 23:31:53 +0000
Message-ID: <20221025233152.idxmtikicu3kmedo@skbuf>
References: <20221024172049.4187400-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221024172049.4187400-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8749:EE_
x-ms-office365-filtering-correlation-id: fdbf3a36-348a-42c8-d0be-08dab6e1193d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4F2DDxT+fWLIIVjrJ1gIei3NhoPqkq9oDoFs2p/6xTUB78VjX6Cn5kWEytsrvE8/ffENmrfXf6Ldamhqf8LvD/a68vuCx2/tg9HI03SuyYeIqEUbPzgk2bQikWm2ukDYYCvDMvYtkaxoA7tvrua19FmmxN6hzNoMeEOriitznlI/tCKPDLyHyEBUX04h6o0m7bch3sSV+6gHsO1l4GMHCTEvOdRJ7/cfBLwnp5dhJuZMqy9QVZ4Ka8feNSZNnLSuMaz22OaaQszinGAR+RALBQsejmYGWdPJzd46FGANMnF1LJFsnjqJq0IscTgq79Ce7LBvGusSyycMWEaiWHGIm6S9GVgGdaSb07AM4tnadV2LXffosN6xIEokFtQ7GvB2bh+OLiaNk6LZqF4ZsS5HsYEnThmIWcW0wG0crXglpqQ55nZq8RXuOvoa/OZOKOWwxWtTztmCL0OHIER1uLtfgjz60EdRjcaoi0Ai8ym5Gq3WYtTHeyMtCTPNxMXaiwMbRd1e1EorRPpBjUfaks9F1Cen4GBLlepuGLNEgSaLRuj6muy61o5jT5fuR3niHj7vNfFr5GOdhO+RiE3qJLqR7Dx9TPizFoN7FskcBOnLp8EKIQh4wkjUNx8BV4mummJm+5ME0ddjjsbu2ewtPSnGZP5WShqB832JfagrD8wZh7je1UhsmjXCjorKSCmmtT3KdqyaNX3POB4NchKRlGj3fYj3xUF+UBnULipW+8dDeyLx5/SueC1Wa7m+G65tmqQGwnnfpFcQgBiNj/WLqVHayw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(26005)(6486002)(8676002)(4326008)(66476007)(66446008)(9686003)(6512007)(41300700001)(64756008)(6506007)(38100700002)(478600001)(122000001)(2906002)(44832011)(4744005)(8936002)(38070700005)(86362001)(1076003)(186003)(5660300002)(66556008)(54906003)(6916009)(316002)(76116006)(33716001)(71200400001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o/hKFpJQUomytHW8gpq1Ylv2T8xqwNhj+WNquC6aDkjkk5gDX4xZCzK8Yt7D?=
 =?us-ascii?Q?DM71X+HQDyy1OG4VTVSxzdB8dChMp+5Ht9xUqqMM9/qWS/d4n3CkJuikELQ0?=
 =?us-ascii?Q?8iRxFFDEOxuIuf5vx3+ddabAg6UWj5LlHgD45w8+y6vBJa7tuH82tVcy+bNK?=
 =?us-ascii?Q?GWOqdYSwJoc+FyxmvFiAz95KaNe4dCkANdziHSlnfZh64UeuJ3BEAXFRd2X6?=
 =?us-ascii?Q?KFIcSUO8/RvEbJQSnD2OOGLZyxx0tJj1XdKnwIQyZNRU1SJMVxKDbZq4Czjg?=
 =?us-ascii?Q?hCuVSIj0YT1qBM/HxqlNoRg/yCCZ5Emegv8y9Y2Qhm4Cc1tFcIgWfvn5uUaM?=
 =?us-ascii?Q?rdG8TNgThCKnFlCgt6IrJxe0Vjei0K0AwXiLb+eKb3h2XiTE9ytB4j4idhza?=
 =?us-ascii?Q?S5+93JbYnc3HOUVgMVZUHddVtVI5bKwXwxtVUNf2OdRTRJPCIj7DGwUkG3fh?=
 =?us-ascii?Q?DeF+y2RpaY+sr9THcNXLZ20KpWTeT3lfHffi/nCG36lixmPF2OzkERGvshuv?=
 =?us-ascii?Q?SqMHHi5UopEP1jC3lCsE09eGkuHvOkFHuknqV6GR9zjsUUmez2GB1jH6pA7g?=
 =?us-ascii?Q?pwFtDzj7WCmRiDkg9shozzYygkeDHpj0V9rYZ4NiUlNM4DPsKnPeQyGNv7SB?=
 =?us-ascii?Q?X7Adq0QbJu1VFujhhVMikgR9z9Lwml/xyO4TftZOeO8U4+Xi76UCd1oS8dyY?=
 =?us-ascii?Q?l9nEKkuddPwIPVeUsffoUf18fXSlAiE1qrJNfBA+SfH+vbrQH1iidlX9+iDF?=
 =?us-ascii?Q?KGX0+SLspo/DYr4Ywv5hpea4SH0u0Tt+KxzyniEiRRNJBKBAGJX9AuflCB+m?=
 =?us-ascii?Q?s4nOaezUAXetJueWb/kVvbppAFOK237nNpxOgxgk9/n4E7zKK5SGx1QzWMho?=
 =?us-ascii?Q?hCkw64mwf4qCyRv0RSNOR3Z5/4TahU4G3Ng7LotxhQi/nRdhfqXbW3gAzlW7?=
 =?us-ascii?Q?Gkc8NJUenI7oA/0XX0cjjsl5Qdb9CYsWSlQzkHzS7y+EFAVBpuBF8c4O9+8e?=
 =?us-ascii?Q?Ys3/QNIPAdxzFCudx1NYW+t8NNIjQDcHNj41kuCqQ9S9CK1JTo80/iS8nSH0?=
 =?us-ascii?Q?mCIV4s5E8YlOmV0GeTkclKE5uEKIlltFJ2NOEXPG7bR97jTa6CYeeNS6vo5K?=
 =?us-ascii?Q?ZtalxhVpV8Nv8agdHYwgkr887kQ2Rsw6cj+4DWaDFLQkkLYm5N1XzkiLxt/9?=
 =?us-ascii?Q?zhf+DPUjkSLDQEp6kRFVErfbJuvFK3VSVxEu8TDCFt48c+SRT7mlHKB52xlU?=
 =?us-ascii?Q?55aUUCYrEaFoUGYQBIVd4bFRJTHfQGZW7jAXF3Z0UC/u2pJrUXUbSxHa5ZLJ?=
 =?us-ascii?Q?rFZNds6g3mnzbUEJ1nWFp7FSiyu73xVdR/eXw9p58GX2wHjOq33V78wr0R7q?=
 =?us-ascii?Q?jZLHqQGMQV8S557WiRVjYNP4OLH/XM659knknTgv+yhoWnwhQtTXxTePWTu1?=
 =?us-ascii?Q?9QDSVypx9qhwV2V8Sx3MjerhtpUqaEAnqAQHEybe4soEE1fLkVH80vEHIN0L?=
 =?us-ascii?Q?Oj1QXR9uFGekLqeV35HAFKqyJETsXHHwubKag0gDNhFjZJOSXK9+a7Wm9isp?=
 =?us-ascii?Q?R18moRk30h6ythPVbGw6A5wZ0vEPhKjqIajyEjt+QM3wDMnjBU15c3wXMF2b?=
 =?us-ascii?Q?cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCECCFA63B101548B9AA41D62F44DF8F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbf3a36-348a-42c8-d0be-08dab6e1193d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:31:53.3256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9EtN6FFMc1pUV14ZMV8qQQjwWSSr4Dlg6kUf2+yKBKQsAkSgDzixfhId3Md5lvQ9vFwTzEIoH//9rCL7kZTQEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8749
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 08:20:49PM +0300, Vladimir Oltean wrote:
> Under memory pressure, enetc_refill_rx_ring() may fail, and when called
> during the enetc_open() -> enetc_setup_rxbdr() procedure, this is not
> checked for.

Please don't apply this yet, I'm still investigating a crash which has
the symptoms described here, and I'm not sure why the patch didn't fix it.=
