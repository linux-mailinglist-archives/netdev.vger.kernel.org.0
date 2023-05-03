Return-Path: <netdev+bounces-158-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64DCC6F58BE
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ACA5280F60
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55A0D526;
	Wed,  3 May 2023 13:12:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD665321E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:12:31 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02olkn2106.outbound.protection.outlook.com [40.92.49.106])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8405B90;
	Wed,  3 May 2023 06:11:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASIZyUS4ffBJyQJLvrRxec+emTg7GrvzXNwyXjDhCBw5YaqfD531NZDAu3ykeK/TD0R6MVDNTGQb4DDvNvnmxqApEP5/11UCj36C2WHgUqwjVjvlVYFi+cquyW2dV+pwJdjiEcxuHenbVXnCXRrm1FwOK9PcHNLOmvvtcUuCuEbpHp8q03GI4F9/rQMoOB3hQOmvqO0KS26xHgPqHuRtfibNwSRNGNOFLOuUkOLGOwHh3cMXAGKli3mCmqxe8rd3udqqasBIWtfRk/dOGm1yh6s3pE2Vw+VovkhiyLiRJKQAQ80sOk/2VglJyM4Hk/Bdxp3uZXWffWRypfnUPuzM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LqDn8E3+ZjWnA1NbCEZRWb0nxecRZGAbNexUC1wUuU=;
 b=a3ajiIMbU8M7og8mUKowpMeTGmOKdEXK4nof4f9YQT9cmYvrx6fPte4lNxUD4G+qhOnyJr4JQJGoGTzqsCR87b1jBrr+QnwWHrSo+0Q0tZqFvmOzbnnFmYiiotShIJ644v+LyVHReCcKsuClDaBlzh+zcR2Xn+qajIbIhwJ0HVjyfkuXI19DTHl6rkkL+6gMrzcUkKilp8JkTWe49T9EXMaU4nTQWqQ99Li2YNZZs0beGfT/GhprfggsYsbuR+1hHnA7gJtPrh+r3qfD1WuNumS/iXCwpIIZJxxeXJuN3aYzGxD1CEV8y0wFL3Q+2/0VX4BjXw4jZZOC8ILs+HmSug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LqDn8E3+ZjWnA1NbCEZRWb0nxecRZGAbNexUC1wUuU=;
 b=W9q2sMSq2uiLRMja6uMh2kSaSb4XWhB64M5/5IlwJnt2ZCzBi+UFAOUAs9KZhuvrR2MXgVgouo+RhSkrMJ8x3VnaetczMbJa/Y6zsOYWW4jU1f89apxkreTGb0WC948iSsam+dd9Yp7f5bkff8hBsEt2bp8elAh5X0tymUAbkzbOXRASFqRrKr8S+8qaueRXuLoeHFvwxTb6Wm4okBTt77+3FwEamuOMO1ERf/sCZsvKMhAcISH7jVfZkQ6LDeBc3eojh5A7D/zKMAJNO55WKxflaKUORSKB3DgDE8F08Lj5ZH6pbvj7YkvaiBizyFmTpwd6X5GpCtQxFwpJQXuivg==
