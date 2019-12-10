Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D4C11819E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLJH7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:59:05 -0500
Received: from mail-eopbgr40076.outbound.protection.outlook.com ([40.107.4.76]:17634
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbfLJH7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 02:59:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmfMxsJhOMiSuRot9hdx6jBY/ch6nG99kSAOccG3x9qDn9WnLGT/v1ZmcKzxrLtNrP0HczU77IjX0bKqcq7bYPZ4bpQZXc3RxIRgmqP1KUc68yR1xVaZyd+I8Mq6gFOYom29JgamCmR8XihS+zPYxU+ULjo9LaU0Cg8wMMngkYg0ISNVOHZ8BckTJyniFW3GvHnQEHqRkHh4nMpm62de2h47irveKpdrs5kPVZnVMg/v68g01g4RRCpD+PpIZqEIQtXTqp0qI7dX2gs2ivBWen91dW7AkFmJp+iAy7TWuACz30U2InNU78GWMU8N27CLXE4y92XLk9it1VgrcB7jeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cY0kBCE3SZe4naaIzwzp8Ln/uGpU0te54SQbA7plsb8=;
 b=K2vaPTo6mQu/5lGV2sJCWKx5RU+3HBFroALKA2ollxp/DvfOp2j5/Mwue8oIuTLSXbbCD1EeMkSwV9SUBXJt+Fh5u0qDkHqeVHbx1ZiDjTelDIHlud0LR9IsIWu0rYp3VEE9B7QSFa53wh2Rt0LnYc5IDENVyPeUfZTDH9v0voLbRLT/xacWRX/ddYMX3Ovu64Gju54ly/934KCak3GW+6JAhfROs8CZb3YISNPZSS+BDDw5Aceel+IDIojOEd3c+DwzMC8wtFw3idqBI+Y2btx5TPIJooOws7OYgOhVL7u9mue/UPtJwVywd5Q3f/QKLuaecAEyEm2wtcGfYDvFKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cY0kBCE3SZe4naaIzwzp8Ln/uGpU0te54SQbA7plsb8=;
 b=IkobJzI9DPoD3Wm1WTEn+yltDlfe32f+vSzxqgmJtyxsWs/MKBKX4XRj+7zdD0rKoHuGjltdNuzmzrf1kb+tjwYOGyCLNWN1iW7nTHBchP/ZddRIwOGmPCtLP9Zr635Ow9V3GnDy2hu5TDWbgF8Ag1lK+Vyp79vBVHqzfmP6fzI=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4107.eurprd04.prod.outlook.com (52.134.110.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Tue, 10 Dec 2019 07:58:57 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 07:58:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] can: flexcan: disable clocks during stop mode
Thread-Topic: [PATCH 2/2] can: flexcan: disable clocks during stop mode
Thread-Index: AQHVrymtB+TSUJwNhE6xk7ucZQ3eC6ey+7UAgAAE9aA=
Date:   Tue, 10 Dec 2019 07:58:57 +0000
Message-ID: <DB7PR04MB4618C7286138CDE490AEBE3BE65B0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191210071252.26165-1-qiangqing.zhang@nxp.com>
 <20191210071252.26165-2-qiangqing.zhang@nxp.com>
 <0035862d-f202-4a54-0ca0-92bec5dc7063@geanix.com>
In-Reply-To: <0035862d-f202-4a54-0ca0-92bec5dc7063@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 704dce11-455f-4b43-b82e-08d77d46cf7d
x-ms-traffictypediagnostic: DB7PR04MB4107:|DB7PR04MB4107:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB41075BA57B8A17744750BEE3E65B0@DB7PR04MB4107.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:298;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(13464003)(199004)(189003)(86362001)(53546011)(110136005)(33656002)(316002)(7696005)(52536014)(8676002)(71190400001)(55016002)(54906003)(186003)(9686003)(71200400001)(81156014)(81166006)(66446008)(305945005)(6506007)(26005)(4744005)(66556008)(4326008)(64756008)(66476007)(8936002)(5660300002)(2906002)(76116006)(66946007)(478600001)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4107;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X1mALjtcxZgCmSxdJQGl2qEGKFYy9B181iny9shx94OtDM63P3nIrOUZvdVVOaeF2aJtBEthLg/e/ZbWGtdJekAIYJ7J+ESlnih4+zD1FpCluUFLE35zkG6ttctJd0dDmmdS9IHT8/N2revbGjWVB7gtPlxXA7CedPtHClT5CX48uWwSt8sx9NmI7q3bZTqbahBohYcwd7TU4F9Z3dc7xJq1elkEF2rql0UqMRstHldz0bvMBx3jsLvL4NrzcwWsnSBTy9Nc4Sd5ipNgjmHPz2R2P3ecpFtDQ8nve3sNkjAS8YYCU6l4cGrSI+Ntq4eQijcg77GrTdERZcmky0b1ExX8HAHoR642bfLN6a18hbB1urOJBWEvRDLOcdEhIx8rRs5b5Tz4ZhY3mZY/d7zh57oiWFQJ/9dhqbjrW9Qk5w1MuHrU0nz24P9ET8c0LF8E5Z7Bsh+4Ph9QHJZTIqGv84Y6CRnulWRM8n8/p3+6nnkXzRhw//quUoWXV5ItGFAi
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704dce11-455f-4b43-b82e-08d77d46cf7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 07:58:57.8270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqRPF6yqHa1m0xWScP7aQbN984lQtAsJsaCXI1E95lnjmGL2X4AybCQpZBKTEdC8LxaBg2AM8ALjxlRBbBhUDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDEy5pyIMTDml6UgMTU6NDANCj4gVG86IEpv
YWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGU7
DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgt
aW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggMi8yXSBjYW46IGZsZXhjYW46IGRpc2FibGUgY2xvY2tzIGR1cmluZyBzdG9wIG1vZGUNCj4g
DQo+IA0KPiANCj4gT24gMTAvMTIvMjAxOSAwOC4xNiwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+
IERpc2FibGUgY2xvY2tzIGR1cmluZyBDQU4gaW4gc3RvcCBtb2RlLg0KPiA+DQo+IA0KPiBIaSBK
b2FraW0NCj4gDQo+IEkgaG9wZSBJIGNhbiBnZXQgdGltZSB0byB0ZXN0IHRoaXMgcGF0Y2hzZXQg
ZHVyaW5nIHRoaXMgd2VlayA6LSkNCg0KSGkgU2VhbiwNCg0KWW91IGFyZSByZWFsbHkga2luZCA6
LSksIHRoYW5rIHlvdSB2ZXJ5IG11Y2ghDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
PiAvU2Vhbg0K
