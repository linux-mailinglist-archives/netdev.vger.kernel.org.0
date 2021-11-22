Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F7A4587E7
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 03:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhKVCK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 21:10:28 -0500
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:38004
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229594AbhKVCK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 21:10:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jkj3zNGUj3iFs5ZRTAF41eARZocNkv69/VbAXUPZtFoqCmMEuVzJSyT3Zypp/y/0ayPsh3tcL+18BytUdrBFH4FSgpvqCbhxFXoEHhq0xNglCgYoRxwHP9Oj3dlTlrTAdQNWbbGi+jLG6gUy0tAGXVY4kdHrNz4TtTsFL/I+NrY/DD9WbEO2uTgiP8mnex2Heh8XIE2duMRwX56OHz4fgoTYgtg3LCvntvTyZRW/BLgnqTAw7H3kYCQ33PgCIOPB3ppWG1DdFzx+UeA70el01Z46i+zg82K2utAkszmO1NH4HTARbJt3+dli/rE1PAsLcF+GMMvLoA63bUOTcVcz4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyHzuuoCNZ93VTXWx2xguOpd72qiPMf26Bl+tDeLgrc=;
 b=IhlnyRKn/Zsh7rq925Iy2kSJiX6xg2eMcVYPqTtHokJmiC20uf4hp8oPIAN6NQQYSoOW0wjSx4mLN6/e+pXBk47Xd3+YJBnNXSNZ6UpG0MlxU+45771Y6uYoKAH6lJszrtFkncct6hL6BTGPSPhJ12N06JWzwy3JWAsbZ919L+GIEVVuSlvaftMBCoagfSmFXVmguUDU+qx387qVE7A+yJ3GjrwkE1Yd1FMN1biBVe9o5Eojy5Fr/7l8ODKscfi64uPvuOKx9KTs6xlWf3F3hXh1qWgwQGn1zO3FEiHzy56tDL/nlbwcIsUJ9n7EOOq+dqs6gcsCPkY5YgVuUr0Uug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyHzuuoCNZ93VTXWx2xguOpd72qiPMf26Bl+tDeLgrc=;
 b=JYNu18u7jK7Hg/9tJDJ0GmMfZeRKeOUrQb2Yc302KuqaPFt2qa2qkEhj3Bg2KjumEOanjvADRO7n6H3zx42YpTKhPsGD0Qve0DgH/OQHpRqEUTNagZcC6HhcNvYZWs16yeCXaErC1T079ot0pO9hrqhDPQoAcxbkYwK4cRN4RoU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8429.eurprd04.prod.outlook.com (2603:10a6:10:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Mon, 22 Nov
 2021 02:07:18 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 02:07:18 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>, Peng Fan <peng.fan@nxp.com>
Subject: RE: [PATCH 1/4] dt-bindings: net: fec: simplify yaml
Thread-Topic: [PATCH 1/4] dt-bindings: net: fec: simplify yaml
Thread-Index: AQHX3gYPxfkSynkPv0KAVqfC2LReCawOxhvQ
Date:   Mon, 22 Nov 2021 02:07:18 +0000
Message-ID: <DB8PR04MB6795E60F4D2CED35569CBFA7E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-2-peng.fan@oss.nxp.com>
In-Reply-To: <20211120115825.851798-2-peng.fan@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50b5aed5-da54-44ea-611d-08d9ad5ccfe5
x-ms-traffictypediagnostic: DB9PR04MB8429:
x-microsoft-antispam-prvs: <DB9PR04MB84291CD9AE6F3DA6896F2E43E69F9@DB9PR04MB8429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Iwm+Co8QHNInfu7LQEgVTfQTLFiAnlP6BVgdoG4tZOyU5ygf+GKrrxnQU4tt9obDH9l3a8DKriGawdgkkAIaPFJkHpxuUk2pNjnv3qrO87nOMQfIB2YnU73kc4sV1b9pfj+GKas4KA+L6xEqg+CBaBkkUcOizaPAg3dE9jXYcvv90zSpY3Pbui8O6LJ197FkyY33QUmfoIzpssESOJrKu1uvxZQFlS3bCvm4ItQNV4UB63fl6YsM9ekIkFognkvtru39NIH8nqOD5lIHBrkjC871YOBtk1wJJZjIacWf+YgRcKaP9ZPrCSQwJOg9quzulY7CR7SOIGp9ENV+SmWM7TqQObNVW+rP+X5DTuKppxdQZojniOL4OWRrRilNxXKC5Vp77qV24LMv/jZLlGdb2BP4uDYUoZBX4crAVjpKGGrTI1gqhy2+KNKOHaA6UWJkq/BM657Y5W15tydvUklk9wR0vxESwfV1fQA2hUOh6kv5kEzAzfTqLJDdsQo6godGp53R/h7R4k8OhMfXgQTIrBh51w7CQevuIBN3DklSTU0pwY4eEqD5fSy5hMgDs1Vm6ll0BkdYPNvxHs9DGaR7ATyKfzAjGrvgR9bidPWCB301x4keZMiYzmFQ0+h3blrP8fnUauF6+sEqG9aq5rGHcBs5I2YRo8JgVerT2R36IaR/9YSBUk6pl/WxGLq+a7gF2keqyHnZwXi0D7tPYainOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6506007)(53546011)(66946007)(110136005)(316002)(55016002)(7416002)(7696005)(9686003)(5660300002)(76116006)(54906003)(2906002)(66556008)(71200400001)(66446008)(66476007)(64756008)(122000001)(4326008)(83380400001)(38100700002)(186003)(52536014)(8936002)(38070700005)(508600001)(26005)(33656002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?SUlMayszeG84NFZSdC9iOE4wRGNIcTBmVnJVVWhNcVg0S2dzYUpxVkdDZzNG?=
 =?gb2312?B?S1BNS3pOWWp1RDUrVEt4Q3p0TW5PY2V2ek5SUzNtbzdpUjczOU90UFpoblBi?=
 =?gb2312?B?MFlBaFhrVy9vcGQ4UHc0RkZQT3BVbk1YSXp2RFNPUUNIWjRFaExOWXI5RGFa?=
 =?gb2312?B?MFdVYmcwUHVNR2FzZ3Z6bVVDVEdYYmcxeWM3V3pDM2FTNFhTWWZBMnlRTk1S?=
 =?gb2312?B?UDYzTy8vZlVUWnlKelhESVBDd3NDZ1k0dmIvaDhpc041QmR0T0VkeDlxcEZR?=
 =?gb2312?B?Sit2M3pveG8vakk1K2k0WUlUSXB2VmdaaE9RekRwc2VZSyt1RmNuWlFmL0xJ?=
 =?gb2312?B?TG83YXVjK0F1MVQrU0RNUmFsUjlMWWJoU2ZxYUlOZ3Zydm1ka3JSM25kQ2ZZ?=
 =?gb2312?B?RWxXekZDNG5QMno2QjFNemxyUC9sNnB0NkhyK29mNTJyM0RmTzJrcGYxZGpL?=
 =?gb2312?B?aWdxL2VEUkhQS0FPUk5OR1dpY2Eya2VmTVZ3blpDL2lBSVNPcjdpQVJCRHJZ?=
 =?gb2312?B?UzZVTklySStidFlNR1hXUmg2K0o4WjF1QzZVK3lZT3JUejFpcE1QZWU4S0d6?=
 =?gb2312?B?THNCNmxrL2tvSWlQenJtUGtzbGc2bHpqcUlkbXNNcDcvMktmNWIzMDZFd2Z3?=
 =?gb2312?B?cXA5ckM3NloyU0VncDd0ZDRGa1YyL2NsU3JlVmJJbHJaSU1wWVNkbHB5ZWkw?=
 =?gb2312?B?TER0ZUlXaE5PWE0yWDRiOVkrZWJKYmMzVFZtWmdhQzdkV1N6b1l4QVIrdkEv?=
 =?gb2312?B?ZXdmdmo2VFhzVEI1WmVxQWEzZStLSGF6SnhYdUJ3dk1Ba3FRbWd5MWYrSHpv?=
 =?gb2312?B?dmtnWkRYaW9INDRGN0RtRGdoTXpCendKM1pYZUJQSnZnaHQ0UXhZa213dG9w?=
 =?gb2312?B?dmI4Z3oxcmhRdVlENy9jSlNXc05oS2NwR2xBanpJdC9qS1NZY29JSFFab2pa?=
 =?gb2312?B?RzdHNG5rRnFSTDlYOG52Z01pTGw0c2Z3MXNnVEdrR3lYQ2lucmJxZ3h6NGg1?=
 =?gb2312?B?ZENxb09iOGZxcmNpL2dBSXlnNG9YeDNGNDdNMVpQaWtqaEF4cGJJd3NaR0Ra?=
 =?gb2312?B?MjhEZk5TWTMza1VhaDZEY0MzbjVVbWVxTDQvSlBIZ2ZkVzEvMzlxcHRzWVZV?=
 =?gb2312?B?dEp5SUcvSFlXYjFFbndONXo3MGxBdEVlaUtyYStvQmRmSHFUZ2s0TkZ4YzRZ?=
 =?gb2312?B?OTdFaE1Bb2xLSXhISGE0NTVNRnloRUVYVUd3N0l1WmY4bWwvd25Ib2VxL2Ew?=
 =?gb2312?B?aC9kaTBVRWpyTDdOTkg2bnUzVVNMTEVYbGkzOTYzUjIwRnhxQk5EdFFCSm0r?=
 =?gb2312?B?UmxqYjc0UXBkNWlBVk9JOE81NCsyZEN0dENMTGJJcmhBdThrSTQ4ZVVLRlZk?=
 =?gb2312?B?WU1LdWNNUzhMWUphNDM3bkk2S0hEbENxa0oyanhiVmw1a2pNY3haZ1ZhSGYz?=
 =?gb2312?B?bllPbmVWZjlsUzdmNFRYVnRxOVN3aTV4UWwwaUhqdG1UR2NtMUxwamZBSURV?=
 =?gb2312?B?Uko2Rk4zaUZVRFBJZHR2d3dsV21GVjdxenRTK3ZObUNocmtaN2VOYUVMM2lS?=
 =?gb2312?B?MFF2a3hRSlFVSHJJUjdNSkVmaUN6RFF3ZitxczlXUnE3UkF0cjZJT21sRmQ5?=
 =?gb2312?B?b2VWSGVFbXFPQnl2b3F6Yi9PVzVIZ25ybS9CU0lhOE5sbG9FOWdnU1hwZlhx?=
 =?gb2312?B?VjFJWk9xWEJNdU5FREFFVTZjLytJM3I2NWNSN3pRMzcxT2FWTmdKVDlxTjRS?=
 =?gb2312?B?SHY1dXFpRXRVWENXOW5qdjBRTlR0OGpSYXNnYUpOTGx6bzVaUHhyOHlLbnhr?=
 =?gb2312?B?M1ZYVUpncEU1eTJNd1pjazlvckxoOXpUb3NsTnZST2cxaHVudmgyM3Rydjdr?=
 =?gb2312?B?UkthcnRicWxweUxMTVliU1hLYkJZVEpweHRySm9FS0tJQlF5TTBKNERubk5a?=
 =?gb2312?B?NW02QTNvbWsrbklDL2ZEVVIvT1pHSGRJY21ZTDdGdnk0dGhhNDFYVTBVRTlm?=
 =?gb2312?B?ZWNVQnRRS0tVdnpWaFlIem1ON3padkF6STVsWXZiYVluUmJ2TW1oamE5RS9j?=
 =?gb2312?B?QnhhWGxqMkEvcjBkR3lBaThKUTBlUU4wV0pYVDVRQWZCWDh0UjBEWXBnbENI?=
 =?gb2312?B?TytEZ1gxY2d4SEhKemVlRlBjeGdEL1dyM2JyOXo3QzZGMlZsejZSZVBJRlgz?=
 =?gb2312?B?R2c9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b5aed5-da54-44ea-611d-08d9ad5ccfe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 02:07:18.4346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qQSdpSCQlxAiNDRcTC9srJd8ojRobm004SJYdpEsUA7r89N7u8USd7sdYcTYhBZvqugO7V4f5XV0U3xKsWKbEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBQZW5nLA0KDQpUaGFua3MgYSBsb3QgZm9yIGhlbHBpbmcgdXBzdHJlYW0gdGhpcyBwYXRj
aCBzZXQuDQoNCkZvciB0aGlzIGNoYW5nZSwgaGF2ZSB5b3UgcnVuICdtYWtlIGR0YnNfY2hlY2sn
PyBJIHJlbWVtYmVyIHRoYXQgc3BsaXQgdGhlbSB0byBwYXNzIGR0YnNfY2hlY2sgd2hlbiBjb252
ZXJ0IGl0IGludG8geWFtbC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBlbmcgRmFuIChPU1MpIDxwZW5nLmZhbkBv
c3MubnhwLmNvbT4NCj4gU2VudDogMjAyMcTqMTHUwjIwyNUgMTk6NTgNCj4gVG86IHJvYmgrZHRA
a2VybmVsLm9yZzsgQWlzaGVuZyBEb25nIDxhaXNoZW5nLmRvbmdAbnhwLmNvbT47IEpvYWtpbQ0K
PiBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0K
PiBrdWJhQGtlcm5lbC5vcmc7IHNoYXduZ3VvQGtlcm5lbC5vcmc7IHMuaGF1ZXJAcGVuZ3V0cm9u
aXguZGUNCj4gQ2M6IGtlcm5lbEBwZW5ndXRyb25peC5kZTsgZmVzdGV2YW1AZ21haWwuY29tOyBk
bC1saW51eC1pbXgNCj4gPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsNCj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc7DQo+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgUGVuZyBGYW4g
PHBlbmcuZmFuQG54cC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCAxLzRdIGR0LWJpbmRpbmdzOiBu
ZXQ6IGZlYzogc2ltcGxpZnkgeWFtbA0KPiANCj4gRnJvbTogUGVuZyBGYW4gPHBlbmcuZmFuQG54
cC5jb20+DQo+IA0KPiBpLk1YN0QsIGkuTVg4TVEgYW5kIGkuTVg4UU0gYXJlIGNvbXBhdGlibGUg
d2l0aCBpLk1YNlNYLCBzbyBubyBuZWVkIHRvDQo+IHNwbGl0IHRoZW0gaW50byB0aHJlZSBpdGVt
cy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBlbmcgRmFuIDxwZW5nLmZhbkBueHAuY29tPg0KPiAt
LS0NCj4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLGZlYy55YW1s
IHwgOCArKy0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNiBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbmV0L2ZzbCxmZWMueWFtbA0KPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvZnNsLGZlYy55YW1sDQo+IGluZGV4IGVjYTQxNDQzZmNjZS4uZGJmNjNhOWMyYTQ2
IDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Zz
bCxmZWMueWFtbA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0
L2ZzbCxmZWMueWFtbA0KPiBAQCAtMzksOSArMzksOCBAQCBwcm9wZXJ0aWVzOg0KPiAgICAgICAg
LSBpdGVtczoNCj4gICAgICAgICAgICAtIGVudW06DQo+ICAgICAgICAgICAgICAgIC0gZnNsLGlt
eDdkLWZlYw0KPiAtICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg2c3gtZmVjDQo+IC0gICAgICAt
IGl0ZW1zOg0KPiAtICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg4bXEtZmVjDQo+ICsgICAgICAg
ICAgICAgIC0gZnNsLGlteDhtcS1mZWMNCj4gKyAgICAgICAgICAgICAgLSBmc2wsaW14OHFtLWZl
Yw0KPiAgICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg2c3gtZmVjDQo+ICAgICAgICAtIGl0ZW1z
Og0KPiAgICAgICAgICAgIC0gZW51bToNCj4gQEAgLTUwLDkgKzQ5LDYgQEAgcHJvcGVydGllczoN
Cj4gICAgICAgICAgICAgICAgLSBmc2wsaW14OG1wLWZlYw0KPiAgICAgICAgICAgIC0gY29uc3Q6
IGZzbCxpbXg4bXEtZmVjDQo+ICAgICAgICAgICAgLSBjb25zdDogZnNsLGlteDZzeC1mZWMNCj4g
LSAgICAgIC0gaXRlbXM6DQo+IC0gICAgICAgICAgLSBjb25zdDogZnNsLGlteDhxbS1mZWMNCj4g
LSAgICAgICAgICAtIGNvbnN0OiBmc2wsaW14NnN4LWZlYw0KPiAgICAgICAgLSBpdGVtczoNCj4g
ICAgICAgICAgICAtIGVudW06DQo+ICAgICAgICAgICAgICAgIC0gZnNsLGlteDhxeHAtZmVjDQo+
IC0tDQo+IDIuMjUuMQ0KDQo=
