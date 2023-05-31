Return-Path: <netdev+bounces-6838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4557185FC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17FD82812E9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C36F171B6;
	Wed, 31 May 2023 15:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEB6168B9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:20:23 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2070.outbound.protection.outlook.com [40.107.105.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B15C0;
	Wed, 31 May 2023 08:20:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJ3AJkVWqF/TVQGIO2utG3129zrcwODmfBQd+BYFXQfEQSJlU3Sh8GJ+ecsiQXoK3GNhJDPN67Y/+75mbEfudx5pOUp8AfHQD3PrhzpkAAUx0v8gk11JNep8LhZ+jMHoAuDPcPBDSrFPl8GVFWEk1mHgCa4fHxnpuHaSdtfe2fwW1Ilp7kf8AFHTW+K/eqlztsZAp5E1v9qhHCRHFSnXQpLFhPhfqSbww4WaMxJ4zuR95ofU8E5a8dUN61fj9hzynLmxtmQljKNl96advvjauYpCxKmYMI+nvA/chfegV9oNrgl9Yq7GyYZoku7GHWBXRLvvDTtqI6/6yzp/72KMxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rb/JW2PtSKyhquyibap7UT0ynaP5ez97YY0SuLF7d9Q=;
 b=O7z9WDSNqcdZLo7Eu1z8tpfUhrkZrQvW28HLoY8PgfH5SvhE2mVLqXy37gXrNq1f2hEr1aiz+f4ZVtUYkpk2qur0DL5a3sXjbUXORt1J4vZ3e0T7a6yZEEiirPzykx2flZKUGgVkpk9DoXMTI5YcD4+plT4qoZ0RuIn1XMQpwUgX1qQw9SzK+8rrot5dWt9xaK8LhMyl7/TNfE4ojRv4KFLK8KljMawlXKsA+V33Q7eDYk7ToPiPf7dj/3k3kn4JZPxjiKHyfm7gFQAoOd89ozKRdOXi2n4LT8swrCFn/tWE2xba0J13c//bXPxl/Eb/BUCZ0Jc823+s5Mf/6Xqb+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rb/JW2PtSKyhquyibap7UT0ynaP5ez97YY0SuLF7d9Q=;
 b=oJW0G1+I6tuk5rAR2jrY6U2q+fPkOI53e0wO8wloVFug1lLW0WP1sKyWW4QnPD2/9P+2I2/JHw6Rtz9ATuCU/WZ3396DZKQFIJjbEfJcMjoPRG81QC/jWwMz1jLy8fbf6d+LQVy0/6F3p/DqVe9OqqejcnN7OjNqBLeRqL9svGv9UH9WKqSepJWHOLayo/JA4ynqpPjuc2/v4o6OM5ymBKBtrgEvvg7mcesQH69hTjUSUjh6P5s4SfRZ+sOJIanIJGp7KEGAJLIplm1ZRxan1j/T7TZbEqpIxXf77jvflr0SSuPmXbt+t9+qOToXd7udqAUrqz+YkAar4Vs/c/i1Ww==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by AM7PR10MB3734.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:108::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 15:20:19 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2324:90ea:1454:5027]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2324:90ea:1454:5027%6]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:20:19 +0000
From: "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To: "olteanv@gmail.com" <olteanv@gmail.com>
CC: "privat@egil-hjelmeland.no" <privat@egil-hjelmeland.no>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del}
 methods
Thread-Topic: [PATCH] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del}
 methods
Thread-Index: AQHZk82aceD5bgaPR0OFkCZrwVBob690fhkAgAABG4A=
Date: Wed, 31 May 2023 15:20:19 +0000
Message-ID: <426c54cdaa001d55cdcacee4ae9e7712cee617c2.camel@siemens.com>
References: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
	 <20230531151620.rqdaf2dlp5jsn6mk@skbuf>
