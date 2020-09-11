Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49473266A49
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgIKVtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:49:19 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2311 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgIKVtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:49:14 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5bf0ad0000>; Fri, 11 Sep 2020 14:48:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 14:49:14 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 11 Sep 2020 14:49:14 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Sep
 2020 21:49:12 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 11 Sep 2020 21:49:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/K2/A/2XYj3z0YI/d1VXdl0cfgbTe0QXeyBVgqW8gArfAsr6pc+3oVFusMjwfZQdbHwcElV6UYdCxsu6NMaSbeKe5WA1XVtppaxVvpKv14zYts8FgCVqyVqi35pbkBeh/3bnwNfFqdscXm+Kx42mJBlPwY5RlEbXrQJIp/4HQsofr27C9zHyR/gDW85h0WxMaM1MunRUYRkwq2I/kXRib+L+E2SDUQNuOZ0r2lEzcW5TB20EuwzpLnCAW0g2WytjuBZQT6dYY7KJZgsE4mFXROOTYZLdDPo/P91VDtHEL2FwAqNvnERtGAc/b3s1B1wn/oUJ8Hk4YH4y4XIgsa5sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YdUEWJGVJ9p/CUZy34jP46KnIXUhO49GCFC2mXsPwM=;
 b=fxip/KBBQQBTCMSuv5dt5VvMMBgFAKx4JBSx6O/O5VAhGs2YqYQ43FCiPGwZDfQDz3XArvMEjMdKsWFir8h+PxXb2symRoGtMn9zroLDimKhFYnLgCQm/5X2/vfOGvvQwBjkjtA+7leqNeKXORH28obBREIlN7w5tSjC4vJtp40hO+gBKbj7PBlwWSA2EcnZQrPN/tvVXPV95ZedjE1gikdu7r2kywljxHtW8GhSO+9rSqpSxm31PF8BDQ8WSfiol1aPKsovup9EAMSmaRSkGnbxd5vYqo1xkUJy8UNRAizxSTpO/fwkAFpzWsHfYx17ezgbY6s4IXkOYvpzcr5Z+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 11 Sep
 2020 21:49:10 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566%6]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 21:49:10 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        Tariq Toukan <tariqt@nvidia.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next 6/8] mlx5: add pause frame stats
Thread-Topic: [PATCH net-next 6/8] mlx5: add pause frame stats
Thread-Index: AQHWiHU3kRUQ+K6YoUGUo90rnp05yalj+deA
Date:   Fri, 11 Sep 2020 21:49:10 +0000
Message-ID: <be0ba193577ffb219e29b53d767228b1eff9b66b.camel@nvidia.com>
References: <20200911195258.1048468-1-kuba@kernel.org>
         <20200911195258.1048468-7-kuba@kernel.org>
