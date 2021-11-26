Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C35E45EE76
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhKZNHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:07:17 -0500
Received: from mail-eopbgr60098.outbound.protection.outlook.com ([40.107.6.98]:3491
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229709AbhKZNFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 08:05:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dfeib1rBtuXlMguw+3Fe7fimlaGcRREuVcAGJcCwbrr8jOvNdRMKQ154ZKJ3d9CKEdu0GT7YiVuvGnTvN9GQzT3rCDNNhJpZU6Gx2KQjUhmlQ0V8bZCQVGdYD4JkV1CsUaFFpIRP8laK5wrw7cOXopBiMJ/SCGK3QhnuPC3CpwPr57KhpvtDPelD4RXqfV9yd9IOafl1lbfylCwjgJgoH5TiUEK6TyMAsb62lh01wtkanxRH75EV4nLJn9VVbTQ11yJfGpkHMNliaHMBUShCUp+OAKUWB/lUcTCTRytKxzrUVvy0cMQTenxTaxHTgpWRUp1EgLL+dnE6rkultgYzvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxfp8rrN5jORklICWFE1dAf5270/zOLNnU3L+931DDI=;
 b=AkGMAprmjB3zYDhZNGFJa849J3E1mFEfA0nMNzozsMoHNHCFSenilpjmiSU+HKM4PwLJPirg1eqRR4Ycu9ns7ERUNrApwiB36w9iQpSIEeP4SENpy/mVGFERDHJugvBhm2IThUdUwUzKDXkWqez44d92LXdyPNOCEGZh43rDRjyz4IaGo4FOMNXjtnwjOURqTt1I700jS2q4WvOXmNHdOvHQhBtvu6xzuLguhwSe/Rhl4x20PQYL25yUMe2tpUp6FEaMSNOx8Vc1EyECioWcsjl+6eIptFp6VFsDc2jUXcjrpAOrt6gvpMgdxIkygH+BPioQgOu8OQ/VSXYM4OX2+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxfp8rrN5jORklICWFE1dAf5270/zOLNnU3L+931DDI=;
 b=PgR7CNlIAsoF7+QdIyV64kFORqEA1FuwdXlR7z1FvnyHtort+PxD+vKqpWn4Vq2els3fYS41AYrGmh+nYmoUG87rHsOxk8CxQVsyvhdfJOzR4rAaQb5S5hqWUJMy4EICobRidSYWf36v/wk8v9BxE2w3c3t6mtDgmvP7+y11164=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM5PR03MB3121.eurprd03.prod.outlook.com (2603:10a6:206:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 26 Nov
 2021 13:01:58 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63%3]) with mapi id 15.20.4734.022; Fri, 26 Nov 2021
 13:01:57 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net 3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps
 of 0.3 ns
