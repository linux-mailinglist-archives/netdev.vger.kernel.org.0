Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465AB41B213
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241232AbhI1O3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:29:19 -0400
Received: from mail-dm6nam11on2128.outbound.protection.outlook.com ([40.107.223.128]:23008
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241016AbhI1O3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 10:29:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNsK7Q/oq+8AM8xDcprZniT2v4fxHSfXjHRsk7exPt4kAOebsmbZJFY9g/l5tu6nIDLEXD2e7KJPXA5YAOtA9eAan9D1AC0h2Tt7KV1dcn5z4c8PPZaH6GBxGwNgHhABWrZvXFvokoObTgXgtj0TY36oTwC7rUeRj/deZ6xHOZXSRvZzT4Z9LO9snVcHcisULSesntIwh6/cEr5RscVsI55vnJfoXXhrzTo+dBCZteAzb16345eKU5BiDcARraOb4Y/L9/eCrNL22PHW0tg8fI+dGN9FdiXeBlxjdtOFoaz0ih+61pQLdMHlXtX5GJveoNbfMP2UzUHq0M3KLL2rIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4EypWeujxQu7D8f1vPoGFUGmAQ+OZolIispx3LyVzeQ=;
 b=jpX3vC7hs5O6FLjZFxKihyKphODu3Wm63HWKtF10P8h453XBBMXSVRZJMBWvEivODY7RSSOOTnVEstlhtM34qzki4vP9qZQKj6UFDAgEEN9YhyFWAj2TEv4ptk7l2TzVmlgk2/JZ+N1RlrVlMH4Vn1dgSPPua8QN/I2Wcid1hI3apvtN3RQLiE/a9IKwTH0qUb746Rax/jUDyA7waaEMqhl8Di+QXBF1ZTivSmPXtbGTIPdZLHNd8CXh7kzw6BCaWzhzrKTmaoZfCKULCBng8p2l4CrC9tt9NtmYO3wsnrP1s0CD7gWxxu4xSzJk5Rb9lXfZ0axuP59KDyob2KFzxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EypWeujxQu7D8f1vPoGFUGmAQ+OZolIispx3LyVzeQ=;
 b=GP/b8VyKVprbR0mud4bJxqbeLlr1OOF9zs/zHDp1tqWvbA5BV4W/evKXbaFxbQskXXSSWTBL59vKcn8H6JT1HEqSNsBgeTVNvjGBoiYtte0ie7w3m+hvJrYcGef8fgTUdxr1195GpXrEa5ou0e6IRSsNL2th9c9smz/piwfXfgU=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by CH2PR13MB3800.namprd13.prod.outlook.com (2603:10b6:610:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9; Tue, 28 Sep
 2021 14:27:33 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::185b:505d:b35c:a3a2]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::185b:505d:b35c:a3a2%6]) with mapi id 15.20.4566.014; Tue, 28 Sep 2021
 14:27:33 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "bfields@fieldses.org" <bfields@fieldses.org>
CC:     "neilb@suse.com" <neilb@suse.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wanghai38@huawei.com" <wanghai38@huawei.com>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "kolga@netapp.com" <kolga@netapp.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Thread-Topic: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Thread-Index: AQHXtBciMSJq8UTGIk29qdNL+Xnf4qu5ccKAgAAFewCAAAQtAIAAA34AgAAC2oA=
Date:   Tue, 28 Sep 2021 14:27:33 +0000
Message-ID: <cc92411f242290b85aa232e7220027b875942f30.camel@hammerspace.com>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
         <20210928031440.2222303-3-wanghai38@huawei.com>
         <a845b544c6592e58feeaff3be9271a717f53b383.camel@hammerspace.com>
         <20210928134952.GA25415@fieldses.org>
         <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
         <20210928141718.GC25415@fieldses.org>
In-Reply-To: <20210928141718.GC25415@fieldses.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none
 header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 779f8122-2e0a-42b2-c3f6-08d9828c1c95
