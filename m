Return-Path: <netdev+bounces-9100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F7C7273E8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 02:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D501F281471
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B7D7FB;
	Thu,  8 Jun 2023 00:57:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DC6622
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:57:44 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2100.outbound.protection.outlook.com [40.107.113.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B1526B6;
	Wed,  7 Jun 2023 17:57:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hi03wVDjwfWgOXCLkxKQg5WcDwk5C0XL0OZqIZpO5ittcHwyhMytDt+5ggy97nOexmnkg2LZ2kUmuoHwHCoMgXdQCW8+R8yw7/JXEBi/ZPzwDctbYe41nFpAg3oxeN19BIFvR3nbkjIMC/LejMZxFJJpPow0fHn1Ew5WDz6GpxzB2GbHPrhC6kpBD0O2Kyty5AiX1es+GFFfygpEj5bODKP+i1unx2wjtl/6n0m+TneNUswLEpi90kwax6actvS3FtMEV5gCgYPk5pqEtwTa11WMsiTVTDUgYReg24igPKXbYDNMRTH4sRv9g+F7AHRiti3BnhBJ4oA4HiIsvKW5mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uaB5xw5zAyI5GiOnqNLd0RAB7A5z1FSAIqdpHZb6FhI=;
 b=Tqy4w6l4yx/Hy+x3VWwbBoeNIYQhG9Cvw/RlvCqRFWb+rDKNiu4bS69s3Ru07V+NPSsAN2tw5/6MB8pabDIMiS2UJnY3dEzy9luy9dC2gaJAsdpjUOfDpcYyu1dKo0URbTG1gngHzJzd1CUMqDjPs0y0HEK+qFQYNqHMjrTv39Bxw35GYHqEaeTTcxkdrTRvh3G03gfsNeqODOfCMH60kVsPM3ROkAjtiipAORB2Q8CkMe7gT4KsmzAEUIN0tlFNRq5bhSVQLyyxN/DylU4Ivy5jkwmwUhEraliOxvzkkGoPr4zGyuSQA+sXUJRHcdDSY+XEYTTiuDWzvrg2Q4cskQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaB5xw5zAyI5GiOnqNLd0RAB7A5z1FSAIqdpHZb6FhI=;
 b=FukHE1vH7qQL6qSxPPLOgRF96XqdTgGUPsONPk1VngaL6SrV55VX+7DkY17hsXxBnyOoFbsXSTT5bwvPLecIZ8EflcqnGsrqiMZUIwRRnYj9/T4JbCetaTMgsaliycn6zwc3ZEhKNdavipEeCiyYNIk6bLtXMFqpyY+gCW+gsUI=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB8791.jpnprd01.prod.outlook.com
 (2603:1096:400:16b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 00:57:36 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 00:57:37 +0000
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
Thread-Index: AQHZmQ3u9rajBPpejkKoTwa3FiuSIK9/NA4AgADRuVCAAAjasA==
Date: Thu, 8 Jun 2023 00:57:37 +0000
Message-ID:
 <TYBPR01MB53412B2656A2B4756258042BD850A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com>
 <1df24847-6523-12df-2cba-f51412463347@huawei.com>
 <TYBPR01MB5341D374AC1DE6CFEE237647D850A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
In-Reply-To:
 <TYBPR01MB5341D374AC1DE6CFEE237647D850A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB8791:EE_
x-ms-office365-filtering-correlation-id: b51b42b1-def9-41c7-d899-08db67bb5a89
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 tN+jtVXm8Z9H3SXAKugc60R6Hj5sDO3gsnMqL8Rw0eKVYWHPnPb6nW5PoAGONaN+JaEapsT0WWUo/DTkYf+VRVWHrek1EXnSa1z/bGx0J9eLS017XRa0WJeMx4Sw1P6ftjbTQes9YhMNcl7sPXoaOtdAgitol7JqlTnVAKuDJe54YrnG+1v99Hs9/kYnkSil9DDw7hpmrv0W8/ZtWOBfXgWPB07Y6PjaU+eMaE68CaHL1Ok1EeFqzSnNt+t6737+HJeHDC+biZZiZdETaT/qHUB0We/ukNoZe88Rj+uhVyJij3mkgvv5/D/K5kYxGZOyZ3AOh66fR65HbHaz8Vq63TYo5UvecqYCTS1V3Ql9R9ntl78+zMgBHGwA4lIcWe3TPU8AMfBCAn0kwnvPdMCDI6FWOgMnrRd4EXwdv0Zq/L6XPKtWL2+6+/MVtL4txOyGpCyJ5PrEqcp46sYTB/Lk8F0/vuRImVMlqaWgwp2TD/WkvFpMhbivX29+o3DsUDu6vjSHFpfiHjR0Tsc1vWg+D2k6Qcojsqdn8u7mOvV+FB25eqKDQdTzcsfkYXVwspvkXdizWCS9PgvzwRLJQ6uKSyAS+EXA+q4Cu5hEhTJyarw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199021)(76116006)(8676002)(66476007)(66446008)(64756008)(66946007)(66556008)(4326008)(8936002)(107886003)(55016003)(110136005)(316002)(54906003)(41300700001)(2906002)(478600001)(5660300002)(52536014)(7696005)(71200400001)(9686003)(6506007)(53546011)(33656002)(186003)(38070700005)(2940100002)(86362001)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K1dCcFZHeFZuYW02WEdJOEFjVytGRmlTWkN4WUYrYk0zWnh3Sk4rR3pNclpn?=
 =?utf-8?B?VEFtR21iOWdwdExSenYrdktxNG95c0VWNmE3d1NQLy9yTElQUEpiN1phNTVY?=
 =?utf-8?B?N2p2dUpzNTZib0hXRllpVjdzdHVzbC9vVmhTakMzSm9RZUVNYllvM2VKZ2d6?=
 =?utf-8?B?V09OVVFhMEg3WE04c0l6VkhydUNjTlYwMzlHS2tHOWpwUXBCV2dQVkxadVJQ?=
 =?utf-8?B?MTVOU3huNkJiYjU4ZFdKQWhFR0JkU081YUEvV3hVRjV0a2JnNVBqSUtZcGZt?=
 =?utf-8?B?bGw5d1lkQVlvSm1jVnRLUTBqTDB6eUk4dVh0YlFYZ2lBOXlXdmtlcjliNzJC?=
 =?utf-8?B?VmQ2a0ppcXMrWlBObDJ2UVpEczN4ZkhUZWMvZm4zSlhEcU02TFl1Mll4R2oz?=
 =?utf-8?B?ODZkOVRMdVJrS2NiZHRrb200ZHA4eGk2eTZYKzk5NkpSZWYxVW9MT0VDcHNB?=
 =?utf-8?B?c2lUdVVKbDExVnNYVXNXUnZZMXFUWWx0TEg0Sk9wY2t2UE40S3YwL3ZpeE40?=
 =?utf-8?B?MVoxbU1aWUthdE9ZcnRjVU1iYnFPTC8zcmRpWkFGaWJxMk5PcnN0a05MYjZC?=
 =?utf-8?B?bS9rVE9VdWFsQmZidkM3OUVxU2d3SG12VnE4V2pQWk5LV0VRdmE3VUl3RnpS?=
 =?utf-8?B?bzNXcEdzbU1QL3NEbjcrYVh4Y242eEVKbkV3Vm1DamphbEk0ZmE5NTFzb3p6?=
 =?utf-8?B?WDVFL0FXUkUvSS96UnkxU21XSUI2Mkg3N2JuVkdxcStnR2dPQks2S2RhQmdr?=
 =?utf-8?B?U1o1cEJYU1VpZ2ZFbEYvbHpwRitrcTBaTmZ2S3FSMnB5VlMxRExONzUyVStz?=
 =?utf-8?B?QjRDSjVDdnFZa1QrQ3ArcFQ1Vy9jMU1icllIMmZrSkRkNjFRNEtGSzRjWW5N?=
 =?utf-8?B?Rkl4ZXhIWUgwMGUvcndqSmNFWXdkUkhJQjdFTnZ5MC9JV2NhQ2x1TFFxdHFY?=
 =?utf-8?B?WGtxQ1UrMXhnaEhIN0pBVXpXVFl0RklaNEt0OVduU0tmOW5YdjZkZm43eDlZ?=
 =?utf-8?B?dWV6cU9pQzBicnppb1J2Mk4wMUxDMzZaU2cxbGd1UVNIMVF1MU5EdXRnOEFE?=
 =?utf-8?B?c1lscy81NDVGZ1B2dFkxMngvSXplSEJtQzhTWkRUMlFvU1UydFJvY2RxMWhu?=
 =?utf-8?B?b0c2eno2UitTVDIyS2lPU1A4SER3RElySE1pWm1YdzRUb2RUbVhtWnAyY2dH?=
 =?utf-8?B?djFwK0RtMHRxUkY4TVpKU0NUMU05Q3E2eWJ3YzBVTndpYTJvQ3dzeTF0WkIy?=
 =?utf-8?B?cFRHOEgyQ0hNNkN2eDNOK0N3b3ZQVFBZNGpFZkFYdlpzeGNEUjdNRzFCSG9V?=
 =?utf-8?B?U1RNNVduYXp2cmZHdU5IQVBrZXh1djFqdWJYK2t3VGRUZXpKNSt2dVhINHJB?=
 =?utf-8?B?a3M5aHJhbys0VERwWEIwUDhXYVVHWEhxVzBiTGRKSU5GNGZxRVBMVDVPV2Ir?=
 =?utf-8?B?eURCbFBnS1FNaXNicllsUDRlcDZnNmhGbDM3S0VxY1RjdEExa2hQVEJCOHli?=
 =?utf-8?B?ZGVWZkFwTWFvamVnYlJhUWliT0w3cTVVT2RwLytQS1RaanRpbXh1VU14em5o?=
 =?utf-8?B?bVdETm1wbHdjbTR5dHhuVnlYdnNWU3l0ck80MW5UL1U5VmlZa0ZnUlp3M0FS?=
 =?utf-8?B?SlgvUmR5bGhxNmI5RTVvYWpJV1J1TVFFZTY2NDhkcis3eE1wNFRSamF6RFJV?=
 =?utf-8?B?ZnkzajZEc0x5RTZoS0MxOHYzV0oya3k5TjFrQUFubExDL3hPdVJWKzNpZHh4?=
 =?utf-8?B?dEY4WGpydnorSG1wMWI5djFxQTR3SEdlMG02Rk1jNldLMnFSNWc4bXV2a2Jz?=
 =?utf-8?B?M2VvY3l5M2N5RkdWbEFNVlo1c0pvd0RCSDRmZlVITmZobnR3dzFsRlRvbnNW?=
 =?utf-8?B?N2JubWVzRm0xUVE3M3pPRjNkYWh3NHB0eGxKVmVib1JwaTVwRk1mUzNBeWp3?=
 =?utf-8?B?dFUvSnlEY1RsUVozTnpRRFNhRzBKc1d0dXo3ZGNUTTRJQXAwRU94ajVxQ3BX?=
 =?utf-8?B?cHNKYkZpamRlclBlNUJDY01VYXhOaHJRdk5oeWZuYjVkaHhFNEFuUGVsRSt5?=
 =?utf-8?B?YzBXeFVUb2FxbVROblhvTVprSnF3Q2pPSS9wSWduOTNveGxQWlNjME5HUTZE?=
 =?utf-8?B?a3dVSnJQamRybjVjTFZUazhuQU1CNzYrczBZeFU1YXAwZXRGSE5NVXZXRmxF?=
 =?utf-8?B?Zlc0eE1yWUdHOEl6TVk1d1VXN1pDY0ZLK25vUEJ2eFJGdHVQSzh2cWdjcVVq?=
 =?utf-8?B?Uzd4R2cvWnZkVWRpMmNBY1QxdkNRPT0=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b51b42b1-def9-41c7-d899-08db67bb5a89
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 00:57:37.8417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hE+qzPd+G2qISBD/EsAOt6wEhBbr/CPF5FCykoxaBgd/fr+chd35r4qFWLaAte96gAJFdWZtxfLLfBlNp2FFiCeRKAfJYbB1n+BiaCY8ZkeSQTeu9NQaG0Qq5KDsLPBh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8791
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgYWdhaW4sDQoNCj4gRnJvbTogWW9zaGloaXJvIFNoaW1vZGEsIFNlbnQ6IFRodXJzZGF5LCBK
dW5lIDgsIDIwMjMgOToyMSBBTQ0KPiANCj4gSGkgSGFvLA0KPiANCj4gPiBGcm9tOiBIYW8gTGFu
LCBTZW50OiBXZWRuZXNkYXksIEp1bmUgNywgMjAyMyA4OjI4IFBNDQo+ID4NCj4gPiBPbiAyMDIz
LzYvNyAxNTowMSwgWW9zaGloaXJvIFNoaW1vZGEgd3JvdGU6DQo+ID4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3Jzd2l0Y2guYw0KPiA+ID4gaW5kZXggYWFjZTg3MTM5Y2VhLi4wNDlhZGJm
NWE2NDIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jz
d2l0Y2guYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNo
LmMNCj4gPiA+IEBAIC00MjAsNyArNDIwLDcgQEAgc3RhdGljIGludCByc3dpdGNoX2d3Y2FfcXVl
dWVfZm9ybWF0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiA+ID4gIH0NCj4gPiA+DQo+ID4g
PiAgc3RhdGljIHZvaWQgcnN3aXRjaF9nd2NhX3RzX3F1ZXVlX2ZpbGwoc3RydWN0IHJzd2l0Y2hf
cHJpdmF0ZSAqcHJpdiwNCj4gPiA+IC0JCQkJICAgICAgIGludCBzdGFydF9pbmRleCwgaW50IG51
bSkNCj4gPiA+ICsJCQkJICAgICAgIGludCBzdGFydF9pbmRleCwgaW50IG51bSwgYm9vbCBsYXN0
KQ0KPiA+ID4gIHsNCj4gPiA+ICAJc3RydWN0IHJzd2l0Y2hfZ3djYV9xdWV1ZSAqZ3EgPSAmcHJp
di0+Z3djYS50c19xdWV1ZTsNCj4gPiA+ICAJc3RydWN0IHJzd2l0Y2hfdHNfZGVzYyAqZGVzYzsN
Cj4gPiA+IEBAIC00MzEsNiArNDMxLDEyIEBAIHN0YXRpYyB2b2lkIHJzd2l0Y2hfZ3djYV90c19x
dWV1ZV9maWxsKHN0cnVjdCByc3dpdGNoX3ByaXZhdGUgKnByaXYsDQo+ID4gPiAgCQlkZXNjID0g
JmdxLT50c19yaW5nW2luZGV4XTsNCj4gPiA+ICAJCWRlc2MtPmRlc2MuZGllX2R0ID0gRFRfRkVN
UFRZX05EIHwgRElFOw0KPiA+ID4gIAl9DQo+ID4gPiArDQo+ID4gPiArCWlmIChsYXN0KSB7DQo+
ID4gPiArCQlkZXNjID0gJmdxLT50c19yaW5nW2dxLT5yaW5nX3NpemVdOw0KPiA+ID4gKwkJcnN3
aXRjaF9kZXNjX3NldF9kcHRyKCZkZXNjLT5kZXNjLCBncS0+cmluZ19kbWEpOw0KPiA+ID4gKwkJ
ZGVzYy0+ZGVzYy5kaWVfZHQgPSBEVF9MSU5LRklYOw0KPiA+ID4gKwl9DQo+ID4gPiAgfQ0KPiA+
ID4NCj4gPiBIZWxsbyBZb3NoaWhpcm8gU2hpbW9kYe+8jA0KPiA+DQo+ID4gRG9lcyB5b3VyIGZ1
bmN0aW9uIHNldCB0aGUgbGFzdCBkZXNjcmlwdG9yIHRvIGhhcmR3YXJlIG9uIGluaXRpYWxpemF0
aW9uLCBidXQgbm90IGF0IG90aGVyIHRpbWVzPw0KPiANCj4gVGhlIGxhc3QgZGVzY3JpcHRvciBp
bml0aWFsaXphdGlvbiBpcyBuZWVkZWQgYXQgdGhlIGZpcnN0IHRpbWUuIFNvLCBhZnRlciB0aGUg
aW5pdGlhbGl6YXRpb24sDQo+IHRoZSBsYXN0IHNldHRpbmcgd2lsbCBub3QgcnVuIGFueW1vcmUu
DQo+IA0KPiA+IEkgdGhpbmsgcnN3aXRjaF9nd2NhX3RzX3F1ZXVlX2ZpbGwgc2hvdWxkIGJlIGlt
cGxlbWVudGVkIGluIGEgc2VwYXJhdGUgZnVuY3Rpb24sDQo+ID4gbm90IHVzZSB0aGUgJ2xhc3Qn
IGRpc3Rpbmd1aXNoIHRoZSBsYXN0IGRlc2NyaXB0b3IuDQo+IA0KPiBJIGdvdCBpdC4gSSdsbCBt
b2RpZnkgdGhpcyBwYXRjaCBvbiB2My4NCj4gDQo+ID4gQnV0IGlmIGl0IHNob3VsZCBiZSBzZXR0
aW5nIGV2ZXJ5IGN5Y2xlLCBJIHRoaW5rIHJzd2l0Y2hfZ3djYV9xdWV1ZV9leHRfdHNfZmlsbCBz
aG91bGQNCj4gPiBjaGVjayBpZiB0aGUgZGVzY3JpcHRvciBpcyB0aGUgbGFzdCBpbiB0aGUgcXVl
dWUgYW5kIHNldCB0aGUgTElOS0ZJWCBmbGFnLg0KPiANCj4gVGhhbmsgeW91IGZvciB0aGUgY29t
bWVudC4gVGhlIGxhc3QgZGVzY3JpcHRvciBzaG91bGQgbm90IGJlIHNldHRpbmcgZXZlcnkgY3lj
bGUuDQo+IFRvIGltcGxlbWVudCB0aGUgY29kZSBmb3IgY29uc2lzdGVuY3ksIEkgdGhpbmsgdGhh
dCBJIHNob3VsZCBhZGQgcnN3aXRjaF90c2Rlc2NfaW5pdCgpDQo+IHJzd2l0Y2hfZ3djYV9xdWV1
ZV9mb3JtYXQoKSBsaWtlIHJzd2l0Y2hfdHhkbWFjX2luaXQoKSBhbmQgcnN3aXRjaF9nd2NhX3F1
ZXVlX2Zvcm1hdCgpDQoNCkFib3V0IHRzX3F1ZXVlLCBpdCBpcyBzaW1pbGFyIHdpdGggbGlua2Zp
eCwgbm90IHR4ZG1hYy4gU28sIG5vdyBJJ20gdGhpbmtpbmcgdGhhdCBtb2RpZnlpbmcNCnRoZSBy
c3dpdGNoX2d3Y2FfdHNfcXVldWVfYWxsb2MoKSBpcyBzdWl0YWJsZS4NCg0KQmVzdCByZWdhcmRz
LA0KWW9zaGloaXJvIFNoaW1vZGENCg0KPiBCZXN0IHJlZ2FyZHMsDQo+IFlvc2hpaGlybyBTaGlt
b2RhDQo+IA0KPiA+ID4gIHN0YXRpYyBpbnQgcnN3aXRjaF9nd2NhX3F1ZXVlX2V4dF90c19maWxs
KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiA+ID4gQEAgLTk0MSw3ICs5NDcsNyBAQCBzdGF0
aWMgdm9pZCByc3dpdGNoX3RzKHN0cnVjdCByc3dpdGNoX3ByaXZhdGUgKnByaXYpDQo+ID4gPiAg
CX0NCj4gPiA+DQo+ID4gPiAgCW51bSA9IHJzd2l0Y2hfZ2V0X251bV9jdXJfcXVldWVzKGdxKTsN
Cj4gPiA+IC0JcnN3aXRjaF9nd2NhX3RzX3F1ZXVlX2ZpbGwocHJpdiwgZ3EtPmRpcnR5LCBudW0p
Ow0KPiA+ID4gKwlyc3dpdGNoX2d3Y2FfdHNfcXVldWVfZmlsbChwcml2LCBncS0+ZGlydHksIG51
bSwgZmFsc2UpOw0KPiA+ID4gIAlncS0+ZGlydHkgPSByc3dpdGNoX25leHRfcXVldWVfaW5kZXgo
Z3EsIGZhbHNlLCBudW0pOw0KPiA+ID4gIH0NCj4gPiA+DQo+ID4gPiBAQCAtMTc4MCw3ICsxNzg2
LDcgQEAgc3RhdGljIGludCByc3dpdGNoX2luaXQoc3RydWN0IHJzd2l0Y2hfcHJpdmF0ZSAqcHJp
dikNCj4gPiA+ICAJaWYgKGVyciA8IDApDQo+ID4gPiAgCQlnb3RvIGVycl90c19xdWV1ZV9hbGxv
YzsNCj4gPiA+DQo+ID4gPiAtCXJzd2l0Y2hfZ3djYV90c19xdWV1ZV9maWxsKHByaXYsIDAsIFRT
X1JJTkdfU0laRSk7DQo+ID4gPiArCXJzd2l0Y2hfZ3djYV90c19xdWV1ZV9maWxsKHByaXYsIDAs
IFRTX1JJTkdfU0laRSwgdHJ1ZSk7DQo+ID4gPiAgCUlOSVRfTElTVF9IRUFEKCZwcml2LT5nd2Nh
LnRzX2luZm9fbGlzdCk7DQo+ID4gPg0KPiA+ID4gIAlmb3IgKGkgPSAwOyBpIDwgUlNXSVRDSF9O
VU1fUE9SVFM7IGkrKykgew0KPiA+ID4NCg==

