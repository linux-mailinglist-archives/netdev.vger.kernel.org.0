Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD2E266A6
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 17:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfEVPIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 11:08:31 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:33537
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729777AbfEVPIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 11:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L/HEQvIezpdYs12bb1WM4jnx/RIfdBhzpy7EoD2jAY=;
 b=FxiYjNRbIO+UIUzzNPagADRUwWy+mskAzrfqIobfQTxsREiR7fU5FZodkM1LE+C+OLvlCeajOHRtN6cwuWVsjQFesuUvQWPLtHpEyv7+Bibk8etnv3607+gTEfkMkc7PxUHb8GAbyFD8W8ZU33ZZ0VHeGxw3lcAXWlIah4rjR8U=
Received: from AM0PR05MB6516.eurprd05.prod.outlook.com (20.179.35.84) by
 AM0PR05MB6131.eurprd05.prod.outlook.com (20.178.118.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 22 May 2019 15:08:27 +0000
Received: from AM0PR05MB6516.eurprd05.prod.outlook.com
 ([fe80::64a1:9684:1697:4480]) by AM0PR05MB6516.eurprd05.prod.outlook.com
 ([fe80::64a1:9684:1697:4480%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 15:08:27 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
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
Thread-Index: AQHVC1Xqm0FhDSpEhku3LPr7EGO4maZvc2eAgAAd7YCAAct3gIACzUkAgAADUwCAAAkSAIAABTiAgAAjiQCAACutgIABBMEAgAAKYoCAAa+tgA==
Date:   Wed, 22 May 2019 15:08:26 +0000
Message-ID: <vbfblzuedcq.fsf@mellanox.com>
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
 <vbfef4slz5k.fsf@mellanox.com>
In-Reply-To: <vbfef4slz5k.fsf@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VE1PR03CA0035.eurprd03.prod.outlook.com
 (2603:10a6:803:118::24) To AM0PR05MB6516.eurprd05.prod.outlook.com
 (2603:10a6:208:144::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d99eb3b7-1456-48be-d9f4-08d6dec75751
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6131;
x-ms-traffictypediagnostic: AM0PR05MB6131:
x-microsoft-antispam-prvs: <AM0PR05MB613139B508B03E918D52B7A4AD000@AM0PR05MB6131.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(53936002)(2906002)(386003)(6506007)(7416002)(66446008)(486006)(66476007)(66556008)(64756008)(66946007)(86362001)(36756003)(73956011)(8676002)(4326008)(71190400001)(71200400001)(68736007)(2616005)(186003)(7736002)(8936002)(11346002)(102836004)(25786009)(446003)(81166006)(305945005)(53546011)(26005)(476003)(81156014)(6246003)(110136005)(6486002)(54906003)(6512007)(6436002)(478600001)(6116002)(3846002)(14454004)(316002)(229853002)(66066001)(5660300002)(14444005)(256004)(99286004)(52116002)(76176011)(5024004)(4226003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6131;H:AM0PR05MB6516.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d7DdeeBeQOLvo7FTXiKX5kOdyzmgD3l4zbRh9bzTSTxXpa6+UQh6JJGeu3rLnr4tmdtfANl+CEWhD98AUVJvpmWb3+L/0oHYTyMQDED2uBH8SaEjKdZHEvOdK8RHzSFEprQbo00v2Jx6FeRQxzKZFIVJsgf9VPaRGmk9JobvNRD5N6sHCZmOUK+StTtSECZ6JqOT9ptKVHnPC4N5LpeEz15CXvinrkMLJJbOxbYBvtKh+C7azx4GCnZu9ArLh70VTzislX57ImIvuKygGCMYo1aQoEdTzsOJ7jDiXzm4aW7POB+LQigg0QSOqVqCg5dgaWyjD0UgIMBCENqLb5cc6Mf8j58al/GJ5K69mEjVDJFPN2dD51qu+8KTHFYob+llzOKN4pug8rD7CpW9z6euyKb3T71SGWmLZpsNY984+10=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d99eb3b7-1456-48be-d9f4-08d6dec75751
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 15:08:27.0000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUdWUgMjEgTWF5IDIwMTkgYXQgMTY6MjMsIFZsYWQgQnVzbG92IDx2bGFkYnVAbWVsbGFu
b3guY29tPiB3cm90ZToNCj4gT24gVHVlIDIxIE1heSAyMDE5IGF0IDE1OjQ2LCBKYW1hbCBIYWRp
IFNhbGltIDxqaHNAbW9qYXRhdHUuY29tPiB3cm90ZToNCj4+IE9uIDIwMTktMDUtMjAgNToxMiBw
Lm0uLCBKYW1hbCBIYWRpIFNhbGltIHdyb3RlOg0KPj4+IE9uIDIwMTktMDUtMjAgMjozNiBwLm0u
LCBFZHdhcmQgQ3JlZSB3cm90ZToNCj4+Pj4gT24gMjAvMDUvMjAxOSAxNzoyOSwgSmFtYWwgSGFk
aSBTYWxpbSB3cm90ZToNCj4+DQo+Pj4gT2ssIHNvIHRoZSAiZ2V0IiBkb2VzIGl0LiBXaWxsIHRy
eSB0byByZXByb2R1Y2Ugd2hlbiBpIGdldCBzb21lDQo+Pj4gY3ljbGVzLiBNZWFudGltZSBDQ2lu
ZyBDb25nIGFuZCBWbGFkLg0KPj4+DQo+Pg0KPj4NCj4+IEkgaGF2ZSByZXByb2R1Y2VkIGl0IGlu
IGEgc2ltcGxlciBzZXR1cC4gU2VlIGF0dGFjaGVkLiBWbGFkIHRoaXMgaXMNCj4+IGxpa2VseSBm
cm9tIHlvdXIgY2hhbmdlcy4gU29ycnkgbm8gY3ljbGVzIHRvIGRpZyBtb3JlLg0KPg0KPiBKYW1h
bCwgdGhhbmtzIGZvciBtaW5pbWl6aW5nIHRoZSByZXByb2R1Y3Rpb24uIEknbGwgbG9vayBpbnRv
IGl0Lg0KPg0KPj4gTHVjYXMsIGNhbiB3ZSBhZGQgdGhpcyB0byB0aGUgdGVzdGNhc2VzPw0KPj4N
Cj4+DQo+PiBjaGVlcnMsDQo+PiBqYW1hbA0KPj4NCj4+IHN1ZG8gdGMgcWRpc2MgZGVsIGRldiBs
byBpbmdyZXNzDQo+PiBzdWRvIHRjIHFkaXNjIGFkZCBkZXYgbG8gaW5ncmVzcw0KPj4NCj4+IHN1
ZG8gdGMgZmlsdGVyIGFkZCBkZXYgbG8gcGFyZW50IGZmZmY6IHByb3RvY29sIGlwIHByaW8gOCB1
MzIgXA0KPj4gbWF0Y2ggaXAgZHN0IDEyNy4wLjAuOC8zMiBmbG93aWQgMToxMCBcDQo+PiBhY3Rp
b24gdmxhbiBwdXNoIGlkIDEwMCBwcm90b2NvbCA4MDIuMXEgXA0KPj4gYWN0aW9uIGRyb3AgaW5k
ZXggMTA0DQo+Pg0KPj4gc3VkbyB0YyBmaWx0ZXIgYWRkIGRldiBsbyBwYXJlbnQgZmZmZjogcHJv
dG9jb2wgaXAgcHJpbyA4IHUzMiBcDQo+PiBtYXRjaCBpcCBkc3QgMTI3LjAuMC4xMC8zMiBmbG93
aWQgMToxMCBcDQo+PiBhY3Rpb24gdmxhbiBwdXNoIGlkIDEwMSBwcm90b2NvbCA4MDIuMXEgXA0K
Pj4gYWN0aW9uIGRyb3AgaW5kZXggMTA0DQo+Pg0KPj4gIw0KPj4gc3VkbyB0YyAtcyBmaWx0ZXIg
bHMgZGV2IGxvIHBhcmVudCBmZmZmOiBwcm90b2NvbCBpcA0KPj4NCj4+ICN0aGlzIHdpbGwgbm93
IGRlbGV0ZSBhY3Rpb24gZ2FjdCBpbmRleCAxMDQoZHJvcCkgZnJvbSBkaXNwbGF5DQo+PiBzdWRv
IHRjIC1zIGFjdGlvbnMgZ2V0IGFjdGlvbiBkcm9wIGluZGV4IDEwNA0KPj4NCj4+IHN1ZG8gdGMg
LXMgZmlsdGVyIGxzIGRldiBsbyBwYXJlbnQgZmZmZjogcHJvdG9jb2wgaXANCj4+DQo+PiAjQnV0
IHlvdSBjYW4gc3RpbGwgc2VlIGl0IGlmIHlvdSBkbyB0aGlzOg0KPj4gc3VkbyB0YyAtcyBhY3Rp
b25zIGdldCBhY3Rpb24gZHJvcCBpbmRleCAxMDQNCg0KSXQgc2VlbXMgdGhhdCBjdWxwcml0IGlu
IHRoaXMgY2FzZSBpcyB0Y19hY3Rpb24tPm9yZGVyIGZpZWxkLiBJdCBpcyB1c2VkDQphcyBubGEg
YXR0cnR5cGUgd2hlbiBkdW1waW5nIGFjdGlvbnMuIEluaXRpYWxseSBpdCBpcyBzZXQgYWNjb3Jk
aW5nIHRvDQpvcmRlcmluZyBvZiBhY3Rpb25zIG9mIGZpbHRlciB0aGF0IGNyZWF0ZXMgdGhlbS4g
SG93ZXZlciwgaXQgaXMNCm92ZXJ3cml0dGVuIGluIHRjYV9hY3Rpb25fZ2QoKSBlYWNoIHRpbWUg
YWN0aW9uIGlzIGR1bXBlZCB0aHJvdWdoIGFjdGlvbg0KQVBJIChhY2NvcmRpbmcgdG8gYWN0aW9u
IHBvc2l0aW9uIGluIHRiIGFycmF5KSBhbmQgd2hlbiBuZXcgZmlsdGVyIGlzDQphdHRhY2hlZCB0
byBzaGFyZWQgYWN0aW9uIChhY2NvcmRpbmcgdG8gYWN0aW9uIG9yZGVyIG9uIHRoZSBmaWx0ZXIp
Lg0KV2l0aCB0aGlzIHdlIGhhdmUgYW5vdGhlciB3YXkgdG8gcmVwcm9kdWNlIHRoZSBidWc6DQoN
CnN1ZG8gdGMgcWRpc2MgYWRkIGRldiBsbyBpbmdyZXNzDQoNCiNzaGFyZWQgYWN0aW9uIGlzIHRo
ZSBmaXJzdCBhY3Rpb24gKG9yZGVyIDEpDQpzdWRvIHRjIGZpbHRlciBhZGQgZGV2IGxvIHBhcmVu
dCBmZmZmOiBwcm90b2NvbCBpcCBwcmlvIDggdTMyIFwNCm1hdGNoIGlwIGRzdCAxMjcuMC4wLjgv
MzIgZmxvd2lkIDE6MTAgXA0KYWN0aW9uIGRyb3AgaW5kZXggMTA0IFwNCmFjdGlvbiB2bGFuIHB1
c2ggaWQgMTAwIHByb3RvY29sIDgwMi4xcQ0KDQojc2hhcmVkIGFjdGlvbiBpcyB0aGUgdGhlIHNl
Y29uZCBhY3Rpb24gKG9yZGVyIDIpDQpzdWRvIHRjIGZpbHRlciBhZGQgZGV2IGxvIHBhcmVudCBm
ZmZmOiBwcm90b2NvbCBpcCBwcmlvIDggdTMyIFwNCm1hdGNoIGlwIGRzdCAxMjcuMC4wLjEwLzMy
IGZsb3dpZCAxOjEwIFwNCmFjdGlvbiB2bGFuIHB1c2ggaWQgMTAxIHByb3RvY29sIDgwMi4xcSBc
DQphY3Rpb24gZHJvcCBpbmRleCAxMDQNCg0KIyBOb3cgYWN0aW9uIGlzIG9ubHkgdmlzaWJsZSBv
biBvbmUgZmlsdGVyDQpzdWRvIHRjIC1zIGZpbHRlciBscyBkZXYgbG8gcGFyZW50IGZmZmY6IHBy
b3RvY29sIGlwDQoNClRoZSB1c2FnZSBvZiB0Y19hY3Rpb24tPm9yZGVyIGlzIGluaGVyZW50bHkg
aW5jb3JyZWN0IGZvciBzaGFyZWQgYWN0aW9ucw0KYW5kIEkgZG9uJ3QgcmVhbGx5IHVuZGVyc3Rh
bmQgdGhlIHJlYXNvbiBmb3IgdXNpbmcgaXQgaW4gZmlyc3QgcGxhY2UuDQpJJ20gc2VuZGluZyBS
RkMgcGF0Y2ggdGhhdCBmaXhlcyB0aGUgaXNzdWUgYnkganVzdCB1c2luZyBhY3Rpb24gcG9zaXRp
b24NCmluIHRiIGFycmF5IGZvciBhdHRydHlwZSBpbnN0ZWFkIG9mIG9yZGVyIGZpZWxkLCBhbmQg
aXQgc2VlbXMgdG8gc29sdmUNCmJvdGggaXNzdWVzIGZvciBtZS4gUGxlYXNlIGNoZWNrIGl0IG91
dCB0byB2ZXJpZnkgdGhhdCBJJ20gbm90IGJyZWFraW5nDQpzb21ldGhpbmcuIEFsc28sIHBsZWFz
ZSBhZHZpc2Ugb24gImZpeGVzIiB0YWcgc2luY2UgdGhpcyBwcm9ibGVtIGRvZXNuJ3QNCnNlZW0g
dG8gYmUgZGlyZWN0bHkgY2F1c2VkIGJ5IG15IGFjdCBBUEkgcmVmYWN0b3JpbmcuDQo=
