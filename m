Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884342312BC
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732834AbgG1TcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:32:11 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:20456
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732813AbgG1TcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:32:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXyVyrAzV3RsWiZ7rZRPkOaSnZPcg79HrVK5KEv4MLuOqfeerz+uuW2Dx+wc4tQnXX3RZNiXKk28r9llCZg0Tz4C8pCGv7JwmuqIHJioYFFpYHzGsypyFtaKn8z75nS9VLA8KhuxBK+6WEY9L99ls0ME9Ds3binhKe1/hGXYjnzVhn4ioa0RjIqp76zkmAVKe9EwiXsWadz0fWjTDlhzSnO5+Q/woVzjcAv+n3Hs0veRi+9iGiRfd+VRZMRv8xQWK6oSBXTiagh4K+VmvvZKq8TIW6yNbE1oH91IvklDhqQ7+biqO2QKiFDanY3PqoaY2EX1WTwd2+rZyR7apaRdxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weqhGaAm1Ixh7Ly3SYPFZh+8+h7Uuz8hY54U0DQkN4M=;
 b=m0CRo5Bf8pNHy48Fl/xceIWGCVB4PDfSbLlximGT88Fc0bea1a1lq1zA50TlwoxfUWlZuQwMz59NeXQtQydlJIrgxqhTeIeTkhe/9tyGa5UrTw/4/GUgB+xCRZJEDbERG+NeR7CsmfHqONbSkCZB0xccWRZW8Xv5RuczuqVxy9JfcqgdPcXXZFBBxpXrG4n/7A1pXY4bKPDan7uXhWkXnZGTdnJAihib6qv56mfdN6PLUmyFI7CwKm9rIlg/FckZpUEE08zaRJ8lkKJkxafPfLdJwb2P6MWctGMtVNhsPmDN5tMRPOfLZzXHv+t3IpzfSywn7pt6/+tETHsZDxuDdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weqhGaAm1Ixh7Ly3SYPFZh+8+h7Uuz8hY54U0DQkN4M=;
 b=fttYK8A9Y19AvWgV+gPomP0mvMDEUEAq2PVZPhg9Hwj4NhwKjJyoSG5NGxnWTOcTAJrfnnplqRg09ecTdQmb/uDlJlwbFcvUyYKQWPzN1oDs+vWjpYpUC6hRmGpD92o/R0SRnViZOtfpeGdlR/gUb7ZaeFsALfBFJB9a93lx75o=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3902.eurprd05.prod.outlook.com (2603:10a6:803:8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 19:32:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 19:32:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Eli Cohen <eli@mellanox.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 01/12] net/mlx5e: Hold reference on mirred devices while
 accessing them
Thread-Topic: [net 01/12] net/mlx5e: Hold reference on mirred devices while
 accessing them
Thread-Index: AQHWZL8C/cJbTYowkEK6dshbKnSjc6kcycuAgACYQAA=
Date:   Tue, 28 Jul 2020 19:32:05 +0000
Message-ID: <b82449d6fb17471cc23e84f59d264b6b05b08762.camel@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
         <20200728091035.112067-2-saeedm@mellanox.com>
         <CAJ3xEMi-wTfGZvTh=g6Gb5taK_qR=PiDyiAQAPRPiEaSckH8_A@mail.gmail.com>
