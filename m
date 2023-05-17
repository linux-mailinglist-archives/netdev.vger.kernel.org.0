Return-Path: <netdev+bounces-3209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F100C705F85
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9454E1C20D63
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A4D525C;
	Wed, 17 May 2023 05:42:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4792CA9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:42:26 +0000 (UTC)
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2108.outbound.protection.outlook.com [40.107.127.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14A6FF;
	Tue, 16 May 2023 22:42:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6S5GKETQuvo7dUYTM33/sRCocbskHc8oqRRHEnXnozQEXpDS79oJ6mhRkF/qfBuxZfpT6ra+Czo3qy1ifCt5AkAbr40APYP+CJGUzPPeB/1FRJXMldLVkLAB/V2mRdlCOCtZ/b8xuNv6UgcakhESoPsG8Mwon09kGabG89Mlpz/8vzYt8qg571y03bBAEaCrDTVpncl3nVEcjtB1xEl7GJgE1T05CvTxchrxlbf1BJ0PYYqkcPzdi2ZUPZpeS2HNoT3yxCs+jlEH/VsqjnIcKqb7xtBR4OBcoC8hff5SpRwC2I8rPSIQ7lOHFEN3gLEhW2YspIc+3+KeN/StJqGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qT6PIIRzgC4FI18GRlJVxhnp/+g8ALLFNCpP4QhcRqE=;
 b=lQcoEDsmRBJtOIw1mtoum3BOknicj3qHnr1ohnnL35t8Zxhsbhec72z44UCJ1bgEUDOrwo1qMakFidRk7znYYNb0Kg7bj64Pn7r78I0f0jdRTa41cI+dgW0rIypFwYPFXAVtZZeSvLPsRDdbxQEHKxAar9o2VL3TxOg8QD/AsGND7pD8PLwtz3zU88bSq9kZgXxZDoJ+TRS2p7DVRHziMhTYDk3BRe0cFltYSVrtOpkeddCBH2cbL7bVuka62aUEEvkqRWrZ80VTTbEmXfPC7H631Mizlh8lSnrHvvCddALsbd9agmIBxtL1WPpvUTM+OFbj8T1zhgXybZiwzeW6ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fi.rohmeurope.com; dmarc=pass action=none
 header.from=fi.rohmeurope.com; dkim=pass header.d=fi.rohmeurope.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=rohmsemiconductor.onmicrosoft.com;
 s=selector2-rohmsemiconductor-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qT6PIIRzgC4FI18GRlJVxhnp/+g8ALLFNCpP4QhcRqE=;
 b=zN0IYDJJCiBAweF1/nGXhbYGrQuxfT3MiX9JBXjnBHfA+DfNNTDH/+WzzQKO6hJKjkH1C+f2ku1BaeIC36ngwj+OTHo9k5ZoGLbZuUXlVjnTGvQ5D/PkUv1ljIEOPl1ch3Ns8FIw2ficIgFuKnmC5K3WeEJq1bAQeEmBbIJEX2g=
Received: from BEZP281MB2454.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:59::10)
 by BE0P281MB0225.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17; Wed, 17 May 2023 05:41:57 +0000
