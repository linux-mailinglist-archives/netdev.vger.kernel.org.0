Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332D4216386
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 03:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgGGBv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 21:51:27 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:37985
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727124AbgGGBv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 21:51:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFPO0wa9LVLSflN/gtIosFyXD3BOCptKxZLCSMBbpzfwZlCu2qykwfHw1WQ0LdvX9HwPJyMjR4V7H7EwpmsUU37geekWveXvqXImiz+Qnjd5FRu+udo1H2mcrbuuaRA32S50teEkE2fHKAHvxbIvLmOoiaNxvq+fOnDqLjpbRsnhUSi1xzfAxINtVWS6JKCJZ5+2h4kOY5y7ouM1qo/l/p3fXcEyV8wbAuS+7Pyom78+rwMKQ9LaXuJ51JBl5QlWSxN0/MxmPbQuN80HLHFO+oq74TWP0PORDSPPM+XA+jpzqb1J1KRv3aPun26MghS6NQUErJZtWSwA1h2t7ax+Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SE87PlBYRU7kMZPtpvDcncG9ZUcfiWfua9FMzASPhq4=;
 b=oLNgAYbbLpveZNUZcTQLfeq6JqPpc8LHNXjx8OuwOE7zr9+aPq/S3ANvoi3DW1Rg5K00sDbZoGUkN8H0i25YrMM/fAkRnRILCuJsNtdM9VZRYoKYsImFODMtXMyQPLVwCVktbyDygrLlB4Vd4KsqiOMPQZruF2UgsbrkCD1+/M9aRq2uAvvlTmwqL2c7OOC6pTZBjWu6hZZS7+oJmAtRmQih6e7N0WvEnYneR/MUIvw6vUHrwais/e8CFnipGYQXGy7ZtoqReJek69CdIQfSWcxFdxz0hkC+SBoqm7f6ruasH1fflGmNr6gInn9hnRdYszMu4oiGLee29buDrogwUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SE87PlBYRU7kMZPtpvDcncG9ZUcfiWfua9FMzASPhq4=;
 b=Q8sW5kBpIkqtTLP7qIq+IQFP0DOYCbqH/la+yqiBB5WGNmDBSwyRCQp5T8+ZwmrSvnoZrB3YWCMyDb+bbc7HHQAaLcrjkU52BX61b6DXKjzUa1OCfIPhSfjUnsrgoD3XZJzUyedxmF5RqHmXE/6zRp3CtBBhgMFchU39WuOj/34=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6655.eurprd05.prod.outlook.com (2603:10a6:800:131::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21; Tue, 7 Jul
 2020 01:51:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 01:51:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Ron Diskin <rondi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Thread-Topic: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Thread-Index: AQHWUL8B0dTQ7515okubmzIlcDj/s6j1FnWAgAAg54CAAAsHgIAAHreAgADE1wCABNMaAIAABLQAgABi+oA=
Date:   Tue, 7 Jul 2020 01:51:21 +0000
Message-ID: <f5ddd73d9fc5ccdf340de0c6c335888de51d98de.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
         <20200702221923.650779-3-saeedm@mellanox.com>
         <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
         <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
         <20200703105938.2b7b0b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <a8ef2aece592d352dd6bd978db2d430ce55826ed.camel@mellanox.com>
         <20200706125704.465b3a0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200706125704.465b3a0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a7a06ee-4195-468e-b9f9-08d822184012
x-ms-traffictypediagnostic: VI1PR05MB6655:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6655594485F57F835BAEA546BE660@VI1PR05MB6655.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHhfBUuugO42VYyhic5UQvuDan1N0pKEbQZpXmb038VB5c4lM1pF+3Q3jKgNPLxXA4LIHuOIqRpDUBjkP99ktddH3W6V8zM39KH09tisFP2/nTcPpqp4TGrXuv5sWgwdl+H8zeexI9Dgg5UdezKDABXECzORLymOy7Z64woCpupFnXgKqHaLbCfgBfZhDxI1yyD7i3BWKu8HRpxkHEwGgZM2weQmLqWqL2NpywONqAAiurZmqdN50c93aHNlGFixtEc++wmHP8VrV1fRZuRFWzfOqvmcY5BuvTXqWbE29Ek8JIoLhFDaLL9++TIUqudZchAS1s60AJsG75SNUEIANg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(316002)(5660300002)(8676002)(71200400001)(478600001)(66556008)(66446008)(64756008)(66476007)(66946007)(8936002)(54906003)(4326008)(6512007)(2616005)(6916009)(2906002)(6486002)(186003)(6506007)(26005)(86362001)(76116006)(83380400001)(36756003)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /eQ2JG2Y8+Q0rVI1vP1deQ2NByj2lefBS5yGX4fO/qwf/SK6bjoep6OLvcqP2uySVAU4D+zslfbqU+r3GRQpA7jsbrrn2rjIKgMRizDooXJCEY75zYAv00HHaR43r2yRSIKgvzzbRwry7rwWPuTx8L7AY6f4uW0+w6miIJeafgnef7SjJ2vYi13QhuS7PLS1EUi5QRfi9u7G5Ylab6zmlMUF2+H6/huX5tMfcwNNjQqEHJ4hA9A2EbFylYlnAySygjQHOgCu8YXgnfpGfw6Z+iXjhEVZ1FwTiD1njDDEo3A+ru0q/Uiq266r2vBPWrEB1RqfpFmuK8PuW5/Fk1uRtkMCpdVhctyRQrgUB7+ICfAaeqNCqweGdUkyy0E2jOTt7Woj5QXZuU4Bw8owJPMoyYyiXb8q0vAvmO4jVuvhEu8sehCat3LjCwQo++GDENlX5MVifzTeyDWk0ylSqSo07YFEOdDHhuhhmU27nd6KHxY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F2640213832F848983F9710A2572345@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7a06ee-4195-468e-b9f9-08d822184012
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 01:51:22.0115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7YRhOIM6vusfO7MvgwsF0RTBQMdoDQcZHElO71MF8oI+32lgzXJD8BtOSe1aKhQJEMBV/V2pT5rrim+pnaaCFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA3LTA2IGF0IDEyOjU3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCA2IEp1bCAyMDIwIDE5OjQwOjUwICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+ID4gSSBkb24ndCByZWFsbHkgZmVlbCB0b28gc3Ryb25nbHksIEknbSBqdXN0IHRyeWlu
ZyB0byBnZXQgdGhlDQo+ID4gPiBkZXRhaWxzDQo+ID4gPiBiZWNhdXNlIEkgZmVlbCBsaWtlIHRo
ZSBzaXR1YXRpb24gaXMgZ29pbmcgdG8gYmUgaW5jcmVhc2luZ2x5DQo+ID4gPiBjb21tb24uDQo+
ID4gPiBJdCdkIGJlIHF1aXRlIHNhZCBpZiBkcml2ZXJzIGhhZCB0byByZWltcGxlbWVudCBhbGwg
c3RhdHMgaW4gc3cuDQo+ID4gDQo+ID4gRGVwZW5kcyBvbiBIVywgb3VyIEhXL0ZXIHN1cHBvcnRz
IHByb3ZpZGluZyBzdGF0cyBwZXINCj4gPiAoVnBvcnQvZnVuY3Rpb24pLg0KPiA+IHdoaWNoIG1l
YW5zIGlmIGEgcGFja2V0IGdvdCBsb3N0IGJldHdlZW4gdGhlIE5JQyBhbmQgdGhlIG5ldGRldg0K
PiA+IHF1ZXVlLA0KPiA+IGl0IHdpbGwgYmUgY291bnRlZCBhcyByeC1wYWNrZXQvbWNhc3QsIGFs
dGhvdWdoIHdlIGhhdmUgYSBwcml2YXRlDQo+ID4gY291bnRlciB0byBzaG93IHRoaXMgZHJvcCBp
biBldGh0b29sIGJ1dCB3aWxsIGJlIGNvdW50ZWQgaW4gcngNCj4gPiBjb3VudGVyDQo+ID4gaW4g
bmV0ZGV2IHN0YXRzLCBpZiB3ZSB1c2VkIGh3IHN0YXRzLg0KPiA+IA0KPiA+IHNvIHRoaXMgaXMg
d2h5IGkgYWx3YXlzIHByZWZlciBTVyBzdGF0cyBmb3IgbmV0ZGV2IHJlcG9ydGVkIHN0YXRzLA0K
PiA+IGFsbA0KPiA+IHdlIG5lZWQgdG8gY291bnQgaW4gU1cge3J4LHR4fSBYIHtwYWNrZXRzLCBi
eXRlc30gKyByeCBtY2FzdA0KPiA+IHBhY2tldHMuDQo+IA0KPiBJZiB0aGF0IHdhcyBpbmRlZWQg
dGhlIGludGVudGlvbiBpdCdkIGhhZCBiZWVuIGRvbmUgaW4gdGhlIGNvcmUsIG5vdA0KPiBlYWNo
IGRyaXZlciBzZXBhcmF0ZWx5Li4NCj4gDQoNCnRoaXMgaXMgd2h5IGl0IGRlcGVuZHMgb24gdGhl
IEhXLiB1bmZvcnR1bmF0ZWx5IGluIG91ciBjYXNlIEhXIHN0YXRzICE9DQpTVyBzdGF0cy4NCg0K
PiA+IFRoaXMgZ2l2ZXMgbW9yZSBmbGV4aWJpbGl0eSBhbmQgY29ycmVjdG5lc3MsIGFueSBnaXZl
biBIVyBjYW4NCj4gPiBjcmVhdGUNCj4gPiBtdWx0aXBsZSBuZXRkZXZzIG9uIHRoZSBzYW1lIGZ1
bmN0aW9uLCB3ZSBuZWVkIHRoZSBuZXRkZXYgc3RhdHMgdG8NCj4gPiByZWZsZWN0IHRyYWZmaWMg
dGhhdCBvbmx5IHdlbnQgdGhyb3VnaCB0aGF0IG5ldGRldi4NCj4gPiANCj4gPiA+IEkgdGhvdWdo
dCBpdCB3b3VsZCBiZSBlbnRpcmVseSByZWFzb25hYmxlIGZvciB0aGUgZHJpdmVyIHRvIHJlYWQN
Cj4gPiA+IHRoZQ0KPiA+ID4gc3RhdHMgZnJvbSBhIGRlbGF5ZWQgd29yayBldmVyeSAxLzIgSFog
YW5kIGNhY2hlIHRoYXQuIFdlIGRvIGhhdmUNCj4gPiA+IGENCj4gPiA+IGtub2IgaW4gZXRodG9v
bCBJUlEgY29hbGVzY2luZyBzZXR0aW5ncyBmb3Igc3RhdHMgd3JpdGViYWNrDQo+ID4gPiBmcmVx
dWVuY3kuDQo+ID4gDQo+ID4gU29tZSBjdXN0b21lcnMgZGlkbid0IGxpa2UgdGhpcyBzaW5jZSBm
b3IgZHJpdmVycyB0aGF0IGltcGxlbWVudA0KPiA+IHRoaXMNCj4gPiB0aGVpciBDUFUgcG93ZXIg
dXRpbGl6YXRpb24gd2lsbCBiZSBzbGlnaHRseSBoaWdoZXIgb24gaWRsZS4NCj4gDQo+IE90aGVy
IGN1c3RvbWVycyBtYXkgZGlzbGlrZSB0aGUgcGVyIHBhY2tldCBjeWNsZXMuDQo+IA0KPiBJIGRv
bid0IHJlYWxseSBtaW5kLCBJIGp1c3QgZm91bmQgdGhlIGNvbW1pdCBtZXNzYWdlIHRvIGJlIGxh
Y2tpbmcgDQo+IGZvciBhIGZpeCwgd2hpY2ggdGhpcyBzdXBwb3NlZGx5IGlzLg0KPiANCg0KWWVz
IGNvbW1pdCBtZXNzYWdlIGNvdWxkIHVzZSBzb21lIGltcHJvdmVtZW50Lg0KDQpJIHRoaW5rIGl0
IGlzIGV2ZW4gd29yc2UgdGhhbiBpIHRob3VnaHQsIHdlIHJlbW92ZWQgIHRoZSBiYWNrZ3JvdW5k
DQpyZWZyZXNoaW5nIG9mIHN0YXRzIGR1ZSB0byB0aGUgRlcgZXZlbnRzIHN1cHBvcnQgdG8gdXBk
YXRlcyBzb21lDQpjb3VudGVycy4gTXVsdGljYXN0IGNvdW50ZXIgY2FuJ3QgYmUgcmVmcmVzaGVk
IGJ5IEZXIGV2ZW50cyBzaW5jZSBpdCBpcw0KYSBkYXRhIHBhdGggY291bnRlcnMuIA0KDQo+IEFs
c28gbG9va3MgbGlrZSB5b3UgcmVwb3J0IHRoZSB0b3RhbCBudW1iZXIgb2YgbWNhc3QgcGFja2V0
cyBpbg0KPiBldGh0b29sDQo+IC1TLCB3aGljaCBzaG91bGQgYmUgaWRlbnRpY2FsIHRvIGlwIC1z
PyBJZiBzbyBwbGVhc2UgcmVtb3ZlIHRoYXQuDQoNCndoeSA/IGl0IGlzIG9rIHRvIHJlcG9ydCB0
aGUgc2FtZSBjb3VudGVyIGJvdGggaW4gZWh0dG9vbCBhbmQgbmV0ZGV2DQpzdGF0cy4NCg0K
