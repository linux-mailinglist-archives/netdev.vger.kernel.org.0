Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FA543568F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 01:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhJTXoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 19:44:13 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:5216
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229702AbhJTXoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 19:44:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNH8JERdCG0bKqsDX8IWPuJImWz3hKGXIYAYjWDlNhJFgTP3/tcDsKYoEM6PcI8Yht3GQmNJ7FbMczkc5cFe4b19SLQsJkY0rpj8yeStHrJzAoCzxjG8Q6hGPuxsUEmHhqFy9Z4+ziPWB9sg6YBKP5oK4P6z2MG4u9Xnlo/1PcdN94Ji7fVuO0JEUcI9UJZgSy+CXIU4XcAtZIf1+0409BE3FUNieK3kHeWzwdJWMwCHqtztCikYhGGJDAPZp5JNIGLfWVVwENDDM4Demzf3QR2YDmz0RRPbKoBswEcv3jxGAOPuWUxy4/9PfCT/hwt8QqEaLSNTsSsgPjIWvy+4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gew6YqiwadhdSp1mUWNXCXG7n9R5c0W/w9Q4iw6dW1g=;
 b=Xcuozsiesz9Ge95OnApHUuw/Rh5QSDitSLUUBtReoTUIYBq4jrGeNvND9e5SqXeoBWynm1m/lsGtGUVTBGFwUPPUyk4d8Udyp8oASZq7no/MqTTez9PJHKqv7D1uMEv6NRlXyeeOEYQyVkGrEAjZuz0XbhHGGMmeMKh+6Z5jDtQ8vs9jtd+qEnlVm5Aych3Ht4rdYZs77LgtvIu1PVbqxX0vJ532jm/I38hXtHRttDd0RLw0sEYZUn4wRomcIp2iocxDZ0DIS61W53acOfpMPEoK2NoOp7XlGUlzQBpbC5FZD6nH8s1xnHBeUnBl1xz0MzNwFV8+QgYN/VdIt4oW/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gew6YqiwadhdSp1mUWNXCXG7n9R5c0W/w9Q4iw6dW1g=;
 b=UoKNdKdia8qA4ZzLHn7h5+TY1LwG6DS112glvfvi/SrEogUYMTaN8u5QwgrcnS3Z5ZMoZSs6rBwApp+BESpi63yXm4l1yOWOgK0h+3V/3AEjwETRYyXoXCQNzzrCLreFvD4kSWpmixAOQ4R7+BiLmRJC0Og8Me3py99rauKO5lIacMOUXvvm/JawIwErQlhSsCVFiyaaPSAp7v0vhfBvlbAnu35pnEmaBOZq2kTEsa4xwA+Q17GRVoXdol1ofoQFuxPyrvDi1kwZ95gSyjIWnnf9SXlBu0Vhy0gGYQsu30LH31Mf4CEuKFFtiyDPevjwqkiPX93XUBO7fVZX5o/JFw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB4712.namprd12.prod.outlook.com (2603:10b6:a03:9d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 23:41:56 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 23:41:55 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] mlx5: don't write directly to netdev->dev_addr
Thread-Topic: [PATCH] mlx5: don't write directly to netdev->dev_addr
Thread-Index: AQHXwG+3Pg2pxab7TUCLiBqah0gv/avcNk6AgAAFxwCAAFsrAA==
Date:   Wed, 20 Oct 2021 23:41:55 +0000
Message-ID: <3fa078541633eae35c456fa15f705fdcb9511a15.camel@nvidia.com>
References: <20211013202001.311183-1-kuba@kernel.org>
         <d11a744067a3481c37d013a1f770af9b761dd57f.camel@nvidia.com>
         <20211020111536.0c896900@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211020111536.0c896900@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20aab0d2-9481-4f3b-aab1-08d994233384
