Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF5E25771B
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 12:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHaKFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 06:05:16 -0400
Received: from mail-eopbgr70138.outbound.protection.outlook.com ([40.107.7.138]:59822
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726048AbgHaKFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 06:05:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBUyIIzO0/IItR9PCnNg9P2SejwiMSOIl74IC8FA57N2bZcrcoI0OaIusAYEX/NBuHbRO/H5sLIZgX7VByUqvt2d7TfhmvM4euqR1hvnZvAHm7rrjdKFVG5+o8ppnSgcng6qCvloyAWfqIJFMBqjqD9Qid7xuCNB2fJ53oDF6W7f9g5AyxOIALf/eT3TI0DExCpQbmLpozgRG9DBGJm4Nh5xxjZbDjQo9NGFREDflux7OQpSWDJV7xcAwyGdGbDNRl0vqfWE+5r5SWpeymFwi9Ii4VR907b0jQPJn36NVTh/akRoU0R9kMg9cPNVoDts6H2QE7XHf9NdHFswGC1xHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzFhkPNwjkwcX9zd7vVHtFlPZpYsJHVVvBMLmZBXgzI=;
 b=Ea30Dp7OVmmnJI8+XRkLlGGZuv5PorfNaAlpoWK2cszZ8glvGYr+PJf4B7L/iXnr+iyDcaU3OwUKvZ7jhBF8pGZk+gYPjZ/76uP9rs0lDv3SNpXq/x27WmVy3Jh6Gs5H0lR2bRuON+el6Ec8mWB36KOEZ1Ca/ngT6+3d1BJZmBhljOc9IEKfenpAAyqa7TCQisX1h/xb+cGY79XiBZGo+wOeXgxlo3VFD37P6HOSveJ3mhgfBdcCD7Pa19S7ds7k27NICo79klayiHL76vZANMvvUv8vLo4F4TTdPVVU3ADqv9unxFuGMN0ct+0NWm+y8+lBaMWPs+3w7zg8zDhijg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzFhkPNwjkwcX9zd7vVHtFlPZpYsJHVVvBMLmZBXgzI=;
 b=nT4sfc7odlqsWqZaWDhHdN31DUws5Y5DU/oqxFITQCVk4I+F12NTXJCWCp+kwX6W079D86692jC+tTx+gm+LsIH5CRX53pqfqYb64Ssj9lsCR74Z+uaBL+XHyGvFF7uhivWUPt1IcEUwCpqNOAECGDHTX9gn5KNQhcjVLF6ieZY=
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB4674.eurprd05.prod.outlook.com (2603:10a6:208:b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Mon, 31 Aug
 2020 10:05:07 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 10:05:07 +0000
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
Thread-Index: AQHWfoc+himFBG6tQEGws4qIktdqQalR4IkAgAACUeCAABe0AIAAAmDQ
Date:   Mon, 31 Aug 2020 10:05:07 +0000
Message-ID: <AM8PR05MB7332E91A67120D78823353F6E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
References: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
 <f81eafce-e1d1-bb18-cb70-cfdf45bb2ed0@gmail.com>
 <AM8PR05MB733222C45D3F0CC19E909BB0E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <0ed21ba7-2b3b-9d4f-563e-10d329ebeecb@gmail.com>
In-Reply-To: <0ed21ba7-2b3b-9d4f-563e-10d329ebeecb@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
x-originating-ip: [14.161.14.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0d8d669-bc7c-42c6-ce38-08d84d9556c4
x-ms-traffictypediagnostic: AM0PR05MB4674:
x-microsoft-antispam-prvs: <AM0PR05MB467473E0969242819804033BE2510@AM0PR05MB4674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: liGoKrZfAfMKe3RdmtZZ2IF43t1btN6u4GC9ig2sbDNGykYfNwlXJKjykoS016wy72obHRvBit4iVLfwNfCUYQA/5mkjO9DrULgH46Ol5XnI2+R8nGk2Yv7BccPGShyk0xLLtdGybo/BZs6eoSvC8d4gJHoeqfTu5kYZKM2iVd0CA+qphmntQG5TKtUxGAi3pvz51q7T4EVLCfKr+hrNPVP4yYmyrP0xeUrkVrfedcb+styDwsmEl973R1o14FOIfyqi40zxPE1YWBY39r69Wxgj2XS5PgW6PrhS+jbLfSsNE0gkAJCeHHeSKM/86Nk4cXkBtrI1poOwoAFcG5xkmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39850400004)(376002)(346002)(186003)(5660300002)(52536014)(6506007)(71200400001)(9686003)(86362001)(26005)(53546011)(4326008)(8936002)(2906002)(83380400001)(76116006)(316002)(33656002)(66476007)(66556008)(66446008)(66946007)(64756008)(8676002)(110136005)(55016002)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iSJ3wKA7TOgk7D+QBXxb9LX/DlnveDFM1p5WN7JNRmoO2N4xEVQZft1hPBhYpGvIx5lXX7BzRJJvG7zScEe/l/lwAqCv3AXRmYaahT8UTjRsOM0lJI9utroCHzf1j3548g92ldrmogKoRslFf40VoSkXdUdQj6PvB3CL4NKwidekO7l2K3hTYIzMcgOFhWQo4ZyBSiEtL63ZwU7lA+219P3hxZaCxMIlNI9UNO8u8dCk3igIYKbvbvNWbIATmXSdGiLKvpHOlm67/U8pyzPW2b8Twl6JlEkn1sXp0cvXowJ6qqoXr6f5XeDS0m6VwCSfMzGNCTPgoBJDPx7EnfSO632GN+yK1ln9dyx4wQdKW7EgyouFVy1NSCEuyIahA+uBIKTW6kpMrnttK+oQ93BKyL/ufOHIhwfsoYRUzWv8xY1ZACwYKfBdE4/euvXhzC3jg+ouNiE6TRU8IJHpOiQ1Vmynp+ARLY4ri6gAR+g0YlS/F7X5ROfzJSvhHGINvVJ7biALxY6ZDDZg6umbVMZRAk9zc4FjF1YKkvXrILchpmyGeUM+AXdjVvCl6GRfi2c5X4W1tkrMEO2NWxsGyDTkzk1s9BDs8nP8C6+AUtmvh3MwB8M1o3JAS4T2bfIm+3wotBnPHZX2HiUeZh4IOWfQ0g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d8d669-bc7c-42c6-ce38-08d84d9556c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2020 10:05:07.3103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NZ0OQsIl7GM9Jr/vUUZCsBO0hG0cNfyqsur8qNYYEAfvEDa/19Q3SCaPl0ni76oFsKVDOpbZyovNF1A2jTDdfgeTV2Tzf7g2FCkoeyXNCIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
cmljLmR1bWF6ZXRAZ21haWwuY29tPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAzMSwgMjAyMCA0
OjQ4IFBNDQo+IFRvOiBUdW9uZyBUb25nIExpZW4gPHR1b25nLnQubGllbkBkZWt0ZWNoLmNvbS5h
dT47IEVyaWMgRHVtYXpldCA8ZXJpYy5kdW1hemV0QGdtYWlsLmNvbT47IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7DQo+IGptYWxveUByZWRoYXQuY29tOyBtYWxveUBkb25qb25uLmNvbTsgeWluZy54dWVA
d2luZHJpdmVyLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogdGlwYy1kaXNjdXNz
aW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldA0KPiBTdWJqZWN0OiBSZTogW25ldF0gdGlwYzogZml4
IHVzaW5nIHNtcF9wcm9jZXNzb3JfaWQoKSBpbiBwcmVlbXB0aWJsZQ0KPiANCj4gDQo+IA0KPiBP
biA4LzMxLzIwIDE6MzMgQU0sIFR1b25nIFRvbmcgTGllbiB3cm90ZToNCj4gPiBIaSBFcmljLA0K
PiA+DQo+ID4gVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzLCBwbGVhc2Ugc2VlIG15IGFuc3dlcnMg
aW5saW5lLg0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206
IEVyaWMgRHVtYXpldCA8ZXJpYy5kdW1hemV0QGdtYWlsLmNvbT4NCj4gPj4gU2VudDogTW9uZGF5
LCBBdWd1c3QgMzEsIDIwMjAgMzoxNSBQTQ0KPiA+PiBUbzogVHVvbmcgVG9uZyBMaWVuIDx0dW9u
Zy50LmxpZW5AZGVrdGVjaC5jb20uYXU+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBqbWFsb3lAcmVk
aGF0LmNvbTsgbWFsb3lAZG9uam9ubi5jb207DQo+ID4+IHlpbmcueHVlQHdpbmRyaXZlci5jb207
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gQ2M6IHRpcGMtZGlzY3Vzc2lvbkBsaXN0cy5z
b3VyY2Vmb3JnZS5uZXQNCj4gPj4gU3ViamVjdDogUmU6IFtuZXRdIHRpcGM6IGZpeCB1c2luZyBz
bXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUNCj4gPj4NCj4gPj4NCj4gPj4NCj4gPj4g
T24gOC8yOS8yMCAxMjozNyBQTSwgVHVvbmcgTGllbiB3cm90ZToNCj4gPj4+IFRoZSAndGhpc19j
cHVfcHRyKCknIGlzIHVzZWQgdG8gb2J0YWluIHRoZSBBRUFEIGtleScgVEZNIG9uIHRoZSBjdXJy
ZW50DQo+ID4+PiBDUFUgZm9yIGVuY3J5cHRpb24sIGhvd2V2ZXIgdGhlIGV4ZWN1dGlvbiBjYW4g
YmUgcHJlZW1wdGlibGUgc2luY2UgaXQncw0KPiA+Pj4gYWN0dWFsbHkgdXNlci1zcGFjZSBjb250
ZXh0LCBzbyB0aGUgJ3VzaW5nIHNtcF9wcm9jZXNzb3JfaWQoKSBpbg0KPiA+Pj4gcHJlZW1wdGli
bGUnIGhhcyBiZWVuIG9ic2VydmVkLg0KPiA+Pj4NCj4gPj4+IFdlIGZpeCB0aGUgaXNzdWUgYnkg
dXNpbmcgdGhlICdnZXQvcHV0X2NwdV9wdHIoKScgQVBJIHdoaWNoIGNvbnNpc3RzIG9mDQo+ID4+
PiBhICdwcmVlbXB0X2Rpc2FibGUoKScgaW5zdGVhZC4NCj4gPj4+DQo+ID4+PiBGaXhlczogZmMx
YjZkNmRlMjIwICgidGlwYzogaW50cm9kdWNlIFRJUEMgZW5jcnlwdGlvbiAmIGF1dGhlbnRpY2F0
aW9uIikNCj4gPj4NCj4gPj4gSGF2ZSB5b3UgZm9yZ290dGVuICcgUmVwb3J0ZWQtYnk6IHN5emJv
dCsyNjNmOGMwZDAwN2RjMDliMmRkYUBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tJyA/DQo+ID4g
V2VsbCwgcmVhbGx5IEkgZGV0ZWN0ZWQgdGhlIGlzc3VlIGR1cmluZyBteSB0ZXN0aW5nIGluc3Rl
YWQsIGRpZG4ndCBrbm93IGlmIGl0IHdhcyByZXBvcnRlZCBieSBzeXpib3QgdG9vLg0KPiA+DQo+
ID4+DQo+ID4+PiBBY2tlZC1ieTogSm9uIE1hbG95IDxqbWFsb3lAcmVkaGF0LmNvbT4NCj4gPj4+
IFNpZ25lZC1vZmYtYnk6IFR1b25nIExpZW4gPHR1b25nLnQubGllbkBkZWt0ZWNoLmNvbS5hdT4N
Cj4gPj4+IC0tLQ0KPiA+Pj4gIG5ldC90aXBjL2NyeXB0by5jIHwgMTIgKysrKysrKysrLS0tDQo+
ID4+PiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4g
Pj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvbmV0L3RpcGMvY3J5cHRvLmMgYi9uZXQvdGlwYy9jcnlw
dG8uYw0KPiA+Pj4gaW5kZXggYzM4YmFiYWE0ZTU3Li43YzUyM2RjODE1NzUgMTAwNjQ0DQo+ID4+
PiAtLS0gYS9uZXQvdGlwYy9jcnlwdG8uYw0KPiA+Pj4gKysrIGIvbmV0L3RpcGMvY3J5cHRvLmMN
Cj4gPj4+IEBAIC0zMjYsNyArMzI2LDggQEAgc3RhdGljIHZvaWQgdGlwY19hZWFkX2ZyZWUoc3Ry
dWN0IHJjdV9oZWFkICpycCkNCj4gPj4+ICAJaWYgKGFlYWQtPmNsb25lZCkgew0KPiA+Pj4gIAkJ
dGlwY19hZWFkX3B1dChhZWFkLT5jbG9uZWQpOw0KPiA+Pj4gIAl9IGVsc2Ugew0KPiA+Pj4gLQkJ
aGVhZCA9ICp0aGlzX2NwdV9wdHIoYWVhZC0+dGZtX2VudHJ5KTsNCj4gPj4+ICsJCWhlYWQgPSAq
Z2V0X2NwdV9wdHIoYWVhZC0+dGZtX2VudHJ5KTsNCj4gPj4+ICsJCXB1dF9jcHVfcHRyKGFlYWQt
PnRmbV9lbnRyeSk7DQo+ID4+DQo+ID4+IFdoeSBpcyB0aGlzIHNhZmUgPw0KPiA+Pg0KPiA+PiBJ
IHRoaW5rIHRoYXQgdGhpcyB2ZXJ5IHVudXN1YWwgY29uc3RydWN0IG5lZWRzIGEgY29tbWVudCwg
YmVjYXVzZSB0aGlzIGlzIG5vdCBvYnZpb3VzLg0KPiA+Pg0KPiA+PiBUaGlzIHJlYWxseSBsb29r
cyBsaWtlIGFuIGF0dGVtcHQgdG8gc2lsZW5jZSBzeXpib3QgdG8gbWUuDQo+ID4gTm8sIHRoaXMg
aXMgbm90IHRvIHNpbGVuY2Ugc3l6Ym90IGJ1dCByZWFsbHkgc2FmZS4NCj4gPiBUaGlzIGlzIGJl
Y2F1c2UgdGhlICJhZWFkLT50Zm1fZW50cnkiIG9iamVjdCBpcyAiY29tbW9uIiBiZXR3ZWVuIENQ
VXMsIHRoZXJlIGlzIG9ubHkgaXRzIHBvaW50ZXIgdG8gYmUgdGhlICJwZXJfY3B1IiBvbmUuIFNv
IGp1c3QNCj4gdHJ5aW5nIHRvIGxvY2sgdGhlIHByb2Nlc3Mgb24gdGhlIGN1cnJlbnQgQ1BVIG9y
ICdwcmVlbXB0X2Rpc2FibGUoKScsIHRha2luZyB0aGUgcGVyLWNwdSBwb2ludGVyIGFuZCBkZXJl
ZmVyZW5jaW5nIHRvIHRoZSBhY3R1YWwNCj4gInRmbV9lbnRyeSIgb2JqZWN0Li4uIGlzIGVub3Vn
aC4gTGF0ZXIgb24sIHRoYXTigJlzIGZpbmUgdG8gcGxheSB3aXRoIHRoZSBhY3R1YWwgb2JqZWN0
IHdpdGhvdXQgYW55IGxvY2tpbmcuDQo+IA0KPiBXaHkgdXNpbmcgcGVyIGNwdSBwb2ludGVycywg
aWYgdGhleSBhbGwgcG9pbnQgdG8gYSBjb21tb24gb2JqZWN0ID8NCj4gDQo+IFRoaXMgbWFrZXMg
dGhlIGNvZGUgcmVhbGx5IGNvbmZ1c2luZy4NClNvcnJ5IGZvciBtYWtpbmcgeW91IGNvbmZ1c2Vk
LiBZZXMsIHRoZSBjb2RlIGlzIGEgYml0IHVnbHkgYW5kIGNvdWxkIGJlIG1hZGUgaW4gc29tZSBv
dGhlciB3YXlzLi4uIFRoZSBpbml0aWFsIGlkZWEgaXMgdG8gbm90IHRvdWNoIG9yIGNoYW5nZSB0
aGUgc2FtZSBwb2ludGVyIHZhcmlhYmxlIGluIGRpZmZlcmVudCBDUFVzIHNvIGF2b2lkIGEgcGVu
YWx0eSB3aXRoIHRoZSBjYWNoZSBoaXRzL21pc3Nlcy4uLg0KDQpCUi9UdW9uZw0KPiANCj4gV2h5
IG5vIGxvY2sgaXMgcmVxdWlyZWQgPyBUaGlzIHNlZW1zIGhhcmQgdG8gYmVsaWV2ZSwgZ2l2ZW4g
bGFjayBvZiBjbGVhciBleHBsYW5hdGlvbnMgYW55d2hlcmUNCj4gaW4gY29tbWl0IGZjMWI2ZDZk
ZTIyMCAoInRpcGM6IGludHJvZHVjZSBUSVBDIGVuY3J5cHRpb24gJiBhdXRoZW50aWNhdGlvbiIp
Lg0KPiANCj4gSWYgdGhlIG9iamVjdCBjYW4gYmUgdXNlZCB3aXRob3V0IGxvY2tpbmcsIGl0IHNo
b3VsZCBiZSBtYXJrZWQgY29uc3QuDQo+IA0KPiB0aXBjX2FlYWRfdGZtX25leHQoKSBoYXMgc2lk
ZSBlZmZlY3RzIHRoYXQgSSByZWFsbHkgY2FuIG5vdCB1bmRlcnN0YW5kIGluIFNNUCB3b3JsZCwN
Cj4gYW5kIHByZXN1bWFibHkgd2l0aCBzb2Z0IGludGVycnVwdHMgaW4gVVAgYXMgd2VsbC4NCj4g
DQo+IA0KPiANCj4gDQoNCg==
