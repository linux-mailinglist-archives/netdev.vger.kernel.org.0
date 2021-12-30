Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8127F481E66
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241344AbhL3RAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:00:06 -0500
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:20320
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241264AbhL3RAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 12:00:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZLwTna7KyonpJ9MZwnB8DJQhSI6NVSZ89kBdFsQui8ZimoPi3egdtYPth11YwfdhZJHkz8W6DPtsaUomr6KxsSjZZfZcVuoZjoHy2sWM6qlXmJvhlfM1LhRx9MHodpBo95rlkiQOqqfkqpij4i2KYD1cIe2mmVa3MvMZTAMJppUHvkW8bniCAC4DJPmlKidNx7VDNkj8RCKWBDzMO7JpId7CVrIChNrWM4Plr2k47njlJ796M9OKLlTxLwH3WXoccykqZyl7TrcpSIo8DsD7bh7m9GbwxFLL1zrlBKT5aKzg51kl0t/r4kbtl9jhsDYc+OflQGB2FA8SaaYC2RHVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcMDU6lapC7GiVGsx+Khj+hFC0Klf8qXHd6lfghDzCs=;
 b=j7fnQbD+uA5C26W1shU8dHtIiXatDmQOUjm6tHbFolveBPa1vSjO+gLwHaINTkxMftsc0j1JiI8eXAm16owfY3QRKLN5PkSTI+TGTyS5Ycp4vyKNeVRSfIe5DSQwWPP6zMfBXR7wYKqjkoNDAoJUhK0IcxFsLdRpn5Se9Jbtsc5WJ9CGhzvrfEUzqiCDfMOtboKLu5a3NLXL/WqVAuY2AuMaDHN/dcWar/Vj9umKloiCRr8fm2adbIp6DHUloP+WBLYgCjgzHqgKxexiOivoXHZRP/pdYWRcqS6RiWQtfFoh+HUvBPsffTJFzeQM6kVpXtZg4Zd8AolGMmEEt6DGPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qorvo.com; dmarc=pass action=none header.from=qorvo.com;
 dkim=pass header.d=qorvo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qorvo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcMDU6lapC7GiVGsx+Khj+hFC0Klf8qXHd6lfghDzCs=;
 b=LjhL1yLTqgVFjOcWEGHdkv5ayYSTELuO5TomrTcmyLda4jd4YuEw6NYyjYqgDcp5LDqvLQEshLC5YXNLdmzv/4vz3tHkYOuR9QLorI9s9Qe99xIl/7kvng5x5OukN+SBriN11R2zGoIFf25zLAWAdzt/TFMAWysQWx7/xPapdUo=
