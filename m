Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9261B73A9
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgDXMOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:14:09 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:17857
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726668AbgDXMOI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:14:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfiHPKxa1IHBBXNbchWXTfijEt10fTsmzFuRjW182govdvJzWLSuOQID8wJVCmQu4rsXNbTk4RyIlWUwkImuQXsuZNZi5SepPZ3qUQt7umMLC1Npr7EUQZVL8Jadqf+QP5xh3nG1dOPq+fMSGJ8Z6C23eSbkEWj5E//SI1fT3I3KFx6QfMHSWZOHzi6HKgRyEoWV97iqGUsZNhR15wrY9zu3geYBdypIS70a3ShZ2khSTt7p5Az3iGOrc2vaUBiWF2mgxMpz77GUPV4JlKuwNkx5jXzeKmhL3yUEc3auqxyDI+OrPG8M59O51iCjSWSkKTlP9saGz1RJLC835W3jkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0N2ovQwEi1U3BCXEi0kL1IvyFOLJ17/LkzbpQ9Oit5w=;
 b=OQ0SOA6DRFkEtqihgEaa86/agMk+AC6rwWbHPhgTxShptlooeSKJqUxuR3hhpijEceEuVHKemkrNlNzLiN5Om1VNtmcKZZC+eq7/VOalE9UDVgYkgqLlzVOT7/cBoexL0wDui9Erek83ODDIY7rkRltlLFN13Ue8gsDgKviwIEhPZRZWZu1wSlA8Byb5PWHEcm7YhjToGXYPq38p9irGmLfD6Kn0B2XUEo+MXIaX7DpqsUj5bAiQVEHmZ9M7txRdLsUbr1hUNiA1kDMjcVqrTDA2+N5LWcvskCVBODfP8JmVG6xEdvFqN8tgJk0ncJ/JTLiXK8DWBlIIHmxSgA9r8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0N2ovQwEi1U3BCXEi0kL1IvyFOLJ17/LkzbpQ9Oit5w=;
 b=d6r7V0dYWIrEhhuCKza/YyQ4ruwhQy8k3nNcNruxfL0/J8tnyNjKFRCDhndeRBVkgDmaaho3oDE/DOPsHcwYG76IDfvnpEQhGzQBpQXshUIVkKgVrUORdloDgEKKaqPeqoEq7drLOqdea9YBHTbU0qmcMyRXfr9w/dIFE6cCJV8=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5314.eurprd04.prod.outlook.com (2603:10a6:208:cd::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:14:05 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:14:05 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Thread-Topic: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Thread-Index: AdYaMARbyR37uWIvRc+0I7pINBGoWw==
Date:   Fri, 24 Apr 2020 12:14:05 +0000
Message-ID: <AM0PR04MB5443C8E4C6765250CF3361C0FBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [89.136.167.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9c966410-c3d1-445b-4d36-08d7e848fbb7
x-ms-traffictypediagnostic: AM0PR04MB5314:|AM0PR04MB5314:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB53144C49415944600D2FBC6AFBD00@AM0PR04MB5314.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(9686003)(55016002)(53546011)(6506007)(8676002)(8936002)(7696005)(81156014)(54906003)(110136005)(33656002)(2906002)(7416002)(316002)(5660300002)(86362001)(44832011)(71200400001)(66556008)(26005)(478600001)(76116006)(66446008)(4326008)(64756008)(186003)(52536014)(66476007)(66946007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WxM6CcyzWdKK5db+Pw5V2yfOTYmOAUF9wT+c44Xy+bP4mSusZsB5RjW8jxSkRe+gl6EozKApRe++mwKTnyZeI1oT21uUnEnZH6yOkLP2HcvT7v5/pL7++FEtnM1+F0seWP+a8b2cdxrJZ+0gHMkFiOn9+jxziS0qay8UtzCgtOa6J7DiEiIYljIrNq66/hF+l7jaIGlh3zajxTRVE07epk+fQk66M1Y9RoqEU3ZtfUM+LGLAXLWPKjju7b7cj22kwPdC/fjADBzTdMxdCgXFyrGPdiVXSARc603/dGL5cE1OeP3sS3AtFu7Qqf/SLrM4yGcwry4lvPs4I8967RV/zfkLKMyZZHIaSk143kxwNpYHGdqmu/MPVj7FPLH7f1n7OLf9Sil/TF5aoTuGowb8cEJnyKHslhxpR2kIT4/kQDrXkJZ8avAoy8pBEJkP3fIs
x-ms-exchange-antispam-messagedata: Qco8mfGBpVSnQh894OXTkA92U/G/6zVwKkrlDRm/HnQBaz+sKeP0QtkunPlFQAv2qWHZimsu8b3SD7qI525Bi/Wp5jxtaYd5pdJPEiGLltEwsgTI0PPJyVtuw0SjzqOE/4rUAYacYk0+MeVr1aarHg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c966410-c3d1-445b-4d36-08d7e848fbb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 12:14:05.3328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RMxF2ShRQA56ElcyI6rmq/n3vTXyArDDSL1KcaTEm4CQvWLD50SgNjBJF5Asz6U85oMh5sI0fIDsnhbdFAoIMfkOL6j0W8Ec+SbGsK88AiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5314
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAzLzI2LzIwMjAgNjowNyBQTSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+ID4+ICtzdGF0aWMg
dTMyIGxlX2lvcmVhZDMyKHZvaWQgX19pb21lbSAqcmVnKSB7DQo+ID4+ICsgICAgcmV0dXJuIGlv
cmVhZDMyKHJlZyk7DQo+ID4+ICt9DQo+ID4+ICsNCj4gPj4gK3N0YXRpYyB2b2lkIGxlX2lvd3Jp
dGUzMih1MzIgdmFsdWUsIHZvaWQgX19pb21lbSAqcmVnKSB7DQo+ID4+ICsgICAgaW93cml0ZTMy
KHZhbHVlLCByZWcpOw0KPiA+PiArfQ0KPiA+PiArDQo+ID4+ICtzdGF0aWMgdTMyIGJlX2lvcmVh
ZDMyKHZvaWQgX19pb21lbSAqcmVnKSB7DQo+ID4+ICsgICAgcmV0dXJuIGlvcmVhZDMyYmUocmVn
KTsNCj4gPj4gK30NCj4gPj4gKw0KPiA+PiArc3RhdGljIHZvaWQgYmVfaW93cml0ZTMyKHUzMiB2
YWx1ZSwgdm9pZCBfX2lvbWVtICpyZWcpIHsNCj4gPj4gKyAgICBpb3dyaXRlMzJiZSh2YWx1ZSwg
cmVnKTsNCj4gPj4gK30NCj4gPg0KPiA+IFRoaXMgaXMgdmVyeSBzdXJwcmlzaW5nIHRvIG1lLiBJ
J3ZlIG5vdCBnb3QgbXkgaGVhZCBhcm91bmQgdGhlDQo+ID4gc3RydWN0dXJlIG9mIHRoaXMgY29k
ZSB5ZXQsIGJ1dCBpJ20gc3VycHJpc2VkIHRvIHNlZSBtZW1vcnkgbWFwcGVkDQo+ID4gYWNjZXNz
IGZ1bmN0aW9ucyBpbiBnZW5lcmljIGNvZGUuDQo+IA0KPiBUaGlzIGFic3RyYWN0aW9uIG1ha2Vz
IG5vIHNlbnNlIHdoYXRzb2V2ZXIsIHlvdSBhbHJlYWR5IGhhdmUNCj4gaW97cmVhZCx3cml0ZX0z
MntiZSx9IHRvIGRlYWwgd2l0aCB0aGUgY29ycmVjdCBlbmRpYW4sIGFuZCB5b3UgY2FuIHVzZSB0
aGUNCj4gc3RhbmRhcmQgRGV2aWNlIFRyZWUgcHJvcGVydGllcyAnYmlnLWVuZGlhbicsICdsaXR0
bGUtZW5kaWFuJywgJ25hdGl2ZS1lbmRpYW4nIHRvDQo+IGRlY2lkZSB3aGljaCBvZiB0aG9zZSBv
ZiB0byB1c2UuIElmIHlvdSBuZWVkIHRvIGludHJvZHVjZSBhIHdyYXBwZXIgb3IgaW5kaXJlY3QN
Cj4gZnVuY3Rpb24gY2FsbHMgdG8gc2VsZWN0IHRoZSBjb3JyZWN0IEkvTyBhY2Nlc3NvciwgdGhh
dCBpcyBmaW5lIG9mIGNvdXJzZS4NCj4gLS0NCj4gRmxvcmlhbg0KDQpIaSBGbG9yaWFuLA0KSSBu
ZWVkIHRoZXNlIHdyYXBwZXJzIGluIGdlbmVyaWMgY29kZSBpbiBvcmRlciB0byBhdXRvbWF0aWNh
bGx5IGFzc2lnbiB0aGUgcHJvcGVyDQpJL08gYWNjZXNzb3IgaW4gdGhlIGZvbGxvd2luZyBzdHJ1
Y3R1cmUgYWNjb3JkaW5nIHRvIGVuZGlhbm5lc3Mgc3BlY2lmaWVkIGluIERULg0KDQovKiBFbmRp
YW5uZXNzIHNwZWNpZmljIG1lbW9yeSBJL08gKi8NCnN0cnVjdCBtZW1faW8gew0KCXUzMiAoKnJl
YWQzMikodm9pZCBfX2lvbWVtICphZGRyKTsNCgl2b2lkICgqd3JpdGUzMikodTMyIHZhbHVlLCB2
b2lkIF9faW9tZW0gKmFkZHIpOw0KfTsNCg0KQW5kIHRoZW4gdGhlIHVzYWdlIGlzIHN0cmFpZ2h0
Zm9yd2FyZCBpbiBkZXZpY2Ugc3BlY2lmaWMgY29kZToNCmlvLnJlYWQzMigmcmVnX2Jhc2UtPnRj
c3IzKSAuLi4NCmlvLndyaXRlMzIoKGlvLnJlYWQzMigmcmVnX2Jhc2UtPnRjc3IxKSAuLi4gDQoN
CndpdGhvdXQgdGhlIG5lZWQgdG8gY2hlY2sgZW5kaWFubmVzcyBhdCBlYWNoIGNhbGwgYW5kIHNl
bGVjdCB3aGljaCByZWFkL3dyaXRlIGZ1bmN0aW9uIHRvIHVzZS4NClRoaXMgaXMgZG9uZSBpbiBv
cmRlciB0byByZWR1Y2UgdGhlIG92ZXJhbGwgbnVtYmVyIG9mIExPQyAobGluZXMgb2YgY29kZSku
DQoNCkZsb3Jpbi4NCg==
