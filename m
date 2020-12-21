Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443B32DF8F3
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 06:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgLUFxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 00:53:05 -0500
Received: from mail-eopbgr110132.outbound.protection.outlook.com ([40.107.11.132]:44748
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725984AbgLUFxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 00:53:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFydYNhQZ3EfyGxRgN+FtwBs7aV7/Ey9kO622132Akv50jWgVgsPvbpbTDVvtmGYbSpMi3XaMmsrLAQnrM4wUPS77/VnUiyEHGsIEjdFntGqsX7BnmIIRbTwU4mEJqWWK9TRmuCiZw352PaD+UqwFKOD8I5l7nT5v/SlGixoZ1xHJiVixXGhaz3Ci9gz4OJoLyg0Ruheh8uFpsByjGb6OAipvpH+HGCM+NaKUP1BNt8WJ2ovpDH5eXcLb/QYKn4+yL7zhf8UZVvZQ3BFb/dCV95GGOaHlGKnxiaa82ZsYBztZE9Y7xegE4p2mXQABWTSYx3Fzmbt4L3Y/SgxnxRzPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90uZvsAVZBQ7cpW0Xy9NlMsTX1Ahtf5/N/9R9dxDNuk=;
 b=SOaQ36MYwocy/uxNoC+8yHcTCxzvPaf63V9mXeSm8kh6xVJ6v7k7pHRUkdixuxmDBrQmz4f/7J8Y5tFI4M1lPe+7La/nTA3KG8eo0PuZy+DEqGmj8765FWvB2c0rb7fs2lM5Lu+NUiyyUAAvtdgm8YNIIWwOkiwx55F6KkGmVt4nswp7rqd8uFvpIkDgNsbFvZtdhmJ6STZsK2gFhJ2ZT4QHX25Wi5QwpVr1GRNRgaMQnH88w9h7tHZCwAjm4/FY3+Vc5hjof6cY1neaH5jxPpfKe+M0mlg4ADgk+LOoVen9LZIWbtCiZ4jxYp9E9RMcyL/NZ63AgX/5KYfGzFOACg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90uZvsAVZBQ7cpW0Xy9NlMsTX1Ahtf5/N/9R9dxDNuk=;
 b=EjjnSroYWTYCQ/WRQ+2mjK8yIhoZR+8ICanjA3pnClT56mD6rLSTWHC4PDvM2bcv26qvO8Hsee/M95MXM9avb1TR1UKnFTUf243CkSnJNByqOF/smOIjCEMNcz8gFwiYEBdbwArAxG3wqk4YpZesvpDOTnjpQJG8agGwpaX9KVg=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWXP265MB3045.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Mon, 21 Dec
 2020 05:52:16 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c196:42db:8b87:c1ee]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c196:42db:8b87:c1ee%8]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 05:52:16 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: RE: [PATCH] [v11] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Topic: [PATCH] [v11] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWzVlVgcXQb53S8U6wOEHHlogKlqn+dwsugAKom+A=
Date:   Mon, 21 Dec 2020 05:52:16 +0000
Message-ID: <CWXP265MB17998064FCE8FCE6B313FAD1E0C00@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20201208115719.349553-1-srini.raju@purelifi.com>
 <87o8iqq6os.fsf@codeaurora.org>
