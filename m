Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9458F17EE95
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCJCaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:30:39 -0400
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:41198
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbgCJCaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:30:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSzgaquKXZh1DPu9TQAmsvH2nFvvyDP36r6byJIZQv/dUlhMMJchOj0JdPf5LIINJyyjiZMGu9UOXM74Egfc1dGenhJQ1GkUZrftx5b0P5sl/gPnB0LQvrb9JXMKWrMXBiemvgy1FjWUc+t9U52OiRFh8Uei4rf9rB/dz+koaFkDoObb30cOM+Mw9kzia78aMYJrcCWAmhrsAs6OJ7owGJMvlo2vPmE2aj/kijKICRaiYKp+5LMsFzFkf43V0oRFvZFuaDziDSt/MID/SFFe3NnzCEzyrT401xoq8N40VTYDE5Md7FSrZ1R38WXaVcKgDkc95bhwYFY2qZEWMsDc4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdX/rXKfwAwruVZtUUIDfJTUD3fRX0ejEaOFLblHD+U=;
 b=PjsY8xMXV7WrjMFqzk5r886nXnumeXrRJ4C/MpLByea878Nf++5k4TIx7O+xT5AtNwMXrp0qQSR79Bx8yOU3VN8H5+9mogp34YDMEyfBoxI9VMGNyGnamSiGQFA9kC1m4FP+2Ldn9ZuI6MfVTS9XDro0/LExPXGO7wHvJ/Ykb/D0eP2Dh5Jm1aQD2luTnl1fNY/5riKF187RA8kP1umlF7kVWyp2/sC2/VdG2U+o97pOaEa3FBssrHojH3WgTHEcuNs9QoyuGpH3yrLqe0raeVrz8Jh3M6uMZ4ri1lxzBJdkAXT5VEOKNFeO+rDmVCZY+wvOYQt+ADTEqrNPX9DT/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdX/rXKfwAwruVZtUUIDfJTUD3fRX0ejEaOFLblHD+U=;
 b=YvDG8AV0bZVbNq45Hy6lH26KU7yRw97jpzzo6ANhCKhxxjj3qyODqqNBfWloXcuPlbIojFE/vXAGN2ylBlWgcy8T6we3pdyNxOYdymt/94QCg+Vh/hJfgEyXUBsnXNf7dPEtmqYA8I7tecnE5s/q5ggdw+IApJghAuVJ0ipMdDo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5904.eurprd05.prod.outlook.com (20.178.127.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 02:30:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 02:30:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring access.
Thread-Topic: [PATCH] page_pool: use irqsave/irqrestore to protect ring
 access.
Thread-Index: AQHV9kvf9xbvvfqL9UebbKngICNOR6hBAJ0AgAAaiIA=
Date:   Tue, 10 Mar 2020 02:30:34 +0000
Message-ID: <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
         <20200309.175534.1029399234531592179.davem@davemloft.net>
In-Reply-To: <20200309.175534.1029399234531592179.davem@davemloft.net>
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
x-ms-office365-filtering-correlation-id: 4f63bfef-976b-46fb-ad4c-08d7c49b0334
x-ms-traffictypediagnostic: VI1PR05MB5904:
x-microsoft-antispam-prvs: <VI1PR05MB59048B89EF671FD180A13A27BEFF0@VI1PR05MB5904.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(199004)(189003)(6512007)(6486002)(4326008)(6506007)(2906002)(71200400001)(186003)(2616005)(54906003)(316002)(86362001)(478600001)(5660300002)(64756008)(66476007)(66556008)(66446008)(66946007)(26005)(81166006)(81156014)(36756003)(8936002)(8676002)(76116006)(110136005)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5904;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XJgjLrzWAAHtdAkuD/Oeo7e/ahnny9u2kBmMmxSabR58RCgyUISOqeksBo/LnuOrajjnd/e1XvV5gf2G88qTKpmlI2+nxgof/5X0H9y2qtn6GWlK8IYjGKTM+awAku6gwv9b6SjfZXdKaj0GNmVuGGpXwxFt2yT8mexbHRCDpdWhV2Yh2Z9eD5yrZUxxojdvpc7hhbiAWN/46KpFNgssHzkhTc2UNCPSd4cNQMWVmgbTEbUWSsHe5vkQlAF2RIoDw20xadyUe52cDtL7TcbG2g/SZoMSwDAGPHk2RrcOLABbr1HjnJGbaibOdcNxmUQ9JxLPTPZTvVP3juQGHe8cBHDPI2GB5EzqcJbjquzbV3X3O+zC+X5jOB6w5k3dvsHwua+nrW1M7u0q/lCevHdESTsXYiBFBd7GKCPe7zUXsq5JFItv3ufdr38niSoV6sAy
x-ms-exchange-antispam-messagedata: sqf56Gu3B4zyZpiJx646TykMeuAtf/Y9+AtYjprAlND9qlgyAgg3JqsguU4mQ3ZNOzqgdSlQGZj4Z11JveE34lWMzVj2rwVARngmtEIpVvDfexvngkVi4wXh08MRJOX2jEIO25jqttH4EHWGAif5cw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB84D3DE5ED2DC4CA671167DD775A3CB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f63bfef-976b-46fb-ad4c-08d7c49b0334
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 02:30:34.7614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: snFK4raAcPEss8lfyVe7D+JhpJ8Pmb7XG8dsRamzZfaFlB7TeY96miMe0HQ4h5241OJZpOY7fnvgBmlf3RKQxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5904
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAzLTA5IGF0IDE3OjU1IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEpvbmF0aGFuIExlbW9uIDxqb25hdGhhbi5sZW1vbkBnbWFpbC5jb20+DQo+IERhdGU6
IE1vbiwgOSBNYXIgMjAyMCAxMjo0OToyOSAtMDcwMA0KPiANCj4gPiBuZXRwb2xsIG1heSBiZSBj
YWxsZWQgZnJvbSBJUlEgY29udGV4dCwgd2hpY2ggbWF5IGFjY2VzcyB0aGUNCj4gPiBwYWdlIHBv
b2wgcmluZy4gIFRoZSBjdXJyZW50IF9iaCB2YXJpYW50cyBkbyBub3QgcHJvdmlkZSBzdWZmaWNp
ZW50DQo+ID4gcHJvdGVjdGlvbiwgc28gdXNlIGlycXNhdmUvcmVzdG9yZSBpbnN0ZWFkLg0KPiA+
IA0KPiA+IEVycm9yIG9ic2VydmVkIG9uIGEgbW9kaWZpZWQgbWx4NCBkcml2ZXIsIGJ1dCB0aGUg
Y29kZSBwYXRoIGV4aXN0cw0KPiA+IGZvciBhbnkgZHJpdmVyIHdoaWNoIGNhbGxzIHBhZ2VfcG9v
bF9yZWN5Y2xlIGZyb20gbmFwaSBwb2xsLg0KPiA+IA0KPiA+IFdBUk5JTkc6IENQVTogMzQgUElE
OiA1NTAyNDggYXQgL3JvL3NvdXJjZS9rZXJuZWwvc29mdGlycS5jOjE2MQ0KPiBfX2xvY2FsX2Jo
X2VuYWJsZV9pcCsweDM1LzB4NTANCj4gIC4uLg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvbmF0aGFu
IExlbW9uIDxqb25hdGhhbi5sZW1vbkBnbWFpbC5jb20+DQo+IA0KPiBUaGUgbmV0cG9sbCBzdHVm
ZiBhbHdheXMgbWFrZXMgdGhlIGxvY2tpbmcgbW9yZSBjb21wbGljYXRlZCB0aGFuIGl0DQo+IG5l
ZWRzDQo+IHRvIGJlLiAgSSB3b25kZXIgaWYgdGhlcmUgaXMgYW5vdGhlciB3YXkgYXJvdW5kIHRo
aXMgaXNzdWU/DQo+IA0KPiBCZWNhdXNlIElSUSBzYXZlL3Jlc3RvcmUgaXMgYSBoaWdoIGNvc3Qg
dG8gcGF5IGluIHRoaXMgY3JpdGljYWwgcGF0aC4NCg0KYSBwcmludGsgaW5zaWRlIGlycSBjb250
ZXh0IGxlYWQgdG8gdGhpcywgc28gbWF5YmUgaXQgY2FuIGJlIGF2b2lkZWQgLi4NCg0Kb3IgaW5z
dGVhZCBvZiBjaGVja2luZyBpbl9zZXJ2aW5nX3NvZnRpcnEoKSAgY2hhbmdlIHBhZ2VfcG9vbCB0
bw0KY2hlY2sgaW5faW50ZXJydXB0KCkgd2hpY2ggaXMgbW9yZSBwb3dlcmZ1bCwgdG8gYXZvaWQg
cHRyX3JpbmcgbG9ja2luZw0KYW5kIHRoZSBjb21wbGljYXRpb24gd2l0aCBuZXRwb2xsIGFsdG9n
ZXRoZXIuDQoNCkkgd29uZGVyIHdoeSBKZXNwZXIgcGlja2VkIGluX3NlcnZpbmdfc29mdGlycSgp
IGluIGZpcnN0IHBsYWNlLCB3YXMNCnRoZXJlIGEgc3BlY2lmaWMgcmVhc29uID8gb3IgaGUganVz
dCB3YW50ZWQgaXQgdG8gYmUgYXMgbGVzcyBzdHJpY3QgYXMNCnBvc3NpYmxlID8NCg0KDQoNCg0K
