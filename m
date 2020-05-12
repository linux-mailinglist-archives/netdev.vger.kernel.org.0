Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98CE1CECF4
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 08:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgELGVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 02:21:48 -0400
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:17991
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbgELGVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 02:21:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJZYXqPAuIMOmbn9PJztlBePiuL//AI+v4i7/RpyNWgdUvMWZZMHVksTdJZI23MJQhLek2R7CLBHEjeMM7RPfWwI4nBbYLjrx4T6AbmYOBXx/O3wr/ecfy7/QSHvkHkq0v//o7UfUyk/cB4HbOd+g1vj9dmm8QXeBxaiDw3UGKBEisRzy7zdbfQCXdR1iknO02KNQwQGOffFh7Td31ff52B+GSTy4Ve/Bfaaz3s4d12g96P0P0UX15BX/9K+VbHeG+LSrTfZtWjdcnRAERv/InFrbkdhPXjhaYceHDsjLKrAFZkEQxm+T2sLAuz6q/eu+CaRglENi7Afn2HE79W7eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sY4CjL0ZoD2QW6Fj7smXlVexnWC/ZdoLnl4Tr04HNRg=;
 b=lRnGH1ErHmYu1eu2OzAEjCWpE1GzZD87E2lB7lWPsb7/pg13u4Pl1oVemvvIVHaoLFLkeQMjY4KEueTPiZas3sRu/W+xQMDDAfLo0qAcNA2iJfWRr8wGs8tyHcMEVe3G0J+a8JAPG6e8uM17SrU4HuTVPNgKqHbjsZQa5NJ+ujlQzFm0hdVzkDza3Jam7BOGjACnZeauOggHt2W5CNUWDdygUWrJW4tjCpgIgdqINlC+XyryOjQtchJrBfbJCKNDBD6lmOZd152dXFwgIEJO+mUQST4RVaO1esFZALpCHdIbRYlmBgvcav5iM4sSdkUuXH+eijDuB/q2PxCuC47FsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sY4CjL0ZoD2QW6Fj7smXlVexnWC/ZdoLnl4Tr04HNRg=;
 b=k7fFkikt+jr6CKOAFIFmuWKqt5BfHbax4JcVlyVS6QMZy90iMcbQhFFst/tdOeOt3iH9VpDlvhS0H6fOJFcg/9ivz/dwViDj5m+5L2Y6Ux0hKeGrkbMZcuqFUbvuDC8bsW1Pa5O9uoY9gG50f+3MY7Uj5Uaq2joG9B6bDShApDE=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB6748.eurprd04.prod.outlook.com (2603:10a6:10:10e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Tue, 12 May
 2020 06:21:43 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::c898:9dfc:ce78:a315]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::c898:9dfc:ce78:a315%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 06:21:42 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Po Liu <po.liu@nxp.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH v1 net-next 1/3] net: dsa: felix: qos classified
 based on pcp
Thread-Topic: [EXT] Re: [PATCH v1 net-next 1/3] net: dsa: felix: qos
 classified based on pcp
Thread-Index: AQHWJ1fNsDBnHSNejkCTlseQS+vRMaiiixcAgAFn+uA=
Date:   Tue, 12 May 2020 06:21:42 +0000
Message-ID: <DB8PR04MB5785440D5F8A8AA3EB941A15F0BE0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
 <20200511054332.37690-2-xiaoliang.yang_1@nxp.com>
 <CA+h21hpennftjgTr_CK85drFUErQUqZkcFA+zPe0L25VAbe=FA@mail.gmail.com>
