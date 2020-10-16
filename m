Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7E329025A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406440AbgJPKAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:00:37 -0400
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:27973
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406212AbgJPKAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 06:00:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5JMqn4jF47BggdMVwc61YpkYWJ7ri2P9Iw9x4duEWaJEtN3oKAUZg6xzJYjrzwlD60hZczN3/Jue9Ebp6iYB7U3y6MYxnPzX5Y9WuaXvFSDOj7rN3YzAVdF8BMtiHulag8JO25C18QEDZ2KCG6AUQkUHRlUEqbIjhzTRr81v27ZesVmjns52c7anN7eq2IX6RUNZR3pMYnNPkFEkeRjaZKnw9zgJ2dMycw4pcqqlI2FLE+aF8CPjZNbPBJuLRRMGZa6fRGIv1lqiRDTy4Bacgj8gTEA97MC7PSan5Y4j8cMucSlcpaPtoE5sVlhW8enf7YwhxH009uVv20SE7mbyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/B/u6vsPwsmlZIjTOG412IkKTip8zAmAKkNp6jxFKTE=;
 b=HHe54LyWutJ0GJBRkE63MSw3+0yiWXaxytVewv6gWWDvXWNKadkdBYj385qnshffgm4n55vlZBuMC9QJTzR1E9Dwk6nwvtN4q2pYBjmCngFd/G8GDVeCJ5eaIRGp50iZPcf772OGyxlQFtuxHh8N0ZZQ3IS4bLgto+ASh+euZEYS2WLH5nZ1S17UnD7N/SZLUAQeBN+Oetw92xBaSoNWaMTqjBS17lcM+cNg1RSWRffRxxDBTz1Oegikr4+/mjuvQhtYqDE0NBoH28kZXuHfQAyaBzmCv2U0zjsBO7PZuWCWGx9QR9m7ELm97Mb2zqIMPHJaTw7rubiUtqu85qYosg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/B/u6vsPwsmlZIjTOG412IkKTip8zAmAKkNp6jxFKTE=;
 b=cl0UB63lCgsG9aLCR1l5JkOvyhxQZosxx/2p0VOogU0R8Rtz2+X0SotRumgMcMIRa69W38tDNZhsPIKBypELEX1CagzdsRPJsNHWPWbLTJz3SMgEiKNGaOHMg9NQZANwI5xzUXzzCJemUKAEl27TO3kNjv3yMTe+pIrJgl/bWeQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3962.eurprd04.prod.outlook.com (2603:10a6:5:1a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Fri, 16 Oct
 2020 10:00:31 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 10:00:31 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/6] can: flexcan: add CAN wakeup function for i.MX8QM
Thread-Topic: [PATCH 5/6] can: flexcan: add CAN wakeup function for i.MX8QM
Thread-Index: AQHWo39An99v7VNKtkiYHjTJFb8gxqmZwW4AgAAFs9CAADP4sA==
Date:   Fri, 16 Oct 2020 10:00:31 +0000
Message-ID: <DB8PR04MB67952A058934D5013946EE97E6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
 <20201016134320.20321-6-qiangqing.zhang@nxp.com>
 <0e3f5abc-6baf-53e2-959b-793dfd41c17b@pengutronix.de>
 <DB8PR04MB6795DEDFA271889A162539EFE6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795DEDFA271889A162539EFE6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c4f9776c-ac40-4d28-2a86-08d871ba517a
