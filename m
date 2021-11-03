Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D254443DE8
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 08:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKCIA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 04:00:27 -0400
Received: from mail-dm3nam07on2106.outbound.protection.outlook.com ([40.107.95.106]:51169
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231575AbhKCIAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 04:00:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/p/UJrWWZvOjeUKLHzoiY7aU3yFxf5MWdo4iEN7F754lCIPEQEfCz7P4n5DRYfm0Jap60liHOTJj0apifImYkV4O6RsREOlPNVPfDg11L5w9myiIwwfND9/NLpxg2CRlXnzgk4dhITjg9azUi7ajB1XeZ4khc2QTJa1N+5e7OuFJgRR8h3hqZzJlxcYh63HRt0fjEA3sU62LKI6BdllMMLOAYVDdP1HEdjnLSDRB6C54f0fgCXBkgoyf49uHRa13p6ZFzD5DsxzkzzVJVUDCeE27tlteWpFCUR8zcbGE9rT/kN0Cdm8QxvzEal58PCuaj5sbtkZYhbv/dABb/rOzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPBtyAxj1320Oz0dfPCs9xVm2wQrB7JFYUioLfEsyjE=;
 b=JqmpUK/rJee5LMbMlqz7uosiDOjLqI7xZ+1iEQ3qRFImdIxzhAdBeK56TSVe8UTKh9KNUuKKfwLysGxdScNMj5GPGvxPE7UtpyS1N9Xh5qYLY2lEM3vyxSgWesano5YJl8jkbtfwrqkyKfhcpnWx0+KQgqTR8JMcFlpCY9xFIuUvFld5xMdcemdEfT2vTITvJUv5vlpdDsQtnJlKB7wdd8gizSQ4UD6zozwzmcp4XyLzMF+c3piUNnDyiz+AHdZEDSTR9ss/KOHvxIB6RDb1V9E0KZDFwtBPXM5iY993aOJoKI1NvL6Ta+i1a2g/rY+Yj3suZBTiIt4uk+TYO8rTaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPBtyAxj1320Oz0dfPCs9xVm2wQrB7JFYUioLfEsyjE=;
 b=YTmsPPwyeQyd4QOVp+gunESpxwC1C4JYdBzL+Vh4rrJhbWRbaE3slFqbbUvEj9BX6Q4aibvJBq4mvZHwYxvGXSu8/p93DyRkgQ3jUVOajFQkQcC0tZH4ipe75QLboaKKIE007PMZZDcUqKVU7SZ8xut5WthvDNVgmdNA8s9n6+k=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB4329.namprd13.prod.outlook.com (2603:10b6:5:16f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.7; Wed, 3 Nov
 2021 07:57:46 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.010; Wed, 3 Nov 2021
 07:57:46 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Topic: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAEbH4CAAECyAIAAv3npgAC92QCAAOYhwIAAScwAgAHmiwCAAUGbwA==
Date:   Wed, 3 Nov 2021 07:57:46 +0000
Message-ID: <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
In-Reply-To: <20211102123957.GA7266@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41130759-e510-48a9-cdf7-08d99e9f9f7e
x-ms-traffictypediagnostic: DM6PR13MB4329:
x-microsoft-antispam-prvs: <DM6PR13MB4329F39576A42E0F16129293E78C9@DM6PR13MB4329.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oRHI/31/L+X1E/R3LWyP8G/CR7b4Z40g/JNvtFRxEncagjLXJH4bHt3+prrw4FNgP+uI7J4tgVhu8Eb6JXhXqACweh1a1YEkQ7kzDOff5wEOaYDkMLyVBcLHnWNgqxDPRHVVsHhPW3kS/7AQObBhEOzemuEHBBJ0IgJ3k9kHyHmJ3nJYnI2teY/zXcIXkHbx+A5CGAnCqWAnZH0T0/8hcKkgksZ74NnYcoAV54BVzyDNc7bazk7tWf7s/yC8fztvwZLoxXE/q8t8MReS8C0WpvkHUQXCmLp4eu/lyHjdkHspYaSkjYDc/Ey9vdZOuFyA3DpVcDYxc8Hkkd60kM0lznZ+GqaN1D8QOaiTRuugMTTSIAv27ThlCB1OTx52/dF7YTSGz2uxcApeZTKKK7oAPQSRsg6djG0SUMxwNAVQrxxTFrB9e9XnG420maIVvTS8OvewJKRvsS5lyiYhpH6l16RPz6SLlbT/r/BHleOCS7yXgo/BwUJpUvt+sgFXl+D4oMnev3rc7aYWwmwYZfBbWjhAEgICdM6UTteRjyXPiUIHB5KcxBGJ4zWJNKjrXMhXt+HjqdvXOCOKUe+GjsI/te0mN5qDZ/do0g+XPcJc28y6DCVzwdRo1JB28qkQTzLvBhuc97Elb7msI/DMSs6WyJVhSu3NFHeRCi721y1+5QrfepJzrBbeQkfeMKJ9iTIzILiaV3P8V1AeZIzY+s7A0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(8676002)(15650500001)(66446008)(55016002)(38100700002)(44832011)(508600001)(64756008)(122000001)(7696005)(83380400001)(33656002)(8936002)(107886003)(71200400001)(54906003)(316002)(4326008)(9686003)(66556008)(38070700005)(110136005)(186003)(6506007)(4001150100001)(26005)(86362001)(53546011)(76116006)(66476007)(2906002)(66946007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHhzNUlGa3k3M2pqc1hSTHl5SVg3M2tJQzgxWXBEaDFjdWFmNnRqRmEzVXhY?=
 =?utf-8?B?c3VlODZaYTl4WVFRak42Mmp3SUVVNmU5UU9WKzBZMFJCSXljeThnVTlpRUdr?=
 =?utf-8?B?RVh5UVhmalZISU9iWWdxV25kY3dSTis5Tlg4N0EvYzlpdndUWk5PbW9jR3Ev?=
 =?utf-8?B?Z3dGcnZhTHo4SkgvWjJtTjdSbVZVNjhVdTIwV2cyNE5FbVRaQWpwVEJ2bGs5?=
 =?utf-8?B?ekdHY3YrRVQ5Zmg2cHBxVU1pbHEwNEV1MWtEQTM2SFpudDlZR3hxVjRMUzhC?=
 =?utf-8?B?NXI5Zld0WG94VURMQ25VSEE2MVV1bFZCcWM1QnpBT2dxSGJmRkEwZnFiVUpa?=
 =?utf-8?B?MUtUak5mRHVEMlZZYUVydkJCV2RwTy9UQkdOZXBtTW1ObUpJK2NDQWZZY2s3?=
 =?utf-8?B?UjlFNGZ5eDZMenZMc1NzaUJPZytvMGV4OGxQbEhqZDZHSUhicXJMM1cwQVNW?=
 =?utf-8?B?WkRBVmpKNmRXLzM0R0Ura1ErdE5NbDNhZjF2NW9jdjlua3g5T2tsbUhGdjJh?=
 =?utf-8?B?VjJTREFiT21ZT1F0MXNmYjUrbEcwZnc3STRIYytwVVBDbnR5K3hqM2trdzZ2?=
 =?utf-8?B?clgzRXVJdncvY2p5OXFrY2tMbnZvZU9lTkNqV0pvZDA2Q1BlVWZ4S2ZlOEJB?=
 =?utf-8?B?R3kxS1NCQThwZ0FHNHNFYVBFZ0gzc2E5K0xMSkNXalZqZjNESGd1L29sdURz?=
 =?utf-8?B?OHVTd1oraU9tVndXQnc5UGwwNmEyWFo0TlZNcFhkUHN1MWRnWU5hUXV6QUdx?=
 =?utf-8?B?ZGpRN0pFUjQ0a0taR05GQnhOLzFEOTgyYk5tY1lDQkxHdDI0S0NtNTJmVE4r?=
 =?utf-8?B?aTV0eVpxMVhZaVpjdDNuVXVNMGlBT0JHb0laUXVpVHlnWlEvLzVKRU94UDFU?=
 =?utf-8?B?eFNlcUxHMisxM2ovNzY4WW9YQWl4QUVlK0N2OSsrRk1XZHUrSFZoY2pxVVBt?=
 =?utf-8?B?Ym9xSU9JL3VvcmJEbG82c1dSSExDVzh3Nm9RN1Q3c0xOLzlLUlJrUWlTUHRv?=
 =?utf-8?B?MDdhdStxaFRrRFNnMGJFMnBCdkdzVHVhTDJFcE94U0dqVXlTUjduMGtQMjQx?=
 =?utf-8?B?MHhPNmMreDYvYkZyQXdOWklGNUdjR1krWEFuTTg5UlN3OEtqRGNDbWJIRnFV?=
 =?utf-8?B?S1ZsdU91WTJpeU52U1dEQ1NEVmIrOXpheTZ2aHNjZzUrYkZVR0JteXdSbkFS?=
 =?utf-8?B?emRWRS84cC9iR1BrOVp4NGlDQzhXdU1jNTUzVHJLbGd1dkFHcE9TU0RwTUJy?=
 =?utf-8?B?Mkl2aGxvb3AxSXk2ZXgwTGdxKzBsbzZ2b094UE10Rjh4WGtObys1L09BOHFH?=
 =?utf-8?B?ZEd0UTFkRnhlMTVscndsRXFLSCtNY29zZ29laURRcjdOSUVhOGxaVnhJU0JY?=
 =?utf-8?B?YWlDWXdRNmZsRWhURGp0bGhwZGJ1bGc1c3pnY2NhR0N1RlNqRXZQaGFabkE4?=
 =?utf-8?B?dlZaNjh3N3BKU2pjQjNBR3dpNWdFSXVweWxkeTBiNTM2Y1BjL09Md3ArQllD?=
 =?utf-8?B?RDJOc0NpaEhsWndyckJNWjFzbHNjWGxpcktZQXRpOGJqMUhWR1VWbW5oblh0?=
 =?utf-8?B?S3JkTmdUQmJ4enNUYzM5NDNvYW5YYUVjM2x5Mm5UOWdSSUltYVRwWi9oTnRQ?=
 =?utf-8?B?a2xrNXNJbGVZS0dqekxHNHBuOUlsTWFUb0hHcTBUaWN5alI0eGJiWWJzZ1pz?=
 =?utf-8?B?aTVxNzVxZVF0Qng3WWIzaXBKWmZUVlVLZDZNclI2SnV5OEYyMmdtSW05dDVO?=
 =?utf-8?B?eWx2R2xlc2N3a3BBdkFPbjlDOEFCd1VjdmhwTTI5cHRxTS9leEx1ZW5Ddlhw?=
 =?utf-8?B?Rloxd25aTytWSUJMSGVueDhHeG9JVjdUYWZUNUZ4VkR1aWtFTUF6blp0Zjdn?=
 =?utf-8?B?SGxNaHQybjdlYWozV0Q2aG5KTWxnZGxhZnN5c1pQNGw1UVhEeW9IMHY4bW5x?=
 =?utf-8?B?UTYzeU9nSEZrS0kzbWJpTGhOY0FDNnZ5d3A4S3pvSXBkLzliSFBZd3htR0x5?=
 =?utf-8?B?NmpnaE1tbmVGc0FYc20wRmswVzdQbU5rZkx2b2djaXljd0s2SzZucW9LOGlO?=
 =?utf-8?B?bG0wNmc0NGUwSE4rc2xldVdEUE94cDJlWE9XbWh3SUw0YU1MRDIveFI2VVFk?=
 =?utf-8?B?MFN3WDZEc0NJYTcvdktQYzVmZEFRR2lGdHpjbU5vWTJGR0I1Vk1BQlphN3FU?=
 =?utf-8?B?OUNNYUpReWN4RGFPQ0Z4bTc5eWRhWEVnWGZucTZ6MGVmNXhiNXpJQW9nWGow?=
 =?utf-8?B?T3NPcmIwSGRwZzdjemVIc0FucXpRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41130759-e510-48a9-cdf7-08d99e9f9f7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 07:57:46.0373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDw92AdOZI8krfAQ8IS4e7z+CWy21uzEH8QgHDl2yE/TU8P8ikQ9St32/QlePrneWRWGjZKvYntjOX31EQhmLlwWZG5d9bd3AdVfNzvjOSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4329
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMiwgMjAyMSA4OjQwIFBNLCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+T24gTW9u
LCBOb3YgMDEsIDIwMjEgYXQgMDk6Mzg6MzRBTSArMDIwMCwgVmxhZCBCdXNsb3Ygd3JvdGU6DQo+
PiBPbiBNb24gMDEgTm92IDIwMjEgYXQgMDU6MjksIEJhb3dlbiBaaGVuZw0KPjxiYW93ZW4uemhl
bmdAY29yaWdpbmUuY29tPiB3cm90ZToNCj4+ID4gT24gMjAyMS0xMC0zMSA5OjMxIFBNLCBKYW1h
bCBIYWRpIFNhbGltIHdyb3RlOg0KPj4gPj5PbiAyMDIxLTEwLTMwIDIyOjI3LCBCYW93ZW4gWmhl
bmcgd3JvdGU6DQo+PiA+Pj4gVGhhbmtzIGZvciB5b3VyIHJldmlldywgYWZ0ZXIgc29tZSBjb25z
aWRlcmFyaW9uLCBJIHRoaW5rIEkNCj4+ID4+PiB1bmRlcnN0YW5kIHdoYXQNCj4NCj4uLg0KPg0K
Pj4gPj5MZXQgbWUgdXNlIGFuIGV4YW1wbGUgdG8gaWxsdXN0cmF0ZSBteSBjb25jZXJuOg0KPj4g
Pj4NCj4+ID4+I2FkZCBhIHBvbGljZXIgb2ZmbG9hZCBpdA0KPj4gPj50YyBhY3Rpb25zIGFkZCBh
Y3Rpb24gcG9saWNlIHNraXBfc3cgcmF0ZSAuLi4gaW5kZXggMjAgI25vdyBhZGQNCj4+ID4+Zmls
dGVyMSB3aGljaCBpcyBvZmZsb2FkZWQgdGMgZmlsdGVyIGFkZCBkZXYgJERFVjEgcHJvdG8gaXAg
cGFyZW50IGZmZmY6DQo+Zmxvd2VyIFwNCj4+ID4+ICAgICBza2lwX3N3IGlwX3Byb3RvIHRjcCBh
Y3Rpb24gcG9saWNlIGluZGV4IDIwICNhZGQgZmlsdGVyMg0KPj4gPj5saWtld2lzZSBvZmZsb2Fk
ZWQgdGMgZmlsdGVyIGFkZCBkZXYgJERFVjEgcHJvdG8gaXAgcGFyZW50IGZmZmY6IGZsb3dlciBc
DQo+PiA+PiAgICAgc2tpcF9zdyBpcF9wcm90byB1ZHAgYWN0aW9uIHBvbGljZSBpbmRleCAyMA0K
Pj4gPj4NCj4+ID4+QWxsIGdvb2Qgc28gZmFyLi4uDQo+PiA+PiNOb3cgYWRkIGEgZmlsdGVyMyB3
aGljaCBpcyBzL3cgb25seSB0YyBmaWx0ZXIgYWRkIGRldiAkREVWMSBwcm90bw0KPj4gPj5pcCBw
YXJlbnQgZmZmZjogZmxvd2VyIFwNCj4+ID4+ICAgICBza2lwX2h3IGlwX3Byb3RvIGljbXAgYWN0
aW9uIHBvbGljZSBpbmRleCAyMA0KPj4gPj4NCj4+ID4+ZmlsdGVyMyBzaG91bGQgbm90IGJlIGFs
bG93ZWQuDQo+PiA+Pg0KPj4gPj5JZiB3ZSBoYWQgYWRkZWQgdGhlIHBvbGljZXIgd2l0aG91dCBz
a2lwX3N3IGFuZCB3aXRob3V0IHNraXBfaHcgdGhlbg0KPj4gPj5pIHRoaW5rDQo+PiA+PmZpbHRl
cjMgc2hvdWxkIGhhdmUgYmVlbiBsZWdhbCAod2UganVzdCBuZWVkIHRvIGFjY291bnQgZm9yIHN0
YXRzDQo+PiA+PmluX2h3IHZzIGluX3N3KS4NCj4+ID4+DQo+PiA+Pk5vdCBzdXJlIGlmIHRoYXQg
bWFrZXMgc2Vuc2UgKGFuZCBhZGRyZXNzZXMgVmxhZCdzIGVhcmxpZXIgY29tbWVudCkuDQo+PiA+
Pg0KPj4gPiBJIHRoaW5rIHRoZSBjYXNlcyB5b3UgbWVudGlvbmVkIG1ha2Ugc2Vuc2UgdG8gdXMu
IEJ1dCB3aGF0IFZsYWQNCj4+ID4gY29uY2VybnMgaXMgdGhlIHVzZSBjYXNlIGFzOg0KPj4gPiAj
YWRkIGEgcG9saWNlciBvZmZsb2FkIGl0DQo+PiA+IHRjIGFjdGlvbnMgYWRkIGFjdGlvbiBwb2xp
Y2Ugc2tpcF9zdyByYXRlIC4uLiBpbmRleCAyMCAjbm93IGFkZA0KPj4gPiBmaWx0ZXI0IHdoaWNo
IGNhbid0IGJlICBvZmZsb2FkZWQgdGMgZmlsdGVyIGFkZCBkZXYgJERFVjEgcHJvdG8gaXANCj4+
ID4gcGFyZW50IGZmZmY6IGZsb3dlciBcIGlwX3Byb3RvIHRjcCBhY3Rpb24gcG9saWNlIGluZGV4
IDIwIGl0IGlzDQo+PiA+IHBvc3NpYmxlIHRoZSBmaWx0ZXI0IGNhbid0IGJlIG9mZmxvYWRlZCwg
dGhlbiBmaWx0ZXI0IHdpbGwgcnVuIGluDQo+PiA+IHNvZnR3YXJlLCBzaG91bGQgdGhpcyBiZSBs
ZWdhbD8NCj4+ID4gT3JpZ2luYWxseSBJIHRoaW5rIHRoaXMgaXMgbGVnYWwsIGJ1dCBhcyBjb21t
ZW50cyBvZiBWbGFkLCB0aGlzDQo+PiA+IHNob3VsZCBub3QgYmUgbGVnYWwsIHNpbmNlIHRoZSBh
Y3Rpb24gd2lsbCBub3QgYmUgZXhlY3V0ZWQgaW4NCj4+ID4gc29mdHdhcmUuIEkgdGhpbmsgd2hh
dCBWbGFkIGNvbmNlcm5zIGlzIGRvIHdlIHJlYWxseSBuZWVkIHNraXBfc3cgZmxhZyBmb3INCj5h
biBhY3Rpb24/IElmIGEgcGFja2V0IG1hdGNoZXMgdGhlIGZpbHRlciBpbiBzb2Z0d2FyZSwgdGhl
IGFjdGlvbiBzaG91bGQgbm90IGJlDQo+c2tpcF9zdy4NCj4+ID4gSWYgd2UgY2hvb3NlIHRvIG9t
aXQgdGhlIHNraXBfc3cgZmxhZyBhbmQganVzdCBrZWVwIHNraXBfaHcsIGl0IHdpbGwgc2ltcGxp
ZnkNCj5vdXIgd29yay4NCj4+ID4gT2YgY291cnNlLCB3ZSBjYW4gYWxzbyBrZWVwIHNraXBfc3cg
YnkgYWRkaW5nIG1vcmUgY2hlY2sgdG8gYXZvaWQgdGhlDQo+YWJvdmUgY2FzZS4NCj4+ID4NCj4+
ID4gVmxhZCwgSSBhbSBub3Qgc3VyZSBpZiBJIHVuZGVyc3RhbmQgeW91ciBpZGVhIGNvcnJlY3Rs
eS4NCj4+DQo+PiBNeSBzdWdnZXN0aW9uIHdhcyB0byBmb3JnbyB0aGUgc2tpcF9zdyBmbGFnIGZv
ciBzaGFyZWQgYWN0aW9uIG9mZmxvYWQNCj4+IGFuZCwgY29uc2VjdXRpdmVseSwgcmVtb3ZlIHRo
ZSB2YWxpZGF0aW9uIGNvZGUsIG5vdCB0byBhZGQgZXZlbiBtb3JlDQo+PiBjaGVja3MuIEkgc3Rp
bGwgZG9uJ3Qgc2VlIGEgcHJhY3RpY2FsIGNhc2Ugd2hlcmUgc2tpcF9zdyBzaGFyZWQgYWN0aW9u
DQo+PiBpcyB1c2VmdWwuIEJ1dCBJIGRvbid0IGhhdmUgYW55IHN0cm9uZyBmZWVsaW5ncyBhYm91
dCB0aGlzIGZsYWcsIHNvIGlmDQo+PiBKYW1hbCB0aGlua3MgaXQgaXMgbmVjZXNzYXJ5LCB0aGVu
IGZpbmUgYnkgbWUuDQo+DQo+RldJSVcsIG15IGZlZWxpbmdzIGFyZSB0aGUgc2FtZSBhcyBWbGFk
J3MuDQo+DQo+SSB0aGluayB0aGVzZSBmbGFncyBhZGQgY29tcGxleGl0eSB0aGF0IHdvdWxkIGJl
IG5pY2UgdG8gYXZvaWQuDQo+QnV0IGlmIEphbWFsIHRoaW5rcyBpdHMgbmVjZXNzYXJ5LCB0aGVu
IGluY2x1ZGluZyB0aGUgZmxhZ3MgaW1wbGVtZW50YXRpb24gaXMNCj5maW5lIGJ5IG1lLg0KVGhh
bmtzIFNpbW9uLiBKYW1hbCwgZG8geW91IHRoaW5rIGl0IGlzIG5lY2Vzc2FyeSB0byBrZWVwIHRo
ZSBza2lwX3N3IGZsYWcgZm9yIHVzZXIgdG8gc3BlY2lmeQ0KdGhlIGFjdGlvbiBzaG91bGQgbm90
IHJ1biBpbiBzb2Z0d2FyZT8NCg==
