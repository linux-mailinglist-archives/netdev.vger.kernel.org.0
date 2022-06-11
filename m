Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B1F5476C0
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 19:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiFKROf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 13:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiFKROd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 13:14:33 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90084.outbound.protection.outlook.com [40.107.9.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE93021E11;
        Sat, 11 Jun 2022 10:14:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/iVc3l9VXtxkONsoT2YAM63cE3R+e7vNImK+IUIvqmTQwhlfaEhi+llPWAEcc0gXBP61uNcEHhQf462a/ljzBpmgP0yxy94/gFsmLojaS600sY/HUGv+k4Op+sjaSIPgnM/CJdBIGXfZ+87FZNuu3ZdVm7dGGGnlaL5DNOi1H70VHUBMIoac+Er3SMCbcLlsLPcEd1IWCo9QjRJAsH3EGmAhukE+vkhY5wqKoeH3MrpeC1gVQ6hwFVfuRbXA+eB97w4CIHN3KGWqpLDR31Qsmfq2eMFeLfSMtFjnkOK7mtPnrIPnRlIvpFwumk2GBkCAxVnlZIBwjAjJ5PrHzOdlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iq/oDRsn5yxQ6vj0WAhoEzqW8R3HqhMsQLVL5h0Pm90=;
 b=bh/ogBucZ+9wy6SJhThT7mpmcukZ3SerEIlZmyJxYaJGLtxSjyT1G4frtMmL0m8ALlO5cGQt1MEVCQG2S73kDzYH3TGAEMGbHDSVX2XPKTyVda0nYfVNweEx+cJd1bNHsOZpNLybJaQHVltjDvVoQO51oqu2NIdrDlFTS+fAX0oiKtPZCh6NJey3rjhjCqbAN5gj6vgd1biDv3XhIiYQv9EktCvuEJYohzdEOvY3VcZv0j/o475/NI+LGO8cGhMXvuDQAGrRKnoL9YAD63WhRArrqv76lllohARcEDepbRJM5vTChtRLmoI3x9cywFml5vBMP3DWn+tjtM36eoMEZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq/oDRsn5yxQ6vj0WAhoEzqW8R3HqhMsQLVL5h0Pm90=;
 b=ueJ8B2iodACYcZDfw6xoFb6qQ3yCe0jKg314a8rBcLaVhBwxKJLobFCtvikLu+NvwEZwG6yJpy8Fr5jzXxc85m2z7gV1Z4+Yx3Enz5eGMkHb6jsQ01PwaMD9kVdYJ6CNRDcFrwltLv7qPdzdqCgVjGRpg1eVz0u39PmLHP5iLlzt41Qf4Y/Jg3+0B9m2liCH3TYrvu9XL0bxxuyvlR+nZeDW/NMbfZwmi2GRRSFCn4/lTc4Gucq8odnvyLLxvvholfobY9IVR077k0s/yfQeh7qOfqT/fMJT/xckhjAQYp/Q3bjP83YVA+jpwTt/MWnFB6sj3dcObTrpBmdFSM9waA==
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3d::7) by
 PAYP264MB4271.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:115::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.12; Sat, 11 Jun 2022 17:14:28 +0000
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::958f:a26:4984:ffd7]) by MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::958f:a26:4984:ffd7%7]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 17:14:28 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Hari Bathini <hbathini@linux.ibm.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>,
        Russell Currey <ruscur@russell.cc>
Subject: Re: [PATCH v2 4/5] bpf ppc32: add support for BPF_ATOMIC bitwise
 operations
Thread-Topic: [PATCH v2 4/5] bpf ppc32: add support for BPF_ATOMIC bitwise
 operations
Thread-Index: AQHYfOKhjgDYIW+cm0WJw5alsxjjLK1Kc6OA
Date:   Sat, 11 Jun 2022 17:14:28 +0000
Message-ID: <0f41cc76-a214-03c5-8764-808e5001b906@csgroup.eu>
References: <20220610155552.25892-1-hbathini@linux.ibm.com>
 <20220610155552.25892-5-hbathini@linux.ibm.com>
