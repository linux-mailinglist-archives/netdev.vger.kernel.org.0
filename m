Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51DD13DE09
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgAPOwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:52:41 -0500
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:23862
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbgAPOwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 09:52:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9VGOfyXLqwVD8VSqRu4Fdeot7x78lE2uzO1Pql7qZIcvqBgWevg63sAKNUJ/BmGcbNwYQj171ACQBpjlUARO/GRDldXStKR0VUsniANDlPR7ZrDZeZGl3FWfZDeyMMQRbvZLO07rsZgyX6K9gcBXJIKK2IMPCuTlz7SSH2xwVcoXYESINdKj32Tbv+L00wZJPOykpssv55VVmBmRwSWwOrLyeJG25uVNpx04DHM9QggYv04OSpd7QMt6K8KZBfOm4QQu5YSnG4LiRN5GNUd1wpvR6tzid67qlcL8e6nBoADB69hFm4wvx6XGk/tRy0S5rO5QMBZCCR5MGJlVagrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcmWB3H11qNoVDDtl2oo0m0WmOwyK4KDuYqzpIXJWzI=;
 b=HgppXWC/q1zZ0fhm1noWkgY8gYqvpiV6NdiaA1G1sLY4xQp1nMuhIOpVYTV+LeLO4P+A4AXwVmCuJLS5glA9p2rmJp9pmjihfXSnQwjpRdbqctQJsK4AlsrNqcFBimTEQJ64WY0LHxYBwNBSWBshRmlPeaB38ZBGTPZSb7iQA2ZfIc4eTSPv/MGL6ntLKhxQQC/8iswXoCIwyy1R9M6qG6+fFXwr1KikmcHo+cTIvQiqcFthS5Rysbjdg6AJZaMp8xZKf91gRRXjAmTUw6I4ca07+fMrALPv2l9l0UPH0Uuhg2loY5BF37Ut4rpql88UiztQApgoHDLg75gLEb9iuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcmWB3H11qNoVDDtl2oo0m0WmOwyK4KDuYqzpIXJWzI=;
 b=A+wp+TXRiBomPDfYA4LSRpjerfzDQTgEoTREhEvYKIg3mhddn2eAyvHE7N3FBvrlkNMTsTicMbtAKxu3fgyjHwCtL1UKU6QO8yjqCdmjvnnB8C55dARpbQIhkrakR3EWiaeNWAbZAeMYGew51AXzTYzw7tiKjiqhDUsQOuVKr9k=
