Return-Path: <netdev+bounces-213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A12D56F5F0B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 21:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B05CD281736
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8344DF6D;
	Wed,  3 May 2023 19:20:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA74BDF6B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 19:20:20 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97D41BE2;
	Wed,  3 May 2023 12:20:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+7eM60Y4iKopeHgeL3cPGScCU63WOc/Gs33Ksk8ChBlWmZh4fc3VcGvCVveuCjH3NtnPCglL9pJeBt/o19QW2dvNaLgMAurxivf7eIfXlFnSufNNDSm5Vc5RDltIUM4I0hR8JsHl3L5fpyHQreko+/fiNObbSRVnT5N0g8+0xQ9SN79d6xiFaFFpGq/P77XknHzmtfjkllo4JayRpupyoEIKOO/PJtSiOiQXqjg2b6/a8qUXa0UbrrULgxRnUMdBC4dvNVQwa5jDRsQRA+LjJc3UGhcTygFvKm4E1Oo84mbhHlSOHT4gYpvnIQLP2H9KfznO8noSU0Kq/nghAcKlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ig9BU6210unzb+6QsVN2NqOgMP+P2Dd5biYhIpQyVE4=;
 b=Qq/UVufsuxNmu5IYlcyyUCrflN1OK84cX4stN7VIUJgWQKLAxYLmUwoWeKd1Ji9fDa35zCG+UktN/vpR0QbHUmcq1UzpvvjN0XE3yFykOKWQ5PZa4RL+J+28LaYQUNX/n9V3h1l5usiruU/fw6XM+WITBwe+qoGmj/skUjmC12rub0GkSbprT5lk+ZJbIa1rXoa4GaiQTaHlkVrlQkzmSVnmcXebzymRQQR/+MdhBhnJhVhZDF9whG+8oFzG8P40ZbBBcaXmZCVSZJ+N23N3+IYFN3P/7LSKKANEoX/oX0EZG/OXDTKKgIOmY1gU1CPkxJ20XTRrNaXmsEBomPNdzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ig9BU6210unzb+6QsVN2NqOgMP+P2Dd5biYhIpQyVE4=;
 b=X5P0V7UB8mD1fZIzTXHhMhud1YgUh4LZ/MC236qf/a8pLOJS5dbH3fz8LQ4QWhekRrTbHJt/VUTD9+7VqbBqfyXmn6sSsqJ0ybJQQGapORCt5+OWhgdUKKX85HR5wd/jcz4bMfo/2LlKwA5EhpYASpwgVLhfWZPgIt3of0t9n80=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS4PR04MB9484.eurprd04.prod.outlook.com (2603:10a6:20b:4ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.21; Wed, 3 May
 2023 19:20:15 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 19:20:15 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Simon Horman <horms@kernel.org>
CC: Andrew Lunn <andrew@lunn.ch>, Wei Fang <wei.fang@nxp.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Clark Wang
	<xiaoning.wang@nxp.com>, dl-linux-imx <linux-imx@nxp.com>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard
 Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the
 functions to avoid forward declarations
Thread-Topic: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the
 functions to avoid forward declarations
Thread-Index:
 AQHZfUKo4ZwVUtEG3EOjLFQNjL7Wpa9HnlQAgADiOCCAAC5aAIAAM7twgAAHzwCAAAKzUA==
Date: Wed, 3 May 2023 19:20:15 +0000
Message-ID:
 <PAXPR04MB9185FA526B63311C3899BD9C896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230502220818.691444-1-shenwei.wang@nxp.com>
 <20230502220818.691444-2-shenwei.wang@nxp.com>
 <6dff0a5b-c74b-4516-8461-26fcd5d615f3@lunn.ch>
 <PAXPR04MB9185BD38BA486104EE5B7213896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ZFJ+9Ij+jOJO1+wu@kernel.org>
 <PAXPR04MB918564D93054CEDF255DA251896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ZFKw5seP5WclDCG2@kernel.org>
In-Reply-To: <ZFKw5seP5WclDCG2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS4PR04MB9484:EE_
x-ms-office365-filtering-correlation-id: 23129748-2dc1-4c01-110d-08db4c0b6cc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 lf0FAbxTMIsFsXzIBgipwSFbNseWA/gIlwZQDdWm4irCKuMQN1kiWrLYoGcfQNqp5KcWIyVEXZp3+WqGZ9SFJvCpson/+qXNZxN9eSHwF084IDCpNEk3nLaoTTMbm0/4iNVOW8U/my1/TBemJC0K/ZtqVnecPjzUz6ul7P7VL0X52IivrPVOdotdsFS3al9geHH+ca/NNasPff0sueiGWMF1+UCqyfVhUo0p7x9I01N9pZfJ0KpmLuUoJnxr4sKEdmNZcFB3DcCseORpZMe25DRFzzUcTlIgmqZovr0C+3Nbdv/3xc6Qqa9ym5IQ5Jd53BjEIZQarjXbhZFNsFxjPH/ILMmqim0KHMVHejoub429m1K4D1OtQ7K5v4oo+iCl/asIwvtYnEeC5/1lN+VYMXhxJ4N/mPtmJ/efsrc3L89Gk8izBQMVxSOTgzsMtfQlDUGdgSTFDay9Jl0u6yYE5VdCB0vF4SuI/qepkfbpai+NTUpeBhX6LylHFIjvwD2WSBGoVlwGp+GK0hogI0NSFfjKzlaGx35b5ow9qBqmhMx8BsaF29eDJ91+G+ujjluN
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199021)(45080400002)(54906003)(478600001)(53546011)(26005)(186003)(55236004)(9686003)(6506007)(71200400001)(7696005)(966005)(4326008)(6916009)(66446008)(41300700001)(66476007)(66946007)(64756008)(66556008)(76116006)(316002)(83380400001)(8676002)(5660300002)(52536014)(7416002)(44832011)(122000001)(2906002)(38100700002)(8936002)(38070700005)(55016003)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9HfNk0/XRn4W2EaIrf8jnJ3kmHrYZQlSM5mDyDDVB/KyJolZhIYTblI4HsTm?=
 =?us-ascii?Q?52H2Jwp+t5GaYKTB1137ENVGFcUg2+t1lw+cSRVjsyGuUnTf0TwcY8dKN8hF?=
 =?us-ascii?Q?z+e5zKg00G+dLZdpIDEJJRVQYj9e6XbGUxr/Y0gehFh4AZTYYFM1i9yW5SRw?=
 =?us-ascii?Q?xuKzzO4A2KPdEMsyQnjX4lhMdduEQJM7m1VJ0bmkFlfpH8JC3EA4rkKLAKxe?=
 =?us-ascii?Q?xe4QNUgNiLT614J9UpLDJ89gYzJYPpgBizgYGBqzV1t7MScsqXoZK8LvXKrU?=
 =?us-ascii?Q?uAvi4kNbdBxbAeroun7rU42nBSSvo5bbnK36+T6ul4ZcIbA30gsWf5enKi3P?=
 =?us-ascii?Q?6UgUFGJhrJhlPOK4xMtw9KkEUkTgqsuBt+ylTzKlp09hGuUrPazyX5iJqzYq?=
 =?us-ascii?Q?glD7Cc6w4tn3vY4U9rdJNbzvhpRbUVm+rmagltKInVLXBDcOy05HhpArcQsa?=
 =?us-ascii?Q?nbkCPxjbqwiFLcdQWrautIl8UtwZR8xglZvN+WeqfGQC9QvbpdKFijq0sjZh?=
 =?us-ascii?Q?bFjJYLIiS9W1806C74k/TubxeVxWNJLwVFZyD8dEVEmf1FtQ1x5mHfRMbtkX?=
 =?us-ascii?Q?4MTSnVUk34l88cD847H5aJUbcpkr5G6MwH16XHi+WTJURpZNqgQn6P4iqT45?=
 =?us-ascii?Q?9D3b+issRTXC6lkKUqoudnN0SEgPm4WqS3y5CYHBVJdBKKAIXPUPJr7imon1?=
 =?us-ascii?Q?ACckmclYgeRNj0hK54IV4bCGqK7iwnv5ilZcQ2sA+YL+7iCb3q8H916WSC+L?=
 =?us-ascii?Q?7a00AbK3paHNRa84/QmVI2BsKaKg2Xd5V+5r781y2HinOXZ32J6T0BKcdjmj?=
 =?us-ascii?Q?l7lhjd3UX9UbtIk0GnwSUZpYHz4m3zW6u1ijQbGfYhKuNAHC9Ur7II/0WLIV?=
 =?us-ascii?Q?CsIDSSrqdG6MKOzqAmN//ymdpEkQhbdCPIRCKAV306tZ0umPSmMnHmtu57+/?=
 =?us-ascii?Q?MVP7qflhJ/hnN3KpYb2+8G1cH/oCi8hxKlMjyTVolg+32Xw23LKMu+jzhNkv?=
 =?us-ascii?Q?gbsdSWelKLteEf8fD0zA9yVrDDuU2zMZW6wRcCbRWFr+2cqsT9sELEADgYR2?=
 =?us-ascii?Q?AsI8RoxleyBH3zHt2GlDJIYg9U1kyLAGhqNW86XF9zlNd+IFi3zqTc/TCezQ?=
 =?us-ascii?Q?cDTTaudXQE4moE83AARZfxr0qFYp/bwsU4Omsal1KhFsTXyqRSlUgfkVWwTZ?=
 =?us-ascii?Q?azebcQvDo94SgQqmuNsNR8+e9HJSSoqGhUYm4XRYz42kKYElZ+JEqN8Hj+Z1?=
 =?us-ascii?Q?Nl92hRWdkRYJRjnTfkpg4OZCq+MtyFUbM9qh5QpjYbBhEBWGlsP/FgLkWBdv?=
 =?us-ascii?Q?JAYJGimuyg+KV7tYgqOOCIOQ1oIyKz/6lEgu/Xx1HyTgpoim1SJ+yu+lBsre?=
 =?us-ascii?Q?WM/wXKmw1mztvGiuHh7C15F/sYzSOBbryI7FQffFdOj6RTdmA9p1ltKjfHk6?=
 =?us-ascii?Q?yAcKBVu7oXSxQiOlnM8Ryl9ueCGD6Mzf9oZijdGvl7V2bszNAlUQsfNtjVSM?=
 =?us-ascii?Q?xKJQdiGiDixC3j+7OuO8Mf/UXShFFScc64/2GyX35zb/BsHMCiIe/WrDKlPr?=
 =?us-ascii?Q?27K/rcOv98wLmhV3V2CHWa2cufYsnQ+Awy4yVARC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 23129748-2dc1-4c01-110d-08db4c0b6cc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 19:20:15.5994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MqAp6LX3NytpM6pNaeqIsl+WeSq5hK10O77esI2l4l1kzsPibXmncaPX9gajhvzKzbkcptt5iBaAr0qXjpYW9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9484
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <horms@kernel.org>
> Sent: Wednesday, May 3, 2023 2:07 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Wei Fang <wei.fang@nxp.com>; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Clark Wang
> <xiaoning.wang@nxp.com>; dl-linux-imx <linux-imx@nxp.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; Alexander Lobakin
> <alexandr.lobakin@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: Re: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the fun=
ctions to
> avoid forward declarations
>
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>
>
> On Wed, May 03, 2023 at 06:41:59PM +0000, Shenwei Wang wrote:
>
> ...
>
> > > > > On Tue, May 02, 2023 at 05:08:18PM -0500, Shenwei Wang wrote:
> > > > > > The patch reorganizes functions related to XDP frame
> > > > > > transmission, moving them above the fec_enet_run_xdp
> > > > > > implementation. This eliminates the need for forward declaratio=
ns of
> these functions.
> > > > >
> > > > > I'm confused. Are these two patches in the wrong order?
> > > > >
> > > > > The reason that i asked you to fix the forward declaration in
> > > > > net-next is that it makes your fix two patches. Sometimes that
> > > > > is not obvious to people back porting patches, and one gets
> > > > > lost, causing build problems. So it is better to have a single
> > > > > patch which is maybe not 100% best practice merged to stable,
> > > > > and then a cleanup patch
> > > merged to the head of development.
> > > > >
> > > >
> > > > If that is the case, we should forgo the second patch. Its purpose
> > > > was to reorganize function order such that the subsequent patch to
> > > > net-next enabling XDP_TX would not encounter forward declaration is=
sues.
> > >
> > > I think a good plan would be, as I understood Andrew's original
> > > suggestion,
> > > to:
> > >
> > > 1. Only have patch 2/2, targeted at 'net', for now 2. Later, once
> > > that patch has been accepted into 'net', 'net-next' has
> > >    reopened, and that patch is present in 'net-next', then follow-up
> > >    with patch 1/2, which is a cleanup.
> >
> > So should I re-submit the patch? Or you just take the 1st patch and
> > drop the 2nd one?
>
> net and net-next work on a granularity of patch-sets.
> So I would suggest re-submitting only patch 2/2 for 'net'.
>

Hi Simon,

I'm a bit confused.

Are you suggesting that I submit the following restructuring patch for 'net=
' at this time?
[PATCH v2 net 2/2] net: fec: restructuring the functions to avoid forward d=
eclarations

Thanks,
Shenwei


> I would also suggest waiting 24h between posting v2 and v3, as per
> https://kernel.or/
> g%2Fdoc%2Fhtml%2Fnext%2Fprocess%2Fmaintainer-
> netdev.html&data=3D05%7C01%7Cshenwei.wang%40nxp.com%7Ca451f7a0cf674
> 0b0561d08db4c09a558%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7
> C638187376528990151%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM
> DAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C
> &sdata=3DwBrPt7eKO2Y8ve%2B%2BG8STtZZVS9YdQR11YUL6wcwJ29M%3D&rese
> rved=3D0
>


