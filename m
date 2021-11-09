Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF6B44B1A7
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 18:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbhKIREP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 12:04:15 -0500
Received: from mail-eopbgr50136.outbound.protection.outlook.com ([40.107.5.136]:32389
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238128AbhKIREO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 12:04:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5GzFC8W1WIPUkw2yVGpd96xpG6FkC0xButJWlldhsUw8y6xKhgHwosoT6XFtp+LluTJHS/BHTDCEmWE9VZWFHiTQehTHoZOnVjxkzSePR7oaShudEq1s/hWHuczIg8e+3YDot9F87NNHnbYgoMX+xjNmKE8T/1Zo5bslxUNiHJA8LrfQ9GyliBdjMHmHx/+w3slwU25iSaoS2t1+mzErZ0Jce0voQD+sHF47bEq7sMKB1bL7x7KJFZv2P/4Q7wrObZh45vuWyYUf9OPA/RAwtM+e4O3ChNuT1yyuqCYDRNeQSpdY95+2y/ByKqO2fu3qWH2Uei9aobD4qdLpCy7og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLKBOoNjgtG+KI7tPASSKvwLiOsDs7NkqV2qfYgTc+k=;
 b=la0L31Zlkl0fx6s28fNZHqs6IovCF/7tYmNi+qJS6IBYTGBV56QiZxJRAzvbMsZg2MGtwGo8bIesgR/4iR5cVWwyecu6+7Ur3a9k6DpN/yZ5a2pTi6Sf1EjU7JoK4GT77jt6/C5QSVeG8tiLeSH4bKZr81TUwDMjWE2JwIklAub42QrrP3BuNJohAvEtrfK7trHr3d/I+oCH+6SCKZDoelCORFBShTyXvF9KEDhLpSt1ZN9HgVY1+FMxMIb72mqO8kpJ19I1Pq++AI5bb06g7z7LbBag7CPTOJWDdhRs+x3SbVetKtkSVN4DWzb7R9zWhfTGCQ0NdpPQBAhWyRzFYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLKBOoNjgtG+KI7tPASSKvwLiOsDs7NkqV2qfYgTc+k=;
 b=DtP0syLfIB6JYrnYhlZi9ksa1B9SmUFOGnYWvnKPsZu7JxGPyHIC93ZDBj1n5DMlxGu1JcnnVD0ZRaCRcFwnD52PItYf0u2E3YlVGN7XejrmtS9nNUu67F33U6LPnp59Gb84eSAb8SVQ6DGKZHPI9rz4uYtVSB6t3Xl+qADU6UpyDA0n3RIaZIoCyFvdBY/D80gfVLg700zUFInY+8CLlOEiY2Hc+D+8C7+8GO26DBMwxknR0pad8THfoM6k5nVeaRrUgD8otrVmi2kLbqvibzFyn19FvJ31NOJEZVv2wP1K5P5y82I4hcDnibdQCIe/UqvoMrHeZz/C81TJCdY42w==
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DBAPR06MB7061.eurprd06.prod.outlook.com (2603:10a6:10:1a2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 17:01:25 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::8c3c:6acb:c2ca:3721]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::8c3c:6acb:c2ca:3721%8]) with mapi id 15.20.4690.015; Tue, 9 Nov 2021
 17:01:24 +0000
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
To:     Marcin Wojtas <mw@semihalf.com>, Louis Amas <louis.amas@eho.link>
CC:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] net: mvpp2: fix XDP rx queues registering
Thread-Topic: [PATCH] net: mvpp2: fix XDP rx queues registering
Thread-Index: AQHX1VTwPcpWvxILPUqEUkI20PYhwKv7ReIAgAAlV58=
Date:   Tue, 9 Nov 2021 17:01:24 +0000
Message-ID: <DB9PR06MB8058D71218633CD7024976CAFA929@DB9PR06MB8058.eurprd06.prod.outlook.com>
References: <20211109103101.92382-1-louis.amas@eho.link>
 <CAPv3WKeHN3c_C4Y+QrAR9=BnQ_+tdhyKKAk=-o_DpyQ_6KyzAQ@mail.gmail.com>
