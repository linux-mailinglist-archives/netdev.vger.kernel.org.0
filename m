Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08721F6FB8
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgFKWI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:08:56 -0400
Received: from mail-eopbgr00089.outbound.protection.outlook.com ([40.107.0.89]:6713
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbgFKWI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:08:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiENLFGwsjCYajTFqY83I/Fq5YX/uf8E0foc3l7zIXT20bfeLr8pBT5IxJu50zRS5hUinJvSJcJBMWP86MidSJTzjG38E5Lz6+Rsb5js979R3DWJ9Lo1uwQv4Tvj+kA4qSU1EyDKk0cH2xUqH0QlVJy5qGMIGeK1VfhHq5YCLfmFqt5rrzbuwfXYbX2vCkp6yBnuRGCU0dFGUpZdEra8O6HGG2nRF0X2bdkCWNqkbJICAHFHA8BQgPF7EJ9K0esNcBIyoqMgzhjMlQGrporwMa9rLrrn6UreKQrpboLEzVx84/qrJlw8mL5sTiE51F/3ktYcaoAAciucMGJb6xrDxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Akn/M/Qh/p6rpRyzDgNZV3PDQXZnEkeR/SlP/TADP5o=;
 b=Bnidl/DPNT9vgdd51aAvonn8ejbRs0LKPTlBEfepT8hh8vZZAOmrKSi79Xp4yfaeQ/mzJHzcRHq15Ngn34eg0crVTBMSloZLrfOmnBtwi52kyXClnOv2xmfaKB1co9hJ9sSFteCjYiV+FOEz+OgmMzb8D1gX8w0OID7FRO06PjktU3gOQqiDEA5LTwyRWXP5hfyPnYoHPJdSYmx0P79NGCEJwkugHxSN0uGcXpUZ4y7Y3DKOf7bMdBGqmUa8KZA3xADT7hj2qei+Ol/7oqccimSC6DndWbW4kbMfpifRj0NxZXwms54Wg4Cl+Ja0ROkLfobtc+vdL7l8mI4z6Do84Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Akn/M/Qh/p6rpRyzDgNZV3PDQXZnEkeR/SlP/TADP5o=;
 b=kKVwXM4ap4SjXoQUCiQaUz8K1CgTTtngHKyFg3j/cotJH8R6L5QKAhPyxjf80gTNNHfetrv6LzLiVwvu7g5ni+tOTcTKiUM0NWu5A618DUdF8fy9+mA9S/7GyvggAC8H+hWpzwSmKaHlKvmKGXS2I9HK1ykBrj+N3PHcKbNrYh0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6415.eurprd05.prod.outlook.com (2603:10a6:803:fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Thu, 11 Jun
 2020 22:08:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:08:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "efremov@linux.com" <efremov@linux.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Thread-Topic: [PATCH] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Thread-Index: AQHWO26wR5RaG1X1skiq2QytAVGtR6jKcCYAgAmSvwA=
Date:   Thu, 11 Jun 2020 22:08:50 +0000
Message-ID: <6e00918130708cdc8eb6cbf77333ef92567675bc.camel@mellanox.com>
References: <20200605192235.79241-1-efremov@linux.com>
         <1cd5f60d-4a42-f7ba-1d0b-2303470a1f73@gmail.com>
In-Reply-To: <1cd5f60d-4a42-f7ba-1d0b-2303470a1f73@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: linux.com; dkim=none (message not signed)
 header.d=none;linux.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d160198-576b-490c-bccc-08d80e5405ae
x-ms-traffictypediagnostic: VI1PR05MB6415:
x-microsoft-antispam-prvs: <VI1PR05MB6415A1A64126604716BF68BBBE800@VI1PR05MB6415.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eVcxaEJqob0DBDtYVyRXSfKTLC7SDXpEs+RWW9LRWc9l/5OPPChLZ9FbTCd225EGcyrtPUx9H0qVGcE2iGJaxmyrZ6tyHBS49rqNdKHi97RL4oM3RV6a3eE82bnoctshx4hyCJbVsQJEVbYuNq868/vxZpycmDfzcLdNO4OhAVigRSnZXf5sqxkOF1vvQPh9KFvGs7nyaD9ryvol91dqI6+uY72XSIRjgp1aaGyFzv2KB1zsINaQR6qbRzYCuXGHLebLJOmRyORtoDw/WCcNLS3ir7+WJOloZNOMnO03cN/q2o1hTpHGLdGrXSK1l7Qw+AFO9oW51xDGM+xOZLrl1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(8676002)(316002)(8936002)(71200400001)(4326008)(2906002)(6512007)(5660300002)(54906003)(110136005)(6486002)(91956017)(66946007)(478600001)(86362001)(83380400001)(6506007)(36756003)(186003)(53546011)(66476007)(2616005)(76116006)(26005)(66556008)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5iqtlyI1KZRCnUVdBpg+3X692+gLB5mbZ75naPh37uBSN/JqgoOUMiSDxpaneNQ5+zY/1DE8bz9CPZqRAUONwfh0TImZ887kdlCGtSDhur00DHIX+EZbEpXwVNWHu55EIDA52EzvwekHga2Vn+E94H72azAQRJ/VF+vXB/1g6TOX0ggIBKn5udI5CopeSNfs1CxVX5EHJQ5Ps4JBYSNVpCBcIyUk+73/IdthT7hFdPLcgvgwBVnApXfhp1PiPVtFnhk8WQzihn2nht8iNqFxcC57NilIlAYN9lZGZ5FZTLKNINVCj3lvwst62dXK10YRqKm7LI0V1JAVyrjvnANnWNvpgCeJ2+5vBuioZomT7ambE9nB8eD5WH+sFpyBBEPMQ76qrUg1Fw4vwPDQypf1itlScZUT3HkHFWnAAkRz3BfZ3AGuvIhjAB9ts69EM6eIRz5fR9K1PRe9JtlxAFDSCByB+vtXx9JqZ1nnaWdB/CA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDF05B72BD204B49A7CBA4ED70FC54DB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d160198-576b-490c-bccc-08d80e5405ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 22:08:50.6525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xFXCxV+MVVzTgnJmhX2qcyEYP6vXB1TZCWc2yHdPjlHfv+sZYlEn2IPSEYBU+YRLGOnennHGt7yWPKudf1Ie/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6415
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA2LTA1IGF0IDEyOjU3IC0wNzAwLCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+
IA0KPiBPbiA2LzUvMjAgMTI6MjIgUE0sIERlbmlzIEVmcmVtb3Ygd3JvdGU6DQo+ID4gVXNlIGtm
cmVlKCkgaW5zdGVhZCBvZiBrdmZyZWUoKSBvbiBmdC0+ZyBpbiBhcmZzX2NyZWF0ZV9ncm91cHMo
KQ0KPiA+IGJlY2F1c2UNCj4gPiB0aGUgbWVtb3J5IGlzIGFsbG9jYXRlZCB3aXRoIGtjYWxsb2Mo
KS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBEZW5pcyBFZnJlbW92IDxlZnJlbW92QGxpbnV4
LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX2FyZnMuYyB8IDIgKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hcmZzLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hcmZzLmMNCj4gPiBpbmRleCAwMTQ2MzllYTA2ZTMu
LmM0YzlkNmNkYTdlNiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fYXJmcy5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX2FyZnMuYw0KPiA+IEBAIC0yMjAsNyArMjIwLDcgQEAgc3Rh
dGljIGludCBhcmZzX2NyZWF0ZV9ncm91cHMoc3RydWN0DQo+ID4gbWx4NWVfZmxvd190YWJsZSAq
ZnQsDQo+ID4gIAkJCXNpemVvZigqZnQtPmcpLCBHRlBfS0VSTkVMKTsNCj4gPiAgCWluID0ga3Z6
YWxsb2MoaW5sZW4sIEdGUF9LRVJORUwpOw0KPiA+ICAJaWYgICghaW4gfHwgIWZ0LT5nKSB7DQo+
ID4gLQkJa3ZmcmVlKGZ0LT5nKTsNCj4gPiArCQlrZnJlZShmdC0+Zyk7DQo+ID4gIAkJa3ZmcmVl
KGluKTsNCj4gPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gPiAgCX0NCj4gPiANCj4gDQo+IFRoaXMg
aXMgc2xvdyBwYXRoLCBrdmZyZWUoKSBpcyBwZXJmZWN0bHkgYWJsZSB0byBmcmVlIG1lbW9yeSB0
aGF0IHdhcw0KPiBrbWFsbG9jKCllZA0KPiANCj4gbmV0LW5leHQgaXMgY2xvc2VkLCBjYW4gd2Ug
YXZvaWQgdGhlc2UgcGF0Y2hlcyBkdXJpbmcgbWVyZ2Ugd2luZG93ID8NCg0KSSBhZ3JlZSwgd2l0
aCBFcmljLCBiZXR0ZXIgaWYgd2Ugd2FpdCBmb3IgbmV0LW5leHQgdG8gb3Blbi4NCg0KSSB3aWxs
IGFwcGx5IHRoaXMgb25jZSBuZXQtbmV4dCBpcyBvcGVuLiANCg0KVGhhbmtzLA0KU2FlZWQuDQo=
