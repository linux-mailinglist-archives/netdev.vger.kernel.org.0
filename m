Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF4800D7
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404439AbfHBTXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:23:09 -0400
Received: from mail-eopbgr130080.outbound.protection.outlook.com ([40.107.13.80]:41444
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403792AbfHBTXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 15:23:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/PqMTa3H4q3xRWSJR44rtBvWEVS1EyVjSIMBJVB5VtW8qwrK5d6NhyDZXf+GE7yM4OknNYN1qgtuOIaGT4+HP8lhvJ8yHK+kJYltN4PdBPASR3CAaei4z4pPBAnGSljREmrT2lAoP8ss+EmmA+SMN7vuF+meaj47vZDTWG9Rqgmsho3BYHmwLrCLUjitqNxqXylG7yMPbnwBLSc5CYumk4tmFW3WuDc55xIdNyytmCRUmdwP4PWZMU4zgAtfbWocOu2KQPISHWwEaBPRRr8l7T5+falkiat7C+YAvFxaSbb4fsDcqGsL279MUJMtNihpjbMmpGXdKNvUMN+nGu3Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QoZhpqUIe0JpzGUXLdRW8JHiMhaDfX+XRl0PAkwzET0=;
 b=eieqfJtRKYTAefyXvMLIo92mkGkBDaxaZ1eyeP+qbR/gxd1LRelZZhjrZsavrjYUgqzUx5crmo9t1nAwFPczUxWe4jJRnynX4gTLDMJI+Mtye0vj11hirFHKymbnYg8gQPZwA+kjFSNncrZI4N01w+iuK6mI24afFIO/LzXbcnHlE2nR4UBeAWZZRH2/Za7Ns0QzBYbbvbNkJ7cZqUCUdAIff2ro5J+qRc6ZUrKG7orK4uojhbqg5ultsH4QT4MXnNHZSfZlIzXgZToWL3+pQmd5wxLzNNaOGfiV6N09fzz7M2tHB6opu5ZqbcI4ldjXOOydg2XNt4kwudlLSYi0cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QoZhpqUIe0JpzGUXLdRW8JHiMhaDfX+XRl0PAkwzET0=;
 b=qBTCEQnO6U2lKT32n+mInNRJ6osNp9Rvv8t1kxEuP35dw86feHUPYpt8aeAS3Z7wnd5zuypr8g7oGTAk0w7IAA0eQdig581BKMl1RCDYSBAKXO5AgHiZ3v9bUVlmawSM1EeLGRckeYQUQ9P2lJZS+Nd7k9vsntSnqt59+RbFtqs=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2165.eurprd05.prod.outlook.com (10.168.55.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Fri, 2 Aug 2019 19:22:21 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 19:22:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>
CC:     Eli Cohen <eli@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>
Subject: Re: [net-next 01/12] net/mlx5: E-Switch, add ingress rate support
Thread-Topic: [net-next 01/12] net/mlx5: E-Switch, add ingress rate support
Thread-Index: AQHVSKNDPnW5aHKn80u4pfZRmdQ1/KboII2AgAAdYIA=
Date:   Fri, 2 Aug 2019 19:22:21 +0000
Message-ID: <b2c77010e96b5fdb6693e5cf0a46a2017f389b44.camel@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
         <20190801195620.26180-2-saeedm@mellanox.com>
         <CAADnVQ+VOSYxbF9RiMJx4kY9bxJCS+Tsf97nsOnRLvi2r6RCog@mail.gmail.com>
In-Reply-To: <CAADnVQ+VOSYxbF9RiMJx4kY9bxJCS+Tsf97nsOnRLvi2r6RCog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4eab0fe-2743-492c-658f-08d7177ebe26
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2165;
x-ms-traffictypediagnostic: DB6PR0501MB2165:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2165C66E66D5DAEBDAAC23CCBED90@DB6PR0501MB2165.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(189003)(199004)(1361003)(7736002)(91956017)(76116006)(64756008)(66556008)(66946007)(4326008)(6246003)(66476007)(66446008)(6486002)(107886003)(305945005)(14454004)(118296001)(76176011)(26005)(5640700003)(6436002)(81166006)(8676002)(186003)(54906003)(2351001)(966005)(316002)(58126008)(2616005)(68736007)(36756003)(81156014)(5024004)(14444005)(71200400001)(5660300002)(256004)(478600001)(6916009)(8936002)(6306002)(102836004)(229853002)(476003)(66066001)(2906002)(11346002)(99286004)(446003)(3846002)(53546011)(6512007)(6506007)(25786009)(2501003)(71190400001)(486006)(86362001)(6116002)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2165;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jbgH2d/ASu9d/yFf9QC2Mx3EjS0LlhryinO+vPOIYH9VUeos0Xfy4hc59SZCMIhaWL7XuAE0enES8Xb4s7O+TFAZYqOqjdVKTEke49UIGdkFdCWhfTZc9UXAqB10NwTcan8pjISL+crGs7gR64rQwDeYOQ8ms904k/mwWtroVTwpudcX39fMtvYwOxR30Fl3JPUOfub5eoKyE17l72YeAjG3fUG2THMXlMbopWU3uGwq6f6cg6Y/lZmRZDEFHmxxvW8IddmYR9WtY68sje5gN9MIu4A2RhrIE1Y1/YtOIfPt3+AfrGO0kUpUcCldcCbMdJD0kEneYeUxEBlAFG63gZXeFazxy+ZbqMvpfiJaT9fuU+O6qWUIvj0Wmx6mzQbJz6NHNYSPr6sQbnGXSqsG2lusW5c9wBG7aB832W64Qd8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB5B7C8D7CD8BC499214070B93930208@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4eab0fe-2743-492c-658f-08d7177ebe26
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 19:22:21.8870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTAyIGF0IDEwOjM3IC0wNzAwLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3Jv
dGU6DQo+IE9uIFRodSwgQXVnIDEsIDIwMTkgYXQgNjozMCBQTSBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG1lbGxhbm94LmNvbT4NCj4gd3JvdGU6DQo+ID4gRnJvbTogRWxpIENvaGVuIDxlbGlAbWVs
bGFub3guY29tPg0KPiA+IA0KPiA+IFVzZSB0aGUgc2NoZWR1bGluZyBlbGVtZW50cyB0byBpbXBs
ZW1lbnQgaW5ncmVzcyByYXRlIGxpbWl0ZXIgb24gYW4NCj4gPiBlc3dpdGNoIHBvcnRzIGluZ3Jl
c3MgdHJhZmZpYy4gU2luY2UgdGhlIGluZ3Jlc3Mgb2YgZXN3aXRjaCBwb3J0IGlzDQo+ID4gdGhl
DQo+ID4gZWdyZXNzIG9mIFZGIHBvcnQsIHdlIGNvbnRyb2wgZXN3aXRjaCBpbmdyZXNzIGJ5IGNv
bnRyb2xsaW5nIFZGDQo+ID4gZWdyZXNzLg0KPiANCj4gTG9va3MgbGlrZSB0aGUgcGF0Y2ggaXMg
b25seSBwYXNzaW5nIGFyZ3MgdG8gZmlybXdhcmUgd2hpY2ggaXMgZG9pbmcNCj4gdGhlIG1hZ2lj
Lg0KPiBDYW4geW91IHBsZWFzZSBkZXNjcmliZSB3aGF0IGlzIHRoZSBhbGdvcml0aG0gdGhlcmU/
DQo+IElzIGl0IGNvbmZpZ3VyYWJsZT8NCg0KSGkgQWxleGVpLCANCg0KSSBhbSBub3Qgc3VyZSBo
b3cgbXVjaCBkZXRhaWxzIHlvdSBhcmUgbG9va2luZyBmb3IsIGJ1dCBsZXQgbWUgc2hhcmUNCnNv
bWUgb2Ygd2hhdCBpIGtub3c6DQoNCkZyb20gYSBwcmV2aW91cyBzdWJtaXNzaW9uIGZvciBsZWdh
Y3kgbW9kZSBzcmlvdiB2ZiBidyBsaW1pdCwgd2hlcmUgd2UgDQppbnRyb2R1Y2VkIHRoZSBGVyBj
b25maWd1cmF0aW9uIEFQSSBhbmQgdGhlIGxlZ2FjeSBzcmlvdiB1c2UgY2FzZTogDQpodHRwczov
L3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzk0MDQ2NTUvDQoNClNvIGJhc2ljYWxseSB0aGUg
YWxnb3JpdGhtIGlzIERlZmljaXQgV2VpZ2h0ZWQgUm91bmQgUm9iaW4gKERXUlIpDQpiZXR3ZWVu
IHRoZSBhZ2VudHMsIHdlIGNhbiBjb250cm9sIEJXIGFsbG9jYXRpb24vd2VpZ2h0IG9mIGVhY2gg
YWdlbnQNCih2ZiB2cG9ydCkuDQoNClF1b3RpbmcgdGhlIGNvbW1pdCBtZXNzYWdlIGZyb20gdGhl
IGFib3ZlIGxpbms6DQoNCiJUaGUgVFNBUiBpbXBsZW1lbnRzIGEgRGVmaWNpdCBXZWlnaHRlZCBS
b3VuZCBSb2JpbiAoRFdSUikgYmV0d2VlbiB0aGUNCmFnZW50cy4gRWFjaCBhZ2VudCBhdHRhY2hl
ZCB0byB0aGUgVFNBUiBpcyBhc3NpZ25lZCB3aXRoIGEgV2VpZ2h0LiBBbg0KYWdlbnQgaXMgYXdh
cmRlZCB3aXRoIHRyYW5zbWlzc2lvbiB0b2tlbnMgYWNjb3JkaW5nIHRvIGl0cyBXZWlnaHQsIGFu
ZA0KY2hhcmdlZCB3aXRoIHRyYW5zbWlzc2lvbiBUb2tlbnMgYWNjb3JkaW5nIHRvIHRoZSBhbW91
bnQgb2YgZGF0YSBpdCBoYXMNCnRyYW5zbWl0dGVkLiBFZmZlY3RpdmVseSwgdGhlIFdlaWdodCAo
cmVsYXRpdmUgdG8gdGhlIG90aGVyIGFnZW50c+KAmQ0KV2VpZ2h0KSBkZWZpbmVzIHRoZSBwZXJj
ZW50YWdlIG9mIHRoZSBCVyBhbiBhZ2VudCB3aWxsIHJlY2VpdmUsDQphc3N1bWluZyBpdCBoYXMg
ZW5vdWdoIGRhdGEgdG8gc3VzdGFpbiB0aGlzIEJXLg0KDQpUaGlzIGFyYml0cmF0aW9uIHNjaGVt
ZSBpcyB3b3JrLXByZXNlcnZpbmcsIG1lYW5pbmcgdGhhdCBhbiBhZ2VudCBub3QNCnVzaW5nIHRo
ZSBlbnRpcmUgQlcgaXQgd2FzIGFsbG9jYXRlZCwgaGFuZHMgb3ZlciB0aGUgZXhjZXNzIEJXLCB0
byBiZQ0KcmVkaXN0cmlidXRlZCBhbW9uZyB0aGUgb3RoZXIgYWdlbnRzLiBFYWNoIGFnZW50IHdp
bGwgcmVjZWl2ZQ0KYWRkaXRpb25hbCBCVyBhY2NvcmRpbmcgdG8gaXRzIFdlaWdodC4iDQoNCg0K
VGhhbmtzLA0KU2FlZWQuDQo=
