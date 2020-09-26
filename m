Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC94A279C6E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 22:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIZUty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 16:49:54 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:47008
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726311AbgIZUtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 16:49:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdlDaNgCqCbMVAR45rxsgWJQfdHuBHPLhKjg/LM/3tvR+ztYXMdEz4/Ik5mmeA3oqMrXj1V1TG/BH1HCJQLyr8Ia9zLiEqS/LnC7YdyafxBDfoiH4LP2c1dtzDdzDjecj7av4jm7NYjt8+kWr14Tek8DI97FnYZH0miQHG9m2sEk3r8XGjvOXHUHy5H4r3jpq+nSgOmEsjoWuY2Yd/xAM5tP4PjJ/HearC3eBU77Of9B19NCOZz53039Iayv3uwVa2Jug9iJwweJVqUiEJOsOi3zoX1OtSsgpVJTLYClcIP1lV1Pn/imRBpJbNXGurEQ3utb55xSao47i5xyjMd9NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JRT8Qxb84sfGD7chQzTGP8PrQOc1ke271zV9ul7UDc=;
 b=hqJlG9MFe0+5d+BLI6kMlt+J3QMDjMS4rLwn1fPIsMcstO6cLwbF7TxtoMyu9E7V7RDm5+cpDTDLT+fykbaLkiAf5aGAFaotRhIl4MCgWIg2LIhnY+n0P1zfSlaSLAFglveNj1RqPERaLQOB0F3nxLNzrNEyIF6d5jEhLH75WWYgPc/46g5WExco+PVmhmPxHnD9ou9r7b2xbaGOSu5PiAgO1e0wNF9tUO32fOfxI7bXoeggNTq+LtFjTKrkTkzjwITrVLLwHSjJ8rn9n9CE6OUtyKL23EZWuPhHdfbEdicu1NcoE06YYjwPxIHMyziE3fDu8gQ3mztdllzqaBhRmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JRT8Qxb84sfGD7chQzTGP8PrQOc1ke271zV9ul7UDc=;
 b=bJKAGIAJNtudwLuzfCCzJSLqIj4hKcOSOHVFAXT6/oeaUlALMRMk+CeNEp0cRHq1ufa1xjxaNcUpKj1+smyOoIv2RszShbhH06hS3aPPL4aMAOWpw0Hbs3RrrkQ40S/bRoehBN7G3kR+lD4HU6m6EkFt7QL2zMR3mUQhQPEHcIs=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM7PR04MB6887.eurprd04.prod.outlook.com (2603:10a6:20b:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Sat, 26 Sep
 2020 20:49:49 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226%4]) with mapi id 15.20.3412.028; Sat, 26 Sep 2020
 20:49:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH v3 net-next 06/15] net: dsa: add a generic procedure for
 the flow dissector
Thread-Topic: [PATCH v3 net-next 06/15] net: dsa: add a generic procedure for
 the flow dissector
Thread-Index: AQHWlDvaJb5CrrbqDUi8J9FFhi8if6l7X/sAgAAEsgA=
Date:   Sat, 26 Sep 2020 20:49:49 +0000
Message-ID: <20200926204948.zu6zvj2yqrv4733t@skbuf>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
 <20200926193215.1405730-7-vladimir.oltean@nxp.com>
 <20200926203300.GE3887691@lunn.ch>
