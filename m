Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7711A2BED
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDHWi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:38:58 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:6099
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726467AbgDHWi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:38:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfmeHej3WpQZRNO9I9Z+hczQEpebfQle40DhAJDKT3Nk6sqBCZ4bcz01RdEiblUzNBIcvMr+t8+VCm0gJFlmtqmY1A27t3ZkWzmLPhI8gVjuiN3XojOSPYCT7tMmeD0FOV+1fMCi2COyVi90Vj8tB75l2WoiVLGG3QD4i0qny+kLKtfMkuaTn8QQIMNHpMnKF3JJRVJqI7XVNma48h04s4ssHDY+RYujz8p5mSeUntcXFBPhXv2UMkBota3NtdJqmA/jvdJPyv99ZslZ298VZ6oUkX/ISrdIYBv1iyLofACCDlTuyrBftQyCzAiLhTTWCf7OuBntl1mz1FW+kGsNdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNuSaZSBwJZ0nD1GFLDozTqIePVolMK2GsUFI28vlt4=;
 b=ILALtEX3VjR+abIoe+QLvkS8rE9fdeDtyKeIgRzfaoH523tEmv7erCYEjadh70Y4Qyrvd4gfSt+9goroWiYD8pikn8k8IIgmbxAW+TBhlItxiVDuZyACXM3BjxaPdMTzYi6NNwvxenwOvkl9YggxJUvWPTRGGlbzni488O9wszmQ8pDBXrGYTKGFtPNuFRHBy+0OwbzxwYWFxbWS7myLPmEhGAJStwOq7x4MLEd/5o5XomiIfYCUsqNTPv2mzZfnji7Q7I4FTT5uqY7G3kdtgs293CS5G1aN3t96+OiRml5xcCiR42n4A/nHll3ZIKrAElmcL/IRu36z81075d6K6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNuSaZSBwJZ0nD1GFLDozTqIePVolMK2GsUFI28vlt4=;
 b=XJf/uvivjS1Jnx6SSXIh/4l6F/ddIdIvvA6aIDCjNItkM6tWsQ4hn4ELG+ZbGAaFxS56r9E4UKBVxKhVTarXySn9wTN5llxcV+DrTSQRDH0Y45YFo0NQJGYIh99gRt4LSJFpXZmbXJz9KxanwmIX2s8/IE34/B6YObmyozlgFl8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5935.eurprd05.prod.outlook.com (2603:10a6:803:e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:38:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:38:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing to
 _once
Thread-Topic: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing
 to _once
Thread-Index: AQHWCUyXcROC9qaN+Eig+06PJQGPPKhmrCGAgAAGAoCACPlpAIAAImAAgAAMa4A=
Date:   Wed, 8 Apr 2020 22:38:52 +0000
Message-ID: <54e70f800bc8f3b4d2dc7ddea02c1baa0036ea54.camel@mellanox.com>
References: <d57b95462cccf0f67089c91d3dfd3d1f4c46e9bf.1585872570.git.marcelo.leitner@gmail.com>
         <c4e43a61a8ad7f57e2cb228cc0ba810b68af89cb.camel@mellanox.com>
         <20200403024835.GA3547@localhost.localdomain>
         <d4c0225fc25a6979c6f6863eaf84ee4d4d0a7972.camel@mellanox.com>
         <20200408215422.GA137894@localhost.localdomain>
In-Reply-To: <20200408215422.GA137894@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb9bda91-ca29-4a65-bd4f-08d7dc0d9cfd
x-ms-traffictypediagnostic: VI1PR05MB5935:|VI1PR05MB5935:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5935AA1F66078BE46D5A0C18BEC00@VI1PR05MB5935.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(136003)(346002)(366004)(76116006)(6486002)(71200400001)(8936002)(66556008)(26005)(186003)(478600001)(86362001)(66946007)(64756008)(6512007)(81156014)(5660300002)(66446008)(91956017)(66476007)(81166007)(54906003)(6916009)(8676002)(4326008)(2906002)(6506007)(2616005)(36756003)(15650500001)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N7JNjUlES921vY2ej5Ts07ZxmiD38xpaQA4nLMReR6eOs8UC/VBVvxpyqpZSPLTQ/RXww3J4rqlNVBdoC+CS8pqTQnb1GW4OQew+dAhv7xgl2jga2OXm0cB2LjBnmE+BHirXXoELLLv8wQxfVh6V7xF2We+KJHaI2tjswWSyt8LI4o/x4Ae2zSRCiu94NJzes58arml/QdxcydYT0jR0PRIcmCeuH9b2GEBaIE17xTSkhl5qMOWqqzj6DDBkQFC4NWihHuVA2yLq/0dUs6U1aFYoiiu6YoSYr6yuarxhlLQlAZdzBuQ2kZyK5mEHaFUsX6UVo1GpXuGZOUer/nImd++l6ianrBQjRBEsJDX8XGhtL99TSLlgov8PkIkSQeXR0dyhFs15v4WTzAL9jY5tkfkzFli7icVf/zzvRX+cyTOim6VjTWLED5xtorvfynqG
x-ms-exchange-antispam-messagedata: bjeMjGpYHpFkOuAwNdtlgmnKSXHUlbhj+qzEs8Y1VTB+6ggUTEO6M0NNQDhuuAio5AnnA5M6/Fcd6o1h6kEBl5AUL3R5doqemN+j3i0VoUZp42U8vAL0k6V1cm0DwG4WhfgvzXH55D9DD6abMZNFLA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <683D5620EF3CAD428EBD215A4B8DBD20@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9bda91-ca29-4a65-bd4f-08d7dc0d9cfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 22:38:52.1475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gR5bHEzlpJaWqQZcymUFhacp1rO2baa2WEK/xWopatMYziTzjyK0WPXjVV8ez3bgcQxXBub7PAsVG2dg9l7Log==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5935
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTA4IGF0IDE4OjU0IC0wMzAwLCBtYXJjZWxvLmxlaXRuZXJAZ21haWwu
Y29tIHdyb3RlOg0KPiBPbiBXZWQsIEFwciAwOCwgMjAyMCBhdCAwNzo1MToyMlBNICswMDAwLCBT
YWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gLi4uDQo+ID4gPiA+IEkgdW5kZXJzdGFuZCBpdCBpcyBm
b3IgZGVidWcgb25seSBidXQgaSBzdHJvbmdseSBzdWdnZXN0IHRvIG5vdA0KPiA+ID4gPiB0b3Rh
bGx5DQo+ID4gPiA+IHN1cHByZXNzIHRoZXNlIG1lc3NhZ2VzIGFuZCBtYXliZSBqdXN0IG1vdmUg
dGhlbSB0byB0cmFjZXBvaW50cw0KPiA+ID4gPiBidWZmZXINCj4gPiA+ID4gPyBmb3IgdGhvc2Ug
d2hvIHdvdWxkIHdhbnQgdG8gcmVhbGx5IGRlYnVnIC4uIA0KPiA+ID4gPiANCj4gPiA+ID4gd2Ug
YWxyZWFkeSBoYXZlIHNvbWUgdHJhY2Vwb2ludHMgaW1wbGVtZW50ZWQgZm9yIGVuX3RjLmMgDQo+
ID4gPiA+IG1seDUvY29yZS9kaWFnL2VuX3RjX3RyYWNlcG9pbnRzLmMsIG1heWJlIHdlIHNob3Vs
ZCBkZWZpbmUgYQ0KPiA+ID4gPiB0cmFjZXBvaW50DQo+ID4gPiA+IGZvciBlcnJvciByZXBvcnRp
bmcgLi4gDQo+ID4gPiANCj4gPiA+IFRoYXQsIG9yIHMvbmV0ZGV2X3dhcm4vbmV0ZGV2X2RiZy8s
IGJ1dCBib3RoIGFyZSBtb3JlIGhpZGRlbiB0bw0KPiA+ID4gdGhlDQo+ID4gPiB1c2VyIHRoYW4g
dGhlIF9vbmNlLg0KPiA+ID4gDQo+ID4gDQo+ID4gaSBkb24ndCBzZWUgYW55IHJlYXNvbiB0byBw
b2xsdXRlIGtlcm5lbCBsb2cgd2l0aCBkZWJ1ZyBtZXNzYWdlcw0KPiA+IHdoZW4NCj4gPiB3ZSBo
YXZlIHRyYWNlcG9pbnQgYnVmZmVyIGZvciBlbl90YyAuLiANCj4gDQo+IFNvIHdlJ3JlIGFncmVl
aW5nIHRoYXQgdGhlc2UgbmVlZCB0byBiZSBjaGFuZ2VkLiBHb29kLg0KDQpJIHdvdWxkIGxpa2Ug
dG8gd2FpdCBmb3IgdGhlIGZlZWRiYWNrIGZyb20gdGhlIENDJ2VkIG1sbnggVEMNCmRldmVsb3Bl
cnMuLg0KDQpJIGp1c3QgcGluZ2VkIHRoZW0sIGxldHMgc2VlIHdoYXQgdGhleSB0aGluay4NCg0K
YnV0IGkgdG90YWxseSBhZ3JlZSwgVEMgY2FuIHN1cHBvcnQgMTAwayBvZmZsb2FkcyByZXF1ZXN0
cyBwZXIgc2Vjb25kcywNCmR1bXBpbmcgZXZlcnkgcG9zc2libGUgaXNzdWUgdG8gdGhlIGtlcm5l
bCBsb2cgc2hvdWxkbid0IGJlIGFuIG9wdGlvbix0aGlzIGlzIG5vdCBhIGJvb3Qgb3IgYSBmYXRh
bCBlcnJvci93YXJuaW5nIC4uIA0KDQo+IA0KPiBJIGRvbid0IHRoaW5rIGEgc3lzYWRtaW4gd291
bGQgYmUgdXNpbmcgdHJhY2Vwb2ludHMgZm9yDQo+IHRyb3VibGVzaG9vdGluZyB0aGlzLCBidXQg
b2theS4gTXkgb25seSBvYmplY3RpdmUgaGVyZSBpcyBleGFjdGx5DQo+IHdoYXQNCj4geW91IHNh
aWQsIHRvIG5vdCBwb2xsdXRlIGtlcm5lbCBsb2cgdG9vIG11Y2ggd2l0aCB0aGVzZSBwb3RlbnRp
YWxseQ0KPiByZXBldGl0aXZlIG1lc3NhZ2VzLg0KDQp0aGVzZSB0eXBlcyBvZiBlcnJvcnMgYXJl
IGVhc2lseSByZXByb2R1Y2UtYWJsZSwgYSBzeXNhZG1pbiBjYW4gc2VlIGFuZA0KcmVwb3J0IHRo
ZSBlcnJubyBhbmQgdGhlIGV4dGFjayBtZXNzYWdlLCBhbmQgaW4gY2FzZSBpdCBpcyByZWFsbHkN
CnJlcXVpcmVkLCB0aGUgc3VwcG9ydCBvciBkZXZlbG9wbWVudCB0ZWFtIGNhbiBhc2sgdG8gdHVy
biBvbiB0cmFjZS0NCnBvaW50cyBvciBkZWJ1ZyBhbmQgcmVwcm9kdWNlIC4uIA0K
