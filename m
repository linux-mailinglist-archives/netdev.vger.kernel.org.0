Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052CD74A2A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390615AbfGYJnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 05:43:17 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:60902
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfGYJnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 05:43:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKosNsjIWB0Rwh+zLM2vPjb1t7AkHEVMHpncG6ken/WFjy4QcrQFR5lD2Tx1X7peVlfm73GTzVQonioiILtWzYGnl6ykmpTLifZOaW/C7wMiprIGnmB1x3XvWi8CQUIJ2nZ0FNSTeAafbQi/YOzKKHzfw+kwcDnGyHtwTpFoUokL/7a04vMIdjkEbUyFiAyAq1Ou6G+KW7rWZFZksJauVaz1Hwd3uPbwJF4lQ+5dzCLYaXEclKegMF5FKiURsgG9So6md45jxDhvN1y5+okCAIf8efLhmS6RfD8g2Nl6qSPrmms3WlXpFRPzY4TMta1gsvmYHnz9REWZpFukjX7ClA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDGduCEYR/tRBYLj7DokqOqMB/G1KRNvrjCZko1HRTQ=;
 b=QrL3CkWO+hC3Eu2i+4S+kFf1R/U+20Eo9WSxfJOlTIM8ZcOPszLlNuN0+e8SM7c0jiTyxavwFf4wOz50Gu8OH17+jbiQLMOmtr1VmGe2dfXCvekoVUafYAXwu2Uyq6pTUCj9yvyfuCm6SGalrBUJlMmT/XMID/CWZIrR9dP27032kjehLEyBWFkYwGkSceLRzdrO6ZGo1+Ws9ibWYtH6lwIQ/5TOyJ60SJJ/pE+1gidKoP8w5tC4TjI/yfKCkU0KtHcSaCdwkjoPTmqAJeNFdcJxjdZjaX5HLoz6lSF3cFJbrzwGfJOSGkUB32RBKGb1idURR8rvhi0mGcNnribSjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDGduCEYR/tRBYLj7DokqOqMB/G1KRNvrjCZko1HRTQ=;
 b=Al1ZDS8XvrCMSyHfGgQvK0F8dSt+LAdTzaL+W8Um9hn3aYweWtPAcTKDely/qFpPSbyA2C/dxqmVSwac23zvf55T6XSW7tzsRWGkO9totVGFSmx/VpJWxp+XMZUf+XQCbPS5qRwZlO4LIC4pJr14peXjEMPWMa2WNloCStCV3Fk=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6405.eurprd05.prod.outlook.com (20.179.6.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Thu, 25 Jul 2019 09:43:06 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 09:43:06 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Kevin Laatz <kevin.laatz@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "bruce.richardson@intel.com" <bruce.richardson@intel.com>,
        "ciara.loftus@intel.com" <ciara.loftus@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH bpf-next v3 08/11] samples/bpf: add unaligned chunks mode
 support to xdpsock
Thread-Topic: [PATCH bpf-next v3 08/11] samples/bpf: add unaligned chunks mode
 support to xdpsock