In-Reply-To: <87o8iqq6os.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [103.104.125.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: daad7643-604f-4939-694d-08d8a574926c
x-ms-traffictypediagnostic: CWXP265MB3045:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWXP265MB304508267CCF537B732434B5E0C00@CWXP265MB3045.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K55dApPH8Hw7Mo8EHCmzclQMmWzX779dig+/R+hhlvowAcfsjRYG+lw+o/e/OHg7uwwrMfzULfLi60x9rCbAGt/9UdOEk1s2im0xrUXpBiMsfEktBWnelmYeGwcllXOf17N7ix6N4cAIm6nreh4vtc0PcVg/RzQqEaD/DH+GRzRY6FhiwDodWHTY8fXPUPKhbpNe7kvU6nyqqusk6Jc89UfOYGj76Ai9yR8tPVMfUZBTf+fTzuuwbzSr91STOtJQZFBiqxM+k9Mjsf91OuU9aEMWy1Vpsj60ccpcCIyf7mu7BVFAzihaPBcJp8oqSaomPVpNumNI+2mZ3V7ygcIZ3hnK2TXEQrpkOG9tWRcrR3FmuVim/jrMY3LhWFpt2H8q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(376002)(346002)(366004)(39830400003)(136003)(396003)(7696005)(8676002)(186003)(26005)(9686003)(33656002)(4326008)(8936002)(71200400001)(2906002)(54906003)(316002)(4744005)(55016002)(6506007)(5660300002)(76116006)(478600001)(66556008)(6916009)(52536014)(66946007)(66476007)(64756008)(66446008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eqBU3BIFt0Kz3DVbaifsT+b5l5p9DMiXpFvLIgRfqPuzYWf16rCq7lnbtMtd?=
 =?us-ascii?Q?UKttwEWb9QpaWdQBboauGkAEe6+iV1Tpk5fTubal9mmPXS9zYyB9akmW2RQd?=
 =?us-ascii?Q?di18bz44/NU+Bbxx5K4vN8qaQljB8zE3C6k8A40BRu9U6pLfYPTevc51ZcdQ?=
 =?us-ascii?Q?YKtXNka583Ka7xUUYFFo+mV7TXrhMBTyBgSMK48lWQhIQCDIJXPd+QNh3SP6?=
 =?us-ascii?Q?Q1kHZ3NnWSiqzMl70j/+rUxUi8icibrqqjRnwiIUFfV1rW4GdNG2TDmkydU+?=
 =?us-ascii?Q?ZobfBQhVSpumzhufnLvgxl3PJa5AEdk1ScUG6fl2uH9am3Zkm+Gxd1vrHalz?=
 =?us-ascii?Q?yoIvWKxQ/b2mG5Pc6OgNGYH2xjOGUHwVMLYaioHb5d2nqKkT8N/GEpoNxsKx?=
 =?us-ascii?Q?B7twSVv2m4zbNd9ivzduy5+EaZ6WPIIqSzajT6JzFI/pOM0LRhvUUgEWVFFf?=
 =?us-ascii?Q?wCTaRFUMOpaNimY6HA5MnqXtOCYttA7G7kSvcj4gH4EWoUKqfkyG4wKRpSNU?=
 =?us-ascii?Q?bsn4Q+EQ754s+j1/2g2eLk+aGyUJUThm7pjnJkZOIFYPqCmj0C3c/YGY74ZC?=
 =?us-ascii?Q?r+xWTb2Y55Z1A1tBuYgcmNko/jfSJQmhf/S4IkO5D/CRco0hUzh33r1Zo3Rq?=
 =?us-ascii?Q?kCbtJxCC8UIATN+V4B0VwZABTgh0zxLmaoTuaHFXSSxwtPCCp1MiXiOahaNl?=
 =?us-ascii?Q?kzC8I4Fnn9Hve5vr6jq2S7Q1Marms6668UUOr06I7UzCpq4L2qqIm6UhgnYj?=
 =?us-ascii?Q?n4CqJi6xHjkYypoC8CiBCjh/MN90EDAa5fCYmzaOMzNvlAMx+9AT96SPNbjF?=
 =?us-ascii?Q?4CmiI6FlGn83EcpGreRyb0CUOiA6IXAKqszTtLWa+iEUA3wicNSZBOwfV1wY?=
 =?us-ascii?Q?DE0LYC19MywzL9eXSOS2xvMThyAZ4D4l8BjGkKb//9RCNMFmZmGSkcAhud2Q?=
 =?us-ascii?Q?xi4Ct86ym8NgSittSxuMl8ZU53FSXqzPQcp/ES28Wl0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: daad7643-604f-4939-694d-08d8a574926c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 05:52:16.3038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 19kJiuEyOVRmANRRRLb9DTwvSlDft8vZco8z2Vn2qVyU5nePTvz3n+ZPzNuCA7SeiIK9KDRt+AN3u0jpFQGvbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB3045
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> I see lots of magic numbers in the driver like 2, 0x33 and 0x34 here.
> Please convert the magic numbers to proper defines explaining the meaning=
. And for vendor commands you could even use enum to group them better in .=
h file somewhere.

Hi Kalle,

Thanks for reviewing the driver, We will work on the comments.

Regards,
Srini

