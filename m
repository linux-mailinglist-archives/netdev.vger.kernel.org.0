Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945B722B04B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 15:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgGWNS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 09:18:28 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:12742 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgGWNS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 09:18:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595510308; x=1627046308;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SZ6B77O5/M4+OCP1S2wQpay9y1ccfSiO5darEm/SpL0=;
  b=KAYrWIO2InkVqwKnOb+OZAZuJvb9cVtesAGa5oa528k157DpdmbRjr9n
   sPQeDpCoLH0MG5PQiDEYWb8VVGdYRy3DtbCKvTSjhQB+DvS9i/bztbSZF
   KtIuIoOo+bpMHUr+hGDB6QBZiWLWD6r+54l23K/U2LeDjQq9vRcJ7sN8k
   GG2ZpWNufjVnDdJ4KmejAMu3UNsRGTZ6xrb4R0fM5Mk3JheBsFfJmB+ws
   qanApjC6kvngn1XO3dJ1vHyn3yuj4zoGipOKl003uVXkzKvphwzHlarDt
   nve81htG3t61QOCrCGCB1Jcn2OtzpLbNrEJJiHsm6f1SRVwYW+nuFJ4jH
   w==;
IronPort-SDR: I1lqsqKpwPbYgdKhG9/mLJEoqdUOPyzmYtuWyXtulaMscVQj1LY1d6vGHfopb+bcaOVhwC4IOM
 X5BYfEP+XjoYazfguAZnnCL2vkSlVATWJEeCipwsMV2E3m6tdXNJax5ttNHMjrBjIjw78aBqpO
 TWyhkf0ZDFP20u8STv9sSqnrIpz5UQRYOyhYpg6KEY8NBR9gGF0MI+ASzYWjZ8zIzgnbxrjpDe
 nibLgtFHm1K7y/weRMBYzMmbQtar98xbac2mVBuKWOw3h5BqwzTMkA3Rp8VCnPvzy7IN+6x1Ki
 pZk=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="84346656"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 06:18:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 06:18:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 06:17:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejsIR/I1qsQa0vl1TkAjnPHsfTpBZctwh2kCZ1KoDqOxpWbtxcGDxdaBvco+YjidrXGvyy92BcRSpgfPoby1GjIZ5QPqKH8UvObTyGMrHdnXxUlNrve6MZWyw97Uf1g/ov13cyZffkJVASQjV0vhoMmIVXfwiWzT4o8bnq0k361dG+TCoCbvLObbYMumB3rFglUqBN4PVDzuwcJUX7w1C2kvTDzb4YqvCzMuUrrvnP4X+4UWest6pe0qnXwNS3GlogDTSghmIm3XX/wD/cqkNfofMiZHnc30zwCJVSVVot8YjvjYo5WpekxkJ/K3Wff/o45lU1F2PdVAYJjjHczZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZ6B77O5/M4+OCP1S2wQpay9y1ccfSiO5darEm/SpL0=;
 b=ZoIKg9jkWksml8BWhuZtvHt9qfZdt1SsaDVEaZAANrN0oZC+G8RULBxz0rra6fuR9g0BALJSPPy50D7j/raFvOu4Gfc3rsE/Cx5WJaAg+rXRJFMZuZRtr1Pj+8H82x/UA7LYkZdyE0Abg53DOJg/WVo44T4yTdT0P4at9k8EgTNN7/toh2JcWeiow3+h/ZQZNr2Y+K2hMFWGIdH3oeZsNNgpJZaCizP7cZxayjXTf3VJayMH4FmdmX+qQrbO05ZUrEMHbGO2f2omM85H3jAame4kIIGfKBDvHsptWotFyySFxnx8e7+gip8vLEEoBK0erXAe4kDbxsR65FsjNv0meg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZ6B77O5/M4+OCP1S2wQpay9y1ccfSiO5darEm/SpL0=;
 b=jZDlk7Gu9l/QagD6WuOepuHTVdKuvOH5W3OuMNtehBNu+hhFtzZ9yHEwa9vhcnW35vGPluNDUEAThtccgQlfMvfOUXyFYvGk89UgWGgK+Uh08iOMNMpErpPyR1tnX2gZbmXHmBva6TZ5XmrIDGr8XTCGYyOFvPgSoH6x1UksWEw=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SN6PR11MB2893.namprd11.prod.outlook.com (2603:10b6:805:dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Thu, 23 Jul
 2020 13:18:16 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3216.022; Thu, 23 Jul 2020
 13:18:15 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <robh+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Thread-Topic: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Thread-Index: AQHWX4JuelDTpdq80UW3XJv+RJlkGakTZ76AgAASg4CAAVL2AIAAWzGA
Date:   Thu, 23 Jul 2020 13:18:15 +0000
Message-ID: <dc523fbb-c247-88da-e9b1-ce13c276e8d9@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
 <0ec99957-57e9-b384-425a-ccf0e877f1a1@microchip.com>
 <7cab13f6-ac54-8f5c-c1bf-35e6c3b5d9db@microchip.com>
 <8a78218a-9fbe-889d-8501-ad67ccb6e59b@microchip.com>
In-Reply-To: <8a78218a-9fbe-889d-8501-ad67ccb6e59b@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3971270c-3c89-411d-d384-08d82f0adbfb
x-ms-traffictypediagnostic: SN6PR11MB2893:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB28930643F2A9067F3AE27E48E7760@SN6PR11MB2893.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fSqg90P9a/VE+om3BcccsQlSB7PVoN0+2V/YpAkEIqZ4mlXJv44IWmrV3rEg+zphbmEQhRZMMzEiuj6ZVnnk4WfJ+havj5mWryG88Asxiu9mWZwlQp7kCvbA+8M+U2Gp2MBvWJHVDsI0otAybiU7fjDqL8ldDuuvoVWqQKm+a1GhpsNIjMuxDlDgYpnRXBsLusny4fb9AB+Yovwvg0PcFuuVVzr3JYhlU7RO3Q6cC7U8kVxc3u6aj1tCkuapaa2LJ0o252KKru6DlxsrbiTBWcmYkyJlXt+xRlvB0HjQPARkl9ywyv+sRvDOZ6YMcg/sZRTggvfbtuNKYlIWdqNDu1roe83GCG8sSjw3jTaM8a86ll1dvjKPvBNkqCr1UZOn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(39860400002)(346002)(396003)(107886003)(53546011)(2616005)(6506007)(66476007)(478600001)(86362001)(26005)(31696002)(4326008)(7416002)(64756008)(36756003)(5660300002)(8676002)(6512007)(66446008)(8936002)(54906003)(110136005)(6486002)(316002)(66946007)(71200400001)(91956017)(76116006)(2906002)(31686004)(186003)(66556008)(83380400001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5vq67hbu6orUVWRD49v/04P2TKZd2O2HC8k7bS/yWVNKZyyOl3ckqzkvGJxpTGSQE6CvrTWRulk2NmFowzxrC1NSDf1pzzGWpBvxns9nstfM3q+l8v/YMxZNklNvDcWryAlG5gonI8lDigKaGmC11SI+ozdXTO/65Nx7syWcbt7mTrRxN7GOX2/aU+mAWp7ip5bpFJgtaYhcKFVkHtPG8ccgyOcq0Q0rM8mQQEobqVKVquTLHlzdQKm/6arXwzX3pXx0sW8h7fF6mLg8lTHIG1+UQ6Elk6Tik17/1oF+GwxNnBOt6N2LXwS/SLzGpOE+UeuPxDGtARABlJd0EJETRs6z/hT/Wjzf6DUXaBMdUDqer4R8ewkUjKI2zqMAR9IlNkHs4eUxbANaqv+MQlSKI8QUnHVoPWwY28wSh8cRauAIRALSmb+c/NKfZSEptPu/PsGK14/kEKEsHTTqDHdkRnsaTza+GH2nA2K55dymx5PBc9VJIeLo6Y8CPvSo0eaC
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3666192770986448CFF6EF665BE4B28@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3971270c-3c89-411d-d384-08d82f0adbfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 13:18:15.8478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6C/z4Anu6vAD1UQ/OBNHmydJzdpzd5MqmAqNw4QL4ulgXPwLtUfJiiSevgbIDAy3qTxixwfYQhTR+XJPrjH+Frlj0NLZxbcnSYV6ZwWBu3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2893
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjMuMDcuMjAyMCAxMDo1MSwgQ2xhdWRpdSBCZXpuZWEgLSBNMTgwNjMgd3JvdGU6DQo+IA0K
PiANCj4gT24gMjIuMDcuMjAyMCAxNDozOCwgQ29kcmluIENpdWJvdGFyaXUgLSBNMTk5NDAgd3Jv
dGU6DQo+PiBPbiAyMi4wNy4yMDIwIDEzOjMyLCBDbGF1ZGl1IEJlem5lYSAtIE0xODA2MyB3cm90
ZToNCj4+Pg0KPj4+DQo+Pj4gT24gMjEuMDcuMjAyMCAyMDoxMywgQ29kcmluIENpdWJvdGFyaXUg
d3JvdGU6DQo+Pj4+IEFkZGluZyB0aGUgUEhZIG5vZGVzIGRpcmVjdGx5IHVuZGVyIHRoZSBFdGhl
cm5ldCBub2RlIGJlY2FtZSBkZXByZWNhdGVkLA0KPj4+PiBzbyB0aGUgYWltIG9mIHRoaXMgcGF0
Y2ggc2VyaWVzIGlzIHRvIG1ha2UgTUFDQiB1c2UgYW4gTURJTyBub2RlIGFzDQo+Pj4+IGNvbnRh
aW5lciBmb3IgTURJTyBkZXZpY2VzLg0KPj4+PiBUaGlzIHBhdGNoIHNlcmllcyBzdGFydHMgd2l0
aCBhIHNtYWxsIHBhdGNoIHRvIHVzZSB0aGUgZGV2aWNlLW1hbmFnZWQNCj4+Pj4gZGV2bV9tZGlv
YnVzX2FsbG9jKCkuIEluIHRoZSBuZXh0IHR3byBwYXRjaGVzIHdlIHVwZGF0ZSB0aGUgYmluZGlu
Z3MgYW5kDQo+Pj4+IGFkYXB0IG1hY2IgZHJpdmVyIHRvIHBhcnNlIHRoZSBkZXZpY2UtdHJlZSBQ
SFkgbm9kZXMgZnJvbSB1bmRlciBhbiBNRElPDQo+Pj4+IG5vZGUuIFRoZSBsYXN0IHBhdGNoZXMg
YWRkIHRoZSBNRElPIG5vZGUgaW4gdGhlIGRldmljZS10cmVlcyBvZiBzYW1hNWQyLA0KPj4+PiBz
YW1hNWQzLCBzYW1hZDQgYW5kIHNhbTl4NjAgYm9hcmRzLg0KPj4+Pg0KPj4+DQo+Pj4gVGVzdGVk
IHRoaXMgc2VyaWVzIG9uIHNhbWE1ZDJfeHBsYWluZWQgaW4gdGhlIGZvbGxvd2luZyBzY2VuYXJp
b3M6DQo+Pj4NCj4+PiAxLyBQSFkgYmluZGluZ3MgZnJvbSBwYXRjaCA0Lzc6DQo+Pj4gbWRpbyB7
DQo+Pj4gCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPj4+IAkjc2l6ZS1jZWxscyA9IDwwPjsNCj4+
PiAJZXRoZXJuZXQtcGh5QDEgew0KPj4+IAkJcmVnID0gPDB4MT47DQo+Pj4gCQlpbnRlcnJ1cHQt
cGFyZW50ID0gPCZwaW9BPjsNCj4+PiAJCWludGVycnVwdHMgPSA8UElOX1BDOSBJUlFfVFlQRV9M
RVZFTF9MT1c+Ow0KPj4+IH07DQo+Pj4NCj4+PiAyLyBQSFkgYmluZGluZ3MgYmVmb3JlIHRoaXMg
c2VyaWVzOg0KPj4+IGV0aGVybmV0LXBoeUAxIHsNCj4+PiAJcmVnID0gPDB4MT47DQo+Pj4gCWlu
dGVycnVwdC1wYXJlbnQgPSA8JnBpb0E+Ow0KPj4+IAlpbnRlcnJ1cHRzID0gPFBJTl9QQzkgSVJR
X1RZUEVfTEVWRUxfTE9XPjsNCj4+PiB9Ow0KPj4+DQo+Pj4gMy8gTm8gUEhZIGJpbmRpbmdzIGF0
IGFsbC4NCj4+Pg0KPj4+IEFsbCAzIGNhc2VzIHdlbnQgT0suDQo+Pj4NCj4+PiBZb3UgY2FuIGFk
ZDoNCj4+PiBUZXN0ZWQtYnk6IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2No
aXAuY29tPg0KPj4+IEFja2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWlj
cm9jaGlwLmNvbT4NCj4+DQo+PiBUaGFuayB5b3UgdmVyeSBtdWNoIENsYXVkaXUhDQo+PiBUaGVy
ZSBpcyBzdGlsbCBvbmUgbW9yZSBjYXNlIGluIG15IG1pbmQuIG1hY2IgY291bGQgYmUgYSBmaXhl
ZC1saW5rIHdpdGgNCj4+IGFuIE1ESU8gRFNBIHN3aXRjaC4gV2hpbGUgdGhlIG1hY2Igd291bGQg
aGF2ZSBhIGZpeGVkIGNvbm5lY3Rpb24gd2l0aCBhDQo+PiBwb3J0IGZyb20gdGhlIERTQSBzd2l0
Y2gsIHRoZSBzd2l0Y2ggY291bGQgYmUgY29uZmlndXJlZCB1c2luZyBtYWNiJ3MNCj4+IE1ESU8u
IFRoZSBkdCB3b3VsZCBiZSBzb21ldGhpbmcgbGlrZToNCj4+DQo+PiBtYWNiIHsNCj4+IAlmaXhl
ZC1saW5rIHsNCj4+IAkJLi4uDQo+PiAJfTsNCj4+IAltZGlvIHsNCj4+IAkJc3dpdGNoQDAgew0K
Pj4gCQkJLi4uDQo+PiAJCX07DQo+PiAJfTsNCj4+IH07DQo+IA0KPiBEbyB5b3UgaGF2ZSBhIHNl
dHVwIGZvciB0ZXN0aW5nIHRoaXM/IEF0IHRoZSBtb21lbnQgSSBkb24ndCBrbm93IGENCj4gY29u
ZmlndXJhdGlvbiBsaWtlIHRoaXMgdGhhdCBtYWNiIGlzIHdvcmtpbmcgd2l0aC4NCg0KVGhlcmUg
aXNuJ3Qgb25lIHRoYXQgSSBhbSBhd2FyZSBvZiwgYnV0IHdlIHNob3VsZCBhZGRyZXNzIGl0Lg0K
DQo+IA0KPj4NCj4+IFRvIHN1cHBvcnQgdGhpcywgaW4gcGF0Y2ggMy83IEkgc2hvdWxkIGZpcnN0
IGNoZWNrIGZvciB0aGUgbWRpbyBub2RlIHRvDQo+PiByZXR1cm4gb2ZfbWRpb2J1c19yZWdpc3Rl
cigpIGFuZCB0aGVuIGNoZWNrIGlmIGl0J3MgYSBmaXhlZC1saW5rIHRvDQo+PiByZXR1cm4gc2lt
cGxlIG1kaW9idXNfcmVnaXN0ZXIoKS4gSSB3aWxsIGFkZHJlc3MgdGhpcyBpbiB2My4uLj4NCj4+
IFRoYW5rcyBhbmQgYmVzdCByZWdhcmRzLA0KPj4gQ29kcmluDQo+Pg0KPj4+DQo+Pj4gVGhhbmsg
eW91LA0KPj4+IENsYXVkaXUgQmV6bmVhDQo+Pj4NCj4+Pj4gQ2hhbmdlcyBpbiB2MjoNCj4+Pj4g
ICAgLSByZW5hbWVkIHBhdGNoIDIvNyBmcm9tICJtYWNiOiBiaW5kaW5ncyBkb2M6IHVzZSBhbiBN
RElPIG5vZGUgYXMgYQ0KPj4+PiAgICAgIGNvbnRhaW5lciBmb3IgUEhZIG5vZGVzIiB0byAiZHQt
YmluZGluZ3M6IG5ldDogbWFjYjogdXNlIGFuIE1ESU8NCj4+Pj4gICAgICBub2RlIGFzIGEgY29u
dGFpbmVyIGZvciBQSFkgbm9kZXMiDQo+Pj4+ICAgIC0gYWRkZWQgYmFjayBhIG5ld2xpbmUgcmVt
b3ZlZCBieSBtaXN0YWtlIGluIHBhdGNoIDMvNw0KPj4+Pg0KPj4+PiBDb2RyaW4gQ2l1Ym90YXJp
dSAoNyk6DQo+Pj4+ICAgICBuZXQ6IG1hY2I6IHVzZSBkZXZpY2UtbWFuYWdlZCBkZXZtX21kaW9i
dXNfYWxsb2MoKQ0KPj4+PiAgICAgZHQtYmluZGluZ3M6IG5ldDogbWFjYjogdXNlIGFuIE1ESU8g
bm9kZSBhcyBhIGNvbnRhaW5lciBmb3IgUEhZIG5vZGVzDQo+Pj4+ICAgICBuZXQ6IG1hY2I6IHBh
cnNlIFBIWSBub2RlcyBmb3VuZCB1bmRlciBhbiBNRElPIG5vZGUNCj4+Pj4gICAgIEFSTTogZHRz
OiBhdDkxOiBzYW1hNWQyOiBhZGQgYW4gbWRpbyBzdWItbm9kZSB0byBtYWNiDQo+Pj4+ICAgICBB
Uk06IGR0czogYXQ5MTogc2FtYTVkMzogYWRkIGFuIG1kaW8gc3ViLW5vZGUgdG8gbWFjYg0KPj4+
PiAgICAgQVJNOiBkdHM6IGF0OTE6IHNhbWE1ZDQ6IGFkZCBhbiBtZGlvIHN1Yi1ub2RlIHRvIG1h
Y2INCj4+Pj4gICAgIEFSTTogZHRzOiBhdDkxOiBzYW05eDYwOiBhZGQgYW4gbWRpbyBzdWItbm9k
ZSB0byBtYWNiDQo+Pj4+DQo+Pj4+ICAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvbWFjYi50eHQgfCAxNSArKysrKysrKysrKystLS0NCj4+Pj4gICAgYXJjaC9hcm0vYm9v
dC9kdHMvYXQ5MS1zYW05eDYwZWsuZHRzICAgICAgICAgICB8ICA4ICsrKysrKy0tDQo+Pj4+ICAg
IGFyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMjdfc29tMS5kdHNpICAgICAgfCAxNiArKysr
KysrKysrLS0tLS0tDQo+Pj4+ICAgIGFyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMjdfd2xz
b20xLmR0c2kgICAgfCAxNyArKysrKysrKysrLS0tLS0tLQ0KPj4+PiAgICBhcmNoL2FybS9ib290
L2R0cy9hdDkxLXNhbWE1ZDJfcHRjX2VrLmR0cyAgICAgIHwgMTMgKysrKysrKystLS0tLQ0KPj4+
PiAgICBhcmNoL2FybS9ib290L2R0cy9hdDkxLXNhbWE1ZDJfeHBsYWluZWQuZHRzICAgIHwgMTIg
KysrKysrKystLS0tDQo+Pj4+ICAgIGFyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkM194cGxh
aW5lZC5kdHMgICAgfCAxNiArKysrKysrKysrKystLS0tDQo+Pj4+ICAgIGFyY2gvYXJtL2Jvb3Qv
ZHRzL2F0OTEtc2FtYTVkNF94cGxhaW5lZC5kdHMgICAgfCAxMiArKysrKysrKy0tLS0NCj4+Pj4g
ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyAgICAgICB8IDE4ICsr
KysrKysrKysrKy0tLS0tLQ0KPj4+PiAgICA5IGZpbGVzIGNoYW5nZWQsIDg2IGluc2VydGlvbnMo
KyksIDQxIGRlbGV0aW9ucygtKQ0KDQo=
