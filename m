Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A79366A728
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjAMXiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjAMXh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:37:59 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FBA736E3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:37:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4wMpzWM119woorFsk7T+iWUGq2qXOG0+RFmBf9oFk5IYp/coNOFrbnGPRIeVicpJIETe3MUOx2LPDartt+KXNOpaqXeFiCd9NZ5zSNqX5oVQKuTnHqyH8CYnLO7OzoXKCuyfyJulzLbxRb5d1hB5hwiCmlvCMtTKnJfqUvnRbJ7qzFbis2DxmD562nLbYJnS0FTvUZPwyk2EeNfgliu8rYswkbzET2SPeZ8jNy/Jy3+FQ5yljFeZFEEXOQBPZ9L9SbR/poGINE7+Q0Kt41AoZXC48GmjCNTFqueaMmLcVHAfwDOHuiMkStfkDpkIf7bUX0mpkAIXYg3XTX32A2Jlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvOKBt0BeKk5Rm47yJXTzFIp6IMGDaSLQvXDPOgD5Xo=;
 b=aZijAGjS3JzPB/V2ikDRVQfK3o/2nnPjjoyVuxsce4HdX3Go6tx8QeldnR2Ef1zDozNg4B9YULJJkwAX73TbEtYVEkUkYT9gwn7pSAaZ0EL+G9QwtJWuhjaWL1wjtiBHX4wpd5wCB4tlP7ldSuKucY3hD++iSmEj2DERNFT9o13LitQKmFw82tA0s8vx7zOnxLG9lw4O3YvUB+ECn93MLvX8YDyFG394CCzqdLgaZIv6q+Fk4r66eNty3xTK1rST/ip4Gs2dJvUu7WvhmJhFB90/GhydoDUSYCuv5YdYazys3+SK21fLjUrnr7tXi4kTGTsGAEOVLlA5vLmSn6QdrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvOKBt0BeKk5Rm47yJXTzFIp6IMGDaSLQvXDPOgD5Xo=;
 b=XqSAVDmGXUH2S3Rq1T07BcwYK+hNgadkADw+AB5OFJawekzSckOU52IWEp8WL5O5pa/XhPb3dG+UjHJnogI5+COxpF0+UYLUQ2Kww8eaR7fvWB7PiD3qeKxdUvd64CwcKbkO1b//h/OB+RheRTBRP3IFvVwXOT9KjYdEBoSvHGKVhD1y7nB0mHnMI61RDKYhWtj5v7AnZtLBxRdzB/GTcj8fZAmAu4D30BNPtijtgD8iUn9D1oYTzXXQut3bzsmntDBVoS9xqbKSHIkjiYG4wyRAJ6UYtWTuHQwz09g24w3SubVVXi84lQMOQaYpZcd2p5R9ymJHMCK31kc5BX1lmw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB8557.namprd12.prod.outlook.com (2603:10b6:8:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 23:37:56 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0%6]) with mapi id 15.20.5986.019; Fri, 13 Jan 2023
 23:37:56 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH net-next 1/2] virtio_net: Fix short frame length check
Thread-Topic: [PATCH net-next 1/2] virtio_net: Fix short frame length check
Thread-Index: AQHZJ5+K3DKVg5aInUyA+MiyhrF1eK6c/Q6AgAAAlzA=
Date:   Fri, 13 Jan 2023 23:37:56 +0000
Message-ID: <PH0PR12MB5481C03EDED7C2D67395FCA4DCC29@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230113223619.162405-1-parav@nvidia.com>
         <20230113223619.162405-2-parav@nvidia.com>
 <92b98f45dcd65facac78133c6250d9d96ea1a25f.camel@gmail.com>
