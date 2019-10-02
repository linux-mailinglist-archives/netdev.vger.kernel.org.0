Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56805C8EF5
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfJBQvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:51:06 -0400
Received: from mail-eopbgr810040.outbound.protection.outlook.com ([40.107.81.40]:56928
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbfJBQvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 12:51:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDf8cNiVaIs1USTdZfYtFWuiOlkBnLW2mdxHFTjzIMXPbkGkBwe0DJDzFDgpW3MH4PCibAAYAPMMFKx36Qwrh3ijC2ksS5KAPT9mxZvxHJUAjyarrr0jGMg2mGFLXckbu3Q6s6do6hr1i47bCYjUqahN4lrvesBox5UH6f1a5zdb/qWr7ACXwAh/r3AMrASdE6ZbeRLr/I+TeBMR+qIvyYnlGbp7zN6O1Jihxp9sJHGUwPTePMun0/lyA7Vhr+x4q7G70Wlhr+vxfQRRHjTB2jDOm/UsLFp5k8sOEOZE7DI7LiQPXMmJNPUA69yIFJ4UdrUPzgVXOR2M9+WgDwB3jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ziovh6Z/smGLGAiixIv5ZVkNm5JWlgc5DA97F/bWCqo=;
 b=PQs5KrSoz+oDLwsLtQoDcPRyeO3mmTPyF3zMmlbWcHQwJHLMP1oMtT4ico+4Wigvn0RQ8WcAQrH/z5nMTK9bqMyh9e3Mm5V4jluIv8bAnJwkHCZwQJBjhFLM8V7U0wOSPLed8iwwXpQ7BU4rqM5LHw18cwB7zUtxd8kCrQBwuQmNBms/VuHRapmFkPMKa47S6ihw7umkKmXpl6YUD086OA67dTWXdPZIjXG0o+5qeCrDPD0riLnYwD7plqz19rEc0UrTDBvAncZDkzwjTdWjNneiqjdK+9BKGq7X66gaaxqjE8PO3dekRag1OSZNwscjS4Xz9dfiklWQrZJsDP48dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ziovh6Z/smGLGAiixIv5ZVkNm5JWlgc5DA97F/bWCqo=;
 b=c3GWiyISylf2hC+CCh3e5s2XwzBxkHkB7ybZz/bHJAHDrgiM69pCBJiGp3lfJAoZqPu6l6U3AHlq+MYIdKSVmRlktNZgtq4dLPwwbMeXwrTyfpBdjeYt48mbnfQNo4wNGMqzTkw08SMuKkR0CwibP8cN/KzMPVbgqM7uF0QfOIE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3918.namprd11.prod.outlook.com (10.255.180.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Wed, 2 Oct 2019 16:51:02 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ac8c:fc55:d1e2:465f]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ac8c:fc55:d1e2:465f%5]) with mapi id 15.20.2305.017; Wed, 2 Oct 2019
 16:51:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Le Goff <David.Legoff@silabs.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 02/20] staging: wfx: add support for I/O access
Thread-Topic: [PATCH 02/20] staging: wfx: add support for I/O access
Thread-Index: AQHVbthYAz5BV9jhoUCLDh42xNi6RaczMoaAgBRsfQCAAAP0gIAAAimA
Date:   Wed, 2 Oct 2019 16:51:01 +0000
Message-ID: <2259110.QEIxtLcPIB@pc-42>
References: <20190919105153.15285-1-Jerome.Pouiller@silabs.com>
 <4024590.nSQgSsaaFe@pc-42> <20191002164207.GA1758310@kroah.com>
In-Reply-To: <20191002164207.GA1758310@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30a366c0-d004-4c82-3f44-08d74758b51f
x-ms-traffictypediagnostic: MN2PR11MB3918:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB391807CFBB0291A9D625746E939C0@MN2PR11MB3918.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(7916004)(136003)(376002)(366004)(39850400004)(346002)(396003)(189003)(199004)(51444003)(478600001)(26005)(102836004)(76176011)(6486002)(486006)(8936002)(305945005)(7736002)(8676002)(6506007)(229853002)(81156014)(6246003)(14454004)(81166006)(76116006)(6436002)(64756008)(66446008)(66556008)(11346002)(91956017)(66946007)(476003)(66066001)(66476007)(71190400001)(71200400001)(25786009)(186003)(14444005)(256004)(446003)(6512007)(9686003)(6116002)(3846002)(2906002)(4326008)(66574012)(6916009)(86362001)(33716001)(54906003)(99286004)(316002)(5660300002)(4744005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3918;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: miXPqlD7uojS2keYbaU6A7E7eEkLFREmk9tkMsjExyA/S0RJnGDLM+9HeX11DmaxeVEAcHJWAUr0nNMaxgHHW/o99hw48s5qrLv4VXDFAu8Cxb2Ryo4ialbzQresvCLif9JcjeHbi7gA9hqGevXCEZNbSfy8ytWAA/y6eb+BHwB4ywpy3EoNtUcpezW1EPCgPBMejx5BpgjvmEjSp6cTC4F920Eq7W+SqUWetC+f15ucS+K+TRYFfJQlKcde1m6EVmTewTzcV4WL2vao9jupxZvVlSPTCYxS8122EfHD9SnhuywEV+Ryeh9+v4mAo9kF4Y/T+SDm6mtPs0dL2yD4i+zsZFm8c8FuE76Hq252dG27ImX8L00/fk5z5IEJu3lT+DtuvH92YT3DlmwQn91Q5vpRQHTPlEqbokvfhTxvevA=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <97457DD34C246E4F95A1E589E5D28F25@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a366c0-d004-4c82-3f44-08d74758b51f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 16:51:01.6073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dtl8cSgUJXafLV+ALxSAcTxGMVFMKn17lomLQBCbLXsjBfyrdVp8IIdbn5c+Asf2QywzcYV7RXEeN+LuJNVDqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3918
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 2 October 2019 18:42:14 CEST Greg Kroah-Hartman wrote:
> On Wed, Oct 02, 2019 at 04:29:09PM +0000, Jerome Pouiller wrote:
[...]
> >
> > Hi Andrew,
> >
> > I did not forget your suggestion. However, if everyone is agree with th=
at, I'd
> > prefer to address it in a next pull request. Indeed, I'd prefer to keep=
 this
> > version in sync with version 2.3.1 published on github.
>=20
> Ugh, you aren't doing development outside of the kernel tree and
> expecting things to stay in sync somehow are you?  That way lies madness
> and a sure way to get me to just delete the staging driver.  Just work
> on it in-tree please.

Sure, I will just work in-tree. But, I think that if someone want to
follow history, it is easier if it exists a version exactly identical
in kernel and on github.


--=20
J=E9r=F4me Pouiller

