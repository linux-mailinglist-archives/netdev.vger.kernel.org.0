Return-Path: <netdev+bounces-6476-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA474716746
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7574B1C20B1B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF10524E95;
	Tue, 30 May 2023 15:39:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61C017AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:39:54 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6E2C5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:39:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkNU8fqane9xjB32LSZKE0WN0LLFrc3H727yMmObcGmBhGA1TP8CotomzXSRts6Jm1T3OlYLn5YYEqqJLhOUAsLDXB8jQ3NKbLQ2FOocyr8SB6QGBhoVnaSn12FYEGG3WyrKACSgNywsshr+4E92TXlsutciX+sx7ZzisRZIQ63dQ3csWB+Dtoj+e1NwWtcwDr9hwOI8glmeUcbAsZCdlKf9WsI/CKPcnpgsrHgoJCrKI3hTwumLnbvrSByf5miW8smbR3T30qF7/ILtAi8ikJzJ7gtdpELoZ3q8S9ug9BS/ccn4GMqaqAhg3Up0e1a7m7l/+DcXnF2GiwcqbmtajQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QabdK9AvF92de9+mfnDuHtahEajuNhgESa8aO21ZpZk=;
 b=FSUAwQiRFpFYePL7/cfV8180a1L+BFfl/9nZogAoClqfughogeqGCRO36z7z49eOiOuC1u9LXJ4p+Uw+SFUGg84cpR/fgdOJHJgFINYnGOh4c6JU/ouLN6udBjarzRqwr04EmHTQHLCOTUNJTeX71Vyo4NLN8aAx91436QbO54G4YYpHL5Hsd3TS+x03aDpdf3RoIeJN6ziVCH+z7t00OgVrjYAbCEAoF8b4tvdS3HuXVJpm9GjO1RlESkpzLhwBGEZy2rQmYd/3swGVWnLCjhK2HeY9LU39HYo7EKX2ROhd1F1h7+yzvBCmcZnJj2vx2tGJtZ8Enu2ypF2LiX2b/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QabdK9AvF92de9+mfnDuHtahEajuNhgESa8aO21ZpZk=;
 b=oNN0NSXjwXndkCgkO7mcckcsQzhufpyL8xBKS9fRNoxljbhV2KRT7YAkfJZIbxanjxhohNamavC+yK1zmjmb2WJodGSs44B5an76LjC3p269n7BoDPJm6GTrtSVL3X2q631H8VCf9cbI8/ez80bqUJu3+unkb2bqsXmBKCnOk6tk4V+iC3MR8JigHvt4c/Br5NPYF0FCty5WL0dwZLnhGzRbDei74QJIZzqWz5JRTqFgM5IjIoub1T8fbEZ3XEPJzpe2nMZEcWMaDogjftYMU1F67uw+K3/L2TC4fV+rrsqYFApAM/Nj+zXuDMbC9b4A4WgnbW1gy7AxWYY6M3gvtA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by IA0PR12MB8693.namprd12.prod.outlook.com (2603:10b6:208:48e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 15:39:51 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::824c:2f44:2922:fd76]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::824c:2f44:2922:fd76%5]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 15:39:51 +0000
From: Parav Pandit <parav@nvidia.com>
To: David Ahern <dsahern@kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net: Make gro complete function to return void
Thread-Topic: [PATCH net-next] net: Make gro complete function to return void
Thread-Index: AQHZkjPELq30Jr2uT0qjGHkTzwnBm69y8YgAgAACp5A=
Date: Tue, 30 May 2023 15:39:50 +0000
Message-ID:
 <PH0PR12MB5481B447D6D667ECB97886CEDC4B9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230529134430.492879-1-parav@nvidia.com>
 <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
