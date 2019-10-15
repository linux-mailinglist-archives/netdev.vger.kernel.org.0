Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E21D80A7
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfJOUH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:07:56 -0400
Received: from mail-eopbgr50044.outbound.protection.outlook.com ([40.107.5.44]:53824
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726717AbfJOUH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 16:07:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bd75dtzlEwnqcSrrSAMJVTBlBTqaMkRoMlOHZQ4bH2U8KllMD/Zm8pkSNqpNh3ee5/maCG2qvukX3fsJJEIQ5i3z9XRN0D9rvgz7a9xP2ftiM3FMkHo6k5euA5Umdx/u+KcvbXGuNIqKc75kZEQwZ8QQDCVACNRupHAp3vkVuwMdNL3Hd4AH9LvoPVKORKi97fbPKP/ngvxgN0Hw89uODjhmdZtVGLtPZCKoQOAQUG0uS/M+iX2Bznn7am+Bv8JSoJ3dTpulBy/EMQui8kCD1lEBZDO30eqsqpw/UKFrvfDRVXIP8GNxalEirNGZVx8D3HWXRA1M0WXGDqNAct4yqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o95eOOGGA9YdKcnEhOBqL3+iDELlXvPI7JGozlgDuK0=;
 b=XiD9GrEAAFOXeddg346xKyYYVGQf9UcOFSdsTcSh8QxHwWvHL+zS4OR3t8ye3DwZyK7XzdHxgyQaps3fOaRHd2si/ZHFzhLZ5CvJnxRe+JODlK61IZKjK2OkB7opivJW8tzpUSpM/gzfamkPjfEJSW6hDaUlXsqb8TTAJEMcX4X3GHZsPwmAuxynSI4CMOc7CBTKUa40ooWtG6yzOF9CrLil1onBPgOa5Ve9h5TiIjOzO9sgOhOQySQKvFCEsq3Rp3uefbpPUsoj9Shd8wM1Wmfe23QF179SURqNeMzI/sBsM1Lgkk/7YdtkCSkNgUTIUlGgG5RcoeIfgbSgWFjsww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o95eOOGGA9YdKcnEhOBqL3+iDELlXvPI7JGozlgDuK0=;
 b=hvZ+cY/0kV87vfU8y3ZupGg+/C/slBsvYqTd5TaGJnuzhArJxiRJJfFGX4xbivdKJrXwZ2S/uX43K3NlElNUx21BXzZ34QBh0KCZmFIA1OtOM+nTgDCCciiu7T4e7p09X5oYIxU9YitJ9Jm0BIZpYLMaDxU73P9mTTOPo/TaDxE=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3774.eurprd04.prod.outlook.com (52.134.15.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 20:07:50 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::9136:9090:5b7c:433d]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::9136:9090:5b7c:433d%9]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 20:07:50 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH v2 net 2/2] dpaa2-eth: Fix TX FQID values
