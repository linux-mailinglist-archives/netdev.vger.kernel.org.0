Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8B213249
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGCDpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:45:52 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:45953
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725937AbgGCDpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 23:45:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAW7qkrTnnypt+iB9ahA+PO5Am5tt5vHvb3erIuHICOLq7BKxkxrLE+brT3QsF/+POhASzuxmjThaqXyqpbLcqMPMrTcCG+Fo5LZXExmMba5nagh9vRq1MoAf8iH2GlSbERhaLFaJiGHFjKfzsYoOuR4VOAThcljuxPfusCWlxJO9zkN1fK+iWXX7dHrxEHBJGGGgE5P3lDMKFvCLWhe7HeRO+GUoj0mgoaXDqq530uMaaJMmdIvDYUWycwL5cITkXV94YHinN53GMMJSiyNSJigMI4ctv/PJzTGRJSII0oXzZXuIoyWy2m4kHie49pPvuD4T7Ww+G82RHN3UkgDbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6fXuw4GA5b5x8Vic4SJwVxY6WfziwtdRCaJasf+kJ4=;
 b=DPKSP8nVEwyxI9d/Ae2isgq32d4osl53Fpk8DEH+YFv6VV8DVR5gREQhxsChyorTstm5L9gWtVZDsyTSrM1dqynn30Ft/5AWaiY09qlLf8Nownqrqn9m4u0LQX5xCqSGS/b4RKUb0NbGdye2LGhUYke2Ln9IWVW9h3X7RHzuNsFQu47rxUVwkTcx0ipTgRsqtDNCdHuKY72qPXxI9yTdsAKuxAl0jVZ2/AWw/1+Z1fJSmI+OLrw/1etiKOU/kDo5fz491q7X+tf9u5AyioJK+pu6RxJVDitbzmhRKp4PFa7t+X72c+ZfYHhqDo97RJgfn3RrjSPyuaHmOuVLJuDLkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6fXuw4GA5b5x8Vic4SJwVxY6WfziwtdRCaJasf+kJ4=;
 b=leZ0Rd1L0sp4KDg5Rdjq6u5fNJ13f649y0sH6p/gYU2HcBIa/5RnnPIa++H4N153UshNtfOiZN7sLvL8vH10fF9srkyg4u+/7jHwBC/nu6B2z9cD+91LOiN0c/S68+iSmJ5Rp0zHw8NerybUUmoM1BHUBriYeXmCfh70cEpBI0A=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4303.eurprd05.prod.outlook.com (2603:10a6:803:47::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Fri, 3 Jul
 2020 03:45:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 03:45:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ron Diskin <rondi@mellanox.com>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Thread-Topic: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Thread-Index: AQHWUL8B0dTQ7515okubmzIlcDj/s6j1FnWAgAAg54A=
Date:   Fri, 3 Jul 2020 03:45:45 +0000
Message-ID: <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
         <20200702221923.650779-3-saeedm@mellanox.com>
         <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 962ff7ed-2b5e-410e-b8fc-08d81f0391a9
x-ms-traffictypediagnostic: VI1PR05MB4303:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4303FFEFA6C62FF8CA663401BE6A0@VI1PR05MB4303.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Hez+0gxizpZOPbiwi5dNYCks9ZfB5xjOUDPAgpzhkXKnlUEA3UiaLW1Do5Qm0PaikCHFOPy3aZRxW4/JkX3H4JLLZWFzUpK+wzrav7yAtgGXhFT+Dg4+glR4hpOAK3dLC5Uv1o8xMZsX5nsiHTIr12YkDjOzJd4QovBDqe8Zpy6YnpBT7D4h+lhKo5t4zRsGmnWQ1uhdOTsus2HnUVS8yjyNzbWANvjscSB+hhrcXkJWFj6gxi924MpAz12GgHTIa+gsjTIKOE8FRoLFixgicM/6k+YtGgmLusrPgwVsiazHvmvFKFcQHtoNYuZ0EC+m34Ci+9ZF7W2NAQ/TMBg1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(4326008)(91956017)(186003)(76116006)(2616005)(83380400001)(107886003)(6486002)(6512007)(66476007)(66946007)(66446008)(54906003)(64756008)(66556008)(36756003)(6916009)(71200400001)(8936002)(26005)(86362001)(316002)(5660300002)(2906002)(8676002)(6506007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NA4+zboWUgR8xFErU98kPWq0KflEEJ91M0+KbQAtLmOfN5DmBW+6EE6DkDqGeifF33XbNeOG968jKpGQ0bedPoDhnnawhzGOFKVB2vJSxmzLJ9osM0fXvK+y74l6XsSKnYF48yvmIr6V+vFOooaxENx8jP2baoj9pwX2V6giKc+xe1SF4rlrkPaDY2ytTqadCxTmN2D6DH5jIDh03yiSkxLPOr2TwthaDMzsFsHHwfwrNIRygCcgQMuJCxwZnHVX/aZ02ylbsIjtxDAs9Bj4Sb4XYFrfGR5RGqsSW7GuaPMYGHmPeV2wgdpOfHsbrbF/eLAa+9UJ6KheiRkcZPTo5XJqPBXRo0VQp6Z0KvcoHo+v5WIvxGxAgPWURYcEqMF1FKNu4xDrQmJvdkFar8+ArtmRLQmeh5rUurIYCcEjTj1abhoHxyWYSNTP/nlq6fF3WbdM9/72/DLb2mLq/v++22PbK6BzMBzY5dC5DJCSdaw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75A0263350B60D40B8C4D1D58D287F94@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962ff7ed-2b5e-410e-b8fc-08d81f0391a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 03:45:46.0398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qfuf6/jGitDfok337YYs/cI67hDFUWNTO4uU+rQgXpxgUNfwciLTk3lyNsrdEaNgCBRE4LGYobs133+lEmok4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4303
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTAyIGF0IDE4OjQ3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAgMiBKdWwgMjAyMCAxNToxOToxNCAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBSb24gRGlza2luIDxyb25kaUBtZWxsYW5veC5jb20+DQo+ID4gDQo+ID4g
Q3VycmVudGx5IHRoZSBGVyBkb2VzIG5vdCBnZW5lcmF0ZSBldmVudHMgZm9yIGNvdW50ZXJzIG90
aGVyIHRoYW4NCj4gPiBlcnJvcg0KPiA+IGNvdW50ZXJzLiBVbmxpa2UgIi5nZXRfZXRodG9vbF9z
dGF0cyIsICIubmRvX2dldF9zdGF0czY0IiAod2hpY2ggaXANCj4gPiAtcw0KPiA+IHVzZXMpIG1p
Z2h0IHJ1biBpbiBhdG9taWMgY29udGV4dCwgd2hpbGUgdGhlIEZXIGludGVyZmFjZSBpcyBub24N
Cj4gPiBhdG9taWMuDQo+ID4gVGh1cywgJ2lwJyBpcyBub3QgYWxsb3dlZCB0byBpc3N1ZSBmdyBj
b21tYW5kcywgc28gaXQgd2lsbCBvbmx5DQo+ID4gZGlzcGxheQ0KPiA+IGNhY2hlZCBjb3VudGVy
cyBpbiB0aGUgZHJpdmVyLg0KPiA+IA0KPiA+IEFkZCBhIFNXIGNvdW50ZXIgKG1jYXN0X3BhY2tl
dHMpIGluIHRoZSBkcml2ZXIgdG8gY291bnQgcngNCj4gPiBtdWx0aWNhc3QNCj4gPiBwYWNrZXRz
LiBUaGUgY291bnRlciBhbHNvIGNvdW50cyBicm9hZGNhc3QgcGFja2V0cywgYXMgd2UgY29uc2lk
ZXINCj4gPiBpdCBhDQo+ID4gc3BlY2lhbCBjYXNlIG9mIG11bHRpY2FzdC4NCj4gPiBVc2UgdGhl
IGNvdW50ZXIgdmFsdWUgd2hlbiBjYWxsaW5nICJpcCAtcyIvImlmY29uZmlnIi4gIERpc3BsYXkg
dGhlDQo+ID4gbmV3DQo+ID4gY291bnRlciB3aGVuIGNhbGxpbmcgImV0aHRvb2wgLVMiLCBhbmQg
YWRkIGEgbWF0Y2hpbmcgY291bnRlcg0KPiA+IChtY2FzdF9ieXRlcykgZm9yIGNvbXBsZXRlbmVz
cy4NCj4gDQo+IFdoYXQgaXMgdGhlIHByb2JsZW0gdGhhdCBpcyBiZWluZyBzb2x2ZWQgaGVyZSBl
eGFjdGx5Pw0KPiANCj4gRGV2aWNlIGNvdW50cyBtY2FzdCB3cm9uZyAvIHVuc3VpdGFibHk/DQo+
IA0KDQpUbyByZWFkIG1jYXN0IGNvdW50ZXIgd2UgbmVlZCB0byBleGVjdXRlIEZXIGNvbW1hbmQg
d2hpY2ggaXMgYmxvY2tpbmcsDQp3ZSBjYW4ndCBibG9jayBpbiBhdG9taWMgY29udGV4dCAubmRv
X2dldF9zdGF0czY0IDooIC4uIHdlIGhhdmUgdG8NCmNvdW50IGluIFNXLiANCg0KdGhlIHByZXZp
b3VzIGFwcHJvYWNoIHdhc24ndCBhY2N1cmF0ZSBhcyB3ZSByZWFkIHRoZSBtY2FzdCBjb3VudGVy
IGluIGENCmJhY2tncm91bmQgdGhyZWFkIHRyaWdnZXJlZCBieSB0aGUgcHJldmlvdXMgcmVhZC4u
IHNvIHdlIHdlcmUgb2ZmIGJ5DQp0aGUgaW50ZXJ2YWwgYmV0d2VlbiB0d28gcmVhZHMuDQoNCj4g
PiBGaXhlczogZjYyYjhiYjhmMmQzICgibmV0L21seDU6IEV4dGVuZCBtbHg1X2NvcmUgdG8gc3Vw
cG9ydA0KPiA+IENvbm5lY3RYLTQgRXRoZXJuZXQgZnVuY3Rpb25hbGl0eSIpDQo+ID4gU2lnbmVk
LW9mZi1ieTogUm9uIERpc2tpbiA8cm9uZGlAbWVsbGFub3guY29tPg0KPiA+IFJldmlld2VkLWJ5
OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo=