Received: from GV1P193MB2005.EURP193.PROD.OUTLOOK.COM (2603:10a6:150:25::22)
 by GV1P193MB2264.EURP193.PROD.OUTLOOK.COM (2603:10a6:150:29::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.21; Wed, 3 May
 2023 13:11:22 +0000
Received: from GV1P193MB2005.EURP193.PROD.OUTLOOK.COM
 ([fe80::7394:8920:7e89:7cc1]) by GV1P193MB2005.EURP193.PROD.OUTLOOK.COM
 ([fe80::7394:8920:7e89:7cc1%4]) with mapi id 15.20.6363.021; Wed, 3 May 2023
 13:11:22 +0000
From: Adrien Delorme <delorme.ade@outlook.com>
To: Pavel Begunkov <asml.silence@gmail.com>, "david.laight@aculab.com"
	<david.laight@aculab.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "davem@davemloft.net"
	<davem@davemloft.net>, "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
	"dsahern@kernel.org" <dsahern@kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "leit@fb.com" <leit@fb.com>,
	"leitao@debian.org" <leitao@debian.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "marcelo.leitner@gmail.com"
	<marcelo.leitner@gmail.com>, "matthieu.baerts@tessares.net"
	<matthieu.baerts@tessares.net>, "mptcp@lists.linux.dev"
	<mptcp@lists.linux.dev>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "willemb@google.com"
	<willemb@google.com>, "willemdebruijn.kernel@gmail.com"
	<willemdebruijn.kernel@gmail.com>
Subject: RE: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Topic: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Index: AQHZfPcbeWikE8uGs0CEhT1cqCE61a9Ido9g
Date: Wed, 3 May 2023 13:11:22 +0000
Message-ID:
 <GV1P193MB2005214F383309B8466C6361EA6C9@GV1P193MB2005.EURP193.PROD.OUTLOOK.COM>
References:
 <GV1P193MB200533CC9A694C4066F4807CEA6F9@GV1P193MB2005.EURP193.PROD.OUTLOOK.COM>
 <49866ae2-db19-083c-6498-e7d9d62e8267@gmail.com>
In-Reply-To: <49866ae2-db19-083c-6498-e7d9d62e8267@gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [CAfFIVjbgyQQDAEHMlD8CcP1pgHk4Lzw]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1P193MB2005:EE_|GV1P193MB2264:EE_
x-ms-office365-filtering-correlation-id: 04f62c61-9448-4d24-c3dc-08db4bd7e447
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 yIAh4UwxsA0VrRV7YMKSAfXYn5Y1PyCYmOjrbx27OMDagfwD1GAaccaiDa1w4dwP+gFAfGVX+el1mdNKtz4r9iVfxP0nL8GfmvNX0UotBtTy57M/rfhSE4xmL1DvGAXyZllF2Cv9TCOwMUb0Bmuiij1kwi8KmaeS31kScILzu2Lll/yWGi3gir81lgJvsfr5Kj4gxzoA3oji1vukyx+CBr1x5E+z7SbYo6Kt8JiN5ASn2ce2dRv3VWfUqavdUIL1FBTxXXHDQLDti3HJ/9bPBC5VyNsqsAj52B5NeIkUQWmCnfhcN5SfL+Y47nuVxAdzogK0Ouxc2N6XanpharyRZnlfvxLWVJZ2bUo85ttej1tBtm2NqYX43QG6rNSCcW2OvvXXsIYtIw6rioVTet5q7lVlfJEf35s9lc6TbjpZ1hUdtkmhLbkMNtvqlqKPfp5loGRkYFeu/DT5c2EuS7HFtJ4BAR7FSFr6Cgm2nC9AYPYtzI81fhmWUYZLiQfdsvyPIuKM4AJWqwemPALbnMrRlIA3evQRni8kmWZnpPsZtTJ8D65p93cJHw1JdUZfRCgBeiCj9mRMtCyoutADfd1EnPgeGrjdf2cU+tK+7Fxia/bXK4cHm0iZ4RxEEeefiepa
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ajZlc2RpcjU2cmdtOXY2WStZTFpuemFKNEttZmxWRmJ0Y2ptMElVNmZjMElH?=
 =?utf-8?B?dVByWGc5SGh1RVpMWk9KSGR1MlIySXhGaktYNkxFVTRPOFQ5ZXMrZzNSQnND?=
 =?utf-8?B?M25saHljd0ZxNE5GbGoweFlaQmhmdW4wcWlHd2xZZ2oxZFJNLzFua2FMckRV?=
 =?utf-8?B?VXVzVjZlQXc1aWFJZmoyeXZuK0hPQURLQkltekxsQzMwQmxrQzgwY2wxQXQ5?=
 =?utf-8?B?ZjVVVFZWTTQxMGowOXUzTXp5Q093cDYwaVIzcDV1TE4vaS9iY3VUZE1ZVWZh?=
 =?utf-8?B?d2Z0WHgvWTUwVGJ2eXdGRlRBYm43empRbXpSV0NKWmwyamNJd0V1a0dSTDBu?=
 =?utf-8?B?bGxZUDJlSjg3VUlmcXRSOStYaklqR2RtU015K0xMSnNVTlExeExpeTlLRkxH?=
 =?utf-8?B?Nzh5VFl6V3FwbVFkU1d1enBiVWhVWFNSaGlPamlqSE5YMGFvV2FOZmtoOVRh?=
 =?utf-8?B?cmp3cDdoT1JIbGFzbGNQWmFJVEdBbkhOb0g5RkdwNFFvU255cFBXbGFwYUdS?=
 =?utf-8?B?UEtiT0hQYW1TM0F6VXRWNGN3V3dYeGRISk15RTBXYlRvUTBjQ0EyRzdCanFp?=
 =?utf-8?B?bkZLM1BldFJaNkNpeEVNcjM3c24reCtkR2s3Ui96cHRENXRXekFkSXVqNEs3?=
 =?utf-8?B?N1IrODVFbktjRWZDaFNva2dkaHpHMjdGYUNhb3pKU0pBYU90N3E1dVpWRkRX?=
 =?utf-8?B?T2V2L21wQnJWMUZSYjdPOHd0cURXSzhtNmxWbmhHN1hYVE9kZDFIMmQ2Tnda?=
 =?utf-8?B?V3hJd2MvRm8zZTVLWEU4dG9DK245RmdxeUVqaDY5SzZNaURsTit6TU1OZ1FI?=
 =?utf-8?B?bTM5OWRXN1UxRkdtOWE2TXk4SEszcTY4YU9PaUZlUVFmUlJIZ1pUaERjaTF4?=
 =?utf-8?B?Wjl1Y2ZLNjdzZ2hVSE45SlcxR04zcXdzQXprdkY3MjE3d1EvR1RhOGlYZ0Z2?=
 =?utf-8?B?eHVwUlBGUXk1dXNuVEFnallqYlprZVhSd0JJRnU3ZjVNWWFPeU1PdVBqWTFM?=
 =?utf-8?B?T3I2NllWUGdmTTRKV1NlcUJSVHEvRHJtNExRcC82MWQ5MXgybW5oNVdqU3dX?=
 =?utf-8?B?amJ1NFhGRE1oYnhZMDdnWE9pY3FLRjRWVkpxRXY2UGcrRHhSZnZVWFJJZlJl?=
 =?utf-8?B?aGpmT1FQajJ2cFhaY1RnMXRFNnhLanRtWmRwdXhub3BjY3BvRFV5bVZPdWUw?=
 =?utf-8?B?MG5kWWZkakFQejE3NFBKbG5SbjBQV1Z4V1JBWDNMV0h0aWdreHpqWmRWcFFE?=
 =?utf-8?B?eTFmVGNzWUFaZ2NWT3g0M1FKRHhYRXJBRWhlNEU3TE93QUZoVHFXMmZEb2py?=
 =?utf-8?B?ajhHam0vYjY0bUkralNjM1NHWXJjQk1RNFhnQ1gyd3I0bHEvT1QrSE1NUEJO?=
 =?utf-8?B?REZreVY2cjBJNG5uTFVPV3NEM1VKM3E0N05CZWV4b1BhQkxVM3NpbVpQTTBJ?=
 =?utf-8?B?cEhtS3BhMkNuU2M0MFpjYmEyYXJDbWJhN3Z6MVF2MWhPMlgyS2VqVUlkSmN1?=
 =?utf-8?B?aVpwcUNRRGZlSWZDdzMyUGVWN3JlaW1KR0syQzhlKzdDeEczQTlDT3dCNHdZ?=
 =?utf-8?B?eGN2bEJLbkpkZU4zbjFzM3JiNlRlRDZreWxodys2R0tDbnFjbHJDZ0xvdFlo?=
 =?utf-8?B?cXRoejBWR3JwR3MrS1dRMlJmSWpjbUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P193MB2005.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f62c61-9448-4d24-c3dc-08db4bd7e447
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 13:11:22.2533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P193MB2264
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQpGcm9tIEFkcmllbiBEZWxvcm1lDQo+IEZyb23CoDogUGF2ZWwgQmVndW5rb3YgDQo+IFNlbnQg
OiAyIE1heSAyMDIzIDE1OjA0DQo+IE9uIDUvMi8yMyAxMDoyMSwgQWRyaWVuIERlbG9ybWUgd3Jv
dGU6DQo+ID4gIEZyb20gQWRyaWVuIERlbG9ybWUNCj4gPg0KPiA+PiBGcm9tOiBEYXZpZCBBaGVy
bg0KPiA+PiBTZW50OiAxMiBBcHJpbCAyMDIzIDc6MzkNCj4gPj4+IFNlbnQ6IDExIEFwcmlsIDIw
MjMgMTY6MjgNCj4gPj4gLi4uLg0KPiA+PiBPbmUgcHJvYmxlbSBpcyB0aGF0IG5vdCBhbGwgc29j
a29wdCBjYWxscyBwYXNzIHRoZSBjb3JyZWN0IGxlbmd0aC4NCj4gPj4gQW5kIHNvbWUgb2YgdGhl
bSBjYW4gaGF2ZSB2ZXJ5IGxvbmcgYnVmZmVycy4NCj4gPj4gTm90IHRvIG1lbnRpb24gdGhlIG9u
ZXMgdGhhdCBhcmUgcmVhZC1tb2RpZnktd3JpdGUuDQo+ID4+DQo+ID4+IEEgcGxhdXNpYmxlIHNv
bHV0aW9uIGlzIHRvIHBhc3MgYSAnZmF0IHBvaW50ZXInIHRoYXQgY29udGFpbnMgc29tZSwNCj4g
Pj4gb3IgYWxsLCBvZjoNCj4gPj4gICAgICAgIC0gQSB1c2Vyc3BhY2UgYnVmZmVyIHBvaW50ZXIu
DQo+ID4+ICAgICAgICAtIEEga2VybmVsIGJ1ZmZlciBwb2ludGVyLg0KPiA+PiAgICAgICAgLSBU
aGUgbGVuZ3RoIHN1cHBsaWVkIGJ5IHRoZSB1c2VyLg0KPiA+PiAgICAgICAgLSBUaGUgbGVuZ3Ro
IG9mIHRoZSBrZXJuZWwgYnVmZmVyLg0KPiA+PiAgICAgICAgPSBUaGUgbnVtYmVyIG9mIGJ5dGVz
IHRvIGNvcHkgb24gY29tcGxldGlvbi4NCj4gPj4gRm9yIHNpbXBsZSB1c2VyIHJlcXVlc3RzIHRo
ZSBzeXNjYWxsIGVudHJ5L2V4aXQgY29kZSB3b3VsZCBjb3B5IHRoZQ0KPiA+PiBkYXRhIHRvIGEg
c2hvcnQgb24tc3RhY2sgYnVmZmVyLg0KPiA+PiBLZXJuZWwgdXNlcnMganVzdCBwYXNzIHRoZSBr
ZXJuZWwgYWRkcmVzcy4NCj4gPj4gT2RkIHJlcXVlc3RzIGNhbiBqdXN0IHVzZSB0aGUgdXNlciBw
b2ludGVyLg0KPiA+Pg0KPiA+PiBQcm9iYWJseSBuZWVkcyBhY2Nlc3NvcnMgdGhhdCBhZGQgaW4g
YW4gb2Zmc2V0Lg0KPiA+Pg0KPiA+PiBJdCBtaWdodCBhbHNvIGJlIHRoYXQgc29tZSBvZiB0aGUg
cHJvYmxlbWF0aWMgc29ja29wdCB3ZXJlIGluIGRlY25ldA0KPiA+PiAtIG5vdyByZW1vdmVkLg0K
PiA+DQo+ID4gSGVsbG8gZXZlcnlvbmUsDQo+ID4NCj4gPiBJJ20gY3VycmVudGx5IHdvcmtpbmcg
b24gYW4gaW1wbGVtZW50YXRpb24gb2Yge2dldCxzZXR9IHNvY2tvcHQuDQo+ID4gU2luY2UgdGhp
cyB0aHJlYWQgaXMgYWxyZWFkeSB0YWxraW5nIGFib3V0IGl0LCBJIGhvcGUgdGhhdCBJIHJlcGx5
aW5nIGF0IHRoZQ0KPiBjb3JyZWN0IHBsYWNlLg0KPiANCj4gSGkgQWRyaWVuLCBJIGJlbGlldmUg
QnJlbm8gaXMgd29ya2luZyBvbiBzZXQvZ2V0c29ja29wdCBhcyB3ZWxsIGFuZCBoYWQNCj4gc2lt
aWxhciBwYXRjaGVzIGZvciBhd2hpbGUsIGJ1dCB0aGF0IHdvdWxkIG5lZWQgZm9yIHNvbWUgcHJv
YmxlbXMgdG8gYmUNCj4gc29sdmVkIGZpcnN0LCBlLmcuIHRyeSBhbmQgZGVjaWRlIHdoZXRoZXIg
aXQgY29waWVzIHRvIGEgcHRyIGFzIHRoZSBzeXNjYWxsDQo+IHZlcnNpb25zIG9yIHdvdWxkIGdl
dC9yZXR1cm4gb3B0dmFsIGRpcmVjdGx5IGluIHNxZS9jcWUuIEFuZCBhbHNvIHdoZXJlIHRvDQo+
IHN0b3JlIGJpdHMgdGhhdCB5b3UgcGFzcyBpbiBzdHJ1Y3QgYXJnc19zZXRzb2Nrb3B0X3VyaW5n
LCBhbmQgd2hldGhlciB0byByZWx5DQo+IG9uIFNRRTEyOCBvciBub3QuDQo+IA0KDQpIZWxsbyBQ
YXZlbCwNClRoYXQgaXMgZ29vZCB0byBoZWFyLiBJZiBwb3NzaWJsZSBJIHdvdWxkIGxpa2UgdG8g
cHJvdmlkZSBzb21lIGhlbHAuIA0KSSBsb29rZWQgYXQgdGhlIGdldHNvY2tvcHQgaW1wbGVtZW50
YXRpb24uIEZyb20gd2hhdCBJJ20gc2VlaW5nLCBJIGJlbGlldmUgdGhhdCBpdCB3b3VsZCBiZSBl
YXNpZXIgdG8gY29waWVzIHRvIGEgcHRyIGFzIHRoZSBzeXNjYWxsLg0KVGhlIGxlbmd0aCBvZiB0
aGUgb3V0cHV0IGlzIHVzdWFsbHkgNCBieXRlcyAoc29tZXRpbWVzIGxlc3MpIGJ1dCBpbiBhIGxv
dCBvZiBjYXNlcywgdGhpcyBsZW5ndGggaXMgdmFyaWFibGUuIFNvbWV0aW1lIGl0IGNhbiBldmVu
IGJlIGJpZ2dlciB0aGF0IHRoZSBTUUUxMjggcmluZy4NCg0KSGVyZSBpcyBhIG5vbi1leGhhdXN0
aXZlIGxpc3Qgb2YgdGhvc2UgY2FzZXMgOiANCi9uZXQvaXB2NC90Y3AuYyA6IGludCBkb190Y3Bf
Z2V0c29ja29wdCguLi4pDQogIC0gVENQX0lORk8gOiB1cCB0byAyNDAgYnl0ZXMNCiAgLSBUQ1Bf
Q0NfSU5GTyBhbmQgVENQX1JFUEFJUl9XSU5ET1cgOiB1cCB0byAyMCBieXRlcw0KICAtIFRDUF9D
T05HRVNUSU9OIGFuZCBUQ1BfVUxQIDogdXAgdG8gMTYgYnl0ZXMNCiAgLSBUQ1BfWkVST0NQT1lf
UkVDRUlWRSA6IHVwIHRvIDY0IGJ5dGVzICANCi9uZXQvYXRtL2NvbW11bi5jIDogaW50IHZjY19n
ZXRzb2Nrb3B0KC4uLikNCiAgLSBTT19BVE1RT1MgOiB1cCB0byA4OCBieXRlcw0KICAtIFNPX0FU
TVBWQyA6IHVwIHRvIDE2IGJ5dGVzDQovbmV0L2lwdjQvaW9fc29ja2dsdWUuYyA6IGludCBkb19p
cF9nZXRzb2Nrb3B0KC4uLikNCiAgLSBNQ0FTVF9NU0ZJTFRFUiA6IHVwIHRvIDE0NCBieXRlcw0K
ICAtIElQX01TRklMVEVSIDogMTYgYnl0ZXMgbWluaW11bQ0KDQpJIHdpbGwgbG9vayBpbnRvIHNl
dHNvY2tvcHQgYnV0IEkgYmVsaWV2ZSBpdCBtaWdodCBiZSB0aGUgc2FtZS4gDQpJZiBuZWVkZWQg
SSBjYW4gYWxzbyBjb21wbGV0ZSB0aGlzIGxpc3QuIA0KSG93ZXZlciB0aGVyZSBhcmUgc29tZSBj
YXNlcyB3aGVyZSBpdCBpcyBoYXJkIHRvIGRldGVybWluYXRlIGEgbWF4aW11bSBhbW91bnQgb2Yg
Ynl0ZXMgaW4gYWR2YW5jZS4gDQoNCkFzIHRvIHdoZXJlIHRoZSBieXRlcyBzaG91bGQgYmUgc3Rv
cmVkIEkgd2FzIHRoaW5raW5nIG9mIGVpdGhlciA6DQogIC0gQXMgYSBwb2ludGVyIGluIHNxZS0+
YWRkciBzbyB0aGUgU1FFMTI4IGlzIG5vdCBuZWVkZWQgDQogIC0gSW4gc3FlLT5jbWQgYXMgYSBz
dHJ1Y3QgYnV0IGZyb20gbXkgdW5kZXJzdGFuZGluZywgdGhlIFNRRTEyOCBpcyBuZWVkZWQNCj4g
DQo+ID4gTXkgaW1wbGVtZW50YXRpb24gaXMgcmF0aGVyIHNpbXBsZSB1c2luZyBhIHN0cnVjdCB0
aGF0IHdpbGwgYmUgdXNlZCB0byBwYXNzDQo+IHRoZSBuZWNlc3NhcnkgaW5mbyB0aHJvdWdodCBz
cWUtPmNtZC4NCj4gPg0KPiA+IEhlcmUgaXMgbXkgaW1wbGVtZW50YXRpb24gYmFzZWQgb2Yga2Vy
bmVsIHZlcnNpb24gNi4zIDoNCj4gPiAuLi4NCj4gPiArLyogU3RydWN0IHRvIHBhc3MgYXJncyBm
b3IgSU9fVVJJTkdfQ01EX09QX0dFVFNPQ0tPUFQgYW5kDQo+ID4gK0lPX1VSSU5HX0NNRF9PUF9T
RVRTT0NLT1BUIG9wZXJhdGlvbnMgKi8gc3RydWN0DQo+ID4gK2FyZ3Nfc2V0c29ja29wdF91cmlu
Z3sNCj4gDQo+IFRoZSBuYW1lIG9mIHRoZSBzdHJ1Y3R1cmUgaXMgcXVpdGUgaW5jb25zaXN0ZW50
IHdpdGggdGhlIHJlc3QuIEl0J3MgYmV0dGVyIHRvIGJlDQo+IGlvX1t1cmluZ19dX3NvY2tvcHRf
YXJnIG9yIHNvbWUgdmFyaWF0aW9uLg0KPiANCj4gPiArICAgICAgIGludCAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgbGV2ZWw7DQo+ID4gKyAgICAgICBpbnQgICAgICAgICAgICAgICAgICAg
ICBvcHRuYW1lOw0KPiA+ICsgICAgICAgY2hhciBfX3VzZXIgKiAgIHVzZXJfb3B0dmFsOw0KPiA+
ICsgICAgICAgaW50ICAgICAgICAgICAgICAgICAgICAgb3B0bGVuOw0KPiANCj4gVGhhdCdzIHVh
cGksIHRoZXJlIHNob3VsZCBub3QgYmUgX191c2VyLCBhbmQgZmllbGQgc2l6ZXMgc2hvdWxkIGJl
IG1vcmUNCj4gcG9ydGFibGUsIGkuZS4gdXNlIF9fdTMyLCBfX3U2NCwgZXRjLCBsb29rIHRocm91
Z2ggdGhlIGZpbGUuDQo+IA0KPiBXb3VsZCBuZWVkIHRvIGxvb2sgaW50byB0aGUgZ2V0L3NldHNv
Y2tvcHQgaW1wbGVtZW50YXRpb24gYmVmb3JlIHNheWluZw0KPiBhbnl0aGluZyBhYm91dCB1cmlu
Z19jbWRfe3NldCxnZXR9c29ja29wdC4NCj4gLi4uDQo+IFBhdmVsIEJlZ3Vua292DQoNClRoYW5r
IHlvdSBmb3IgdGhlIHJldmlldy4NCkFkcmllbiBEZWxvcm1lDQotLQ0KDQo=

