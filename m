Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15242466A16
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 19:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357459AbhLBS7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 13:59:18 -0500
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:2913
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1357520AbhLBS7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 13:59:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJH/rygYPIirDc16Da+6n+L7Raq1BFQiRIVHRXG1IL+E6xqXvBpZpErwBQRCtZ/8lZtx5CKW7b2oIoa8g3ZvKy9apTcooV4rNY0WvHjtssdyFFyUEGPfTAWAs0SMe7uKmtlASBemVeYAEsI++O8lbHseiAgw5oPiG9IMhat1PDY93Ogy2YWU43bEVwH1+tifcDWOIV3Z67CoTncDoT2Lm7HhN0xI20lt6Gz6AkkBFTnK3jSL0X1vndZW1gVJBe96fkpoqR/rv7rTF8ij6/iie3lyHPWgCs0rC+j5U6fLamqDtWTEk9M/f/zDthpjCrOd/mdDyc3M7hHjvAJgECL4dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVYGeor+UoSXicz5VIe0e2kn0VOrEXY+zKttsp4w3VQ=;
 b=T8mXvNo3ipcaHTTYOOtoX9K22g2HeyHTZwJi/Qli9H4vcfZoRbbF4tCbi0Z6NIyFr2rtW+IBqhTBrhTwcqOpDpfLXlKspSIA0oIsU6IYtpCP/e+O/RHbJ7QGWlcO+ssLI1DNntWN38XibZbVgtWniiBDP8deyqmAfvojtOzOXAQydiDgwbLuEiryFu3v6A0KSDggJQToj3cDdYZsgOTld/ZbW2XwmH7jf8mXqnavkVsehByfi1eQMK6enMfgfhpjfpfD0NlKu04+AweEDBHAvQ9UxoGYgU/FF4HAn6H4UyD6R8Fay7TDKwkjMS1PQ0lA8OFjUa+AYRoLhrp+fblOfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVYGeor+UoSXicz5VIe0e2kn0VOrEXY+zKttsp4w3VQ=;
 b=iyd6JqLaBr/XTna50t16IMoOxt/6x8RHJuNi5Yfs0xejSlWWKVQpBTetrWq9JySCvoR9YSpIIUnBG+cItYqeYUlCrS8te28y35e2kXX3eJN4sm3NFXXFZeV02oQjghL84rxoRGg7fqMK5WIXVXe8UuNnpjwEMU03FrjC9IvhWcBORZ6BKM+GDEjak7ME2shSH3Bw/FSzWsMOwlA4ESO36ZZCeNWgRDPe7QpE121yZOHeE5kdILfbzklKgQbzqUTof88270cIRkiBq/r5odg/bfIZ0lCaCPGyoSmxxMxPsmOw/2zlk+VY3hshYcZDQsq4K4+W2IxJ1hPPiua4eUZWUQ==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2741.namprd12.prod.outlook.com (2603:10b6:a03:62::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19; Thu, 2 Dec
 2021 18:55:38 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%5]) with mapi id 15.20.4734.028; Thu, 2 Dec 2021
 18:55:38 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Shay Drory <shayd@nvidia.com>, "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net/mlx5: Memory optimizations
Thread-Topic: [PATCH net-next 0/4] net/mlx5: Memory optimizations
Thread-Index: AQHX5fwaHVlcFGoAK0uaV7Wa//p2d6wcd+sAgADVN4CAAivGgIAAF4KA
Date:   Thu, 2 Dec 2021 18:55:37 +0000
Message-ID: <36d138a36fb1f86397929d56e6b716e89fc61e2e.camel@nvidia.com>
References: <20211130150705.19863-1-shayd@nvidia.com>
         <20211130113910.25a9e3ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <879d6d7c-f789-69bc-9f2d-bf77d558586a@nvidia.com>
         <20211202093129.2713b64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211202093129.2713b64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e19fe893-9cef-4631-6bd9-08d9b5c55487
