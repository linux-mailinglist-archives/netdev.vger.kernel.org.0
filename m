Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B50F438B3
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbfFMPHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:07:45 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:17571
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732393AbfFMOCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwjkTsSOzxvMei1WWtiqM5j1F7tuAmDOIuiMMAHI8wo=;
 b=a6fXO2bQqpSuA8UPqSSSfcqoeGhk2xpiYb7+LWvbpOsHXGvU3VssfckkHdIz4B7PS7qMf8JNKPBorgCVTPUDBO8Xhp5ThtTMpcvfT34B/8Mdvitzr6qYIuYOW816EVti/jPO+8HBvntZVWrBv2S0IgoBMO5XoRql5sj8q7y+oig=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5637.eurprd05.prod.outlook.com (20.178.86.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 13 Jun 2019 14:01:45 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 14:01:45 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
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
Subject: Re: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Topic: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Index: AQHVITdoe6rurVkq00yTWSmwKXBCXaaYfdWAgAEgvYA=
Date:   Thu, 13 Jun 2019 14:01:45 +0000
Message-ID: <2773eabb-68ac-faec-a629-6c2d8b7a1582@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612134805.3bf4ea25@cakuba.netronome.com>
In-Reply-To: <20190612134805.3bf4ea25@cakuba.netronome.com>
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
x-ms-office365-filtering-correlation-id: bd443d4c-9671-49c1-8b7d-08d6f007aa99
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5637;
x-ms-traffictypediagnostic: AM6PR05MB5637:
x-microsoft-antispam-prvs: <AM6PR05MB563700A0C48BFF62FF3BC6DFD1EF0@AM6PR05MB5637.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(376002)(346002)(366004)(199004)(189003)(68736007)(11346002)(31686004)(446003)(8936002)(8676002)(81156014)(81166006)(486006)(305945005)(73956011)(66946007)(66446008)(66476007)(66556008)(64756008)(6246003)(229853002)(14454004)(7736002)(476003)(2616005)(6512007)(316002)(31696002)(99286004)(7416002)(6486002)(25786009)(54906003)(66066001)(53936002)(52116002)(6916009)(76176011)(5660300002)(4326008)(478600001)(6436002)(86362001)(53546011)(6506007)(386003)(26005)(55236004)(102836004)(71190400001)(71200400001)(256004)(186003)(36756003)(2906002)(6116002)(3846002)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5637;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x1Sefsf6x2VbwL/bdrPtOH0jFzC3YV6+wLp829zs6bObEdKCA0f6yWrC/MFoSLSjJ3WgpQRddZVTq5AI0l+jiWnyinnxFzeogK97dYjr+ZmPzz5deanVLOCPELyeyFd4oLt/PzXi5JnLsj4zopElGpHtqJE5AA6kSsy0hCH+g6eCh2LJcwYHuvdWcBEVsc1ZzK2X1KGSB/bJYDJ5cunuXxTpNQnH73WeEen7tlwbXvxxBzGJgWvhuM2n0nVzv7R/XsleFUGWAJUnTQl/Cd6n4G58oPwf4IZbwoh/HHzpmCtsFV7rtez/6Z+7bbEGazz+YvE1WAXHYjpiRuDSH7XWzNwsA1dCYna/Vqbn7DDKW5gjDz68jI2t2bEm5xyV39WiFgI96i4+zSTudYSzlrI+NJs+OJ9Xk3j4vKQ/WNmX7N8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <312A2C616B2A394CAC9FA48E80EF2B4A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd443d4c-9671-49c1-8b7d-08d6f007aa99
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:01:45.1682
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

T24gMjAxOS0wNi0xMiAyMzo0OCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFdlZCwgMTIg
SnVuIDIwMTkgMTU6NTY6MzMgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+IFVB
UEkgaXMgbm90IGNoYW5nZWQsIFhTSyBSWCBxdWV1ZXMgYXJlIGV4cG9zZWQgdG8gdGhlIGtlcm5l
bC4gVGhlIGxvd2VyDQo+PiBoYWxmIG9mIHRoZSBhdmFpbGFibGUgYW1vdW50IG9mIFJYIHF1ZXVl
cyBhcmUgcmVndWxhciBxdWV1ZXMsIGFuZCB0aGUNCj4+IHVwcGVyIGhhbGYgYXJlIFhTSyBSWCBx
dWV1ZXMuDQo+IA0KPiBJZiBJIGhhdmUgMzIgcXVldWVzIGVuYWJsZWQgb24gdGhlIE5JQw0KDQpM
ZXQncyBzYXkgd2UgaGF2ZSAzMiBjb21iaW5lZCBjaGFubmVscy4gSW4gdGhpcyBjYXNlIFJYIHF1
ZXVlcyAwLi4zMSBhcmUgDQpyZWd1bGFyIG9uZXMsIGFuZCAzMi4uNjMgYXJlIFhTSy1aQy1lbmFi
bGVkLg0KDQo+IGFuZCBJIGluc3RhbGwgQUZfWERQIHNvY2tldCBvbg0KPiBxdWV1ZSAxMA0KDQpJ
dCdsbCB0cmlnZ2VyIHRoZSBjb21wYXRpYmlsaXR5IG1vZGUgb2YgQUZfWERQICh3aXRob3V0IHpl
cm8gY29weSkuIFlvdSANCnNob3VsZCB1c2UgcXVldWUgNDIsIHdoaWNoIGlzIGluIHRoZSAzMi4u
NjMgc2V0Lg0KDQo+ICwgZG9lcyB0aGUgTklDIG5vdyBoYXZlIDY0IFJRcywgYnV0IG9ubHkgZmly
c3QgMzIgYXJlIGluIHRoZQ0KPiBub3JtYWwgUlNTIG1hcD8NCg0KT25seSB0aGUgcmVndWxhciAw
Li4zMSBSWCBxdWV1ZXMgYXJlIHBhcnQgb2YgUlNTLg0KDQo+IA0KPj4gVGhlIHBhdGNoICJ4c2s6
IEV4dGVuZCBjaGFubmVscyB0byBzdXBwb3J0IGNvbWJpbmVkIFhTSy9ub24tWFNLDQo+PiB0cmFm
ZmljIiB3YXMgZHJvcHBlZC4gVGhlIGZpbmFsIHBhdGNoIHdhcyByZXdvcmtlZCBhY2NvcmRpbmds
eS4NCj4gDQo+IFRoZSBmaW5hbCBwYXRjaGVzIGhhcyAyayBMb0MsIGtpbmQgb2YgaGFyZCB0byBk
aWdlc3QuICBZb3UgY2FuIGFsc28NCj4gcG9zdCB0aGUgY2xlYW4gdXAgcGF0Y2hlcyBzZXBhcmF0
ZWx5LCBubyBuZWVkIGZvciBsYXJnZSBzZXJpZXMgaGVyZS4NCj4gDQoNCkkgdXNlZCB0byBoYXZl
IHRoZSBmaW5hbCBwYXRjaCBhcyB0aHJlZSBwYXRjaGVzIChhZGQgWFNLIHN0dWJzLCBhZGQgUlgg
DQpzdXBwb3J0IGFuZCBhZGQgVFggc3VwcG9ydCksIGJ1dCBJIHByZWZlciBub3QgdG8gaGF2ZSB0
aGlzIHNlcGFyYXRpb24sIA0KYmVjYXVzZSBpdCBkb2Vzbid0IGxvb2sgcmlnaHQgdG8gYWRkIGVt
cHR5IHN0dWIgZnVuY3Rpb25zIHdpdGggLyogVE9ETzogDQppbXBsZW1lbnQgKi8gY29tbWVudHMg
aW4gb25lIHBhdGNoIGFuZCB0byBhZGQgdGhlIGltcGxlbWVudGF0aW9ucyANCmltbWVkaWF0ZWx5
IGluIHRoZSBuZXh0IHBhdGNoLg0KDQpUaGFua3MgZm9yIHJldmlld2luZyENCk1heA0K
