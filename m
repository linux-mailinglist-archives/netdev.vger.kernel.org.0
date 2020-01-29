Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB4C14C9DA
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 12:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgA2Lmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 06:42:42 -0500
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:62764
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgA2Lmm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 06:42:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=do7CpSDcOvPJzCMEwm0E/AEE6A0HydOIuwdqBIy//gKYMf3ZkQEYolwAXwHsBNeG8RVcQio7QrZ5CuMa/wke1F9YlTHjV2uK0KqqXwUG57NgIdp0N8jcGiPv8fMOu+HStPOHlcBvgsNexjXHjnpqbG1e+VvOFiLSYu4T+XHh+TxY6yq2XFnfyTlepZ3kSwzMcgfl0nneREXGK9FYbPlagndfc9qCAyF0UHjePp3pSO+zNzyPacgG59YAtv5+XKd1khsZ3z6ihUDtr+b0C93P+dlq1h5g+Wwj/Eu0cxTc7r8usPJYFmShmomsGGbmo2auqOjBBW1IwHWLGz9dnbsbqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHaKn6SBE69OK5IhCQhNnAcXou/zvj5SOpU9qToWDZ0=;
 b=bb97Y8WFSH+RQ/sPhL7v1Wo0tWDvaGAKru2RrDL6ccZfVKGJW9uD0JlMvtzfkXNFBHFGtqVKB5rpZ2DT0WFjBxNU9pNJWO3OdSmev6dWqWLgYlJvWZThD9ZdgqjWQL2ouY+8y65Ae5Vuc2FwZPdfiHX6Wo5kgcBI8NY3i+nsX1IDwQPyzRninfdOubTh48zpsfl8Es06TZNvaptn+LhHBi4eC+ppp9aeto9WSZHSqsjM5AynykMx+crQ1KYVAqKu3BPhzPXoFsXfQT9uC8uQe4D4OJDhl9VOI0JVPb8YRc+FGMJb9CYNSG+gRnZzEZxWH3nu+gVmix20suBE/99gFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHaKn6SBE69OK5IhCQhNnAcXou/zvj5SOpU9qToWDZ0=;
 b=ehUZxq/VT10Q2DNHrPCN1ctfDsTQKvU8/T6Rk7vobB2e9kBmZLjvxywtFmoH7IfzXscOh33x7KQkBF5ubVtBoMsEl3r1Ajhq6lELMDxTwaliiRGKcnso0ROM6+SNF7CwjxinFwMJD1Pg69OdDaE6ps7Yn/R0h86Q+gwMII9xVQM=
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com (10.171.187.33) by
 AM4PR05MB3364.eurprd05.prod.outlook.com (10.171.191.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.26; Wed, 29 Jan 2020 11:42:37 +0000
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720]) by AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720%2]) with mapi id 15.20.2665.027; Wed, 29 Jan 2020
 11:42:37 +0000
Received: from [10.223.0.122] (193.47.165.251) by FR2P281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Wed, 29 Jan 2020 11:42:36 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>
CC:     "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] net/mlx5e: Don't allow forwarding between uplink
Thread-Topic: [PATCH v3] net/mlx5e: Don't allow forwarding between uplink
Thread-Index: AQHV0RU6J45T8uTRaUSYf1wNB/NefKf2rwMAgArhKwA=
Date:   Wed, 29 Jan 2020 11:42:37 +0000
Message-ID: <d5d9c2d1-1201-c1e7-903a-a27c37e9e1e8@mellanox.com>
References: <1579691703-56363-1-git-send-email-xiangxia.m.yue@gmail.com>
 <20200122133354.GB2196@nanopsycho>