x-ms-traffictypediagnostic: CH2PR13MB3800:
x-microsoft-antispam-prvs: <CH2PR13MB380076025FB707F8F66F4C55B8A89@CH2PR13MB3800.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OsnSEpr6Dts9ur+HimyD3hCr7OUi40BWJHa8rDxy9USwmgcNqzlvQTT+LwbxZvHh1ZqHc7fOiV+c4RNUsc8F9/7wL8zZZj4830lQsGFxSkaCul5180LqYzbKoUzHDgcENCSlX7ndk1TyBre8v89GF5K1k539GeoBRoodi+pvf+p1nqGyI0mWP7VhjafJznomA7lA1C/ohwx03BYE+N7/SnTXLsQDQTplNqeKUHVFVMPgZXdSfAb9DBetAV5CqE4MZF3V/9kdH4fezGDo1uCRl+e60ucD6hVSDl7Is+teNaJHFj/XkqNfVKFMJ5NiMXNK57KpEUfT47gm3aIT6iYefqvTMVYeMgiLXpDfmN8TrolOO2cF9algBEOb35I3AVeo3KftnxBhbtynM93GPufy2jkDWj79CiK9/HsUJ6eb+4pbUSF5OwmyGoemmJe7Z6sg7ohQGuZt/dVhmzAexze+faTtA1eKONoq5y0dr9OZLV1Q7979f/7FG3/tLvvktAGzUAR1TneFv+ieaRJ9L4lrP9MPrHDxz17e9XsppaWwZKwQXze5J3x59+CsOs6mpM63PfLZmo1A3z6IrytnURSUgDFMDoBOjYKUZONdR6kho4StIN+4JXOnWGxG/YjdpCvWqroOpfydlNfMJiyHte3Ik5HX05hx6H+7N3eXe4UAf9WWsVcl4dy59H107mm6j4+5wftn9qnvWL2EGBGzqHhw6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(26005)(54906003)(7416002)(6506007)(71200400001)(8936002)(508600001)(36756003)(186003)(6486002)(38070700005)(66556008)(6512007)(38100700002)(8676002)(122000001)(6916009)(5660300002)(86362001)(2906002)(76116006)(4326008)(66446008)(66476007)(64756008)(66946007)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWFKdDFvdFJyZ0NscVhNVUVncjNyNGx3MzY4dkJydHRaWjhaOHlZOWRlUXdE?=
 =?utf-8?B?bWM0VHhaQ3QzRlRDMGxwV1FpWXBlVDVlYVFmanRjK29LTUxTUDA5VWRTbEh1?=
 =?utf-8?B?TDdqOENKbU9GRmZ6bmxJdnQyVGVqMWt6b3pYSFF3R2FtSlJYa2NCQXdXSng3?=
 =?utf-8?B?Ukd6MERUNVlWTTdwTlZhdnIyemhFRSszWmZZd0ZsSE5RbjgvVGpQMjR3dkw5?=
 =?utf-8?B?VlhzMU1FaERPL3B3NWFxNTlFK1pWSzlvSS9uUTFsNk80SzJObDdGV0JpYW1T?=
 =?utf-8?B?N0QvZ1RHd3BnWEozdVRxbkIrQjA5Z1J4ckwxaTBCcWloUHN1M3k1cWZiL2xL?=
 =?utf-8?B?WkhvS3JwRURRYzNIV3dQSVUvZXZYL0hWMTJPd3hEUDVZOWJyWDltUkswdkVG?=
 =?utf-8?B?cnZ0Sm1jWDBXQkNYcFpIbldWUEdBemlhbE5pRjBnZkNSa0RKTjEyN3YrRE5G?=
 =?utf-8?B?dHZ4Rk5hRXZmTlJSR1cvSjVMS01Qcm1RRThTeEoyaUpMRmJuUXpNbWh0N3BB?=
 =?utf-8?B?YS9ZNXIxN0dPWFdRKzRLN1dMeHNpRVJoWi9DOXY0RUt5SWlOaXYwQlFsamJO?=
 =?utf-8?B?bjc5RTVmZTVvVjdpWkhoTDd3T1daejc3TmxWWEsvbHFvRlNQVkxQSkNpZ2Zm?=
 =?utf-8?B?dERJZnJHTzAvUndRWnZkanB0RWdzRWFNTWw3S3prbitKSTZ1T1FPL2ZvQms4?=
 =?utf-8?B?WlRGVnRTaGhLYUVGazhvaDNNaTlZd2hmdVl6WmFGZlNPRER1VmRUc3F2bTIv?=
 =?utf-8?B?N1pwdytaOWhIV1pvWmlMd1BucTdHem4wakdBRU8xV1U2VytBUFZHY1AwZEtr?=
 =?utf-8?B?ckEwMVYwYi9ydmV5RElmbWpXZW53cFpwaUFSd2psaDJHdnh1bkJkN1JIQjlS?=
 =?utf-8?B?SjJzOFdVUjc4WXZTbDI4TmpKZituM01Wa2E2UnZFZFJtUFFQelR4YmMrZUNY?=
 =?utf-8?B?UU5LM04vRG53OXl3K09PYktNeUZnaDE5VGdFL0lOSnlkVXgrZU5FYUhlN0Zy?=
 =?utf-8?B?b294ek0zTy9lUjNYWXdWRHBVZ0h6Mlg4bUpYd1Y3NTVXU3dQcUlmQVhFNCtF?=
 =?utf-8?B?dFRjeXFlT0xQWUduRlR0TUg1ZGk5bjlIYXkxRGcyR1I1MWpYWjA4RG5oZkpB?=
 =?utf-8?B?MTcrVHo3NjFkbXo0a2hFWnZsQVJ0OHpZcGVDL1BxV2c4U2pWTHlXL2Uya0d4?=
 =?utf-8?B?MVZSQ0tvb2NzZzdyeTNiOFRmL3hKQ0hXdkx0QmlseURNcVNkYWdZM3Z0U2Yv?=
 =?utf-8?B?YlVjMHlHTG9jU00vV1RYV1dmSjlZVmhzTTVGc2Z3djBpWGlxWkh1blNUbmN3?=
 =?utf-8?B?MU5qcVZ3MzNNLzEvTi9BRHdGT3RzeEEvUVlBNVZHUFI3WDhFOE9EZjN4WDkz?=
 =?utf-8?B?dlhrSFByVVVNOUN2Yzg5cHR3dGtLSUNSMkxPa1l6OWVoWkF1WmNuYzAvR1hh?=
 =?utf-8?B?ZC8yRXJiTFAxcGtENkgvU3lLNU0wU2laWS9uaVM5YkEzanVTN2hVa2VTL2VI?=
 =?utf-8?B?RkdzaEp1OHdQaElpdVJWRlQxdnZuelVrSWlycklKQ3hGZ3FpbE9rWTJidGFS?=
 =?utf-8?B?SzZ6NmlyUHpUTGRXdzh3NVlrK1JsRW92emZWZ0hGR0NwMlY4bFZjbm96RGNR?=
 =?utf-8?B?NzBnQ0FTbEovSWhsMFhUWVlnVUJiZVg3MVN0TnVmMktsamR1Ni9qYlcySVBv?=
 =?utf-8?B?QnZFVTdxZ0JERUVUOWZsYTdnbFgrSnl2YnA1V3BoYmorZ0JXbWdlZnlUUnJS?=
 =?utf-8?Q?lr5ZceMfeaFI2hxh7Bm7mwWXbRdpE9dxUy3ni/w?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBF17693396C594FA9F5D5352FEF4645@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779f8122-2e0a-42b2-c3f6-08d9828c1c95
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 14:27:33.4433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIFrwjtfOs2HSKNd4KMsBmHz/tqfRJj2s8DVpB3l3WOoiIrfizozgtceEaxZfAPNt4DvXO2rwWCcVn2wOJUxvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA5LTI4IGF0IDEwOjE3IC0wNDAwLCBiZmllbGRzQGZpZWxkc2VzLm9yZyB3
cm90ZToNCj4gT24gVHVlLCBTZXAgMjgsIDIwMjEgYXQgMDI6MDQ6NDlQTSArMDAwMCwgVHJvbmQg
TXlrbGVidXN0IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMS0wOS0yOCBhdCAwOTo0OSAtMDQwMCwg
YmZpZWxkc0BmaWVsZHNlcy5vcmfCoHdyb3RlOg0KPiA+ID4gT24gVHVlLCBTZXAgMjgsIDIwMjEg
YXQgMDE6MzA6MTdQTSArMDAwMCwgVHJvbmQgTXlrbGVidXN0IHdyb3RlOg0KPiA+ID4gPiBPbiBU
dWUsIDIwMjEtMDktMjggYXQgMTE6MTQgKzA4MDAsIFdhbmcgSGFpIHdyb3RlOg0KPiA+ID4gPiA+
IFdoZW4gdXNlLWdzcy1wcm94eSBpcyBzZXQgdG8gMSwgd3JpdGVfZ3NzcCgpIGNyZWF0ZXMgYSBy
cGMNCj4gPiA+ID4gPiBjbGllbnQNCj4gPiA+ID4gPiBpbg0KPiA+ID4gPiA+IGdzc3BfcnBjX2Ny
ZWF0ZSgpLCB0aGlzIGluY3JlYXNlcyB0aGUgbmV0bnMgcmVmY291bnQgYnkgMiwNCj4gPiA+ID4g
PiB0aGVzZQ0KPiA+ID4gPiA+IHJlZmNvdW50cyBhcmUgc3VwcG9zZWQgdG8gYmUgcmVsZWFzZWQg
aW4NCj4gPiA+ID4gPiBycGNzZWNfZ3NzX2V4aXRfbmV0KCksDQo+ID4gPiA+ID4gYnV0DQo+ID4g
PiA+ID4gaXQNCj4gPiA+ID4gPiB3aWxsIG5ldmVyIGhhcHBlbiBiZWNhdXNlIHJwY3NlY19nc3Nf
ZXhpdF9uZXQoKSBpcyB0cmlnZ2VyZWQNCj4gPiA+ID4gPiBvbmx5DQo+ID4gPiA+ID4gd2hlbg0K
PiA+ID4gPiA+IHRoZSBuZXRucyByZWZjb3VudCBnZXRzIHRvIDAsIHNwZWNpZmljYWxseToNCj4g
PiA+ID4gPiDCoMKgwqAgcmVmY291bnQ9MCAtPiBjbGVhbnVwX25ldCgpIC0+IG9wc19leGl0X2xp
c3QgLT4NCj4gPiA+ID4gPiBycGNzZWNfZ3NzX2V4aXRfbmV0DQo+ID4gPiA+ID4gSXQgaXMgYSBk
ZWFkbG9jayBzaXR1YXRpb24gaGVyZSwgcmVmY291bnQgd2lsbCBuZXZlciBnZXQgdG8gMA0KPiA+
ID4gPiA+IHVubGVzcw0KPiA+ID4gPiA+IHJwY3NlY19nc3NfZXhpdF9uZXQoKSBpcyBjYWxsZWQu
IFNvLCBpbiB0aGlzIGNhc2UsIHRoZSBuZXRucw0KPiA+ID4gPiA+IHJlZmNvdW50DQo+ID4gPiA+
ID4gc2hvdWxkIG5vdCBiZSBpbmNyZWFzZWQuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSW4gdGhp
cyBjYXNlLCB4cHJ0IHdpbGwgdGFrZSBhIG5ldG5zIHJlZmNvdW50IHdoaWNoIGlzIG5vdA0KPiA+
ID4gPiA+IHN1cHBvc2VkDQo+ID4gPiA+ID4gdG8gYmUgdGFrZW4uIEFkZCBhIG5ldyBmbGFnIHRv
IHJwY19jcmVhdGVfYXJncyBjYWxsZWQNCj4gPiA+ID4gPiBSUENfQ0xOVF9DUkVBVEVfTk9fTkVU
X1JFRiBmb3Igbm90IGluY3JlYXNpbmcgdGhlIG5ldG5zDQo+ID4gPiA+ID4gcmVmY291bnQuDQo+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gSXQgaXMgc2FmZSBub3QgdG8gaG9sZCB0aGUgbmV0bnMgcmVm
Y291bnQsIGJlY2F1c2Ugd2hlbg0KPiA+ID4gPiA+IGNsZWFudXBfbmV0KCksIGl0DQo+ID4gPiA+
ID4gd2lsbCBob2xkIHRoZSBnc3NwX2xvY2sgYW5kIHRoZW4gc2h1dCBkb3duIHRoZSBycGMgY2xp
ZW50DQo+ID4gPiA+ID4gc3luY2hyb25vdXNseS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiANCj4g
PiA+ID4gSSBkb24ndCBsaWtlIHRoaXMgc29sdXRpb24gYXQgYWxsLiBBZGRpbmcgdGhpcyBraW5k
IG9mIGZsYWcgaXMNCj4gPiA+ID4gZ29pbmcgdG8NCj4gPiA+ID4gbGVhZCB0byBwcm9ibGVtcyBk
b3duIHRoZSByb2FkLg0KPiA+ID4gPiANCj4gPiA+ID4gSXMgdGhlcmUgYW55IHJlYXNvbiB3aGF0
c29ldmVyIHdoeSB3ZSBuZWVkIHRoaXMgUlBDIGNsaWVudCB0bw0KPiA+ID4gPiBleGlzdA0KPiA+
ID4gPiB3aGVuIHRoZXJlIGlzIG5vIGFjdGl2ZSBrbmZzZCBzZXJ2ZXI/IElPVzogSXMgdGhlcmUg
YW55IHJlYXNvbg0KPiA+ID4gPiB3aHkNCj4gPiA+ID4gd2UNCj4gPiA+ID4gc2hvdWxkbid0IGRl
ZmVyIGNyZWF0aW5nIHRoaXMgUlBDIGNsaWVudCBmb3Igd2hlbiBrbmZzZCBzdGFydHMNCj4gPiA+
ID4gdXANCj4gPiA+ID4gaW4NCj4gPiA+ID4gdGhpcyBuZXQgbmFtZXNwYWNlLCBhbmQgd2h5IHdl
IGNhbid0IHNodXQgaXQgZG93biB3aGVuIGtuZnNkDQo+ID4gPiA+IHNodXRzDQo+ID4gPiA+IGRv
d24/DQo+ID4gPiANCj4gPiA+IFRoZSBycGMgY3JlYXRlIGlzIGRvbmUgaW4gdGhlIGNvbnRleHQg
b2YgdGhlIHByb2Nlc3MgdGhhdCB3cml0ZXMNCj4gPiA+IHRvDQo+ID4gPiAvcHJvYy9uZXQvcnBj
L3VzZS1nc3MtcHJveHkgdG8gZ2V0IHRoZSByaWdodCBuYW1lc3BhY2VzLsKgIEkgZG9uJ3QNCj4g
PiA+IGtub3cNCj4gPiA+IGhvdyBoYXJkIGl0IHdvdWxkIGJlIGNhcHR1cmUgdGhhdCBpbmZvcm1h
dGlvbiBmb3IgYSBsYXRlciBjcmVhdGUuDQo+ID4gPiANCj4gPiANCj4gPiBzdmNhdXRoX2dzc19w
cm94eV9pbml0KCkgdXNlcyB0aGUgbmV0IG5hbWVzcGFjZSBTVkNfTkVUKHJxc3RwKQ0KPiA+IChp
LmUuDQo+ID4gdGhlIGtuZnNkIG5hbWVzcGFjZSkgaW4gdGhlIGNhbGwgdG8NCj4gPiBnc3NwX2Fj
Y2VwdF9zZWNfY29udGV4dF91cGNhbGwoKS4NCj4gPiANCj4gPiBJT1c6IHRoZSBuZXQgbmFtZXNw
YWNlIHVzZWQgaW4gdGhlIGNhbGwgdG8gZmluZCB0aGUgUlBDIGNsaWVudCBpcw0KPiA+IHRoZQ0K
PiA+IG9uZSBzZXQgdXAgYnkga25mc2QsIGFuZCBzbyBpZiB1c2UtZ3NzLXByb3h5IHdhcyBzZXQg
aW4gYSBkaWZmZXJlbnQNCj4gPiBuYW1lc3BhY2UgdGhhbiB0aGUgb25lIHVzZWQgYnkga25mc2Qs
IHRoZW4gaXQgd29uJ3QgYmUgZm91bmQuDQo+IA0KPiBSaWdodC7CoCBJZiB5b3UndmUgZ290IG11
bHRpcGxlIGNvbnRhaW5lcnMsIHlvdSBkb24ndCB3YW50IHRvIGZpbmQgYQ0KPiBnc3MtcHJveHkg
ZnJvbSBhIGRpZmZlcmVudCBjb250YWluZXIuDQo+IA0KDQpFeGFjdGx5LiBTbyB0aGVyZSBpcyBu
byBuYW1lc3BhY2UgY29udGV4dCB0byBjYXB0dXJlIGluIHRoZSBSUEMgY2xpZW50DQpvdGhlciB0
aGFuIHdoYXQncyBhbHJlYWR5IGluIGtuZnNkLg0KVGhlIFJQQyBjbGllbnQgZG9lc24ndCBjYXB0
dXJlIGFueSBvdGhlciBwcm9jZXNzIGNvbnRleHQuIEl0IGNhbiBjYWNoZQ0KYSB1c2VyIGNyZWQg
aW4gb3JkZXIgdG8gY2FwdHVyZSB0aGUgdXNlciBuYW1lc3BhY2UsIGJ1dCB0aGF0DQppbmZvcm1h
dGlvbiBhcHBlYXJzIHRvIGJlIHVudXNlZCBieSB0aGlzIGdzc2QgUlBDIGNsaWVudC4NCg0KU28g
SSdsbCByZXBlYXQgbXkgcXVlc3Rpb246IFdoeSBjYW4ndCB3ZSBzZXQgdGhpcyBnc3NkIFJQQyBj
bGllbnQgdXAgYXQNCmtuZnNkIHN0YXJ0dXAgdGltZSwgYW5kIHRlYXIgaXQgZG93biB3aGVuIGtu
ZnNkIGlzIHNodXQgZG93bj8NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGll
bnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5j
b20NCg0KDQo=
