Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2CF438B6
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbfFMPHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:07:46 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:17571
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732391AbfFMOCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMEDWzwtr5V+A4uLeVJrM/DvbFyp5Z0xlbhM/us1uak=;
 b=lytjaHwOPRVGIJ+Aon2+H9yyZLdu9gjR/Ref5aAW0S31Q8GbVqCBPcrR5HEpaDgirStWpMaSBhWvMmzhX43Yo4JLQ6T0gBaJW0ER+q9FXfgYJOVbX1QsyU1E4p9KWBD5O25/FNkNu6HhY4xv7BJLSBLHc56lxqsFiGk/vpvCYYI=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5637.eurprd05.prod.outlook.com (20.178.86.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 13 Jun 2019 14:01:41 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 14:01:41 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 05/17] xsk: Change the default frame size to
 4096 and allow controlling it
Thread-Topic: [PATCH bpf-next v4 05/17] xsk: Change the default frame size to
 4096 and allow controlling it
Thread-Index: AQHVITdu7fpr20kECE+M200+kOAnM6aYc0WAgAErPoA=
Date:   Thu, 13 Jun 2019 14:01:39 +0000
Message-ID: <b7217210-1ce6-4b27-9964-b4daa4929e8b@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-6-maximmi@mellanox.com>
 <20190612131017.766b4e82@cakuba.netronome.com>
In-Reply-To: <20190612131017.766b4e82@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0058.namprd11.prod.outlook.com
 (2603:10b6:a03:80::35) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ef9956d-ca4c-4f05-2f67-08d6f007a7d5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5637;
x-ms-traffictypediagnostic: AM6PR05MB5637:
x-microsoft-antispam-prvs: <AM6PR05MB5637FD813CC212DFC2C49844D1EF0@AM6PR05MB5637.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(376002)(346002)(366004)(199004)(189003)(68736007)(11346002)(31686004)(446003)(8936002)(8676002)(81156014)(81166006)(486006)(305945005)(73956011)(66946007)(66446008)(66476007)(66556008)(64756008)(6246003)(229853002)(14454004)(7736002)(476003)(2616005)(6512007)(316002)(31696002)(99286004)(7416002)(6486002)(25786009)(54906003)(66066001)(53936002)(52116002)(6916009)(76176011)(5660300002)(4326008)(478600001)(6436002)(86362001)(53546011)(6506007)(386003)(26005)(55236004)(102836004)(71190400001)(71200400001)(256004)(14444005)(186003)(36756003)(2906002)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5637;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6x8NboJ4scGXBubPXFLa1XO4VrDbGj8Ks7nhJUDsmwZTK0C26LBgBJp12OZUMbG05ZpMSOPHBBBRXyvQ9UwZ6VzwBPj+gs+3G+4SwDlttZdaRqBaFRNwzUEqfaIH7hUUWhBsGxiBUCilZ5lPXF4O1BIPSeJzvmXfgIYTHtX3pM9cQw+XikAo92Am6eG+3Yi/gDOvfPf8hVI17YCCuSyT/Tzzj6TI0dRbm/BLFCArPASx3MT/mD3ABVPrxwoBKkEemcl+SnxuWshr26YZJe1FnBybjiUBu11c+MSwRT45B/Az5gU2Hw3CXLn4SxvuVh9NisorDGO4aXoCW9IhmKkXeh6L43nypKT+OrQz7tgE+6uoMx1QqSsxR2ODEpMyzqE5xxWHcLBhXbp/S8Cykt2GSU1dO3v1wFVzNRCOqqwiDQM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A3BB8C4240F74488D4EBA13D4F86D0F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef9956d-ca4c-4f05-2f67-08d6f007a7d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:01:39.8103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xMiAyMzoxMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFdlZCwgMTIg
SnVuIDIwMTkgMTU6NTY6NDMgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+IFRo
ZSB0eXBpY2FsIFhEUCBtZW1vcnkgc2NoZW1lIGlzIG9uZSBwYWNrZXQgcGVyIHBhZ2UuIENoYW5n
ZSB0aGUgQUZfWERQDQo+PiBmcmFtZSBzaXplIGluIGxpYmJwZiB0byA0MDk2LCB3aGljaCBpcyB0
aGUgcGFnZSBzaXplIG9uIHg4NiwgdG8gYWxsb3cNCj4+IGxpYmJwZiB0byBiZSB1c2VkIHdpdGgg
dGhlIGRyaXZlcnMgd2l0aCB0aGUgcGFja2V0LXBlci1wYWdlIHNjaGVtZS4NCj4gDQo+IFRoaXMg
aXMgc2xpZ2h0bHkgc3VycHJpc2luZy4gIFdoeSBkb2VzIHRoZSBkcml2ZXIgY2FyZSBhYm91dCB0
aGUgYnVmc3o/DQoNClRoZSBjbGFzc2ljIFhEUCBpbXBsZW1lbnRhdGlvbiBzdXBwb3J0cyBvbmx5
IHRoZSBwYWNrZXQtcGVyLXBhZ2Ugc2NoZW1lLiANCm1seDVlIGltcGxlbWVudHMgdGhpcyBzY2hl
bWUsIGJlY2F1c2UgaXQgcGVyZmVjdGx5IGZpdHMgd2l0aCB4ZHBfcmV0dXJuIA0KYW5kIHBhZ2Ug
cG9vbCBBUElzLiBBRl9YRFAgcmVsaWVzIG9uIFhEUCwgYW5kIGV2ZW4gdGhvdWdoIEFGX1hEUCBk
b2Vzbid0IA0KcmVhbGx5IGFsbG9jYXRlIG9yIHJlbGVhc2UgcGFnZXMsIGl0IHdvcmtzIG9uIHRv
cCBvZiBYRFAsIGFuZCBYRFAgDQppbXBsZW1lbnRhdGlvbiBpbiBtbHg1ZSBkb2VzIGFsbG9jYXRl
IGFuZCByZWxlYXNlIHBhZ2VzIChpbiBnZW5lcmFsIA0KY2FzZSkgYW5kIHdvcmtzIHdpdGggdGhl
IHBhY2tldC1wZXItcGFnZSBzY2hlbWUuDQoNCj4gWW91J3JlIG5vdCBzdXBwb3NlZCB0byBzbyBw
YWdlIG9wZXJhdGlvbnMgb24gVU1FTSBwYWdlcywgYW55d2F5Lg0KPiBBbmQgdGhlIFJYIHNpemUg
ZmlsdGVyIHNob3VsZCBiZSBjb25maWd1cmVkIGFjY29yZGluZyB0byBNVFUgcmVnYXJkbGVzcw0K
PiBvZiBYRFAgc3RhdGUuDQoNClllcywgb2YgY291cnNlLCBNVFUgaXMgdGFrZW4gaW50byBhY2Nv
dW50Lg0KDQo+IENhbiB5b3UgZXhwbGFpbj8NCj4gDQo+PiBBZGQgYSBjb21tYW5kIGxpbmUgb3B0
aW9uIC1mIHRvIHhkcHNvY2sgdG8gYWxsb3cgdG8gc3BlY2lmeSBhIGN1c3RvbQ0KPj4gZnJhbWUg
c2l6ZS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNraXkgPG1heGltbWlA
bWVsbGFub3guY29tPg0KPj4gUmV2aWV3ZWQtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxh
bm94LmNvbT4NCj4+IEFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNv
bT4NCg0K
