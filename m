Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C4A3CEFFF
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353283AbhGSWyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 18:54:22 -0400
Received: from mail-bn8nam12on2094.outbound.protection.outlook.com ([40.107.237.94]:25094
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1384959AbhGSTw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 15:52:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntrSF+ivHc4D5M7CrEn6hTdOeqyfbOXY1XBNK1FBlBdGWgRbnAR2gVKs4qn/9kqWQQSYp2f0XHm9qm8Kxnl3Fy8r186VmDX8v59xKrUwdUTx9NlUnuauh8KLkqb2fAm5KjAUfiPmeo2KxwfHln5sh0vb+HErR0hBe2aJwkZqdbEP4DR4fq/4+eeIniD0NYkoI6Zb4O5ziI7kB6QATM02kyreswmz4RsJuUKydZZa6rbJVXZiJRzg422fGhyiISeUvX8F8hY5epJD2X7XrOxj8NwAZ8HoHydeOeOKVO2Zycg3Q0qR6OIxfi+Fo0BycGDaQYOlyW4lpBnKjaoHJwaaSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbE/GkTeN/gSd9oGbEFIjSC3QKMZS9qXGBTp0loZ1CA=;
 b=HvleMr+VSQt9HtXgKUBA5ov9mEJb8RfFC0wJLcEqGq02ZZhk2KmZCWqhn64tustCN/gQM3KwknNO4EV5XtPdigvVTTUMdonLRvb3nbFQ56VFw27wYWHSBo5HyEX/7M2CiPtsAFipXoFPZjV2LYbsoUTxOh+BZ+VN3IiFCtz/6mHfHMVUNEegqkrrRqV6htw/61EuizoBnCsxVq3/tJ7/CIHAXt6hnw/l3i50ECMKN2KGr+/JfLtTxhPHnlMX7+/PbO06GssDuvqNsGKVBFtWrPHK0/xiijUrP8k4yc0jb8dGumefG5cMkRbgszSkeGAEbjwzqzDcAmWp8x98E07AEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbE/GkTeN/gSd9oGbEFIjSC3QKMZS9qXGBTp0loZ1CA=;
 b=McrAjnPtbOgBquc+RxpQspBH9kuCFYdWXO3FXGFjkQj8ryN4fJyIMqihBTx5g26AgR6Lxf2+qyNhh4aJZ6OrS2Bo18zcu7gAVV1Aff4fYEpmlvpQGEMo/g583a8SnOPlARxJuc5KdhfQDPzbzH86b6e/ZkGVoIADg+i1Zl5xsyg=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BY5PR21MB1491.namprd21.prod.outlook.com (2603:10b6:a03:233::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.0; Mon, 19 Jul
 2021 20:33:30 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2c36:65ec:79ee:6f02]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2c36:65ec:79ee:6f02%5]) with mapi id 15.20.4331.014; Mon, 19 Jul 2021
 20:33:30 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Topic: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Index: Add5D8Zto2s5ndNhQDWxYbgsDd9OBQABZMKwAPF1LOYAAFUOYA==
Date:   Mon, 19 Jul 2021 20:33:30 +0000
Message-ID: <BYAPR21MB127077DE03164CA31AE0B33DBFE19@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <BYAPR21MB12703228F3E7A8B8158EB054BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
         <BYAPR21MB127099BADA8490B48910D3F1BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
         <YPPwel8mhaIdHP1y@unreal>
 <c61af64fd275b3a329bbad699de9db661e3cf082.camel@kernel.org>
