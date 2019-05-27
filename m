Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C17292B1A3
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 11:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfE0J5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 05:57:21 -0400
Received: from mail-eopbgr700086.outbound.protection.outlook.com ([40.107.70.86]:52793
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfE0J5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 05:57:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+F6IkD/p2LZkfsi4vtbHIKIctngkv5s39A8I4I0a+0=;
 b=Ar6wsAHpTnN+n6mt+m+DjlThG4cOFtbC/884JkqSXJZALjLCGJAM+7bK4Orjw7KyVkLqo9Zn2OqC9KjWVgQGRnIfPXAe4+IviSsw3e7PkaEKJViTk8jJhg8Zwo5d3dlB6rMGc77Fi4ymRDrIafoKzJYh63bfcpQnoxbs3JT2LsY=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB2857.namprd11.prod.outlook.com (20.176.100.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Mon, 27 May 2019 09:57:18 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 09:57:18 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/4] net: aquantia: tx clean budget logic error
Thread-Topic: [PATCH net 1/4] net: aquantia: tx clean budget logic error
Thread-Index: AQHVEuBVT4SUIS3FcU+FHgKEouHK5KZ+cMUAgABOlAA=
Date:   Mon, 27 May 2019 09:57:18 +0000
Message-ID: <ba532713-7ca6-6497-8c18-31c418d41ee5@aquantia.com>
References: <cover.1558777421.git.igor.russkikh@aquantia.com>
 <f659b94aff7f57a4592d89d797060d24f22a1bb9.1558777421.git.igor.russkikh@aquantia.com>
 <20190526.221556.885075788672387642.davem@davemloft.net>
In-Reply-To: <20190526.221556.885075788672387642.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0376.eurprd05.prod.outlook.com
 (2603:10a6:7:94::35) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c4478e4-fa0b-4619-a7e7-08d6e289b408
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR11MB2857;
x-ms-traffictypediagnostic: DM6PR11MB2857:
x-microsoft-antispam-prvs: <DM6PR11MB285731BF92711F6B8EAF18F6981D0@DM6PR11MB2857.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(39830400003)(396003)(199004)(189003)(6916009)(4326008)(7736002)(186003)(386003)(66066001)(6512007)(25786009)(99286004)(6506007)(53546011)(446003)(36756003)(229853002)(26005)(31686004)(11346002)(6116002)(3846002)(14444005)(256004)(71200400001)(486006)(476003)(44832011)(2616005)(68736007)(52116002)(76176011)(6246003)(53936002)(71190400001)(6486002)(66476007)(66556008)(66446008)(8936002)(8676002)(81156014)(81166006)(6436002)(72206003)(316002)(66946007)(14454004)(73956011)(478600001)(5660300002)(102836004)(2906002)(31696002)(86362001)(305945005)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2857;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n+OxP7SwQGxKwdjpnq3n7dclcJLnEs9dT3YFUXWb1a+mgXGMW7k/ekbIgXWHrfaxfPdMGXtDcvjctfzx1QqdDSWj3WW9pYt9p4YD1ds786ekx6w815+u9tZmRFnN0YnXdxm9xO4Hu+nr86OyeZ33TDHly6RBJiExiqMpK8oCWke3vu4m3N586fwESwWg9MCdViUxsFE+eLt31fxULXvS843NmW/c8z4yvGQgx/PvuKEihH0ZeN4eSnqPO6uhx24URAh9h4VlOXqE70+jXHgg8FBQeDwWs8NJqygCYNr5D2tVC+VZRv0bYOm5FU18z73TDwUpsRLVDTNzn7E5KHrz/3Oqq4NkQmS/u5krpNxdH+fc2Twt63aYLGif/jKEUZBflxxbQmsM+ETzE5nN2bVtyCyhzgtkh1gIdlONvhyHM9U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C940247609417F4A833A73CC38002D1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c4478e4-fa0b-4619-a7e7-08d6e289b408
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 09:57:18.1695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2857
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDI3LjA1LjIwMTkgODoxNSwgRGF2aWQgTWlsbGVyIHdyb3RlOg0KPiBGcm9tOiBJZ29y
IFJ1c3NraWtoIDxJZ29yLlJ1c3NraWtoQGFxdWFudGlhLmNvbT4NCj4gRGF0ZTogU2F0LCAyNSBN
YXkgMjAxOSAwOTo1Nzo1OSArMDAwMA0KPiANCj4+IEluIGNhc2Ugbm8gb3RoZXIgdHJhZmZpYyBo
YXBwZW5pbmcgb24gdGhlIHJpbmcsIGZ1bGwgdHggY2xlYW51cA0KPj4gbWF5IG5vdCBiZSBjb21w
bGV0ZWQuIFRoYXQgbWF5IGNhdXNlIHNvY2tldCBidWZmZXIgdG8gb3ZlcmZsb3cNCj4+IGFuZCB0
eCB0cmFmZmljIHRvIHN0dWNrIHVudGlsIG5leHQgYWN0aXZpdHkgb24gdGhlIHJpbmcgaGFwcGVu
cy4NCj4+DQo+PiBUaGlzIGlzIGR1ZSB0byBsb2dpYyBlcnJvciBpbiBidWRnZXQgdmFyaWFibGUg
ZGVjcmVtZW50b3IuDQo+PiBWYXJpYWJsZSBpcyBjb21wYXJlZCB3aXRoIHplcm8sIGFuZCB0aGVu
IHBvc3QgZGVjcmVtZW50ZWQsDQo+PiBjYXVzaW5nIGl0IHRvIGJlY29tZSBNQVhfSU5ULiBTb2x1
dGlvbiBpcyByZW1vdmUgZGVjcmVtZW50b3INCj4+IGZyb20gdGhlIGBmb3JgIHN0YXRlbWVudCBh
bmQgcmV3cml0ZSBpdCBpbiBhIGNsZWFyIHdheS4NCj4+DQo+PiBGaXhlczogYjY0N2QzOTgwOTQ4
ZSAoIm5ldDogYXF1YW50aWE6IEFkZCB0eCBjbGVhbiBidWRnZXQgYW5kIHZhbGlkIGJ1ZGdldCBo
YW5kbGluZyBsb2dpYyIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBJZ29yIFJ1c3NraWtoIDxpZ29yLnJ1
c3NraWtoQGFxdWFudGlhLmNvbT4NCj4gDQo+IEkgdGhpbmsgdGhlIFRYIGNsZWFuIGJ1ZGdldCBp
cyBhIHZlcnkgYmFkIGlkZWEuDQo+IA0KPiBZb3Ugc2hvdWxkIGFsd2F5cyBkbyBhcyBtdWNoIFRY
IGNsZWFuIHdvcmsgYXMgdGhlcmUgaXMgVE9ETy4NCg0KSGkgRGF2aWQsDQoNClRoaXMgaXMgbm90
IGFib3V0IGludHJvZHVjaW5nIHR4IGNsZWFuIGJ1ZGdldCwgYnV0IGFib3V0IGZpeGluZyBhIGJ1
Zy4NCg0KdHggY2xlYW4gYnVkZ2V0IGxvZ2ljIGlzIHByZXNlbnQgaW4gbWFqb3JpdHkgb2YgdGhl
IGRyaXZlcnMgYXMgSSBzZWUsDQppbmNsdWRpbmcgaWdiLGl4Z2JlLG1seDUuDQoNCkkgc2VlIGl0
IGFzIGEgbG9naWNhbCBhY3Rpb24gdG8gbGltaXQgdGhlIHRpbWUgZHJpdmVyIHNwZW5kcyBpbiBu
YXBpX3BvbGwNCnVuZGVyIG5hcGkgYnVkZ2V0Lg0KDQpSZWdhcmRzLA0KICBJZ29yDQo=