In-Reply-To: <20200911195258.1048468-7-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03184e1f-1be9-438f-e386-08d8569c845e
x-ms-traffictypediagnostic: BYAPR12MB4791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB47910E9A2F07BEA2060ADFD0B3240@BYAPR12MB4791.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GWUpC7pTWLoJmS9DaE1jAm5FNzC+/GOwuLVKw4CVTZksPQWmh4xcdXtbySEhL6/MrLxag1XmUnxVxq6q1z5elsgP3ufaYTTkA+qOQNw62IGpyAtOq/gTkFqGxQfG12/QgyvGVdA+WuTiUj+w3uk0PuCU5rWWZS9Hyi5kzdOBBbK59NWA0TsBg9IVr/rmZ8d0EXsxlpDVCpyfBBS9PfbdmmNenJc5D3s4vlt3nYGXekdkLuOU7D7Vk+uMjpL3VYMdbD6WXJXDlpgDlm3YJ0GPr4YwZdkRNnhdVdarYUnId0Elcb69xF7s2Cm7Q+GpWZVjy/Mr8fl8+xqtUkb6ciNypQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(4326008)(86362001)(2906002)(66556008)(66446008)(64756008)(2616005)(26005)(66476007)(66946007)(316002)(76116006)(186003)(36756003)(6512007)(83380400001)(6506007)(110136005)(6486002)(478600001)(5660300002)(8936002)(71200400001)(8676002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HN3qMBRinWstBvhc0KVlmG9extch++qA47Y5pCHc5VoUTZD7i7hXTlsDbKiEn95p4LMcI1SwqR3pX46S8GDv658nGtKbXsqLXjDLK0lH+jvgou9Pb0ETtSA0bmxCy2bY7u/XFnXJwUyZLo6ORGdlsKpLqzmd8/vAiLXX6zwGiVzGS6iLG5i4+cM1PsSwWpm6KWpSFNiDU1mwiCLGf4ezxlntptey8e/kxStO10uv3hGCI6lEy/zg3Zm896MNrQQpojSsG5bP9kCP4nJxvIBdxcKHnznI/SK0X0x3jw69uFLNBHvXlObFYLzrcFWUgdrg/jIHpcwpQpeQTYgoybSkPy+X5mwjYWRmdKF3u8KlHuPRIEO5lMnCikoh+N313P/pvkaqkhWKmHwlqINvOjrRk/8uyD/ywXcFTlyKSBUYLw+4n7F4atFe4Xhdxm0xGMrcVO24t3cWuwN7y/BiuSrUYu82pN8y3t+YNAe7ahkBonGn57POpAK17oRRsLxd58g1/WBACgytbaSSvTEWlm9fLhFOWqRfWYFjpq3YDq5VYy4sZV+m2RyafER6JhkRqYUuX1qeKUK9DC9jmbumeRCcuMALz+4dMQPgNY58ptu2EVvpfp7JAQeYd+s9AKXfshQcOB4R78s2FOJPe+Nh8I03+A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <23F0ED6E9DD8E84A8C49B0C35F32308E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03184e1f-1be9-438f-e386-08d8569c845e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2020 21:49:10.6383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: //I56Hvb/JS31Ybsz0XUAmYT3oW7DURywOW3DE978XqbUmnwkTPj7QCvB4c5lsYdbhW16A2K7LyHnXjVgPI2Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4791
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599860909; bh=/YdUEWJGVJ9p/CUZy34jP46KnIXUhO49GCFC2mXsPwM=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Fx7gDPj3FGz1q2ePzOIZH4B6AuBmYYr1De3dkZCBR7s5zLC8MMIHv80fBCxGCa9Hs
         RuFKq1MZbtmQ20QdEf6xGnFFDiK9Z65RCa2hPMIj4mJMF0ZWGxFcL8kdaHxFe4t42b
         BPGNH4raTOzJVkrxA4RaPZsSGxz+VXnK7l6mU5kxa5yRu1rL2vNmTbglZs1wdKubvq
         BauB955G1EyrbCPo1e29tz6pbGgM4+2UhDBsY/6v95KU/RkYrobS8N6NzeUfU9p9lr
         U7aPKudWNK/W7GU5nMisZrWIUYALzkb9XumA/m5iQCRXFfxuBADCb2x29ZD0lLIjil
         1yAl8jyctIv3Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTExIGF0IDEyOjUyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gUGx1bWIgdGhyb3VnaCBhbGwgdGhlIGluZGlyZWN0aW9uIGFuZCBjb3B5IHNvbWUgY29kZSBm
cm9tDQo+IGV0aHRvb2wgLVMuIFRoZSBuYW1lcyBvZiB0aGUgZ3JvdXAgaW5kaWNhdGUgdGhhdCB0
aGVzZSBhcmUNCj4gdGhlIHN0YXRzIHdlIGFyZSBhZnRlci4NCj4gDQoNClllcyB0aGV5IGFyZS4N
Cg0KPiBTaWduZWQtb2ZmLWJ5OiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiAt
LS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oICB8ICAy
ICsrDQo+ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2V0aHRvb2wuYyAgfCAx
NSArKysrKysrKysrDQo+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9y
ZXAuYyAgfCAgOSArKysrKysNCj4gIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
c3RhdHMuYyAgICB8IDMwDQo+ICsrKysrKysrKysrKysrKysrKysNCj4gIC4uLi9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fc3RhdHMuaCAgICB8ICAzICsrDQo+ICA1IGZpbGVzIGNoYW5n
ZWQsIDU5IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaA0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbi5oDQo+IGluZGV4IDRmMzM2NThkYTI1YS4uNjE1YWMwZGMyNDhl
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW4uaA0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4u
aA0KPiBAQCAtMTA1Myw2ICsxMDUzLDggQEAgaW50IG1seDVlX2V0aHRvb2xfZ2V0X3RzX2luZm8o
c3RydWN0IG1seDVlX3ByaXYNCj4gKnByaXYsDQo+ICAJCQkgICAgICBzdHJ1Y3QgZXRodG9vbF90
c19pbmZvICppbmZvKTsNCj4gIGludCBtbHg1ZV9ldGh0b29sX2ZsYXNoX2RldmljZShzdHJ1Y3Qg
bWx4NWVfcHJpdiAqcHJpdiwNCj4gIAkJCSAgICAgICBzdHJ1Y3QgZXRodG9vbF9mbGFzaCAqZmxh
c2gpOw0KPiArdm9pZCBtbHg1ZV9ldGh0b29sX2dldF9wYXVzZV9zdGF0cyhzdHJ1Y3QgbWx4NWVf
cHJpdiAqcHJpdiwNCj4gKwkJCQkgICBzdHJ1Y3QgZXRodG9vbF9wYXVzZV9zdGF0cw0KPiAqcGF1
c2Vfc3RhdHMpOw0KPiAgdm9pZCBtbHg1ZV9ldGh0b29sX2dldF9wYXVzZXBhcmFtKHN0cnVjdCBt
bHg1ZV9wcml2ICpwcml2LA0KPiAgCQkJCSAgc3RydWN0IGV0aHRvb2xfcGF1c2VwYXJhbQ0KPiAq
cGF1c2VwYXJhbSk7DQo+ICBpbnQgbWx4NWVfZXRodG9vbF9zZXRfcGF1c2VwYXJhbShzdHJ1Y3Qg
bWx4NWVfcHJpdiAqcHJpdiwNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9ldGh0b29sLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jDQo+IGluZGV4IDVjYjFlNDgzOWViNy4uYzlm
YjNjMDE4Yjk2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fZXRodG9vbC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9ldGh0b29sLmMNCj4gQEAgLTEzNDEsNiArMTM0MSwyMCBAQCBzdGF0
aWMgaW50IG1seDVlX3NldF90dW5hYmxlKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYsDQo+ICAJ
cmV0dXJuIGVycjsNCj4gIH0NCj4gIA0KPiArdm9pZCBtbHg1ZV9ldGh0b29sX2dldF9wYXVzZV9z
dGF0cyhzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCj4gKwkJCQkgICBzdHJ1Y3QgZXRodG9vbF9w
YXVzZV9zdGF0cw0KPiAqcGF1c2Vfc3RhdHMpDQo+ICt7DQo+ICsJbWx4NWVfc3RhdHNfcGF1c2Vf
Z2V0KHByaXYsIHBhdXNlX3N0YXRzKTsNCnRoaXMgZnVuY3Rpb24gaXMgb25seSBiZWluZyBjYWxs
ZWQgaGVyZSwgSSB3b3VsZCBqdXN0IHVuZm9sZCBpdCBoZXJlDQphbmQgc2tpcCB0aGUgcmVkdW5k
YW50IGRlZmluaXRpb24gaW4gZW5fc3RhdC5jIGFuZCBkZWNsYXJhdGlvbiBpbg0KZW5fc3RhdHMu
aC4NCg0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBtbHg1ZV9nZXRfcGF1c2Vfc3RhdHMoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5ldGRldiwNCj4gKwkJCQkgIHN0cnVjdCBldGh0b29sX3BhdXNlX3N0
YXRzDQo+ICpwYXVzZV9zdGF0cykNCj4gK3sNCj4gKwlzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiA9
IG5ldGRldl9wcml2KG5ldGRldik7DQo+ICsNCj4gKwltbHg1ZV9ldGh0b29sX2dldF9wYXVzZV9z
dGF0cyhwcml2LCBwYXVzZV9zdGF0cyk7DQo+ICt9DQo+ICsNCj4gIHZvaWQgbWx4NWVfZXRodG9v
bF9nZXRfcGF1c2VwYXJhbShzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCj4gIAkJCQkgIHN0cnVj
dCBldGh0b29sX3BhdXNlcGFyYW0NCj4gKnBhdXNlcGFyYW0pDQo+ICB7DQo+IEBAIC0yMDMzLDYg
KzIwNDcsNyBAQCBjb25zdCBzdHJ1Y3QgZXRodG9vbF9vcHMgbWx4NWVfZXRodG9vbF9vcHMgPSB7
DQo+ICAJLnNldF9yeG5mYyAgICAgICAgID0gbWx4NWVfc2V0X3J4bmZjLA0KPiAgCS5nZXRfdHVu
YWJsZSAgICAgICA9IG1seDVlX2dldF90dW5hYmxlLA0KPiAgCS5zZXRfdHVuYWJsZSAgICAgICA9
IG1seDVlX3NldF90dW5hYmxlLA0KPiArCS5nZXRfcGF1c2Vfc3RhdHMgICA9IG1seDVlX2dldF9w
YXVzZV9zdGF0cywNCj4gIAkuZ2V0X3BhdXNlcGFyYW0gICAgPSBtbHg1ZV9nZXRfcGF1c2VwYXJh
bSwNCj4gIAkuc2V0X3BhdXNlcGFyYW0gICAgPSBtbHg1ZV9zZXRfcGF1c2VwYXJhbSwNCj4gIAku
Z2V0X3RzX2luZm8gICAgICAgPSBtbHg1ZV9nZXRfdHNfaW5mbywNCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPiBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPiBpbmRleCAxMzVl
ZTI2ODgxYzkuLjg1NmFlNGM4Y2IyNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPiBAQCAtMjg4LDYgKzI4OCwxNCBAQCBz
dGF0aWMgdTMyIG1seDVlX3JlcF9nZXRfcnhmaF9pbmRpcl9zaXplKHN0cnVjdA0KPiBuZXRfZGV2
aWNlICpuZXRkZXYpDQo+ICAJcmV0dXJuIG1seDVlX2V0aHRvb2xfZ2V0X3J4ZmhfaW5kaXJfc2l6
ZShwcml2KTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIHZvaWQgbWx4NWVfdXBsaW5rX3JlcF9nZXRf
cGF1c2Vfc3RhdHMoc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5ldGRldiwNCj4gKwkJCQkJICAgICBz
dHJ1Y3QgZXRodG9vbF9wYXVzZV9zdGF0cw0KPiAqc3RhdHMpDQo+ICt7DQo+ICsJc3RydWN0IG1s
eDVlX3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihuZXRkZXYpOw0KPiArDQo+ICsJbWx4NWVfZXRo
dG9vbF9nZXRfcGF1c2Vfc3RhdHMocHJpdiwgc3RhdHMpOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMg
dm9pZCBtbHg1ZV91cGxpbmtfcmVwX2dldF9wYXVzZXBhcmFtKHN0cnVjdCBuZXRfZGV2aWNlDQo+
ICpuZXRkZXYsDQo+ICAJCQkJCSAgICBzdHJ1Y3QgZXRodG9vbF9wYXVzZXBhcmFtDQo+ICpwYXVz
ZXBhcmFtKQ0KPiAgew0KPiBAQCAtMzYyLDYgKzM3MCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
ZXRodG9vbF9vcHMNCj4gbWx4NWVfdXBsaW5rX3JlcF9ldGh0b29sX29wcyA9IHsNCj4gIAkuc2V0
X3J4ZmggICAgICAgICAgPSBtbHg1ZV9zZXRfcnhmaCwNCj4gIAkuZ2V0X3J4bmZjICAgICAgICAg
PSBtbHg1ZV9nZXRfcnhuZmMsDQo+ICAJLnNldF9yeG5mYyAgICAgICAgID0gbWx4NWVfc2V0X3J4
bmZjLA0KPiArCS5nZXRfcGF1c2Vfc3RhdHMgICA9IG1seDVlX3VwbGlua19yZXBfZ2V0X3BhdXNl
X3N0YXRzLA0KPiAgCS5nZXRfcGF1c2VwYXJhbSAgICA9IG1seDVlX3VwbGlua19yZXBfZ2V0X3Bh
dXNlcGFyYW0sDQo+ICAJLnNldF9wYXVzZXBhcmFtICAgID0gbWx4NWVfdXBsaW5rX3JlcF9zZXRf
cGF1c2VwYXJhbSwNCj4gIH07DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fc3RhdHMuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5jDQo+IGluZGV4IGUzYjJmNTk0MDhlNi4uOTdiMDNh
YTc1MzVmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fc3RhdHMuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fc3RhdHMuYw0KPiBAQCAtNjc3LDYgKzY3NywzNiBAQCBzdGF0aWMNCj4gTUxY
NUVfREVDTEFSRV9TVEFUU19HUlBfT1BfVVBEQVRFX1NUQVRTKDgwMl8zKQ0KPiAgCW1seDVfY29y
ZV9hY2Nlc3NfcmVnKG1kZXYsIGluLCBzeiwgb3V0LCBzeiwgTUxYNV9SRUdfUFBDTlQsIDAsDQo+
IDApOw0KPiAgfQ0KPiAgDQo+ICsjZGVmaW5lIE1MWDVFX1JFQURfQ1RSNjRfQkVfRihwdHIsIGMp
CQkJXA0KPiArCWJlNjRfdG9fY3B1KCooX19iZTY0ICopKChjaGFyICopcHRyICsJCVwNCj4gKwkJ
TUxYNV9CWVRFX09GRihwcGNudF9yZWcsCQlcDQo+ICsJCQljb3VudGVyX3NldC5ldGhfODAyXzNf
Y250cnNfZ3JwX2RhdGFfbGF5b3V0LmMjIw0KPiBfaGlnaCkpKQ0KPiArDQo+ICt2b2lkIG1seDVl
X3N0YXRzX3BhdXNlX2dldChzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCj4gKwkJCSAgIHN0cnVj
dCBldGh0b29sX3BhdXNlX3N0YXRzICpwYXVzZV9zdGF0cykNCj4gK3sNCj4gKwlzdHJ1Y3QgbWx4
NWVfcHBvcnRfc3RhdHMgKnBzdGF0cyA9ICZwcml2LT5zdGF0cy5wcG9ydDsNCj4gKwlzdHJ1Y3Qg
bWx4NV9jb3JlX2RldiAqbWRldiA9IHByaXYtPm1kZXY7DQo+ICsJdTMyIGluW01MWDVfU1RfU1pf
RFcocHBjbnRfcmVnKV0gPSB7MH07DQogICAgIG5vIG5lZWQgZm9yIGV4cGxpY2l0IGFycmF5IGlu
aXRpYWxpemVyIF5eIGp1c3Qge30gc2hvdWxkIGJlIGdvb2QNCmVub3VnaC4NCg0KPiArCWludCBz
eiA9IE1MWDVfU1RfU1pfQllURVMocHBjbnRfcmVnKTsNCj4gKwl2b2lkICpvdXQ7DQo+ICsNCj4g
KwlpZiAoIU1MWDVfQkFTSUNfUFBDTlRfU1VQUE9SVEVEKG1kZXYpKQ0KPiArCQlyZXR1cm47DQo+
ICsNCj4gKwlNTFg1X1NFVChwcGNudF9yZWcsIGluLCBsb2NhbF9wb3J0LCAxKTsNCj4gKwlvdXQg
PSBwc3RhdHMtPklFRUVfODAyXzNfY291bnRlcnM7DQoNCnlvdSBhcmUgcmVhZGluZyB0aGUgb3V0
Ym94IGJ1ZmZlciBpbnRvIGEgc2hhcmVkIGJ1ZmZlciwgYW5kIHRoaXMgY291bGQNCmxlYWQgdG8g
d2VpcmQgcmFjZSBjb25kaXRpb25zIHdpdGggZXRodG9vbCBzdGF0cywgbWF5YmUgYm90aCBldGh0
b29sDQpzdGF0cyBhbmQgcGF1c2Vfc3RhdHMgYXJlIHByb3RlY3RlZCB3aXRoIHJ0bmxfbG9jaywg
YnV0IGxldCdzIG5vdCBtYWtlDQphbnkgYXNzdW1wdGlvbiBoZXJlIGFuZCB1c2UgYSBsb2NhbCBi
dWZmZXIgZm9yIHRoaXMgZmxvdyBhbnl3YXkuDQoNCmp1c3QgZGVmaW5lICJvdXQiIHRvIGJlDQp1
MzIgcHBjbnRfaWVlZV84MDJfM1tNTFg1X1NUX1NaX0RXKHBwY250X3JlZyldOw0KDQpJIGhvcGUg
dGhpcyBpcyBub3QgdG9vIGJpZyBmb3IgdGhlIHN0YWNrLg0KDQo+ICsJTUxYNV9TRVQocHBjbnRf
cmVnLCBpbiwgZ3JwLCBNTFg1X0lFRUVfODAyXzNfQ09VTlRFUlNfR1JPVVApOw0KPiArCW1seDVf
Y29yZV9hY2Nlc3NfcmVnKG1kZXYsIGluLCBzeiwgb3V0LCBzeiwgTUxYNV9SRUdfUFBDTlQsIDAs
IA0KICAgICAgICAgICAgICAgICAgICAgICAgcmVwbGFjZSAib3V0IiBoZXJlIF5eXiB3aXRoIHBw
Y250X2llZWVfODAyXzMNCg0KPiAwKTsNCj4gKw0KPiArCXBhdXNlX3N0YXRzLT50eF9wYXVzZV9m
cmFtZXMgPQ0KPiArCQlNTFg1RV9SRUFEX0NUUjY0X0JFX0YoJnByaXYtDQo+ID5zdGF0cy5wcG9y
dC5JRUVFXzgwMl8zX2NvdW50ZXJzLA0KPiArCQkJCSAgICAgIGFfcGF1c2VfbWFjX2N0cmxfZnJh
bWVzX3RyYW5zbWl0dA0KPiBlZCk7DQo+ICsJcGF1c2Vfc3RhdHMtPnJ4X3BhdXNlX2ZyYW1lcyA9
DQo+ICsJCU1MWDVFX1JFQURfQ1RSNjRfQkVfRigmcHJpdi0NCj4gPnN0YXRzLnBwb3J0LklFRUVf
ODAyXzNfY291bnRlcnMsDQo+ICsJCQkJICAgICAgYV9wYXVzZV9tYWNfY3RybF9mcmFtZXNfcmVj
ZWl2ZWQpDQo+IDsNCg0KaW4gdGhlIGFib3ZlIDIgbGluZXMgeW91IGNvdWxkIGhhdmUganVzdCB1
c2VkICJvdXQiIGluc3RlYWQgb2YgDQomcHJpdi0+c3RhdHMucHBvcnQuSUVFRV84MDJfM19jb3Vu
dGVycywgYnV0IHdpdGggbXkgc3VnZ2VzdGlvbiBhYm92ZQ0KanVzdCB1c2UgdGhlIGxvY2FsIGJ1
ZmZlci4NCg0KDQoNCj4gK30NCj4gKw0KPiAgI2RlZmluZSBQUE9SVF8yODYzX09GRihjKSBcDQo+
ICAJTUxYNV9CWVRFX09GRihwcGNudF9yZWcsIFwNCj4gIAkJICAgICAgY291bnRlcl9zZXQuZXRo
XzI4NjNfY250cnNfZ3JwX2RhdGFfbGF5b3V0LmMjI19oaQ0KPiBnaCkNCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5oDQo+IGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3N0YXRzLmgNCj4gaW5k
ZXggMmUxY2NhMTkyM2I5Li45ZDllZTI2OWEwNDEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5oDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5oDQo+IEBAIC0xMDQsNiAr
MTA0LDkgQEAgdm9pZCBtbHg1ZV9zdGF0c191cGRhdGUoc3RydWN0IG1seDVlX3ByaXYgKnByaXYp
Ow0KPiAgdm9pZCBtbHg1ZV9zdGF0c19maWxsKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LCB1NjQg
KmRhdGEsIGludCBpZHgpOw0KPiAgdm9pZCBtbHg1ZV9zdGF0c19maWxsX3N0cmluZ3Moc3RydWN0
IG1seDVlX3ByaXYgKnByaXYsIHU4ICpkYXRhKTsNCj4gIA0KPiArdm9pZCBtbHg1ZV9zdGF0c19w
YXVzZV9nZXQoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQo+ICsJCQkgICBzdHJ1Y3QgZXRodG9v
bF9wYXVzZV9zdGF0cyAqcGF1c2Vfc3RhdHMpOw0KPiArDQo+ICAvKiBDb25jcmV0ZSBOSUMgU3Rh
dHMgKi8NCj4gIA0KPiAgc3RydWN0IG1seDVlX3N3X3N0YXRzIHsNCg==