x-ms-traffictypediagnostic: BYAPR12MB2741:
x-microsoft-antispam-prvs: <BYAPR12MB2741CEA96976EB8C71206237B3699@BYAPR12MB2741.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 07eVlWE2ndKY66JRJhPfmZYPlW76bmA/lQjK61LewZYHH8YgvOjVvTYnfp9n7tiRTB+bMm7ttgk/BQmIkbwqi1ridEaomUjIQricacnUJf/vg/5N24/d1yY8M49nmBDDEi0k1qA9tp1ja+G4M5zx5X5GwdLVFimzwzWIHpZPtlKC2aRsU0ZlctmGG72clk2ZdjM4PPQfTCPmKRqRSzGYoNsa1QSwJVekvXHazrroKZxpfW9IXAPRJl8yVOEBUHHBHCk2FRuP7gtRaeDBszTjp2jXQVqfvs7FP9IdZxRNaAsh+A1lPLA142iIQRbYU8GHKuARxr5JXAq3F9qLyxt2zZS+jGJ0IRaCmYA6M9IFR0dvrFyOrgWKmB937W+L1S5qe5P6bcmkiI/he7a7g4+DIo+XorfeUaKRnEo7VPvtEV54Eqi2QSz2Rj9EVw38pNvND/Y6t9m2UAsa94rG5WePa5zen7FnlO6rXQRbk5+19uC9f3xXXk/OQlGOJLSh93eUvBhGaGzjNzmMG8vP3B82fg0sTopt1M/N/3vQGDJQSn0JMeDxVDdluIlhgLT2kOnuNLmWtTEg6NnisXDvIgNW0LOM2w3XbpyAl4tOBzvain6RdyjRe0paVL1DEhqqKxSr/eBv2Qv8SxyXL4o0PzolYTUF6Gn2xSx6YJ2b6kYRk70ZvrNdi8lnXsCdNGBOwmF+pcA8a47jxLmSbTGkffSiHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(83380400001)(36756003)(26005)(4326008)(6512007)(2906002)(38100700002)(76116006)(5660300002)(316002)(38070700005)(110136005)(54906003)(64756008)(66946007)(66476007)(66556008)(66446008)(71200400001)(2616005)(8676002)(86362001)(8936002)(6506007)(508600001)(53546011)(6486002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGpVWGJOT3dsNUZLaENWN3JSLytENW1ZeXRldGJPckl3cUJpYU9FSjVMeWcy?=
 =?utf-8?B?dlAxWm1oYXVDYVhvdDRGRkxnQUY3bHIrV21wcjBvaWltMDQra2ZwaUhDaElI?=
 =?utf-8?B?dk4zdG9KbE5GUXlPZTVuZC9nandXTTFsS1ZHSitsZ2VnOVNuRy9CMmx5NFlC?=
 =?utf-8?B?bStYK3F2NExqSTdOeUJrMnFGTk0ycldqLzFicjBucVFkSStPRW41WFQ3WGYw?=
 =?utf-8?B?akRnWXVHZkIvSUJFSG4rUG9sdFVkY0haL1JIbFEzOURtY29SUndWNGU0VFhY?=
 =?utf-8?B?RlRvT1ZyQWczZWxUeml2Ymw5UHE1SlQvUnM1WnlhN281TzhmdUdaUXdNWlU5?=
 =?utf-8?B?dGdvd25LaEs5Rzl3Q1IvelJpZ0RxQm9CNlJlcm9icy9RSmZPb3RqZTRJOUhO?=
 =?utf-8?B?WklZVHZ2blI2Z09aRFhreXQxelkvektqc2FzZE8xN1RuN3hScHV3Z1ZTWHY2?=
 =?utf-8?B?SUtSQmlRaHlGZWxiZEdDanBaTTRrUTFVc3VFWEh3aGhSY0YvclJYaWkzUzhl?=
 =?utf-8?B?V1czUmkvVkh2QVBLQmVCVVJvQ3RibHNPZlp0ZkRxQVl5bjhtekpRcUhISTNY?=
 =?utf-8?B?bXJ1ZGVFWVpWdk5rRHFDa2MrTGpVSTArOEtxTjJhTnd5V241NWJCamQ2Qm1a?=
 =?utf-8?B?UHUzQlZDaS84R3ZEUEk5enJFQlpwcW1jcFU1aGJuYTM5VWd4Wmg1aWNNWmMv?=
 =?utf-8?B?VU9USkZPd0hYblZMV25rZlhwTXVYRDY3Q1ZsZFhkMUJDRlFabi81blEySjZ0?=
 =?utf-8?B?OTd3YnN5ODY0Uk54ei9ZSlF6WFMxQzFVWElUV0RWK1FLN1ZnRWR2U25udGNx?=
 =?utf-8?B?eGpTL1J5SUdLUzFWYlVvOGVLcXJZd3Q0bktJVnVNeEQxVzJHb3d4bjNXS3FN?=
 =?utf-8?B?VFhWZ0ZJc1cvM1NVM1lBUllaWXp5M3RDVGs5VnpZV1ZqUmJlb1o1VE8rWFVk?=
 =?utf-8?B?bElaZG4yRzZMdWRNYTdob0N3V1kwUk8xR0xTNUUxb3I3VFRJdkxOanI4amE3?=
 =?utf-8?B?V212RHpNRzdOTjFMclZsMDNLRjNhRmlDUjFWa3ZaNlhYclhJVWs5RW4wck1J?=
 =?utf-8?B?a1kzbXdkWWtPRDBCekYweG1MZStETEJmWVJMZEx3cnFzKzE1ZWpKQnBJdCt6?=
 =?utf-8?B?ck9FTjhrTU0xR0xaMnhwVmdzTWVIaFF1VG5kamE3OUUrRWVibXpweHRQRGp3?=
 =?utf-8?B?bVVUWDZocFlxd2FvTkkrOGlpdzh6UU1pdStrb3hUcDlHRFdOdkxDQWpqNFI4?=
 =?utf-8?B?dTNFOTdYVWwvR1ArNUVEUXgrRXNXR3NvRU1rNGJSZ3BsWWJtQzQ1UHQ3YUxx?=
 =?utf-8?B?UmJTMTU1Z2VtMTFxWk9STFczU0VXSmwrMDlzaC9qTjA3YTRVU3VRc2s1RHM4?=
 =?utf-8?B?ZEs0S1JlTk9nQis5bXJ2YTl2MDdkVWZSY2RFM0drNm1NN1gwUmlZaWh4QjhM?=
 =?utf-8?B?TVlEREZmVG5vTktOVHJPR1Z5VHorWUoxRyswTVU0MEpKR1JyRXZCaDRUbktZ?=
 =?utf-8?B?dVA3VUNJUFJTVEdiK1BHUVZLOUVUUnJNUW0rN0VHdEw5K2VaNXgvV3YxNHJV?=
 =?utf-8?B?SlJLU1U0Wi9zQ1FLbGxHY204N29rR2RFWlp4aWZZOUpFQkhiZDRjRUVyaEMy?=
 =?utf-8?B?YnE1OC9xNkRDZEE3T1hMcnBIbURPUThuVlRrdzh2QlFrS2RBaDNOR3RCUUdK?=
 =?utf-8?B?b2F1QW9TMXZmN0RVUnh0S0lZMmg0VCtielhJTDRsT05sOUlIQm1wMnVjekxu?=
 =?utf-8?B?OWtjenNWOEQvRWRQd0RRYUE5UzZRMjFiUmpXcFZSTXRJeW5WY014c0YrYSs0?=
 =?utf-8?B?UXZ0WUJ2VjlkSmhPdUV5aEMzYlNSZHVzMDMvQ2N1UjBoVG8yWVFoL2ZGZmRE?=
 =?utf-8?B?VUNTTVJZSUNJb2plNEFRK0FQTE51ZkdJVVMyalFiS01XOVNKYTVzTWFkbXh5?=
 =?utf-8?B?cFh3TmswUHVQdW9WalhzUUpTMDVUL1NZV1BjSVR0c1EwVWtwYkRXWFZPMTJx?=
 =?utf-8?B?aVVDMEcxQkYxQnVIUk9JMkMzdEpzTnJLZDMybU5NbEJqYzBaNEdaQ09tUmti?=
 =?utf-8?B?ajZZczdJcFl1N0dJMXloV1NQWTZ2L2o1QnNUNE10cHFUSWoxRUd5N2I5Ymh0?=
 =?utf-8?B?MWpBZ1lhdG42STBWWmR5d2pEaU1HSk9WazJpTG5ickszYVN6RlVtVEtVanda?=
 =?utf-8?Q?hKmUjSlp3EsnYW2vbJUc4LU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1862ACF8A28C104E94DDC4D973BDAC02@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19fe893-9cef-4631-6bd9-08d9b5c55487
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 18:55:38.0135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RP+k43lECJQz122kRNeIjDJTsrs3LBmuxHCodg8o+6XM3yQLvsNzRMWuYmZYMSzI/wfKxUFIvB8nsdXLo7/pqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2741
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTEyLTAyIGF0IDA5OjMxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxIERlYyAyMDIxIDEwOjIyOjE3ICswMjAwIFNoYXkgRHJvcnkgd3JvdGU6DQo+
ID4gT24gMTEvMzAvMjAyMSAyMTozOSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gPiBPbiBU
dWUsIDMwIE5vdiAyMDIxIDE3OjA3OjAyICswMjAwIFNoYXkgRHJvcnkgd3JvdGU6wqAgDQo+ID4g
PiA+IMKgIC0gUGF0Y2gtMSBQcm92aWRlcyBJL08gRVEgc2l6ZSByZXNvdXJjZSB3aGljaCBlbmFi
bGVzIHRvIHNhdmUNCj4gPiA+ID4gwqDCoMKgIHVwIHRvIDEyOEtCLg0KPiA+ID4gPiDCoCAtIFBh
dGNoLTIgUHJvdmlkZXMgZXZlbnQgRVEgc2l6ZSByZXNvdXJjZSB3aGljaCBlbmFibGVzIHRvDQo+
ID4gPiA+IHNhdmUgdXAgdG8NCj4gPiA+ID4gwqDCoMKgIDUxMktCLsKgIA0KPiA+ID4gV2h5IGlz
IHNvbWV0aGluZyBhbGxvY2F0ZWQgaW4gaG9zdCBtZW1vcnkgYSBkZXZpY2UgcmVzb3VyY2U/IPCf
pJTCoCANCj4gPiANCj4gPiBFUSByZXNpZGVzIGluIHRoZSBob3N0IG1lbW9yeS4gSXQgaXMgUk8g
Zm9yIGhvc3QgZHJpdmVyLCBSVyBieQ0KPiA+IGRldmljZS4NCj4gPiBXaGVuIGludGVycnVwdCBp
cyBnZW5lcmF0ZWQgRVEgZW50cnkgaXMgcGxhY2VkIGJ5IGRldmljZSBhbmQgcmVhZA0KPiA+IGJ5
IGRyaXZlci4NCj4gPiBJdCBpbmRpY2F0ZXMgYWJvdXQgd2hhdCBldmVudCBvY2N1cnJlZCBzdWNo
IGFzIENRRSwgYXN5bmMgYW5kIG1vcmUuDQo+IA0KPiBJIHVuZGVyc3RhbmQgdGhhdC4gTXkgcG9p
bnQgd2FzIHRoZSByZXNvdXJjZSB3aGljaCBpcyBiZWluZyBjb25zdW1lZA0KPiBoZXJlIGlzIF9o
b3N0XyBtZW1vcnkuIElzIHRoZXJlIHByZWNlZGVudCBmb3IgY29uZmlndXJpbmcgaG9zdCBtZW1v
cnkNCj4gY29uc3VtcHRpb24gdmlhIGRldmxpbmsgcmVzb3VyY2U/DQo+IA0KDQppdCdzIGEgZGV2
aWNlIHJlc291cmNlIHNpemUgbm9uZXRoZWxlc3MsIGRldmxpbmsgcmVzb3VyY2UgQVBJIG1ha2Vz
DQp0b3RhbCBzZW5zZS4NCg0KPiBJJ2QgZXZlbiBxdWVzdGlvbiB3aGV0aGVyIHRoaXMgYmVsb25n
cyBpbiBkZXZsaW5rIGluIHRoZSBmaXJzdCBwbGFjZS4NCj4gSXQgaXMgbm90IGdsb2JhbCBkZXZp
Y2UgY29uZmlnIGluIGFueSB3YXkuIElmIGRldmxpbmsgcmVwcmVzZW50cyB0aGUNCj4gZW50aXJl
IGRldmljZSBpdCdzIHJhdGhlciBzdHJhbmdlIHRvIGhhdmUgYSBjYXNlIHdoZXJlIG1haW4gaW5z
dGFuY2UNCj4gbGltaXRzIGEgc2l6ZSBvZiBzb21lIHJlc291cmNlIGJ5IFZGcyBhbmQgb3RoZXIg
ZW5kcG9pbnRzIGNhbiBzdGlsbA0KPiBjaG9vc2Ugd2hhdGV2ZXIgdGhleSB3YW50Lg0KPiANCg0K
VGhpcyByZXNvdXJjZSBpcyBwZXIgZnVuY3Rpb24gaW5zdGFuY2UsIHdlIGhhdmUgZGV2bGluayBp
bnN0YW5jZSBwZXINCmZ1bmN0aW9uLCBlLmcuIGluIHRoZSBWTSwgdGhlcmUgaXMgYSBWRiBkZXZs
aW5rIGluc3RhbmNlIHRoZSBWTSB1c2VyDQpjYW4gdXNlIHRvIGNvbnRyb2wgb3duIFZGIHJlc291
cmNlcy4gaW4gdGhlIFBGL0h5cGVydmlzb3IsIHRoZSBvbmx5DQpkZXZsaW5rIHJlcHJlc2VudGF0
aW9uIG9mIHRoZSBWRiB3aWxsIGJlIGRldmxpbmsgcG9ydCBmdW5jdGlvbiAodXNlZA0KZm9yIG90
aGVyIHB1cnBvc2VzKQ0KDQpmb3IgZXhhbXBsZToNCg0KQSB0ZW5hbnQgY2FuIGZpbmUtdHVuZSBh
IHJlc291cmNlIHNpemUgdGFpbG9yZWQgdG8gdGhlaXIgbmVlZHMgdmlhIHRoZQ0KVkYncyBvd24g
ZGV2bGluayBpbnN0YW5jZS4NCg0KQW4gYWRtaW4gY2FuIG9ubHkgY29udHJvbCBvciByZXN0cmlj
dCBhIG1heCBzaXplIG9mIGEgcmVzb3VyY2UgZm9yIGENCmdpdmVuIHBvcnQgZnVuY3Rpb24gKCB0
aGUgZGV2bGluayBpbnN0YW5jZSB0aGF0IHJlcHJlc2VudHMgdGhlIFZGIGluDQp0aGUgaHlwZXJ2
aXNvcikuIChub3RlOiB0aGlzIHBhdGNoc2V0IGlzIG5vdCBhYm91dCB0aGF0KQ0KDQoNCj4gPiA+
IERpZCB5b3UgYW5hbHl6ZSBpZiBvdGhlcnMgbWF5IG5lZWQgdGhpcz/CoCANCj4gPiANCj4gPiBT
byBmYXIgbm8gZmVlZGJhY2sgYnkgb3RoZXIgdmVuZG9ycy4NCj4gPiBUaGUgcmVzb3VyY2VzIGFy
ZSBpbXBsZW1lbnRlZCBpbiBnZW5lcmljIHdheSwgaWYgb3RoZXIgdmVuZG9ycw0KPiA+IHdvdWxk
DQo+ID4gbGlrZSB0byBpbXBsZW1lbnQgdGhlbS4NCj4gDQo+IFdlbGwsIEkgd2FzIGhvcGluZyB5
b3UnZCBsb29rIGFyb3VuZCwgYnV0IG1heWJlIHRoYXQncyB0b28gbXVjaCB0bw0KPiBhc2sNCj4g
b2YgYSB2ZW5kb3IuDQoNCldlIGxvb2tlZCwgZXEgaXMgYSBjb21tb24gb2JqZWN0IGFtb25nIG1h
bnkgb3RoZXIgZHJpdmVycy4NCmFuZCBERVZMSU5LX1BBUkFNX0dFTkVSSUNfSURfTUFYX01BQ1Mg
aXMgYWxyZWFkeSBhIGRldmxpbmsgZ2VuZXJpYw0KcGFyYW0sIGFuZCBpIGFtIHN1cmUgb3RoZXIg
dmVuZG9ycyBoYXZlIGxpbWl0ZWQgbWFjcyBwZXIgVkYgOikgLi4gDQpzbyB0aGlzIGFwcGxpZXMg
dG8gYWxsIHZlbmRvcnMgZXZlbiBpZiB0aGV5IGRvbid0IGFkdmVydGlzZSBpdC4NCg0KDQoNCg==
