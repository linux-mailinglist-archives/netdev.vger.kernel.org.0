Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC33B43946
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732968AbfFMPMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:12:53 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:50693
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732276AbfFMNk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:40:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OL7ctYcNOc7Q7Sp27sVEUaoArffRUV92bvJMgytw3ao=;
 b=G+lAkDCmOdV3C7Pme426r1ABjy1AuPNYkrvSDGhKsIRroztElrkrr5ffreBHsIFdi8XiArCCHgTn3+MKUDCymOJLlBswVXVWV8Zm00S74fYoXu7steZojRm06u0LkJNsew0fW4QgAhHBL38/x/YjQDu23blZjx7LuNRMVKIrmVY=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3201.eurprd05.prod.outlook.com (10.171.188.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 13 Jun 2019 13:40:24 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f%3]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 13:40:24 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
CC:     Justin Pettit <jpettit@ovn.org>,
        John Hurley <john.hurley@netronome.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Index: AQHVIFmsY/4/azwa5kOjF2Jw4P/H36aZYZGAgAAJBICAAC/NAA==
Date:   Thu, 13 Jun 2019 13:40:24 +0000
Message-ID: <b96edcb0-27ee-ebd1-d5d5-d462fb3ca4a0@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <a08bde08fce26054754172786ced8bd671079833.camel@redhat.com>
 <7ad9dd803e3d961fef3ceaf77215f27e02b04981.camel@redhat.com>
In-Reply-To: <7ad9dd803e3d961fef3ceaf77215f27e02b04981.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0601CA0045.eurprd06.prod.outlook.com
 (2603:10a6:203:68::31) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a205d455-e79f-4ae0-ae04-08d6f004afa5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3201;
x-ms-traffictypediagnostic: AM4PR05MB3201:
x-microsoft-antispam-prvs: <AM4PR05MB32011262AB5A0A902E8D775ECFEF0@AM4PR05MB3201.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(366004)(346002)(136003)(396003)(189003)(199004)(486006)(256004)(31686004)(2501003)(6436002)(478600001)(305945005)(64756008)(52116002)(229853002)(2906002)(76176011)(5660300002)(4326008)(8936002)(26005)(54906003)(186003)(110136005)(14454004)(6486002)(6512007)(66946007)(71200400001)(316002)(81166006)(6116002)(3846002)(81156014)(446003)(66476007)(71190400001)(6506007)(73956011)(86362001)(99286004)(102836004)(53546011)(31696002)(2616005)(386003)(7736002)(66446008)(476003)(53936002)(68736007)(25786009)(6246003)(36756003)(8676002)(66556008)(66066001)(11346002)(7416002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3201;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8SDtx4SqSvUdvkUz/lt0xtw6J+OTFAsP1+odVw9CpWcPg3aIRxlTzzoBUFbDLqqYIXOHDseRXHkNsGKl9VbpitNNb/a/iUk64097TsyJLLXrug3+yC8Om62y6Vb0mEVZk4ZA7Q+bNU8YRijSxhBI7w9HRg9FVwfIDIo08aukcguFeKISK54NqnlpARs3tEhfdqRCHdqhRehUgkvn/ZCSsLzF9XOrLTb+M/kcDCyVR8/Q3MxbZXnbtAVWPymkmhmJN8D1eEc57WFFSSrclaa6sJLt221G/GRO8g1igTLLcZJbKTLFHfA6ukgVN5FUlmK0h0Mae+4PacSFTCinUL9Aykt4kz2COp2UxGxnaDkuCB1E6KeqcrEbVbGJIP24hRrSrBLD+NnKQJ4nUtsCnpevrtdVYVr+Gg4faU/ZWJ4vYVM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4909A626AD4FE4488605CF1672ABDFF3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a205d455-e79f-4ae0-ae04-08d6f004afa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 13:40:24.0887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3201
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzEzLzIwMTkgMTo0OSBQTSwgRGF2aWRlIENhcmF0dGkgd3JvdGU6DQo+IE9uIFRodSwg
MjAxOS0wNi0xMyBhdCAxMjoxNiArMDIwMCwgRGF2aWRlIENhcmF0dGkgd3JvdGU6DQo+PiBoZWxs
byBQYXVsIQ0KPj4NCj4+IE9uIFR1ZSwgMjAxOS0wNi0xMSBhdCAxNjoyOCArMDMwMCwgUGF1bCBC
bGFrZXkgd3JvdGU6DQo+Pg0KPj4+ICsjZW5kaWYgLyogX19ORVRfVENfQ1RfSCAqLw0KPj4+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvcGt0X2Nscy5oIGIvaW5jbHVkZS91YXBpL2xp
bnV4L3BrdF9jbHMuaA0KPj4+IGluZGV4IGE5MzY4MGYuLmM1MjY0ZDcgMTAwNjQ0DQo+Pj4gLS0t
IGEvaW5jbHVkZS91YXBpL2xpbnV4L3BrdF9jbHMuaA0KPj4+ICsrKyBiL2luY2x1ZGUvdWFwaS9s
aW51eC9wa3RfY2xzLmgNCj4+PiBAQCAtODMsNiArODMsNyBAQCBlbnVtIHsNCj4+PiAgICNkZWZp
bmUgVENBX0FDVF9TSU1QIDIyDQo+Pj4gICAjZGVmaW5lIFRDQV9BQ1RfSUZFIDI1DQo+Pj4gICAj
ZGVmaW5lIFRDQV9BQ1RfU0FNUExFIDI2DQo+Pj4gKyNkZWZpbmUgVENBX0FDVF9DVCAyNw0KPj4g
Xl4gIEkgdGhpbmsgeW91IGNhbid0IHVzZSAyNyAoYWN0X2N0aW5mbyBmb3Jnb3QgdG8gZXhwbGlj
aXRseSBkZWZpbmUgaXQpLA0KPj4gb3IgdGhlIHVBUEkgd2lsbCBicmVhay4gU2VlIGJlbG93Og0K
PiBbLi4uXQ0KPg0KPiBOZXZlcm1pbmQsIEkganVzdCByZWFkIHRoZSBjb21tZW50IGFib3ZlIHRo
ZSBkZWZpbml0aW9uIG9mIFRDQV9BQ1RfR0FDVC4NCj4+IHNvLCBJIHRoaW5rIHlvdSBzaG91bGQg
dXNlIDI4LiBBbmQgSSB3aWxsIHNlbmQgYSBwYXRjaCBmb3IgbmV0LW5leHQgbm93DQo+PiB0aGF0
IGFkZHMgdGhlIG1pc3NpbmcgZGVmaW5lIGZvciBUQ0FfSURfQ1RJTkZPLiBPaz8NCj4gd2UgZG9u
J3QgbmVlZCB0byBwYXRjaCBwa3RfY2xzLmguIEp1c3QgYXZvaWQNCj4NCj4gI2RlZmluZSBUQ0Ff
QUNUX0NUIDI3DQo+DQo+IGFuZCB0aGUgYXNzaWdubWVudCBpbiB0aGUgZW51bSwgdGhhdCBzaG91
bGQgYmUgc3VmZmljaWVudC4NCg0KDQpSaWdodCwgdGhhbmtzLg0KDQo=