In-Reply-To: <92b98f45dcd65facac78133c6250d9d96ea1a25f.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|DM4PR12MB8557:EE_
x-ms-office365-filtering-correlation-id: 1fdec5c6-53af-4724-61ad-08daf5bf32c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9iivoxCIpj3JocMSjg02wdwrOypTowJxo4K2dRVkOXa6J5JD2m1EhV2bPwNpKQyIqM60KSloKVGmfjfDiuMN48Zw9zjOzTximTFSl7oR4Mymkdf552FdrwL6NjwWsQJ1SJizOZWaFYJ21TyOl5s+X8Jwuw6OzjifE/1ymhUggKJiSYrFkGD5B3YMxrecN9hItFv6wxULCEHHnEhx4/QL1cD6GTlb/PbRLMn+jbxW1JR9ZI235Aa0UMn92xRu2TfnjsUHXXsOJ2svOYjqNEAP7vJFZCR69xVLf7QanIXwpmSlH7GS3i6GZ4PAMYxavNiHOSAJuPbfZXr/FTJYwX259UrvLqT1J+n4RCG+lY4lJESlb/H1t3vVNLov8CK7VOIblHCah54Mns6/EXmU1hbNFDmM7XRxe4NzQhe3ratwKR88wcE1YXBtRJC1TGhSHaifUKGkKvL1w58GpVK9oedIrQxqR9l62iMNAuQINT2QXbkUTYrbuaG/Mt6hkLeJ4sKBssXeC8UDHacBW93nAkB6Tqm6ZP6BdIWok9VNM07eIdVe6sa48kPO8+gQ1GfLv6HCPCbqR8bQ6lATGQrimZ/kzDab8P8zbpR8uMoYozx9eI8gCuhbEKME9t5cA9AUaPjSuwBN4XhMFMqYrsUC/TxfV7iOfDAk/m4vOWvIc3qYPycPUCCD0l2QzXeOtHxytKkuZ3TRGCukZyPvuHgOPyLLCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(66446008)(66946007)(55016003)(76116006)(66476007)(64756008)(66556008)(4326008)(8676002)(316002)(83380400001)(86362001)(478600001)(41300700001)(9686003)(7696005)(71200400001)(6506007)(186003)(26005)(110136005)(54906003)(33656002)(2906002)(38070700005)(122000001)(5660300002)(52536014)(8936002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2IxK1AxS1M3RDdNSEN0bkZrT3dJYVFwVEZkM3RHc05HWEhQa3ErdjVZY0tt?=
 =?utf-8?B?MjdFN01aM3FmZ0Vwcmx5UjhSdHUxYnlEbjR6dTNNamRnR3N2aEF2a2FqUjJC?=
 =?utf-8?B?NDlaTXdKdnpvR09uVXUzSUF4SkFYVTVKWm9mMk1BOHdDR2ZYdTNJZEFMbWNH?=
 =?utf-8?B?anZSWWhkS3Jzc3U3ckw1dm9ub2E2cE5oN1pwQlQ2dVNEbng4RVE4SDJzeEk0?=
 =?utf-8?B?RmNNd3VWaUE3WWdSdnFuTzc2ZllvVWxTUVJTUzNiOXJZcWNuZXNTWTdLLzNk?=
 =?utf-8?B?Y0dPUTlwbUxjNVBLNXRqOFR3V1RzdEhoQVErUjVyOE1nS2VFQjZVTElrVXhC?=
 =?utf-8?B?bkdlQ01aRWRFbnJmYTRsMVZuaG5ORFlXbHlmOWJiRnUwRGpJZ1R1TG1BVUxG?=
 =?utf-8?B?YWVxaFhTd1NUNFJ5c25mOU9NK1Yxdk11V0I0RGV3enJPdzl4eGVRYUtTRzdL?=
 =?utf-8?B?TWdsUHJRRXJsMC9vSE4xV081WDhNV2grNUtjb1FzUXlPcllnY0N3WGlTQVNr?=
 =?utf-8?B?alZZb2s0OGVPMlpyNzluZnRSQjJtbnpkMjgvbjd5MjV3NGFUUk5IY3lOckN2?=
 =?utf-8?B?dHAzL01lWkg2NU8rZFg2ckhmZmRqelI4NDJRem1EU3Q2UWJOMHhkOUdwSHZ5?=
 =?utf-8?B?UjUwTjlMbERaU0UzV2FkQmFaS2Vja1VKbCtvQ1pQenhFbW1mZktJZmlwVFg0?=
 =?utf-8?B?LzFFY3JORzZ5M0Z6QTVxYXE3OU96RXR3b1ZodGlPeGhkT3J1OGtRL0p5bU5I?=
 =?utf-8?B?aVh6RzZKTG1NZkt5ejRyNE4zVitLL1krRzZ2Q3RLbk1GQzRCMEU4ZU9YTDJy?=
 =?utf-8?B?TWh6TXFONHgxcDRUK0NSNy9sRUpvTnJPOHB4MzZMMktEdHlldjFWQTQ1VVJX?=
 =?utf-8?B?UVd5R2FNK2JFVW1US3FWb1l0NjhZZGpoUWNzelY2QkNCV1U1TmZHai9WeG9T?=
 =?utf-8?B?OEZqbkptN2tOK0VnZDdHbEE5aEw5bS9vZ296ckQ3cjNNZ0FNcnpTdWcvZ0Yr?=
 =?utf-8?B?L2UrODY3QVJGS0YrOGt0YllmaStSUlYwSmRuNGgvcE1UK3V1SDUydENNVEF5?=
 =?utf-8?B?Q2NnRUhKbTA4Lzh6aVUxNFQrVlhOU2QwV3ZPaG1DVFIvVjRWQkZOdkhkTkdo?=
 =?utf-8?B?MFE5RWJRN2RrcytIazd2ak82S1l1eXl4cnU2ejRYb3VJc283SElBOEVnWjBi?=
 =?utf-8?B?eER5Q1M2TXc5a1ovQTBqd0FkYVNFdHhTbFlxRmhJTTlmU3RCUy9HdzJhQ2Fx?=
 =?utf-8?B?TVM1L2tCUFMwU0xEQVlwdXVxNUpwbWVuVllBb3R0dWRQT1Z4d3pNWkVsdk92?=
 =?utf-8?B?SmpsVnkvSGFpNlhlVjczN1Z6Ni8yZ0Z5REoxSWIwOFYyY0VFUmhqZmkxSjVQ?=
 =?utf-8?B?VUdmTjQwV1dockRMYS9oQnNyWjlvVGF5WllmUW9rQy9hNTI2b24yQVNwd09l?=
 =?utf-8?B?dEhyNG45QkRZMWtTZW1WekFCbWIvOUdwWk5LWnk4N2YxZVhCZ2hCSVFlbDVs?=
 =?utf-8?B?MHFIbDVydzFBemVVVUdlOGwyeG9LVGRFTkRabnZvZGRWT283RE4vaWpnYzBR?=
 =?utf-8?B?bFlmblViZ1BsRGRpajZ4S25ScFFRWVc1Y2dsTnlXMUVML2xWQkdOQVRNclZJ?=
 =?utf-8?B?RTBxT0ZPSFhsWDFsQTluZFRsUlhKOGtnRnVxRDcvVVV3Yks4eXVGMkxPTHlH?=
 =?utf-8?B?SnV2Zmx1NFUySWZYTGdBVlBnalNFU3EwenRnSWkwYVo4ZU9xdDJGWG9UakhT?=
 =?utf-8?B?RHBtUDg5dDRnU0hNQkppNEtVb09FcmNubHAvdUxacnZZZkEzcE83UHRZd3Zj?=
 =?utf-8?B?ZDYrOUhKZzRhZ0U4eUxYdHR4VnVMWURpOEFGOXcxQkxFOG5SZDBSNFNhOXRR?=
 =?utf-8?B?eGpiR09vc0VCQjBXbEFEMDZoeDdXQ2NvcWJvc2Y0aGdhV2ZNV3RFT01QQXZC?=
 =?utf-8?B?eFVvejRnWGFzTkdISUFnb2tSNlBBREYxZ1JCUHNRWUpLTTZmb2ZFZTY1d2lG?=
 =?utf-8?B?MG1KMU8wK0JLUjBJbExEWUVsVDJyT0RzdHhadUxLVHZVK3J4dW9HcHppd2hn?=
 =?utf-8?B?S2liK0R0RXIyVW03YnJQYklXOXNTeHdld3VFaWIxK2NOUUNZV3AyR2tKTU9U?=
 =?utf-8?Q?QXrU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fdec5c6-53af-4724-61ad-08daf5bf32c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 23:37:56.5454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lgOU5d6HIrbjsaiL5uS6wQ2wV5RuiKIreC6KTBnLVVsisWW2+/pORNMB9E/oNFQEknt2aLKub1jJeHiMfZsimQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8557
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEFsZXhhbmRlciBIIER1eWNrIDxhbGV4YW5kZXIuZHV5Y2tAZ21haWwuY29tPg0K
PiBTZW50OiBGcmlkYXksIEphbnVhcnkgMTMsIDIwMjMgNjoyNCBQTQ0KPiANCj4gT24gU2F0LCAy
MDIzLTAxLTE0IGF0IDAwOjM2ICswMjAwLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gQSBzbWFs
bGVzdCBFdGhlcm5ldCBmcmFtZSBkZWZpbmVkIGJ5IElFRUUgODAyLjMgaXMgNjAgYnl0ZXMgd2l0
aG91dA0KPiA+IGFueSBwcmVlbWJsZSBhbmQgQ1JDLg0KPiA+DQo+ID4gQ3VycmVudCBjb2RlIG9u
bHkgY2hlY2tzIGZvciBtaW5pbWFsIDE0IGJ5dGVzIG9mIEV0aGVybmV0IGhlYWRlciBsZW5ndGgu
DQo+ID4gQ29ycmVjdCBpdCB0byBjb25zaWRlciB0aGUgbWluaW11bSBFdGhlcm5ldCBmcmFtZSBs
ZW5ndGguDQo+ID4NCj4gPiBGaXhlczogMjk2Zjk2ZmNmYzE2ICgiTmV0IGRyaXZlciB1c2luZyB2
aXJ0aW8iKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNv
bT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvdmlydGlvX25ldC5jIHwgMiArLQ0KPiA+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMgYi9kcml2ZXJzL25ldC92aXJ0aW9f
bmV0LmMgaW5kZXgNCj4gPiA3NzIzYjJhNDlkOGUuLmQ0NWUxNDBiNjg1MiAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC92aXJ0
aW9fbmV0LmMNCj4gPiBAQCAtMTI0OCw3ICsxMjQ4LDcgQEAgc3RhdGljIHZvaWQgcmVjZWl2ZV9i
dWYoc3RydWN0IHZpcnRuZXRfaW5mbyAqdmksDQo+IHN0cnVjdCByZWNlaXZlX3F1ZXVlICpycSwN
Cj4gPiAgCXN0cnVjdCBza19idWZmICpza2I7DQo+ID4gIAlzdHJ1Y3QgdmlydGlvX25ldF9oZHJf
bXJnX3J4YnVmICpoZHI7DQo+ID4NCj4gPiAtCWlmICh1bmxpa2VseShsZW4gPCB2aS0+aGRyX2xl
biArIEVUSF9ITEVOKSkgew0KPiA+ICsJaWYgKHVubGlrZWx5KGxlbiA8IHZpLT5oZHJfbGVuICsg
RVRIX1pMRU4pKSB7DQo+ID4gIAkJcHJfZGVidWcoIiVzOiBzaG9ydCBwYWNrZXQgJWlcbiIsIGRl
di0+bmFtZSwgbGVuKTsNCj4gPiAgCQlkZXYtPnN0YXRzLnJ4X2xlbmd0aF9lcnJvcnMrKzsNCj4g
PiAgCQlpZiAodmktPm1lcmdlYWJsZV9yeF9idWZzKSB7DQo+IA0KPiBJJ20gbm90IHN1cmUgSSBh
Z3JlZSB3aXRoIHRoaXMgY2hhbmdlIGFzIHBhY2tldHMgYXJlIG9ubHkgNjBCIGlmIHRoZXkgaGF2
ZSBnb25lDQo+IGFjcm9zcyB0aGUgd2lyZSBhcyB0aGV5IGFyZSB1c3VhbGx5IHBhZGRlZCBvdXQg
b24gdGhlIHRyYW5zbWl0IHNpZGUuIFRoZXJlIG1heQ0KPiBiZSBjYXNlcyB3aGVyZSBzb2Z0d2Fy
ZSByb3V0ZWQgcGFja2V0cyBtYXkgbm90IGJlIDYwQi4NCj4gDQpEbyB5b3UgbWVhbiBMaW51eCBr
ZXJuZWwgc29mdHdhcmU/IEFueSBsaW5rIHRvIGl0IHdvdWxkIGJlIGhlbHBmdWwuDQoNCj4gQXMg
c3VjaCByYXRoZXIgdGhhbiBjaGFuZ2luZyBvdXQgRVRIX0hMRU4gZm9yIEVUSF9aTEVOIEkgd29u
ZGVyIGlmIHdlDQo+IHNob3VsZCBsb29rIGF0IG1heWJlIG1ha2luZyB0aGlzIGEgIjw9IiBjb21w
YXJpc29uIGluc3RlYWQgc2luY2UgdGhhdCBpcyB0aGUNCj4gb25seSBjYXNlIEkgY2FuIHRoaW5r
IG9mIHdoZXJlIHRoZSBwYWNrZXQgd291bGQgZW5kIHVwIGJlaW5nIGVudGlyZWx5IGVtcHR5DQo+
IGFmdGVyIGV0aF90eXBlX3RyYW5zIGlzIGNhbGxlZCBhbmQgd2Ugd291bGQgYmUgcGFzc2luZyBh
biBza2Igd2l0aCBsZW5ndGggMC4NCg0KSSBsaWtlbHkgZGlkbuKAmXQgdW5kZXJzdGFuZCB5b3Vy
IGNvbW1lbnQuDQpUaGlzIGRyaXZlciBjaGVjayBpcyBiZWZvcmUgY3JlYXRpbmcgdGhlIHNrYiBm
b3IgdGhlIHJlY2VpdmVkIHBhY2tldC4NClNvLCBwdXJwb3NlIGlzIHRvIG5vdCBldmVuIHByb2Nl
c3MgdGhlIHBhY2tldCBoZWFkZXIgb3IgcHJlcGFyZSB0aGUgc2tiIGlmIGl0IG5vdCBhbiBFdGhl
cm5ldCBmcmFtZS4NCg0KSXQgaXMgaW50ZXJlc3RpbmcgdG8ga25vdyB3aGVuIHdlIGdldCA8IDYw
QiBmcmFtZS4NCg==
