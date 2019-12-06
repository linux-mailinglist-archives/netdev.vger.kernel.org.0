Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEA2114CEA
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 08:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfLFHwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 02:52:30 -0500
Received: from mail-eopbgr00047.outbound.protection.outlook.com ([40.107.0.47]:9347
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726642AbfLFHw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 02:52:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTWSivkBfGCept3R2dvtvIzJyo1cmE81JTFFCcaCziSGygaNKLljJ2QSLTuGg3eAZVlSV5dX6lBG+kJoRaOO5voSvNiFm4a/muLr/qB3JdRnDOXlxJnnqj5zUSAmm/IZY/NvMnR56LMPTPk8IsDEds/kR1eJKCx3Klzd17ywEy8KNiAuI4tfO7c1HAgIAEOY0jpVqmDmtHwEUtC8iHMf2XtsIJxsEnkfarU0/gXnItpViko7vekjzfj2u1UK0mQA3UqkaD+fC1l4hcbFrp9zgzPATpRgqolU+Av4Zxd+fsg8orx96dUN7QN/k3Cq/jedlA0nn5PZaNZDKKONhhMhVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVEpKG8puljaqTCN4/V2TScUTZDB7X/mcZPg4SdNbtc=;
 b=HFSBim6NE5WdIdEup3eiaE8FzFXDEIwEmd5kgbmKOOh5yXOszVYFOjWqnrST/tZ9IVq4cR3QqGL4ET2gRDXNNPpYTJdLfRe/QTEWJtvAlUj8yfIuB3lusrei6d+5/+6wxNGqmftfOZRWatC7zl2TH9XHJuIN3UbGaLCDAkKFV9suX2eYsM5Q2ahQeb2gZ9ulIvrgLkH+2b5fperr4TMPhebOYWxG/4goOhu7Pmw1lqq12ZIm2+KtJYcbOgE+2ifbikUpcXSLt2vABemNFk/eBo4/wpaQniHCDJ0JPFikJBbYavaTdIBrRgPdyLmDLCTNFszlKwkFpK2dHy8Fp13+RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVEpKG8puljaqTCN4/V2TScUTZDB7X/mcZPg4SdNbtc=;
 b=bIGlEARiPeAIQc4X9XVJjHJWVPiBzsguXX3RXBRh14s9ZQdSW7BowQzdb/+J9UisNopHZF1v2+i5Sd/3shtTwCbz6ifjDlroyTSM4J4Oo80JdViW20t51fVUgNjDP8PeH/x1RiP6CS/6C4ad3R9wmsAZVNmwft93gkAGaVPlKRM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4155.eurprd04.prod.outlook.com (52.134.108.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Fri, 6 Dec 2019 07:52:24 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.017; Fri, 6 Dec 2019
 07:52:23 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V3 0/6] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V3 0/6] can: flexcan: fixes for stop mode
