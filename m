Return-Path: <netdev+bounces-9093-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A314A7273A6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 02:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 009881C20E90
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C80628;
	Thu,  8 Jun 2023 00:20:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F3D623
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:20:37 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2131.outbound.protection.outlook.com [40.107.114.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5352128;
	Wed,  7 Jun 2023 17:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXOcxHvL2kS+P3kk6drmlsf0iPxWXTpLw8P8Nz7W5KNKW/Ft4ePF8aoh1hBByjRG921avz22YxOXVZ61/jaeHgY7zeB1OiYYCdikpTfoz89hdAe3D9RcQT2DiE6xExmauTCotyVeC2nD6Yu65cK3KcytCF3KkVO1rRvTsxi3FUw7Qz0QFtHQUmiCdHt5D822c5VUOiF5/KuIc1+4KUG/q7jGozF/B2wgbaRXnJUYtX1DWwmK9OQ7bBWih1Q2su+Ni8Ln/qkQ2Od5rbW6I0ZyDMFtvcB5Jbe2uHemnnM+o6/lLWR2O+oFiPkpt5AwN/VLWCv8iddjOfxyEBDDnvlhHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2e5wKCH16Uk+/NfiJE6RqNC59OYxtPJQlKdsovdNCPg=;
 b=IaFo02jHKmcuJfAZSCTlSx4NqeCtUAumfz1fkq+XgXhjRtQ/vzo5Q+2Kxy86jiyBRkju1U3gTHpATDSfBs+bKX9sfkNEhrQFgu+T5fbPjW6C9jriDTbrTt2CqJYAfMeE0ZQ77ajnn01yDxRXL+x46IwmlMUijlctwI5dXXjezazld5YEiBch1ujll29kA4E93bwYHM4NpnuX+rBlNBJI8xRDtsMfBOmKbz6FGWrL+wAQSKcQn4JC0ap50nG3GjRwCT5UAEY+ZR8RNyOt6tNeLgaWr9VBfnATirr0sDZoP4XftjrW0JNpWqU/uPJXzrD2FHeLMxX388799XHZCf06Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2e5wKCH16Uk+/NfiJE6RqNC59OYxtPJQlKdsovdNCPg=;
 b=ZXlIxQRHIGQjCNWeIvARaNcFT7Iiknv0nspbfamwa+aYKucRiK27nrAH5ZoBgrHTaIyKY9yELSoLBXWOjfM7qEGja8+z6wzgxBvzV/YMS7nN1A4QlGSNTOvKsFpVpaxwVF2p43k720MawG+Rx4qBcEX46LEtPHhcDLVX7bPwtJ0=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB10511.jpnprd01.prod.outlook.com
 (2603:1096:400:308::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Thu, 8 Jun
 2023 00:20:34 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 00:20:33 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Hao Lan <lanhao@huawei.com>, "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>,
	Phong Hoang <phong.hoang.wz@renesas.com>
Subject: RE: [PATCH net v2] net: renesas: rswitch: Fix timestamp feature after
 all descriptors are used
Thread-Topic: [PATCH net v2] net: renesas: rswitch: Fix timestamp feature
 after all descriptors are used
Thread-Index: AQHZmQ3u9rajBPpejkKoTwa3FiuSIK9/NA4AgADRuVA=
Date: Thu, 8 Jun 2023 00:20:33 +0000
Message-ID:
 <TYBPR01MB5341D374AC1DE6CFEE237647D850A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com>
 <1df24847-6523-12df-2cba-f51412463347@huawei.com>
In-Reply-To: <1df24847-6523-12df-2cba-f51412463347@huawei.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB10511:EE_
x-ms-office365-filtering-correlation-id: 83a4913d-000e-475b-04b0-08db67b62d00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Yjk5XZpYhkgQUxtyCX6ONt6vfaUn41XlCdILE5iFIxf/Hn2SCYkYvRNqXcfD2Ba4f1qpJ+H6a9V34xqQnWW8zM+rFLdtiTDQi4YBuy6957zsRxDL0zkM9NuCtaea4OLAdM90zG+myTQM5Oy4TStQH1O1mxNzpTVI5TY44q9cWAVRgLVKjAZPBrNKDVV/0qkJTNwi78ljlmGIZbz6oeRWszb5dvexESphFLkd5RD63DtofIDz2hsANa7R8w7TJ2U2GH3fb45tgyIIvwa5drlT1daBqPk6M4vQFkHBJ62SV6l9nMDJfKkqEVPRKaz8nayrTn6dQUkFvvU0s9UrOCtAMTqVc8oBRuxBt6RYmacn5rrTC0dvpAjKK7f/hZs9nd2cDATdL23PZXZwLil8dovuJm/iqI2/OdVX2nK9hlY3JlCvn3hPbQaxrq5kDc2yL4kl6kgLEb9QSf8tAzvwaeFLC7go6sNSbkXecWS+RdORmjl0sBr2vKtm3rohYYwZZY4nlJno2Svy5axj+pE43lGTR2zfy18Jdvnv1igf95LlW9sL1dwARlH99ISh7P2VULOSqH6AQ6kNU5pXlKao3iKU7ifWHejbNz7pKzE0SkunzZA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199021)(186003)(478600001)(71200400001)(38070700005)(6506007)(53546011)(9686003)(55016003)(8936002)(86362001)(107886003)(4326008)(66556008)(316002)(122000001)(66476007)(64756008)(76116006)(7696005)(66946007)(66446008)(5660300002)(2906002)(33656002)(52536014)(41300700001)(8676002)(38100700002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cmFKMWZOaUQwc0R3bXRGVDlJbFFmUlJKRUdwQTZOcVJQUHJuc2syM25rSThW?=
 =?utf-8?B?azN3djREM2VmdVZITFpMTlQ4VWJ0Y0ltMmY1TlhtSUpFWnhJUG1HVzNCRFJr?=
 =?utf-8?B?b2VibXRUbjRpOE0wb3laSy9mdjF5QlBJQzh4clhDMGVRR2NheTZzcU9ndURo?=
 =?utf-8?B?TGRHNXpORVlOWDZYVU95cEFEdjR4SzB0VGVpa1Uxc3N5T2h1NjVYSUxQVUtx?=
 =?utf-8?B?Y2pNSlM5VVpGQWoxUWRGYTlZVEJhT01NYitIMnkwS2ZGSEd0K1krME5ocld3?=
 =?utf-8?B?dnR0MDFZNnVRV1RaeW5ud1JEWFBPMzc4N0l4bEV0MmpTYzFoZm81L21DWjRy?=
 =?utf-8?B?Rms3NldTSkpld3kxb3hYSWo4ejVOZ09QbWhmSnFKN1FKS0gzT0xRdUJBRHlq?=
 =?utf-8?B?aHNEejlSeFdXYTh4cHdreVRxeWZqL0p6bXhINE8xR053bVdUdFYyV2pqQjQ2?=
 =?utf-8?B?eGw3Z0ZVbHFMcERpQWE0N3lnK1FvbUpid0h4L2JXQkNQMGdMWU9kZUxPVjU4?=
 =?utf-8?B?TmdRSTR0RTJOdVVCRnRxSmxnOUpjdVJMU2VONURwMG9jd3NQMlZqdEJtdGl6?=
 =?utf-8?B?eXNpRHJBNG5RSlBUeThLNE1kdHU3UjU5MHFkS01wQktXdlVGWjVJNzdoK3FM?=
 =?utf-8?B?aFlOVEZMelhzS0dxeU5oMHkwV001TTY3REp3dUlSVDJiemo3Mk9qUHdnZEJp?=
 =?utf-8?B?S2c4VXY5S3oyUmJyTXBLclVNdkc4cDdTd1NrQTZxa3BHeEwyVFJSVHd3SDlG?=
 =?utf-8?B?Zm5SUkNQb0IwbTZVdlF1amZURm5NelVMR080QUhmU20wZ1RoZGF0SWhybzZY?=
 =?utf-8?B?QXZFOEFwbTJOYWl0ZGZxcmpUQ2YvS2NVeWl4OHhXODBWTzc2WDVqL2luQ3FX?=
 =?utf-8?B?SjltZ0d0elBOWkVEZVhRa2p1Y1FQemR3ZERtTEE5c2dSVDhNMTFoYWFDbEZr?=
 =?utf-8?B?WFNzWmt3Z1RvN2lJOWRuWjNWUDRwMmxnQ09YUkxCNGNNZ0F2ZXFsNDd2UEdQ?=
 =?utf-8?B?UTZLL290V0lSUCs5SlJWOFRWMXg0MmpvVDFCelpWQmo3Wk56MTFva0NnWnFV?=
 =?utf-8?B?SER4b0kvUWpuRUdTY2t1ZUhEbDNCNjFmQzlCS3F4dG8wZCs2eDRLbkVjOFZs?=
 =?utf-8?B?OGR4a2NySmc2RXBxUmJFUjFVRDEwQ1VGUTZWaFdXY09KT21uTWpqRG56NUpn?=
 =?utf-8?B?di9hVVlyK2pUVUI3SVVmNnd4d0JiVGRoTDVwV1k4MWJwT0czY2ZxQ0hEN1F4?=
 =?utf-8?B?aXM0TXkwbno1TGRzNzdLdCtZdnR4SkZzejg5V1pvS245VjUxQ3FzV3BaeDgx?=
 =?utf-8?B?TEhkVWxlL2RicytYOWdwQW14b2NtdFlXbnhxOVJneW1uQ2tpQ2xha1NSaWVP?=
 =?utf-8?B?QnV6WURNZnZiMVkzUjBFSTFoVnQzQWJkK203RmQ4dGs2QzdubnhVaVBaRm9v?=
 =?utf-8?B?d0hIVlFpS2QzemlPT2doNDFndFV0QmxNV25qUzdzTFltazVXeG9leWxDemxj?=
 =?utf-8?B?U2NsS0w5dWdkdGlPQkgzTW1pMFgwTEpCZGt1VGgrVXFlS1dMYXVELzZ3OGpR?=
 =?utf-8?B?NEUxVU5Oc3RONmpkamJqSFlrZks5dlBQVWJkM2VTTWcyYURHT1pYWnQ1Q2E4?=
 =?utf-8?B?V2RGcmZLUkZxalVzQTBwT01LeURJOFlBaFpiMzU2UGRrVlRySWhEcEl0dUt3?=
 =?utf-8?B?dHB2TFBLN1ZQQ0s2b2JpTVc1QXBJeXFFYU1LRHlCVGJTRDM3NmxSZUJzb0Vn?=
 =?utf-8?B?T3NNUG1TNEJsbUNRYlNPYTI0eUt1OVRDajh4WXhjbWJvbUZvSS9XanN1SlR3?=
 =?utf-8?B?bXZPZGp3aEVEeXpNNGZ4a3VYem4yYkFDTCs1UWd5S0g5cWRIUU1HQktRaWNa?=
 =?utf-8?B?VjFLWHlWdThpVU5EdE1jbFhMNFdDWlh5WmtlZ0RmbXdnNjlDNGFqeDJ2bVFP?=
 =?utf-8?B?Q1FiVEIyd2Z0Nm5HRGJEdzl2MnBSVzZYYTV6R0NVa05JWjFBTHg1WloyZ2p2?=
 =?utf-8?B?UUZzR2pKeVZDUy9vNnF1Z0hDWm9FcXFlTE8xemlIS3l2MnBzWEE2U25yc3di?=
 =?utf-8?B?NDJpT1c1ZFNKTENNNDVldWVaZ0Z3RjVJMVZhVmJWRGY3VG9EallObEIzYzRz?=
 =?utf-8?B?N0hMSERxTUtsKzBGRyt5azY4a1d3S3d6clY1dnp5c0NLbEc0Snl1d0VSV2kv?=
 =?utf-8?B?b1BWT0JFREQ2WXVLOS9hTGs4NG54NzQwUUd5QlFUdWM5YWJxRStWelNaQU4v?=
 =?utf-8?B?eUthTmtPYzQvQnVNY0NFM3Y1U1lBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a4913d-000e-475b-04b0-08db67b62d00
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 00:20:33.9647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qXrCtn3ncCEKd6gb2sXWjXAHafIxFZBCbG/MXUUYp6DyK4gGMtNzI6FIjk/xTXMb86WgEdFWzSFeTj5TG4srCaZqqcN+Z5rtovypqL/iOxZlUShWI3aL+56T0Vq4CEx5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10511
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgSGFvLA0KDQo+IEZyb206IEhhbyBMYW4sIFNlbnQ6IFdlZG5lc2RheSwgSnVuZSA3LCAyMDIz
IDg6MjggUE0NCj4gDQo+IE9uIDIwMjMvNi83IDE1OjAxLCBZb3NoaWhpcm8gU2hpbW9kYSB3cm90
ZToNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNo
LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jzd2l0Y2guYw0KPiA+IGluZGV4IGFh
Y2U4NzEzOWNlYS4uMDQ5YWRiZjVhNjQyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcnN3aXRjaC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yc3dpdGNoLmMNCj4gPiBAQCAtNDIwLDcgKzQyMCw3IEBAIHN0YXRpYyBpbnQgcnN3
aXRjaF9nd2NhX3F1ZXVlX2Zvcm1hdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwNCj4gPiAgfQ0K
PiA+DQo+ID4gIHN0YXRpYyB2b2lkIHJzd2l0Y2hfZ3djYV90c19xdWV1ZV9maWxsKHN0cnVjdCBy
c3dpdGNoX3ByaXZhdGUgKnByaXYsDQo+ID4gLQkJCQkgICAgICAgaW50IHN0YXJ0X2luZGV4LCBp
bnQgbnVtKQ0KPiA+ICsJCQkJICAgICAgIGludCBzdGFydF9pbmRleCwgaW50IG51bSwgYm9vbCBs
YXN0KQ0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgcnN3aXRjaF9nd2NhX3F1ZXVlICpncSA9ICZwcml2
LT5nd2NhLnRzX3F1ZXVlOw0KPiA+ICAJc3RydWN0IHJzd2l0Y2hfdHNfZGVzYyAqZGVzYzsNCj4g
PiBAQCAtNDMxLDYgKzQzMSwxMiBAQCBzdGF0aWMgdm9pZCByc3dpdGNoX2d3Y2FfdHNfcXVldWVf
ZmlsbChzdHJ1Y3QgcnN3aXRjaF9wcml2YXRlICpwcml2LA0KPiA+ICAJCWRlc2MgPSAmZ3EtPnRz
X3JpbmdbaW5kZXhdOw0KPiA+ICAJCWRlc2MtPmRlc2MuZGllX2R0ID0gRFRfRkVNUFRZX05EIHwg
RElFOw0KPiA+ICAJfQ0KPiA+ICsNCj4gPiArCWlmIChsYXN0KSB7DQo+ID4gKwkJZGVzYyA9ICZn
cS0+dHNfcmluZ1tncS0+cmluZ19zaXplXTsNCj4gPiArCQlyc3dpdGNoX2Rlc2Nfc2V0X2RwdHIo
JmRlc2MtPmRlc2MsIGdxLT5yaW5nX2RtYSk7DQo+ID4gKwkJZGVzYy0+ZGVzYy5kaWVfZHQgPSBE
VF9MSU5LRklYOw0KPiA+ICsJfQ0KPiA+ICB9DQo+ID4NCj4gSGVsbG8gWW9zaGloaXJvIFNoaW1v
ZGHvvIwNCj4gDQo+IERvZXMgeW91ciBmdW5jdGlvbiBzZXQgdGhlIGxhc3QgZGVzY3JpcHRvciB0
byBoYXJkd2FyZSBvbiBpbml0aWFsaXphdGlvbiwgYnV0IG5vdCBhdCBvdGhlciB0aW1lcz8NCg0K
VGhlIGxhc3QgZGVzY3JpcHRvciBpbml0aWFsaXphdGlvbiBpcyBuZWVkZWQgYXQgdGhlIGZpcnN0
IHRpbWUuIFNvLCBhZnRlciB0aGUgaW5pdGlhbGl6YXRpb24sDQp0aGUgbGFzdCBzZXR0aW5nIHdp
bGwgbm90IHJ1biBhbnltb3JlLg0KDQo+IEkgdGhpbmsgcnN3aXRjaF9nd2NhX3RzX3F1ZXVlX2Zp
bGwgc2hvdWxkIGJlIGltcGxlbWVudGVkIGluIGEgc2VwYXJhdGUgZnVuY3Rpb24sDQo+IG5vdCB1
c2UgdGhlICdsYXN0JyBkaXN0aW5ndWlzaCB0aGUgbGFzdCBkZXNjcmlwdG9yLg0KDQpJIGdvdCBp
dC4gSSdsbCBtb2RpZnkgdGhpcyBwYXRjaCBvbiB2My4NCg0KPiBCdXQgaWYgaXQgc2hvdWxkIGJl
IHNldHRpbmcgZXZlcnkgY3ljbGUsIEkgdGhpbmsgcnN3aXRjaF9nd2NhX3F1ZXVlX2V4dF90c19m
aWxsIHNob3VsZA0KPiBjaGVjayBpZiB0aGUgZGVzY3JpcHRvciBpcyB0aGUgbGFzdCBpbiB0aGUg
cXVldWUgYW5kIHNldCB0aGUgTElOS0ZJWCBmbGFnLg0KDQpUaGFuayB5b3UgZm9yIHRoZSBjb21t
ZW50LiBUaGUgbGFzdCBkZXNjcmlwdG9yIHNob3VsZCBub3QgYmUgc2V0dGluZyBldmVyeSBjeWNs
ZS4NClRvIGltcGxlbWVudCB0aGUgY29kZSBmb3IgY29uc2lzdGVuY3ksIEkgdGhpbmsgdGhhdCBJ
IHNob3VsZCBhZGQgcnN3aXRjaF90c2Rlc2NfaW5pdCgpDQpyc3dpdGNoX2d3Y2FfcXVldWVfZm9y
bWF0KCkgbGlrZSByc3dpdGNoX3R4ZG1hY19pbml0KCkgYW5kIHJzd2l0Y2hfZ3djYV9xdWV1ZV9m
b3JtYXQoKQ0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo+ID4gIHN0YXRp
YyBpbnQgcnN3aXRjaF9nd2NhX3F1ZXVlX2V4dF90c19maWxsKHN0cnVjdCBuZXRfZGV2aWNlICpu
ZGV2LA0KPiA+IEBAIC05NDEsNyArOTQ3LDcgQEAgc3RhdGljIHZvaWQgcnN3aXRjaF90cyhzdHJ1
Y3QgcnN3aXRjaF9wcml2YXRlICpwcml2KQ0KPiA+ICAJfQ0KPiA+DQo+ID4gIAludW0gPSByc3dp
dGNoX2dldF9udW1fY3VyX3F1ZXVlcyhncSk7DQo+ID4gLQlyc3dpdGNoX2d3Y2FfdHNfcXVldWVf
ZmlsbChwcml2LCBncS0+ZGlydHksIG51bSk7DQo+ID4gKwlyc3dpdGNoX2d3Y2FfdHNfcXVldWVf
ZmlsbChwcml2LCBncS0+ZGlydHksIG51bSwgZmFsc2UpOw0KPiA+ICAJZ3EtPmRpcnR5ID0gcnN3
aXRjaF9uZXh0X3F1ZXVlX2luZGV4KGdxLCBmYWxzZSwgbnVtKTsNCj4gPiAgfQ0KPiA+DQo+ID4g
QEAgLTE3ODAsNyArMTc4Niw3IEBAIHN0YXRpYyBpbnQgcnN3aXRjaF9pbml0KHN0cnVjdCByc3dp
dGNoX3ByaXZhdGUgKnByaXYpDQo+ID4gIAlpZiAoZXJyIDwgMCkNCj4gPiAgCQlnb3RvIGVycl90
c19xdWV1ZV9hbGxvYzsNCj4gPg0KPiA+IC0JcnN3aXRjaF9nd2NhX3RzX3F1ZXVlX2ZpbGwocHJp
diwgMCwgVFNfUklOR19TSVpFKTsNCj4gPiArCXJzd2l0Y2hfZ3djYV90c19xdWV1ZV9maWxsKHBy
aXYsIDAsIFRTX1JJTkdfU0laRSwgdHJ1ZSk7DQo+ID4gIAlJTklUX0xJU1RfSEVBRCgmcHJpdi0+
Z3djYS50c19pbmZvX2xpc3QpOw0KPiA+DQo+ID4gIAlmb3IgKGkgPSAwOyBpIDwgUlNXSVRDSF9O
VU1fUE9SVFM7IGkrKykgew0KPiA+DQo=

