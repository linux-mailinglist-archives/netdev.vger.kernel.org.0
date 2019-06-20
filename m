Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5074C86D
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 09:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfFTHcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 03:32:07 -0400
Received: from mail-eopbgr00078.outbound.protection.outlook.com ([40.107.0.78]:49028
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbfFTHcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 03:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtL3qLNOYBoTjjNE+FjK1/9M0xKeQN73j+qB4p+p4ls=;
 b=cb9SX5B42Imcn/a9u7VgE5D7855+qVgTiZKj9TuJYFd1oM3pmIcZ+Z5yvT019ChvQUVPuhn8fq4DNcGzns2V9jpmdfTi84m0Wn6X3HnOep6eYZaW9Xu258nZTrdmzgRrU1RBeZavJ1rPulfpjqZKZUzcTBfaCIeSelmG4MUACW8=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3251.eurprd05.prod.outlook.com (10.171.187.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 20 Jun 2019 07:32:02 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f%3]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 07:32:02 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Index: AQHVIFmsY/4/azwa5kOjF2Jw4P/H36aWexsAgAAEYgCAABY5AIAABU8AgATcYICAABVagIAGEVaAgAKVtIA=
Date:   Thu, 20 Jun 2019 07:32:02 +0000
Message-ID: <db10725e-d31a-efda-e57e-9978fd680c92@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <87d0jkgr3r.fsf@toke.dk> <da87a939-9000-8371-672a-a949f834caea@mellanox.com>
 <877e9sgmp1.fsf@toke.dk> <20190611155350.GC3436@localhost.localdomain>
 <CAM_iQpX1jFBYCLu1t+SbuxKDMr3_c2Fip0APwLebO9tf_hqs8w@mail.gmail.com>
 <20190614192403.GK3436@localhost.localdomain>
 <CAM_iQpWLrRKKr4v6sUWeFfaJDJe4tGHdCAfUttxV4oQim=-9Bw@mail.gmail.com>
In-Reply-To: <CAM_iQpWLrRKKr4v6sUWeFfaJDJe4tGHdCAfUttxV4oQim=-9Bw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0055.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::32) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45edea9e-d3c5-4fe8-66ad-08d6f55162f8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3251;
x-ms-traffictypediagnostic: AM4PR05MB3251:
x-microsoft-antispam-prvs: <AM4PR05MB32519C04D7386617BC08ABACCFE40@AM4PR05MB3251.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39860400002)(376002)(396003)(366004)(199004)(189003)(7416002)(64756008)(11346002)(86362001)(66446008)(6246003)(6486002)(316002)(53546011)(186003)(229853002)(110136005)(66556008)(54906003)(14454004)(6506007)(5660300002)(52116002)(2906002)(26005)(8936002)(256004)(386003)(6436002)(6512007)(81156014)(305945005)(73956011)(102836004)(8676002)(486006)(2616005)(81166006)(476003)(6116002)(66476007)(99286004)(25786009)(7736002)(66946007)(66066001)(68736007)(76176011)(3846002)(478600001)(53936002)(31686004)(4326008)(36756003)(71190400001)(71200400001)(31696002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3251;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QT3U9ck1GJdWp26XWANQU7+5G9vXtOAJb4lQDDLGSMspjZsdzZqYCQgaZ280sQ1/SNL5IyNEdEti6rSq3qr/+h3yPETvkiWqPJ5Vj1RjVxi4d9M7j0HL0EJRqz4/NGFNHs0qdqyJGIbOh4drdBMxNepAEye2cQB2x1gWmrF59ZYaBCDCeznoYpDxhRiTIAOOvxBpBKvfcL8MPOuSAcExT26XeslcGdZ9RgKX0zAVBX14sgAB8Qa23unhji2/wDrrUNmkfjGibANZala3y4cg+q9pT/m45ZIJNjvSCMhJVrZD4t+NvZTzA0yXy3uo5sWRYMR0MktoPUjdlp3B7/LO3nZ24icDLmZjfsi2JuYylCr6hiBykJk9gxCPhAomJL+wyL4yBlQIuVhN2USPLu/5JWsofZd0gqQ1DlR9UcDOF1A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAD39862E4BC6445A506FAAC87651B55@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45edea9e-d3c5-4fe8-66ad-08d6f55162f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 07:32:02.5144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3251
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzE4LzIwMTkgNzowMyBQTSwgQ29uZyBXYW5nIHdyb3RlOg0KPiBPbiBGcmksIEp1biAx
NCwgMjAxOSBhdCAxMjoyNCBQTSBNYXJjZWxvIFJpY2FyZG8gTGVpdG5lcg0KPiA8bWFyY2Vsby5s
ZWl0bmVyQGdtYWlsLmNvbT4gd3JvdGU6DQo+PiBPbiBGcmksIEp1biAxNCwgMjAxOSBhdCAxMTow
NzozN0FNIC0wNzAwLCBDb25nIFdhbmcgd3JvdGU6DQo+Pj4gT24gVHVlLCBKdW4gMTEsIDIwMTkg
YXQgOTo0NCBBTSBNYXJjZWxvIFJpY2FyZG8gTGVpdG5lcg0KPj4+IDxtYXJjZWxvLmxlaXRuZXJA
Z21haWwuY29tPiB3cm90ZToNCj4+Pj4gSSBoYWQgc3VnZ2VzdGVkIHRvIGxldCBhY3RfY3QgaGFu
ZGxlIHRoZSBhYm92ZSBhcyB3ZWxsLCBhcyB0aGVyZSBpcyBhDQo+Pj4+IGJpZyBjaHVuayBvZiBj
b2RlIG9uIGJvdGggdGhhdCBpcyBwcmV0dHkgc2ltaWxhci4gVGhlcmUgaXMgcXVpdGUgc29tZQ0K
Pj4+PiBib2lsZXJwbGF0ZSBmb3IgaW50ZXJmYWNpbmcgd2l0aCBjb25udHJhY2sgd2hpY2ggaXMg
ZHVwbGljYXRlZC4NCj4+PiBXaHkgZG8geW91IHdhbnQgdG8gbWl4IHJldHJpZXZpbmcgY29ubnRy
YWNrIGluZm8gd2l0aCBleGVjdXRpbmcNCj4+PiBjb25udHJhY2s/DQo+PiBUbyBzYXZlIG9uIHRo
ZSBoZWF2eSBib2lsZXJwbGF0ZSBmb3IgaW50ZXJmYWNpbmcgd2l0aCBjb25udHJhY2suDQo+Pg0K
Pj4+IFRoZXkgYXJlIHRvdGFsbHkgZGlmZmVyZW50IHRoaW5ncyB0byBtZSwgYWN0X2N0aW5mbyBt
ZXJlbHkgcmV0cmlldmVzDQo+Pj4gaW5mb3JtYXRpb24gZnJvbSBjb25udHJhY2ssIHdoaWxlIHRo
aXMgb25lLCBhY3RfY3QsIGlzIHN1cHBvc2VkIHRvDQo+Pj4gbW92ZSBwYWNrZXRzIHRvIGNvbm50
cmFjay4NCj4+IFNlZW1zIHdlIGhhdmUgYSBkaWZmZXJlbnQgdW5kZXJzdGFuZGluZyBmb3IgIm1v
dmUgcGFja2V0cyB0bw0KPj4gY29ubnRyYWNrIjogY29ubnRyYWNrIHdpbGwgbm90IGNvbnN1bWUg
dGhlIHBhY2tldHMgYWZ0ZXIgdGhpcy4NCj4+IEJ1dCBhZnRlciBhY3RfY3QgaXMgZXhlY3V0ZWQs
IGlmIG5vdCB3aXRoIHRoZSBjbGVhciBmbGFnLCBza2Igd2lsbCBub3cNCj4+IGhhdmUgdGhlIHNr
Yi0+X25mY3QgZW50cnkgYXZhaWxhYmxlLCBvbiB3aGljaCBmbG93ZXIgdGhlbiB3aWxsIGJlIGFi
bGUNCj4+IHRvIG1hdGNoLiBTbyBpbiBlc3NlbmNlLCBpdCBpcyBhbHNvIGZldGNoaW5nIGluZm9y
bWF0aW9uIGZyb20NCj4+IGNvbm50cmFjay4NCj4gSW50ZXJlc3RpbmcuIElzIGl0IGJlY2F1c2Ug
Y2xzX2Zsb3dlciB1c2VzIGNvbm50cmFjayBmb3IgZmxvdyBkaXNzZWN0aW9uPw0KPiBXaGF0J3Mg
dGhlIHJlYXNvbiBiZWhpbmQ/DQo+DQo+IEFnYWluLCBJIGFtIHN0aWxsIG5vdCBjb252aW5jZWQg
dG8gZG8gTDMgb3BlcmF0aW9ucyBpbiBMMiwgc2tiLT5fbmZjdA0KPiBiZWxvbmdzIHRvIGNvbm50
cmFjayB3aGljaCBpcyBMMywgbm8gbWF0dGVyIHRoZSBwYWNrZXQgaXMgY29uc3VtZWQNCj4gb3Ig
bm90Lg0KPg0KPiBUaGFua3MuDQoNCkknbSBub3Qgc3VyZSB3aGF0IHlvdSBtZWFuLCB0aGUgcmVh
c29uIGJlaGluZCB3aGF0Pw0KDQpXZSB1c2UgY29ubnRyYWNrIHRvIHRyYWNrLCBtYXJrIHRoZSBw
YWNrZXQgd2l0aCBjb25udHJhY2sgaW5mbywgYW5kIA0KZXhlY3V0ZSBuYXQsIHRoZW4gd2UgcHVz
aCB0aGUNCg0KaGVhZGVycyBiYWNrIHRvIGNvbnRpbnVlIHByb2Nlc3NpbmcgdGhlIG5leHQgYWN0
aW9uLiBUaGlzIGFjdGlvbiB3aWxsIA0KcHJvYmFibHkgYmUgZm9sbG93ZWQgYnkNCg0KZ290byBj
aGFpbiBvciByZWNsYXNzaWZ5IGFuZCB0aGVuIGNsc19mbG93ZXIgY2FuIGJlIHVzZWQgdG8gbWF0
Y2ggb24gDQpjb25udHJhY2sgc3RhdGUgYW5kIG1ldGFkYXRhIHZpYSB0aGUgbmV3IGZsb3cgZGlz
c2VjdG9yIGNoYW5nZS4NCg0KDQoNCg0KDQoNCg0K