Received: from DB7PR05MB4204.eurprd05.prod.outlook.com (52.134.107.161) by
 DB7PR05MB4266.eurprd05.prod.outlook.com (52.134.108.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Thu, 16 Jan 2020 14:52:36 +0000
Received: from DB7PR05MB4204.eurprd05.prod.outlook.com
 ([fe80::1c4e:bcb1:679f:f6]) by DB7PR05MB4204.eurprd05.prod.outlook.com
 ([fe80::1c4e:bcb1:679f:f6%3]) with mapi id 15.20.2623.018; Thu, 16 Jan 2020
 14:52:35 +0000
Received: from [10.80.1.94] (193.47.165.251) by AM0PR02CA0042.eurprd02.prod.outlook.com (2603:10a6:208:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Thu, 16 Jan 2020 14:52:35 +0000
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC 3/3] net/mlx5: Add FW upgrade reset support
Thread-Topic: [PATCH net-next RFC 3/3] net/mlx5: Add FW upgrade reset support
Thread-Index: AQHVyvM49OAL4RHfXUeZhKhHIzGBuKfr04GAgAGPw4A=
Date:   Thu, 16 Jan 2020 14:52:35 +0000
Message-ID: <2f7a4d81-6ed9-7c93-1562-1df4dc7f9578@mellanox.com>
References: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
 <1579017328-19643-4-git-send-email-moshe@mellanox.com>
 <20200115070145.3db10fe4@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200115070145.3db10fe4@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM0PR02CA0042.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::19) To DB7PR05MB4204.eurprd05.prod.outlook.com
 (2603:10a6:5:18::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=moshe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4ce066e5-0e65-4717-f750-08d79a93b953
x-ms-traffictypediagnostic: DB7PR05MB4266:
x-microsoft-antispam-prvs: <DB7PR05MB4266F99D7CF89AA35540833CD9360@DB7PR05MB4266.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(8676002)(66946007)(71200400001)(5660300002)(66446008)(16576012)(31696002)(4326008)(64756008)(66476007)(54906003)(66556008)(316002)(36756003)(52116002)(86362001)(186003)(26005)(53546011)(2616005)(16526019)(6916009)(956004)(6486002)(8936002)(31686004)(2906002)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB4266;H:DB7PR05MB4204.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fRwYKTVTdTdEcAfDntMr396zIyRSIScPgPTN96FTd+Vy3pY/09xkE9uQLhX+0ERYvUKA6z0XsPNR4iBizQjnD2dPfNtzfHpC9XoSc6YgbmjryQ/LDQtD7Ny99rCOGE5OV2JNN/Lr2lcEGwHMB5zNbj8FjUPUsXv0GSUe4zXYPFRbXCBRRMDNOk9ohgVidZyRiSNuBrve6YYMv+CE7wqEdJKykm6eWRJTkwo+3V/EDiqx3Ans5ZFXPC61jcBh1mIasxVamsKb20LGbv9WpgRNST4g4ocBGGzWldu4f/JnM19wN0rfpD3NkQhycIYee0+rLqWIj4znSZUtgqbE6ha7YwKkzEIGduGGwrwMOe9bqrivn1gC7z2fMp+B00tnGFPT/aYN63NDSMSL0iCHejrz7+bdYzcbSPz2rPuzvrIlghnI3JanJxg5+09PTuSYnLDd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B643D3360A5660449C6E63F3056008FC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce066e5-0e65-4717-f750-08d79a93b953
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 14:52:35.8381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 06y75cZua9KDk+WRt5Dcpzl0CEr0TRL9D5Td5f7GM3Hb0S7y2koH0SkZ230xYVy2bpZZNua9Hz2IblJwJc7JJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4266
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE1LzIwMjAgNTowMSBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFR1ZSwg
MTQgSmFuIDIwMjAgMTc6NTU6MjggKzAyMDAsIE1vc2hlIFNoZW1lc2ggd3JvdGU6DQo+PiBBZGQg
c3VwcG9ydCBmb3IgRlcgdXBncmFkZSByZXNldC4NCj4+IE9uIGRldmxpbmsgcmVsb2FkIHRoZSBk
cml2ZXIgY2hlY2tzIGlmIHRoZXJlIGlzIGEgRlcgc3RvcmVkIHBlbmRpbmcNCj4+IHVwZ3JhZGUg
cmVzZXQuIEluIHN1Y2ggY2FzZSB0aGUgZHJpdmVyIHdpbGwgc2V0IHRoZSBkZXZpY2UgdG8gRlcg
dXBncmFkZQ0KPj4gcmVzZXQgb24gbmV4dCBQQ0kgbGluayB0b2dnbGUgYW5kIGRvIGxpbmsgdG9n
Z2xlIGFmdGVyIHVubG9hZC4NCj4+DQo+PiBUbyBkbyBQQ0kgbGluayB0b2dnbGUsIHRoZSBkcml2
ZXIgZW5zdXJlcyB0aGF0IG5vIG90aGVyIGRldmljZSBJRCB1bmRlcg0KPj4gdGhlIHNhbWUgYnJp
ZGdlIGJ5IGNoZWNraW5nIHRoYXQgYWxsIHRoZSBQRiBmdW5jdGlvbnMgdW5kZXIgdGhlIHNhbWUg
UENJDQo+PiBicmlkZ2UgaGF2ZSBzYW1lIGRldmljZSBJRC4gSWYgbm8gb3RoZXIgZGV2aWNlIGl0
IHVzZXMgUENJIGJyaWRnZSBsaW5rDQo+PiBjb250cm9sIHRvIHR1cm4gbGluayBkb3duIGFuZCB1
cC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNb3NoZSBTaGVtZXNoIDxtb3NoZUBtZWxsYW5veC5j
b20+DQo+IEknZCBoYXZlIGEgc2xpZ2h0IHByZWZlcmVuY2UgZm9yIHRoZSByZXNldCB0byBiZSBh
biBleHBsaWNpdCBjb21tYW5kDQo+IHJhdGhlciB0aGFuIHNvbWV0aGluZyB0aGUgZHJpdmVyIGRv
ZXMgYXV0b21hdGljYWxseSBvbiB0aGUgcmVsb2FkIGlmDQo+IHRoZXJlIGFyZSBwZW5kaW5nIGNo
YW5nZXMuIFdvbid0IHRoZXJlIGV2ZXIgYmUgc2NlbmFyaW9zIHdoZXJlIHVzZXJzDQo+IGp1c3Qg
d2FudCB0byBoYXJkIHJlc2V0IHRoZSBkZXZpY2UgZm9yIHRoZWlyIG93biByZWFzb24/DQoNCg0K
R29vZCBwb2ludCwgSSB3aWxsIHRha2UgaXQgd2l0aCBKaXJpLCBtYXkgYWRkIGEgbmV3IGRldmxp
bmsgZGV2IGNvbW1hbmQgDQpmb3IgdGhhdC4NCg0KPg0KPiBJZiBtdWx0aXBsZSBkZXZpY2VzIHVu
ZGVyIG9uZSBicmlkZ2UgYXJlIGEgcmVhbCBjb25jZXJuIChvciBvdGhlcndpc2UNCj4gaW50ZXJk
ZXBlbmRlbmNpZXMpIHdvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8gbWFyayB0aGUgZGV2aWNlcyBhcyAi
cmVsb2FkDQo+IHBlbmRpbmciIGFuZCBwZXJmb3JtIHRoZSByZWxvYWRzIG9uY2UgYWxsIGRldmlj
ZXMgaW4gdGhlIGdyb3VwIGhhcyB0aGlzDQo+IG1hcmsgc2V0Pw0KDQpBbGwgbWx4NSBjdXJyZW50
IGRldmljZXMgc3VwcG9ydCBQQ0kgLSBFeHByZXNzIG9ubHkuDQoNClBDSS1FeHByZXNzIGRldmlj
ZSBzaG91bGQgaGF2ZSBpdHMgb3duIFBDSS1FeHByZXNzIGJyaWRnZSwgaXQgaXMgMXgxIA0KY29u
bmVjdGlvbi4NCg0KU28gdGhlIGNoZWNrIGhlcmUgaXMganVzdCB0byB2ZXJpZnksIGFsbCBmdW5j
dGlvbnMgZm91bmQgdW5kZXIgdGhlIA0KYnJpZGdlIGFyZSBleHBlY3RlZCB0byBiZSB0aGUgc2Ft
ZSBkZXZpY2UgZnVuY3Rpb25zIChQRnMgYW5kIFZGcykuDQoNCg==