In-Reply-To: <20230531151620.rqdaf2dlp5jsn6mk@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|AM7PR10MB3734:EE_
x-ms-office365-filtering-correlation-id: 6d1dd33c-9330-472e-f80c-08db61ea8b87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 4CK2wqmNEhbM68T/LoXW/B2s2aAPKuDyeDtQC5veSjbtumoNFptDa5Hf6Fwvg48kTLOeR/rRm5l67pIBfmfmIj6k7+FfY6arJ//7SezvoQlu+VScKjx5TNDIBmFTI1zt7xi8t/Ly+tajbApBmTXYC99o0k17sjfhcSSU3dbGRvEq1tDJoUV9AQ6CKYfb/toZ/txwk6BwsqiL1sNZPdT2mUrdoAHOXd2em66nEMc7RgFq76DT9UAcR45pszhQSVb4pp6S2X4VaxgiLwyqzwKfZFiAR5Y2FXUlj4Iu38KvnJJmNNQ4SjMW0PZG8+QVYewHB12yML3bpawyaYIZ+KxXMRNhkzoX6fnsHhvDX5b0PEB7XZxpccVke3J3X8Ts8N8JlWe9m4hxpL06MI0K9FvqSm+0Nf9vFKm7e4q4cXJXRbjoGQjDcNoJ1RfyZwV67qkPqryRD0lJl1rqVXbSSqHgk1Ss92z8mhXXOfwBoSGfjNR4UcLudGUEiqa5dKkBj4jcbEOKDvT5Hj29zTPT+0LnCu0/p7SG9sn3uLvI7zL7uhedcgYOPyMTdnBbRK0ush2DU/A5BjzZpP+BpnlwgPVN447hRIRXq504Cneb0/aLMmUxSFACr6uXuMpbw1mmP9oM8XDIVHXUYmuFl9ko1o25Fw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199021)(71200400001)(478600001)(54906003)(8676002)(66476007)(8936002)(5660300002)(2906002)(36756003)(86362001)(38070700005)(15974865002)(91956017)(4326008)(6916009)(76116006)(82960400001)(122000001)(66446008)(66946007)(64756008)(316002)(66556008)(41300700001)(38100700002)(186003)(6512007)(2616005)(6506007)(6486002)(83380400001)(966005)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WkVZYnhQWE11K2g1S1NMUno4YmlGMzZjdmFVSnJ6Q0FLMmg3YkZBK2JkdG84?=
 =?utf-8?B?Q2dIdlhZRmxkaDd0SlVaTEtiSWVWZWRSdWN6L2lSV3doZkJxV2NCd1VlcjBs?=
 =?utf-8?B?cmgxNDc5K29nVEI2QzliQ3F1ZXNuLzBSUlhZQVVSVzZ0N1lFcGNBQ2Qvc3N3?=
 =?utf-8?B?cFFkQXNnNGFJWEtBLzFrc0l0TThEemFlOUZQK0Y1T2Ntbm5nanQyTVBTRGto?=
 =?utf-8?B?SU9VVGZFYkg1eWJqdXB1TXR6MGwrVDF3SWJWTDhBa21qSGh6OGlHYXh2bGJl?=
 =?utf-8?B?NGY1UlJpOXdOd05xM0pTWlNsdkY3V3ZNd3pETk14UGVrUUJUTDBJY0FCSzB3?=
 =?utf-8?B?TnlYRk9SbjJSRlRFb0FBM2VhL0VqOFk0WWF5MlRIT3BsbnNrT3RRNUFybzVK?=
 =?utf-8?B?V1ZyejdCRExwZlVQNm9uQjM2WjM1S2t0WnhYTWM4ZjZ2cVFrMy9NMGhsMDdv?=
 =?utf-8?B?V3JYSXpiYTI4eVhoOUFsWlBKa1UwMVdCdlp6TXdNRjhtd3h4T3BmK1J1SlNz?=
 =?utf-8?B?dGxNRklSN0VBdU5VMlArRGYxTU5jbHBVRnRoK3I4NkdNZS81Qk41b2JQWWFP?=
 =?utf-8?B?bFVwbG5pRjc2Y3hlTXVMM0VkbGFvQU5Demd0dXp4R1VIWEcyWFhwajFZQ3ZT?=
 =?utf-8?B?cFJtUGRQa1N2OHR3QmlrSGVZazd5Y0pFb2xmMC8rd3ZGKzBpVDlNY3N4c0p5?=
 =?utf-8?B?cHVRS2RMbjFuUmVENFQ2dW9xR1o1clBya3YrTnlHdk0zbXBiMGV1bFVlaEJE?=
 =?utf-8?B?N1l2cU1sMnM4MnIyNzVrYy95SVZlMHVPVHAyUzdhUTFkNGFrd1UrSkkrUFFI?=
 =?utf-8?B?L3dQVFVjYklUQXJKTE9iS1hxLzc2b3dTVG1Hc2Jubm1ibFFMb2l4RFJSbEFP?=
 =?utf-8?B?REVyd00vYzJjcTJIanl2R1MyWUlaNG1wb3FKZUFuNk5FUGZyNk4wRWVhaHJr?=
 =?utf-8?B?ekp4bWJHRlNaZnpLYklhejVaSHIybDY3SjBnaFk1WUdMbzlWMEZyQVJmQmw1?=
 =?utf-8?B?eTZYVWQ3bXdxdlFyKzhGc2Q2MVV2WlpLdk9pR3VGMjRvNXQ1cWs3OVpBbjZR?=
 =?utf-8?B?b0YyZmorcGNPU0RZRXlFQ1J2bUtrNkhkMWQzcS8xOWdIRk1HMTl2YkNlRWxG?=
 =?utf-8?B?a2RCSERZYXYyRHpZY0xrSGpRMUhkQnNFVXdIcW1DTnZvWjZHclY2SE9VcEdq?=
 =?utf-8?B?WU01Sng1K0xCRVVvTDFaMm5uMms1ZURjMm40UG9LMzZUSjcvZURmZE56WjYr?=
 =?utf-8?B?MmtKVkFFR28zSlZxQTl3d0pZN1BScjhGTGZJcytHa3F6Zm9yYUJtaisvYmlm?=
 =?utf-8?B?NGt5bUNxdjlhZkxqMWdrcFkwa2ozekQvcFJscExlRkhqOHo5RDZLV0pxSysr?=
 =?utf-8?B?NEVuUmJueUN4N1VIWFZsWGtSYjJxSitjYU1XZm1JclBhNEF2UlJkMGhJYUZm?=
 =?utf-8?B?ZnZadVo5QTJrSlZoWFJ5ZzdkdlNHeG1Rc1g0TWgxSW9Eb05HYUxLeFdkazJz?=
 =?utf-8?B?TDNNbVFxOFRZMTZCMEhkOW42UzBzeFFuU01VSU1FK29kM0NDMTRhQklJcndG?=
 =?utf-8?B?OXZWSFRVazJkK0ZWZEJiNXM5aWdlbEY3dDBxV2lSK01ZREdSOHBtNmRxYks3?=
 =?utf-8?B?bUhhTndtcmZrcEYzS3N6RFJzY3U1YTFJK25DdHFEUXNxNzVwcmxUK2RlcVAw?=
 =?utf-8?B?dHBOdzFoOUQ1ZmhQenJrSGNMWTJkTGJBNmhLek9hZlM0a25yNVhJNTlEaHNs?=
 =?utf-8?B?dk84SmdSVkZBUTBJVnpJVkRsUUJDRGFkeDBVOEMwSXdERWtJZ0sxSisxZ0Q2?=
 =?utf-8?B?WTRQRzdBZ3VzKzRZK09HRytWK2Ixc1VIMG4vdWZBcVRkeDFHc1NMbmRBV3RE?=
 =?utf-8?B?OTlGL0tBUDUxTlB6emtvWWU3M3pvcjBmUW5HVEM1VEl1V0tTS0wvVFBBcTA5?=
 =?utf-8?B?ODk5OXRDa3JzNXU1TnJPVFNhTUJ2eVFBOEI3eTUzclkxWkFiUS9hRHlrWVYx?=
 =?utf-8?B?N0w4TXB2aVFNM1ZveXZjVUZZZ0dwVUNSM1NqQndPcHpSSWpRcFkrNXBjalNz?=
 =?utf-8?B?ZzhqZWZ6ZXZmZjlnS1pNNFlkNEVOL3Q5L1h0OEJRMVJRRGFoVFhJU2FMV3VE?=
 =?utf-8?B?UExUWmFvUTg1elNYcGVJN2pnM2VmRTdIMHhPTGhjRlVzcFpyT0xoZElpOC9G?=
 =?utf-8?B?NWsvK0hETFNZeG9ncVYyNC9ka3FCTDJyVzRpUyt5dExIVjM2RHd4UHNjSnhM?=
 =?utf-8?Q?Z7Ipx50IbtlLfkRBQquehb+2FgiJJi8NTjNmixvgKQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C893B2E56459B542842A977D5DFA2B78@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1dd33c-9330-472e-f80c-08db61ea8b87
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 15:20:19.3847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 26p9u+rBRNu0MLaCAque8dVA/GUiGVRS9Q0Sl3WmXpotH3/rjqY8FXn3UL+w2vIapJ6CTuGpKeeFZLX0s2nfkO0XIJyyfsXY521oMTNJ4I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR10MB3734
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgVmxhZGltaXIsDQoNCnRoYW5rIHlvdSBmb3IgcXVpY2sgcmV2aWV3IQ0KDQpPbiBXZWQsIDIw
MjMtMDUtMzEgYXQgMTg6MTYgKzAzMDAsIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gPiBMQU45
MzAzIGRvZXNuJ3QgYXNzb2NpYXRlIEZEQiAoQUxSKSBlbnRyaWVzIHdpdGggVkxBTnMsIGl0IGhh
cyBqdXN0DQo+ID4gb25lDQo+ID4gZ2xvYmFsIEFkZHJlc3MgTG9naWMgUmVzb2x1dGlvbiB0YWJs
ZSBbMV0uDQo+ID4gDQo+ID4gSWdub3JlIFZJRCBpbiBwb3J0X2ZkYl97YWRkfGRlbH0gbWV0aG9k
cywgZ28gb24gd2l0aCB0aGUgZ2xvYmFsDQo+ID4gdGFibGUuIFRoaXMNCj4gPiBpcyB0aGUgc2Ft
ZSBzZW1hbnRpY3MgYXMgaGVsbGNyZWVrIG9yIFJaL04xIGltcGxlbWVudC4NCj4gPiANCj4gPiBW
aXNpYmxlIHN5bXB0b21zOg0KPiA+IExBTjkzMDNfTURJTyA1YjA1MDAwMC5ldGhlcm5ldC0xOjAw
OiBwb3J0IDIgZmFpbGVkIHRvIGRlbGV0ZQ0KPiA+IDAwOnh4Onh4Onh4Onh4OmNmIHZpZCAxIGZy
b20gZmRiOiAtMg0KPiA+IExBTjkzMDNfTURJTyA1YjA1MDAwMC5ldGhlcm5ldC0xOjAwOiBwb3J0
IDIgZmFpbGVkIHRvIGFkZA0KPiA+IDAwOnh4Onh4Onh4Onh4OmNmIHZpZCAxIHRvIGZkYjogLTk1
DQo+ID4gDQo+ID4gWzFdIGh0dHBzOi8vd3cxLm1pY3JvY2hpcC5jb20vZG93bmxvYWRzL2VuL0Rl
dmljZURvYy8wMDAwMjMwOEEucGRmDQo+ID4gDQo+ID4gRml4ZXM6IDA2MjA0MjdlYTBkNiAoIm5l
dDogZHNhOiBsYW45MzAzOiBBZGQgZmRiL21kYiBtYW5pcHVsYXRpb24iKQ0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEFsZXhhbmRlciBTdmVyZGxpbiA8YWxleGFuZGVyLnN2ZXJkbGluQHNpZW1lbnMuY29t
Pg0KPiA+IC0tLQ0KPiANCj4gVGhhbmtzIGZvciB0YWtpbmcgYSBsb29rLiBBbHRob3VnaCBpdCB3
b3VsZCBwcm9iYWJseSBiZSBzYWZlciB0byBhZGQ6DQo+IA0KPiBGaXhlczogMmZkMTg2NTAxYjFj
ICgibmV0OiBkc2E6IGJlIGxvdWRlciB3aGVuIGEgbm9uLWxlZ2FjeSBGREINCj4gb3BlcmF0aW9u
IGZhaWxzIikNCj4gDQo+IHNpbmNlIEknbSBub3Qgc3VyZSBpdCBoYXMgYSByZWFzb24gdG8gYmUg
YmFja3BvcnRlZCBiZXlvbmQgdGhhdC4NCg0KV2VsbCwgaXQncyBub3Qgb25seSBhYm91dCB2aXNp
YmxlIGVycm9ycywgYnV0IHRoZSBkcml2ZXIgYWxzbyByZWZ1c2VkDQp0byBpbnN0YWxsIHRoZSBG
REIgZW50cmllcywgc28gaXQncyBjaGFuZ2UgaW4gYmVoYXZpb3VyLCBub3Qgb25seQ0KY29zbWV0
aWNzLg0KDQo+IEFueXdheToNCj4gDQo+IFJldmlld2VkLWJ5OiBWbGFkaW1pciBPbHRlYW4gPG9s
dGVhbnZAZ21haWwuY29tPg0KDQotLSANCkFsZXhhbmRlciBTdmVyZGxpbg0KU2llbWVucyBBRw0K
d3d3LnNpZW1lbnMuY29tDQo=

