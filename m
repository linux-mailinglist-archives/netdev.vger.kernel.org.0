Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2B586A7B
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404271AbfHHTSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:18:38 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:43744
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403928AbfHHTSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 15:18:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=di6wkmJ9sblyIxkdP9osa7OAdsarYSalYtSdkQAWHc0cxL1Ru7jYzVjTj19EVzy0X0a7WMNgeLsOjLu3Oi48kJ+3s1SzGsj6OyZoL+dkoN3wV+qPiMVAiB/zkLhfw3DmaJvxCLBmnUiMZ1lYGMoSVSoAmiRhePGSsLGBQQIPUV28z2ByYf+clfol1IDVwOk9HuNgT47Vzm8ng+T1AN5kRIgMdakXt61z+jcaYPebG/icMyZRcfFYdu2vrCnA8i+JLQTfiIDdtSNa/vxCX5NpfNGKn//qVz6369XtjOmFngpiPdplmrK/XfLMKxm5DJx/wWBSkMQCBjZY8c8qoue16A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2O7WL78kJptKFsI/x+39LQ4PrK1k1affDwjAHBgt9o=;
 b=EFa6DgincBB2vKa+3YMeJUgndR9Jw2uJeF8hi+1mpBEtSWYKKIoyPijMnx6A8OqDMmrG0cVtiOvUsqEMcrdTVwEybTLzETxS6hCtjQzDE87zI/4dLqJ9ZgP0mPoGL4sLc6rd2rSDs5I0vgowrmQqvkdre2vMmqx+pcl2tqvtJoL1/VZCBGqeOMtUNabj9B4irVHVyqm2rx8MWHkdzrm7zQBOflByXWKjLXALu1f963AFIRU7uRQdmx/WCMwaJ8KTURYwGQ12C2dlBfn9HLU5wH95XTMfB+V1bMSguWudXsQoOWpD2bWGlrgC5M8N4Xw6KmogIjyWqq+vYM58g0ZLnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2O7WL78kJptKFsI/x+39LQ4PrK1k1affDwjAHBgt9o=;
 b=DX2VHjCWvkWHErlkboRftmaGOilcZ8Qyan5x/abeRdW22/IG5W2mZkgeSbVQt8lF4Cyi4jsTNd/dJizNAG/fTOjJKNT4IxsTUXdnW+6Hck1xUwgLxIkzylvBf65QcEXSlJcDQrY7rd8bWkuHXqCo2EIdKtwHwZupwvme5me1Qkk=