In-Reply-To: <20220610155552.25892-5-hbathini@linux.ibm.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40cf9165-c85d-42b1-425c-08da4bcdd7ca
x-ms-traffictypediagnostic: PAYP264MB4271:EE_
x-microsoft-antispam-prvs: <PAYP264MB4271A9D0C948F41F942D364AEDA99@PAYP264MB4271.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n+nyG7f5s2TofU4afyhM6ykXmydoLrsL5jYc0MuWPMFpjHpOHNGJZ9LMUdIw6TOXDFgp4S9FIV6ggLA5X4Yz/rJdsaYT/u3Yb6ivAP+XPKROPiYZ5xqcmNn+MxoR8Ezo/eghSieYNoo//Q8CucGToh1XVIYuqsfz6cjnL7r+cWPHPdRBjfUXST77KsTGwfjxqRaHIxcLdNqGYI93aTjOUZd03RBZxwPgH3dLDkMe+XbII2VCAhrwPQXLgeIYLWPkb1xfvfpMIvhLpk1jDv4FvJB7BsT2pr6y16D+MUp7R26M5JTdRZZnWKrsez6r8smRvgxfEq9j3QI+01lxejWFgrO0GNtvZI0sjAlw1LowvIn2Wm5NqG622Lot8D+DfkyAEzrB/5ogloKxW0GFHvcCpj4uzcj9lQqanG1eGQb1UMGOG7EFYtV6OeZNHHLEXgrAYpAxR0fqfbNNbramX4d8cCKbQ3ibyQzUq5P50I1Z8D9UB2Cyu11eqnZYGH9/+NyCUET0FVaX+S/nPVUe2acGoB63qsJv23Epi/8TJJPfsMsuNuvIsQl1avER9cePaGZs8IZLxqWjbDYH+Xr8/WNyDZC9ASxNa3GFcnfpffyFY21bCatagnYVje80ywZ7rNRR2YtT1jb+HITuiXp1ebG5hUeKBe2isJjMzd5Opwd6z3YSG3tOMfwMMBaDP4eZg8mZnYA8GqLwzF/q5knhH4ezI3T/qKmNWEZGdGOQrBrrMGx2WOQy3tHncNV9Tz/ZJOkVn5l2dI9md4szoE1M25dtvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(31686004)(8676002)(4326008)(64756008)(76116006)(91956017)(36756003)(44832011)(66446008)(66476007)(8936002)(316002)(5660300002)(66946007)(66556008)(71200400001)(6486002)(110136005)(54906003)(6506007)(2906002)(7416002)(508600001)(38070700005)(26005)(6512007)(122000001)(38100700002)(86362001)(186003)(2616005)(83380400001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEhkYW1tbWlyNm15RGVld2lRUjhHcG45M21VbldBaFdZc0JIYklPV2dacVJv?=
 =?utf-8?B?TEQ5TjlJbXUwVHR3WktHeFpoRjhpOG83dTFVVTI5dkFxc0hDcTYyZ0ZQeE9t?=
 =?utf-8?B?VzZiTEd0SFJzN21JamMyVC8wWEZIWnpGbkk0TlZkdjM0b2dyVUtjNnJMcWND?=
 =?utf-8?B?ZHdVZlEvYnBNaTZBZStWV0hNUXJIWEZKK0E0THFFd0hCZzhUSmxSYXNoZUV3?=
 =?utf-8?B?TVFySnVEU2taVFdnb3hTOGxDV3E4akxXY0JuQ256WGlUUURjTURZdjFBRE1h?=
 =?utf-8?B?M1RPNGhRUi9KUG1Ed3BRWjl4S3Nia1ZUTU9oL0g4RTY0V3I4Mzh2Q1BLTGIr?=
 =?utf-8?B?SDlaUndaNlVNUUtLYmJlKzhLV0ZSSmpSb2V2WDJtdHc5NTVENWxQTXozaE41?=
 =?utf-8?B?YWhPWDJXQ052OGdZcURKNlBpL1d6QUdJNm9mM1E1Vk05M29SNTJsOFMvQlZk?=
 =?utf-8?B?bCtIMHErSHF6dGpjdVlXc2lnVjVuRmpNNVJkZW5TSkRXV1RwMk5yb3Z4WlZj?=
 =?utf-8?B?RlM1Q3BCTzg2VG14OTB1NXhxc3pBZHpvbEEwaVgzRmlZOVJEeVQ4dVhDYWdj?=
 =?utf-8?B?UjFudE0wbU1hRmRPaUNneng5T1I4N3JrWWp4cHF0ZEhGOEpVL05BM3gyam0y?=
 =?utf-8?B?anFscHRSMGtodnRIMWpLSGMwRC9TZ3JtRmdSNGtycEFaakNxcnBOanAwT2Ra?=
 =?utf-8?B?MXRvT3VRYXo0Q2RiNzZpZlZVL0pDZVBnNFNxMnNwRkxkYi9jUFI4bGllTkJj?=
 =?utf-8?B?blFSMlNmSUVFcDNSNHhhNU54azg0YzFkbHd1RXBvcTZyY291elptdVczekFM?=
 =?utf-8?B?M2VCeVUwdmJmdkVabFgzQjQ3dERTRjdLeURTaG1MQXRpQm14eHhFb3dGN2dk?=
 =?utf-8?B?NVUxOWxyUnkrZHJrejFEdnZLN0hEL0tqa1p4RFBsMmZEZDJGUTVIdUl4aU5n?=
 =?utf-8?B?NE9abCtCMGRUSC9LR01vYkxrcGFNT09KY3ZhdnljU2xoK1FoNnRBVy9UMC9J?=
 =?utf-8?B?UURORExJeFZaYjVjN1NoZnJic0NMZ0JJTEFYeDNZMnB0aU1lOEl2MUZmL1hH?=
 =?utf-8?B?Q1FlTVlNOWppMjlZcXpXc1RRa1k3ZDBTQnZ0VmpsRHJ5UWhRQXFiamp0L3V1?=
 =?utf-8?B?cEp2R1I2TmFNbVdiS1NjRkZzWFpuV1IyOENnR0R0dzRhSEVaMEpSemh0dmlO?=
 =?utf-8?B?NjBmZWZCQTN3MVh6U1ZESEVnL0lhWEhCSFFGenpKeVZraFA5REJzUE9uS09a?=
 =?utf-8?B?dit4d2o5cXFWUTRDRm1LYURVNDcrRDBuQXRneG56Z1pvRjZJR0xYV05MWjBU?=
 =?utf-8?B?WXlmUGFsTSs3QkNVbmZXZWJwTUZFV0VNeit2MFRkL0hlWTd3NEVDQXMxL0ZL?=
 =?utf-8?B?R3BFLzRiSzRETWhQYjhweUVhOWo2cUp2RXVVWTltS3JwYlBmd2dUSkRvRFVH?=
 =?utf-8?B?UDBEbDlmYXIrQUdzQjNMOFZCbklKTXZETU5UM0pDbEtTdS9ZdHN3WWFhMFJk?=
 =?utf-8?B?VnRyQWgyMjkyQzdneVhKdnJXMzRUeXcxVGlXbkM1TDY2bUlGbkV1ZXFRZFhm?=
 =?utf-8?B?ak92U1JjSUNnL05ZbEprYXU2RHdDd3Y2WkVZeEZLUUdXT09ISmRrQXVRTGNM?=
 =?utf-8?B?dGRMTk1MRDgzaUpNYzVzN3VnYTdGZFRWdzh0RHhUU3ZzYlBtc1dHckNSUTdT?=
 =?utf-8?B?SWlxc084OFlXM0lqQVB3L05CK3FjV3QxYTlLMUVoLzZobnMrZ3B3LzEzUHAz?=
 =?utf-8?B?MVdld1Q0T3hlN2I4MlZHV1lrcGdMclpkVlRGby9YL2Z6R2hHL28zNTlSbFZ0?=
 =?utf-8?B?SGR1dDllb1lRZkVZejVZNzZrdzBYSFJSRVdreVNMejhtTmJuRU45NW1mK3p5?=
 =?utf-8?B?VDdtUGJOUlp5M3IrTHA0SDFpWi94YWFqRzJPcTBqNFN6N2V6bjFmakFKRnM0?=
 =?utf-8?B?VXczM0VsZTJMQlY3ZWhCOG9rZjdLMWNrZlVqSHU2d0Y5Y0Q3T0U1dUdzcS9P?=
 =?utf-8?B?RTczMGRRalp1SFAwWElYTHFOdkJ6MVdLTXlyRndFTWdlZWNYY0ZDT1NVM0Zy?=
 =?utf-8?B?c2JGMkRCSW4zRVdCZVFHdGV2V1hES1FjRDA2cWNCUE9TZVBjUmpqY015QU5n?=
 =?utf-8?B?T21DQi8ySDVuNGprMFA3T3FENDUvOGxNTm1EcXpCQWJNdE9veXdqc2JSV0Nu?=
 =?utf-8?B?VGJQcHMzTVBJYmxNNUpRTXBYVG9Xci9zVGtlQ21halBxRnM1VG9VTnQwWnJq?=
 =?utf-8?B?WjBoTDhyZFd5SU5aT3ZFR1pPU2J6MTQxdW11OCtpR0R5Uk5pR2ZXelplTnh0?=
 =?utf-8?B?eFFqeHdjOWY0OXQxQ1hndi8zZEUxVnlKTXNCa0ladUIvTlBTSTNGWFJYMjJy?=
 =?utf-8?Q?QX4U4O6RSI9FZOJav3j5INa/VxOzSq8/1ZvBg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61A324021EC2D84CA356B3B8DC222FB9@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 40cf9165-c85d-42b1-425c-08da4bcdd7ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 17:14:28.6926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TqqkpgeqJw62a6rOjE9aX1jDY88P5doz1uwEhfQf5sSZz2FSQIU8lPQRKLjKW2EYmYU81Bx1/YFp9infFlmW2/CRKCM1jG7BPzcIIaL3vAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAYP264MB4271
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDEwLzA2LzIwMjIgw6AgMTc6NTUsIEhhcmkgQmF0aGluaSBhIMOpY3JpdMKgOg0KPiBB
ZGRpbmcgaW5zdHJ1Y3Rpb25zIGZvciBwcGMzMiBmb3INCj4gDQo+IGF0b21pY19hbmQNCj4gYXRv
bWljX29yDQo+IGF0b21pY194b3INCj4gYXRvbWljX2ZldGNoX2FkZA0KPiBhdG9taWNfZmV0Y2hf
YW5kDQo+IGF0b21pY19mZXRjaF9vcg0KPiBhdG9taWNfZmV0Y2hfeG9yDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBIYXJpIEJhdGhpbmkgPGhiYXRoaW5pQGxpbnV4LmlibS5jb20+DQo+IC0tLQ0KPiAN
Cj4gQ2hhbmdlcyBpbiB2MjoNCj4gKiBVc2VkIGFuIGFkZGl0aW9uYWwgcmVnaXN0ZXIgKEJQRl9S
RUdfQVgpDQo+ICAgICAgLSB0byBhdm9pZCBjbG9iYmVyaW5nIHNyY19yZWcuDQo+ICAgICAgLSB0
byBrZWVwIHRoZSBsd2FyeCByZXNlcnZhdGlvbiBhcyBpbnRlbmRlZC4NCj4gICAgICAtIHRvIGF2
b2lkIHRoZSBvZGQgc3dpdGNoL2dvdG8gY29uc3RydWN0Lg0KDQpNaWdodCBiZSBhIHN0dXBpZCBx
dWVzdGlvbiBhcyBJIGRvbid0IGtub3cgdGhlIGludGVybmFscyBvZiBCUEY6IEFyZSB3ZSANCnN1
cmUgQlBGX1JFR19BWCBjYW5ub3QgYmUgdGhlIHNyYyByZWcgb3IgdGhlIGRzdCByZWcgPw0KDQoN
Cj4gKiBaZXJvJ2VkIG91dCB0aGUgaGlnaGVyIDMyLWJpdCBleHBsaWNpdGx5IHdoZW4gcmVxdWly
ZWQuDQo+IA0KPiAgIGFyY2gvcG93ZXJwYy9uZXQvYnBmX2ppdF9jb21wMzIuYyB8IDUzICsrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgNDEgaW5zZXJ0
aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBj
L25ldC9icGZfaml0X2NvbXAzMi5jIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXAzMi5j
DQo+IGluZGV4IGU0NmVkMWU4YzZjYS4uMjhkYzZhMWE4ZjJmIDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDMyLmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL25ldC9i
cGZfaml0X2NvbXAzMi5jDQo+IEBAIC0yOTQsNiArMjk0LDcgQEAgaW50IGJwZl9qaXRfYnVpbGRf
Ym9keShzdHJ1Y3QgYnBmX3Byb2cgKmZwLCB1MzIgKmltYWdlLCBzdHJ1Y3QgY29kZWdlbl9jb250
ZXh0ICoNCj4gICAJCXUzMiBkc3RfcmVnX2ggPSBkc3RfcmVnIC0gMTsNCj4gICAJCXUzMiBzcmNf
cmVnID0gYnBmX3RvX3BwYyhpbnNuW2ldLnNyY19yZWcpOw0KPiAgIAkJdTMyIHNyY19yZWdfaCA9
IHNyY19yZWcgLSAxOw0KPiArCQl1MzIgYXhfcmVnID0gYnBmX3RvX3BwYyhCUEZfUkVHX0FYKTsN
Cj4gICAJCXUzMiB0bXBfcmVnID0gYnBmX3RvX3BwYyhUTVBfUkVHKTsNCj4gICAJCXUzMiBzaXpl
ID0gQlBGX1NJWkUoY29kZSk7DQo+ICAgCQlzMTYgb2ZmID0gaW5zbltpXS5vZmY7DQo+IEBAIC03
OTgsMjUgKzc5OSw1MyBAQCBpbnQgYnBmX2ppdF9idWlsZF9ib2R5KHN0cnVjdCBicGZfcHJvZyAq
ZnAsIHUzMiAqaW1hZ2UsIHN0cnVjdCBjb2RlZ2VuX2NvbnRleHQgKg0KPiAgIAkJICogQlBGX1NU
WCBBVE9NSUMgKGF0b21pYyBvcHMpDQo+ICAgCQkgKi8NCj4gICAJCWNhc2UgQlBGX1NUWCB8IEJQ
Rl9BVE9NSUMgfCBCUEZfVzoNCj4gLQkJCWlmIChpbW0gIT0gQlBGX0FERCkgew0KPiAtCQkJCXBy
X2Vycl9yYXRlbGltaXRlZCgiZUJQRiBmaWx0ZXIgYXRvbWljIG9wIGNvZGUgJTAyeCAoQCVkKSB1
bnN1cHBvcnRlZFxuIiwNCj4gLQkJCQkJCSAgIGNvZGUsIGkpOw0KPiAtCQkJCXJldHVybiAtRU5P
VFNVUFA7DQo+IC0JCQl9DQo+IC0NCj4gLQkJCS8qICoodTMyICopKGRzdCArIG9mZikgKz0gc3Jj
ICovDQo+IC0NCj4gICAJCQlicGZfc2V0X3NlZW5fcmVnaXN0ZXIoY3R4LCB0bXBfcmVnKTsNCj4g
KwkJCWJwZl9zZXRfc2Vlbl9yZWdpc3RlcihjdHgsIGF4X3JlZyk7DQo+ICsNCj4gICAJCQkvKiBH
ZXQgb2Zmc2V0IGludG8gVE1QX1JFRyAqLw0KPiAgIAkJCUVNSVQoUFBDX1JBV19MSSh0bXBfcmVn
LCBvZmYpKTsNCj4gKwkJCXRtcF9pZHggPSBjdHgtPmlkeCAqIDQ7DQo+ICAgCQkJLyogbG9hZCB2
YWx1ZSBmcm9tIG1lbW9yeSBpbnRvIHIwICovDQo+ICAgCQkJRU1JVChQUENfUkFXX0xXQVJYKF9S
MCwgdG1wX3JlZywgZHN0X3JlZywgMCkpOw0KPiAtCQkJLyogYWRkIHZhbHVlIGZyb20gc3JjX3Jl
ZyBpbnRvIHRoaXMgKi8NCj4gLQkJCUVNSVQoUFBDX1JBV19BREQoX1IwLCBfUjAsIHNyY19yZWcp
KTsNCj4gLQkJCS8qIHN0b3JlIHJlc3VsdCBiYWNrICovDQo+ICsNCj4gKwkJCS8qIFNhdmUgb2xk
IHZhbHVlIGluIEJQRl9SRUdfQVggKi8NCj4gKwkJCWlmIChpbW0gJiBCUEZfRkVUQ0gpDQo+ICsJ
CQkJRU1JVChQUENfUkFXX01SKGF4X3JlZywgX1IwKSk7DQo+ICsNCj4gKwkJCXN3aXRjaCAoaW1t
KSB7DQo+ICsJCQljYXNlIEJQRl9BREQ6DQo+ICsJCQljYXNlIEJQRl9BREQgfCBCUEZfRkVUQ0g6
DQo+ICsJCQkJRU1JVChQUENfUkFXX0FERChfUjAsIF9SMCwgc3JjX3JlZykpOw0KPiArCQkJCWJy
ZWFrOw0KPiArCQkJY2FzZSBCUEZfQU5EOg0KPiArCQkJY2FzZSBCUEZfQU5EIHwgQlBGX0ZFVENI
Og0KPiArCQkJCUVNSVQoUFBDX1JBV19BTkQoX1IwLCBfUjAsIHNyY19yZWcpKTsNCj4gKwkJCQli
cmVhazsNCj4gKwkJCWNhc2UgQlBGX09SOg0KPiArCQkJY2FzZSBCUEZfT1IgfCBCUEZfRkVUQ0g6
DQo+ICsJCQkJRU1JVChQUENfUkFXX09SKF9SMCwgX1IwLCBzcmNfcmVnKSk7DQo+ICsJCQkJYnJl
YWs7DQo+ICsJCQljYXNlIEJQRl9YT1I6DQo+ICsJCQljYXNlIEJQRl9YT1IgfCBCUEZfRkVUQ0g6
DQo+ICsJCQkJRU1JVChQUENfUkFXX1hPUihfUjAsIF9SMCwgc3JjX3JlZykpOw0KPiArCQkJCWJy
ZWFrOw0KPiArCQkJZGVmYXVsdDoNCj4gKwkJCQlwcl9lcnJfcmF0ZWxpbWl0ZWQoImVCUEYgZmls
dGVyIGF0b21pYyBvcCBjb2RlICUwMnggKEAlZCkgdW5zdXBwb3J0ZWRcbiIsDQo+ICsJCQkJCQkg
ICBjb2RlLCBpKTsNCj4gKwkJCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICsJCQl9DQo+ICsNCj4g
KwkJCS8qIHN0b3JlIG5ldyB2YWx1ZSAqLw0KPiAgIAkJCUVNSVQoUFBDX1JBV19TVFdDWChfUjAs
IHRtcF9yZWcsIGRzdF9yZWcpKTsNCj4gICAJCQkvKiB3ZSdyZSBkb25lIGlmIHRoaXMgc3VjY2Vl
ZGVkICovDQo+IC0JCQlQUENfQkNDX1NIT1JUKENPTkRfTkUsIChjdHgtPmlkeCAtIDMpICogNCk7
DQo+ICsJCQlQUENfQkNDX1NIT1JUKENPTkRfTkUsIHRtcF9pZHgpOw0KPiArDQo+ICsJCQkvKiBG
b3IgdGhlIEJQRl9GRVRDSCB2YXJpYW50LCBnZXQgb2xkIGRhdGEgaW50byBzcmNfcmVnICovDQo+
ICsJCQlpZiAoaW1tICYgQlBGX0ZFVENIKSB7DQo+ICsJCQkJRU1JVChQUENfUkFXX01SKHNyY19y
ZWcsIGF4X3JlZykpOw0KPiArCQkJCWlmICghZnAtPmF1eC0+dmVyaWZpZXJfemV4dCkNCj4gKwkJ
CQkJRU1JVChQUENfUkFXX0xJKHNyY19yZWdfaCwgMCkpOw0KPiArCQkJfQ0KPiAgIAkJCWJyZWFr
Ow0KPiAgIA0KPiAgIAkJY2FzZSBCUEZfU1RYIHwgQlBGX0FUT01JQyB8IEJQRl9EVzogLyogKih1
NjQgKikoZHN0ICsgb2ZmKSArPSBzcmMgKi8=
