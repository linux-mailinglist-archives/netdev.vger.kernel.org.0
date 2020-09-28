Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0DE27B47D
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgI1SbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:31:12 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:28355 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbgI1SbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 14:31:11 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f722beb0000>; Tue, 29 Sep 2020 02:31:07 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Sep
 2020 18:31:07 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 28 Sep 2020 18:31:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut8pvedev8dLtNvLBw2MYMR+ttusCPjio92K74uwwN/pFcumnvRbIeiTV4u4r9kbEXXkalQYhI6LX4X8IN+B028znQqYhCgoZFe3ldd9C7M/MqtDeTpZgL7orw2QBjbkJVuOgkUmzs4itrnrL0mvgf+AsVyFR9DPzqwkxCayoe0jcYg0wTxHIrYleGMNO7qE0v7XSsAVijMqjOuzKbDYZ76HrcxwlvthDM8IoZ/77H4raghsZ5eEjllKNPaSYkcyGm2PELqVsQZNCODA6nyXOQpR0jsjavA21a/nFukGmLX2H+TKRGhfkxsSGDqcxy33e4AZ1/0im5fe4In/zXJkLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnLWXWH8seDf1K7nlun32DCkeOxBNyxeb0n8DfEaVe0=;
 b=M0kvdvIBm4A8xoVDWdw53xAIpRWA8CZLnTtoJo3CRR/j+zUX4Diuv+rJE69gXa+GLZ4YBIq88taYkYpDOD0bHJBuyapr33tGGjJX6UoLGaS9gDt2xoXkjU07WSke7ZNl8wymKl26kdPATIWGqefIlAgegjWt/pjnRCrY6cAsTUgGuRk1kvhEEE9Qp9mt2pabMAWmg/48lc7uleywiIfyepgFFY/B93jAjWbRWfI2ZWN8nFLJJF9JPI8BlxpMZBnX+X0hr410BHrVexT76BfkZdt2sd/bAEsJxYAuSPCDz0Yazhd9SAdnfLxx8sT/8N+VOTo1+AYL1cZmdpNJJ6i4qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from MN2PR12MB2942.namprd12.prod.outlook.com (2603:10b6:208:108::27)
 by MN2PR12MB3357.namprd12.prod.outlook.com (2603:10b6:208:d1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Mon, 28 Sep
 2020 18:31:04 +0000
Received: from MN2PR12MB2942.namprd12.prod.outlook.com
 ([fe80::e089:b3a7:ae3f:2436]) by MN2PR12MB2942.namprd12.prod.outlook.com
 ([fe80::e089:b3a7:ae3f:2436%5]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 18:31:04 +0000
From:   Ariel Levkovich <lariel@nvidia.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 1/2 net-next] net/mlx5e: TC: Fix IS_ERR() vs NULL checks
Thread-Topic: [PATCH 1/2 net-next] net/mlx5e: TC: Fix IS_ERR() vs NULL checks
Thread-Index: AQHWlb68MWAXNKlLSEGRSOUupTI8J6l+X45g
Date:   Mon, 28 Sep 2020 18:31:04 +0000
Message-ID: <3F057952-3C88-452F-BFC5-4DC2B87FAD67@nvidia.com>
References: <20200928174153.GA446008@mwanda>
In-Reply-To: <20200928174153.GA446008@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [2604:2000:1342:c20:1dfe:d10b:526:54a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 572f8a3c-72d0-4eb9-cffa-08d863dca8bc
x-ms-traffictypediagnostic: MN2PR12MB3357:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3357B7BEE269798DC97A79B5B7350@MN2PR12MB3357.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1OJ/0Fvzm4+tyJMO+NkrQZmizWF50RaWq95GvgaZOTPdVjkWWpP2BnS/8nqAfFI4425EwAfmpEmb++9Q+fNtCMjXFYNpN1PVPN7+T3vquav/MPPxdMaaCgcls82EKhzo/qCNiphoE5MBSDFhxW3pqpsziTQkRBqfZ0UXJmuBb6UYbWT3g4HpwY6/mKuiAsEQddz5Ivl2XTz1i6wSHDjf9+0Oh96byxfl37+nS1Nv0MKhMnHjgxMrl3WcUI/7SQ0L7GNew/tnyW0/jVDx0c9AMHKU42b4k7s3HIayTJGe/xGmMSV3Uk8pGGuRBMvXhgc6kN2jhc04ybz/OZq4CuEgmqFwO84IkDdUAxm3cepIIXR+uYjTpmjR9Iz1i3XnVNec
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB2942.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(76116006)(6916009)(2616005)(4326008)(8936002)(6486002)(6512007)(2906002)(71200400001)(6506007)(186003)(54906003)(66446008)(86362001)(64756008)(66556008)(66476007)(8676002)(66946007)(5660300002)(316002)(33656002)(36756003)(83380400001)(53546011)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 23dzgtqUHRRCzQv0/QrodnXKWi1gtifhXHYxcV6Wjfgi2DzspvRgGWTIKYd0HSgjaa+xROBJnodlfSd1Iosu0I9XkxjId5LoHDQwXSo6jSrA3NZUO62sLQb6WGhrf6Fy+K1ThZmJXtogGG6HHfnAyvSNzBNcyn8e5BhbhOGwaPuwZHm78oAETHa3On/obUjs9E0F7VsUxUXFDfsPSYct3VcrRD9M9mZjFzb2rrJro7xI6l8jvXQqivZuuRicNARp4+cs18Avme8kGEl2f7pE8osBzaAikQd3Tgwq7PRhSHrT+3oQIF/dhIyJiXNSYnJqK+BUUjcfckT9xxzbEMJ7py2x3z+B/NFX5NC3s9oX+7watmfnyUB+fJmOr7bt3MxAbzIUcHBq9xRZVuyy3QiZu2xkke5IR1Nu1ynPUPZQnPy4Io+w+yOrOXt2Bn4yc9ZEGKNoPvA2osvIUmomx06SS8oIbcj8LW60kXEHOSbfAfDn3XcM6M17DN/rxvFcPcDfvvCDBxDYH7LTzDdeJQbbhVsxJvW1iy24tINHJTkzq8//TQn7tJjXZU1KS3KMmDiJMTYLjFDgLVF7o9oPoBZ4X+UYqy7IMQBMC2nuNyYaR1JjFEngsF+kQiMkp7Oy/VijHElevnx6Hrq03lQKma9vJLcC1sAmSsqWgL0YhgRVJI++faviOaOmhwkfs4OdAAEwWOM2z3Q66Nxl93fUcbvu9g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB2942.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572f8a3c-72d0-4eb9-cffa-08d863dca8bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 18:31:04.6617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XV7rDgwdk5XIjA8WsTUvweZodEZPnz/VbASuaySojJPfDUSJR89zI2RDgeEtGAZsluQlVffft6648cKoUsbLag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3357
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601317867; bh=PnLWXWH8seDf1K7nlun32DCkeOxBNyxeb0n8DfEaVe0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Ryqy60iFIph62P6k8xSR9CzIHh8NJnkhyaEN4O4G6TSb86pBgbpHTPYcfu3wYlnk6
         7/0BIlYw8Yf/JL6BduSPSez5aBoXINwDIJZLnOikVJ4VETvldhRwJ/Jc1spF5IK2JX
         RDk2VG8HN2o4+75evm90NUHHoc+NXnXbgrmFd+cQlYJWEk2//jxhUIU7hPiMEZ2k+U
         2BpptORU8XMjHV3uL7xncAs89nwwX65GdRsw93k/wfIwwIxPvtYhE0XGJDvLoyzcRb
         82cleWbocUBlBrWiv5zxk56sZ9U8LflOO7gh2iSCy+pejeBnkmYGbHJheBJlNe/0me
         dlopNkGivXz0A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2VwIDI4LCAyMDIwLCBhdCAxMzo0MiwgRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBv
cmFjbGUuY29tPiB3cm90ZToNCj4gDQo+IO+7v1RoZSBtbHg1X3RjX2N0X2luaXQoKSBmdW5jdGlv
biBkb2Vzbid0IHJldHVybiBlcnJvciBwb2ludGVycyBpdCByZXR1cm5zDQo+IE5VTEwuICBBbHNv
IHdlIG5lZWQgdG8gc2V0IHRoZSBlcnJvciBjb2RlcyBvbiB0aGlzIHBhdGguDQo+IA0KPiBGaXhl
czogYWVkZDEzM2QxN2JjICgibmV0L21seDVlOiBTdXBwb3J0IENUIG9mZmxvYWQgZm9yIHRjIG5p
YyBmbG93cyIpDQo+IFNpZ25lZC1vZmYtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJA
b3JhY2xlLmNvbT4NCj4gLS0tDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl90Yy5jIHwgOCArKysrKystLQ0KPiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gaW5kZXggMTA0YjFjMzM5ZGUwLi40MzhmYmNmNDc4
ZDEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl90Yy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl90Yy5jDQo+IEBAIC01MjI0LDggKzUyMjQsMTAgQEAgaW50IG1seDVlX3RjX25pY19pbml0
KHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2KQ0KPiANCj4gICAgdGMtPmN0ID0gbWx4NV90Y19jdF9p
bml0KHByaXYsIHRjLT5jaGFpbnMsICZwcml2LT5mcy50Yy5tb2RfaGRyLA0KPiAgICAgICAgICAg
ICAgICAgTUxYNV9GTE9XX05BTUVTUEFDRV9LRVJORUwpOw0KPiAtICAgIGlmIChJU19FUlIodGMt
PmN0KSkNCj4gKyAgICBpZiAoIXRjLT5jdCkgew0KPiArICAgICAgICBlcnIgPSAtRU5PTUVNOw0K
PiAgICAgICAgZ290byBlcnJfY3Q7DQo+ICsgICAgfQ0KDQpIaSBEYW4sDQpUaGF0IHdhcyBpbXBs
ZW1lbnQgbGlrZSB0aGF0IG9uIHB1cnBvc2UuIElmIG1seDVfdGNfaW5pdF9jdCByZXR1cm5zIE5V
TEwgaXQgbWVhbnMgdGhlIGRldmljZSBkb2VzbuKAmXQgc3VwcG9ydCBDVCBvZmZsb2FkIHdoaWNo
IGNhbiBoYXBwZW4gd2l0aCBvbGRlciBkZXZpY2VzIG9yIG9sZCBGVyBvbiB0aGUgZGV2aWNlcy4N
Ckhvd2V2ZXIsIGluIHRoaXMgY2FzZSB3ZSB3YW50IHRvIGNvbnRpbnVlIHdpdGggdGhlIHJlc3Qg
b2YgdGhlIFRjIGluaXRpYWxpemF0aW9uIGJlY2F1c2Ugd2UgY2FuIHN0aWxsIHN1cHBvcnQgb3Ro
ZXIgVEMgb2ZmbG9hZHMuIE5vIG5lZWQgdG8gZmFpbCB0aGUgZW50aXJlIFRDIGluaXQgaW4gdGhp
cyBjYXNlLiBPbmx5IGlmIG1seDVfdGNfaW5pdF9jdCByZXR1cm4gZXJyX3B0ciB0aGF0IG1lYW5z
IHRoZSB0YyBpbml0IGZhaWxlZCBub3QgYmVjYXVzZSBvZiBsYWNrIG9mIHN1cHBvcnQgYnV0IGR1
ZSB0byBhIHJlYWwgZXJyb3IgYW5kIG9ubHkgdGhlbiB3ZSB3YW50IHRvIGZhaWwgdGhlIHJlc3Qg
b2YgdGhlIHRjIGluaXQuDQoNCllvdXIgY2hhbmdlIHdpbGwgYnJlYWsgY29tcGF0aWJpbGl0eSBm
b3IgZGV2aWNlcy9GVyB2ZXJzaW9ucyB0aGF0IGRvbuKAmXQgaGF2ZSBDVCBvZmZsb2FkIHN1cHBv
cnQuDQoNCkFyaWVsDQoNCj4gDQo+ICAgIHRjLT5uZXRkZXZpY2VfbmIubm90aWZpZXJfY2FsbCA9
IG1seDVlX3RjX25ldGRldl9ldmVudDsNCj4gICAgZXJyID0gcmVnaXN0ZXJfbmV0ZGV2aWNlX25v
dGlmaWVyX2Rldl9uZXQocHJpdi0+bmV0ZGV2LA0KPiBAQCAtNTMwMCw4ICs1MzAwLDEwIEBAIGlu
dCBtbHg1ZV90Y19lc3dfaW5pdChzdHJ1Y3Qgcmhhc2h0YWJsZSAqdGNfaHQpDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZXN3X2NoYWlucyhlc3cpLA0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICZlc3ctPm9mZmxvYWRzLm1vZF9oZHIsDQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgTUxYNV9GTE9XX05BTUVTUEFDRV9GREIpOw0KPiAtICAgIGlmIChJU19FUlIodXBsaW5rX3By
aXYtPmN0X3ByaXYpKQ0KPiArICAgIGlmICghdXBsaW5rX3ByaXYtPmN0X3ByaXYpIHsNCj4gKyAg
ICAgICAgZXJyID0gLUVOT01FTTsNCj4gICAgICAgIGdvdG8gZXJyX2N0Ow0KPiArICAgIH0NCj4g
DQo+ICAgIG1hcHBpbmcgPSBtYXBwaW5nX2NyZWF0ZShzaXplb2Yoc3RydWN0IHR1bm5lbF9tYXRj
aF9rZXkpLA0KPiAgICAgICAgICAgICAgICAgVFVOTkVMX0lORk9fQklUU19NQVNLLCB0cnVlKTsN
Cj4gLS0gDQo+IDIuMjguMA0KPiANCg==
