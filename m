Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9582A456B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 13:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgKCMpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 07:45:04 -0500
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:53216
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727668AbgKCMpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 07:45:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UL9bKi98uGtleU+cYdOB2LllfMSX71wRbtKVCqzzdww0VPKIkr0ooHSBl3zDH6iWbNfPz4H4uj60UR3B7/Go5gmdEuA8knnAyHHi+bNBf5my/LS64s8Mo4iklah81+cdQk/mbMKpfFUbFSKmEn5h+TFgx7koy+Xl7cKAm8PTbxN4s8gLR5TRBoeCP25JqcWERnVB3zhUbCE/bUZWcksXmEUfASyinbnuMqfDJG63nx/55QfD1X+a1zvrD0bpbYV2DQitUwqcRw0woRYNULI9f76WD/ntF5nm8cl4FmScTbc5Mclf/aNU87vIJbSrWykozMUdMkvfSfWRKVsi7PTDiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmTcC3y0OrNHxjiwdlupjxSVgpEkvYTa8VEA6bd0ZmA=;
 b=UFXz6dWuPAlu2AzGF0N96/Alwl3Mx3XvZDKlvFiPOEVrF1bnge6RWOKz1n2vIKGU6khXiwZvR/NBnWQ/VT2REse3zoZzEBJ6prTYowRxPGgcJxtrBQOwD1jfM7jVqUfKRkCEb2hgUAJO8pu47NWs8h/9/T7w80jK8LxPrNNbKFxsX2q7//OEDmaKccTzogjym6ie2rXRmc4isBP8DvsFhioLXil2LsHkW3XZhaMZB5zYOQONuP1bMUDKJIiFTdC6lQLkuikYujsnzQjY3kYRUqwV6uPd3UGVINWvgAbTUIfdHJF9xjkrJppiCZ8UGsT3W/kV4THW6tmPiUotISU1uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmTcC3y0OrNHxjiwdlupjxSVgpEkvYTa8VEA6bd0ZmA=;
 b=fqqDkXWMcc83YMp7nyJTj+vTjs/74RqJ6rT6DdnpA+oKRxL/kr6eDXIqe8GgOi7ghQpAU6xpYyHbG80EaSFLr/GyDRFAdokiRxYhJyZXzTD2ONYNFD9gBjYXFaP4woCgYmcbnqs3wDIqwZwWIpvYxaCv5kXwj/qw246WAoXt54E=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0402MB3597.eurprd04.prod.outlook.com (2603:10a6:803:e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 12:44:58 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51%6]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 12:44:58 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH v2 net-next 0/3] fsl/qbman: in_interrupt() cleanup.
