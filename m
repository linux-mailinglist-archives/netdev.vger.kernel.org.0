Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B82B2D1526
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgLGPu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:50:56 -0500
Received: from us-smtp-delivery-181.mimecast.com ([63.128.21.181]:56418 "EHLO
        us-smtp-delivery-181.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727009AbgLGPuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 10:50:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rbbn.com; s=mimecast20180816;
        t=1607356167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cnnhstO/6P9tnk5+0I9GN3viVWcJMzw2WOVRbNKvDRg=;
        b=lOQeTbUNZpoJT+Yod+6LS6x4ABvgGkGhGofFM8DZYg40RqT7v0KNqjcW4PYUoX5VOJ0Zmo
        clnzebwDRXYFuASDl+HiOoSf0gtL7Zpos2BI+CFEaiZNMDXTT+SLfJueHDoYv9gbdwzeFL
        4njXl8M0v3x2dwH1G7357xt48+r/1/A=
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-tOCkYp8rNpS7ygcIne7XCw-1; Mon, 07 Dec 2020 10:49:21 -0500
Received: from MN2PR03MB4752.namprd03.prod.outlook.com (2603:10b6:208:af::30)
 by MN2PR03MB5342.namprd03.prod.outlook.com (2603:10b6:208:1ea::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 7 Dec
 2020 15:49:18 +0000
Received: from MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df]) by MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df%7]) with mapi id 15.20.3632.018; Mon, 7 Dec 2020
 15:49:18 +0000
From:   "Finer, Howard" <hfiner@rbbn.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "andy@greyhouse.net" <andy@greyhouse.net>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: bonding driver issue when configured for active/backup and using
 ARP monitoring
Thread-Topic: bonding driver issue when configured for active/backup and using
 ARP monitoring
Thread-Index: AdbHQ00ZgN9FZpM9RKmwxP/JkIcJoADOsOqAAItX5rAAAUKF8A==
Date:   Mon, 7 Dec 2020 15:49:18 +0000
Message-ID: <MN2PR03MB47523F9683E2CDF64D5653B0B7CE0@MN2PR03MB4752.namprd03.prod.outlook.com>
References: <MN2PR03MB47526B686EF6E0F8D81A9397B7F50@MN2PR03MB4752.namprd03.prod.outlook.com>
 <14769.1607114585@famine>
 <MN2PR03MB4752855F586F7CC5811E9B67B7CE0@MN2PR03MB4752.namprd03.prod.outlook.com>
