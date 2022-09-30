Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0333A5F1335
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiI3UJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiI3UJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:09:02 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2059.outbound.protection.outlook.com [40.107.21.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098121C9E3C;
        Fri, 30 Sep 2022 13:09:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVsZGTNcoz3MG/Eon8+46ppuFKS4dggBJzhK7xFFqbuuRunKIkxbU+Tu7fZ8K7yp1mD7TJSbk1l9EMuzjUNKhFkR/PHWRu8mO1ovw/s+mF7bxsBPeQHiyx6SNQczraBUKE88OgSzwwloaxKtkQROnVu/Q5d0w6v9BEHjwUOhWV6riOB4kQySaJkIgqAQ9qSTlUrwd10ZBz6estqdvp2fUdK1VtG3h/b4LM2P5pp0PiTxZMbLIXQuLxwL27GROKEhb/KPKNzBEZbu1QKClKwYA3gbXRa0V+MWitigjDGQKH4nfePaVZL9Pmq4hI9/5JG80l6IZA9XI1+Rb427Zft4aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKbjT5ZGj138iYUVXVSJEtunW1QPjnPVWF+Y1SC2DA8=;
 b=Y7eJsnpUNsvlliCaUQB3Ng0D/9Fc3TgSwq7qAt+cnUNW5JiYADY8X5mMDyPHbO8N9tZ7olcqVjWkOLYzJgyNj+b+WxTZak5Ae0AMWvfqbnC+BMv/L/H3NCp7Ss0ea7omdyzncsS19CMt2rVMn/JEAWUrk9igPYWrQWCJ7N7WfPclZmFaiJj/ptR+nsg8QFwLpFIkpesWz9pkNh9MrSKRitfHCDctDzv24x9owC7AdpNUc0LuprrmA0CYc1nRFgJ4d3//nk74rik+cm8SPQOwddcui34mzpzJrju54BSEgOSWzfx1OzEmUf6TrCAS6/OHhk6YV7hqoMEySE7ts4kICQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKbjT5ZGj138iYUVXVSJEtunW1QPjnPVWF+Y1SC2DA8=;
 b=f/EBhm+NMyrV4qGDEZlHhTKzFNCQByEtv7NKuuOkmf9DjWTmrPE/GGP+pCY9I+ZkxwcX4nygqIhYdn/tiMddIdPDifPkNgKrhbRtsUg/lLpJrFnXibKxpUb5n0EKrEnFj62mGB7dtn8rGvxy5aaWXBadtBQ9Q5sKooFWM/J8v9A=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB8064.eurprd04.prod.outlook.com (2603:10a6:102:cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:08:58 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:08:58 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
 buffers
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
 buffers
Thread-Index: AQHY1QQs3moef3i30kelaD3cHlhvbK34Yi8AgAAAVFCAAAJXgIAAAdEw
Date:   Fri, 30 Sep 2022 20:08:58 +0000
Message-ID: <PAXPR04MB91851D68BDDEAEF25DED506289569@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20220930193751.1249054-1-shenwei.wang@nxp.com>
 <YzdI4mDXCKuI/58N@lunn.ch>
 <PAXPR04MB9185E69829540686618987D289569@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzdLHx+N4SXaAkUe@lunn.ch>
In-Reply-To: <YzdLHx+N4SXaAkUe@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PA4PR04MB8064:EE_
x-ms-office365-filtering-correlation-id: c40eacee-9f00-411d-c172-08daa31f9c3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A0FAXpIRTNe8vwrmS4ivDuu72I4FDC0fMlnE3mOY4cPoXKhXC/QNkt/6EPVyi1cb/eIE/8GGyc0s/y2G7Scunis3qQ95SqjiBIZyutixrWSt8v55CzhKEa0jG3ggV1m4rOU8hmUoqEvFnnk3xZADQ/aUFNdFK0eej+GodjFt/VcH07FQ1+ao5t+9SMi4hQC7tn2twupgETwt22ISplEATRa7xrGd9qKJuRkjmAPRBCAoIp6Y2WD615pAzv5khme98+hHaEEWFzulHdqcA6T05Xl65njguUstuW1YgUvEWY25pBGc7gnBTzhbmhKUpIOG8QCPmc4dMi5sKw06eWv77IY/4f7V1Mx8GB0xMTjkPDxNe6gWFExhVbX3RVKMJhjyKxGITLuEyB882dYzVjd9wpSpg0bqsCSjib9sMFw8gJ3IRjtk781KNH7jOqYxq7KBoKcfmj6aImY4y08rU53UoKLhU2dBLU41X6Kdg79DW+wPexur4LAhW+gSFbtIX+uO6es+E9DPn4Dzrarx/Iauls4BCKGjN9Tuo4o5f49UDqb4LCxWucv7DodUBGduXianmfU5CHSAHqJNB1cLZ5oXzQKYALFldfqWMuyVQy0DO/rlvrfIAU2eMHSD75+Lpliy94YDDIebgwkCanZzYFZ37rCjRic/ZYlKO9II/EeMgBowa7wDqZ8LPkyOF5kiU0rY1vKT5SPJ4WfJ1ZIlnvpYSIfmdZ2IPfMrUm2Urbs+rfKPeOD6I7FRpJecUpL2wR0U2pj1f2tvzq2IoAkgFSinCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(83380400001)(478600001)(55016003)(71200400001)(38070700005)(66476007)(26005)(52536014)(33656002)(8936002)(66574015)(2906002)(38100700002)(7416002)(186003)(5660300002)(44832011)(316002)(41300700001)(66446008)(8676002)(66556008)(66946007)(55236004)(53546011)(64756008)(86362001)(4326008)(76116006)(9686003)(54906003)(6916009)(6506007)(7696005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3GP9mnNtL+DLP9q/FsiFv/m8RBSXGuXUvotTOJ8OVlLz30FgzDNpcY7dN1?=
 =?iso-8859-1?Q?1HxuRarnCyXPR5L9YrEe3rYwGdvQdTYVxHZIANn8ZrarkSK/qzLFcc/PdU?=
 =?iso-8859-1?Q?EheYHiPQ4TyeNpugHgZTwN6H49+k6ENLIRbenlFf547HlZUZSujaQpkcfQ?=
 =?iso-8859-1?Q?tJBSkbbaL0joqlYk4M7HObPFXSuIWVDhsFf9/l/vseWy14cEoxDIkpAxSo?=
 =?iso-8859-1?Q?Qm66F869D7Ezymwg0mKOPESm7nx2yOzgrW7U1B7xPYwkvfbYlAWERYD3v+?=
 =?iso-8859-1?Q?1D9KrFZvd8L6MaaHl9Lupp9uBhtqsFun0J6I5sJTUGBLbynsxKSaz74zNV?=
 =?iso-8859-1?Q?MP0CHX7dHuXXn0fruGoNyzoffiRrFXpB6SkJzo8C95zhP3K/g7IYuVrBMi?=
 =?iso-8859-1?Q?WNE8uLQUU8xt9V6Vm79zGusXLnfJfR1dS7V/v7vHhAQEXtW/k7ioz7HbJ0?=
 =?iso-8859-1?Q?OWdBX5eqeQup1nsZLhe4w5UzulOcG93aFE8UYduaCBZQYaWeJez8+bouKJ?=
 =?iso-8859-1?Q?Otx+3SxmMKARWmE7jUSqqkiR8mLMTW2JwjSlw98d2nrbUlB8wDxJgb3FBn?=
 =?iso-8859-1?Q?eJ5DmJLEfQJbfqDEYDOimy5kHuzjrewZQ9aVWIeLE93z440PP/3Jqvye4v?=
 =?iso-8859-1?Q?tgw0ayoan3mIDsTTsERv/qG43blo4wWhxaLXfgxPR6OmhImCoIexudNax6?=
 =?iso-8859-1?Q?D2EUCsR50ru6uXvmBIAdd3trXHN/hU2842Jkp6U0jzf26oPSM74rIy2zdv?=
 =?iso-8859-1?Q?UqCbLXKCbhPBjbJRJRVe8j55nWRr3Dg1gdBsyNlsRcQJNgp12tZEfjbkf0?=
 =?iso-8859-1?Q?8CJi9czYvr081qFHJZqPjoeW0xWbyD6K+KVrnT0s2H0j0r31NteMjkIobA?=
 =?iso-8859-1?Q?gs1eGGGFcVoR7t7NtZd3FV+ObOXz9KgzNshgFAIVLaX6bEKR03iJxoJhz3?=
 =?iso-8859-1?Q?XrXca3JWX8GRABw6D77kxFbKsg3TbD82Z549tn2l85J1VGKPH6NcCf2vt+?=
 =?iso-8859-1?Q?bE+xEK+ODuLkNlQ2/zxXgS52YNPCo7U3+zFmECdWJ6a6z/iycheuxbCATJ?=
 =?iso-8859-1?Q?DlnOy62ARfYE+0fPIs7fmE5tFzaXcZbxku2lBwGzV/437LiJbaoxBzk8gu?=
 =?iso-8859-1?Q?cvgDOM6VdChY07fJHS8XPoOkZxQT6zcWDZv9gXvzWVV3W2cTRbzpqXHvhd?=
 =?iso-8859-1?Q?h8GTWE09rXmwAS6mKP1WO/mEsxGSQ06yWO0+uSIZ1ex58nbT6Ti4St90JT?=
 =?iso-8859-1?Q?Lp9BhmnWj5hNtXW5YxKB55TX1HsXdHB0U678jko69S4OuXHG+wotZrbL3m?=
 =?iso-8859-1?Q?FTsr+GphNqVL2q1t+PrtS4+bWvlkMJxx5wlngWrXD88s2eMVEzAp+0ROup?=
 =?iso-8859-1?Q?91iTDiN7jyRWOxmmEcpajVxn7AEdx7wzoUpAED0WUpfBmgte5D39yl5ynI?=
 =?iso-8859-1?Q?+tY54bDbbh44wdZBBBYFyomIIxq0PZ4yh7YbnJS+splub6PZDJmxAFy2w+?=
 =?iso-8859-1?Q?e7HkpLKhAiGqhiTxbpIdNJvd2L6C0XagJ5RjawLrcTHWFiS8zJo9Z3FiPN?=
 =?iso-8859-1?Q?r6lhZ9QRE3AjvxSKKkj2x8Tn/cWzl/NFe6y+0u+lZh0Bx4zu8oySv7nXpt?=
 =?iso-8859-1?Q?Znv2OMRKMqr+ZLlUwTsv/2v18FR5H8tyZv?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40eacee-9f00-411d-c172-08daa31f9c3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 20:08:58.6706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NF93kGb6JSReev5XrzjieTvpawsFickvia75DT9zghW15gsJqhOXCknvILgPQax+w18nB77d9ZaYofshZfXyXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8064
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
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, September 30, 2022 3:02 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S . Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> Fastabend <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
> buffers
>=20
> Caution: EXT Email
>=20
> > The testing above was on the imx8 platform. The following are the
> > testing result On the imx6sx board:
> >
> > ######### Original implementation ######
> >
> > shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1
> > ------------------------------------------------------------
> > Client connecting to 10.81.16.245, TCP port 5001 TCP window size:  416
> > KByte (WARNING: requested 1.91 MByte)
> > ------------------------------------------------------------
> > [  1] local 10.81.17.20 port 36486 connected with 10.81.16.245 port 500=
1
> > [ ID] Interval       Transfer     Bandwidth
> > [  1] 0.0000-1.0000 sec  70.5 MBytes   591 Mbits/sec
> > [  1] 1.0000-2.0000 sec  64.5 MBytes   541 Mbits/sec
> > [  1] 2.0000-3.0000 sec  73.6 MBytes   618 Mbits/sec
> > [  1] 3.0000-4.0000 sec  73.6 MBytes   618 Mbits/sec
> > [  1] 4.0000-5.0000 sec  72.9 MBytes   611 Mbits/sec
> > [  1] 5.0000-6.0000 sec  73.4 MBytes   616 Mbits/sec
> > [  1] 6.0000-7.0000 sec  73.5 MBytes   617 Mbits/sec
> > [  1] 7.0000-8.0000 sec  73.4 MBytes   616 Mbits/sec
> > [  1] 8.0000-9.0000 sec  73.4 MBytes   616 Mbits/sec
> > [  1] 9.0000-10.0000 sec  73.9 MBytes   620 Mbits/sec
> > [  1] 0.0000-10.0174 sec   723 MBytes   605 Mbits/sec
> >
> >
> >  ######  Page Pool impl=E9mentation ########
> >
> > shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1
> > ------------------------------------------------------------
> > Client connecting to 10.81.16.245, TCP port 5001 TCP window size:  416
> > KByte (WARNING: requested 1.91 MByte)
> > ------------------------------------------------------------
> > [  1] local 10.81.17.20 port 57288 connected with 10.81.16.245 port 500=
1
> > [ ID] Interval       Transfer     Bandwidth
> > [  1] 0.0000-1.0000 sec  78.8 MBytes   661 Mbits/sec
> > [  1] 1.0000-2.0000 sec  82.5 MBytes   692 Mbits/sec
> > [  1] 2.0000-3.0000 sec  82.4 MBytes   691 Mbits/sec
> > [  1] 3.0000-4.0000 sec  82.4 MBytes   691 Mbits/sec
> > [  1] 4.0000-5.0000 sec  82.5 MBytes   692 Mbits/sec
> > [  1] 5.0000-6.0000 sec  82.4 MBytes   691 Mbits/sec
> > [  1] 6.0000-7.0000 sec  82.5 MBytes   692 Mbits/sec
> > [  1] 7.0000-8.0000 sec  82.4 MBytes   691 Mbits/sec
> > [  1] 8.0000-9.0000 sec  82.4 MBytes   691 Mbits/sec
> > ^C[  1] 9.0000-9.5506 sec  45.0 MBytes   686 Mbits/sec
> > [  1] 0.0000-9.5506 sec   783 MBytes   688 Mbits/sec
>=20
> Cool, so it helps there as well.
>=20
> But you knew i was interested in these numbers. So you should of made the=
m
> part of the commit message so i didn't have to ask...
>=20

Sorry. I am adding it to the commit v2.

Thanks,
Shenwei

>      Andrew