In-Reply-To: <CA+h21hpennftjgTr_CK85drFUErQUqZkcFA+zPe0L25VAbe=FA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f94bc9ff-1aaf-4c43-0da5-08d7f63cbce6
x-ms-traffictypediagnostic: DB8PR04MB6748:|DB8PR04MB6748:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB67488B7E608CA71E4E644083F0BE0@DB8PR04MB6748.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7nth+fgQ+BnNs/Uq3/FyQkxpp27HUlg/QPUtL58R6R7hPpWdSlCihEeBn6iiR7KHvBJMPAYL8fidG9a5D4I5i3reuA2TRcXAt+GdmZzdji8A6p8UIBc3dLEBJXsMeDaKePcQ1NJbwSvi+tB1SS5dNi2TnRUu1s7paXV8Oyu4asVVEVm69/oDrrWh/pvQkvKXTvVgTfZ+5ygWHRh6YsYkP2gZjV4ZbgdBuRLa55FFPZfoyv/oLAuDvxfVwV4+V+9SjDDEbTojZuSJ1BzqziVY+Hlq/EVeFb/D8fZKdnW4uGIqpNCstH0s2C3762h3Mx1i6k9tVtbCNfu7CMssm2ghdJ8XsemYUWzYNvAhGfWQvwFKIqFt+UXwZV2u25HmIj2cHwE+qzkPbx3yxV8FENXbsHcRIPuz9kpFj97MXO4rIlnujJV7SmqdlsHScgVxIbHvM29Oxedl0n+d1b0awrQP5mN1lEkNF2gNMijjUm7hVL7D2KUY/VtBvwBQKsGTFGaXQX4M9WEkEPpuVpV3TwH0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(33430700001)(55016002)(186003)(7416002)(54906003)(2906002)(8936002)(6916009)(9686003)(8676002)(86362001)(71200400001)(316002)(5660300002)(33440700001)(26005)(6506007)(4326008)(478600001)(66446008)(66946007)(52536014)(76116006)(7696005)(33656002)(64756008)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2H4ZLpKe8ErWBlV+AQQSBaGGXJuJXOLd3ufukRL8cq3PIL4V7PSFONv8hWMW93zBGl03i2zavd8dBIVA6lAWbaupyd7L5wNB5qBFGj3LSVOCQ+hhHbqQgDCY8zr5Xit9bueYdv3buk4JQiJaij6J2tpGKb9hsO/uuTmLs8HrtLF7dvGBeyH1Odj0nHPseQlrLrmixaD1igCMbpFG2Z8gZtuyFB44wvAmFqeeTy5BduAUpUkmcWunVQUeTxWvs2wK+pAkQB6A5ygHChMNj7QCm0O4HIpbfTdNVicSxWxJEZ9tTPLl94nhvj0PDVGq44xZPP80E/uC+0cfpJrqNKMBOo3rOjybnTADipOvAay9XETLhEETpKSt+JLOVaYf+45xvUWGxZiwCs/lE59q5GsKuP00a1sWyeetGuEbM726q9FXzi4qFhmwdBXiicDYbStK3+ybv1y4WZ7KkPStC+ihjSMxqIMNyl5A/OFUudi5ess=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94bc9ff-1aaf-4c43-0da5-08d7f63cbce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 06:21:42.3298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mQDGzxJEAoWmGgkMLlDsPLn/Vnh0LxuT7UjAbVUTCWJB5CZaLKCXFkG5jqUsCP4tuNjy4NNjyokmWVoXyj4ApDunGKY14XxVIYA/N4eGr74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6748
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIE1vbiwgMTEgTWF5IDIwMjAgYXQgMDg6MTksIFZsYWRpbWlyIE9s
dGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+IHdyb3RlOg0KPiANCj4gVGhlIG5ldyBza2Jl
ZGl0IHByaW9yaXR5IG9mZmxvYWQgYWN0aW9uIGxvb2tzIGludGVyZXN0aW5nIHRvIG1lLg0KPiBC
dXQgaXQgYWxzbyByYWlzZXMgdGhlIHF1ZXN0aW9uIG9mIHdoYXQgdG8gZG8gaW4gdGhlIGRlZmF1
bHQgY2FzZSB3aGVyZSBzdWNoIHJ1bGVzIGFyZSBub3QgaW5zdGFsbGVkLiBJIHRoaW5rIGl0IGlz
IG9rIHRvIHN1cHBvcnQgYQ0KPiAxLXRvLTEgVkxBTiBQQ1AgdG8gVEMgbWFwcGluZyBieSBkZWZh
dWx0PyBUaGlzIHNob3VsZCBhbHNvIGJlIG5lZWRlZCBmb3IgZmVhdHVyZXMgc3VjaCBhcyBQcmlv
cml0eSBGbG93IENvbnRyb2wuDQoNCnNrYmVkaXQgcHJpb3JpdHkgb2ZmbG9hZCBzZWVtcyBvbmx5
IHN1cHBvcnQgcG9ydCBiYXNlZCBwcm9yaXR5IHNldCBub3csIEkgaGF2ZW4ndCBmb3VuZCBob3cg
dG8gc2V0IGEgcHJpb3JpdHkgZm9yIGVhY2ggcG9ydCBhbmQgUW9TLiBTbyBJIHNldCBhIDEtdG8t
MSBWTEFOIFBDUCB0byBUQyBtYXBwaW5nIGJ5IGRlZmF1bHQuDQoNCj4gWGlhb2xpYW5nLCBqdXN0
IGEgc21hbGwgY29tbWVudCBpbiBjYXNlIHlvdSBuZWVkIHRvIHJlc2VuZC4NCj4gVGhlIGZlbGl4
LT5pbmZvIHN0cnVjdHVyZSBpcyBpbnRlbmRlZCB0byBob2xkIFNvQy1zcGVjaWZpYyBkYXRhIHRo
YXQgDQo+IGlzIGxpa2VseSB0byBkaWZmZXIgYmV0d2VlbiBjaGlwcyAobGlrZSBmb3IgZXhhbXBs
ZSBpZiB2c2M3NTExIHN1cHBvcnQgDQo+IGV2ZXIgYXBwZWFycyBpbiBmZWxpeCkuIEJ1dCBJIHNl
ZSBBTkE6UE9SVDpRT1NfQ0ZHIGFuZCANCj4gQU5BOlBPUlQ6UU9TX1BDUF9ERUlfTUFQX0NGRyBh
cmUgY29tbW9uIHJlZ2lzdGVycywgc28gYXJlIHRoZXJlIGFueSANCj4gc3BlY2lmaWMgcmVhc29u
cyB3aHkgeW91IHB1dCB0aGlzIGluIGZlbGl4X3ZzYzk5NTkgYW5kIG5vdCBpbiB0aGUgDQo+IGNv
bW1vbiBvY2Vsb3QgY29kZT8NCg0KQWxsIHJpZ2h0LCBJIGhhdmUgY2hlY2tlZCB0aGV5IGFyZSBj
b21tb24gcmVnaXN0ZXJzLCBJIHdpbGwgbW92ZSBwb3J0X3Fvc19tYXBfaW5pdCgpIGZ1bmN0aW9u
IHRvIGZlbGl4LmMuDQoNCj4gPiArICAgICAgIGZvciAoaSA9IDA7IGkgPCBGRUxJWF9OVU1fVEMg
KiAyOyBpKyspIHsNCj4gPiArICAgICAgICAgICAgICAgb2NlbG90X3Jtd19peChvY2Vsb3QsDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKEFOQV9QT1JUX1BDUF9ERUlfTUFQX0RQ
X1BDUF9ERUlfVkFMICYgDQo+ID4gKyBpKSB8DQo+ID4gKwkJCQkJCQkJIEFOQV9QT1JUX1BDUF9E
RUlfTUFQX1FPU19QQ1BfREVJX1ZBTChpKSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBBTkFfUE9SVF9QQ1BfREVJX01BUF9EUF9QQ1BfREVJX1ZBTCB8DQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgQU5BX1BPUlRfUENQX0RFSV9NQVBfUU9TX1BDUF9ERUlfVkFM
X00sDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQU5BX1BPUlRfUENQX0RFSV9N
QVAsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcG9ydCwgaSk7DQo+IA0KPiBB
TkFfUE9SVF9QQ1BfREVJX01BUF9EUF9QQ1BfREVJX1ZBTCBpcyAxIGJpdC4gQXJlIHlvdSBzdXJl
IHRoaXMgc2hvdWxkIGJlICUgaSBhbmQgbm90ICUgMj8NCg0KQmVjYXVzZSBpbiBRT1NfUENQX0RF
SV9NQVBfQ0ZHIHJlZ2lzdGVyLCBCSVQoMykgaXMgRFAgdmFsdWUsIEJJVCgyLCAwKSBpcyBRT1Mg
dmFsdWUuIFFvUyBjbGFzcz1RT1NfUENQX0RFSV9NQVBfQ0ZHW2ldLlFPU19QQw0KUF9ERUlfVkFM
LCBpPTgqREVJICsgUENQLCBzbyBEUCB2YWx1ZSBuZWVkIHRvIGJlIHNldCBCSVQoMykmaS4NCg0K
UmVnYXJkcywNClhpYW9saWFuZyBZYW5nDQo=
