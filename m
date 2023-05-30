Return-Path: <netdev+bounces-6351-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDA2715DB8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:46:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C16228116B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F9518001;
	Tue, 30 May 2023 11:46:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B0D17FE6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:46:21 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2070b.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::70b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957D310EC;
	Tue, 30 May 2023 04:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAzb65FouuWvRzwIKHn9i3iChyEJeh/HbXysxZxfoiiDfgtl9Yw4wubOKQVyqlyzZWmAWk/Ak9AhXzoeItYCqYGdrgs1Hvezug1imY++5fI8hOw6F+U40FRRfclU47ngRi9mAjbD2aM+4u8x8tkYIlNXD/VxX+hySy5Q3YLsfmliW60ZUkIpuy6QYKa6dRIC6AS8576gaunCGZo5UL072QYtdMcb31hfEKU86b2nYoqNOATzOgRe5kyQ7fP6nwh6wTYI7U/kTgBD1G9JY+U7dpFVLO/TugpvzpMsjBUk+NbJcIR2g3OUpUquKV0nd26ookrlzIrl3z/5L9fIsHYObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSM407LRWS6JliztqvtFPGRQ3gZ9UrUBY4dCn9FBFa4=;
 b=V3ASCYMWf6simiPIUYfVtlh7nhbRBHK706dBuoxWjiy2B9nQpe/f1SAXgvVJphGEjBYBXwGAf2oTYyZoufOmUQ5x2PJB10vaUwaNXUfCz33qAHF4xKAWT1tribexWw5fHU45qVF9aa7J7E69E6YqtuS9RKFYuC1J0Y2U9C8Y885wKbIdhM+3wd2zEdlZ4rEenm+PgC1xI834zT0/TM53olYnxdLu5FiXWBtJPfC/RgdSvcyCGzAMoJZ+MinU6P+wFRk7kHKzMOL2Ato7AIBgXErBwMhUM/yqP9C0UcgGhjBRcEypgt5ONKLkxJcTWOVxoIgC/jDKVbQaPuO+u1+QdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSM407LRWS6JliztqvtFPGRQ3gZ9UrUBY4dCn9FBFa4=;
 b=GGWEF4jOMWxygreEaGw6s95fRghyoub6LnJsAV6ik2mT0mBQQfWgt3y4GFO9EUYE+WO/JKc9FSMdwZrcsW5stQPOJGm8p2GuDjzL1nzrLBOEBgV8Vgp2Ip3tYRIe/tNJK7erMyhK9J3FI6dnzJ4AMskBRIC+HRlhCau0IMpaLoY=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB10307.jpnprd01.prod.outlook.com
 (2603:1096:400:1d5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:45:32 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 11:45:32 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "geert+renesas@glider.be"
	<geert+renesas@glider.be>, "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 5/5] net: renesas: rswitch: Use per-queue rate
 limiter
Thread-Topic: [PATCH net-next 5/5] net: renesas: rswitch: Use per-queue rate
 limiter
Thread-Index: AQHZkgTPigbr2NDJIU2hZvqbiDJN569ybfIAgABF0+A=
Date: Tue, 30 May 2023 11:45:32 +0000
Message-ID:
 <TYBPR01MB53415F57455DC990D5A2F799D84B9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-6-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdVsu+aZG9Vhb5fPwzR9J8uPPQ658Kz_g1hZXAzB5qi2+Q@mail.gmail.com>
In-Reply-To:
 <CAMuHMdVsu+aZG9Vhb5fPwzR9J8uPPQ658Kz_g1hZXAzB5qi2+Q@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB10307:EE_
x-ms-office365-filtering-correlation-id: 711695d5-51fa-4169-383c-08db61036007
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 GlveiduWXHm4e0jzlqmODC6JDsC93Op8tIayq69DZn3kqUAFFq5ZBfeD5rYm4m4rHLfCzrxBO3CoY8Lo5ATLCcEJnQ2EP37dpk4ehCHUmAIZKjqlqwvItu3wKgmIBNlaf6MNgj54Ty89UG9wk7TD8MfK46LpvzuWO8F+HOentX8rW7UbJTXxkftM8L5RWtK7ieRuJW2E2Hku2JZhaby57PnAbXb1DxbXKkgPe6w1gG4Gy5elbmO75fJVv8bv2fckawLRHA4NBjo0ZBCXkVFCJADnl/sBmKVU2De4CPbXeuHTBlgQc2TTFeEJDOTvmCP0zCokG38XPueQZRqjMnv8vq2MNmWXkZtR2AyYPa9Ywxd1871m04z119VI8xYzc/GrwFtMddWcn89PwKN26hIisLLVZQg70viJMgKgtVuvrNcSpxxb92hsuxQMW2GLmAHgaLegCpAAdd+0OCOpfXL0Ve+VzQQnXsoVokcWLAlAjusKRpXZdyZwfOlqHkuy7RvLSEOUIxLWaKyTBP60pzzrKjeKROcDdFYeDe6Sgsg3ubEvCh8f7HsuEwJHtCt+0saPAnkzYoV1l0PS8kn/XTDFU0MEVySp0VIV1Jz944cNxX1B38rDgVqPjmqKcVPhHRw0
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199021)(186003)(38100700002)(41300700001)(83380400001)(53546011)(6506007)(26005)(9686003)(7696005)(478600001)(54906003)(71200400001)(4326008)(6916009)(66476007)(76116006)(66946007)(122000001)(64756008)(66556008)(66446008)(55016003)(316002)(52536014)(5660300002)(8676002)(8936002)(7416002)(2906002)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cjZaR0w0ZWVhaGlWaFVRdFd4c0E3Q3dOL1FXZzYzaWhOd2FjU1pMc1J1K0FW?=
 =?utf-8?B?Q0FVRkJwT0I4Nm1oVGlZSTJTRHZINTNETXgweHIyQWNSUG1QM3pjYWp3Qlll?=
 =?utf-8?B?aXh5WTNPTEJaTG9PMk5ZT3BCRXdpeVJ0VnlZNW5OWTdEd3VFUmpTaENjMHVY?=
 =?utf-8?B?WnNNbjdFZk5SZ1pYRk1DbU1NUk9keFdUdUpndGJZeDcxT2w5K2EzNHdSZG0r?=
 =?utf-8?B?RTRqTjNFdGl6V3BNVFg2U0JSaUtmNkFBblByN0pQUEtmSnQ3K0plakZjeE02?=
 =?utf-8?B?WHVQakdNQURrYklaQy9sc240R1ExcldERFpDTmhVTy9EdXE2NGlsMUdzS1pl?=
 =?utf-8?B?RXg4TGJaakJQbEpkOWRWaVlHL3VyZGJXelY3ZUZwQktQUzFHMXFnbm9HU2tT?=
 =?utf-8?B?cHpRL1AwVjVReUk1UkRVNTliVmdMUmFKczJXYUVyazRYaWlyRys5cWNMUUhF?=
 =?utf-8?B?NmY3Ti8zNnNjdmlvYkZ0cHBBWm0zQXBhVVh4eXNIY3VndTVKQWVrOWlZYVR5?=
 =?utf-8?B?dktGSGdVNE50WlVjeHhOVjlBaDBHOWdBb0hvOUhIcGlkWnpiRVF4N1RqQVB4?=
 =?utf-8?B?WE1oZ3N2UTJUTXpZS0pwbnpPaDBXZytkMTVwWVRjdWtJT28rQ0NiSFpVdVlJ?=
 =?utf-8?B?L045eERtMkpGaVZjMGdBMGNVTGRBQ1JDRjdKQU9yUzhncVhKV1pPaWp6UUVW?=
 =?utf-8?B?WnY5NzNtcmVCeTNGa2pJeGRwcll3Vm82Q2w1cDlvcUloODdkTXhTRjhtLzJq?=
 =?utf-8?B?SWo5cGl2aWc3SFVaMzhDWGx3LzhwVS8xajl1NHJkbjVKUGo2anNDd3ZZdmRu?=
 =?utf-8?B?UWgxb1p3ejYrcldIU2VwMmlCaXhVQ1pTT1VZSHFKNk1UeHAxOWh3NjlvMmx1?=
 =?utf-8?B?TzZGR2JDeWFsMVZFWit4VER4emVjNHZnQjU5MXZoWTYzSU1hcXBmbUkrYVBY?=
 =?utf-8?B?NVpPMHlrOTVOakpDcHBRbFR2ZEljd2Z2V2JBSG5PcVIwNFdDdHdLRXJJS0Z1?=
 =?utf-8?B?cFV5S2IzWmZ6U0wyWXY5SXVnRWpwVzI3VUQyeDlVRkt6VGRjdFo0dHpLRnBr?=
 =?utf-8?B?QVFRVHFjTXNxOHZqdmptUDJYYXZ3QmVZZzdJSU1YZ3BXK0EvTEE1bHo5cGtu?=
 =?utf-8?B?ak1mbzZ1M2JJQTdmNjlicktDVlRyNll0dy9QWkNhTDlXWnJ3NkVMODByYzZz?=
 =?utf-8?B?S0xzOHFrY1htU0o2MlY0enB2KzJuNkNKUzk1R1Y5TUhETmVEYTlMSzArNEd3?=
 =?utf-8?B?NG1vTnR1Qit6SUYzUitiWWdMSGRTWm5RWlByYzBDLzFZODcwQmE4UVhmekFp?=
 =?utf-8?B?dXN5ajRzS3ZyUkw0dXpwcnJHcEY0MzNGcUxnQjNDbFU4aGh0NVh5UXBQNTRH?=
 =?utf-8?B?YWtXVUNUY3dSUlZ3OVRCamEyOGJFWjdHR1ZpUmxOU1VGU3o1UFI3Z0dLNUhw?=
 =?utf-8?B?TkEyZFFLRVlHKy9XaDhUUDd5dDVkRnZUU2xsby90Vjg5QkhQNFpvZnBFRmdN?=
 =?utf-8?B?WFhEU3lLaXgzdVdHTjR0Ynp1ejJuZVU4Q1hZT0tKNTNka24wcFpnUzBOV1VS?=
 =?utf-8?B?bEhXNlBRN2xDMk85cmNhMk9QSWhmUjV0S2pkOFpCYWNLTnFyUkxjSXpEWDZa?=
 =?utf-8?B?S2xKanZFV3I5Z0ZyREFZZUc3S2NWcE5TYzRaQXQ3ckhISnFQQkpVT1RZTk1S?=
 =?utf-8?B?clY2K2pZcWhkb01iVkZDdjh0WUp4cGlDNytSL0wxZmd0UEY3a0F1ZDNlUW5k?=
 =?utf-8?B?anRvV0E3R3RpY1MzWk83TVMwNnV3TEhzOFhIR0hHTHpMSEdLcm92V2pQMmM2?=
 =?utf-8?B?R1JyRXRqUDdNUHM3dXVwWUhPdjVIR0RweVVzVFdxOE9idFNzVnZBMXhXZHFa?=
 =?utf-8?B?NXFwZ0xEUURpN3YyWGhScG84ZVhidWx3U0Zjc09zRlVhQkc1cGhZN2Q1NHhp?=
 =?utf-8?B?R0FFTTB3Z1I2L3g4UUZ4Mng4M3dibTd0bnZQYjRzRlhXVjlSZDRUdzFMVENa?=
 =?utf-8?B?bkhBQWlGWlgvWW1TNUNwcTA5a2RYMmppV1ZkQ1Z3MmFjYXVVNW1BTXZ1V0dY?=
 =?utf-8?B?bC9abnRLK0tPUUlLVURURWMvN1hqMzZXNnhqaWYzelJLQWhZbTg0YUl1ekZK?=
 =?utf-8?B?alhBOGxMQ3VZN2tyeHNldUdabCtPWUVsNUpibndsQWc5bVhIaEh2ZFdDMk1a?=
 =?utf-8?B?ZHc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 711695d5-51fa-4169-383c-08db61036007
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 11:45:32.6430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ef7pn8DF6hC8qNO+WFi23QbB0bPiD4wk4Ix2MRtC6CHvwNKDneepBxKmq5hGPfz/kE8COibES5jWDcshE8EvVp/mojzJceA1QVPhR4i1Nghmrj/AvvDuWyATLmIIfuLT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10307
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2Rh
eSwgTWF5IDMwLCAyMDIzIDQ6MzMgUE0NCj4gDQo+IEhpIFNoaW1vZGEtc2FuLA0KPiANCj4gT24g
TW9uLCBNYXkgMjksIDIwMjMgYXQgMTA6MDjigK9BTSBZb3NoaWhpcm8gU2hpbW9kYQ0KPiA8eW9z
aGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5jb20+IHdyb3RlOg0KPiA+IFVzZSBwZXItcXVldWUg
cmF0ZSBsaW1pdGVyIGluc3RlYWQgb2YgZ2xvYmFsIHJhdGUgbGltaXRlci4gT3RoZXJ3aXNlDQo+
ID4gVFggcGVyZm9ybWFuY2Ugd2lsbCBiZSBsb3cgd2hlbiB3ZSB1c2UgbXVsdGlwbGUgcG9ydHMg
YXQgdGhlIHNhbWUgdGltZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlvc2hpaGlybyBTaGlt
b2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4NCj4gDQo+IFRoYW5rcyBmb3Ig
eW91ciBwYXRjaCENCg0KVGhhbmsgeW91IGZvciB5b3VyIHJldmlldyENCg0KPiA+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcnN3aXRjaC5jDQo+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmMNCj4gPiBAQCAtMTU2LDIyICsxNTYsMzEgQEAg
c3RhdGljIGludCByc3dpdGNoX2d3Y2FfYXhpX3JhbV9yZXNldChzdHJ1Y3QgcnN3aXRjaF9wcml2
YXRlICpwcml2KQ0KPiA+ICAgICAgICAgcmV0dXJuIHJzd2l0Y2hfcmVnX3dhaXQocHJpdi0+YWRk
ciwgR1dBUklSTSwgR1dBUklSTV9BUlIsIEdXQVJJUk1fQVJSKTsNCj4gPiAgfQ0KPiA+DQo+ID4g
LXN0YXRpYyB2b2lkIHJzd2l0Y2hfZ3djYV9zZXRfcmF0ZV9saW1pdChzdHJ1Y3QgcnN3aXRjaF9w
cml2YXRlICpwcml2LCBpbnQgcmF0ZSkNCj4gPiArc3RhdGljIHZvaWQgcnN3aXRjaF9nd2NhX3Nl
dF9yYXRlX2xpbWl0KHN0cnVjdCByc3dpdGNoX3ByaXZhdGUgKnByaXYsDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCByc3dpdGNoX2d3Y2FfcXVldWUg
KnR4cSkNCj4gPiAgew0KPiA+IC0gICAgICAgdTMyIGd3Z3JsdWxjLCBnd2dybGM7DQo+ID4gKyAg
ICAgICB1NjQgcGVyaW9kX3BzOw0KPiA+ICsgICAgICAgdW5zaWduZWQgbG9uZyByYXRlOw0KPiA+
ICsgICAgICAgdTMyIGd3cmxjOw0KPiA+DQo+ID4gLSAgICAgICBzd2l0Y2ggKHJhdGUpIHsNCj4g
PiAtICAgICAgIGNhc2UgMTAwMDoNCj4gPiAtICAgICAgICAgICAgICAgZ3dncmx1bGMgPSAweDAw
MDAwMDVmOw0KPiA+IC0gICAgICAgICAgICAgICBnd2dybGMgPSAweDAwMDEwMjYwOw0KPiA+IC0g
ICAgICAgICAgICAgICBicmVhazsNCj4gPiAtICAgICAgIGRlZmF1bHQ6DQo+ID4gLSAgICAgICAg
ICAgICAgIGRldl9lcnIoJnByaXYtPnBkZXYtPmRldiwgIiVzOiBUaGlzIHJhdGUgaXMgbm90IHN1
cHBvcnRlZCAoJWQpXG4iLCBfX2Z1bmNfXywgcmF0ZSk7DQo+ID4gLSAgICAgICAgICAgICAgIHJl
dHVybjsNCj4gPiAtICAgICAgIH0NCj4gPiArICAgICAgIHJhdGUgPSBjbGtfZ2V0X3JhdGUocHJp
di0+YWNsayk7DQo+ID4gKyAgICAgICBpZiAoIXJhdGUpDQo+ID4gKyAgICAgICAgICAgICAgIHJh
dGUgPSBSU1dJVENIX0FDTEtfREVGQVVMVDsNCj4gPiArDQo+ID4gKyAgICAgICBwZXJpb2RfcHMg
PSBkaXY2NF91NjQoMTAwMDAwMDAwMDAwMFVMTCwgcmF0ZSk7DQo+IA0KPiBkaXY2NF91bCwgYXMg
cmF0ZSBpcyB1bnNpZ25lZCBsb25nLg0KDQpJIHNlZS4NCg0KPiA+ICsNCj4gPiArICAgICAgIC8q
IEdXUkxDIHZhbHVlID0gMjU2ICogQUNMS19wZXJpb2RbbnNdICogbWF4QmFuZHdpZHRoW0dicHNd
ICovDQo+ID4gKyAgICAgICBnd3JsYyA9IDI1NiAqIHBlcmlvZF9wcyAqIHR4cS0+c3BlZWQgLyAx
MDAwMDAwOw0KPiANCj4gVGhpcyBjb250YWlucyBhbiBvcGVuLWNvZGVkIDY0LWJ5LTMyIGRpdmlz
aW9uLCBjYXVzaW5nIGxpbmsgZmFpbHVyZXMNCj4gb24gMzItYml0IHBsYXRmb3Jtcywgc28geW91
IHNob3VsZCB1c2UgZGl2X3U2NCgpIGluc3RlYWQuICBIb3dldmVyLA0KPiBiZWNhdXNlIG9mIHRo
ZSBwcmVtdWx0aXBsaWNhdGlvbiBieSBzcGVlZCwgd2hpY2ggaXMgMzItYml0LCB5b3UgY2FuDQo+
IHVzZSB0aGUgbXVsX3U2NF91MzJfZGl2KCkgaGVscGVyLg0KDQpUaGFuayB5b3UgZm9yIHlvdXIg
Y29tbWVudCEgQWZ0ZXIgSSBnb3QgZW1haWxzIGZyb20ga2VybmVsIHRlc3Qgcm9ib3QsDQpJIHJl
YWxpemVkIHRoYXQgSSBzaG91bGQgdXNlIHN1Y2ggYSBtYWNybyBoZXJlLg0KDQo+IENvbWJpbmlu
ZyB0aGlzIHdpdGggdGhlIGNhbGN1bGF0aW9uIG9mIHBlcmlvZF9wcyBhYm92ZSwgeW91IGNhbiBz
aW1wbGlmeQ0KPiB0aGlzIHRvOg0KPiANCj4gICAgIGd3cmxjID0gZGl2NjRfdWwoMjU2MDAwMDAw
VUxMICogdHhxLT5zcGVlZCwgcmF0ZSk7DQoNClRoYW5rIHlvdSBmb3IgeW91ciBzdWdnZXN0aW9u
ISBJJ2xsIGZpeCBpdCBvbiB2Mi4NCg0KQmVzdCByZWdhcmRzLA0KWW9zaGloaXJvIFNoaW1vZGEN
Cg0KPiA+ICsNCj4gPiArICAgICAgIC8qIFRvIGF2b2lkIG92ZXJmbG93IGludGVybmFsbHksIHRo
ZSB2YWx1ZSBzaG91bGQgYmUgOTclICovDQo+ID4gKyAgICAgICBnd3JsYyA9IGd3cmxjICogOTcg
LyAxMDA7DQo+ID4NCj4gPiAtICAgICAgIGlvd3JpdGUzMihnd2dybHVsYywgcHJpdi0+YWRkciAr
IEdXR1JMVUxDKTsNCj4gPiAtICAgICAgIGlvd3JpdGUzMihnd2dybGMsIHByaXYtPmFkZHIgKyBH
V0dSTEMpOw0KPiA+ICsgICAgICAgZGV2X2RiZygmcHJpdi0+cGRldi0+ZGV2LA0KPiA+ICsgICAg
ICAgICAgICAgICAiJXM6IGluZGV4ID0gJWQsIHNwZWVkID0gJWQsIHJhdGUgPSAlbGQsIGd3cmxj
ID0gJTA4eFxuIiwNCj4gPiArICAgICAgICAgICAgICAgX19mdW5jX18sIHR4cS0+aW5kZXhfdHJp
bSwgdHhxLT5zcGVlZCwgcmF0ZSwgZ3dybGMpOw0KPiA+ICsNCj4gPiArICAgICAgIGlvd3JpdGUz
MihHV1JMVUxDX05PVF9SRVFVSVJFRCwgcHJpdi0+YWRkciArIEdXUkxVTEModHhxLT5pbmRleF90
cmltKSk7DQo+ID4gKyAgICAgICBpb3dyaXRlMzIoZ3dybGMgfCBHV1JMQ19STEUsIHByaXYtPmFk
ZHIgKyBHV1JMQyh0eHEtPmluZGV4X3RyaW0pKTsNCj4gPiAgfQ0KPiA+DQo+IA0KPiBHcntvZXRq
ZSxlZXRpbmd9cywNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIEdlZXJ0DQo+IA0KPiAt
LQ0KPiBHZWVydCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBp
YTMyIC0tIGdlZXJ0QGxpbnV4LW02OGsub3JnDQo+IA0KPiBJbiBwZXJzb25hbCBjb252ZXJzYXRp
b25zIHdpdGggdGVjaG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0DQo+
IHdoZW4gSSdtIHRhbGtpbmcgdG8gam91cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIg
b3Igc29tZXRoaW5nIGxpa2UgdGhhdC4NCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAtLSBMaW51cyBUb3J2YWxkcw0K

