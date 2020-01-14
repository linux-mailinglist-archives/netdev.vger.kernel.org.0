Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B0713B3B4
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 21:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgANUdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 15:33:55 -0500
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:31360
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728986AbgANUdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 15:33:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0fVsCyAEB/L/y+cxoztkBJtg3cclxoUcLsjCKqFeFnboLvy/Ju4bU0eOS8D4UYjWvGvqNWWt4yeOiRAZsKl4k2IFIUfrOCjb4vHrYv2wDodXE5LEpWaFuKXmCXNIZtChk4uzOA0WBk6O/ofKcK8zfczLY3oAambO+dR0PNALH7eEWPRuvP+vVnGPy8FUBlvMAC7+EHLbKf+wQjTFnub4IYCerbAFW9VrVMw4spxFYGK1LkNe27731jyJpbQHrO+QZRgAAWIn8MvhPEsITJ/c1phtTXHpb8FW0ZPh0QuHYhx1k9XiR0c2Fsiz1+wjteD4Bx+E8ncPR1HJPgZ94W0CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+VhthRkZENHZDDcR+Vjm0i2uSJ533dmPehf8iX3+yE=;
 b=KOSGuUWebXQxYqVV9UUo/XoHKEBRv4G+zvJbS/U8u+b32hAndZcuigg6sGKxjdi30RSSSYW43LByqgO3iZTs9kihx+2VVNkqIZaOg4uEoz2fc7BDvvbjHJy0lGwZ18R5lmfYpfYcwzeB7gvrl93j97wdIG3T8ov+dAjI8+SlBHvVxI8p/6x67A6I6jfm6/0dkKazQ4aHpPnXHw2u5dJzApKAzH+g5Ud8J2OZ85z8B2TbflMbczATVbmqqWQXvSADCLADltt650d67WuLXEdeLm+ZpxkrAL+9sk4vE56EO2vD/vyfD4bnPQ1O0QOW2K0BBBf5aQuxooW7RGVJ5RD7GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+VhthRkZENHZDDcR+Vjm0i2uSJ533dmPehf8iX3+yE=;
 b=fDDMCiRCXTVU7FSTD+LV74R/9V/ipr40/XD1VzVSjWlwLdm+bmvBL4RkWnAMXs3bfSaFqK5yMGDeM1ng3wu542OTIw5uPLbFOyYn1ItJoz4AVPO1I6BJpHmCrlZLRsNtRMxd+nNz13ZnVbcW8cy0rdGJNLUpaO5B+z7shOxj0tk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5600.eurprd05.prod.outlook.com (20.177.200.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Tue, 14 Jan 2020 20:33:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2623.017; Tue, 14 Jan 2020
 20:33:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: allow TSO on VXLAN over VLAN
 topologies
Thread-Topic: [PATCH net-next] net/mlx5e: allow TSO on VXLAN over VLAN
 topologies
Thread-Index: AQHVxt0XKkb4QYB7xEaYOlzTI7MN16firjGAgAf35AA=
Date:   Tue, 14 Jan 2020 20:33:50 +0000
Message-ID: <0a3bd429b63967286e1dc3f9a637abb741271b4c.camel@mellanox.com>
References: <c1f4cc6214c28ce9a39147db9f3b66927dbae612.1578567988.git.dcaratti@redhat.com>
         <20200109.105237.1514181450032103034.davem@davemloft.net>
In-Reply-To: <20200109.105237.1514181450032103034.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.2 (3.34.2-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 74c7378b-00d4-4f31-41ac-08d7993110bd
x-ms-traffictypediagnostic: VI1PR05MB5600:
x-microsoft-antispam-prvs: <VI1PR05MB560031BE6B131E4E22148C73BE340@VI1PR05MB5600.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(189003)(199004)(186003)(4326008)(6506007)(478600001)(26005)(2906002)(2616005)(81156014)(81166006)(8936002)(86362001)(6486002)(8676002)(6512007)(5660300002)(66556008)(66446008)(36756003)(64756008)(316002)(71200400001)(110136005)(76116006)(66476007)(4744005)(66946007)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5600;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /BbOugvmnczZfyz5NvyIOotZdGJeRbJvSQKIvLlbMu/bxlaFza1HqvVQty3E9jsPCMaWiWukHPFKi06KVdRGMNyo9zuNAMgfvCl5/PkTDsnBHPcp07s9+qutVh3HhhhQoviNb4im2OAvtLhlLkJkRYcZKTqC2ZfGM5Q3CpoHq+NVUNSTKmzCS7RjLhRLSxY4LD8fRIoP4tWXGwc0AK4SVQlOzDe7hsLxHHB6muZo//R2a2Hzoamkxlb559C4TYA+v5jRZsViLBDhdRBmdcCe3lkbU/RS9Bdji0hm3EvRSSLcBEulo0kqMUgcW9blVmycEp5N3R4TjzQRRnEf7qVle7I11SWTB0fmAJ6GdMLRMpbGD7IUh2HgveMrPmkXvL50cKyS7/8TZB841bHrw8hFtPYgcHZaz4F3qUcRB1LRQbiRcPbxiDM3nij8shjLf/wp
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A9614D55A4E6C43A388D9DDABF53D37@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c7378b-00d4-4f31-41ac-08d7993110bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 20:33:50.8440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hkDyB8mbsCKc3izIIkFrRrrDDlvP0SRx09Wz5EM0mslE/VbMrU0Q2uc80dTkp8X6pkU9ikxDS9VXpzZx9McaWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5600
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAxLTA5IGF0IDEwOjUyIC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IERhdmlkZSBDYXJhdHRpIDxkY2FyYXR0aUByZWRoYXQuY29tPg0KPiBEYXRlOiBUaHUs
ICA5IEphbiAyMDIwIDEyOjA3OjU5ICswMTAwDQo+IA0KPiA+IHNpbmNlIG1seDUgaGFyZHdhcmUg
Y2FuIHNlZ21lbnQgY29ycmVjdGx5IFRTTyBwYWNrZXRzIG9uIFZYTEFOIG92ZXINCj4gVkxBTg0K
PiA+IHRvcG9sb2dpZXMsIENQVSB1c2FnZSBjYW4gaW1wcm92ZSBzaWduaWZpY2FudGx5IGlmIHdl
IGVuYWJsZSB0dW5uZWwNCj4gPiBvZmZsb2FkcyBpbiBkZXYtPnZsYW5fZmVhdHVyZXMsIGxpa2Ug
aXQgd2FzIGRvbmUgaW4gdGhlIHBhc3Qgd2l0aA0KPiBvdGhlcg0KPiA+IE5JQyBkcml2ZXJzIChl
LmcuIG1seDQsIGJlMm5ldCBhbmQgaXhnYmUpLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IERh
dmlkZSBDYXJhdHRpIDxkY2FyYXR0aUByZWRoYXQuY29tPg0KPiANCj4gU2FlZWQsIEkgYW0gYXNz
dW1pbmcgeW91IHdpbGwgcmV2aWV3IGFuZCBpbnRlZ3JhdGUgdGhpcy4NCj4gDQo+IFRoYW5rIHlv
dS4NCg0KTEdUTSwgYXBwbGllZCB0byBuZXQtbmV4dC1tbHg1LCB3aWxsIHJ1biBzb21lIHRlc3Rz
IGFuZCBwcm92aWRlDQpmZWVkYmFjayBpZiBhbnkgaXNzdWVzIHdpbGwgc3VyZmFjZSwgd2hpbGUg
aSBkb24ndCBleHBlY3QgYW55Lg0KDQpXaWxsIHN1Ym1pdCB0byBuZXQtbmV4dCBpbiBvbmUgb2Yg
bXkgdXBjb21pbmcgbmV0LW5leHQgcHVsbCByZXF1ZXN0cy4NCg0KVGhhbmtzLA0KU2FlZWQuDQo=