In-Reply-To: <20200926203300.GE3887691@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 210c15db-4e46-4e0e-4111-08d8625db5e0
x-ms-traffictypediagnostic: AM7PR04MB6887:
x-microsoft-antispam-prvs: <AM7PR04MB68870A83F5F1A056788CB62FE0370@AM7PR04MB6887.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zn3/SLgkvOrCFNbOJYgj4G3j56z2lRHRR3pNCd7nQFcKOFXD1m3+tKSoqzIIIWIqnWm/T/PSU4sXFUWQTTxniVKXGXjz9JgF44urkhZF5IZdhmhXKfrx2ZDcnbtPYbikRwfV2Vb2a/bxnNJgBPrKZmVE1neXn3fwkLQweqxSdL8ApZCW+Tws2y7Jr55IIOfiqCptDALRNytQjVz6STHj+jHFCPW3xa+wknagdy0G+KGykam4qSldqVmVK/8PWUrkSaVte2gjYyGks3xnBRwZRAUmx6rkSMDmdVTIiGus9DuVK9X2qaqN0dexqJ0t/ZQ9OTooASLJpIzhwvKh9+oXljv5a0w/RUqpjndgbXNPJQoLnqBgo07ZEqvuM8Oi/d1KBQABQL2zghS30GKelNE1KhZsHZYNyxEIA4uPIDxRGwM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(396003)(366004)(346002)(136003)(376002)(6506007)(86362001)(478600001)(54906003)(186003)(4326008)(26005)(8676002)(6512007)(9686003)(44832011)(2906002)(8936002)(66946007)(76116006)(91956017)(66446008)(64756008)(66556008)(66476007)(71200400001)(6916009)(316002)(6486002)(4744005)(5660300002)(33716001)(1076003)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qey//xuh5sEdM95ywZ0V3Qk0/8xBjJv0QnTSnMwyApZTw59f5qJ31aMYIxNai+hyTLwMp2E52w1Jg3HoPFAaMfQYqo0FJzrSZvtSNlPeOWk2hUbaj2QX7+7JX1vKxWcYekR5MkugKAfAkWNuNiVR3YjU9oUFF9Vk4ztfkxFOwzLTs8p22Ro9BOZ0c185zLhuua/InfLx1ZTzx/Tacoksdb8AwLFRVyPtzasvOrs19ZHRtOHR3xVYq+px+Q9WCOcxUBjWgkIaHg76AonUb3/SvBrXUBZgOmo5qWbGKZQIzqCOIoeWMLp0m0N4iExDwSnKcAGq6Y8YusUlpirTXabKYQIfzdylO0WHK6bF/NjwwLgzlDlaGEBLN21pEWNCjtT9JdqVIuSyZfXs1O3H0MNy9mGKEa95V0bbCFVo61Hr7CnzTbvbZ2EyDrn6erIXyJeqB7nvmC/Cb5DTS34JWRBluCJ8krES7RA+CxTxOoxapE7Ij4wHjGomT5YOIzogTkk5GWIBetDN2VUiGwvtOIaDnBOknglA8T0UfcqVnGKrUZy7ZVvCOMmHKseooSW4E5vDqef0Hm7fCvm+jzXUtqTYY72tr/+PfaNVSzY/kkvcaBNHt7HAkZimMXRCBvz69l/v0pA9jCq6aCrid1+oKVPTgw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D331010A839204AB3694D7FF4BA19B4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 210c15db-4e46-4e0e-4111-08d8625db5e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2020 20:49:49.4529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X53Wut6qZjRC2AH6Kqlanfe1jGx2JRKKHDKp41pp3b2O1QjVDnV8z48ThgFx/PTy7gMr+7Lzi8smwAzo/CW7tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6887
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBTZXAgMjYsIDIwMjAgYXQgMTA6MzM6MDBQTSArMDIwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+ID4gK3N0YXRpYyBpbmxpbmUgdm9pZCBkc2FfdGFnX2dlbmVyaWNfZmxvd19kaXNzZWN0
KGNvbnN0IHN0cnVjdCBza19idWZmICpza2IsDQo+ID4gKwkJCQkJCV9fYmUxNiAqcHJvdG8sIGlu
dCAqb2Zmc2V0KQ0KPiA+ICt7DQo+ID4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19ORVRfRFNBKQ0K
PiA+ICsJY29uc3Qgc3RydWN0IGRzYV9kZXZpY2Vfb3BzICpvcHMgPSBza2ItPmRldi0+ZHNhX3B0
ci0+dGFnX29wczsNCj4gPiArCWludCB0YWdfbGVuID0gb3BzLT5vdmVyaGVhZDsNCj4gPiArDQo+
ID4gKwkqb2Zmc2V0ID0gdGFnX2xlbjsNCj4gPiArCSpwcm90byA9ICgoX19iZTE2ICopc2tiLT5k
YXRhKVsodGFnX2xlbiAvIDIpIC0gMV07DQo+ID4gKyNlbmRpZg0KPiA+ICt9DQo+ID4gKw0KPg0K
PiBEbyB5b3UgYWN0dWFsbHkgbmVlZCB0aGUgSVNfRU5BQkxFRCgpPyBUaGVyZSBpcyBvbmx5IG9u
ZSBjYWxsZXIgb2YNCj4gdGhpcyBmdW5jdGlvbiwgYW5kIGl0IGlzIGFscmVhZHkgcHJvdGVjdGVk
IGJ5DQo+IElTX0VOQUJMRUQoQ09ORklHX05FVF9EU0EpLiBTbyBpIGRvbid0IHRoaW5rIGl0IGFk
ZHMgYW55dGhpbmcuDQoNCkl0IGRvZXNuJ3QgbWF0dGVyIGhvdyBtYW55IGNhbGxlcnMgaXQgaGFz
LCBpdCBkb2Vzbid0IGNvbXBpbGUgd2hlbg0KTkVUX0RTQT1uOg0KDQouL2luY2x1ZGUvbmV0L2Rz
YS5oOiBJbiBmdW5jdGlvbiDigJhkc2FfdGFnX2dlbmVyaWNfZmxvd19kaXNzZWN04oCZOg0KLi9p
bmNsdWRlL25ldC9kc2EuaDo3MzI6NDc6IGVycm9yOiDigJhzdHJ1Y3QgbmV0X2RldmljZeKAmSBo
YXMgbm8gbWVtYmVyIG5hbWVkIOKAmGRzYV9wdHLigJk7IGRpZCB5b3UgbWVhbiDigJhpcF9wdHLi
gJk/DQogIGNvbnN0IHN0cnVjdCBkc2FfZGV2aWNlX29wcyAqb3BzID0gc2tiLT5kZXYtPmRzYV9w
dHItPnRhZ19vcHM7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF5+fn5+fn4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaXBfcHRy
