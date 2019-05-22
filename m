Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C5126962
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbfEVRuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:50:07 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:2020
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728450AbfEVRuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 13:50:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQWPVFeIoDgQLLEQf6do4yW4kurrbnUOwAY+rZYjTvk=;
 b=ejfGyIuT1qGOSKbXROhEtu4Nrr5vkVOmgVFMiOq3o8qvry6SMFaBedbmCFcS3t+G9I7gWFImZVpesgcEVB3hv4dqdB8Mnl5MN4atqG/n+zxxtvaBlcCEJPRublWpRm5/FHzyNw7IzkDlXVL4mvjGeUXfdjG2FcdiPTlDEfHhLmw=
Received: from AM0PR05MB6516.eurprd05.prod.outlook.com (20.179.35.84) by
 AM0PR05MB6372.eurprd05.prod.outlook.com (20.179.33.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Wed, 22 May 2019 17:49:59 +0000
Received: from AM0PR05MB6516.eurprd05.prod.outlook.com
 ([fe80::64a1:9684:1697:4480]) by AM0PR05MB6516.eurprd05.prod.outlook.com
 ([fe80::64a1:9684:1697:4480%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 17:49:53 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Lucas Bates <lucasb@mojatatu.com>
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
Thread-Topic: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
Thread-Index: AQHVC1Xqm0FhDSpEhku3LPr7EGO4maZvc2eAgAAd7YCAAct3gIACzUkAgAADUwCAAAkSAIAABTiAgAAjiQCAACutgIABBMEAgAAKYoCAAa+tgIAAJiQAgAAG+YA=
Date:   Wed, 22 May 2019 17:49:53 +0000
Message-ID: <vbfa7fee5vm.fsf@mellanox.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
 <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
 <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
 <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
 <d70ed72f-69db-dfd0-3c0d-42728dbf45c7@solarflare.com>
 <e0603687-272d-6d41-1c3a-9ea14aa8cfad@mojatatu.com>
 <b1a0d4b5-7262-a5a0-182d-54778f9d176a@mojatatu.com>
 <vbfef4slz5k.fsf@mellanox.com> <vbfblzuedcq.fsf@mellanox.com>
 <b147865f-5224-b66b-2824-8c1c8986900f@mojatatu.com>
In-Reply-To: <b147865f-5224-b66b-2824-8c1c8986900f@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0292.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::16) To AM0PR05MB6516.eurprd05.prod.outlook.com
 (2603:10a6:208:144::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 485f0027-9dc3-4519-1bb8-08d6dedde517
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6372;
x-ms-traffictypediagnostic: AM0PR05MB6372:
x-microsoft-antispam-prvs: <AM0PR05MB63728E170DCF0C46A7436F1BAD000@AM0PR05MB6372.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(305945005)(66476007)(64756008)(66556008)(66446008)(73956011)(66946007)(256004)(14444005)(5024004)(186003)(2906002)(316002)(36756003)(66066001)(2616005)(11346002)(7736002)(102836004)(5660300002)(71200400001)(71190400001)(476003)(54906003)(26005)(3846002)(6116002)(7416002)(99286004)(6512007)(52116002)(68736007)(14454004)(486006)(76176011)(53546011)(6506007)(386003)(8936002)(8676002)(86362001)(81156014)(81166006)(6246003)(446003)(229853002)(6916009)(25786009)(6436002)(478600001)(53936002)(6486002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6372;H:AM0PR05MB6516.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: szHr1wVPGZ/Yi+pmE9NUaSGBAyb9E+NqkqEzbAQlnh+Bi5B5AXgNPdQfYwis2kCsMr7A9SPsB1dEzcScQnq1cI/FwzJS4T9Tjenl/FIX0ZdMS0LVp4YdqYaRJhqdxQ3P+KC3vuaur46ixlqOdfvI5gVkPcS7UgXjQm4NzfPS8D8+0QcvZU0q4AcJOTM4sALdC9vjlVYtndXeFb5sjTnd+0ULYqF5w2TTFihqyErkFq9V2ToReIWPQ/bKwgIhDozGQnhisCXUL2xywo8Dv4XI0CRTrBgmiaRwifeM9t1XLHtXPB7DaZUfrtg+ojfWyWJ+VoCB74rHst965fY66Udg39YvoVT8vVBfw6ZnAwX2xAX2KSB5+7lRo9h6fjP1uSC3IVF7AtvfzAxYEluJ+iOrLPfQl4+pFquWj1sMclHpWpU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485f0027-9dc3-4519-1bb8-08d6dedde517
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 17:49:53.5477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6372
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBXZWQgMjIgTWF5IDIwMTkgYXQgMjA6MjQsIEphbWFsIEhhZGkgU2FsaW0gPGpoc0Btb2ph
dGF0dS5jb20+IHdyb3RlOg0KPiBPbiAyMDE5LTA1LTIyIDExOjA4IGEubS4sIFZsYWQgQnVzbG92
IHdyb3RlOg0KPj4NCj4+IE9uIFR1ZSAyMSBNYXkgMjAxOSBhdCAxNjoyMywgVmxhZCBCdXNsb3Yg
PHZsYWRidUBtZWxsYW5veC5jb20+IHdyb3RlOg0KPg0KPj4NCj4+IEl0IHNlZW1zIHRoYXQgY3Vs
cHJpdCBpbiB0aGlzIGNhc2UgaXMgdGNfYWN0aW9uLT5vcmRlciBmaWVsZC4gSXQgaXMgdXNlZA0K
Pj4gYXMgbmxhIGF0dHJ0eXBlIHdoZW4gZHVtcGluZyBhY3Rpb25zLiBJbml0aWFsbHkgaXQgaXMg
c2V0IGFjY29yZGluZyB0bw0KPj4gb3JkZXJpbmcgb2YgYWN0aW9ucyBvZiBmaWx0ZXIgdGhhdCBj
cmVhdGVzIHRoZW0uIEhvd2V2ZXIsIGl0IGlzDQo+PiBvdmVyd3JpdHRlbiBpbiB0Y2FfYWN0aW9u
X2dkKCkgZWFjaCB0aW1lIGFjdGlvbiBpcyBkdW1wZWQgdGhyb3VnaCBhY3Rpb24NCj4+IEFQSSAo
YWNjb3JkaW5nIHRvIGFjdGlvbiBwb3NpdGlvbiBpbiB0YiBhcnJheSkgYW5kIHdoZW4gbmV3IGZp
bHRlciBpcw0KPj4gYXR0YWNoZWQgdG8gc2hhcmVkIGFjdGlvbiAoYWNjb3JkaW5nIHRvIGFjdGlv
biBvcmRlciBvbiB0aGUgZmlsdGVyKS4NCj4+IFdpdGggdGhpcyB3ZSBoYXZlIGFub3RoZXIgd2F5
IHRvIHJlcHJvZHVjZSB0aGUgYnVnOg0KPj4NCj4+IHN1ZG8gdGMgcWRpc2MgYWRkIGRldiBsbyBp
bmdyZXNzDQo+Pg0KPj4gI3NoYXJlZCBhY3Rpb24gaXMgdGhlIGZpcnN0IGFjdGlvbiAob3JkZXIg
MSkNCj4+IHN1ZG8gdGMgZmlsdGVyIGFkZCBkZXYgbG8gcGFyZW50IGZmZmY6IHByb3RvY29sIGlw
IHByaW8gOCB1MzIgXA0KPj4gbWF0Y2ggaXAgZHN0IDEyNy4wLjAuOC8zMiBmbG93aWQgMToxMCBc
DQo+PiBhY3Rpb24gZHJvcCBpbmRleCAxMDQgXA0KPj4gYWN0aW9uIHZsYW4gcHVzaCBpZCAxMDAg
cHJvdG9jb2wgODAyLjFxDQo+Pg0KPj4gI3NoYXJlZCBhY3Rpb24gaXMgdGhlIHRoZSBzZWNvbmQg
YWN0aW9uIChvcmRlciAyKQ0KPj4gc3VkbyB0YyBmaWx0ZXIgYWRkIGRldiBsbyBwYXJlbnQgZmZm
ZjogcHJvdG9jb2wgaXAgcHJpbyA4IHUzMiBcDQo+PiBtYXRjaCBpcCBkc3QgMTI3LjAuMC4xMC8z
MiBmbG93aWQgMToxMCBcDQo+PiBhY3Rpb24gdmxhbiBwdXNoIGlkIDEwMSBwcm90b2NvbCA4MDIu
MXEgXA0KPj4gYWN0aW9uIGRyb3AgaW5kZXggMTA0DQo+Pg0KPj4gIyBOb3cgYWN0aW9uIGlzIG9u
bHkgdmlzaWJsZSBvbiBvbmUgZmlsdGVyDQo+PiBzdWRvIHRjIC1zIGZpbHRlciBscyBkZXYgbG8g
cGFyZW50IGZmZmY6IHByb3RvY29sIGlwDQo+Pg0KPg0KPiBPaywgdGhhbmtzIGZvciBjaGFzaW5n
IHRoaXMuIEEgdGVzdCBjYXNlIGkgaGFkIGluIG1pbmQgaXMgdG8NCj4gbWF5YmUgaGF2ZSAzIGFj
dGlvbnMuIEFkZCB0aGUgZHJvcCBpbiB0aGUgbWlkZGxlIGZvciBvbmUNCj4gYW5kIGF0IHRoZSBi
ZWdnaW5nIGZvciBhbm90aGVyIGFuZCBzZWUgaWYgdGhleSBhcmUgdmlzaWJsZQ0KPiB3aXRoIHRo
ZSBwYXRjaC4NCj4gSWYgeW91IGRvbnQgaGF2ZSB0aW1lIEkgY2FuIHRlc3QgbWF5YmUgQU0gdG9t
bW9yb3cuDQoNCldvcmtzIHdpdGggbXkgcGF0Y2g6DQoNCn4kIHN1ZG8gdGMgcWRpc2MgZGVsIGRl
diBsbyBpbmdyZXNzDQp+JCBzdWRvIHRjIHFkaXNjIGFkZCBkZXYgbG8gaW5ncmVzcw0KfiQgc3Vk
byB0YyBmaWx0ZXIgYWRkIGRldiBsbyBwYXJlbnQgZmZmZjogcHJvdG9jb2wgaXAgcHJpbyA4IHUz
MiBcDQo+IG1hdGNoIGlwIGRzdCAxMjcuMC4wLjgvMzIgZmxvd2lkIDE6MTAgXA0KPiBhY3Rpb24g
ZHJvcCBpbmRleCAxMDQgXA0KPiBtaXJyZWQgZWdyZXNzIHJlZGlyZWN0IGRldiBlbnMxZjAgXA0K
PiBhY3Rpb24gdmxhbiBwdXNoIGlkIDEwMCBwcm90b2NvbCA4MDIuMXENCn4kIHN1ZG8gdGMgZmls
dGVyIGFkZCBkZXYgbG8gcGFyZW50IGZmZmY6IHByb3RvY29sIGlwIHByaW8gOCB1MzIgXA0KPiBt
YXRjaCBpcCBkc3QgMTI3LjAuMC4xMC8zMiBmbG93aWQgMToxMCBcDQo+IGFjdGlvbiB2bGFuIHB1
c2ggaWQgMTAxIHByb3RvY29sIDgwMi4xcSBcDQo+IGFjdGlvbiBkcm9wIGluZGV4IDEwNCBcDQo+
IG1pcnJlZCBlZ3Jlc3MgcmVkaXJlY3QgZGV2IGVuczFmMA0KfiQgc3VkbyB0YyAtcyBmaWx0ZXIg
bHMgZGV2IGxvIHBhcmVudCBmZmZmOiBwcm90b2NvbCBpcA0KZmlsdGVyIHByZWYgOCB1MzIgY2hh
aW4gMA0KZmlsdGVyIHByZWYgOCB1MzIgY2hhaW4gMCBmaCA4MDA6IGh0IGRpdmlzb3IgMQ0KZmls
dGVyIHByZWYgOCB1MzIgY2hhaW4gMCBmaCA4MDA6OjgwMCBvcmRlciAyMDQ4IGtleSBodCA4MDAg
Ymt0IDAgZmxvd2lkIDE6MTAgbm90X2luX2h3ICAocnVsZSBoaXQgMCBzdWNjZXNzIDApDQogIG1h
dGNoIDdmMDAwMDA4L2ZmZmZmZmZmIGF0IDE2IChzdWNjZXNzIDAgKQ0KICAgICAgICBhY3Rpb24g
b3JkZXIgMTogZ2FjdCBhY3Rpb24gZHJvcA0KICAgICAgICAgcmFuZG9tIHR5cGUgbm9uZSBwYXNz
IHZhbCAwDQogICAgICAgICBpbmRleCAxMDQgcmVmIDIgYmluZCAyIGluc3RhbGxlZCA4IHNlYyB1
c2VkIDggc2VjDQogICAgICAgIEFjdGlvbiBzdGF0aXN0aWNzOg0KICAgICAgICBTZW50IDAgYnl0
ZXMgMCBwa3QgKGRyb3BwZWQgMCwgb3ZlcmxpbWl0cyAwIHJlcXVldWVzIDApDQogICAgICAgIGJh
Y2tsb2cgMGIgMHAgcmVxdWV1ZXMgMA0KDQogICAgICAgIGFjdGlvbiBvcmRlciAyOiBtaXJyZWQg
KEVncmVzcyBSZWRpcmVjdCB0byBkZXZpY2UgZW5zMWYwKSBzdG9sZW4NCiAgICAgICAgaW5kZXgg
MSByZWYgMSBiaW5kIDEgaW5zdGFsbGVkIDggc2VjIHVzZWQgOCBzZWMNCiAgICAgICAgQWN0aW9u
IHN0YXRpc3RpY3M6DQogICAgICAgIFNlbnQgMCBieXRlcyAwIHBrdCAoZHJvcHBlZCAwLCBvdmVy
bGltaXRzIDAgcmVxdWV1ZXMgMCkNCiAgICAgICAgYmFja2xvZyAwYiAwcCByZXF1ZXVlcyAwDQoN
CiAgICAgICAgYWN0aW9uIG9yZGVyIDM6IHZsYW4gIHB1c2ggaWQgMTAwIHByb3RvY29sIDgwMi4x
USBwcmlvcml0eSAwIHBpcGUNCiAgICAgICAgIGluZGV4IDEgcmVmIDEgYmluZCAxIGluc3RhbGxl
ZCA4IHNlYyB1c2VkIDggc2VjDQogICAgICAgIEFjdGlvbiBzdGF0aXN0aWNzOg0KICAgICAgICBT
ZW50IDAgYnl0ZXMgMCBwa3QgKGRyb3BwZWQgMCwgb3ZlcmxpbWl0cyAwIHJlcXVldWVzIDApDQog
ICAgICAgIGJhY2tsb2cgMGIgMHAgcmVxdWV1ZXMgMA0KDQpmaWx0ZXIgcHJlZiA4IHUzMiBjaGFp
biAwIGZoIDgwMDo6ODAxIG9yZGVyIDIwNDkga2V5IGh0IDgwMCBia3QgMCBmbG93aWQgMToxMCBu
b3RfaW5faHcgIChydWxlIGhpdCAwIHN1Y2Nlc3MgMCkNCiAgbWF0Y2ggN2YwMDAwMGEvZmZmZmZm
ZmYgYXQgMTYgKHN1Y2Nlc3MgMCApDQogICAgICAgIGFjdGlvbiBvcmRlciAxOiB2bGFuICBwdXNo
IGlkIDEwMSBwcm90b2NvbCA4MDIuMVEgcHJpb3JpdHkgMCBwaXBlDQogICAgICAgICBpbmRleCAy
IHJlZiAxIGJpbmQgMSBpbnN0YWxsZWQgNCBzZWMgdXNlZCA0IHNlYw0KICAgICAgICBBY3Rpb24g
c3RhdGlzdGljczoNCiAgICAgICAgU2VudCAwIGJ5dGVzIDAgcGt0IChkcm9wcGVkIDAsIG92ZXJs
aW1pdHMgMCByZXF1ZXVlcyAwKQ0KICAgICAgICBiYWNrbG9nIDBiIDBwIHJlcXVldWVzIDANCg0K
ICAgICAgICBhY3Rpb24gb3JkZXIgMjogZ2FjdCBhY3Rpb24gZHJvcA0KICAgICAgICAgcmFuZG9t
IHR5cGUgbm9uZSBwYXNzIHZhbCAwDQogICAgICAgICBpbmRleCAxMDQgcmVmIDIgYmluZCAyIGlu
c3RhbGxlZCA4IHNlYyB1c2VkIDggc2VjDQogICAgICAgIEFjdGlvbiBzdGF0aXN0aWNzOg0KICAg
ICAgICBTZW50IDAgYnl0ZXMgMCBwa3QgKGRyb3BwZWQgMCwgb3ZlcmxpbWl0cyAwIHJlcXVldWVz
IDApDQogICAgICAgIGJhY2tsb2cgMGIgMHAgcmVxdWV1ZXMgMA0KDQogICAgICAgIGFjdGlvbiBv
cmRlciAzOiBtaXJyZWQgKEVncmVzcyBSZWRpcmVjdCB0byBkZXZpY2UgZW5zMWYwKSBzdG9sZW4N
CiAgICAgICAgaW5kZXggMiByZWYgMSBiaW5kIDEgaW5zdGFsbGVkIDQgc2VjIHVzZWQgNCBzZWMN
CiAgICAgICAgQWN0aW9uIHN0YXRpc3RpY3M6DQogICAgICAgIFNlbnQgMCBieXRlcyAwIHBrdCAo
ZHJvcHBlZCAwLCBvdmVybGltaXRzIDAgcmVxdWV1ZXMgMCkNCiAgICAgICAgYmFja2xvZyAwYiAw
cCByZXF1ZXVlcyAwDQoNCg==