Received: from BEZP281MB2454.DEUP281.PROD.OUTLOOK.COM
 ([fe80::4218:fb63:61ae:c42a]) by BEZP281MB2454.DEUP281.PROD.OUTLOOK.COM
 ([fe80::4218:fb63:61ae:c42a%6]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 05:41:57 +0000
From: "Vaittinen, Matti" <Matti.Vaittinen@fi.rohmeurope.com>
To: =?utf-8?B?Sm9uYXRoYW4gTmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>, Matti
 Vaittinen <mazziesaccount@gmail.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Daniel Scally
	<djrscally@gmail.com>, Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>, Michael Hennerich
	<Michael.Hennerich@analog.com>, Jonathan Cameron <jic23@kernel.org>, Andreas
 Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>, Russell King
	<linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Paul Cercueil
	<paul@crapouillou.net>, Wolfram Sang <wsa@kernel.org>, Akhil R
	<akhilrajeev@nvidia.com>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-iio@vger.kernel.org"
	<linux-iio@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "openbmc@lists.ozlabs.org"
	<openbmc@lists.ozlabs.org>, "linux-gpio@vger.kernel.org"
	<linux-gpio@vger.kernel.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>
Subject: Re: [PATCH v4 4/7] pinctrl: wpcm450: elax return value check for IRQ
 get
Thread-Topic: [PATCH v4 4/7] pinctrl: wpcm450: elax return value check for IRQ
 get
Thread-Index: AQHZh8Xo0JXBbPSiBUmjPTMSTabxeq9dGF+AgADcq4A=
Date: Wed, 17 May 2023 05:41:57 +0000
Message-ID: <61e12f46-a283-3e12-5f5c-5086a3c1bb35@fi.rohmeurope.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
 <2d89de999a1d142efbd5eb10ff31cca12309e66d.1684220962.git.mazziesaccount@gmail.com>
 <ZGOwCSPH68DJN/NC@probook>
In-Reply-To: <ZGOwCSPH68DJN/NC@probook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fi.rohmeurope.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BEZP281MB2454:EE_|BE0P281MB0225:EE_
x-ms-office365-filtering-correlation-id: 43b163ea-2b2a-4e34-5321-08db56996de4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 npiRLWx47lCCjov/igopqCXA4AoNTb7MZtf1bRdQ/TGOYDcIhh1iyX5Jx7Xos+8oKLgF/PFLo7aG2L2gKMKuUzsapgxjC44QHnHJ0V7B1HvhfF7qn30dle8r7p4RjOwf0ivK36CSOGT77rtcnUtAxlGrM34n9Lv29qZaxyxEERs7hi4+inPmU4DgR7ZXpJVR6A3JEL/kOT1gD9hcQLes4WBW8ybg4yMFiAp1QJCQALTNVrSGY0wvDVPkSDDiK31D8lwBQ/C+j0dXuR8NUYuZ8LF+GhyXrYuxqCzsS6WNTVJvlMX8Fc99CLMo4vSjy4NLyNCseNXKjX1bzqqe4QZcOGot9qJkEM3J84fGq2h3D3/blagJ+0NZwX2WDt7VLlYOD6BBuqZ4KOwgMP3RLv09envyrxaohsp/ZAugJMk+YlzqS4ul/W7CNODop0Cl1GR/UGrrMRvZWrsQpe/8Ir+1nnngSOkdN5wEK+sAosc6JVNkt/E5akuGe9NEGYynv5mubNYvVDBxy++OcQsfdKlG2kDLKkq0l1y3fuKHty3TLynPpwl2qzpFBLzRmKEe5v6JVqV4qJfPzmvx5No37G8EqX1669FVgQj7mkeYzKcWQyC6WWb4QI6lXMjmNYuGmWPCEsMRrzi+I80SV9SBylzNnE9Fv24IsWZ0XPgTpXAk2Xwc80h/SMhdi+IxGf75f4nx
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BEZP281MB2454.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(39850400004)(396003)(451199021)(5660300002)(8936002)(8676002)(7416002)(66574015)(53546011)(26005)(6506007)(6512007)(186003)(86362001)(31696002)(2616005)(83380400001)(122000001)(38100700002)(38070700005)(66476007)(71200400001)(478600001)(6486002)(4326008)(66556008)(66946007)(76116006)(41300700001)(66446008)(64756008)(316002)(54906003)(110136005)(91956017)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dzBSUTBkV1ZETUJRcUpIdGFMWmJRd0d6MGRGMWpIUDVFRmsrN09VT3VFUUJj?=
 =?utf-8?B?a0hxcTVKbWt4YkVhZkwvNmthdFFpb205ZHpaM05ldzlvWm54NU83dDdZQXFo?=
 =?utf-8?B?MEdqSGp6Z2dJNE1iL3lWcXdxL2lCT2JnbUJUeHhWWFZnUTRxMHdrcDM4N2VY?=
 =?utf-8?B?eEk3Mmx2cUdHdHlKZEt6VEdhbkE2dENwM3lEZERHMFJNU0taOXowTTU0Unhq?=
 =?utf-8?B?ZlozYS9NVk1wdzQ1SUtUY1FzM3hINVFOMTZudUpZMkpvS1RPY3EvTXA1Sk5J?=
 =?utf-8?B?L1ZKaUdOa0tUeFhETWxqanRzSnZKeUxDZkczUUs1NDBpSlQxOE5xODZqM0NH?=
 =?utf-8?B?WVJMWUpWWmZVSStEZ3RXejJkZWcxUVk5aG9aVlpmNmVheFNldFVmZ2lQekNi?=
 =?utf-8?B?VHpSVzVLVHIzcEExWW9pYTBBTk1FdmJVbFk2ekYwU1VmdFFrK3JFcGNUZkNx?=
 =?utf-8?B?NnRkYmwxaitldlVlMWJxdDZWYnlBS1BkZUJXYmwzK051T2VvSXFuQmZWL253?=
 =?utf-8?B?REwweGE0NlpQa2JEcCtoQ1lQVU01TDdpYnU2d0E4UUVGS2dZMFFDL2xuSk5j?=
 =?utf-8?B?c1J4V1VEU09FRUl5dHpsbDZMSm1kKyt1amVaVUxwUmNseTV1a1JjZVQ4d2dY?=
 =?utf-8?B?NTdKTXZQRkhRTWRvUGIzR0NwbjJiOVo3cmNmZ3Zqblk1UFRKNVpxSklVTEs0?=
 =?utf-8?B?b3dicmxoaE9adlhsUVVjeUFXelV0c21oS1NBOTNxYXh0UEVNUG9UNEhIMlhM?=
 =?utf-8?B?WmJyNkUzM0pyZEl0UGh4eGJzdkMwZ1pwblRBNTlWbHVkbnA2NFAwakYrZHY0?=
 =?utf-8?B?RW1yUWpNaUdUekFxN2xGTm5jT3RYbmdsWU44Sk9PUGhGcCt2SVk3cU10WEdh?=
 =?utf-8?B?TWJ6S1NZVUFQRkpLejdrVFhYUDlEZStvTE0vUEhGTUtlWHd3aWttSTRWdFpw?=
 =?utf-8?B?THJhZWNnM1k5TlBwTXlVYnJwSzlBM2tRMXVCNi9kUjBmaDRJVlJIaEVaQ0ts?=
 =?utf-8?B?RkV6eVlLSmhqRjZLZFBFY3VRTFptQzZ0aldxYXJLV0RRUE15T0NDYUhoVmFz?=
 =?utf-8?B?NDAzcUNGV0h5VFdxYVlBV05tYS84VXVNWk1tdlo1aUZaTnZXcm0xQlZnR0Rm?=
 =?utf-8?B?TmpBMnM2cG9zS01qSTV4WjBxTURGeVpST1dsdEY1Zm9UQk53ZkI1QWdKeTM3?=
 =?utf-8?B?cHVQbURqc0FEMnZRUGJ6VTdUMXVZa3ZjTC9BTEsvaXk0V1B3cUlnbFlHcVBK?=
 =?utf-8?B?RTFHOFpLZ2dNT1hzd2lLVXRrWHBQUGgwR0I2dmNoYUJudHNvM0V6dk1mWStB?=
 =?utf-8?B?OEdMVVZUd2dObGxiWVpaVmcrMkJpVEk0WWMvMFBYZTdoNVhyNTRlVVJyRXBq?=
 =?utf-8?B?RVhxWXpiV2V3SU95SWpkM1VvRGhmRHpzQ2k1TFc4a3VES24vakhXakgyNkY4?=
 =?utf-8?B?R1NDK2luZUJUNkxuR3U5VStoeFlFVWF4MUtqT3U0YlJ3WHVpL2Z3cWY1eXh3?=
 =?utf-8?B?aVhYTTB3NHZ6RThQNVZrS0tjaUp3Y0VQSGlrdE0rZE52c205MC93UUJ0RjVJ?=
 =?utf-8?B?NHplVzN4MFIwUjViR2pKbTNwRituai8wYnlCanZxZFh4MUQ1aWpBalRHU1h5?=
 =?utf-8?B?dXQ1MFhtcDBaSCt5TjJDV1BjcFRaTmVIYzBTRmorQnpTa0VXM0RiWkFyOUE3?=
 =?utf-8?B?ZmtoWnFWTzIxYkRzWDlrMldBUE5YOWE2SG43YldzWmxmcmdUWWFKK05rNk5B?=
 =?utf-8?B?a0R0akpEMy9UL01iQjdqS3k3b0lCUHRqWkQxY0FjWWoxSXAwcmpTZWo4WVhH?=
 =?utf-8?B?d3BuenF0ZG5QY0o2dk05QWlRelBld3RNaE5NSHF0LzBvdDExSXB1VjlOakJt?=
 =?utf-8?B?Wmx3NjU2TE1iUm9KT095OGkxM2orVG9VaFlYWS9DTHZjekl0ZVVZam1sWXZ5?=
 =?utf-8?B?ZkxJcTdLQ0dNVWI2THRPMUljbFB6M2lOODRZQ3dTdmZmd0phMUZMT3Nsa1pk?=
 =?utf-8?B?dGZlZ3pQZTJDNzlPS01TM3JVR1N6UU9vbGxTcmdQMG1DWjVxY1NvYWFITjJX?=
 =?utf-8?B?N3hZTkF5SG92d1ZQeWJyL1JDOHpuaGNadTA3eGxldGlzRDhadFhkRUhQWTZS?=
 =?utf-8?B?TWU3ZE93NGtZUHFSN2RmZDBLdE9TNEw1aC9tWFV6bFc0Rm9yODd4d0hrd2dv?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4DF89B4052ACC4E936D27F35FF13AA5@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: fi.rohmeurope.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BEZP281MB2454.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b163ea-2b2a-4e34-5321-08db56996de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 05:41:57.6433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b24d4f96-5b40-44b1-ac2e-2ed7fdbde1c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pKTB7ztcgOVmgFKkapkYhHqc15tnDyZXM7IOhZjzVFb7zhQAGLg/OABZuP3uv02jTxERnAgtU1dEj60DomhmYMxqj0ffMNTsJeZH9xQAnnGM1vdjSEw3Iuyx8F4/ksa1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE0P281MB0225
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

VGhhbmtzIGZvciB0YWtpbmcgYSBsb29rIGF0IHRoaXMgSm9uYXRoYW4uDQoNCk9uIDUvMTYvMjMg
MTk6MzIsIEpvbmF0aGFuIE5ldXNjaMOkZmVyIHdyb3RlOg0KPiBIZWxsbywNCj4gDQo+PiBbUEFU
Q0ggdjQgNC83XSBwaW5jdHJsOiB3cGNtNDUwOiBlbGF4IHJldHVybiB2YWx1ZSBjaGVjayBmb3Ig
SVJRIGdldA0KPiANCj4gVHlwbyAoImVsYXgiKSBpbiB0aGUgc3ViamVjdCBsaW5lLg0KDQpJdCBt
dXQndmUgYmVuIHRoZSBsZXRlciBlYXRuZyBtb3N0ZXIgOikNCg0KSSdsbCB0YWtlIGNhcmUgb2Yg
dGhpcyB3aGVuIHJlLXNwaW5uaW5nLg0KDQo+IE9uIFR1ZSwgTWF5IDE2LCAyMDIzIGF0IDEwOjEz
OjE0QU0gKzAzMDAsIE1hdHRpIFZhaXR0aW5lbiB3cm90ZToNCj4+IFRoZSBzcGVjaWFsIGhhbmRs
aW5nIGluIHRoaXMgZHJpdmVyIHdhcyBhZGRlZCB3aGVuIGZpeGluZyBhIHByb2JsZW0NCj4+IHdo
ZXJlIHJldHVybmluZyB6ZXJvIGZyb20gZndub2RlX2lycV9nZXRbX2J5bmFtZV0oKSB3YXMgdHJl
YXRlZCBhcw0KPj4gc3VjY2VzIHlpZWxkaW5nIHplcm8gYmVpbmcgdXNlZCBhcyBhIHZhbGlkIElS
USBieSB0aGUgZHJpdmVyLg0KPj4gZjRhMzFmYWNmYTgwICgicGluY3RybDogd3BjbTQ1MDogQ29y
cmVjdCB0aGUgZndub2RlX2lycV9nZXQoKSByZXR1cm4gdmFsdWUgY2hlY2siKQ0KPj4gVGhlIGNv
bW1pdCBtZXNzYWdlIGRvZXMgbm90IG1lbnRpb24gaWYgY2hvb3Npbmcgbm90IHRvIGFib3J0IHRo
ZSBwcm9iZQ0KPj4gb24gZGV2aWNlLXRyZWUgbWFwcGluZyBmYWlsdXJlIChhcyBpcyBkb25lIG9u
IG90aGVyIGVycm9ycykgd2FzIGNob3Nlbg0KPj4gYmVjYXVzZTogYSkgQWJvcnQgd291bGQgaGF2
ZSBicm9rZW4gc29tZSBleGlzdGluZyBzZXR1cC4gYikgQmVjYXVzZSBza2lwcGluZw0KPj4gYW4g
SVJRIG9uIGZhaWx1cmUgaXMgInRoZSByaWdodCB0aGluZyB0byBkbyIsIG9yIGMpIGJlY2F1c2Ug
aXQgc291bmRlZCBsaWtlDQo+PiBhIHdheSB0byBtaW5pbWl6ZSByaXNrIG9mIGJyZWFraW5nIHNv
bWV0aGluZy4NCj4+DQo+PiBJZiB0aGUgcmVhc29uIGlzIGEpIC0gdGhlbiBJJ2QgYXBwcmVjaWF0
ZSByZWNlaXZpbmcgc29tZSBtb3JlDQo+PiBpbmZvcm1hdGlvbiBhbmQgYSBzdWdnZXN0aW9uIGhv
dyB0byBwcm9jZWVkIChpZiBwb3NzaWJsZSkuIElmIHRoZSByZWFzb24NCj4+IGlzIGIpLCB0aGVu
IGl0IG1pZ2h0IGJlIGJlc3QgdG8ganVzdCBza2lwIHRoZSBJUlEgaW5zdGVhZCBvZiBhYm9ydGlu
Zw0KPj4gdGhlIHByb2JlIGZvciBhbGwgZXJyb3JzIG9uIElSUSBnZXR0aW5nLiBGaW5hbGx5LCBp
biBjYXNlIG9mIGMpLCB3ZWxsLA0KPj4gYnkgYWNraW5nIHRoaXMgY2hhbmdlIHlvdSB3aWxsIG5v
dyBhY2NlcHQgdGhlIHJpc2sgOikNCj4+DQo+PiBUaGUgZmlyc3QgcGF0Y2ggb2YgdGhlIHNlcmll
cyBjaGFuZ2VzIHRoZSBmd25vZGVfaXJxX2dldCgpIHNvIHRoaXMgZGVwZW5kcw0KPj4gb24gdGhl
IGZpcnN0IHBhdGNoIG9mIHRoZSBzZXJpZXMgYW5kIHNob3VsZCBub3QgYmUgYXBwbGllZCBhbG9u
ZS4NCj4gDQo+IFRoYW5rcyBmb3IgaW52ZXN0aWdhdGluZyB0aGlzIQ0KPiANCj4gSXQncyBub3Qg
YSksIGJlY2F1c2UgdGhlcmUgYXJlIG5vIGV4aXN0aW5nIHNldHVwcyB0aGF0IHJlbHkgb24gYnJv
a2VuDQo+IElSUXMgY29ubmVjdGVkIHRvIHRoaXMgcGluY3RybC9HUElPIGNvbnRyb2xsZXIuDQoN
CkdsYWQgdG8ga25vdy4gVGhlbiB3ZSBzaG91bGQgYmUgYWJsZSB0byAidW5pZnkiIHRoZSBlcnJv
ciBoYW5kbGluZyBubyANCm1hdHRlciB3aGF0IGZhaWxzIHdoZW4gSVJRIGlzIHRyaWVkIHRvIGJl
IG9idGFpbmVkLiBFaXRoZXIgYnkgYWx3YXlzIA0KYWJvcnRpbmcgdGhlIHByb2JlIG9yIGJ5IHNr
aXBwaW5nIHRoZSBicm9rZW4gSVJRcy4NCg0KPiBJIHN1c3BlY3QgYikgb3IgYyksIGJ1dCBJJ2xs
IGxldCBBbmR5IGdpdmUgYSBtb3JlIGRlZmluaXRlIGFuc3dlci4NCj4gDQo+PiAtLS0NCj4+ICAg
ZHJpdmVycy9waW5jdHJsL251dm90b24vcGluY3RybC13cGNtNDUwLmMgfCAyIC0tDQo+PiAgIDEg
ZmlsZSBjaGFuZ2VkLCAyIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3BpbmN0cmwvbnV2b3Rvbi9waW5jdHJsLXdwY200NTAuYyBiL2RyaXZlcnMvcGluY3RybC9udXZv
dG9uL3BpbmN0cmwtd3BjbTQ1MC5jDQo+PiBpbmRleCAyZDFjMTY1MmNmZDkuLmY5MzI2MjEwYjVl
YiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvcGluY3RybC9udXZvdG9uL3BpbmN0cmwtd3BjbTQ1
MC5jDQo+PiArKysgYi9kcml2ZXJzL3BpbmN0cmwvbnV2b3Rvbi9waW5jdHJsLXdwY200NTAuYw0K
Pj4gQEAgLTExMDYsOCArMTEwNiw2IEBAIHN0YXRpYyBpbnQgd3BjbTQ1MF9ncGlvX3JlZ2lzdGVy
KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYsDQo+PiAgIAkJCWlycSA9IGZ3bm9kZV9pcnFf
Z2V0KGNoaWxkLCBpKTsNCj4+ICAgCQkJaWYgKGlycSA8IDApDQo+PiAgIAkJCQlicmVhazsNCj4+
IC0JCQlpZiAoIWlycSkNCj4+IC0JCQkJY29udGludWU7DQo+PiAgIA0KPj4gICAJCQlnaXJxLT5w
YXJlbnRzW2ldID0gaXJxOw0KPj4gICAJCQlnaXJxLT5udW1fcGFyZW50cysrOw0KPiANCj4gQW55
d2F5LCB0aGlzIGxvb2tzIGdvb2QgdG8gbWUuDQo+IA0KPiBSZXZpZXdlZC1ieTogSm9uYXRoYW4g
TmV1c2Now6RmZXIgPGoubmV1c2NoYWVmZXJAZ214Lm5ldD4NCg0KWW91cnMsDQoJLS0gTWF0dGkN
Cg0KLS0gDQpNYXR0aSBWYWl0dGluZW4NCkxpbnV4IGtlcm5lbCBkZXZlbG9wZXIgYXQgUk9ITSBT
ZW1pY29uZHVjdG9ycw0KT3VsdSBGaW5sYW5kDQoNCn5+IFdoZW4gdGhpbmdzIGdvIHV0dGVybHkg
d3JvbmcgdmltIHVzZXJzIGNhbiBhbHdheXMgdHlwZSA6aGVscCEgfn4NCg0K