In-Reply-To: <MN2PR03MB4752855F586F7CC5811E9B67B7CE0@MN2PR03MB4752.namprd03.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [208.45.178.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1024dde3-0d37-410c-2658-08d89ac7a872
x-ms-traffictypediagnostic: MN2PR03MB5342:
x-microsoft-antispam-prvs: <MN2PR03MB5342BFD8C598AE51C3AC6605B7CE0@MN2PR03MB5342.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: naNdCkLACbmR2CP9Fm/WkUlyXn5nPYICFdFLnyrro1/urOAfkze5RU4ih8kHgBwb47JUYiogN3qnfa/AgiuyUtACU/PFIFHaTfRsW6rmi+l3VdkjIpBT+SWOcJOaaPngbF5EGjPEN9yt0CCUJuLB8M+0R6kjRWA3ZVJi9L5pxjHPi71ALJnngI/b6h+gwi/O4gioM3NElrCpgQtLPacWwUfQPIh75hLaQTjgFfEXu+Z8Z2spr4Htwif2Db3t7npRWMihl/R3pHt/rH6FT6lc2wIqygvlxAYTMWHtrrQsNRXqowU2kkeh6zIsGz4xz7N4+R2nv9ro9TSEUsQaTlMSnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR03MB4752.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(26005)(8936002)(66476007)(66556008)(66446008)(86362001)(7696005)(66946007)(478600001)(71200400001)(64756008)(2940100002)(316002)(76116006)(6916009)(33656002)(6506007)(53546011)(8676002)(83380400001)(54906003)(9686003)(186003)(52536014)(55016002)(2906002)(5660300002)(4326008);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: =?utf-8?B?QVBrdzIyUXlMbytJMCtMVW1kbk91Lys0b2RWN3czZ1RNZFRCQlhMSU1JWHNz?=
 =?utf-8?B?OHVXMjFvM29jL1pJckxLUjBBQ2xHTHVnOE1pWi9YOTRYbWR5Z0xNSHZxdy9O?=
 =?utf-8?B?STE0T2N5WGErblBiMlFiM2dwTHpFb3UyTEpkQmQ2TTVTRllrQnlkOXd2TEJo?=
 =?utf-8?B?VVVTVVkyVGt0YnFiWUdKRFovN3hBelVwWFhXNzlEQ1p3S0dETEhvLzIzdk9o?=
 =?utf-8?B?anpkT0lweURuZHVFWUlIVCtNZDVkVXFLRVlzbzcwbytiTk04UTFXaldIY3li?=
 =?utf-8?B?MXFUZ3N4L25ENDVJc1Yva0NDYTdXQnQzZVJXVUFsZStpRzdRWGR4ZEJmQnZ2?=
 =?utf-8?B?Z1N1MFh3WDFRQVh1WnRRS09yclc1TWk2MUZVbzRvTkRsSzA1OVRpRXYyR3RJ?=
 =?utf-8?B?QjZSTDR6dXdSeGhoZTZUZWRhT3MrVFkyV25DRGhqMmxQc0I0UzExYnVBdDRZ?=
 =?utf-8?B?d3p2NEFnYVlwRFRSQ0dlNitiNDdMTndPTG92bmN0a09NN3FHcTlldStlVzQ5?=
 =?utf-8?B?dXRvcjFncEFZWU5kb1doY1Q4c2lkL1RJTU1wREFzVnVNRUhaR1hxZ25BSEUr?=
 =?utf-8?B?SUh0dTBjOHM4ZDkrYmdjK2ErR2U2Q1EyL3IzaU9JWTVwV1dKUHFCb3A1RFYz?=
 =?utf-8?B?ZXNaSEp5MzhjZmFjNyt4L2xIYlJxb2UyVXpxb3pVcnVMaG83Q204U1JVeTNQ?=
 =?utf-8?B?Wk11NkcvR2tCNnFXUWZ6TkROQ1k5ZU9UYysxK2JsNzg5bDRlZ3NkUnlGRHAz?=
 =?utf-8?B?dnJ4WUJrRFkrRktONE1kL1FlWXpRSDZHTU12MVoydmxkZVFmUk5nMEZQaWlh?=
 =?utf-8?B?WXNXUUtkTlNKWG5JS0VYdGE2MU4wc0hKK0xYVlRySG9lVVVpbDFucXRtRUVy?=
 =?utf-8?B?S2t2dVFjaUMrYnpmREJhaGJSZDYxWGlkeVl5RExLc1lmbUU0L3RQQmluTFAv?=
 =?utf-8?B?NGZaeExWTzF5dEdRWjU3ZUNRRFFiTEhON0RYZHdtVm1XVDcxTUJhbVg4N29m?=
 =?utf-8?B?ZndsUWNiaEFJQ1U3a1FzcTRBa1A3L25JMFNFWFIxdlJMM0VnVTlpYmJobmlw?=
 =?utf-8?B?ZEpYV1JmeXR3NnZVcjRkd1dDcVNhZWx0VnE5YlJhYmtwTDJCK1pHUXRqU1kw?=
 =?utf-8?B?RXBjRERpNmhlaDI5cHRjdlppd09zSEFJZWYrdDVSL3NxLzY0VDVUTXZoRWdx?=
 =?utf-8?B?NStLbFhzdEd5MDNaaGtCQzNtR0htV21XVmpUcjFwYzFNOEs3a3AwWCswUUZR?=
 =?utf-8?B?MUEvaWo0KytpbjhtV2tEUFVUdTNLS2RCcmV0dkh3RGd0UWRnMzRXV204M1E3?=
 =?utf-8?Q?8yS5t3tfqVpaM=3D?=
x-ms-exchange-transport-forked: True
x-mc-unique: tOCkYp8rNpS7ygcIne7XCw-1
x-originatororg: rbbn.com
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: MN2PR03MB4752.namprd03.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: 1024dde3-0d37-410c-2658-08d89ac7a872
x-ms-exchange-crosstenant-originalarrivaltime: 07 Dec 2020 15:49:18.7128 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 29a671dc-ed7e-4a54-b1e5-8da1eb495dc3
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: D5rlPrqORE9YB/Gv3sG4NC3qURSGTTvT4+SgHUUW/oU9Z/WIBz3BcVej+dDgd+nN
x-ms-exchange-transport-crosstenantheadersstamped: MN2PR03MB5342
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA81A106 smtp.mailfrom=hfiner@rbbn.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rbbn.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciBjb25maXJtaW5nIHdoYXQgSSBhbSBzZWVpbmcuICAgIEkgYWdyZWUgaXQgaXMg
bm90IGp1c3QgYSBub3RpZmljYXRpb24gaXNzdWUsIGFuZCB0aGF0IOKAnGl0IHdvdWxkIGJlIGlk
ZWFsIGlmIHRoZSBiYWNrdXAgaW50ZXJmYWNlcyBjb3VsZCBiZSBrZXB0DQp0cmFjayBvZiBhbmQg
c3dpdGNoZWQgdG8gaW1tZWRpYXRlbHkgYXMgeW91IHN1Z2dlc3Qu4oCdDQoNCkdpdmVuIHRoYXQg
dGhpcyBpcyBhIGRlZmVjdCBpbiB0aGUgZHJpdmVyIGFuZCB0aGF0IGFuIGFjdGl2ZS9iYWNrdXAg
Y29uZmlndXJhdGlvbiB3aXRoIEFSUCBtb25pdG9yaW5nIGlzIGJyb2tlbiwgaXMgdGhpcyBzb21l
dGhpbmcgdGhhdCB3b3VsZCByZWNlaXZlIHNvbWUgYXR0ZW50aW9uIGFuZCBnZXQgZml4ZWQgaW4g
dGhlIG5lYXIgdGVybT8NCg0KVGhhbmtzIGFnYWluLA0KSG93YXJkDQoNCg0KRnJvbTogSmF5IFZv
c2J1cmdoIDxtYWlsdG86amF5LnZvc2J1cmdoQGNhbm9uaWNhbC5jb20+DQpTZW50OiBGcmlkYXks
IERlY2VtYmVyIDQsIDIwMjAgMzo0MyBQTQ0KVG86IEZpbmVyLCBIb3dhcmQgPG1haWx0bzpoZmlu
ZXJAcmJibi5jb20+DQpDYzogbWFpbHRvOmFuZHlAZ3JleWhvdXNlLm5ldDsgbWFpbHRvOnZmYWxp
Y29AZ21haWwuY29tOyBtYWlsdG86bmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6
IGJvbmRpbmcgZHJpdmVyIGlzc3VlIHdoZW4gY29uZmlndXJlZCBmb3IgYWN0aXZlL2JhY2t1cCBh
bmQgdXNpbmcgQVJQIG1vbml0b3JpbmcNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXw0KTk9USUNFOiBUaGlzIGVtYWlsIHdhcyByZWNlaXZlZCBmcm9tIGFuIEVYVEVS
TkFMIHNlbmRlcg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KDQpG
aW5lciwgSG93YXJkIDxtYWlsdG86aGZpbmVyQHJiYm4uY29tPiB3cm90ZToNCg0KPldlIHVzZSB0
aGUgYm9uZGluZyBkcml2ZXIgaW4gYW4gYWN0aXZlLWJhY2t1cCBjb25maWd1cmF0aW9uIHdpdGgg
QVJQDQo+bW9uaXRvcmluZy4gV2UgYWxzbyB1c2UgdGhlIFRJUEMgcHJvdG9jb2wgd2hpY2ggd2Ug
cnVuIG92ZXIgdGhlIGJvbmQNCj5kZXZpY2UuIFdlIGFyZSBjb25zaXN0ZW50bHkgc2VlaW5nIGFu
IGlzc3VlIGluIGJvdGggdGhlIDMuMTYgYW5kIDQuMTkNCj5rZXJuZWxzIHdoZXJlYnkgd2hlbiB0
aGUgYm9uZCBzbGF2ZSBpcyBzd2l0Y2hlZCBUSVBDIGlzIGJlaW5nIG5vdGlmaWVkIG9mDQo+dGhl
IGNoYW5nZSByYXRoZXIgdGhhbiBpdCBoYXBwZW5pbmcgc2lsZW50bHkuIFRoZSBwcm9ibGVtIHRo
YXQgd2Ugc2VlIGlzDQo+dGhhdCB3aGVuIHRoZSBhY3RpdmUgc2xhdmUgZmFpbHMsIGEgTkVUREVW
X0NIQU5HRSBldmVudCBpcyBiZWluZyBzZW50IHRvDQo+dGhlIFRJUEMgZHJpdmVyIHRvIG5vdGlm
eSBpdCB0aGF0IHRoZSBsaW5rIGlzIGRvd24uIFRoaXMgY2F1c2VzIHRoZSBUSVBDDQo+ZHJpdmVy
IHRvIHJlc2V0IGl0cyBiZWFyZXJzIGFuZCB0aGVyZWZvcmUgYnJlYWsgY29tbXVuaWNhdGlvbiBi
ZXR3ZWVuIHRoZQ0KPm5vZGVzIHRoYXQgYXJlIGNsdXN0ZXJlZC4NCj5XaXRoIHNvbWUgYWRkaXRp
b25hbCBpbnN0cnVtZW50YXRpb24gaW4gdGhlZSBkcml2ZXIsIEkgc2VlIHRoaXMgaW4NCj4vdmFy
L2xvZy9zeXNsb2c6DQo+PDY+IDEgMjAyMC0xMS0yMFQxODoxNDoxOS4xNTk1MjQrMDE6MDAgTEFC
TkJTNUIga2VybmVsIC0gLSAtDQo+WzY1ODE4LjM3ODI4N10gYm9uZDA6IGxpbmsgc3RhdHVzIGRl
ZmluaXRlbHkgZG93biBmb3IgaW50ZXJmYWNlIGV0aDAsDQo+ZGlzYWJsaW5nIGl0DQo+PDY+IDEg
MjAyMC0xMS0yMFQxODoxNDoxOS4xNTk1MzYrMDE6MDAgTEFCTkJTNUIga2VybmVsIC0gLSAtDQo+
WzY1ODE4LjM3ODI5Nl0gYm9uZDA6IG5vdyBydW5uaW5nIHdpdGhvdXQgYW55IGFjdGl2ZSBpbnRl
cmZhY2UhDQo+PDY+IDEgMjAyMC0xMS0yMFQxODoxNDoxOS4xNTk1MzcrMDE6MDAgTEFCTkJTNUIg
a2VybmVsIC0gLSAtDQo+WzY1ODE4LjM3ODMwNF0gYm9uZDA6IGJvbmRfYWN0aXZlYmFja3VwX2Fy
cF9tb246IG5vdGlmeV9ydG5sLCBzbGF2ZSBzdGF0ZQ0KPm5vdGlmeS9zbGF2ZSBsaW5rIG5vdGlm
eQ0KPjw2PiAxIDIwMjAtMTEtMjBUMTg6MTQ6MTkuMTU5NTM4KzAxOjAwIExBQk5CUzVCIGtlcm5l
bCAtIC0gLQ0KPls2NTgxOC4zNzg4MzVdIG5ldGRldiBjaGFuZ2UgYmVhcmVyIDxldGg6Ym9uZDA+
DQo+PDY+IDEgMjAyMC0xMS0yMFQxODoxNDoxOS4yNjM1MjMrMDE6MDAgTEFCTkJTNUIga2VybmVs
IC0gLSAtDQo+WzY1ODE4LjQ4MjM4NF0gYm9uZDA6IGxpbmsgc3RhdHVzIGRlZmluaXRlbHkgdXAg
Zm9yIGludGVyZmFjZSBldGgxDQo+PDY+IDEgMjAyMC0xMS0yMFQxODoxNDoxOS4yNjM1MzQrMDE6
MDAgTEFCTkJTNUIga2VybmVsIC0gLSAtDQo+WzY1ODE4LjQ4MjM4N10gYm9uZDA6IG1ha2luZyBp
bnRlcmZhY2UgZXRoMSB0aGUgbmV3IGFjdGl2ZSBvbmUNCj48Nj4gMSAyMDIwLTExLTIwVDE4OjE0
OjE5LjI2MzUzNiswMTowMCBMQUJOQlM1QiBrZXJuZWwgLSAtIC0NCj5bNjU4MTguNDgyNjMzXSBi
b25kMDogZmlyc3QgYWN0aXZlIGludGVyZmFjZSB1cCENCj48Nj4gMSAyMDIwLTExLTIwVDE4OjE0
OjE5LjI2MzUzNyswMTowMCBMQUJOQlM1QiBrZXJuZWwgLSAtIC0NCj5bNjU4MTguNDgyNjcxXSBu
ZXRkZXYgY2hhbmdlIGJlYXJlciA8ZXRoOmJvbmQwPg0KPjw2PiAxIDIwMjAtMTEtMjBUMTg6MTQ6
MTkuMzY3NTIzKzAxOjAwIExBQk5CUzVCIGtlcm5lbCAtIC0gLQ0KPls2NTgxOC41ODYyMjhdIGJv
bmQwOiBib25kX2FjdGl2ZWJhY2t1cF9hcnBfbW9uOiBjYWxsX25ldGRldmljZV9ub3RpZmllcnMN
Cj5ORVRERVZfTk9USUZZX1BFRVJTDQo+DQo+VGhlcmUgaXMgbm8gaXNzdWUgd2hlbiB1c2luZyBN
SUkgbW9uaXRvcmluZyBpbnN0ZWFkIG9mIEFSUCBtb25pdG9yaW5nDQo+c2luY2Ugd2hlbiB0aGUg
c2xhdmUgaXMgZGV0ZWN0ZWQgYXMgZG93biwgaXQgaW1tZWRpYXRlbHkgc3dpdGNoZXMgdG8gdGhl
DQo+YmFja3VwIGFzIGl0IHNlZXMgdGhhdCBzbGF2ZSBhcyBiZWluZyB1cCBhbmQgcmVhZHkuIEJ1
dCB3aGVuIHVzaW5nIEFSUA0KPm1vbml0b3JpbmcsIG9ubHkgb25lIG9mIHRoZSBzbGF2ZXMgaXMg
J3VwJy4gU28gd2hlbiB0aGUgYWN0aXZlIHNsYXZlIGdvZXMNCj5kb3duLCB0aGUgYm9uZGluZyBk
cml2ZXIgd2lsbCBzZWUgbm8gYWN0aXZlIHNsYXZlcyB1bnRpbCBpdCBicmluZ3MgdXAgdGhlDQo+
YmFja3VwIHNsYXZlIG9uIHRoZSBuZXh0IGNhbGwgdG8gYm9uZF9hY3RpdmViYWNrdXBfYXJwX21v
bi4gQnJpbmdpbmcgdXANCj50aGF0IGJhY2t1cCBzbGF2ZSBoYXMgdG8gYmUgYXR0ZW1wdGVkIHBy
aW9yIHRvIG5vdGlmeWluZyBhbnkgcGVlcnMgb2YgYQ0KPmNoYW5nZSBvciBlbHNlIHRoZXkgd2ls
bCBzZWUgdGhlIG91dGFnZS4gSW4gdGhpcyBjYXNlIGl0IHNlZW1zIHRoZQ0KPnNob3VsZF9ub3Rp
ZnlfcnRubCBmbGFnIGhhcyB0byBiZSBzZXQgdG8gZmFsc2UuIEhvd2V2ZXIsIEkgYWxzbyBxdWVz
dGlvbg0KPmlmIHRoZSBzd2l0Y2ggdG8gdGhlIGJhY2t1cCBzbGF2ZSBzaG91bGQgYWN0dWFsbHkg
b2NjdXIgaW1tZWRpYXRlbHkgbGlrZQ0KPml0IGRvZXMgZm9yIE1JSSBhbmQgdGhhdCB0aGUgYmFj
a3VwIHNob3VsZCBiZSBpbW1lZGlhdGVseSAnYnJvdWdodA0KPnVwL3N3aXRjaGVkIHRvJyB3aXRo
b3V0IGhhdmluZyB0byB3YWl0IGZvciB0aGUgbmV4dCBpdGVyYXRpb24uDQoNCkkgc2VlIHdoYXQg
eW91J3JlIGRlc2NyaWJpbmc7IEknbSB3YXRjaGluZyAiaXAgbW9uaXRvciIgd2hpbGUNCmRvaW5n
IGZhaWxvdmVycyBhbmQgY29tcGFyaW5nIHRoZSBiZWhhdmlvciBvZiB0aGUgbWlpbW9uIHZzIHRo
ZSBBUlANCm1vbml0b3IuIFRoZSBib25kIGRldmljZSBpdHNlbGYgZ29lcyBkb3duIGR1cmluZyB0
aGUgY291cnNlIG9mIGFuIEFSUA0KZmFpbG92ZXIsIHdoaWNoIGRvZXNuJ3QgaGFwcGVuIGR1cmlu
ZyB0aGUgbWlpbW9uIGZhaWxvdmVyLg0KDQpUaGlzIGRvZXMgY2F1c2Ugc29tZSBjaHVybiBvZiBl
dmVuIHRoZSBJUHY0IG11bHRpY2FzdCBhZGRyZXNzZXMNCmFuZCBzdWNoLCBzbyBpdCB3b3VsZCBi
ZSBpZGVhbCBpZiB0aGUgYmFja3VwIGludGVyZmFjZXMgY291bGQgYmUga2VwdA0KdHJhY2sgb2Yg
YW5kIHN3aXRjaGVkIHRvIGltbWVkaWF0ZWx5IGFzIHlvdSBzdWdnZXN0Lg0KDQpJIGRvbid0IHRo
aW5rIGl0J3Mgc2ltcGx5IGEgbWF0dGVyIG9mIG5vdCBkb2luZyBhIG5vdGlmaWNhdGlvbiwNCmhv
d2V2ZXIuIEkgaGF2ZW4ndCBpbnN0cnVtZW50ZWQgaXQgY29tcGxldGVseSB5ZXQgdG8gc2VlIHRo
ZSBjb21wbGV0ZQ0KYmVoYXZpb3IsIGJ1dCB0aGUgYmFja3VwIGludGVyZmFjZSBoYXMgdG8gYmUg
aW4gYSBib25kaW5nLWludGVybmFsIGRvd24NCnN0YXRlLCBvdGhlcndpc2UgdGhlIGJvbmRfYWJf
YXJwX2NvbW1pdCBjYWxsIHRvIGJvbmRfc2VsZWN0X2FjdGl2ZV9zbGF2ZQ0Kd291bGQgc2VsZWN0
IGEgbmV3IGFjdGl2ZSBzbGF2ZSwgYW5kIHRoZSBib25kIGl0c2VsZiB3b3VsZCBub3QgZ28NCk5P
LUNBUlJJRVIgKHdoaWNoIGlzIGxpa2VseSB3aGVyZSB0aGUgTkVUREVWX0NIQU5HRSBldmVudCBj
b21lcyBmcm9tLA0KdmlhIGxpbmt3YXRjaCBkb2luZyBuZXRkZXZfc3RhdGVfY2hhbmdlKS4NCg0K
Wy4uLl0NCg0KPkFzIGl0IGN1cnJlbnRseSBiZWhhdmVzIHRoZXJlIGlzIG5vIHdheSB0byBydW4g
VElQQyBvdmVyIGFuIGFjdGl2ZS1iYWNrdXANCj5BUlAtbW9uaXRvcmVkIGJvbmQgZGV2aWNlLiBJ
IHN1c3BlY3QgdGhlcmUgYXJlIG90aGVyIHNpdHVhdGlvbnMvdXNlcyB0aGF0DQo+d291bGQgbGlr
ZXdpc2UgaGF2ZSBhbiBpc3N1ZSB3aXRoIHRoZSAnZXJyb25lb3VzJyBORVRERVZfQ0hBTkdFIGJl
aW5nDQo+aXNzdWVkLiBTaW5jZSBUSVBDIChhbmQgb3RoZXJzKSBoYXZlIG5vIGlkZWEgd2hhdCB0
aGUgZGV2IGlzLCBpdCBpcyBub3QNCj5wb3NzaWJsZSB0byBpZ25vcmUgdGhlIGV2ZW50IG5vciBz
aG91bGQgaXQgYmUgaWdub3JlZC4gSXQgdGhlcmVmb3JlIHNlZW1zDQo+dGhlIGV2ZW50IHNob3Vs
ZG4ndCBiZSBzZW50IGZvciB0aGlzIHNpdHVhdGlvbi4gUGxlYXNlIGNvbmZpcm0gdGhlDQo+YW5h
bHlzaXMgYWJvdmUgYW5kIHByb3ZpZGUgYSBwYXRoIGZvcndhcmQgc2luY2UgYXMgY3VycmVudGx5
IGltcGxlbWVudGVkDQo+dGhlIGZ1bmN0aW9uYWxpdHkgaXMgYnJva2VuLg0KDQpBcyBJIHNhaWQg
YWJvdmUsIEkgZG9uJ3QgdGhpbmsgaXQncyBqdXN0IGFib3V0IG5vdGlmaWNhdGlvbnMuDQoNCi1K
DQoNCi0tLQ0KLUpheSBWb3NidXJnaCwgbWFpbHRvOmpheS52b3NidXJnaEBjYW5vbmljYWwuY29t
DQo=