In-Reply-To: <CAPv3WKeHN3c_C4Y+QrAR9=BnQ_+tdhyKKAk=-o_DpyQ_6KyzAQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 42bf139a-25ec-ad94-6d57-ac4f09329ab6
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b2c0621-8e9f-49bf-ccbf-08d9a3a29039
x-ms-traffictypediagnostic: DBAPR06MB7061:
x-microsoft-antispam-prvs: <DBAPR06MB7061CE152CF7C3291B8D8A38FA929@DBAPR06MB7061.eurprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wuorwzHmCn4dzoJ//tF4j7tjiqCfUF+n+T1izvTzNe6H7QJvgXLslvZZ7zVaeOZFqAfWbVBB/ST+sZ3gzuDhgciWYhCmgRkcIJA4L15wUIk26p0BZanvL95LveRsobvMpLtJvDYFUbPgVCPjCrxaQgQNN/BX3AsLqVFHUQfCw8tu4F4q6buNskfjK0hBI27qSxTl/C5n5Z/2fVUFMLmXOhe3Z+947kyVEz9c9gU203AJyUD3f58BMo0kB//IW7Z9kiVic0v9NT86vy5tdUd5XdHIUmGGQf+tfMRGHDnLhg6mldzs9xsY0SEsQjUVuaMK8rEVL1hBLdYEPjlbXuAWHOZyIs1BmH9tXgvJ0xAbhDlHDEc4g8YzbOc/1ihE4wZ3bec5Gs7XqI/couMx4R84qdKEz4mVC7l+ui919AY0ANHAgI+MZ3gSwjkA94FPJ7l4pdLKWW2uHOj+gaPsTbB3ArgeibQq8DeklobbgR8Y9SpU6TG7o1FBiK4gGj5NwUdTab6nwEvR8HivjndVtZjMCD3iJHb6BNvLXB5WBAN5EtkZ5mNBHrA2bA3D4at7FPu4Cb9bOX9B/IiZ5uL3dcIVjyJDhjZ0PSFd/mrmgmf3f1WcsJztQmYVrqeFEdB6mcy81fG/aj6bd6JkGHU8rrIX76pc5bIbGBQu2vu26ZL+w8chHSlXHkzN9xcztClR1DLRSkZPl8YvgcxkIiL0atm/OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39830400003)(346002)(376002)(4326008)(33656002)(7696005)(71200400001)(6506007)(44832011)(83380400001)(55016002)(66446008)(2906002)(86362001)(54906003)(38100700002)(508600001)(7416002)(5660300002)(8936002)(38070700005)(66556008)(316002)(64756008)(26005)(122000001)(66476007)(9686003)(4744005)(8676002)(186003)(76116006)(110136005)(6636002)(91956017)(66946007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?FimSB4IyhpxlDXZfTgwRyFUxwFd75CZ5JsYflxdxfZ8tlZuef6t08MYFe1?=
 =?iso-8859-2?Q?8WtDJhzEZVLNKb4THEUtV9buGGf5fwYno4kDJDZM/o+T/Prv1qFxOy18G8?=
 =?iso-8859-2?Q?OPR+aNEf2vtf3/X/NLW5QrWf5ttal3Q7xn9v2AXFuMGwZ1UUnhmz37GjaM?=
 =?iso-8859-2?Q?LgbdnM08HiJmzdnnVivkZzN/NEW/WGR1vxnSFr8DGEQvdhNeaCdTVUnTnT?=
 =?iso-8859-2?Q?UHH2vFOxquutBP2thGD6zm8TE8Sb84O7wIf0iMFzLFGHigHCSf4aTywz5J?=
 =?iso-8859-2?Q?kjhtSVAHhOLY3G4oFl18SbWmgWh3vkfwROyG3ajHvjQqG2ESisc1/7dKXX?=
 =?iso-8859-2?Q?TnFgQ2QlRpyMdiHqgvmi9VlCY3/8vsMdebW9K/UfhZunbmC2Vn4rPgo0mK?=
 =?iso-8859-2?Q?Q0dpZ130Tvdu7klBl/28kmmudeuh5URPdcPkhsaR4rLOdF33hNogRujpE5?=
 =?iso-8859-2?Q?cVollrODmKl+kSbhCF8pbD/HK4FXTqSxtge3H2kyZVT5SS1weyoBAVZyY0?=
 =?iso-8859-2?Q?DFionz/nqmV0ICxGrSkEdxCNffOs/+DSPMIMagvvVBgp2N4Wa7cfZl2GrA?=
 =?iso-8859-2?Q?A4x7If7Kpg+3E4oSRorwCyZoWwh1lSV9zK86RUYi/6xQKDhqZ9/DiRETHg?=
 =?iso-8859-2?Q?6lLhEUJuWSEw5kyb65ZsAyKxwG2RBkhWaepS/APxEuTHJxpFTQOs4EebTb?=
 =?iso-8859-2?Q?XTH9pVibOl9Zu96kkk4mgwzwM7z3PM2m4vwN0mVo+vLmPDPp2K78dpmsQy?=
 =?iso-8859-2?Q?18nLJ5fI+yZw6O7jsj4s/HPzH1MsDZiRvBVj4EiMmXxbfpV2fZyE72pNS8?=
 =?iso-8859-2?Q?9aq8dJi5sR12JaEiyJhOw5xkg8eTVgt8KPWBh72U47Tn/P87+rZLYhQFbg?=
 =?iso-8859-2?Q?khe8szbG1T4HGqGvFiTdyA3orJdla65Hvq03c+2CkaSc3SWxcuqd1xeRqE?=
 =?iso-8859-2?Q?XZpNb7vX5fKfaLO8deIOeyxE87f6vuHv3YD4qyl2fQA5qnFKTmM7eRHlfj?=
 =?iso-8859-2?Q?R89OH6JRAvKNVrXYtl2ESGVSEtSZAzE0Rll09nRk3f/Zk7nqGSgZfoGvLz?=
 =?iso-8859-2?Q?BVLsjhYU4UXjRu6KWViCv+iTh9lO1HHUeqi6HZY037CTP6IoI51EVExk1p?=
 =?iso-8859-2?Q?kCqz/3g+77/lUjGyQiZqTv4Ti/FcuhNBxH5scE/4x9s/S8INtSlZXaOoFa?=
 =?iso-8859-2?Q?a735G9iMI6aXMP+n7zXDdTcvu4IJxs3F27OHGxrTTI2m/da2ogMpp6idxj?=
 =?iso-8859-2?Q?SmNYk+EVx5QCGVoJZPvc2OtQz9aCOGN5KLMUR4jsz3Wv9JT0CGTHDp5v7m?=
 =?iso-8859-2?Q?LUonh+JbY+l1AK7xUNqRk7Ur4L1CQZRSCSfwtuEAgOsr04h9tutE/pF1Og?=
 =?iso-8859-2?Q?vzuRak3L909iUCSph0oUXefYPuOeBzDnkm2hfUcMC8FuQ0vwU4n5OJ9m9l?=
 =?iso-8859-2?Q?ofiILCsncXthvL+FZLW6rIP8MGuRlE/dCwbTnVFNiOajuGMZnan2Vxxq/M?=
 =?iso-8859-2?Q?Ym13lh3vJWjayBW5a3q4NxYaVYo9ZsX73UWQlo6a74qbcLC4KWBoGPPBwk?=
 =?iso-8859-2?Q?Hd6jBHBZpDp7kQJ1dqwMEJXc5V8f7bQzkLTuDZcz0eowByhSqC6YCZOi+M?=
 =?iso-8859-2?Q?mLwxlcwmDuqIPB5P3jchVjyTpko5VLyctnNMQCaoDLaxH6u3C7uFj23hd2?=
 =?iso-8859-2?Q?8vWMbtS5jDIrejk/OhvzqBJSzpWjdjVzyCziwVlquQ6+sEt41oPiC4J4D2?=
 =?iso-8859-2?Q?N+ag=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b2c0621-8e9f-49bf-ccbf-08d9a3a29039
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 17:01:24.8705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8KLCyU8PtMgoPPue8UFN2M4eJTm4yAxk14LkZLuY31Jy6WJI9Ez1HsXQJtci8exyLJ9rk7mDyKSytT/YRTwPLbG2YQmLoeosQSjxEv/o//k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR06MB7061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, =0A=
=0A=
From: Marcin Wojtas <mw@semihalf.com>=0A=
> wt., 9 lis 2021 o 11:31 Louis Amas <louis.amas@eho.link> napisa=B3(a):=0A=
> =0A=
> Thank you for the patch and the detailed explanation. I think "Fixes:"=0A=
> tag should be added to the commit message:=0A=
> Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")=0A=
> =0A=
> Other than that - LGTM, so you can add my:=0A=
> Reviewed-by: Marcin Wojtas <mw@semihalf.com>=0A=
> =0A=
> Best regards,=0A=
> Marcin=0A=
=0A=
Thank you :)=0A=
=0A=
We'll send an augmented version tomorrow along with a small rework of the c=
ommit message. =0A=
=0A=
Best regards, =0A=
=0A=
-- Emmanuel Deloget=
