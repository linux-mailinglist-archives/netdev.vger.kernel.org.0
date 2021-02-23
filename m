Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55C322630
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhBWHLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:11:38 -0500
Received: from mail-eopbgr10043.outbound.protection.outlook.com ([40.107.1.43]:63118
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231605AbhBWHL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 02:11:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIRuXM2LPE5+WNZk1Gnm5cUR8y9hkGRo49opPqqS8Sg35FNC2GhQAQE7lXyFC8jrsoV8Fkv1M8hdv62acZRhPutAGHl60iQs5SGocVoiuq1waKu8M3PMaFVGG39GNIRe9wn7Ci0uRL8rYbnOPSSWBc0agvEUPzsK/XAewdZZ7nYUdBTLAQxEzt5KSLZ11TltuPQDnMlfo69PW8fqQVeZZg+gLFqwrsqxowDj07iVuqbKU3ilrnLzv71q8raGbqTP4RlXTM7A9WqarkW5bcdf9mF8NO4Ts8CC2QH8b1Pzkg7lI/jrAEgJJbHGxGlvA4BuHofv0fyEaqFFTaIue2n6tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oc9x/g0QNUF1P2EVBmi+bvoD0uax8eK8r8D6+4x78Vo=;
 b=Q6rlUrt8MZzs1Q9dTa4ruvvizjlMTI6Ipkx+Ub0eWpbV40dqb3d8GdswOqEH6Zeq3bVRykPA4tk/tNO8hfD+RjNWgLHhNrKCYMklQHGFDQmh0KeJE2qzm8NHpHIWG6ayifAp/5YPHNgNCjtZYG1rj/2oKppi+92g5EF6A/8futWgibyN8LDAnkVOSQdTz5FvZtXnUvhsRnwb2gtj8UuYIAJ6fPwpDd/Mf3iA6a0iNYMw93ZdG8Y3EgRU2bgtFK0CvJ6NneTQJI1zIe/qkdLRojimW+bLEP/KqAiE0pe2Kuyq5PGwR1kJHfka1R73s2Yla3QGvGP11QQNkrrjcXyUuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oc9x/g0QNUF1P2EVBmi+bvoD0uax8eK8r8D6+4x78Vo=;
 b=YqiNY30aIdkvI9K1ytEalA9oNXEvjfDXWOKeKJn/aVzg3OUOYLMXgPmqiZCGLhjjGxeLpC1LPgw/8lsAqI2EEXJjGszq2zyWKK7+3uBHiYxG+JQn+xqfcReUbW6KNPVEPQNdeXPfIuBe0y+C2ZDQAllqQCIv+T9HoU2Pnf65Jv0=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5786.eurprd04.prod.outlook.com (2603:10a6:10:a8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 07:10:38 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Tue, 23 Feb 2021
 07:10:38 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V4 net 3/5] net: stmmac: fix dma physical address of
 descriptor when display ring
Thread-Topic: [PATCH V4 net 3/5] net: stmmac: fix dma physical address of
 descriptor when display ring
Thread-Index: AQHW+uft+uKr8xEA7U2SuzvYUkHYB6pLl6SAgBUjTZCAA/YCAIAAtYWg
Date:   Tue, 23 Feb 2021 07:10:38 +0000
Message-ID: <DB8PR04MB679566B923A571F8E8384278E6809@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
        <20210204112144.24163-4-qiangqing.zhang@nxp.com>
        <20210206122911.5037db4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB67956B6D0E9BCEC015E57A81E6839@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210222114616.4eaac47c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222114616.4eaac47c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1df4fd7-9978-413d-dab2-08d8d7ca1f8f
x-ms-traffictypediagnostic: DB8PR04MB5786:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5786682477044B8F4356F2E5E6809@DB8PR04MB5786.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /4fnZqWA7zrwfYYQKBFOCmvDTWCSpeba5bZZPS13Qtdfp6PeXO38NecuZpTmLfjGy5L1WE2VICRePFRI1sHkY5U9Jm3rTsoB6GiFbkUEwzJ5tGPz/fuXyv84d/9pc0WVl+QeBAxLZSJlOJcjfCsWTuNKFyP7sgwUssdIUTDgnxw/C3VJh+4dB5bXXfhrtuY+FJwyTcgUoACucVBV8xwrN2xLJwJNnIYu9ijFVQkA8Uddk87ExnYVUMynyus749qdR4Wyxew/YJgj6R1H59pzT/E9XaI4K2CzK0i9+IB29QqqnbN2HP/yDxL+88qkYMzgZN2IOdgL9tUv/5eMuvbmPGDvzp/m1pCBgzp+N7juxVuA79qBMWItof3MWDAfMRBHHZHDzeAlyb0Lw1rvE81zjpcMkT9Mj5VTTqiq4XlOO/7h/8tpYtK5J2wKcdCga9IRxSN8FfNYJY2YCCctkiyVjFSYQ/3nZXooB6JW3S3sPyYXzmaSz7AFpM4Vv+FwmPnroagU3dTY2dc/skE5Um/ceg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(8676002)(33656002)(2906002)(52536014)(8936002)(66446008)(76116006)(55016002)(9686003)(316002)(4326008)(66946007)(26005)(6506007)(478600001)(5660300002)(6916009)(186003)(86362001)(53546011)(71200400001)(7696005)(66476007)(83380400001)(66556008)(64756008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?bVZzdytEUkJSdlVHU2JPcjM3OTJVemlrbENpcnoyR1pyNU5IKzZsbW9NZUkz?=
 =?gb2312?B?bHFCK2x1WlJxc3d2TisxK2psUzBacmJ3bytrMHkzaGpCRkE3QmdRcTg2V1Bo?=
 =?gb2312?B?eXNOQXlacm8rS1ZBQjJFc2RiTk9LMTI0dDlTUUxEWEpRSDhubGRYWGFWamRF?=
 =?gb2312?B?QXBPaUR4WUZrQnU3d3VDZWZnNUxNa3c1cVh6dWYxUzQ4KzZaSDVUL21aNmt5?=
 =?gb2312?B?UGdHdmlWYWhCRUlYaXEwZTdvcDAwejRoQjllMjRDWXRGZHZ6VS84TWczSzdZ?=
 =?gb2312?B?VzQvQmsyNG1RVEZCOUNxYWcwUFVhbjBabEV1SnVzUWpYMmpYQmEwU0hjVHdh?=
 =?gb2312?B?eFBBWElPQ3lvYlZTYnpYSnQyS2FMYjdSN0VJT3RXV1pOZ21KSUJBWDVkNXl0?=
 =?gb2312?B?djVLSU5CTmZyc2ZFNWtMOGFvS1RhVFpuR3J6ZFVsMWpPRlFHRDByZXhKQS9t?=
 =?gb2312?B?ZG5BZEszTnhIWEFHMGZLdlZrUFg5TDFrSXl2WTMyZjRTdEhNSE9FQ0NZTkQ1?=
 =?gb2312?B?N2N5RnZURHpxK2V2VWhhOVRYVS9xT1pDaWNYWWZFTk1mNnJodUVORUFISC9z?=
 =?gb2312?B?TEpwVFZpZDRzR3FXZnUzaFAvTHpVcjNkVWxSVmRPT044c01FYVZDOFRncHQz?=
 =?gb2312?B?S28xM1VOV0NZalViSjZIZEpJQnZtZDBMTll2WjRYWEZBYlJHUFc4cm9Dd29z?=
 =?gb2312?B?cWgrVUZRRnd6ZytISFoyMGx0eVlqUEcxV2w4VHR0L0lBeW16Zmtlc2Fza3B2?=
 =?gb2312?B?YitDRmVrb1B2dCtFaFMxRkZ6U0JvS1JSamEzbU1iTm4xV3lrSnVieHVsbWlX?=
 =?gb2312?B?ZkJHclB2Q3FiREZFS2ZLV1RGckZOdHR4RGVCQ1NEZm14YTNzTHo5aGJLcjNR?=
 =?gb2312?B?WUs5WEJhT0VRbzRGa0lFeTdNZEdqTk51M3dFd0EraVlTdlFUY2Z1aXJNcEc0?=
 =?gb2312?B?aklpNjVVQ1BWM21GQmxSNDIza2JiL2sxemRJWitBajJMNVNaUGtTMVJQMzRC?=
 =?gb2312?B?a1dVN24zTlZ5THc2TDFqUlMyUTJCT0ZkS1FoNCtzNzJlNHowbGZKamhnTzAv?=
 =?gb2312?B?dzlhWGJXdE90bXJmSzJOT3Z5am5CdWFoQnpmNGQ0OXhRM1FiYVRDMHJoOTN3?=
 =?gb2312?B?bi9pb0RLeWNIVUxGN0xvSGM4eThrTnhGMGszTUFMNS9aenpPNXA3OUw4KzEr?=
 =?gb2312?B?OUROb0ozaUxMN3d1STZITFg3VWUyTnUwWVVJaDF4OGl1alRGU21pckNMVW5H?=
 =?gb2312?B?Wmtac3ppRFQxbHZlMGlOejZoN0c5MmNtdFI4M0xUMnlaQTFSSFlvQ1M4N0N1?=
 =?gb2312?B?V3hXTUpIWUNBbkNKSjBoTkh5eUtMUklEcUVscnplMjYyK2hGSEtac2F0QTFB?=
 =?gb2312?B?N3I3aTk5UGxRU2hBWlplNTJiY0lqWUE5NkpBemxLWFJ5djBCQkp6RzZJV25h?=
 =?gb2312?B?OVBRRCs4cXlPL3VGTlUwQlAxSlpJeWxjWlNqVmU2T0NtQ3MxOHB3VGNuaFFC?=
 =?gb2312?B?TnMvZksvN01VTDdUYXdNcHhGd3FMWjNoRGdxZTJkYklnSWk1OXgzQ2NlTnVO?=
 =?gb2312?B?SHRKZnRUeHFoR3VwNVQzQ1VJQ0wrNkR5Vk9Zd0g3U0k1RTZEanc0eVNrMmRz?=
 =?gb2312?B?YlQxdWR0WklncFNoVzdRY0JxRUl5c0t6ajMxd0NwUStyNVlRNUZyUWJhNTJO?=
 =?gb2312?B?NVoyYW93dWdzbEgvaFBTL0d3a1Q1bkc2MEczeVZsRUk3SGlQMFNFMkJtbUc2?=
 =?gb2312?Q?TALxlQP0Gk2fpvyHKmZBKNEVReSW5djESPloyqJ?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1df4fd7-9978-413d-dab2-08d8d7ca1f8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 07:10:38.4448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4jGm/0YnOdyP/ma7i4htF//TGvBvQMSCqorjzavwLH4Bvd5MpY8I3JNJNzFeij5AaEA8PCfXSGRE5hAlgKqtLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5786
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jLUwjIzyNUgMzo0Ng0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0Bz
dC5jb207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gZGwtbGludXgt
aW14IDxsaW51eC1pbXhAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWNCBuZXQgMy81
XSBuZXQ6IHN0bW1hYzogZml4IGRtYSBwaHlzaWNhbCBhZGRyZXNzIG9mDQo+IGRlc2NyaXB0b3Ig
d2hlbiBkaXNwbGF5IHJpbmcNCj4gDQo+IE9uIFNhdCwgMjAgRmViIDIwMjEgMDc6NDM6MzMgKzAw
MDAgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+ID4gPiAgCXByX2luZm8oIiVzIGRlc2NyaXB0b3Ig
cmluZzpcbiIsIHJ4ID8gIlJYIiA6ICJUWCIpOw0KPiA+ID4gPg0KPiA+ID4gPiAgCWZvciAoaSA9
IDA7IGkgPCBzaXplOyBpKyspIHsNCj4gPiA+ID4gLQkJcHJfaW5mbygiJTAzZCBbMHgleF06IDB4
JXggMHgleCAweCV4IDB4JXhcbiIsDQo+ID4gPiA+IC0JCQlpLCAodW5zaWduZWQgaW50KXZpcnRf
dG9fcGh5cyhwKSwNCj4gPiA+ID4gKwkJcHJfaW5mbygiJTAzZCBbMHglbGx4XTogMHgleCAweCV4
IDB4JXggMHgleFxuIiwNCj4gPiA+ID4gKwkJCWksICh1bnNpZ25lZCBsb25nIGxvbmcpKGRtYV9y
eF9waHkgKyBpICogZGVzY19zaXplKSwNCj4gPiA+ID4gIAkJCWxlMzJfdG9fY3B1KHAtPmRlczAp
LCBsZTMyX3RvX2NwdShwLT5kZXMxKSwNCj4gPiA+ID4gIAkJCWxlMzJfdG9fY3B1KHAtPmRlczIp
LCBsZTMyX3RvX2NwdShwLT5kZXMzKSk7DQo+ID4gPiA+ICAJCXArKzsNCj4gPiA+DQo+ID4gPiBX
aHkgZG8geW91IHBhc3MgdGhlIGRlc2Nfc2l6ZSBpbj8gVGhlIHZpcnQgbWVtb3J5IHBvaW50ZXIg
aXMNCj4gPiA+IGluY3JlbWVudGVkIGJ5DQo+ID4gPiBzaXplb2YoKnApIHN1cmVseQ0KPiA+ID4N
Cj4gPiA+IAlkbWFfYWRkciArIGkgKiBzaXplb2YoKnApDQo+ID4NCj4gPiBJIHRoaW5rIHdlIGNh
bid0IHVzZSBzaXplb2YoKnApLCBhcyB3aGVuIGRpc3BsYXkgZGVzY3JpcHRvciwgb25seSBkbyAi
DQo+ID4gc3RydWN0IGRtYV9kZXNjICpwID0gKHN0cnVjdCBkbWFfZGVzYyAqKWhlYWQ7IiwgYnV0
IGRyaXZlciBjYW4gcGFzcw0KPiA+ICJzdHJ1Y3QgZG1hX2Rlc2MiLCAiIHN0cnVjdCBkbWFfZWRl
c2MiIG9yICIgc3RydWN0IGRtYV9leHRlbmRlZF9kZXNjIiwNCj4gDQo+IExvb2tzIGxpa2Ugc29t
ZSBvZiB0aGUgZnVuY3Rpb25zIHlvdSBjaGFuZ2UgYWxyZWFkeSB0cnkgdG8gcGljayB0aGUgcmln
aHQgdHlwZS4NCj4gV2hpY2ggb25lIGlzIHByb2JsZW1hdGljPw0KDQpZZXMsIHNvbWUgZnVuY3Rp
b25zIGhhdmUgcGlja2VkIHRoZSByaWdodCB0eXBlOg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvc3Rt
aWNyby9zdG1tYWMvZW5oX2Rlc2MuYyAtPiBlbmhfZGVzY19kaXNwbGF5X3JpbmcoKQ0KZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvbm9ybV9kZXNjLmMgLT4gbmRlc2NfZGlzcGxh
eV9yaW5nKCkNCg0KdGhlIHByb2JsZW1hdGljIG9uZSBpczoNCmRyaXZlcnMvbmV0L2V0aGVybmV0
L3N0bWljcm8vc3RtbWFjL2R3bWFjNF9kZXNjcy5jIC0+IGR3bWFjNF9kaXNwbGF5X3JpbmcoKQ0K
DQpTaW5jZSB0aGUgY2FsbGJhY2sgZm9ybWF0IGlzIHRoZSBzYW1lIGZvciB0aGVtLCBhbmQgdXNl
ZCBmcm9tIHN0bW1hY19tYWluLmMgaW4gdGhlIHNhbWUgd2F5Lg0KZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc3RtaWNyby9zdG1tYWMvaHdpZi5oIC0+IHZvaWQgKCpkaXNwbGF5X3JpbmcpKHZvaWQgKmhl
YWQsIHVuc2lnbmVkIGludCBzaXplLCBib29sIHJ4KTsNCg0KU28gSSBkZWNpZGUgdG8gbW9kaWZ5
IHRoZW0gYXMgYSB3aG9sZSB0byBhdm9pZCBzZXBhcmF0ZSB0aGVtIGFzIGRpZmZlcmVudCBmb3Jt
YXQgd2hpY2ggd291bGQgaW50cm9kdWNlIG1vcmUgcmVkdW5kYW50IGNvZGUuIElzIGl0IHJlYXNv
bmFibGU/DQoNCj4gPiBzbyBpdCdzIG5lY2Vzc2FyeSB0byBwYXNzIGRlc2Nfc2l6ZSB0byBjb21w
YXRpYmxlIGFsbCBjYXNlcy4NCj4gDQo+IEJ1dCB5b3Ugc3RpbGwgaW5jcmVtZW50IHRoZSB0aGUg
Vk1BIHBvaW50ZXIgKCdwJyBpbiB0aGUgcXVvdGUgYWJvdmUpIGJ1dCBpdCdzIHNpemUsDQo+IHNv
IGhvdyBpcyB0aGF0IGNvcnJlY3QgaWYgdGhlIERNQSBhZGRyIG5lZWRzIGEgc3BlY2lhbCBzaXpl
IGluY3JlbWVudD8NCg0KWWVzLCB5b3UgYXJlIHJpZ2h0LiBJdCBpbmRlZWQgYSBwcm9ibGVtLiBT
ZWVtcyBkd21hYzRfZGlzcGxheV9yaW5nKCkgZnVuY3Rpb24gaGFzIG5vdCBzdXBwb3J0ZWQgZGlm
ZmVyZW50IGRlc2MgZm9ybWF0IHdlbGwuDQpETUEgcGh5IGFkZHJlc3MgaXMganVzdCBvbmUgb2Yg
aXRzIHByb2JsZW0uIEkgd2lsbCBmaXggaXQgdG9nZXRoZXIuIFRoYW5rcy4NCg0KQmVzdCBSZWdh
cmRzLA0KSm9ha2ltIFpoYW5nDQoNCg==
