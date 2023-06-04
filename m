Return-Path: <netdev+bounces-7754-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E04872164D
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A50C91C209CF
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 11:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6695237;
	Sun,  4 Jun 2023 11:13:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A0923AE
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 11:13:20 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2104.outbound.protection.outlook.com [40.107.6.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692D4D2
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 04:13:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gi1raiCL/uslrhjQbfrt6ygBuftnh3eabSyjhqG3scIKHQK+7aQ5ovdgQ4qW85d4umgGhoZoAQmclBLnr7R7ut+7qQ6tDqbKWZnzZIYu+dUJ/TpMRKLHXQ8+6fCOo6eEUtgL8zy/rxbXiR9ahbUfoDi9E7AEDoxS2dXnZ5vcKZisH+P5kZWEqri8s4GqHtEMsdosfI57JVbac3UIDjU/r54JmxhkitytrjsWnzZpQDMdsnkA7wGK5zxMbKXlJdxfXP0LJOAALOQx9X3RvczvlIraYkWtgI3LEl68PaiXT+HDo5Ze9bcSd5xhtj1aYiBWI+Uc7mktD6kcdYsnihmOnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGN1q6tI4Jrt4WB5nyR2C10GlhcV/KNehaW9mzATaS0=;
 b=Ry9RmstkkSrWkajemQjEBAqsaNNejOLpjCezNtUkRDkYliToKW/QM/6SFa9EupQO+ZuSGqtpsPL8tB4sDvCyKVhEc65gU3E5N4NnMKP2kqCDkPxSa2r+iIgVb3pu0Iz8KYorfQul33dRJNlP5EIAKJTrq7nTes5EvTt4SAzmvEjIODco9GGlh1RuwshcWC3ujoujOHthM9NbNzfWyKGT3sbcX2mRS4+sl7a+YsxlujrTniDKqZrzhtPjizDJE0JHszsyyytmik7Wxo5MzH0p7MkRjgGAnC6nSJSgxLw/+Z071M8M8Cv/ijSUDNTJbBoaPtCZMwI2huHwoaKnLkJbBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGN1q6tI4Jrt4WB5nyR2C10GlhcV/KNehaW9mzATaS0=;
 b=pV4/FkoDbOnZRXtrsl2JWKrfFT1KlQPUf8uBCLtRmJaPnkz3ofrXLiSLMhouNqIbKWpp1UX7eOyL64E1QS+4YwZ1ALnmweEXTHeW/eIJyPZJhVeVfl9al24iJmC8rnVcxzxGHsihYDgVRM3l3FzAo/0Pm99B+cTs9BwrSDwYarw=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR03MB6480.eurprd03.prod.outlook.com (2603:10a6:800:194::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Sun, 4 Jun
 2023 11:13:15 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::b8e6:a92f:367e:801f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::b8e6:a92f:367e:801f%7]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 11:13:14 +0000
From: =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To: Christian Lamparter <chunkeey@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "luizluca@gmail.com"
	<luizluca@gmail.com>, "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
	"andrew@lunn.ch" <andrew@lunn.ch>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH v1] net: dsa: realtek: rtl8365mb: add missing case for
 digital interface 0
Thread-Topic: [PATCH v1] net: dsa: realtek: rtl8365mb: add missing case for
 digital interface 0
Thread-Index: AQHZlaUbiNIpGpW+YUqQiFxKZayVsq96f9CA
Date: Sun, 4 Jun 2023 11:13:14 +0000
Message-ID: <xh2nnmdasqngkycxqvpplxzwu5cqjnjsxp2ssosaholo5iexti@7lzdftu6dmyi>
References:
 <40df61cc5bebe94e4d7d32f79776be0c12a37d61.1685746295.git.chunkeey@gmail.com>
In-Reply-To:
 <40df61cc5bebe94e4d7d32f79776be0c12a37d61.1685746295.git.chunkeey@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|VI1PR03MB6480:EE_