x-ms-traffictypediagnostic: DB7PR04MB3962:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB3962DD15C234E8C2A3B73F87E6030@DB7PR04MB3962.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fprz7A0tvGIlxrj0Esyzd7E8Sxtyx2qYVNZuftObJNaRUlkxx4XrsqTN4RemkHM4o0+aFxfawdcuaBmyS2oX1Uo1lh4aStfK66QeNFFDdK+zvFjfNHob5UTK4Rw3jJ5mQgbjtnB3zYUFOHcquXRNVK+ZzbyEDfM/gvBr9I5PBiVKD/Mh6il2KrCJW+Dhjl8XsqxntMnvrZYVG74fduFnqLVv0lRUGQdTyGqegUawxI1oXlc6AqZaDMvEYTbPItvyMIEzEhv0hIOGfmLdv8H3BFa258DUdYxOgTxp/HAyBa4sCIOsl8kfTgsgYodpwzsU7P3wjN4yPjWXGWopLX4yBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(2906002)(5660300002)(83380400001)(7696005)(6506007)(4744005)(4326008)(8936002)(33656002)(8676002)(186003)(26005)(478600001)(54906003)(316002)(110136005)(2940100002)(66446008)(66476007)(66556008)(71200400001)(64756008)(76116006)(86362001)(66946007)(9686003)(55016002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /PnbYZpBgYrIkDunHfywIh3OSF3w2ty8ozGrM4mA6y/MEtpM11L4wyUYK9+XemlR0dAjuTcjTdo3eFI0IlN0JV8SpmFtT33HIsAX0gGkqput6011y0ORqlcPaNFPsMS/EyzZFsuoh+dnVUzPUUKdUVS4zOpf+5ZbOuYubVN2XJiYGdB3IQ2jxF+SFTcR+CVxcOB9eJVwpE+D4AmDQ9gZzoOiEX2eE9MGbEGJkYCRrbzYvY20QEY9RXvF98vWBCLU9Md/pfS5XG9x1vpsrlvb4jj0qWoB2rFymTAwgxy52P1lLtJ+ZiBTTFFt1uAQ4zsEPajQe3bOgV5c/JsDTugdT1OquEvKO5GDoIQB05GGXFCJPSXhYgqGHzOFLNrdKXhKapiXbG+YenSPRJZNzYQx2OfTsrpDWj8csvaVI1y4okA0ILR+/0Mju1TdNlXP2QW3VcxIM2rcc98wcd+y1IpteRTmFJYigcvNp25QooBrNpIdNy2VSJ4EcehDvXHp1kAAbNDWClUX8o0P8r8dTpr6nfmR6yWFKIYoWidVkJ0RHcboi5W8u5Qb0sWOHXJJSU8p6XLjY7YW11gExoKz5KLCwfeE0Q9Lq7dRpmXMCZkWLg/yxxR5p2DXkVZS5QxfQrQlWeaiQ/K/CQmKd/Q52mlfYw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f9776c-ac40-4d28-2a86-08d871ba517a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 10:00:31.6586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8RLKMwA3xUuSijg60flb4No0NWfJieht/hLuP1hCufqEppuPKD219nOHzyUF4bl5vFq3+t7uD7Uw/3r8CF9FXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3962
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQpbLi4uXQ0KPiA+ID4gK3N0YXRpYyBpbnQgZmxleGNhbl9zdG9wX21vZGVf
ZW5hYmxlX3NjZncoc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiwNCj4gPiA+ICtib29sIGVuYWJs
ZWQpIHsNCj4gPiA+ICsJdTggaWR4ID0gcHJpdi0+Y2FuX2lkeDsNCj4gPiA+ICsJdTMyIHJzcmNf
aWQsIHZhbDsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKGlkeCA9PSAwKQ0KPiA+ID4gKwkJcnNyY19p
ZCA9IElNWF9TQ19SX0NBTl8wOw0KPiA+ID4gKwllbHNlIGlmIChpZHggPT0gMSkNCj4gPiA+ICsJ
CXJzcmNfaWQgPSBJTVhfU0NfUl9DQU5fMTsNCj4gPiA+ICsJZWxzZQ0KPiA+ID4gKwkJcnNyY19p
ZCA9IElNWF9TQ19SX0NBTl8yOw0KPiA+DQo+ID4gQ2FuIHlvdSBpbnRyb2R1Y2Ugc29tZXRoaW5n
IGxpa2UgYW5kIG1ha2UgdXNlIG9mIGl0Og0KPiA+DQo+ID4gI2RlZmluZSBJTVhfU0NfUl9DQU4o
eCkJCQkoMTA1ICsgKHgpKQ0KPiBPSy4NCg0KSSB0aG91Z2h0IGl0IG92ZXIgYWdhaW4sIGZyb20g
bXkgcG9pbnQgb2YgdmlldywgdXNlIG1hY3JvIGhlcmUgZGlyZWN0bHkgY291bGQgYmUgbW9yZSBp
bnR1aXRpdmUsIGFuZCBjYW4gYWNoaWV2ZSBhIGRpcmVjdCBqdW1wLg0KSWYgY2hhbmdlIHRvIGFi
b3ZlIHdyYXBwZXIsIG9uIHRoZSBjb250cmFyeSBtYWtlIGNvbmZ1c2lvbiwgYW5kIGdlbmVyYXRl
IHRoZSBtYWdpYyBudW1iZXIgMTA1LiDimLkNCg0KPiA+ID4gKw0KPiA+ID4gKwlpZiAoZW5hYmxl
ZCkNCj4gPiA+ICsJCXZhbCA9IDE7DQo+ID4gPiArCWVsc2UNCj4gPiA+ICsJCXZhbCA9IDA7DQo+
ID4gPiArDQo+ID4gPiArCS8qIHN0b3AgbW9kZSByZXF1ZXN0IHZpYSBzY3UgZmlybXdhcmUgKi8N
Cj4gPiA+ICsJcmV0dXJuIGlteF9zY19taXNjX3NldF9jb250cm9sKHByaXYtPnNjX2lwY19oYW5k
bGUsIHJzcmNfaWQsDQo+ID4gPiArSU1YX1NDX0NfSVBHX1NUT1AsIHZhbCk7IH0NCg0KV2Ugc3Rp
bGwgbmVlZCB1c2UgSU1YX1NDX0NfSVBHX1NUT1AsIHdoeSBub3QgYmUgY29uc2lzdGVudD8NCg0K
QmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo=
