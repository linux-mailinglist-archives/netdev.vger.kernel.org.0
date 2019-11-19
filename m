Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF61101A19
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfKSHNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:13:46 -0500
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:52968
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbfKSHNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 02:13:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WV96+Jy+32lGI5U+I1O735BHSNjLg8JqlZU9ApF5UY6j6Vo3p6E/GcGAe5xCGu49spymh6jZXddD8YyODcthwEvPkPOXZ9Og4+4ohH1aRQhZyPlGScRtd/hx7Qmopy+EBpoYBB0Xite05rnL+4CjNhsgi9x32m3YbsSgTlfPkcU21ofglVAhw3QtXqv+NKhEcjOf2lSPT28y3os9dtoWno7UVyASFUA6kfYmkEIiiTNP9WH2RRmFyFtEdm10WPtzBOdu/zi7V0s0Gu9PHC7Il7AZrJH/qCP2AF5AP/zjReooeDUhnN50pbcYwagRZom6R2QzWyOugoggrjk1Mj3HOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WydvYJfKC7ziVn8f359QmGI7zDAuEGWT8T0tDGBZkaw=;
 b=JNTIDW6/0psb8vadeEGhWOeHUAIhee7BWD78ZjMdDS+SZJh/lheUM+HzzIeUPQ+kxaPghhbzzAAO1XqGIlBGKeEW7Ox/qq/jOHhv5X3p7m3/IT2c/BWJCf5o6OiQXBHZfPaUFeClwMAkuEYoYipvtT1Qc6wE4xMS8M1kV8oAIFUiqaKuk5/wQtcqS5g/VuyrMEg97j6EVH66+CrFtMSV+Mr7dY7XyVOGM7146mjuo/J6eq5YAX0Gihw2RwoVHMZjnRPX0fQLFfAkET/LHnDsd0nKl8KXYwDACQHkV1EXuc7nSoeVLl7Y9zu0LKtzBfTqX0ZBQ0HZKo2VCl/SNv0Bug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WydvYJfKC7ziVn8f359QmGI7zDAuEGWT8T0tDGBZkaw=;
 b=CZH/QPijtpiPGPkyQ6UqdOdtjHt6W0ylrfxsefdVaKAnpiEALWczeT4j6cNnJLE7ppe2RbBemcmY+nUtWne3xd/8QpwldNXVTcqhQMgjJVRjVx4XfeTIe7SpCaCmxNmk6RdgltPTt/UC/jG+fYjS5wsl1SX1w8WomFENz4FRC4Q=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6306.eurprd05.prod.outlook.com (20.179.35.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 19 Nov 2019 07:13:41 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 07:13:41 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAURC4CAAAcf0IAAJnyAgAAC1aA=
Date:   Tue, 19 Nov 2019 07:13:41 +0000
Message-ID: <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
In-Reply-To: <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56e3641d-2224-419c-4823-08d76cc001b0
x-ms-traffictypediagnostic: AM0PR05MB6306:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM0PR05MB6306D43B941FD94AC0002438D14C0@AM0PR05MB6306.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(189003)(199004)(66946007)(86362001)(2906002)(102836004)(9686003)(6306002)(66476007)(66556008)(66066001)(25786009)(2201001)(64756008)(66446008)(99286004)(3846002)(486006)(476003)(478600001)(2501003)(26005)(6246003)(446003)(11346002)(7416002)(966005)(256004)(71190400001)(71200400001)(6116002)(33656002)(55016002)(14454004)(4326008)(229853002)(74316002)(186003)(8936002)(6506007)(6436002)(316002)(110136005)(54906003)(81166006)(76176011)(5660300002)(81156014)(8676002)(305945005)(7696005)(76116006)(7736002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6306;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: re4ISLLvoPhCNa9tHpHt8Vd4Au4DVGHcm2xcxndYipUBy8oI+1fU2YgapmrbCewA+Akc+nwRHX01umFrG+xEuLjIch6BeSvjBXYbtw/aCyjP8rhnXLN335Q8/h2hmlU7gihjwkilvHCdqH6OrXclXoeCQubXqKao1z2qO1cFCocvS6bgLBMoSd/8F+orHFhfjXiq0UoET7VycTrMopdGG/Hrz5z7E3eEnmGw6DPdmSVGxYqOj9O0ItQnfcgceEi+Ty28WyrnhFoWAhHRiwey3A/rTyzHPlwFPuVLLjXQl63cvzci+CMK7/xmla6DvNfGfwD07H1efZkFXqyhiVWSce8CddLgnj61EElyCCIPcXrNZa/Oy9Ud0UTtrw2HTbB0BHBmYVbER1xK8R9AMmdVKPYDg7sMzg9zPx2o6cANZCjcrJyO8VImQM+s6gCRpNgLU9Q0XnjAqfkCAYe3NiHbFKsqTjiXWFgv19RUsoaEvW8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e3641d-2224-419c-4823-08d76cc001b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 07:13:41.3455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cOOfwcEaoQ1puT5aaS4GZDSTsqXQ/bHi3eGEa+ZnXsCupBLG6WWpgTuMct3+j8cohfKGsMM7G6kRSOAI5soGWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6306
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbbmV0LW5leHQgdjIgMS8xXSB2aXJ0dWFsLWJ1czogSW1wbGVtZW50YXRpb24gb2YgVmlydHVh
bCBCdXMNCj4gDQo+IA0KWy4uXQ0KDQo+IA0KPiBQcm9iYWJseSwgZm9yIHZpcnRpbyBtZGV2IHdl
IG5lZWQgbW9yZSB0aGFuIGp1c3QgbWF0Y2hpbmc6IGxpZmUgY3ljbGUNCj4gbWFuYWdlbWVudCwg
Y29vcGVyYXRpb24gd2l0aCBWRklPIGFuZCB3ZSBhbHNvIHdhbnQgdG8gYmUgcHJlcGFyZWQgZm9y
DQo+IHRoZSBkZXZpY2Ugc2xpY2luZyAobGlrZSBzdWIgZnVuY3Rpb25zKS4NCg0KV2VsbCBJIGFt
IHJldmlzaW5nIG15IHBhdGNoZXMgdG8gbGlmZSBjeWNsZSBzdWIgZnVuY3Rpb25zIHZpYSBkZXZs
aW5rIGludGVyZmFjZSBmb3IgZmV3IHJlYXNvbnMsIGFzDQoNCihhKSBhdm9pZCBtZGV2IGJ1cyBh
YnVzZSAoc3RpbGwgbmFtZWQgYXMgbWRldiBpbiB5b3VyIHYxMyBzZXJpZXMsIHRob3VnaCBpdCBp
cyBhY3R1YWxseSBmb3IgdmZpby1tZGV2KQ0KKGIpIHN1cHBvcnQgaW9tbXUNCihjKSBtYW5hZ2Ug
YW5kIGhhdmUgY291cGxpbmcgd2l0aCBkZXZsaW5rIGVzd2l0Y2ggZnJhbWV3b3JrLCB3aGljaCBp
cyB2ZXJ5IHJpY2ggaW4gc2V2ZXJhbCBhc3BlY3RzDQooZCkgZ2V0IHJpZCBvZiBsaW1pdGVkIHN5
c2ZzIGludGVyZmFjZSBmb3IgbWRldiBjcmVhdGlvbiwgYXMgbmV0bGluayBpcyBzdGFuZGFyZCBh
bmQgZmxleGlibGUgdG8gYWRkIHBhcmFtcyBldGMuDQoNCklmIHlvdSB3YW50IHRvIGdldCBhIGds
aW1wc2Ugb2Ygb2xkIFJGQyB3b3JrIG9mIG15IHJldmlzZWQgc2VyaWVzLCBwbGVhc2UgcmVmZXIg
dG8gWzFdLg0KDQpKaXJpLCBKYXNvbiwgbWUgdGhpbmsgdGhhdCBldmVuIHZpcnRpbyBhY2NlbGVy
YXRlZCBkZXZpY2VzIHdpbGwgbmVlZCBlc3dpdGNoIHN1cHBvcnQuIEFuZCBoZW5jZSwgbGlmZSBj
eWNsaW5nIHZpcnRpbyBhY2NlbGVyYXRlZCBkZXZpY2VzIHZpYSBkZXZsaW5rIG1ha2VzIGEgbG90
IG9mIHNlbnNlIHRvIHVzLg0KVGhpcyB3YXkgdXNlciBoYXMgc2luZ2xlIHRvb2wgdG8gY2hvb3Nl
IHdoYXQgdHlwZSBvZiBkZXZpY2UgaGUgd2FudCB0byB1c2UgKHNpbWlsYXIgdG8gaXAgbGluayBh
ZGQgbGluayB0eXBlKS4NClNvIHN1YiBmdW5jdGlvbiBmbGF2b3VyIHdpbGwgYmUgc29tZXRoaW5n
IGxpa2UgKHZpcnRpbyBvciBzZikuDQoNClNvIEkgYW0gcmV2aXZpbmcgbXkgb2xkIFJGQyBbMV0g
YmFjayBub3cgaW4gZmV3IGRheXMgYXMgYWN0dWFsIHBhdGNoZXMgYmFzZWQgb24gc2VyaWVzIFsy
XS4NCg0KWzFdIGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE5LzMvMS8xOQ0KWzJdIGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LXJkbWEvMjAxOTExMDcxNjA0NDguMjA5NjItMS1wYXJhdkBt
ZWxsYW5veC5jb20vDQoNCg==
