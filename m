Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD9CAF538
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 07:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfIKFDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 01:03:52 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:33346 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfIKFDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 01:03:52 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8B53HEo023307;
        Wed, 11 Sep 2019 01:03:38 -0400
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2053.outbound.protection.outlook.com [104.47.48.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uv967mnxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 01:03:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9IokxyF9d1mieG5GC138owNyneBijTHg+eZKQwbjhWZGMPkE1uBzNzhiYu1qVUkubYF+tXf2xLVj+59ejxVyf5zU7deCAOhYWTbK9PEnnLH12f6ESJfzb/RiHGNgIBdDdF+36HWhRG/Xtjz7SgZFdJ/IHEgKnbr4jd/3tSIMm8ng0n4LEU5EYzZBZQkgdN6OQwuMS4eOVl2kijiTzd5iiAop461OCFc3OwqOM6xEAere/YkKvuWbWMteP2cT/zMa/v1hVetJaiLmGRyAwNhvpD1ofDOfX08JRp9eGQRJrGSvSMYsLPNOw0PgCnQyLi2YLd1cYE6SF0VAKHT1SG3AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2WMo+m1AAE1eZBl1EPzJZh7GOVLQQ3Wq8YlseAqhGg=;
 b=DxanoqG6mKgZIXdwlTtOGfH9h+j6o27kTmC3IhzbYmHrz7pd9QzccFHjSy68Yw3HnBGJKMeQ2jGSWHyHNyF22bqnp9AFjoTKNkVjfT3z4HQJ4ravaAxVQmkkuVy1V8BLXDOAAA1NdHupw6WKhi5xiAYAZklTA9yY4ElO70W/bPJ6rBKsDOwu6tvyxYtLG9DYzSQJ41gs4wT58uH+6Pg0npRO6x4scLhjxooA3miMGOO8s9W+QxkCyO/j+Hlj3EHYa4kP88RdqdHTRb4wCmkl6nm60EGNIdDxc6VuEsbedMdDJTsKgLI3cNT61ZWfOTzNETbG5kQ4lzOXoXaLlUwmMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2WMo+m1AAE1eZBl1EPzJZh7GOVLQQ3Wq8YlseAqhGg=;
 b=Dm5B759GP+9RgcmCU8OcyQXVSpgP36As111oGCFksIgJ0+rDgoP7ApA2L0Fs3hCrEIhXRuVr4IKWexO9ArkOaSpTxEro2PTPI/UqpXB4p08nTNiLrnv0A9s9KY9896oRBIIULsslWRt4EbjCxlMdF3g67zt6GvcUCVfCHKZUExo=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5160.namprd03.prod.outlook.com (20.180.5.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 05:03:36 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b%3]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 05:03:36 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>
Subject: Re: [PATCH] net: stmmac: socfpga: re-use the `interface` parameter
 from platform data
Thread-Topic: [PATCH] net: stmmac: socfpga: re-use the `interface` parameter
 from platform data
Thread-Index: AQHVZK71MotWq7Szq0ysUG4QFG+T4qclFD4AgAAAU4CAARDhAA==
Date:   Wed, 11 Sep 2019 05:03:35 +0000
Message-ID: <06fc03662b540b057d214c85932ae2520ac7182f.camel@analog.com>
References: <20190906123054.5514-1-alexandru.ardelean@analog.com>
         <20190910.174544.945128884852877943.davem@davemloft.net>
         <20190910.174653.800353422834551780.davem@davemloft.net>
In-Reply-To: <20190910.174653.800353422834551780.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac2185ad-6a56-44d9-15fd-08d7367566e0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CH2PR03MB5160;
x-ms-traffictypediagnostic: CH2PR03MB5160:
x-microsoft-antispam-prvs: <CH2PR03MB51606CEEEC49CC2A047A6289F9B10@CH2PR03MB5160.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(346002)(396003)(199004)(189003)(256004)(4326008)(2501003)(91956017)(81156014)(3846002)(2351001)(2616005)(8676002)(76116006)(14454004)(476003)(1730700003)(6116002)(5660300002)(66066001)(71190400001)(7736002)(66946007)(6506007)(81166006)(25786009)(118296001)(66476007)(478600001)(305945005)(71200400001)(186003)(26005)(486006)(86362001)(5640700003)(229853002)(76176011)(316002)(6512007)(6246003)(6436002)(6486002)(102836004)(8936002)(53936002)(6916009)(36756003)(446003)(11346002)(99286004)(2906002)(66556008)(64756008)(54906003)(66446008)(81973001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5160;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2hNQ/ivRqDEh1GYD/gga26qN1IBDGXuVBDq6NAUNhcNhnxecSZqsd234GkCsCTv4jawVanll1wfTeZZ1VooASpu7Z+LEwMaoEstLtSQXh5xddk0kzgcdjTn1Y/2vtF+6LKdea6gD3hKheanDXUHN41gNWSIa9GZLGEBYK3VnBUSS50xd55F8VYUa/+fwLiPd0gWaJHEUA2ayHnyxZE9Vqfrc6YlRyzPa+dxifJqIyelppAoS8PiwKBYWAlZtvmkphAQW6tBsFb6ciwyVb0M3jKmUAX3Ja3EV9YaHqr5fiCe8TAK8dsvFUX5v2ZUHvfU2wKkIecYfYj4c+ehNSMK8pRs8nc3er9f6IZITaUM/7QEsvDQQi42IWwgtrVlgoSd+Of5yLUAblEwGkDu3pNQbJZg7E3nNgPbF7ypdXQhcQLg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <46B7C1F905245E4D83428112B3686E68@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac2185ad-6a56-44d9-15fd-08d7367566e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 05:03:35.8637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jktkrWhPAHm8O6quKTk9pHuXm8fKLn7eULd44mupLV1cp0a50ylhgXY0yG3uOt4AjqimLN40qxlPWdShrqUf+zmUcL5/qUu+alWISHTd3BQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5160
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_03:2019-09-10,2019-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909110048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTEwIGF0IDE3OjQ2ICswMjAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IFtFeHRlcm5hbF0NCj4gDQo+IEZyb206IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD4NCj4gRGF0ZTogVHVlLCAxMCBTZXAgMjAxOSAxNzo0NTo0NCArMDIwMCAoQ0VTVCkNCj4gDQo+
ID4gRnJvbTogQWxleGFuZHJ1IEFyZGVsZWFuIDxhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9nLmNv
bT4NCj4gPiBEYXRlOiBGcmksIDYgU2VwIDIwMTkgMTU6MzA6NTQgKzAzMDANCj4gPiANCj4gPiA+
IFRoZSBzb2NmcGdhIHN1Yi1kcml2ZXIgZGVmaW5lcyBhbiBgaW50ZXJmYWNlYCBmaWVsZCBpbiB0
aGUgYHNvY2ZwZ2FfZHdtYWNgDQo+ID4gPiBzdHJ1Y3QgYW5kIHBhcnNlcyBpdCBvbiBpbml0Lg0K
PiA+ID4gDQo+ID4gPiBUaGUgc2hhcmVkIGBzdG1tYWNfcHJvYmVfY29uZmlnX2R0KClgIGZ1bmN0
aW9uIGFsc28gcGFyc2VzIHRoaXMgZnJvbSB0aGUNCj4gPiA+IGRldmljZS10cmVlIGFuZCBtYWtl
cyBpdCBhdmFpbGFibGUgb24gdGhlIHJldHVybmVkIGBwbGF0X2RhdGFgICh3aGljaCBpcw0KPiA+
ID4gdGhlIHNhbWUgZGF0YSBhdmFpbGFibGUgdmlhIGBuZXRkZXZfcHJpdigpYCkuDQo+ID4gPiAN
Cj4gPiA+IEFsbCB0aGF0J3MgbmVlZGVkIG5vdyBpcyB0byBkaWcgdGhhdCBpbmZvcm1hdGlvbiBv
dXQsIHZpYSBzb21lDQo+ID4gPiBgZGV2X2dldF9kcnZkYXRhKClgICYmIGBuZXRkZXZfcHJpdigp
YCBjYWxscyBhbmQgcmUtdXNlIGl0Lg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4
YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5hcmRlbGVhbkBhbmFsb2cuY29tPg0KPiA+IA0KPiA+
IFRoaXMgZG9lc24ndCBidWlsZCBldmVuIG9uIG5ldC1uZXh0Lg0KPiANCg0KUmlnaHQuDQpNeSBi
YWQuDQoNCkkgdGhpbmsgSSBnb3QgY29uZnVzZWQgd2l0aCBtdWx0aXBsZS9jcm9zcy10ZXN0aW5n
IGFuZCBwcm9iYWJseSB0aGlzIGNoYW5nZSBkaWRuJ3QgZXZlbiBnZXQgY29tcGlsZWQuDQoNCkFw
b2xvZ2llcyBmb3IgdGhpcy4NCldpbGwgc2VuZCBhIGdvb2QgdmVyc2lvbi4NCg0KQWxleA0KDQo+
IFNwZWNpZmljYWxseToNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFj
L2R3bWFjLXNvY2ZwZ2EuYzogSW4gZnVuY3Rpb24g4oCYc29jZnBnYV9nZW41X3NldF9waHlfbW9k
ZeKAmToNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtc29jZnBn
YS5jOjI2NDo0NDogZXJyb3I6IOKAmHBoeW1vZGXigJkgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGlu
IHRoaXMgZnVuY3Rpb24pOw0KPiBkaWQgeW91IG1lYW4g4oCYcGh5X21vZGVz4oCZPw0KPiAgIDI2
NCB8ICAgZGV2X2Vycihkd21hYy0+ZGV2LCAiYmFkIHBoeSBtb2RlICVkXG4iLCBwaHltb2RlKTsN
Cj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+
fn5+fg0KPiAuL2luY2x1ZGUvbGludXgvZGV2aWNlLmg6MTQ5OTozMjogbm90ZTogaW4gZGVmaW5p
dGlvbiBvZiBtYWNybyDigJhkZXZfZXJy4oCZDQo+ICAxNDk5IHwgIF9kZXZfZXJyKGRldiwgZGV2
X2ZtdChmbXQpLCAjI19fVkFfQVJHU19fKQ0KPiAgICAgICB8ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBefn5+fn5+fn5+fg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0
bW1hYy9kd21hYy1zb2NmcGdhLmM6MjY0OjQ0OiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRp
ZmllciBpcyByZXBvcnRlZCBvbmx5IG9uY2UgZm9yDQo+IGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFy
cyBpbg0KPiAgIDI2NCB8ICAgZGV2X2Vycihkd21hYy0+ZGV2LCAiYmFkIHBoeSBtb2RlICVkXG4i
LCBwaHltb2RlKTsNCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXn5+fn5+fg0KPiAuL2luY2x1ZGUvbGludXgvZGV2aWNlLmg6MTQ5OTozMjogbm90
ZTogaW4gZGVmaW5pdGlvbiBvZiBtYWNybyDigJhkZXZfZXJy4oCZDQo+ICAxNDk5IHwgIF9kZXZf
ZXJyKGRldiwgZGV2X2ZtdChmbXQpLCAjI19fVkFfQVJHU19fKQ0KPiAgICAgICB8ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fg0KPiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9kd21hYy1zb2NmcGdhLmM6IEluIGZ1bmN0aW9uIOKAmHNvY2ZwZ2Ff
Z2VuMTBfc2V0X3BoeV9tb2Rl4oCZOg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0
bW1hYy9kd21hYy1zb2NmcGdhLmM6MzQwOjY6IGVycm9yOiDigJhwaHltb2Rl4oCZIHVuZGVjbGFy
ZWQgKGZpcnN0IHVzZSBpbiB0aGlzIGZ1bmN0aW9uKTsNCj4gZGlkIHlvdSBtZWFuIOKAmHBoeV9t
b2Rlc+KAmT8NCj4gICAzNDAgfCAgICAgIHBoeW1vZGUgPT0gUEhZX0lOVEVSRkFDRV9NT0RFX01J
SSB8fA0KPiAgICAgICB8ICAgICAgXn5+fn5+fg0KPiAgICAgICB8ICAgICAgcGh5X21vZGVzDQo=