Thread-Topic: [PATCH v2 net 2/2] dpaa2-eth: Fix TX FQID values
Thread-Index: AQHVgnFTE+1p7xEGekmpP/G97EE3oA==
Date:   Tue, 15 Oct 2019 20:07:49 +0000
Message-ID: <VI1PR0402MB28001CD49E92E461531DC24BE0930@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571045117-26329-1-git-send-email-ioana.ciornei@nxp.com>
 <1571045117-26329-3-git-send-email-ioana.ciornei@nxp.com>
 <20191015192923.GC7839@lunn.ch>
 <20191015124017.64a3d19b@cakuba.netronome.com>
 <20191015194704.GE7839@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.124.196.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4ffa431-2ce8-446c-f0d8-08d751ab5ad6
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR0402MB3774:|VI1PR0402MB3774:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB377458EDDA6AD848DCFAC4CDE0930@VI1PR0402MB3774.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(51444003)(199004)(189003)(9686003)(110136005)(7696005)(71200400001)(71190400001)(76176011)(316002)(25786009)(66066001)(14454004)(54906003)(14444005)(6116002)(229853002)(256004)(6506007)(86362001)(52536014)(5660300002)(99286004)(3846002)(6436002)(55016002)(2906002)(478600001)(186003)(446003)(44832011)(102836004)(81166006)(8676002)(81156014)(7736002)(305945005)(53546011)(6246003)(4326008)(66446008)(76116006)(33656002)(476003)(26005)(64756008)(66556008)(66476007)(66946007)(74316002)(8936002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3774;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LIom/Y2sM0QCLGOseXyqE5zqPkC3Q7lKWbILGZ/uq8hW2d8RW+jZEzw4Vul7hyfWMpJ3WPdNBZv69ku6oIKgkz2JzBo/AD5HBrlJkoAdm8HnDaXgVZRYLQxvJLne5LCYxe6ZEIRD03bKdr2QtjJOndtLREoSl1YpsR5GAPEalzBfhm0H/SUuoUbetm4eK0qfRu/xYHrWMvBUpbd7EBvnnYUx4YpQpSaQTO1mlDkSw9tmz6KI7nJIIXsqTHrUmNlQoLU+1+Zpc8urRgghaxgBeS1Vrg4OF7RMcpp2Fy3YWHWWv41kBBpt7I/DPf8/IpQ/9sqCTZMuHI9MDUr0SQyOjPJnQZ9Dm2m79vDGYTEanzCoIbgaCUIBXIxpQ3Cdmozfg6INTgcxgiHh3EUMHeyjdHk1gPvGmITU7norGV5FzBk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ffa431-2ce8-446c-f0d8-08d751ab5ad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 20:07:50.0128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VDZP6ONxYSK0I0A1tqrVn2/p6tFQpeMtxMLH1d9Io42Py6n63HNVVs2UzuFQQT+/lBq6A+sBvFxLrG2omvtjug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3774
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTUvMTkgMTA6NDcgUE0sIEFuZHJldyBMdW5uIHdyb3RlOgo+IE9uIFR1ZSwgT2N0IDE1
LCAyMDE5IGF0IDEyOjQwOjE3UE0gLTA3MDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOgo+PiBPbiBU
dWUsIDE1IE9jdCAyMDE5IDIxOjI5OjIzICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToKPj4+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLWV0
aC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLWV0aC5jCj4+
Pj4gaW5kZXggNWFjZDczNGEyMTZiLi5jM2MyYzA2MTk1YWUgMTAwNjQ0Cj4+Pj4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLWV0aC5jCj4+Pj4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLWV0aC5jCj4+Pj4gQEAg
LTEyMzUsNiArMTIzNSw4IEBAIHN0YXRpYyB2b2lkIGRwYWEyX2V0aF9zZXRfcnhfdGFpbGRyb3Ao
c3RydWN0IGRwYWEyX2V0aF9wcml2ICpwcml2LCBib29sIGVuYWJsZSkKPj4+PiAgIAlwcml2LT5y
eF90ZF9lbmFibGVkID0gZW5hYmxlOwo+Pj4+ICAgfQo+Pj4+ICAgCj4+Pj4gK3N0YXRpYyB2b2lk
IHVwZGF0ZV90eF9mcWlkcyhzdHJ1Y3QgZHBhYTJfZXRoX3ByaXYgKnByaXYpOwo+Pj4+ICsKPj4+
Cj4+PiBIaSBJb2FuYSBhbmQgSW9hbmEKPj4+Cj4+PiBVc2luZyBmb3J3YXJkIGRlY2xhcmF0aW9u
cyBpcyBnZW5lcmFsbHkgbm90IGxpa2VkLiBJcyB0aGVyZSBzb21ldGhpbmcKPj4+IHdoaWNoIGlz
IHByZXZlbnRpbmcgeW91IGZyb20gaGF2aW5nIGl0IGVhcmxpZXIgaW4gdGhlIGZpbGU/Cj4+Cj4+
IEhhISBJIHdhcyBqdXN0IGFib3V0IHRvIGFzayB0aGUgc2FtZSBxdWVzdGlvbiDwn5iKCj4+Cj4+
ICtvdXRfZXJyOgo+PiArCW5ldGRldl9pbmZvKHByaXYtPm5ldF9kZXYsCj4+ICsJCSAgICAiRXJy
b3IgcmVhZGluZyBUeCBGUUlELCBmYWxsYmFjayB0byBRRElELWJhc2VkIGVucXVldWUiKTsKPj4g
Kwlwcml2LT5lbnF1ZXVlID0gZHBhYTJfZXRoX2VucXVldWVfcWQ7Cj4+ICt9Cj4+Cj4+IEhlcmUg
ZHBhYTJfZXRoX2VucXVldWVfcWQgaXMgYSBmdW5jdGlvbiBwb2ludGVyIHdoaWNoIGlzIGlzIGRl
ZmluZWQKPj4gdG93YXJkcyB0aGUgZW5kIG9mIHRoZSBmaWxlIDpTCj4gCj4gSGkgSmFrdWIKPiAK
PiBUaGFua3MsIGkgd2FzIHRvbyBsYXp5IHRvIGxvb2suCj4gCj4gU28gdGhpcyBpcyBPLksuIGZv
ciBuZXQsIHNpbmNlIGZpeGVzIHNob3VsZCBiZSBtaW5pbWFsLgo+IAo+IElvYW5hJ3MgcGxlYXNl
IGNvdWxkIHlvdSBzdWJtaXQgYSBwYXRjaCB0byBuZXQtbmV4dCwgb25jZSB0aGlzIGhhcwo+IGJl
ZW4gbWVyZ2VkLCB0byBtb3ZlIHRoZSBjb2RlIGFyb3VuZCB0byByZW1vdmUgdGhlIGZvcndhcmQK
PiBkZWNsYXJhdGlvbnMuCgoKWWVzLCBJJ2xsIGNsZWFudXAgdGhpcyBpbiBuZXQtbmV4dC4KCkFs
c28sIG5vIG1vcmUgSW9hbmEncyBmb3IgYSB3aGlsZSwganVzdCBtZSA6KQoKPiAKPj4gQWxzbyBj
YW4gSSBwb2ludCBvdXQgdGhhdCB0aGlzOgo+Pgo+PiBzdGF0aWMgaW5saW5lIGludCBkcGFhMl9l
dGhfZW5xdWV1ZV9xZChzdHJ1Y3QgZHBhYTJfZXRoX3ByaXYgKnByaXYsCj4+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgZHBhYTJfZXRoX2ZxICpmcSwKPj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBkcGFhMl9mZCAq
ZmQsIHU4IHByaW8pCj4+IHsKPj4gICAgICAgICAgcmV0dXJuIGRwYWEyX2lvX3NlcnZpY2VfZW5x
dWV1ZV9xZChmcS0+Y2hhbm5lbC0+ZHBpbywKPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBwcml2LT50eF9xZGlkLCBwcmlvLAo+PiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZxLT50eF9xZGJpbiwgZmQpOwo+PiB9Cj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIAo+PiBzdGF0aWMgaW5saW5lIGludCBkcGFhMl9ldGhfZW5x
dWV1ZV9mcShzdHJ1Y3QgZHBhYTJfZXRoX3ByaXYgKnByaXYsCj4+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgZHBhYTJfZXRoX2ZxICpmcSwKPj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBkcGFhMl9mZCAqZmQsIHU4
IHByaW8pCj4+IHsKPj4gICAgICAgICAgcmV0dXJuIGRwYWEyX2lvX3NlcnZpY2VfZW5xdWV1ZV9m
cShmcS0+Y2hhbm5lbC0+ZHBpbywKPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBmcS0+dHhfZnFpZFtwcmlvXSwgZmQpOwo+PiB9Cj4+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIAo+PiBzdGF0aWMgdm9pZCBzZXRfZW5xdWV1ZV9tb2RlKHN0cnVjdCBkcGFhMl9l
dGhfcHJpdiAqcHJpdikKPj4gewo+PiAgICAgICAgICBpZiAoZHBhYTJfZXRoX2NtcF9kcG5pX3Zl
cihwcml2LCBEUE5JX0VOUVVFVUVfRlFJRF9WRVJfTUFKT1IsCj4+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIERQTklfRU5RVUVVRV9GUUlEX1ZFUl9NSU5PUikgPCAwKQo+PiAg
ICAgICAgICAgICAgICAgIHByaXYtPmVucXVldWUgPSBkcGFhMl9ldGhfZW5xdWV1ZV9xZDsKPj4g
ICAgICAgICAgZWxzZQo+PiAgICAgICAgICAgICAgICAgIHByaXYtPmVucXVldWUgPSBkcGFhMl9l
dGhfZW5xdWV1ZV9mcTsKPj4gfQo+Pgo+PiBDb3VsZCBiZSB0aGUgbW9zdCBwb2ludGxlc3MgdXNl
IG9mIHRoZSBpbmxpbmUga2V5d29yZCBwb3NzaWJsZSA6KQo+PiBCb3RoIGRwYWEyX2V0aF9lbnF1
ZXVlX3FkKCkgYW5kIGRwYWEyX2V0aF9lbnF1ZXVlX2ZxKCkgYXJlIG9ubHkgZXZlcgo+PiBjYWxs
ZWQgdmlhIGEgcG9pbnRlci4uCgpJIHRoaW5rIHRoYXQncyBhbm90aGVyIGNoYW5nZSBmb3IgbmV0
LW5leHQuCgo+IAo+IElzIHByaXYtPmVucXVldWUgdXNlZCBvbiB0aGUgaG90cGF0aD8gU1BFQ1RS
QS9NZWx0ZG93biBldGMgbWFrZSB0aGF0Cj4gZXhwZW5zaXZlLgo+IAoKWWVzLCB0aGUgcHJpdi0+
ZW5xdWV1ZSBpcyB1c2VkIG9uIHRoZSBUeCBwYXRoIHRvIGVucXVldWUgYSBza2IgCih0cmFuc2Zv
cm1lZCBpbnRvIGEgZnJhbWUgZGVzY3JpcHRvcikgaW50byBhIHF1ZXVlLgpJIG5lZWQgdG8gYmVu
Y2htYXJrIGlmIHRyYW5zZm9ybWluZyB0aGUgY2FsbGJhY2sgaW50byBhbiBpZi1lbHNlIApzdGF0
ZW1lbnQgaXMgaGVscGluZy4KCklvYW5hIEMKCj4gCUFuZHJldwo+IAoK