Thread-Topic: [PATCH v2 net-next 0/3] fsl/qbman: in_interrupt() cleanup.
Thread-Index: AQHWsKYAqHZCR49oYkaYnu880WCw3qm2W/VQ
Date:   Tue, 3 Nov 2020 12:44:58 +0000
Message-ID: <VI1PR04MB5807E42B31EFF7F9F4941E44F2110@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20201101232257.3028508-1-bigeasy@linutronix.de>
In-Reply-To: <20201101232257.3028508-1-bigeasy@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d9301244-da77-4b10-c546-08d87ff64611
x-ms-traffictypediagnostic: VI1PR0402MB3597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3597EA829EA8203EBD1FC69FF2110@VI1PR0402MB3597.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gEC8ceVpaNEfNuysyQjdfyTB2fabNKVRBs5EJT7C1ypbMnDvJusb8FuYbL50av+AGSBqKm167gz+Gl6VT5JLU07QbI8d5Gy46QQqXjGpXjP5o6mwMY11bWiuYnN3a2vFc1buXikvNHuA4Lg/ZqQdJMc5agjoAA9tzKMwrUBiTKba2z+i2tVGejivovZ3Ov3ZN2CQ4wBKVNn5CfSZ7T7HQdvWozWDoZNYyx5Ndi6isl8mtLVqjZFj0hz1NSnj0XIjbMT6oLLhrt3F5FA4NfdVuwmsg0/+SDv1u6dMkKLkrYKCP7D0wLsw2yEsD21XT62kIwBwv2AC4rEXvVbbxecZAsf7hhdK0lsVfozoklggnDy2CXr/uKSCaARwGN2fxWIRHwPV7tqNaZ+rZ/L7em989Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(2906002)(64756008)(55016002)(83380400001)(66476007)(966005)(66446008)(33656002)(9686003)(53546011)(498600001)(54906003)(110136005)(7696005)(76116006)(66946007)(8936002)(26005)(8676002)(6506007)(186003)(52536014)(5660300002)(4326008)(4744005)(71200400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cYdNUyb3BUQcTD/7246msoZNhBKKN50O49fHeeKUe+aq9tGpRCZavi8pU77LKDduOZcivEvm7rLOEFMzSOo/kFv/IXp9GIDR6pHnrYjNN+RIHpEDNY+ferTw0nQb3iX5plhCLiZ10VZaZxAXK75tyxz81gPHGmXOBT1BoOVEMtL0r90GxKDejkCn4FVKICPeXLTlxEGolKPZ2kX2GiXm6smUfP6GgL1+9+4/p7EWNi/YKms5WAWHTHg4j0F+lMZg4U8QxzLbwU7M3yFeXigWQuyf3tgxCiCBO1NWaDgtLkW7ytQ46ubaDVLiTbRMIqwQ9kcI2LqoCi0wvkKWrz0tbX1guOVy72FjaFimgx2WO066aMwt8SRVU6bllG5LQTwCRu5Jk0XFMjcKoe8Iy1WU5nKLvatXhnbF6WTBqBHzVnNOz1bcJ8XGc8aVt0Uxgbj0vyKYGUA0CGpiltseP89swOgsrVu6rQQpMynrgnwwhaeI1l22lr+0eXH9kUSZZHAuJOi/sHfzSmokkjUkGFtkM5bS0tR0gRXyXDrfgGYWTn/6uo3KWJxC6VrJLbM1gR/75fAZDqHTIOUe0CbHRefUd2q7e+zp7slEj1pbsFCKKOMHXfK1km2d/cnJHb9s/3osYuZK6HDzf63l0Q6T2OvzeA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9301244-da77-4b10-c546-08d87ff64611
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 12:44:58.5228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gNumebc/LyVqbrH+frx939fORa5CHdB7YNCNjXWavHD/CheFidW45Que78D28LqDTm0scoFOyhUZFfaC2iFKag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3597
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTZWJhc3RpYW4gQW5kcnplaiBT
aWV3aW9yIDxiaWdlYXN5QGxpbnV0cm9uaXguZGU+DQo+IFNlbnQ6IE1vbmRheSwgTm92ZW1iZXIg
MiwgMjAyMCAwMToyMw0KPiBUbzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogSG9yaWEg
R2VhbnRhIDxob3JpYS5nZWFudGFAbnhwLmNvbT47IEF5bWVuIFNnaGFpZXINCj4gPGF5bWVuLnNn
aGFpZXJAbnhwLmNvbT47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47
DQo+IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IE1hZGFsaW4gQnVjdXIN
Cj4gPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5v
cmc+OyBMZW8gTGkNCj4gPGxlb3lhbmcubGlAbnhwLmNvbT47IFRob21hcyBHbGVpeG5lciA8dGds
eEBsaW51dHJvbml4LmRlPjsgU2ViYXN0aWFuDQo+IEFuZHJ6ZWogU2lld2lvciA8YmlnZWFzeUBs
aW51dHJvbml4LmRlPg0KPiBTdWJqZWN0OiBbUEFUQ0ggdjIgbmV0LW5leHQgMC8zXSBmc2wvcWJt
YW46IGluX2ludGVycnVwdCgpIGNsZWFudXAuDQo+IA0KPiBUaGlzIGlzIHRoZSBpbl9pbnRlcnJ1
cHQoKSBjbGVhbiBmb3IgRlNMIERQQUEgZnJhbWV3b3JrIGFuZCB0aGUgdHdvDQo+IHVzZXJzLg0K
PiANCj4gVGhlIGBuYXBpJyBwYXJhbWV0ZXIgaGFzIGJlZW4gcmVuYW1lZCB0byBgc2NoZWRfbmFw
aScsIHRoZSBvdGhlciBwYXJ0cw0KPiBhcmUgc2FtZSBhcyBpbiB0aGUgcHJldmlvdXMgcG9zdCBb
MF0uDQo+IA0KPiBbMF0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYXJtLWtlcm5lbC8y
MDIwMTAyNzIyNTQ1NC4zNDkyMzUxLTEtYmlnZWFzeUBsaW51dHJvbml4LmRlLw0KPiANCj4gU2Vi
YXN0aWFuDQoNClRlc3RlZC1ieTogQ2FtZWxpYSBHcm96YSA8Y2FtZWxpYS5ncm96YUBueHAuY29t
Pg0K