Received: from VI1PR05MB5469.eurprd05.prod.outlook.com (20.177.201.28) by
 VI1PR05MB5805.eurprd05.prod.outlook.com (20.178.122.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Thu, 8 Aug 2019 19:18:33 +0000
Received: from VI1PR05MB5469.eurprd05.prod.outlook.com
 ([fe80::51fb:9ac1:d2cf:bbf4]) by VI1PR05MB5469.eurprd05.prod.outlook.com
 ([fe80::51fb:9ac1:d2cf:bbf4%5]) with mapi id 15.20.2136.018; Thu, 8 Aug 2019
 19:18:33 +0000
From:   Boris Pismenny <borisp@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "willemb@google.com" <willemb@google.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [PATCH net v3] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
Thread-Topic: [PATCH net v3] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
Thread-Index: AQHVTXzZcpsjiHfvhUmjJrLKtd/Z36bxnhwA
Date:   Thu, 8 Aug 2019 19:18:33 +0000
Message-ID: <80d30591-ee5b-9676-7bbd-b5168d5763c7@mellanox.com>
References: <20190808000359.20785-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190808000359.20785-1-jakub.kicinski@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::19) To VI1PR05MB5469.eurprd05.prod.outlook.com
 (2603:10a6:803:94::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [79.177.243.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 132f233e-59e9-4762-2f8e-08d71c353440
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5805;
x-ms-traffictypediagnostic: VI1PR05MB5805:
x-microsoft-antispam-prvs: <VI1PR05MB5805FB392D40B8A7E3CF3218B0D70@VI1PR05MB5805.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(189003)(199004)(2616005)(486006)(229853002)(81156014)(6436002)(81166006)(8676002)(25786009)(8936002)(316002)(4326008)(305945005)(6486002)(14444005)(6512007)(7736002)(31686004)(478600001)(53936002)(54906003)(256004)(76176011)(6246003)(86362001)(26005)(36756003)(476003)(66066001)(5660300002)(11346002)(446003)(2501003)(52116002)(66476007)(31696002)(64756008)(186003)(66446008)(6506007)(386003)(3846002)(71190400001)(66556008)(99286004)(71200400001)(110136005)(2906002)(53546011)(102836004)(66946007)(7416002)(14454004)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5805;H:VI1PR05MB5469.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SWjBFtA0Icz9OGAwyA72CTC44F6DJqBLF7RSURi25ZtVCdzuiMNZ7hfv/COCkMN9BtvDMmE0ylVptaI1P9qiRkA5U2wMnnPOlbEW3+1supo9kuW38VzqH+x5PhxaVGxX56zTBM0mCQ0ZPE6m7jWNhbKMainEaNsRc0jWK0fLhcUACx/n5WheHeOZ1Ip9wNtdvW6JS7KwKE+TDsq0ufnDBn+rww5HO98uqVQSZ7c0R9C9gtDYZVSkhIVPYyQml43hGK2utDs/bx1mK3n2oF5/IJCLvPz5d1h8VczWW4l+FKP7UhorYoduuGID5yK77dr3KL6irMNV4hZMrpIcmPpF7BU6lMYMtiKVcqzZ1m3oDtbsf/Bs6NLP4NCSrR0PVC5Asbwai9DsRmBmv/TlOnAVwNbVBBq/DOWTygNxfiSnZjA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2BE4D69269D8847871E1411E7B6900A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132f233e-59e9-4762-2f8e-08d71c353440
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 19:18:33.4969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: borisp@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5805
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDA4LzA4LzIwMTkgMzowMywgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IHNrX3ZhbGlk
YXRlX3htaXRfc2tiKCkgYW5kIGRyaXZlcnMgZGVwZW5kIG9uIHRoZSBzayBtZW1iZXIgb2YNCj4g
c3RydWN0IHNrX2J1ZmYgdG8gaWRlbnRpZnkgc2VnbWVudHMgcmVxdWlyaW5nIGVuY3J5cHRpb24u
DQo+IEFueSBvcGVyYXRpb24gd2hpY2ggcmVtb3ZlcyBvciBkb2VzIG5vdCBwcmVzZXJ2ZSB0aGUg
b3JpZ2luYWwgVExTDQo+IHNvY2tldCBzdWNoIGFzIHNrYl9vcnBoYW4oKSBvciBza2JfY2xvbmUo
KSB3aWxsIGNhdXNlIGNsZWFyIHRleHQNCj4gbGVha3MuDQo+IA0KPiBNYWtlIHRoZSBUQ1Agc29j
a2V0IHVuZGVybHlpbmcgYW4gb2ZmbG9hZGVkIFRMUyBjb25uZWN0aW9uDQo+IG1hcmsgYWxsIHNr
YnMgYXMgZGVjcnlwdGVkLCBpZiBUTFMgVFggaXMgaW4gb2ZmbG9hZCBtb2RlLg0KPiBUaGVuIGlu
IHNrX3ZhbGlkYXRlX3htaXRfc2tiKCkgY2F0Y2ggc2ticyB3aGljaCBoYXZlIG5vIHNvY2tldA0K
PiAob3IgYSBzb2NrZXQgd2l0aCBubyB2YWxpZGF0aW9uKSBhbmQgZGVjcnlwdGVkIGZsYWcgc2V0
Lg0KPiANCj4gTm90ZSB0aGF0IENPTkZJR19TT0NLX1ZBTElEQVRFX1hNSVQsIENPTkZJR19UTFNf
REVWSUNFIGFuZA0KPiBzay0+c2tfdmFsaWRhdGVfeG1pdF9za2IgYXJlIHNsaWdodGx5IGludGVy
Y2hhbmdlYWJsZSByaWdodCBub3csDQo+IHRoZXkgYWxsIGltcGx5IFRMUyBvZmZsb2FkLiBUaGUg
bmV3IGNoZWNrcyBhcmUgZ3VhcmRlZCBieQ0KPiBDT05GSUdfVExTX0RFVklDRSBiZWNhdXNlIHRo
YXQncyB0aGUgb3B0aW9uIGd1YXJkaW5nIHRoZQ0KPiBza19idWZmLT5kZWNyeXB0ZWQgbWVtYmVy
Lg0KPiANCj4gU2Vjb25kLCBzbWFsbGVyIGlzc3VlIHdpdGggb3JwaGFuaW5nIGlzIHRoYXQgaXQg
YnJlYWtzDQo+IHRoZSBndWFyYW50ZWUgdGhhdCBwYWNrZXRzIHdpbGwgYmUgZGVsaXZlcmVkIHRv
IGRldmljZQ0KPiBxdWV1ZXMgaW4tb3JkZXIuIEFsbCBUTFMgb2ZmbG9hZCBkcml2ZXJzIGRlcGVu
ZCBvbiB0aGF0DQo+IHNjaGVkdWxpbmcgcHJvcGVydHkuIFRoaXMgbWVhbnMgc2tiX29ycGhhbl9w
YXJ0aWFsKCkncw0KPiB0cmljayBvZiBwcmVzZXJ2aW5nIHBhcnRpYWwgc29ja2V0IHJlZmVyZW5j
ZXMgd2lsbCBjYXVzZQ0KPiBpc3N1ZXMgaW4gdGhlIGRyaXZlcnMuIFdlIG5lZWQgYSBmdWxsIG9y
cGhhbiwgYW5kIGFzIGENCj4gcmVzdWx0IG5ldGVtIGRlbGF5L3Rocm90dGxpbmcgd2lsbCBjYXVz
ZSBhbGwgVExTIG9mZmxvYWQNCj4gc2ticyB0byBiZSBkcm9wcGVkLg0KPiANCj4gUmV1c2luZyB0
aGUgc2tfYnVmZi0+ZGVjcnlwdGVkIGZsYWcgYWxzbyBwcm90ZWN0cyBmcm9tDQo+IGxlYWtpbmcg
Y2xlYXIgdGV4dCB3aGVuIGluY29taW5nLCBkZWNyeXB0ZWQgc2tiIGlzIHJlZGlyZWN0ZWQNCj4g
KGUuZy4gYnkgVEMpLg0KPiANCj4gU2VlIGNvbW1pdCAwNjA4YzY5YzlhODAgKCJicGY6IHNrX21z
Zywgc29ja3ttYXB8aGFzaH0gcmVkaXJlY3QNCj4gdGhyb3VnaCBVTFAiKSBmb3IganVzdGlmaWNh
dGlvbiB3aHkgdGhlIGludGVybmFsIGZsYWcgaXMgc2FmZS4NCj4gVGhlIG9ubHkgbG9jYXRpb24g
d2hpY2ggY291bGQgbGVhayB0aGUgZmxhZyBpbiBpcyB0Y3BfYnBmX3NlbmRtc2coKSwNCj4gd2hp
Y2ggaXMgdGFrZW4gY2FyZSBvZiBieSBjbGVhcmluZyB0aGUgcHJldmlvdXNseSB1bnVzZWQgYml0
Lg0KPiANCj4gdjI6DQo+ICAtIHJlbW92ZSBzdXBlcmZsdW91cyBkZWNyeXB0ZWQgbWFyayBjb3B5
IChXaWxsZW0pOw0KPiAgLSByZW1vdmUgdGhlIHN0YWxlIGRvYyBlbnRyeSAoQm9yaXMpOw0KPiAg
LSByZWx5IGVudGlyZWx5IG9uIEVPUiBtYXJraW5nIHRvIHByZXZlbnQgY29hbGVzY2luZyAoQm9y
aXMpOw0KPiAgLSB1c2UgYW4gaW50ZXJuYWwgc2VuZHBhZ2VzIGZsYWcgaW5zdGVhZCBvZiBtYXJr
aW5nIHRoZSBzb2NrZXQNCj4gICAgKEJvcmlzKS4NCj4gdjMgKFdpbGxlbSk6DQo+ICAtIHJlb3Jn
YW5pemUgdGhlIGNhbl9za2Jfb3JwaGFuX3BhcnRpYWwoKSBjb25kaXRpb247DQo+ICAtIGZpeCB0
aGUgZmxhZyBsZWFrLWluIHRocm91Z2ggdGNwX2JwZl9zZW5kbXNnLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogSmFrdWIgS2ljaW5za2kgPGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+DQoNCkxH
VE0NCg0KUmV2aWV3ZWQtYnk6IEJvcmlzIFBpc21lbm55IDxib3Jpc3BAbWVsbGFub3guY29tPg0K
