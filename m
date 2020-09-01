Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EA7258E1A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgIAMVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:21:04 -0400
Received: from mail-db8eur05on2110.outbound.protection.outlook.com ([40.107.20.110]:59104
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727977AbgIAMSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 08:18:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QW5r5XKH+l9Gv0UigUAybgK1xbFHYM/0z6j0VeUz85534loP5ER1n67HqYtMIerh1hyEJKV2HmC1+0U2KhIrfmXnki0XIR0ONebY18h4grWrmKDfL10fRjs7+MNGfERMBDt57KqcnNwKyMynD+PkxQ34Hf4GgR+oQY9TW+e6FaOWk/DuTlleIhkqKvVMkrukH5ScnIF0xqTj0lWrVa5aZtQwta2xplNRvN+ciziP+fqLI5+ggMr4dGfM6yHDCdjcOU6vin17dZkG69QuFRONHW9qX9Ato+HXPly+sp/tLorWzRgfzpYhnZX6fim2ZZZHU3TINKg5ujLyKM0t7wEwhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ic6++jyXAiZS/unBXLvMAjW1izu2NOmeT/ItKplQzgQ=;
 b=RcP+I7czovz44JEPO2SkZmVtqJHYK5v8xf03PBna7voncsA9zZP/zxnBhW6V35Wg1250ZvsFYTJRXz53+I3ryCIg6TAxx9h1tYZRXBCpUsskQAffaMB6wMUu+TUtACNQ4t1E/Iv/m/MFMrL06pbdnoPVM7LagtbVSiHcvcV0iqXgLreIAfNbP7ZlRSHJsnPe15rmPcGHQLfY4yOk7gJRTUsVuw91MUyRAOKw020gk50Snr0wDzBm2CHsgnfx+SbitayHXBJWKjUS6i0+RsFI8JXIqTl279Yru/bu5q473Of/9u7kVA/o76dwCVHNXO+GmmwmaWBgxsF9TSUzKvJzAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ic6++jyXAiZS/unBXLvMAjW1izu2NOmeT/ItKplQzgQ=;
 b=u6dPzU5V46gKrAWCGyGnmVZeZp2GGg8CvGuxhS1U5S+W7ApcBYmaHlH+Z/aRNJmhd7tNPWQSBWoUSuW/M8AgxzxHuCjQdPRU2e2OxpIfpt6g0CZq9hqf5ZE9PaFr4gr2YaQQk2A+UQPwdSp9F7HuB3UYqVC85UYPuApE1BPkmuU=
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB4915.eurprd05.prod.outlook.com (2603:10a6:208:cb::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Tue, 1 Sep
 2020 12:18:24 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 12:18:24 +0000
From:   Tuong Tong Lien <tuong.t.lien@dektech.com.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
Subject: RE: [net] tipc: fix using smp_processor_id() in preemptible
Thread-Topic: [net] tipc: fix using smp_processor_id() in preemptible
Thread-Index: AQHWfoc+himFBG6tQEGws4qIktdqQalR4IkAgAACUeCAABe0AIAAAmDQgAAv7QCAAYkt0A==
Date:   Tue, 1 Sep 2020 12:18:24 +0000
Message-ID: <AM8PR05MB7332BE4B6E0381D2894E057AE22E0@AM8PR05MB7332.eurprd05.prod.outlook.com>
References: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
 <f81eafce-e1d1-bb18-cb70-cfdf45bb2ed0@gmail.com>
 <AM8PR05MB733222C45D3F0CC19E909BB0E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <0ed21ba7-2b3b-9d4f-563e-10d329ebeecb@gmail.com>
 <AM8PR05MB7332E91A67120D78823353F6E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <3f858962-4e38-0b72-4341-1304ec03cd7a@gmail.com>
In-Reply-To: <3f858962-4e38-0b72-4341-1304ec03cd7a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
x-originating-ip: [183.80.118.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a156a7d4-f5a4-43c8-8745-08d84e711fb6
x-ms-traffictypediagnostic: AM0PR05MB4915:
x-microsoft-antispam-prvs: <AM0PR05MB4915B8D7609E22CAD9AEF8A8E22E0@AM0PR05MB4915.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EGcsnYk4tqUeaK0SuRXt0x61qCIeVH7yVOddU5zauM8g9wctu2Zd89ATG3rR7qZngglCdAXDp+QORgwPHjfgYL3GUVvcYuK3abI/U/UnSBvNah3EJg8mD1DO0RhxuYzlXlYYS/zsQhrY4gQskBc2cLs2tQ7hkCw4tGBRGDnbsPv2GQ/5PHG6uBYkZG+pyrADtlYLbhXc/AMepiFIkZAueIuspdNFLLprfeFfB7177e+dVhTqtHkWXAk1dGTMC2C1FRXXv8Omk6dJtGmHVLJgA1zqKiRpTSiwbYJNf22rMO1DO6o4qcVOTKE8UIu/QvTwvtCQ28WGx6h3ZL/jxr2RxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(396003)(39850400004)(55016002)(66476007)(4326008)(86362001)(66556008)(64756008)(53546011)(2906002)(76116006)(66446008)(26005)(6506007)(7696005)(52536014)(83380400001)(66946007)(186003)(71200400001)(316002)(8936002)(5660300002)(9686003)(33656002)(110136005)(8676002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Drd6r2x4itg5vsg9U6ZOGtTEZ2skJihwEQYKST38bYpNUjtoOb2zbWyUNhfBI5iO7J2vugB85Gcn/Mdhd2C1fzZcRWlUYBvVvrNiF+jZ6wuik589b3E5ECPm4A3R26nl8jDzzM1TC/PqKxjtMjLrqGckV7e3rm5FlsyPiEQ1bJwgLj9j4cEguIh7kDbNAG29p1oMwfVBrJvT84hleLzqggC/9CCUNBAn9uSjvZlmQ4QIkkr78jx7Nqk14wXsieLFAqfaLoaCvwJdlS2kIg9OsedrRmsxANP4qMu9kYi5VviyGK7eDXskvUeXQ9B7F8sC5lO+Wgmh4Hmd0fXhEQspjoNG1fX/Oqu2ONgz79IQUlqPOXBy4P2Vti6o5+Oqa2me0aS2Vn1ywps7uzBoEoB6HlOgFHloOMLwrBNdcMYnuWjVOW3Y5IC+GYxrwPlqkdcpZDyytm9A9oeCtdswTWY2lw9H0Jdp5f7Te1EfXEeEi2ZE+D60p+OnIX2G3s9qUNcheODGdVjY2t9WHtkfL6mnsK25xKPJDGJtJtpIZPB+yZEkHBZydYqbp9bLZV+FdZUAyQulwy8TExSoitI82gk+rdQa3qGbcmyYnwYOMuZTmR7LIln/v541gCsMUFZ8r+Xiiotsasj4BxbbJdLFQxf5AQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a156a7d4-f5a4-43c8-8745-08d84e711fb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2020 12:18:24.2186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n9ZMwLU5nQ6gP6va/lNoThcwebhyEE4Dzce7eqNMzwMWkFsZk2LE+s5xA4vo/ypv8APpY3+TkwXlVVLEP/uUjHboB8Oh0+Xvrv9rvbnZWs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4915
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
cmljLmR1bWF6ZXRAZ21haWwuY29tPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAzMSwgMjAyMCA3
OjQ4IFBNDQo+IFRvOiBUdW9uZyBUb25nIExpZW4gPHR1b25nLnQubGllbkBkZWt0ZWNoLmNvbS5h
dT47IEVyaWMgRHVtYXpldCA8ZXJpYy5kdW1hemV0QGdtYWlsLmNvbT47IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7DQo+IGptYWxveUByZWRoYXQuY29tOyBtYWxveUBkb25qb25uLmNvbTsgeWluZy54dWVA
d2luZHJpdmVyLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogdGlwYy1kaXNjdXNz
aW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldA0KPiBTdWJqZWN0OiBSZTogW25ldF0gdGlwYzogZml4
IHVzaW5nIHNtcF9wcm9jZXNzb3JfaWQoKSBpbiBwcmVlbXB0aWJsZQ0KPiANCj4gDQo+IA0KPiBP
biA4LzMxLzIwIDM6MDUgQU0sIFR1b25nIFRvbmcgTGllbiB3cm90ZToNCj4gPg0KPiA+DQo+ID4+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEVyaWMgRHVtYXpldCA8ZXJp
Yy5kdW1hemV0QGdtYWlsLmNvbT4NCj4gPj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMzEsIDIwMjAg
NDo0OCBQTQ0KPiA+PiBUbzogVHVvbmcgVG9uZyBMaWVuIDx0dW9uZy50LmxpZW5AZGVrdGVjaC5j
b20uYXU+OyBFcmljIER1bWF6ZXQgPGVyaWMuZHVtYXpldEBnbWFpbC5jb20+OyBkYXZlbUBkYXZl
bWxvZnQubmV0Ow0KPiA+PiBqbWFsb3lAcmVkaGF0LmNvbTsgbWFsb3lAZG9uam9ubi5jb207IHlp
bmcueHVlQHdpbmRyaXZlci5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gQ2M6IHRp
cGMtZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQNCj4gPj4gU3ViamVjdDogUmU6IFtu
ZXRdIHRpcGM6IGZpeCB1c2luZyBzbXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUNCj4g
Pj4NCj4gPj4NCj4gPj4NCj4gPj4gT24gOC8zMS8yMCAxOjMzIEFNLCBUdW9uZyBUb25nIExpZW4g
d3JvdGU6DQo+ID4+PiBIaSBFcmljLA0KPiA+Pj4NCj4gPj4+IFRoYW5rcyBmb3IgeW91ciBjb21t
ZW50cywgcGxlYXNlIHNlZSBteSBhbnN3ZXJzIGlubGluZS4NCj4gPj4+DQo+ID4+Pj4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4+PiBGcm9tOiBFcmljIER1bWF6ZXQgPGVyaWMuZHVt
YXpldEBnbWFpbC5jb20+DQo+ID4+Pj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMzEsIDIwMjAgMzox
NSBQTQ0KPiA+Pj4+IFRvOiBUdW9uZyBUb25nIExpZW4gPHR1b25nLnQubGllbkBkZWt0ZWNoLmNv
bS5hdT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGptYWxveUByZWRoYXQuY29tOyBtYWxveUBkb25q
b25uLmNvbTsNCj4gPj4+PiB5aW5nLnh1ZUB3aW5kcml2ZXIuY29tOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnDQo+ID4+Pj4gQ2M6IHRpcGMtZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQN
Cj4gPj4+PiBTdWJqZWN0OiBSZTogW25ldF0gdGlwYzogZml4IHVzaW5nIHNtcF9wcm9jZXNzb3Jf
aWQoKSBpbiBwcmVlbXB0aWJsZQ0KPiA+Pj4+DQo+ID4+Pj4NCj4gPj4+Pg0KPiA+Pj4+IE9uIDgv
MjkvMjAgMTI6MzcgUE0sIFR1b25nIExpZW4gd3JvdGU6DQo+ID4+Pj4+IFRoZSAndGhpc19jcHVf
cHRyKCknIGlzIHVzZWQgdG8gb2J0YWluIHRoZSBBRUFEIGtleScgVEZNIG9uIHRoZSBjdXJyZW50
DQo+ID4+Pj4+IENQVSBmb3IgZW5jcnlwdGlvbiwgaG93ZXZlciB0aGUgZXhlY3V0aW9uIGNhbiBi
ZSBwcmVlbXB0aWJsZSBzaW5jZSBpdCdzDQo+ID4+Pj4+IGFjdHVhbGx5IHVzZXItc3BhY2UgY29u
dGV4dCwgc28gdGhlICd1c2luZyBzbXBfcHJvY2Vzc29yX2lkKCkgaW4NCj4gPj4+Pj4gcHJlZW1w
dGlibGUnIGhhcyBiZWVuIG9ic2VydmVkLg0KPiA+Pj4+Pg0KPiA+Pj4+PiBXZSBmaXggdGhlIGlz
c3VlIGJ5IHVzaW5nIHRoZSAnZ2V0L3B1dF9jcHVfcHRyKCknIEFQSSB3aGljaCBjb25zaXN0cyBv
Zg0KPiA+Pj4+PiBhICdwcmVlbXB0X2Rpc2FibGUoKScgaW5zdGVhZC4NCj4gPj4+Pj4NCj4gPj4+
Pj4gRml4ZXM6IGZjMWI2ZDZkZTIyMCAoInRpcGM6IGludHJvZHVjZSBUSVBDIGVuY3J5cHRpb24g
JiBhdXRoZW50aWNhdGlvbiIpDQo+ID4+Pj4NCj4gPj4+PiBIYXZlIHlvdSBmb3Jnb3R0ZW4gJyBS
ZXBvcnRlZC1ieTogc3l6Ym90KzI2M2Y4YzBkMDA3ZGMwOWIyZGRhQHN5emthbGxlci5hcHBzcG90
bWFpbC5jb20nID8NCj4gPj4+IFdlbGwsIHJlYWxseSBJIGRldGVjdGVkIHRoZSBpc3N1ZSBkdXJp
bmcgbXkgdGVzdGluZyBpbnN0ZWFkLCBkaWRuJ3Qga25vdyBpZiBpdCB3YXMgcmVwb3J0ZWQgYnkg
c3l6Ym90IHRvby4NCj4gPj4+DQo+ID4+Pj4NCj4gPj4+Pj4gQWNrZWQtYnk6IEpvbiBNYWxveSA8
am1hbG95QHJlZGhhdC5jb20+DQo+ID4+Pj4+IFNpZ25lZC1vZmYtYnk6IFR1b25nIExpZW4gPHR1
b25nLnQubGllbkBkZWt0ZWNoLmNvbS5hdT4NCj4gPj4+Pj4gLS0tDQo+ID4+Pj4+ICBuZXQvdGlw
Yy9jcnlwdG8uYyB8IDEyICsrKysrKysrKy0tLQ0KPiA+Pj4+PiAgMSBmaWxlIGNoYW5nZWQsIDkg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPj4+Pj4NCj4gPj4+Pj4gZGlmZiAtLWdp
dCBhL25ldC90aXBjL2NyeXB0by5jIGIvbmV0L3RpcGMvY3J5cHRvLmMNCj4gPj4+Pj4gaW5kZXgg
YzM4YmFiYWE0ZTU3Li43YzUyM2RjODE1NzUgMTAwNjQ0DQo+ID4+Pj4+IC0tLSBhL25ldC90aXBj
L2NyeXB0by5jDQo+ID4+Pj4+ICsrKyBiL25ldC90aXBjL2NyeXB0by5jDQo+ID4+Pj4+IEBAIC0z
MjYsNyArMzI2LDggQEAgc3RhdGljIHZvaWQgdGlwY19hZWFkX2ZyZWUoc3RydWN0IHJjdV9oZWFk
ICpycCkNCj4gPj4+Pj4gIAlpZiAoYWVhZC0+Y2xvbmVkKSB7DQo+ID4+Pj4+ICAJCXRpcGNfYWVh
ZF9wdXQoYWVhZC0+Y2xvbmVkKTsNCj4gPj4+Pj4gIAl9IGVsc2Ugew0KPiA+Pj4+PiAtCQloZWFk
ID0gKnRoaXNfY3B1X3B0cihhZWFkLT50Zm1fZW50cnkpOw0KPiA+Pj4+PiArCQloZWFkID0gKmdl
dF9jcHVfcHRyKGFlYWQtPnRmbV9lbnRyeSk7DQo+ID4+Pj4+ICsJCXB1dF9jcHVfcHRyKGFlYWQt
PnRmbV9lbnRyeSk7DQo+ID4+Pj4NCj4gPj4+PiBXaHkgaXMgdGhpcyBzYWZlID8NCj4gPj4+Pg0K
PiA+Pj4+IEkgdGhpbmsgdGhhdCB0aGlzIHZlcnkgdW51c3VhbCBjb25zdHJ1Y3QgbmVlZHMgYSBj
b21tZW50LCBiZWNhdXNlIHRoaXMgaXMgbm90IG9idmlvdXMuDQo+ID4+Pj4NCj4gPj4+PiBUaGlz
IHJlYWxseSBsb29rcyBsaWtlIGFuIGF0dGVtcHQgdG8gc2lsZW5jZSBzeXpib3QgdG8gbWUuDQo+
ID4+PiBObywgdGhpcyBpcyBub3QgdG8gc2lsZW5jZSBzeXpib3QgYnV0IHJlYWxseSBzYWZlLg0K
PiA+Pj4gVGhpcyBpcyBiZWNhdXNlIHRoZSAiYWVhZC0+dGZtX2VudHJ5IiBvYmplY3QgaXMgImNv
bW1vbiIgYmV0d2VlbiBDUFVzLCB0aGVyZSBpcyBvbmx5IGl0cyBwb2ludGVyIHRvIGJlIHRoZSAi
cGVyX2NwdSIgb25lLiBTbw0KPiBqdXN0DQo+ID4+IHRyeWluZyB0byBsb2NrIHRoZSBwcm9jZXNz
IG9uIHRoZSBjdXJyZW50IENQVSBvciAncHJlZW1wdF9kaXNhYmxlKCknLCB0YWtpbmcgdGhlIHBl
ci1jcHUgcG9pbnRlciBhbmQgZGVyZWZlcmVuY2luZyB0byB0aGUgYWN0dWFsDQo+ID4+ICJ0Zm1f
ZW50cnkiIG9iamVjdC4uLiBpcyBlbm91Z2guIExhdGVyIG9uLCB0aGF04oCZcyBmaW5lIHRvIHBs
YXkgd2l0aCB0aGUgYWN0dWFsIG9iamVjdCB3aXRob3V0IGFueSBsb2NraW5nLg0KPiA+Pg0KPiA+
PiBXaHkgdXNpbmcgcGVyIGNwdSBwb2ludGVycywgaWYgdGhleSBhbGwgcG9pbnQgdG8gYSBjb21t
b24gb2JqZWN0ID8NCj4gPj4NCj4gPj4gVGhpcyBtYWtlcyB0aGUgY29kZSByZWFsbHkgY29uZnVz
aW5nLg0KPiA+IFNvcnJ5IGZvciBtYWtpbmcgeW91IGNvbmZ1c2VkLiBZZXMsIHRoZSBjb2RlIGlz
IGEgYml0IHVnbHkgYW5kIGNvdWxkIGJlIG1hZGUgaW4gc29tZSBvdGhlciB3YXlzLi4uIFRoZSBp
bml0aWFsIGlkZWEgaXMgdG8gbm90IHRvdWNoIG9yDQo+IGNoYW5nZSB0aGUgc2FtZSBwb2ludGVy
IHZhcmlhYmxlIGluIGRpZmZlcmVudCBDUFVzIHNvIGF2b2lkIGEgcGVuYWx0eSB3aXRoIHRoZSBj
YWNoZSBoaXRzL21pc3Nlcy4uLg0KPiANCj4gV2hhdCBtYWtlcyB0aGlzIGNvZGUgaW50ZXJydXB0
IHNhZmUgPw0KPiANCldoeSBpcyBpdCB1bnNhZmU/IEl0cyAicGFyZW50IiBvYmplY3QgaXMgYWxy
ZWFkeSBtYW5hZ2VkIGJ5IFJDVSBtZWNoYW5pc20uIEFsc28sIGl0IGlzIG5ldmVyIG1vZGlmaWVk
IGJ1dCBqdXN0ICJyZWFkLW9ubHkiIGluIGFsbCBjYXNlcy4uLg0KDQpCUi9UdW9uZw0KPiBIYXZp
bmcgYSBwZXItY3B1IGxpc3QgaXMgbm90IGludGVycnVwdCBzYWZlIHdpdGhvdXQgc3BlY2lhbCBj
YXJlLg0KPiANCj4gDQoNCg==
