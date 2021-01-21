Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9192FF299
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389356AbhAUR5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:57:46 -0500
Received: from mail-dm6nam08on2117.outbound.protection.outlook.com ([40.107.102.117]:4320
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389327AbhAUR5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 12:57:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pyh7Ci7BB0/wc1SijzzIQoWyNbNvkAui/JSPMM4/eulGn38nTQy10/zwowSPD1JIzaQzFt0wpGCmDhtApLoLZFRVBpRUCJ62vE6GKfVDYBXvO4ZLhFMk3jZlDgohEtxAbCxpBE1uI5vHN595NnnOuAvRm1c+u9ZpYCKHX3d0KVz9oBPgHZJvgHn0lBwNxi5PYQTYvr+bSkdsz5NSM1x3gSj10A5JmEF5W8Ur0ZVvmUhy1EbHDqDIU20/UVDBEHxaO0tdR/ssXPaLRyF2zQXzNwLk5pw3Gt3kOxPiYze1jxHjEiAieHarMNPy5kb2TP2ww1G13vAm1tvFBIUXrJlCUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rvBcutis5r81i9IjM4vTx1jOl+q+tIp7zXF1P/xMrc=;
 b=EZT+LneREUSPA/o6QLjevpTC2Qv0albR5GtDQtiTxXM8dM6Xnd1HtsBjhKMiIDHG1SB7gs9qbusfSS14UU84kKnZpX27SQmtU9EbjSssMd2qtFZcS2k17rUiBgGql2TGYaKHhayaXuiHyNpKIxVx8WpzpKzDDjKBxOgp8PJJwe47sQMDGQeW8+8LtQ2cKUHA5+xPkgy3gmfEgElcgfoSP+1ICk2XD1YoYNdw+XMJI+96aM/G4Kxe7z8Yd0401MhGF+O2fixNu9T8vwruopgBilsc8mgU/M8FSIB9GuIW9iGsr64p5Q/AG8qXEBfqmNPuoXpYQ9bZdBFyZiNIqIZIHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rvBcutis5r81i9IjM4vTx1jOl+q+tIp7zXF1P/xMrc=;
 b=fx1YvWXS+zv80hjmbfw9VNnYCunau7EQ+I1U3ELYTFZX/gBeZuEguzTOimIRX9h4FUykYhjzz8SCm5Oci7SLx4njqWihnzX/0VQS2H0XweFh+l4mBqCRcVjnVFILA19Iu+meEiMJun4eGuv9DuDzMc7oVliJ9SMyv3foqixALfs=
Received: from (2603:10b6:610:21::29) by
 CH2PR13MB3814.namprd13.prod.outlook.com (2603:10b6:610:9a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.5; Thu, 21 Jan 2021 17:56:27 +0000
Received: from CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063]) by CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063%3]) with mapi id 15.20.3805.006; Thu, 21 Jan 2021
 17:56:27 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
        "Anna.Schumaker@netapp.com" <Anna.Schumaker@netapp.com>
