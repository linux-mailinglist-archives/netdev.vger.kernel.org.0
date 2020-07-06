Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8559215F8A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGFTkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:40:55 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:6066
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbgGFTky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 15:40:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLsDLdXraGlofu2rJo+ksJ9XpyHDLKmdsbJyqjQ/LCk3LF3h4UPUQb2tuAYes9vhbzYY6q1LLCuPNm01glf+zqhlkc2zbutDqZEAwnA2FeHN/iR/wEB0a+2vFzvMyZLrfJUmS21Pw3nwyRyI7SJJukY9Pa65sewOoG62RreJW6OIHAOrwOr/WeKGinjBgPFhKGHmJgeGf2MrcHzUOdBzm71XC+ZmgoToTwVeOKR21ISd2SuACihMo3e63/d+T4fJpJdkfaZioLaxPx27bctQkiRMyCYGnrS2kCc7oXrvrOxWU6D9k/f1ioSDsxHap7ZwTYfMlPZjcG3snB2e6pmuhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQIhNt0aY4pmK/gvixsc3iw3gz6zyJcMnZHBV1tCjt0=;
 b=SVCjvLvNdoTFOp7M/nRhPIeXDKc3F61iqKN+IqMnmEIzjbi0nqLMsCsAZzXf9+Zm+kH4DOU/4eqVyN8vIIjXZQU4dhR1GdbXt8EikXz8E7fYpMyv9XO4iMTh9djAOUYekahH1aRRYRBHpRzjFY6LzepOwqxiUIVizor5Ez1uScyqim/LYKTSg/mdr2wS1eKiMV9/zzrVHcEYLRkgijzhN9Q9qYXH4wmkKDfiSAJw6ilMRv1ke+Thr6pu/4cfQhjdMaTYhQoCq2LrkojXjwoZ6zqW05BZmtM9YGoGyJl+YzWC/cAjWpEuSFOFOYDCjioDudn77k+HJJzS9jRYe6DEYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQIhNt0aY4pmK/gvixsc3iw3gz6zyJcMnZHBV1tCjt0=;
 b=PU6VYxS7tjP+2u3tRYpoo3xKq/RxgLN5IyHdge0xh5r0lPPnkDGvDZAj2DU/GEPcgUf8rt13pWEsdoMLbl886nHDlj5u5LhHfaO/dALJ/vIffKWjh5qErZ2f95JqxaOzf+XvSdop7RxRTokjsl+2FM7TCEG5sfzxgiUhV2NVG7o=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3518.eurprd05.prod.outlook.com (2603:10a6:802:17::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Mon, 6 Jul
 2020 19:40:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 19:40:50 +0000
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
Thread-Index: AQHWUL8B0dTQ7515okubmzIlcDj/s6j1FnWAgAAg54CAAAsHgIAAHreAgADE1wCABNMaAA==
Date:   Mon, 6 Jul 2020 19:40:50 +0000
Message-ID: <a8ef2aece592d352dd6bd978db2d430ce55826ed.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
         <20200702221923.650779-3-saeedm@mellanox.com>
         <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
         <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
         <20200703105938.2b7b0b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200703105938.2b7b0b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 78023ba5-909e-41f9-9f3e-08d821e47d04
x-ms-traffictypediagnostic: VI1PR05MB3518:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3518CC73C3853963C96AF195BE690@VI1PR05MB3518.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HYOby67+zB6zF8BUrQo1FRPqmUtl6xuZRPHOsGrPnONivRKO2B/0k9nb1MIKaZfyv5d+dBfdMnb0kF95dS8XvxeaVhaVEmmrdh7AYAeRG4XPuw5RzwSQT0l6LvxKw5o6DB/s1pmjhg5EfPJ/2Ft15v+HuCibITpFgogvhWWcfIR5E2HxIDClj2kWgYouVIhEWdd5RnmY/qOfrbWNCKzjbYH3zGNyOw1fSeHvcKm7OryvnnJTRA+VSGUbwOaBcHlNOEicdYqHbS517Vlw/4jqF/qBFozXxFlTa3rFCndE0E5GVXfk35R6N3zfI7VxUcF6ftXRr/Z0/XzGBfAnQmodOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(186003)(76116006)(36756003)(91956017)(66946007)(6506007)(66556008)(64756008)(66446008)(83380400001)(316002)(478600001)(6486002)(8936002)(2616005)(4326008)(5660300002)(26005)(6916009)(71200400001)(86362001)(54906003)(8676002)(66476007)(6512007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: K7aVFgNxSxYOQ0+WzMqogguqtKVmBBQ1OmZ5U7SlJ5pbPQUDxlSHrQlsg5ys0g8k6+eiBo59RFBADKfIUiLch+z/y1zo8Rtv3PHLS+HHLPghwREGTghvoEtnQAmczKZJmlzTwVkrPuZnAqHvDBocWod+LrJ8crhiu76tIAs+KafpsIkE3WPF6uikJ8PCFKmx03pn89vDSl41+lZnhk3DaiAiEtYcuNCoi4eeWVGQGerZuFMyK0YiWxAoRJgm532nbvlxAEYiEc+zU2bXIGcuT1r8VMaT94zK73qbUlF00YH4BKri9ugBusQXeQrYRuQIM5NVi23jl0wejouLrb0KfTbE7UQE4PXnx3bnNlZqU6QVidrkQWlTsOikohv8ZOHR9eV9vRKIKD+6QlqUqi2SB25TUxJDp1qU6R6eorg7ArCssSCmdfusjp7s2EcSti+IhWDBr6yBL66DeOCS7xDtd1UflUdLMRFvveNVuZY3qv8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5F0B6DF507EEF45AFB343473CA7A9C9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78023ba5-909e-41f9-9f3e-08d821e47d04
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 19:40:50.5530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yxigA4/bv8tHjBn+HXlF8jWPlrJ07JKgl5oWUHa6EGwfxphBBNW65/qvJw9bm8RrtOYpnMaEXOkEIicZiuy6BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3518
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTAzIGF0IDEwOjU5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAzIEp1bCAyMDIwIDA2OjE1OjA5ICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+ID4gPiBUbyByZWFkIG1jYXN0IGNvdW50ZXIgd2UgbmVlZCB0byBleGVjdXRlIEZXIGNv
bW1hbmQgd2hpY2ggaXMNCj4gPiA+ID4gYmxvY2tpbmcsDQo+ID4gPiA+IHdlIGNhbid0IGJsb2Nr
IGluIGF0b21pYyBjb250ZXh0IC5uZG9fZ2V0X3N0YXRzNjQgOiggLi4gd2UgaGF2ZQ0KPiA+ID4g
PiB0bw0KPiA+ID4gPiBjb3VudCBpbiBTVy4gDQo+ID4gPiA+IA0KPiA+ID4gPiB0aGUgcHJldmlv
dXMgYXBwcm9hY2ggd2Fzbid0IGFjY3VyYXRlIGFzIHdlIHJlYWQgdGhlIG1jYXN0DQo+ID4gPiA+
IGNvdW50ZXINCj4gPiA+ID4gaW4gYQ0KPiA+ID4gPiBiYWNrZ3JvdW5kIHRocmVhZCB0cmlnZ2Vy
ZWQgYnkgdGhlIHByZXZpb3VzIHJlYWQuLiBzbyB3ZSB3ZXJlDQo+ID4gPiA+IG9mZg0KPiA+ID4g
PiBieQ0KPiA+ID4gPiB0aGUgaW50ZXJ2YWwgYmV0d2VlbiB0d28gcmVhZHMuICANCj4gPiA+IA0K
PiA+ID4gQW5kIHRoYXQncyBiYWQgZW5vdWdoIHRvIGNhdXNlIHRyb3VibGU/IFdoYXQncyB0aGUg
d29yc3QgY2FzZQ0KPiA+ID4gdGltZQ0KPiA+ID4gZGVsdGEgeW91J3JlIHNlZWluZz8NCj4gPiAN
Cj4gPiBEZXBlbmRzIG9uIHRoZSB1c2VyIGZyZXF1ZW5jeSB0byByZWFkIHN0YXRzLA0KPiA+IGlm
IHlvdSByZWFkIHN0YXRzIG9uY2UgZXZlcnkgNSBtaW51dGVzIHRoZW4gbWNhc3Qgc3RhdHMgYXJl
IG9mZiBieQ0KPiA+IDUNCj4gPiBtaW51dGVzLi4NCj4gPiANCj4gPiBKdXN0IHRoaW5raW5nIG91
dCBsb3VkLCBpcyBpdCBvayBvZiB3ZSBidXN5IGxvb3AgYW5kIHdhaXQgZm9yIEZXDQo+ID4gcmVz
cG9uc2UgZm9yIG1jYXN0IHN0YXRzIGNvbW1hbmRzID8gDQo+ID4gDQo+ID4gSW4gZXRodG9vbCAt
UyB0aG91Z2gsIHRoZXkgYXJlIGFjY3VyYXRlIHNpbmNlIHdlIGdyYWIgdGhlbSBvbiB0aGUNCj4g
PiBzcG90DQo+ID4gZnJvbSBGVy4NCj4gDQo+IEkgZG9uJ3QgcmVhbGx5IGZlZWwgdG9vIHN0cm9u
Z2x5LCBJJ20ganVzdCB0cnlpbmcgdG8gZ2V0IHRoZSBkZXRhaWxzDQo+IGJlY2F1c2UgSSBmZWVs
IGxpa2UgdGhlIHNpdHVhdGlvbiBpcyBnb2luZyB0byBiZSBpbmNyZWFzaW5nbHkgY29tbW9uLg0K
PiBJdCdkIGJlIHF1aXRlIHNhZCBpZiBkcml2ZXJzIGhhZCB0byByZWltcGxlbWVudCBhbGwgc3Rh
dHMgaW4gc3cuDQo+IA0KDQpEZXBlbmRzIG9uIEhXLCBvdXIgSFcvRlcgc3VwcG9ydHMgcHJvdmlk
aW5nIHN0YXRzIHBlciAoVnBvcnQvZnVuY3Rpb24pLg0Kd2hpY2ggbWVhbnMgaWYgYSBwYWNrZXQg
Z290IGxvc3QgYmV0d2VlbiB0aGUgTklDIGFuZCB0aGUgbmV0ZGV2IHF1ZXVlLA0KaXQgd2lsbCBi
ZSBjb3VudGVkIGFzIHJ4LXBhY2tldC9tY2FzdCwgYWx0aG91Z2ggd2UgaGF2ZSBhIHByaXZhdGUN
CmNvdW50ZXIgdG8gc2hvdyB0aGlzIGRyb3AgaW4gZXRodG9vbCBidXQgd2lsbCBiZSBjb3VudGVk
IGluIHJ4IGNvdW50ZXINCmluIG5ldGRldiBzdGF0cywgaWYgd2UgdXNlZCBodyBzdGF0cy4NCg0K
c28gdGhpcyBpcyB3aHkgaSBhbHdheXMgcHJlZmVyIFNXIHN0YXRzIGZvciBuZXRkZXYgcmVwb3J0
ZWQgc3RhdHMsIGFsbA0Kd2UgbmVlZCB0byBjb3VudCBpbiBTVyB7cngsdHh9IFgge3BhY2tldHMs
IGJ5dGVzfSArIHJ4IG1jYXN0IHBhY2tldHMuDQoNClRoaXMgZ2l2ZXMgbW9yZSBmbGV4aWJpbGl0
eSBhbmQgY29ycmVjdG5lc3MsIGFueSBnaXZlbiBIVyBjYW4gY3JlYXRlDQptdWx0aXBsZSBuZXRk
ZXZzIG9uIHRoZSBzYW1lIGZ1bmN0aW9uLCB3ZSBuZWVkIHRoZSBuZXRkZXYgc3RhdHMgdG8NCnJl
ZmxlY3QgdHJhZmZpYyB0aGF0IG9ubHkgd2VudCB0aHJvdWdoIHRoYXQgbmV0ZGV2Lg0KDQo+IEkg
dGhvdWdodCBpdCB3b3VsZCBiZSBlbnRpcmVseSByZWFzb25hYmxlIGZvciB0aGUgZHJpdmVyIHRv
IHJlYWQgdGhlDQo+IHN0YXRzIGZyb20gYSBkZWxheWVkIHdvcmsgZXZlcnkgMS8yIEhaIGFuZCBj
YWNoZSB0aGF0LiBXZSBkbyBoYXZlIGENCj4ga25vYiBpbiBldGh0b29sIElSUSBjb2FsZXNjaW5n
IHNldHRpbmdzIGZvciBzdGF0cyB3cml0ZWJhY2sNCj4gZnJlcXVlbmN5Lg0KPiANCg0KU29tZSBj
dXN0b21lcnMgZGlkbid0IGxpa2UgdGhpcyBzaW5jZSBmb3IgZHJpdmVycyB0aGF0IGltcGxlbWVu
dCB0aGlzDQp0aGVpciBDUFUgcG93ZXIgdXRpbGl6YXRpb24gd2lsbCBiZSBzbGlnaHRseSBoaWdo
ZXIgb24gaWRsZS4NCg0KPiBJJ20gbm90IHN1cmUgd2hhdCBsb2NrcyBwcm9jZnMgYWN0dWFsbHkg
aG9sZHMsIGlmIGl0cyBzb21ldGhpbmcgdGhhdA0KPiBjb3VsZCBpbXBhY3QgcmVhZGluZyBvdGhl
ciBmaWxlcyAtIGl0J2QgcHJvYmFibHkgYmUgYSBiYWQgaWRlYSB0bw0KPiBidXN5DQo+IHdhaXQu
DQoNCkFncmVlZC4NCg==