Thread-Index: AQHVqpcC9+9ZZuOr5E+r+rwXW/eLZKesvbgQ
Date:   Fri, 6 Dec 2019 07:52:23 +0000
Message-ID: <DB7PR04MB4618D19B51F80DDE74BEA3CAE65F0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191204113249.3381-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191204113249.3381-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0654e4c9-0d16-4b76-9634-08d77a213b15
x-ms-traffictypediagnostic: DB7PR04MB4155:|DB7PR04MB4155:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB41550A7BA1A23A95B1DAE01CE65F0@DB7PR04MB4155.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(13464003)(189003)(199004)(7696005)(99286004)(25786009)(11346002)(76176011)(110136005)(54906003)(186003)(316002)(4326008)(478600001)(6506007)(71190400001)(53546011)(102836004)(14454004)(81156014)(26005)(71200400001)(86362001)(76116006)(66946007)(64756008)(66476007)(66556008)(66446008)(33656002)(74316002)(8936002)(52536014)(5660300002)(229853002)(9686003)(2906002)(8676002)(305945005)(81166006)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4155;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c1QEGC7iH5bY1qEoLKx24BKEhTWhrBbTHC5I2c30bxKNc/lTPffV2298cW17aBiy5rmwfGjIfGuTujhhCdKoBndfE9v3uo3Qibn+/3KNGWYVK6Pu04PSQAjHB7IEKL2r5rDkQtyR+4jM+9CBDL4CQDI9eqQLno2Fvcc7l/WorTZJnvWQZBtkxRF/t5+gqQV0CC5sWpffIv+UkdhlPABVYh05bT8KBuMirp/JASYkjr+k2EwPRoUuSb300sJ8Mq+V15wD2wJ4dtLg9Smt7L8RaC0rsCFR1Q/4hHW2ManREmvqjW2fSVM683MgcFedARi+MgPLV7/nkB0SZC0PZWM/qRpA0E9jUCG3adgAcD2BbqyV6/JtneR5+8iaMSB89/39YY4fhpp3kB3JO2YzFtcmrWr/5vH8Q/aGutti+Fk93qpT77vik/xCLdMgxFLa6Zwy2NBljX3qyh0W07a6yuINlZWajDPxPSpvlCp+TyALPROYM1aJDBFgbQhcCc5kk3aC
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0654e4c9-0d16-4b76-9634-08d77a213b15
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 07:52:23.9544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UVsppLxPBf7sfBzYmITEGCvpbaqt5Tq+gfDTvxExfefgS5dZiy+q91lSlb22p9EhuXIckKfw8tQByK1kHCbogw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMTnE6jEy1MI0yNUgMTk6MzYNCj4gVG86
IG1rbEBwZW5ndXRyb25peC5kZTsgc2VhbkBnZWFuaXguY29tOyBsaW51eC1jYW5Admdlci5rZXJu
ZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgSm9ha2ltIFpoYW5nDQo+IDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4N
Cj4gU3ViamVjdDogW1BBVENIIFYzIDAvNl0gY2FuOiBmbGV4Y2FuOiBmaXhlcyBmb3Igc3RvcCBt
b2RlDQo+IA0KPiBIaSBNYXJjLA0KPiANCj4gICAgSSByZW1vdmVkIHRoZSBwYXRjaCAoY2FuOiBm
bGV4Y2FuOiB0cnkgdG8gZXhpdCBzdG9wIG1vZGUgZHVyaW5nIHByb2JlIHN0YWdlKQ0KPiBvdXQg
b2YgdGhpcyBwYXRjaCBzZXQgZm9yIG5vdy4gVGhpcyBwYXRjaCBzaG91bGQgZnVydGhlciBkaXNj
dXNzIHdpdGggU2VhbiBhbmQgSQ0KPiB3aWxsIHByZXBhcmUgaXQgYWNjb3JkaW5nIHRvIGZpbmFs
IGNvbmNsdXNpb24uIFRoYW5rcy4NCg0KSGkgTWFyYywNCg0KQWZ0ZXIgZGlzY3Vzc2VkIHdpdGgg
U2VhbiwgQ0FOLUlQIHN0dWNrIGluIHN0b3AgbW9kZSBkaXNhcHBlYXJlZCB3aXRoIHBhdGNoKGNh
bjogZmxleGNhbjogZml4IGRlYWRsb2NrIHdoZW4gdXNpbmcgc2VsZiB3YWtldXApLCBzbyBJIHRo
aW5rIHdlIGRvbid0IG5lZWQNCmFub3RoZXIgcGF0Y2ggdG8gZml4IHRoZSBzYW1lIGlzc3VlLiBC
dXQgdGhpcyBmaXggcGF0Y2ggaGFkIGJldHRlciBnbyB0byBzdGFibGUgdHJlZS4NCg0KQW55IGNv
bW1lbnRzIGFib3V0IHRoaXMgcGF0Y2ggc2V0Pw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhh
bmcNCj4gUmVnYXJkcywNCj4gSm9ha2ltIFpoYW5nDQo+IA0KPiBKb2FraW0gWmhhbmcgKDUpOg0K
PiAgIGNhbjogZmxleGNhbjogQWNrIHdha2V1cCBpbnRlcnJ1cHQgc2VwYXJhdGVseQ0KPiAgIGNh
bjogZmxleGNhbjogYWRkIGxvdyBwb3dlciBlbnRlci9leGl0IGFja25vd2xlZGdtZW50IGhlbHBl
cg0KPiAgIGNhbjogZmxleGNhbjogY2hhbmdlIHRoZSB3YXkgb2Ygc3RvcCBtb2RlIGFja25vd2xl
ZGdtZW50DQo+ICAgY2FuOiBmbGV4Y2FuOiBwcm9wYWdhdGUgZXJyb3IgdmFsdWUgb2YgZmxleGNh
bl9jaGlwX3N0b3AoKQ0KPiAgIGNhbjogZmxleGNhbjogYWRkIExQU1IgbW9kZSBzdXBwb3J0DQo+
IA0KPiBTZWFuIE55ZWtqYWVyICgxKToNCj4gICBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3
aGVuIHVzaW5nIHNlbGYgd2FrZXVwDQo+IA0KPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyB8
IDEzMSArKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDc5IGluc2VydGlvbnMoKyksIDUyIGRlbGV0aW9ucygtKQ0KPiANCj4gLS0NCj4gMi4x
Ny4xDQoNCg==
