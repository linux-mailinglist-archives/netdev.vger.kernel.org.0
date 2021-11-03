Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC36944428A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhKCNkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:40:32 -0400
Received: from mail-mw2nam12on2108.outbound.protection.outlook.com ([40.107.244.108]:12512
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230282AbhKCNkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 09:40:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LO8GJuA9u4j/ZajNFgtnTThIzIxaWojjoqvDD+3tDZZ3+dz3Ks5eirmRI7c9sEW6dpMmRfXqFL6BShwoYy0biUpDh2idGpvROr1vo6oEsuR0DDb896vZuSv0CEvsFPSSvRy+BKRzMy4U+3lz47ZPvoIiW+BfKjuINg1Sk8eK7xZmtitGItWRPHO9KM7/Q9ZESeBJSZyw90mVI7bgpxI+Mo/vo2/5iwVmTylmT/LlV6iIEpGXJzsixmm/9ihIalg4FzfsCKl/+WuR9qtLXT3JXooI50wtyzLWJhaVjdSRy7Q8ZjWy9LNEk7kWKQXUAxD2w1UT2cD52VTLYc7CATnIDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KF5P/SE+/rzk3w4BUtGXXPx0LyzJul5z+/BQWYJ/INc=;
 b=JycdwFw6hRdh7W9pAgDHWKIzIqyxya0Oy33Bm8ekOabdo9iOuhu2NXZFtPozAeUq+YBmw7pybIxq3Akc9p2QLk0lK2w89UMwRVrltZObV7Q/UNmK+fq23//yGBrolAa1a5gUEareAIjq7S36LRUYWIuTkQshtsi4SRkp2L8Rq+3mLx08ouBptgOpyUMl3Qgwt64hLX522f2p89Kya2O8t+m0v4NLKWAvVtQeRLkDrcN8IOTYCOJfc1n/aEr/jOQqXKxfim70GOEZCU7/mLKymmQ4ixc1fikG6S9D9ChVaRvV8eqVS2RZiPtgMhjUcSM8ZZhGAoMxcGi7f7ytsdmlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KF5P/SE+/rzk3w4BUtGXXPx0LyzJul5z+/BQWYJ/INc=;
 b=oKEoKfMmiTn7zaQvCgQjI5xsjQuND83mIlStv8vJi4+SY/MukU+ikQh03VI+FqOXlbc2tF3LCymLoGKAOd7GvnNExAtqzf48fKdZDQwAkNHSod+vBpoXk3ra+kgI/evMooRdvvK4Q/3R7SNryCo91bWrXb5vA9sjRk6E49OIyu8=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB4539.namprd13.prod.outlook.com (2603:10b6:5:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.9; Wed, 3 Nov
 2021 13:37:53 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.010; Wed, 3 Nov 2021
 13:37:53 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: RE: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Topic: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAEbH4CAAECyAIAAv3npgAC92QCAAOYhwIAAScwAgAHmiwCAAUGbwIAAJ94AgAASrMCAABR9gIAAEAJQ
Date:   Wed, 3 Nov 2021 13:37:53 +0000
Message-ID: <DM5PR1301MB21721ACDDACAC28BE86F796BE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
 <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
In-Reply-To: <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 396a7fe8-fbf7-455d-aa2f-08d99ecf2343
x-ms-traffictypediagnostic: DM6PR13MB4539:
x-microsoft-antispam-prvs: <DM6PR13MB4539F7CD45211DA657242A76E78C9@DM6PR13MB4539.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:431;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AAVfRFuGEkYsgAwx7zv6NIwfsQqZ9lcQNd4O45tcanJukLcmr0evodsTtRgnq4ulKYtWfr/VqeA4K6FnZwOxY5TCsFedgTTstOHT3AFv+HgcwmMcw1eBhnW6EWUnGSNOURCFP52/VYcGddsI42R6ZPAjOT9yM2laazZU9thEai7L57WFDKNNKPccuVf0mlgObhNsAGQRYFANbSLvqmFZVkmvHA6q+aEY/gCgenyBFkWj6ybSy915tfQfNotQVdt4ayBFmqzYauMiBAvAJtWPU8G8JvX9PNmhajateglg+PpwVFBMoouUPr0C/gFZwpTysSaWu6vf7/HTb84Og/VGxLDBtcKGGr1eLlbkHU0XOZtUcdrnWCalYUo6R0sSar++jBXhaKOLfn+TGdlyiJ5MpAVhTF8XpzKELQ2MddFaUFs7uPowARnq2l+WFDzCjw/QZZf7he5LoABOOJ3GWmYU53qMalpPcDUlIRi4EPtcV19+VkxsF19pEGnk5MnXWL6Ib3gpAfMEzxwGSy4qFuykHXekO7wDX/Wa1B7npkTsNv8s9InFyOsCHyCWuiVVOXpQgLOv4slWh2zZKu633/X8eAQuxHfGzXBqMPZUR/lZZ33k5UKVn357udaonH21UqsMn25kFSpspzfJK1J70ngYGM354YTXArBNKR12oKW4AX5X09ciLhHIfMh3KXswSlpvIYqxeD+txOoipOqH9PTaMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39840400004)(186003)(86362001)(38100700002)(508600001)(44832011)(4326008)(66446008)(26005)(122000001)(71200400001)(2906002)(64756008)(7696005)(52536014)(66556008)(66476007)(53546011)(110136005)(76116006)(316002)(66946007)(8936002)(6506007)(5660300002)(38070700005)(9686003)(55016002)(33656002)(8676002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1BONGN0N3JNUkFERGR0ZFUyVzgzdTVlU3F1MGNLM2xidXM3QmNYZmNERytM?=
 =?utf-8?B?YWN3bVo2SXZtOEJBQXFibnZnNXVQdGdTclhXRDRuZ0E2ZXZIdXZ6aVJpZmtP?=
 =?utf-8?B?NTlrSk1LeFlqRldybExkS2E2Smh5WDhaVVdzU0IreFREQ2J0OUk5UnF2dm9R?=
 =?utf-8?B?QXFOOS9sc2xDUldNeXVkSWNQQS8rZHM5eS9FNWVRYlhJdWhmR0Zsek1KYVVy?=
 =?utf-8?B?YmxUWHN4cWRPMjE4dWFtSkNMQjdLck1kaHg4MlU5S1liSWhXMHBSUjVVRzdz?=
 =?utf-8?B?T2pYTmlMcDkwQnFheFhUTldPRm9VQ3E5dXZ3SWtuL2NQV2I3emVaMys3czN6?=
 =?utf-8?B?cDRyVHI4SG9YWndid3RnYWNZdElYNFBYb3dGcjJNMFF3TmY1djQwSmlUTlR1?=
 =?utf-8?B?QkNHblpWQlFLTXE2cUNlWEd5VDBLVUtYNVpqMTM5NjRNUWVjamNRNTY3anYw?=
 =?utf-8?B?QTVEQ3JKN2gybjRhNmlHVDRVTVpJeUMrMnpMa28zR2RKU29sVUlXUkR6Qmkv?=
 =?utf-8?B?SzVaMTJQWWlxVHdnOElPK0MzV0Q2MmJQZGZ1ZXlraWFSY0U4QTJDbVlpa3dW?=
 =?utf-8?B?Y0lGWHV3Z1RUcTJud2RsTEliOTdtWGZvdDZEVjNaSmRkRmd6MUR5elpCdFEx?=
 =?utf-8?B?MGRlY2hITHl0WGpKWGlxZy9EQ1hnY3Iwd20wczB0QlJMdU92Qjl6cnBlbVhj?=
 =?utf-8?B?VlIrUnJjOElKZUJ1RXFPZnJMVlRZZWYwTXZaVjlWaU1aUzBmYzd5TTFJL3NF?=
 =?utf-8?B?b0xubDhIS0htR2NhN2d5QUFVQWMycFlmVW1TdmdmK3JQKzd4bisvMEV3L3cv?=
 =?utf-8?B?cWZNMnVtcUdscUJsRTNyZUdkTHBDVnNVZ09hTWtSbDRwb0N3clhyT0hnOG5u?=
 =?utf-8?B?NmpZYXFkQ2NSVHdDVEhVemJwRWt5bUEwd2RFZG9BL21id0U3aXE5UmRydnlu?=
 =?utf-8?B?WkxoN0l4VlFUaTdRbGtSR0lKcGJwSjJJakRDTXVuRUtlWmppcW1DZmR6d2xO?=
 =?utf-8?B?SiszMXBmRVdheXp6ZFZRbVF1RXZ0dTdsUk1UOExVSG42UDRPZTZsS0dzQmtJ?=
 =?utf-8?B?ZWNaRG9lOGFjVjB5R3l3SVVtRkp5YlhYWUJOdXp3WmtoaEVQTk4xV0ZjQVg2?=
 =?utf-8?B?VVJUQW9yM2YvbDVWdzBWYlMyRWgyelV0eStLdVRsOWxuVk40U29xdVdtSHZF?=
 =?utf-8?B?MjRQZTA4TmRWL1U3Yk9mSXRBM2UybzhQN0UzanVJNmFOR0tFRWg2NnNIY0VC?=
 =?utf-8?B?YmQ4YlFpcGc2bHhlNG5VelhlRExNNjkydFA1WThWRnM4TjVUUmprNkFZeFlU?=
 =?utf-8?B?bEdqWFRFcloyRkVoOFhDWmtwbHpOb2NXTjhqR3ZlQ2V3YVU2M3BCUGlhR0tw?=
 =?utf-8?B?c1E5ZHFRUDBqZGpNRkR6M0F4S1N6ak5CNzZpL3liT1JzbzNLOERESjNPaWtP?=
 =?utf-8?B?QUVQcEUxUDUzNm16VFFxVmNia3Y1aElNT3E4eVNOVWk1ZjQ4ZHZGbXdKMkJw?=
 =?utf-8?B?THJvWVA4TytNZ1hNdEd6czVJWXNIeThEZklJbmVOekoxTnRVTW43MjBhR011?=
 =?utf-8?B?dGw4YXZaYTA0STVhTnhVeGx2eHdZTWlpS0s1Sm90QmliRmc2U0R0VXlubklK?=
 =?utf-8?B?dzhHbU9TVXoxV3JldlpjditZUDVUNmFoRTY5YkZZYlRZWWxuR000eE0xZzBz?=
 =?utf-8?B?YmFKL0ZJTnVZb01qR3JwdFNJbFBocy9oS0xnSlFqZFZqWXM4VnBMb3NVU0kx?=
 =?utf-8?B?bjVVVlFLZTF4ZnVNUlRSa3JkTVBPNmJYUVBSUGR5Vyt1ZmZzVG0ydmNXTlFY?=
 =?utf-8?B?Z3M3SVJnNWNqQ0YyRUZjQWxtRjBjVnRhYzBTQ1hqYkF5amhzSm5HTG14Qkg0?=
 =?utf-8?B?ZGRJWVdkMVN0MVR0Y241QlR2bC9VTk9sOU1wOVJsVERtRDM5QTYwOUlaK1BH?=
 =?utf-8?B?QVdUR2dCQWVCVDRQbXlnZmFmMjlQRHV0MjA3b29pRU5ENnpYQVVJeUNldVZP?=
 =?utf-8?B?NExPZjN3UExlUFR0VFZQdTd5ZHRKOVBBd3VzNDViUUU3L2J4ZEQ3OTNETVU0?=
 =?utf-8?B?bjVkWFNBS042UGwxRFhEbklnZ241NEhXc2hjSmUzRzJJdHpRZXJTbHgyUENl?=
 =?utf-8?B?bVJaTmhmZnZ2QS9iQnViaHc0UzZndG4vQ2JnaXF3RDRybHYveVMvQW9BanZD?=
 =?utf-8?B?Q2Fva3doa0lya3RzNk5aUHBvdWFDK3ZxcUtpQ3VuQ2w1aStONGR2eVp2Ti9K?=
 =?utf-8?B?SmNubnZzaW5VVG81ZG9obWFJRWRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 396a7fe8-fbf7-455d-aa2f-08d99ecf2343
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 13:37:53.5182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ITeOh3KWXOUBbvrQPO9WIkn7niXYrbe2/IYWBkeGkZ64IQ4P55SWNmbYyAU33t8gKakjcKitK2faqDHgGGI6CFB6xyCoCDLGbOi2bWwA4GM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMywgMjAyMSA4OjM0IFBNLCBKYW1hbCBIYWRpIFNhbGltIHdyb3RlOg0KPk9u
IDIwMjEtMTEtMDMgMDc6MzAsIEJhb3dlbiBaaGVuZyB3cm90ZToNCj4+IE9uIE5vdmVtYmVyIDMs
IDIwMjEgNjoxNCBQTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj4+PiBPbiAyMDIxLTExLTAz
IDAzOjU3LCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+Pj4+IE9uIE5vdmVtYmVyIDIsIDIwMjEgODo0
MCBQTSwgU2ltb24gSG9ybWFuIHdyb3RlOg0KPj4+Pj4gT24gTW9uLCBOb3YgMDEsIDIwMjEgYXQg
MDk6Mzg6MzRBTSArMDIwMCwgVmxhZCBCdXNsb3Ygd3JvdGU6DQo+Pj4+Pj4gT24gTW9uIDAxIE5v
diAyMDIxIGF0IDA1OjI5LCBCYW93ZW4gWmhlbmcNCj4+Pg0KPj4+IFsuLl0NCj4+Pj4+Pg0KPj4+
Pj4+IE15IHN1Z2dlc3Rpb24gd2FzIHRvIGZvcmdvIHRoZSBza2lwX3N3IGZsYWcgZm9yIHNoYXJl
ZCBhY3Rpb24NCj4+Pj4+PiBvZmZsb2FkIGFuZCwgY29uc2VjdXRpdmVseSwgcmVtb3ZlIHRoZSB2
YWxpZGF0aW9uIGNvZGUsIG5vdCB0byBhZGQNCj4+Pj4+PiBldmVuIG1vcmUgY2hlY2tzLiBJIHN0
aWxsIGRvbid0IHNlZSBhIHByYWN0aWNhbCBjYXNlIHdoZXJlIHNraXBfc3cNCj4+Pj4+PiBzaGFy
ZWQgYWN0aW9uIGlzIHVzZWZ1bC4gQnV0IEkgZG9uJ3QgaGF2ZSBhbnkgc3Ryb25nIGZlZWxpbmdz
DQo+Pj4+Pj4gYWJvdXQgdGhpcyBmbGFnLCBzbyBpZiBKYW1hbCB0aGlua3MgaXQgaXMgbmVjZXNz
YXJ5LCB0aGVuIGZpbmUgYnkgbWUuDQo+Pj4+Pg0KPj4+Pj4gRldJSVcsIG15IGZlZWxpbmdzIGFy
ZSB0aGUgc2FtZSBhcyBWbGFkJ3MuDQo+Pj4+Pg0KPj4+Pj4gSSB0aGluayB0aGVzZSBmbGFncyBh
ZGQgY29tcGxleGl0eSB0aGF0IHdvdWxkIGJlIG5pY2UgdG8gYXZvaWQuDQo+Pj4+PiBCdXQgaWYg
SmFtYWwgdGhpbmtzIGl0cyBuZWNlc3NhcnksIHRoZW4gaW5jbHVkaW5nIHRoZSBmbGFncw0KPj4+
Pj4gaW1wbGVtZW50YXRpb24gaXMgZmluZSBieSBtZS4NCj4+Pj4gVGhhbmtzIFNpbW9uLiBKYW1h
bCwgZG8geW91IHRoaW5rIGl0IGlzIG5lY2Vzc2FyeSB0byBrZWVwIHRoZQ0KPj4+PiBza2lwX3N3
IGZsYWcgZm9yIHVzZXIgdG8gc3BlY2lmeSB0aGUgYWN0aW9uIHNob3VsZCBub3QgcnVuIGluIHNv
ZnR3YXJlPw0KPj4+Pg0KPj4+DQo+Pj4gSnVzdCBjYXRjaGluZyB1cCB3aXRoIGRpc2N1c3Npb24u
Li4NCj4+PiBJTU8sIHdlIG5lZWQgdGhlIGZsYWcuIE96IGluZGljYXRlZCB3aXRoIHJlcXVpcmVt
ZW50IHRvIGJlIGFibGUgdG8NCj4+PiBpZGVudGlmeSB0aGUgYWN0aW9uIHdpdGggYW4gaW5kZXgu
IFNvIGlmIGEgc3BlY2lmaWMgYWN0aW9uIGlzIGFkZGVkDQo+Pj4gZm9yIHNraXBfc3cgKGFzIHN0
YW5kYWxvbmUgb3IgYWxvbmdzaWRlIGEgZmlsdGVyKSB0aGVuIGl0IGNhbnQgYmUNCj4+PiB1c2Vk
IGZvciBza2lwX2h3LiBUbyBpbGx1c3RyYXRlIHVzaW5nIGV4dGVuZGVkIGV4YW1wbGU6DQo+Pj4N
Cj4+PiAjZmlsdGVyIDEsIHNraXBfc3cNCj4+PiB0YyBmaWx0ZXIgYWRkIGRldiAkREVWMSBwcm90
byBpcCBwYXJlbnQgZmZmZjogZmxvd2VyIFwNCj4+PiAgICAgIHNraXBfc3cgaXBfcHJvdG8gdGNw
IGFjdGlvbiBwb2xpY2UgYmxhaCBpbmRleCAxMA0KPj4+DQo+Pj4gI2ZpbHRlciAyLCBza2lwX2h3
DQo+Pj4gdGMgZmlsdGVyIGFkZCBkZXYgJERFVjEgcHJvdG8gaXAgcGFyZW50IGZmZmY6IGZsb3dl
ciBcDQo+Pj4gICAgICBza2lwX2h3IGlwX3Byb3RvIHVkcCBhY3Rpb24gcG9saWNlIGluZGV4IDEw
DQo+Pj4NCj4+PiBGaWx0ZXIyIHNob3VsZCBiZSBpbGxlZ2FsLg0KPj4+IEFuZCB3aGVuIGkgZHVt
cCB0aGUgYWN0aW9ucyBhcyBzbzoNCj4+PiB0YyBhY3Rpb25zIGxzIGFjdGlvbiBwb2xpY2UNCj4+
Pg0KPj4+IEZvciBkZWJ1Z2FiaWxpdHksIEkgc2hvdWxkIHNlZSBpbmRleCAxMCBjbGVhcmx5IG1h
cmtlZCB3aXRoIHRoZSBmbGFnDQo+Pj4gYXMgc2tpcF9zdw0KPj4+DQo+Pj4gVGhlIG90aGVyIGV4
YW1wbGUgaSBnYXZlIGVhcmxpZXIgd2hpY2ggc2hvd2VkIHRoZSBzaGFyaW5nIG9mIGFjdGlvbnM6
DQo+Pj4NCj4+PiAjYWRkIGEgcG9saWNlciBhY3Rpb24gYW5kIG9mZmxvYWQgaXQNCj4+PiB0YyBh
Y3Rpb25zIGFkZCBhY3Rpb24gcG9saWNlIHNraXBfc3cgcmF0ZSAuLi4gaW5kZXggMjAgI25vdyBh
ZGQNCj4+PiBmaWx0ZXIxIHdoaWNoIGlzIG9mZmxvYWRlZCB1c2luZyBvZmZsb2FkZWQgcG9saWNl
ciB0YyBmaWx0ZXIgYWRkIGRldiAkREVWMQ0KPnByb3RvIGlwIHBhcmVudCBmZmZmOg0KPj4+IGZs
b3dlciBcDQo+Pj4gICAgICBza2lwX3N3IGlwX3Byb3RvIHRjcCBhY3Rpb24gcG9saWNlIGluZGV4
IDIwICNhZGQgZmlsdGVyMg0KPj4+IGxpa2V3aXNlIG9mZmxvYWRlZCB0YyBmaWx0ZXIgYWRkIGRl
diAkREVWMSBwcm90byBpcCBwYXJlbnQgZmZmZjogZmxvd2VyIFwNCj4+PiAgICAgIHNraXBfc3cg
aXBfcHJvdG8gdWRwIGFjdGlvbiBwb2xpY2UgaW5kZXggMjANCj4+Pg0KPj4+IEFsbCBnb29kIGFu
ZCBmaWx0ZXIgMSBhbmQgMiBhcmUgc2hhcmluZyBwb2xpY2VyIGluc3RhbmNlIHdpdGggaW5kZXgg
MjAuDQo+Pj4NCj4+PiAjTm93IGFkZCBhIGZpbHRlcjMgd2hpY2ggaXMgcy93IG9ubHkNCj4+PiB0
YyBmaWx0ZXIgYWRkIGRldiAkREVWMSBwcm90byBpcCBwYXJlbnQgZmZmZjogZmxvd2VyIFwNCj4+
PiAgICAgIHNraXBfaHcgaXBfcHJvdG8gaWNtcCBhY3Rpb24gcG9saWNlIGluZGV4IDIwDQo+Pj4N
Cj4+PiBmaWx0ZXIzIHNob3VsZCBub3QgYmUgYWxsb3dlZC4NCj4+IEkgdGhpbmsgdGhlIHVzZSBj
YXNlcyB5b3UgbWVudGlvbmVkIGFib3ZlIGFyZSBjbGVhciBmb3IgdXMuIEZvciB0aGUgY2FzZToN
Cj4+DQo+PiAjYWRkIGEgcG9saWNlciBhY3Rpb24gYW5kIG9mZmxvYWQgaXQNCj4+IHRjIGFjdGlv
bnMgYWRkIGFjdGlvbiBwb2xpY2Ugc2tpcF9zdyByYXRlIC4uLiBpbmRleCAyMCAjTm93IGFkZCBh
DQo+PiBmaWx0ZXI0IHdoaWNoIGhhcyBubyBmbGFnIHRjIGZpbHRlciBhZGQgZGV2ICRERVYxIHBy
b3RvIGlwIHBhcmVudA0KPj4gZmZmZjogZmxvd2VyIFwNCj4+ICAgICAgIGlwX3Byb3RvIGljbXAg
YWN0aW9uIHBvbGljZSBpbmRleCAyMA0KPj4NCj4+IElzIGZpbHRlcjQgbGVnYWw/DQo+DQo+WWVz
IGl0IGlzIF9iYXNlZCBvbiBjdXJyZW50IHNlbWFudGljc18uDQo+VGhlIHJlYXNvbiBpcyB3aGVu
IGFkZGluZyBhIGZpbHRlciBhbmQgc3BlY2lmeWluZyBuZWl0aGVyIHNraXBfc3cgbm9yIHNraXBf
aHcNCj5pdCBkZWZhdWx0cyB0byBhbGxvd2luZyBib3RoLg0KPmkuZSBpcyB0aGUgc2FtZSBhcyBz
a2lwX3N3fHNraXBfaHcuIFlvdSB3aWxsIG5lZWQgdG8gaGF2ZSBjb3VudGVycyBmb3IgYm90aA0K
PnMvdyBhbmQgaC93ICh3aGljaCBpIHRoaW5rIGlzIHRha2VuIGNhcmUgb2YgdG9kYXkpLg0KVGhh
bmtzLCBidXQgd2hhdCB3ZSBjb25jZXJuIGlzIG5vdCB0aGUgY291bnRlcnMgYnV0IHRoZSBiZWhh
dmlvciBvZiB0aGlzIGZpbHRlci4gDQpTaW5jZSB0aGUgZmlsdGVyIHJ1bnMgaW4gc29mdHdhcmUg
YW5kIGFjdGlvbiBpcyBza2lwX3N3LCBzbyB0aGUgYWN0aW9uIHdpbGwgbm90IGV4ZWN1dGUgaW4g
c29mdHdhcmUuIA0KU28gd2hlbiB0aGUgcGFja2V0IG1hdGNoZXMgdGhlIGZpbHRlciwgaXQgd2ls
bCBleGVjdXRlIGFsbCB0aGUgYWN0aW9ucyBleGNlcHQgdGhlIHNraXBfc3cgYWN0aW9uLiANCkkg
dGhpbmsgaXQgaXMgbm90IHdoYXQgd2UgZXhwZWN0LCB3ZSBleHBlY3QgdGhlIHBhY2tldCBleGVj
dXRlIGFsbCB0aGUgYWN0aW9ucyB0aGUgZmlsdGVyIHJlZmVycyB0by4gDQpTbyBJIHRoaW5rIGlu
IHRoaXMgY2FzZSwgZmlsdGVyNCBzaG91bGQgbm90IGJlIGFsbG93ZWQuDQpXRFlUPw0KPj5iYXNp
Y2FsbHksIGl0IHNob3VsZCBiZSBsZWdhbCwgYnV0IHNpbmNlIGZpbHRlcjQgbWF5IGJlIG9mZmxv
YWRlZA0KPj5mYWlsZWQgc28gIGl0IHdpbGwgcnVuIGluIHNvZnR3YXJlLCB5b3Uga25vdyB0aGUg
YWN0aW9uIHBvbGljZSBzaG91bGQNCj4+bm90IHJ1biBpbiBzb2Z0d2FyZSB3aXRoIHNraXBfc3cs
ICBzbyBJIHRoaW5rIGZpbHRlcjQgc2hvdWxkIGJlIGlsbGVnYWwgYW5kIHdlDQo+c2hvdWxkIG5v
dCBhbGxvdyB0aGlzIGNhc2UuDQo+PiBUaGF0IGlzIGlmIHRoZSBhY3Rpb24gaXMgc2tpcF9zdywg
dGhlbiB0aGUgZmlsdGVyIHJlZmVycyB0byB0aGlzIGFjdGlvbiBzaG91bGQgYWxzbw0KPnNraXBf
c3cuDQo+PiBXRFlUPw0KPg0KPlNlZSBhYm92ZS4uDQo+DQo+Y2hlZXJzLA0KPmphbWFsDQoNCg==