CC:     "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: rpc_xprt_debugfs_register() - atomic_inc_return() usage
Thread-Topic: rpc_xprt_debugfs_register() - atomic_inc_return() usage
Thread-Index: AQHW74dXBrq8kHbX/kyLzHgl6JHsMKoyU6CA
Date:   Thu, 21 Jan 2021 17:56:26 +0000
Message-ID: <020aee05c808b3725db5679967406a918840f86f.camel@hammerspace.com>
References: <06c8f6ff-f821-e909-d40c-9de98657729f@linuxfoundation.org>
In-Reply-To: <06c8f6ff-f821-e909-d40c-9de98657729f@linuxfoundation.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [50.124.246.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58c02fde-ef5e-4bab-9402-08d8be35dfe3
x-ms-traffictypediagnostic: CH2PR13MB3814:
x-microsoft-antispam-prvs: <CH2PR13MB3814D1EC6960DED1CE13F647B8A19@CH2PR13MB3814.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eM8E5jHpvbg9KsdOMQxyl5t//KcL7v6OeixoWEKUA9V4atmvbvsOvP8WxsUJltZ7t0nZteb4QPiMnMEoZMdwpMbLaadAKCtZk4ZYDc9HwUZN4Lpo41UJ46p/vhaL6HQjPBA8qWd2gUhDSPaWUeJwAewO3h1goxw41PsF5ue99fR609qKdIDcplUuHx/ASAGx1CVij09Kqn9L45MtFki8ZAOLwqhhxpt+s+6OjHpCZhRGwEt050YHJnhKiAC4gQQhomdvVnBJIOyweGAy2P7r/xIrupaMJAIFnXoMPqJIM4b+cXs4mNhudciLPKz6ZzcaTprIrgJtKuAV1/SeJHtsIsqM77hwFt9CMBlumcJRBEp26zUBojUzE5+t4USqU2KkBKbeCjaWOLKo3cJFCbb2OTZeVRPKuH12UzxGY1yVtf9vS0qFAkoWrfuliID5sR9C/SYdbabzOAqatLGdwTepRyCLgvj5HfGZwVGWNLDoVjcTr2Y/HsjHdCZc5M0pjJMG80XezkaECfAArCtv3PN3bQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3525.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39830400003)(396003)(136003)(376002)(86362001)(2906002)(76116006)(6512007)(36756003)(4326008)(478600001)(316002)(6506007)(54906003)(110136005)(71200400001)(186003)(5660300002)(26005)(6486002)(8676002)(2616005)(66446008)(64756008)(66556008)(83380400001)(66476007)(8936002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cjNPalY5eFdmOWV0Nkp1ckRQOUVoTDhqL3pyZldHa1FzZUYvS2FkVmhTZGJn?=
 =?utf-8?B?TWNkYURTOEtmLzJCUzV1NGpEcjEwOUtzb011RnFyVXN3ZmNBay85SlJtQXJJ?=
 =?utf-8?B?eFdYR2NpZFo0YzkzL1BjQS93dGRCRm5tWWhxQUxoQ1lNZmRMT3lYbTV1ZnVJ?=
 =?utf-8?B?TFg4bVk5NG5zNERvMThqTXBSNy95cnh6UGNxWU5RZUFROEV5VUhLYnlJODJ1?=
 =?utf-8?B?dElNZ29Jb0dyeUdNbEFMZzI4dGdnMWJZcTVicDBSZEx4WGRXQ2lIaHpNdFFt?=
 =?utf-8?B?V01sbTVvRStzWjdGTXVId1B2b2h3OGdLbm9McFRZUU1SeUo4Qnp2ZFBmbm0v?=
 =?utf-8?B?UjdDZmJZRE1tUTlpbTlhN1dhbnJ0cG9ZWVBReEw4aGZZVS9wV29iNEVXQk5R?=
 =?utf-8?B?MzJ5VHJabjIwQUNRcVcrUG1UTDRRQUxWRUxRU00wbXl4blNNUmVjK3oxSUpU?=
 =?utf-8?B?NFlFWkJ0UjRha0FMU1dhNE9FcDhGRmFQVDBGS05IYk8xQk40djQyaW5qUW41?=
 =?utf-8?B?RUZ4VlUrYU5sSjVJNVI5M01mTG9FcjJZc1J5Nm5udmh2aVNUYy8vL0RVWmc4?=
 =?utf-8?B?VWRFTmwwby91bWhtMXh1a1BZSDkxTmRFWHBFZnVrVUh0bWo2VUFxd1lJVGJV?=
 =?utf-8?B?KzhXNXBLLytjMnM2SUpTRGR6a2JMNnRpWnYybGhJa1IzOW1MejNTYnM3TVAw?=
 =?utf-8?B?RWJCMTRnWVFsMmw1cEVVNUdIRjRVU29MUWQ5SGhjQ08wTVhvT21LdlVmSkR6?=
 =?utf-8?B?QjZLQnpqSHliZjZQUWV4aVJjZklIckU3QitFYVkybVpac29rWWhaUlplaWFJ?=
 =?utf-8?B?WDc2UEdjL3R5UkIvM0FtRUtKT0M1UEs2UEQxaExkb1B0dDNKU0VUZEZRdmlZ?=
 =?utf-8?B?MktXVGRKY29IQWhwMlZvYXRLMmhEa2RBcEZGUzQvRWRIbU1NREVZc3FoVStR?=
 =?utf-8?B?dE5IcndLUFkvR0oyaktYUkxQdlFuKzZ6SmJla0RXV0dURklZUEVUWWg1bThL?=
 =?utf-8?B?amFNdkRLY2R6T016TzhFcnBBWFYwckVwQjlXVmFHNmxwSVorNHJ3QkczV2Vw?=
 =?utf-8?B?Tld5RkcxNkVPQTE2WFRLOFNpSE41ZHVYQjI0cDNLWGt2eEZPd3NkQ1pYTTU0?=
 =?utf-8?B?dEJSSHR2cTF5SXAxMzBwZkE0YkgySDlweEFrLzhYUFVqYkZCaXBXM1EzK1B2?=
 =?utf-8?B?eExoekFWMS9qN3BnWEVPalpoYnFqcjFNSGNuL21VWUVncnlXQ0UrcUlRZCtE?=
 =?utf-8?B?TUZVYnMvL0tXcnYrQ3NGUytia3o1c3ZQQ2JGNytvUkNLNk5EdGsvb01WQ1JQ?=
 =?utf-8?Q?z9wc9kHGyd9B5lxV53n22yy01KdkdTWWEp?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD78C4F3198F7E4F8A36A745A7CA9796@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR13MB3525.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c02fde-ef5e-4bab-9402-08d8be35dfe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 17:56:27.0103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZsUrnLpGrjdkrqrnoJOT5ifDLoXV6Xghjg778m4VaDHrEUyPpvD3LB6FlXgoHOmKDssuWNIJo/ydQjGwPdDTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTAxLTIwIGF0IDE2OjUyIC0wNzAwLCBTaHVhaCBLaGFuIHdyb3RlOg0KPiBI
aSBBbm5hIGFuZCBUcm9uZCwNCj4gDQo+IEkgY2FtZSBhY3Jvc3MgdGhlIGZvbGxvd2luZyB3aGls
ZSByZXZpZXdpbmcgYXRvbWljX2luY19yZXR1cm4oKQ0KPiB1c2FnZXMNCj4gdGhhdCBjYXN0IHJl
dHVybiB2YWx1ZSB0byB1bnNpZ25lZA0KPiANCj4gcnBjX3hwcnRfZGVidWdmc19yZWdpc3Rlcigp
J3MgYXRvbWljX2luY19yZXR1cm4oKSB1c2FnZSBsb29rcyBhIGJpdA0KPiBvZGQuDQo+IA0KPiAt
IGN1cl9pZCBpc24ndCBpbml0aWFsaXplZA0KPiAtIGlkID0gKHVuc2lnbmVkIGludClhdG9taWNf
aW5jX3JldHVybigmY3VyX2lkKTsNCj4gDQo+IFBsZWFzZSBub3RlIHRoYXQgaWQgaXMgaW50LiBJ
cyBpdCBleHBlY3RlZCB0aGF0IGN1cl9pZCBjb3VsZA0KPiBvdmVyZmxvdz8NCj4gSXMgdGhlcmUg
YSBtYXhpbXVtIGxpbWl0IGZvciB0aGlzIHZhbHVlPw0KPiANCg0KWWVzLCB3ZSBkbyBleHBlY3Qg
Y3VyX2lkIHRvIGV2ZW50dWFsbHkgb3ZlcmZsb3cgKG9uY2UgeW91IGhhdmUgY3JlYXRlZA0KMiBi
aWxsaW9uIFJQQyBjbGllbnQgaW5zdGFuY2VzKSwgaG93ZXZlciB0aGUgYXRvbWljIGluY3JlbWVu
dA0Kb3BlcmF0aW9ucyBhcmUgZXhwZWN0ZWQgdG8gaGFuZGxlIHRoaXMgY29ycmVjdGx5IGFjY29y
ZGluZyB0byB0aGUNCm1haW50YWluZXJzIChJIGFscmVhZHkgYXNrZWQgdGhlbSBpbiBhIGRpZmZl
cmVudCBjb250ZXh0KS4gRnVydGhlcm1vcmUsDQp0aGUgY29kZSBpdHNlbGYgZG9lc24ndCBjYXJl
IGFib3V0IHN0cmljdCBzZXF1ZW50aWFsaXR5LiBBbGwgaXQgd2FudHMNCmZyb20gdGhlIGNvdW50
ZXIgaXMgdW5pcXVlbmVzcywgd2l0aCB0aGF0IHVuaXF1ZW5lc3MgY29uZGl0aW9uIGFjdHVhbGx5
DQpiZWluZyBlbmZvcmNlZCBieSB0aGUgc3Vic2VxdWVudCBkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCkg
Y2FsbC4NCg0KSU9XOiBJIGRvbid0IHRoaW5rIHRoaXMgaXMgYSByZWFsIHByb2JsZW0uDQoNCi0t
IA0KVHJvbmQgTXlrbGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNw
YWNlDQp0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