x-ms-traffictypediagnostic: BYAPR12MB4712:
x-microsoft-antispam-prvs: <BYAPR12MB47122BA35D9346739AC65E1CB3BE9@BYAPR12MB4712.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m7/q+qPGE8/tigFAJtXJy88DM/Ni5dbmLzMNKLhfK2UEIATyF9UxvzGUteIMIDpfE8U5K/4p2xv36ovueTaFXY9CDGelSRZVU9W5WcHYHeD/SUSBv/3olbp+20IoPKq2nPVlj5gGIn+onvQ3NbCEcy1XuzxQQ2kEPh9jRPNSeirkfnLRctJ3jatyCeBjKetGIGeGg7gYt+39urfUxwiAA0ivy2y+GQbilwFf782EtiFMYkekqiw+/albG8BqkwJsLjOsuZ2l9MC+W/W9YMFKFsF9bnKA16ObUqMjrGLC9hwqxvZ8btv7L9up+C1qNN0pAZs6cv4qjP1/FNyKayUbrE7RMKrEfDVetvcskJu0CQPpCcUI4b+T+/yF9d00m+d9UoP4+MvRN1W/9hANn9FiUUxCLMmNiSw3Jrm+ouS7H5BPM97Oy4BqSHL1YD51HpjY1AHBcOhvrinX6tzlynOnT9JBSnDX7SjoN4RBbNNRaT1ctx/3dOFXNDmctRpr3RLlVLmegTMAH8Q8DO59GDmj6vKHZBD5lYxOmj6h88VjQEyCRpsrvd6QE2FbZsFKme7cf9iEf/cXKQd27zvanErOtvDZbeGTiDi1ilOXpM0xDXonWumHFjaZiBIbjyQ1fIoiZm45z5fYsU8M2wrie8mm0aUxPeqfQxT2MfHKqfGNw74o0zjHyAmulJfCpr0zcpey1fPHk9hhSYwNZdyGwIZ+4aSKTg4XjEFd5jboQSkzdNUHfL8rHbwRGAH2qEDBu4khNY44hnKTXvWeMoxpughclovoZ9tAsbMUpvf60ORrIDE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(26005)(45080400002)(4001150100001)(66946007)(4326008)(38070700005)(122000001)(4744005)(64756008)(8936002)(71200400001)(6916009)(66556008)(66476007)(186003)(6506007)(86362001)(8676002)(2906002)(966005)(76116006)(6486002)(38100700002)(5660300002)(6512007)(2616005)(66446008)(36756003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk5uYVFWclVKR2s5M3RUWVR3OU9IenJiYmcrS01Zb0duaUJkdWZKRVBiVEI1?=
 =?utf-8?B?QW51a2tidjAvam41RDdOaFhDZC9vY1hVWmNDcWxteGxwTEI3VXpLQlQ3OStE?=
 =?utf-8?B?eDVsTXpNNUhUMm9ZaW9LWklORmIwR3QwL2FCOW9XekpYZDMyM05xVEJVOW95?=
 =?utf-8?B?VGg0bm9BZU0wM05XMHRlRDE5RU42cSswSWNLaTdobTllZ1QzVHM4RUFCS0s2?=
 =?utf-8?B?Sit2bi85TWxrSnZoVzVqWWtoN1VQWTFvSnVCdHo1L2tNYUNFclAzOHJJengr?=
 =?utf-8?B?QkM3ZGMyWFhURitRYjZsZTRkcEk1QnkwbGhpdUhITm5yRnJNWUtvZ2M0NTd4?=
 =?utf-8?B?RWZzZ2lGTjd6UGJ4WkJmM25TVUg5U2xKbFZSQlV2UkgyUmN4L1Y1ZGVENlY2?=
 =?utf-8?B?WFdpM0swY08zbE1ab3VCVTdSMllUelRRY3pFemMwN3lUMjNWQjN2VTNoeTF1?=
 =?utf-8?B?RlpHNVYxQjlmSXMraE5DTzRpMUYvaVoyL1l3anFqMVRIenpZU3R5TUUwWHFi?=
 =?utf-8?B?azJ4WUliL0dzRnUxcklNMFMxSjR2ZFg0anI0M3VuZVdka3orc0hmZkV1WWRB?=
 =?utf-8?B?eEZsOTRxa2wwSXUycEdzRjNsNW9TbTVtREJkVElSZ0k1MXJLd2VyU2dCcXFE?=
 =?utf-8?B?elppVUlrKzJjSEwzYy81bE5reU4zU0xmYThxS2FIVVEvd2tNNmNTOUZMUVZT?=
 =?utf-8?B?a1NEUHB3RTBoblYraWhZUE4yckFaUy9vb3RIRWc2MnFDT0NFRGRLMUwvd01o?=
 =?utf-8?B?RUc2aXN3amF1aWl5Zmw0OVBLWnhNcU1vZG9uSGVmcWJQZmpqR1Z3TlVEcTFh?=
 =?utf-8?B?V09TbVVKNUJYaDVxL29SdHRsUkhBTGVkcjFYR1N5V21VRXZKeHhxZG1Daktt?=
 =?utf-8?B?S2Zob0p1K0NoMFp0cjNmd21rb3FxNHJqY05uajhaZ0xaeHZaTTJ2RWdmSWph?=
 =?utf-8?B?ZkRiQ0lZL1RBcXYwUkhycUh0RWMwMHZuV04vb1ViOFVWelZMcXZwMlZVR3N3?=
 =?utf-8?B?WFZESG5RQjBNT1ltaVBGbjN0U0VtVTFKOXZ5RlYrU1JzL21qb2hVZVNOOHBo?=
 =?utf-8?B?Q0tJS0hnVUhZblE3aHcrRE85UGJJMTMwMWJpZXBjVWRKWXpqZzlBd2RXbGpp?=
 =?utf-8?B?WHd5R3Q5QUlQRFowa1FpMWJ5RW1hbkNMZmJ4Qy9VVmNYQi9vSlFqd0toRVZQ?=
 =?utf-8?B?cVh4bFM5ZTFrdFNKMTgvdWtoNHpqQkcwY2VCeFBXSTZMNzZ4Y0p0NU5BQlNJ?=
 =?utf-8?B?a1hpU3NYZVpkU2FjQ1RmMEE2OE1sRXNnRDJYR2QwSlFKYzVFUmxVckJQWFNO?=
 =?utf-8?B?eCs0c2JUeXVGeVhVMVlrVy9PenRqOTQ1eGQwZVZtMms3Kzc4YWVLQms0c01n?=
 =?utf-8?B?NEFDZkZ5ZzJGalBGeU15cHFJTGlSNWJ1ZDVNWDN6VlFyKzA0MWZaS0xxK1F1?=
 =?utf-8?B?QytFdlAvVlBKejkzeEYwUEVYanpEbFRzeE82RENQV08zMUlLcm4zQ2E1ZUo2?=
 =?utf-8?B?SGQxMnI0cDU2SEFIMnRKTVk0b1VBT3FkMzhnRkpIbkxUNkpyRVlROUlEcDZW?=
 =?utf-8?B?NEo1ZGhnMWF2SWtHck1CaXJHWkZhSWtTMXVjV0I4bGs2Z21KYUY1QWN6RG1Q?=
 =?utf-8?B?a1JVcFhGMlFkTUdFWDR2WSt5cmsvLzhENGYrN0R4a1FXVUJ2TTVUSEM5K1Nv?=
 =?utf-8?B?Z1A2bDNKblg1eXRUM2ROQzZucnV4Yi9JSGViMmJINEpkakZvRVhQTjdqUXRm?=
 =?utf-8?B?a2NHMWplcmltSWJtdVMrR1JacVF2TDdGcHRVQ21HbWtYb3B2SUhWV3NMOGNY?=
 =?utf-8?B?YjhiZVBUNi91dStCT042Zz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CC3F0F010027F4C893D7F07D55E6E2A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20aab0d2-9481-4f3b-aab1-08d994233384
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 23:41:55.7549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEwLTIwIGF0IDExOjE1IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyMCBPY3QgMjAyMSAxNzo1NDo1NiArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBPbiBXZWQsIDIwMjEtMTAtMTMgYXQgMTM6MjAgLTA3MDAsIEpha3ViIEtpY2luc2tp
IHdyb3RlOg0KPiA+ID4gVXNlIGEgbG9jYWwgYnVmZmVyIGFuZCBldGhfaHdfYWRkcl9zZXQoKS4N
Cj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVs
Lm9yZz4NCj4gPiA+IC0tLQ0KPiA+ID4gVGhpcyB0YWtlcyBjYXJlIG9mIEV0aGVybmV0LCBtbHg1
L2NvcmUvaXBvaWIvaXBvaWIuYw0KPiA+ID4gd2lsbCBiZSBjaGFuZ2VkIGFzIHBhcnQgb2YgYWxs
IHRoZSBJQiBjb252ZXJzaW9ucy4NCj4gPiANCj4gPiB0aGUgcGF0Y2ggbG9va3MgZmluZSwgaSB3
aWxsIHRha2UgaXQgZGlyZWN0bHkgdG8gbmV0LW5leHQtbWx4NSwNCj4gDQo+IFRoYW5rcyENCj4g
DQo+ID4gSSBkaWRuJ3QgZ2V0IHRoZSBwYXJ0IGFib3V0IElCIGNvbnZlcnNpb25zLCB3aGVyZSBj
YW4gaSBmaW5kIHRoYXQgPw0KPiANCj4gSGVyZToNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FsbC8yMDIxMTAxOTE4MjYwNC4xNDQxMzg3LTMta3ViYUBrZXJuZWwub3JnLw0KDQpUaGFu
a3MsDQpIYWQgYSBzdHVwaWQgb3V0bG9vayBmaWx0ZXIgdGhhdCBoaWRlcyByZG1hLXN0dWZmIGlu
IHNvbWUgb2xkDQpkaXJlY3RvcnkuLiANCg==
