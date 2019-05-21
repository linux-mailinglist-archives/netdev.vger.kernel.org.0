Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7458D25010
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfEUNXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:23:30 -0400
Received: from mail-eopbgr150043.outbound.protection.outlook.com ([40.107.15.43]:25933
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726692AbfEUNX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 09:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEf+jGGIRj4C2SF7irCO8PD+/b8x884L+HDyioFDU9Y=;
 b=JjU16mZn3tCE41ychBG4I/ZoauC9wGlsMQVT/Tm19YU2cnuyNstwAv10vI0Ltxdc4VtiBQ0xMRdseOYOAJghxCLW0A2jBpKO2Yfest7weN4R+Mz8Rfp434n6BPvbdU+ceC/xKR8ZSrGgWiJrswRXWmtVP+CFC9lPF4scWv1f7dI=
Received: from AM0PR05MB6516.eurprd05.prod.outlook.com (20.179.35.84) by
 AM0PR05MB5010.eurprd05.prod.outlook.com (52.134.89.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Tue, 21 May 2019 13:23:23 +0000
Received: from AM0PR05MB6516.eurprd05.prod.outlook.com
 ([fe80::64a1:9684:1697:4480]) by AM0PR05MB6516.eurprd05.prod.outlook.com
 ([fe80::64a1:9684:1697:4480%7]) with mapi id 15.20.1900.020; Tue, 21 May 2019
 13:23:23 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Lucas Bates <lucasb@mojatatu.com>
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
Thread-Topic: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
Thread-Index: AQHVC1Xqm0FhDSpEhku3LPr7EGO4maZvc2eAgAAd7YCAAct3gIACzUkAgAADUwCAAAkSAIAABTiAgAAjiQCAACutgIABBMEAgAAKYoA=
Date:   Tue, 21 May 2019 13:23:23 +0000
Message-ID: <vbfef4slz5k.fsf@mellanox.com>
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
In-Reply-To: <b1a0d4b5-7262-a5a0-182d-54778f9d176a@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0121.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::13) To AM0PR05MB6516.eurprd05.prod.outlook.com
 (2603:10a6:208:144::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d3fa237-236f-404d-f4c1-08d6ddef7fe2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5010;
x-ms-traffictypediagnostic: AM0PR05MB5010:
x-microsoft-antispam-prvs: <AM0PR05MB5010704AC8F3FADC9CBA3045AD070@AM0PR05MB5010.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(396003)(376002)(346002)(189003)(199004)(6116002)(54906003)(66066001)(3846002)(386003)(53546011)(6916009)(6506007)(7416002)(102836004)(99286004)(76176011)(52116002)(305945005)(7736002)(14454004)(478600001)(81156014)(8936002)(8676002)(81166006)(486006)(446003)(4326008)(11346002)(2616005)(476003)(316002)(53936002)(6512007)(6246003)(5024004)(14444005)(256004)(6486002)(25786009)(86362001)(26005)(186003)(71190400001)(71200400001)(6436002)(73956011)(66946007)(68736007)(2906002)(5660300002)(66476007)(66556008)(64756008)(66446008)(36756003)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5010;H:AM0PR05MB6516.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TduHKPO6PXx3crfK3vR1SOPqCRwLhqTG+WoIy61rEApVWTfhw1SVuJzYcSmvf5nr6qCrlyGONHLtfDJQysk7Y25He62frmVm1epK/AkEDCichS9J1ZgINTzNMPeq6Kw91EN4ByhEwxNfT9sf0/c4JxHA7ibZztBxvYK8A0+1RwycUDtMhz+kz89JT2+K/IwUPPAoEMs4w96VNL8TDe9/cAVjOoqSY5Lqvb7aSmfPmfXmivGIPiMhSQi6jtIpBR1RIZAPhvy5kljBbFl8FvR8A8kxykzhfCApsyrAwxplEICkvzl5LxXumqAnuQ1fUg3r6j9ydMZAPyLqhuaQAzlRWBJuU8lWOWvEg4kuxAkem1/Dk27EUIy+2L4ygFuDmOIHmssAaTUyBxANBmRpkWOJuBZhILaeNVNPJ08s9ssQgsU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d3fa237-236f-404d-f4c1-08d6ddef7fe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 13:23:23.5384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5010
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUdWUgMjEgTWF5IDIwMTkgYXQgMTU6NDYsIEphbWFsIEhhZGkgU2FsaW0gPGpoc0Btb2ph
dGF0dS5jb20+IHdyb3RlOg0KPiBPbiAyMDE5LTA1LTIwIDU6MTIgcC5tLiwgSmFtYWwgSGFkaSBT
YWxpbSB3cm90ZToNCj4+IE9uIDIwMTktMDUtMjAgMjozNiBwLm0uLCBFZHdhcmQgQ3JlZSB3cm90
ZToNCj4+PiBPbiAyMC8wNS8yMDE5IDE3OjI5LCBKYW1hbCBIYWRpIFNhbGltIHdyb3RlOg0KPg0K
Pj4gT2ssIHNvIHRoZSAiZ2V0IiBkb2VzIGl0LiBXaWxsIHRyeSB0byByZXByb2R1Y2Ugd2hlbiBp
IGdldCBzb21lDQo+PiBjeWNsZXMuIE1lYW50aW1lIENDaW5nIENvbmcgYW5kIFZsYWQuDQo+PiAN
Cj4NCj4NCj4gSSBoYXZlIHJlcHJvZHVjZWQgaXQgaW4gYSBzaW1wbGVyIHNldHVwLiBTZWUgYXR0
YWNoZWQuIFZsYWQgdGhpcyBpcw0KPiBsaWtlbHkgZnJvbSB5b3VyIGNoYW5nZXMuIFNvcnJ5IG5v
IGN5Y2xlcyB0byBkaWcgbW9yZS4NCg0KSmFtYWwsIHRoYW5rcyBmb3IgbWluaW1pemluZyB0aGUg
cmVwcm9kdWN0aW9uLiBJJ2xsIGxvb2sgaW50byBpdC4NCg0KPiBMdWNhcywgY2FuIHdlIGFkZCB0
aGlzIHRvIHRoZSB0ZXN0Y2FzZXM/DQo+DQo+DQo+IGNoZWVycywNCj4gamFtYWwNCj4NCj4gc3Vk
byB0YyBxZGlzYyBkZWwgZGV2IGxvIGluZ3Jlc3MNCj4gc3VkbyB0YyBxZGlzYyBhZGQgZGV2IGxv
IGluZ3Jlc3MNCj4NCj4gc3VkbyB0YyBmaWx0ZXIgYWRkIGRldiBsbyBwYXJlbnQgZmZmZjogcHJv
dG9jb2wgaXAgcHJpbyA4IHUzMiBcDQo+IG1hdGNoIGlwIGRzdCAxMjcuMC4wLjgvMzIgZmxvd2lk
IDE6MTAgXA0KPiBhY3Rpb24gdmxhbiBwdXNoIGlkIDEwMCBwcm90b2NvbCA4MDIuMXEgXA0KPiBh
Y3Rpb24gZHJvcCBpbmRleCAxMDQNCj4NCj4gc3VkbyB0YyBmaWx0ZXIgYWRkIGRldiBsbyBwYXJl
bnQgZmZmZjogcHJvdG9jb2wgaXAgcHJpbyA4IHUzMiBcDQo+IG1hdGNoIGlwIGRzdCAxMjcuMC4w
LjEwLzMyIGZsb3dpZCAxOjEwIFwNCj4gYWN0aW9uIHZsYW4gcHVzaCBpZCAxMDEgcHJvdG9jb2wg
ODAyLjFxIFwNCj4gYWN0aW9uIGRyb3AgaW5kZXggMTA0DQo+DQo+ICMNCj4gc3VkbyB0YyAtcyBm
aWx0ZXIgbHMgZGV2IGxvIHBhcmVudCBmZmZmOiBwcm90b2NvbCBpcA0KPg0KPiAjdGhpcyB3aWxs
IG5vdyBkZWxldGUgYWN0aW9uIGdhY3QgaW5kZXggMTA0KGRyb3ApIGZyb20gZGlzcGxheQ0KPiBz
dWRvIHRjIC1zIGFjdGlvbnMgZ2V0IGFjdGlvbiBkcm9wIGluZGV4IDEwNA0KPg0KPiBzdWRvIHRj
IC1zIGZpbHRlciBscyBkZXYgbG8gcGFyZW50IGZmZmY6IHByb3RvY29sIGlwDQo+DQo+ICNCdXQg
eW91IGNhbiBzdGlsbCBzZWUgaXQgaWYgeW91IGRvIHRoaXM6DQo+IHN1ZG8gdGMgLXMgYWN0aW9u
cyBnZXQgYWN0aW9uIGRyb3AgaW5kZXggMTA0DQoNCg==