In-Reply-To: <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|IA0PR12MB8693:EE_
x-ms-office365-filtering-correlation-id: 8bc5f9cb-9f65-4462-4c07-08db61241b51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 bZ4Pr7L0RDiDcKePA+erwbM06zwc6KO3dFaBn34CEbjsq8FxLIZt63sMmXKOKHiHlccc9Ipb3vOb76kRIjXBx7/n7EFE6oJ+jRYzNvEMoW+RdxxhfyK36B4C8g58y1IFNifoh37o1Z75xyyCrWlBsgYW/OqjV5gWzKfVB8dFCDQ+6fDA05NUqOnhjWqpm9aAwFaHysyHNY3VnGyON0RhsQ0Pk0KmJnrk2lKDrWeW/QhPbOqsCEe5rDVyKC0KqPPG47VoKd2oAjqYP48HKub1xlwjYKZHw23Z3ogZcGEIk0XXdGGi6F431kOE6sQlDnfMl8jihQd+FW+Nlzb9kbZ03s+JgdXFGOko4z2zMzMKCPYSPH3AF8ZM/bGQOmH8V0ZEe5PT+/Ty98SaHZ107nxUC/9/7XD54nE4S0OIJ8Q9tEfA7BvhviAXwopASC8qMaI324hl4+zhu3vuYT87dNs60DUfUOummrY6tgvCrjKwtt4xw9SdJUnEE/3RVBs/tbK6muHco6rsWtMg5/iM/IXVUFpaLgr15TBUKu0rKyqunwGINTZFmBL1ah3f3Yxwb25YToavLsu6xiVL/kzzACNgKjiJhkMGAbqKMfXgDVzzp4BGTdELy1mv3B29UokJcgc0
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199021)(7696005)(186003)(52536014)(33656002)(5660300002)(41300700001)(71200400001)(55016003)(38100700002)(9686003)(8936002)(8676002)(53546011)(26005)(6506007)(122000001)(38070700005)(110136005)(86362001)(2906002)(66946007)(64756008)(66446008)(66476007)(66556008)(76116006)(478600001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MWYxOHJsejQwMk9ZaWs0YUg2MXJuK0wwTEVEOGRGVU1KUXoxZlpsUkNTUXc2?=
 =?utf-8?B?QTBaZ3NFbUU2cG5tUlU0TDcxbVdVN1FIcVBleUd6U3ZoZjB5SzJvQ2RWUlBx?=
 =?utf-8?B?OEFsL3hXVGNHQWFOU3E0TFZySTB5cHhodEpuZmFHV1VxK09qRG9mUmM4YW9N?=
 =?utf-8?B?UHNCYmtnUWhuNE5hODFZaGVpWlE3VlVjb2pFQ3M3NGVBRlB6RkJYdE9PU3hk?=
 =?utf-8?B?TFFrOFdhdmJnZDlETUt5MzJXYllMSGpYQktCOXpkSVpyV2p6TTZKaEZuT21D?=
 =?utf-8?B?aHVQOUgybXVJczdHcEkrS3dTbWMxbVZHU1ZIK2UzYWhGZ3pUZzlLemU1L1R2?=
 =?utf-8?B?UDVWV2Q5ZGNGYzdjUmtnRlU2WHVGVGFuaUFOZlNoeG1BTXVFOVBTckJVMmt0?=
 =?utf-8?B?cGFBUEhFVHRVa1lhdUR4bENVUWYzS3ZjcEdwaXo2VkFjNllEbnlTN0VLb2JP?=
 =?utf-8?B?dFpESHBIWDJCL0NWcjQwSnlmbnI3dVFra0h4bEhoTE9tREtLOXgyWEEvbVNk?=
 =?utf-8?B?ZnR1bTJFVlY4WmFaUXJvRnZFVzF6cWl0d0QrcUdWc2JxUVE1bXM4MlJ4bVk5?=
 =?utf-8?B?bkl5WkhZc3p5Y3JsMWhITUJXYURIZGRDdjRpc1NaZnJONTFsSTZWQlBzdkQy?=
 =?utf-8?B?TXIwMXU5WE93V3lVK3ErdHRDQ1p4ejFIR0JPMmYwRU4ySVF3cVN5R2IwN1pC?=
 =?utf-8?B?cjI3NGpiOHA4MnJWUWl2NkhuSmsycFB1Q1Q2cGVHQU9ZSjRhUnpMelVqUlRE?=
 =?utf-8?B?Mkg1ZG0xelJ2NmNNaFNCbHR1ZDlqSWlYK2FWVkNGMFIxOGJPSTRCL2h3UFpK?=
 =?utf-8?B?bDg2WVQ4M3F2V3IxWDd1OWZkOGM3K3daK00zanhrMTZSdmE3TTNDa3J3d0lm?=
 =?utf-8?B?RXlJeWJtK3ZNWm54Snk3ZFA3S29vMEFWcTZrMEtTSnZiQXgrZEg4NUJtRU1w?=
 =?utf-8?B?Yk43QnNWWDVjR1p4NElRV0g3QmpmWmZUdHJiSzIrSVBSbHBQajg2ay93V1Rn?=
 =?utf-8?B?UXZJdjF1R3czRktUL3Y1b1laVFpQd1pEcUNqUUZwL3VPSEExTVpxQk5EQ0hj?=
 =?utf-8?B?RmpFVHVmT1ZQOU9ubzhCbUxwR3VQZ0ZzNVd2bndyVTIydFJ0MnJONWVRbzZ0?=
 =?utf-8?B?VGt2eWc3dHdrR1JwRWFmTFljV3RadnFTOENjWUZUSXk4WUx6ZlNoZVVhVU1h?=
 =?utf-8?B?NkYyODZOM0ZzRFVmTUhzcmV2enVZVVBYSWZpOHVMWGlnSSt2eTVkVnNEVnBo?=
 =?utf-8?B?NFU4b2FkTUdTaGFDODBlc0dHOWVtRWdRRDBIN2RqUjVRaVdpclFKakcreVJo?=
 =?utf-8?B?VG1sVUJGMjNQYTJuaU5uR0IwYmMxTFJOd1dud2UxNStRdjV1bHZpekx5L3hV?=
 =?utf-8?B?ako1L2QvblhuekJyV0l2UXc3M0w0Sk5nMDIxU3QvV01yZ2xCMUozc0ttN2Nu?=
 =?utf-8?B?Rnh3UElQeGZ0MlhubklodFZUb3JWQXBjQzUzR29sZExOcEcvNFp0QlZFZWdZ?=
 =?utf-8?B?TDU0SG1SMldpUVZRWk1jVzBoZG5yUldGUEVZNlBraVkwZG1ydWg5c0syMjNV?=
 =?utf-8?B?REhFUWNwRkc2R003Q3ZWTHBzTjRTdUNoYUFPTG9paER5RzFTQ1hzZHVBUHpV?=
 =?utf-8?B?K2JTTnJyNnBibE5hTHdrTWtZQ1ZEV3R0Vkl4MHFTRW1tUm91ZngrV1hIYTNF?=
 =?utf-8?B?RGpRWW9FdUdFR3RGOXJYK1ZqTzJTczlKOGhPdGduNDFONWZJaUFBcUdqMG1Z?=
 =?utf-8?B?YmN4bGJFS08yODJlbGpFeHNnWkRZOHFGUHFSL2R0TDN6SmczTng1R2REZ3hI?=
 =?utf-8?B?ci9wS3dSSnpmeFZ0ZmNqREpFV0FaS0dpMURFSTlhQUdVcnBrSU9GaiswWVdY?=
 =?utf-8?B?bGgzRUhINjgvTTNXYUtDUU1JeHhpbVpVUmZjeWR5a0NPVUxRaWRvM3QwV3BB?=
 =?utf-8?B?VzhQTjNybUpvNm9SRVlYV2UyT05PWC8zRGZTMXJOeE5TRFM1N3pvVUFCL2JF?=
 =?utf-8?B?YTBEQmxDQjlZdTUxSjJPWDVudDE1d1FqeHFSN005M1ZJeTFzOXFKQ2ZsTWFI?=
 =?utf-8?B?R2R2eXBsL1NiNnVYZHo3SzNKNzUyUW5CVkE2UHNYYUFwb0d5VTREc3ozUmxN?=
 =?utf-8?Q?frlM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc5f9cb-9f65-4462-4c07-08db61241b51
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 15:39:50.7679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7rQCevn/ByE+tPYA50f2MtgAX7moQQeQ+kPZ+Hxdpe93uGnc9NtZfoygGtnGnIWUwu4CRRuSc1KCV6NE6/L0nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8693
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBrZXJuZWwub3JnPg0KPiBTZW50OiBUdWVzZGF5
LCBNYXkgMzAsIDIwMjMgMTE6MjYgQU0NCj4gDQo+IE9uIDUvMjkvMjMgNzo0NCBBTSwgUGFyYXYg
UGFuZGl0IHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9uZXQvaXB2NC90Y3Bfb2ZmbG9hZC5jIGIv
bmV0L2lwdjQvdGNwX29mZmxvYWQuYyBpbmRleA0KPiA+IDQ1ZGRhNzg4OTM4Ny4uODhmOWIwMDgx
ZWU3IDEwMDY0NA0KPiA+IC0tLSBhL25ldC9pcHY0L3RjcF9vZmZsb2FkLmMNCj4gPiArKysgYi9u
ZXQvaXB2NC90Y3Bfb2ZmbG9hZC5jDQo+ID4gQEAgLTI5Niw3ICsyOTYsNyBAQCBzdHJ1Y3Qgc2tf
YnVmZiAqdGNwX2dyb19yZWNlaXZlKHN0cnVjdCBsaXN0X2hlYWQNCj4gKmhlYWQsIHN0cnVjdCBz
a19idWZmICpza2IpDQo+ID4gIAlyZXR1cm4gcHA7DQo+ID4gIH0NCj4gPg0KPiA+IC1pbnQgdGNw
X2dyb19jb21wbGV0ZShzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiA+ICt2b2lkIHRjcF9ncm9fY29t
cGxldGUoc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gPiAgew0KPiA+ICAJc3RydWN0IHRjcGhkciAq
dGggPSB0Y3BfaGRyKHNrYik7DQo+ID4NCj4gPiBAQCAtMzExLDggKzMxMSw2IEBAIGludCB0Y3Bf
Z3JvX2NvbXBsZXRlKHN0cnVjdCBza19idWZmICpza2IpDQo+ID4NCj4gPiAgCWlmIChza2ItPmVu
Y2Fwc3VsYXRpb24pDQo+ID4gIAkJc2tiLT5pbm5lcl90cmFuc3BvcnRfaGVhZGVyID0gc2tiLT50
cmFuc3BvcnRfaGVhZGVyOw0KPiA+IC0NCj4gPiAtCXJldHVybiAwOw0KPiA+ICB9DQo+ID4gIEVY
UE9SVF9TWU1CT0wodGNwX2dyb19jb21wbGV0ZSk7DQo+IA0KPiB0Y3BfZ3JvX2NvbXBsZXRlIHNl
ZW1zIGZhaXJseSB0cml2aWFsLiBBbnkgcmVhc29uIG5vdCB0byBtYWtlIGl0IGFuIGlubGluZSBh
bmQNCj4gYXZvaWQgYW5vdGhlciBmdW5jdGlvbiBjYWxsIGluIHRoZSBkYXRhcGF0aD8NCj4gDQpT
b3VuZHMgZ29vZCB0byBtZS4NCldpdGggaW5saW5lIGl0IHNob3VsZCBtb3N0bHkgaW1wcm92ZSB0
aGUgcGVyZiwgYnV0IEkgZG8gbm90IGhhdmUgYW55IG9mIHRoZSAzIGFkYXB0ZXJzIHdoaWNoIGFy
ZSBjYWxsaW5nIHRoaXMgQVBJIHRvIHNob3cgcGVyZiByZXN1bHRzLg0KDQpTaW5jZSwgaXQgaXMg
YSBkaWZmZXJlbnQgY2hhbmdlIHRvdWNoaW5nIHRoZSBwZXJmb3JtYW5jZSwgSSBwcmVmZXIgdG8g
ZG8gZm9sbG93IHVwIHBhdGNoIHRoYXQgYm54IG93bmVycyBjYW4gdGVzdC4NCklzIHRoYXQgb2s/
DQo=