In-Reply-To: <c61af64fd275b3a329bbad699de9db661e3cf082.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=eecc8dcb-8c3f-4abd-916d-f291e37535a0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-07-19T20:27:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8d3f08f-d0a3-47f5-cc47-08d94af478a8
x-ms-traffictypediagnostic: BY5PR21MB1491:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR21MB14919A690132872DB911ADEEBFE19@BY5PR21MB1491.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bgklswPg3Y71Hloq3Eo4TBOUAss466qql+SjzsFjXzfCE5Dy+9cGwftoAcrYfHjjMStmHlJ1/AC50NZVyorIctRQx05ETc/p31EbbMQrpyqBg1Trs+PrDHRvRlpTtqQKH83Bs+5RuPgW6X5gJecF5ipF/Zk8mUpmI9maYwes8+/v0IxETuUL7fG1mcHuUjnTPMqREjpA6l+5kJKC/fXHMw/ZfINHzWFaFiHn+RmKvzmdeGtIyz9B9BvIqcQveEojMh1rmbkTAKnK23a4IGTsbAolKkevLPUD+9QjZzsQPk3Kli8oDolJp2mIbtgYIJso/RocZUnWNSR8dqAbi6hByPK18fRBo/LGXcAl/jnD4HBp49ZoIeqPRDmCngvkzxybUScxsPF5TR0A28dSsCtEIfjmH4f8K2XCMu9Jyl3w5t8PVVaiK0PFY5RB9conrw4hsUHrEbmOmpqyCfGn0cV1ioHCu8SJ7G0AiWfE1vuQ5xokNS/2esj65pCgrF98FgpIw6TZaMQslp1aokw1oU2Vx87bUFJ6lTIwVdVwaUX/M4aAX/EAMe7Nkra+bcTJFLmuH2Uuv/gHvn4xDb3IBDsJtZ1Iqk4fFTuScPgYPb6REVY/GS3ct5JtEZdsaknP8y3+mEByyJh3PFfIkJ8HzwSFZaQA1/RtZq5LGlc5vBUttOOLzbKNcuzRqq4s/Rg6Om9iEv7xml1uHNrcAqgM3PDPjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(10290500003)(66446008)(66946007)(76116006)(64756008)(66476007)(38100700002)(8936002)(122000001)(9686003)(66556008)(5660300002)(8676002)(4326008)(86362001)(110136005)(316002)(83380400001)(55016002)(71200400001)(186003)(508600001)(8990500004)(6506007)(82950400001)(2906002)(52536014)(7696005)(82960400001)(33656002)(26005)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXlUQ0luMXk3SnU3OGx0WHB1K0VrNVB6QlljQWlDa2d0blJ3U2R5alhTaFMz?=
 =?utf-8?B?dzNHcTZFVStreFJiZ2x5S0lOTCs3ZHl0L0xzRmZCeHZwQjBEZE40ZkV0TElT?=
 =?utf-8?B?dWNjRjlnQW1zN3dKRzBROFJVSnYvRVJZUjNvdU9RK0FTeDIrZGhTRVBrbExw?=
 =?utf-8?B?Q1RHenFmTWZOMWVEOGx1cDhPQ3dwZ3dkVVhoQ3FBWmFjMVlQYmNhUE1CT1Ji?=
 =?utf-8?B?Mjc5Z0VxUmN3RE1kekdaVmRyUmN5YmNuaW1XbExBTmVUSkpEWUNnZHR5dDFU?=
 =?utf-8?B?YmVRZDFCRkhMcE1EdzI2NGRHcVUveVVwWkpzT2dpQmZxUkNINkZxWW1QWDFq?=
 =?utf-8?B?TGMzOG5GSUlnMFBOZnlpUWIxUS83bDdFNW5oL3Q4cTJJbG1jdHdRcisrYUNI?=
 =?utf-8?B?Z3M2K0Z2UldWUDg5VGFBZnFXSnhQZE1uVytHSlNYTnR4UUxUOWtxcEk4alps?=
 =?utf-8?B?RHcrb0ZuZGFSL0l5dW1TRlBUUytCUFQxd2ZXMFl1dnZ1VGtzYVA5VXJtVVhC?=
 =?utf-8?B?YzZwUnNiaFY1V0k1NHVWODlzcVBsMGU0SW90NXF1Rkw4dFB6K2lSZ00yY0xZ?=
 =?utf-8?B?bHA5Znc5RllMekVyZ3lJMlJkTmZKR0ZjWHhiallDUDZZelQwUkVuUWhMSnNa?=
 =?utf-8?B?bGZnQkJDa2ErNGdrZHMyTFY4cDZ0eEF5UHczbW1BdEQzUVBDRDdNbXRBeG0v?=
 =?utf-8?B?OURXbWFOQU9DWEt6dXUxa3VQRVhIdFM5dk0vMVhGM1g5U2s5TmN1V2NLaDh2?=
 =?utf-8?B?dlZZVDcxZHBHQmJtZVRzeWgxUElEUHBwempsQmhWWVVkY2ZKdHN1ZmVCb3lM?=
 =?utf-8?B?TjZoK2ZBaDZHWitDc2xrb2RzVEFkUUZyR1A0M3BGemlpQUliTmE0M0k4VEZ0?=
 =?utf-8?B?VHNweHpVMVdEbXg4VC80bGc3Vnc4SENYeU5DTjdsdHNJSlFiWVVRWmQ4ZE9I?=
 =?utf-8?B?OFBLM0RvZGlvY3lPeVNyYlo4WWo0TERsR0JhNjJsNk0wTHVDRVNNWXAzZmtT?=
 =?utf-8?B?My9wSmJkd2pNRjJVdlBSUlZCM2N0UDBIWGExZ3JxMlNCWWR3T3NKL2x0N1c3?=
 =?utf-8?B?b0ZTdC9BdURmODB3dUJJWVp2bnh2OUp3d3RIbkVBRGx0NlBKQm9hbGZidWto?=
 =?utf-8?B?aW03Y0RzRzZldHQxYzIvV1oxaUN5WTQ5S0hpVlljeXlRZzZTT2RxYXdteW9q?=
 =?utf-8?B?MmJ0RW5QTm0xMHZpTlV2Nm1aelpGN1B1K1F6di9hMEEwM3U2UktNQS9PUjFY?=
 =?utf-8?B?N3Y2Uy9ObVJQWHIzMnQ0L1JPclZxUFUvMUR2ZFZpdDd5M0MxTW5wVEhROER6?=
 =?utf-8?B?SS90bUtBSDNLZnRJYWpLK0h0eERBR2FjdWlTcGRSbkNVL3NhV3BSLzRRNzA5?=
 =?utf-8?B?cytvWGNyUTRrTUkwbktqTGFuTUNBb1lMTDFIRXQrcVdkeGVrRW9IVnd0b1JE?=
 =?utf-8?B?K1FjYjRkUXZIM3IxaE41WkJ1U0E1eVp1aXpzeGM4MVNabkQyQTEzQWcva1M0?=
 =?utf-8?B?QjQxU1AyQWUrK21NNS9kM1NZZGJQUWR2cC96SmRDWmlJNU1iR0ZKMjZxR2pj?=
 =?utf-8?B?YWdJY1ZRdnlSNEdiU1lmenduL29jaVV0QTBvM2dWMG5MeC9tMVdLNVV5MmRx?=
 =?utf-8?B?QkxKSFlYWERmNjJDWlFvMEkxb3lYK0VienVjd3M5bXd6VmZZbWM1dHMwU2VY?=
 =?utf-8?B?WTZyR3RuUzQ4UVpvY0xza2V6VS94RmZLYngvUE10Rnk1R3JPeHBnWE9VSng5?=
 =?utf-8?Q?2R+GbwrNhVgUBlvG0xKF+DAAwRvC5F1DWkygeVQ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d3f08f-d0a3-47f5-cc47-08d94af478a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 20:33:30.5760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6EIBVg9x3UhelEG2WoBocdWZ9JYP2E3NVXHUB8foumr3KC1wxx5Ph0vFaAE94TeAw81CTuahQB/rO08EH6XOtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1491
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5
LCBKdWx5IDE5LCAyMDIxIDE6MTggUE0NCj4gPiA+IC4uLg0KPiA+ID4gSXQgdHVybnMgb3V0IHRo
YXQgYWRkaW5nICJpbnRyZW1hcD1vZmYiIGNhbiB3b3JrIGFyb3VuZCB0aGUgaXNzdWUhDQo+ID4g
Pg0KPiA+ID4gVGhlIHJvb3QgY2F1c2UgaXMgc3RpbGwgbm90IGNsZWFyIHlldC4gSSBkb24ndCBr
bm93IHdoeSBXaW5kb3dzIGlzDQo+ID4gPiBnb29kIGhlcmUuDQo+ID4NCj4gPiBUaGUgY2FyZCBp
cyBzdHVjayBpbiB0aGUgRlcsIG1heWJlIFNhZWVkIGtub3dzIHdoeS4gSSB0cmllZCB5b3VyDQo+
ID4gc2NlbmFyaW8gYW5kIGl0IHdvcmtlZCBmb3IgbWUuDQo+ID4NCj4gPiBUaGFua3MNCj4gDQo+
IEkgZG9uJ3QgdGhpbmsgdGhlIEZXIGlzIHN0dWNrIHNpbmNlIHdlIHNlZSB0aGUgY21kIGNvbXBs
ZXRpb24gYWZ0ZXINCj4gdGltZW91dCwgdGhpcyBtZWFucyB0aGF0IHRoZSAxc3QgaW50ZXJydXB0
IGZyb20gdGhlIGRldmljZSBnb3QgbG9zdC4NCj4gDQo+ICJ3YWl0X2Z1bmNfaGFuZGxlX2V4ZWNf
dGltZW91dDoxMDYyOihwaWQgMTQxNik6IGNtZFswXToNCj4gQ1JFQVRFX0VRKDB4MzAxKSByZWNv
dmVyZWQgYWZ0ZXIgdGltZW91dCINCj4gDQo+IHRoZSBmYWN0IHRoYXQgdGhpcyBoYXBwZW5zIG9u
ICA1LjE0IGFuZCA1LjQga2VybmVscyBhbmQgdGhlIGlzc3VlIGlzDQo+IHdvcmtlZCBhcm91bmQg
dmlhIGJyaW5naW5nIHRoZSBjcHVzIG9ubGluZSwgb3IgZGlzYWJsaW5nIGludHJlbWFwLA0KPiBt
ZWFucyB0aGF0IHRoZXJlIGlzIHNvbWV0aGluZyB3cm9uZyB3aXRoIHRoZSBpbnRlcnJ1cHQgcmVt
YXBwaW5nDQo+IG1lY2hhbmlzbSwgbWF5YmUgdGhlIGludGVycnVwdCBpcyBiZWluZyBkZWxpdmVy
ZWQgb24gYW4gb2ZmbGluZSBjcHUgPw0KPiBpcyB0aGlzIGEgcWVtdS9WTSBndWVzdCBvciBhIGJh
cmUgbWV0YWwgaG9zdCA/DQoNClRoYW5rcyBmb3IgdGhlIHJlcGxpZXMhIA0KDQpUaGlzIGlzIGEg
YmFyZSBtZXRhbCB4ODYtNjQgaG9zdCB3aXRoIEludGVsIENQVXMuIFllcywgSSBiZWxpZXZlIHRo
ZQ0KaXNzdWUgaXMgaW4gdGhlIElPTU1VIEludGVycnVwdCBSZW1hcHBpbmcgbWVjaGFuaXNtIHJh
dGhlciBpbiB0aGUNCk5JQyBkcml2ZXIuIEkganVzdCBkb24ndCB1bmRlcnN0YW5kIHdoeSBicmlu
Z2luZyB0aGUgQ1BVcyBvbmxpbmUgYW5kDQpvZmZsaW5lIGNhbiB3b3JrIGFyb3VuZCB0aGUgaXNz
dWUuIEknbSB0cnlpbmcgdG8gZHVtcCB0aGUgSU9NTVUgSVINCnRhYmxlIGVudHJpZXMgdG8gbG9v
ayBmb3IgYW55IGVycm9yLiANCg0KVGhhbmtzLA0KRGV4dWFuDQo=
