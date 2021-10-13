Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2816242BA28
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbhJMI17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:27:59 -0400
Received: from mail-eopbgr20123.outbound.protection.outlook.com ([40.107.2.123]:35214
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238319AbhJMI15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 04:27:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PI0oBlMU3I7GrAay1rVkxvMjSpOsR2DvinN8O/r/AeUb3jUUtBVRYnigV5bWIF997KAJxXUQ4SmUej+HM9lkPSxXuMScA0jSE+IHo002HUGmzYEXdD4ImhViMyhcSBEN8tL4CEP1VHZpvyuWPYtVm7Jof8VrpZoKOanziivtS2rI3mnRlNNiUQ94K5/NUQQKNHgDgFr/amg825OmcqoqiRu9J4kcENVHiONd2awofWppcsz+5UvUOPhwO58YZ+LYCMpAkodTfEVivmeA3m3IAf5GwO5x6n+7FMli0Ap/lEm1DgloedB0NCdbo/XKQtsSnRKNPZ1MZ243xmVMqTwImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Si4xpRWxxIAK032hZaMQB9SlSOCysA3Hzy2oB+Np4JE=;
 b=HzlY1FuZ6OyJI/fJylkcMxwAsfFCgvjRYXDc7U8GGlmFtntu92B673X6wnrtsWqvkB3QCj8eeYgGzIgAQO5FTtLSAw/N1fmzeNBdH6cNISwATI+jMRjv19K6N5Ad18oglqA16gValJGSR6QRJK0H2KuV5QmEemTlAx7C5uI3STCC0wvfCvnaujcBqQMSU5PwjoWJu1+0Q/fQF86w+3MdDavA1f+LVKye0wosF51Z9VWrrNW2QDzSx2rrAphXswXurfT9ZxZB0ZiyBmEHL1bqTsOj/+bxh9O/rkJl25AjyV0jkKe6ZaiE5SzHigFTMYElODI76w+mvmdsgtsFDhHz7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Si4xpRWxxIAK032hZaMQB9SlSOCysA3Hzy2oB+Np4JE=;
 b=sxIgbIGSeQyMuM7bCtRFcdjMjB8hrITgrJdd+EJHShGYTZ2aSjetO97TEOn/iEHwYXIWaDXh3JjG5n/7Y4JIyk9BCwD2V7lYIByp4tkeSPlSB2dqpmQ/cX0Aj2PGZK5AaMCE7ADnKYQgxETs+PyKpWkJCn6QwMyezYx0Wr+WLTk=
Received: from VE1PR05MB7278.eurprd05.prod.outlook.com (2603:10a6:800:1a5::23)
 by VI1PR05MB4207.eurprd05.prod.outlook.com (2603:10a6:803:45::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.26; Wed, 13 Oct
 2021 08:25:50 +0000
Received: from VE1PR05MB7278.eurprd05.prod.outlook.com
 ([fe80::2853:2c91:4f51:5bdf]) by VE1PR05MB7278.eurprd05.prod.outlook.com
 ([fe80::2853:2c91:4f51:5bdf%5]) with mapi id 15.20.4587.027; Wed, 13 Oct 2021
 08:25:50 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "matthias.schiffer@ew.tq-group.com" 
        <matthias.schiffer@ew.tq-group.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phy: micrel: make *-skew-ps check more lenient
Thread-Topic: [PATCH] net: phy: micrel: make *-skew-ps check more lenient
Thread-Index: AQHXv1TGDKMf7QJb+0yUIu55DbbWE6vQmTIA
Importance: high
X-Priority: 1
Date:   Wed, 13 Oct 2021 08:25:50 +0000
Message-ID: <45137d2d365d5737f36fa398ee815695722b04e5.camel@toradex.com>
References: <20211012103402.21438-1-matthias.schiffer@ew.tq-group.com>
In-Reply-To: <20211012103402.21438-1-matthias.schiffer@ew.tq-group.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 
authentication-results: ew.tq-group.com; dkim=none (message not signed)
 header.d=none;ew.tq-group.com; dmarc=none action=none
 header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c42c1f10-65b6-4554-0097-08d98e2310e3
x-ms-traffictypediagnostic: VI1PR05MB4207:
x-microsoft-antispam-prvs: <VI1PR05MB4207499CD5F930F5D655A705F4B79@VI1PR05MB4207.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UvI5HYbwuXLGeAhgNpGNmBjqhR6jmdaTx40ze1X1e0bIpXHvVZRZrRdbZjykpqOz3+jyUfrPa0gH7d1OrN2Tjhvm7q1r+X+Al2kNxbm9PmONKuWFlgogzIy4NbigM3SnjFmv0uyhV6EgJnlNQDVKgOZk+mfa5PXAO5BAMnVZev5IEerSNgvNGdAhQnK2GRKVhnXHh8ocbuu++PoeNghJLgXj6mEniIM6nyXlJ5XHGTXyBh8IMfudyUhTrfircCnPgTuR74zgzG4ICqEzb2cMhk85evNb1sdgO0qFhTGkvhp+UyN7RCxqrvosi2f8ojItsg05txOm6UZ++GsOBViysjtCKzIugzJoDtk5LZggKRVZoC01RNil9CWsPqQegYjUPXvKXdCLwcXfUn5t+Kquw7y566Lq5iBtTu7wCG/WXUSNGEXJbMGLVXFKIJB1oEYXCbVDj2Xt/54iiP7oMVEE5xKM0AcbADbE/TwX8N+TCEwkxj7F/kLQOWFTcDHloPm81ZHeBfgAUhsp/XLHV1WFKuAlMAcWxlsY1BJgw0d+TviHnrZ/0meE8vZt2AdRo7e5OVtrmiu0749yqRJFoyskPd9MGvwLKyQH05EegtT49yeUxnHdcw0dEOWs+PpLkO3nkC39tZwRPvgSxOGkBM7OTrt90L8p919y/FMCvRH5YtK5fsSZRuLVFbzOXJGOW9dqETfik9HZvvXuAb8r7zcdOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7278.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(39850400004)(136003)(396003)(5660300002)(44832011)(8936002)(76116006)(91956017)(66446008)(64756008)(6506007)(66476007)(26005)(186003)(66946007)(2906002)(66556008)(54906003)(38070700005)(8676002)(6486002)(86362001)(4001150100001)(2616005)(122000001)(4326008)(71200400001)(38100700002)(316002)(36756003)(508600001)(83380400001)(6512007)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VG4vMzhVaDZCZVh4NW9LY215T2MrK2NPR3hMYWhEbXNEQUREUllXL1JoRlFa?=
 =?utf-8?B?Qkg1Z1Awb2FOaDU4WkxtcDcyKzZvV1BIa0FtYkp0ZUZBQVhHNGZHaFpSclNB?=
 =?utf-8?B?S3FXMG9XYlFCYnJKc0xUenpmcU9VSkxDaEFwUHRMaUYvWUZwMitxTjE1cHZR?=
 =?utf-8?B?empPdGRTQjVBUDFCVHptYkpuV1ZtaUhiUVcxZ2QvRzFPU3p1VDNWcHhNcURq?=
 =?utf-8?B?WmJENVI2RGpTdUNsTXhSbkVnaStmY013VGJHWnkwMm1ROFlGUXMyN0ZpbXpT?=
 =?utf-8?B?eEFucHo1RnFTR1JVK3RmOGhJVHYxbVZndGZSRnV0N2owZUF5NWxnclVCejJL?=
 =?utf-8?B?SURGU0hrR0kwa0pPYjh3ZlI3SENERzNJOUloLzdzK0NBT1pFTVd5ZDlmcjg4?=
 =?utf-8?B?ODh0azdraC85WWxoZ0dYc3lhQ0RKMjB2eEQrTXJ5ZDBKZElCVks5Q2xrdVNI?=
 =?utf-8?B?aUxsam1VTFpaMHdjeXFQN3FwUld1WjBDNkRrL1oyWmFHeUYxWkxGdFdLRkg5?=
 =?utf-8?B?RWJ0aHUrTVdETlViV20xcUJYaFdmNlhCR3J5WWZyTHdUMFVQMEp5cUswbCs2?=
 =?utf-8?B?K0RyVnBYdFZMTzNyREcxSmN3dUpXUzBkUVU1VEJYbUdOSVZheDBQZUVwa3d3?=
 =?utf-8?B?aG9Rek1rWnlYVFFpakM2ZnNyYUFsUEJGM3VOQjhUOWJDd0NQOUFZSU40Qjlq?=
 =?utf-8?B?NUFDTEZtak5BdXp4alBubXZUZVJnK1hQQ3p2ci9GWTFiNzlnSVFKUjluRFdY?=
 =?utf-8?B?WE1jWTNYeWg2UStKaFdQY1UwNDZ5VHR3N1lodjdaWU5jK08yVnBKN0NWak9T?=
 =?utf-8?B?WTNiRlJqZ05tbmlLZDYzaFNDNExLZnh6djFPaXVrQkFvOG9ldFFwYzVTK2oz?=
 =?utf-8?B?aUJoYytyVTZlTWM0YW5DQ2Y3V01xakRLcWZOOTdwNjUzK1QzSUlZMWIrbUJi?=
 =?utf-8?B?YUl2dS8yUzRUQUFpZkNFdG9pdmpsTVJGRy9HV2R1dEl2RXJIaDlUQStYZXV3?=
 =?utf-8?B?ZlJ5TlRaQ3BiTGNuK3paLzM2MUcwU0dQak4wWkhnc0hvQ1NTeHZEeTl1Q2xs?=
 =?utf-8?B?bXhHcDd3dFZ5OXd4d2JOQjVQNVM1TE5RTnpvUHEyN0REWVJwMVZhU1pUbDRK?=
 =?utf-8?B?dU4xZnp4YzFXYVdzNjFaLzEwdXlsRlFjOUtlZlA2SXlMYkgrR0RJdnIyeWZw?=
 =?utf-8?B?THVJbkQ5SUVDSzVaZ3dGMUZBYWxDclliK0YrMzRxQUU2MXFKRWIzV1FyUGpQ?=
 =?utf-8?B?c05MSFpzcFJmU0lkeVJaQjlpeE0vNFYwYWVmYVZuMlpyb3Q1aml5N2FxbGRY?=
 =?utf-8?B?dllsYnhoOGxHVnlMeUp0RW1VUGRkNVlreEFnZ0tTK0k0MkZaMVkyQjJoWmcz?=
 =?utf-8?B?bWNqSFdkYUNER1Byb3BpeEVXNm1YbDNjMGFjdi94a1JsNVZBQ0lJS0w0TFQ3?=
 =?utf-8?B?UElZdkxQeER1cTRtR3FmK1pncTJmT3BRUnl1NFdnMFJLQUZ3MUdrYng0Z1g5?=
 =?utf-8?B?bGluQUYybzdnR1pmNGVNbWNwdmZCOUE2RlNyRnllNGxYNG4va0hIVlVsVTJW?=
 =?utf-8?B?RmxvZ2tpZVUxUHVVTVNKN1NybWlQQUlwbjdqaEs1RTZlaDlwYjRhL0l5aXBW?=
 =?utf-8?B?Zi9nckR2RTNvNjRyaFcyRXpDQ1ArZ0J4cm1vZlZEcm5IYS9kZ3BaVEZlbklR?=
 =?utf-8?B?RWZhVXBkS1BCaEczOHY5L2d1WXFlVUpUYUxRREs3VmRwZlpocDVlNVVxdWR4?=
 =?utf-8?Q?ltngDQDmlezK5Nz23y3GugR8cUT+JwTi7ahWuL+?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9996A527E83EC84D84E08C9069E17A02@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7278.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c42c1f10-65b6-4554-0097-08d98e2310e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:25:50.6513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uy2zilRVXTGtmUGMY9Wgndc5QVLu54f1abFhDNZSl148eg2EQ3FUvkwH1fMCIaXMVHbpI/E8DENH8oWxPC+5bc2ZUMbUKfxlYhG/EhFkhKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4207
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEwLTEyIGF0IDEyOjM0ICswMjAwLCBNYXR0aGlhcyBTY2hpZmZlciB3cm90
ZToKPiBJdCBzZWVtcyByZWFzb25hYmxlIHRvIGZpbmUtdHVuZSBvbmx5IHNvbWUgb2YgdGhlIHNr
ZXcgdmFsdWVzIHdoZW4KPiB1c2luZwo+IG9uZSBvZiB0aGUgcmdtaWktKmlkIFBIWSBtb2Rlcywg
YW5kIGV2ZW4gd2hlbiBhbGwgc2tldyB2YWx1ZXMgYXJlCj4gc3BlY2lmaWVkLCB1c2luZyB0aGUg
Y29ycmVjdCBJRCBQSFkgbW9kZSBtYWtlcyBzZW5zZSBmb3IgZG9jdW1lbnRhdGlvbgo+IHB1cnBv
c2VzLiBTdWNoIGEgY29uZmlndXJhdGlvbiBhbHNvIGFwcGVhcnMgaW4gdGhlIGJpbmRpbmcgZG9j
cyBpbgo+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWljcmVsLWtzejkw
eDEudHh0LCBzbyB0aGUKPiBkcml2ZXIKPiBzaG91bGQgbm90IHdhcm4gYWJvdXQgaXQuCgpJIGRv
bid0IHRoaW5rIHlvdXIgY29tbWl0IG1lc3NhZ2UgaXMgcmlnaHQuIFRoZSByZ21paS0qaWQgUEhZ
IG1vZGVzIGFyZQpubyBsb25nZXIganVzdCBmb3IgZG9jdW1lbnRhdGlvbiBwdXJwb3NlcyBvbiBL
U1o5MDMxIFBIWS4gVGhleSBhcmUgdXNlZAp0byBzZXQgdGhlIHNrZXctcmVnaXN0ZXJzIGFjY29y
ZGluZyB0byAuCgpUaGUgd2FybmluZyBpcyB0aGVyZSwgdGhhdCBpbiBjYXNlIHlvdSBvdmVycmlk
ZSB0aGUgc2tldyByZWdpc3RlcnMgb2YKb25lIG9mIHRoZSBtb2RlcyByZ21paS1pZCwgcmdtaWkt
dHhpZCwgcmdtaWktcnhpZCB3aXRoICotc2tldy1wcwpzZXR0aW5ncyBpbiBEVC4KClRoZXJlZm9y
ZSBJIGFsc28gdGhpbmsgdGhlIHdhcm5pbmcgaXMgdmFsdWFibGUgYW5kIHNob3VsZCBiZSBrZXB0
LiBXZQptYXkgd2FudCB0byByZXdvcmQgaXQgdGhvdWdoLgoKUGhpbGlwcGUKCj4gCj4gU2lnbmVk
LW9mZi1ieTogTWF0dGhpYXMgU2NoaWZmZXIgPG1hdHRoaWFzLnNjaGlmZmVyQGV3LnRxLWdyb3Vw
LmNvbT4KPiAtLS0KPiDCoGRyaXZlcnMvbmV0L3BoeS9taWNyZWwuYyB8IDQgKystLQo+IMKgMSBm
aWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jIGIvZHJpdmVycy9uZXQvcGh5L21pY3JlbC5j
Cj4gaW5kZXggYzMzMGE1YTlmNjY1Li4wM2U1OGViZjY4YWYgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVy
cy9uZXQvcGh5L21pY3JlbC5jCj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jCj4gQEAg
LTg2Myw5ICs4NjMsOSBAQCBzdGF0aWMgaW50IGtzejkwMzFfY29uZmlnX2luaXQoc3RydWN0IHBo
eV9kZXZpY2UKPiAqcGh5ZGV2KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBNSUlfS1NaOTAzMVJOX1RYX0RBVEFfUEFEX1NL
RVcsIDQsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHR4X2RhdGFfc2tld3MsIDQsICZ1cGRhdGUpOwo+IMKgCj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICh1cGRhdGUgJiYgcGh5ZGV2LT5pbnRlcmZhY2Ug
IT0KPiBQSFlfSU5URVJGQUNFX01PREVfUkdNSUkpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGlmICh1cGRhdGUgJiYgIXBoeV9pbnRlcmZhY2VfaXNfcmdtaWkocGh5ZGV2KSkKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwaHlkZXZfd2Fy
bihwaHlkZXYsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICIqLXNrZXctcHMgdmFsdWVzIHNob3VsZCBiZSB1c2Vk
Cj4gb25seSB3aXRoIHBoeS1tb2RlID0gXCJyZ21paVwiXG4iKTsKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIiot
c2tldy1wcyB2YWx1ZXMgc2hvdWxkIGJlIHVzZWQKPiBvbmx5IHdpdGggUkdNSUkgUEhZIG1vZGVz
XG4iKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogU2lsaWNvbiBF
cnJhdGEgU2hlZXQgKERTODAwMDA2OTFEIG9yIERTODAwMDA2OTJEKToKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqIFdoZW4gdGhlIGRldmljZSBsaW5rcyBpbiB0aGUgMTAwMEJB
U0UtVCBzbGF2ZSBtb2RlCj4gb25seSwKCg==