Thread-Topic: [PATCH net 3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps
 of 0.3 ns
Thread-Index: AQHX4sQywchAVGwyl0ag8mfEEb5J9qwVxMaAgAABR4A=
Date:   Fri, 26 Nov 2021 13:01:57 +0000
Message-ID: <46bd63ea-b153-e3ad-3cee-eb845e6b2709@bang-olufsen.dk>
References: <20211126125007.1319946-3-alvin@pqrs.dk>
 <8F46AA41-9B98-4EFA-AB2E-03990632D75C@arinc9.com>
In-Reply-To: <8F46AA41-9B98-4EFA-AB2E-03990632D75C@arinc9.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 159852e0-bf9a-4145-850a-08d9b0dceddf
x-ms-traffictypediagnostic: AM5PR03MB3121:
x-microsoft-antispam-prvs: <AM5PR03MB312178E0A38F31F0B42A5EF383639@AM5PR03MB3121.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PzbayTsuo/bks2C+B0xgnriysHgpvPdjPM7r6mQDuWbqg8SqFJyTr3hFHsNub/SlgarrAncJtyK5w0YDEOp2sTxAPzlYOKaCCfM3ePDZC48FWuvGuBzCbIvegXiLPpVINFSywUgOlyH5OPVJcWLMI12xTGdmFlCXmJCAeBmPfv69hZPYiHNFVlXjL4xnWcCLZ5h9dR94jBHEfEBrZAy+oJYxVqXXtd6a1zj6o0XUNA6Sj67J9tDWft6ZjvAdy5YzRBhBeXiMN0O1yXIn1JhcsGhbbkIr/XRjhGUrQmekSQv030Om74CQ04dNvgApMjillaLzboRkZZVRso/X7Ihx8BNeS1Gpvvx/+gfAKsVOQ2Akp8vHFGPhXVXxfIo9h8ZeIkAp49XGm1tg2TulSHGMrjk1/Pzup4nWnAmsCIYtDiRJKno8MKp4V92dA178o1xAlMQjLbaXcoaNqCJ4MIH/fl3uoVhGlofZjgbrsDm2Hy8NMSzx2mlrSPbvzJUuv2iGTKrLgPBEILVqaxB+JhbIJsEXgCcPMHRLD9MHEiijY4WB7kzgMdkODvFohKJl5IdXyuOTZHh021LYNrjDPxgGxITgKF6xEZtgbZqxFo2x7L1vHU1YsFTFzv8BsHOlao2wMO9Cz1cp2jQ3Gf3yURuvUHGbcwUlX4ibjOJ4xyaCkhhxc3vVyN0kUxmICMaP8j6ZJuyJ6oP4/ASn1D3uAB90f65qRFfbjuNANMYVGmx6J5Bs8R5oiS7z5PaDF0E2ebsOkE/OT6q1QvkRLRBBg/Fptw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(91956017)(76116006)(83380400001)(64756008)(66446008)(508600001)(66476007)(26005)(6486002)(66946007)(2616005)(66556008)(6506007)(186003)(71200400001)(2906002)(53546011)(36756003)(5660300002)(122000001)(38100700002)(54906003)(66574015)(8676002)(316002)(8976002)(85182001)(85202003)(38070700005)(31686004)(110136005)(31696002)(4326008)(8936002)(86362001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGxTc2UyRlhocGN4VXlmZVB6WHgwcVRZTnFvcUJJOGp6bHVHUlA4dFpvRFNY?=
 =?utf-8?B?Q3VFRzBiT0NPNmwxL2k2NjlZa3Q1RW15N216ZUU5UGhQTnNtb2pUQmJEdXF3?=
 =?utf-8?B?OHJKYXJ2NmovdHhaTzVwTzJTSFFmTjV4Qm9LTFExdW81TU5QM3d5Yjd4Z2E5?=
 =?utf-8?B?Wk1VRkR4T1pYclUvdmNvZm5tdXBMWmxvWUdvd3ozTnNSTU5xUWNETTdWTVFH?=
 =?utf-8?B?SnJVRkFXdVpoSVFQd1U3cW5ZcUl0cHlaUmVodkZ0b25aV2F6YmUvdHhBbkI4?=
 =?utf-8?B?Ukh1endVRUpybUViZll5RzRBSGtkZW4yYzV5bUFHZW9DUnRjd0xBY2tnUUww?=
 =?utf-8?B?em5aeGNHYjhxaHFOWVpXR0d3bUpxcElaeVdMaHVDQVExRG4vTUx1dUlNYkRk?=
 =?utf-8?B?N1lIdU5yMm0yZmEvVVhXeXVSaUZUSVM1MTN4Qi9yVU1tMmdHdGxVNEIwbnJH?=
 =?utf-8?B?WmVxTUdDSjh0Q0VXekVjNmluamM3RTQrQWxHalUwb0hpMUtMOWZEcXg3Zm8y?=
 =?utf-8?B?ZUsyR1o3eW91MGp1NnBmUERRaUQ2UFdQR1ZKd29EUSs3YVZGdkQ1MmNscGZa?=
 =?utf-8?B?dEVuVitzQWxNclpQM1daeXAxREZoVTFJSlFWSEdFc3ZuUUMxZGNmV3AzL3lI?=
 =?utf-8?B?R0ZDUGVua0pKY1hZMXh5cndPcXlWa2J2cHlwSE5rTjh3SnhHZTRoSVZrN2Nl?=
 =?utf-8?B?UnE2OEk4cjJSQlpMQitGZnRGaGxCT0o2QU5wN3FWb2xtWGNwWHJhWVlTNlYx?=
 =?utf-8?B?WTZHZmhtMU9WdDE4WEJNTm9Fcm9BTDkvSmo0czNrYVNZV0dObXZ0aXhpYkJ1?=
 =?utf-8?B?WjJpM01GRzJPRU1LdjViK3NCRG9mWkNIUW44bUJtMzhNcFlWNzZPbjBFU2hG?=
 =?utf-8?B?SzRtOTV4eW1sT2w3QmRrMkhDSGtiQkxsZlYyMmlwa3FZaTZYRW5hY2dXSmR1?=
 =?utf-8?B?K1JQUTJMUUlHcSs2YzRCQWdFekk3a2RyRmVYWmxSQ0lVdHgxTHN3eElvRWNC?=
 =?utf-8?B?N2hoa0VkTDR6YkJINlhXMmo5em5aOXIvbUJhY0MwTy9rY2lFWGRsZDdWRDEv?=
 =?utf-8?B?WVI5NlpnRW5Rc2NRV3AzQnhBSjRtNlhSbzd0dmhnRmNYalVXWWlmbHRydEFp?=
 =?utf-8?B?UlRyNGcrTXV6ZkNmTDRoZ1BqZjgzeGZoRk9ucDNkWkZKdzE5WElqV3NJanVS?=
 =?utf-8?B?Q2dFL1RJeFNpd0ViUlNLK2NSaDRjL2FqQys0VkpEUi9xbmRFZ0JLQ0ZnREhk?=
 =?utf-8?B?V2x6K1lJemFSWEl6Z3gzOGJwYzduYTV5OUZBeCttQmdCWmtVUWI3U2EvdGZ2?=
 =?utf-8?B?OTd1MXVTcTJ3U3BJZXRyYllTZ3JTWTMwSlRSV1NuVkk2WUJyTkdYQk1PYjVN?=
 =?utf-8?B?dG9pZnlpZ2xDSDl6RGNLWjdpbkVINTFIcjZGOTlGb1FENmdaYmFzazlJanpV?=
 =?utf-8?B?Vmt4QUl0MG9sTlIzUjIvcG5sRFFHODd3bjczNGZzKzBxd0QxZmtCYXlCL2JY?=
 =?utf-8?B?U2dKaGVRZ2hON2JxUm5qNm0xN1BMbXBweVkzNXMrUTJDYVVFSk1abkJENUxH?=
 =?utf-8?B?YlEyZmdLbmpLRDV5cnlFclFDN2p4SGtVVXBaT3BoemhxSk9lQWU1b1Yzb283?=
 =?utf-8?B?Z1hBVUU4VkMyci8rL3F5WHdNd3pwdFJ5QUpQM0FMMnFBNVVsQjJPU2srcmpr?=
 =?utf-8?B?dHNhNTcveEtXU0hkNHpHQS9ObmFnbEh3NDYzM1pqTUtnV3RCZG5yYWZNWEg4?=
 =?utf-8?B?Z1JsU3pGd2xDSkozeVc5eElJR3pJWVh0Z2gzeG5zTWVvU0x3ZWowRnlHUito?=
 =?utf-8?B?d0ZqbkFkRlFqVmJRWXpDNGlHdkw0SXFRMWtzczRIekdjajlIMnRpZUhsME8x?=
 =?utf-8?B?djJMT29CZTdORmVCay82eG5qS044ZmFnMmFhT3dyay94Sk5OTFNpZEJlSE9l?=
 =?utf-8?B?ZnlvcG5rTzVQZUhzSDArOFRWT0FNTGhFQ3RjYWJBQk4zcWUvL09uNG5SUkJl?=
 =?utf-8?B?NCtjRnMyYmVDdWlmSUlqeFlSSWE1NHhIaGFaWnk2YnBER2p4MlhRY1llYWNJ?=
 =?utf-8?B?NkdRVlkzWFpvcnduYmtHTm5oSmVKRTMxbkIvVnBvcU56b1d5RkFuSlRJS29i?=
 =?utf-8?B?azM5VFhHem9scklsWXdwVjFUY3AxU051UW5qL2NHR3RFNUc2K2ZtSEE3OXRy?=
 =?utf-8?Q?XyR0gcbGaDQgNxmOwrZ3CgY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEB3F81CEBF8DA42BD2AC1AEB0313054@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 159852e0-bf9a-4145-850a-08d9b0dceddf
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 13:01:57.9068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A1BkIYxg8FfJb/FMH1AAMaZw4CZHLX24E9x+PWkjvIZZwg7eaYhQwbyVL/K3vA2XS+L3VKAvvmc+RWmQURZ0VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR03MB3121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQXLEsW7DpywNCk9uIDExLzI2LzIxIDEzOjU3LCBBcsSxbsOnIMOcTkFMIHdyb3RlOg0KPj4g
T24gMjYgTm92IDIwMjEsIGF0IDE1OjUwLCBBbHZpbiDFoGlwcmFnYSA8YWx2aW5AcHFycy5kaz4g
d3JvdGU6DQo+Pg0KPj4g77u/RnJvbTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2Vu
LmRrPg0KPj4NCj4+IEEgY29udGFjdCBhdCBSZWFsdGVrIGhhcyBjbGFyaWZpZWQgd2hhdCBleGFj
dGx5IHRoZSB1bml0cyBvZiBSR01JSSBSWA0KPj4gZGVsYXkgYXJlLiBUaGUgYW5zd2VyIGlzIHRo
YXQgdGhlIHVuaXQgb2YgUlggZGVsYXkgaXMgImFib3V0IDAuMyBucyIuDQo+PiBUYWtlIHRoaXMg
aW50byBhY2NvdW50IHdoZW4gcGFyc2luZyByeC1pbnRlcm5hbC1kZWxheS1wcyBieQ0KPj4gYXBw
cm94aW1hdGluZyB0aGUgY2xvc2VzdCBzdGVwIHZhbHVlLiBEZWxheXMgb2YgbW9yZSB0aGFuIDIu
MSBucyBhcmUNCj4+IHJlamVjdGVkLg0KPj4NCj4+IFRoaXMgb2J2aW91c2x5IGNvbnRyYWRpY3Rz
IHRoZSBwcmV2aW91cyBhc3N1bXB0aW9uIGluIHRoZSBkcml2ZXIgdGhhdCBhDQo+PiBzdGVwIHZh
bHVlIG9mIDQgd2FzICJhYm91dCAyIG5zIiwgYnV0IFJlYWx0ZWsgYWxzbyBwb2ludHMgb3V0IHRo
YXQgaXQgaXMNCj4+IGVhc3kgdG8gZmluZCBtb3JlIHRoYW4gb25lIFJYIGRlbGF5IHN0ZXAgdmFs
dWUgd2hpY2ggbWFrZXMgUkdNSUkgd29yay4NCj4+DQo+PiBGaXhlczogNGFmMjk1MGM1MGM4ICgi
bmV0OiBkc2E6IHJlYWx0ZWstc21pOiBhZGQgcnRsODM2NW1iIHN1YmRyaXZlciBmb3IgUlRMODM2
NU1CLVZDIikNCj4+IENjOiBBcsSxbsOnIMOcTkFMIDxhcmluYy51bmFsQGFyaW5jOS5jb20+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+
IA0KPiBBY2tlZC1ieTogQXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg0KDQpJ
IGtub3cgeW91IHN1Ym1pdHRlZCBhIGRldmljZSB0cmVlIHVzaW5nIHRoaXMgZHJpdmVyIHdpdGgg
DQpyeC1pbnRlcm5hbC1kZWxheS1wcyA9IDwyMDAwPi4gV291bGQgeW91IGNhcmUgdG8gdGVzdCB5
b3VyIGRldmljZSB0cmVlIA0Kd2l0aCB0aGlzIHBhdGNoIGFuZCBzZWUgaWYgaXQgbmVlZHMgdXBk
YXRpbmc/IEJlZm9yZSB0aGlzIHBhdGNoLCB0aGUgDQpkcml2ZXIgd291bGQgY29uZmlndXJlIGEg
c3RlcCB2YWx1ZSBvZiA0LiBBZnRlciB0aGlzIHBhdGNoIGl0IHdpbGwgDQpjb25maWd1cmUgYSBz
dGVwIHZhbHVlIG9mIDcuDQoNCklmIHlvdSBleHBlcmllbmNlIHByb2JsZW1zIHRoZW4gd2Ugd2ls
bCBoYXZlIHRvIHVwZGF0ZSB0aGUgZGV2aWNlIHRyZWUgDQphZ2FpbiwgYXNzdW1pbmcgdGhpcyBw
YXRjaCBpcyBhY2NlcHRlZC4NCg0KVGhhbmtzIQ0KDQoJQWx2aW4=