Received: from SN6PR08MB4464.namprd08.prod.outlook.com (2603:10b6:805:3a::10)
 by SN2PR0801MB2207.namprd08.prod.outlook.com (2603:10b6:804:16::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 30 Dec
 2021 16:59:59 +0000
Received: from SN6PR08MB4464.namprd08.prod.outlook.com
 ([fe80::8477:deb8:201b:b634]) by SN6PR08MB4464.namprd08.prod.outlook.com
 ([fe80::8477:deb8:201b:b634%4]) with mapi id 15.20.4844.014; Thu, 30 Dec 2021
 16:59:59 +0000
From:   David Girault <David.Girault@qorvo.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Romuald Despres <Romuald.Despres@qorvo.com>,
        Frederic Blain <Frederic.Blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: RE: [net-next 17/18] net: mac802154: Let drivers provide their own
 beacons implementation
Thread-Topic: [net-next 17/18] net: mac802154: Let drivers provide their own
 beacons implementation
Thread-Index: AQHX90y646vLv4dx7kChQ6wFJZ+MJ6xIhPMAgALD84w=
Date:   Thu, 30 Dec 2021 16:59:59 +0000
Message-ID: <SN6PR08MB4464D7124FCB5D0801D26B94E0459@SN6PR08MB4464.namprd08.prod.outlook.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-18-miquel.raynal@bootlin.com>
 <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
In-Reply-To: <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 37d2767c-3012-e8f0-8d43-5e88150cdbc7
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qorvo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c28149e-9738-462c-cef2-08d9cbb5d072
x-ms-traffictypediagnostic: SN2PR0801MB2207:EE_
x-microsoft-antispam-prvs: <SN2PR0801MB22079F896304A7242C3435AFE0459@SN2PR0801MB2207.namprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VqV3SZKAgdaXhpB+rg+Lc+eU2puMv2hAncD63cmSPstthxsBCdLAKW6rZ3ER87VA9aNzpE2VChmXREOgBszGQf+U3X3nNa6Sc2OJufD9yfJz6iMTHI/4VLoSREL5GoawNKG0cERcsTLoRkCNj5GXxe/LKwzeraE3ExI3Ap73MCpg7F83MSxgZHpR/mXV0BkwM6sY70V1GpJUz6cRwfR+C0V1+JoneqZAI2pcEM5NGuhr0f2wSCyJpXTYfyiKvoi/VwHWjQN2Uh26x53Kmg07yea9urrY6a1L3Z47DSoMvxGamud7T2i4dTOBbLgL+H1bVn7rFdcpH4SFZ6AGtMDlrmGZVyATgduMtcqEiF78tDLIMpTHkZNX93GSB2+U98tBAu/X3Y9arShJDelHoROIBatH/YJrlSNeGf7MkgPt6flM4Ir95Q41y6kTwJYBGIIeY6Mfq2AfkFkO0PLsi208SyUpeU4KCVvYe5k+L0kP3tN6LXRQEuTYb3pW4nKq4cdJR8YzJo7yM0DUc2fIQqMxt4yyHn586nDeEE6Lla9tJndvsu6mmfa4vezsNh3JOLC6s86kjMtnvL6PukVVvylAz/ZareFWFd1FbuAvHm1Xu2r+P4l14BxyuhXOh2kf61fI2vuBzmdcuMl5ePZO/aAf4UYsrLeltiL1oBX/l0LtLJ2JZQK07iQBeSO8if6hhHo79drKHgwAS8qAt1q933DtUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR08MB4464.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(76116006)(508600001)(26005)(66556008)(66476007)(91956017)(38070700005)(66446008)(64756008)(110136005)(186003)(316002)(6506007)(122000001)(83380400001)(2906002)(7696005)(66574015)(66946007)(38100700002)(33656002)(8936002)(71200400001)(54906003)(5660300002)(86362001)(8676002)(52536014)(55016003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?qtmPSE5niDGCBYaIF2uCNHxa1QXTHetcT8W4ncr1VvGFaHUqry/49usrXj?=
 =?iso-8859-1?Q?PsFWPZydwcJh0fj/ErczXtgYgN5oWjDuDPtRfpAMxszQX5fu0MK+PxrWM9?=
 =?iso-8859-1?Q?wAuU8X/HMcXv5e32FFe8xH8atbjE35cWn5ap5qqY50tAtCYU8wwVIKMF6X?=
 =?iso-8859-1?Q?sxeeuNNfEH4dg+vBm/h5asdq9BgeZlmalZ7BDkXfPIgiwyIZ52WAsj1RyU?=
 =?iso-8859-1?Q?KUa6PHuxwQwFP1+g1fsRKcIswFhtXmrO0SvpW3iNJOHKFthyRto54gskHt?=
 =?iso-8859-1?Q?2bbmXmq3Z2QI9vXEfYf04I3F8xDsuwzu91NWfqei6rMytE78rwHCfPTpk9?=
 =?iso-8859-1?Q?amGM1vJqvhRb13G4uiliGcUflWps73JPuYSOI1pagGSKJWtJEZONv5HlP0?=
 =?iso-8859-1?Q?QADPPuP+spbpR5B5o9BogH9O1bBrNRCGexIlvAtsNM7e77CRHetLMY3X3P?=
 =?iso-8859-1?Q?E5OSzYJXLrakUbUvHHtaapNjdlGPvgLrwpAyZ5jmvVAfM+soRJ5DiLMpM7?=
 =?iso-8859-1?Q?FVHPYBi3vkIzRgBVtYvd9h9xzpb9tp7UMmS6uhL4sO7UefpXuQ2mbMGdej?=
 =?iso-8859-1?Q?6j48Bxhfhyw5Pl/QSgFVzu9Mg88izM5e4rI8nB8Z/7ZcKkfHscP5MCnwwF?=
 =?iso-8859-1?Q?187CabqSSZy21Rlb/BqtkfVuTxEsKm+9VYDeMZprJGzZ0nOljSMKM16cjW?=
 =?iso-8859-1?Q?ohl7TMbQB/bToBGzWd7OHTLCqmnUg/edVjjzQevBbVo2o0QPJc0qpUv1I3?=
 =?iso-8859-1?Q?osKG7ILzdoLBVvmQlb/bGscfjGTqbvrQ/FQyb9qwp1mn0DSF5lydbbw+5N?=
 =?iso-8859-1?Q?hUifiVhbm7k8NNtcW/sEjE9JS3pMLzzMmwJ7khfYNMMEO4Gsgm2BsNayle?=
 =?iso-8859-1?Q?5BYC6JWyKUay4v5OSXbskauUYf983eex2OBOQXSfU1yjgJQgJIXEP5QWlZ?=
 =?iso-8859-1?Q?oTm9y+NTfkDksoOEFXNquckdjNBVqiv2qXDJWUoo+1K6b8TaSsvG1FFu9q?=
 =?iso-8859-1?Q?9NZwSt4fuO1BCJNNg1i2fQ8NZ6sQAP5n8Ugr5HzzSQKhWzcVm9uG/tQJn1?=
 =?iso-8859-1?Q?8j8kCd4HKQXl2pPaEEQS9GKUFIpRv9i1yDvdYDEs4arX/oohj0WGvKEPwm?=
 =?iso-8859-1?Q?4BQ8jd4PlucTN2Mr7J/mu5kR177GCl+1psB9+dAStB+O4TWvhsqrfI7x3T?=
 =?iso-8859-1?Q?fOvTZEWlnIYqytuYRY00VxI36tDpQ/iCazJeD6AjVo7gk9ylrral1cY3A8?=
 =?iso-8859-1?Q?FHsM4zxYJrbm8PSDbZl7Ze+ieygoqbhdPx+2AZgNfFhKBN1GBZuz2j/5In?=
 =?iso-8859-1?Q?Uukb5ROSnZIzg6CNgSBqYnsjKyNyF5EBGiOMPHtneQGLZjDPb9H2FVsDTj?=
 =?iso-8859-1?Q?SZefcWuji9CRb2foGfyQY5qJ9iuWTVpGzf/70gFG43xL4kJ/QuVnaaufYQ?=
 =?iso-8859-1?Q?d7DhuIQRFzCVaSv46QiZtQ0MsxMdchtv1AkENWQSc7UGolnYl1mLc7zzVU?=
 =?iso-8859-1?Q?IyqU09jUAFz/tvYw6WNpPyObotXqwusDPWTCMaQBxt1imTKxY1RtHP08D5?=
 =?iso-8859-1?Q?BE6Q3A0lU7CPx/DAPuYyUZF9vj9JbemMCUu1+ErWq7gbD/1V5fUcXrG4kg?=
 =?iso-8859-1?Q?4sp/lN41E73VINS27E+85zsoFY64gPJYjjYym0THpYY79o0em3BPeUaA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: qorvo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR08MB4464.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c28149e-9738-462c-cef2-08d9cbb5d072
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2021 16:59:59.4621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ea529389-cf47-4fb2-b8ff-2ddd0b7d2a34
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7npn9COaB/T+6R/G3lcTNDVGfZePjWRuUC/xFOJ/pRj5ZgtbdTpXRTolLW6wvLl2d1bzLHw6QA9Tvy6mWXPRKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR0801MB2207
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,=0A=
=0A=
At Qorvo, we have developped a SoftMAC driver for our DW3000 chip that will=
 benefit such API.=0A=
=0A=
To be short, beacon sending is controller by our driver to be synchronized =
chip clock or delayed until =0A=
other operation in progress (a ranging for example).=0A=
=0A=
Regards,=0A=
David Girault=0A=
=0A=
________________________________________=0A=
De : Alexander Aring <alex.aring@gmail.com>=0A=
Envoy=E9 : mardi 28 d=E9cembre 2021 23:25=0A=
=C0 : Miquel Raynal=0A=
Cc : David S. Miller; Jakub Kicinski; open list:NETWORKING [GENERAL]; Stefa=
n Schmidt; linux-wpan - ML; David Girault; Romuald Despres; Frederic Blain;=
 Thomas Petazzoni; kernel list=0A=
Objet : Re: [net-next 17/18] net: mac802154: Let drivers provide their own =
beacons implementation=0A=
=0A=
=0A=
**This email has been sent from an EXTERNAL source**=0A=
=0A=
=0A=
Hi,=0A=
=0A=
On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wro=
te:=0A=
>=0A=
> So far only a pure software procedure for sending beacons was possible.=
=0A=
> Let's create a couple of driver's hooks in order to allow the device=0A=
> drivers to provide their own implementation. If not provided, fallback=0A=
> to the pure software logic.=0A=
>=0A=
=0A=
Can you name a SoftMAC transceiver which provides such an "offload" feature=
?=0A=
=0A=
- Alex=0A=