x-ms-office365-filtering-correlation-id: 832e73bf-8a62-4732-dc20-08db64ecb0fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 n3kthPMp1TRdYVifmujZcU85x2BGg+SkSJkIX8GDRSmYWuHwVVhAuj1NkYmuJvSRvoMbSdX9xrpM+SR1td8OpQf0oSoyntLL0n9mFulfGjlczkUGV7s33pRX0QmiWIlvM/hUnWloGSb8VdP9ysXPbkNU0HUlsUfxRlEoxZ882KNUnvMsbhXQY29vaGW2WNx/zPVdi2iGQmjl15kC4FLU3Dk5hKR8/SjXhfzzkWYrPhBRDXDdBWnPrWnDPBsHDWiaqLE8PFVDtMh31bkAZPrvL/hJ6UVpVzD/upCZkzTBGJk7C3r+TdZvhIS4iUr/rrk86UhtMsdUuxdJ2cwLpbXukK3JqXYgFAAbK8slvqcmjMOX5+qXODbqiNBGKb3xUc8dwfoYP2UqeAcoxAExZoAezWe8//KI5//FI1Veeuk41pr+B5HKahzW03W/vPzN/brgondDbTEih8TqHHj4JYVVPXfdBvHlkF4ThszmCqX18EXwxK3YESglh+jUpQSH1wKtyu2j7pfG1OY+ju4LAVsRCNGUtiZ62f7V4DZggryv8Jt7wV0Gap8E3eC+QIJlCXdHc2i+k4P9HIkGg7ldWSOcC6MaZR26x++FazORJlO8ns0zwabi2CxuL8KdEj+ljsuD
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39830400003)(376002)(366004)(136003)(396003)(346002)(451199021)(54906003)(71200400001)(478600001)(8936002)(8676002)(5660300002)(85182001)(38070700005)(85202003)(2906002)(33716001)(86362001)(4326008)(122000001)(6916009)(91956017)(64756008)(66446008)(66476007)(66556008)(316002)(66946007)(76116006)(38100700002)(41300700001)(26005)(186003)(6486002)(9686003)(6506007)(83380400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZldxaHI2Mk5tclJEVDRJMldSbTFnNFFHV20zQVNkaUxBa0gxcFIyQTF6NVRB?=
 =?utf-8?B?azBLSHJCc010am5OblVDTWVvOExuS2JIMUx4NFpmRFFtV2tQSFVDK2lXVmhU?=
 =?utf-8?B?ZmNsSExHRURzejlzWFErZ2kyQzNFVUFUS0VIcERsOEZPUUNOaGJvbW1tM3k0?=
 =?utf-8?B?Nkp2M0NWQ2lkWGgzSzlvd1IxU05aaXdGei8xUHUxNWpVTzVwV2hHd21ON3kz?=
 =?utf-8?B?OUpsY21HYTZtRVkzTkZmNlhSbWVGTlpQTVpINzJxVjBSYk56NGN6RVUvNk5H?=
 =?utf-8?B?N0VBNFlQcUZFdUE2d0NNWXlmTmlwSlY3dTB1a1FkWUtzOHBGbEFzZnF6MUli?=
 =?utf-8?B?aFhzd25WUUs0VGZZNlN1dmV5ZFBuRkRueHNVcW1zNXhOR0lYbW5qRS9iUFpL?=
 =?utf-8?B?QVB3TGZFZyt2QVQwakNJbXptUWoyL2YydnZYYVYrSys1WTY2VGpiRDNjaGw2?=
 =?utf-8?B?RlpzUmpXNjJHT1pTSzIvVXByYlpjTmVLSDc5RjFYeGRxTEVITVIxVlpYZHVx?=
 =?utf-8?B?N2wzRUIvL1RaelpLcVpFRXV4T2Z3UE9RaG5MK2IwL1hlaUkyS2xzVlJxcTkx?=
 =?utf-8?B?TGQrSUpCV3liSkticngwdGQxU0E0KyttQTJzSTVGRlBIWWY1Q3pKU3lya2VM?=
 =?utf-8?B?TTE3WmViZ1Z4VWg4blN2R0ozVC9LQ1h4OExVUmlRM1V2U042ZFJFeXJjWTdQ?=
 =?utf-8?B?VGNRTnNsdTJpcytnSmNhRFZyVm51Wk5TWEZmVkdUTkNMK1lHbldVSWVuaUpt?=
 =?utf-8?B?d1hGWnhVMUJabThvL0FnTWJnazE0aTR6YUE0SkQ2SzUvc2FQL29TUi9FcDlj?=
 =?utf-8?B?YWxHMWhHemJ2dFR3VlVBV0tsWlJaS3h6UnNDVlpYaVA2VHB5bEl1QTFMdklW?=
 =?utf-8?B?Z3VkSm1oM1IzVXhFcGUyZGkyM1hsc2E2Q3JuSHFmOFh5cWkyekNWRlVCWDRU?=
 =?utf-8?B?NVJPRmt0Vi9Ea20wWEhWS3RmVC9MU0kvbUhVNFQ5SC9JWkdWaUZHU1hVZzJu?=
 =?utf-8?B?WkNGVFZCU0RpU1NmcHRLQ3kyRFFMZmFpQXFqWWpNNi8rOVlCd09NZG8yd3lJ?=
 =?utf-8?B?ZTBpdzJKMVY2RWRoekI0RnhpUnZNeGpsV0lBVk94THV1Y2V3ZG5xWGNyengv?=
 =?utf-8?B?S3diQXYvK1lDaUhMQ0tRYmlZQnB4ZkYvVjNxdEdsOXRzTFd5WTNtQWlrWjlm?=
 =?utf-8?B?aXltclFkM3FlVGxaa1ZMN0VaMTUyTjE2WTdtdEYvcmZlUWJpMlZ2NDVSQ2U3?=
 =?utf-8?B?YzFyalNBcS8zWVRqS3JGUy80VFFERDRYTkFKVWdhRWwwNkRzR2hQekdYbXB3?=
 =?utf-8?B?UjlBODlIY29tTm42WVAwMHVMa3NhUGdZVmptMXcvSUtFNHlkUWc4OUFkeW1h?=
 =?utf-8?B?NzRiS1RITWsxbytqQ1hUSW5rT01nQ2lXVzc3ZDh4Zlp5WVBRRThaS0lNcGVl?=
 =?utf-8?B?UmhtSVVYRkd4TjY4ZS9QekR2ME94T0RvSkNBeVZ3UnJkMWo1MTNwM0VLVmNV?=
 =?utf-8?B?a053dm5GWW5KVHh4T2JkN0l5c1NLQ2RWZkF4dVJac085cnhOUkdodkh0L1hC?=
 =?utf-8?B?UE9QNGg5Wm1CdEU4OTdleXNQZWlzcjBsdWk4d2ZxWEpONzlEOFhzN1ZRMy9t?=
 =?utf-8?B?ZENvNWUyWVNMZFF0d3B2V2N3NDJma1EwRkZpN0NhZkR0clRUQzB0WlpDcUQ4?=
 =?utf-8?B?V3EyR01FUmpGTStNSWRIbWJWL2VLampGck9vMkdxSzNTeFZHWG5TZWRxNUh6?=
 =?utf-8?B?ejZyd1g4UHdzcnUzcmdjakQxSkpJT28wT0NIeDFrQnBkUThXWVhkTEV3UVlr?=
 =?utf-8?B?QXJmRk53TTVDVWN2cyt0dEJ0L0p2UGQ0UlBEdHJ6TWlXeWVRNWgzNmx1VG85?=
 =?utf-8?B?RVk2YjMzbHRuR1ZaV3d0eWgvOEdBaHJlS1VnNEM5RXdWaUl4SzlsZjJObWV3?=
 =?utf-8?B?blk4VTVHc2dHNlBmc00wenZrT0k2MHZHRXpOYkttdzZMb0Y4c2Qrb005N3dC?=
 =?utf-8?B?YXlRcTRob1lZVDVJeitRVGtqMGp4OWU1bjZVRy8vbXpLdzN5ZWp6bjJoYWw4?=
 =?utf-8?B?aytKaVMydG1SejJFOFhLR0RaQWtJWGpBRUFtL2JQS2JZYkN0bkZlREFmY3c4?=
 =?utf-8?Q?zuSPYnnQnxhbYLLMWnPDt6wRb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53CCE0E3E0409942955116B5F1D78076@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 832e73bf-8a62-4732-dc20-08db64ecb0fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2023 11:13:14.7333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sBOFEQ/F+tPUTqv1MUZlLbIzXCTPnm+Jo9eBqG+TgSkTUY8Qcs3zMR8fQUyZdIda76J4NbvSF7N65MQFooJRCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gU2F0LCBKdW4gMDMsIDIwMjMgYXQgMTI6NTM6NDhBTSArMDIwMCwgQ2hyaXN0aWFuIExhbXBh
cnRlciB3cm90ZToNCj4gd2hlbiBicmluZ2luZyB1cCB0aGUgc3dpdGNoIG9uIGEgTmV0Z2VhciBX
TkRBUDY2MCwgSSBvYnNlcnZlZCB0aGF0DQo+IG5vIHRyYWZmaWMgZ290IHBhc3NlZCBmcm9tIHRo
ZSBSVEw4MzYzIHRvIHRoZSBldGhlcm5ldCBpbnRlcmZhY2UuLi4NCg0KQ291bGQgeW91IHNoYXJl
IHRoZSBjaGlwIElEL3ZlcnNpb24geW91IHJlYWQgb3V0IGZyb20gdGhpcyBSVEw4MzYzU0I/IEkg
aGF2ZW4ndA0Kc2VlbiB0aGlzIHBhcnQgbnVtYmVyIGJ1dCBtYXliZSBpdCdzIGVxdWl2YWxlbnQg
dG8gc29tZSBvdGhlciBrbm93biBzd2l0Y2guDQoNCj4gDQo+IFR1cm5zIG91dCwgdGhpcyB3YXMg
YmVjYXVzZSB0aGUgZHJvcHBlZCBjYXNlIGZvcg0KPiBSVEw4MzY1TUJfRElHSVRBTF9JTlRFUkZB
Q0VfU0VMRUNUX1JFRygwKSB0aGF0DQo+IGdvdCBkZWxldGVkIGJ5IGFjY2lkZW50Lg0KDQpDb3Vs
ZCB5b3Ugc2hvdyB3aGVyZSBleGFjdGx5IHRoaXMgbWFjcm8gaXMgY2FsbGVkIHdpdGggMCBhcyBh
biBhcmd1bWVudD8gQUZBSUNUDQp0aGlzIHBhdGNoIGRvZXNuJ3QgY2hhbmdlIGFueXRoaW5nLCBh
cyB0aGUgbWFjcm8gaXMgY2FsbGVkIGluIG9ubHkgb25lIHBsYWNlDQp3aXRoIHJ0bDgzNjVtYl9l
eHRpbnQ6OmlkIGFzIGFuIGFyZ3VtZW50LCBidXQgdGhlc2UgaWQgZmllbGRzIGFyZSBzdGF0aWNh
bGx5DQpwb3B1bGF0ZWQgaW4gcnRsODM2NW1iX2NoaXBfaW5mbyBhbmQgSSBvbmx5IHNlZSB2YWx1
ZXMgMSBvciAyIHRoZXJlLg0KDQpJZiB5b3UgYXJlIGludHJvZHVjaW5nIHN1cHBvcnQgZm9yIGEg
bmV3IHN3aXRjaCwgd2h5IG5vdCBqdXN0IHVzZSBhIHZhbHVlIG9mIDENCmluc3RlYWQ/IFRoZSBt
YWNybyB3aWxsIHRoZW4gbWFwIHRvIC4uLl9SRUcwIGFzIHlvdSBkZXNpcmUuDQoNCktpbmQgcmVn
YXJkcywNCkFsdmluDQoNCj4gDQo+IEZpeGVzOiBkMThiNTlmNDhiMzEgKCJuZXQ6IGRzYTogcmVh
bHRlazogcnRsODM2NW1iOiByZW5hbWUgZXh0cG9ydCB0byBleHRpbnQiKQ0KPiBTaWduZWQtb2Zm
LWJ5OiBDaHJpc3RpYW4gTGFtcGFydGVyIDxjaHVua2VleUBnbWFpbC5jb20+DQo+IC0tLQ0KPiBS
VEw4MzY1TUJfRElHSVRBTF9JTlRFUkZBQ0VfU0VMRUNUX1JFRygwKSBpcyBzaGFyZWQgYmV0d2Vl
bg0KPiBleHRpZjAgYW5kIGV4dGlmMS4gVGhlcmUncyBhbiBleHRyYQ0KPiBSVEw4MzY1TUJfRElH
SVRBTF9JTlRFUkZBQ0VfU0VMRUNUX01PREVfTUFTSyBsYXRlciBvbiB0byBkaWZmeQ0KPiB1cCBi
ZXR3ZWVuIGJpdHMgZm9yIGV4dGlmMCBhbmQgZXh0aWYxLg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0
L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgMyArKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgz
NjVtYi5jDQo+IGluZGV4IDZjMDBlNmRjYjE5My4uNTdhYTM5ZjViMzQxIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiArKysgYi9kcml2ZXJzL25l
dC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiBAQCAtMjA5LDcgKzIwOSw4IEBADQo+ICAjZGVm
aW5lIFJUTDgzNjVNQl9ESUdJVEFMX0lOVEVSRkFDRV9TRUxFQ1RfUkVHMAkJMHgxMzA1IC8qIEVY
VDEgKi8NCj4gICNkZWZpbmUgUlRMODM2NU1CX0RJR0lUQUxfSU5URVJGQUNFX1NFTEVDVF9SRUcx
CQkweDEzQzMgLyogRVhUMiAqLw0KPiAgI2RlZmluZSBSVEw4MzY1TUJfRElHSVRBTF9JTlRFUkZB
Q0VfU0VMRUNUX1JFRyhfZXh0aW50KSBcDQo+IC0JCSgoX2V4dGludCkgPT0gMSA/IFJUTDgzNjVN
Ql9ESUdJVEFMX0lOVEVSRkFDRV9TRUxFQ1RfUkVHMCA6IFwNCj4gKwkJKChfZXh0aW50KSA9PSAw
ID8gUlRMODM2NU1CX0RJR0lUQUxfSU5URVJGQUNFX1NFTEVDVF9SRUcwIDogXA0KPiArCQkgKF9l
eHRpbnQpID09IDEgPyBSVEw4MzY1TUJfRElHSVRBTF9JTlRFUkZBQ0VfU0VMRUNUX1JFRzAgOiBc
DQo+ICAJCSAoX2V4dGludCkgPT0gMiA/IFJUTDgzNjVNQl9ESUdJVEFMX0lOVEVSRkFDRV9TRUxF
Q1RfUkVHMSA6IFwNCj4gIAkJIDB4MCkNCj4gICNkZWZpbmUgICBSVEw4MzY1TUJfRElHSVRBTF9J
TlRFUkZBQ0VfU0VMRUNUX01PREVfTUFTSyhfZXh0aW50KSBcDQo+IC0tIA0KPiAyLjQwLjENCj4=