In-Reply-To: <20200122133354.GB2196@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
x-clientproxiedby: FR2P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::15) To AM4PR05MB3396.eurprd05.prod.outlook.com
 (2603:10a6:205:5::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 702671ad-4907-4be7-3390-08d7a4b05694
x-ms-traffictypediagnostic: AM4PR05MB3364:|AM4PR05MB3364:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3364CF2320E5EBAE9B7ECF97B5050@AM4PR05MB3364.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(189003)(199004)(5660300002)(81166006)(52116002)(8676002)(8936002)(81156014)(478600001)(26005)(71200400001)(66446008)(64756008)(66476007)(66556008)(4326008)(66946007)(86362001)(31696002)(2906002)(53546011)(36756003)(6486002)(31686004)(16576012)(316002)(54906003)(110136005)(16526019)(2616005)(186003)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3364;H:AM4PR05MB3396.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W4HQCp8kng1p3dnYgp4ADIgcN7t3Iz5Fd/3h9Wjs6Fq3w4dIkjiFEHRSF/AAe22hVvnS1TWT+U8NJTi+1Zn7JlJcNfsloeWSedg0gleo73oPl+T+PSdQnUuvdZQ2b0KqyyfA67gCEjZTewsaZ9q9YUY9RXhDMkAJF6WWiwWPeztMgVjHiyv83jAh+3i59SgPEQ06pjs+OuWbLL611GpVEULb244GhV+sFIHUMGICUyEA/vPymXgaeQyeFozS0eMckF5RjzKeI6GRAIZsAQl9zw1bg0TL8p2dkpZrucyt0AlgbUngkzePcWdKAMtE0LhnFKwBvEn/nfSDGxAIN7X/uZeAd8BUvAi014d80BfWdawwhBRT8RJpGYKqHvRKNU+o1+xxnEl1iOY6pKwoFjnZSfd93q97kp1UFoLbq2H5uZxl37eTJkIyxzncVEMHWxs3
x-ms-exchange-antispam-messagedata: YZZtwWndNurgKLGQ0oEaJHQAOgDqYoe571AT0l/xyN1tS5CRTp5AJBl+7rR/I0b1lcKjiyOOjGUiAlGxx1vu07tx2G2Zaz6DTwaVS3kg5D7Nqp+dXSnwh5PL/YD8AfxsXm3BBHona2PF8XQsWxfgVw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <75126BEC5028FD4F9924B34A1086A4A0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702671ad-4907-4be7-3390-08d7a4b05694
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 11:42:37.1885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ltpaShuaJZ/Ferd3kB1d0wKjve/UrCsrVdMMdlpq1ZiaLu59RTIC2lHQ7Cze57VCqUi9Oay62N0sYLEY5UcANA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3364
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMjAtMDEtMjIgMzozMyBQTSwgSmlyaSBQaXJrbyB3cm90ZToNCj4gV2VkLCBKYW4g
MjIsIDIwMjAgYXQgMTI6MTU6MDNQTSBDRVQsIHhpYW5neGlhLm0ueXVlQGdtYWlsLmNvbSB3cm90
ZToNCj4+IEZyb206IFRvbmdoYW8gWmhhbmcgPHhpYW5neGlhLm0ueXVlQGdtYWlsLmNvbT4NCj4+
DQo+PiBXZSBjYW4gaW5zdGFsbCBmb3J3YXJkaW5nIHBhY2tldHMgcnVsZSBiZXR3ZWVuIHVwbGlu
aw0KPj4gaW4gc3dpdGNoZGV2IG1vZGUsIGFzIHNob3cgYmVsb3cuIEJ1dCB0aGUgaGFyZHdhcmUg
ZG9lcw0KPj4gbm90IGRvIHRoYXQgYXMgZXhwZWN0ZWQgKG1sbnhfcGVyZiAtaSAkUEYxLCB3ZSBj
YW4ndCBnZXQNCj4+IHRoZSBjb3VudGVyIG9mIHRoZSBQRjEpLiBCeSB0aGUgd2F5LCBpZiB3ZSBh
ZGQgdGhlIHVwbGluaw0KPj4gUEYwLCBQRjEgdG8gT3BlbiB2U3dpdGNoIGFuZCBlbmFibGUgaHct
b2ZmbG9hZCwgdGhlIHJ1bGVzDQo+PiBjYW4gYmUgb2ZmbG9hZGVkIGJ1dCBub3Qgd29yayBmaW5l
IHRvby4gVGhpcyBwYXRjaCBhZGQgYQ0KPj4gY2hlY2sgYW5kIGlmIHNvIHJldHVybiAtRU9QTk9U
U1VQUC4NCj4+DQo+PiAkIHRjIGZpbHRlciBhZGQgZGV2ICRQRjAgcHJvdG9jb2wgYWxsIHBhcmVu
dCBmZmZmOiBwcmlvIDEgaGFuZGxlIDEgXA0KPj4gICAgZmxvd2VyIHNraXBfc3cgYWN0aW9uIG1p
cnJlZCBlZ3Jlc3MgcmVkaXJlY3QgZGV2ICRQRjENCj4+DQo+PiAkIHRjIC1kIC1zIGZpbHRlciBz
aG93IGRldiAkUEYwIGluZ3Jlc3MNCj4+ICAgIHNraXBfc3cNCj4+ICAgIGluX2h3IGluX2h3X2Nv
dW50IDENCj4+ICAgIGFjdGlvbiBvcmRlciAxOiBtaXJyZWQgKEVncmVzcyBSZWRpcmVjdCB0byBk
ZXZpY2UgZW5wMTMwczBmMSkgc3RvbGVuDQo+PiAgICAuLi4NCj4+ICAgIFNlbnQgaGFyZHdhcmUg
NDA4OTU0IGJ5dGVzIDQxNzMgcGt0DQo+PiAgICAuLi4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBU
b25naGFvIFpoYW5nIDx4aWFuZ3hpYS5tLnl1ZUBnbWFpbC5jb20+DQo+PiAtLS0NCj4+IGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyB8ICA1ICsrKysrDQo+
PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmggfCAgMSAr
DQo+PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYyAgfCAx
OSArKysrKysrKysrKysrKysrKysrDQo+PiAzIGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMo
KykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX3JlcC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX3JlcC5jDQo+PiBpbmRleCBmMTc1Y2IyLi5hYzJhMDM1IDEwMDY0NA0KPj4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+PiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4+IEBAIC0x
NDM0LDYgKzE0MzQsMTEgQEAgc3RhdGljIHN0cnVjdCBkZXZsaW5rX3BvcnQgKm1seDVlX2dldF9k
ZXZsaW5rX3BvcnQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4+IAkubmRvX3NldF9mZWF0dXJl
cyAgICAgICAgPSBtbHg1ZV9zZXRfZmVhdHVyZXMsDQo+PiB9Ow0KPj4NCj4+ICtib29sIG1seDVl
X2Vzd2l0Y2hfdXBsaW5rX3JlcChzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2KQ0KPj4gK3sNCj4+
ICsJcmV0dXJuIG5ldGRldi0+bmV0ZGV2X29wcyA9PSAmbWx4NWVfbmV0ZGV2X29wc191cGxpbmtf
cmVwOw0KPj4gK30NCj4+ICsNCj4+IGJvb2wgbWx4NWVfZXN3aXRjaF9yZXAoc3RydWN0IG5ldF9k
ZXZpY2UgKm5ldGRldikNCj4+IHsNCj4+IAlpZiAobmV0ZGV2LT5uZXRkZXZfb3BzID09ICZtbHg1
ZV9uZXRkZXZfb3BzX3JlcCB8fA0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9yZXAuaA0KPj4gaW5kZXggMzFmODNjOC4uNTIxMTgxOSAxMDA2NDQN
Cj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAu
aA0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3Jl
cC5oDQo+PiBAQCAtMTk5LDYgKzE5OSw3IEBAIHZvaWQgbWx4NWVfcmVwX2VuY2FwX2VudHJ5X2Rl
dGFjaChzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCj4+IHZvaWQgbWx4NWVfcmVwX3F1ZXVlX25l
aWdoX3N0YXRzX3dvcmsoc3RydWN0IG1seDVlX3ByaXYgKnByaXYpOw0KPj4NCj4+IGJvb2wgbWx4
NWVfZXN3aXRjaF9yZXAoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldik7DQo+PiArYm9vbCBtbHg1
ZV9lc3dpdGNoX3VwbGlua19yZXAoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldik7DQo+Pg0KPj4g
I2Vsc2UgLyogQ09ORklHX01MWDVfRVNXSVRDSCAqLw0KPj4gc3RhdGljIGlubGluZSBib29sIG1s
eDVlX2lzX3VwbGlua19yZXAoc3RydWN0IG1seDVlX3ByaXYgKnByaXYpIHsgcmV0dXJuIGZhbHNl
OyB9DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX3RjLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
dGMuYw0KPj4gaW5kZXggZGI2MTRiZC4uMzVmNjhlNCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQo+PiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPj4gQEAgLTMzNjEsNiAr
MzM2MSw3IEBAIHN0YXRpYyBpbnQgcGFyc2VfdGNfZmRiX2FjdGlvbnMoc3RydWN0IG1seDVlX3By
aXYgKnByaXYsDQo+PiAJCQkJc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3ID0gcHJpdi0+bWRldi0+
cHJpdi5lc3dpdGNoOw0KPj4gCQkJCXN0cnVjdCBuZXRfZGV2aWNlICp1cGxpbmtfZGV2ID0gbWx4
NV9lc3dpdGNoX3VwbGlua19nZXRfcHJvdG9fZGV2KGVzdywgUkVQX0VUSCk7DQo+PiAJCQkJc3Ry
dWN0IG5ldF9kZXZpY2UgKnVwbGlua191cHBlcjsNCj4+ICsJCQkJc3RydWN0IG1seDVlX3JlcF9w
cml2ICpyZXBfcHJpdjsNCj4+DQo+PiAJCQkJaWYgKGlzX2R1cGxpY2F0ZWRfb3V0cHV0X2Rldmlj
ZShwcml2LT5uZXRkZXYsDQo+PiAJCQkJCQkJCW91dF9kZXYsDQo+PiBAQCAtMzM5Niw2ICszMzk3
LDI0IEBAIHN0YXRpYyBpbnQgcGFyc2VfdGNfZmRiX2FjdGlvbnMoc3RydWN0IG1seDVlX3ByaXYg
KnByaXYsDQo+PiAJCQkJCQlyZXR1cm4gZXJyOw0KPj4gCQkJCX0NCj4+DQo+PiArCQkJCS8qIERv
bid0IGFsbG93IGZvcndhcmRpbmcgYmV0d2VlbiB1cGxpbmsuDQo+PiArCQkJCSAqDQo+PiArCQkJ
CSAqIElucHV0IHZwb3J0IHdhcyBzdG9yZWQgZXN3X2F0dHItPmluX3JlcC4NCj4+ICsJCQkJICog
SW4gTEFHIGNhc2UsICpwcml2KiBpcyB0aGUgcHJpdmF0ZSBkYXRhIG9mDQo+PiArCQkJCSAqIHVw
bGluayB3aGljaCBtYXkgYmUgbm90IHRoZSBpbnB1dCB2cG9ydC4NCj4+ICsJCQkJICovDQo+PiAr
CQkJCXJlcF9wcml2ID0gbWx4NWVfcmVwX3RvX3JlcF9wcml2KGF0dHItPmluX3JlcCk7DQo+PiAr
CQkJCWlmIChtbHg1ZV9lc3dpdGNoX3VwbGlua19yZXAocmVwX3ByaXYtPm5ldGRldikgJiYNCj4+
ICsJCQkJICAgIG1seDVlX2Vzd2l0Y2hfdXBsaW5rX3JlcChvdXRfZGV2KSkgew0KPj4gKwkJCQkJ
TkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywNCj4+ICsJCQkJCQkJICAgImRldmljZXMgYXJlIGJv
dGggdXBsaW5rLCAiDQo+IA0KPiBOZXZlciBicmVhayBlcnJvciBtZXNzYWdlcy4NCj4gDQo+IA0K
Pj4gKwkJCQkJCQkgICAiY2FuJ3Qgb2ZmbG9hZCBmb3J3YXJkaW5nIik7DQo+PiArCQkJCQlwcl9l
cnIoImRldmljZXMgJXMgJXMgYXJlIGJvdGggdXBsaW5rLCAiDQo+IA0KPiBIZXJlIGFzIHdlbGwu
DQo+IA0KPiANCj4+ICsJCQkJCSAgICAgICAiY2FuJ3Qgb2ZmbG9hZCBmb3J3YXJkaW5nXG4iLA0K
Pj4gKwkJCQkJICAgICAgIHByaXYtPm5ldGRldi0+bmFtZSwgb3V0X2Rldi0+bmFtZSk7DQo+PiAr
CQkJCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+PiArCQkJCX0NCj4+ICsNCj4+IAkJCQlpZiAoIW1s
eDVlX2lzX3ZhbGlkX2Vzd2l0Y2hfZndkX2Rldihwcml2LCBvdXRfZGV2KSkgew0KPj4gCQkJCQlO
TF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLA0KPj4gCQkJCQkJCSAgICJkZXZpY2VzIGFyZSBub3Qg
b24gc2FtZSBzd2l0Y2ggSFcsIGNhbid0IG9mZmxvYWQgZm9yd2FyZGluZyIpOw0KPj4gLS0gDQo+
PiAxLjguMy4xDQo+Pg0KDQpiZXNpZGUgd2hhdCBKaXJpIGNvbW1lbnRlZCwgdGhlIHJlc3QgbG9v
a3MgZmluZSB0byBtZS4NCg==