Thread-Index: AQHVQiNte53eRR+QTUqnn7befgzUpKbbFmwA
Date:   Thu, 25 Jul 2019 09:43:06 +0000
Message-ID: <fd7b6b71-5bfd-986a-b288-b9e3478acebb@mellanox.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190724051043.14348-9-kevin.laatz@intel.com>
In-Reply-To: <20190724051043.14348-9-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::34)
 To AM6PR05MB5879.eurprd05.prod.outlook.com (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 869f8f85-bbf4-492d-a22a-08d710e47f03
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6405;
x-ms-traffictypediagnostic: AM6PR05MB6405:
x-microsoft-antispam-prvs: <AM6PR05MB6405829A28E48F36AC1EE9F7D1C10@AM6PR05MB6405.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(199004)(189003)(6506007)(36756003)(76176011)(102836004)(55236004)(53546011)(386003)(305945005)(66946007)(14454004)(64756008)(26005)(52116002)(5660300002)(8936002)(6512007)(3846002)(6116002)(81166006)(66446008)(99286004)(6436002)(68736007)(6486002)(7736002)(316002)(6246003)(86362001)(66556008)(486006)(81156014)(31696002)(2906002)(25786009)(53936002)(6916009)(66066001)(446003)(8676002)(11346002)(4326008)(54906003)(31686004)(71200400001)(71190400001)(476003)(186003)(478600001)(2616005)(256004)(66476007)(7416002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6405;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UgtbhasJw2gu1IVQU9J/7jrL7wKn5RJ06965Pal0TBtWfZkY4WLErzQZtVhAlqlisH0V3k54+ZJ6rynJnA4mR48bn/VdUyqTmYhmRF25osbek/hKjHBFZcZeoRSYJnqtickOAXS7zJngYJJMF5pic6ni3RO5xoOgLLcqMvlJY6+mSdzRFkx9amnuGhiFzN8D6cXndx3y2rM0/3CiEyxOdzwpV6gRgScaIyKaT8sUlYkBLK9sUd+mEisFMCAXQm5Z0DiHaMqDCK4zD6/SWPdho3X8VrZ+3pFBbx6zktg3XGI11eeL8UMSE/GaPXdPYymv3CWvyM7mQ1MV2Gat1XPFDD2LeEj23fn28ZOxNLQRU7VRvpNsv+yn/Alu7IeONlN4Mza3pQZVTtCMo9l0y12qqQZNI/kwcwK/rXxaGSqQYbQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3858018B23BE0C48BA41FECF6A806CCB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869f8f85-bbf4-492d-a22a-08d710e47f03
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 09:43:06.7446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNy0yNCAwODoxMCwgS2V2aW4gTGFhdHogd3JvdGU6DQo+IFRoaXMgcGF0Y2ggYWRk
cyBzdXBwb3J0IGZvciB0aGUgdW5hbGlnbmVkIGNodW5rcyBtb2RlLiBUaGUgYWRkaXRpb24gb2Yg
dGhlDQo+IHVuYWxpZ25lZCBjaHVua3Mgb3B0aW9uIHdpbGwgYWxsb3cgdXNlcnMgdG8gcnVuIHRo
ZSBhcHBsaWNhdGlvbiB3aXRoIG1vcmUNCj4gcmVsYXhlZCBjaHVuayBwbGFjZW1lbnQgaW4gdGhl
IFhEUCB1bWVtLg0KPiANCj4gVW5hbGlnbmVkIGNodW5rcyBtb2RlIGNhbiBiZSB1c2VkIHdpdGgg
dGhlICctdScgb3IgJy0tdW5hbGlnbmVkJyBjb21tYW5kDQo+IGxpbmUgb3B0aW9ucy4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEtldmluIExhYXR6IDxrZXZpbi5sYWF0ekBpbnRlbC5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IENpYXJhIExvZnR1cyA8Y2lhcmEubG9mdHVzQGludGVsLmNvbT4NCj4gLS0t
DQo+ICAgc2FtcGxlcy9icGYveGRwc29ja191c2VyLmMgfCAxNyArKysrKysrKysrKysrKystLQ0K
PiAgIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQo8
Li4uPg0KDQo+IEBAIC0zNzIsNiArMzc4LDcgQEAgc3RhdGljIHZvaWQgdXNhZ2UoY29uc3QgY2hh
ciAqcHJvZykNCj4gICAJCSIgIC16LCAtLXplcm8tY29weSAgICAgIEZvcmNlIHplcm8tY29weSBt
b2RlLlxuIg0KPiAgIAkJIiAgLWMsIC0tY29weSAgICAgICAgICAgRm9yY2UgY29weSBtb2RlLlxu
Ig0KPiAgIAkJIiAgLWYsIC0tZnJhbWUtc2l6ZT1uICAgU2V0IHRoZSBmcmFtZSBzaXplIChtdXN0
IGJlIGEgcG93ZXIgb2YgdHdvLCBkZWZhdWx0IGlzICVkKS5cbiINCg0KSGVscCB0ZXh0IGZvciAt
ZiBoYXMgdG8gYmUgdXBkYXRlZCwgaXQgZG9lc24ndCBoYXZlIHRvIGJlIGEgcG93ZXIgb2YgdHdv
IA0KaWYgLXUgaXMgc3BlY2lmaWVkLg0KDQo+ICsJCSIgIC11LCAtLXVuYWxpZ25lZAlFbmFibGUg
dW5hbGlnbmVkIGNodW5rIHBsYWNlbWVudFxuIg0KDQo8Li4uPg0KDQo+ICAgDQo+IC0JaWYgKG9w
dF94c2tfZnJhbWVfc2l6ZSAmIChvcHRfeHNrX2ZyYW1lX3NpemUgLSAxKSkgew0KPiArCWlmICgo
b3B0X3hza19mcmFtZV9zaXplICYgKG9wdF94c2tfZnJhbWVfc2l6ZSAtIDEpKSAmJg0KPiArCQkJ
IW9wdF91bmFsaWduZWRfY2h1bmtzKSB7DQo+ICAgCQlmcHJpbnRmKHN0ZGVyciwgIi0tZnJhbWUt
c2l6ZT0lZCBpcyBub3QgYSBwb3dlciBvZiB0d29cbiIsDQo+ICAgCQkJb3B0X3hza19mcmFtZV9z
aXplKTsNCj4gICAJCXVzYWdlKGJhc2VuYW1lKGFyZ3ZbMF0pKTsNCj4gDQoNCg==