In-Reply-To: <CAJ3xEMi-wTfGZvTh=g6Gb5taK_qR=PiDyiAQAPRPiEaSckH8_A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 772c190a-5c8b-46b6-3871-08d8332ce977
x-ms-traffictypediagnostic: VI1PR0502MB3902:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0502MB3902C6173A1E4FEBF3104411BE730@VI1PR0502MB3902.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4BRE7Q7rUk6YAUutw834+iOHT66MWPgbmtQcZ7FRiIWMDqwYbdhrFsitkwVJqhvWgFa1aqSK/si8kgMdDsipBjCSRtsGFdFXdMhc+etkLZ0wZrq/OwmWf8rqvy5hP4Y1bA7ivBCKIJ0vq2iQ8TTZ5NbYei7dPeMWmKhylRK2c2TOOPeliiSAAZMb4ihGScajrjW1zhlUwSZFjr/ZC3PyoKiltr3HMQE1dS9LX9As5DxgvTDtGgCeraI6zPjO9pv1dZEP0eL7HpOFy1TvyzSRP9UaDFWwCiAzRMELAYt5N53Mxk5600bagBnQnq57gWvV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(91956017)(76116006)(66946007)(64756008)(54906003)(4326008)(110136005)(5660300002)(66446008)(71200400001)(66476007)(26005)(66556008)(186003)(4744005)(8676002)(2616005)(2906002)(6486002)(86362001)(6512007)(53546011)(83380400001)(36756003)(498600001)(6506007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 8ubAcFHUzYmRWjVRoKYZTPWsI2e4fW1ODrm4nLSsUq2wWv6jXsIHgGy3NGVE3cWbyeGNHQeJEjQl72jsQfksB8dDoomVw/xx5JUcR+fcbcX7DwOVcoSX2VI3Sb4GbZnS2yrDgIF2Y7d2yQga1agYPHPQhNYlSg99KNfupwKVm7MOuRsobCWHrDGubN9tL52LU9mWWrFuHq98tz09Q9q0PZ+P63krJzs/Rw9M7sJ3pkWn/fQKMZcvLlVQFTLVXxZ556dei2ECgRV8gb0Obsszvikvd1EKed9Kjl2EKjsFIVrtXdu82KZXsP8BDq7cb+gEzD+OGGX2ILSG3EEWlF++1cojmuV+7t8m+nBrUngSJUJqKzmUhXdYq3qUtxVYd61wnNImtE94BhT5FTIZjhW5EMgJwjNFQUt7gshOIso+MuRQ7mDKxbE/j7WhhmwTj4dGR/r2o+hgvlkRh8OUvOmKgQ/BHtuRk7ecb+OGOnCQxpk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE4B2ACEDE767542AB2BA7D9296D2C54@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772c190a-5c8b-46b6-3871-08d8332ce977
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 19:32:05.9910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rLcW7oxQTM5M62JAo7BA+tpK/+lb71t4MyVpmeCnAmwo8ueupGx1UcE10nznmoyOMtpmZ2hEDbQbE3T5Kl1DFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3902
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTI4IGF0IDEzOjI3ICswMzAwLCBPciBHZXJsaXR6IHdyb3RlOg0KPiBP
biBUdWUsIEp1bCAyOCwgMjAyMCBhdCAxMjoxMyBQTSBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT4NCj4gd3JvdGU6DQo+ID4gRnJvbTogRWxpIENvaGVuIDxlbGlAbWVsbGFub3gu
Y29tPg0KPiA+IA0KPiA+IE5ldCBkZXZpY2VzIG1pZ2h0IGJlIHJlbW92ZWQuIEZvciBleGFtcGxl
LCBhIHZ4bGFuIGRldmljZSBjb3VsZCBiZQ0KPiA+IGRlbGV0ZWQgYW5kIGl0cyBpZm5pZGV4IHdv
dWxkIGJlY29tZSBpbnZhbGlkLiBVc2UNCj4gPiBkZXZfZ2V0X2J5X2luZGV4KCkNCj4gPiBpbnN0
ZWFkIG9mIF9fZGV2X2dldF9ieV9pbmRleCgpIHRvIGhvbGQgcmVmZXJlbmNlIG9uIHRoZSBkZXZp
Y2UNCj4gPiB3aGlsZQ0KPiA+IGFjY2Vzc2luZyBpdCBhbmQgcmVsZWFzZSBhZnRlciBkb25lLg0K
PiANCj4gaGF2ZW4ndCB0aGlzIHBhdGNoIHNlbnQgaW4gdGhlIHBhc3QgaW4gdGhlIHNhbWUgZm9y
bSBhbmQgd2Ugd2VyZSBpbg0KPiB0aGUgbWlkZGxlDQo+IG9mIGRpc2N1c3NpbmcgaG93IHRvIHBy
b3Blcmx5IGFkZHJlc3MgdGhpcz8gaWYgc29tZXRoaW5nIGNoYW5nZWQsDQo+IHdoYXQ/DQoNCkkg
dGhvdWdodCB0aGUgZGlzY3Vzc2lvbiB3YXMgY29uY2x1ZGVkID8gDQoNCmFueXdheSBpIHdpbGwg
cmVtb3ZlIHRoaXMgcGF0Y2ggZnJvbSBteSB0cmVlcywgRWxpIHBsZWFzZSBkaXNjdXNzIHdpdGgN
Ck9yLCBpIGFtIGZpbmUgd2l0aCB0aGlzIHBhdGNoIGFzIGlzIHNpbmNlIGl0IGlzIGEgbWluaW1h
bCBmaXggdG8gbmV0Lg0K
